$PBExportHeader$w_expense_import.srw
$PBExportComments$For Global Agent Import file
forward
global type w_expense_import from mt_w_sheet
end type
type st_reject_count from mt_u_statictext within w_expense_import
end type
type st_1 from mt_u_statictext within w_expense_import
end type
type st_accept_count from mt_u_statictext within w_expense_import
end type
type dw_rejected from mt_u_datawindow within w_expense_import
end type
type dw_voyage_list from u_datagrid within w_expense_import
end type
type dw_accepted from u_datagrid within w_expense_import
end type
type dw_ratedate from mt_u_datawindow within w_expense_import
end type
type cb_saveas from mt_u_commandbutton within w_expense_import
end type
type cb_load_errors from mt_u_commandbutton within w_expense_import
end type
type cb_print from mt_u_commandbutton within w_expense_import
end type
type cb_update from mt_u_commandbutton within w_expense_import
end type
type cb_validate_errors from mt_u_commandbutton within w_expense_import
end type
type cb_import from mt_u_commandbutton within w_expense_import
end type
type gb_accepted from mt_u_groupbox within w_expense_import
end type
type gb_poc from mt_u_groupbox within w_expense_import
end type
type gb_rejected from mt_u_groupbox within w_expense_import
end type
end forward

global type w_expense_import from mt_w_sheet
integer x = 1074
integer y = 484
integer width = 4608
integer height = 2568
string title = "Import Expenses"
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
boolean center = false
boolean ib_setdefaultbackgroundcolor = true
st_reject_count st_reject_count
st_1 st_1
st_accept_count st_accept_count
dw_rejected dw_rejected
dw_voyage_list dw_voyage_list
dw_accepted dw_accepted
dw_ratedate dw_ratedate
cb_saveas cb_saveas
cb_load_errors cb_load_errors
cb_print cb_print
cb_update cb_update
cb_validate_errors cb_validate_errors
cb_import cb_import
gb_accepted gb_accepted
gb_poc gb_poc
gb_rejected gb_rejected
end type
global w_expense_import w_expense_import

type prototypes

end prototypes

type variables
u_import_expenses inv_import_exp

end variables

forward prototypes
public subroutine documentation ()
public subroutine wf_enabled_button ()
public subroutine wf_set_ordervalue ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_expense_import
   <OBJECT>		</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		03/06/14		CR3553		XSZ004		Check if the expenses exist in disburesement.
		20/08/14		CR3553UAT	XSZ004		Fix bug.
		28/08/14		CR3781		CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

public subroutine wf_enabled_button ();/********************************************************************
   wf_enabled_button
   <DESC> Enabled the buttons </DESC>
   <RETURN>	       
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		02/06/14		CR3553		XSZ004		First Version
   </HISTORY>
********************************************************************/

if dw_accepted.find("isnull(reason)", 1, dw_accepted.rowcount()) > 0 then
	cb_update.enabled = true
else
	cb_update.enabled = false
end if

if dw_rejected.RowCount() > 0 then
	cb_validate_errors.enabled = true
else
	dw_voyage_list.reset()
	cb_validate_errors.enabled = false
end if

st_accept_count.text = string(dw_accepted.rowcount()) + " row(s)"
st_reject_count.text = string(dw_rejected.rowcount()) + " row(s)"
end subroutine

public subroutine wf_set_ordervalue ();/********************************************************************
   wf_set_ordervalue
   <DESC> Set order value for sorting </DESC>
   <RETURN>	       
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		22/07/14		CR3553		XSZ004		First Version
   </HISTORY>
********************************************************************/

long ll_row 

dw_rejected.setsort("vessel_nr A, voyage_nr A, port_code A, pcn A, disb_invoice_nr A")
dw_rejected.sort()

for ll_row = 1 to dw_rejected.rowcount()
	dw_rejected.setitem(ll_row, "order_no", ll_row)
next

dw_rejected.setsort("order_no")

if dw_rejected.rowcount() > 0 then
	dw_rejected.event rowfocuschanged(1)
end if
end subroutine

on w_expense_import.create
int iCurrent
call super::create
this.st_reject_count=create st_reject_count
this.st_1=create st_1
this.st_accept_count=create st_accept_count
this.dw_rejected=create dw_rejected
this.dw_voyage_list=create dw_voyage_list
this.dw_accepted=create dw_accepted
this.dw_ratedate=create dw_ratedate
this.cb_saveas=create cb_saveas
this.cb_load_errors=create cb_load_errors
this.cb_print=create cb_print
this.cb_update=create cb_update
this.cb_validate_errors=create cb_validate_errors
this.cb_import=create cb_import
this.gb_accepted=create gb_accepted
this.gb_poc=create gb_poc
this.gb_rejected=create gb_rejected
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_reject_count
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_accept_count
this.Control[iCurrent+4]=this.dw_rejected
this.Control[iCurrent+5]=this.dw_voyage_list
this.Control[iCurrent+6]=this.dw_accepted
this.Control[iCurrent+7]=this.dw_ratedate
this.Control[iCurrent+8]=this.cb_saveas
this.Control[iCurrent+9]=this.cb_load_errors
this.Control[iCurrent+10]=this.cb_print
this.Control[iCurrent+11]=this.cb_update
this.Control[iCurrent+12]=this.cb_validate_errors
this.Control[iCurrent+13]=this.cb_import
this.Control[iCurrent+14]=this.gb_accepted
this.Control[iCurrent+15]=this.gb_poc
this.Control[iCurrent+16]=this.gb_rejected
end on

on w_expense_import.destroy
call super::destroy
destroy(this.st_reject_count)
destroy(this.st_1)
destroy(this.st_accept_count)
destroy(this.dw_rejected)
destroy(this.dw_voyage_list)
destroy(this.dw_accepted)
destroy(this.dw_ratedate)
destroy(this.cb_saveas)
destroy(this.cb_load_errors)
destroy(this.cb_print)
destroy(this.cb_update)
destroy(this.cb_validate_errors)
destroy(this.cb_import)
destroy(this.gb_accepted)
destroy(this.gb_poc)
destroy(this.gb_rejected)
end on

event open;call super::open;string  ls_user
integer li_count

n_service_manager  lnv_servicemgr
n_dw_style_service lnv_style

lnv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_voyage_list, false)

dw_voyage_list.setrowfocusindicator(Off!)

dw_ratedate.modify("datawindow.color = " + string(c#color.MT_LISTDETAIL_BG_ALT))
dw_ratedate.modify("date_value.border = 5 date_value.width = 236 date_value.alignment = 2")
dw_ratedate.modify("date_value.background.mode = 0 date_value.background.color = " + string(c#color.MT_MAERSK))

// Lock this function, so only one user at the time can open it 
ls_user = uo_global.is_userid

/* If there is no row in the table that indicate whether a file is being generated
	insert row with key (date)*/
SELECT COUNT(PROGRESS_START)
INTO	 :li_count
FROM 	 ELECTRONIC_IN_PROGRESS;

If li_count = 0 then
	INSERT INTO ELECTRONIC_IN_PROGRESS(PROGRESS_START, IMPORT_START, IMPORT_USER) 
	VALUES(getdate(), getdate(), :ls_user);  
	
	If sqlca.sqlcode <> 0 then
		RollBack;
		messagebox("Error","Could not insert a new row in electronic_in_progress table",Stopsign!,OK!)
		Return
	Else
		Commit;
	End if
else
	UPDATE ELECTRONIC_IN_PROGRESS
			SET IMPORT_START= getdate(), IMPORT_USER = :ls_user;
	If sqlca.sqlcode <> 0 then
		RollBack;
		messagebox("Error","It was not possible to lock the import priviligde! Import not possible",Stopsign!,OK!)
		return
	Else
		Commit;
	End if
End if

dw_ratedate.insertrow(0)

inv_import_exp = Create u_import_expenses
inv_import_exp.of_SetShareOn(dw_accepted, dw_rejected)
dw_voyage_list.setTransObject(SQLCA)

dw_ratedate.setfocus( )
end event

event close;Destroy inv_import_exp

UPDATE ELECTRONIC_IN_PROGRESS
		SET IMPORT_USER = NULL;
If sqlca.sqlcode <> 0 then
	RollBack;
	messagebox("Error", "It was not possible to unlock the import priviligde! Import is blocked.", Stopsign!, OK!)
	return
Else
	Commit;
End if



end event

event closequery;IF cb_update.enabled THEN
	IF messagebox("Closing window", "It has accepted expenses, but not updated. ~n Are you sure you want to close window ?", Question!, YesNo!, 1) = 2 THEN
		RETURN 1
	END IF
END IF
end event

event activate;call super::activate;if w_tramos_main.MenuName <> "m_tramosmain" then
	w_tramos_main.ChangeMenu(m_tramosmain)
end if
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_expense_import
end type

type st_reject_count from mt_u_statictext within w_expense_import
integer x = 73
integer y = 2348
integer width = 713
integer height = 48
long backcolor = 553648127
string text = "0 row(s)"
end type

type st_1 from mt_u_statictext within w_expense_import
integer x = 1778
integer y = 1080
integer width = 439
integer height = 52
long backcolor = 553648127
string text = "Exchange rate date"
end type

type st_accept_count from mt_u_statictext within w_expense_import
integer x = 73
integer y = 1056
integer width = 677
integer height = 48
long backcolor = 553648127
string text = "0 row(s)"
end type

type dw_rejected from mt_u_datawindow within w_expense_import
integer x = 73
integer y = 1244
integer width = 3122
integer height = 1088
integer taborder = 60
string dataobject = "d_rejected_transactions"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;long ll_vessel_nr, ll_found
int  li_return

choose case dwo.name
	case "voyage_nr", "port_code", "pcn", "agents_agent_sn", "disb_invoice_nr", "vessel_ref_nr"		
		
		cb_update.enabled = false
		
		if dwo.name = "vessel_ref_nr" then
			SELECT VESSEL_NR INTO :ll_vessel_nr FROM VESSELS WHERE VESSEL_REF_NR = :data;
			if sqlca.sqlcode <> 0 then
				MessageBox("Error", "Entered vessel number is not correct. Please enter a valid number.")
				return 1
			end if
			this.setItem(row, "vessel_nr", ll_vessel_nr)
		end if
		
		if dwo.name <> "disb_invoice_nr" then this.accepttext()
		
		inv_import_exp.of_rejected_modified(row, dwo.name, data)
		
	case else
		//do nothing
end choose
end event

event rowfocuschanged;call super::rowfocuschanged;integer li_vessel
string  ls_voyage
long    ll_found

if currentrow > 0 then
	li_vessel = this.getItemNumber(currentrow, "vessel_nr")
	ls_voyage = this.getItemString(currentrow, "voyage_nr")
	
	/* only retrieve if vessel and voyage changed */
	if dw_voyage_list.rowcount() > 0 then 
		if li_vessel <> dw_voyage_list.getItemNumber(1, "vessel_nr") or &
			mid(ls_voyage, 1, 2) <> mid(dw_voyage_list.getItemString(1, "voyage_nr"), 1, 2) then
			
			dw_voyage_list.retrieve(li_vessel, mid(ls_voyage, 1, 2))
		end if
	else
		dw_voyage_list.retrieve(li_vessel, mid(ls_voyage, 1, 2))
	end if
	
	/* Find voyage */
	ll_found = dw_voyage_list.find("voyage_nr = '" + ls_voyage + "'", 1, 99999)
	if ll_found < 1 then
		ll_found = dw_voyage_list.find("voyage_nr > '" + ls_voyage + "'", 1, 99999)
	end if
	if ll_found > 0 then
		dw_voyage_list.scrolltorow(ll_found)
	end if
end if
end event

event itemerror;call super::itemerror;return 1
end event

type dw_voyage_list from u_datagrid within w_expense_import
integer x = 3291
integer y = 80
integer width = 1230
integer height = 2368
integer taborder = 130
string dataobject = "d_sq_gr_voyagelist_impexp"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

type dw_accepted from u_datagrid within w_expense_import
integer x = 73
integer y = 80
integer width = 3122
integer height = 960
integer taborder = 10
string dataobject = "d_expense_transactions"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dw_ratedate from mt_u_datawindow within w_expense_import
integer x = 2222
integer y = 1072
integer width = 256
integer height = 68
integer taborder = 30
string dataobject = "d_date"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_saveas from mt_u_commandbutton within w_expense_import
integer x = 2510
integer y = 2348
integer taborder = 90
string text = "&Save As..."
end type

event clicked;if dw_rejected.rowcount() > 0 then 
	dw_rejected.saveas()
else
	MessageBox("Information","There are no rejected expenses to save.")
end if
end event

type cb_load_errors from mt_u_commandbutton within w_expense_import
integer x = 2162
integer y = 2348
integer taborder = 80
string text = "&Load"
end type

event clicked;if inv_import_exp.ib_imported or dw_rejected.RowCount() > 0 then 
	if MessageBox("Warning", "You have imported/loaded expenses pending. Do you want to clear all data and load errors?",Question!,YesNo!) = 2 THEN
		return
	else	
		inv_import_exp.of_clear_ds()
	end if	
end if

inv_import_exp.of_Load_Errors()

wf_set_ordervalue()
wf_enabled_button()


end event

type cb_print from mt_u_commandbutton within w_expense_import
integer x = 2853
integer y = 2348
integer taborder = 100
string text = "&Print"
end type

event clicked;if dw_rejected.RowCount() > 0 then
	dw_rejected.Print(true)
else
	MessageBox("Information","There are no rejected expenses to print.")
end if
end event

type cb_update from mt_u_commandbutton within w_expense_import
integer x = 2857
integer y = 1056
integer taborder = 50
boolean enabled = false
string text = "&Update"
end type

event clicked;if inv_import_exp.of_update_transactions() = -1 then 
	inv_import_exp.of_clear_ds()
end if

wf_enabled_button()





		
end event

type cb_validate_errors from mt_u_commandbutton within w_expense_import
integer x = 1815
integer y = 2348
integer taborder = 70
boolean enabled = false
string text = "&Validate"
end type

event clicked;Integer li_return

dw_ratedate.accepttext( )
if inv_import_exp.of_set_exrate(dw_ratedate.GetItemDate(1,"date_value")) < 0 then 
	dw_ratedate.setfocus()
	return
end if

parent.setredraw(false)

li_return = inv_import_exp.of_validate_rejected()
wf_set_ordervalue()

parent.setredraw(true)

if li_return = -1 then
	inv_import_exp.of_clear_ds()
	MessageBox("Error","Error in the validation process. All import is halted !")
end if

wf_enabled_button()
end event

type cb_import from mt_u_commandbutton within w_expense_import
integer x = 2510
integer y = 1056
integer taborder = 40
string text = "&Import"
end type

event clicked;long   ll_exist_expenses, ll_rowcount  
Int    li_return
string ls_message

dw_ratedate.accepttext()
if inv_import_exp.of_set_exrate(dw_ratedate.GetItemDate(1,"date_value")) < 0 then
	dw_ratedate.setfocus()
	return
end if

if inv_import_exp.ib_imported or dw_rejected.RowCount() > 0 then
	ls_message = "You have imported/loaded expenses pending. Do you want to import a new file?"
	if MessageBox("Warning", ls_message, Question!, YesNo!) = 1 then
		inv_import_exp.of_clear_ds()
	else
		return 
	end if
end if

dw_accepted.vscrollbar = false
dw_rejected.vscrollbar = false

li_return = inv_import_exp.of_import_expenses()
wf_set_ordervalue()

dw_accepted.vscrollbar = true
dw_rejected.vscrollbar = true

IF li_return = c#return.failure THEN 
	inv_import_exp.of_clear_ds()
elseif li_return = c#return.success then
	
	ll_exist_expenses = long(dw_accepted.describe("Evaluate('sum(if(reason = ~~'Settled~~' or reason = ~~'Duplicated~~', 1, 0))', 0)"))
	ll_rowcount       = dw_accepted.rowcount()
	
	if ll_exist_expenses = ll_rowcount and ll_rowcount > 0 then
		messagebox("Information", "The expenses in the selected file have already been imported. Please select another file.")
	end if
end if

wf_enabled_button()
end event

type gb_accepted from mt_u_groupbox within w_expense_import
integer x = 37
integer y = 16
integer width = 3200
integer height = 1160
integer taborder = 20
integer weight = 400
string facename = "Tahoma"
long backcolor = 32304364
string text = "Accepted Expenses"
end type

type gb_poc from mt_u_groupbox within w_expense_import
integer x = 3255
integer y = 16
integer width = 1307
integer height = 2464
integer taborder = 110
integer weight = 400
string facename = "Tahoma"
long backcolor = 32304364
string text = "Port of Calls"
end type

type gb_rejected from mt_u_groupbox within w_expense_import
integer x = 37
integer y = 1184
integer width = 3200
integer height = 1296
integer taborder = 110
integer weight = 400
string facename = "Tahoma"
long backcolor = 32304364
string text = "Rejected Expenses"
end type

