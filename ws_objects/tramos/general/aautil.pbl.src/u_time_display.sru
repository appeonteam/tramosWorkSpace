$PBExportHeader$u_time_display.sru
$PBExportComments$This object displays time/remaining time
forward
global type u_time_display from mt_u_visualobject
end type
type p_4 from picture within u_time_display
end type
type p_8 from picture within u_time_display
end type
type p_7 from picture within u_time_display
end type
type p_3 from picture within u_time_display
end type
type p_2 from picture within u_time_display
end type
type p_6 from picture within u_time_display
end type
type p_5 from picture within u_time_display
end type
type p_1 from picture within u_time_display
end type
type st_elapsed from statictext within u_time_display
end type
type st_remaining from statictext within u_time_display
end type
type st_elapsed_time from statictext within u_time_display
end type
type st_remaining_time from statictext within u_time_display
end type
end forward

global type u_time_display from mt_u_visualobject
integer width = 1390
integer height = 148
boolean border = false
long backcolor = 32304364
p_4 p_4
p_8 p_8
p_7 p_7
p_3 p_3
p_2 p_2
p_6 p_6
p_5 p_5
p_1 p_1
st_elapsed st_elapsed
st_remaining st_remaining
st_elapsed_time st_elapsed_time
st_remaining_time st_remaining_time
end type
global u_time_display u_time_display

type variables
Long il_time 
Integer ii_picture = 1
Boolean ib_show_hour = false
Boolean ib_show_minute = true
Boolean ib_show_second = true
Boolean ib_show_ms = false
Decimal {2} id_min_pct_before_remaining
end variables

forward prototypes
public function string uf_time_to_str (long al_time)
public subroutine uf_start ()
public subroutine uf_update (double al_percent)
public subroutine uf_add_time_str (integer ai_value, ref string as_string)
public subroutine documentation ()
end prototypes

public function string uf_time_to_str (long al_time);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Converts minutes, seconds and milliseconds into a string

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


String ls_result

If ib_show_hour then 
	// Not implemented yet
End if

If ib_show_minute Then 	uf_add_time_str(int(al_time / 60000), ls_result)
If ib_show_second Then uf_add_time_str(Int(Mod(al_time,60000) / 1000), ls_result)
If ib_show_ms Then uf_add_time_str(Mod(al_time,1000), ls_result)

Return(ls_result)

end function

public subroutine uf_start ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Starts the timer

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

il_time = Cpu()
end subroutine

public subroutine uf_update (double al_percent);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Updates the elapsed and remaining time. Completed percent is passsed
 					in the al_percent argument

 Arguments : al_percent as double

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


// Updates elapsed and estimated time

Long ll_tmp
Integer li_x, li_y
String ls_tmp

// update elapsed time

ll_tmp = Cpu() - il_time

ls_tmp = uf_time_to_str(ll_tmp)
If ls_tmp <> st_elapsed_time.text Then st_elapsed_time.text = ls_tmp

If (id_min_pct_before_remaining=0) or (al_percent >= id_min_pct_before_remaining) Then
	ls_tmp = uf_time_to_str(((ll_tmp / al_percent ) * 100) - ll_tmp)
	If ls_tmp <> st_remaining_time.text Then st_remaining_time.text = ls_tmp
	if id_min_pct_before_remaining>0 Then id_min_pct_before_remaining=0
End if


// Update bitmaps

li_x = 1 		// Align rest of bitmaps on same position as P_1
li_y = 1

choose case ii_picture
	case 1
		p_1.draw(li_x,li_y)
	case 2
		p_2.draw(li_x,li_y)
	case 3
		p_3.draw(li_x,li_y)
	case 4
		p_4.draw(li_x,li_y)
	case 5
		p_5.draw(li_x,li_y)
	case 6
		p_6.draw(li_x,li_y)
	case 7
		p_7.draw(li_x,li_y)
	case 8
		p_8.draw(li_x,li_y)
end choose 
if ii_picture = 8 then
	ii_picture = 1
else
	ii_picture ++
end if	

end subroutine

public subroutine uf_add_time_str (integer ai_value, ref string as_string);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Adds time (hour, minutes or seconds) to the final timestring

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


String ls_tmp

If ai_value < 0 Then 
	ls_tmp = "--" 
Else
	ls_tmp = Left(String(ai_value, "00"),2)
End if

If Len(as_string) > 0 Then as_string += ":"

as_string += ls_tmp
end subroutine

public subroutine documentation ();/********************************************************************
   u_time_display
	<OBJECT>
	</OBJECT>
  	<DESC>	</DESC>
  	<USAGE>	</USAGE>
  	<ALSO>	</ALSO>
	<HISTORY>
		Date    		Ref   	Author		Comments
		12/09/14		CR3773	XSZ004		Change icon absolute path to reference path
	</HISTORY>
********************************************************************/
end subroutine

on u_time_display.create
int iCurrent
call super::create
this.p_4=create p_4
this.p_8=create p_8
this.p_7=create p_7
this.p_3=create p_3
this.p_2=create p_2
this.p_6=create p_6
this.p_5=create p_5
this.p_1=create p_1
this.st_elapsed=create st_elapsed
this.st_remaining=create st_remaining
this.st_elapsed_time=create st_elapsed_time
this.st_remaining_time=create st_remaining_time
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_4
this.Control[iCurrent+2]=this.p_8
this.Control[iCurrent+3]=this.p_7
this.Control[iCurrent+4]=this.p_3
this.Control[iCurrent+5]=this.p_2
this.Control[iCurrent+6]=this.p_6
this.Control[iCurrent+7]=this.p_5
this.Control[iCurrent+8]=this.p_1
this.Control[iCurrent+9]=this.st_elapsed
this.Control[iCurrent+10]=this.st_remaining
this.Control[iCurrent+11]=this.st_elapsed_time
this.Control[iCurrent+12]=this.st_remaining_time
end on

on u_time_display.destroy
call super::destroy
destroy(this.p_4)
destroy(this.p_8)
destroy(this.p_7)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_6)
destroy(this.p_5)
destroy(this.p_1)
destroy(this.st_elapsed)
destroy(this.st_remaining)
destroy(this.st_elapsed_time)
destroy(this.st_remaining_time)
end on

type p_4 from picture within u_time_display
integer x = 2153
integer y = 32
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "images\clock4.bmp"
boolean focusrectangle = false
end type

type p_8 from picture within u_time_display
integer x = 2144
integer y = 188
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "images\clock8.bmp"
boolean focusrectangle = false
end type

type p_7 from picture within u_time_display
integer x = 1966
integer y = 200
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "images\clock7.bmp"
boolean focusrectangle = false
end type

type p_3 from picture within u_time_display
integer x = 1920
integer y = 20
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "images\clock3.bmp"
boolean focusrectangle = false
end type

type p_2 from picture within u_time_display
integer x = 1719
integer y = 16
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "images\clock2.bmp"
boolean focusrectangle = false
end type

type p_6 from picture within u_time_display
integer x = 1774
integer y = 200
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "images\clock6.bmp"
boolean focusrectangle = false
end type

type p_5 from picture within u_time_display
integer x = 1591
integer y = 128
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "images\clock5.bmp"
boolean focusrectangle = false
end type

type p_1 from picture within u_time_display
integer x = 1445
integer y = 48
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "images\clock1.bmp"
boolean focusrectangle = false
end type

type st_elapsed from statictext within u_time_display
integer x = 165
integer y = 32
integer width = 297
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
string text = "Elapsed time:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_remaining from statictext within u_time_display
integer x = 731
integer y = 32
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
string text = "Remaining time:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_elapsed_time from statictext within u_time_display
integer x = 475
integer y = 32
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
string text = "--:--"
boolean focusrectangle = false
end type

type st_remaining_time from statictext within u_time_display
integer x = 1097
integer y = 32
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
string text = "--:--"
boolean focusrectangle = false
end type

