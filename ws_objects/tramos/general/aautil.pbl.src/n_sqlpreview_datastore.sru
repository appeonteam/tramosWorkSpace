$PBExportHeader$n_sqlpreview_datastore.sru
forward
global type n_sqlpreview_datastore from datastore
end type
end forward

global type n_sqlpreview_datastore from datastore
end type
global n_sqlpreview_datastore n_sqlpreview_datastore

event sqlpreview;MessageBox("SQLsyntax", sqlsyntax)


return 0
end event

on n_sqlpreview_datastore.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_sqlpreview_datastore.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event dberror;MessageBox("sqldbcode", string(sqldbcode))
MessageBox("sqlerrtext", sqlerrtext)
MessageBox("sqlsyntax", sqlsyntax)


end event

