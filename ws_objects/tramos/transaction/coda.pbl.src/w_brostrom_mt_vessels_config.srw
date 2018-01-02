$PBExportHeader$w_brostrom_mt_vessels_config.srw
$PBExportComments$Brostrom vessels managed by Maersk Tankers
forward
global type w_brostrom_mt_vessels_config from mt_w_main
end type
type cb_delete from mt_u_commandbutton within w_brostrom_mt_vessels_config
end type
type cb_cancel from mt_u_commandbutton within w_brostrom_mt_vessels_config
end type
type cb_update from mt_u_commandbutton within w_brostrom_mt_vessels_config
end type
type cb_new from mt_u_commandbutton within w_brostrom_mt_vessels_config
end type
type dw_configuration from mt_u_datawindow within w_brostrom_mt_vessels_config
end type
end forward

global type w_brostrom_mt_vessels_config from mt_w_main
integer width = 2839
integer height = 2072
string title = "Broström/MT Vessels"
event ue_postopen ( )
cb_delete cb_delete
cb_cancel cb_cancel
cb_update cb_update
cb_new cb_new
dw_configuration dw_configuration
end type
global w_brostrom_mt_vessels_config w_brostrom_mt_vessels_config

type variables
n_brostrom_mt_vessels_config_interface  _inv_interface
mt_n_dddw_searchasyoutype inv_dddw_search
end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_postopen();n_service_manager 		lnv_servicemgr
n_dw_style_service  	lnv_dwstyle
long ll_rows

// _inv_interface = create n_brostrom_mt_vessels_config_interface
lnv_servicemgr.of_loadservice( lnv_dwstyle, "n_dw_style_service")


if _inv_interface.of_share( "config", this.dw_configuration) = c#return.failure then
	_addMessage( this.classdefinition, "constructor", "Error getting the data for the configuration", "The interface manager of_share() function failed")	
	return
end if

lnv_dwstyle.of_dwlistformater(dw_configuration)


cb_cancel.event clicked( )

end event

public subroutine documentation ();/********************************************************************
   ObjectName: w_brostrom_mt_vessels_config
	
   <OBJECT> Window for configuration of Brostrom Maersk Tankers
	managed Vessels.</OBJECT>
   <DESC></DESC>
   <USAGE>  Visual aspect of the window and controls.</USAGE>
   <ALSO>   n_brostrom_mt_vessels_config_interface, n_dw_validation_service</ALSO>
    Date   		Ref    			Author	Comments
  19/04/11 	CR#2323		AGL     	First Version
  28/08/14	CR3781		CCY018	The window title match with the text of a menu item
********************************************************************/

end subroutine

on w_brostrom_mt_vessels_config.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.cb_new=create cb_new
this.dw_configuration=create dw_configuration
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_update
this.Control[iCurrent+4]=this.cb_new
this.Control[iCurrent+5]=this.dw_configuration
end on

on w_brostrom_mt_vessels_config.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.cb_new)
destroy(this.dw_configuration)
end on

event open;call super::open;post event ue_postopen()
end event

event closequery;call super::closequery;if _inv_interface.of_Updatespending( ) then
	if MessageBox("Confirm Changes", "You have data that is not saved yet. Would you like to save the date before closing?", Question!,YesNo!, 1) = 1 then
		return 1
	else 
		return 0
	end if
else
	return 0
end if	
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_brostrom_mt_vessels_config
end type

type cb_delete from mt_u_commandbutton within w_brostrom_mt_vessels_config
integer x = 750
integer y = 1836
integer taborder = 30
string text = "Delete"
end type

event clicked;call super::clicked;_inv_interface.of_deleterow( "config", dw_configuration.getrow())



end event

type cb_cancel from mt_u_commandbutton within w_brostrom_mt_vessels_config
integer x = 1106
integer y = 1836
integer taborder = 20
string text = "Cancel"
end type

event clicked;call super::clicked;long ll_rows
ll_rows = _inv_interface.of_retrieve()

datawindowchild ldwc

dw_configuration.getchild("vessel_nr", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.setfilter("iomsin=0 and pcgroup_id=5")
ldwc.filter()

end event

type cb_update from mt_u_commandbutton within w_brostrom_mt_vessels_config
integer x = 393
integer y = 1836
integer taborder = 20
string text = "Update"
end type

event clicked;call super::clicked;long ll_row=0
integer li_column=0

dw_configuration.accepttext( )

if _inv_interface.of_update("config",ll_row, li_column) = c#return.Failure and ll_row > 0 then
	/* position cursor if possible */
	dw_configuration.setrow( ll_row)
	dw_configuration.scrolltorow(ll_row)
	dw_configuration.post setcolumn(li_column)
	dw_configuration.post setfocus()
end if


end event

type cb_new from mt_u_commandbutton within w_brostrom_mt_vessels_config
integer x = 37
integer y = 1836
integer taborder = 20
string text = "New"
end type

event clicked;call super::clicked;long ll_row
ll_row = _inv_interface.of_insertrow( "config")
dw_configuration.setrow(ll_row)
dw_configuration.setcolumn("vessel_nr")
dw_configuration.scrolltorow(ll_row)
dw_configuration.setfocus( )

end event

type dw_configuration from mt_u_datawindow within w_brostrom_mt_vessels_config
integer x = 37
integer y = 56
integer width = 2715
integer height = 1728
integer taborder = 10
boolean vscrollbar = true
end type

event dberror;call super::dberror;n_error_service 		lnv_error
n_service_manager 	lnv_SrvMgr
string 					ls_userfriendlymessage

constant string METHOD = "dberror"

lnv_SrvMgr.of_loadservice( lnv_error, "n_error_service")

choose case sqldbcode
	case 547
		ls_userfriendlymessage="There is a constraint stopping the system completing this task"
	case 2601
		ls_userfriendlymessage="Can not make change as the record is a duplicate"
	case else
		lnv_error.of_dblogging( true )
		ls_userfriendlymessage=string(sqldbcode) + ":Something unexpected has occured.  We have logged the error in the database"
end choose

lnv_error.of_addmsg(this.classdefinition, METHOD, ls_userfriendlymessage, sqlerrtext + "(dbcode=" + string(sqldbcode)+ ")" , 2)

return 3
end event

event editchanged;call super::editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, dw_configuration)
end event

