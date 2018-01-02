$PBExportHeader$w_print_target.srw
$PBExportComments$Prints list of targets given Target period start date interval, Target periode end date interval and a sales person interval.
forward
global type w_print_target from w_print_basewindow
end type
type st_2 from uo_st_base within w_print_target
end type
type st_3 from uo_st_base within w_print_target
end type
type st_4 from uo_st_base within w_print_target
end type
type st_5 from uo_st_base within w_print_target
end type
type gb_targ_start from uo_gb_base within w_print_target
end type
type gb_targ_end from uo_gb_base within w_print_target
end type
type sle_namefrom from uo_sle_base within w_print_target
end type
type sle_nameto from uo_sle_base within w_print_target
end type
type st_6 from uo_st_base within w_print_target
end type
type st_7 from uo_st_base within w_print_target
end type
type gb_sales_pers from uo_gb_base within w_print_target
end type
type cb_retrieve from uo_cb_base within w_print_target
end type
type sle_key2 from uo_sle_base within w_print_target
end type
type sle_key4 from uo_sle_base within w_print_target
end type
type sle_key1 from uo_sle_base within w_print_target
end type
type sle_key3 from uo_sle_base within w_print_target
end type
type sle_key5 from uo_sle_base within w_print_target
end type
type gb_keycodes from uo_gb_base within w_print_target
end type
type cbx_expanded from uo_cbx_base within w_print_target
end type
type dw_startfromdate from datawindow within w_print_target
end type
type dw_starttodate from datawindow within w_print_target
end type
type dw_endtodate from datawindow within w_print_target
end type
type dw_endfromdate from datawindow within w_print_target
end type
end forward

global type w_print_target from w_print_basewindow
string title = "Targets/Projects"
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
gb_targ_start gb_targ_start
gb_targ_end gb_targ_end
sle_namefrom sle_namefrom
sle_nameto sle_nameto
st_6 st_6
st_7 st_7
gb_sales_pers gb_sales_pers
cb_retrieve cb_retrieve
sle_key2 sle_key2
sle_key4 sle_key4
sle_key1 sle_key1
sle_key3 sle_key3
sle_key5 sle_key5
gb_keycodes gb_keycodes
cbx_expanded cbx_expanded
dw_startfromdate dw_startfromdate
dw_starttodate dw_starttodate
dw_endtodate dw_endtodate
dw_endfromdate dw_endfromdate
end type
global w_print_target w_print_target

type variables
String is_child

end variables

forward prototypes
public subroutine wf_calculate_support ()
public function long wf_retrieve ()
private subroutine wf_set_dw (string dw_object)
public subroutine documentation ()
end prototypes

public subroutine wf_calculate_support ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_target_detail
  
 Object     : wf_calculate_support
  
 Event	 : 

 Scope     :Public 

 ************************************************************************************

 Author    : Jeannette Holland/Kim Husson Kasperek
   
 Date       : 10-09-96

 Description :Retrieves and calculates support for the Target

 Arguments : none

 Returns   : none

 Variables : 

 Other : The report concist of several rows of targets where some of the targets may have support definitions. For each
		 of theese support definitions must an actual and an estimated figure be calculated.

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
10-09-96		1.0 			JH		Initial version	
************************************************************************************/
// User object to calculate support figures
u_compute_support uo_com_sup

Long ll_count, ll_row, ll_result_act, ll_result_est
String ls_type, ls_cerpid, ls_chartnr, ls_chgp, ls_cerpdate, ls_vv_nr, ls_formula, ls_act, ls_est

/* Initialize the user object used to calculate actual and estimated support figures */
uo_com_sup = CREATE u_compute_support

/* Retrieve Targets with definitions */
ll_count = wf_retrieve()




IF ll_count > 0 THEN
/* For each row calculate actual and estimated support figures */ 
	FOR ll_row = 1 TO ll_count

//Test to see items returned in support definitions
//string aa		
//	aa = dw_print.GetItemString(ll_row,"ccs_sdef_ccs_sdef_desc")
//	IF IsNull(aa) THEN
//		Messagebox("Is NULL","")
//	ELSE 
//	Messagebox("Is Not NULL", "Her: "+ aa)
//	END IF
	
		IF Not IsNull(dw_print.GetItemString(ll_row,"ccs_sdef_ccs_sdef_desc")) THEN
		/* Get all details of the support definition on targets that have it */
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

public function long wf_retrieve ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window : w_print_target
  
 Object     :wf_retrieve 
  
 Event	 : 

 Scope     : public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 22-09-96

 Description :Sets datawindow acording to retrieve criterias and  Retrieves rows 

 Arguments : none

 Returns   : none  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Rows can be retrieved given Target start- and end-date interval, person interval and keycodes. Date and person
		 interrvals must be given at all times. 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-09-96		1.0	 		JH		Initial version
  
************************************************************************************/
Long ll_count

IF  sle_key1.Text = "" AND sle_key2.Text = "" AND sle_key3.Text = "" AND sle_key4.Text = ""&
																		 AND sle_key5.Text = "" THEN
//	Only date interval and person interval is entered

	IF cbx_expanded.Checked  THEN
		wf_set_dw("d_rep_target2_ex")
	ELSE
		wf_set_dw("d_rep_target2")
	END IF

	ll_count = dw_print.Retrieve(dw_startfromdate.GetItemDate(1,1),dw_starttodate.GetItemDate(1,1),&
		dw_endfromdate.GetItemDate(1,1),dw_endtodate.GetItemDate(1,1),sle_namefrom.Text,sle_nameto.Text)
	Return ll_count
END IF


IF sle_key1.Text > ""  OR sle_key2.Text > "" OR  sle_key3.Text > "" OR sle_key4.Text > ""&
																		 OR sle_key5.Text > ""  THEN
//	Date interval and person interval is entered together with at least one key code

	IF cbx_expanded.Checked  THEN
		// Report with action/status details
		wf_set_dw("d_rep_target_ex_ny")
		ll_count = dw_print.Retrieve(dw_startfromdate.GetItemDate(1,1),dw_starttodate.GetItemDate(1,1),&
			dw_endfromdate.GetItemDate(1,1),dw_endtodate.GetItemDate(1,1),sle_namefrom.Text,&
			sle_nameto.Text,sle_key1.Text,sle_key2.Text,sle_key3.Text,sle_key4.Text,sle_key5.Text)
			COMMIT USING SQLCA;
		Return ll_count
						


	ELSE
		// flat target report with support figures
		wf_set_dw("d_rep_target")
		ll_count = dw_print.Retrieve(dw_startfromdate.GetItemDate(1,1),dw_starttodate.GetItemDate(1,1),&
			dw_endfromdate.GetItemDate(1,1),dw_endtodate.GetItemDate(1,1),sle_namefrom.Text,&
			sle_nameto.Text,sle_key1.Text,sle_key2.Text,sle_key3.Text,sle_key4.Text,sle_key5.Text)
			COMMIT USING SQLCA;
		Return ll_count
	END IF
END IF


end function

private subroutine wf_set_dw (string dw_object);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_print_target
  
 Object     :wf_set_dw(dw_object) 
  
 Event	 : 

 Scope     : Private

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 16-09-96

 Description : Sets data object and transaction object for dw_print 

 Arguments : String dw_object gives the data object to be set for dw_print

 Returns   : none  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-09-96		1.0	 		JH		Initial version
  
************************************************************************************/
dw_print.DataObject = dw_object

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

event open;call super::open;
dw_startfromdate.InsertRow(0)
dw_starttodate.InsertRow(0)
dw_endfromdate.InsertRow(0)
dw_endtodate.InsertRow(0)

// Initialize Retrieval arguments
dw_startfromdate.SetItem(1,1,RelativeDate(Today(),-3650))
dw_starttodate.SetItem(1,1,Today())
dw_endfromdate.SetItem(1,1,RelativeDate(Today(),-3650))
dw_endtodate.SetItem(1,1,RelativeDate(Today(),1095))
sle_namefrom.Text = " "
sle_nameto.Text = "ZZZZ"



wf_retrieve()
end event

on w_print_target.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.gb_targ_start=create gb_targ_start
this.gb_targ_end=create gb_targ_end
this.sle_namefrom=create sle_namefrom
this.sle_nameto=create sle_nameto
this.st_6=create st_6
this.st_7=create st_7
this.gb_sales_pers=create gb_sales_pers
this.cb_retrieve=create cb_retrieve
this.sle_key2=create sle_key2
this.sle_key4=create sle_key4
this.sle_key1=create sle_key1
this.sle_key3=create sle_key3
this.sle_key5=create sle_key5
this.gb_keycodes=create gb_keycodes
this.cbx_expanded=create cbx_expanded
this.dw_startfromdate=create dw_startfromdate
this.dw_starttodate=create dw_starttodate
this.dw_endtodate=create dw_endtodate
this.dw_endfromdate=create dw_endfromdate
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.gb_targ_start
this.Control[iCurrent+6]=this.gb_targ_end
this.Control[iCurrent+7]=this.sle_namefrom
this.Control[iCurrent+8]=this.sle_nameto
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.st_7
this.Control[iCurrent+11]=this.gb_sales_pers
this.Control[iCurrent+12]=this.cb_retrieve
this.Control[iCurrent+13]=this.sle_key2
this.Control[iCurrent+14]=this.sle_key4
this.Control[iCurrent+15]=this.sle_key1
this.Control[iCurrent+16]=this.sle_key3
this.Control[iCurrent+17]=this.sle_key5
this.Control[iCurrent+18]=this.gb_keycodes
this.Control[iCurrent+19]=this.cbx_expanded
this.Control[iCurrent+20]=this.dw_startfromdate
this.Control[iCurrent+21]=this.dw_starttodate
this.Control[iCurrent+22]=this.dw_endtodate
this.Control[iCurrent+23]=this.dw_endfromdate
end on

on w_print_target.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.gb_targ_start)
destroy(this.gb_targ_end)
destroy(this.sle_namefrom)
destroy(this.sle_nameto)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.gb_sales_pers)
destroy(this.cb_retrieve)
destroy(this.sle_key2)
destroy(this.sle_key4)
destroy(this.sle_key1)
destroy(this.sle_key3)
destroy(this.sle_key5)
destroy(this.gb_keycodes)
destroy(this.cbx_expanded)
destroy(this.dw_startfromdate)
destroy(this.dw_starttodate)
destroy(this.dw_endtodate)
destroy(this.dw_endfromdate)
end on

type st_hidemenubar from w_print_basewindow`st_hidemenubar within w_print_target
end type

type cbx_save_size from w_print_basewindow`cbx_save_size within w_print_target
end type

type dw_print from w_print_basewindow`dw_print within w_print_target
integer height = 1424
string dataobject = "d_rep_target2_ex"
end type

type cb_fullpreview from w_print_basewindow`cb_fullpreview within w_print_target
integer taborder = 130
end type

type st_previewtext from w_print_basewindow`st_previewtext within w_print_target
integer y = 1712
end type

type em_zoom from w_print_basewindow`em_zoom within w_print_target
integer taborder = 180
end type

type cb_pageforward10 from w_print_basewindow`cb_pageforward10 within w_print_target
integer taborder = 170
end type

type cb_pageforward from w_print_basewindow`cb_pageforward within w_print_target
integer taborder = 160
end type

type cb_pageback from w_print_basewindow`cb_pageback within w_print_target
integer taborder = 150
end type

type cb_pageback10 from w_print_basewindow`cb_pageback10 within w_print_target
integer taborder = 140
end type

type st_percent from w_print_basewindow`st_percent within w_print_target
end type

type st_1 from w_print_basewindow`st_1 within w_print_target
end type

type st_misc_print_file from w_print_basewindow`st_misc_print_file within w_print_target
end type

type cbx_misc_print_to_file from w_print_basewindow`cbx_misc_print_to_file within w_print_target
integer taborder = 240
end type

type cbx_misc_collate_copies from w_print_basewindow`cbx_misc_collate_copies within w_print_target
integer taborder = 250
end type

type sle_misc_print_file from w_print_basewindow`sle_misc_print_file within w_print_target
integer taborder = 260
end type

type cb_misc_file from w_print_basewindow`cb_misc_file within w_print_target
integer taborder = 270
end type

type rb_range_pages from w_print_basewindow`rb_range_pages within w_print_target
end type

type rb_range_current from w_print_basewindow`rb_range_current within w_print_target
end type

type rb_range_all from w_print_basewindow`rb_range_all within w_print_target
end type

type cb_select_filecollate from w_print_basewindow`cb_select_filecollate within w_print_target
integer taborder = 120
end type

type cb_select_pages from w_print_basewindow`cb_select_pages within w_print_target
integer taborder = 110
end type

type cb_select_options from w_print_basewindow`cb_select_options within w_print_target
integer taborder = 100
end type

type st_range from w_print_basewindow`st_range within w_print_target
end type

type sle_range_range from w_print_basewindow`sle_range_range within w_print_target
integer taborder = 310
end type

type cb_options_printer from w_print_basewindow`cb_options_printer within w_print_target
integer taborder = 210
end type

type sle_options_no_copies from w_print_basewindow`sle_options_no_copies within w_print_target
integer taborder = 200
borderstyle borderstyle = stylelowered!
end type

type st_options_text from w_print_basewindow`st_options_text within w_print_target
end type

type st_options_2 from w_print_basewindow`st_options_2 within w_print_target
end type

type st_optins_1 from w_print_basewindow`st_optins_1 within w_print_target
end type

type cb_cancel from w_print_basewindow`cb_cancel within w_print_target
integer taborder = 230
end type

type cb_print from w_print_basewindow`cb_print within w_print_target
integer taborder = 220
end type

type gb_misc_print from w_print_basewindow`gb_misc_print within w_print_target
end type

type gb_range from w_print_basewindow`gb_range within w_print_target
end type

type gb_options from w_print_basewindow`gb_options within w_print_target
end type

type cb_saveas from w_print_basewindow`cb_saveas within w_print_target
end type

type st_2 from uo_st_base within w_print_target
integer x = 110
integer y = 768
integer width = 146
integer height = 64
string text = "From:"
end type

type st_3 from uo_st_base within w_print_target
integer x = 110
integer y = 944
integer width = 146
integer height = 64
boolean bringtotop = true
string text = "From:"
end type

type st_4 from uo_st_base within w_print_target
integer x = 530
integer y = 768
integer width = 91
integer height = 64
string text = "To:"
end type

type st_5 from uo_st_base within w_print_target
integer x = 530
integer y = 944
integer width = 91
integer height = 64
boolean bringtotop = true
string text = "To:"
end type

type gb_targ_start from uo_gb_base within w_print_target
integer x = 18
integer y = 688
integer width = 1097
integer height = 176
integer taborder = 0
string text = "Select Target Period Start Date"
end type

type gb_targ_end from uo_gb_base within w_print_target
integer x = 18
integer y = 880
integer width = 1097
integer height = 176
integer taborder = 0
string text = "Select Target Period End Date"
end type

type sle_namefrom from uo_sle_base within w_print_target
integer x = 274
integer y = 1136
integer width = 238
integer height = 80
integer taborder = 10
boolean autohscroll = true
textcase textcase = upper!
end type

type sle_nameto from uo_sle_base within w_print_target
integer x = 640
integer y = 1136
integer width = 238
integer height = 80
integer taborder = 20
boolean bringtotop = true
boolean autohscroll = true
textcase textcase = upper!
end type

type st_6 from uo_st_base within w_print_target
integer x = 110
integer y = 1152
integer width = 146
integer height = 64
boolean bringtotop = true
string text = "From:"
end type

type st_7 from uo_st_base within w_print_target
integer x = 530
integer y = 1152
integer width = 91
integer height = 64
boolean bringtotop = true
string text = "To:"
end type

type gb_sales_pers from uo_gb_base within w_print_target
integer x = 18
integer y = 1056
integer width = 1097
integer height = 176
integer taborder = 0
string text = "Select Sales Persons"
end type

type cb_retrieve from uo_cb_base within w_print_target
integer x = 768
integer y = 1696
integer width = 274
integer height = 80
integer taborder = 90
string text = "&Retrieve"
end type

event clicked;call super::clicked;dw_endfromdate.Accepttext()
dw_endtodate.Accepttext()
dw_startfromdate.Accepttext()
dw_starttodate.Accepttext()


IF cbx_expanded.Checked THEN
// wants expanded report with action status and no support
	wf_retrieve()
ELSE
// wants base report with support figures, where estimated and actual has to be calculated
	wf_calculate_support()
END IF


end event

type sle_key2 from uo_sle_base within w_print_target
integer x = 640
integer y = 1296
integer taborder = 40
boolean autohscroll = true
end type

type sle_key4 from uo_sle_base within w_print_target
integer x = 640
integer y = 1392
integer taborder = 60
boolean autohscroll = true
end type

type sle_key1 from uo_sle_base within w_print_target
integer x = 274
integer y = 1296
integer taborder = 30
boolean autohscroll = true
end type

type sle_key3 from uo_sle_base within w_print_target
integer x = 274
integer y = 1392
integer taborder = 50
boolean autohscroll = true
end type

type sle_key5 from uo_sle_base within w_print_target
integer x = 274
integer y = 1488
integer taborder = 70
boolean autohscroll = true
end type

type gb_keycodes from uo_gb_base within w_print_target
integer x = 18
integer y = 1232
integer width = 1097
integer height = 368
integer taborder = 0
string text = "With Key Codes"
end type

type cbx_expanded from uo_cbx_base within w_print_target
integer x = 18
integer y = 1616
integer width = 530
integer height = 64
integer taborder = 80
string text = "Show Action/Status"
boolean checked = true
end type

type dw_startfromdate from datawindow within w_print_target
integer x = 247
integer y = 756
integer width = 288
integer height = 88
integer taborder = 300
boolean bringtotop = true
string dataobject = "d_date"
boolean livescroll = true
end type

type dw_starttodate from datawindow within w_print_target
integer x = 640
integer y = 756
integer width = 288
integer height = 88
integer taborder = 280
boolean bringtotop = true
string dataobject = "d_date"
boolean livescroll = true
end type

type dw_endtodate from datawindow within w_print_target
integer x = 635
integer y = 944
integer width = 288
integer height = 88
integer taborder = 290
boolean bringtotop = true
string dataobject = "d_date"
boolean livescroll = true
end type

type dw_endfromdate from datawindow within w_print_target
integer x = 242
integer y = 940
integer width = 288
integer height = 88
integer taborder = 282
boolean bringtotop = true
string dataobject = "d_date"
boolean livescroll = true
end type

