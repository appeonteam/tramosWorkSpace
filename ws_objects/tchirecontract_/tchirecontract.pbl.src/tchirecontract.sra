$PBExportHeader$tchirecontract.sra
$PBExportComments$Generated Application Object
forward
global type tchirecontract from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
long gl_logHandle
end variables

global type tchirecontract from application
string appname = "tchirecontract"
end type
global tchirecontract tchirecontract

on tchirecontract.create
appname="tchirecontract"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on tchirecontract.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;// If INI-file not exists, return without import
if fileexists("tchirecontract.ini") = False then return

// ERROR HANDLING
gl_logHandle = FileOpen("tchirecontract.log", LineMode!, Write!, LockWrite!, Replace!)
if gl_logHandle = -1 then return

// Set DB profile. If connect failes, return without import
SQLCA.DBMS 			= ProfileString ( "tchirecontract.ini", "database", "dbms", "None" )
SQLCA.Database 	= ProfileString ( "tchirecontract.ini", "database", "database", "None" )
SQLCA.LogPass 		= ProfileString ( "tchirecontract.ini", "login", "pwd", "None" )
SQLCA.ServerName 	= ProfileString ( "tchirecontract.ini", "database", "servername", "None" )
SQLCA.LogId 		= ProfileString ( "tchirecontract.ini", "login", "uid", "None" )
SQLCA.AutoCommit 	= False
SQLCA.DBParm 		= "Release='15', UTF8=1, Appname='server_tchire', host='server_tchire'"

connect using SQLCA;
if SQLCA.SQLCode <> 0 then	
	fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Connection to database failed!")
	fileClose(gl_logHandle)
	return
end if

u_tchire_contract luo_tchire_contract
luo_tchire_contract = create u_tchire_contract
luo_tchire_contract.of_tchire_runout( )
end event

event close;disconnect using SQLCA;

fileClose(gl_logHandle)
end event

