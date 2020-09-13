--[[
 Кнопки и индикаторы управления
 ver 1.0
--]]

do
    ---[[  Светодиоды
    if Led and type(Led)=="table"  then
        for i, val in pairs(Led) do
            gpio.mode(val.pin, val.mode);
            gpio.write(val.pin, val.off);       -- выключение
         end
    end
    --]]

    ---[[ переключатели Switch
    if Switch and type(Switch)=="table" then

        for i, val in pairs(Switch) do
            gpio.mode(val.pin, val.mode)

            local _state
            if Config and Config.switch and Config.switch[i] then
                if (Config.switch[i].default ~= "last") then    -- default может {"on", "off", "last"}
                    Config.switch[i].state = Config.switch[i].default
                end
                _state = Config.switch[i].state == "on"
            end
            gpio.write(val.pin, _state and val.on or val.off)
        end

    end
    --]]

    -- Кнопки
    if Btn and type(Btn)=="table" then

        -- Инициализация
        for i, val in pairs(Btn) do
            gpio.mode(Btn[1].pin, Btn[1].mode, gpio.PULLUP)

        end

        -- функция обработки нажатия кнопки
        local function pressBtn(n)
            local pressLongTime = 5000000   -- 5 сек. принимать как длинное нажатие
            local last                      -- переменная для отслеживания длительности нажатия кнопик
            local lastlev                    -- перемнная - последнее состояние

            return function (level, when, count)
                -- print("Start pressBtn(). level="..level.."\twhen="..when.."\tcount="..count.."\tlastlev="..(lastlev or "-"))

                if last and lastlev and (lastlev == level) then
                    -- print("....Button chatter")
                    if count > 1 then lastlev= nil end
                    return      -- дребезг
                end

                lastlev = level
                if not last then last = when end

                if level == 0 then  -- нажатие btn

                    last = when

                    ---- Обработка нажатия
                    -- переключаем реле
                    if Switch[n] then
                        local data = (gpio.read(Switch[n].pin) == Switch[n].on) and Switch[n].off or Switch[n].on
                        gpio.write(Switch[n].pin, data)

                        -- сохранить конфиг
                        Config.switch[n].state = data == Switch[n].on and "on" or "off"

                        local fl = file.open(Conf_file, "w+")
                        if fl then
                            fl:write(sjson.encode(Config))
                            fl:close();
                        end
                    end

                    CF.doluafile("publishMQTT")        -- публикация state устройства

                elseif level == 1 then -- отпускание btn
                    local _t = (when - last)/1000000
                    -- print("Time press: ".._t.." sec.")

                    if when - last < pressLongTime then return end

                    -- Тут можно разместить код обслуживания длительного нажатия
                    do
                        -- print("!!! Long press....reload")
                        node.restart()
                    end
                    --
                end

            end
        end

        -- Проверка состояник кнопки при старте
        BtnPressOnStart = gpio.read(Btn[1].pin) == Btn[1].press or false    -- BtnPressOnStart = true Кнопка нажата при загрузке

        -- подписываемся на событие
        local pressBtn1 = pressBtn(1)
        gpio.trig(Btn[1].pin, Btn[1].presstype, pressBtn1)     -- нажатие кнопки
    end
end
