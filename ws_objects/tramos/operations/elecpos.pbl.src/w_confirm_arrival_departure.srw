$PBExportHeader$w_confirm_arrival_departure.srw
$PBExportComments$Used to confirm Arrival/Departure data agains TC Contract when delivery/Redelivery
forward
global type w_confirm_arrival_departure from mt_w_response
end type
type cb_continue from mt_u_commandbutton within w_confirm_arrival_departure
end type
type em_time_difference from editmask within w_confirm_arrival_departure
end type
type st_3 from statictext within w_confirm_arrival_departure
end type
type st_2 from statictext within w_confirm_arrival_departure
end type
type st_departure from statictext within w_confirm_arrival_departure
end type
type st_arrival from statictext within w_confirm_arrival_departure
end type
type dw_datetime from datawindow within w_confirm_arrival_departure
end type
end forward

global type w_confirm_arrival_departure from mt_w_response
integer width = 1189
integer height = 920
string title = "Date Confirmation"
long backcolor = 32304364
cb_continue cb_continue
em_time_difference em_time_difference
st_3 st_3
st_2 st_2
st_departure st_departure
st_arrival st_arrival
dw_datetime dw_datetime
end type
global w_confirm_arrival_departure w_confirm_arrival_departure

type variables
s_select_tc_contract	istr_parm
end variables

on w_confirm_arrival_departure.create
int iCurrent
call super::create
this.cb_continue=create cb_continue
this.em_time_difference=create em_time_difference
this.st_3=create st_3
this.st_2=create st_2
this.st_departure=create st_departure
this.st_arrival=create st_arrival
this.dw_datetime=create dw_datetime
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_continue
this.Control[iCurrent+2]=this.em_time_difference
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_departure
this.Control[iCurrent+6]=this.st_arrival
this.Control[iCurrent+7]=this.dw_datetime
end on

on w_confirm_arrival_departure.destroy
call super::destroy
destroy(this.cb_continue)
destroy(this.em_time_difference)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_departure)
destroy(this.st_arrival)
destroy(this.dw_datetime)
end on

event open;istr_parm = message.powerobjectparm
if istr_parm.arrival then
	st_arrival.visible = true
	st_departure.visible = false
else
	st_arrival.visible = false
	st_departure.visible = true
end if

setNull(istr_parm.lt_to_utc_difference)

dw_datetime.insertRow(0)
end event

event close;closeWithReturn(this, istr_parm)
end event

type cb_continue from mt_u_commandbutton within w_confirm_arrival_departure
integer x = 411
integer y = 712
integer taborder = 40
string text = "&Continue"
boolean default = true
end type

event clicked;call super::clicked;dw_datetime.accepttext( )
istr_parm.arrival_departure = dw_datetime.getItemDatetime(1, "datetime_value")
if len(em_time_difference.text) = 0 then
	setNull(istr_parm.lt_to_utc_difference)
else
	istr_parm.lt_to_utc_difference = dec(em_time_difference.text)
end if

closeWithReturn(parent, istr_parm)
end event

type em_time_difference from editmask within w_confirm_arrival_departure
integer x = 503
integer y = 592
integer width = 169
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 31775128
string text = "0.0"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#0.0"
end type

type st_3 from statictext within w_confirm_arrival_departure
integer x = 69
integer y = 440
integer width = 1033
integer height = 140
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "( If TC Contract is in LT, difference will not be used, and you can just enter 0)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_confirm_arrival_departure
integer x = 64
integer y = 368
integer width = 1047
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Enter difference from LT to UTC in hours:"
boolean focusrectangle = false
end type

type st_departure from statictext within w_confirm_arrival_departure
integer x = 27
integer y = 20
integer width = 1120
integer height = 140
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Please enter Port Departure date and time (remember to enter Local Time):"
boolean focusrectangle = false
end type

type st_arrival from statictext within w_confirm_arrival_departure
integer x = 27
integer y = 20
integer width = 1120
integer height = 140
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Please enter Port Arrival date and time (remember to enter Local Time):"
boolean focusrectangle = false
end type

type dw_datetime from datawindow within w_confirm_arrival_departure
integer x = 389
integer y = 232
integer width = 398
integer height = 80
integer taborder = 10
string title = "none"
string dataobject = "d_datetime"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

