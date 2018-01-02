$PBExportHeader$w_actual_earnings.srw
$PBExportComments$This window lets the user enter actual earning information
forward
global type w_actual_earnings from w_vessel_basewindow
end type
type cb_cancel from commandbutton within w_actual_earnings
end type
type cb_new from commandbutton within w_actual_earnings
end type
type cb_close from commandbutton within w_actual_earnings
end type
type cb_update from commandbutton within w_actual_earnings
end type
type cb_delete from commandbutton within w_actual_earnings
end type
type st_year from statictext within w_actual_earnings
end type
type dw_actual_earnings from uo_datawindow within w_actual_earnings
end type
end forward

global type w_actual_earnings from w_vessel_basewindow
integer width = 4187
integer height = 2608
string title = "Actual Earnings"
cb_cancel cb_cancel
cb_new cb_new
cb_close cb_close
cb_update cb_update
cb_delete cb_delete
st_year st_year
dw_actual_earnings dw_actual_earnings
end type
global w_actual_earnings w_actual_earnings

type variables
datawindowchild dwc
//s_off_service lstr_idle_days
end variables

event ue_insert;call super::ue_insert;Long ll_rows

cb_cancel.Enabled = TRUE
cb_delete.Enabled = FALSE
cb_new.Enabled = FALSE
cb_new.default = false
cb_update.Default = TRUE
dw_actual_earnings.SelectRow(0,FALSE)
uo_vesselselect.Enabled = FALSE
dw_actual_earnings.InsertRow(0)
ll_rows = dw_actual_earnings.RowCount()
dw_actual_earnings.ScrolltoRow(ll_rows)
dw_actual_earnings.SetItem(ll_rows,"vessel_nr",ii_vessel_nr)
dw_actual_earnings.SetFocus()
dw_actual_earnings.SetColumn("startdate")
end event

event ue_delete;call super::ue_delete;Long ll_row

IF dw_actual_earnings.RowCount() < 1 THEN return
ll_row = dw_actual_earnings.GetRow()
IF ll_row < 1 THEN Return
IF dw_actual_earnings.DeleteRow(0) = 1 THEN
	IF dw_actual_earnings.Update() = 1 THEN
		Commit;
		cb_delete.Default = FALSE
		cb_new.Default = TRUE
		cb_new.SetFocus()
	ELSE
		RollBack;
	END IF
ELSE
	Rollback;
END IF

end event

event ue_update;call super::ue_update;IF dw_actual_earnings.Update() = 1 THEN
	Commit;
	dw_actual_earnings.ReSelectRow(dw_actual_earnings.RowCount())
	dw_actual_earnings.Enabled = TRUE
	uo_vesselselect.Enabled = TRUE
	cb_cancel.Enabled = FALSE
	cb_new.Enabled = TRUE
	cb_update.default = false
	cb_new.Default = TRUE
	cb_new.SetFocus()
	postevent( "ue_retrieve" )
ELSE
	Rollback;
END IF
end event

event ue_retrieve;call super::ue_retrieve;long ll_row, ll_minutes, ll_currentrow
Integer li_days, li_hours, li_minutes

dw_actual_earnings.Retrieve(ii_vessel_nr)	
ll_row = dw_actual_earnings.RowCount()
IF ll_row > 0 THEN

	for ll_currentrow = 1 to ll_row
		ll_minutes = f_timedifference( dw_actual_earnings.GetItemDateTime(ll_currentrow,"startdate") ,&
		dw_actual_earnings.GetItemDateTime(ll_currentrow,"enddate") )
		li_days = Int(ll_minutes/1440)
		li_hours = ( ll_minutes - ( li_days * 1440 ) ) / 60 
		li_minutes = ll_minutes - (li_days * 1440 ) - ( li_hours * 60 )
		dw_actual_earnings.SetItem(ll_currentrow,"nbr_of_days",li_days)
		dw_actual_earnings.SetItem(ll_currentrow,"nbr_of_hours",li_hours)
		dw_actual_earnings.SetItem(ll_currentrow,"nbr_of_minutes",li_minutes)
	next
	dw_actual_earnings.resetupdate()
	
	dw_actual_earnings.SelectRow(0,FALSE)
	dw_actual_earnings.SelectRow(ll_row,TRUE)
	dw_actual_earnings.ScrollToRow(ll_row)
	cb_delete.enabled = TRUE
	cb_new.Enabled = TRUE
	cb_new.Default = TRUE
ELSE
	cb_delete.enabled = FALSE
END IF


end event

event open;call super::open;this.Move(20,20)
dw_actual_earnings.SetTransObject(SQLCA)

uo_vesselselect.of_registerwindow( w_actual_earnings )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

if (uo_global.ib_rowsindicator) then
	dw_actual_earnings.setrowfocusindicator(FOCUSRECT!)
end if
end event

on w_actual_earnings.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_new=create cb_new
this.cb_close=create cb_close
this.cb_update=create cb_update
this.cb_delete=create cb_delete
this.st_year=create st_year
this.dw_actual_earnings=create dw_actual_earnings
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_new
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.st_year
this.Control[iCurrent+7]=this.dw_actual_earnings
end on

on w_actual_earnings.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_new)
destroy(this.cb_close)
destroy(this.cb_update)
destroy(this.cb_delete)
destroy(this.st_year)
destroy(this.dw_actual_earnings)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(False)
end event

event ue_vesselselection;call super::ue_vesselselection;dw_actual_earnings.accepttext()
if dw_actual_earnings.modifiedcount( ) + dw_actual_earnings.deletedcount( ) > 0 then
	if MessageBox("Data not saved!", "TC Contract data modified, but not saved~n~r~n~r" &
					 +"Would you like to update before switching", Question!, YesNo!, 1) = 1 then
		dw_actual_earnings.POST setFocus()
		return 
	end if
end if
postevent( "ue_retrieve" )
end event

event closequery;call super::closequery;if dw_actual_earnings.modifiedcount( ) + dw_actual_earnings.deletedcount( ) > 0 then
	if MessageBox("Data not saved!", "Actual Earnings data modified, but not saved~n~r~n~r" &
					 +"Would you like to update before switching", Question!, YesNo!, 1) = 1 then
		dw_actual_earnings.POST setFocus()
		return 1 //prevent window from closing
	else
		return 0 //allow window to close
	end if
end if
	
end event

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_actual_earnings
end type

type cb_cancel from commandbutton within w_actual_earnings
integer x = 2295
integer y = 2380
integer width = 343
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "C&ancel"
boolean cancel = true
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

cb_new.Enabled = TRUE
cb_cancel.Enabled = FALSE
dw_actual_earnings.Enabled = TRUE
dw_actual_earnings.DeleteRow(dw_actual_earnings.RowCount())
uo_vesselselect.Enabled = TRUE
cb_new.Default = TRUE
cb_new.SetFocus()


end event

type cb_new from commandbutton within w_actual_earnings
integer x = 3045
integer y = 2380
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
boolean default = true
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

parent.TriggerEvent("ue_insert")
end event

type cb_close from commandbutton within w_actual_earnings
integer x = 3794
integer y = 2380
integer width = 343
integer height = 100
integer taborder = 40
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

type cb_update from commandbutton within w_actual_earnings
integer x = 3419
integer y = 2380
integer width = 343
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Update"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

parent.TriggerEvent("ue_update")

end event

type cb_delete from commandbutton within w_actual_earnings
integer x = 2670
integer y = 2380
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

If MessageBox("Delete Message","You are about to DELETE an Actual Earnings.~r~n~r~nAre you sure?",Question!,YesNo!,2) = 2 THEN Return
parent.TriggerEvent("ue_delete")
end event

type st_year from statictext within w_actual_earnings
integer x = 1001
integer y = 1792
integer width = 96
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "  "
boolean focusrectangle = false
end type

type dw_actual_earnings from uo_datawindow within w_actual_earnings
integer x = 18
integer y = 232
integer width = 4110
integer height = 2124
integer taborder = 70
string dataobject = "d_actual_earnings"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;

IF row > 0 THEN
	cb_delete.Enabled = NOT cb_cancel.Enabled 	
	this.SelectRow(0,FALSE)
	this.SelectRow(row, TRUE)
END IF


end event

event itemchanged;call super::itemchanged;//Long ll_minutes
//Integer li_days, li_hours, li_minutes
//
//CHOOSE CASE dw_idle_days.GetColumnName()
//	CASE "idle_start", "idle_end"
//		AcceptText()
//		ll_minutes = f_timedifference( dw_idle_days.GetItemDateTime(dw_idle_days.Rowcount(),"idle_start") ,&
//								dw_idle_days.GetItemDateTime(dw_idle_days.Rowcount(),"idle_end") )
//		li_days = Int(ll_minutes/1440)
//		li_hours = ( ll_minutes - ( li_days * 1440 ) ) / 60 
//		li_minutes = ll_minutes - (li_days * 1440 ) - ( li_hours * 60 )
//		dw_idle_days.SetItem(dw_idle_days.Rowcount(),"idle_time_days",li_days)
//		dw_idle_days.SetItem(dw_idle_days.Rowcount(),"idle_time_hours",li_hours)
//		dw_idle_days.SetItem(dw_idle_days.Rowcount(),"idle_time_minutes",li_minutes)
//END CHOOSE
//

Long 			ll_minutes
Integer 		li_days, li_hours, li_minutes
decimal {4}	ld_start, ld_end

//CHOOSE CASE this.GetColumnName()
CHOOSE CASE dwo.name
	CASE "startdate", "enddate"
		this.AcceptText()
		ll_minutes = f_timedifference( this.GetItemDateTime(row,"startdate") ,&
								this.GetItemDateTime(row,"enddate") )
		li_days = Int(ll_minutes/1440)
		li_hours = ( ll_minutes - ( li_days * 1440 ) ) / 60 
		li_minutes = ll_minutes - (li_days * 1440 ) - ( li_hours * 60 )
		this.SetItem(row,"nbr_of_days",li_days)
		this.SetItem(row,"nbr_of_hours",li_hours)
		this.SetItem(row,"nbr_of_minutes",li_minutes)
END CHOOSE

end event

