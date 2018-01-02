$PBExportHeader$mt_w_popupbox.srw
$PBExportComments$Styled popup window used for special cases such as: portvalidator and sensitivity
forward
global type mt_w_popupbox from mt_w_popup
end type
type r_styledborder from rectangle within mt_w_popupbox
end type
type p_close from picture within mt_w_popupbox
end type
type p_refresh from picture within mt_w_popupbox
end type
type st_title from statictext within mt_w_popupbox
end type
type st_spacer from statictext within mt_w_popupbox
end type
end forward

global type mt_w_popupbox from mt_w_popup
integer width = 2898
integer height = 1488
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
event ue_closeitem ( )
event ue_refresh ( )
r_styledborder r_styledborder
p_close p_close
p_refresh p_refresh
st_title st_title
st_spacer st_spacer
end type
global mt_w_popupbox mt_w_popupbox

type variables
string is_title="<give me a title please>"
/* could be message/ warning / error */
string is_windowstyle = "standard"
private integer ii_redraw

end variables

forward prototypes
public function integer wf_initstyles (integer ai_width, integer ai_height)
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
public subroutine documentation ()
end prototypes

event ue_closeitem();close(this)
end event

event ue_refresh();/* code here to refresh window if necessary */
end event

public function integer wf_initstyles (integer ai_width, integer ai_height);long ll_usecolor = c#color.MT_LISTHEADER_BG

/* *set colours */
if lower(is_windowstyle) = "error" then
	ll_usecolor = c#color.DarkRed
end if

st_title.backcolor = ll_usecolor
st_title.bordercolor = ll_usecolor
st_spacer.bordercolor = ll_usecolor
st_spacer.backcolor = ll_usecolor
r_styledborder.linecolor = ll_usecolor
st_title.backcolor = ll_usecolor

/* set size */
r_styledborder.width = ai_width
r_styledborder.height = ai_height
st_title.width = ai_width
p_close.x =  ai_width - (r_styledborder.linethickness + p_close.width)
p_refresh.x = ai_width - (r_styledborder.linethickness + p_close.width + p_refresh.width)


return c#return.Success
end function

public subroutine uf_redraw_off ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 

 Function  : uf_redraw_off

 Object     : 
  
 Event	 :  

 Scope     : Object

 ************************************************************************************

 Author    : Martin "Far" Israelsen
   
 Date       : 30/7-96

 Description : Enables nested redraw on/off commands, which otherwise is a problem
		in powerbuilder. This function turns redraw off

 Arguments : none

 Returns   : none

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/
ii_redraw++

this.Setredraw(false)


end subroutine

public subroutine uf_redraw_on ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 

 Function : uf_redraw_on
  
 Object     : 
  
 Event	 :  

 Scope     : Object

 ************************************************************************************

 Author    : Martin "Far" Israelsen
   
 Date       : 30/7-96

 Description : Enables nested redraw on/off commands, which otherwise is a problem
		in powerbuilder. This function turns redraw on

 Arguments : none

 Returns   : none

 Variables :  None

 Other : Will display an error messagebox if nested value is out-of-sync

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/


If ii_redraw > 0 Then 
   ii_redraw --
Else
	MessageBox("Warning", "redraw setting below zero")
End if

If ii_redraw = 0 Then
	this.Setredraw(true)
End if
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: mt_w_popupbox
	
	<OBJECT>
		Used to follow unique style of window that has different behaviour to standard windows
	</OBJECT>
   	<DESC>
			
	</DESC>
   	<USAGE>
		Currently the port validator and the sensitvity window inherit from this ancestor.  It is possible
		the error service within the MT framework could also use a variation of this.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date		Ref    		Author   		Comments
  	01/12/2011 	D-CALC		AGL027     		First Version - (forgot to add document function previously)
	04/08/2014 	CR3708		AGL027			F1 help application coverage - add menuname m_helpmain to properties
	04/11/2014	CR3708		CCY018			Set Border property is enabled, remove the menu m_helpmain.
********************************************************************/
end subroutine

on mt_w_popupbox.create
int iCurrent
call super::create
this.r_styledborder=create r_styledborder
this.p_close=create p_close
this.p_refresh=create p_refresh
this.st_title=create st_title
this.st_spacer=create st_spacer
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.r_styledborder
this.Control[iCurrent+2]=this.p_close
this.Control[iCurrent+3]=this.p_refresh
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.st_spacer
end on

on mt_w_popupbox.destroy
call super::destroy
destroy(this.r_styledborder)
destroy(this.p_close)
destroy(this.p_refresh)
destroy(this.st_title)
destroy(this.st_spacer)
end on

event resize;call super::resize;st_title.text = is_title
wf_initstyles(newwidth,newheight)
end event

event open;call super::open;this.toolbarvisible = false
/* as window is type popup, standard modification of shortcuts do nto work as changemenu
returns error code.  So property MenuName is used instead */

end event

type st_hidemenubar from mt_w_popup`st_hidemenubar within mt_w_popupbox
end type

type r_styledborder from rectangle within mt_w_popupbox
long linecolor = 22628899
integer linethickness = 4
long fillcolor = 32304364
integer width = 2729
integer height = 1040
end type

type p_close from picture within mt_w_popupbox
integer x = 2633
integer y = 4
integer width = 91
integer height = 80
string picturename = "Close!"
boolean focusrectangle = false
string powertiptext = "Close Popup"
end type

event clicked;parent.event ue_closeitem()
end event

type p_refresh from picture within mt_w_popupbox
integer x = 2537
integer y = 4
integer width = 96
integer height = 80
string picturename = "Update5!"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

event clicked;parent.event ue_refresh()
end event

type st_title from statictext within mt_w_popupbox
event ue_lbuttondown pbm_lbuttondown
integer x = 5
integer y = 12
integer width = 2533
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
alignment alignment = center!
boolean focusrectangle = false
end type

event ue_lbuttondown;Send(Handle(parent),274, 61458,0) 
POST(Handle(this),514, 0,0) 

end event

type st_spacer from statictext within mt_w_popupbox
event ue_lbuttondown pbm_lbuttondown
integer x = 5
integer y = 4
integer width = 2533
integer height = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
alignment alignment = center!
boolean focusrectangle = false
end type

event ue_lbuttondown;Send(Handle(parent),274, 61458,0) 
POST(Handle(this),514, 0,0) 

end event

