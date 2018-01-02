$PBExportHeader$c#consumptiontype.sru
forward
global type c#consumptiontype from nonvisualobject
end type
end forward

global type c#consumptiontype from nonvisualobject
end type
global c#consumptiontype c#consumptiontype

type variables
constant integer il_SAILING_BALLAST = 1
constant integer il_SAILING_LADEN = 2
constant integer il_ATPORT_LOAD = 3
constant integer il_ATPORT_GENERAL = 4
constant integer il_ATPORT_DISCHARGE = 6
constant integer il_ATPORT_IDLE = 7
constant integer il_ATPORT_HEATING = 8
constant integer il_SAILING_IDLE = 9
constant integer il_SAILING_HEATING = 10

end variables

on c#consumptiontype.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#consumptiontype.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

