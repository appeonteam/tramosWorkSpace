$PBExportHeader$w_print_calender.srw
$PBExportComments$Window lets the user print calendars.
forward
global type w_print_calender from w_print_basewindow
end type
type st_2 from uo_st_base within w_print_calender
end type
type st_3 from uo_st_base within w_print_calender
end type
type gb_1 from uo_gb_base within w_print_calender
end type
type sle_namefrom from uo_sle_base within w_print_calender
end type
type sle_nameto from uo_sle_base within w_print_calender
end type
type st_4 from uo_st_base within w_print_calender
end type
type st_5 from uo_st_base within w_print_calender
end type
type gb_2 from uo_gb_base within w_print_calender
end type
type cb_retrieve from uo_cb_base within w_print_calender
end type
type sle_actiontype from uo_sle_base within w_print_calender
end type
type gb_3 from uo_gb_base within w_print_calender
end type
type sle_key1 from uo_sle_base within w_print_calender
end type
type sle_key5 from uo_sle_base within w_print_calender
end type
type sle_key3 from uo_sle_base within w_print_calender
end type
type sle_key2 from uo_sle_base within w_print_calender
end type
type sle_key4 from uo_sle_base within w_print_calender
end type
type gb_4 from uo_gb_base within w_print_calender
end type
type dw_fromdate from datawindow within w_print_calender
end type
type dw_todate from datawindow within w_print_calender
end type
end forward

global type w_print_calender from w_print_basewindow
string title = "Calendar"
event ue_retrieve pbm_custom09
st_2 st_2
st_3 st_3
gb_1 gb_1
sle_namefrom sle_namefrom
sle_nameto sle_nameto
st_4 st_4
st_5 st_5
gb_2 gb_2
cb_retrieve cb_retrieve
sle_actiontype sle_actiontype
gb_3 gb_3
sle_key1 sle_key1
sle_key5 sle_key5
sle_key3 sle_key3
sle_key2 sle_key2
sle_key4 sle_key4
gb_4 gb_4
dw_fromdate dw_fromdate
dw_todate dw_todate
end type
global w_print_calender w_print_calender

forward prototypes
public subroutine wf_retrieve ()
private subroutine wf_set_dw (string dw_object)
public subroutine documentation ()
end prototypes

event ue_retrieve;call super::ue_retrieve;dw_fromdate.SetItem(1,1,Today())
dw_todate.SetItem(1,1,DateTime(RelativeDate(Today(),30)))
sle_namefrom.Text = " "
sle_nameto.text = "ÅÅÅÅ"
dw_print.Retrieve(DateTime(dw_fromdate.GetItemDate(1,1)),DateTime(dw_todate.GetItemDate(1,1)),sle_namefrom.Text,sle_nameto.Text)
COMMIT USING SQLCA;
end event

public subroutine wf_retrieve ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window : w_print_calender
  
 Object     :wf_retrieve 
  
 Event	 : 

 Scope     : public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 16-09-96

 Description :Sets datawindow acording to retrieve criterias and  Retrieves rows 

 Arguments : none

 Returns   : none  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : Rows can be retrieved given date interval, person interval, action type and keycodes. Date and person
		 interrval must be given at all times. 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-09-96		1.0	 		JH		Initial version
  
************************************************************************************/

dw_print.SetRedraw(FALSE)

IF sle_actiontype.Text = "" AND sle_key1.Text = "" AND sle_key2.Text = "" AND sle_key3.Text = "" AND sle_key4.Text = ""&
																		 AND sle_key5.Text = "" THEN
/*	Only date interval and person interval is entered */
	dw_fromdate.Accepttext()
	dw_todate.Accepttext()
	wf_set_dw("d_calender")
	dw_print.Retrieve(DateTime(dw_fromdate.GetItemDate(1,1)),DateTime(dw_todate.GetItemDate(1,1)),&
																	sle_namefrom.Text,sle_nameto.Text)
	COMMIT USING SQLCA;
	Return
END IF

IF sle_actiontype.Text > "" AND sle_key1.Text = "" AND sle_key2.Text = "" AND sle_key3.Text = "" AND sle_key4.Text = ""&
																		 AND sle_key5.Text = "" THEN
/*	Date interval and person interval is entered together with a action type */
	wf_set_dw("d_calender2")
	dw_print.Retrieve(DateTime(dw_fromdate.GetItemDate(1,1)),DateTime(dw_todate.GetItemDate(1,1)),&
												sle_namefrom.Text,sle_nameto.Text,sle_actiontype.Text)
	COMMIT USING SQLCA;
	Return
END IF

IF sle_actiontype.Text > "" AND (sle_key1.Text > ""  OR sle_key2.Text > "" OR  sle_key3.Text > "" OR sle_key4.Text > ""&
																		 OR sle_key5.Text > "") THEN
/*	Date interval and person interval is entered together with a action type and at least one key code */
	wf_set_dw("d_calender3")
	dw_print.Retrieve(DateTime(dw_fromdate.GetItemDate(1,1)),DateTime(dw_todate.GetItemDate(1,1)),sle_namefrom.Text,&
		sle_nameto.Text,sle_actiontype.Text,sle_key1.Text,sle_key2.Text,sle_key3.Text,sle_key4.Text,sle_key5.Text)
	COMMIT USING SQLCA;
	Return
END IF

IF sle_actiontype.Text = "" AND (sle_key1.Text > ""  OR sle_key2.Text > "" OR  sle_key3.Text > "" OR sle_key4.Text > ""&
																		 OR sle_key5.Text > "") THEN
/*	Date interval and person interval is entered together at least one key code and no action type */
	wf_set_dw("d_calender4")
	dw_print.Retrieve(DateTime(dw_fromdate.GetItemDate(1,1)),DateTime(dw_todate.GetItemDate(1,1)),sle_namefrom.Text,&
		sle_nameto.Text,sle_key1.Text,sle_key2.Text,sle_key3.Text,sle_key4.Text,sle_key5.Text)
	COMMIT USING SQLCA;
	Return
END IF

dw_print.SetRedraw(TRUE)
end subroutine

private subroutine wf_set_dw (string dw_object);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_print_calender
  
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

event open;call super::open;dw_fromdate.InsertRow(0)
dw_todate.InsertRow(0)
PostEvent("ue_retrieve")
end event

on w_print_calender.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
this.sle_namefrom=create sle_namefrom
this.sle_nameto=create sle_nameto
this.st_4=create st_4
this.st_5=create st_5
this.gb_2=create gb_2
this.cb_retrieve=create cb_retrieve
this.sle_actiontype=create sle_actiontype
this.gb_3=create gb_3
this.sle_key1=create sle_key1
this.sle_key5=create sle_key5
this.sle_key3=create sle_key3
this.sle_key2=create sle_key2
this.sle_key4=create sle_key4
this.gb_4=create gb_4
this.dw_fromdate=create dw_fromdate
this.dw_todate=create dw_todate
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.sle_namefrom
this.Control[iCurrent+5]=this.sle_nameto
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.cb_retrieve
this.Control[iCurrent+10]=this.sle_actiontype
this.Control[iCurrent+11]=this.gb_3
this.Control[iCurrent+12]=this.sle_key1
this.Control[iCurrent+13]=this.sle_key5
this.Control[iCurrent+14]=this.sle_key3
this.Control[iCurrent+15]=this.sle_key2
this.Control[iCurrent+16]=this.sle_key4
this.Control[iCurrent+17]=this.gb_4
this.Control[iCurrent+18]=this.dw_fromdate
this.Control[iCurrent+19]=this.dw_todate
end on

on w_print_calender.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.sle_namefrom)
destroy(this.sle_nameto)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.gb_2)
destroy(this.cb_retrieve)
destroy(this.sle_actiontype)
destroy(this.gb_3)
destroy(this.sle_key1)
destroy(this.sle_key5)
destroy(this.sle_key3)
destroy(this.sle_key2)
destroy(this.sle_key4)
destroy(this.gb_4)
destroy(this.dw_fromdate)
destroy(this.dw_todate)
end on

type st_hidemenubar from w_print_basewindow`st_hidemenubar within w_print_calender
end type

type cbx_save_size from w_print_basewindow`cbx_save_size within w_print_calender
end type

type dw_print from w_print_basewindow`dw_print within w_print_calender
integer taborder = 0
string dataobject = "d_calender"
end type

type cb_fullpreview from w_print_basewindow`cb_fullpreview within w_print_calender
integer taborder = 120
end type

type st_previewtext from w_print_basewindow`st_previewtext within w_print_calender
end type

type em_zoom from w_print_basewindow`em_zoom within w_print_calender
integer taborder = 170
end type

type cb_pageforward10 from w_print_basewindow`cb_pageforward10 within w_print_calender
integer taborder = 160
end type

type cb_pageforward from w_print_basewindow`cb_pageforward within w_print_calender
integer taborder = 150
end type

type cb_pageback from w_print_basewindow`cb_pageback within w_print_calender
integer taborder = 140
end type

type cb_pageback10 from w_print_basewindow`cb_pageback10 within w_print_calender
integer taborder = 130
end type

type st_percent from w_print_basewindow`st_percent within w_print_calender
end type

type st_1 from w_print_basewindow`st_1 within w_print_calender
end type

type st_misc_print_file from w_print_basewindow`st_misc_print_file within w_print_calender
end type

type cbx_misc_print_to_file from w_print_basewindow`cbx_misc_print_to_file within w_print_calender
integer taborder = 230
end type

type cbx_misc_collate_copies from w_print_basewindow`cbx_misc_collate_copies within w_print_calender
integer taborder = 240
end type

type sle_misc_print_file from w_print_basewindow`sle_misc_print_file within w_print_calender
integer taborder = 250
end type

type cb_misc_file from w_print_basewindow`cb_misc_file within w_print_calender
integer taborder = 260
end type

type rb_range_pages from w_print_basewindow`rb_range_pages within w_print_calender
end type

type rb_range_current from w_print_basewindow`rb_range_current within w_print_calender
end type

type rb_range_all from w_print_basewindow`rb_range_all within w_print_calender
end type

type cb_select_filecollate from w_print_basewindow`cb_select_filecollate within w_print_calender
integer taborder = 110
end type

type cb_select_pages from w_print_basewindow`cb_select_pages within w_print_calender
integer taborder = 100
end type

type cb_select_options from w_print_basewindow`cb_select_options within w_print_calender
integer taborder = 90
end type

type st_range from w_print_basewindow`st_range within w_print_calender
end type

type sle_range_range from w_print_basewindow`sle_range_range within w_print_calender
integer taborder = 280
end type

type cb_options_printer from w_print_basewindow`cb_options_printer within w_print_calender
integer taborder = 190
end type

type sle_options_no_copies from w_print_basewindow`sle_options_no_copies within w_print_calender
integer taborder = 180
end type

type st_options_text from w_print_basewindow`st_options_text within w_print_calender
end type

type st_options_2 from w_print_basewindow`st_options_2 within w_print_calender
end type

type st_optins_1 from w_print_basewindow`st_optins_1 within w_print_calender
end type

type cb_cancel from w_print_basewindow`cb_cancel within w_print_calender
integer taborder = 210
end type

type cb_print from w_print_basewindow`cb_print within w_print_calender
integer taborder = 200
end type

type gb_misc_print from w_print_basewindow`gb_misc_print within w_print_calender
end type

type gb_range from w_print_basewindow`gb_range within w_print_calender
end type

type gb_options from w_print_basewindow`gb_options within w_print_calender
end type

type cb_saveas from w_print_basewindow`cb_saveas within w_print_calender
end type

type st_2 from uo_st_base within w_print_calender
integer x = 55
integer y = 784
integer width = 146
integer height = 64
string text = "From:"
alignment alignment = left!
end type

type st_3 from uo_st_base within w_print_calender
integer x = 549
integer y = 784
integer width = 91
integer height = 64
boolean bringtotop = true
string text = "To:"
alignment alignment = left!
end type

type gb_1 from uo_gb_base within w_print_calender
integer x = 14
integer y = 704
integer width = 1097
integer height = 192
integer taborder = 0
string text = "Select Date Period"
end type

type sle_namefrom from uo_sle_base within w_print_calender
integer x = 219
integer y = 976
integer width = 311
integer height = 80
integer taborder = 10
boolean autohscroll = true
textcase textcase = upper!
end type

type sle_nameto from uo_sle_base within w_print_calender
integer x = 658
integer y = 976
integer width = 311
integer height = 80
integer taborder = 20
boolean bringtotop = true
boolean autohscroll = true
textcase textcase = upper!
end type

type st_4 from uo_st_base within w_print_calender
integer x = 55
integer y = 976
integer width = 128
integer height = 64
boolean bringtotop = true
string text = "From:"
alignment alignment = left!
end type

type st_5 from uo_st_base within w_print_calender
integer x = 549
integer y = 976
integer width = 73
integer height = 64
boolean bringtotop = true
string text = "To:"
alignment alignment = left!
end type

type gb_2 from uo_gb_base within w_print_calender
integer x = 18
integer y = 896
integer width = 1097
integer height = 176
integer taborder = 0
string text = "Select Sales Persons"
end type

type cb_retrieve from uo_cb_base within w_print_calender
integer x = 750
integer y = 1696
integer width = 274
integer height = 80
integer taborder = 220
string text = "&Retrieve"
end type

on clicked;call uo_cb_base::clicked;wf_retrieve()
end on

type sle_actiontype from uo_sle_base within w_print_calender
integer x = 219
integer y = 1136
integer width = 750
integer height = 80
integer taborder = 30
boolean autohscroll = true
end type

type gb_3 from uo_gb_base within w_print_calender
integer x = 18
integer y = 1072
integer width = 1097
integer height = 160
integer taborder = 0
string text = "Action Type"
end type

type sle_key1 from uo_sle_base within w_print_calender
integer x = 219
integer y = 1312
integer width = 311
integer height = 80
integer taborder = 40
boolean bringtotop = true
boolean autohscroll = true
end type

type sle_key5 from uo_sle_base within w_print_calender
integer x = 219
integer y = 1504
integer width = 311
integer height = 80
integer taborder = 80
boolean bringtotop = true
boolean autohscroll = true
end type

type sle_key3 from uo_sle_base within w_print_calender
integer x = 219
integer y = 1408
integer width = 311
integer height = 80
integer taborder = 60
boolean bringtotop = true
boolean autohscroll = true
end type

type sle_key2 from uo_sle_base within w_print_calender
integer x = 658
integer y = 1312
integer width = 311
integer height = 80
integer taborder = 50
boolean bringtotop = true
boolean autohscroll = true
end type

type sle_key4 from uo_sle_base within w_print_calender
integer x = 658
integer y = 1408
integer width = 311
integer height = 80
integer taborder = 70
boolean bringtotop = true
boolean autohscroll = true
end type

type gb_4 from uo_gb_base within w_print_calender
integer x = 18
integer y = 1232
integer width = 1097
integer height = 384
integer taborder = 0
string text = "Key codes"
end type

type dw_fromdate from datawindow within w_print_calender
integer x = 224
integer y = 768
integer width = 297
integer height = 88
integer taborder = 270
boolean bringtotop = true
string dataobject = "d_date"
boolean livescroll = true
end type

type dw_todate from datawindow within w_print_calender
integer x = 654
integer y = 768
integer width = 297
integer height = 88
integer taborder = 262
boolean bringtotop = true
string dataobject = "d_date"
boolean livescroll = true
end type

