$PBExportHeader$w_print_r_outstanding_bladings.srw
forward
global type w_print_r_outstanding_bladings from w_print_basewindow
end type
type gb_1 from groupbox within w_print_r_outstanding_bladings
end type
type st_2 from statictext within w_print_r_outstanding_bladings
end type
type cb_retrieve from commandbutton within w_print_r_outstanding_bladings
end type
type dw_date from datawindow within w_print_r_outstanding_bladings
end type
type dw_profit_center from datawindow within w_print_r_outstanding_bladings
end type
type st_3 from statictext within w_print_r_outstanding_bladings
end type
type sle_signer from singlelineedit within w_print_r_outstanding_bladings
end type
type st_4 from statictext within w_print_r_outstanding_bladings
end type
type sle_cosigner from singlelineedit within w_print_r_outstanding_bladings
end type
type rr_1 from roundrectangle within w_print_r_outstanding_bladings
end type
end forward

global type w_print_r_outstanding_bladings from w_print_basewindow
string title = "Outstanding Bills of Lading"
gb_1 gb_1
st_2 st_2
cb_retrieve cb_retrieve
dw_date dw_date
dw_profit_center dw_profit_center
st_3 st_3
sle_signer sle_signer
st_4 st_4
sle_cosigner sle_cosigner
rr_1 rr_1
end type
global w_print_r_outstanding_bladings w_print_r_outstanding_bladings

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
   	23/12/14		CR3727		LHG008			Fix bug for print only the current page showing in the preview pane.
   </HISTORY>
********************************************************************/
end subroutine

on w_print_r_outstanding_bladings.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.st_2=create st_2
this.cb_retrieve=create cb_retrieve
this.dw_date=create dw_date
this.dw_profit_center=create dw_profit_center
this.st_3=create st_3
this.sle_signer=create sle_signer
this.st_4=create st_4
this.sle_cosigner=create sle_cosigner
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_retrieve
this.Control[iCurrent+4]=this.dw_date
this.Control[iCurrent+5]=this.dw_profit_center
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_signer
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.sle_cosigner
this.Control[iCurrent+10]=this.rr_1
end on

on w_print_r_outstanding_bladings.destroy
call super::destroy
destroy(this.gb_1)
destroy(this.st_2)
destroy(this.cb_retrieve)
destroy(this.dw_date)
destroy(this.dw_profit_center)
destroy(this.st_3)
destroy(this.sle_signer)
destroy(this.st_4)
destroy(this.sle_cosigner)
destroy(this.rr_1)
end on

event ue_printdefault;call super::ue_printdefault;dw_date.SetFocus()
end event

event open;call super::open;dw_date.InsertRow(0)

dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve( uo_global.is_userid )

if (uo_global.ib_rowsindicator) then dw_profit_center.setrowfocusindicator(FOCUSRECT!)
end event

type st_hidemenubar from w_print_basewindow`st_hidemenubar within w_print_r_outstanding_bladings
end type

type cbx_save_size from w_print_basewindow`cbx_save_size within w_print_r_outstanding_bladings
end type

type dw_print from w_print_basewindow`dw_print within w_print_r_outstanding_bladings
integer taborder = 260
string dataobject = "r_outstanding_bladings"
end type

type cb_fullpreview from w_print_basewindow`cb_fullpreview within w_print_r_outstanding_bladings
end type

type st_previewtext from w_print_basewindow`st_previewtext within w_print_r_outstanding_bladings
end type

type em_zoom from w_print_basewindow`em_zoom within w_print_r_outstanding_bladings
integer taborder = 210
end type

type cb_pageforward10 from w_print_basewindow`cb_pageforward10 within w_print_r_outstanding_bladings
integer taborder = 250
end type

type cb_pageforward from w_print_basewindow`cb_pageforward within w_print_r_outstanding_bladings
integer taborder = 240
end type

type cb_pageback from w_print_basewindow`cb_pageback within w_print_r_outstanding_bladings
integer taborder = 230
end type

type cb_pageback10 from w_print_basewindow`cb_pageback10 within w_print_r_outstanding_bladings
integer taborder = 220
end type

type st_percent from w_print_basewindow`st_percent within w_print_r_outstanding_bladings
end type

type st_1 from w_print_basewindow`st_1 within w_print_r_outstanding_bladings
end type

type st_misc_print_file from w_print_basewindow`st_misc_print_file within w_print_r_outstanding_bladings
integer x = 50
end type

type cbx_misc_print_to_file from w_print_basewindow`cbx_misc_print_to_file within w_print_r_outstanding_bladings
end type

type cbx_misc_collate_copies from w_print_basewindow`cbx_misc_collate_copies within w_print_r_outstanding_bladings
end type

type sle_misc_print_file from w_print_basewindow`sle_misc_print_file within w_print_r_outstanding_bladings
end type

type cb_misc_file from w_print_basewindow`cb_misc_file within w_print_r_outstanding_bladings
end type

type rb_range_pages from w_print_basewindow`rb_range_pages within w_print_r_outstanding_bladings
end type

type rb_range_current from w_print_basewindow`rb_range_current within w_print_r_outstanding_bladings
end type

type rb_range_all from w_print_basewindow`rb_range_all within w_print_r_outstanding_bladings
end type

type cb_select_filecollate from w_print_basewindow`cb_select_filecollate within w_print_r_outstanding_bladings
end type

type cb_select_pages from w_print_basewindow`cb_select_pages within w_print_r_outstanding_bladings
end type

type cb_select_options from w_print_basewindow`cb_select_options within w_print_r_outstanding_bladings
end type

type st_range from w_print_basewindow`st_range within w_print_r_outstanding_bladings
end type

type sle_range_range from w_print_basewindow`sle_range_range within w_print_r_outstanding_bladings
integer taborder = 170
end type

type cb_options_printer from w_print_basewindow`cb_options_printer within w_print_r_outstanding_bladings
end type

type sle_options_no_copies from w_print_basewindow`sle_options_no_copies within w_print_r_outstanding_bladings
end type

type st_options_text from w_print_basewindow`st_options_text within w_print_r_outstanding_bladings
end type

type st_options_2 from w_print_basewindow`st_options_2 within w_print_r_outstanding_bladings
end type

type st_optins_1 from w_print_basewindow`st_optins_1 within w_print_r_outstanding_bladings
end type

type cb_cancel from w_print_basewindow`cb_cancel within w_print_r_outstanding_bladings
integer taborder = 200
end type

type cb_print from w_print_basewindow`cb_print within w_print_r_outstanding_bladings
integer taborder = 190
end type

type gb_misc_print from w_print_basewindow`gb_misc_print within w_print_r_outstanding_bladings
end type

type gb_range from w_print_basewindow`gb_range within w_print_r_outstanding_bladings
end type

type gb_options from w_print_basewindow`gb_options within w_print_r_outstanding_bladings
end type

type cb_saveas from w_print_basewindow`cb_saveas within w_print_r_outstanding_bladings
integer taborder = 180
end type

type gb_1 from groupbox within w_print_r_outstanding_bladings
integer x = 18
integer y = 704
integer width = 1097
integer height = 1344
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
end type

type st_2 from statictext within w_print_r_outstanding_bladings
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
string text = "Start date:"
boolean focusrectangle = false
end type

type cb_retrieve from commandbutton within w_print_r_outstanding_bladings
integer x = 823
integer y = 768
integer width = 261
integer height = 80
integer taborder = 160
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;//dw_date.AcceptText()
//dw_print.retrieve(dw_date.GetItemDate(1,1))

long ll_rows, ll_row , la_pcs[], ll_count=0

dw_date.AcceptText()

ll_rows = dw_profit_center.rowcount()

FOR ll_row=1 TO ll_rows
	if (dw_profit_center.isselected(ll_row)) then
		ll_count++
		la_pcs[ll_count] = dw_profit_center.getitemnumber(ll_row, "pc_nr")
	end if
NEXT

if ll_count = 0 then 
	Messagebox("Profit Center missing", "Please select a Profit Center before retrieving")
	return
end if

dw_print.retrieve(dw_date.GetItemDate(1,1), la_pcs[], uo_global.is_userid )

ll_rows = dw_print.rowcount()
FOR ll_row = 1 TO ll_rows
	dw_print.setitem(ll_row, "signers_s_name" , sle_signer.text)
	dw_print.setitem(ll_row, "co_signers_cs_name", Sle_cosigner.text)
NEXT

end event

type dw_date from datawindow within w_print_r_outstanding_bladings
integer x = 325
integer y = 768
integer width = 315
integer height = 80
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_date"
boolean livescroll = true
end type

type dw_profit_center from datawindow within w_print_r_outstanding_bladings
integer x = 64
integer y = 960
integer width = 718
integer height = 516
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_profit_center"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if (row > 0) then
	if this.isselected(row) then
		this.selectrow(row,false)
	else
		this.selectrow(row,true)
	end if
end if

end event

type st_3 from statictext within w_print_r_outstanding_bladings
integer x = 59
integer y = 1588
integer width = 261
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Signer:"
boolean focusrectangle = false
end type

type sle_signer from singlelineedit within w_print_r_outstanding_bladings
integer x = 64
integer y = 1664
integer width = 960
integer height = 84
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_print_r_outstanding_bladings
integer x = 64
integer y = 1768
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Co-Signer:"
boolean focusrectangle = false
end type

type sle_cosigner from singlelineedit within w_print_r_outstanding_bladings
integer x = 64
integer y = 1844
integer width = 960
integer height = 84
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_print_r_outstanding_bladings
integer linethickness = 1
long fillcolor = 16777215
integer x = 914
integer y = 900
integer width = 165
integer height = 144
integer cornerheight = 40
integer cornerwidth = 46
end type

