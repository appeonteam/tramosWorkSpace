$PBExportHeader$w_verifysa.srw
forward
global type w_verifysa from window
end type
type cb_gen from commandbutton within w_verifysa
end type
type sle_sapw from singlelineedit within w_verifysa
end type
type st_1 from statictext within w_verifysa
end type
type cb_close from commandbutton within w_verifysa
end type
type gb_1 from groupbox within w_verifysa
end type
end forward

global type w_verifysa from window
integer width = 1298
integer height = 592
boolean titlebar = true
string title = "Admin Access Required"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_gen cb_gen
sle_sapw sle_sapw
st_1 st_1
cb_close cb_close
gb_1 gb_1
end type
global w_verifysa w_verifysa

on w_verifysa.create
this.cb_gen=create cb_gen
this.sle_sapw=create sle_sapw
this.st_1=create st_1
this.cb_close=create cb_close
this.gb_1=create gb_1
this.Control[]={this.cb_gen,&
this.sle_sapw,&
this.st_1,&
this.cb_close,&
this.gb_1}
end on

on w_verifysa.destroy
destroy(this.cb_gen)
destroy(this.sle_sapw)
destroy(this.st_1)
destroy(this.cb_close)
destroy(this.gb_1)
end on

type cb_gen from commandbutton within w_verifysa
integer x = 201
integer y = 384
integer width = 347
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ok"
boolean default = true
end type

event clicked;
// Below disabled as 'sa' password not accessible anymore.
// Have changed to static password

//Transaction MyTrans
//
//MyTrans = Create Transaction
//
//MyTrans.DBMS = SQLCA.DBMS
//MyTrans.Database = SQLCA.Database
//MyTrans.Servername = SQLCA.Servername
//MyTrans.Logid = "sa"
//MyTrans.LogPass = sle_sapw.Text
//MyTrans.Autocommit = False
//
//Connect Using MyTrans;
//
//If MyTrans.SQLCode <> 0 then
//	Messagebox("Connect Error", "Could not verify admin password.~n~n" + MyTrans.SQLErrText)
//	Destroy MyTrans
//	Return
//End If
//
//Disconnect Using MyTrans;
//
//Destroy MyTrans
//

If sle_sapw.Text <> "Vims_Admin" then
	Messagebox("Invalid Password", "The supplied password is not correct.")
	sle_sapw.Text = ""
	sle_sapw.setfocus( )
	Return
End If

Close(Parent)

Open(w_sqlIssue)
end event

type sle_sapw from singlelineedit within w_verifysa
integer x = 91
integer y = 160
integer width = 1097
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

type st_1 from statictext within w_verifysa
integer x = 91
integer y = 96
integer width = 987
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please enter the VIMS admin password:"
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_verifysa
integer x = 750
integer y = 384
integer width = 347
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 700
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

type gb_1 from groupbox within w_verifysa
integer x = 18
integer width = 1243
integer height = 352
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
end type

