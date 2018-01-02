$PBExportHeader$w_deletedb.srw
forward
global type w_deletedb from window
end type
type st_4 from statictext within w_deletedb
end type
type cb_cancel from commandbutton within w_deletedb
end type
type cb_delete from commandbutton within w_deletedb
end type
type sle_pw from singlelineedit within w_deletedb
end type
type st_3 from statictext within w_deletedb
end type
type st_2 from statictext within w_deletedb
end type
type st_1 from statictext within w_deletedb
end type
type gb_1 from groupbox within w_deletedb
end type
end forward

global type w_deletedb from window
integer width = 1870
integer height = 1064
boolean titlebar = true
string title = "Delete VIMS Mobile Database"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_4 st_4
cb_cancel cb_cancel
cb_delete cb_delete
sle_pw sle_pw
st_3 st_3
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_deletedb w_deletedb

on w_deletedb.create
this.st_4=create st_4
this.cb_cancel=create cb_cancel
this.cb_delete=create cb_delete
this.sle_pw=create sle_pw
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_4,&
this.cb_cancel,&
this.cb_delete,&
this.sle_pw,&
this.st_3,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_deletedb.destroy
destroy(this.st_4)
destroy(this.cb_cancel)
destroy(this.cb_delete)
destroy(this.sle_pw)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
f_Write2Log("w_DeleteDB Open")
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 1300)
end event

type st_4 from statictext within w_deletedb
integer x = 73
integer y = 688
integer width = 1554
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VIMS Mobile must be closed on all workstations (if any)"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_deletedb
integer x = 1024
integer y = 848
integer width = 567
integer height = 112
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
Close(Parent)
end event

type cb_delete from commandbutton within w_deletedb
integer x = 238
integer y = 848
integer width = 567
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete Database"
boolean default = true
end type

event clicked;Long ll_Value
Integer li_Loop
String ls_PW, ls_Month
Boolean lbool_Fail

ll_Value = Year(Today())

ll_Value *= ll_Value + Month(Today())    // Square Year and add month

ll_Value = Mod(1073741824, ll_Value)    // Get remainder when 2^30 is divided by value

ls_Month = String(Today(), "mmm")

For li_Loop = 1 to 3  // Add cube of ASCII of each character in userid
	ll_Value += AscA(Mid(ls_Month, li_Loop, 1)) * AscA(Mid(ls_Month, li_Loop, 1)) * AscA(Mid(ls_Month, li_Loop, 1))
Next 

ls_PW = String(ll_Value)      // Convert to string

Do While Len(ls_PW) < 6       // If less than 6 digits, add zeros to beginning
	ls_PW = '0' + ls_PW
Loop

li_Loop = Integer(Left(ls_PW, 1)) * 2   // Get value of first char and multiply by 2

ls_PW = CharA(66 + li_Loop) + Right(ls_PW, Len(ls_PW) - 1)   // Convert first char into alphabet

If ls_PW = sle_Pw.Text then
	If Messagebox("Password Accepted", "The password was accepted. The VIMS Mobile Database will now be deleted and VIMS Mobile will be closed. VIMS Mobile will attempt to re-create the database on the next startup.~n~nAre you SURE you want to proceed?", Question!, YesNo!) = 2 then Return

	f_Write2Log("PW Accepted. Dropping Database VIMSDB...")
	
	Execute Immediate "Commit Transaction";
	Execute Immediate "Use Master";
	If SQLCA.SQLCode<0 then 
		Messagebox("DB Error", "Unable to use the Master DB.~n~n" + SQLCA.SQLErrText, StopSign!)
		lbool_Fail = True
	End If
	If Not lbool_Fail then
		Execute Immediate "Drop Database VIMSDB";
		If SQLCA.SQLCode<0 then 
			Messagebox("DB Error", "Critical Error: Unable to drop database.~n~n" + SQLCA.SQLErrText, StopSign!)
			f_Write2Log("Drop Failed: " + SQLCA.SQLErrText)
			lbool_Fail = True
		Else
			f_Write2Log("Database Dropped")
		End If
	End If
		
	Disconnect Using SQLCA;
	
	If lbool_Fail then
		Messagebox("Deletion Failed", "The VIMS Mobile database could not be deleted. VIMS Mobile cannot continue.", StopSign!)
	Else
		Messagebox("Database Deleted", "The VIMS Mobile database was successfully deleted. VIMS Mobile will now close.~n~nPlease restart the application to create the database again.")
	End If
	Close(Parent)
	Close(w_Main)
Else
	Messagebox("Incorrect Password", "The password entered is not correct.", Exclamation!)
	sle_PW.Text = ""
	sle_PW.SetFocus()
End If
end event

type sle_pw from singlelineedit within w_deletedb
integer x = 567
integer y = 512
integer width = 786
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean password = true
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_deletedb
integer x = 73
integer y = 528
integer width = 475
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enter Password:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_deletedb
integer x = 73
integer y = 352
integer width = 1623
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "A special password will be required to authorize this deletion."
boolean focusrectangle = false
end type

type st_1 from statictext within w_deletedb
integer x = 73
integer y = 80
integer width = 1723
integer height = 224
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "The VIMS Mobile database must be deleted only as a last resort due to severe database corruption or when instructed by the Vetting department."
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_deletedb
integer x = 18
integer width = 1810
integer height = 816
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

