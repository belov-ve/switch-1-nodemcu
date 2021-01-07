-- print( "Start vars. Heap() " .. tostring(node.heap()) )
do
    local j = {}

    if GET.name == Config.name then
        if Config.network.sta.pwd then j.sta_pwd = Config.network.sta.pwd end
        if Config.network.sta.dhcp then j.dhcp = true end
        if Config.mqtt.user then j.mqtt_user = Config.mqtt.user end
        if Config.mqtt.pwd then j.mqtt_pwd = Config.mqtt.pwd end
        if Config.mqtt.enable then j.mqtt = true end
        if Config.ha and Config.ha.enable then j.ha = true end

        return encoder.toBase64( sjson.encode(j) )
    end

    return sjson.encode(j)
end