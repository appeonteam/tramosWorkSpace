$PBExportHeader$w_off_services.srw
$PBExportComments$This widow lets the opertaot create/delete off services
forward
global type w_off_services from w_vessel_basewindow
end type
type st_red from statictext within w_off_services
end type
type dw_off_services from uo_datawindow within w_off_services
end type
type st_blue from statictext within w_off_services
end type
type st_1 from statictext within w_off_services
end type
type cb_new from commandbutton within w_off_services
end type
type cb_close from commandbutton within w_off_services
end type
type cb_delete from commandbutton within w_off_services
end type
type cb_print from commandbutton within w_off_services
end type
type cb_modify from commandbutton within w_off_services
end type
type cb_calc from commandbutton within w_off_services
end type
end forward

global type w_off_services from w_vessel_basewindow
integer width = 4663
integer height = 2628
string title = "Off-Hire"
string icon = "images\off_services.ico"
st_red st_red
dw_off_services dw_off_services
st_blue st_blue
st_1 st_1
cb_new cb_new
cb_close cb_close
cb_delete cb_delete
cb_print cb_print
cb_modify cb_modify
cb_calc cb_calc
end type
global w_off_services w_off_services

type variables
datawindowchild 				dwc

n_offService 					inv_offService
end variables

forward prototypes
public subroutine wf_updatecontrol (string as_status)
public subroutine documentation ()
public function integer wf_getpaymentstatusdescription (long al_row, ref string as_status, ref long al_payment_id, ref datetime adt_cp_date, ref datetime adt_est_due_date, ref string as_suggestion, ref long al_contract_id)
end prototypes

public subroutine wf_updatecontrol (string as_status);/* This function enables/disables window controls
	as_status can have following values:
	
		windowOpen		= opened 
		vessel			= vessel selected
		new				= new contract
*/

CHOOSE CASE upper(as_status)
	CASE "WINDOWOPEN"
		/* Window buttons */
		cb_new.enabled = false
		cb_modify.enabled = false
		cb_close.enabled = true
		cb_delete.enabled = false
	CASE "VESSEL"
		/* Window buttons */
		cb_new.enabled = not (uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2)
		cb_modify.enabled = not (uo_global.ii_access_level = -1)
		cb_close.enabled = true
		cb_delete.enabled = cb_new.enabled
END CHOOSE
cb_print.enabled = dw_off_services.rowCount() > 0
end subroutine

public subroutine documentation ();/********************************************************************
   w_off_services
   <OBJECT></OBJECT>
   <USAGE></USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date       CR-Ref       		Author             	Comments
   	2012-06-14 M5-12            	RJH022       			fix a history bug when clicking Modify button without select any row
		23/09/2015 CR3133             SSX014               a great deal of changes
		09/12/2015 CR4213             SSX014
   </HISTORY>
********************************************************************/


end subroutine

public function integer wf_getpaymentstatusdescription (long al_row, ref string as_status, ref long al_payment_id, ref datetime adt_cp_date, ref datetime adt_est_due_date, ref string as_suggestion, ref long al_contract_id);return inv_offService.of_getpaymentstatusdescription(dw_off_services, al_row, as_status, al_payment_id, adt_cp_date, adt_est_due_date, as_suggestion, al_contract_id)

end function

event ue_retrieve;call super::ue_retrieve;long ll_row
ll_row = dw_off_services.Retrieve(ii_vessel_nr)	
IF ll_row > 0 THEN
	dw_off_services.SelectRow(0,FALSE)
	dw_off_services.ScrollToRow(ll_row)
END IF
wf_updateControl("vessel")

end event

event open;call super::open;this.Move(0,0)

inv_offService = CREATE n_offService 
dw_off_services.SetTransObject(SQLCA)

uo_vesselselect.of_registerwindow( w_off_services )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()
wf_updateControl("windowOpen")

dw_off_services.setrowfocusindicator(FOCUSRECT!)

cb_new.enabled = not (uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2)
cb_delete.enabled = cb_new.enabled
cb_modify.enabled = not (uo_global.ii_access_level = -1)

end event

on w_off_services.create
int iCurrent
call super::create
this.st_red=create st_red
this.dw_off_services=create dw_off_services
this.st_blue=create st_blue
this.st_1=create st_1
this.cb_new=create cb_new
this.cb_close=create cb_close
this.cb_delete=create cb_delete
this.cb_print=create cb_print
this.cb_modify=create cb_modify
this.cb_calc=create cb_calc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_red
this.Control[iCurrent+2]=this.dw_off_services
this.Control[iCurrent+3]=this.st_blue
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_new
this.Control[iCurrent+6]=this.cb_close
this.Control[iCurrent+7]=this.cb_delete
this.Control[iCurrent+8]=this.cb_print
this.Control[iCurrent+9]=this.cb_modify
this.Control[iCurrent+10]=this.cb_calc
end on

on w_off_services.destroy
call super::destroy
destroy(this.st_red)
destroy(this.dw_off_services)
destroy(this.st_blue)
destroy(this.st_1)
destroy(this.cb_new)
destroy(this.cb_close)
destroy(this.cb_delete)
destroy(this.cb_print)
destroy(this.cb_modify)
destroy(this.cb_calc)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(False)
end event

event close;call super::close;destroy inv_offService
end event

event ue_vesselselection;call super::ue_vesselselection;inv_offservice.of_setvessel( ii_vessel_nr )
postevent( "ue_retrieve" )
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_off_services
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_off_services
end type

type st_red from statictext within w_off_services
integer x = 1330
integer y = 88
integer width = 2898
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 80269524
string text = "When the Off-Hire is on a hire statement in status Final, Part Paid or Paid, it is shown in red and cannot be modified."
boolean focusrectangle = false
end type

type dw_off_services from uo_datawindow within w_off_services
event ue_keydown pbm_dwnkey
integer y = 224
integer width = 4617
integer height = 2148
integer taborder = 20
string dataobject = "d_off_services"
boolean vscrollbar = true
end type

event ue_keydown;if key = KeySpaceBar! then
	this.Event DoubleClicked(0,0, this.getRow(), this.object.voyage_nr)
	/* no special reason using voyage_nr. It could be any column name
	   not used for other things in DoubleClicked */
end if
end event

event clicked;//overwrite of ancestor script
If row > 0 Then
	SelectRow(0,False)
	SelectRow(row,True)
	if len(trim(this.getItemString(row, "voyage_nr"))) > 5 then
		cb_calc.enabled = false
	else
		cb_calc.enabled = true
	end if
End if


end event

event rowfocuschanged;//If currentrow > 0 Then
//	SelectRow(0,False)
//	SelectRow(currentrow,True)
//End if
//
//
end event

event doubleclicked;call super::doubleclicked;if row > 0 then
	IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
	END IF

//	if this.getItemNumber(row, "trans_to_coda") > 0 then return
		
	CHOOSE CASE dwo.name
		CASE "voyage_nr"  /* Column name used when triggered from ue_keydown */
			inv_offService.of_modifyRow(dw_off_services, row)
		CASE ELSE
			inv_offService.of_modifyRow(dw_off_services, row)
	END CHOOSE
end if
end event

type st_blue from statictext within w_off_services
integer x = 1330
integer y = 28
integer width = 1659
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 80269524
boolean enabled = false
string text = "Off-Hire shown in blue has been transferred to a TC Hire contract."
boolean focusrectangle = false
end type

type st_1 from statictext within w_off_services
integer x = 1330
integer y = 148
integer width = 1591
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean enabled = false
string text = "Off-Hire shown in black is not transferred to a TC Hire contract."
boolean focusrectangle = false
end type

type cb_new from commandbutton within w_off_services
integer x = 2450
integer y = 2400
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&New "
end type

event clicked;IF uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2 THEN 
	MessageBox("Infomation","You do not have access to this functionality.")
	Return
END IF

if inv_offService.of_insertRow(dw_off_services) = 1 then
	dw_off_services.POST setFocus()
end if
end event

type cb_close from commandbutton within w_off_services
integer x = 4274
integer y = 2400
integer width = 343
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

on clicked;Close(Parent)
end on

type cb_delete from commandbutton within w_off_services
integer x = 3182
integer y = 2400
integer width = 343
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;long ll_row, ll_payment_id
string ls_statusDescription, ls_suggestion
datetime ldt_cp_date, ldt_due_date
integer li_rc
long ll_contract_id

IF uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2 THEN 
	MessageBox("Infomation","You do not have access to this functionality.")
	Return
END IF

ll_row = dw_off_services.getSelectedRow(0)
if ll_row < 1 then return

li_rc = wf_getPaymentStatusDescription(ll_row, ls_statusDescription, ll_payment_id, ldt_cp_date, ldt_due_date, ls_suggestion, ll_contract_id)
if li_rc > 0 then
	MessageBox("Information", "You cannot delete the selected Off-Hire, because it is included in a hire statement in status " + ls_statusDescription + ".~r~n~r~n" + &
		"TC-Hire contract ID: " + string(ll_contract_id) + "~r~n" + &
		"C/P date: " + string(ldt_cp_date, "dd-mm-yy") + "~r~n" + &
		"Hire statement ID: " + string(ll_payment_id) + "~r~n" + &
		"Due date: " + string(ldt_due_date, "dd-mm-yy") + &
		"~r~n~r~n" + ls_suggestion)
	return
end if

If MessageBox("Confirm delete","Are you sure you want to delete the selected Off-Hire?", Exclamation!,YesNo!,2) = 2 THEN Return

if inv_offService.of_deleteRow(dw_off_services, ll_row) = 1 then
	wf_updateControl("vessel")
end if

dw_off_services.POST setFocus()

end event

type cb_print from commandbutton within w_off_services
integer x = 3913
integer y = 2400
integer width = 343
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print List"
end type

event clicked;datastore lds_off_services_print
lds_off_services_print = create datastore
lds_off_services_print.dataobject = "dw_off_services_print"
lds_off_services_print.settransobject(SQLCA)

dw_off_services.ShareData(lds_off_services_print)

lds_off_services_print.object.datawindow.print.orientation = 1
lds_off_services_print.print()

dw_off_services.ShareDataoff()
end event

type cb_modify from commandbutton within w_off_services
integer x = 2816
integer y = 2400
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Open"
end type

event clicked;long ll_row

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_off_services.getSelectedRow(0)
//Added by RJH022 on 2012-05-11. Change desc: modify history bug
if ll_row <= 0 then return
//if dw_off_services.getItemNumber(ll_row, "trans_to_coda") > 0 then 
//	MessageBox("Information", "You can't modify a settled Off-service")
//	return
//end if

if inv_offService.of_modifyRow(dw_off_services, ll_row) = 1 then
	dw_off_services.POST setFocus()
end if
end event

type cb_calc from commandbutton within w_off_services
integer x = 3547
integer y = 2400
integer width = 343
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Show C&alc."
end type

event clicked;long 	ll_row

ll_row = dw_off_services.getSelectedRow(0)

if ll_row < 1 then return

openwithparm(w_offservice_bunker_calculation, dw_off_services.getItemNumber(ll_row, "ops_off_service_id" ))
	
end event

