$PBExportHeader$w_print_gifts.srw
$PBExportComments$Window lets the user print a report of contact persons gifts.
forward
global type w_print_gifts from w_print_basewindow
end type
type st_2 from uo_st_base within w_print_gifts
end type
type st_3 from uo_st_base within w_print_gifts
end type
type gb_1 from uo_gb_base within w_print_gifts
end type
type gb_2 from uo_gb_base within w_print_gifts
end type
type sle_namefrom from uo_sle_base within w_print_gifts
end type
type sle_nameto from uo_sle_base within w_print_gifts
end type
type st_4 from uo_st_base within w_print_gifts
end type
type st_5 from uo_st_base within w_print_gifts
end type
type gb_3 from uo_gb_base within w_print_gifts
end type
type rb_gift_desc from uo_rb_base within w_print_gifts
end type
type rb_gift_desc_brok from uo_rb_base within w_print_gifts
end type
type rb_charterer from uo_rb_base within w_print_gifts
end type
type rb_broker from uo_rb_base within w_print_gifts
end type
type cb_retrieve from uo_cb_base within w_print_gifts
end type
type dw_fromdate from datawindow within w_print_gifts
end type
type dw_todate from datawindow within w_print_gifts
end type
end forward

global type w_print_gifts from w_print_basewindow
string title = "Gifts"
event ue_retrieve pbm_custom08
st_2 st_2
st_3 st_3
gb_1 gb_1
gb_2 gb_2
sle_namefrom sle_namefrom
sle_nameto sle_nameto
st_4 st_4
st_5 st_5
gb_3 gb_3
rb_gift_desc rb_gift_desc
rb_gift_desc_brok rb_gift_desc_brok
rb_charterer rb_charterer
rb_broker rb_broker
cb_retrieve cb_retrieve
dw_fromdate dw_fromdate
dw_todate dw_todate
end type
global w_print_gifts w_print_gifts

type variables

end variables

forward prototypes
public subroutine wf_set_datawindow (string a_dw_object)
public subroutine documentation ()
end prototypes

event ue_retrieve;call super::ue_retrieve;Date ld_from


ld_from = RelativeDate(Today(),-10950)

dw_fromdate.SetItem(1,1,DateTime(ld_from))
dw_todate.SetItem(1,1,Today())
sle_namefrom.Text = " "
sle_nameto.text = "ååååå"
dw_print.Retrieve(DateTime(dw_fromdate.GetItemDate(1,1)),DateTime(dw_todate.GetItemDate(1,1)),sle_namefrom.Text,sle_nameto.Text)
COMMIT USING SQLCA;
end event

public subroutine wf_set_datawindow (string a_dw_object);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window : w_print_calender
  
 Object     :wf_set_datawindow 
  
 Event	 : 

 Scope     : public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 18-09-96

 Description :Sets data object, transaction object and retrieves rows. 

 Arguments : String a_dw_object  gives the data object to be used

 Returns   : none  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
18-09-96		1.0	 		JH		Initial version
  
************************************************************************************/
dw_print.SetRedraw(FALSE)
dw_print.dataobject = a_dw_object

dw_print.SetTransObject(SQLCA)


dw_print.Retrieve(DateTime(dw_fromdate.GetItemDate(1,1)),DateTime(dw_todate.GetItemDate(1,1)),sle_namefrom.Text,sle_nameto.Text)
COMMIT USING SQLCA;

dw_print.SetRedraw(TRUE)


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

on w_print_gifts.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
this.sle_namefrom=create sle_namefrom
this.sle_nameto=create sle_nameto
this.st_4=create st_4
this.st_5=create st_5
this.gb_3=create gb_3
this.rb_gift_desc=create rb_gift_desc
this.rb_gift_desc_brok=create rb_gift_desc_brok
this.rb_charterer=create rb_charterer
this.rb_broker=create rb_broker
this.cb_retrieve=create cb_retrieve
this.dw_fromdate=create dw_fromdate
this.dw_todate=create dw_todate
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.gb_2
this.Control[iCurrent+5]=this.sle_namefrom
this.Control[iCurrent+6]=this.sle_nameto
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.gb_3
this.Control[iCurrent+10]=this.rb_gift_desc
this.Control[iCurrent+11]=this.rb_gift_desc_brok
this.Control[iCurrent+12]=this.rb_charterer
this.Control[iCurrent+13]=this.rb_broker
this.Control[iCurrent+14]=this.cb_retrieve
this.Control[iCurrent+15]=this.dw_fromdate
this.Control[iCurrent+16]=this.dw_todate
end on

on w_print_gifts.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.sle_namefrom)
destroy(this.sle_nameto)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.gb_3)
destroy(this.rb_gift_desc)
destroy(this.rb_gift_desc_brok)
destroy(this.rb_charterer)
destroy(this.rb_broker)
destroy(this.cb_retrieve)
destroy(this.dw_fromdate)
destroy(this.dw_todate)
end on

type st_hidemenubar from w_print_basewindow`st_hidemenubar within w_print_gifts
end type

type cbx_save_size from w_print_basewindow`cbx_save_size within w_print_gifts
integer taborder = 190
end type

type dw_print from w_print_basewindow`dw_print within w_print_gifts
integer taborder = 140
string dataobject = "d_gift_all_chart"
end type

type cb_fullpreview from w_print_basewindow`cb_fullpreview within w_print_gifts
integer taborder = 80
end type

type st_previewtext from w_print_basewindow`st_previewtext within w_print_gifts
end type

type em_zoom from w_print_basewindow`em_zoom within w_print_gifts
integer taborder = 130
end type

type cb_pageforward10 from w_print_basewindow`cb_pageforward10 within w_print_gifts
integer taborder = 120
end type

type cb_pageforward from w_print_basewindow`cb_pageforward within w_print_gifts
integer taborder = 110
end type

type cb_pageback from w_print_basewindow`cb_pageback within w_print_gifts
integer taborder = 100
end type

type cb_pageback10 from w_print_basewindow`cb_pageback10 within w_print_gifts
integer taborder = 90
end type

type st_percent from w_print_basewindow`st_percent within w_print_gifts
end type

type st_1 from w_print_basewindow`st_1 within w_print_gifts
end type

type st_misc_print_file from w_print_basewindow`st_misc_print_file within w_print_gifts
end type

type cbx_misc_print_to_file from w_print_basewindow`cbx_misc_print_to_file within w_print_gifts
integer taborder = 200
end type

type cbx_misc_collate_copies from w_print_basewindow`cbx_misc_collate_copies within w_print_gifts
integer taborder = 210
end type

type sle_misc_print_file from w_print_basewindow`sle_misc_print_file within w_print_gifts
integer taborder = 220
end type

type cb_misc_file from w_print_basewindow`cb_misc_file within w_print_gifts
integer taborder = 230
end type

type rb_range_pages from w_print_basewindow`rb_range_pages within w_print_gifts
end type

type rb_range_current from w_print_basewindow`rb_range_current within w_print_gifts
end type

type rb_range_all from w_print_basewindow`rb_range_all within w_print_gifts
end type

type cb_select_filecollate from w_print_basewindow`cb_select_filecollate within w_print_gifts
integer taborder = 70
end type

type cb_select_pages from w_print_basewindow`cb_select_pages within w_print_gifts
integer taborder = 60
end type

type cb_select_options from w_print_basewindow`cb_select_options within w_print_gifts
integer taborder = 50
end type

type st_range from w_print_basewindow`st_range within w_print_gifts
end type

type sle_range_range from w_print_basewindow`sle_range_range within w_print_gifts
integer taborder = 250
end type

type cb_options_printer from w_print_basewindow`cb_options_printer within w_print_gifts
integer taborder = 160
end type

type sle_options_no_copies from w_print_basewindow`sle_options_no_copies within w_print_gifts
integer taborder = 150
end type

type st_options_text from w_print_basewindow`st_options_text within w_print_gifts
end type

type st_options_2 from w_print_basewindow`st_options_2 within w_print_gifts
end type

type st_optins_1 from w_print_basewindow`st_optins_1 within w_print_gifts
end type

type cb_cancel from w_print_basewindow`cb_cancel within w_print_gifts
integer taborder = 180
end type

type cb_print from w_print_basewindow`cb_print within w_print_gifts
integer taborder = 170
end type

type gb_misc_print from w_print_basewindow`gb_misc_print within w_print_gifts
end type

type gb_range from w_print_basewindow`gb_range within w_print_gifts
end type

type gb_options from w_print_basewindow`gb_options within w_print_gifts
end type

type cb_saveas from w_print_basewindow`cb_saveas within w_print_gifts
end type

type st_2 from uo_st_base within w_print_gifts
integer x = 110
integer y = 784
integer width = 201
integer height = 80
string text = "From:"
alignment alignment = left!
end type

type st_3 from uo_st_base within w_print_gifts
integer x = 640
integer y = 784
integer width = 110
integer height = 80
boolean bringtotop = true
string text = "To:"
alignment alignment = left!
end type

type gb_1 from uo_gb_base within w_print_gifts
integer x = 18
integer y = 1168
integer width = 1097
integer height = 432
integer taborder = 40
string text = "Sort Gifts on"
end type

type gb_2 from uo_gb_base within w_print_gifts
integer x = 18
integer y = 704
integer width = 1097
integer height = 208
integer taborder = 0
string text = "Select Gift Date Period"
end type

type sle_namefrom from uo_sle_base within w_print_gifts
integer x = 238
integer y = 1008
integer width = 347
integer height = 80
integer taborder = 20
boolean autohscroll = true
end type

type sle_nameto from uo_sle_base within w_print_gifts
integer x = 713
integer y = 1008
integer width = 347
integer height = 80
integer taborder = 30
boolean bringtotop = true
boolean autohscroll = true
end type

type st_4 from uo_st_base within w_print_gifts
integer x = 91
integer y = 1008
integer width = 128
integer height = 80
string text = "From:"
alignment alignment = left!
end type

type st_5 from uo_st_base within w_print_gifts
integer x = 640
integer y = 1008
integer width = 73
integer height = 64
boolean bringtotop = true
string text = "To:"
alignment alignment = left!
end type

type gb_3 from uo_gb_base within w_print_gifts
integer x = 18
integer y = 912
integer width = 1097
integer height = 240
integer taborder = 0
string text = "Select Broker or Charterer Long Name"
end type

type rb_gift_desc from uo_rb_base within w_print_gifts
integer x = 91
integer y = 1232
integer width = 768
integer height = 64
boolean bringtotop = true
string text = "Gift Description Charterers"
boolean checked = true
end type

type rb_gift_desc_brok from uo_rb_base within w_print_gifts
integer x = 91
integer y = 1312
integer width = 859
integer height = 64
boolean bringtotop = true
string text = "Gift Description Brokers"
end type

type rb_charterer from uo_rb_base within w_print_gifts
integer x = 91
integer y = 1392
integer width = 805
integer height = 64
boolean bringtotop = true
string text = "Charterers Contact Persons"
end type

type rb_broker from uo_rb_base within w_print_gifts
integer x = 91
integer y = 1472
integer width = 731
integer height = 64
boolean bringtotop = true
string text = "Brokers Contact Persons "
end type

type cb_retrieve from uo_cb_base within w_print_gifts
integer x = 805
integer y = 1696
integer width = 274
integer height = 80
integer taborder = 10
string text = "Retrieve"
end type

event clicked;call super::clicked;dw_fromdate.Accepttext()
dw_todate.Accepttext()


IF rb_gift_desc.Checked THEN
	wf_set_datawindow("d_gift_all_chart")	
ELSEIF rb_gift_desc_brok.Checked THEN
	wf_set_datawindow("d_gift_all_brok")
ELSEIF rb_charterer.Checked THEN
	wf_set_datawindow("d_gift_report")
ELSEIF rb_broker.Checked THEN
	wf_set_datawindow("d_gift_report_broker")
END IF

end event

type dw_fromdate from datawindow within w_print_gifts
integer x = 293
integer y = 772
integer width = 293
integer height = 84
integer taborder = 240
boolean bringtotop = true
string dataobject = "d_date"
boolean livescroll = true
end type

type dw_todate from datawindow within w_print_gifts
integer x = 759
integer y = 772
integer width = 288
integer height = 84
integer taborder = 232
boolean bringtotop = true
string dataobject = "d_date"
boolean livescroll = true
end type

