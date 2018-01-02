$PBExportHeader$w_chartererlist.srw
forward
global type w_chartererlist from w_coredata_ancestor
end type
type cb_refresh_group_list from commandbutton within tabpage_1
end type
type st_notice from statictext within w_chartererlist
end type
type st_2 from u_topbar_background within w_chartererlist
end type
end forward

global type w_chartererlist from w_coredata_ancestor
integer width = 4608
integer height = 2600
string title = "Charterers"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
st_notice st_notice
st_2 st_2
end type
global w_chartererlist w_chartererlist

type variables

long il_charterer_nr

CONSTANT STRING is_NEW     = "NEW"
CONSTANT STRING is_UPDATE  = "UPDATE"
CONSTANT STRING is_CANCEL  = "CANCEL"
CONSTANT STRING is_INITIAL = "INITIAL"
end variables

forward prototypes
public function integer wf_validate ()
private function integer uf_updatespending ()
public function integer wf_update ()
public subroutine wf_settaborder ()
public subroutine wf_control_access_right ()
public subroutine wf_enabled_button (string as_status)
end prototypes

public function integer wf_validate ();return 0
end function

private function integer uf_updatespending ();
tab_1.tabpage_1.dw_1.acceptText()

If tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount() > 0 then
	If MessageBox("Updates Pending", "Data modified but not saved.~r~nWould you like to update changes?",Question!,YesNo!,1)=1 then
		return -1
	Else
		tab_1.tabpage_1.dw_1.reset()		
		return 0
	End if
End if

Return 0
end function

public function integer wf_update ();return 0

end function

public subroutine wf_settaborder ();// Set tabs so that normal users can only modify alt address

tab_1.tabpage_1.dw_1.settaborder("chart_nr",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_sn",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_n_1",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_n_2",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_a_1",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_a_2",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_a_3",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_a_4",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_c",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_att",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_ph",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_tx",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_tx_ab",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_tfx",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_nom_acc_nr",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_chart_custsupp",0)	
tab_1.tabpage_1.dw_1.settaborder("ccs_chgp_pk",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_chart_last_tx",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_chart_email",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_chart_homepage",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_vat_nr",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_apl_vat_rate",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_active",0)

end subroutine

public subroutine wf_control_access_right ();/********************************************************************
   wf_control_access_right
   <DESC>	All users only read column in Group Charterer Identity & Address Details, but Finance/any Group Access.
	         All users only read column in Group contact Information, but Finance and Chartering/any Group Access</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Suggest to use in the open event	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	07/12/2012 CR2877       WWA048             First Version
   </HISTORY>
********************************************************************/

string	ls_tag
long		ll_column, ll_count

ll_count = long(tab_1.tabpage_1.dw_1.describe("datawindow.column.count"))

if uo_global.ii_user_profile = 1 then  //Profile is Charterer
	for ll_column = 1 to ll_count
		ls_tag = tab_1.tabpage_1.dw_1.describe("#" + string(ll_column) + ".tag")
		if ls_tag = 'F' then
			tab_1.tabpage_1.dw_1.modify("#" + string(ll_column) + ".protect = 1")
			tab_1.tabpage_1.dw_1.modify("#" + string(ll_column) + ".background.mode = '1'")
			tab_1.tabpage_1.dw_1.modify("#" + string(ll_column) + ".background.color = '" + string(c#color.Transparent) + "'")
		end if
	next
elseif uo_global.ii_user_profile <> 3 then  //Profile is Operater, Developer, Support, Charterer
	for ll_column = 1 to ll_count
		ls_tag = tab_1.tabpage_1.dw_1.describe("#" + string(ll_column) + ".tag")
		if ls_tag = 'F' or ls_tag = 'FC' then
			tab_1.tabpage_1.dw_1.modify("#" + string(ll_column) + ".protect = 1")
			tab_1.tabpage_1.dw_1.modify("#" + string(ll_column) + ".background.mode = '1'")
			tab_1.tabpage_1.dw_1.modify("#" + string(ll_column) + ".background.color = '" + string(c#color.Transparent) + "'")
		end if
	next
end if

end subroutine

public subroutine wf_enabled_button (string as_status);/********************************************************************
   wf_enabled_button
   <DESC>	Enabled or disabled button	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_status
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	18/06/2013 CR2877       WWA048				 First Version
   </HISTORY>
********************************************************************/

choose case as_status
	case is_INITIAL
		if uo_global.ii_user_profile = 1 then  //Charterer
			cb_update.enabled = true
			cb_cancel.enabled = false
			cb_new.enabled = false
			cb_delete.enabled = false
		elseif uo_global.ii_user_profile = 2 then  //Operator
			cb_cancel.enabled = false
			cb_update.enabled = false
			cb_new.enabled = false
			cb_delete.enabled = false
		else		         //3  Finance, 4  Developer, 5  Support
			cb_cancel.enabled = true
			cb_update.enabled = true
			cb_new.enabled = true
			cb_delete.enabled = true
		end if
		
		//only finance superuser can update to unblock vendor info
		if tab_1.tabpage_1.dw_1.getitemnumber(1, "chart_blocked") = 1 then
			if uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 then
				cb_update.enabled = true
			else
				cb_update.enabled = false
			end if 
		end if
	case is_NEW
		cb_new.enabled = false
		cb_delete.enabled = false
	case is_UPDATE, is_CANCEL
		if uo_global.ii_user_profile = 3 then
			cb_new.enabled = true
			cb_update.enabled = true
			cb_delete.enabled = true
		elseif uo_global.ii_user_profile = 1 then
			cb_update.enabled = true
		end if
end choose

end subroutine

on w_chartererlist.create
int iCurrent
call super::create
this.st_notice=create st_notice
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_notice
this.Control[iCurrent+2]=this.st_2
end on

on w_chartererlist.destroy
call super::destroy
destroy(this.st_notice)
destroy(this.st_2)
end on

event open;call super::open;// Init datawindows
dw_list.settransobject(sqlca)
tab_1.tabpage_1.dw_1.settransobject(sqlca)
dw_list.retrieve()
il_charterer_nr = message.doubleparm
if isnull(il_charterer_nr) then il_charterer_nr = 0

// Sort and select
long ll_found
dw_list.setsort("chart_sn")
dw_list.sort( )

if il_charterer_nr = 0 then
	ll_found = 1
else
	ll_found = dw_list.find("chart_nr = " + string(il_charterer_nr), 0, dw_list.rowcount())
	if ll_found <= 0 then ll_found = 1
end if

dw_list.event clicked(0, 0, ll_found, dw_list.object)
dw_list.scrolltorow(ll_found)

//Initialize search box
uo_searchbox.of_initialize(dw_List, "chart_sn+'~'+chart_n_1")
uo_searchbox.sle_search.post setfocus()

wf_enabled_button(is_INITIAL)

uo_searchbox.st_search.text = 'Search'
uo_searchbox.sle_search.y = uo_searchbox.sle_search.y +14
uo_searchbox.sle_search.height = 56
uo_searchbox.cb_clear.x = uo_searchbox.cb_clear.x + 4
uo_searchbox.cb_clear.y = uo_searchbox.sle_search.y - 10
uo_searchbox.cb_clear.height = 70

uo_searchbox.sle_search.border = false
uo_searchbox.backcolor = c#color.mt_listheader_bg
uo_searchbox.st_search.backcolor = c#color.mt_listheader_bg
uo_searchbox.st_search.textcolor = c#color.mt_listheader_text

n_service_manager 	 lnv_servicemgr
n_dw_style_service 	 lnv_style

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")

lnv_style.of_dwlistformater(dw_list, false)

//Change read/write and read-only access rights
wf_control_access_right()

if ib_setdefaultbackgroundcolor then _setbackgroundcolor()

end event

event closequery;call super::closequery;
If uf_updatespending() = 0 Then Return 0

If cb_update.event clicked() = -1 Then Return 1 Else Return 0
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_chartererlist
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_chartererlist
integer y = 16
integer width = 1207
end type

type st_1 from w_coredata_ancestor`st_1 within w_chartererlist
boolean visible = false
integer x = 946
integer y = 212
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_chartererlist
boolean visible = false
integer x = 1134
integer y = 188
integer width = 219
end type

type dw_list from w_coredata_ancestor`dw_list within w_chartererlist
integer y = 240
integer width = 1257
integer height = 2124
string dataobject = "dw_charterer_list"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_list::clicked;call super::clicked;// Call ancestor Clicked event to perform sorting
// Super::Event Clicked(xpos, ypos, row, dwo)

If row < 1 then return

If uf_updatespending() = -1 then 
	cb_Update.Event Clicked()
	Return
End If

setPointer(hourGlass!)

dw_list.selectrow(0, false)
dw_list.selectrow(row, true)

il_charterer_nr = this.getitemnumber(row, "chart_nr")

//Retrieve tabpages
tab_1.tabpage_1.dw_1.retrieve(il_charterer_nr)

//set datawindow read-only when blocked, only finance superuser can unblock
if tab_1.tabpage_1.dw_1.getitemnumber(1, "chart_blocked") = 1 then
	if uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 then
		tab_1.tabpage_1.dw_1.settaborder("chart_blocked",600)
	else
		tab_1.tabpage_1.dw_1.object.datawindow.readonly='yes'
	end if
else
	if cb_new.enabled then
		tab_1.tabpage_1.dw_1.settaborder("chart_blocked", 0)
	end if
	
	tab_1.tabpage_1.dw_1.object.datawindow.readonly='no'
	
	if uo_global.ii_user_profile <> 3 then
		tab_1.tabpage_1.dw_1.settaborder("chart_active", 0)
	end if
end if

wf_enabled_button(is_INITIAL)

setpointer(arrow!)
end event

type cb_close from w_coredata_ancestor`cb_close within w_chartererlist
boolean visible = false
integer x = 4169
integer y = 2180
integer width = 343
integer height = 100
end type

event cb_close::clicked;call super::clicked;
Close(Parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_chartererlist
integer x = 4238
integer y = 2380
integer width = 343
integer height = 100
end type

event cb_cancel::clicked;call super::clicked;// Triggers the Clickedevent of dw_list
tab_1.tabpage_1.dw_1.reset()

dw_list.event clicked(0,0,dw_list.getrow(),dw_list.object)

wf_enabled_button(is_CANCEL)

end event

type cb_delete from w_coredata_ancestor`cb_delete within w_chartererlist
integer x = 3890
integer y = 2380
integer width = 343
integer height = 100
end type

event cb_delete::clicked;call super::clicked;long ll_row

ll_row = dw_list.getselectedrow(0)

if ll_row <> 0 then
	If messagebox("Delete","You are about to DELETE the charterer!~r~nAre you sure you want to continue?",Question!,YesNo!,2) = 2 Then Return
	dw_list.deleterow(ll_row)
	if dw_list.update() = 1 then
		commit;
	else
		rollback;
	end if
	if dw_list.retrieve() > 0 then 
		if ll_row > dw_list.rowcount() then ll_row = dw_list.rowcount()
		dw_list.selectrow(ll_row, true)
		dw_list.event clicked(0, 0, ll_row, dw_list.object)
		dw_list.scrolltorow(ll_row)
	else
		tab_1.tabpage_1.dw_1.reset( )
	end if			
end if

wf_enabled_button(is_UPDATE)

end event

type cb_new from w_coredata_ancestor`cb_new within w_chartererlist
integer x = 3195
integer y = 2380
integer width = 343
integer height = 100
end type

event cb_new::clicked;call super::clicked;if uf_updatespending() = -1 then return

tab_1.tabpage_1.dw_1.reset()
tab_1.tabpage_1.dw_1.insertrow(0)
tab_1.tabpage_1.dw_1.setfocus()

tab_1.tabpage_1.dw_1.object.datawindow.readonly='no'
 
tab_1.tabpage_1.dw_1.setitem(1,"chart_chart_custsupp",0)
tab_1.tabpage_1.dw_1.setitem(1,"chart_active",1)

wf_enabled_button(is_NEW)

il_charterer_nr = 0

end event

type cb_update from w_coredata_ancestor`cb_update within w_chartererlist
integer x = 3543
integer y = 2380
integer width = 343
integer height = 100
end type

event cb_update::clicked;call super::clicked;int		li_next_charterer_nr, li_intr_suppl
int		li_count, li_chart_blocked
long		ll_countryID, ll_found, ll_acc, ll_chart_active, ll_chart_nr
string	ls_chart_sn, ls_account_no, ls_countryName, ls_acc_new, ls_null

datawindowchild dwc

tab_1.tabpage_1.dw_1.accepttext()

If IsNull(tab_1.tabpage_1.dw_1.GetItemString(1, "chart_sn")) Then
	MessageBox("Update Error", "Please enter the charterer's Short Name!")
	Return
End If	

If IsNull(tab_1.tabpage_1.dw_1.GetItemstring(1, "chart_n_1")) Then
	MessageBox("Update Error", "Please enter the charterer's Full Name!")
	Return
End If

ls_chart_sn = tab_1.tabpage_1.dw_1.GetItemString(1, "chart_sn")
SELECT count(*) INTO :li_count FROM CHART WHERE CHART_SN = :ls_chart_sn;
If (il_Charterer_nr = 0 And li_count = 1) Then
	MessageBox("Duplicate", "You are creating a duplicate Charterer!~r~nThis is not allowed")
	Return
End If

// Validate the contents of "Nominal acc. number"
li_intr_suppl   = tab_1.tabpage_1.dw_1.GetItemNumber(1, "chart_chart_custsupp")
ls_account_no   = tab_1.tabpage_1.dw_1.GetItemString(1, "Chart_nom_acc_nr")
ll_countryID    = tab_1.tabpage_1.dw_1.GetItemNumber(1, "country_id")
ll_chart_active = tab_1.tabpage_1.dw_1.GetItemNumber(1, "chart_active")

if isnull(ls_account_no) then
	messagebox("Error", "Please enter the Nominal Account number.")
	return
end if

if tab_1.tabpage_1.dw_1.getitemstatus(1, "chart_nom_acc_nr", Primary!) = DataModified! then
	ll_chart_nr = tab_1.tabpage_1.dw_1.getitemnumber(1, "chart_nr")
	SELECT count(*)
	  INTO :li_count
	  FROM CHART
	 WHERE (:ll_chart_nr is null or CHART_NR <> :ll_chart_nr) AND
	       NOM_ACC_NR = :ls_account_no;
	if li_count > 0 then
		messagebox("Error", "The Nominal Account Number must be unique within all Charterers.")
		return
	end if
end if

// Validate country
if isNull(ll_countryID) then
	MessageBox("Error","Please select country")
	tab_1.SelectedTab = 1
	tab_1.tabpage_1.dw_1.setColumn( "country_id" )
	tab_1.tabpage_1.dw_1.post setfocus()
	Return
end if	
tab_1.tabpage_1.dw_1.getchild( "country_id", dwc)
ll_found = dwc.find( "country_id=" + string(ll_countryID) , 1, 9999 )
If ll_found < 1 then 
	MessageBox("Error","Please select country")
	tab_1.SelectedTab = 1	
	tab_1.tabpage_1.dw_1.setColumn( "country_id" )
	tab_1.tabpage_1.dw_1.post setfocus()
	Return
End if	
ls_countryName = dwc.getItemString(ll_found, "country_name")
tab_1.tabpage_1.dw_1.setItem(1, "chart_c", ls_countryName)

If li_intr_suppl = 0 Then
	// Not internal supplier - numeric(5)
	IF Not(IsNumber(ls_account_no)) OR (Len(ls_account_no) < 5) OR (Len(ls_account_no) > 5) THEN
		MessageBox("Error","The nominal account number must have exactly five digits")
		Return
	End If
Else
	// Internal supplier - text(3)
	If (Len(ls_account_no) < 3) OR (Len(ls_account_no) > 3) Then
		MessageBox("Error","The nominal account number must have exactly three characters")
		Return
	End If
End If

IF IsNull(tab_1.tabpage_1.dw_1.GetItemNumber(1, "ccs_chgp_pk")) THEN
	MessageBox("Update Error","Please select a Charterer Group")
	Return
End If

//CR2411 Begin added by ZSW001 on 29/07/2011
if isnull(tab_1.tabpage_1.dw_1.getitemstring(1, "chart_dem_analyst")) then
	messagebox("Update Error", "Please select a charterer demurrage analyst")
	tab_1.post selecttab(1)
	tab_1.tabpage_1.dw_1.post setcolumn("chart_dem_analyst")
	tab_1.tabpage_1.dw_1.post setfocus()
	return
end if
//CR2411 End added by ZSW001 on 29/07/2011

If il_Charterer_nr = 0 Then
	SELECT max(CHART_NR)	INTO :li_next_charterer_nr	FROM CHART;
	If IsNull(li_next_charterer_nr) Then
		tab_1.tabpage_1.dw_1.SetItem(1,"chart_nr",1)
	Else
		tab_1.tabpage_1.dw_1.SetItem(1,"chart_nr", li_next_charterer_nr + 1)
	End If
End If

/* Check if Charterer is already blocked from AX */
li_next_charterer_nr = tab_1.tabpage_1.dw_1.getItemNumber(1,"chart_nr")
SELECT COUNT(*) INTO :li_count FROM CHART	WHERE CHART_NR <> :li_next_charterer_nr AND NOM_ACC_NR = :ls_account_no	AND CHART_BLOCKED = 1;
If li_count > 0 then
	MessageBox("Error","Entered Account number is blocked in AX.",StopSign!)
	Return
End if

//Unblock an entry
SELECT NOM_ACC_NR, CHART_BLOCKED	INTO :ll_acc, :li_chart_blocked FROM CHART WHERE CHART_NR = :li_next_charterer_nr;
ls_acc_new = tab_1.tabpage_1.dw_1.getItemString(1,"chart_nom_acc_nr")

if tab_1.tabpage_1.dw_1.getItemNumber(1,"chart_blocked") = 0 and li_chart_blocked = 1 then
	if ls_acc_new = string(ll_acc) then
		messagebox("","Please enter a different 'Nominal Acc. Nr' when unblocking!")
		tab_1.selectedtab = 1
		tab_1.tabpage_1.dw_1.setColumn( "chart_nom_acc_nr" )
		tab_1.tabpage_1.dw_1.post setfocus()
		Return
	else
		string ls_blocked_note, ls_supplier_number, ls_supplier_name
		datetime ldt_blocked_date
		ls_blocked_note = "Unblocked, Nominal Acc. Nr changed from " + string(ll_acc) + " to " + ls_acc_new
		ldt_blocked_date = DateTime(Today(),Now())
		ls_supplier_name = tab_1.tabpage_1.dw_1.getItemString(1,"chart_n_1")
		INSERT INTO BLOCKED_VENDOR_LOG (BLOCKED_DATE, BLOCKED, TRAMOS_TYPE, SUPPLIER_NUMBER, SUPPLIER_NAME, TRAMOS_NAME, BLOCKED_NOTE)
		VALUES (:ldt_blocked_date, 0,"C",:ls_acc_new,:ls_supplier_name,:uo_global.gos_userid,:ls_blocked_note);
	end if
end if

If tab_1.tabpage_1.dw_1.Update() = 1 THEN
	commit;
Else
	rollback;
End If

// Set buttons
wf_enabled_button(is_UPDATE)

// Retrieve and select from main list
dw_list.Retrieve()
dw_list.Sort()
ll_found = dw_list.Find("chart_nr = " + string(tab_1.tabpage_1.dw_1.GetItemNumber(1, "chart_nr" ) ), 1, dw_list.rowCount() ) 
If ll_found = 0 then  // In case unable to find due to filter, remove filter and find again
	uo_searchbox.cb_clear.event clicked( )
	ll_found = dw_list.Find("chart_nr = " + string(tab_1.tabpage_1.dw_1.GetItemNumber(1, "chart_nr" ) ), 1, dw_list.rowCount() ) 	
End If
dw_list.event Clicked( 0, 0, ll_found, dw_list.object )
dw_list.scrollToRow(ll_found)

Return 1
end event

type st_list from w_coredata_ancestor`st_list within w_chartererlist
boolean visible = false
integer x = 2258
integer y = 244
integer height = 56
string text = "Charterers:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_chartererlist
integer x = 1330
integer y = 240
integer width = 3250
integer height = 2124
end type

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer width = 3214
integer height = 2008
string text = "Charterer Information"
cb_refresh_group_list cb_refresh_group_list
end type

on tabpage_1.create
this.cb_refresh_group_list=create cb_refresh_group_list
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_refresh_group_list
end on

on tabpage_1.destroy
call super::destroy
destroy(this.cb_refresh_group_list)
end on

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
event type boolean ue_usedefaultbackgroundcolor ( )
integer x = 18
integer y = 8
integer width = 3218
integer height = 1980
string dataobject = "dw_charterer_ns"
end type

event type boolean dw_1::ue_usedefaultbackgroundcolor();return true

end event

event dw_1::clicked;call super::clicked;datawindowchild	ldwc_child

if dwo.name = "p_refresh" then
	if this.getchild("ccs_chgp_pk", ldwc_child) = 1 then
		ldwc_child.settransobject(sqlca)
		ldwc_child.retrieve()
	end if
end if

end event

type cb_refresh_group_list from commandbutton within tabpage_1
boolean visible = false
integer x = 2857
integer y = 480
integer width = 256
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;
datawindowchild	dwc

If dw_1.GetChild("ccs_chgp_pk", dwc) = 1 then
	dwc.setTransObject( sqlca )
	dwc.retrieve()
	Commit;
End if
end event

type st_notice from statictext within w_chartererlist
boolean visible = false
integer x = 37
integer y = 2396
integer width = 2194
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "As you are a user without Finance profile, you can only modify comments!"
boolean focusrectangle = false
end type

type st_2 from u_topbar_background within w_chartererlist
integer width = 6999
end type

