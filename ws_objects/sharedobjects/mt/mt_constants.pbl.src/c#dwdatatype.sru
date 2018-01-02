$PBExportHeader$c#dwdatatype.sru
$PBExportComments$Datawindow Column Data Type Constants
forward
global type c#dwdatatype from nonvisualobject
end type
end forward

global type c#dwdatatype from nonvisualobject
end type
global c#dwdatatype c#dwdatatype

type variables
//column data types
constant string Char = "char"
constant string Date = "date"
constant string Datetime = "datetime"
constant string Decimal = "decimal"
constant string Int = "int"
constant string Long = "long"
constant string Number = "number"
constant string Real = "real"
constant string Time = "time"
constant string Timestamp = "timestamp"
constant string Ulong = "ulong"
end variables

on c#dwdatatype.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#dwdatatype.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

