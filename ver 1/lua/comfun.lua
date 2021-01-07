--[[
    # comfun v1.1
    getNext     <- Циклический перебор элементов массива
    doluafile   <- Выполнение файла с выбором расширения
    mgsub       <- Замена символов в строке
========================================================
--]]

--[[ библиотеки для отладки на ББ
local sjson = require "json"
--]]

-----------------------------------------
-- Циклический перебор элементов массива
--
-- Создание: nextEl = getNext(array)
-- Получение следующего: nextEl()
-----------------------------------------
local function getNext (m)
    local i = 0
    if type(m)~="table" then
        m = {m}
    end

    return function()
        i = (i<#m) and (i + 1) or 1
        return m[i]
    end

end

-----------------------------------------
-- Выполнение файла с выбором расширения
-- (скрипт или байт-код)
--
-- Если найден, выполняется .lua
-- нет, .lc
-----------------------------------------
local function doluafile (fn)
    local ext = {'.lua','.lc'}

    fn = file.exists(fn..ext[1]) and fn..ext[1] or fn..ext[2]
    local st, err = pcall(function() return dofile(fn) end)

    if (st) then
        return true
    else
        print(err)
        return false, err
    end
end

-------------------------------------------------
-- Замена символов в строке
--
-- str - исходная строк
-- sub - строка искомых симовлов (кроме ".")
-- rep - строка заменяемых символов
-- mgsub("Test test~", " ~","_-") -> "Test_test-"
-------------------------------------------------
local function mgsub(str, sub, rep)
    local _sub, _rep = {}, {}
    sub:gsub(".", function(s) table.insert(_sub, s) end)
    rep:gsub(".", function(s) table.insert(_rep, s) end)

    for i,v in pairs(_sub) do
      if v~="." then str = str:gsub(v, _rep[i] or "") end
    end

    return str
end

------
return {
    getNext     = getNext,      -- Циклический перебор элементов массива
    doluafile   = doluafile,    -- Выполнение файла с выбором расширения
    mgsub       = mgsub,        -- Замена символов в строке
}
