$PBExportHeader$c#profile.sru
forward
global type c#profile from nonvisualobject
end type
end forward

global type c#profile from nonvisualobject
end type
global c#profile c#profile

type variables
public:
constant int CHARTERER  = 1
constant int OPERATOR   = 2
constant int FINANCE    = 3
constant int DEVELOPER  = 4
constant int SUPPORT    = 5

end variables

on c#profile.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#profile.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

