$PBExportHeader$w_update_proceed.srw
$PBExportComments$NOT IN USE - Window that lists ports in proceeding, where voyage is allocated a calcule, but where ports are not in calcule.
forward
global type w_update_proceed from mt_w_main
end type
type dw_1 from uo_datawindow within w_update_proceed
end type
type st_2 from statictext within w_update_proceed
end type
type cb_4 from commandbutton within w_update_proceed
end type
type cb_3 from commandbutton within w_update_proceed
end type
type st_1 from statictext within w_update_proceed
end type
type cb_1 from commandbutton within w_update_proceed
end type
end forward

global type w_update_proceed from mt_w_main
integer x = 110
integer y = 140
integer width = 2464
integer height = 1344
string title = "Change Non-Cargo Proceeding to Real Proceedings"
boolean maxbox = false
boolean resizable = false
dw_1 dw_1
st_2 st_2
cb_4 cb_4
cb_3 cb_3
st_1 st_1
cb_1 cb_1
end type
global w_update_proceed w_update_proceed

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
   	Date       CR-Ref		Author			Comments
   	21/08/14 CR3708		CCY018		F1 help application coverage - modified ancestor.
   </HISTORY>
********************************************************************/
end subroutine

on w_update_proceed.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_2=create st_2
this.cb_4=create cb_4
this.cb_3=create cb_3
this.st_1=create st_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_4
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_1
end on

on w_update_proceed.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.cb_1)
end on

type dw_1 from uo_datawindow within w_update_proceed
integer x = 37
integer y = 36
integer width = 2391
integer height = 984
integer taborder = 40
string dataobject = "dw_1"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_update_proceed
integer x = 599
integer y = 1040
integer width = 1833
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "All viap./canals must have a portcode before list of ports missing in calc. is correct."
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_4 from commandbutton within w_update_proceed
integer x = 585
integer y = 1136
integer width = 571
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Viap. with no portcode"
end type

on clicked;dw_1.DataObject = "d_ports"
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()

dw_1.SetFilter("(VIA_POINT = 1 OR VIA_POINT = 2)")
dw_1.Filter()

st_1.text = string(dw_1.Rowcount()) + " Rows"
end on

type cb_3 from commandbutton within w_update_proceed
integer x = 1842
integer y = 1136
integer width = 283
integer height = 108
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

on clicked;dw_1.Print(FALSE)
end on

type st_1 from statictext within w_update_proceed
integer x = 37
integer y = 1028
integer width = 283
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "?? Rows"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_update_proceed
integer x = 2144
integer y = 1136
integer width = 283
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

on clicked;Close(parent)
end on

