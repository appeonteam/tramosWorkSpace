$PBExportHeader$ws_fieldinformation.sru
$PBExportComments$Proxy imported from Web service using Web Service Proxy Generator.
forward
    global type ws_FieldInformation from nonvisualobject
    end type
end forward

global type ws_FieldInformation from nonvisualobject
end type

type variables
    long ws_Type
    string DisplayName
    string InternalName
    string Id
    string Value
end variables

on ws_FieldInformation.create
call super::create
TriggerEvent( this, "constructor" )
end on

on ws_FieldInformation.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

