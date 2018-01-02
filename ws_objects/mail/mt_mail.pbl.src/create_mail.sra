$PBExportHeader$create_mail.sra
$PBExportComments$Generated Application Object
forward
global type create_mail from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type create_mail from application
string appname = "create_mail"
end type
global create_mail create_mail

on create_mail.create
appname="create_mail"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on create_mail.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open(w_test)
end event

