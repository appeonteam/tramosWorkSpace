$PBExportHeader$w_reports_gv.srw
$PBExportComments$Used for selecting the criteria to create the Gas report .
forward
global type w_reports_gv from mt_w_sheet
end type
type cb_open_report from commandbutton within w_reports_gv
end type
type cb_report_list from commandbutton within w_reports_gv
end type
type uo_broker from u_drag_drop_boxes_gas within w_reports_gv
end type
type uo_purpose from u_drag_drop_boxes_gas within w_reports_gv
end type
type uo_port from u_drag_drop_boxes_gas within w_reports_gv
end type
type uo_charterer from u_drag_drop_boxes_gas within w_reports_gv
end type
type uo_charterer_grp from u_drag_drop_boxes_gas within w_reports_gv
end type
type uo_grade_grp from u_drag_drop_boxes_gas within w_reports_gv
end type
type uo_vessel from u_drag_drop_boxes_gas within w_reports_gv
end type
type uo_shiptype from u_drag_drop_boxes_gas within w_reports_gv
end type
type uo_profit_center from u_drag_drop_boxes_gas within w_reports_gv
end type
type st_exp from statictext within w_reports_gv
end type
type st_year_end from statictext within w_reports_gv
end type
type cb_reset from commandbutton within w_reports_gv
end type
type cb_create_report from commandbutton within w_reports_gv
end type
type st_year_start from statictext within w_reports_gv
end type
type sle_start_year from singlelineedit within w_reports_gv
end type
type cb_close from commandbutton within w_reports_gv
end type
type uo_country_charterer from u_drag_drop_boxes_gas within w_reports_gv
end type
type uo_country from u_drag_drop_boxes_gas within w_reports_gv
end type
type sle_end_year from datawindow within w_reports_gv
end type
type sle_start_year_date from datawindow within w_reports_gv
end type
end forward

global type w_reports_gv from mt_w_sheet
integer x = 151
integer y = 252
integer width = 4311
integer height = 2584
string title = "Standard Reports"
boolean maxbox = false
boolean resizable = false
long backcolor = 81324524
boolean center = false
cb_open_report cb_open_report
cb_report_list cb_report_list
uo_broker uo_broker
uo_purpose uo_purpose
uo_port uo_port
uo_charterer uo_charterer
uo_charterer_grp uo_charterer_grp
uo_grade_grp uo_grade_grp
uo_vessel uo_vessel
uo_shiptype uo_shiptype
uo_profit_center uo_profit_center
st_exp st_exp
st_year_end st_year_end
cb_reset cb_reset
cb_create_report cb_create_report
st_year_start st_year_start
sle_start_year sle_start_year
cb_close cb_close
uo_country_charterer uo_country_charterer
uo_country uo_country
sle_end_year sle_end_year
sle_start_year_date sle_start_year_date
end type
global w_reports_gv w_reports_gv

type variables
Private long il_vessel_groupno
Public uo_visual_control iuo_visual_control
Public boolean ib_retrieve = False
Public Integer ii_sheet_count = 0

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref		Author			Comments
   	21/08/14 CR3708		CCY018		F1 help application coverage - modified ancestor.
   </HISTORY>
********************************************************************/
end subroutine

on w_reports_gv.create
int iCurrent
call super::create
this.cb_open_report=create cb_open_report
this.cb_report_list=create cb_report_list
this.uo_broker=create uo_broker
this.uo_purpose=create uo_purpose
this.uo_port=create uo_port
this.uo_charterer=create uo_charterer
this.uo_charterer_grp=create uo_charterer_grp
this.uo_grade_grp=create uo_grade_grp
this.uo_vessel=create uo_vessel
this.uo_shiptype=create uo_shiptype
this.uo_profit_center=create uo_profit_center
this.st_exp=create st_exp
this.st_year_end=create st_year_end
this.cb_reset=create cb_reset
this.cb_create_report=create cb_create_report
this.st_year_start=create st_year_start
this.sle_start_year=create sle_start_year
this.cb_close=create cb_close
this.uo_country_charterer=create uo_country_charterer
this.uo_country=create uo_country
this.sle_end_year=create sle_end_year
this.sle_start_year_date=create sle_start_year_date
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_open_report
this.Control[iCurrent+2]=this.cb_report_list
this.Control[iCurrent+3]=this.uo_broker
this.Control[iCurrent+4]=this.uo_purpose
this.Control[iCurrent+5]=this.uo_port
this.Control[iCurrent+6]=this.uo_charterer
this.Control[iCurrent+7]=this.uo_charterer_grp
this.Control[iCurrent+8]=this.uo_grade_grp
this.Control[iCurrent+9]=this.uo_vessel
this.Control[iCurrent+10]=this.uo_shiptype
this.Control[iCurrent+11]=this.uo_profit_center
this.Control[iCurrent+12]=this.st_exp
this.Control[iCurrent+13]=this.st_year_end
this.Control[iCurrent+14]=this.cb_reset
this.Control[iCurrent+15]=this.cb_create_report
this.Control[iCurrent+16]=this.st_year_start
this.Control[iCurrent+17]=this.sle_start_year
this.Control[iCurrent+18]=this.cb_close
this.Control[iCurrent+19]=this.uo_country_charterer
this.Control[iCurrent+20]=this.uo_country
this.Control[iCurrent+21]=this.sle_end_year
this.Control[iCurrent+22]=this.sle_start_year_date
end on

on w_reports_gv.destroy
call super::destroy
destroy(this.cb_open_report)
destroy(this.cb_report_list)
destroy(this.uo_broker)
destroy(this.uo_purpose)
destroy(this.uo_port)
destroy(this.uo_charterer)
destroy(this.uo_charterer_grp)
destroy(this.uo_grade_grp)
destroy(this.uo_vessel)
destroy(this.uo_shiptype)
destroy(this.uo_profit_center)
destroy(this.st_exp)
destroy(this.st_year_end)
destroy(this.cb_reset)
destroy(this.cb_create_report)
destroy(this.st_year_start)
destroy(this.sle_start_year)
destroy(this.cb_close)
destroy(this.uo_country_charterer)
destroy(this.uo_country)
destroy(this.sle_end_year)
destroy(this.sle_start_year_date)
end on

event open;call super::open;/*************************************************************************************
DATE			INITIALS		DESCRIPTION
16-06-2000	TAU			Doing the startup stuff
*************************************************************************************/
// Create object that runs visual control
iuo_visual_control = Create uo_visual_control

// Reset all controls
cb_reset.PostEvent(Clicked!)

// Open report listwindow
cb_report_list.PostEvent(Clicked!)

sle_end_year.insertrow(0)
sle_start_year_date.insertrow(0)
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_reports_gv
end type

type cb_open_report from commandbutton within w_reports_gv
integer x = 3758
integer y = 2308
integer width = 503
integer height = 84
integer taborder = 190
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Open Report"
end type

event clicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
28-05-2001  1.0	TAU	Initial version. 
************************************************************************************/
str_parm lstr_parm
w_print_preview w1, w2, w3, w4

lstr_parm.report_name = "Empty"
SetNull(lstr_parm.parameters)
SetNull(lstr_parm.blb_data)

If ii_sheet_count = 0 Then
	OpenSheetWithParm(w1,lstr_parm,w_tramos_main,0,Original!)
Elseif ii_sheet_count = 1 Then
	OpenSheetWithParm(w2,lstr_parm,w_tramos_main,0,Original!)
Elseif ii_sheet_count = 2 Then
	OpenSheetWithParm(w3,lstr_parm,w_tramos_main,0,Original!)
Elseif ii_sheet_count = 3 Then
	OpenSheetWithParm(w4,lstr_parm,w_tramos_main,0,Original!)
End if	

ii_sheet_count++

end event

type cb_report_list from commandbutton within w_reports_gv
integer x = 3762
integer y = 2020
integer width = 503
integer height = 84
integer taborder = 170
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Report List"
end type

event clicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
String ls_report_name

Open(w_select_gas_report)

ls_report_name = Message.StringParm
If ls_report_name <> "" Then
	iuo_visual_control.of_window_control(ls_report_name)
End if
end event

type uo_broker from u_drag_drop_boxes_gas within w_reports_gv
integer x = 2875
integer y = 952
integer taborder = 70
end type

on uo_broker.destroy
call u_drag_drop_boxes_gas::destroy
end on

event constructor;call super::constructor;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
this.uf_set_frame_label("Broker")
this.uf_setleft_datawindow("d_gas_broker")
this.uf_setright_datawindow("d_gas_broker")
this.uf_set_left_dw_width(150)
this.uf_set_right_dw_width(150)

end event

event ue_retrieve;call super::ue_retrieve;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_retrieve Then
	/* set redraw off */
	uf_redraw_off()
	
	/* retrieve left dw */
	this.dw_left.retrieve()
	
	/* sort dw's */
	this.uf_set_sort("A",2,1)
	this.uf_sort()
	
	/* set redraw on */
	uf_redraw_on()
End if
end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_enabled Then
	of_enabled()
Else
	of_reset()
	of_enabled()
End if
end event

type uo_purpose from u_drag_drop_boxes_gas within w_reports_gv
integer x = 2629
integer y = 1732
integer taborder = 100
end type

on uo_purpose.destroy
call u_drag_drop_boxes_gas::destroy
end on

event ue_retrieve;call super::ue_retrieve;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_retrieve Then
	/* set redraw off */
	uf_redraw_off()
	
	/* retrieve left dw */
	this.dw_left.retrieve()
	
	/* sort dw's */
	this.uf_sort()
	
	/* set redraw on */
	uf_redraw_on()
End if
end event

event constructor;call super::constructor;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
this.uf_set_frame_label("Purpose")
this.uf_setleft_datawindow("d_gas_purpose")
this.uf_setright_datawindow("d_gas_purpose")
this.uf_set_left_dw_width(110)
this.uf_set_right_dw_width(110)

end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_enabled Then
	of_enabled()
Else
	of_reset()
	of_enabled()
End if
end event

type uo_port from u_drag_drop_boxes_gas within w_reports_gv
integer x = 1289
integer y = 1732
integer taborder = 90
end type

on uo_port.destroy
call u_drag_drop_boxes_gas::destroy
end on

event constructor;call super::constructor;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
this.uf_set_frame_label("Port")
this.uf_setleft_datawindow("d_gas_port")
this.uf_setright_datawindow("d_gas_port")
this.uf_set_left_dw_width(140)
this.uf_set_right_dw_width(140)

end event

event ue_retrieve;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

/* Declare local variables */
long ll_rows_in_right_dw, ll_counter, ll_ret, ll_select_array[]

If ib_retrieve Then
	If uo_country.ib_enabled Then
		/* Set redraw for this object off */
		uf_redraw_off()
		
		// New dataobjects
		this.uf_setleft_datawindow("d_gas_port_arg")
		This.dw_left.Object.DataWindow.Color='16777215'
		this.uf_setright_datawindow("d_gas_port_arg")
		This.dw_right.Object.DataWindow.Color='16777215'
		
		/* If there are no profit centers chosen, stop processing */
		if uo_country.dw_right.rowcount() < 1 then 
			uf_redraw_on()
			return
		end if
		
		/* Allocate array memory for better performance */
		SetNull(ll_select_array[uo_country.dw_right.rowcount()])
		
		/* Get amount of chosen rows */
		ll_rows_in_right_dw = uo_country.dw_right.rowcount()
		
		/* Set array to chosen profit centers */
		for ll_counter = 1 to ll_rows_in_right_dw
			ll_select_array[ll_counter] = uo_country.dw_right.getitemNumber(ll_counter,"ports_country_id")
		next
		
		/* Retrieve left dw in this object */
		ll_ret = this.dw_left.retrieve(ll_select_array[])
		
		/* sort dw's */
		this.uf_set_sort("A",2,1)
		this.uf_sort()
		
		/* Set redraw for this object on */
		uf_redraw_on()
	Else
		/* set redraw off */
		uf_redraw_off()
		
		// New dataobjects
		this.uf_setleft_datawindow("d_gas_port")
		This.dw_left.Object.DataWindow.Color='16777215'
		this.uf_setright_datawindow("d_gas_port")
		This.dw_right.Object.DataWindow.Color='16777215'
		
		/* retrieve left dw */
		this.dw_left.retrieve()
		
		/* sort dw's */
		this.uf_set_sort("A",2,1)
		this.uf_sort()
		
		/* set redraw on */
		uf_redraw_on()
	End if
End if
end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_enabled Then
	of_enabled()
Else
	of_reset()
	of_enabled()
End if
end event

type uo_charterer from u_drag_drop_boxes_gas within w_reports_gv
integer x = 1454
integer y = 952
integer taborder = 60
end type

on uo_charterer.destroy
call u_drag_drop_boxes_gas::destroy
end on

event constructor;call super::constructor;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
this.uf_set_frame_label("Charterer")
this.uf_setleft_datawindow("d_gas_charterer_arg")
this.uf_setright_datawindow("d_gas_charterer_arg")
this.uf_set_left_dw_width(150)
this.uf_set_right_dw_width(150)
end event

event ue_retrieve;call super::ue_retrieve;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_retrieve Then
	If uo_charterer_grp.Enabled = true Then
		//  Retrieve depends on arguments from uo_charterer_grp
		/* Declare local variables */
		Int li_select_array[]
		long ll_rows_in_right_dw, ll_counter
		
		/* Set redraw for this object off */
		uf_redraw_off()
		
		// New dataobjects
		This.dw_left.Object.DataWindow.Color='16777215'
		This.dw_right.Object.DataWindow.Color='16777215'
		
		/* If there are no charterer group chosen, stop processing */
		if uo_charterer_grp.dw_right.rowcount() < 1 then 
			uf_redraw_on()
			return
		end if
		
		/* Allocate array memory for better performance */
		li_select_array[uo_charterer_grp.dw_right.rowcount()] = 0
		
		/* Get amount of chosen rows */
		ll_rows_in_right_dw = uo_charterer_grp.dw_right.rowcount()
		
		/* Set array to chosen charterer groups */
		for ll_counter = 1 to ll_rows_in_right_dw
			li_select_array[ll_counter] = uo_charterer_grp.dw_right.getitemnumber(ll_counter,"ccs_chgp_pk")
		next
		
		/* Retrieve left dw in this object */
		this.dw_left.retrieve(li_select_array)
		
		/* sort dw's */
		this.uf_set_sort("A",2,1)
		this.uf_sort()
		
		/* Set redraw for this object on */
		uf_redraw_on()
	End if
End if

end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_enabled Then
	of_enabled()
Else
	of_reset()
	of_enabled()
End if
end event

type uo_charterer_grp from u_drag_drop_boxes_gas within w_reports_gv
integer x = 32
integer y = 952
integer taborder = 50
end type

on uo_charterer_grp.destroy
call u_drag_drop_boxes_gas::destroy
end on

event constructor;call super::constructor;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
this.uf_set_frame_label("Charterer group")
this.uf_setleft_datawindow("d_gas_charterer_group")
this.uf_setright_datawindow("d_gas_charterer_group")
this.uf_set_left_dw_width(150)
this.uf_set_right_dw_width(150)

end event

event ue_retrieve;call super::ue_retrieve;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_retrieve Then
	/* set redraw off */
	uf_redraw_off()
	
	/* retrieve left dw */
	this.dw_left.retrieve()
	
	/* sort dw's */
	this.uf_set_sort("A",2,1)
	this.uf_sort()
	
	/* set redraw on */
	uf_redraw_on()
End if
end event

event ue_dw_changed;call super::ue_dw_changed;/* Post vessels object retrieve */
If uo_charterer.ib_enabled Then
	uo_charterer.postevent("ue_retrieve")
End if
end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_enabled Then
	of_enabled()
Else
	of_reset()
	of_enabled()
End if
end event

type uo_grade_grp from u_drag_drop_boxes_gas within w_reports_gv
integer x = 3310
integer y = 172
integer taborder = 40
end type

on uo_grade_grp.destroy
call u_drag_drop_boxes_gas::destroy
end on

event constructor;call super::constructor;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
this.uf_set_frame_label("Grade group")
this.uf_setleft_datawindow("d_gas_grade_group")
this.uf_setright_datawindow("d_gas_grade_group")
this.uf_set_left_dw_width(95)
this.uf_set_right_dw_width(95)

end event

event ue_retrieve;call super::ue_retrieve;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_retrieve Then
	/* set redraw off */
	uf_redraw_off()
	
	/* retrieve left dw */
	this.dw_left.retrieve()
	
	/* sort dw's */
	this.uf_sort()
	
	/* set redraw on */
	uf_redraw_on()
End if
end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_enabled Then
	of_enabled()
Else
	of_reset()
	of_enabled()
End if
end event

type uo_vessel from u_drag_drop_boxes_gas within w_reports_gv
integer x = 1970
integer y = 172
integer taborder = 30
end type

on uo_vessel.destroy
call u_drag_drop_boxes_gas::destroy
end on

event constructor;call super::constructor;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
this.uf_set_frame_label("Vessel")
this.uf_setleft_datawindow("d_gas_vessel")
this.uf_setright_datawindow("d_gas_vessel")
this.uf_set_left_dw_width(140)
this.uf_set_right_dw_width(140)

end event

event ue_retrieve;call super::ue_retrieve;/* RMO 23/03-10 Changes related to CR #1227 */

/* Declare local variables */
long ll_select_profit_center[], ll_select_shiptype[]
//long ll_rows_in_right_dw_of_profit_center
long ll_rows_in_right_dw_of_profit_center, ll_rows_in_right_dw_of_shiptype, ll_counter

If ib_retrieve Then
	/* Set redraw for this object off */
	uf_redraw_off()
	
	/* If there are no vessel groups chosen, stop processing */
	if uo_shiptype.dw_right.rowcount() < 1 then 
		uf_redraw_on()
		return
	end if
	
	/* Allocate array memory for better performance */
	ll_select_profit_center[uo_profit_center.dw_right.rowcount()] = 0
	ll_select_shiptype[uo_shiptype.dw_right.rowcount()] = 0
	
	/* Get amount of profit centers  and vessel groups chosen */
	ll_rows_in_right_dw_of_profit_center = uo_profit_center.dw_right.rowcount()
	ll_rows_in_right_dw_of_shiptype = uo_shiptype.dw_right.rowcount()
	
	/* Set array to chosen profit centers */
	for ll_counter = 1 to ll_rows_in_right_dw_of_profit_center
		ll_select_profit_center[ll_counter] = uo_profit_center.dw_right.getitemnumber(ll_counter,"pc_nr")
	next
	
	/* Set array to chosen vessel groups */
	for ll_counter = 1 to ll_rows_in_right_dw_of_shiptype
		ll_select_shiptype[ll_counter] = uo_shiptype.dw_right.getitemnumber(ll_counter,"cal_vest_type_id")
	next
	
	/* Retrieve left dw in this object */
	this.dw_left.retrieve(ll_select_profit_center, ll_select_shiptype)
	
	/* sort dw's */
	this.uf_sort()
	
	/* Set redraw for this object on */
	uf_redraw_on()
End if
end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_enabled Then
	of_enabled()
Else
	of_reset()
	of_enabled()
End if
end event

type uo_shiptype from u_drag_drop_boxes_gas within w_reports_gv
integer x = 960
integer y = 172
integer taborder = 20
end type

on uo_shiptype.destroy
call u_drag_drop_boxes_gas::destroy
end on

event ue_retrieve;call super::ue_retrieve;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
/* Declare local variables */
Int li_select_array[]
long ll_rows_in_right_dw, ll_counter

If ib_retrieve Then
	/* Set redraw for this object off */
	uf_redraw_off()
	
	/* If there are no profit centers chosen, stop processing */
	if uo_profit_center.dw_right.rowcount() < 1 then 
		uf_redraw_on()
		return
	end if
	
	/* Allocate array memory for better performance */
	li_select_array[uo_profit_center.dw_right.rowcount()] = 0
	
	/* Get amount of chosen rows */
	ll_rows_in_right_dw = uo_profit_center.dw_right.rowcount()
	
	/* Set array to chosen profit centers */
	for ll_counter = 1 to ll_rows_in_right_dw
		li_select_array[ll_counter] = uo_profit_center.dw_right.getitemnumber(ll_counter,"pc_nr")
	next
	
	/* Retrieve left dw in this object */
	this.dw_left.retrieve(li_select_array)
	
	/* sort dw's */
	this.uf_sort()
	
	/* Set redraw for this object on */
	uf_redraw_on()
End if
end event

event constructor;call super::constructor;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
this.uf_set_frame_label("Shiptype")
this.uf_setleft_datawindow("d_sq_tb_shiptypes_profitcenter")
this.uf_setright_datawindow("d_sq_tb_shiptypes_profitcenter")
this.uf_set_left_dw_width(100)
this.uf_set_right_dw_width(100)
 
end event

event ue_dw_changed;call super::ue_dw_changed;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-07-2000  1.0	TAU	Initial version. 
************************************************************************************/
/* Post voyages object retrieve */
If uo_vessel.ib_enabled Then
	uo_vessel.postevent("ue_retrieve")
End if

end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_enabled Then
	of_enabled()
Else
	of_reset()
	of_enabled()
End if
end event

type uo_profit_center from u_drag_drop_boxes_gas within w_reports_gv
integer x = 32
integer y = 172
integer taborder = 10
end type

on uo_profit_center.destroy
call u_drag_drop_boxes_gas::destroy
end on

event constructor;call super::constructor;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
this.uf_set_frame_label("Profit center")
this.uf_setleft_datawindow("d_gas_profit_center")
this.uf_setright_datawindow("d_gas_profit_center")
this.uf_set_left_dw_width(90)
this.uf_set_right_dw_width(90)

end event

event ue_retrieve;call super::ue_retrieve;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_retrieve Then
	/* set redraw off */
	uf_redraw_off()
	
	/* retrieve left dw */
	this.dw_left.retrieve( uo_global.is_userid )
	
	// Save number of rows
	ii_left_total += this.dw_left.RowCount()
	
	/* sort dw's */
	this.uf_set_sort("A",2,1)
	this.uf_sort()
	
	/* set redraw on */
	uf_redraw_on()
end if

end event

event ue_dw_changed;call super::ue_dw_changed;/* Post vessels object retrieve */
uo_shiptype.postevent("ue_retrieve")
end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_enabled Then
	of_enabled()
Else
	of_reset()
	of_enabled()
End if
end event

type st_exp from statictext within w_reports_gv
integer x = 37
integer y = 24
integer width = 4247
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_year_end from statictext within w_reports_gv
integer x = 3758
integer y = 1876
integer width = 512
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "End Year (dd-mm-yy)"
boolean focusrectangle = false
end type

type cb_reset from commandbutton within w_reports_gv
integer x = 3762
integer y = 2116
integer width = 503
integer height = 84
integer taborder = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Reset"
end type

event clicked;/*************************************************************************************
DATE			INITIALS		DESCRIPTION
20-06-2000	TAU			
*************************************************************************************/

iuo_visual_control.of_reset()

end event

type cb_create_report from commandbutton within w_reports_gv
integer x = 3758
integer y = 2212
integer width = 503
integer height = 84
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "C&reate Report"
boolean default = true
end type

event clicked;/*************************************************************************************
DATE			INITIALS		DESCRIPTION
19-06-2000	TAU			
*************************************************************************************/
iuo_visual_control.of_create_report()
end event

type st_year_start from statictext within w_reports_gv
integer x = 3758
integer y = 1744
integer width = 512
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Year (yy)"
boolean focusrectangle = false
end type

type sle_start_year from singlelineedit within w_reports_gv
integer x = 3758
integer y = 1800
integer width = 507
integer height = 76
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type cb_close from commandbutton within w_reports_gv
integer x = 3758
integer y = 2408
integer width = 503
integer height = 84
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;/*************************************************************************************
DATE			INITIALS		DESCRIPTION
19-06-2000	TAU			
*************************************************************************************/
Close(Parent)
end event

type uo_country_charterer from u_drag_drop_boxes_gas within w_reports_gv
integer x = 32
integer y = 1732
integer taborder = 80
end type

event constructor;call super::constructor;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
this.uf_set_frame_label("Country")
this.uf_setleft_datawindow("d_gas_country_chart")
this.uf_setright_datawindow("d_gas_country_chart")
this.uf_set_left_dw_width(130)
this.uf_set_right_dw_width(130)

end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_enabled Then
	of_enabled()
Else
	of_reset()
	of_enabled()
End if
end event

event ue_retrieve;call super::ue_retrieve;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_retrieve Then
	/* set redraw off */
	uf_redraw_off()
	
	/* retrieve left dw */
	this.dw_left.retrieve()
	
	/* sort dw's */
	this.uf_set_sort("A",2,1)
	this.uf_sort()
	
	/* set redraw on */
	uf_redraw_on()
End if
end event

event ue_dw_changed;call super::ue_dw_changed;/* Post vessels object retrieve */
//If uo_port.ib_enabled Then
//	uo_port.postevent("ue_retrieve")
//End if
end event

on uo_country_charterer.destroy
call u_drag_drop_boxes_gas::destroy
end on

type uo_country from u_drag_drop_boxes_gas within w_reports_gv
integer x = 32
integer y = 1732
integer taborder = 150
end type

on uo_country.destroy
call u_drag_drop_boxes_gas::destroy
end on

event constructor;call super::constructor;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
this.uf_set_frame_label("Country")
this.uf_setleft_datawindow("d_gas_country")
this.uf_setright_datawindow("d_gas_country")
this.uf_set_left_dw_width(130)
this.uf_set_right_dw_width(130)

end event

event ue_childmodified;call super::ue_childmodified;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_enabled Then
	of_enabled()
Else
	of_reset()
	of_enabled()
End if
end event

event ue_retrieve;call super::ue_retrieve;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

If ib_retrieve Then
	/* set redraw off */
	uf_redraw_off()
	
	/* retrieve left dw */
	this.dw_left.retrieve()
	
	/* sort dw's */
	this.uf_set_sort("A",2,1)
	this.uf_sort()
	
	/* set redraw on */
	uf_redraw_on()
End if
end event

event ue_dw_changed;call super::ue_dw_changed;/* Post vessels object retrieve */
If uo_port.ib_enabled Then
	uo_port.postevent("ue_retrieve")
End if
end event

type sle_end_year from datawindow within w_reports_gv
integer x = 3758
integer y = 1932
integer width = 507
integer height = 76
integer taborder = 130
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_start_year_date from datawindow within w_reports_gv
integer x = 3758
integer y = 1800
integer width = 507
integer height = 76
integer taborder = 110
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

