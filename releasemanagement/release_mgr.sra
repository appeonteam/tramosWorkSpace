HA$PBExportHeader$release_mgr.sra
$PBExportComments$Generated Application Object
forward
global type release_mgr from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
n_app g_app
end variables

global type release_mgr from application
string appname = "release_mgr"
end type
global release_mgr release_mgr

type variables

end variables

on release_mgr.create
appname="release_mgr"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on release_mgr.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
g_app.event ue_open()
end event

