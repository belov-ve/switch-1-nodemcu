--[[
 Инициализация переключателей, кнопок и индикаторов управления
 ver 2.0
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
            if State and State.switch[i] and Config and Config.switch and Config.switch[i] then
                if (Config.switch[i].default ~= "last") then    -- default может {"on", "off", "last"}
                    State.switch[i] = Config.switch[i].default
                end
                _state = State.switch[i] == "on"
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
            local lastlev                   -- перемнная - последнее состояние

            return function (level, when, count)
                -- print("Start pressBtn(). level="..level.."\twhen="..when.."\tcount="..count.."\tlastlev="..(lastlev or "-"))


                -- Функция обработки короткого нажатия кнопки
                local function shortPressBtn()
                    if Switch[n] then
                        local data = (gpio.read(Switch[n].pin) == Switch[n].on) and Switch[n].off or Switch[n].on

                        -- сохранить статус
                        -- Пояснение:
                        --  Сначала сохраняем новый статус, на случай сбоя ESP-8266 при переключении реле (ЭМИ),
                        --  это позволяем избавиться от возможного разрушения файла статуса при записи.
                        --  Недостаток - появилась задержка на реакцию от кнопки.
                        --  Если коммутация слаботочки или "правильная" разводка, то сохранение переключение можно поменять местами
                        State.switch[n] = data == Switch[n].on and "on" or "off"

                        local fl = file.open(State_file, "w+")
                        if fl then
                            fl:write(sjson.encode(State))
                            fl:close();
                        end

                        -- переключаем реле
                        gpio.write(Switch[n].pin, data)
                    end

                    CF.doluafile("publishMQTT")        -- публикация state устройства
                    return
                end

--
                if last and lastlev and (lastlev == level) then
                    -- print("....Button chatter")
                    if count > 1 then lastlev = nil end
                    return      -- дребезг
                end

                lastlev = level
                if not last then last = when end

                if level == 0 then  -- нажатие btn

                    last = when

                -- При нажатии кнопки
                    if Switch[n] and Config.switch[n].change and Config.switch[n].change == 'down' then
                        shortPressBtn()
                    end

                elseif level == 1 then -- отпускание btn
                    local _t = (when - last)/1000000
                    -- print("Time press: ".._t.." sec.")

                    if when - last < pressLongTime then
                        -- При отпускании кнопки (по умолчанию)
                        if Switch[n] and (not Config.switch[n].change or Config.switch[n].change == 'up') then
                            shortPressBtn()
                        end

                        return
                    end

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
