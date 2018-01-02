$PBExportHeader$w_voyage_alerts.srw
forward
global type w_voyage_alerts from w_syswin_master
end type
end forward

global type w_voyage_alerts from w_syswin_master
integer width = 4608
integer height = 2568
string title = "Voyage Alerts"
boolean minbox = true
long backcolor = 32304364
boolean center = false
end type
global w_voyage_alerts w_voyage_alerts

type variables

n_messagebox inv_messagebox
end variables

forward prototypes
public function integer wf_validate (u_datagrid adw_master, n_dw_validation_service anv_validation)
public function boolean wf_get_port_active (string as_port_code)
end prototypes

public function integer wf_validate (u_datagrid adw_master, n_dw_validation_service anv_validation);/********************************************************************
   wf_validate
   <DESC>	Datawindow validation	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_master
		anv_validation
   </ARGS>
   <USAGE> ref: cb_updadte.event clicked()	</USAGE>
   <HISTORY>
		Date     CR-Ref   Author   Comments
		30/05/14		CR4144		CCY018		UX standards
   </HISTORY>
********************************************************************/

integer li_dwbuf
long ll_row, ll_rowcount, ll_country_id
string  ls_message, ls_port_code, ls_name, ls_desc, ls_port_name
date ldate_start, ldate_end

dw_1.setredraw(false)

//delete new! row from filter!
for ll_row = dw_1.filteredcount() to 1 step -1
	if dw_1.getitemstatus(ll_row, 0, filter!) = new! then
		dw_1.rowsdiscard( ll_row, ll_row, filter!)
	end if
next

uo_search.cb_clear.event clicked( )

ll_row = 0
ll_rowcount = dw_1.rowcount()

do while ll_row <= ll_rowcount
	ll_row = dw_1.getnextmodified(ll_row, Primary!)

	if ll_row > 0 then
		ll_country_id = dw_1.getitemnumber(ll_row, "country_id")
		ls_port_code = dw_1.getitemstring(ll_row, "port_code")
		ldate_start = dw_1.getitemdate(ll_row, "start_date")
		ldate_end = dw_1.getitemdate(ll_row, "end_date")
		ls_name = dw_1.getitemstring(ll_row, "alert_name")
		ls_desc = dw_1.getitemstring(ll_row, "alert_desc")
		
		if isnull(ls_port_code) then ls_port_code = ""
		if not isnull(ldate_start) then ldate_start = date(2000, month(ldate_start), day(ldate_start))
		if not isnull(ldate_end) then ldate_end = date(2000, month(ldate_end), day(ldate_end))
		if isnull(ls_name) then ls_name = ""
		if isnull(ls_desc) then ls_desc = ""
		
		if isnull(ll_country_id) and trim(ls_port_code, true) = "" then
			dw_1.setfocus()
			dw_1.setrow(ll_row)
			dw_1.scrolltorow(ll_row)
			dw_1.setcolumn("country_id")
			dw_1.setredraw(true)
			inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must select a Country or a Port.", this)
			return C#Return.Failure
		end if
		
		if trim(ls_port_code, true) <> "" then
			if not wf_get_port_active(ls_port_code) then
				ls_port_name = dw_1.getitemstring(ll_row, "ports_port_n")
				dw_1.setfocus()
				dw_1.setrow(ll_row)
				dw_1.scrolltorow(ll_row)
				dw_1.setcolumn("port_code")
				dw_1.setredraw(true)
				inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You cannot enter " + ls_port_name + " because it is inactive.", this)
				return C#Return.Failure
			end if
		end if
		
		if (isnull(ldate_start) and not isnull(ldate_end)) or (not isnull(ldate_start) and isnull(ldate_end)) then
			dw_1.setfocus()
			dw_1.setrow(ll_row)
			dw_1.scrolltorow(ll_row)
			if isnull(ldate_start) then
				dw_1.setcolumn("start_date")
			else
				dw_1.setcolumn("end_date")
			end if
			dw_1.setredraw(true)
			inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must enter both Start Date and End Date, or no dates at all if the voyage alert is applicable all year.", this)
			return C#Return.Failure
		end if
		
		if ldate_start > ldate_end then
			dw_1.setfocus()
			dw_1.setrow(ll_row)
			dw_1.scrolltorow(ll_row)
			dw_1.setcolumn("start_date")
			dw_1.setredraw(true)
			inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must enter a Start Date which is before the End Date.", this)
			return C#Return.Failure
		end if
		
		if trim(ls_name, true) = "" then
			dw_1.setfocus()
			dw_1.setrow(ll_row)
			dw_1.scrolltorow(ll_row)
			dw_1.setcolumn("alert_name")
			dw_1.setredraw(true)
			inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must enter a Name.", this)
			return C#Return.Failure
		end if
		
		if trim(ls_desc, true) = "" then
			dw_1.setfocus()
			dw_1.setrow(ll_row)
			dw_1.scrolltorow(ll_row)
			dw_1.setcolumn("alert_desc")
			dw_1.setredraw(true)
			inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must enter a Description.", this)
			return C#Return.Failure
		end if
	else	
		ll_row = ll_rowcount + 1
	end if
loop

dw_1.setredraw(true)

return c#return.Success
end function

public function boolean wf_get_port_active (string as_port_code);/********************************************************************
   wf_get_port_active
   <DESC>get port active status</DESC>
   <RETURN>	boolean	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_port_code
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21/03/17		CR4414		CCY018		First Version
   </HISTORY>
********************************************************************/

integer li_active

SELECT PORT_ACTIVE INTO :li_active
FROM PORTS
WHERE PORT_CODE = :as_port_code;

if li_active = 1 then
	return true
else
	return false
end if
end function

on w_voyage_alerts.create
int iCurrent
call super::create
end on

on w_voyage_alerts.destroy
call super::destroy
end on

event open;call super::open;string ls_filter, ls_mandatorycol[]
n_dw_style_service   lnv_style

this.move(0, 0)

ls_mandatorycol[1] = "alert_name"
ls_mandatorycol[2] = "alert_desc"

wf_format_datawindow(dw_1, ls_mandatorycol)
dw_1.of_setallcolumnsresizable(true)
inv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_autoadjustdddwwidth(dw_1, "country_id")
lnv_style.of_autoadjustdddwwidth(dw_1, "port_code")
dw_1.of_set_dddwspecs(true)
dw_1.inv_dddwsearch.of_register("country_id", "country_name")
dw_1.inv_dddwsearch.of_register("port_code", "port_n")

ls_filter = "lookupdisplay(country_id)+'#'+lookupdisplay(port_code)+'#'+ string(day(start_date), '00') + '-' + string(month(start_date), '00')+'#' + &
			 string(day(end_date), '00')+'-' + string(month(end_date), '00')+'#'+alert_name+'#'+alert_desc"

uo_search.of_initialize(dw_1, ls_filter)
uo_search.sle_search.post setfocus()

if uo_global.ii_access_level = c#usergroup.#SUPERUSER and (uo_global.ii_user_profile = c#profile.CHARTERER or uo_global.ii_user_profile = c#profile.OPERATOR) then
	cb_new.enabled = true
	cb_delete.enabled = (dw_1.rowcount() > 0)
else
	cb_new.enabled = false
	cb_delete.enabled = false
	cb_update.enabled = false
	cb_cancel.enabled = false
	dw_1.object.datawindow.readonly = "Yes"
end if
end event

event closequery;integer li_rtn

ib_showmessage = false
dw_1.accepttext()
if dw_1.modifiedcount() + dw_1.deletedcount() > 0 then
	li_rtn = inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_UNSAVED_DATA, this)
	if li_rtn = 1 then
		if cb_update.event clicked() = C#Return.Failure then
			return 1
		end if
	end if
	
	if li_rtn = 3 then return 1
end if

if isvalid(inv_validation) then
	destroy inv_validation
end if

return 0
end event

event ue_delete;
long ll_row
long ll_rc
DWItemStatus le_rowstatus

dw_1.setredraw(false)
ll_row = dw_1.getrow()
if ll_row > 0 then
	le_rowstatus = dw_1.getitemstatus( ll_row, 0, primary!)
	if le_rowstatus = New! or le_rowstatus = NewModified! then
		dw_1.deleterow(ll_row)
	else
		if ib_confirmdeletion or ib_update_after_del then
			ll_rc = inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_CONFIRM_DELETE, "the selected Voyage Alert", this)
		else
			ll_rc = 1
		end if
		
		if ll_rc = 1 then
			if ib_update_after_del then
				if wf_delete_row( ll_row) = c#return.Success then
					dw_1.rowsdiscard( ll_row, ll_row, primary!)
				else
					messagebox("Error", "Delete failed.", StopSign!)
					dw_1.setredraw(true)
					return c#return.Failure
				end if
			else
				dw_1.deleterow(ll_row)
			end if
		else
			dw_1.setredraw(true)
			return c#return.Failure
		end if
	end if
end if

if ll_row > dw_1.rowcount( ) then ll_row = dw_1.rowcount( )
if ll_row > 0 then
	dw_1.scrolltorow(ll_row)
	dw_1.selectrow(ll_row, true)
end if

dw_1.setredraw(true)
return C#Return.Success
end event

event ue_postupdate;call super::ue_postupdate;long ll_row, ll_rowid

cb_cancel.enabled = false

//scroll to pre row
dw_1.setredraw(false)
ll_row = dw_1.getrow()
if ll_row > 0 then
	ll_rowid = dw_1.getrowidfromrow(ll_row)
end if

dw_1.sort( )

if ll_rowid > 0 then
	ll_row = dw_1.getrowfromrowid(ll_rowid)
	if ll_row > 0 then
		dw_1.setrow(ll_row)
		dw_1.scrolltorow(ll_row)
	end if
end if

dw_1.setredraw(true)

return C#Return.Success
end event

event ue_postadd;call super::ue_postadd;cb_cancel.enabled = true

dw_1.post setcolumn("country_id")

return C#Return.Success
end event

event ue_update;/********************************************************************
   ue_update
   <DESC>	Update the changed object.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author	Comments
	22/17/17		CR4414		CCY018		UX standards
   </HISTORY>
********************************************************************/

if dw_1.update() = 1 then
	commit;
	return C#Return.Success
else
	rollback;
	return C#Return.Failure
end if

end event

event ue_postdelete;call super::ue_postdelete;long ll_modifycount, ll_delcount

ll_modifycount = dw_1.modifiedcount()
ll_delcount = dw_1.deletedcount()

cb_update.enabled = (ll_modifycount + ll_delcount > 0)
cb_cancel.enabled = (ll_modifycount + ll_delcount > 0)

return C#Return.Success
end event

event close;call super::close;dw_1.of_set_dddwspecs(false)
end event

type st_hidemenubar from w_syswin_master`st_hidemenubar within w_voyage_alerts
end type

type cb_cancel from w_syswin_master`cb_cancel within w_voyage_alerts
integer x = 4219
integer y = 2376
integer taborder = 60
boolean enabled = false
end type

event cb_cancel::clicked;long ll_row, ll_rowcount

ll_row = dw_1.getrow()

dw_1.setredraw(false)
ll_rowcount = dw_1.retrieve()
if ll_row > ll_rowcount or ll_row = 0 then ll_row = ll_rowcount

if ll_row > 0 and ll_rowcount > 0 then
	dw_1.setfocus()
	dw_1.setrow(ll_row)
	dw_1.scrolltorow(ll_row)
	dw_1.setcolumn("country_id")
end if

dw_1.setredraw(true)

cb_update.enabled = false
cb_delete.enabled = (ll_rowcount > 0)
this.enabled = false

end event

type cb_refresh from w_syswin_master`cb_refresh within w_voyage_alerts
integer taborder = 70
end type

type cb_delete from w_syswin_master`cb_delete within w_voyage_alerts
integer x = 3872
integer y = 2376
integer taborder = 50
end type

type cb_update from w_syswin_master`cb_update within w_voyage_alerts
integer x = 3525
integer y = 2376
integer taborder = 40
boolean default = false
end type

type cb_new from w_syswin_master`cb_new within w_voyage_alerts
integer x = 3177
integer y = 2376
integer taborder = 30
end type

type dw_1 from w_syswin_master`dw_1 within w_voyage_alerts
event ue_refreshdddw ( )
event ue_enterkey pbm_dwnprocessenter
integer width = 4526
integer height = 2120
integer taborder = 20
string dataobject = "d_sq_gr_voyage_alerts"
boolean hscrollbar = true
boolean ib_setselectrow = true
end type

event dw_1::ue_refreshdddw();/********************************************************************
   ue_refreshdddw
   <DESC>	Description	</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21/03/17		CR4414		CCY018        First Version
   </HISTORY>
********************************************************************/

long ll_row
string ls_filter, ls_port_code
datawindowchild	ldwc_child

ll_row = this.getrow()
if ll_row < 1 then return

if this.getchild("port_code", ldwc_child) = 1 then
	ls_port_code = this.getitemstring(ll_row, "port_code")
	if isnull(ls_port_code) then ls_port_code = ""
	if trim(ls_port_code, true) = "" then
		ls_filter = "port_active = 1"
	else
		ls_filter = "(port_active = 1 or port_code = '" + ls_port_code + "')"
	end if
	
	ldwc_child.setfilter(ls_filter)
	ldwc_child.filter()
end if




end event

event dw_1::editchanged;call super::editchanged;string ls_month, ls_day, ls_colname
date ldate_date

choose case dwo.name
	case "start_date", "end_date"
		ls_colname = dwo.name
		if not isnull(data) then
			ls_day = left(data, 2)
			ls_month = right(data, 2)
			if ls_day <> '00' and ls_month <> '00' then
				ldate_date = date(2000, integer(ls_month), integer(ls_day))
				this.setitem(row, ls_colname, ldate_date)
			end if
		end if
end choose

cb_cancel.enabled = true
end event

event dw_1::itemerror;call super::itemerror;if dwo.name = "country_id" then this.selecttext(1, 0)

return 3
end event

event dw_1::constructor;call super::constructor;this.modify("port_code_1.width = '0~tlong(describe(~"port_code.width~"))' port_code_1.x = '0~tlong(describe(~"port_code.x~"))'")
this.modify("datawindow.processing = '0' port_code_1.visible = '0~tif(currentRow() = getrow() , 0, 1)' datawindow.processing = '1'")

end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;this.event ue_refreshdddw( )
end event

event dw_1::clicked;long ll_row

if row = 0 then
	this.setredraw(false)
	super::event clicked(xpos, ypos, row, dwo)
	this.setredraw(true)
else
	ll_row = this.getrow()
	
	if ll_row <> row then
		this.setrow(row)
		this.scrolltorow(row)
	end if
end if

end event

event dw_1::itemchanged;long ll_country_id
string ls_country_name, ls_port_name

if row < 1 then return
if this.of_itemchanged() = c#return.failure then return 2

if dwo.name = "country_id" then
	ll_country_id = long(data)
	SELECT COUNTRY_NAME INTO :ls_country_name
	FROM COUNTRY
	WHERE COUNTRY_ID = :ll_country_id;
	
	this.setitem(row, "country_country_name", ls_country_name)
	this.setitemstatus(row, "country_country_name", primary!, notmodified!)
elseif dwo.name = "port_code" then
	SELECT PORT_N INTO :ls_port_name
	FROM PORTS
	WHERE PORT_CODE = :data;
	
	this.setitem(row, "ports_port_n", ls_port_name)
	this.setitemstatus(row, "ports_port_n", primary!, notmodified!)
end if

cb_update.Enabled = true
cb_cancel.enabled = true
end event

event dw_1::ue_dwkeypress;call super::ue_dwkeypress;
long ll_prerow, ll_currow, ll_nextrow
string ls_cur_portcode, ls_next_portcode, ls_colname, ls_display_name

if dw_1.object.datawindow.readonly = "Yes" then return

//tab order
if key <> KeyTab! then return

ll_currow = this.getrow()
ll_prerow = ll_currow - 1
ll_nextrow = ll_currow + 1

if ll_currow < 1 then return

ls_colname = this.getcolumnname()
ls_cur_portcode = this.getitemstring(ll_currow, "port_code")
if ll_nextrow <= this.rowcount() then ls_next_portcode = this.getitemstring(ll_nextrow, "port_code")

this.setredraw( false)

if keyflags = 1 then
	if ll_currow > 1 then
		if (ls_colname = "port_code" and not isnull(ls_cur_portcode)) or ls_colname = "country_id" then
			this.post setrow(ll_prerow)
			this.post scrolltorow(ll_prerow)
			this.post setcolumn("alert_desc")
		end if
	end if
else
	if ll_currow < this.rowcount() then
		if ls_colname = "alert_desc" then
			this.post setrow(ll_nextrow)
			this.post scrolltorow(ll_nextrow)
			
			if not isnull(ls_next_portcode) then
				this.post setcolumn("port_code")
			else
				this.post setcolumn("country_id")
			end if
		end if
	end if
end if

this.post setredraw(true)
end event

event dw_1::getfocus;call super::getfocus;
this.settaborder("country_id", 10)
this.settaborder("port_code", 20)

if keydown(KeyTab!) then
	this.setcolumn("country_id")
end if


end event

event dw_1::losefocus;call super::losefocus;integer li_col
string ls_colarr[]

ls_colarr[1] = "country_id"
ls_colarr[2] = "port_code"

for li_col = 1 to upperbound(ls_colarr)
	if this.getcolumnname() <> ls_colarr[li_col] then
		this.settaborder(ls_colarr[li_col], 0)
	end if
next
end event

event dw_1::dberror;
string	ls_userfriendlymessage, err_type

choose case sqldbcode
	case -3 
		ls_userfriendlymessage="The record has been modified by another application or user since your last retrieval. Update failed. Please refresh to get the latest data."
		ib_updatecontinue = true
	case 229
		ls_userfriendlymessage="You do not have access to this Functionality!"
	case 233
		ls_userfriendlymessage="Please populate the mandatory fields before updating!"
	case 546
		ls_userfriendlymessage="You are using a value that does not exist in the system! This is probably a drop down list box you have written a wrong value/string in!"
	case 547
		ls_userfriendlymessage="There is a constraint stopping the system completing this task"
	case 2601
		ls_userfriendlymessage="Can not make change as the record is a duplicate"
	case 30006
		ls_userfriendlymessage="Dependent data exists on what you are deleting! This operation cannot be performed. For example, you maybe deleting a system type that is used elsewhere in the system"			
	case else
		ls_userfriendlymessage=string(sqldbcode) + ":Something unexpected has occured.  sqlerrtext:" + sqlerrtext
end choose

inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_GENERAL_ERROR, ls_userfriendlymessage, parent)
if buffer = primary! then
	this.setrow(row)
	this.scrolltorow(row)
end if
	
return 3

end event

type uo_search from w_syswin_master`uo_search within w_voyage_alerts
integer taborder = 10
boolean ib_scrolltocurrentrow = true
end type

event uo_search::ue_keypress;call super::ue_keypress;if dw_1.getselectedrow(0) = 0 and dw_1.rowcount() > 0 then
	if dw_1.getrow() = 1 then
		dw_1.event rowfocuschanged(1)
	else
		dw_1.setrow(1)
	end if
end if

if dw_1.object.datawindow.readonly <> "yes" then
	cb_delete.enabled = (dw_1.rowcount() > 0)
end if
end event

event uo_search::ue_prekeypress;call super::ue_prekeypress;if key = keyenter! then return c#return.failure
return c#return.Success
end event

event uo_search::clearclicked;call super::clearclicked;if dw_1.object.datawindow.readonly <> "yes" then
	cb_delete.enabled = (dw_1.rowcount() > 0)
end if
end event

type st_background from w_syswin_master`st_background within w_voyage_alerts
end type

