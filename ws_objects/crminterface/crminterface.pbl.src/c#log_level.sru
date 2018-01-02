$PBExportHeader$c#log_level.sru
$PBExportComments$msps constant
forward
global type c#log_level from nonvisualobject
end type
end forward

global type c#log_level from nonvisualobject
end type
global c#log_level c#log_level

type variables
constant string is_LOW    = "low"
constant string is_MEDIUM = "medium"
constant string is_HIGH   = "high"

constant string is_GET_LOG_LEVEL_FAILED = "Failed to get the log level"
end variables

on c#log_level.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#log_level.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

