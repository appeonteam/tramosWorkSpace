$PBExportHeader$w_brokerlist.srw
forward
global type w_brokerlist from w_coredata_ancestor
end type
type tabpage_2 from userobject within tab_1
end type
type cb_delacc from commandbutton within tabpage_2
end type
type cb_newacc from commandbutton within tabpage_2
end type
type dw_account from uo_datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_delacc cb_delacc
cb_newacc cb_newacc
dw_account dw_account
end type
type st_notice from statictext within w_brokerlist
end type
type st_notify2 from statictext within w_brokerlist
end type
end forward

global type w_brokerlist from w_coredata_ancestor
integer width = 4375
integer height = 2472
string title = "Brokers"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
st_notice st_notice
st_notify2 st_notify2
end type
global w_brokerlist w_brokerlist

type variables

Long il_broker_nr
end variables

forward prototypes
public function integer wf_validate ()
private function integer uf_updatespending ()
public function integer wf_update ()
end prototypes

public function integer wf_validate ();string ls_broker_sn, ls_account_no, ls_countryName
integer li_count, li_intr_suppl
long ll_count, ll_rows, ll_row, ll_countryID, ll_found
datetime ldt_null
setNull(ldt_null)
datawindowchild dwc

tab_1.tabpage_1.dw_1.AcceptText()
tab_1.tabpage_2.dw_account.AcceptText()

/* *** START BASE *** First check that Broker base information is correct */
IF IsNull(tab_1.tabpage_1.dw_1.GetItemString(1,"broker_sn")) THEN
	MessageBox("Update Error","Please enter a broker Short Name!")
	tab_1.tabpage_1.dw_1.POST setColumn("broker_sn")
	tab_1.tabpage_1.dw_1.POST setFocus()
	Return -1
END IF	

IF IsNull(tab_1.tabpage_1.dw_1.GetItemstring(1,"broker_name")) THEN
	MessageBox("Update Error","Please enter a broker Full Name (Blue Line)!")
	tab_1.tabpage_1.dw_1.POST setColumn("broker_name")
	tab_1.tabpage_1.dw_1.POST setFocus()
	Return -1
END IF	

ls_broker_sn = tab_1.tabpage_1.dw_1.GetItemString(1,"broker_sn")
SELECT count(*)
INTO :li_count
FROM BROKERS
WHERE BROKER_SN = :ls_broker_sn;
IF (il_broker_nr = 0 AND li_count = 1) THEN
	MessageBox("Duplicate","You are creating a duplicate broker. Broker Short Name must be unique!")
	tab_1.tabpage_1.dw_1.POST setColumn("broker_sn")
	tab_1.tabpage_1.dw_1.POST setFocus()
	Return -1
END IF

// Validate the contents of "Nominal acc. number"
li_intr_suppl = tab_1.tabpage_1.dw_1.GetItemNumber(1, "broker_custsupp")
ls_account_no = tab_1.tabpage_1.dw_1.GetItemString(1, "nom_acc_nr")

IF isNull(ls_account_no) THEN
	MessageBox("Error","Please enter the nominal account number")
	tab_1.tabpage_1.dw_1.POST setColumn("nom_acc_nr")
	tab_1.tabpage_1.dw_1.POST setFocus()
	Return -1
END IF

// Validate country
ll_countryID = tab_1.tabpage_1.dw_1.GetItemNumber(1, "country_id")

if isNull(ll_countryID) then
	MessageBox("Error","Please select country")
	tab_1.tabpage_1.dw_1.setColumn( "country_id" )
	tab_1.tabpage_1.dw_1.post setfocus()
	Return -1
end if	
tab_1.tabpage_1.dw_1.getchild( "country_id", dwc)
ll_found = dwc.find( "country_id="+string(ll_countryID) , 1, 9999 )
if ll_found < 1 then 
	MessageBox("Error","Please select country")
	tab_1.tabpage_1.dw_1.setColumn( "country_id" )
	tab_1.tabpage_1.dw_1.post setfocus()
	Return -1
end if	
ls_countryName = dwc.getItemString(ll_found, "country_name")
tab_1.tabpage_1.dw_1.setItem(1, "broker_c", ls_countryName)

IF li_intr_suppl = 0 THEN
	// Not internal supplier - numeric(5)
	IF NOT(IsNumber(ls_account_no)) OR (Len(ls_account_no) < 5) OR (Len(ls_account_no) > 5) THEN
		MessageBox("Error","The nominal account number must have exactly five digits")
		tab_1.tabpage_1.dw_1.POST setColumn("nom_acc_nr")
		tab_1.tabpage_1.dw_1.POST setFocus()
		Return -1
	END IF
ELSE
	// Internal supplier - text(3)
	IF (Len(ls_account_no) < 3) OR (Len(ls_account_no) > 3) THEN
		MessageBox("Error","The nominal account number must have exactly three characters")
		tab_1.tabpage_1.dw_1.POST setColumn("nom_acc_nr")
		tab_1.tabpage_1.dw_1.POST setFocus()
		Return -1
	END IF
END IF

/* *** END BASE *** Validation */ 
///* *** START from Pool Manager to Broker 
//	if changed from Pool Manager to Broker, check that there are no commissions settled
//	don't check if Broker is NEW */
//if il_broker_nr > 0 then
//	if dw_broker.getItemNumber(1, "broker_pool_manager") = 1 and dw_broker.getItemNumber(1, "broker_pool_manager", primary!, true)= 0 then
//		SELECT count(*)  
//			INTO :ll_count
//			FROM TCCOMMISSION  
//			WHERE TCCOMMISSION.BROKER_NR = :il_broker_nr  
//				AND TCCOMMISSION.TCCOMM_SETTLED = 1  ;
//		COMMIT;
//		if ll_count > 0 then
//			MessageBox("Error","As there are TC Commissions settled, it is not possible to change Broker to be 'Normal Broker'")
//			dw_broker.POST setColumn("broker_pool_manager")
//			dw_broker.POST setFocus()
//			Return -1
//		end if
//		SELECT count(*)  
//			INTO :ll_count
//			FROM COMMISSIONS  
//			WHERE COMMISSIONS.BROKER_NR = :il_broker_nr  
//				AND COMMISSIONS.COMM_SETTLED = 1   ;
//		COMMIT;
//		if ll_count > 0 then
//			MessageBox("Error","As there are Claim Commissions settled, it is not possible to change Broker to be 'Normal Broker'")
//			dw_broker.POST setColumn("broker_pool_manager")
//			dw_broker.POST setFocus()
//			Return -1
//		end if
//	end if
//end if
///* *** END from Pool Manager to Broker */
//
///* *** START validate accounts */
//ll_rows = dw_account.rowCount()
//for ll_row = 1 to ll_rows
//	// validate dates empty or not in sequence
//	choose case ll_row
//		case ll_rows
//			if isNull(dw_account.getItemDatetime(ll_row, "period_start")) then
//				MessageBox("Validation Error","Please enter a start date in first period!")
//				dw_account.POST setColumn("period_start")
//				dw_account.POST setFocus()
//				Return -1
//			end if
//			if NOT isNull(dw_account.getItemDatetime(ll_row, "period_end")) then
//				MessageBox("Validation Error","Last row must have period end equals NULL, and will be set by system")
//				dw_account.setItem(ll_row, "period_end", ldt_null)
//			end if
//		case 1
//			if isNull(dw_account.getItemDatetime(ll_row, "period_start")) then
//				MessageBox("Validation Error","Please enter a start date in first period!")
//				dw_account.POST setColumn("period_start")
//				dw_account.POST setFocus()
//				Return -1
//			end if
//			if isNull(dw_account.getItemDatetime(ll_row, "period_end")) then
//				MessageBox("Validation Error","Please enter a end date in first period!")
//				dw_account.POST setColumn("period_end")
//				dw_account.POST setFocus()
//				Return -1
//			end if
//			if dw_account.getItemDatetime(ll_row, "period_end") <= dw_account.getItemDatetime(ll_row, "period_start") then
//				MessageBox("Validation Error","End date must be > start date!")
//				dw_account.POST setColumn("period_end")
//				dw_account.POST setFocus()
//				Return -1
//			end if
//		case else
//			if isNull(dw_account.getItemDatetime(ll_row, "period_start")) then
//				MessageBox("Validation Error","Please enter a start date in row # "+string(ll_row))
//				dw_account.POST setColumn("period_start")
//				dw_account.POST setFocus()
//				Return -1
//			end if
//			if isNull(dw_account.getItemDatetime(ll_row, "period_end")) then
//				MessageBox("Validation Error","Please enter a end date in row # "+string(ll_row))
//				dw_account.POST setColumn("period_end")
//				dw_account.POST setFocus()
//				Return -1
//			end if
//			if dw_account.getItemDatetime(ll_row, "period_end") <= dw_account.getItemDatetime(ll_row, "period_start") then
//				MessageBox("Validation Error","End date must be > start date in row # "+string(ll_row))
//				dw_account.POST setColumn("period_end")
//				dw_account.POST setFocus()
//				Return -1
//			end if
//			if dw_account.getItemDatetime(ll_row -1, "period_end") <> dw_account.getItemDatetime(ll_row, "period_start") then
//				MessageBox("Validation Error","Start date must be = end date in previous period, and will be set be system.")
//				dw_account.setItem(ll_row, "period_start", dw_account.getItemDatetime(ll_row -1, "period_end")) 
//			end if
//			if dw_account.getItemDatetime(ll_row, "period_end") <> dw_account.getItemDatetime(ll_row +1, "period_start") then
//				MessageBox("Validation Error","End date must be = start date in next period, and will be set be system.")
//				dw_account.setItem(ll_row +1, "period_start", dw_account.getItemDatetime(ll_row, "period_end")) 
//			end if
//	end choose
//	// validate other fields
//	if isNull(dw_account.getItemString(ll_row, "coda_el_3")) then
//		MessageBox("Validation Error","Please enter CODA Element 3 in row # "+string(ll_row))
//		dw_account.POST setColumn("coda_el_3")
//		dw_account.POST setFocus()
//		Return -1
//	end if
//	if isNull(dw_account.getItemString(ll_row, "coda_el_4")) then
//		MessageBox("Validation Error","Please enter CODA Element 4 in row # "+string(ll_row))
//		dw_account.POST setColumn("coda_el_4")
//		dw_account.POST setFocus()
//		Return -1
//	end if
//	if isNull(dw_account.getItemNumber(ll_row, "coda_el_5_vessel_or_dept")) then
//		MessageBox("Validation Error","Please enter CODA Element 5 in row # "+string(ll_row))
//		dw_account.POST setColumn("coda_el_5_vessel_or_dept")
//		dw_account.POST setFocus()
//		Return -1
//	end if
//next
///* *** END validate accounts */

return 1

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

public function integer wf_update ();int 		li_next_broker_nr, li_count, li_broker_blocked
long		ll_rows, ll_row, ll_acc
string	ls_account_no, ls_acc_new

/* Get next broker number if new broker */
if il_broker_nr = 0 then
	SELECT max(BROKER_NR)
		INTO :li_next_broker_nr
		FROM BROKERS;
	COMMIT;
	if IsNull(li_next_broker_nr) then
		il_broker_nr = 1
	else 
		il_broker_nr = li_next_broker_nr +1
	end if
	tab_1.tabpage_1.dw_1.SetItem(1,"broker_nr", il_broker_nr)
end if

ll_rows = tab_1.tabpage_2.dw_account.rowCount()
/* Find out if cleanup of accounts is required or if broker number has to be set */
if ll_rows > 0 then
	if tab_1.tabpage_1.dw_1.getItemNumber(1, "broker_pool_manager") = 0 then
		for ll_row = 1 to ll_rows
			tab_1.tabpage_2.dw_account.deleteRow(0)
		next
	else
		for ll_row = 1 to ll_rows
			tab_1.tabpage_2.dw_account.setItem(ll_row, "broker_nr", il_broker_nr)
		next
	end if
end if

/* Check if Broker is already blocked from AX */
li_next_broker_nr = tab_1.tabpage_1.dw_1.getItemNumber(1,"broker_nr")
ls_account_no = tab_1.tabpage_1.dw_1.getItemString(1, "nom_acc_nr")
SELECT COUNT(*) 
	INTO :li_count
	FROM BROKERS
	WHERE BROKER_NR <> :li_next_broker_nr
	AND NOM_ACC_NR = :ls_account_no
	AND BROKER_BLOCKED = 1;
if li_count > 0 then
	MessageBox("Error","Entered Account number is blocked in AX.",StopSign!)
	Return -1
end if

//unblock an entry
SELECT NOM_ACC_NR, BROKER_BLOCKED
	INTO :ll_acc, :li_broker_blocked
	FROM BROKERS
	WHERE BROKER_NR = :li_next_broker_nr;
ls_acc_new = tab_1.tabpage_1.dw_1.getItemString(1,"nom_acc_nr")
if tab_1.tabpage_1.dw_1.getItemNumber(1,"broker_blocked") = 0 and li_broker_blocked = 1 then
	if ls_acc_new = string(ll_acc) then
		messagebox("","Please enter a different 'Nominal Acc. Nr' when unblocking!")
		tab_1.tabpage_1.dw_1.setColumn( "nom_acc_nr" )
		tab_1.tabpage_1.dw_1.post setfocus()
		Return 0
	else
		string ls_blocked_note, ls_supplier_number, ls_supplier_name
		datetime ldt_blocked_date
		ls_blocked_note = "Unblocked, Nominal Acc. Nr changed from " + string(ll_acc) + " to " + ls_acc_new
		ldt_blocked_date = DateTime(Today(),Now())
		ls_supplier_name = tab_1.tabpage_1.dw_1.getItemString(1,"broker_n_1")
		INSERT INTO BLOCKED_VENDOR_LOG (BLOCKED_DATE, BLOCKED, TRAMOS_TYPE, SUPPLIER_NUMBER, SUPPLIER_NAME, TRAMOS_NAME, BLOCKED_NOTE)
		VALUES (:ldt_blocked_date, 0,"B",:ls_acc_new,:ls_supplier_name,:uo_global.gos_userid,:ls_blocked_note);
	end if
end if

if tab_1.tabpage_1.dw_1.Update(TRUE, FALSE) = 1 then
	if tab_1.tabpage_2.dw_account.Update(TRUE, FALSE) = 1 then
		tab_1.tabpage_1.dw_1.ResetUpdate() 						// Both updates are OK
		tab_1.tabpage_2.dw_account.ResetUpdate()						// Clear update flags
		return 1 							  				
	else
		return -1		 										// 2nd update failed
	end if
else
	return -1		 											// 1st update failed
end if
end function

on w_brokerlist.create
int iCurrent
call super::create
this.st_notice=create st_notice
this.st_notify2=create st_notify2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_notice
this.Control[iCurrent+2]=this.st_notify2
end on

on w_brokerlist.destroy
call super::destroy
destroy(this.st_notice)
destroy(this.st_notify2)
end on

event open;call super::open;Integer li_profile

// Init datawindows
dw_dddw.setTransObject(SQLCA)
dw_list.setTransObject(SQLCA)
tab_1.tabpage_2.dw_account.SetTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
dw_list.Retrieve()

il_Broker_nr = Message.DoubleParm
If IsNull(il_Broker_nr) then il_Broker_nr = 0

// Sort and select
Long ll_Found
dw_list.SetSort("broker_sn")
dw_list.Sort( )
If il_Broker_nr = 0 then
	ll_Found = 1
Else
	ll_Found = dw_List.Find("broker_nr = " + String(il_Broker_nr), 0, dw_List.RowCount())
	If ll_Found <= 0 then ll_Found = 1
End If
dw_list.event Clicked(0, 0, ll_Found, dw_list.object)
dw_List.ScrollToRow(ll_Found)

// Initialize search box
uo_SearchBox.of_initialize(dw_List, "broker_sn+'~'+broker_name")
uo_SearchBox.sle_search.POST setfocus()

/* Only Finance superuser can modify "Pool Manager" status */
if uo_global.ii_access_level <> 2 or uo_global.ii_user_profile < 3 then
	tab_1.tabpage_1.dw_1.Object.broker_pool_manager.TabSequence='0'
end if

/* Only Finance Profile or Admin can modify Brokers -   If user is not admin and is not finance then disable*/
If uo_global.ii_access_level < 3 and uo_global.ii_user_profile < 3 then
	tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='Yes'
	tab_1.tabpage_2.dw_account.Object.DataWindow.ReadOnly='Yes'
	tab_1.tabpage_2.cb_newacc.enabled = false
	tab_1.tabpage_2.cb_delacc.enabled = false	
	st_notify2.visible = True	
	cb_update.enabled = False
	cb_New.Enabled = False
	cb_Cancel.Enabled = False
	cb_Delete.Enabled = False
	return
End if
end event

event closequery;call super::closequery;
If uf_updatespending() = 0 Then Return 0

If cb_update.event clicked() = -1 Then Return 1 Else Return 0
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_brokerlist
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_brokerlist
integer y = 32
integer width = 1371
end type

type st_1 from w_coredata_ancestor`st_1 within w_brokerlist
boolean visible = false
integer x = 987
integer y = 48
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_brokerlist
boolean visible = false
integer x = 841
integer y = 128
end type

type dw_list from w_coredata_ancestor`dw_list within w_brokerlist
integer y = 288
integer width = 1371
integer height = 1952
string dataobject = "dw_broker_list"
end type

event dw_list::clicked;call super::clicked;// Call ancestor Clicked event to perform sorting
// Super::Event Clicked(xpos, ypos, row, dwo)

If row < 1 then return

If uf_updatespending() = -1 then 
	cb_Update.Event Clicked()
	Return
End If

setPointer(hourGlass!)

il_broker_nr = dw_list.getItemNumber(row, "broker_nr")

dw_list.selectRow(0,false)
dw_list.selectRow(row,true)

//Retrieve tabpages
tab_1.tabpage_1.dw_1.Retrieve(il_Broker_nr)

If (tab_1.tabpage_1.dw_1.getItemNumber(1, "broker_pool_manager") = 1) and ((uo_global.ii_access_level = 2)  or (uo_global.ii_user_profile = 3)) then
	tab_1.tabpage_2.dw_account.retrieve(tab_1.tabpage_1.dw_1.getItemNumber(1, "broker_nr"))
	tab_1.tabpage_2.cb_NewAcc.enabled = true
	tab_1.tabpage_2.cb_DelAcc.enabled = true
Else
	tab_1.tabpage_2.cb_NewAcc.enabled = false
	tab_1.tabpage_2.cb_DelAcc.enabled = false
End if

if cb_cancel.enabled then
//set datawindow read-only when blocked, only finance superuser can unblock
if tab_1.tabpage_1.dw_1.getitemnumber(1, "broker_blocked") = 1 then
	If uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 then
		tab_1.tabpage_1.dw_1.settaborder("broker_blocked", 600)
	else
		tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='Yes'
		cb_update.enabled = false /* Update button */
		st_notice.visible = true
	end if
Else
	tab_1.tabpage_1.dw_1.settaborder("broker_blocked", 0)
	tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='No'
	cb_update.enabled = true /* Update button */
	st_notice.visible = false
End if
end if

SetPointer(Arrow!)
end event

type cb_close from w_coredata_ancestor`cb_close within w_brokerlist
integer x = 3931
integer y = 2256
end type

event cb_close::clicked;call super::clicked;
Close(Parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_brokerlist
integer x = 3493
integer y = 2256
end type

event cb_cancel::clicked;call super::clicked;// Triggers the Clickedevent of dw_list
tab_1.tabpage_1.dw_1.reset()

dw_list.event Clicked(0,0,dw_list.Getrow(),dw_list.object)

cb_new.enabled = (dw_list.rowcount() > 0)
cb_delete.enabled = cb_new.enabled
cb_update.enabled = cb_new.enabled
cb_cancel.enabled = cb_new.enabled

end event

type cb_delete from w_coredata_ancestor`cb_delete within w_brokerlist
integer x = 3054
integer y = 2256
end type

event cb_delete::clicked;call super::clicked;Long ll_row

ll_row = dw_list.GetSelectedRow(0)

If ll_Row <> 0 Then
	If MessageBox("Delete","You are about to DELETE the broker!~r~nAre you sure you want to continue?",Question!,YesNo!,2) = 2 Then Return
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
		tab_1.tabpage_2.dw_account.Reset()
		tab_1.tabpage_2.cb_Delacc.Enabled = False
		tab_1.tabpage_2.cb_Newacc.Enabled = False
		cb_Update.Enabled = False
	End If			
end if
end event

type cb_new from w_coredata_ancestor`cb_new within w_brokerlist
integer x = 2158
integer y = 2256
end type

event cb_new::clicked;call super::clicked;If uf_updatesPending() = -1 then return

tab_1.tabpage_1.dw_1.Reset()
tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_1.dw_1.setFocus()

tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly='No'

tab_1.tabpage_1.dw_1.SetItem(1,"broker_custsupp",0)
tab_1.tabpage_1.dw_1.SetItem(1,"broker_pool_manager",0)
tab_1.tabpage_1.dw_1.SetItem(1,"broker_active",1)

cb_new.enabled = false
cb_delete.enabled = false
cb_update.enabled = true
cb_cancel.enabled = true

il_broker_nr = 0

end event

type cb_update from w_coredata_ancestor`cb_update within w_brokerlist
integer x = 2597
integer y = 2256
end type

event cb_update::clicked;call super::clicked;Long ll_GetRow

If wf_validate() = -1 then Return -1

// Perform update
If wf_update() = 1 Then
	Commit;
Else
	Rollback;
	Return -1
End If

// Set buttons
cb_update.enabled = true
cb_cancel.enabled = true
cb_new.enabled = true
cb_delete.enabled = true

// Retrieve and select from main list
dw_list.Retrieve()
dw_list.Sort()
ll_GetRow = dw_list.Find("broker_nr = " + string(tab_1.tabpage_1.dw_1.GetItemNumber(1, "broker_nr" ) ), 1, dw_list.rowCount() ) 
If ll_GetRow = 0 then  // In case unable to find due to filter, remove filter and find again
	uo_searchbox.cb_clear.event clicked( )
	ll_GetRow = dw_list.Find("broker_nr = " + string(tab_1.tabpage_1.dw_1.GetItemNumber(1, "broker_nr" ) ), 1, dw_list.rowCount() ) 	
End If
dw_list.event Clicked( 0, 0, ll_GetRow, dw_list.object )
dw_list.scrollToRow(ll_getrow)

Return 1

end event

type st_list from w_coredata_ancestor`st_list within w_brokerlist
integer y = 224
string text = "Brokers:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_brokerlist
event create ( )
event destroy ( )
integer x = 1463
integer y = 16
integer width = 2871
integer height = 2224
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
integer width = 2834
integer height = 2108
string text = "Broker Information"
end type

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
integer x = 18
integer y = 24
integer width = 2798
integer height = 2064
string dataobject = "dw_broker"
end type

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 2834
integer height = 2108
boolean enabled = false
long backcolor = 67108864
string text = "Pool Management Fee"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_delacc cb_delacc
cb_newacc cb_newacc
dw_account dw_account
end type

on tabpage_2.create
this.cb_delacc=create cb_delacc
this.cb_newacc=create cb_newacc
this.dw_account=create dw_account
this.Control[]={this.cb_delacc,&
this.cb_newacc,&
this.dw_account}
end on

on tabpage_2.destroy
destroy(this.cb_delacc)
destroy(this.cb_newacc)
destroy(this.dw_account)
end on

type cb_delacc from commandbutton within tabpage_2
integer x = 256
integer y = 520
integer width = 238
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;long	ll_row
datetime ldt_null

if dw_account.rowCount() = 1 then return

ll_row = dw_account.getRow()
choose case ll_row
	case 1
		dw_account.deleterow(ll_row)
		if dw_account.rowcount() = 1 then
			setNull(ldt_null)
			dw_account.setItem(dw_account.rowCount(), "period_end", ldt_null)
		end if			
	case dw_account.rowCount()
		dw_account.deleterow(ll_row)
		setNull(ldt_null)
		dw_account.setItem(dw_account.rowCount(), "period_end", ldt_null)
	case else
		dw_account.setItem(ll_row +1, "period_start", dw_account.getItemDateTime(ll_row -1, "period_end"))
		dw_account.deleterow(ll_row)
end choose

end event

type cb_newacc from commandbutton within tabpage_2
integer x = 18
integer y = 520
integer width = 238
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&New"
end type

event clicked;long ll_row

ll_row = dw_account.insertRow(0)
dw_account.setItem(ll_row, "coda_el_5_vessel_or_dept", 0)
if ll_row = 1 then 
	dw_account.post setColumn("period_start")
else	
	dw_account.post setColumn("period_end")
end if	
dw_account.post setFocus()
dw_account.scrolltorow(ll_row -1)
end event

type dw_account from uo_datawindow within tabpage_2
integer x = 18
integer y = 40
integer width = 2798
integer height = 480
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_sq_tb_pool_management_account_number"
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;if row < 1 then return

if dwo.name = "period_end" then
	dw_account.AcceptText()
	dw_account.setItem(row +1, "period_start", dw_account.getItemdatetime(row, "period_end"))
end if

end event

type st_notice from statictext within w_brokerlist
boolean visible = false
integer x = 37
integer y = 2256
integer width = 1362
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Only users with Finance profile can modify Brokers!"
boolean focusrectangle = false
end type

type st_notify2 from statictext within w_brokerlist
boolean visible = false
integer x = 37
integer y = 2320
integer width = 1792
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Only administrator can modify Pool Management Fee related data!"
boolean focusrectangle = false
end type

