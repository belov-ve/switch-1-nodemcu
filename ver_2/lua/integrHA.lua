--[[
 Скрипт интеграции с Home Assistant
 ver 1.1
--]]

do

    if Config and Config.mqtt.enable and Config.ha.enable and MQTT and Config.ha.discovery_prefix and (wifi.sta.status() == wifi.STA_GOTIP) then

        local frn = string.lower( Config.friendly_name )
        -- device
        do
        ---[=[   switch
            local swTempl = [[
{"name":"%s_%s_%s","unique_id":"%s_%s_%s","icon":"%s","availability_topic":"%s","state_topic":"%s","command_topic":"%s","payload_on":"ON","payload_off":"OFF","json_attributes_topic":"%s","value_template":"{{ value_json.%s_%s }}",
"device":{"identifiers":["%s"],"name":"%s","sw_version":"%s","model":"%s","manufacturer":"%s"}}
]]

            if Config.mqtt.switch and type(Config.mqtt.switch)=="table" then

                local hw = "switch"

                for i,v in pairs(Config.mqtt.switch) do
                    local data = string.format(swTempl,
                        Config.friendly_name, hw, i, Config.name, hw, i, Config.switch[i].icon, Config.mqtt.lwt,
                        Config.mqtt.state, v, Config.mqtt.state, hw, i,
                        Config.name, Config.name, ModelVersion, CF.mgsub(Model, "#*/\"","--__"), ModelManufacturer)

                    local confTopic = string.format("%s/%s/%s/%s_%s/config", Config.ha.discovery_prefix, hw, frn, hw, i)
                    MQTT:publish(confTopic, data, QoS, 1)
                end

            end
        --]=]
        end
        -- collectgarbage()

        do
        ---[=[   sensor
            local lqTempl = [[
{"name":"%s_%s","unique_id":"%s_%s","icon":"%s","unit_of_measurement":"%s","availability_topic":"%s","state_topic":"%s","json_attributes_topic":"%s","value_template":"{{value_json.%s}}",
"device":{"identifiers":["%s"],"name":"%s","sw_version":"%s","model":"%s","manufacturer":"%s"}}
]]

            local lq = "linkquality"

            local data = string.format(lqTempl, Config.friendly_name, lq, Config.name, lq, "mdi:signal", "lqi",
                Config.mqtt.lwt, Config.mqtt.state, Config.mqtt.state, lq,
                Config.name, Config.name, ModelVersion, CF.mgsub(Model, "#*/\"","--__"), ModelManufacturer)

            local confTopic = string.format("%s/sensor/%s/%s/config", Config.ha.discovery_prefix, frn, lq)
            MQTT:publish(confTopic, data, QoS, 1)
        --]=]
        end

        -- print("Send config to Home Assistant")

    -- else
        -- print("Home Assistant discovery_prefix not availabel")
    end

end