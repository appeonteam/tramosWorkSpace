$PBExportHeader$w_progress.srw
$PBExportComments$Progress graph window
forward
global type w_progress from window
end type
type cb_cancel from uo_cb_base within w_progress
end type
type st_name from statictext within w_progress
end type
type uo_time_display from u_time_display within w_progress
end type
type dw_progress from datawindow within w_progress
end type
end forward

global type w_progress from window
integer x = 1495
integer y = 48
integer width = 1417
integer height = 536
boolean titlebar = true
string title = "Progress"
windowtype windowtype = popup!
long backcolor = 32304364
boolean center = true
cb_cancel cb_cancel
st_name st_name
uo_time_display uo_time_display
dw_progress dw_progress
end type
global w_progress w_progress

type variables
int ii_bar_width
string is_cancel_event
window iw_cancel_window
Boolean ib_auto_yield
end variables

forward prototypes
public subroutine wf_progress (real ar_pct, string as_txt)
end prototypes

public subroutine wf_progress (real ar_pct, string as_txt);integer resp

st_name.text = as_txt

if ar_pct > 1 or ar_pct <= 0 then return // if more than 100% or less than 0% then do not display
dw_progress.setredraw(false)
resp = dw_progress.setitem(1,"pct", ar_pct) // change the number displayed
if resp <> 1 then messagebox(string(resp),string(ar_pct)) // and the size of the bar
dw_progress.modify("bar.width = "+string(int(ar_pct * ii_bar_width)))
dw_progress.setredraw(true)

uo_time_display.uf_update(ar_pct * 100)

If ib_auto_yield Then Yield()
end subroutine

event open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_progress
  
 Object     : 
  
 Event	 : Open

 Scope     : Object GLobal

 ************************************************************************************

 Author    : From Powerbulder 
   
 Date       : 

 Description :  Progress status indicator
 			opened by passing the window and event to be triggered if the user closes the window
 			example :
 
			str_progress parm	
			parm.cancel_window = this
 			parm.cancel_event = 'progress_canceled'
 			parm.title = 'title'
			openwithparm(w_progress,parm)

			Use w_progress.wf_progress(percent_complete,status_msg) to change the displayed value
 			and also display an optional status message
 			remember to close the window when everything is complete.

			New arguments:
			i_no_text_lines (number of textlines), -1 = none, 0  = 2 lines, if >1 equals number of textlines

			b_no_auto_yield.  w_progress will automaticly yield in the progress function, if the cb_cancel button
				is enabled. Set b_no_auto_yield to false to turn this functionality off

			d_min_pct_before_remaining. Specifies pct value before remaining time is calculated and displayed

			

 Arguments : str_progress

 Returns   : None

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
?			1.0					Initial version
26-2-97		4.0			MI+PBT	Changed w_progress to handle time and animated watch   
************************************************************************************/
str_progress parm
string tmp,command, bar_x,bar_y
Integer li_tmp, li_textheight

// get the parameters
parm = message.powerobjectparm

this.title = parm.title
iw_cancel_window = parm.cancel_window
is_cancel_event = parm.cancel_event

If (not isValid(iw_cancel_window)) Or (is_cancel_event="") Then
	// Cancel button should not be enabled
	cb_cancel.visible = false
	this.height = this.height - cb_cancel.height  // Resize window
End if

If not parm.b_show_time Then
	// Remove time display, move cancel button up and resize window

	uo_time_display.visible = false
	this.height = this.height - (cb_cancel.y - uo_time_display.y)
	cb_cancel.y = uo_time_display.y
End if

// Adjust for text lines, -1 = no text, 0,1 = 1 textline otherwise i_no_text_lines = number of textlines
If parm.i_no_text_lines = 0 Then 
	parm.i_no_text_lines = 2
Elseif parm.i_no_text_lines = -1 Then
	parm.i_no_text_lines = 0
End if

li_textheight = parm.i_no_text_lines * 65  // Hardcoded text height
if li_textheight <> st_name.height Then
	li_tmp = li_textheight - st_name.height

	st_name.height = li_textheight
	dw_progress.y += li_tmp
	uo_time_display.y += li_tmp
	cb_cancel.y += li_tmp
	
	this.height += li_tmp
End if


// set up the window
dw_progress.insertrow(0)
tmp = dw_progress.describe("pct.width pct.x pct.y") // how wide is the display area ?
ii_bar_width = integer(f_get_token(tmp,'~n'))
bar_x = f_get_token(tmp,'~n')
bar_y = tmp

// set the size and position of the progress bar
command = "bar.width = 0 bar.x = "+bar_x+" bar.y = "+bar_y 
tmp = dw_progress.modify(command)
if len(tmp) > 0 then messagebox(command,tmp)
move(420,350)

f_center_window(this)
uo_time_display.uf_start()

uo_time_display.ib_show_hour = parm.b_show_hour
uo_time_display.ib_show_ms = parm.b_show_ms
uo_time_display.id_min_pct_before_remaining = parm.d_min_pct_before_remaining

ib_auto_yield = (not parm.b_no_auto_yield) And (cb_cancel.enabled)
end event

on w_progress.create
this.cb_cancel=create cb_cancel
this.st_name=create st_name
this.uo_time_display=create uo_time_display
this.dw_progress=create dw_progress
this.Control[]={this.cb_cancel,&
this.st_name,&
this.uo_time_display,&
this.dw_progress}
end on

on w_progress.destroy
destroy(this.cb_cancel)
destroy(this.st_name)
destroy(this.uo_time_display)
destroy(this.dw_progress)
end on

type cb_cancel from uo_cb_base within w_progress
integer x = 585
integer y = 320
integer taborder = 30
string text = "&Cancel"
end type

on clicked;call uo_cb_base::clicked;iw_cancel_window.triggerevent(is_cancel_event)
close(parent)
end on

type st_name from statictext within w_progress
integer x = 37
integer y = 16
integer width = 1335
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
alignment alignment = center!
end type

type uo_time_display from u_time_display within w_progress
integer x = 55
integer y = 176
integer width = 1335
integer height = 144
integer taborder = 20
boolean border = false
long backcolor = 32304364
end type

on uo_time_display.destroy
call u_time_display::destroy
end on

type dw_progress from datawindow within w_progress
integer y = 80
integer width = 1371
integer height = 96
integer taborder = 10
boolean enabled = false
string dataobject = "d_tramos_progress"
boolean border = false
end type

