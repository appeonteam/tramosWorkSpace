$PBExportHeader$c#email.sru
forward
global type c#email from nonvisualobject
end type
end forward

global type c#email from nonvisualobject
end type
global c#email c#email

type variables
constant string	DOMAIN			= "@maersktankers.com"
constant string	TRAMOSSUPPORT	= "TramosMT@maersktankers.com"
constant long		il_ATT_MAXSIZE	= 14680000 //14M
constant string	LDAPADDRESS    = "LDAP://shore"
end variables

on c#email.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#email.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

