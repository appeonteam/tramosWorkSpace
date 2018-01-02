$PBExportHeader$allegroexport.sra
$PBExportComments$Generated Application Object
forward
global type allegroexport from application
end type
global mt_n_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type allegroexport from application
string appname = "allegroexport"
end type
global allegroexport allegroexport

on allegroexport.create
appname="allegroexport"
message=create message
sqlca=create mt_n_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on allegroexport.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;string ls_sql, ls_ErrText, ls_commandline
n_allegro_export	lnv_allegro
n_error_service	lnv_

lnv_allegro = create n_allegro_export

// sample usage below:
// ls_commandline = "/server:scrbtandkbal311 /db:TEST_TRAMOS /monitor_id:ALLEG /logoutput:ALLEG_[MM].log /transfer:ALL"

lnv_allegro.of_export( false, ls_ErrText, commandline )  //false = not opened from tramos window

destroy lnv_allegro




end event

event close;disconnect using sqlca;

end event

