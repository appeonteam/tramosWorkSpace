$PBExportHeader$ws_copyresult.sru
$PBExportComments$Proxy imported from Web service using Web Service Proxy Generator.
forward
    global type ws_CopyResult from nonvisualobject
    end type
end forward

global type ws_CopyResult from nonvisualobject
end type

type variables
    long ErrorCode
    string ErrorMessage
    string DestinationUrl
end variables

on ws_CopyResult.create
call super::create
TriggerEvent( this, "constructor" )
end on

on ws_CopyResult.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

