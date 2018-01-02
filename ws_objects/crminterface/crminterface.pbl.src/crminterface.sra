$PBExportHeader$crminterface.sra
$PBExportComments$Generated Application Object
forward
global type crminterface from application
end type
global mt_n_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type crminterface from application
string appname = "crminterface"
end type
global crminterface crminterface

type prototypes
Function uLong CreateMutex(uLong lpMutexAttributes, Boolean bInitialOwner, String lpName) Library "kernel32" Alias For "CreateMutexA;Ansi"
Function uLong GetLastError() Library "kernel32" Alias For "GetLastError"
Function uLong GetModuleFileName(uLong hModule, ref String lpFileName, Long nSize) Library "kernel32" Alias For "GetModuleFileNameA;Ansi"
end prototypes

on crminterface.create
appname="crminterface"
message=create message
sqlca=create mt_n_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on crminterface.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;//When commoand line is not available, exit application directly
if isnull(commandline) or commandline = "" then halt close
//Open main window
openwithparm(w_crm_interface, commandline)
end event

