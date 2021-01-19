--[[
 Описание аппаратной конфигурации
 ver 1.0
--]]

-- Кнопки
Btn = {
    {pin=4, mode=gpio.INT, press=gpio.LOW, presstype="both"}        -- GPIO2 pin4
}

-- Led индикаторы
--[[
Led = {
    {pin=1, on=gpio.LOW, off=gpio.HIGH, mode=gpio.OUTPUT},          -- GPIO5 pin1
    {pin=2, on=gpio.HIGH, off=gpio.LOW, mode=gpio.OUTPUT}
}
--]]

-- Выключатель
Switch = {
    {pin=3, on=gpio.HIGH, off=gpio.LOW, mode=gpio.OUTPUT}           -- GPIO0 pin3
}
