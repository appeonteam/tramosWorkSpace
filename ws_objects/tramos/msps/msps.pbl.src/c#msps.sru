$PBExportHeader$c#msps.sru
$PBExportComments$msps constant
forward
global type c#msps from nonvisualobject
end type
end forward

global type c#msps from nonvisualobject
end type
global c#msps c#msps

type variables
//msps message status
constant integer ii_NEW = 1
constant integer ii_ARCHIVE = 2
constant integer ii_REJECTED = 3
constant integer ii_APPROVED = 4
constant integer ii_FAILED = 5
constant integer ii_ACTIVE = 6

//msps load or discharge status
constant integer ii_LOAD = 1
constant integer ii_DISCHARGE = 0

//sent e-mail status
constant integer ii_SENDMAIL = 1

//Message type
constant string is_ARRIVAL = "arrival"
constant string is_CANAL = "canal"
constant string is_FWODRIFT = "fwo/drift"
constant string is_LOAD = "loading"
constant string is_DISCHARGE = "discharging"
constant string is_HEATING = "heating"
constant string is_NOON = "noon"

end variables

on c#msps.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#msps.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

