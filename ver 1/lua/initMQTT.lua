--[[
 Скрипт загрузки конфигурации и подключения к MQTT брокеру
 ver 1.0
--]]

do
    if Config and Config.mode == "st" then

        QoS = 1

        local keepalive = 120           -- keepalive параметр mqtt (сек)
        local port = 1883               -- mqtt порт (если не указан)
        local publicationTime = 300     -- период публикации состояния в mqtt (сек)

        -- функция поиска индекса элемента по таблице
        local function findInTable(tbl, value)
            if tbl and type(tbl)=="table" then
                for i, v in pairs(tbl) do
                    if v == value then return i end
                end
            end
            return nil
        end


        if Config and Config.mqtt and Config.mqtt.enable and Config.mqtt.server then

            -- Список адресов для подключения (при каждом обращении следующий по порядку)
            local mqttGetServer = CF.getNext(Config.mqtt.server)
            local mqttServer = mqttGetServer()

            ---- Таймеры
            -- Ожидание подключения WiFi
            local _tmr = tmr.create()
            -- Публикации состояния
            local _tmrPubl  = tmr.create()

            -- Процедура подключение к MQTT брокерку
            local function mqttConnect()

                MQTT = mqtt.Client(Config.name, keepalive, Config.mqtt.user, Config.mqtt.pwd)

                if Config.mqtt.lwt then
                    MQTT:lwt(Config.mqtt.lwt, "offline", QoS, 1)     -- регистрация сообщения об отключении
                end

                -- Событие offline
                MQTT:on("offline", function(client)
                    --print ("MQTT:on offline")

                    MQTT = nil
                    -- остановка публицкации статуса
                    _tmrPubl:unregister()

                    collectgarbage("collect")

                    -- пауза и повторное подключение к следующему серверу
                    _tmr:start()
                end)

                -- Событие message (опубликовано сообщение)
                MQTT:on("message", function(client, topic, data)
                    -- print(topic .. " :" )

                    if data ~= nil then
                        -- print("\t"..data)

                        data = string.lower(data)
                        do
                            local needsave

                            -- Обработка топиков "switch"
                            if Switch then      -- and Config.mqtt.switch
                                local n = findInTable(Config.mqtt.switch, topic)

                                if n and Switch[n] and data~=Config.switch[n].state and findInTable({"on","off"},data) then
                                    -- состояние не совпадает, требуется изменить состояние
                                    needsave = true
                                    -- применить для реле
                                    gpio.write(Switch[n].pin, data=="on" and Switch[n].on or Switch[n].off)

                                    -- сохранить конфиг
                                    Config.switch[n].state = data

                                    CF.doluafile("publishMQTT")        -- публикация state устройства
                                end
                            end

                            if needsave then
                                local fl = file.open(Conf_file, "w+")
                                if fl then
                                    fl:write(sjson.encode(Config))
                                    fl:close();
                                end
                            end

                        end

                    end

                end)


                -- подключение к mqtt брокеру
                -- print(string.format("Connect to %s MQTT server", mqttServer))
                MQTT:connect(mqttServer, Config.mqtt.port or port,
                    function(client)

                        -- print("MQTT connected")

                        MQTT:publish(Config.mqtt.lwt, "online", QoS, 1)

                        -- Подпись на топики
                        -- switch
                        if Config.mqtt.switch and type(Config.mqtt.switch)=="table" then
                            local _topics = {}
                            for i,v in pairs(Config.mqtt.switch) do
                                _topics[v] = QoS
                            end

                            if not MQTT:subscribe(_topics) then
                                -- print("Subscribe failed")

                                MQTT:close()
                                mqttServer = mqttGetServer()    -- смена сервера
                                _tmr:start()                    -- пауза и повторное подключение
                            else
                                do
                                    -- инеграция с HomeAssisatnt
                                    if Config.ha and Config.ha.enable then
                                        -- print("Start HA integration")
                                        CF.doluafile("integrHA")
                                    end
                                end
                                collectgarbage()

                                -- публикация state устройства
                                CF.doluafile("publishMQTT")

                                -- создаем периодичный таймер пубикации. настройка и запуск
                                _tmrPubl:alarm(publicationTime * 1000, tmr.ALARM_AUTO, function() CF.doluafile("publishMQTT") end)
                            end
                        end

                    end,
                    function(client, reason)
                        -- print("Failed reason: " .. reason..".")

                        mqttServer = mqttGetServer()    -- смена сервера
                        _tmr:start()                    -- пауза и повторное подключение
                    end
                )

            end


            -- Настройка и запуск таймера
            _tmr:alarm(1000, tmr.ALARM_SEMI, function()
                if wifi.sta.status() == wifi.STA_GOTIP then
                    mqttConnect()       -- запуск подключения к mqtt
                else
                    _tmr:start()        -- повтор ожидания подключения WiFi
                end
            end)

            _tmr:start()  -- старт таймера

        -- else
            -- print("MQTT is disabled or not configured")
        end

    end

end