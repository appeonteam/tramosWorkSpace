$PBExportHeader$w_print_r_charters_report.srw
forward
global type w_print_r_charters_report from w_print_basewindow
end type
type gb_1 from groupbox within w_print_r_charters_report
end type
type st_2 from statictext within w_print_r_charters_report
end type
type sle_chartersn from singlelineedit within w_print_r_charters_report
end type
type cb_retrieve from commandbutton within w_print_r_charters_report
end type
type cb_search_charter from commandbutton within w_print_r_charters_report
end type
end forward

global type w_print_r_charters_report from w_print_basewindow
string title = "Charterers Report"
gb_1 gb_1
st_2 st_2
sle_chartersn sle_chartersn
cb_retrieve cb_retrieve
cb_search_charter cb_search_charter
end type
global w_print_r_charters_report w_print_r_charters_report

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
   	Date       CR-Ref       Author             Comments
   	29/08/14		CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on open;call w_print_basewindow::open;sle_chartersn.Setfocus()
end on

on w_print_r_charters_report.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.st_2=create st_2
this.sle_chartersn=create sle_chartersn
this.cb_retrieve=create cb_retrieve
this.cb_search_charter=create cb_search_charter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_chartersn
this.Control[iCurrent+4]=this.cb_retrieve
this.Control[iCurrent+5]=this.cb_search_charter
end on

on w_print_r_charters_report.destroy
call super::destroy
destroy(this.gb_1)
destroy(this.st_2)
destroy(this.sle_chartersn)
destroy(this.cb_retrieve)
destroy(this.cb_search_charter)
end on

type st_hidemenubar from w_print_basewindow`st_hidemenubar within w_print_r_charters_report
end type

type cbx_save_size from w_print_basewindow`cbx_save_size within w_print_r_charters_report
end type

type dw_print from w_print_basewindow`dw_print within w_print_r_charters_report
integer taborder = 230
string dataobject = "r_statoil_liftings"
end type

type cb_fullpreview from w_print_basewindow`cb_fullpreview within w_print_r_charters_report
end type

type st_previewtext from w_print_basewindow`st_previewtext within w_print_r_charters_report
end type

type em_zoom from w_print_basewindow`em_zoom within w_print_r_charters_report
integer taborder = 180
end type

type cb_pageforward10 from w_print_basewindow`cb_pageforward10 within w_print_r_charters_report
integer taborder = 220
end type

type cb_pageforward from w_print_basewindow`cb_pageforward within w_print_r_charters_report
integer taborder = 210
end type

type cb_pageback from w_print_basewindow`cb_pageback within w_print_r_charters_report
integer taborder = 200
end type

type cb_pageback10 from w_print_basewindow`cb_pageback10 within w_print_r_charters_report
integer taborder = 190
end type

type st_percent from w_print_basewindow`st_percent within w_print_r_charters_report
end type

type st_1 from w_print_basewindow`st_1 within w_print_r_charters_report
end type

type st_misc_print_file from w_print_basewindow`st_misc_print_file within w_print_r_charters_report
end type

type cbx_misc_print_to_file from w_print_basewindow`cbx_misc_print_to_file within w_print_r_charters_report
end type

type cbx_misc_collate_copies from w_print_basewindow`cbx_misc_collate_copies within w_print_r_charters_report
end type

type sle_misc_print_file from w_print_basewindow`sle_misc_print_file within w_print_r_charters_report
end type

type cb_misc_file from w_print_basewindow`cb_misc_file within w_print_r_charters_report
end type

type rb_range_pages from w_print_basewindow`rb_range_pages within w_print_r_charters_report
end type

type rb_range_current from w_print_basewindow`rb_range_current within w_print_r_charters_report
end type

type rb_range_all from w_print_basewindow`rb_range_all within w_print_r_charters_report
end type

type cb_select_filecollate from w_print_basewindow`cb_select_filecollate within w_print_r_charters_report
end type

type cb_select_pages from w_print_basewindow`cb_select_pages within w_print_r_charters_report
end type

type cb_select_options from w_print_basewindow`cb_select_options within w_print_r_charters_report
end type

type st_range from w_print_basewindow`st_range within w_print_r_charters_report
end type

type sle_range_range from w_print_basewindow`sle_range_range within w_print_r_charters_report
integer taborder = 150
end type

type cb_options_printer from w_print_basewindow`cb_options_printer within w_print_r_charters_report
end type

type sle_options_no_copies from w_print_basewindow`sle_options_no_copies within w_print_r_charters_report
end type

type st_options_text from w_print_basewindow`st_options_text within w_print_r_charters_report
end type

type st_options_2 from w_print_basewindow`st_options_2 within w_print_r_charters_report
end type

type st_optins_1 from w_print_basewindow`st_optins_1 within w_print_r_charters_report
end type

type cb_cancel from w_print_basewindow`cb_cancel within w_print_r_charters_report
integer taborder = 170
end type

type cb_print from w_print_basewindow`cb_print within w_print_r_charters_report
integer taborder = 160
end type

type gb_misc_print from w_print_basewindow`gb_misc_print within w_print_r_charters_report
end type

type gb_range from w_print_basewindow`gb_range within w_print_r_charters_report
end type

type gb_options from w_print_basewindow`gb_options within w_print_r_charters_report
end type

type cb_saveas from w_print_basewindow`cb_saveas within w_print_r_charters_report
end type

type gb_1 from groupbox within w_print_r_charters_report
integer x = 18
integer y = 704
integer width = 1097
integer height = 192
integer taborder = 110
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
end type

type st_2 from statictext within w_print_r_charters_report
integer x = 55
integer y = 784
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Charter:"
boolean focusrectangle = false
end type

type sle_chartersn from singlelineedit within w_print_r_charters_report
integer x = 256
integer y = 768
integer width = 366
integer height = 80
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16776960
boolean autohscroll = false
end type

type cb_retrieve from commandbutton within w_print_r_charters_report
integer x = 823
integer y = 768
integer width = 261
integer height = 80
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;string charter_sn

charter_sn = sle_chartersn.text
dw_print.retrieve(charter_sn, uo_global.is_userid )
end event

type cb_search_charter from commandbutton within w_print_r_charters_report
integer x = 640
integer y = 768
integer width = 91
integer height = 80
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "?"
end type

on clicked;sle_chartersn.text =  f_select_from_list ( "dw_charterer_list", 2, "Shortname", 3, "Fullname", 2, "Select",false ) 

If sle_chartersn.text <> "" Then
	cb_retrieve.SetFocus()
	cb_retrieve.TriggerEvent(Clicked!)
End if
end on

