# switch-1-nodemcu
Switch 1 relay on NodeMCU platform (Lua)
---
### Directory structure:
    \firmware\* - NodeMCU custom build
    \schematic\* - electric scheme
    \ver "_"\ - release version "_"

### Note
    1. Prepare the hardware. See electric scheme.
    2. Load NodeMCU firmware.
    3. Select switch version.
    4. All files \ *.lc, \init.lua and \web\*.* copied to the root of the ESP module.
       Or:
       - copy \lua\*.lua files, compile them into bytecode, delete the sources *.lua;
       - copy files \web\lua\*.lua, compile them into bytecode, rename them to * .lch, delete the sources *.lua.
    5. Copy \ha\packages\drying_shoes.yaml into packages of Home Assistant. Set the required sensor name.
    6. Insert lines from \ha\ui-lovelace.yaml into ui-lovelace.yaml (also set the required sensor name).
