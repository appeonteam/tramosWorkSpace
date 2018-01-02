$PBExportHeader$w_iom_sin_vessels.srw
$PBExportComments$Used fro storing special CODA account numbers for Isle of Man and Singapore vesels.
forward
global type w_iom_sin_vessels from mt_w_main
end type
type st_4 from statictext within w_iom_sin_vessels
end type
type cb_close from mt_u_commandbutton within w_iom_sin_vessels
end type
type cb_delete from mt_u_commandbutton within w_iom_sin_vessels
end type
type cb_insert from mt_u_commandbutton within w_iom_sin_vessels
end type
type cb_retrieve from mt_u_commandbutton within w_iom_sin_vessels
end type
type cb_update from mt_u_commandbutton within w_iom_sin_vessels
end type
type st_3 from statictext within w_iom_sin_vessels
end type
type st_2 from statictext within w_iom_sin_vessels
end type
type st_1 from statictext within w_iom_sin_vessels
end type
type dw_iom_sin_vessels from mt_u_datawindow within w_iom_sin_vessels
end type
end forward

global type w_iom_sin_vessels from mt_w_main
integer x = 1074
integer y = 484
integer width = 4091
integer height = 2636
string title = "IOM/SIN Vessels"
long backcolor = 32304364
st_4 st_4
cb_close cb_close
cb_delete cb_delete
cb_insert cb_insert
cb_retrieve cb_retrieve
cb_update cb_update
st_3 st_3
st_2 st_2
st_1 st_1
dw_iom_sin_vessels dw_iom_sin_vessels
end type
global w_iom_sin_vessels w_iom_sin_vessels

type variables
mt_n_dddw_searchasyoutype inv_dddw_search
end variables

forward prototypes
private function integer wf_validate ()
public subroutine documentation ()
end prototypes

private function integer wf_validate ();// Validate date elements if 'Post TO as Crew' is cheched
long ll_rows, ll_row, ll_foundrow
constant string ls_METHOD="wf_validate()"
mt_n_datastore	lds_mtbrovessels

lds_mtbrovessels = create mt_n_datastore

lds_mtbrovessels.dataobject = "d_sq_tb_bro_mt_vessels"
lds_mtbrovessels.settransobject( sqlca)
lds_mtbrovessels.retrieve( )

dw_iom_sin_vessels.accepttext( )

ll_rows = dw_iom_sin_vessels.rowcount( )

if dw_iom_sin_vessels.modifiedcount( )=0 then return c#return.NoAction

for ll_row = 1 to ll_rows

	ll_foundrow = lds_mtbrovessels.find("vessel_nr=" + string(dw_iom_sin_vessels.getItemNumber(ll_row, "iom_sin_vessels_vessel_nr")),1,10000)
	if ll_foundrow>0 then
		_addmessage( this.classdefinition, ls_METHOD,"Validation error - You are not able to create an IOM/Sing vessel when it is contained within the Brostrom/MT vessel setup for Crew/T.O.  Please correct this!", "User validation error")
		dw_iom_sin_vessels.post ScrollToRow(ll_row)
		dw_iom_sin_vessels.post setColumn( "iom_sin_vessels_post_to_startdate" )
		dw_iom_sin_vessels.post setFocus()
		return -1				
	end if
	if dw_iom_sin_vessels.getItemNumber(ll_row, "iom_sin_vessels_post_to_as_crew") = 1 then
		if isNull(dw_iom_sin_vessels.getItemDatetime(ll_row, "iom_sin_vessels_post_to_startdate")) then
			_addmessage( this.classdefinition, ls_METHOD,"Validation error - You must enter a startdate when 'Post T.O. as Crew' is checked. Please correct!", "User validation error")
			dw_iom_sin_vessels.post ScrollToRow(ll_row)
			dw_iom_sin_vessels.post setColumn( "iom_sin_vessels_post_to_startdate" )
			dw_iom_sin_vessels.post setFocus()
			return -1
		end if
		if NOT isNull(dw_iom_sin_vessels.getItemDatetime(ll_row, "iom_sin_vessels_post_to_enddate")) then
			if dw_iom_sin_vessels.getItemDatetime(ll_row, "iom_sin_vessels_post_to_startdate") &
			>= dw_iom_sin_vessels.getItemDatetime(ll_row, "iom_sin_vessels_post_to_enddate") then
				_addmessage( this.classdefinition, ls_METHOD,"Validation error - Startdate must be before enddate. Please correct!", "User validation error")
				dw_iom_sin_vessels.post ScrollToRow(ll_row)
				dw_iom_sin_vessels.post setColumn( "iom_sin_vessels_post_to_startdate" )
				dw_iom_sin_vessels.post setFocus()
				return -1
			end if			
		end if	
	end if
next

destroy lds_mtbrovessels

return 1
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

event open;datawindowchild 	ldwc
n_service_manager		lnv_serviceMgr
n_dw_style_service   lnv_style

dw_iom_sin_vessels.SetTransObject(SQLCA)
/* Populate dropdown */
dw_iom_sin_vessels.getchild("iom_sin_vessels_vessel_nr", ldwc)
ldwc.setTransObject(sqlca)
ldwc.retrieve()
ldwc.setfilter("bromt=0")
ldwc.filter()
/* setup datawindow formatter service */
lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_iom_sin_vessels)

dw_iom_sin_vessels.Retrieve()
COMMIT;




/* Only user with administrator rights have access */
IF  uo_global.ii_access_level = 3 or  (uo_global.ii_user_profile = 3 and  uo_global.ii_access_level = 2) THEN
	dw_iom_sin_vessels.Enabled = TRUE
	cb_insert.Enabled = TRUE
	cb_update.Enabled = TRUE
	cb_delete.Enabled = TRUE
else
	dw_iom_sin_vessels.Enabled = TRUE
	dw_iom_sin_vessels.object.datawindow.readonly = "Yes"
END IF

//SetRowFocusIndicator(Hand!) 
dw_iom_sin_vessels.SetRowFocusIndicator(FocusRect!)
IF dw_iom_sin_vessels.RowCount() > 0 THEN
	dw_iom_sin_vessels.SetRow(1)
	dw_iom_sin_vessels.SetFocus()
END IF


end event

event closequery;long ll_return
IF dw_iom_sin_vessels.ModifiedCount( ) > 0 THEN
	ll_return = MessageBox("About to close", "Are you sure you will close the window ? All rows are not updated!",Question!,YesNo!,2)
	IF ll_return = 2 THEN
		return 1
	END IF
END IF
end event

on w_iom_sin_vessels.create
int iCurrent
call super::create
this.st_4=create st_4
this.cb_close=create cb_close
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.cb_retrieve=create cb_retrieve
this.cb_update=create cb_update
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_iom_sin_vessels=create dw_iom_sin_vessels
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_insert
this.Control[iCurrent+5]=this.cb_retrieve
this.Control[iCurrent+6]=this.cb_update
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.dw_iom_sin_vessels
end on

on w_iom_sin_vessels.destroy
call super::destroy
destroy(this.st_4)
destroy(this.cb_close)
destroy(this.cb_delete)
destroy(this.cb_insert)
destroy(this.cb_retrieve)
destroy(this.cb_update)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_iom_sin_vessels)
end on

type st_hidemenubar from mt_w_main`st_hidemenubar within w_iom_sin_vessels
end type

type st_4 from statictext within w_iom_sin_vessels
integer x = 23
integer y = 544
integer width = 4005
integer height = 132
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "If ~"Post T.O. as Crew~" is checked, then all TO Expenses will be posted the same way as Crew expenses if the Port Arrival date is within given start and enddate"
boolean focusrectangle = false
end type

type cb_close from mt_u_commandbutton within w_iom_sin_vessels
integer x = 1472
integer y = 2404
integer height = 108
integer taborder = 32
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_delete from mt_u_commandbutton within w_iom_sin_vessels
integer x = 1111
integer y = 2404
integer height = 108
integer taborder = 40
boolean enabled = false
string text = "&Delete"
end type

event clicked;Integer li_result

li_result = MessageBox("Delete", "Is it OK to delete the row ?" ,  Exclamation!, OKCancel!, 2)
IF li_result = 1 THEN 
	// Process OK.
	dw_iom_sin_vessels.DeleteRow(0)

	IF dw_iom_sin_vessels.Update() = 1 THEN
		COMMIT;
	ELSE
		MessageBox("Update Error","Update of IOM/SIN Vessels failed")
		ROLLBACK;
	END IF
END IF

IF dw_iom_sin_vessels.RowCount() > 0 THEN
	dw_iom_sin_vessels.SetRow(1)
	dw_iom_sin_vessels.SetFocus()
END IF

end event

type cb_insert from mt_u_commandbutton within w_iom_sin_vessels
integer x = 389
integer y = 2404
integer height = 108
integer taborder = 30
boolean enabled = false
string text = "&Insert"
end type

event clicked;long ll_row

ll_row = dw_iom_sin_vessels.InsertRow(0)
dw_iom_sin_vessels.ScrollToRow(ll_row)
dw_iom_sin_vessels.SetRow(ll_row)
dw_iom_sin_vessels.SetFocus()
	
end event

type cb_retrieve from mt_u_commandbutton within w_iom_sin_vessels
integer x = 27
integer y = 2404
integer height = 108
integer taborder = 10
string text = "&Retrieve"
end type

event clicked;dw_iom_sin_vessels.Retrieve()
COMMIT;

IF dw_iom_sin_vessels.RowCount() > 0 THEN
	dw_iom_sin_vessels.SetRow(1)
	dw_iom_sin_vessels.SetFocus()
END IF

end event

type cb_update from mt_u_commandbutton within w_iom_sin_vessels
integer x = 750
integer y = 2404
integer height = 108
integer taborder = 50
boolean enabled = false
string text = "&Update"
end type

event clicked;IF wf_validate() = -1 then return

IF dw_iom_sin_vessels.Update() = 1 THEN
	COMMIT;
ELSE
	MessageBox("Update Error","Update of IOM/SIN Vessels failed")
	ROLLBACK;
END IF

IF dw_iom_sin_vessels.RowCount() > 0 THEN
	dw_iom_sin_vessels.SetRow(1)
	dw_iom_sin_vessels.SetFocus()
END IF

end event

type st_3 from statictext within w_iom_sin_vessels
integer x = 23
integer y = 344
integer width = 4005
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
string text = "Expenses with TRAMOS voucher numbers marked as ~'T.O. Expenses~', will use elements from voucher table APM vessels, since expenses updated on these voucher numbers shall be paid by T.O. (who subsequently charge IOM/SIN)."
boolean focusrectangle = false
end type

type st_2 from statictext within w_iom_sin_vessels
integer x = 23
integer y = 188
integer width = 4005
integer height = 148
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
string text = "Expenses with TRAMOS voucher numbers marked as ~'Crew Expenses~', will use the elements from the list below, since expenses updated on these voucher numbers shall be paid by IOM/SIN."
boolean focusrectangle = false
end type

type st_1 from statictext within w_iom_sin_vessels
integer x = 23
integer y = 32
integer width = 4005
integer height = 144
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
string text = "This window is used to store information for ~"settling of disbursement expenses~". If a vessel is in the list below, the settling will be handled as described here:"
boolean focusrectangle = false
end type

type dw_iom_sin_vessels from mt_u_datawindow within w_iom_sin_vessels
integer x = 23
integer y = 704
integer width = 4005
integer height = 1676
integer taborder = 20
boolean enabled = false
string dataobject = "d_iom_sin_vessels"
boolean vscrollbar = true
boolean border = false
end type

event clicked;IF row > 0 THEN
//	this.SelectRow(0, FALSE)
//	this.SelectRow(row, TRUE)
	this.SetRow(row)
END IF
end event

event dberror;call super::dberror;string 					ls_userfriendlymessage
n_service_manager 	lnv_serviceManager
n_error_service		lnv_errService

lnv_serviceManager.of_loadservice( lnv_errService , "n_error_service")
constant string METHOD = "dberror"

choose case sqldbcode
	case 547
		ls_userfriendlymessage="There is a constraint stopping the system completing this task"
	case 2601
		ls_userfriendlymessage="Can not make change as the record is a duplicate"
	case else
		ls_userfriendlymessage=string(sqldbcode) + ":Something unexpected has occured.  We have logged the error in the database"
end choose

lnv_errService.of_addMsg(this.classdefinition , METHOD, ls_userfriendlymessage, sqlerrtext + "(dbcode=" + string(sqldbcode)+ ")"  )
lnv_errService.of_showmessages( )

return 3

end event

event editchanged;call super::editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, dw_iom_sin_vessels)
end event

