$PBExportHeader$w_import_progress.srw
$PBExportComments$Progress bar for import disb expenses
forward
global type w_import_progress from window
end type
type uo_progress_bar from u_progress_bar within w_import_progress
end type
type st_validate from statictext within w_import_progress
end type
end forward

global type w_import_progress from window
integer x = 503
integer y = 412
integer width = 1541
integer height = 448
boolean titlebar = true
string title = "Global Agent Import Validation"
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
boolean center = true
uo_progress_bar uo_progress_bar
st_validate st_validate
end type
global w_import_progress w_import_progress

type variables
boolean ib_canceled = FALSE
end variables

on w_import_progress.create
this.uo_progress_bar=create uo_progress_bar
this.st_validate=create st_validate
this.Control[]={this.uo_progress_bar,&
this.st_validate}
end on

on w_import_progress.destroy
destroy(this.uo_progress_bar)
destroy(this.st_validate)
end on

type uo_progress_bar from u_progress_bar within w_import_progress
integer x = 73
integer y = 156
integer width = 1358
integer height = 76
integer taborder = 1
end type

on uo_progress_bar.destroy
call u_progress_bar::destroy
end on

type st_validate from statictext within w_import_progress
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
string text = "Validating expenses"
alignment alignment = center!
boolean focusrectangle = false
end type

