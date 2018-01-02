$PBExportHeader$w_tcowner_list.srw
forward
global type w_tcowner_list from w_coredata_ancestor
end type
type tabpage_2 from userobject within tab_1
end type
type dw_bank from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_bank dw_bank
end type
type st_notice from statictext within w_tcowner_list
end type
end forward

global type w_tcowner_list from w_coredata_ancestor
integer width = 4018
integer height = 2456
string title = "T/C Owners"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
st_notice st_notice
end type
global w_tcowner_list w_tcowner_list

type variables

Long il_TCOwner_nr
end variables

forward prototypes
public function integer wf_validate ()
private function integer uf_updatespending ()
public function integer wf_update ()
public subroutine wf_settaborder ()
public subroutine documentation ()
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
tab_1.tabpage_1.dw_1.settaborder("chart_b_n_1",0)		
tab_1.tabpage_1.dw_1.settaborder("chart_b_n_2",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_a_1",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_a_2",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_a_3",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_a_4",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_c",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_att",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_ph",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_tfx",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_tx",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_tx_ab",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_nr",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_acc_o",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_swift",0)	
tab_1.tabpage_1.dw_1.settaborder("chart_b_chips",0)
tab_1.tabpage_1.dw_1.settaborder("chart_active",0)
end subroutine

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
   	28/08/14		CR3781	CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_tcowner_list.create
int iCurrent
call super::create
this.st_notice=create st_notice
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_notice
end on

on w_tcowner_list.destroy
call super::destroy
destroy(this.st_notice)
end on

event open;call super::open;// Init datawindows
dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.ShareData(tab_1.tabpage_2.dw_bank)
dw_list.Retrieve()

il_TCOwner_nr = Message.DoubleParm
If IsNull(il_TCOwner_nr) then il_TCOwner_nr = 0

// Sort and select
Long ll_Found
dw_list.SetSort("tcowner_sn")
dw_list.Sort( )
If il_TCOwner_nr = 0 then
	ll_Found = 1
Else
	ll_Found = dw_List.Find("tcowner_nr = " + String(il_TCOwner_nr), 0, dw_List.RowCount())
	If ll_Found <= 0 then ll_Found = 1
End If
dw_list.event Clicked(0, 0, ll_Found, dw_list.object)
dw_List.ScrollToRow(ll_Found)

// Initialize search box
uo_SearchBox.of_initialize(dw_List, "tcowner_sn+'#'+tcowner_n_1")
uo_SearchBox.sle_search.POST setfocus()

//set datawindow read-only when blocked, only finance superuser can unblock
If tab_1.tabpage_1.dw_1.getitemnumber( 1, "tcowner_blocked") = 1 then
	if uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 then
		tab_1.tabpage_1.dw_1.settaborder("tcowner_blocked",600)
	else
		tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='Yes'
		cb_Update.enabled = false /* Update button */
		st_notice.visible = true
	end if
End if

/* If not "administrator" then check if person is finans profile.
If not disable nom_acc_nr */
If uo_global.ii_access_level < 3 And uo_global.ii_user_profile < 3 then 
	tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='Yes'
	cb_Update.enabled = false
	cb_cancel.enabled = false
	cb_new.enabled = false
	cb_delete.enabled = false
	st_notice.visible = true
End if


end event

event closequery;call super::closequery;
If uf_updatespending() = 0 Then Return 0

If cb_update.event clicked() = -1 Then Return 1 Else Return 0
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_tcowner_list
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_tcowner_list
integer y = 32
integer width = 1554
end type

type st_1 from w_coredata_ancestor`st_1 within w_tcowner_list
boolean visible = false
integer x = 987
integer y = 48
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_tcowner_list
boolean visible = false
integer x = 1134
integer y = 192
integer width = 219
end type

type dw_list from w_coredata_ancestor`dw_list within w_tcowner_list
integer y = 288
integer width = 1554
integer height = 1936
string dataobject = "dw_tcowner_list"
end type

event dw_list::clicked;call super::clicked;// Call ancestor Clicked event to perform sorting
// Super::Event Clicked(xpos, ypos, row, dwo)

If row < 1 then return

If uf_updatespending() = -1 then 
	cb_Update.Event Clicked()
	Return
End If

setPointer(hourGlass!)

dw_list.selectRow(0,false)
dw_list.selectRow(row,true)

il_TCOwner_nr = This.GetItemNumber(row, "tcowner_nr")

//Retrieve tabpages
tab_1.tabpage_1.dw_1.Retrieve(il_TCOwner_nr)

//set datawindow read-only when blocked, only finance superuser can unblock

if  uo_global.ii_access_level = 3 or uo_global.ii_user_profile =3 then 
tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='No'
tab_1.tabpage_2.dw_bank.Object.DataWindow.ReadOnly='No'

If tab_1.tabpage_1.dw_1.getitemnumber( 1, "tcowner_blocked") = 1 then
	If uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 then
		tab_1.tabpage_1.dw_1.settaborder("tcowner_blocked",600)
	Else
		tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='Yes'
		tab_1.tabpage_2.dw_bank.Object.DataWindow.ReadOnly='Yes'
		cb_Update.enabled = false 
		st_notice.visible = true
	End if
Else
	If cb_New.Enabled then
		tab_1.tabpage_1.dw_1.settaborder("tcowner_blocked", 0)
		tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='No'
		tab_1.tabpage_2.dw_bank.Object.DataWindow.ReadOnly='No'
		cb_Update.enabled = True
		st_notice.visible = False
	End If
End if
	cb_new.enabled = true
     cb_delete.enabled = true 
end if


SetPointer(Arrow!)
end event

type cb_close from w_coredata_ancestor`cb_close within w_tcowner_list
integer x = 3584
integer y = 2240
end type

event cb_close::clicked;call super::clicked;
Close(Parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_tcowner_list
integer x = 3182
integer y = 2240
end type

event cb_cancel::clicked;call super::clicked;// Triggers the Clickedevent of dw_list
tab_1.tabpage_1.dw_1.reset()

dw_list.event Clicked(0,0,dw_list.Getrow(),dw_list.object)

cb_new.enabled = (dw_list.rowcount() > 0)
cb_delete.enabled = cb_new.enabled
cb_update.enabled = cb_new.enabled
cb_cancel.enabled = cb_new.enabled

end event

type cb_delete from w_coredata_ancestor`cb_delete within w_tcowner_list
integer x = 2779
integer y = 2240
end type

event cb_delete::clicked;call super::clicked;Long ll_row

ll_row = dw_list.GetSelectedRow(0)

If ll_Row <> 0 Then
	If MessageBox("Delete","You are about to DELETE the charterer!~r~nAre you sure you want to continue?",Question!,YesNo!,2) = 2 Then Return
	dw_list.DeleteRow(ll_row)
	If dw_list.Update() = 1 Then
		Commit;
	Else
		Rollback;
	End If
	If dw_list.Retrieve() > 0 then 
		If ll_Row > dw_List.RowCount() then ll_Row = dw_List.RowCount()
		dw_List.SelectRow(ll_Row, True)
		dw_List.event clicked(0,0, ll_row, dw_list.object)
		dw_List.ScrollToRow(ll_row)
	Else
		tab_1.tabpage_1.dw_1.Reset( )
		cb_Update.Enabled = False
	End If			
end if
end event

type cb_new from w_coredata_ancestor`cb_new within w_tcowner_list
integer x = 1975
integer y = 2240
end type

event cb_new::clicked;call super::clicked;If uf_updatesPending() = -1 then return

tab_1.tabpage_1.dw_1.Reset()
tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_1.dw_1.setFocus()

tab_1.tabpage_1.dw_1.SetItem(1,"tcowner_active",1)
tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='No'
tab_1.tabpage_2.dw_bank.Object.DataWindow.ReadOnly='No'

cb_new.enabled = false
cb_delete.enabled = false
cb_update.enabled = true
cb_cancel.enabled = true

il_TCOwner_nr = 0

end event

type cb_update from w_coredata_ancestor`cb_update within w_tcowner_list
integer x = 2377
integer y = 2240
end type

event cb_update::clicked;call super::clicked;integer li_count, li_tcowner_blocked
long ll_next_tcowner_nr, ll_countryID, ll_found, ll_acc
string ls_tcowner_sn, ls_countryName, ls_acc_new
datawindowchild dwc

tab_1.tabpage_1.dw_1.accepttext()
tab_1.tabpage_2.dw_bank.accepttext( )

if isnull(tab_1.tabpage_1.dw_1.getitemstring(1, "tcowner_sn")) then
	Messagebox("Update Error", "Please enter a T/C Owner short name")
	return 
end if

if isnull(tab_1.tabpage_1.dw_1.getitemstring(1, "tcowner_n_1")) then
	Messagebox("Update Error", "Please enter a T/C Owner full name")
	return 
end if

if isnull(tab_1.tabpage_1.dw_1.getitemstring(1, "tcowner_a_1")) then
	Messagebox("Update Error", "Please enter a T/C Owner Address")
	return 
end if

ls_tcowner_sn = tab_1.tabpage_1.dw_1.getitemstring(1,"tcowner_sn") 

SELECT count(*) into :li_count FROM TCOWNERS WHERE TCOWNER_SN = :ls_tcowner_sn;
COMMIT USING SQLCA;

if (il_TCOwner_nr = 0 and li_count = 1) then 
	Messagebox("Duplicate", "You are creating a duplicate T/C Owner!~r~nThis is not allowed.")
	return
end if

// Validate the contents of "Nominal acc. number" FR 30-08-02
string ls_account_no

ls_account_no = tab_1.tabpage_1.dw_1.GetItemString(1,"nom_acc_nr")

IF isNull(ls_account_no) THEN
	MessageBox("Error","Please enter the nominal account number")
	Return
END IF

IF NOT(IsNumber(ls_account_no)) OR (Len(ls_account_no) < 5) OR (Len(ls_account_no) > 5) THEN
	MessageBox("Error","The nominal account number must have exactly five digits")
	Return
END IF

// Validate country
ll_countryID = tab_1.tabpage_1.dw_1.getItemNumber(1, "country_id")
if isNull(ll_countryID) then
	MessageBox("Error","Please select country")
	tab_1.tabpage_1.dw_1.setColumn( "country_id" )
	tab_1.tabpage_1.dw_1.post setfocus()
	Return
end if	
tab_1.tabpage_1.dw_1.getchild( "country_id", dwc)
ll_found = dwc.find( "country_id="+string(ll_countryID) , 1, 9999 )
if ll_found < 1 then 
	MessageBox("Error","Please select country")
	tab_1.tabpage_1.dw_1.setColumn( "country_id" )
	tab_1.tabpage_1.dw_1.post setfocus()
	Return
end if	
ls_countryName = dwc.getItemString(ll_found, "country_name")
tab_1.tabpage_1.dw_1.setItem(1, "tcowner_c", ls_countryName)

if (il_tcowner_nr = 0) then 
	SELECT max(TCOWNER_NR) INTO :ll_next_tcowner_nr	FROM TCOWNERS;
	COMMIT USING SQLCA;
	if (isnull(ll_next_tcowner_nr)) then
		tab_1.tabpage_1.dw_1.setitem(1, "tcowner_nr", 1)
	else
		tab_1.tabpage_1.dw_1.setitem(1, "tcowner_nr", ll_next_tcowner_nr +1 )
	end if
end if

if isnull(tab_1.tabpage_2.dw_bank.getitemstring(1, "tcowner_b_n_1")) then
	Messagebox("Update Error", "Please enter a T/C Owner Bank Detail Fullname")
	return 
end if

if isnull(tab_1.tabpage_2.dw_bank.getitemstring(1, "tcowner_b_a_1")) then
	Messagebox("Update Error", "Please enter a T/C Owner Bank Detail Address")
	return 
end if

if isnull(tab_1.tabpage_2.dw_bank.getitemstring(1, "tcowner_b_nr")) then
	Messagebox("Update Error", "Please enter a T/C Owner Bank Account Number")
	return 
end if

if isnull(tab_1.tabpage_2.dw_bank.getitemstring(1, "tcowner_b_acc_o")) then
	Messagebox("Update Error", "Please enter a T/C Owner Bank Account Owner")
	return 
end if

/* Check if TC Owner is already blocked from AX */
ll_next_tcowner_nr = tab_1.tabpage_1.dw_1.getItemNumber(1,"tcowner_nr")
SELECT COUNT(*) INTO :li_count FROM TCOWNERS	WHERE TCOWNER_NR <> :ll_next_tcowner_nr AND NOM_ACC_NR = :ls_account_no	AND TCOWNER_BLOCKED = 1;
if li_count > 0 then
	MessageBox("Error","Entered Account number is blocked in AX.",StopSign!)
	Return
end if

//unblock an entry
SELECT NOM_ACC_NR, TCOWNER_BLOCKED INTO :ll_acc, :li_tcowner_blocked	FROM TCOWNERS WHERE TCOWNER_NR = :ll_next_tcowner_nr;
ls_acc_new = tab_1.tabpage_1.dw_1.getItemString(1,"nom_acc_nr")
if tab_1.tabpage_1.dw_1.getItemNumber(1,"tcowner_blocked") = 0 and li_tcowner_blocked = 1 then
	if ls_acc_new = string(ll_acc) then
		messagebox("","Please enter a different 'Nominal Acc. Nr' when unblocking!")
		tab_1.tabpage_1.dw_1.setColumn( "nom_acc_nr" )
		tab_1.tabpage_1.dw_1.post setfocus()
		Return
	else
		string ls_blocked_note, ls_supplier_number, ls_supplier_name
		datetime ldt_blocked_date
		ls_blocked_note = "Unblocked, Nominal Acc. Nr changed from " + string(ll_acc) + " to " + ls_acc_new
		ldt_blocked_date = DateTime(Today(),Now())
		ls_supplier_name = tab_1.tabpage_1.dw_1.getItemString(1,"tcowner_n_1")
		INSERT INTO BLOCKED_VENDOR_LOG (BLOCKED_DATE, BLOCKED, TRAMOS_TYPE, SUPPLIER_NUMBER, SUPPLIER_NAME, TRAMOS_NAME, BLOCKED_NOTE)
		VALUES (:ldt_blocked_date, 0,"T",:ls_acc_new,:ls_supplier_name,:uo_global.gos_userid,:ls_blocked_note);
	end if
end if

If (tab_1.tabpage_1.dw_1.update() = 1) then
	commit;
else
	rollback;
end if

// Set buttons
cb_update.enabled = true
cb_cancel.enabled = true
cb_new.enabled = true
cb_delete.enabled = true

// Retrieve and select from main list
dw_list.Retrieve()
dw_list.Sort()
ll_found = dw_list.Find("tcowner_nr = " + string(tab_1.tabpage_1.dw_1.GetItemNumber(1, "tcowner_nr" ) ), 1, dw_list.rowCount() ) 
If ll_found = 0 then  // In case unable to find due to filter, remove filter and find again
	uo_searchbox.cb_clear.event clicked( )
	ll_found = dw_list.Find("tcowner_nr = " + string(tab_1.tabpage_1.dw_1.GetItemNumber(1, "tcowner_nr" ) ), 1, dw_list.rowCount() ) 	
End If
dw_list.event Clicked( 0, 0, ll_found, dw_list.object )
dw_list.scrollToRow(ll_found)

Return 1
end event

type st_list from w_coredata_ancestor`st_list within w_tcowner_list
integer y = 224
string text = "TC Owners:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_tcowner_list
integer x = 1646
integer y = 16
integer width = 2341
integer height = 2208
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_2=create tabpage_2
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_2
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_2)
end on

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer width = 2304
integer height = 2092
string text = "Owner Information"
end type

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
integer x = 18
integer y = 24
integer width = 3090
integer height = 2064
string dataobject = "dw_tcowner"
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2304
integer height = 2092
long backcolor = 67108864
string text = "Bank Details"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_bank dw_bank
end type

on tabpage_2.create
this.dw_bank=create dw_bank
this.Control[]={this.dw_bank}
end on

on tabpage_2.destroy
destroy(this.dw_bank)
end on

type dw_bank from datawindow within tabpage_2
integer x = 18
integer y = 24
integer width = 2249
integer height = 1424
integer taborder = 50
string title = "none"
string dataobject = "dw_tcowner_bank_shared"
boolean border = false
boolean livescroll = true
end type

type st_notice from statictext within w_tcowner_list
boolean visible = false
integer x = 37
integer y = 2272
integer width = 1481
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Only users with finance profile can modify TC Owners"
boolean focusrectangle = false
end type

