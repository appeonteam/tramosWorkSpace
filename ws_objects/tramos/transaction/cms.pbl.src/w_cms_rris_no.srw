$PBExportHeader$w_cms_rris_no.srw
$PBExportComments$Window for resetting the counter for the RRIS number.
forward
global type w_cms_rris_no from mt_w_main
end type
type dw_cms_rris_nr from u_datawindow_sqlca within w_cms_rris_no
end type
type cb_close from commandbutton within w_cms_rris_no
end type
type gb_1 from groupbox within w_cms_rris_no
end type
end forward

global type w_cms_rris_no from mt_w_main
integer x = 832
integer y = 360
integer width = 2158
integer height = 1264
string title = "Last Transaction Number"
boolean maxbox = false
boolean resizable = false
long backcolor = 81324524
dw_cms_rris_nr dw_cms_rris_nr
cb_close cb_close
gb_1 gb_1
end type
global w_cms_rris_no w_cms_rris_no

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_cms_rris_no
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		28/08/14		CR3781		CCY018		The window title match with the text of a menu item
	</HISTORY>
********************************************************************/
end subroutine

on w_cms_rris_no.create
int iCurrent
call super::create
this.dw_cms_rris_nr=create dw_cms_rris_nr
this.cb_close=create cb_close
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cms_rris_nr
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.gb_1
end on

on w_cms_rris_no.destroy
call super::destroy
destroy(this.dw_cms_rris_nr)
destroy(this.cb_close)
destroy(this.gb_1)
end on

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cms_rris_no
  
 Object  : 
  
 Event	:  open

 Scope   : local

 ************************************************************************************

 Author  : Teit Aunt 
   
 Date    : 23-10-97

 Description : 

 Arguments   : None

 Returns     : None

 Variables   : None

 Other : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
23-10-97	1.0		TA		Initial version
  
************************************************************************************/


/* Retrieve data for dw_cms_rris_nr */
dw_cms_rris_nr.SetTransObject(SQLCA)
dw_cms_rris_nr.Retrieve()



end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_cms_rris_no
end type

type dw_cms_rris_nr from u_datawindow_sqlca within w_cms_rris_no
integer x = 64
integer y = 68
integer width = 2034
integer height = 936
integer taborder = 20
boolean enabled = false
string dataobject = "d_cms_rris_nr"
boolean border = false
boolean livescroll = false
end type

type cb_close from commandbutton within w_cms_rris_no
integer x = 1787
integer y = 1044
integer width = 329
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;Close(parent)
end event

type gb_1 from groupbox within w_cms_rris_no
integer x = 41
integer y = 8
integer width = 2075
integer height = 1008
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
end type

