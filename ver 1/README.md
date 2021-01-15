# switch-1-nodemcu ver 1
Switch 1 relay on NodeMCU platform (Lua). Version 1
---
### Directory structure:
    \*.lc - lua bytecode file (for esp8266 1Mb)
    \*.lua - lua files
    \lua\* - project source files
    \web\* - web server files (*.lch - lua bytecode modules for web server services (esp8266 1Mb))
    \web\lua\* - web server service source files
    \ha\ui-lovelace.yaml - sample form UI (for ui-lovelace.yaml)
    \ha\packages\drying_shoes.yaml - sample integration into HA in the form of packages 
### Note
    1. All files \ *.lc, \init.lua and \web\*.* copied to the root of the ESP module
       Or:
       - copy \lua\*.lua files, compile them into bytecode, delete the sources *.lua;
       - copy files \web\lua\*.lua, compile them into bytecode, rename them to * .lch, delete the sources *.lua.
    2. Copy \ha\packages\drying_shoes.yaml into packages of Home Assistant. Set the required sensor name
    3. Insert lines from \ha\ui-lovelace.yaml into ui-lovelace.yaml (also set the required sensor name)
### Integration in Home Assistant
    Sample data integration in HA friendly name set in 'Electric Switch' and node.chip_id equal '6120123'
---
## Sample MQTT Topics:
#### MQTT Topic: homeassistant/switch/electric_switch/switch_1/config
    {
        "icon": "mdi:tumble-dryer",
        "payload_off": "OFF",
        "payload_on": "ON",
        "value_template": "{{ value_json.switch_1 }}",
        "command_topic": "nodemcu/electric_switch/switch/1/set",
        "state_topic": "nodemcu/electric_switch",
        "json_attributes_topic": "nodemcu/electric_switch",
        "name": "electric_switch_switch_1",
        "unique_id": "ESP-6120123_switch_1",
        "device": {
            "identifiers": [ "ESP-6120123" ],
            "name": "ESP-6120123",
            "sw_version": "ver:1.0",
            "model": "NodeMCU WiFi Switch (1 relay)",
            "manufacturer": "BVE"
        },
        "availability_topic": "nodemcu/electric_switch/lwt"
    }    
#### MQTT Topic: homeassistant/sensor/electric_switch/linkquality/config
    {
        "icon": "mdi:signal",
        "unit_of_measurement": "lqi",
        "value_template": "{{ value_json.linkquality }}",
        "state_topic": "nodemcu/electric_switch",
        "json_attributes_topic": "nodemcu/electric_switch",
        "name": "electric_switch_linkquality",
        "unique_id": "ESP-6120123_linkquality",
        "device": {
            "identifiers": [ "ESP-6120123" ],
            "name": "ESP-6120123",
            "sw_version": "ver:1.0",
            "model": "NodeMCU WiFi Switch (1 relay)",
            "manufacturer": "BVE"
        },
        "availability_topic": "nodemcu/electric_switch/lwt"
    }

#### MQTT Topic: nodemcu/electric_switch
    {
        "type":"device_announced",
        "name":"ESP-6120123",
        "switch_1":"ON",
        "linkquality":63,
        "friendly_name":"electric_switch",
        "ip":"192.168.xxx.xxx"
    }
#### MQTT Topic: nodemcu/electric_switch/switch/1/set
    ON or OFF
#### MQTT Topic: nodemcu/electric_switch/lwt
    online or offline
