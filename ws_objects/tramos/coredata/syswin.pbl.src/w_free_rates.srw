$PBExportHeader$w_free_rates.srw
$PBExportComments$This window is used to update "free rates" used for open days in pool allocation. Started from menu "system tables", "Free Rates"
forward
global type w_free_rates from window
end type
type rb_swift from radiobutton within w_free_rates
end type
type rb_handy from radiobutton within w_free_rates
end type
type cb_close from commandbutton within w_free_rates
end type
type st_1 from statictext within w_free_rates
end type
type cb_update from commandbutton within w_free_rates
end type
type dw_year from datawindow within w_free_rates
end type
type cb_1 from commandbutton within w_free_rates
end type
type dw_free_rate from datawindow within w_free_rates
end type
type gb_1 from groupbox within w_free_rates
end type
end forward

global type w_free_rates from window
integer width = 1929
integer height = 1528
boolean titlebar = true
string title = "Update Free Rates"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
rb_swift rb_swift
rb_handy rb_handy
cb_close cb_close
st_1 st_1
cb_update cb_update
dw_year dw_year
cb_1 cb_1
dw_free_rate dw_free_rate
gb_1 gb_1
end type
global w_free_rates w_free_rates

on w_free_rates.create
this.rb_swift=create rb_swift
this.rb_handy=create rb_handy
this.cb_close=create cb_close
this.st_1=create st_1
this.cb_update=create cb_update
this.dw_year=create dw_year
this.cb_1=create cb_1
this.dw_free_rate=create dw_free_rate
this.gb_1=create gb_1
this.Control[]={this.rb_swift,&
this.rb_handy,&
this.cb_close,&
this.st_1,&
this.cb_update,&
this.dw_year,&
this.cb_1,&
this.dw_free_rate,&
this.gb_1}
end on

on w_free_rates.destroy
destroy(this.rb_swift)
destroy(this.rb_handy)
destroy(this.cb_close)
destroy(this.st_1)
destroy(this.cb_update)
destroy(this.dw_year)
destroy(this.cb_1)
destroy(this.dw_free_rate)
destroy(this.gb_1)
end on

event open;long ll_found

dw_year.setTransObject(SQLCA)
dw_free_rate.setTransObject(SQLCA)
dw_year.retrieve()

ll_found = dw_year.find("rate_year="+string(year(today())),1,9999)
if ll_found > 0 then
	dw_year.scrollToRow(ll_found)
end if
end event

event closequery;dw_free_rate.acceptText()

if dw_free_rate.modifiedCount() > 0 then
	if messageBox("", "Rates modified but not saved. Are you sure you don't want to update", Question!,YesNo!,2) = 2 then
		return 1
	else
		return 0
	end if
end if
end event

type rb_swift from radiobutton within w_free_rates
integer x = 617
integer y = 60
integer width = 448
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Swift Tankers"
end type

event clicked;long		ll_row

if dw_free_rate.dataObject = "d_free_rate_swift" then return

dw_free_rate.acceptText()

if dw_free_rate.modifiedCount() > 0 then
	if messageBox("", "Rates modified but not saved. Are you sure you don't want to update", Question!,YesNo!,2) = 1 then
		//
	else
		rb_handy.checked = true
		rb_swift.checked = false
		return 
	end if
end if

dw_free_rate.dataObject = "d_free_rate_swift"
dw_free_rate.setTransObject(sqlca)

ll_row = dw_year.getSelectedrow( 0 )
if ll_row > 0 then
	dw_free_rate.retrieve(dw_year.getItemNumber(ll_row, "rate_year"))
else
	dw_free_rate.reset()
end if

end event

type rb_handy from radiobutton within w_free_rates
integer x = 91
integer y = 60
integer width = 443
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Handytankers"
boolean checked = true
end type

event clicked;long		ll_row

if dw_free_rate.dataObject = "d_free_rate_handy" then return

dw_free_rate.acceptText()

if dw_free_rate.modifiedCount() > 0 then
	if messageBox("", "Rates modified but not saved. Are you sure you don't want to update", Question!,YesNo!,2) = 1 then
		//
	else
		rb_handy.checked = false
		rb_swift.checked = true
		return 
	end if
end if

dw_free_rate.dataObject = "d_free_rate_handy"
dw_free_rate.setTransObject(sqlca)

ll_row = dw_year.getSelectedrow( 0 )
if ll_row > 0 then
	dw_free_rate.retrieve(dw_year.getItemNumber(ll_row, "rate_year"))
else
	dw_free_rate.reset()
end if

end event

type cb_close from commandbutton within w_free_rates
integer x = 1312
integer y = 1276
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
boolean cancel = true
end type

event clicked;close(parent)
end event

type st_1 from statictext within w_free_rates
integer x = 1189
integer y = 24
integer width = 645
integer height = 500
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Update ~'Free Rates~' for a Vessel with TC index 100. The rates are used when calculating Estimated TCE for Open Days. Handytankers / Swift Tankers Pool WEB Pre- and Post allocations."
boolean focusrectangle = false
end type

type cb_update from commandbutton within w_free_rates
integer x = 1312
integer y = 1136
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Update"
boolean default = true
end type

event clicked;if dw_free_rate.update() = 1 then
	commit;
else
	Rollback;
	MessageBox("Update Error", "Error updating rates")
end if
end event

type dw_year from datawindow within w_free_rates
integer x = 59
integer y = 200
integer width = 311
integer height = 1176
integer taborder = 40
string title = "none"
string dataobject = "d_free_rate_year"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if currentrow < 1 then return

this.selectrow(0, false)
this.selectrow(currentrow, true)

dw_free_rate.retrieve(dw_year.getItemNumber(currentrow, "rate_year"))

end event

event rowfocuschanging;dw_free_rate.acceptText()

if dw_free_rate.modifiedCount() > 0 then
	if messageBox("", "Rates modified but not saved. Are you sure you don't want to update", Question!,YesNo!,2) = 2 then
		return 1
	else
		return 0
	end if
end if
end event

type cb_1 from commandbutton within w_free_rates
boolean visible = false
integer x = 1189
integer y = 748
integer width = 690
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "run once for initial values"
end type

event clicked;long year, month, yy, mm, ll_row

string ls_sql
ls_sql = "delete from RATES_FOR_OPEN_DAYS"
execute immediate :ls_sql;
commit;

for yy=2000 to 2020
	for mm = 1 to 12
		ll_row = dw_free_rate.InsertRow(0)
		dw_free_rate.setItem(ll_row, "rate_year", yy)
		dw_free_rate.setItem(ll_row, "rate_month", mm)
		dw_free_rate.setItem(ll_row, "rate", 30000)
	next 
next 

dw_free_rate.Update()
commit;

		
end event

type dw_free_rate from datawindow within w_free_rates
integer x = 402
integer y = 200
integer width = 718
integer height = 1180
integer taborder = 10
string title = "none"
string dataobject = "d_free_rate_handy"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_free_rates
integer x = 59
integer width = 1065
integer height = 160
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Pool"
end type

