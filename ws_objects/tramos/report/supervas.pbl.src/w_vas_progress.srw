$PBExportHeader$w_vas_progress.srw
$PBExportComments$Window showing progress bar for Super VAS Reports.
forward
global type w_vas_progress from window
end type
type cb_cancel from commandbutton within w_vas_progress
end type
type st_type from statictext within w_vas_progress
end type
type st_vessel_voyage from statictext within w_vas_progress
end type
type st_report_type from statictext within w_vas_progress
end type
type uo_progress_bar from u_progress_bar within w_vas_progress
end type
end forward

global type w_vas_progress from window
integer x = 832
integer y = 360
integer width = 1513
integer height = 680
boolean titlebar = true
string title = "Generating VAS Reports"
long backcolor = 79741120
boolean center = true
cb_cancel cb_cancel
st_type st_type
st_vessel_voyage st_vessel_voyage
st_report_type st_report_type
uo_progress_bar uo_progress_bar
end type
global w_vas_progress w_vas_progress

type variables
boolean ib_canceled = FALSE
end variables

on w_vas_progress.create
this.cb_cancel=create cb_cancel
this.st_type=create st_type
this.st_vessel_voyage=create st_vessel_voyage
this.st_report_type=create st_report_type
this.uo_progress_bar=create uo_progress_bar
this.Control[]={this.cb_cancel,&
this.st_type,&
this.st_vessel_voyage,&
this.st_report_type,&
this.uo_progress_bar}
end on

on w_vas_progress.destroy
destroy(this.cb_cancel)
destroy(this.st_type)
destroy(this.st_vessel_voyage)
destroy(this.st_report_type)
destroy(this.uo_progress_bar)
end on

type cb_cancel from commandbutton within w_vas_progress
integer x = 631
integer y = 456
integer width = 297
integer height = 108
integer taborder = 2
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;ib_canceled = TRUE
end event

type st_type from statictext within w_vas_progress
integer x = 55
integer y = 128
integer width = 1408
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "st_type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_vessel_voyage from statictext within w_vas_progress
integer x = 55
integer y = 224
integer width = 1408
integer height = 76
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "st_vessel_voyage"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_report_type from statictext within w_vas_progress
integer x = 55
integer y = 48
integer width = 1408
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "st_report_type"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_progress_bar from u_progress_bar within w_vas_progress
integer x = 215
integer y = 344
integer width = 1083
integer height = 76
integer taborder = 1
end type

on uo_progress_bar.destroy
call u_progress_bar::destroy
end on

