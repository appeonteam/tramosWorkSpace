$PBExportHeader$c#dwedit.sru
$PBExportComments$Datawindow Edit Style Constants
forward
global type c#dwedit from nonvisualobject
end type
end forward

global type c#dwedit from nonvisualobject
end type
global c#dwedit c#dwedit

type variables
//column edit styles
constant string Edit = "edit"
constant string EditMask = "editmask"
constant string DDLB = "ddlb"
constant string DDDW = "dddw"
constant string CheckBox = "checkbox"
constant string RadioButton = "radiobuttons"
constant string Column = "column"
end variables

on c#dwedit.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#dwedit.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

