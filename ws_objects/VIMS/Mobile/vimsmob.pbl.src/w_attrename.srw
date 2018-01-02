$PBExportHeader$w_attrename.srw
forward
global type w_attrename from window
end type
type st_3 from statictext within w_attrename
end type
type st_2 from statictext within w_attrename
end type
type cb_cancel from commandbutton within w_attrename
end type
type cb_ok from commandbutton within w_attrename
end type
type sle_name from singlelineedit within w_attrename
end type
type st_1 from statictext within w_attrename
end type
type ln_1 from line within w_attrename
end type
end forward

global type w_attrename from window
integer width = 1833
integer height = 680
boolean titlebar = true
string title = "Rename Attachment"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_3 st_3
st_2 st_2
cb_cancel cb_cancel
cb_ok cb_ok
sle_name sle_name
st_1 st_1
ln_1 ln_1
end type
global w_attrename w_attrename

on w_attrename.create
this.st_3=create st_3
this.st_2=create st_2
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_name=create sle_name
this.st_1=create st_1
this.ln_1=create ln_1
this.Control[]={this.st_3,&
this.st_2,&
this.cb_cancel,&
this.cb_ok,&
this.sle_name,&
this.st_1,&
this.ln_1}
end on

on w_attrename.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_name)
destroy(this.st_1)
destroy(this.ln_1)
end on

event open;Integer li_Pos

f_Write2Log("w_AttRename Open")

// The following code selects the name of the file without the extension

li_Pos = Len(g_Obj.ParamString) 

Do
	li_Pos --
Loop Until Mid(g_Obj.ParamString, li_Pos, 1) = "." or li_Pos <= 1

li_Pos --

If li_Pos = 0 then li_Pos = Len(g_Obj.ParamString) 

sle_name.Text = g_Obj.ParamString

sle_name.SelectText(1, li_Pos)
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 1000)
end event

type st_3 from statictext within w_attrename
integer x = 37
integer y = 288
integer width = 1774
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "Renaming the extension may cause the file to become unusable. Do not change the extension unless absolutely necessary."
boolean focusrectangle = false
end type

type st_2 from statictext within w_attrename
integer x = 37
integer y = 224
integer width = 238
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "Caution:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_attrename
integer x = 1061
integer y = 480
integer width = 402
integer height = 96
integer taborder = 30
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
f_Write2Log("w_AttRename Cancel")

g_Obj.ParamString = ""

Close(Parent)
end event

type cb_ok from commandbutton within w_attrename
integer x = 347
integer y = 480
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ok"
boolean default = true
end type

event clicked;Integer li_Pos

g_Obj.ParamString = Trim(sle_name.text)

If Len(g_Obj.ParamString)<5 then 
	Messagebox("Invalid Name", "The full file name must be at least 5 characters including the extension.",Exclamation!)
	Return
End If

For li_Pos = 1 to Len(g_Obj.ParamString)
	If Pos("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&(){}[];',.-=+_ ", Upper(Mid(g_Obj.ParamString,li_Pos,1))) = 0 then
		Messagebox("Invalid Name", "The file name contains one or more invalid characters.",Exclamation!)
		Return		
	End If
Next

If (Left(g_Obj.Paramstring,1) = ".") or (Right(g_Obj.Paramstring,1) = ".") then
	Messagebox("Invalid Name", "The file name is invalid. Please check the file name and try again.",Exclamation!)
	Return		
End If

f_Write2Log("w_AttRename Close: " + g_Obj.ParamString)

Close(Parent)
end event

type sle_name from singlelineedit within w_attrename
integer x = 37
integer y = 112
integer width = 1755
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_attrename
integer x = 37
integer y = 32
integer width = 1189
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enter a new file name for the attachment:"
boolean focusrectangle = false
end type

type ln_1 from line within w_attrename
long linecolor = 33554432
integer linethickness = 4
integer beginx = 37
integer beginy = 448
integer endx = 1774
integer endy = 448
end type

