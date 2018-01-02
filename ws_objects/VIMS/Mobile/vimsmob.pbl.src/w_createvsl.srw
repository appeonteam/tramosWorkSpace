$PBExportHeader$w_createvsl.srw
forward
global type w_createvsl from window
end type
type st_4 from statictext within w_createvsl
end type
type cb_close from commandbutton within w_createvsl
end type
type cb_create from commandbutton within w_createvsl
end type
type sle_name from singlelineedit within w_createvsl
end type
type st_3 from statictext within w_createvsl
end type
type sle_num from singlelineedit within w_createvsl
end type
type st_2 from statictext within w_createvsl
end type
type sle_imo from singlelineedit within w_createvsl
end type
type st_1 from statictext within w_createvsl
end type
type gb_1 from groupbox within w_createvsl
end type
end forward

global type w_createvsl from window
integer width = 1751
integer height = 756
boolean titlebar = true
string title = "New Vessel"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_4 st_4
cb_close cb_close
cb_create cb_create
sle_name sle_name
st_3 st_3
sle_num sle_num
st_2 st_2
sle_imo sle_imo
st_1 st_1
gb_1 gb_1
end type
global w_createvsl w_createvsl

on w_createvsl.create
this.st_4=create st_4
this.cb_close=create cb_close
this.cb_create=create cb_create
this.sle_name=create sle_name
this.st_3=create st_3
this.sle_num=create sle_num
this.st_2=create st_2
this.sle_imo=create sle_imo
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_4,&
this.cb_close,&
this.cb_create,&
this.sle_name,&
this.st_3,&
this.sle_num,&
this.st_2,&
this.sle_imo,&
this.st_1,&
this.gb_1}
end on

on w_createvsl.destroy
destroy(this.st_4)
destroy(this.cb_close)
destroy(this.cb_create)
destroy(this.sle_name)
destroy(this.st_3)
destroy(this.sle_num)
destroy(this.st_2)
destroy(this.sle_imo)
destroy(this.st_1)
destroy(this.gb_1)
end on

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 3900)
end event

type st_4 from statictext within w_createvsl
integer x = 585
integer y = 400
integer width = 1097
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "( Do not include any prefix such as MT, SS, etc.)"
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_createvsl
integer x = 1024
integer y = 528
integer width = 475
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
g_Obj.Level = 0

Close(Parent)
end event

type cb_create from commandbutton within w_createvsl
integer x = 219
integer y = 528
integer width = 475
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Create Vessel"
end type

event clicked;Long ll_IMO, ll_Temp
String ls_Num, ls_Name

g_Obj.Level = 0

If sle_num.Text = "" then 
	Messagebox("Vessel Number", "Please specify the vessel number.")
	sle_num.SetFocus( )
	Return
End If

If sle_imo.Text = "" then 
	Messagebox("Vessel IMO Number", "Please specify the vessel's IMO number.")
	sle_imo.SetFocus( )
	Return
End If

If Len(sle_imo.Text) <> 7 then 
	Messagebox("Vessel IMO Number", "The vessel's IMO number must be 7 digits in length.")
	sle_imo.SetFocus( )
	sle_imo.SelectText(1, Len(sle_imo.Text))
	Return
End If

If sle_name.Text = "" then 
	Messagebox("Vessel Name", "Please specify the vessel's name.")
	sle_name.SetFocus( )
	Return
End If

If f_CheckInvalid(sle_name.Text) then
	Messagebox("Vessel Name", "The vessel's name contains invalid characters (replaced by underscore).~n~nPlease check and try again.")
	sle_name.SetFocus( )
	Return
End If

ll_IMO = Long(sle_IMO.Text)
ls_Num = sle_num.Text
ls_Name = sle_name.Text

Select Count(*) Into :ll_Temp From VESSELS Where (IMO_NUMBER = :ll_IMO);

If SQLCA.SQLCode < 0 then
	Rollback;
	Messagebox("DB Error", "Could not check existing vessels for IMO number.~n~n" + SQLCA.SQLErrtext, Exclamation!)
	Return
End If

If ll_Temp > 0 then
	Messagebox("Vessel IMO", "The IMO number specified already belongs to one of the vessels in the list. Please make sure the IMO number is entered correctly.", Exclamation!)
	sle_imo.SetFocus( )
	sle_imo.SelectText(1, Len(sle_imo.Text))	
	Return
End If

Select Count(*) Into :ll_Temp From VESSELS Where (VESSEL_REF_NR = :ls_Num);

If SQLCA.SQLCode < 0 then
	Rollback;
	Messagebox("DB Error", "Could not check existing vessel numbers.~n~n" + SQLCA.SQLErrtext, Exclamation!)
	Return
End If

If ll_Temp > 0 then
	Messagebox("Vessel Number", "The Vessel number specified already belongs to one of the vessels in the list. Please make sure the vessel number is entered correctly.", Exclamation!)
	sle_num.SetFocus( )
	sle_num.SelectText(1, Len(sle_num.Text))	
	Return
End If

Insert Into VESSELS (VESSEL_REF_NR, VESSEL_NAME, IMO_NUMBER, VESSEL_ACTIVE) Values( :ls_Num, :ls_Name, :ll_IMO, 1);

If SQLCA.SQLCode < 0 then
	Rollback;
	Messagebox("DB Error", "Could add new vessel to database.~n~n" + SQLCA.SQLErrtext, Exclamation!)
	Return
End If

Commit;

Messagebox("Vessel Added", "The vessel '" + ls_Name + "' was added successfully.")

g_Obj.Level = 1
g_Obj.ParamString = ls_Num

Close(Parent)
end event

type sle_name from singlelineedit within w_createvsl
integer x = 585
integer y = 320
integer width = 1097
integer height = 80
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

event modified;
This.Text = WordCap(Trim(This.Text))
end event

type st_3 from statictext within w_createvsl
integer x = 91
integer y = 336
integer width = 421
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Name:"
boolean focusrectangle = false
end type

type sle_num from singlelineedit within w_createvsl
integer x = 585
integer y = 64
integer width = 219
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 5
borderstyle borderstyle = stylelowered!
end type

event modified;
This.Text = Trim(Upper(This.Text))
end event

type st_2 from statictext within w_createvsl
integer x = 91
integer y = 80
integer width = 430
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Number:"
boolean focusrectangle = false
end type

type sle_imo from singlelineedit within w_createvsl
integer x = 585
integer y = 192
integer width = 457
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;
This.Text = String(Long(This.Text))
end event

type st_1 from statictext within w_createvsl
integer x = 91
integer y = 208
integer width = 421
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "IMO Number:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_createvsl
integer x = 18
integer width = 1701
integer height = 496
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

