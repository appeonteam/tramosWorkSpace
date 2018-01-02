$PBExportHeader$docpublication.sra
$PBExportComments$Generated Application Object
forward
global type docpublication from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type docpublication from application
string appname = "docpublication"
end type
global docpublication docpublication

on docpublication.create
appname="docpublication"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on docpublication.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open(w_document_publication)
end event

