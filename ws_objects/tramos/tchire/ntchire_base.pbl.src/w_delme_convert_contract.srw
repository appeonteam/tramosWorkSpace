$PBExportHeader$w_delme_convert_contract.srw
$PBExportComments$delete after conversion is finished
forward
global type w_delme_convert_contract from window
end type
type st_5 from statictext within w_delme_convert_contract
end type
type cb_14 from commandbutton within w_delme_convert_contract
end type
type dw_bunker from datawindow within w_delme_convert_contract
end type
type st_4 from statictext within w_delme_convert_contract
end type
type st_3 from statictext within w_delme_convert_contract
end type
type st_2 from statictext within w_delme_convert_contract
end type
type cb_13 from commandbutton within w_delme_convert_contract
end type
type cb_12 from commandbutton within w_delme_convert_contract
end type
type cb_11 from commandbutton within w_delme_convert_contract
end type
type dw_portexp from datawindow within w_delme_convert_contract
end type
type cb_10 from commandbutton within w_delme_convert_contract
end type
type st_1 from statictext within w_delme_convert_contract
end type
type em_exrate from editmask within w_delme_convert_contract
end type
type cb_9 from commandbutton within w_delme_convert_contract
end type
type cb_8 from commandbutton within w_delme_convert_contract
end type
type cb_7 from commandbutton within w_delme_convert_contract
end type
type cb_6 from commandbutton within w_delme_convert_contract
end type
type cb_5 from commandbutton within w_delme_convert_contract
end type
type cb_4 from commandbutton within w_delme_convert_contract
end type
type cb_3 from commandbutton within w_delme_convert_contract
end type
type dw_paid from datawindow within w_delme_convert_contract
end type
type cb_2 from commandbutton within w_delme_convert_contract
end type
type cb_1 from commandbutton within w_delme_convert_contract
end type
type cb_delete from commandbutton within w_delme_convert_contract
end type
type dw_contract from datawindow within w_delme_convert_contract
end type
type dw_payments from datawindow within w_delme_convert_contract
end type
type dw_list from datawindow within w_delme_convert_contract
end type
end forward

global type w_delme_convert_contract from window
integer width = 4421
integer height = 2948
boolean titlebar = true
string title = "Data Conversion"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
st_5 st_5
cb_14 cb_14
dw_bunker dw_bunker
st_4 st_4
st_3 st_3
st_2 st_2
cb_13 cb_13
cb_12 cb_12
cb_11 cb_11
dw_portexp dw_portexp
cb_10 cb_10
st_1 st_1
em_exrate em_exrate
cb_9 cb_9
cb_8 cb_8
cb_7 cb_7
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
dw_paid dw_paid
cb_2 cb_2
cb_1 cb_1
cb_delete cb_delete
dw_contract dw_contract
dw_payments dw_payments
dw_list dw_list
end type
global w_delme_convert_contract w_delme_convert_contract

type variables
long il_contract_id

end variables

forward prototypes
public function integer wf_check_paymentid (ref datawindow adw)
public function integer wf_deleteattachment ()
end prototypes

public function integer wf_check_paymentid (ref datawindow adw);long ll_rows, ll_row

ll_rows = adw.rowcount()
if ll_rows < 1 then return 1

for ll_row = 1 to ll_rows
	//Messagebox(string(dw_payments.find("payment_id="+string(adw.getItemNumber(ll_row, "payment_id")),1,99999999)), "payment_id="+string(adw.getItemNumber(ll_row, "payment_id")))
	if dw_payments.find("payment_id="+string(adw.getItemNumber(ll_row, "payment_id")),1,99999999) < 1 then
		MessageBox("Error", "Payment id not entered correct in row# "+string(ll_row)+" in datawindow "+adw.DataObject)
		return -1
	end if
next

return 1

end function

public function integer wf_deleteattachment ();datastore ds_file
int li_i
long ll_file_id
string ls_attachtablename,ls_sqlerrtext
n_service_manager 	lnv_serviceMgr
n_fileattach_service 	lnv_attachmentservice

ds_file = create datastore
ds_file.dataobject = 'd_sq_ff_ntc_tc_action_files'
ds_file.settransobject(sqlca)

ds_file.retrieve(il_contract_id)
if ds_file.rowcount() < 1 then return c#return.Success

DELETE FROM NTC_TC_ACTION
WHERE NTC_TC_ACTION.CONTRACT_ID = :il_contract_id;

if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_TC_ACTION sqlerrtext= "+ls_sqlerrtext) 
	return c#return.Failure
end if

lnv_serviceMgr.of_loadservice( lnv_attachmentService, "n_fileattach_service" )
lnv_attachmentservice.of_activate()
ls_attachtablename = "ATTACHMENTS_FILES"	
//Delete attachments files from file database
for li_i = 1 to ds_file.rowcount()
	ll_file_id = ds_file.getitemnumber(li_i,'file_id')
	DELETE FROM ATTACHMENTS
	WHERE ATTACHMENTS.FILE_ID = :ll_file_id;
	if SQLCA.SQLCODE <> 0 then 
		ls_sqlerrtext = sqlca.sqlerrtext
		rollback;
		MessageBox("Delete Error", "Error while deleting table ATTACHMENTS sqlerrtext= "+ls_sqlerrtext) 
		return c#return.Failure
	end if
	
	if lnv_attachmentService.of_deleteblob(ls_attachtablename,ll_file_id,false) = 0 then
		ls_sqlerrtext = sqlca.sqlerrtext
		ROLLBACK USING SQLCA;
		lnv_attachmentservice.of_rollback( )
		MessageBox("Delete Error", "Error while deleting table ATTACHMENTS_FILES from file database sqlerrtext= "+ls_sqlerrtext) 
		destroy lnv_attachmentservice
		return c#return.Failure
	end if
	
next


return c#return.Success
	
end function

on w_delme_convert_contract.create
this.st_5=create st_5
this.cb_14=create cb_14
this.dw_bunker=create dw_bunker
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.cb_13=create cb_13
this.cb_12=create cb_12
this.cb_11=create cb_11
this.dw_portexp=create dw_portexp
this.cb_10=create cb_10
this.st_1=create st_1
this.em_exrate=create em_exrate
this.cb_9=create cb_9
this.cb_8=create cb_8
this.cb_7=create cb_7
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.dw_paid=create dw_paid
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_delete=create cb_delete
this.dw_contract=create dw_contract
this.dw_payments=create dw_payments
this.dw_list=create dw_list
this.Control[]={this.st_5,&
this.cb_14,&
this.dw_bunker,&
this.st_4,&
this.st_3,&
this.st_2,&
this.cb_13,&
this.cb_12,&
this.cb_11,&
this.dw_portexp,&
this.cb_10,&
this.st_1,&
this.em_exrate,&
this.cb_9,&
this.cb_8,&
this.cb_7,&
this.cb_6,&
this.cb_5,&
this.cb_4,&
this.cb_3,&
this.dw_paid,&
this.cb_2,&
this.cb_1,&
this.cb_delete,&
this.dw_contract,&
this.dw_payments,&
this.dw_list}
end on

on w_delme_convert_contract.destroy
destroy(this.st_5)
destroy(this.cb_14)
destroy(this.dw_bunker)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_13)
destroy(this.cb_12)
destroy(this.cb_11)
destroy(this.dw_portexp)
destroy(this.cb_10)
destroy(this.st_1)
destroy(this.em_exrate)
destroy(this.cb_9)
destroy(this.cb_8)
destroy(this.cb_7)
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.dw_paid)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_delete)
destroy(this.dw_contract)
destroy(this.dw_payments)
destroy(this.dw_list)
end on

event open;openwithparm(w_delme_convert_password,"nottubesutnod")  

if message.doubleParm = 1 then 
	dw_list.settransobject(sqlca)
	dw_contract.settransobject(sqlca)
	dw_payments.settransobject(sqlca)
	dw_paid.settransobject(sqlca)
	dw_portexp.settransobject(sqlca)
	dw_bunker.settransobject(sqlca)
	dw_list.retrieve()
else
	POST close(this)
end if
end event

type st_5 from statictext within w_delme_convert_contract
integer x = 41
integer y = 2332
integer width = 823
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bunker on Delivery / Re-delivery:"
boolean focusrectangle = false
end type

type cb_14 from commandbutton within w_delme_convert_contract
integer x = 2702
integer y = 2724
integer width = 453
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update Bunker"
end type

event clicked;dw_bunker.accepttext()
if wf_check_paymentid(dw_bunker) = -1 then return
if dw_bunker.update() = 1 then
	commit;
else
	messageBox("","Update failed!")
end if
end event

type dw_bunker from datawindow within w_delme_convert_contract
integer x = 41
integer y = 2400
integer width = 2615
integer height = 432
integer taborder = 110
string title = "none"
string dataobject = "d_delme_convert_move_bp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_delme_convert_contract
integer x = 41
integer y = 1780
integer width = 402
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port Expenses:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_delme_convert_contract
integer x = 3355
integer y = 572
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Already Paid:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_delme_convert_contract
integer x = 846
integer y = 572
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Payments:"
boolean focusrectangle = false
end type

type cb_13 from commandbutton within w_delme_convert_contract
integer x = 3296
integer y = 1964
integer width = 453
integer height = 100
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "U&pdate PortExp"
end type

event clicked;dw_portexp.accepttext()
if wf_check_paymentid(dw_portexp) = -1 then return
if dw_portexp.update() = 1 then
	commit;
else
	messageBox("","Update failed!")
end if
end event

type cb_12 from commandbutton within w_delme_convert_contract
integer x = 3296
integer y = 1836
integer width = 453
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New PortExp"
end type

event clicked;long ll_row

ll_row = dw_portexp.insertRow(0)

if ll_row < 1 then return

dw_portexp.setItem(ll_row, "payment_id", dw_payments.getItemNumber(dw_payments.getrow(), "payment_id"))
dw_portexp.setItem(ll_row, "exp_for_oa", 0)
dw_portexp.setItem(ll_row, "use_in_vas", 0)
dw_portexp.scrollToRow(ll_row)
dw_portexp.post setfocus()

end event

type cb_11 from commandbutton within w_delme_convert_contract
integer x = 3296
integer y = 2088
integer width = 453
integer height = 100
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete PortExp"
end type

event clicked;long ll_row

if MessageBox("Delete Request", "Do you realy want to delete this item", Question!,YesNo!,2) = 2 then return

ll_row = dw_portexp.getRow()

if ll_row < 1 then return

dw_portexp.deleteRow(ll_row)

dw_portexp.accepttext()
if wf_check_paymentid(dw_portexp) = -1 then return
if dw_portexp.update() = 1 then
	commit;
else
	MessageBox("Error", "Error when updating table")
	rollback;
end if

end event

type dw_portexp from datawindow within w_delme_convert_contract
integer x = 41
integer y = 1836
integer width = 3205
integer height = 480
integer taborder = 100
string title = "none"
string dataobject = "d_delme_convert_portexp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_10 from commandbutton within w_delme_convert_contract
integer x = 3671
integer y = 1696
integer width = 402
integer height = 76
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Received"
end type

event clicked;long ll_row

if MessageBox("Delete Request", "Do you realy want to delete this item", Question!,YesNo!,2) = 2 then return

ll_row = dw_paid.getRow()

if ll_row < 1 then return

dw_paid.accepttext()
if wf_check_paymentid(dw_paid) = -1 then return
dw_paid.deleteRow(ll_row)

if dw_paid.update() = 1 then
	commit;
else
	MessageBox("Error", "Error when updating table")
	rollback;
end if

end event

type st_1 from statictext within w_delme_convert_contract
integer x = 1806
integer y = 1632
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ex.rate to USD:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_exrate from editmask within w_delme_convert_contract
integer x = 2226
integer y = 1612
integer width = 457
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#,##0.000000"
end type

type cb_9 from commandbutton within w_delme_convert_contract
integer x = 2715
integer y = 1612
integer width = 434
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set Ex.Rate"
end type

event clicked;long ll_rows, ll_row

ll_rows = dw_payments.rowCount()

if ll_rows < 1 then return

for ll_row = 1 to ll_rows
	dw_payments.setItem(ll_row, "ex_rate_usd", dec(em_exrate.text))
next

end event

type cb_8 from commandbutton within w_delme_convert_contract
integer x = 3365
integer y = 1612
integer width = 402
integer height = 76
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Received"
end type

event clicked;long ll_row

ll_row = dw_paid.insertRow(0)

if ll_row < 1 then return

dw_paid.setItem(ll_row, "payment_id", dw_payments.getItemNumber(dw_payments.getrow(), "payment_id"))
dw_paid.scrollToRow(ll_row)
dw_paid.post setfocus()

end event

type cb_7 from commandbutton within w_delme_convert_contract
integer x = 3808
integer y = 320
integer width = 398
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_6 from commandbutton within w_delme_convert_contract
integer x = 41
integer y = 1696
integer width = 590
integer height = 76
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "CalcBalance all Payments"
end type

event clicked;long ll_pid, ll_rowno, ll_rows
string ls_sql

dw_payments.acceptText()
if dw_payments.ModifiedCount() > 0 then
	if messageBox("Update", "Payments data changed but not updated. Would you like to update before switching?", Question!, YesNo!,1) = 1 then
		if dw_payments.update() = 1 then
			commit;
		else
			MessageBox("Error", "Update failed!")
			rollback;
			return
		end if
	else
		dw_payments.resetUpdate()
	end if	
end if

ll_rows = dw_payments.rowCount()

if ll_rows > 0 then
	for ll_rowno = 1 to ll_rows 
		ll_pid = dw_payments.getItemNumber(ll_rowno, "payment_id")
		ls_sql = "sp_paymentBalance "+string(ll_pid)
		execute immediate :ls_sql;
		commit;
	next
end if

dw_payments.retrieve(dw_list.getItemNumber(dw_list.getrow(), "contract_id"))
end event

type cb_5 from commandbutton within w_delme_convert_contract
integer x = 41
integer y = 1608
integer width = 590
integer height = 76
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;dw_list.retrieve()
end event

type cb_4 from commandbutton within w_delme_convert_contract
integer x = 1321
integer y = 1612
integer width = 434
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Calc&Balance"
end type

event clicked;long ll_pid, row
string ls_sql

dw_payments.acceptText()
if dw_payments.ModifiedCount() > 0 then
	if messageBox("Update", "Payments data changed but not updated. Would you like to update before switching?", Question!, YesNo!,1) = 1 then
		if dw_payments.update() = 1 then
			commit;
		else
			MessageBox("Error", "Update failed!")
			rollback;
			return
		end if
	else
		dw_payments.resetUpdate()
	end if	
end if

row = dw_payments.getrow()

if row > 0 then
	ll_pid = dw_payments.getItemNumber(row, "payment_id")
	ls_sql = "sp_paymentBalance "+string(ll_pid)
	execute immediate :ls_sql;
	commit;
end if

dw_payments.retrieve(dw_list.getItemNumber(dw_list.getrow(), "contract_id"))
dw_payments.scrollToRow(dw_payments.find("payment_id="+string(ll_pid),1,9999999))
end event

type cb_3 from commandbutton within w_delme_convert_contract
integer x = 3986
integer y = 1612
integer width = 402
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "U&pdate Received"
end type

event clicked;dw_paid.accepttext()
if wf_check_paymentid(dw_paid) = -1 then return
if dw_paid.update() = 1 then
	commit;
else
	messageBox("","Update failed!")
end if
end event

type dw_paid from datawindow within w_delme_convert_contract
integer x = 3355
integer y = 628
integer width = 1033
integer height = 968
integer taborder = 30
string title = "none"
string dataobject = "d_delme_convert_paid"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_delme_convert_contract
integer x = 846
integer y = 1612
integer width = 434
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Update Payment"
end type

event clicked;dw_payments.accepttext()
if dw_payments.update() = 1 then
	commit;
else
	messageBox("","Update failed!")
end if
end event

type cb_1 from commandbutton within w_delme_convert_contract
integer x = 3808
integer y = 176
integer width = 398
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Fixture"
end type

event clicked;IF MESSAGEBOX("", "NO FIXTURE NOTE GENERATED. CONTINUE YES/NO", QUESTION!, YESNO!,2) = 2 THEN RETURN

datetime dt
dt = datetime(today())

UPDATE NTC_TC_CONTRACT
	SET FIX_DATE = :dt,
		FIXTURE_USER_ID = "TT1"
		WHERE CONTRACT_ID = :IL_CONTRACT_ID;
		
commit;
end event

type cb_delete from commandbutton within w_delme_convert_contract
integer x = 3808
integer y = 40
integer width = 398
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Contract"
end type

event clicked;string ls_sqlerrtext

if MessageBox("Delete Request", "Do you realy want to delete this contract", Question!,YesNo!,2) = 2 then return


/***********************************************************************/
/* Now it is OK to delete all contract related tables in reverse order */
/***********************************************************************/
DELETE 
	FROM NTC_NON_PORT_EXP  
   WHERE NTC_NON_PORT_EXP.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_NON_PORT_EXP sqlerrtext= "+ ls_sqlerrtext) 
	return -1 
end if

DELETE 
	FROM NTC_PAY_CONTRACT_EXP  
   WHERE NTC_PAY_CONTRACT_EXP.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_PAY_CONTRACT_EXP sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

DELETE 
	FROM NTC_PAYMENT_DETAIL  
   WHERE NTC_PAYMENT_DETAIL.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_PAYMENT_DETAIL sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

DELETE 
	FROM NTC_PAYMENT_SETTLED_AMOUNT
   WHERE NTC_PAYMENT_SETTLED_AMOUNT.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext 
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_PAYMENT_SETTLED_AMOUNT sqlerrtext= "+ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_PORT_EXP
   WHERE NTC_PORT_EXP.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_PORT_EXP sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

DELETE 
	FROM NTC_COMMISSION
   WHERE NTC_COMMISSION.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_COMMISSION sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

DELETE NTC_OFF_SERVICE_DETAIL  
	FROM NTC_OFF_SERVICE_DETAIL,   
         NTC_OFF_SERVICE  
   WHERE NTC_OFF_SERVICE.OFF_SERVICE_ID = NTC_OFF_SERVICE_DETAIL.OFF_SERVICE_ID  
	AND NTC_OFF_SERVICE.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);

if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_OFF_SERVICE_DETAIL sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

DELETE 
	FROM NTC_OFF_SERVICE
   WHERE NTC_OFF_SERVICE.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_OFF_SERVICE sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

UPDATE BP_DETAILS 
	SET BP_DETAILS.PAYMENT_ID = NULL 
	WHERE BP_DETAILS.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while updating table BP_DETAILS sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

DELETE 
	FROM NTC_PAYMENT  
   WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_PAYMENT sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

//////////

DELETE 
	FROM NTC_EST_INCOME_EXP  
   WHERE NTC_EST_INCOME_EXP.TC_PERIODE_ID IN (SELECT NTC_TC_PERIOD.TC_PERIODE_ID
																FROM NTC_TC_PERIOD
																WHERE NTC_TC_PERIOD.CONTRACT_ID =:il_contract_id);
if SQLCA.SQLCODE <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_EST_INCOME_EXP sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

DELETE 
	FROM NTC_TC_PERIOD  
   WHERE NTC_TC_PERIOD.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_TC_PERIOD sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

DELETE 
	FROM NTC_CONTRACT_EXPENSE  
   WHERE NTC_CONTRACT_EXPENSE.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext 
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_CONTRACT_EXPENSE sqlerrtext= "+ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_CONT_BROKER_COMM  
   WHERE NTC_CONT_BROKER_COMM.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_CONT_BROKER_COMM sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

DELETE 
	FROM NTC_SHARE_MEMBER  
   WHERE NTC_SHARE_MEMBER.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_SHARE_MEMBER sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

if wf_deleteattachment() = -1 then
	return -1
end if

DELETE 
	FROM NTC_TC_ACTION_LOG  
   WHERE NTC_TC_ACTION_LOG.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext 
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_TC_ACTION_LOG sqlerrtext= "+ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_TC_CONTRACT  
   WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_TC_CONTRACT sqlerrtext= "+ls_sqlerrtext) 
	return -1 
end if

COMMIT;

end event

type dw_contract from datawindow within w_delme_convert_contract
integer x = 827
integer y = 36
integer width = 2944
integer height = 532
integer taborder = 30
boolean enabled = false
string title = "none"
string dataobject = "d_tc_contract"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_payments from datawindow within w_delme_convert_contract
integer x = 841
integer y = 628
integer width = 2455
integer height = 968
integer taborder = 20
string title = "none"
string dataobject = "d_delme_convert_payment_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;long ll_pid

dw_paid.acceptText()
if dw_paid.ModifiedCount() > 0 then
	if messageBox("Update", "Received data changed but not updated. Would you like to update before switching?", Question!, YesNo!,1) = 1 then
		if wf_check_paymentid(dw_paid) = -1 then return
		if dw_paid.update() = 1 then
			commit;
		else
			MessageBox("Error", "Update failed!")
			rollback;
			return
		end if
	end if	
end if

dw_portexp.acceptText()
if dw_portexp.ModifiedCount() > 0 then
	if messageBox("Update", "PortExpenses data changed but not updated. Would you like to update before switching?", Question!, YesNo!,1) = 1 then
		if wf_check_paymentid(dw_portexp) = -1 then return
		if dw_portexp.update() = 1 then
			commit;
		else
			MessageBox("Error", "Update failed!")
			rollback;
			return
		end if
	end if	
end if

dw_bunker.acceptText()
if dw_bunker.ModifiedCount() > 0 then
	if messageBox("Update", "Bunker data changed but not updated. Would you like to update before switching?", Question!, YesNo!,1) = 1 then
		if wf_check_paymentid(dw_bunker) = -1 then return
		if dw_bunker.update() = 1 then
			commit;
		else
			MessageBox("Error", "Update failed!")
			rollback;
			return
		end if
	end if	
end if

if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	ll_pid = this.getItemNumber(currentrow, "payment_id")
	dw_paid.retrieve(ll_pid)
	dw_portexp.retrieve(ll_pid)
	dw_bunker.retrieve(ll_pid)
end if
end event

event itemchanged;decimal	ld_null

if row < 1 then return
if dwo.name = "transfer_to_next" then
	if row = this.rowcount() then 
		MessageBox("Error", "You can,t transfer from last payment")
		setNull(ld_null)
		this.setItem(row, "transfer_to_next", ld_null)
		return
	end if
	this.accepttext()
	this.setItem(row +1 , "transfer_from_previous", this.getItemDecimal(row, "transfer_to_next"))
end if	
end event

type dw_list from datawindow within w_delme_convert_contract
integer x = 41
integer y = 32
integer width = 763
integer height = 1564
integer taborder = 10
string title = "none"
string dataobject = "d_delme_convert_contract_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;long ll_cid

dw_paid.acceptText()
if dw_paid.ModifiedCount() > 0 then
	if messageBox("Update", "Received data changed but not updated. Would you like to update before switching?", Question!, YesNo!,1) = 1 then
		if wf_check_paymentid(dw_paid) = -1 then return
		if dw_paid.update() = 1 then
			commit;
		else
			MessageBox("Error", "Update failed!")
			rollback;
			return
		end if
	else
		dw_paid.resetupdate()
	end if	
end if

dw_portexp.acceptText()
if dw_portexp.ModifiedCount() > 0 then
	if messageBox("Update", "PortExpenses data changed but not updated. Would you like to update before switching?", Question!, YesNo!,1) = 1 then
		if wf_check_paymentid(dw_portexp) = -1 then return
		if dw_portexp.update() = 1 then
			commit;
		else
			MessageBox("Error", "Update failed!")
			rollback;
			return
		end if
	else
		dw_portexp.resetUpdate()
	end if	
end if

dw_bunker.acceptText()
if dw_bunker.ModifiedCount() > 0 then
	if messageBox("Update", "Bunker data changed but not updated. Would you like to update before switching?", Question!, YesNo!,1) = 1 then
		if wf_check_paymentid(dw_bunker) = -1 then return
		if dw_bunker.update() = 1 then
			commit;
		else
			MessageBox("Error", "Update failed!")
			rollback;
			return
		end if
	else
		dw_bunker.resetUpdate()
	end if	
end if

dw_payments.acceptText()
if dw_payments.ModifiedCount() > 0 then
	if messageBox("Update", "Payments data changed but not updated. Would you like to update before switching?", Question!, YesNo!,1) = 1 then
		if dw_payments.update() = 1 then
			commit;
		else
			MessageBox("Error", "Update failed!")
			rollback;
			return
		end if
	else
		dw_payments.resetUpdate()
	end if	
end if

if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	ll_cid = this.getItemNumber(currentrow, "contract_id")
	il_contract_id = ll_cid
	dw_contract.reset()
	dw_contract.retrieve(ll_cid)
	dw_payments.reset()
	dw_payments.retrieve(ll_cid)
else
	setnull(il_contract_id)
end if
end event

