$PBExportHeader$w_f_tc_calculation_add.srw
forward
global type w_f_tc_calculation_add from mt_w_response
end type
type st_year from statictext within w_f_tc_calculation_add
end type
type st_trade from statictext within w_f_tc_calculation_add
end type
type cb_cancel from commandbutton within w_f_tc_calculation_add
end type
type cb_save from commandbutton within w_f_tc_calculation_add
end type
type sle_new from singlelineedit within w_f_tc_calculation_add
end type
type rb_add from radiobutton within w_f_tc_calculation_add
end type
type rb_2 from radiobutton within w_f_tc_calculation_add
end type
type rb_1 from radiobutton within w_f_tc_calculation_add
end type
type st_1 from statictext within w_f_tc_calculation_add
end type
end forward

global type w_f_tc_calculation_add from mt_w_response
integer width = 1637
integer height = 724
string title = "Add Flat Rate"
st_year st_year
st_trade st_trade
cb_cancel cb_cancel
cb_save cb_save
sle_new sle_new
rb_add rb_add
rb_2 rb_2
rb_1 rb_1
st_1 st_1
end type
global w_f_tc_calculation_add w_f_tc_calculation_add

type variables
Decimal 	id_rb1, id_rb2
s_param_flatrate	lstr_param
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_f_tc_calculation_add
	
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
	</HISTORY>
********************************************************************/
end subroutine

event open;


lstr_param= message.powerObjectParm

st_year.text = "(" + string(lstr_param.ll_year) + ")"
st_trade.text = lstr_param.ls_fixture_trade


if lstr_param.ld_flatrateports <> 0 and lstr_param.ld_flatrate_defaultports<>0 then
	rb_1.visible=true
	rb_2.visible=true
	id_rb1 = lstr_param.ld_flatrateports
	rb_1.text = "= " + string(id_rb1)  +  " - " + lstr_param.ls_msg_ports
	id_rb2 = lstr_param.ld_flatrate_defaultports
	rb_2.text = "= " + string(id_rb2) + " - "  +lstr_param.ls_msg_defaultports
	
else
	if lstr_param.ld_flatrateports <> 0 then
		rb_2.visible=true
		id_rb2 = lstr_param.ld_flatrateports
 		rb_2.text = "= " + string(id_rb2)  +  " - " + lstr_param.ls_msg_ports
			 
	elseif  lstr_param.ld_flatrate_defaultports<>0 then
		rb_2.visible=true
		id_rb2 = lstr_param.ld_flatrate_defaultports
 		rb_2.text = "= " + string(id_rb2)  +  " - " + lstr_param.ls_msg_defaultports 
	end if
	
	sle_new.text = "0"

end if

end event

on w_f_tc_calculation_add.create
int iCurrent
call super::create
this.st_year=create st_year
this.st_trade=create st_trade
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.sle_new=create sle_new
this.rb_add=create rb_add
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_year
this.Control[iCurrent+2]=this.st_trade
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_save
this.Control[iCurrent+5]=this.sle_new
this.Control[iCurrent+6]=this.rb_add
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.st_1
end on

on w_f_tc_calculation_add.destroy
call super::destroy
destroy(this.st_year)
destroy(this.st_trade)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.sle_new)
destroy(this.rb_add)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_1)
end on

type st_year from statictext within w_f_tc_calculation_add
integer x = 1033
integer y = 20
integer width = 229
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "2009"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_trade from statictext within w_f_tc_calculation_add
integer x = 649
integer y = 20
integer width = 370
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "xx"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_f_tc_calculation_add
integer x = 1326
integer y = 516
integer width = 274
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;
lstr_param.ld_flatrateports = 0

closewithreturn(parent,lstr_param)
end event

type cb_save from commandbutton within w_f_tc_calculation_add
integer x = 997
integer y = 516
integer width = 274
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save"
end type

event clicked;decimal	ld_flatrate

if rb_1.visible and rb_1.checked then
	ld_flatrate=id_rb1
	
elseif rb_2.visible and rb_2.checked then
	ld_flatrate=id_rb2
	
elseif  rb_add.checked then
	if sle_new.text ="" then
		MessageBox("Warning", "Please add a new flat rate")
		return 0
	end if
	if  isnumber(sle_new.text )=false then
		MessageBox("Warning", "Please add a numeric flat rate value")
		return 0
	end if
	ld_flatrate = Dec(sle_new.text)
end if


lstr_param.ld_flatrateports = ld_flatrate

closewithreturn(parent,lstr_param)
end event

type sle_new from singlelineedit within w_f_tc_calculation_add
integer x = 389
integer y = 404
integer width = 402
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type rb_add from radiobutton within w_f_tc_calculation_add
integer x = 110
integer y = 400
integer width = 297
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "New"
boolean checked = true
end type

type rb_2 from radiobutton within w_f_tc_calculation_add
boolean visible = false
integer x = 110
integer y = 268
integer width = 1495
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
end type

type rb_1 from radiobutton within w_f_tc_calculation_add
boolean visible = false
integer x = 110
integer y = 136
integer width = 1481
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
end type

type st_1 from statictext within w_f_tc_calculation_add
integer x = 14
integer y = 20
integer width = 617
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Add Flat Rate for trade"
boolean focusrectangle = false
end type

