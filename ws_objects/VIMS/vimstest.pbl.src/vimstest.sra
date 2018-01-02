$PBExportHeader$vimstest.sra
$PBExportComments$Generated Application Object
forward
global type vimstest from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

String gs_userid
end variables

global type vimstest from application
string appname = "vimstest"
end type
global vimstest vimstest

on vimstest.create
appname="vimstest"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on vimstest.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
Open(w_login)


end event

