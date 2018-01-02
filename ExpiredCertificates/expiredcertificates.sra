HA$PBExportHeader$expiredcertificates.sra
$PBExportComments$Generated Application Object
forward
global type expiredcertificates from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
long gl_logHandle
integer	gi_expireddays
string	gs_testemailaddress
string	gs_testemailaddress2
end variables

global type expiredcertificates from application
string appname = "expiredcertificates"
end type
global expiredcertificates expiredcertificates

type variables
//datetime idt_startdate, idt_enddate


end variables

on expiredcertificates.create
appname="expiredcertificates"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on expiredcertificates.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;// If INI-file not exists, return without import
if fileexists("expiredcertificates.ini") = False then return

// ERROR HANDLING
if ProfileInt ( "expiredcertificates.ini", "logfile", "append", 0 ) = 1 then
	gl_logHandle = FileOpen("expiredcertificates.log", LineMode!, Write!, LockWrite!, Append!)
else
	gl_logHandle = FileOpen("expiredcertificates.log", LineMode!, Write!, LockWrite!, Replace!)
end if
if gl_logHandle = -1 then return

// Set DB profile. If connect failes, return without import
SQLCA.DBMS 			= ProfileString ( "expiredcertificates.ini", "database", "dbms", "None" )
SQLCA.Database 	= ProfileString ( "expiredcertificates.ini", "database", "database", "None" )
SQLCA.LogPass 		= ProfileString ( "expiredcertificates.ini", "login", "pwd", "None" )
SQLCA.ServerName 	= ProfileString ( "expiredcertificates.ini", "database", "servername", "None" )
SQLCA.LogId 		= ProfileString ( "expiredcertificates.ini", "login", "uid", "None" )
SQLCA.AutoCommit 	= False
SQLCA.DBParm 		= "Release='15', UTF8=1, appname='server_expiredcertificates', host='server_expiredcertificates' "

gi_expireddays = Integer(ProfileString ( "expiredcertificates.ini", "criteria", "expireddays", "0" ))
gs_testemailaddress=ProfileString ( "expiredcertificates.ini", "criteria", "test_email", "" )
gs_testemailaddress2=ProfileString ( "expiredcertificates.ini", "criteria", "test_email2", "" )

connect using SQLCA;
if SQLCA.SQLCode <> 0 then	
	fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Connection to database failed!")
	fileClose(gl_logHandle)
	return
end if

u_expiredcertificates luo_expiredcertificates
luo_expiredcertificates = create u_expiredcertificates
if luo_expiredcertificates.of_start() = 1 then
	fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Expired Cetificates Sucessfull")
else
	fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Expired Cetificates Failed!")
end if

end event

event close;disconnect using SQLCA;

fileClose(gl_logHandle)
end event

