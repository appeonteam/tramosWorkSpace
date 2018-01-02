$PBExportHeader$releasemanagement.sra
$PBExportComments$Generated Application Object
forward
global type releasemanagement from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type releasemanagement from application
string appname = "releasemanagement"
end type
global releasemanagement releasemanagement

on releasemanagement.create
appname = "releasemanagement"
message = create message
sqlca = create transaction
sqlda = create dynamicdescriptionarea
sqlsa = create dynamicstagingarea
error = create error
end on

on releasemanagement.destroy
destroy( sqlca )
destroy( sqlda )
destroy( sqlsa )
destroy( error )
destroy( message )
end on

