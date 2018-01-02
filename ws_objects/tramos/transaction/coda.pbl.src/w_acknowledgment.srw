$PBExportHeader$w_acknowledgment.srw
forward
global type w_acknowledgment from mt_w_response
end type
type cb_resend from commandbutton within w_acknowledgment
end type
type cb_saveas from commandbutton within w_acknowledgment
end type
type cb_refresh from commandbutton within w_acknowledgment
end type
type dw_acknowledgment from u_datagrid within w_acknowledgment
end type
type ids_trans_log_b from mt_n_datastore within w_acknowledgment
end type
type ids_trans_log_main_a from mt_n_datastore within w_acknowledgment
end type
end forward

global type w_acknowledgment from mt_w_response
integer width = 3621
integer height = 2048
string title = "Acknowledgment of Credit Notes"
boolean ib_setdefaultbackgroundcolor = true
cb_resend cb_resend
cb_saveas cb_saveas
cb_refresh cb_refresh
dw_acknowledgment dw_acknowledgment
ids_trans_log_b ids_trans_log_b
ids_trans_log_main_a ids_trans_log_main_a
end type
global w_acknowledgment w_acknowledgment

type variables
datetime	idt_transdate = datetime(2012-03-01, 00:00:00)

end variables

forward prototypes
public function long of_update ()
public function long of_resend ()
public subroutine documentation ()
public subroutine of_enable_buttons ()
end prototypes

public function long of_update ();/********************************************************************
   of_update
   <DESC>	Update acknowledge to TRANS_LOG_MAIN_A table	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Suggest to use in the event itemchanged of the datawindow	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	05/04/2012   M5-11        ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_error

if dw_acknowledgment.update() = 1 then
	COMMIT;
	return c#return.Success
else
	ls_error = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Update Error", ls_error, stopsign!)
	return c#return.Failure
end if

end function

public function long of_resend ();/********************************************************************
   of_resend
   <DESC>	Create a full copy of the A-POST and all the associated B-POSTS	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Suggest to use in the event clicked of the cb_resend button	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	05/04/2012   M5-11        ZSW001       First Version
   </HISTORY>
********************************************************************/

long		ll_row, ll_cur_trans_key, ll_ori_trans_key, ll_loga_count, ll_logb_count, ll_null, ll_link_id, ll_DebitCredit
string	ls_error, ls_null, ls_trans_type
datetime	ldt_null, ldt_trans_date

setnull(ll_null)
setnull(ls_null)
setnull(ldt_null)

ll_row = dw_acknowledgment.getrow()
if ll_row <= 0 then return c#return.Failure

//Get current trans key
ll_cur_trans_key = dw_acknowledgment.getitemnumber(ll_row, "trans_key")
ldt_trans_date = dw_acknowledgment.getitemdatetime(ll_row, "trans_date")
ls_trans_type = dw_acknowledgment.getitemstring(ll_row, "trans_type")

SELECT LINK_ID, F29_DEBITCREDIT INTO :ll_link_id, :ll_DebitCredit FROM TRANS_LOG_MAIN_A WHERE TRANS_KEY = :ll_cur_trans_key;

//Get original trans key
SELECT TOP 1 TRANS_KEY
  INTO :ll_ori_trans_key
  FROM TRANS_LOG_MAIN_A
 WHERE TRANS_DATE = :ldt_trans_date AND
       TRANS_TYPE = :ls_trans_type AND
		 LINK_ID    = :ll_link_id AND
		 F29_DEBITCREDIT <> :ll_DebitCredit
ORDER BY TRANS_KEY DESC;

if isnull(ll_ori_trans_key) or ll_ori_trans_key = 0 then return c#return.Failure

ids_trans_log_main_a.settransobject(sqlca)
ll_loga_count = ids_trans_log_main_a.retrieve(ll_ori_trans_key)
if ll_loga_count <> 1 then return c#return.Failure

ids_trans_log_b.settransobject(sqlca)
ll_logb_count = ids_trans_log_b.retrieve(ll_ori_trans_key)

//Create a full copy of the A-POST
ids_trans_log_main_a.setitemstatus(1, 0, primary!, newmodified!)

//Empty the following columns inside the new A-POST record
ids_trans_log_main_a.setitem(1, "trans_key", ll_null)
ids_trans_log_main_a.setitem(1, "trans_date", today())
ids_trans_log_main_a.setitem(1, "f07_docnum", ls_null)
ids_trans_log_main_a.setitem(1, "file_name", ls_null)
ids_trans_log_main_a.setitem(1, "file_date", ldt_null)

//Restore payment id
ids_trans_log_main_a.setitem(1, "payment_id", ll_link_id)

if ids_trans_log_main_a.update() = 1 then
	ll_ori_trans_key = ids_trans_log_main_a.getitemnumber(1, "trans_key")
	//Create a full copy of all the associated B-POSTS
	for ll_row = 1 to ll_logb_count
		ids_trans_log_b.setitemstatus(ll_row, 0, primary!, newmodified!)
		ids_trans_log_b.setitem(ll_row, "trans_key", ll_ori_trans_key)
	next
	if ids_trans_log_b.update() = 1 then
		COMMIT;
		return c#return.Success
	end if
end if

ls_error = sqlca.sqlerrtext
ROLLBACK;
messagebox("Update Error", ls_error, stopsign!)

return c#return.Failure

end function

public subroutine documentation ();/********************************************************************
   w_acknowledgment
   <OBJECT>		Acknowledgment of Credit Notes	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	06/04/2012   M5-11        ZSW001        First Version
	13/08/2012	CR2836		JMC112	Deactivation of the resend button
   </HISTORY>
********************************************************************/

end subroutine

public subroutine of_enable_buttons ();/********************************************************************
   of_enable_buttons
   <DESC>	Enabled or disabled buttons	</DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Suggest to use in the event itemchanged of the dw_acknowledgment datawindow	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	06/04/2012   M5-11         ZSW001       First Version
   </HISTORY>
********************************************************************/

long	ll_row

/* DEACTIVATED
ll_row = dw_acknowledgment.getrow()
if ll_row > 0 then
	cb_resend.enabled = (dw_acknowledgment.getitemnumber(ll_row, "acknowledge") = 0)
end if
*/

end subroutine

on w_acknowledgment.create
int iCurrent
call super::create
this.cb_resend=create cb_resend
this.cb_saveas=create cb_saveas
this.cb_refresh=create cb_refresh
this.dw_acknowledgment=create dw_acknowledgment
this.ids_trans_log_b=create ids_trans_log_b
this.ids_trans_log_main_a=create ids_trans_log_main_a
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_resend
this.Control[iCurrent+2]=this.cb_saveas
this.Control[iCurrent+3]=this.cb_refresh
this.Control[iCurrent+4]=this.dw_acknowledgment
end on

on w_acknowledgment.destroy
call super::destroy
destroy(this.cb_resend)
destroy(this.cb_saveas)
destroy(this.cb_refresh)
destroy(this.dw_acknowledgment)
destroy(this.ids_trans_log_b)
destroy(this.ids_trans_log_main_a)
end on

event open;call super::open;n_service_manager		lnv_servicemgr
n_dw_style_service	lnv_style

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_acknowledgment)

//Finance Profile
if uo_global.ii_user_profile = 3 then
	dw_acknowledgment.modify("acknowledge.tabsequence = '10'")
end if

cb_refresh.event clicked()

end event

type cb_resend from commandbutton within w_acknowledgment
integer x = 2885
integer y = 1840
integer width = 686
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Re-send &transaction"
end type

event clicked;setpointer(hourglass!)

if of_resend() = c#return.Success then
	messagebox("Notice", "Selected transaction has been regenerated and is being sent onto AX.")
end if

setpointer(arrow!)

end event

type cb_saveas from commandbutton within w_acknowledgment
integer x = 2537
integer y = 1840
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save as..."
end type

event clicked;dw_acknowledgment.saveas("", excel5!, true)

end event

type cb_refresh from commandbutton within w_acknowledgment
integer x = 2190
integer y = 1840
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;dw_acknowledgment.settransobject(sqlca)
dw_acknowledgment.retrieve(idt_transdate)

end event

type dw_acknowledgment from u_datagrid within w_acknowledgment
integer x = 37
integer y = 32
integer width = 3534
integer height = 1796
integer taborder = 10
string title = ""
string dataobject = "d_sq_gr_acknowledgment"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event clicked;call super::clicked;if row > 0 then this.setrow(row)

end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	of_enable_buttons()
end if

end event

event itemchanged;call super::itemchanged;if row > 0 then
	if dwo.name = "acknowledge" then
		post of_update()
		post of_enable_buttons()
	end if
end if

end event

type ids_trans_log_b from mt_n_datastore within w_acknowledgment descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_trans_log_b"
end type

on ids_trans_log_b.create
call super::create
end on

on ids_trans_log_b.destroy
call super::destroy
end on

type ids_trans_log_main_a from mt_n_datastore within w_acknowledgment descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_trans_log_main_a"
end type

on ids_trans_log_main_a.create
call super::create
end on

on ids_trans_log_main_a.destroy
call super::destroy
end on

