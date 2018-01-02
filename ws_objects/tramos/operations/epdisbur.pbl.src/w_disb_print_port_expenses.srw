$PBExportHeader$w_disb_print_port_expenses.srw
$PBExportComments$Print of port expenses.
forward
global type w_disb_print_port_expenses from w_print_basewindow
end type
type dw_2 from uo_datawindow within w_disb_print_port_expenses
end type
type gb_1 from groupbox within w_disb_print_port_expenses
end type
type box from groupbox within w_disb_print_port_expenses
end type
end forward

global type w_disb_print_port_expenses from w_print_basewindow
integer width = 4571
dw_2 dw_2
gb_1 gb_1
box box
end type
global w_disb_print_port_expenses w_disb_print_port_expenses

type variables
s_disbursement lstr_disb
end variables

event open;call super::open;lstr_disb = Message.PowerObjectParm
string ls_agent_n1

ii_startup = 2
ib_autoclose = TRUE

dw_print.Retrieve(lstr_disb.vessel_nr,lstr_disb.voyage_nr,lstr_disb.port_code,lstr_disb.pcn)
dw_2.SetTransObject(SQLCA)
dw_2.Retrieve(lstr_disb.vessel_nr,lstr_disb.voyage_nr,lstr_disb.port_code,lstr_disb.pcn)
commit;
ls_agent_n1 = dw_2.GetItemString(1,"agents_agent_n_1")
dw_print.modify("agent_name.text='"+ls_agent_n1+"'")

IF dw_2.RowCount() > 1 THEN
		dw_print.modify("subtotal_local.visible=0")
		dw_print.modify("total_local.visible=0")
		dw_print.modify("ex_rate.visible=0")
END IF
dw_print.modify("signer.text='"+uo_global.getuserid()+"'")
dw_print.POST setfocus()
end event

on w_disb_print_port_expenses.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.gb_1=create gb_1
this.box=create box
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.box
end on

on w_disb_print_port_expenses.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.gb_1)
destroy(this.box)
end on

type cbx_save_size from w_print_basewindow`cbx_save_size within w_disb_print_port_expenses
end type

type dw_print from w_print_basewindow`dw_print within w_disb_print_port_expenses
integer taborder = 200
string dataobject = "dw_disb_print_port_expenses"
end type

type cb_fullpreview from w_print_basewindow`cb_fullpreview within w_disb_print_port_expenses
end type

type st_previewtext from w_print_basewindow`st_previewtext within w_disb_print_port_expenses
end type

type em_zoom from w_print_basewindow`em_zoom within w_disb_print_port_expenses
integer taborder = 150
end type

type cb_pageforward10 from w_print_basewindow`cb_pageforward10 within w_disb_print_port_expenses
integer taborder = 190
end type

type cb_pageforward from w_print_basewindow`cb_pageforward within w_disb_print_port_expenses
integer taborder = 180
end type

type cb_pageback from w_print_basewindow`cb_pageback within w_disb_print_port_expenses
integer taborder = 170
end type

type cb_pageback10 from w_print_basewindow`cb_pageback10 within w_disb_print_port_expenses
integer taborder = 160
end type

type st_percent from w_print_basewindow`st_percent within w_disb_print_port_expenses
end type

type st_1 from w_print_basewindow`st_1 within w_disb_print_port_expenses
end type

type st_misc_print_file from w_print_basewindow`st_misc_print_file within w_disb_print_port_expenses
end type

type cbx_misc_print_to_file from w_print_basewindow`cbx_misc_print_to_file within w_disb_print_port_expenses
end type

type cbx_misc_collate_copies from w_print_basewindow`cbx_misc_collate_copies within w_disb_print_port_expenses
end type

type sle_misc_print_file from w_print_basewindow`sle_misc_print_file within w_disb_print_port_expenses
integer taborder = 100
end type

type cb_misc_file from w_print_basewindow`cb_misc_file within w_disb_print_port_expenses
integer taborder = 110
end type

type rb_range_pages from w_print_basewindow`rb_range_pages within w_disb_print_port_expenses
end type

type rb_range_current from w_print_basewindow`rb_range_current within w_disb_print_port_expenses
end type

type rb_range_all from w_print_basewindow`rb_range_all within w_disb_print_port_expenses
end type

type cb_select_filecollate from w_print_basewindow`cb_select_filecollate within w_disb_print_port_expenses
integer taborder = 40
end type

type cb_select_pages from w_print_basewindow`cb_select_pages within w_disb_print_port_expenses
integer taborder = 30
end type

type cb_select_options from w_print_basewindow`cb_select_options within w_disb_print_port_expenses
end type

type st_range from w_print_basewindow`st_range within w_disb_print_port_expenses
end type

type sle_range_range from w_print_basewindow`sle_range_range within w_disb_print_port_expenses
integer taborder = 120
end type

type cb_options_printer from w_print_basewindow`cb_options_printer within w_disb_print_port_expenses
integer taborder = 90
end type

type sle_options_no_copies from w_print_basewindow`sle_options_no_copies within w_disb_print_port_expenses
end type

type st_options_text from w_print_basewindow`st_options_text within w_disb_print_port_expenses
end type

type st_options_2 from w_print_basewindow`st_options_2 within w_disb_print_port_expenses
end type

type st_optins_1 from w_print_basewindow`st_optins_1 within w_disb_print_port_expenses
end type

type cb_cancel from w_print_basewindow`cb_cancel within w_disb_print_port_expenses
integer taborder = 140
end type

type cb_print from w_print_basewindow`cb_print within w_disb_print_port_expenses
integer taborder = 130
end type

type gb_misc_print from w_print_basewindow`gb_misc_print within w_disb_print_port_expenses
end type

type gb_range from w_print_basewindow`gb_range within w_disb_print_port_expenses
end type

type gb_options from w_print_basewindow`gb_options within w_disb_print_port_expenses
end type

type cb_saveas from w_print_basewindow`cb_saveas within w_disb_print_port_expenses
end type

type dw_2 from uo_datawindow within w_disb_print_port_expenses
integer x = 37
integer y = 820
integer width = 1051
integer height = 420
integer taborder = 20
string dataobject = "dw_max_agent"
boolean border = false
end type

type gb_1 from groupbox within w_disb_print_port_expenses
integer x = 18
integer y = 760
integer width = 1097
integer height = 496
integer taborder = 80
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Agents for Port"
borderstyle borderstyle = stylelowered!
end type

type box from groupbox within w_disb_print_port_expenses
boolean visible = false
integer x = 91
integer y = 192
integer width = 1097
integer height = 496
integer taborder = 210
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "File/Collate"
borderstyle borderstyle = stylelowered!
end type

