$PBExportHeader$w_calc_claims.srw
$PBExportComments$The claims window for the calculation
forward
global type w_calc_claims from mt_w_response_calc
end type
type cb_close from uo_cb_base within w_calc_claims
end type
type cb_headev_new from uo_cb_base within w_calc_claims
end type
type cb_headev_delete from uo_cb_base within w_calc_claims
end type
type cb_misc_delete from uo_cb_base within w_calc_claims
end type
type cb_misc_new from uo_cb_base within w_calc_claims
end type
type dw_calc_misc_claim from u_datawindow_sqlca within w_calc_claims
end type
type dw_calc_hea_dev_claim from u_datawindow_sqlca within w_calc_claims
end type
type gb_hea_dev from uo_gb_base within w_calc_claims
end type
type gb_misc from uo_gb_base within w_calc_claims
end type
end forward

global type w_calc_claims from mt_w_response_calc
integer x = 311
integer y = 192
integer width = 2304
integer height = 1664
string title = "Claims"
long backcolor = 32304364
string icon = "images\claims.ico"
cb_close cb_close
cb_headev_new cb_headev_new
cb_headev_delete cb_headev_delete
cb_misc_delete cb_misc_delete
cb_misc_new cb_misc_new
dw_calc_misc_claim dw_calc_misc_claim
dw_calc_hea_dev_claim dw_calc_hea_dev_claim
gb_hea_dev gb_hea_dev
gb_misc gb_misc
end type
global w_calc_claims w_calc_claims

type variables
Integer ii_order_hd
Integer ii_order_misc
//private u_calc_cargos iuo_calc_cargoes
private u_atobviac_calc_cargos iuo_calc_cargoes

end variables

forward prototypes
public function boolean wf_validate_hea_dev ()
public function boolean wf_validate_misc ()
private subroutine documentation ()
end prototypes

public function boolean wf_validate_hea_dev ();Long ll_row
Double ld_amount

//This is the secondary shared data window, so do an accepttext
If dw_calc_hea_dev_claim.AcceptText() <> 1 Then 
	dw_calc_hea_dev_claim.SetFocus()	
	Return false
End if

ll_row = dw_calc_hea_dev_claim.GetRow()
If ll_row > 0 Then
	ld_amount = dw_calc_hea_dev_claim.GetItemNumber(ll_row,"hea_dev_amount")
	If Not(ld_amount >0) Then
		MessageBox("Error","The claim amount sum has to be above zero",StopSign!)

		dw_calc_hea_dev_claim.SetFocus()
		dw_calc_hea_dev_claim.SelectRow(0,False)
		dw_calc_hea_dev_claim.ScrollToRow(ll_row)

		Return false
	End if
End if

Return true
end function

public function boolean wf_validate_misc ();Long ll_row
Double ld_amount

// This is a secondary shared data window, so do an accepttext
If dw_calc_misc_claim.AcceptText()<> 1 Then 
	dw_calc_misc_claim.SetFocus()
	Return false
End if

// Only insert a new row if there is a valid value in the previouse row !
ll_row = dw_calc_misc_claim.GetRow()
If ll_row > 0 Then
	ld_amount = dw_calc_misc_claim.GetItemNumber(ll_row,"cal_clmi_amount")
	If ld_amount =  0 Then
		dw_calc_misc_claim.SelectRow(0,False)
		dw_calc_misc_claim.ScrollToRow(ll_row)
	
		MessageBox("Notice", "Misc. claim amount is not allowed to be zero", StopSign!)
		dw_calc_misc_claim.SetFocus()

		Return false
	End if
End if

Return true
		

end function

private subroutine documentation ();/********************************************************************
   w_calc_claims
	
	<OBJECT>

	</OBJECT>
	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
	<HISTORY>
    	Date    		Ref   	Author		Comments
		06/10/10		CR2129	JSU   		Align the way of calculating broker commision 
													to be the same as in the operation part
		07/08/14		CR3708	AGL027		F1 help application coverage - corrected ancestor
		12/09/14		CR3773	XSZ004		Change icon absolute path to reference path
	</HISTORY>
*****************************************************************/
end subroutine

on closequery;call mt_w_response_calc::closequery;Integer li_ret

If not wf_validate_hea_dev() Then 
	li_ret = 1 
Else
	If not wf_validate_misc() Then li_ret = 1
End if

Message.ReturnValue = li_ret

end on

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_hea_dev_claim
  
 Object     : 
  
 Event	 : Open

 Scope     : Object local

 ************************************************************************************

 Author    : MIS
   
 Date       : 22-3-97

 Description : Heating & Deviation update

 Arguments : cargo id as long

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
21-5-97		2.0			TA		Modified to run on shared datawindows because
								of update problems  
************************************************************************************/
iuo_calc_cargoes = Message.PowerObjectParm
int li_max, li_count, li_lock_value, li_old_modified_count
String ls_cargo_id

// Datawindows are shared with hidden datawindows on u_calc_cargoes

If iuo_calc_cargoes.dw_calc_hea_dev_claim.ShareData(dw_calc_hea_dev_claim) <> 1 Then &
	messageBox("Error","Error getting/sharing d_calc_hea_dev_claim")
If iuo_calc_cargoes.dw_calc_misc_claim.ShareData(dw_calc_misc_claim) <> 1 Then &
	messageBox("Error","Error getting/sharing d_calc_misc_claim")

li_max = dw_calc_hea_dev_claim.RowCount()
If IsNull(li_max) Then
	ii_order_hd = 0
Else 
	ii_order_hd = li_max
End if

li_max = dw_calc_misc_claim.Rowcount()
If IsNull(li_max) Then
	ii_order_misc = 0
Else 
	ii_order_misc = li_max
End if

f_center_window(this)

ls_cargo_id = String(iuo_calc_cargoes.uf_get_cargo_id())
dw_calc_hea_dev_claim.SetFilter("cal_carg_id = "+ls_cargo_id)
dw_calc_hea_dev_claim.Filter()
dw_calc_misc_claim.SetFilter("cal_carg_id = "+ls_cargo_id)
dw_calc_misc_claim.Filter()

li_old_modified_count = dw_calc_misc_claim.ModifiedCount() + dw_calc_hea_dev_claim.ModifiedCount()

If iuo_calc_cargoes.uf_get_cargo_locked() Then 
// When locked, active column is moved to the dummy-field, created just for this reason.
// This is because of the "one column needs to have focus" bug in powerbuilder (infobase)
	li_lock_value = 1
	dw_calc_hea_dev_claim.SetColumn("dummy")
	dw_calc_misc_claim.SetColumn("dummy")
Else
	li_lock_value = 0
End if

li_max = dw_calc_hea_dev_claim.RowCount()
For li_count = 1 To li_max 
	dw_calc_hea_dev_claim.SetItem(li_count, "locked", li_lock_value)
Next

li_max = dw_calc_misc_claim.RowCount()
For li_count = 1 To li_max 
	dw_calc_misc_claim.SetItem(li_count, "locked", li_lock_value)
Next

if li_old_modified_count = 0 Then
	dw_calc_misc_claim.resetupdate()
	dw_calc_hea_dev_claim.ResetUpdate()
End if

cb_headev_delete.enabled = li_lock_value = 0
cb_headev_new.enabled = li_lock_value = 0
cb_misc_delete.enabled = li_lock_value = 0
cb_misc_new.enabled = li_lock_value = 0

n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwformformater(dw_calc_hea_dev_claim)
lnv_style.of_dwlistformater(dw_calc_misc_claim,false)


end event

on close;call mt_w_response_calc::close;dw_calc_hea_dev_claim.uf_ClearFilter()
dw_calc_misc_claim.uf_clearfilter()

end on

on w_calc_claims.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.cb_headev_new=create cb_headev_new
this.cb_headev_delete=create cb_headev_delete
this.cb_misc_delete=create cb_misc_delete
this.cb_misc_new=create cb_misc_new
this.dw_calc_misc_claim=create dw_calc_misc_claim
this.dw_calc_hea_dev_claim=create dw_calc_hea_dev_claim
this.gb_hea_dev=create gb_hea_dev
this.gb_misc=create gb_misc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.cb_headev_new
this.Control[iCurrent+3]=this.cb_headev_delete
this.Control[iCurrent+4]=this.cb_misc_delete
this.Control[iCurrent+5]=this.cb_misc_new
this.Control[iCurrent+6]=this.dw_calc_misc_claim
this.Control[iCurrent+7]=this.dw_calc_hea_dev_claim
this.Control[iCurrent+8]=this.gb_hea_dev
this.Control[iCurrent+9]=this.gb_misc
end on

on w_calc_claims.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.cb_headev_new)
destroy(this.cb_headev_delete)
destroy(this.cb_misc_delete)
destroy(this.cb_misc_new)
destroy(this.dw_calc_misc_claim)
destroy(this.dw_calc_hea_dev_claim)
destroy(this.gb_hea_dev)
destroy(this.gb_misc)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_claims
end type

type cb_close from uo_cb_base within w_calc_claims
integer x = 1897
integer y = 1436
integer width = 343
integer height = 100
integer taborder = 60
string text = "&Close"
end type

event clicked;call super::clicked;integer li_ret

If not wf_validate_hea_dev() Then return
If not wf_validate_misc() Then return

If ( dw_calc_hea_dev_claim.ModifiedCount() + dw_calc_hea_dev_claim.DeletedCount() + &
		dw_calc_misc_claim.ModifiedCount() + dw_calc_misc_claim.DeletedCount() ) > 0 Then
	li_ret = 1
Else
	li_ret = 0
End if

CloseWithReturn(w_calc_claims, li_ret)
Return
end event

type cb_headev_new from uo_cb_base within w_calc_claims
integer x = 1897
integer y = 80
integer width = 343
integer height = 100
integer taborder = 70
string text = "&New"
end type

event clicked;call super::clicked;Long ll_row

If not wf_validate_hea_dev() Then Return

ll_row = dw_calc_hea_dev_claim.InsertRow(0)
dw_calc_hea_dev_claim.ScrollToRow(ll_row)

dw_calc_hea_dev_claim.SetItem(ll_row, "cal_carg_id",  iuo_calc_cargoes.uf_get_cargo_id())
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_hfo_ton", 0)
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_do_ton", 0)
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_go_ton", 0)
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_lshfo_ton", 0)
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_hfo_price", 0)
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_do_price", 0)
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_go_price", 0)
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_lshfo_price", 0)
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_hea_dev_hours", 0)
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_hea_dev_price_pr_day", 0)
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_adr_comm_hours", 1)
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_broker_comm_hours", 0)

	
ii_order_hd ++
dw_calc_hea_dev_claim.SetItem(ll_row, "cal_hedv_cal_hedv_order", ii_order_hd)



end event

type cb_headev_delete from uo_cb_base within w_calc_claims
integer x = 1897
integer y = 208
integer width = 343
integer height = 100
integer taborder = 50
string text = "&Delete"
end type

on clicked;call uo_cb_base::clicked;Long ll_row 

ll_row = dw_calc_hea_dev_claim.GetRow()
If ll_row >0 Then
	dw_calc_hea_dev_claim.DeleteRow(ll_row)
End if
end on

type cb_misc_delete from uo_cb_base within w_calc_claims
integer x = 1344
integer y = 1400
integer width = 343
integer height = 100
integer taborder = 10
string text = "De&lete"
end type

on clicked;call uo_cb_base::clicked;Long ll_row 

ll_row = dw_calc_misc_claim.GetRow()
If ll_row >0 Then
	dw_calc_misc_claim.DeleteRow(ll_row)
End if
end on

type cb_misc_new from uo_cb_base within w_calc_claims
integer x = 1344
integer y = 1272
integer width = 343
integer height = 100
integer taborder = 20
string text = "Ne&w"
end type

event clicked;call super::clicked;Long ll_row

If not wf_validate_misc() Then return

ll_row = dw_calc_misc_claim.InsertRow(0)
dw_calc_misc_claim.ScrollToRow(ll_row)

dw_calc_misc_claim.SetItem(ll_row, "cal_carg_id", iuo_calc_cargoes.uf_get_cargo_id())
dw_calc_misc_claim.SetItem(ll_row, "cal_clmi_amount", 0)
dw_calc_misc_claim.SetItem(ll_row, "cal_clmi_broker_commission", 0)
dw_calc_misc_claim.SetItem(ll_row, "cal_clmi_address_commision", 1)
	
ii_order_misc ++
dw_calc_misc_claim.SetItem(ll_row, "cal_clmi_cal_clmi_order", ii_order_misc)

end event

type dw_calc_misc_claim from u_datawindow_sqlca within w_calc_claims
integer x = 73
integer y = 1272
integer width = 1243
integer height = 240
integer taborder = 30
string dataobject = "d_calc_misc_claim"
boolean vscrollbar = true
boolean border = false
end type

on constructor;call u_datawindow_sqlca::constructor;This.SetRowFocusIndicator(FocusRect!)
end on

on retrieveend;call u_datawindow_sqlca::retrieveend;cb_misc_delete.enabled = this.rowCount() > 0
end on

event itemchanged;call super::itemchanged;integer li_bro_comm

if dwo.name = "claim_type" then
	SELECT BROKER_COMMISSION
	INTO :li_bro_comm
	FROM CLAIM_TYPES
	WHERE CLAIM_TYPE = :data
	;
	COMMIT;
	if li_bro_comm = 1 then
		this.setitem(row, "cal_clmi_broker_commission",1)
	else
		this.setitem(row, "cal_clmi_broker_commission",0)
	end if
	dw_calc_misc_claim.SetItem(row, "cal_clmi_address_commision", 1)
end if

end event

type dw_calc_hea_dev_claim from u_datawindow_sqlca within w_calc_claims
integer x = 73
integer y = 80
integer width = 1792
integer height = 1080
integer taborder = 80
string dataobject = "d_calc_hea_dev_claim"
boolean vscrollbar = true
boolean border = false
end type

on constructor;call u_datawindow_sqlca::constructor;This.SetRowFocusIndicator(FocusRect!)
end on

on retrieveend;call u_datawindow_sqlca::retrieveend;cb_headev_delete.enabled = This.RowCount()>0
end on

event itemchanged;call super::itemchanged;integer li_bro_comm

if dwo.name = "claim_type" then
	SELECT BROKER_COMMISSION
	INTO :li_bro_comm
	FROM CLAIM_TYPES
	WHERE CLAIM_TYPE = :data
	;
	COMMIT;
	if li_bro_comm = 1 then
		this.setitem(row, "cal_hedv_broker_comm_hours",1)
	else
		this.setitem(row, "cal_hedv_broker_comm_hours",0)
	end if
	dw_calc_hea_dev_claim.SetItem(row, "cal_hedv_adr_comm_hours", 1)
end if
end event

type gb_hea_dev from uo_gb_base within w_calc_claims
integer x = 37
integer y = 16
integer width = 2213
integer height = 1176
integer taborder = 90
integer weight = 700
long backcolor = 32304364
string text = "Heating and Deviation"
end type

type gb_misc from uo_gb_base within w_calc_claims
integer x = 37
integer y = 1208
integer width = 1678
integer height = 336
integer taborder = 40
integer weight = 700
long backcolor = 32304364
string text = "Misc. claims"
end type

