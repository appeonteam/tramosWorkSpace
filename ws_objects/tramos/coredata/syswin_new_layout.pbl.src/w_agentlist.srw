$PBExportHeader$w_agentlist.srw
forward
global type w_agentlist from w_coredata_ancestor
end type
type tabpage_2 from userobject within tab_1
end type
type dw_bank from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_bank dw_bank
end type
type st_notice from statictext within w_agentlist
end type
end forward

global type w_agentlist from w_coredata_ancestor
integer width = 3831
integer height = 2500
string title = "Agents"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
st_notice st_notice
end type
global w_agentlist w_agentlist

type variables

Long il_agent_nr
end variables

forward prototypes
private function integer uf_updatespending ()
end prototypes

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

on w_agentlist.create
int iCurrent
call super::create
this.st_notice=create st_notice
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_notice
end on

on w_agentlist.destroy
call super::destroy
destroy(this.st_notice)
end on

event open;call super::open;// Init datawindows
dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.ShareData(tab_1.tabpage_2.dw_Bank)
dw_list.Retrieve()

il_agent_nr = Message.DoubleParm
If IsNull(il_agent_nr) then il_agent_nr = 0

// Sort and select
Long ll_Found
dw_list.SetSort("agent_sn")
dw_list.Sort( )
If il_agent_nr = 0 then
	ll_Found = 1
Else
	ll_Found = dw_List.Find("agent_nr = " + String(il_agent_nr), 0, dw_List.RowCount())
	If ll_Found <= 0 then ll_Found = 1
End If
dw_list.event Clicked(0, 0, ll_Found, dw_list.object)
dw_List.ScrollToRow(ll_Found)

// Initialize search box
uo_SearchBox.of_initialize(dw_List, "agent_sn+'#'+agent_n_1")
uo_SearchBox.sle_search.POST setfocus()

/* Only Administrator and Finance profile can modify Agents */
IF uo_global.ii_access_level < 3 and uo_global.ii_user_profile < 3 then
	tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='Yes'
	tab_1.tabpage_2.dw_bank.Object.DataWindow.ReadOnly='Yes'
	cb_Update.enabled = false /* Update button */
	cb_delete.enabled = false
	cb_Cancel.Enabled = False
	st_notice.visible = true
	cb_new.enabled = false
	return
END IF

end event

event closequery;call super::closequery;
If uf_updatespending() = 0 Then Return 0

If cb_update.event clicked() = -1 Then Return 1 Else Return 0
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_agentlist
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_agentlist
integer y = 32
integer width = 1408
end type

type st_1 from w_coredata_ancestor`st_1 within w_agentlist
boolean visible = false
integer x = 549
integer y = 176
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_agentlist
boolean visible = false
integer x = 731
integer y = 208
integer width = 219
end type

type dw_list from w_coredata_ancestor`dw_list within w_agentlist
integer y = 288
integer width = 1408
integer height = 1984
string dataobject = "dw_agent_list"
end type

event dw_list::clicked;call super::clicked;
If row < 1 then return

If uf_updatespending() = -1 then 
	cb_Update.Event Clicked()
	Return
End If

setPointer(hourGlass!)

dw_list.selectRow(0,false)
dw_list.selectRow(row,true)

il_agent_nr = This.GetItemNumber(row, "agent_nr")

//Retrieve tabpages
tab_1.tabpage_1.dw_1.Retrieve(il_agent_nr)

// If user has access
If cb_cancel.Enabled then
	
	//set datawindow read-only when blocked, only finance superuser can unblock
	If tab_1.tabpage_1.dw_1.GetItemnumber(1, "agent_blocked") = 1 then
		If uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 then
			tab_1.tabpage_1.dw_1.settaborder("agent_blocked",600)
		Else
			tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='Yes'
			tab_1.tabpage_2.dw_bank.Object.DataWindow.ReadOnly='Yes'
			cb_Update.enabled = false /* Update button */
			st_Notice.visible = true
		end if
	Else
		tab_1.tabpage_1.dw_1.settaborder("agent_blocked", 0)
		tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='No'
		tab_1.tabpage_2.dw_bank.Object.DataWindow.ReadOnly='No'
		cb_Update.enabled = True /* Update button */
		st_Notice.visible = False
	End if
End If

SetPointer(Arrow!)
end event

type cb_close from w_coredata_ancestor`cb_close within w_agentlist
integer x = 3401
integer y = 2288
end type

event cb_close::clicked;call super::clicked;
Close(Parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_agentlist
integer x = 2962
integer y = 2288
end type

event cb_cancel::clicked;call super::clicked;// Triggers the Clickedevent of dw_list
tab_1.tabpage_1.dw_1.reset()

dw_list.event Clicked(0,0,dw_list.Getrow(),dw_list.object)

cb_new.enabled = (dw_list.rowcount() > 0)
cb_delete.enabled = cb_new.enabled
cb_update.enabled = cb_new.enabled
cb_cancel.enabled = cb_new.enabled

end event

type cb_delete from w_coredata_ancestor`cb_delete within w_agentlist
integer x = 2523
integer y = 2288
end type

event cb_delete::clicked;call super::clicked;Long ll_row

ll_row = dw_list.GetSelectedRow(0)

If ll_Row <> 0 Then
	If MessageBox("Delete","You are about to DELETE the agent!~r~nAre you sure you want to continue?",Question!,YesNo!,2) = 2 Then Return
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

type cb_new from w_coredata_ancestor`cb_new within w_agentlist
integer x = 1627
integer y = 2288
end type

event cb_new::clicked;call super::clicked;If uf_updatesPending() = -1 then return

tab_1.tabpage_1.dw_1.Reset()
tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_1.dw_1.setFocus()

tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='No'
tab_1.tabpage_2.dw_bank.Object.DataWindow.ReadOnly='No'
	
tab_1.tabpage_1.dw_1.SetItem(1,"agent_disc",0)
tab_1.tabpage_1.dw_1.SetItem(1,"agent_custsupp",0)
tab_1.tabpage_1.dw_1.SetItem(1,"agent_active",1)

cb_new.enabled = false
cb_delete.enabled = false
cb_update.enabled = true
cb_cancel.enabled = true

il_agent_nr = 0

end event

type cb_update from w_coredata_ancestor`cb_update within w_agentlist
integer x = 2066
integer y = 2288
end type

event cb_update::clicked;call super::clicked;int li_next_agent_nr, li_intr_suppl, li_count, li_agent_blocked
long ll_acc, ll_countryID, ll_found
string ls_account_no, ls_countryName, ls_acc_new
datawindowchild	dwc

If IsNull(tab_1.tabpage_1.dw_1.GetItemString(1, "agent_sn")) or IsNull(tab_1.tabpage_1.dw_1.GetItemString(1, "agent_n_1")) or IsNull(tab_1.tabpage_1.dw_1.GetItemString(1, "nom_acc_nr")) then 
	MessageBox("Error", "Please enter all mandatory fields!", Exclamation!)
	Return
End If

// For new agent, get next number
If il_Agent_nr = 0 Then
	SELECT max(AGENT_NR) INTO :li_next_agent_nr FROM AGENTS;
	If IsNull(li_next_agent_nr) THEN 
		tab_1.tabpage_1.dw_1.SetItem(1,"agent_nr",1)
	Else
		tab_1.tabpage_1.dw_1.SetItem(1,"agent_nr", li_next_agent_nr + 1)
	End If
END IF

tab_1.tabpage_1.dw_1.AcceptText()
li_intr_suppl = tab_1.tabpage_1.dw_1.GetItemNumber(1, "agent_custsupp")
ls_account_no = tab_1.tabpage_1.dw_1.GetItemString(1, "nom_acc_nr")
ll_countryID = tab_1.tabpage_1.dw_1.GetItemNumber(1, "country_id")

// Validate the contents of "Nominal acc. number"
If isNull(ls_account_no) THEN
	MessageBox("Error","Please enter the nominal account number.")
	tab_1.tabpage_1.dw_1.setColumn( "nom_acc_nr" )
	tab_1.tabpage_1.dw_1.post setfocus()	
	Return
End If

// Validate country
if isNull(ll_countryID) then
	MessageBox("Error","Please select country")
	tab_1.tabpage_1.dw_1.setColumn( "country_id" )
	tab_1.tabpage_1.dw_1.post setfocus()
	Return
End if	

tab_1.tabpage_1.dw_1.getchild( "country_id", dwc)
ll_found = dwc.find( "country_id="+string(ll_countryID) , 1, 9999 )
if ll_found < 1 then 
	MessageBox("Error","Please select country")
	tab_1.tabpage_1.dw_1.setColumn( "country_id" )
	tab_1.tabpage_1.dw_1.post setfocus()
	Return
end if	
ls_countryName = dwc.getItemString(ll_found, "country_name")
tab_1.tabpage_1.dw_1.setItem(1, "agent_c", ls_countryName)
	
IF li_intr_suppl = 0 THEN
	// Not internal supplier - numeric(5)
	IF NOT(IsNumber(ls_account_no)) OR (Len(ls_account_no) < 5) OR (Len(ls_account_no) > 5) THEN
		MessageBox("Error","The nominal account number must have exactly five digits")
		Return
	END IF
ELSE
	// Internal supplier - text(3)
	IF (Len(ls_account_no) < 3) OR (Len(ls_account_no) > 3) THEN
		MessageBox("Error","The nominal account number must have exactly three characters")
		Return
	END IF
END IF


/* Check if Agent is already blocked from AX */
li_next_agent_nr = tab_1.tabpage_1.dw_1.getItemNumber(1,"agent_nr")
SELECT COUNT(*) INTO :li_count FROM AGENTS WHERE AGENT_NR <> :li_next_agent_nr AND NOM_ACC_NR = :ls_account_no	AND AGENT_BLOCKED = 1;
If li_count > 0 then
	MessageBox("Error","Entered Account number is blocked in AX.",StopSign!)
	Return
End if

//unblock an entry
SELECT NOM_ACC_NR, AGENT_BLOCKED	INTO :ll_acc, :li_agent_blocked FROM AGENTS WHERE AGENT_NR = :li_next_agent_nr;
ls_acc_new = tab_1.tabpage_1.dw_1.getItemString(1,"nom_acc_nr")
If tab_1.tabpage_1.dw_1.getItemNumber(1,"agent_blocked") = 0 and li_agent_blocked = 1 then
	If ls_acc_new = string(ll_acc) then
		messagebox("","Please enter a different 'Nominal Acc. Nr' when unblocking!")
		tab_1.tabpage_1.dw_1.setColumn( "nom_acc_nr" )
		tab_1.tabpage_1.dw_1.post setfocus()
		Return
	Else
		string ls_blocked_note, ls_supplier_number, ls_supplier_name
		datetime ldt_blocked_date
		ls_blocked_note = "Unblocked, Nominal Acc. Nr changed from " + string(ll_acc) + " to " + ls_acc_new
		ldt_blocked_date = DateTime(Today(),Now())
		ls_supplier_name = tab_1.tabpage_1.dw_1.getItemString(1,"agent_n_1")
		INSERT INTO BLOCKED_VENDOR_LOG (BLOCKED_DATE, BLOCKED, TRAMOS_TYPE, SUPPLIER_NUMBER, SUPPLIER_NAME, TRAMOS_NAME, BLOCKED_NOTE)
		VALUES (:ldt_blocked_date, 0,"A",:ls_acc_new,:ls_supplier_name,:uo_global.gos_userid,:ls_blocked_note);
	End if
End if

If tab_1.tabpage_1.dw_1.Update() = 1 then
	Commit;
Else
	Rollback;
	Return
End If

// Set buttons
cb_update.enabled = true
cb_cancel.enabled = true
cb_new.enabled = true
cb_delete.enabled = true

// Retrieve and select from main list
dw_list.Retrieve()
dw_list.Sort()
ll_found = dw_list.Find("agent_nr = " + string(tab_1.tabpage_1.dw_1.GetItemNumber(1, "agent_nr")), 1, dw_list.rowCount() ) 
If ll_found = 0 then  // In case unable to find due to filter, remove filter and find again
	uo_searchbox.cb_clear.event clicked( )
	ll_found = dw_list.Find("agent_nr = " + string(tab_1.tabpage_1.dw_1.GetItemNumber(1, "agent_nr")), 1, dw_list.rowCount() )
End If
dw_list.event Clicked( 0, 0, ll_found, dw_list.object )
dw_list.scrollToRow(ll_found)

Return 1


end event

type st_list from w_coredata_ancestor`st_list within w_agentlist
integer y = 224
string text = "Agents:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_agentlist
integer x = 1499
integer y = 16
integer width = 2304
integer height = 2256
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
integer width = 2267
integer height = 2140
string text = "Agent Details"
end type

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
integer x = 18
integer y = 8
integer width = 2011
integer height = 2144
string dataobject = "dw_agent"
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2267
integer height = 2140
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
integer y = 8
integer width = 2249
integer height = 1536
integer taborder = 50
string title = "none"
string dataobject = "dw_agent_bank_shared"
boolean border = false
boolean livescroll = true
end type

type st_notice from statictext within w_agentlist
boolean visible = false
integer x = 37
integer y = 2320
integer width = 1513
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Only users with Finance profile can modify Agents!"
boolean focusrectangle = false
end type

