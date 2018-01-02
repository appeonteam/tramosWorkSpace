$PBExportHeader$w_atobviac_calc_invisible_print.srw
$PBExportComments$The invisible window for printing a calculation
forward
global type w_atobviac_calc_invisible_print from mt_w_sheet_calc
end type
type dw_print from u_datawindow_sqlca within w_atobviac_calc_invisible_print
end type
end forward

global type w_atobviac_calc_invisible_print from mt_w_sheet_calc
boolean visible = false
integer width = 1755
integer height = 676
dw_print dw_print
end type
global w_atobviac_calc_invisible_print w_atobviac_calc_invisible_print

event open;call super::open;s_calc_print lstr_calc_print
DataWindowChild dwc_tmp1, dwc_tmp2, dwc_tmp3, dwc_tmp4, dwc_tmp5

dw_print.DataObject = "d_calc_print_atobviac"  // For at slå current SetTransObject fra

lstr_calc_print = Message.PowerObjectParm
//f_center_window(this)

If IsValid(lstr_calc_print.dw_sensitivity) Then
	dw_print.dataObject = "d_calc_sens_print_atobviac"

	dw_print.GetChild("d_calc_sensitivity_print", dwc_tmp1)
	If lstr_calc_print.dw_sensitivity.ShareData(dwc_tmp1)<>1 Then &
		MessageBox("Error", "Error getting/sharing d_calc_sensitivity_print")

	string ls_header
	ls_header = lstr_calc_print.s_header
	dwc_tmp1.Modify("ftf_header.text = ' "+ls_header+" ' ")
End if

/* Date and time */
time lt_time
date ld_date
string ls_date_time
lt_time = Now()
ld_date = Today()
ls_date_time = String(DateTime(ld_date, lt_time),"dd-mm-yy hh:mm:ss")
dw_print.Modify("tf_date_time.Text = ' " +ls_date_time+ " ' ")

Long ll_tmp
String ls_tmp 

ll_tmp = lstr_calc_print.dw_calc.GetItemNumber(1,"cal_vest_type_id")
If ll_tmp <> 0 Then
	SELECT CAL_VEST_TYPE_NAME
	INTO :ls_tmp
	FROM CAL_VEST
	WHERE CAL_VEST.CAL_VEST_TYPE_ID = :ll_tmp;
	COMMIT;
Else
	ll_tmp = lstr_calc_print.dw_calc.GetItemNumber(1,"cal_calc_vessel_id")
	If ll_tmp <> 0 Then
		SELECT VESSEL_NAME
		INTO :ls_tmp
		FROM VESSELS
		WHERE VESSELS.VESSEL_NR = :ll_tmp;
		COMMIT;
	Else
		ll_tmp = lstr_calc_print.dw_calc.GetItemNumber(1,"cal_clrk_id")
		If ll_tmp <> 0 Then
			SELECT CAL_CLAR.CAL_CLRK_NAME
			INTO :ls_tmp
			FROM CAL_CLAR
			WHERE CAL_CLAR.CAL_CLRK_ID = :ll_tmp;	
			COMMIT;
		End if
	End if
End if

dw_print.Modify ("tf_ship_name.text = ' " + ls_tmp + " ' ")
dw_print.Modify ("t_username.text = '" + f_get_username() + "'")

dw_print.GetChild("d_calc_result_print", dwc_tmp2) 
If lstr_calc_print.dw_calc.ShareData(dwc_tmp2)<> 1 Then
	MessageBox("Error", "Error getting/sharing d_calc_result_print")
End if

dw_print.GetChild("d_calc_cargo_summary_print", dwc_tmp3)
If lstr_calc_print.dw_cargos.ShareData(dwc_tmp3)<>1 Then
	MessageBox("Error", "Error getting/sharing d_calc_cargo_summary_print")
End if

dw_print.GetChild("d_calc_itinerary_print_atobviac", dwc_tmp4)
If lstr_calc_print.dw_calc_itinerary.ShareData(dwc_tmp4)<>1 Then
	MessageBox("Error", "Error getting/sharing d_calc_itinerary_print")
End if

dw_print.GetChild("d_calc_result_detail_print", dwc_tmp5)
If lstr_calc_print.dw_calc.ShareData(dwc_tmp5)<>1 Then
	MessageBox("Error", "Error getting/sharing d_calc_result_detail_print")
End if

int li_tmp
li_tmp = dw_print.Print(TRUE)
If li_tmp = -1 Then MessageBox("Information","Error in printing calculation")

dwc_tmp1.ShareDataOff()
dwc_tmp2.ShareDataOff()
dwc_tmp3.ShareDataOff()
dwc_tmp4.ShareDataOff()
dwc_tmp5.ShareDataOff()

Close(w_atobviac_calc_invisible_print)
end event

on w_atobviac_calc_invisible_print.create
int iCurrent
call super::create
this.dw_print=create dw_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_print
end on

on w_atobviac_calc_invisible_print.destroy
call super::destroy
destroy(this.dw_print)
end on

type st_hidemenubar from mt_w_sheet_calc`st_hidemenubar within w_atobviac_calc_invisible_print
end type

type dw_print from u_datawindow_sqlca within w_atobviac_calc_invisible_print
integer x = 73
integer y = 64
integer width = 439
integer height = 224
string dataobject = "d_calc_print_atobviac"
end type

