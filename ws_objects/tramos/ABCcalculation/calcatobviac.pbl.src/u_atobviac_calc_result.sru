$PBExportHeader$u_atobviac_calc_result.sru
$PBExportComments$result subobject - used by u_calculation
forward
global type u_atobviac_calc_result from u_atobviac_calc_base_sqlca
end type
type cb_print_preview from commandbutton within u_atobviac_calc_result
end type
type dw_calc_result from u_datawindow_sqlca within u_atobviac_calc_result
end type
end forward

global type u_atobviac_calc_result from u_atobviac_calc_base_sqlca
integer width = 4603
integer height = 2404
boolean border = false
long backcolor = 32304364
cb_print_preview cb_print_preview
dw_calc_result dw_calc_result
end type
global u_atobviac_calc_result u_atobviac_calc_result

on u_atobviac_calc_result.create
int iCurrent
call super::create
this.cb_print_preview=create cb_print_preview
this.dw_calc_result=create dw_calc_result
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print_preview
this.Control[iCurrent+2]=this.dw_calc_result
end on

on u_atobviac_calc_result.destroy
call super::destroy
destroy(this.cb_print_preview)
destroy(this.dw_calc_result)
end on

event constructor;call super::constructor;n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwformformater(dw_calc_result)

end event

type cb_print_preview from commandbutton within u_atobviac_calc_result
integer x = 2432
integer y = 1616
integer width = 343
integer height = 100
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Preview"
end type

event clicked;w_atobviac_calc_calculation lw_calc_calculation
//lw_calc_calculation = parent.parentwindow()
lw_calc_calculation = w_tramos_main.GetActiveSheet()
lw_calc_calculation.uo_calculation.uf_print_preview()
//lw_calc_calculation.uo_calculation.uf_print_preview()

end event

type dw_calc_result from u_datawindow_sqlca within u_atobviac_calc_result
integer width = 4539
integer height = 2344
integer taborder = 1
string dataobject = "d_calc_result"
boolean border = false
boolean livescroll = true
end type

