$PBExportHeader$w_bunker_value_by_date.srw
$PBExportComments$Shows report bunker consumption and stock for a given date
forward
global type w_bunker_value_by_date from window
end type
type cb_sharemember from commandbutton within w_bunker_value_by_date
end type
type rb_input from radiobutton within w_bunker_value_by_date
end type
type rb_sharemember from radiobutton within w_bunker_value_by_date
end type
type rb_result from radiobutton within w_bunker_value_by_date
end type
type cb_delete from commandbutton within w_bunker_value_by_date
end type
type cb_codatrans from commandbutton within w_bunker_value_by_date
end type
type cb_close from commandbutton within w_bunker_value_by_date
end type
type st_status from statictext within w_bunker_value_by_date
end type
type st_2 from statictext within w_bunker_value_by_date
end type
type st_1 from statictext within w_bunker_value_by_date
end type
type cb_saveas from commandbutton within w_bunker_value_by_date
end type
type hpb_1 from hprogressbar within w_bunker_value_by_date
end type
type dw_datetime from datawindow within w_bunker_value_by_date
end type
type cb_run from commandbutton within w_bunker_value_by_date
end type
type cb_print from commandbutton within w_bunker_value_by_date
end type
type gb_1 from groupbox within w_bunker_value_by_date
end type
type gb_2 from groupbox within w_bunker_value_by_date
end type
type dw_result from datawindow within w_bunker_value_by_date
end type
end forward

global type w_bunker_value_by_date from window
integer width = 4238
integer height = 2576
boolean titlebar = true
string title = "Bunker Consumption/Stock Given Date"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
cb_sharemember cb_sharemember
rb_input rb_input
rb_sharemember rb_sharemember
rb_result rb_result
cb_delete cb_delete
cb_codatrans cb_codatrans
cb_close cb_close
st_status st_status
st_2 st_2
st_1 st_1
cb_saveas cb_saveas
hpb_1 hpb_1
dw_datetime dw_datetime
cb_run cb_run
cb_print cb_print
gb_1 gb_1
gb_2 gb_2
dw_result dw_result
end type
global w_bunker_value_by_date w_bunker_value_by_date

type variables
n_bunker_value_by_date	inv_bunker
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29/08/14		CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_bunker_value_by_date.create
this.cb_sharemember=create cb_sharemember
this.rb_input=create rb_input
this.rb_sharemember=create rb_sharemember
this.rb_result=create rb_result
this.cb_delete=create cb_delete
this.cb_codatrans=create cb_codatrans
this.cb_close=create cb_close
this.st_status=create st_status
this.st_2=create st_2
this.st_1=create st_1
this.cb_saveas=create cb_saveas
this.hpb_1=create hpb_1
this.dw_datetime=create dw_datetime
this.cb_run=create cb_run
this.cb_print=create cb_print
this.gb_1=create gb_1
this.gb_2=create gb_2
this.dw_result=create dw_result
this.Control[]={this.cb_sharemember,&
this.rb_input,&
this.rb_sharemember,&
this.rb_result,&
this.cb_delete,&
this.cb_codatrans,&
this.cb_close,&
this.st_status,&
this.st_2,&
this.st_1,&
this.cb_saveas,&
this.hpb_1,&
this.dw_datetime,&
this.cb_run,&
this.cb_print,&
this.gb_1,&
this.gb_2,&
this.dw_result}
end on

on w_bunker_value_by_date.destroy
destroy(this.cb_sharemember)
destroy(this.rb_input)
destroy(this.rb_sharemember)
destroy(this.rb_result)
destroy(this.cb_delete)
destroy(this.cb_codatrans)
destroy(this.cb_close)
destroy(this.st_status)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_saveas)
destroy(this.hpb_1)
destroy(this.dw_datetime)
destroy(this.cb_run)
destroy(this.cb_print)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.dw_result)
end on

event open;inv_bunker = create n_bunker_value_by_date

dw_datetime.insertrow(0)

end event

event close;destroy inv_bunker
end event

type cb_sharemember from commandbutton within w_bunker_value_by_date
integer x = 937
integer y = 2332
integer width = 398
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Share&member"
end type

event clicked;st_status.text = "Generating sharemember report rows..."

inv_bunker.of_distributeSharemember(dw_datetime.getItemdatetime( 1, "datetime_value"), hpb_1 )

rb_sharemember.checked = true
rb_sharemember.post event clicked( ) 

st_status.text = "Sharemember finished..."
dw_result.post setfocus()

cb_codatrans.enabled = true
rb_sharemember.enabled = true

end event

type rb_input from radiobutton within w_bunker_value_by_date
integer x = 3598
integer y = 2368
integer width = 343
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
string text = "Input Data"
end type

event clicked;blob lbl_data
string ls_dataObject

inv_bunker.of_getInputData(lbl_data, ls_dataObject)

dw_result.dataObject = ls_dataObject
dw_result.setFullState(lbl_data)


end event

type rb_sharemember from radiobutton within w_bunker_value_by_date
integer x = 3598
integer y = 2232
integer width = 512
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
string text = "Sharemember Stock"
end type

event clicked;blob lbl_data
string ls_dataObject

inv_bunker.of_getsharemember(lbl_data, ls_dataObject)

dw_result.dataObject = ls_dataObject
dw_result.setFullState(lbl_data)


end event

type rb_result from radiobutton within w_bunker_value_by_date
integer x = 3598
integer y = 2096
integer width = 517
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
string text = "Consumption / Stock"
boolean checked = true
end type

event clicked;blob lbl_data
string ls_dataObject

inv_bunker.of_getresultdata(lbl_data, ls_dataObject)

dw_result.dataObject = ls_dataObject
dw_result.setFullState(lbl_data)


end event

type cb_delete from commandbutton within w_bunker_value_by_date
integer x = 2725
integer y = 2332
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&DeleteRow"
end type

event clicked;long	ll_row

if not rb_result.checked then 
	MessageBox("Information", "You can only delete rows from result data!")
	return
end if

ll_row = dw_result.getselectedrow( 0 )

if ll_row < 1 then return

if MessageBox("Confirmation", "Please confirm that this row shall not be uploaded to CODA", Question!, YesNo!,2) = 2 then return

dw_result.deleteRow(ll_row)

dw_result.selectrow( 0, false )
if ll_row > dw_result.rowCount() then
	dw_result.selectRow(dw_result.rowCount(), true)
else
	dw_result.selectRow(ll_row , true)
end if
end event

type cb_codatrans from commandbutton within w_bunker_value_by_date
integer x = 1367
integer y = 2332
integer width = 398
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Generate Trans."
end type

event clicked;st_status.text = "Generating CODA upload..."

inv_bunker.of_generatecodaupload(  hpb_1 )

st_status.text = "CODA upload finished..."
dw_result.post setfocus()


end event

type cb_close from commandbutton within w_bunker_value_by_date
integer x = 3095
integer y = 2332
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;close(parent)
end event

type st_status from statictext within w_bunker_value_by_date
integer x = 69
integer y = 2156
integer width = 3365
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please enter Calculation date..."
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_bunker_value_by_date
integer x = 64
integer y = 2280
integer width = 421
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Calculation date:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_bunker_value_by_date
integer x = 37
integer y = 24
integer width = 3749
integer height = 132
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "This function calculates the Bunker Consumption and Bunker Stock value per a given date and time.  Excluded from the calculation are following: 1) All in-active vessels 2) Vessels not having a voyage in given Year 3) Vessels on a TC-out contract the given date."
boolean focusrectangle = false
end type

type cb_saveas from commandbutton within w_bunker_value_by_date
integer x = 2359
integer y = 2332
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save As..."
end type

event clicked;dw_result.saveas( )

end event

type hpb_1 from hprogressbar within w_bunker_value_by_date
integer x = 69
integer y = 2076
integer width = 3365
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 10
end type

type dw_datetime from datawindow within w_bunker_value_by_date
integer x = 73
integer y = 2344
integer width = 393
integer height = 88
integer taborder = 10
string title = "none"
string dataobject = "d_datetime"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_run from commandbutton within w_bunker_value_by_date
integer x = 512
integer y = 2332
integer width = 398
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Create &Report"
boolean default = true
end type

event clicked;cb_sharemember.enabled = false
cb_codatrans.enabled = false
rb_result.enabled = false
rb_sharemember.enabled = false
rb_input.enabled = false

dw_datetime.accepttext()
hpb_1.position = 0
st_status.text = "Retrieving data and Calculating Stock..."
inv_bunker.of_calculate( dw_datetime.getItemdatetime( 1, "datetime_value"), hpb_1 )

rb_result.checked = true
rb_result.post event clicked( ) 

st_status.text = "Calculating Stock finished..."
dw_result.post setfocus()

cb_sharemember.enabled = true
rb_result.enabled = true
rb_input.enabled = true
end event

type cb_print from commandbutton within w_bunker_value_by_date
integer x = 1984
integer y = 2332
integer width = 343
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;dw_result.print()

end event

type gb_1 from groupbox within w_bunker_value_by_date
integer x = 9
integer y = 2000
integer width = 3479
integer height = 476
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_bunker_value_by_date
integer x = 3525
integer y = 2000
integer width = 677
integer height = 476
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report"
end type

type dw_result from datawindow within w_bunker_value_by_date
integer x = 9
integer y = 164
integer width = 4187
integer height = 1836
integer taborder = 80
string title = "none"
string dataobject = "d_ex_tb_bunker_value_by_date_result"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if currentrow > 0 then
	this.selectRow(0, false)
	this.selectRow(currentrow, true)
end if
end event

