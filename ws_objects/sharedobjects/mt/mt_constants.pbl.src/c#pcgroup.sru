$PBExportHeader$c#pcgroup.sru
forward
global type c#pcgroup from nonvisualobject
end type
end forward

global type c#pcgroup from nonvisualobject
end type
global c#pcgroup c#pcgroup

type variables
constant integer ii_CRUDE = 1
constant integer ii_HANDYTANKERS = 2
constant integer ii_GAS = 3
constant integer ii_SWIFT = 4
constant integer ii_BROSTROM = 5
constant integer ii_PRODUCT = 6
constant integer ii_NOVA = 7

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   c#pcgroup
   <OBJECT>		Declare default ID for profit center group	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	29/07/2013   CR3244       ZSW001        First Version
   </HISTORY>
********************************************************************/

end subroutine

on c#pcgroup.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#pcgroup.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

