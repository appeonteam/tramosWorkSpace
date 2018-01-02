$PBExportHeader$w_crosstab_portcalls.srw
$PBExportComments$This window shows portcalls since 2003 per year per purpose
forward
global type w_crosstab_portcalls from mt_w_main
end type
type cb_saveas from commandbutton within w_crosstab_portcalls
end type
type cb_2 from commandbutton within w_crosstab_portcalls
end type
type cb_close from commandbutton within w_crosstab_portcalls
end type
type dw_crosstab from datawindow within w_crosstab_portcalls
end type
end forward

global type w_crosstab_portcalls from mt_w_main
integer width = 3808
integer height = 2260
string title = "Port Calls Purpose/Year"
boolean maxbox = false
boolean resizable = false
cb_saveas cb_saveas
cb_2 cb_2
cb_close cb_close
dw_crosstab dw_crosstab
end type
global w_crosstab_portcalls w_crosstab_portcalls

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_crosstab_portcalls
	
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
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		 28/08/14	CR3781		CCY018		The window title match with the text of a menu item
	</HISTORY>
********************************************************************/
end subroutine

event open;call super::open;dw_crosstab.settransobject(SQLCA)
dw_crosstab.post retrieve()

end event

on w_crosstab_portcalls.create
int iCurrent
call super::create
this.cb_saveas=create cb_saveas
this.cb_2=create cb_2
this.cb_close=create cb_close
this.dw_crosstab=create dw_crosstab
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_saveas
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.dw_crosstab
end on

on w_crosstab_portcalls.destroy
call super::destroy
destroy(this.cb_saveas)
destroy(this.cb_2)
destroy(this.cb_close)
destroy(this.dw_crosstab)
end on

type st_hidemenubar from mt_w_main`st_hidemenubar within w_crosstab_portcalls
end type

type cb_saveas from commandbutton within w_crosstab_portcalls
integer x = 2853
integer y = 2040
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&SaveAs..."
end type

event clicked;dw_crosstab.saveas()
end event

type cb_2 from commandbutton within w_crosstab_portcalls
integer x = 2446
integer y = 2040
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_crosstab.print()
end event

type cb_close from commandbutton within w_crosstab_portcalls
integer x = 3360
integer y = 2040
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type dw_crosstab from datawindow within w_crosstab_portcalls
integer x = 96
integer y = 48
integer width = 3611
integer height = 1900
integer taborder = 10
string title = "none"
string dataobject = "d_crosstab_portcalls"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_sort
if dwo.type = "text" then
	ls_sort = dwo.Tag
	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort

end if
end event

