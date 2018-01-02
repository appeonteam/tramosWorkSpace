$PBExportHeader$w_broker.srw
$PBExportComments$Window for editing brokers
forward
global type w_broker from window
end type
type st_notify2 from statictext within w_broker
end type
type cb_new from commandbutton within w_broker
end type
type cb_delete from commandbutton within w_broker
end type
type dw_account from uo_datawindow within w_broker
end type
type st_notice from statictext within w_broker
end type
type cb_update from commandbutton within w_broker
end type
type cb_cancel from commandbutton within w_broker
end type
type dw_broker from uo_datawindow within w_broker
end type
end forward

global type w_broker from window
integer x = 672
integer y = 264
integer width = 2871
integer height = 2692
boolean titlebar = true
string title = "Brokers"
boolean controlmenu = true
windowtype windowtype = child!
long backcolor = 81324524
st_notify2 st_notify2
cb_new cb_new
cb_delete cb_delete
dw_account dw_account
st_notice st_notice
cb_update cb_update
cb_cancel cb_cancel
dw_broker dw_broker
end type
global w_broker w_broker

type variables
long il_broker_nr
end variables

forward prototypes
public function integer wf_validate ()
private function integer wf_update ()
end prototypes

public function integer wf_validate ();string ls_broker_sn, ls_account_no, ls_countryName
integer li_count, li_intr_suppl
long ll_count, ll_rows, ll_row, ll_countryID, ll_found
datetime ldt_null
setNull(ldt_null)
datawindowchild dwc

dw_broker.AcceptText()
dw_account.AcceptText()

/* *** START BASE *** First check that Broker base information is correct */
IF IsNull(dw_broker.GetItemString(1,"broker_sn")) THEN
	MessageBox("Update Error","Please enter a broker Short Name!")
	dw_broker.POST setColumn("broker_sn")
	dw_broker.POST setFocus()
	Return -1
END IF	

IF IsNull(dw_broker.GetItemstring(1,"broker_name")) THEN
	MessageBox("Update Error","Please enter a broker Full Name (Blue Line)!")
	dw_broker.POST setColumn("broker_name")
	dw_broker.POST setFocus()
	Return -1
END IF	

ls_broker_sn = dw_broker.GetItemString(1,"broker_sn")
SELECT count(*)
INTO :li_count
FROM BROKERS
WHERE BROKER_SN = :ls_broker_sn;
IF (il_broker_nr = 0 AND li_count = 1) THEN
	MessageBox("Duplicate","You are creating a duplicate broker. Broker ShortName must be unique!")
	dw_broker.POST setColumn("broker_sn")
	dw_broker.POST setFocus()
	Return -1
END IF

// Validate the contents of "Nominal acc. number"
li_intr_suppl = dw_broker.GetItemNumber(1, "broker_custsupp")
ls_account_no = dw_broker.GetItemString(1, "nom_acc_nr")

IF isNull(ls_account_no) THEN
	MessageBox("Error","Please enter the nominal account number")
	dw_broker.POST setColumn("nom_acc_nr")
	dw_broker.POST setFocus()
	Return -1
END IF

// Validate country
ll_countryID = dw_broker.GetItemNumber(1, "country_id")

if isNull(ll_countryID) then
	MessageBox("Error","Please select country")
	dw_broker.setColumn( "country_id" )
	dw_broker.post setfocus()
	Return -1
end if	
dw_broker.getchild( "country_id", dwc)
ll_found = dwc.find( "country_id="+string(ll_countryID) , 1, 9999 )
if ll_found < 1 then 
	MessageBox("Error","Please select country")
	dw_broker.setColumn( "country_id" )
	dw_broker.post setfocus()
	Return -1
end if	
ls_countryName = dwc.getItemString(ll_found, "country_name")
dw_broker.setItem(1, "broker_c", ls_countryName)

IF li_intr_suppl = 0 THEN
	// Not internal supplier - numeric(5)
	IF NOT(IsNumber(ls_account_no)) OR (Len(ls_account_no) < 5) OR (Len(ls_account_no) > 5) THEN
		MessageBox("Error","The nominal account number must have exactly five digits")
		dw_broker.POST setColumn("nom_acc_nr")
		dw_broker.POST setFocus()
		Return -1
	END IF
ELSE
	// Internal supplier - text(3)
	IF (Len(ls_account_no) < 3) OR (Len(ls_account_no) > 3) THEN
		MessageBox("Error","The nominal account number must have exactly three characters")
		dw_broker.POST setColumn("nom_acc_nr")
		dw_broker.POST setFocus()
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

private function integer wf_update ();int 		li_next_broker_nr, li_count, li_broker_blocked
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
	dw_broker.SetItem(1,"broker_nr", il_broker_nr)
end if

ll_rows = dw_account.rowCount()
/* Find out if cleanup of accounts is required or if broker number has to be set */
if ll_rows > 0 then
	if dw_broker.getItemNumber(1, "broker_pool_manager") = 0 then
		for ll_row = 1 to ll_rows
			dw_account.deleteRow(0)
		next
	else
		for ll_row = 1 to ll_rows
			dw_account.setItem(ll_row, "broker_nr", il_broker_nr)
		next
	end if
end if

/* Check if Broker is already blocked from AX */
li_next_broker_nr = dw_broker.getItemNumber(1,"broker_nr")
ls_account_no = dw_broker.getItemString(1, "nom_acc_nr")
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
ls_acc_new = dw_broker.getItemString(1,"nom_acc_nr")
if dw_broker.getItemNumber(1,"broker_blocked") = 0 and li_broker_blocked = 1 then
	if ls_acc_new = string(ll_acc) then
		messagebox("","Please enter a different 'Nominal Acc. Nr' when unblocking!")
		dw_broker.setColumn( "nom_acc_nr" )
		dw_broker.post setfocus()
		Return 0
	else
		string ls_blocked_note, ls_supplier_number, ls_supplier_name
		datetime ldt_blocked_date
		ls_blocked_note = "Unblocked, Nominal Acc. Nr changed from " + string(ll_acc) + " to " + ls_acc_new
		ldt_blocked_date = DateTime(Today(),Now())
		ls_supplier_name = dw_broker.getItemString(1,"broker_n_1")
		INSERT INTO BLOCKED_VENDOR_LOG (BLOCKED_DATE, BLOCKED, TRAMOS_TYPE, SUPPLIER_NUMBER, SUPPLIER_NAME, TRAMOS_NAME, BLOCKED_NOTE)
		VALUES (:ldt_blocked_date, 0,"B",:ls_acc_new,:ls_supplier_name,:uo_global.gos_userid,:ls_blocked_note);
	end if
end if

if dw_broker.Update(TRUE, FALSE) = 1 then
	if dw_account.Update(TRUE, FALSE) = 1 then
		dw_broker.ResetUpdate() 						// Both updates are OK
		dw_account.ResetUpdate()						// Clear update flags
		return 1 							  				
	else
		return -1		 										// 2nd update failed
	end if
else
	return -1		 											// 1st update failed
end if
end function

event open;integer li_profile

this.move(0,0)
il_broker_nr = message.DoubleParm
dw_broker.SetTransObject(SQLCA)
dw_account.SetTransObject(SQLCA)
IF il_broker_nr = 0 THEN
	dw_broker.InsertRow(0)
	this.title = "Broker - NEW"
	dw_broker.SetItem(dw_broker.GetRow(),"broker_custsupp",0)
	dw_broker.SetItem(dw_broker.GetRow(),"broker_pool_manager",0)
	dw_broker.SetItem(dw_broker.GetRow(),"broker_active",1)
ELSE
	dw_broker.Retrieve(il_broker_nr)
	this.title = "Broker - MODIFY"
	if dw_broker.getItemNumber(1, "broker_pool_manager") = 1 then 
		dw_account.retrieve(dw_broker.getItemNumber(1, "broker_nr"))
		cb_new.enabled = true
		cb_delete.enabled = true
	end if
END IF	
dw_broker.SetFocus()

//set datawindow read-only when blocked, only finance superuser can unblock
if dw_broker.getitemnumber( 1, "broker_blocked") = 1 then
	if uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 then
		dw_broker.settaborder("broker_blocked",600)
	else
		dw_broker.Object.DataWindow.ReadOnly='Yes'
		cb_update.enabled = false /* Update button */
		st_notice.visible = true
	end if
end if

/* Only Administrator can modify "Pool Manager" */
if uo_global.ii_access_level = 3 then
	//
else
	dw_broker.Object.broker_pool_manager.TabSequence='0'
end if

/* Only Administrator and Finance Profile can modify Brokers */
if uo_global.ii_access_level = 3  or uo_global.ii_user_profile = 3 then
	//
else
	dw_broker.Object.DataWindow.ReadOnly='Yes'
	dw_account.Object.DataWindow.ReadOnly='Yes'
	cb_new.enabled = false
	cb_delete.enabled = false
	cb_update.enabled = false /* Update button */
	st_notify2.visible = true
	return
end if
end event

on w_broker.create
this.st_notify2=create st_notify2
this.cb_new=create cb_new
this.cb_delete=create cb_delete
this.dw_account=create dw_account
this.st_notice=create st_notice
this.cb_update=create cb_update
this.cb_cancel=create cb_cancel
this.dw_broker=create dw_broker
this.Control[]={this.st_notify2,&
this.cb_new,&
this.cb_delete,&
this.dw_account,&
this.st_notice,&
this.cb_update,&
this.cb_cancel,&
this.dw_broker}
end on

on w_broker.destroy
destroy(this.st_notify2)
destroy(this.cb_new)
destroy(this.cb_delete)
destroy(this.dw_account)
destroy(this.st_notice)
destroy(this.cb_update)
destroy(this.cb_cancel)
destroy(this.dw_broker)
end on

type st_notify2 from statictext within w_broker
boolean visible = false
integer x = 567
integer y = 2500
integer width = 1659
integer height = 72
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

type cb_new from commandbutton within w_broker
integer y = 2436
integer width = 238
integer height = 80
integer taborder = 20
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

type cb_delete from commandbutton within w_broker
integer x = 270
integer y = 2436
integer width = 238
integer height = 80
integer taborder = 20
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

type dw_account from uo_datawindow within w_broker
integer y = 2180
integer width = 2798
integer height = 232
integer taborder = 40
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

type st_notice from statictext within w_broker
boolean visible = false
integer x = 713
integer y = 2432
integer width = 1362
integer height = 72
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

type cb_update from commandbutton within w_broker
integer x = 2281
integer y = 2436
integer width = 238
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update"
boolean default = true
end type

event clicked;int li_next_broker_nr

if wf_validate() = -1 then return

IF wf_update() = 1 THEN
	commit;
	Close(parent)
ELSE
	rollback;
END IF
end event

type cb_cancel from commandbutton within w_broker
integer x = 2555
integer y = 2436
integer width = 238
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

on clicked;close(parent)
end on

type dw_broker from uo_datawindow within w_broker
integer y = 16
integer width = 2798
integer height = 2156
integer taborder = 30
string dataobject = "dw_broker"
end type

event itemchanged;call super::itemchanged;if row < 1 then return

///* This can only happen if user = administrator */
//if dwo.name = "broker_pool_manager" and data = "1" then
//	if dw_account.rowcount() = 0 then
//		dw_account.insertRow(0)
//		dw_account.setItem(1, "coda_el_5_vessel_or_dept", 0)
//		cb_new.enabled = true
//		cb_delete.enabled = true
//	end if
//end if
	
end event

