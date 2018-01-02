$PBExportHeader$w_vessel_selection.srw
forward
global type w_vessel_selection from mt_w_response
end type
type dw_vessel_selection from datawindow within w_vessel_selection
end type
type cb_2 from commandbutton within w_vessel_selection
end type
type cb_1 from commandbutton within w_vessel_selection
end type
type st_1 from statictext within w_vessel_selection
end type
end forward

global type w_vessel_selection from mt_w_response
integer width = 2057
integer height = 1512
dw_vessel_selection dw_vessel_selection
cb_2 cb_2
cb_1 cb_1
st_1 st_1
end type
global w_vessel_selection w_vessel_selection

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_vessel_selection
	
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
	</HISTORY>
********************************************************************/
end subroutine

on w_vessel_selection.create
int iCurrent
call super::create
this.dw_vessel_selection=create dw_vessel_selection
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_vessel_selection
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_1
end on

on w_vessel_selection.destroy
call super::destroy
destroy(this.dw_vessel_selection)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_1)
end on

event open;dw_vessel_selection.settransobject(SQLCA)
dw_vessel_selection.retrieve(uo_global.is_userid )
end event

type dw_vessel_selection from datawindow within w_vessel_selection
integer x = 37
integer y = 124
integer width = 1947
integer height = 1124
integer taborder = 20
string title = "none"
string dataobject = "dw_vessel_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if (row >0) then
	this.selectrow(0,false)
	this.selectrow(row, true)
end if
end event

event doubleclicked;cb_2.TriggerEvent(Clicked!)
end event

type cb_2 from commandbutton within w_vessel_selection
integer x = 1271
integer y = 1280
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

event clicked;long ll_row
string ls_vessel_ref

ll_row = dw_vessel_selection.getselectedrow(0)

if (ll_row = 0) then
	Messagebox("Select", "Please select a Vessel or Cancel")
else
	ls_vessel_ref = dw_vessel_selection.getitemString(ll_row, "vessel_ref_nr")
	closewithreturn(parent,ls_vessel_ref)
end if

end event

type cb_1 from commandbutton within w_vessel_selection
integer x = 1637
integer y = 1280
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;closewithreturn(parent,"")

end event

type st_1 from statictext within w_vessel_selection
integer x = 37
integer y = 32
integer width = 882
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Vessel:"
boolean focusrectangle = false
end type

