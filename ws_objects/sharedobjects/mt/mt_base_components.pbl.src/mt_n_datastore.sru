$PBExportHeader$mt_n_datastore.sru
forward
global type mt_n_datastore from datastore
end type
end forward

shared variables
boolean sb_datastore_spy = false
boolean sb_multi_datastore_spy = false
end variables

global type mt_n_datastore from datastore
end type
global mt_n_datastore mt_n_datastore

type variables


end variables

forward prototypes
public function integer saveasexcel ()
public subroutine of_setdatastorespy (boolean ab_enabled)
public subroutine of_setmultidatastorespy (boolean ab_enabled)
end prototypes

public function integer saveasexcel ();
String ls_File, ls_Path = ""

If GetFileSaveName("Select file to save as:", ls_File, ls_Path, "xls", "Microsoft Excel File (*.xls),*.xls") < 0 then Return 0

Return SaveAs(ls_File, Excel8!, True)
end function

public subroutine of_setdatastorespy (boolean ab_enabled);sb_datastore_spy = ab_enabled
end subroutine

public subroutine of_setmultidatastorespy (boolean ab_enabled);sb_multi_datastore_spy = ab_enabled
end subroutine

on mt_n_datastore.create
call super::create
TriggerEvent( this, "constructor" )
end on

on mt_n_datastore.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event sqlpreview;if isValid(w_sqlsyntax_spy) then
	n_service_manager  lnv_service
	n_dw_spy_service		lnv_spy
	lnv_service.of_loadservice( lnv_spy , "n_dw_spy_service")
	lnv_spy.of_addMonitorDetail(classdefinition, "sqlpreview", sqlsyntax)
end if
end event

event retrievestart;n_service_manager  lnv_service
n_dw_spy_service		lnv_spy

if isValid(w_sqlsyntax_spy) then
	lnv_service.of_loadservice( lnv_spy , "n_dw_spy_service")
	lnv_spy.of_addMonitorDetail(classdefinition, "sqlpreview", "Retrieve START " &
																				+ string(now(), "HH:mm:ss:fff") &
																				+ " Dataobject = '" + this.dataObject +"'" )
end if



end event

event retrieveend;n_ds_spy_parameters lnv_parm
mt_n_datastore lds_data
w_ds_spy  lw_spy

if isValid(w_sqlsyntax_spy) then
	n_service_manager  lnv_service
	n_dw_spy_service		lnv_spy
	lnv_service.of_loadservice( lnv_spy , "n_dw_spy_service")
	lnv_spy.of_addMonitorDetail(classdefinition, "sqlpreview", "Retrieve END "+ string(now(), "HH:mm:ss:fff")+ " Rows retrieved = "+string(rowcount) )
end if

if sb_datastore_spy then
	lds_data = create mt_n_datastore
	lds_data = this
	lds_data.getfullstate(lnv_parm.ibl_data)
	lnv_parm.is_dataobject = lds_data.dataobject
	// multiple datastores 
	if sb_multi_datastore_spy then
		openwithparm(lw_spy, lnv_parm)
	else
		if isValid(w_ds_spy) then
			w_ds_spy.event ue_postopen(lnv_parm)
		else
			openwithparm(w_ds_spy, lnv_parm  )
		end if
	end if	
end if

end event

event dberror;n_error_service lnv_error
n_service_manager lnv_serviceMgr
lnv_serviceMgr.of_loadservice( lnv_error, "n_error_service")
string ls_userfriendlymessage

constant string METHOD = "dberror"

choose case sqldbcode
	case 547
		ls_userfriendlymessage="There is a constraint stopping the system completing this task"
	case 2601
		ls_userfriendlymessage="Can not make change as the record is a duplicate"
	case else
		lnv_error.of_dblogging( true )
		ls_userfriendlymessage=string(sqldbcode) + ":Something unexpected has occured.  It is recommended that you close Tramos and log in again."
end choose

lnv_error.of_addmsg(this.classdefinition, METHOD, ls_userfriendlymessage, sqlerrtext + "(dbcode=" + string(sqldbcode)+ ")" , 2)
lnv_error.of_showmessages( )

return 1
end event

