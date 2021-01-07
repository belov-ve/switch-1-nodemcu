--[[
Скрипт перезгрузки node
Режим загрузки в GET.mode
ver 1.0
--]]
-- print( string.format("Reboot node in %s. Heap() %u", GET.mode or "nil", node.heap()) )
do
    local st = {"ap","st"}

    -- функция поиска индекса элемента по таблице
    local function findInTable(tbl, value)
        if tbl and type(tbl)=="table" and value then
            for i, v in pairs(tbl) do
                if v == value then return i end
            end
        end
        return nil
    end

    if GET.name == Config.name and Conf_file and Config and findInTable(st, GET.mode) then
        Config.mode = GET.mode

        local j = sjson.encode(Config)
        if file.open(Conf_file, "w+") then
            file.write(j)
            file.close()
        -- else
            -- print("Error save config file")
        end

        node.restart()
    end

    GET = {}
    POST = {}

    return "ОК"
end