$PBExportHeader$c#windowposition.sru
forward
global type c#windowposition from nonvisualobject
end type
end forward

global type c#windowposition from nonvisualobject
end type
global c#windowposition c#windowposition

type variables
//window positions
constant integer TopLeft = 1
constant integer TopCenter = 2
constant integer TopRight = 3
constant integer LeftCenter = 4
constant integer Center = 5
constant integer RightCenter = 6
constant integer BottomLeft = 7
constant integer BottomCenter = 8
constant integer BottomRight = 9
constant integer Cascade = 10
end variables

on c#windowposition.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#windowposition.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

