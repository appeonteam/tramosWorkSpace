$PBExportHeader$w_idle_days.srw
$PBExportComments$This window lets the user enter idle days information
forward
global type w_idle_days from w_vessel_basewindow
end type
type cb_cancel from mt_u_commandbutton within w_idle_days
end type
type cb_new from mt_u_commandbutton within w_idle_days
end type
type cb_close from mt_u_commandbutton within w_idle_days
end type
type cb_update from mt_u_commandbutton within w_idle_days
end type
type cb_delete from mt_u_commandbutton within w_idle_days
end type
type dw_idle_days from uo_datawindow within w_idle_days
end type
end forward

global type w_idle_days from w_vessel_basewindow
integer width = 4187
integer height = 2608
string title = "Idle Days"
string icon = "images\idle_days.ico"
cb_cancel cb_cancel
cb_new cb_new
cb_close cb_close
cb_update cb_update
cb_delete cb_delete
dw_idle_days dw_idle_days
end type
global w_idle_days w_idle_days

type variables
datawindowchild dwc
s_off_service lstr_idle_days
end variables

forward prototypes
public subroutine documentation ()
public function integer wf_isvalidrow ()
public function integer wf_updatespending ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_idle_days
   <OBJECT>		Idle Days	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
		Date      		CR-Ref		Author		Comments
		16/08/2013		CR2961		ZSW001		When changing the dates, the days/hours/minutes should re-calculate, 
		                                        just as they do in the Offservice module
		26/09/2013		CR3331		LHG008		Removed the st_year control
		30/06/2014		CR3535		KSH092		The update function should work for all of the screen (dates, times, totals, calculations etc.)
		                                        whether the cursor focus is moved from where the change has been made or not. 
		20/07/2015		CR3995		SSX014		Added validations on Update
		27/07/15  		CR3226		XSZ004		Change label for Bunkers type.
		29/02/16  		CR3099		XSZ004		Added validations for idle days start and end dates. 
   </HISTORY>
********************************************************************/

end subroutine

public function integer wf_isvalidrow ();/********************************************************************
   wf_isvalidrow
   <DESC> </DESC>
   <RETURN>	(none)  </RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date    		CR-Ref		Author		Comments
		29/02/16  	CR3099		XSZ004		Added validations for idle days start and end dates. 	      
   </HISTORY>
********************************************************************/

int li_ret

u_check_functions lnv_check
n_service_manager lnv_svcmgr
n_dw_validation_service lnv_transrules

if dw_idle_days.AcceptText() <> 1 then return c#return.Failure

lnv_svcmgr.of_loadservice( lnv_transrules, "n_dw_validation_service")


// register all columns requiring validation -
lnv_transrules.of_registerruledatetime( "idle_start", true, "idle_end", "<=", "Start date", "End date")
lnv_transrules.of_registerruledecimal( "fuel_oil_used", false, 0.0, 9999.99, "HSFO")
lnv_transrules.of_registerruledecimal( "diesel_oil_used", false, 0.0, 9999.99, "LSGO")
lnv_transrules.of_registerruledecimal( "gas_oil_used", false, 0.0, 9999.99, "HSGO")
lnv_transrules.of_registerruledecimal( "lshfo_oil_used", false, 0.0, 9999.99, "LSFO")
lnv_transrules.of_registerruledecimal( "idle_time_days", false, 0.0, 9999.99, "Days")
lnv_transrules.of_registerruledecimal( "idle_time_hours", false, 0.0, 9999.99, "Hours")
lnv_transrules.of_registerruledecimal( "idle_time_minutes", false, 0.0, 9999.99, "Minutes")

if lnv_transrules.of_validate( dw_idle_days, true) <> c#return.success then
	return c#return.failure
end if

lnv_check = create u_check_functions

li_ret = lnv_check.of_check_idledays(ii_vessel_nr, "", dw_idle_days, 1)

destroy lnv_check

return li_ret
end function

public function integer wf_updatespending ();/********************************************************************
   wf_updatespending
   <DESC> </DESC>
   <RETURN>	(none)  </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		29/02/16		CR3099		XSZ004		First version.	      
   </HISTORY>
********************************************************************/

string  ls_msg
integer li_ret

dw_idle_days.accepttext()

if dw_idle_days.modifiedcount( ) + dw_idle_days.deletedcount( ) > 0 then
	
	ls_msg = "You have modified Idle Days.~r~n~nWould you like to save before continuing?"
	li_ret = messagebox("Data not saved", ls_msg, Exclamation!, YesNoCancel!, 1)
	
	if li_ret = 1 then
		
		li_ret = cb_update.event clicked()
		
		if li_ret = c#return.failure then
			li_ret = c#return.PreventAction
		else
			li_ret = c#return.ContinueAction
		end if
		
	elseif li_ret = 2 then
		cb_cancel.event clicked()	
		li_ret = c#return.ContinueAction
	elseif li_ret = 3 then
		li_ret = c#return.PreventAction
	end if
else
	li_ret = c#return.ContinueAction
end if
	
return li_ret
end function

event ue_insert;call super::ue_insert;Long ll_rows

lstr_idle_days.vessel_nr = ii_vessel_nr
OpenWithParm( w_select_voyage_and_port_code , lstr_idle_days )
lstr_idle_days = Message.PowerObjectParm
IF IsNull( lstr_idle_days.voyage_nr ) THEN Return
cb_cancel.Enabled = TRUE
cb_delete.Enabled = FALSE
cb_new.Enabled = FALSE
cb_new.default = false
cb_update.Default = TRUE
dw_idle_days.SelectRow(0,FALSE)
uo_vesselselect.Enabled = FALSE
dw_idle_days.InsertRow(0)
ll_rows = dw_idle_days.RowCount()
dw_idle_days.SetItem( ll_rows , "voyage_nr" , lstr_idle_days.voyage_nr )
dw_idle_days.SetItem( ll_rows , "port_code" , lstr_idle_days.port_code )
dw_idle_days.ScrolltoRow(ll_rows)
dw_idle_days.SetItem(ll_rows,"vessel_nr",ii_vessel_nr)
dw_idle_days.SetFocus()
dw_idle_days.SetColumn("idle_start")
end event

on ue_delete;call w_vessel_basewindow::ue_delete;Long ll_row

IF dw_idle_days.RowCount() < 1 THEN return
ll_row = dw_idle_days.GetRow()
IF ll_row < 1 THEN Return
IF dw_idle_days.DeleteRow(0) = 1 THEN
	IF dw_idle_days.Update() = 1 THEN
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

end on

event ue_update;call super::ue_update;int li_ret

li_ret = wf_isvalidrow()

if li_ret = c#return.Success then

	IF dw_idle_days.Update() = 1 THEN
		Commit;
		dw_idle_days.ReSelectRow(dw_idle_days.RowCount())
		dw_idle_days.Enabled = TRUE
		uo_vesselselect.Enabled = TRUE
		cb_cancel.Enabled = FALSE
		cb_new.Enabled = TRUE
		cb_update.default = false
		cb_new.Default = TRUE
		cb_new.SetFocus()
	ELSE
		Rollback;
	END IF
end if

return li_ret

end event

event ue_retrieve;call super::ue_retrieve;long ll_row
dw_idle_days.Retrieve(ii_vessel_nr)	
ll_row = dw_idle_days.RowCount()
IF ll_row > 0 THEN
	dw_idle_days.SelectRow(0,FALSE)
	dw_idle_days.SelectRow(ll_row,TRUE)
	dw_idle_days.ScrollToRow(ll_row)
	cb_delete.enabled = TRUE
//	cb_new.Enabled = TRUE
//	cb_new.Default = TRUE
ELSE
	cb_delete.enabled = FALSE
END IF


end event

event open;call super::open;this.Move(20,20)
dw_idle_days.SetTransObject(SQLCA)

uo_vesselselect.of_registerwindow( w_idle_days )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

if (uo_global.ib_rowsindicator) then
	dw_idle_days.setrowfocusindicator(FOCUSRECT!)
end if
end event

on w_idle_days.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_new=create cb_new
this.cb_close=create cb_close
this.cb_update=create cb_update
this.cb_delete=create cb_delete
this.dw_idle_days=create dw_idle_days
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_new
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.dw_idle_days
end on

on w_idle_days.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_new)
destroy(this.cb_close)
destroy(this.cb_update)
destroy(this.cb_delete)
destroy(this.dw_idle_days)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(False)
end event

event ue_vesselselection;if wf_updatespending() <> c#return.ContinueAction then
	uo_vesselselect.of_setPreviousVessel( )
	dw_idle_days.POST setFocus()
else
	ii_vessel_nr = ai_vessel
	postevent( "ue_retrieve" )
end if
end event

event closequery;call super::closequery;int li_ret

li_ret = wf_updatespending()

return li_ret
	
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_idle_days
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_idle_days
end type

type cb_cancel from mt_u_commandbutton within w_idle_days
integer x = 2295
integer y = 2380
integer taborder = 10
boolean bringtotop = true
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
dw_idle_days.Enabled = TRUE
dw_idle_days.DeleteRow(dw_idle_days.RowCount())
uo_vesselselect.Enabled = TRUE
cb_new.Default = TRUE
cb_new.SetFocus()


end event

type cb_new from mt_u_commandbutton within w_idle_days
integer x = 3045
integer y = 2380
integer taborder = 30
boolean bringtotop = true
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

type cb_close from mt_u_commandbutton within w_idle_days
integer x = 3794
integer y = 2380
integer taborder = 40
boolean bringtotop = true
string facename = "Arial"
string text = "&Close"
end type

event clicked;
Close(Parent)
end event

type cb_update from mt_u_commandbutton within w_idle_days
integer x = 3419
integer y = 2380
integer taborder = 50
boolean bringtotop = true
string facename = "Arial"
string text = "&Update"
end type

event clicked;int li_ret

if dw_idle_days.rowcount() < 1 then return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

li_ret = parent.event ue_update(1, 1)

return li_ret

end event

type cb_delete from mt_u_commandbutton within w_idle_days
integer x = 2670
integer y = 2380
integer taborder = 20
boolean bringtotop = true
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

If MessageBox("Delete Message","You are about to DELETE an Idle Specification.~r~n~r~nAre you sure?",Question!,YesNo!,2) = 2 THEN Return
parent.TriggerEvent("ue_delete")
end event

type dw_idle_days from uo_datawindow within w_idle_days
event ue_itemchanged ( long row,  dwobject dwo,  string data )
integer x = 18
integer y = 232
integer width = 4110
integer height = 2124
integer taborder = 70
string dataobject = "dw_idle_days"
boolean vscrollbar = true
end type

event ue_itemchanged(long row, dwobject dwo, string data);long ll_days, ll_hours, ll_minutes
datetime	ldt_start, ldt_end

if row <= 0 then return

choose case dwo.name
	case "idle_start", "idle_end"
		
		if dwo.name = 'idle_start' then
			
			ldt_start = datetime(data)	
		else
		   ldt_start = this.getitemdatetime(row, "idle_start")
		end if
		
		if dwo.name = 'idle_end' then
			
			ldt_end = datetime(data)		
		else
		   ldt_end   = this.getitemdatetime(row, "idle_end")
		end if
		
		ll_minutes = f_timedifference(ldt_start, ldt_end)
		
		if ll_minutes > 0 then 		
			ll_days = ll_minutes / 1440
			ll_minutes = mod(ll_minutes, 1440)
			ll_hours = ll_minutes / 60
			ll_minutes = mod(ll_minutes, 60)
		else
			ll_minutes = 0
		end if
		
		this.setitem(row, "idle_time_days", ll_days)
		this.setitem(row, "idle_time_hours", ll_hours)
		this.setitem(row, "idle_time_minutes", ll_minutes)
end choose

end event

event clicked;call super::clicked;IF row > 0 THEN
	cb_delete.Enabled = NOT cb_cancel.Enabled 	
	this.SelectRow(0,FALSE)
	this.SelectRow(row, TRUE)
END IF
end event

event itemchanged;call super::itemchanged;this. event ue_itemchanged(row, dwo, data)

end event

event itemfocuschanged;call super::itemfocuschanged;choose case dwo.name
	case "idle_time_days", "idle_time_hours", "idle_time_minutes"
		SelectText(1, Len(GetText()))
end choose

end event

