$PBExportHeader$w_print_r_idle_days.srw
forward
global type w_print_r_idle_days from w_print_basewindow
end type
end forward

global type w_print_r_idle_days from w_print_basewindow
string title = "Idle Days Report"
event ue_retrieve pbm_custom13
end type
global w_print_r_idle_days w_print_r_idle_days

forward prototypes
public subroutine documentation ()
end prototypes

event ue_retrieve;dw_print.SetTransObject(SQLCA)
dw_print.Retrieve( uo_global.is_userid  )
end event

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

on open;call w_print_basewindow::open;PostEvent("ue_retrieve")

end on

on w_print_r_idle_days.create
call super::create
end on

on w_print_r_idle_days.destroy
call super::destroy
end on

type st_hidemenubar from w_print_basewindow`st_hidemenubar within w_print_r_idle_days
end type

type cbx_save_size from w_print_basewindow`cbx_save_size within w_print_r_idle_days
end type

type dw_print from w_print_basewindow`dw_print within w_print_r_idle_days
string dataobject = "r_idledays"
end type

type cb_fullpreview from w_print_basewindow`cb_fullpreview within w_print_r_idle_days
end type

type st_previewtext from w_print_basewindow`st_previewtext within w_print_r_idle_days
end type

type em_zoom from w_print_basewindow`em_zoom within w_print_r_idle_days
end type

type cb_pageforward10 from w_print_basewindow`cb_pageforward10 within w_print_r_idle_days
end type

type cb_pageforward from w_print_basewindow`cb_pageforward within w_print_r_idle_days
end type

type cb_pageback from w_print_basewindow`cb_pageback within w_print_r_idle_days
end type

type cb_pageback10 from w_print_basewindow`cb_pageback10 within w_print_r_idle_days
end type

type st_percent from w_print_basewindow`st_percent within w_print_r_idle_days
end type

type st_1 from w_print_basewindow`st_1 within w_print_r_idle_days
end type

type st_misc_print_file from w_print_basewindow`st_misc_print_file within w_print_r_idle_days
end type

type cbx_misc_print_to_file from w_print_basewindow`cbx_misc_print_to_file within w_print_r_idle_days
end type

type cbx_misc_collate_copies from w_print_basewindow`cbx_misc_collate_copies within w_print_r_idle_days
end type

type sle_misc_print_file from w_print_basewindow`sle_misc_print_file within w_print_r_idle_days
end type

type cb_misc_file from w_print_basewindow`cb_misc_file within w_print_r_idle_days
end type

type rb_range_pages from w_print_basewindow`rb_range_pages within w_print_r_idle_days
end type

type rb_range_current from w_print_basewindow`rb_range_current within w_print_r_idle_days
end type

type rb_range_all from w_print_basewindow`rb_range_all within w_print_r_idle_days
end type

type cb_select_filecollate from w_print_basewindow`cb_select_filecollate within w_print_r_idle_days
end type

type cb_select_pages from w_print_basewindow`cb_select_pages within w_print_r_idle_days
end type

type cb_select_options from w_print_basewindow`cb_select_options within w_print_r_idle_days
end type

type st_range from w_print_basewindow`st_range within w_print_r_idle_days
end type

type sle_range_range from w_print_basewindow`sle_range_range within w_print_r_idle_days
end type

type cb_options_printer from w_print_basewindow`cb_options_printer within w_print_r_idle_days
end type

type sle_options_no_copies from w_print_basewindow`sle_options_no_copies within w_print_r_idle_days
end type

type st_options_text from w_print_basewindow`st_options_text within w_print_r_idle_days
end type

type st_options_2 from w_print_basewindow`st_options_2 within w_print_r_idle_days
end type

type st_optins_1 from w_print_basewindow`st_optins_1 within w_print_r_idle_days
end type

type cb_cancel from w_print_basewindow`cb_cancel within w_print_r_idle_days
end type

type cb_print from w_print_basewindow`cb_print within w_print_r_idle_days
end type

type gb_misc_print from w_print_basewindow`gb_misc_print within w_print_r_idle_days
end type

type gb_range from w_print_basewindow`gb_range within w_print_r_idle_days
end type

type gb_options from w_print_basewindow`gb_options within w_print_r_idle_days
end type

type cb_saveas from w_print_basewindow`cb_saveas within w_print_r_idle_days
end type

