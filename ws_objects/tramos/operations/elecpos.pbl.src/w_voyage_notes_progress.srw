$PBExportHeader$w_voyage_notes_progress.srw
$PBExportComments$Progress window for import of Voyage Notes
forward
global type w_voyage_notes_progress from window
end type
type uo_progress_bar from u_progress_bar within w_voyage_notes_progress
end type
type st_text from statictext within w_voyage_notes_progress
end type
end forward

global type w_voyage_notes_progress from window
integer x = 503
integer y = 412
integer width = 1513
integer height = 424
boolean titlebar = true
string title = "Voyage Note Import Validation / Update"
long backcolor = 79741120
boolean center = true
uo_progress_bar uo_progress_bar
st_text st_text
end type
global w_voyage_notes_progress w_voyage_notes_progress

type variables
boolean ib_canceled = FALSE
end variables

on w_voyage_notes_progress.create
this.uo_progress_bar=create uo_progress_bar
this.st_text=create st_text
this.Control[]={this.uo_progress_bar,&
this.st_text}
end on

on w_voyage_notes_progress.destroy
destroy(this.uo_progress_bar)
destroy(this.st_text)
end on

type uo_progress_bar from u_progress_bar within w_voyage_notes_progress
integer x = 73
integer y = 156
integer width = 1358
integer height = 76
integer taborder = 1
end type

on uo_progress_bar.destroy
call u_progress_bar::destroy
end on

type st_text from statictext within w_voyage_notes_progress
integer x = 55
integer y = 48
integer width = 1408
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean enabled = false
string text = "Validating Voyage Notes..."
alignment alignment = center!
boolean focusrectangle = false
end type

