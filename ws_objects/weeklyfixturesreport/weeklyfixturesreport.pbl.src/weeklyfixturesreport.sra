$PBExportHeader$weeklyfixturesreport.sra
$PBExportComments$Generated Application Object
forward
global type weeklyfixturesreport from application
end type
global mt_n_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
long gl_logHandle
end variables

global type weeklyfixturesreport from application
string appname = "weeklyfixturesreport"
end type
global weeklyfixturesreport weeklyfixturesreport

on weeklyfixturesreport.create
appname="weeklyfixturesreport"
message=create message
sqlca=create mt_n_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on weeklyfixturesreport.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;// If INI-file not exists, return without import
if fileexists("weeklyfixturesreport.ini") = False then return

// !!!!!!!!!!!!!!!! IMPLEMENT SOME ERROR HANDLING !!!!!!!!!!!!!!!!!!!!!!!!!!!
if ProfileInt ( "weeklyfixturesreport.ini", "logfile", "append", 0 ) = 1 then
	gl_logHandle = FileOpen("weeklyfixturesreport.log", LineMode!, Write!, LockWrite!, Append!)
else
	gl_logHandle = FileOpen("weeklyfixturesreport.log", LineMode!, Write!, LockWrite!, Replace!)
end if
if gl_logHandle = -1 then
	return
end if

// Set DB profile. If connect failes, return without import
SQLCA.DBMS 			= ProfileString ( "weeklyfixturesreport.ini", "database", "dbms", "None" )
SQLCA.Database 		= ProfileString ( "weeklyfixturesreport.ini", "database", "database", "None" )
SQLCA.LogPass 		= ProfileString ( "weeklyfixturesreport.ini", "login", "pwd", "None" )
SQLCA.ServerName 	= ProfileString ( "weeklyfixturesreport.ini", "database", "servername", "None" )
SQLCA.LogId 			= ProfileString ( "weeklyfixturesreport.ini", "login", "uid", "None" )
SQLCA.AutoCommit 	= False
SQLCA.DBParm 		= "Release='15'"

connect using SQLCA;
if SQLCA.SQLCode <> 0 then	
	fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Connection to TRAMOS failed!")
	fileClose(gl_logHandle)
	return
end if

n_weeklyfixturereport lnv_weeklyfixturereport
lnv_weeklyfixturereport = create n_weeklyfixturereport
lnv_weeklyfixturereport.createreport( )
destroy lnv_weeklyfixturereport

end event

event close;disconnect using SQLCA;
destroy SQLCA;

fileClose(gl_logHandle)
end event

