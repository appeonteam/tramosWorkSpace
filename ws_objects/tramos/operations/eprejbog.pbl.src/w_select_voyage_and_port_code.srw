$PBExportHeader$w_select_voyage_and_port_code.srw
$PBExportComments$Window for selecting voyage and port code
forward
global type w_select_voyage_and_port_code from mt_w_response
end type
type rb_2 from radiobutton within w_select_voyage_and_port_code
end type
type rb_at_sea from radiobutton within w_select_voyage_and_port_code
end type
type cb_2 from commandbutton within w_select_voyage_and_port_code
end type
type cb_ok from commandbutton within w_select_voyage_and_port_code
end type
type dw_1 from uo_datawindow within w_select_voyage_and_port_code
end type
type gb_1 from groupbox within w_select_voyage_and_port_code
end type
type dw_2 from uo_datawindow within w_select_voyage_and_port_code
end type
end forward

global type w_select_voyage_and_port_code from mt_w_response
integer x = 672
integer y = 264
integer width = 1321
integer height = 996
string title = "Select Voyage and Port"
boolean controlmenu = false
long backcolor = 80269524
rb_2 rb_2
rb_at_sea rb_at_sea
cb_2 cb_2
cb_ok cb_ok
dw_1 dw_1
gb_1 gb_1
dw_2 dw_2
end type
global w_select_voyage_and_port_code w_select_voyage_and_port_code

type variables
s_off_service istr_data
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_select_voyage_and_port_code
	
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

event open;istr_data = Message.PowerObjectParm
Long ll_rows

this.Move ( 200 , 100 )
dw_1.SetTransObject( SQLCA )
dw_1.Retrieve( istr_data.vessel_nr )
dw_2.SetTransObject( SQLCA )
dw_2.Retrieve( istr_data.vessel_nr )
ll_rows = dw_2.RowCount()
IF ll_rows  > 0 THEN
	dw_2.ScrollToRow( ll_rows )
	dw_2.SelectRow(ll_rows , TRUE )
	rb_at_sea.TriggerEvent(Clicked!)
Else
	cb_ok.Enabled = False
END IF
end event

on w_select_voyage_and_port_code.create
int iCurrent
call super::create
this.rb_2=create rb_2
this.rb_at_sea=create rb_at_sea
this.cb_2=create cb_2
this.cb_ok=create cb_ok
this.dw_1=create dw_1
this.gb_1=create gb_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_at_sea
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.dw_2
end on

on w_select_voyage_and_port_code.destroy
call super::destroy
destroy(this.rb_2)
destroy(this.rb_at_sea)
destroy(this.cb_2)
destroy(this.cb_ok)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.dw_2)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_select_voyage_and_port_code
end type

type rb_2 from radiobutton within w_select_voyage_and_port_code
integer x = 914
integer y = 352
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 80269524
string text = "&Port"
end type

on clicked;dw_2.Visible = FALSE
dw_1.Visible = TRUE
dw_1.SelectRow( 0 , FALSE )
dw_1.ScrollToRow(dw_1.RowCount())
dw_1.SelectRow( dw_1.RowCount() , TRUE )
end on

type rb_at_sea from radiobutton within w_select_voyage_and_port_code
integer x = 914
integer y = 224
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 80269524
string text = "&At Sea"
boolean checked = true
end type

on clicked;dw_1.Visible = FALSE
dw_2.Visible = TRUE
dw_2.SelectRow( 0 , FALSE )
dw_2.ScrollToRow(dw_2.RowCount())
dw_2.SelectRow( dw_2.RowCount() , TRUE )
end on

type cb_2 from commandbutton within w_select_voyage_and_port_code
integer x = 869
integer y = 760
integer width = 389
integer height = 104
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;SetNull(istr_data.voyage_nr)
SetNull(istr_data.port_code)
CloseWithReturn(Parent, istr_data)
end event

type cb_ok from commandbutton within w_select_voyage_and_port_code
integer x = 869
integer y = 620
integer width = 389
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

event clicked;Long ll_row

IF dw_1.Visible = TRUE THEN
	ll_row = dw_1.GetRow()
	istr_data.port_code = dw_1.GetItemString( ll_row , "port_code" )
	istr_data.voyage_nr = dw_1.GetItemString( ll_row , "voyage_nr" )
ELSE
	istr_data.port_code = "ATS"
	ll_row = dw_2.GetRow()
	istr_data.voyage_nr = dw_2.GetItemString( ll_row , "voyage_nr" )
END IF
CloseWithReturn( Parent , istr_data )
end event

type dw_1 from uo_datawindow within w_select_voyage_and_port_code
integer x = 18
integer y = 16
integer width = 823
integer height = 848
integer taborder = 10
string dataobject = "dw_idle_days_select_voyage_and_port"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;IF row > 0 THEN
	this.SelectRow( 0 , FALSE )
	this.SelectRow(row , TRUE )
	this.SetRow( row )
END IF
end event

type gb_1 from groupbox within w_select_voyage_and_port_code
integer x = 859
integer y = 128
integer width = 384
integer height = 352
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 80269524
string text = "Port ?"
end type

type dw_2 from uo_datawindow within w_select_voyage_and_port_code
integer x = 18
integer y = 16
integer width = 823
integer height = 848
integer taborder = 20
string dataobject = "dw_idle_days_select_voyage"
boolean vscrollbar = true
end type

event clicked;call super::clicked;IF row > 0 THEN
	this.SelectRow( 0 , FALSE )
	this.SelectRow(row , TRUE )
	this.SetRow(row)
END IF
end event

