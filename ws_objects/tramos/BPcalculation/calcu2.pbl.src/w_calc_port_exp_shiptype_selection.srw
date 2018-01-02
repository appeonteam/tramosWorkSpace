$PBExportHeader$w_calc_port_exp_shiptype_selection.srw
$PBExportComments$This window is used together with window w_calc_port_expenses for selecting Shiptype
forward
global type w_calc_port_exp_shiptype_selection from mt_w_response_calc
end type
type cb_2 from commandbutton within w_calc_port_exp_shiptype_selection
end type
type cb_1 from commandbutton within w_calc_port_exp_shiptype_selection
end type
type st_1 from statictext within w_calc_port_exp_shiptype_selection
end type
type dw_shiptype from datawindow within w_calc_port_exp_shiptype_selection
end type
end forward

global type w_calc_port_exp_shiptype_selection from mt_w_response_calc
integer width = 1778
integer height = 2012
string title = "Select Vessel Type..."
boolean controlmenu = false
event ue_retrieve pbm_custom01
cb_2 cb_2
cb_1 cb_1
st_1 st_1
dw_shiptype dw_shiptype
end type
global w_calc_port_exp_shiptype_selection w_calc_port_exp_shiptype_selection

type variables
s_calc_port_expenses istr_parm
end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_retrieve;integer li_upper, li_x, li_row
string ls_search

dw_shiptype.retrieve( )
dw_shiptype.SetRowFocusIndicator(FocusRect!)

li_upper = UpperBound(istr_parm.shiptype)
for li_x = 1 to li_upper
	ls_search = "cal_vest_type_id="+string(istr_parm.shiptype[li_x])
	li_row = dw_shiptype.find(ls_search, 1, 999)
	if li_row > 0 then dw_shiptype.selectrow(li_row,True)
next 
end event

public subroutine documentation ();/********************************************************************
   w_calc_port_exp_shiptype_selection
	
	<OBJECT>

	</OBJECT>
	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	07/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
*****************************************************************/
end subroutine

on w_calc_port_exp_shiptype_selection.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_1=create st_1
this.dw_shiptype=create dw_shiptype
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_shiptype
end on

on w_calc_port_exp_shiptype_selection.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.dw_shiptype)
end on

event open;istr_parm = message.PowerObjectParm
dw_shiptype.settransobject(SQLCA)

this.PostEvent("ue_retrieve")
end event

event close;closewithreturn(this,istr_parm)
end event

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_port_exp_shiptype_selection
end type

type cb_2 from commandbutton within w_calc_port_exp_shiptype_selection
integer x = 1010
integer y = 1804
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

event clicked;integer li_clean_array[]
long ll_row, ll_rows

ll_row = dw_shiptype.getselectedrow(0)

if (ll_row = 0) then
	Messagebox("Select", "Please select a Vessel Type or Cancel")
	Return
end if

/* Fill array with new type ID's */
istr_parm.shiptype = li_clean_array
ll_rows = dw_shiptype.rowcount()

if (ll_rows = 0) then return

FOR ll_row=0 TO ll_rows
	if (dw_shiptype.isselected(ll_row)) then
		istr_parm.shiptype[UpperBound(istr_parm.shiptype)+1] = &
											dw_shiptype.getitemnumber(ll_row, "cal_vest_type_id")
	end if
NEXT

closewithreturn(parent,istr_parm)


end event

type cb_1 from commandbutton within w_calc_port_exp_shiptype_selection
integer x = 1376
integer y = 1804
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

event clicked;close(parent)

end event

type st_1 from statictext within w_calc_port_exp_shiptype_selection
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
string text = "Select Shiptype:"
boolean focusrectangle = false
end type

type dw_shiptype from datawindow within w_calc_port_exp_shiptype_selection
integer x = 37
integer y = 128
integer width = 1687
integer height = 1628
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_shiptype_pr_userid"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if (row >0) then
	this.selectrow(row,not this.isselected(row))
end if

end event

