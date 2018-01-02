$PBExportHeader$safeportmemo.sra
$PBExportComments$Generated Application Object
forward
global type safeportmemo from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
n_cst_appmanager 	gnv_app 

end variables

global type safeportmemo from application
string appname = "safeportmemo"
end type
global safeportmemo safeportmemo

type variables
n_safeportmemo inv_safememo
end variables

on safeportmemo.create
appname="safeportmemo"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on safeportmemo.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;gnv_app = CREATE n_cst_appmanager
gnv_app.Event pfc_Open(commandline)

inv_safememo = create n_safeportmemo
inv_safememo.of_controlSequence()
destroy inv_safememo

gnv_app.Event pfc_Close( )
DESTROY n_cst_appmanager



end event

