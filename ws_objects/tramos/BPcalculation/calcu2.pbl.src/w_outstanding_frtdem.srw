$PBExportHeader$w_outstanding_frtdem.srw
forward
global type w_outstanding_frtdem from w_list
end type
type st_frt from statictext within w_outstanding_frtdem
end type
type st_2 from statictext within w_outstanding_frtdem
end type
type st_3 from statictext within w_outstanding_frtdem
end type
type st_dem from statictext within w_outstanding_frtdem
end type
type st_tc from statictext within w_outstanding_frtdem
end type
type st_4 from statictext within w_outstanding_frtdem
end type
end forward

global type w_outstanding_frtdem from w_list
integer width = 2688
integer height = 1428
long backcolor = 32304364
boolean center = true
st_frt st_frt
st_2 st_2
st_3 st_3
st_dem st_dem
st_tc st_tc
st_4 st_4
end type
global w_outstanding_frtdem w_outstanding_frtdem

on w_outstanding_frtdem.create
int iCurrent
call super::create
this.st_frt=create st_frt
this.st_2=create st_2
this.st_3=create st_3
this.st_dem=create st_dem
this.st_tc=create st_tc
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_frt
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_dem
this.Control[iCurrent+5]=this.st_tc
this.Control[iCurrent+6]=this.st_4
end on

on w_outstanding_frtdem.destroy
call super::destroy
destroy(this.st_frt)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_dem)
destroy(this.st_tc)
destroy(this.st_4)
end on

event open;call super::open;n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_1,false)
end event

type cb_modify from w_list`cb_modify within w_outstanding_frtdem
boolean visible = false
integer x = 1824
integer y = 528
end type

type cb_delete from w_list`cb_delete within w_outstanding_frtdem
boolean visible = false
integer x = 1824
integer y = 336
end type

type cb_new from w_list`cb_new within w_outstanding_frtdem
boolean visible = false
integer x = 1824
integer y = 240
boolean enabled = false
end type

type cb_close from w_list`cb_close within w_outstanding_frtdem
integer x = 2304
integer y = 1228
integer width = 343
integer height = 100
end type

type cb_refresh from w_list`cb_refresh within w_outstanding_frtdem
boolean visible = false
integer x = 1824
integer y = 432
boolean enabled = false
end type

type rb_header1 from w_list`rb_header1 within w_outstanding_frtdem
integer x = 1861
integer y = 748
long backcolor = 32304364
end type

type rb_header2 from w_list`rb_header2 within w_outstanding_frtdem
integer x = 1861
integer y = 828
long backcolor = 32304364
end type

type st_return from w_list`st_return within w_outstanding_frtdem
integer x = 1605
integer y = 188
long backcolor = 32304364
end type

type st_1 from w_list`st_1 within w_outstanding_frtdem
integer x = 37
integer y = 16
long backcolor = 32304364
end type

type cb_ok from w_list`cb_ok within w_outstanding_frtdem
integer x = 1824
integer y = 240
end type

type cb_cancel from w_list`cb_cancel within w_outstanding_frtdem
integer x = 1824
integer y = 372
end type

type dw_1 from w_list`dw_1 within w_outstanding_frtdem
integer x = 37
integer y = 188
string dataobject = "dw_charterer_list"
end type

event dw_1::clicked;call super::clicked;Decimal {2} ld_frt, ld_dem, ld_tc, ld_transactions
Integer li_rows, li_counter, li_vessel, li_charter, li_claim
String ls_voyage
Datastore lds_dem

if row < 1 then return

li_charter = dw_1.GetItemNumber(row,"chart_nr")

SELECT sum(CLAIMS.CLAIM_AMOUNT_USD)  
INTO :ld_frt  
FROM CLAIMS  
WHERE CLAIMS.CHART_NR = :li_charter  AND CLAIM_TYPE = "FRT" AND
		CLAIMS.CLAIM_AMOUNT_USD > 0;
Commit;

IF ld_frt > 0 THEN 
	w_outstanding_frtdem.st_frt.text = "USD " + String(ld_frt,"#,##0.00")
ELSE
	w_outstanding_frtdem.st_frt.text = "USD 0.00"
END IF

lds_dem = CREATE datastore
lds_dem.dataobject = "d_dem_by_charter"
lds_dem.settransobject(sqlca)
li_rows = lds_dem.retrieve(li_charter)
FOR li_counter = 1 TO li_rows
	li_vessel = lds_dem.GetItemNumber(li_counter,"vessel_nr")
	ls_voyage = lds_dem.GetItemString(li_counter,"voyage_nr")
	li_claim = lds_dem.GetItemNumber(li_counter,"claim_nr")
	SELECT IsNull(SUM( C_TRANS_AMOUNT_USD ),0)
	INTO :ld_transactions
	FROM CLAIM_TRANSACTION
	WHERE CLAIM_TRANSACTION.VESSEL_NR = :li_vessel
	AND CLAIM_TRANSACTION.VOYAGE_NR = :ls_voyage
	AND CLAIM_TRANSACTION.CHART_NR = :li_charter
	AND CLAIM_TRANSACTION.CLAIM_NR = :li_claim ;
	Commit;
	lds_dem.SetItem(li_counter,"trans",ld_transactions)
NEXT
IF li_rows > 0 THEN ld_dem = lds_dem.GetItemDecimal(1,"sumresult")

Destroy lds_dem;

IF ld_dem > 0 THEN 
	w_outstanding_frtdem.st_dem.text = "USD " + String(ld_dem,"#,##0.00")
ELSE
	w_outstanding_frtdem.st_dem.text = "USD 0.00"
END IF

SELECT isnull(sum(NTC_PAYMENT.PAYMENT_BALANCE * isnull(EX_RATE_USD,100)/100),0)   
	into :ld_tc
    FROM NTC_PAYMENT,   
         NTC_TC_CONTRACT   
   WHERE NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID and  
			NTC_TC_CONTRACT.CHART_NR = :li_charter and
         NTC_TC_CONTRACT.TC_HIRE_IN = 0 AND  
         NTC_PAYMENT.EST_DUE_DATE < getdate() and 
			NTC_PAYMENT.PAYMENT_BALANCE <> 0  ;

IF ld_tc > 0 THEN 
	w_outstanding_frtdem.st_tc.text = "USD " + String(ld_tc,"#,##0.00")
ELSE
	w_outstanding_frtdem.st_tc.text = "USD 0.00"
END IF

end event

event dw_1::doubleclicked;// Disable Code
end event

type gb_1 from w_list`gb_1 within w_outstanding_frtdem
integer x = 1824
integer y = 668
integer width = 649
integer height = 300
long textcolor = 0
long backcolor = 32304364
end type

type sle_find from w_list`sle_find within w_outstanding_frtdem
integer x = 37
integer y = 80
end type

type st_frt from statictext within w_outstanding_frtdem
integer x = 1824
integer y = 240
integer width = 745
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "0.00"
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type st_2 from statictext within w_outstanding_frtdem
integer x = 1819
integer y = 172
integer width = 818
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Outst. Frt (sum of balances > 0) :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_outstanding_frtdem
integer x = 1819
integer y = 332
integer width = 850
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Outst. Dem (sum of balances > 0):"
boolean focusrectangle = false
end type

type st_dem from statictext within w_outstanding_frtdem
integer x = 1824
integer y = 400
integer width = 745
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "0.00"
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type st_tc from statictext within w_outstanding_frtdem
integer x = 1824
integer y = 552
integer width = 745
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "0.00"
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type st_4 from statictext within w_outstanding_frtdem
integer x = 1819
integer y = 488
integer width = 850
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Outst. TC (sum of balances > 0):"
boolean focusrectangle = false
end type

