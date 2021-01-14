--[[
 Скрипт загрузки параметров модуля из файла конфигурации
 ver 1.2
--]]

--local cf = require "comfun"

Conf_file = "esp.cfg"         -- имя файла конфигурации
Config = {}                     -- глобальный массив параметров конфигурации
Model = "NodeMCU WiFi Switch (1 relay)"
ModelVersion = "ver:1.2"
ModelManufacturer = "BVE"


do
    local friendly_name = "Electric Switch"

    -- создание шаблонного конфиг файла
    local function createConfig(cfl)
        ----- default config -----
        local sj = [[
        {
            "mode" : "ap",
            "switch" : [
                {
                    "default" : "last",
                    "state" : "off",
                    "change" : "up",
                    "icon" : "mdi:electric-switch"
                }
            ],
            "network" : {
                "ap" : {
                    "setphymode" : "PHYMODE_G",
                    "pwd" : "",
                    "auth" : "",
                    "ip" : "192.168.4.1",
                    "netmask" : "255.255.255.0",
                    "gateway" : "192.168.4.1"
                },
                "sta" : {
                    "setphymode" : "PHYMODE_G",
                    "ssid" : "Home_Net",
                    "pwd" : "12345",
                    "dhcp" : true,
                    "ip" : "192.168.1.51",
                    "netmask" : "255.255.255.0",
                    "gateway" : "192.168.1.1"
                }
            },
            "mqtt" : {
                "enable" : true,
                "server" : ["192.168.1.3", "192.168.1.4"],
                "port" : "1883",
                "user" : "mqtt",
                "pwd" : "mqtt-pwd"
            },
            "ha" : {
                "enable": true,
                "discovery_prefix": "homeassistant"
            }
        }
        ]]
        ------------------

        local config = sjson.decode(sj)

        -- Имя модуля
        config.name = "ESP-" .. tostring(node.info('hw').chip_id)
        if friendly_name then
            config.friendly_name =  CF.mgsub(friendly_name, " #*/", "_--_")
        else
            config.friendly_name =  CF.mgsub(config.name, " #*/", "_--_")
        end

        -- топики mqtt
        config.mqtt.state = "nodemcu/" .. string.lower(config.friendly_name)
        config.mqtt.lwt = config.mqtt.state .. "/lwt"
        if Switch then
            config.mqtt.switch = {}
            for i,val in pairs(Switch) do
                config.mqtt.switch[i] = config.mqtt.state .. "/switch/" .. i .. "/set"
            end
        end

        do
            sj = sjson.encode(config)
            if file.open(cfl, "w+") then
                file.write(sj)
                file.close()
            -- else
                -- print("Error save new config file")
            end
        end
        return config
    end

    -- очистка пустых полей config
    local function clearConfig(obj)
        for k,v in pairs(obj) do        -- очищаем пустые параметры
            if type(v) == "table" then
                clearConfig(v)
            elseif type(v) == "string" then
                obj[k] = v~="" and obj[k] or nil
            end
        end
    end



    local state
    if file.exists(Conf_file) then
        local fl = file.open(Conf_file, "r")
        if fl then
            state = pcall( function ()
                local sj = fl:read()
                fl:close()
                Config = sjson.decode(sj)
            end)
        end
    end

    if not state then
        --print("No valid configuration file found. Create new")
        Config = createConfig(Conf_file)    -- сохранение в файл конфигурации по умолчанию

        -- выбор загружаемой конфигурации (установить по смыслу поведения устройства) - "ap" или "st"
        Config.mode = "ap"   --  первый запуск загружаем в режиме "ap"
    end

    clearConfig(Config)

end
