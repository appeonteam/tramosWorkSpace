$PBExportHeader$w_claims_retrieval.srw
forward
global type w_claims_retrieval from mt_w_sheet
end type
type dw_date from u_datagrid within w_claims_retrieval
end type
type dw_claims_retrieval from u_datagrid within w_claims_retrieval
end type
type cb_saveas from mt_u_commandbutton within w_claims_retrieval
end type
type dw_vessellist from u_datagrid within w_claims_retrieval
end type
type cbx_selectallvessel from mt_u_checkbox within w_claims_retrieval
end type
type cb_retrieve from mt_u_commandbutton within w_claims_retrieval
end type
type cbx_claimtype from mt_u_checkbox within w_claims_retrieval
end type
type dw_claimtype from u_datagrid within w_claims_retrieval
end type
type cbx_selectall_profitcenter from mt_u_checkbox within w_claims_retrieval
end type
type dw_profit_center from u_datagrid within w_claims_retrieval
end type
type gb_profitcenter from mt_u_groupbox within w_claims_retrieval
end type
type gb_claimtype from mt_u_groupbox within w_claims_retrieval
end type
type gb_vessel from mt_u_groupbox within w_claims_retrieval
end type
type st_banner from u_topbar_background within w_claims_retrieval
end type
type dw_export from u_datagrid within w_claims_retrieval
end type
end forward

global type w_claims_retrieval from mt_w_sheet
integer width = 4599
integer height = 2560
string title = "Claims Retrieval"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean center = false
boolean ib_setdefaultbackgroundcolor = true
event type long ue_retrieve ( )
dw_date dw_date
dw_claims_retrieval dw_claims_retrieval
cb_saveas cb_saveas
dw_vessellist dw_vessellist
cbx_selectallvessel cbx_selectallvessel
cb_retrieve cb_retrieve
cbx_claimtype cbx_claimtype
dw_claimtype dw_claimtype
cbx_selectall_profitcenter cbx_selectall_profitcenter
dw_profit_center dw_profit_center
gb_profitcenter gb_profitcenter
gb_claimtype gb_claimtype
gb_vessel gb_vessel
st_banner st_banner
dw_export dw_export
end type
global w_claims_retrieval w_claims_retrieval

type variables
private:
string is_fixedsortcolumns[]
boolean ib_fixedsort[]
string is_sortablecolumns[]
string is_sortcolumns[]
boolean ib_sort[]

// Original site information
long il_row
string is_vessel_ref_nr
string is_voyage_nr
long il_claim_nr
long il_chart_nr
datetime idt_date
string is_subtype
dec id_amount_usd
end variables

forward prototypes
public function long wf_selectall (u_datagrid adw_filter, checkbox acbx_selectall)
public subroutine documentation ()
public function integer of_preservesite ()
public function integer of_restoresite ()
end prototypes

event type long ue_retrieve();/********************************************************************
   ue_retrieve
   <DESC>	retrieve report data	</DESC>
   <RETURN>	long:
            <LI> the number of rows retrieved
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
       None
   </ARGS>
   <USAGE>	Event.ue_retrieve()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		02/07/14 CR3426        SSX014   First Version
   </HISTORY>
********************************************************************/

constant string METHODNAME = "cb_retreive.click()"
constant string MESSAGETYPE = "User warning."
string ls_selclaimtype
string ls_selprofitcenter
string ls_selvessel
datetime ldt_start
datetime ldt_end
boolean lb_autocommit
long ll_rc, ll_row

if dw_claimtype.of_getnumberofselectedrows () <= 0 then
	_addmessage(this.classdefinition ,METHODNAME, "Please select at least one claim type.", MESSAGETYPE)
	return c#return.Failure
end if

if dw_profit_center.of_getnumberofselectedrows () <= 0 then
	_addmessage(this.classdefinition , METHODNAME, "Please select at least one profit center.", MESSAGETYPE)
	return c#return.Failure
end if

if dw_vessellist.of_getnumberofselectedrows () <= 0 then
	_addmessage(this.classdefinition, METHODNAME, "Please select at least one vessel.", MESSAGETYPE)
	return c#return.Failure
end if

dw_claimtype.of_get_selectedvalues("claim_type", ls_selclaimtype, ",")
dw_profit_center.of_get_selectedvalues("pc_nr", ls_selprofitcenter, ",")
dw_vessellist.of_get_selectedvalues("vessel_nr", ls_selvessel, ",")

dw_date.AcceptText()

ldt_start = dw_date.GetItemDatetime(1,"start_dt")
ldt_end = dw_date.GetItemDatetime(1,"end_dt")

if IsNull(ldt_start) then
	_addmessage(this.classdefinition , METHODNAME, "Start date cannot be NULL.", MESSAGETYPE)
	return c#return.Failure
end if

if IsNull(ldt_end) then
	_addmessage(this.classdefinition , METHODNAME, "End date cannot be NULL.", MESSAGETYPE)
	return c#return.Failure
end if

if Len(ls_selvessel) > 5120 then
	_addmessage(this.classdefinition , METHODNAME, "Too many vessels are selected, please unselect some of them and try again.", MESSAGETYPE)
	return c#return.Failure	
end if

dw_claims_retrieval.setredraw(false)
of_preservesite()

// AutoCommit property must be set to True before retrieval
lb_autocommit = SQLCA.autocommit
SQLCA.autocommit = true
ll_rc = dw_claims_retrieval.retrieve(ls_selprofitcenter, ls_selclaimtype, ldt_start, ldt_end, ls_selvessel )
SQLCA.autocommit = lb_autocommit

of_restoresite()
dw_claims_retrieval.setredraw(true)

return ll_rc

end event

public function long wf_selectall (u_datagrid adw_filter, checkbox acbx_selectall);/********************************************************************
   wf_selectall
   <DESC>	Change select all checkbox text and 
				filter change request report	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_filter: Filter datawindow
		acbx_selectall: checkbox for select all
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date             CR-Ref       Author             Comments
   	2014/06/10   CR3426      SSX014           First Version
   </HISTORY>
********************************************************************/

if acbx_selectall.checked then	
	acbx_selectall.text = "Deselect all"
else
	acbx_selectall.text = "Select all"
end if

acbx_selectall.textcolor = c#color.White

// Change the filter selection status
adw_filter.selectrow(0, acbx_selectall.checked)

return 1
end function

public subroutine documentation ();/******************************************************
   w_claims_retrieval
   <OBJECT>An object of claims retrieval report</OBJECT>
   <USAGE></USAGE>
   <ALSO></ALSO>
   <HISTORY>
      Date       CR-Ref    Author       Comments
      10/06/14   CR3426    SSX014       Initial version
   </HISTORY>
******************************************************/


end subroutine

public function integer of_preservesite ();/********************************************************************
   of_preservesite
   <DESC>	Temporarily save the original site information	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	of_PreserveSite()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		10/07/14 CR3426        SSX014   First Version
   </HISTORY>
********************************************************************/

il_row = dw_claims_retrieval.getrow()
if il_row > 0 then
	is_vessel_ref_nr = dw_claims_retrieval.getitemstring(il_row, "vessel_ref_nr")
	is_voyage_nr = dw_claims_retrieval.getitemstring(il_row, "voyage_nr")
	il_claim_nr = dw_claims_retrieval.getitemnumber(il_row, "claim_nr")
	il_chart_nr = dw_claims_retrieval.getitemnumber(il_row, "chart_nr")
	idt_date = dw_claims_retrieval.getitemdatetime(il_row, "date_val")
	is_subtype = dw_claims_retrieval.getitemstring(il_row, "claim_subtype")
	id_amount_usd = dw_claims_retrieval.getitemdecimal(il_row, "amount_usd")
end if

return 1

end function

public function integer of_restoresite ();/********************************************************************
   of_restoresite
   <DESC>	Restore site	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	of_RestoreSite	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		10/07/14 CR3426        SSX014   First Version
   </HISTORY>
********************************************************************/

string ls_expr
long ll_found, ll_row

if il_row > 0 then
	ls_expr = "vessel_ref_nr = '" + is_vessel_ref_nr + "' and voyage_nr = '" + is_voyage_nr + "' and " + &
		"claim_nr = " + string(il_claim_nr) + " and chart_nr = " + string(il_chart_nr) + " and date_val = datetime('" + &
		string(idt_date,"yyyy/mm/dd hh:mm:ss.ffffff") + "') and claim_subtype='" + is_subtype + "' and amount_usd = " + &
		string(id_amount_usd)
	ll_found = dw_claims_retrieval.find(ls_expr, 1, dw_claims_retrieval.rowcount())
	if ll_found > 0 then
		dw_claims_retrieval.setrow(ll_found)
		dw_claims_retrieval.scrolltorow(ll_found)
		dw_claims_retrieval.selectrow(0,false)
		dw_claims_retrieval.selectrow(ll_found, true)
	end if
else
	// Highlight the current row
	ll_row = dw_claims_retrieval.getrow()
	if ll_row > 0 then
		dw_claims_retrieval.SelectRow(0,false)
		dw_claims_retrieval.SelectRow(ll_row,true)
	end if
end if

return 1

end function

on w_claims_retrieval.create
int iCurrent
call super::create
this.dw_date=create dw_date
this.dw_claims_retrieval=create dw_claims_retrieval
this.cb_saveas=create cb_saveas
this.dw_vessellist=create dw_vessellist
this.cbx_selectallvessel=create cbx_selectallvessel
this.cb_retrieve=create cb_retrieve
this.cbx_claimtype=create cbx_claimtype
this.dw_claimtype=create dw_claimtype
this.cbx_selectall_profitcenter=create cbx_selectall_profitcenter
this.dw_profit_center=create dw_profit_center
this.gb_profitcenter=create gb_profitcenter
this.gb_claimtype=create gb_claimtype
this.gb_vessel=create gb_vessel
this.st_banner=create st_banner
this.dw_export=create dw_export
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_date
this.Control[iCurrent+2]=this.dw_claims_retrieval
this.Control[iCurrent+3]=this.cb_saveas
this.Control[iCurrent+4]=this.dw_vessellist
this.Control[iCurrent+5]=this.cbx_selectallvessel
this.Control[iCurrent+6]=this.cb_retrieve
this.Control[iCurrent+7]=this.cbx_claimtype
this.Control[iCurrent+8]=this.dw_claimtype
this.Control[iCurrent+9]=this.cbx_selectall_profitcenter
this.Control[iCurrent+10]=this.dw_profit_center
this.Control[iCurrent+11]=this.gb_profitcenter
this.Control[iCurrent+12]=this.gb_claimtype
this.Control[iCurrent+13]=this.gb_vessel
this.Control[iCurrent+14]=this.st_banner
this.Control[iCurrent+15]=this.dw_export
end on

on w_claims_retrieval.destroy
call super::destroy
destroy(this.dw_date)
destroy(this.dw_claims_retrieval)
destroy(this.cb_saveas)
destroy(this.dw_vessellist)
destroy(this.cbx_selectallvessel)
destroy(this.cb_retrieve)
destroy(this.cbx_claimtype)
destroy(this.dw_claimtype)
destroy(this.cbx_selectall_profitcenter)
destroy(this.dw_profit_center)
destroy(this.gb_profitcenter)
destroy(this.gb_claimtype)
destroy(this.gb_vessel)
destroy(this.st_banner)
destroy(this.dw_export)
end on

event activate;call super::activate;If w_tramos_main.MenuName <> "m_tramosmain" Then
	w_tramos_main.ChangeMenu(m_tramosmain)
End if

end event

event open;call super::open;datetime ldt_start
datetime ldt_end
n_dw_style_service   lnv_style
n_service_manager   lnv_servicemgr

// Set today as default value for both start and end
ldt_start = datetime(today(),time("00:00:00"))
ldt_end = ldt_start
dw_date.setitem(1,"start_dt", ldt_start)
dw_date.setitem(1,"end_dt", ldt_end)

// Select all for default selection
wf_selectall(dw_claimtype, cbx_claimtype)

dw_claims_retrieval.SetTransObject(SQLCA)

lnv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_claims_retrieval, false)

// Initialize sort columns
is_sortablecolumns = {"vessel_ref_nr", "vessel_name", "pc_name", "voyage_nr", &
                  "cp_date", "chart_sn", "ccs_chgp_name", "broker_name", &
                  "office_name", "claim_nr", "claim_type", "curr_code"}

// Set mandatory column color
dw_date.Modify("start_dt.background.color="+string(c#color.MT_MAERSK))
dw_date.Modify("end_dt.background.color="+string(c#color.MT_MAERSK))

end event

event ue_addignoredcolorandobject;call super::ue_addignoredcolorandobject;anv_guistyle.of_addignoredobject(cbx_selectall_profitcenter)
anv_guistyle.of_addignoredobject(cbx_selectallvessel)
anv_guistyle.of_addignoredobject(gb_vessel)
anv_guistyle.of_addignoredobject(cbx_claimtype)

end event

type dw_date from u_datagrid within w_claims_retrieval
integer x = 3145
integer y = 32
integer width = 549
integer height = 256
integer taborder = 40
string dataobject = "d_start_end_date"
boolean border = false
end type

event constructor;this.InsertRow(0)
end event

type dw_claims_retrieval from u_datagrid within w_claims_retrieval
integer x = 37
integer y = 624
integer width = 4517
integer height = 1724
integer taborder = 50
string dataobject = "d_claims_retrieval"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean ib_columntitlesort = true
boolean ib_multicolumnsort = false
boolean ib_sortbygroup = false
string is_sortprefix = "_t"
end type

event clicked;/********************************************************************
   clicked
   <DESC>	sort	</DESC>
   <RETURN>	long:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		xpos: integer
		ypos: integer
		row : long
		dwo : dwobject
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		02/07/14 CR3346        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_i, ll_j
long ll_cnt, ll_cnt2
string ls_column
long ll_fixed
string ls_tmpcolumns[], ls_tmpfixedcolumns[], ls_empty[]
boolean lb_tmpsort[], lb_tmpfixedsort[], lb_empty[]
string ls_criteria
boolean lb_controldown

if row > 0 then
	// Highlight the current row
	this.setrow(row)
	this.SelectRow(0,false)
	this.SelectRow(row,true)
	return
end if

/*
The user is clicking the column header
*/

// Determine if Ctrl is being pressed
lb_controldown = KeyDown(KeyControl!)

// Determine if the column is sortable
ls_column = ""
ll_cnt = upperbound(is_sortablecolumns[])
for ll_i = 1 to ll_cnt
	if dwo.name = is_sortablecolumns[ ll_i ] + "_t" then
		ls_column = is_sortablecolumns[ ll_i ] 
		exit
	end if
next

// If the column is not sortable then exit the event
if ll_i > ll_cnt then return

// Determine if the column is a fixed sort column
ll_cnt = upperbound(is_fixedsortcolumns[])
ll_fixed = 0
for ll_i = 1 to ll_cnt
	if ls_column = is_fixedsortcolumns[ll_i] then
		ll_fixed = ll_i
		exit
	end if
next

if lb_controldown then
	// Muti-sorting
	ll_cnt = upperbound(is_sortcolumns[])
	for ll_i = 1 to ll_cnt
		if ls_column = is_sortcolumns[ll_i] then
			ib_sort[ll_i] = not ib_sort[ll_i]
			exit
		end if
	next
	
	ls_tmpcolumns[] = is_sortcolumns[]
	lb_tmpsort[] = ib_sort[]
	
	if ll_i <= ll_cnt then
		lb_tmpsort[ll_i] = ib_sort[ll_i]
	else
		ls_tmpcolumns[ll_i] = ls_column
		lb_tmpsort[ll_i] = false
	end if
	
	if ll_fixed > 0 then
		ib_fixedsort[ll_fixed] = lb_tmpsort[ll_i]
	end if
	// Add the fixed sort columns
	ll_cnt = upperbound(is_sortcolumns[])
	for ll_i = 1 to ll_cnt
		ll_cnt2 = upperbound( is_fixedsortcolumns[] )
		for ll_j = 1 to ll_cnt2
			if is_sortcolumns[ll_i] = is_fixedsortcolumns[ll_j] then
				ls_tmpfixedcolumns[upperbound(ls_tmpfixedcolumns) + 1] = is_fixedsortcolumns[ll_j]
				lb_tmpfixedsort[upperbound(lb_tmpfixedsort) + 1] = ib_fixedsort[ll_j]
			end if
		next
	next
else
	// Single-sorting
	ls_tmpcolumns[1] = ls_column
	if upperbound(is_sortcolumns[]) > 0 then
		if is_sortcolumns[1] = ls_column then
			lb_tmpsort[1] = not ib_sort[1]
		else
			lb_tmpsort[1] = false
		end if
	else
		lb_tmpsort[1] = false
	end if
	if ll_fixed > 0 then
		ib_fixedsort[ll_fixed] = lb_tmpsort[1]
		ls_tmpfixedcolumns[1] = ls_column
		lb_tmpfixedsort[1] = lb_tmpsort[1]
	end if
	// Add the fixed sort columns
	ll_cnt = upperbound(is_sortcolumns[])
	for ll_i = 1 to ll_cnt
		if is_sortcolumns[ll_i] <> ls_column then
			ll_cnt2 = upperbound( is_fixedsortcolumns[] )
			for ll_j = 1 to ll_cnt2
				if is_sortcolumns[ll_i] = is_fixedsortcolumns[ll_j] then
					ls_tmpcolumns[upperbound(ls_tmpcolumns[]) + 1] = is_fixedsortcolumns[ll_j]
					lb_tmpsort[upperbound(lb_tmpsort[]) + 1] = ib_fixedsort[ll_j]
					ls_tmpfixedcolumns[upperbound(ls_tmpfixedcolumns) + 1] = is_fixedsortcolumns[ll_j]
					lb_tmpfixedsort[upperbound(lb_tmpfixedsort) + 1] = ib_fixedsort[ll_j]
				end if
			next
		end if
	next
end if

// Build the sort criteria expression
ls_criteria = ""

// Add the normal sort columns
ll_cnt = upperbound(ls_tmpcolumns[])
for ll_i = 1 to ll_cnt
	ls_criteria += ls_tmpcolumns[ll_i]
	if lb_tmpsort[ll_i] then
		ls_criteria += " D"
	else
		ls_criteria += " A"
	end if
	ls_criteria += ","
next

/*
Add the rest fixed sort columns to make sure
that the balance is shown correctly
*/
ll_cnt = upperbound(is_fixedsortcolumns)
for ll_i = 1 to ll_cnt
	ll_cnt2 = upperbound(ls_tmpcolumns[])
	for ll_j = 1 to ll_cnt2
		if ls_tmpcolumns[ll_j] = is_fixedsortcolumns[ll_i] then
			exit
		end if
	next
	// if it is a fixed sort column
	if ll_j > ll_cnt2 then
		ls_tmpfixedcolumns[upperbound(ls_tmpfixedcolumns) + 1] = is_fixedsortcolumns[ll_i]
		lb_tmpfixedsort[upperbound(lb_tmpfixedsort) + 1] = ib_fixedsort[ll_i]
		ls_criteria += is_fixedsortcolumns[ll_i]
		if ib_fixedsort[ll_i] then
			ls_criteria += " D"
		else
			ls_criteria += " A"
		end if
		ls_criteria += ","
	end if
next

ls_criteria += "SEQ A"

if lb_controldown then
	is_sortcolumns[] = ls_tmpcolumns[]
	ib_sort = lb_tmpsort[]
else
	is_sortcolumns[] = ls_empty[]
	ib_sort[] = lb_empty[]
	
	is_sortcolumns[1] = ls_tmpcolumns[1]
	ib_sort[1] = lb_tmpsort[1]
end if

is_fixedsortcolumns = ls_tmpfixedcolumns
ib_fixedsort = lb_tmpfixedsort

this.SetSort(ls_criteria)
this.Sort()


end event

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

type cb_saveas from mt_u_commandbutton within w_claims_retrieval
integer x = 4224
integer y = 2356
integer height = 92
integer taborder = 70
string text = "&Save As..."
end type

event clicked;long ll_rowcount

dw_export.dataobject = dw_claims_retrieval.dataobject
dw_export.reset()

ll_rowcount = dw_claims_retrieval.rowcount()
if ll_rowcount > 0 then
	dw_claims_retrieval.rowscopy(1,ll_rowcount,primary!,dw_export,1,primary!)
end if

dw_export.modify("destroy column CHART_NR")
dw_export.modify("destroy column SEQ")

dw_export.saveas("", Excel8!, true)

end event

type dw_vessellist from u_datagrid within w_claims_retrieval
event type long ue_refresh ( )
integer x = 1024
integer y = 80
integer width = 1134
integer height = 448
string dataobject = "d_sq_tb_vessel_for_claimsretrieval"
boolean vscrollbar = true
boolean border = false
end type

event type long ue_refresh();
long ll_profitcenter[]
long ll_row, ll_count =  0
long ll_retrieved

//Get all selected profit center(s)
for ll_row = 1 to dw_profit_center.rowCount()
	if dw_profit_center.isselected(ll_row) then
		ll_count ++
		ll_profitcenter[ll_count] = dw_profit_center.getItemNumber(ll_row, "pc_nr")
	end if
next

//retrieve vessel list
if ll_count > 0 then
	ll_retrieved = this.retrieve(ll_profitcenter)
else
	this.reset()
	ll_retrieved = 0
end if

//reset select all
cbx_selectallvessel.text = "Select all"
cbx_selectallvessel.checked = false

return ll_retrieved

end event

event clicked;if row > 0 then
	this.selectrow(row, not this.isSelected(row))
end if


end event

type cbx_selectallvessel from mt_u_checkbox within w_claims_retrieval
integer x = 1829
integer y = 16
integer width = 334
integer height = 56
integer taborder = 20
integer textsize = -8
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;if this.checked then
	dw_vessellist.selectRow(0, TRUE)
	this.text = "Deselect all"
	this.textcolor = c#color.WHITE
else
	dw_vessellist.selectRow(0, FALSE)
	this.text = "Select all"
	this.textcolor = c#color.WHITE
end if

end event

type cb_retrieve from mt_u_commandbutton within w_claims_retrieval
integer x = 3877
integer y = 2356
integer height = 92
integer taborder = 60
string text = "&Retrieve"
end type

event clicked;Parent.Event ue_retrieve()
end event

type cbx_claimtype from mt_u_checkbox within w_claims_retrieval
integer x = 2798
integer y = 16
integer width = 329
integer height = 56
integer taborder = 30
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Deselect all"
boolean checked = true
end type

event clicked;call super::clicked;parent.wf_selectall(dw_claimtype, this)

end event

type dw_claimtype from u_datagrid within w_claims_retrieval
integer x = 2252
integer y = 80
integer width = 855
integer height = 448
string dataobject = "d_claim_types_selectable"
boolean vscrollbar = true
boolean border = false
end type

event constructor;call super::constructor;this.Retrieve()
end event

event clicked;call super::clicked;
if (row > 0) then
	this.SelectRow(row, not this.IsSelected(row) )
end if



end event

type cbx_selectall_profitcenter from mt_u_checkbox within w_claims_retrieval
integer x = 613
integer y = 16
integer width = 329
integer height = 56
integer taborder = 10
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;call super::clicked;parent.wf_selectall(dw_profit_center, this)
dw_vessellist.Event ue_refresh()
end event

type dw_profit_center from u_datagrid within w_claims_retrieval
integer x = 69
integer y = 80
integer width = 855
integer height = 448
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
end type

event constructor;call super::constructor;this.retrieve(uo_global.is_userid)
end event

event clicked;call super::clicked;if (row > 0) then
	this.SelectRow(row, not this.IsSelected(row) )
end if

dw_vessellist.Event ue_refresh()
end event

type gb_profitcenter from mt_u_groupbox within w_claims_retrieval
integer x = 32
integer y = 16
integer width = 933
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Profit Center(s)"
end type

type gb_claimtype from mt_u_groupbox within w_claims_retrieval
integer x = 2216
integer y = 16
integer width = 923
integer height = 544
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Claim Type(s)"
end type

type gb_vessel from mt_u_groupbox within w_claims_retrieval
integer x = 987
integer y = 16
integer width = 1207
integer height = 544
integer weight = 400
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Vessel(s)"
end type

type st_banner from u_topbar_background within w_claims_retrieval
integer width = 4590
integer height = 592
integer textsize = -10
end type

type dw_export from u_datagrid within w_claims_retrieval
boolean visible = false
integer x = 3456
integer y = 1808
end type

