$PBExportHeader$w_chmmapping.srw
$PBExportComments$show help index
forward
global type w_chmmapping from w_syswin_master
end type
end forward

global type w_chmmapping from w_syswin_master
integer width = 3648
integer height = 2220
string title = "Online Help Mapping"
boolean minbox = true
boolean center = false
end type
global w_chmmapping w_chmmapping

on w_chmmapping.create
int iCurrent
call super::create
end on

on w_chmmapping.destroy
call super::destroy
end on

event open;call super::open;this.move( 0, 0)

wf_format_datawindow( dw_1)

uo_search.of_initialize(dw_1, "if(isnull( open_path ), '' ,  open_path )+'#'+window_title_text+'#'+chm_index")
uo_search.sle_search.setfocus()
end event

event ue_postupdate;call super::ue_postupdate;uo_global.gds_chmmapping.retrieve( )

return C#Return.Success
end event

type st_hidemenubar from w_syswin_master`st_hidemenubar within w_chmmapping
end type

type cb_cancel from w_syswin_master`cb_cancel within w_chmmapping
integer x = 3255
integer y = 2016
integer taborder = 40
end type

type cb_refresh from w_syswin_master`cb_refresh within w_chmmapping
integer x = 2341
integer y = 2224
integer taborder = 0
end type

type cb_delete from w_syswin_master`cb_delete within w_chmmapping
boolean visible = false
integer x = 1975
integer y = 2208
integer width = 329
integer taborder = 0
end type

type cb_update from w_syswin_master`cb_update within w_chmmapping
integer x = 2907
integer y = 2016
boolean enabled = true
boolean default = false
end type

type cb_new from w_syswin_master`cb_new within w_chmmapping
boolean visible = false
integer x = 1499
integer y = 2208
integer taborder = 0
end type

type dw_1 from w_syswin_master`dw_1 within w_chmmapping
integer width = 3566
integer height = 1744
integer taborder = 20
string dataobject = "d_sq_gr_chmmapping"
boolean ib_columntitlesort = false
boolean ib_multicolumnsort = false
end type

event dw_1::clicked;call super::clicked;if row > 0 then this.event rowfocuschanged(row)

end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;this.selecttext(1, len(this.gettext()))
end event

type uo_search from w_syswin_master`uo_search within w_chmmapping
integer width = 1207
integer taborder = 10
boolean ib_scrolltocurrentrow = true
end type

type st_background from w_syswin_master`st_background within w_chmmapping
end type

