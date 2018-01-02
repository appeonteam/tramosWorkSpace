$PBExportHeader$w_consreport.srw
forward
global type w_consreport from window
end type
type st_to from statictext within w_consreport
end type
type dp_to from datepicker within w_consreport
end type
type dp_from from datepicker within w_consreport
end type
type hsb_year from hscrollbar within w_consreport
end type
type st_year from statictext within w_consreport
end type
type cb_cancel from commandbutton within w_consreport
end type
type cb_create from commandbutton within w_consreport
end type
type rb_period from radiobutton within w_consreport
end type
type rb_year from radiobutton within w_consreport
end type
type rb_all from radiobutton within w_consreport
end type
type st_1 from statictext within w_consreport
end type
type gb_1 from groupbox within w_consreport
end type
end forward

global type w_consreport from window
integer width = 2263
integer height = 988
boolean titlebar = true
string title = "Report Period Selection"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_to st_to
dp_to dp_to
dp_from dp_from
hsb_year hsb_year
st_year st_year
cb_cancel cb_cancel
cb_create cb_create
rb_period rb_period
rb_year rb_year
rb_all rb_all
st_1 st_1
gb_1 gb_1
end type
global w_consreport w_consreport

on w_consreport.create
this.st_to=create st_to
this.dp_to=create dp_to
this.dp_from=create dp_from
this.hsb_year=create hsb_year
this.st_year=create st_year
this.cb_cancel=create cb_cancel
this.cb_create=create cb_create
this.rb_period=create rb_period
this.rb_year=create rb_year
this.rb_all=create rb_all
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_to,&
this.dp_to,&
this.dp_from,&
this.hsb_year,&
this.st_year,&
this.cb_cancel,&
this.cb_create,&
this.rb_period,&
this.rb_year,&
this.rb_all,&
this.st_1,&
this.gb_1}
end on

on w_consreport.destroy
destroy(this.st_to)
destroy(this.dp_to)
destroy(this.dp_from)
destroy(this.hsb_year)
destroy(this.st_year)
destroy(this.cb_cancel)
destroy(this.cb_create)
destroy(this.rb_period)
destroy(this.rb_year)
destroy(this.rb_all)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
st_Year.Text = String(Year(Today()))
end event

type st_to from statictext within w_consreport
boolean visible = false
integer x = 1353
integer y = 544
integer width = 91
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "To"
alignment alignment = center!
boolean focusrectangle = false
end type

type dp_to from datepicker within w_consreport
boolean visible = false
integer x = 1463
integer y = 528
integer width = 384
integer height = 80
integer taborder = 30
boolean border = true
borderstyle borderstyle = stylelowered!
datetimeformat format = dtfcustom!
string customformat = "dd MMM yy"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2010-02-26"), Time("13:56:46.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

event valuechanged;
If dp_To.Value < dp_From.Value then dp_From.Value = dp_To.Value
end event

type dp_from from datepicker within w_consreport
boolean visible = false
integer x = 951
integer y = 528
integer width = 384
integer height = 80
integer taborder = 20
boolean border = true
borderstyle borderstyle = stylelowered!
datetimeformat format = dtfcustom!
string customformat = "dd MMM yy"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2010-02-26"), Time("13:56:46.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

event valuechanged;
If dp_From.Value > dp_To.Value then dp_To.Value = dp_From.Value
end event

type hsb_year from hscrollbar within w_consreport
boolean visible = false
integer x = 1134
integer y = 400
integer width = 128
integer height = 80
end type

event lineleft;Integer li_Year

li_Year = Integer(st_Year.Text)

If li_Year > 2000 then li_Year --

st_Year.Text = String(li_Year)
end event

event lineright;Integer li_Year

li_Year = Integer(st_Year.Text)

If li_Year < 2099 then li_Year ++

st_Year.Text = String(li_Year)
end event

type st_year from statictext within w_consreport
boolean visible = false
integer x = 951
integer y = 400
integer width = 183
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "0000"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_consreport
integer x = 1317
integer y = 768
integer width = 530
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type cb_create from commandbutton within w_consreport
integer x = 421
integer y = 768
integer width = 530
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create Report"
end type

event clicked;
Date ld_From, ld_To
String ls_Temp, ls_Char

If rb_All.Checked then
	ld_From = 2000-01-01
	ld_To = 2099-12-31
	ls_Temp = "All voyages"
End If

If rb_Year.Checked then
	ld_From = Date(st_Year.Text + "-01-01")
	ld_To = Date(st_Year.Text + "-12-31")
	ls_Temp = "For Year " + st_Year.Text
End If

If rb_Period.Checked then
	ld_From = Date(dp_From.Value)
	ld_To = Date(dp_To.Value)
	ls_Temp = "Period: From " + String(ld_From, "dd MMM yy") + " to " + String(ld_To, "dd MMM yy")
End If

ld_To = RelativeDate (ld_To, 1)

OpenSheet(w_Report, w_Main, 0, Original!)

Close(Parent)

SetPointer(HourGlass!)

If g_parameters.selection = 0 then w_Report.dw_Rep.DataObject = "d_sq_tb_consreport" else  w_Report.dw_Rep.DataObject = "d_sq_tb_speedconsreport"
w_Report.dw_Rep.SetTransObject(SQLCA)
w_Report.dw_Rep.Object.Datawindow.Print.Preview = 'Yes'
w_Report.dw_Rep.Object.t_Title.Text = ls_Temp

// Select correct logo on report
If g_userInfo.PC_Logo = 2 then  // If Handytankers
	w_Report.dw_Rep.object.p_handy.Visible = 1
	w_Report.dw_Rep.object.p_maersk.Visible = 0
	w_Report.dw_Rep.object.t_company.Text = "Handytankers"
End If

w_Report.dw_Rep.Retrieve(ld_From, ld_To, g_userinfo.userid)






end event

type rb_period from radiobutton within w_consreport
integer x = 274
integer y = 528
integer width = 549
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Specific Period"
end type

event clicked;
st_Year.Visible = False
hsb_Year.Visible = False

dp_To.Visible = True
dp_From.Visible = True
st_To.Visible = True
end event

type rb_year from radiobutton within w_consreport
integer x = 274
integer y = 400
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Full Year"
end type

event clicked;
st_Year.Visible = True
hsb_Year.Visible = True

dp_To.Visible = False
dp_From.Visible = False
st_To.Visible = False
end event

type rb_all from radiobutton within w_consreport
integer x = 274
integer y = 272
integer width = 494
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Complete"
end type

event clicked;
st_Year.Visible = False
hsb_Year.Visible = False

dp_To.Visible = False
dp_From.Visible = False
st_To.Visible = False
end event

type st_1 from statictext within w_consreport
integer x = 128
integer y = 128
integer width = 1079
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please select a period for the report:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_consreport
integer x = 18
integer width = 2213
integer height = 736
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

