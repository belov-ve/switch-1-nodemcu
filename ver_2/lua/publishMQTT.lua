--[[
 Скрипт публикации конфигурации в топик
 ver 2.0.1
--]]

do
    if Config and Config.mode ~= "st" then return nil
    elseif Config and State and Config.mqtt.enable and Config.mqtt.state and MQTT and wifi and (wifi.sta.status() == wifi.STA_GOTIP) then
        local js = {}

        js.type = "device_announced"
        if Config.name then js.name = Config.name end
        if Config.friendly_name then js.friendly_name = Config.friendly_name end
        if Config.model then js.model = Config.model end
        js.ip = wifi.sta.getip()

        if wifi then js.linkquality = 100 + wifi.sta.getrssi() end

        -- switch
        if Switch and State.switch and type(State.switch)=="table" then
            for i,v in pairs(State.switch) do
                    js["switch_"..i] = string.upper( State.switch[i] )
            end
        end

        MQTT:publish(Config.mqtt.state, sjson.encode(js), QoS, 1)
    else
        print("Publication in the topic is not possible")
    end
end