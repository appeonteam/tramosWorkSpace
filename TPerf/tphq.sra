HA$PBExportHeader$tphq.sra
$PBExportComments$Generated Application Object
forward
global type tphq from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
user_info g_UserInfo

param_info g_Parameters

n_voyage gnv_Voyage





end variables
global type tphq from application
string appname = "tphq"
string displayname = "Tramper Performance System"
end type
global tphq tphq

type variables

end variables

on tphq.create
appname="tphq"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on tphq.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;// The login process is contained in w_login
// w_login will fill the g_userinfo structure on successful connection

g_parameters.AppVersion = "02.25.00"  // Always use double digits
g_parameters.AppBuilt = "02 Jul 2012"

open(w_login)

if g_userinfo.userid > "" then Open(w_main)   // Successful login

	

end event

