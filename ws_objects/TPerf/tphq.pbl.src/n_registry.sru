$PBExportHeader$n_registry.sru
forward
global type n_registry from nonvisualobject
end type
end forward

global type n_registry from nonvisualobject autoinstantiate
end type

forward prototypes
public function integer savesetting (string as_setting, string as_value)
public function string getsetting (string as_setting, string as_default)
end prototypes

public function integer savesetting (string as_setting, string as_value);// This function write a setting to the registry

Return RegistrySet("HKEY_LOCAL_MACHINE\Software\TPerf", as_Setting, RegString!, as_Value)
end function

public function string getsetting (string as_setting, string as_default);
// This function returns a TPerf setting from the registry

String ls_Value

If RegistryGet("HKEY_LOCAL_MACHINE\Software\TPerf\", as_Setting, RegString!, ls_Value) = 1 then Return ls_Value Else Return as_Default
end function

on n_registry.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_registry.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

