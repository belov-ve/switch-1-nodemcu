# switch-1-nodemcu
Switch 1 relay on NodeMCU platform (Lua)
---
### Directory structure:
    \*.lc - lua bytecode file (for esp8266)
    \*.lua - lua files
    \lua\* - project source files
    \web\* - web server files (*.lch - lua bytecode modules for web server services (esp8266))
    \web\lua\* - web server service source files
    \firmware\* - NodeMCU custom build
    \schematic\* - electric scheme
### Note
    All files \ *.lc, \init.lua and \web\*.* copied to the root of the ESP module
---
### Sample data integration in Home Assistant
with friendly name set in 'drying_shoes' and node.chip_id equal '6120123'
#### MQTT Topic: homeassistant/switch/drying_shoes/switch_1/config
    {
        "icon": "mdi:tumble-dryer",
        "payload_off": "OFF",
        "payload_on": "ON",
        "value_template": "{{ value_json.switch_1 }}",
        "command_topic": "nodemcu/drying_shoes/switch/1/set",
        "state_topic": "nodemcu/drying_shoes",
        "json_attributes_topic": "nodemcu/drying_shoes",
        "name": "drying_shoes_switch_1",
        "unique_id": "ESP-6120123_switch_1 ",
        "device": {
            "identifiers": [ "ESP-6120123" ],
            "name": "ESP-6120123",
            "sw_version": "ver:1.0",
            "model": "NodeMCU WiFi Switch (1 relay)",
            "manufacturer": "BVE"
        },
        "availability_topic": "nodemcu/drying_shoes/lwt"
    }
    
#### MQTT Topic: homeassistant/sensor/drying_shoes/linkquality/config
    {
        "icon": "mdi:signal",
        "unit_of_measurement": "lqi",
        "value_template": "{{ value_json.linkquality }}",
        "state_topic": "nodemcu/drying_shoes",
        "json_attributes_topic": "nodemcu/drying_shoes",
        "name": "drying_shoes_linkquality",
        "unique_id": "ESP-6120123_linkquality",
        "device": {
            "identifiers": [ "ESP-6120123" ],
            "name": "ESP-6120123",
            "sw_version": "ver:1.0",
            "model": "NodeMCU WiFi Switch (1 relay)",
            "manufacturer": "BVE"
        },
        "availability_topic": "nodemcu/drying_shoes/lwt"
    }
#### MQTT Topic: nodemcu/drying_shoes/switch/1/set
    {
        "type":"device_announced",
        "name":"ESP-6120123",
        "switch_1":"ON",
        "linkquality":63,
        "friendly_name":"Drying_Shoes",
        "ip":"192.168.xxx.xxx"
    }
