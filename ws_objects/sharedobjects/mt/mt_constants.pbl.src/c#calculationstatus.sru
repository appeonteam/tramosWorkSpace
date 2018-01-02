$PBExportHeader$c#calculationstatus.sru
forward
global type c#calculationstatus from nonvisualobject
end type
end forward

global type c#calculationstatus from nonvisualobject
end type
global c#calculationstatus c#calculationstatus

type variables
constant integer il_DELETED = 0
constant integer il_TEMPLATE = 1
constant integer il_WORKING = 2
constant integer il_OFFER = 3
constant integer il_FIXTURE = 4
constant integer il_CALCULATED = 5
constant integer il_ESTIMATED = 6
constant integer il_LOADLOAD = 7


end variables

on c#calculationstatus.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#calculationstatus.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

