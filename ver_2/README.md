# switch-1-nodemcu
Switch 1 relay on NodeMCU platform (Lua)
---

### How to download the project:
    Download all project:
    # cd existing_folder
    # git init
    # git remote add origin git://github.com/belov-ve/switch-1-nodemcu
    # git pull origin master
    
    Or download single version (branch):
    # git init
    # git remote add origin git://github.com/belov-ve/switch-1-nodemcu
    # git fetch
        then choose the desired brunch
        or re-get the list branch:
        # git branch -a
    # git clone -b ver_2 --single-branch git://github.com/belov-ve/switch-1-nodemcu
    
    Or 
    1. Select the required version from branches
    2. Download project from "Code" menu

### Directory structure:
    \firmware\* - NodeMCU custom build
    \schematic\* - electric scheme
    \ver_"N"\ - release version "N"

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
