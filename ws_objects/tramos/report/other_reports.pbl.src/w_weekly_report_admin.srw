$PBExportHeader$w_weekly_report_admin.srw
forward
global type w_weekly_report_admin from mt_w_main
end type
type rb_vessel from radiobutton within w_weekly_report_admin
end type
type rb_date from radiobutton within w_weekly_report_admin
end type
type rb_id from radiobutton within w_weekly_report_admin
end type
type st_1 from statictext within w_weekly_report_admin
end type
type cb_4 from commandbutton within w_weekly_report_admin
end type
type sle_1 from singlelineedit within w_weekly_report_admin
end type
type cb_3 from commandbutton within w_weekly_report_admin
end type
type cb_2 from commandbutton within w_weekly_report_admin
end type
type cb_1 from commandbutton within w_weekly_report_admin
end type
type dw_1 from datawindow within w_weekly_report_admin
end type
type gb_1 from groupbox within w_weekly_report_admin
end type
end forward

global type w_weekly_report_admin from mt_w_main
integer width = 4567
integer height = 2116
string title = "Weekly Report Administration"
boolean maxbox = false
boolean resizable = false
boolean center = false
rb_vessel rb_vessel
rb_date rb_date
rb_id rb_id
st_1 st_1
cb_4 cb_4
sle_1 sle_1
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
gb_1 gb_1
end type
global w_weekly_report_admin w_weekly_report_admin

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

on w_weekly_report_admin.create
int iCurrent
call super::create
this.rb_vessel=create rb_vessel
this.rb_date=create rb_date
this.rb_id=create rb_id
this.st_1=create st_1
this.cb_4=create cb_4
this.sle_1=create sle_1
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_vessel
this.Control[iCurrent+2]=this.rb_date
this.Control[iCurrent+3]=this.rb_id
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_4
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.dw_1
this.Control[iCurrent+11]=this.gb_1
end on

on w_weekly_report_admin.destroy
call super::destroy
destroy(this.rb_vessel)
destroy(this.rb_date)
destroy(this.rb_id)
destroy(this.st_1)
destroy(this.cb_4)
destroy(this.sle_1)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

/* External APM read only */
if uo_global.ii_access_level = -1 then dw_1.object.datawindow.readonly='Yes'
end event

type rb_vessel from radiobutton within w_weekly_report_admin
integer x = 2181
integer y = 1928
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel No"
end type

event clicked;dw_1.SetSort("vessel_nr a, item_id a")
dw_1.Sort()
end event

type rb_date from radiobutton within w_weekly_report_admin
integer x = 1787
integer y = 1928
integer width = 357
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Date"
end type

event clicked;dw_1.SetSort("reported_date a, item_id a")
dw_1.Sort()
end event

type rb_id from radiobutton within w_weekly_report_admin
integer x = 1527
integer y = 1928
integer width = 261
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Id.No"
boolean checked = true
end type

event clicked;dw_1.SetSort("pool_weekly_fixture_identity_nr_1 a, item_id a ")
dw_1.Sort()
end event

type st_1 from statictext within w_weekly_report_admin
integer x = 23
integer y = 1912
integer width = 553
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enter Year (YYYY) :"
boolean focusrectangle = false
end type

type cb_4 from commandbutton within w_weekly_report_admin
integer x = 809
integer y = 1908
integer width = 302
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Get Data"
end type

event clicked;IF NOT(Integer(sle_1.text) > 2000 AND Integer(sle_1.text) < 2099) THEN 
	MessageBox("Error","Please enter a valid year between 2000-2099.")
	Return
END IF

dw_1.Retrieve(Integer(sle_1.text), uo_global.is_userid )

rb_id.checked = TRUE
rb_date.checked = FALSE
rb_vessel.checked = FALSE
end event

type sle_1 from singlelineedit within w_weekly_report_admin
integer x = 576
integer y = 1904
integer width = 192
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_weekly_report_admin
integer x = 4165
integer y = 1892
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clo&se"
end type

event clicked;close(parent)
end event

type cb_2 from commandbutton within w_weekly_report_admin
integer x = 3593
integer y = 1892
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;dw_1.Reset()
end event

type cb_1 from commandbutton within w_weekly_report_admin
integer x = 2990
integer y = 1896
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Update"
end type

event clicked;// If this is a calcule then check that commodity is filled out
IF dw_1.GetItemNumber(1,"commoditytestsum") > 0 THEN
	MessageBox("Warning","You must input a commodity for all rows !")
	Return
END IF
// Check that comment are filled out
IF dw_1.GetItemNumber(1,"commenttestsum") > 0 THEN
	MessageBox("Warning","You must input a comment for all rows !")
	Return
END IF

IF dw_1.Update() = 1 THEN
	Commit;
ELSE
	Rollback;
	MessageBox("Error","Update failed ! Contact system administartor.")
END IF
end event

type dw_1 from datawindow within w_weekly_report_admin
integer y = 28
integer width = 4539
integer height = 1832
integer taborder = 30
string title = "none"
string dataobject = "d_weekly_report_data"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_weekly_report_admin
integer x = 1458
integer y = 1872
integer width = 1120
integer height = 144
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sort"
end type

