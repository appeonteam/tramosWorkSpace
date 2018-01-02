HA$PBExportHeader$tprp.sra
$PBExportComments$Generated Application Object
forward
global type tprp from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

String g_AppFolder
end variables

global type tprp from application
string appname = "tprp"
end type
global tprp tprp

on tprp.create
appname="tprp"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on tprp.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
g_AppFolder = GetCurrentDirectory()
If Right(g_AppFolder, 1) <> "\" then g_AppFolder += "\"

Open(w_Main)
end event

