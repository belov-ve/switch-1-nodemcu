--[[
Скрипт сброса конфигурации на default
ver 1.0
--]]
-- print( "Start Reset to defaul. Heap()" .. tostring(node.heap()) )
do
    if GET.name == Config.name and Conf_file then
        file.remove(Conf_file)
        assert(node.restart())
    end

    GET = {}
    POST = {}

    return "Ok"
end