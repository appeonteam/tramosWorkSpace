$PBExportHeader$msps_interface.sra
$PBExportComments$Generated Application Object
forward
global type msps_interface from application
end type
global mt_n_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

end variables

global type msps_interface from application
string appname = "msps_interface"
end type
global msps_interface msps_interface

type prototypes
Function uLong CreateMutex(uLong lpMutexAttributes, Boolean bInitialOwner, String lpName) Library "kernel32" Alias For "CreateMutexA;Ansi"
Function uLong GetLastError() Library "kernel32" Alias For "GetLastError"
Function uLong GetModuleFileName(uLong hModule, ref String lpFileName, Long nSize) Library "kernel32" Alias For "GetModuleFileNameA;Ansi"
end prototypes

on msps_interface.create
appname="msps_interface"
message=create message
sqlca=create mt_n_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on msps_interface.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event close;disconnect using sqlca;
destroy sqlca;
end event

event open;//Open main window directly
openwithparm(w_msps_interface, commandline)
end event

