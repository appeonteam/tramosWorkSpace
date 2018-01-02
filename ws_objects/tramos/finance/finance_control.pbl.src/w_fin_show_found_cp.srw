$PBExportHeader$w_fin_show_found_cp.srw
forward
global type w_fin_show_found_cp from mt_w_response
end type
type cb_cancel from commandbutton within w_fin_show_found_cp
end type
type cb_ok from commandbutton within w_fin_show_found_cp
end type
type st_1 from statictext within w_fin_show_found_cp
end type
type dw_voyagelist from datawindow within w_fin_show_found_cp
end type
end forward

global type w_fin_show_found_cp from mt_w_response
integer width = 1550
integer height = 1228
string title = "Select voyage..."
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
dw_voyagelist dw_voyagelist
end type
global w_fin_show_found_cp w_fin_show_found_cp

type variables
datastore	ids_data
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_fin_show_found_cp
	
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

on w_fin_show_found_cp.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_1=create st_1
this.dw_voyagelist=create dw_voyagelist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_voyagelist
end on

on w_fin_show_found_cp.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.dw_voyagelist)
end on

event open;ids_data = create datastore

ids_data = message.powerobjectparm

ids_data.sharedata (dw_voyagelist)
end event

type cb_cancel from commandbutton within w_fin_show_found_cp
integer x = 841
integer y = 996
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;closewithreturn (parent, -1)
end event

type cb_ok from commandbutton within w_fin_show_found_cp
integer x = 242
integer y = 1000
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;long ll_row 

ll_row = dw_voyagelist.getSelectedRow(0)

if ll_row < 1 then
	closewithreturn(parent, -1)
else
	closewithreturn(parent, ll_row)
end if
end event

type st_1 from statictext within w_fin_show_found_cp
integer x = 91
integer y = 40
integer width = 1385
integer height = 124
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Following voyages match the entered C/P date. Please  select one."
boolean focusrectangle = false
end type

type dw_voyagelist from datawindow within w_fin_show_found_cp
integer x = 27
integer y = 260
integer width = 1458
integer height = 680
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_fin_find_cp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.selectrow(0, false)
this.selectrow(currentrow, true)
end event

