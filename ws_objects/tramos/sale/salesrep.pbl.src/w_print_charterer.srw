$PBExportHeader$w_print_charterer.srw
$PBExportComments$Print window to create charterer reports.
forward
global type w_print_charterer from w_print_basewindow
end type
type sle_chart_name_from from uo_sle_base within w_print_charterer
end type
type sle_chart_name_to from uo_sle_base within w_print_charterer
end type
type sle_key1 from uo_sle_base within w_print_charterer
end type
type sle_key2 from uo_sle_base within w_print_charterer
end type
type sle_key3 from uo_sle_base within w_print_charterer
end type
type sle_key5 from uo_sle_base within w_print_charterer
end type
type sle_key4 from uo_sle_base within w_print_charterer
end type
type st_2 from uo_st_base within w_print_charterer
end type
type st_3 from uo_st_base within w_print_charterer
end type
type gb_1 from uo_gb_base within w_print_charterer
end type
type gb_keycodes from uo_gb_base within w_print_charterer
end type
type cb_retrieve from uo_cb_base within w_print_charterer
end type
type cbx_exp_rep from uo_cbx_base within w_print_charterer
end type
end forward

global type w_print_charterer from w_print_basewindow
string title = "Charterers"
sle_chart_name_from sle_chart_name_from
sle_chart_name_to sle_chart_name_to
sle_key1 sle_key1
sle_key2 sle_key2
sle_key3 sle_key3
sle_key5 sle_key5
sle_key4 sle_key4
st_2 st_2
st_3 st_3
gb_1 gb_1
gb_keycodes gb_keycodes
cb_retrieve cb_retrieve
cbx_exp_rep cbx_exp_rep
end type
global w_print_charterer w_print_charterer

forward prototypes
public function long wf_retrieve ()
public subroutine wf_calculate_support ()
private subroutine wf_set_dw (string a_dw_object)
public subroutine documentation ()
end prototypes

public function long wf_retrieve ();Long ll_rows



IF  sle_key1.Text = "" AND sle_key2.Text = "" AND sle_key3.Text = "" AND sle_key4.Text = ""&
																		 AND sle_key5.Text = "" THEN
//	Only charterer interval  is entered
	IF cbx_exp_rep.Checked THEN
		wf_set_dw("d_rep_chart_freeform2")
	ELSE
		wf_set_dw("d_rep_chart2")
	END IF
	ll_rows = dw_print.Retrieve(sle_chart_name_from.Text,sle_chart_name_to.Text)
	COMMIT USING SQLCA;
	Return ll_rows
END IF

IF sle_key1.Text > ""  OR sle_key2.Text > "" OR  sle_key3.Text > "" OR sle_key4.Text > ""&
																		 OR sle_key5.Text > ""  THEN
//	Charterer interval is entered together with at least one key code
	IF cbx_exp_rep.Checked THEN
		wf_set_dw("d_rep_chart_freeform")
	ELSE
		wf_set_dw("d_rep_chart")
	END IF
	ll_rows = dw_print.Retrieve(sle_chart_name_from.Text,sle_chart_name_to.Text,sle_key1.Text ,sle_key2.Text &
			,sle_key3.Text ,sle_key4.Text,sle_key5.Text  )
	COMMIT USING SQLCA;
	Return ll_rows
END IF
end function

public subroutine wf_calculate_support ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : wf_calculate_support
  
 Event	 : 

 Scope     :Public 

 ************************************************************************************

 Author    : Jeannette Holland/Kim Husson Kasperek
   
 Date       : 24-09-96

 Description :Retrieves and calculates support for the Charterer

 Arguments : none

 Returns   : none

 Variables : 

 Other : The report concist of several rows of charterer where some of the charterers may have support definitions. For each
		 of theese support definitions must an actual and an estimated figure be calculated.

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
24-09-96		1.0 			JH		Initial version	
************************************************************************************/
u_compute_support uo_com_sup
Long ll_count,ll_row, ll_result_act,ll_result_est
String ls_type,ls_cerpid,ls_chartnr,ls_chgp,ls_cerpdate,ls_vv_nr, ls_formula, ls_act,ls_est

/* Initialize the user object used to calculate actual and estimated support figures */
uo_com_sup = CREATE u_compute_support

/* Retrieve Report with  Support definitions */
ll_count = wf_retrieve()

IF ll_count > 0 THEN
/* For each row calculate actual and estimated support figures */ 
	FOR ll_row = 1 TO ll_count

////Test to see items returned in support definitions
//string aa		
//	aa = dw_print.GetItemString(ll_row,"ccs_sdef_ccs_sdef_desc")
//	IF IsNull(aa) THEN
//		Messagebox("Is NULL","")
//	ELSE 
//	Messagebox("Is Not NULL", "Her: "+ aa)
//	END IF
//	
		IF Not IsNull(dw_print.GetItemString(ll_row,"ccs_sdef_ccs_sdef_desc")) THEN
		/* Get all details of the support definition on charterer that have it */

		ls_type = dw_print.GetItemString(ll_row,"ccs_sdef_ccs_sdef_con_type")
		IF ls_type = "0" THEN ls_type = ""
		ls_cerpid = dw_print.GetItemString(ll_row,"ccs_sdef_ccs_sdef_cal_cerp_id_list")
		ls_chartnr = dw_print.GetItemString(ll_row,"ccs_sdef_ccs_sdef_chart_nr_list")
		ls_chgp = dw_print.GetItemString(ll_row,"ccs_sdef_ccs_sdef_chgp_list")
		ls_cerpdate = dw_print.GetItemString(ll_row,"ccs_sdef_ccs_sdef_cerp_date_list")
		ls_vv_nr =  dw_print.GetItemString(ll_row,"ccs_sdef_ccs_sdef_vv_no_list")
		ls_formula = dw_print.GetItemString(ll_row,"ccs_sdef_ccs_sdef_form_list")
		/* Make the actual and estimated formulars */
		ls_act = uo_com_sup.uf_compute_support(ls_type,ls_cerpid,ls_chartnr,ls_chgp,ls_cerpdate,ls_vv_nr,ls_formula,"ACTUAL")
		ls_est = uo_com_sup.uf_compute_support(ls_type,ls_cerpid,ls_chartnr,ls_chgp,ls_cerpdate,ls_vv_nr,ls_formula,"ESTIMATE")
		/* Calculate the formular */
		ll_result_act = Long(dw_print.Describe("evaluate('"+ls_act+"', " + String(ll_row) + ")"))
		ll_result_est = Long(dw_print.Describe("evaluate('"+ls_est+"', " + String(ll_row) + ")"))
		/* Show the actual and estimated figures */
		dw_print.SetItem(ll_row,"compute_0017",ll_result_act)
		dw_print.SetItem(ll_row,"compute_0018",ll_result_est)
		END IF
	NEXT
END IF

DESTROY uo_com_sup
end subroutine

private subroutine wf_set_dw (string a_dw_object);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_print_calender
  
 Object     :wf_set_dw(a_dw_object) 
  
 Event	 : 

 Scope     : Private

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 24-09-96

 Description : Sets data object and transaction object for dw_print 

 Arguments : String a_dw_object gives the data object to be set for dw_print

 Returns   : none  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
24-09-96		1.0	 		JH		Initial version
  
************************************************************************************/
dw_print.DataObject = a_dw_object

dw_print.SetTransObject(SQLCA)
end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01/09/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_print_charterer.create
int iCurrent
call super::create
this.sle_chart_name_from=create sle_chart_name_from
this.sle_chart_name_to=create sle_chart_name_to
this.sle_key1=create sle_key1
this.sle_key2=create sle_key2
this.sle_key3=create sle_key3
this.sle_key5=create sle_key5
this.sle_key4=create sle_key4
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_keycodes=create gb_keycodes
this.cb_retrieve=create cb_retrieve
this.cbx_exp_rep=create cbx_exp_rep
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_chart_name_from
this.Control[iCurrent+2]=this.sle_chart_name_to
this.Control[iCurrent+3]=this.sle_key1
this.Control[iCurrent+4]=this.sle_key2
this.Control[iCurrent+5]=this.sle_key3
this.Control[iCurrent+6]=this.sle_key5
this.Control[iCurrent+7]=this.sle_key4
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_keycodes
this.Control[iCurrent+12]=this.cb_retrieve
this.Control[iCurrent+13]=this.cbx_exp_rep
end on

on w_print_charterer.destroy
call super::destroy
destroy(this.sle_chart_name_from)
destroy(this.sle_chart_name_to)
destroy(this.sle_key1)
destroy(this.sle_key2)
destroy(this.sle_key3)
destroy(this.sle_key5)
destroy(this.sle_key4)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_keycodes)
destroy(this.cb_retrieve)
destroy(this.cbx_exp_rep)
end on

type st_hidemenubar from w_print_basewindow`st_hidemenubar within w_print_charterer
end type

type cbx_save_size from w_print_basewindow`cbx_save_size within w_print_charterer
end type

type dw_print from w_print_basewindow`dw_print within w_print_charterer
string dataobject = "d_rep_chart2"
end type

type cb_fullpreview from w_print_basewindow`cb_fullpreview within w_print_charterer
integer taborder = 130
end type

type st_previewtext from w_print_basewindow`st_previewtext within w_print_charterer
end type

type em_zoom from w_print_basewindow`em_zoom within w_print_charterer
integer taborder = 180
end type

type cb_pageforward10 from w_print_basewindow`cb_pageforward10 within w_print_charterer
integer taborder = 170
end type

type cb_pageforward from w_print_basewindow`cb_pageforward within w_print_charterer
integer taborder = 160
end type

type cb_pageback from w_print_basewindow`cb_pageback within w_print_charterer
integer taborder = 150
end type

type cb_pageback10 from w_print_basewindow`cb_pageback10 within w_print_charterer
integer taborder = 140
end type

type st_percent from w_print_basewindow`st_percent within w_print_charterer
end type

type st_1 from w_print_basewindow`st_1 within w_print_charterer
end type

type st_misc_print_file from w_print_basewindow`st_misc_print_file within w_print_charterer
end type

type cbx_misc_print_to_file from w_print_basewindow`cbx_misc_print_to_file within w_print_charterer
integer taborder = 240
end type

type cbx_misc_collate_copies from w_print_basewindow`cbx_misc_collate_copies within w_print_charterer
integer taborder = 250
end type

type sle_misc_print_file from w_print_basewindow`sle_misc_print_file within w_print_charterer
integer taborder = 260
end type

type cb_misc_file from w_print_basewindow`cb_misc_file within w_print_charterer
integer taborder = 270
end type

type rb_range_pages from w_print_basewindow`rb_range_pages within w_print_charterer
end type

type rb_range_current from w_print_basewindow`rb_range_current within w_print_charterer
end type

type rb_range_all from w_print_basewindow`rb_range_all within w_print_charterer
end type

type cb_select_filecollate from w_print_basewindow`cb_select_filecollate within w_print_charterer
integer taborder = 120
end type

type cb_select_pages from w_print_basewindow`cb_select_pages within w_print_charterer
integer taborder = 110
end type

type cb_select_options from w_print_basewindow`cb_select_options within w_print_charterer
integer taborder = 100
end type

type st_range from w_print_basewindow`st_range within w_print_charterer
end type

type sle_range_range from w_print_basewindow`sle_range_range within w_print_charterer
integer taborder = 280
end type

type cb_options_printer from w_print_basewindow`cb_options_printer within w_print_charterer
integer taborder = 210
end type

type sle_options_no_copies from w_print_basewindow`sle_options_no_copies within w_print_charterer
integer taborder = 200
end type

type st_options_text from w_print_basewindow`st_options_text within w_print_charterer
end type

type st_options_2 from w_print_basewindow`st_options_2 within w_print_charterer
end type

type st_optins_1 from w_print_basewindow`st_optins_1 within w_print_charterer
end type

type cb_cancel from w_print_basewindow`cb_cancel within w_print_charterer
integer taborder = 230
end type

type cb_print from w_print_basewindow`cb_print within w_print_charterer
integer taborder = 220
end type

type gb_misc_print from w_print_basewindow`gb_misc_print within w_print_charterer
end type

type gb_range from w_print_basewindow`gb_range within w_print_charterer
end type

type gb_options from w_print_basewindow`gb_options within w_print_charterer
end type

type cb_saveas from w_print_basewindow`cb_saveas within w_print_charterer
end type

type sle_chart_name_from from uo_sle_base within w_print_charterer
integer x = 201
integer y = 768
integer width = 329
integer height = 80
integer taborder = 10
boolean autohscroll = true
end type

type sle_chart_name_to from uo_sle_base within w_print_charterer
integer x = 750
integer y = 768
integer width = 329
integer height = 80
integer taborder = 20
boolean bringtotop = true
boolean autohscroll = true
end type

type sle_key1 from uo_sle_base within w_print_charterer
integer x = 201
integer y = 992
integer taborder = 30
boolean bringtotop = true
boolean autohscroll = true
end type

type sle_key2 from uo_sle_base within w_print_charterer
integer x = 530
integer y = 992
integer taborder = 40
boolean bringtotop = true
boolean autohscroll = true
end type

type sle_key3 from uo_sle_base within w_print_charterer
integer x = 201
integer y = 1104
integer taborder = 50
boolean bringtotop = true
boolean autohscroll = true
end type

type sle_key5 from uo_sle_base within w_print_charterer
integer x = 201
integer y = 1216
integer taborder = 70
boolean bringtotop = true
boolean autohscroll = true
end type

type sle_key4 from uo_sle_base within w_print_charterer
integer x = 530
integer y = 1104
integer taborder = 60
boolean bringtotop = true
boolean autohscroll = true
end type

type st_2 from uo_st_base within w_print_charterer
integer x = 55
integer y = 784
integer width = 146
integer height = 64
string text = "From:"
alignment alignment = left!
end type

type st_3 from uo_st_base within w_print_charterer
integer x = 640
integer y = 784
integer width = 91
integer height = 64
string text = "To:"
alignment alignment = left!
end type

type gb_1 from uo_gb_base within w_print_charterer
integer x = 18
integer y = 688
integer width = 1097
integer height = 224
integer taborder = 0
string text = "Select Charterer"
end type

type gb_keycodes from uo_gb_base within w_print_charterer
integer x = 18
integer y = 912
integer width = 1097
integer height = 432
integer taborder = 0
string text = "With Key Codes"
end type

type cb_retrieve from uo_cb_base within w_print_charterer
integer x = 750
integer y = 1696
integer width = 274
integer height = 80
integer taborder = 90
string text = "Retrieve"
end type

on clicked;call uo_cb_base::clicked;IF cbx_exp_rep.Checked THEN
	wf_retrieve()
ELSE
	wf_calculate_support()
END IF
end on

type cbx_exp_rep from uo_cbx_base within w_print_charterer
integer x = 37
integer y = 1600
integer width = 699
integer taborder = 80
string text = "Expanded Charterer Report  "
end type

