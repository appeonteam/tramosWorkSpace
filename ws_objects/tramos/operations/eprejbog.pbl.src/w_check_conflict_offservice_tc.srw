$PBExportHeader$w_check_conflict_offservice_tc.srw
forward
global type w_check_conflict_offservice_tc from mt_w_response
end type
type st_4 from statictext within w_check_conflict_offservice_tc
end type
type st_3 from statictext within w_check_conflict_offservice_tc
end type
type st_2 from statictext within w_check_conflict_offservice_tc
end type
type st_1 from statictext within w_check_conflict_offservice_tc
end type
type cb_ok from commandbutton within w_check_conflict_offservice_tc
end type
type dw_spy from datawindow within w_check_conflict_offservice_tc
end type
end forward

global type w_check_conflict_offservice_tc from mt_w_response
integer width = 1623
integer height = 1604
string title = "Validation Error"
boolean controlmenu = false
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
cb_ok cb_ok
dw_spy dw_spy
end type
global w_check_conflict_offservice_tc w_check_conflict_offservice_tc

type variables
datastore	ids_data
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_check_conflict_offservice_tc
	
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

event open;ids_data = CREATE datastore
ids_data = message.PowerObjectParm

dw_spy.dataObject = ids_data.dataObject
ids_data.shareData(dw_spy)


end event

on w_check_conflict_offservice_tc.create
int iCurrent
call super::create
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_ok=create cb_ok
this.dw_spy=create dw_spy
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.dw_spy
end on

on w_check_conflict_offservice_tc.destroy
call super::destroy
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.dw_spy)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_check_conflict_offservice_tc
end type

type st_4 from statictext within w_check_conflict_offservice_tc
integer x = 46
integer y = 400
integer width = 1499
integer height = 180
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "If the Off-service is covering several TC Contract periods, you have to split the Off-service into several Off-services that matches the TC Contract periods."
boolean focusrectangle = false
end type

type st_3 from statictext within w_check_conflict_offservice_tc
integer x = 46
integer y = 260
integer width = 1499
integer height = 124
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please correct the Off-service, so that it matches the TC Contract periods. "
boolean focusrectangle = false
end type

type st_2 from statictext within w_check_conflict_offservice_tc
integer x = 46
integer y = 168
integer width = 1499
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "This Off-service conflicts with the below shown periods."
boolean focusrectangle = false
end type

type st_1 from statictext within w_check_conflict_offservice_tc
integer x = 46
integer y = 40
integer width = 1518
integer height = 144
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "An Off-service period may not conflict with the TC Contract periods.  "
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_check_conflict_offservice_tc
integer x = 635
integer y = 1376
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

event clicked;dw_spy.shareDataOff()
closewithreturn ( parent, 0 )
end event

type dw_spy from datawindow within w_check_conflict_offservice_tc
integer x = 37
integer y = 644
integer width = 1536
integer height = 696
integer taborder = 10
string dataobject = "d_check_conflict_offservice_tc"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

