$PBExportHeader$c#connectivity.sru
$PBExportComments$database constants used for connectivity.
forward
global type c#connectivity from nonvisualobject
end type
end forward

global type c#connectivity from nonvisualobject
end type
global c#connectivity c#connectivity

type variables
constant string PRODUCTIONSERVER = "ASEPROD"
constant string PRODUCTIONDB = "PROD_TRAMOS"
constant string STANDBYSERVER = "ASESTANDBY"
constant string TESTSERVER = "ASETEST"
constant string TESTDB = "TEST_TRAMOS"
constant string PRETRAMOSDB = "PRE_TRAMOS"

end variables

on c#connectivity.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#connectivity.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

