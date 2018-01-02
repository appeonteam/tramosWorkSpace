$PBExportHeader$c#usergroup.sru
forward
global type c#usergroup from nonvisualobject
end type
end forward

global type c#usergroup from nonvisualobject
end type
global c#usergroup c#usergroup

type variables
constant int  #SUPERUSER  = 2
constant int  #USER = 1
constant int  #ADMINISTRATOR  = 3
constant int  #EXTERNAL_PARTNER  = -2
constant int  #EXTERNAL_APM  = -1
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN>	(None):
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>declare var about users group</USAGE>
   <HISTORY>
   	Date       CR-Ref       		Author             Comments
   	2011-10-20 CR1573            	RJH022        First Version
   </HISTORY>
********************************************************************/
end subroutine

on c#usergroup.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#usergroup.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

