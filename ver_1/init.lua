node.egc.setmode(node.egc.ALWAYS)

CF = require "comfun"

CF.doluafile("loadHW")          -- загрузка аппаратной конфигурации
CF.doluafile("loadConfig")      -- загрузка конфигурации
CF.doluafile("initHW")          -- инцицализация аппаратной конфигурации
CF.doluafile("initNet")         -- выбор и загрузка сетевой конфигурации
