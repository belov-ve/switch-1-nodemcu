--[[
Скрипт сохранениея данных html страницы конфигурации
ver 1.0
--]]

-- print( "Start saveconf. Heap() " .. tostring(node.heap()) )
do
    local post = POST
    POST = nil

    if post then
        post = sjson.decode(encoder.fromBase64(post))
    end

    if post and post.name == Config.name then
        local mt = "^%s*(.-)%s*$"    -- Trim() s = s:gsub("^%s*(.-)%s*$", "%1")

    --    print(post.friendly_name)
        if post.friendly_name then
            Config.friendly_name =  CF.mgsub(post.friendly_name:gsub(mt, "%1"), " #*/", "_--_")

            -- топики mqtt
            Config.mqtt.state = "nodemcu/" .. string.lower(Config.friendly_name)
            Config.mqtt.lwt = Config.mqtt.state .. "/lwt"
            if Switch then
                Config.mqtt.switch = {}
                for i,val in pairs(Switch) do
                    Config.mqtt.switch[i] = Config.mqtt.state .. "/switch/" .. i .. "/set"
                end
            end
        end

    --    print(post.wifi_id)
        if post.wifi_id then
            Config.network.sta.ssid = post.wifi_id:gsub(mt, "%1")
        end

    --    print(post.sta_pwd)
        if post.sta_pwd then
            Config.network.sta.pwd = post.sta_pwd
        end

    --    print(post.wifi_mode)
        if post.wifi_mode then
            Config.network.sta.setphymode = post.wifi_mode
        end

    --    print(post.dhcp)
        if post.dhcp~=nil then
            Config.network.sta.dhcp = post.dhcp
        end

    --    print(post.ip)
        if post.ip then
            Config.network.sta.ip = post.ip:gsub(mt, "%1")
        end

    --    print(post.mask)
        if post.mask then
            Config.network.sta.netmask = post.mask:gsub(mt, "%1")
        end

    --    print(post.gw)
        if post.gw then
            Config.network.sta.gateway = post.gw:gsub(mt, "%1")
        end

        -- упрощенно, один выключатель
    --    print(post.sw1_boot)
        if post.sw1_boot then
            Config.switch[1].default = post.sw1_boot
        end

    --    print(post.icon)
        if post.icon then
            Config.switch[1].icon = post.icon:gsub(mt, "%1")
        end
        --

    --    print(post.mqtt)
        if post.mqtt~=nil then
            Config.mqtt.enable = post.mqtt
        end

    --    print(post.mqtt_user)
        if post.mqtt_user then
            Config.mqtt.user = post.mqtt_user:gsub(mt, "%1")
        end

    --    print(post.mqtt_pwd)
        if post.mqtt_pwd then
            Config.mqtt.pwd = post.mqtt_pwd
        end

        -- mqtt_server
        if post.mqtt_server and (type(post.mqtt_server)=='table') then
            Config.mqtt.server = {}
            for i,v in pairs(post.mqtt_server) do
    --            print('\t MQTT Server: '..v:gsub(mt, "%1"))
                local _v = v:gsub(mt, "%1")
                if #_v > 0 then Config.mqtt.server[#Config.mqtt.server + 1] = _v end
            end
        end

    --    print(post.mqtt_port)
        if post.mqtt_port then
            Config.mqtt.port = post.mqtt_port:gsub(mt, "%1")
        end

    --    print(post.ha)
        if post.ha~=nil then
            Config.ha.enable = post.ha
        end

    --    print(post.dp)
        if post.dp then
            Config.ha.discovery_prefix = post.dp:gsub(mt, "%1")
        end

        ---[[ Save new Config
        local sj = sjson.encode(Config)
        if file.open(Conf_file, "w+") then
            file.write(sj)
            file.close()
        -- else
            -- print("Error save new Config file")
        end
        --]]

    -- else
        -- print("POST skip. Not save")
    end

    return "Ok"
end