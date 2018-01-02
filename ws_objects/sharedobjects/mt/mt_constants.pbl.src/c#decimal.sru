$PBExportHeader$c#decimal.sru
forward
global type c#decimal from nonvisualobject
end type
end forward

global type c#decimal from nonvisualobject
end type
global c#decimal c#decimal

type variables
constant decimal{4} AvgMonthDays = 30.416
constant decimal{4} GrossToNetRate = 0.9625
end variables

on c#decimal.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#decimal.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

