$PBExportHeader$w_cont_response.srw
$PBExportComments$This response window asks the user if a contact person belongs to a charterer or a broker.
forward
global type w_cont_response from w_sale_response
end type
type rb_charterer from uo_rb_base within w_cont_response
end type
type rb_broker from uo_rb_base within w_cont_response
end type
type cb_ok from uo_cb_base within w_cont_response
end type
type gb_1 from uo_gb_base within w_cont_response
end type
end forward

global type w_cont_response from w_sale_response
integer x = 923
integer y = 664
integer width = 869
integer height = 552
string title = "Contact Person is a ?"
boolean controlmenu = false
rb_charterer rb_charterer
rb_broker rb_broker
cb_ok cb_ok
gb_1 gb_1
end type
global w_cont_response w_cont_response

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_cont_response
	
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

on open;call w_sale_response::open;This.Move(929,665)
end on

on w_cont_response.create
int iCurrent
call super::create
this.rb_charterer=create rb_charterer
this.rb_broker=create rb_broker
this.cb_ok=create cb_ok
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_charterer
this.Control[iCurrent+2]=this.rb_broker
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.gb_1
end on

on w_cont_response.destroy
call super::destroy
destroy(this.rb_charterer)
destroy(this.rb_broker)
destroy(this.cb_ok)
destroy(this.gb_1)
end on

type st_hidemenubar from w_sale_response`st_hidemenubar within w_cont_response
end type

type rb_charterer from uo_rb_base within w_cont_response
integer x = 55
integer y = 112
integer width = 366
integer height = 64
integer textsize = -10
string text = "Charterer"
boolean checked = true
end type

type rb_broker from uo_rb_base within w_cont_response
integer x = 494
integer y = 112
integer width = 311
integer height = 64
integer textsize = -10
string text = "Broker"
end type

type cb_ok from uo_cb_base within w_cont_response
integer x = 274
integer y = 320
integer width = 293
integer height = 96
integer taborder = 20
string text = "OK"
boolean default = true
end type

on clicked;call uo_cb_base::clicked;String ls_c_or_b

IF rb_broker.checked = TRUE THEN
	ls_c_or_b = "B"
ELSE
	ls_c_or_b = "C"
END IF


CloseWithReturn(Parent,ls_c_or_b)

end on

type gb_1 from uo_gb_base within w_cont_response
integer x = 37
integer y = 48
integer width = 786
integer height = 176
integer taborder = 10
string text = ""
end type

