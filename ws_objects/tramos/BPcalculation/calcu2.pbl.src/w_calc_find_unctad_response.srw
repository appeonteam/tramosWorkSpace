$PBExportHeader$w_calc_find_unctad_response.srw
$PBExportComments$Find UNCTAD code for a habor, or a near port
forward
global type w_calc_find_unctad_response from w_calc_find_unctad
end type
type cb_1 from commandbutton within w_calc_find_unctad_response
end type
end forward

global type w_calc_find_unctad_response from w_calc_find_unctad
windowtype windowtype = response!
cb_1 cb_1
end type
global w_calc_find_unctad_response w_calc_find_unctad_response

on w_calc_find_unctad_response.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_calc_find_unctad_response.destroy
call super::destroy
destroy(this.cb_1)
end on

type st_hidemenubar from w_calc_find_unctad`st_hidemenubar within w_calc_find_unctad_response
end type

type cb_close from w_calc_find_unctad`cb_close within w_calc_find_unctad_response
boolean visible = false
end type

type dw_calc_longlat from w_calc_find_unctad`dw_calc_longlat within w_calc_find_unctad_response
boolean ib_autochildmodified = true
end type

type dw_calc_longlat_search from w_calc_find_unctad`dw_calc_longlat_search within w_calc_find_unctad_response
boolean livescroll = true
end type

type cb_clear from w_calc_find_unctad`cb_clear within w_calc_find_unctad_response
end type

type cb_search_longlat from w_calc_find_unctad`cb_search_longlat within w_calc_find_unctad_response
end type

type st_norows from w_calc_find_unctad`st_norows within w_calc_find_unctad_response
end type

type dw_calc_unctad_search_name from w_calc_find_unctad`dw_calc_unctad_search_name within w_calc_find_unctad_response
boolean livescroll = true
end type

type cb_search_name from w_calc_find_unctad`cb_search_name within w_calc_find_unctad_response
end type

type cbx_los_distance from w_calc_find_unctad`cbx_los_distance within w_calc_find_unctad_response
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

type gb_1 from w_calc_find_unctad`gb_1 within w_calc_find_unctad_response
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

type gb_3 from w_calc_find_unctad`gb_3 within w_calc_find_unctad_response
integer textsize = -8
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

type cb_1 from commandbutton within w_calc_find_unctad_response
integer x = 2263
integer y = 1336
integer width = 517
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close with UNCTAD"
end type

event clicked;string ls_unctadcode
integer li_row

li_row = dw_calc_longlat.GetSelectedRow(0)
ls_unctadcode = dw_calc_longlat.GetItemString(li_row,"cal_unct_unctadcode")

CloseWithReturn(Parent,ls_unctadcode)
end event

