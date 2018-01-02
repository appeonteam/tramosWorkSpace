$PBExportHeader$w_redflag.srw
forward
global type w_redflag from window
end type
type tab_1 from tab within w_redflag
end type
type tabpage_1 from userobject within tab_1
end type
type cb_save from commandbutton within tabpage_1
end type
type mle_reason from multilineedit within tabpage_1
end type
type st_4 from statictext within tabpage_1
end type
type mle_notes from multilineedit within tabpage_1
end type
type st_3 from statictext within tabpage_1
end type
type rb_n from radiobutton within tabpage_1
end type
type rb_y from radiobutton within tabpage_1
end type
type st_2 from statictext within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_save cb_save
mle_reason mle_reason
st_4 st_4
mle_notes mle_notes
st_3 st_3
rb_n rb_n
rb_y rb_y
st_2 st_2
end type
type tabpage_2 from userobject within tab_1
end type
type st_6 from statictext within tabpage_2
end type
type st_5 from statictext within tabpage_2
end type
type dw_hist from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
st_6 st_6
st_5 st_5
dw_hist dw_hist
end type
type tab_1 from tab within w_redflag
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type cb_cancel from commandbutton within w_redflag
end type
type st_port from statictext within w_redflag
end type
type st_1 from statictext within w_redflag
end type
end forward

global type w_redflag from window
integer width = 2254
integer height = 2340
boolean titlebar = true
string title = "Port Red Flag Status"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
tab_1 tab_1
cb_cancel cb_cancel
st_port st_port
st_1 st_1
end type
global w_redflag w_redflag

type variables

String is_Port
end variables

on w_redflag.create
this.tab_1=create tab_1
this.cb_cancel=create cb_cancel
this.st_port=create st_port
this.st_1=create st_1
this.Control[]={this.tab_1,&
this.cb_cancel,&
this.st_port,&
this.st_1}
end on

on w_redflag.destroy
destroy(this.tab_1)
destroy(this.cb_cancel)
destroy(this.st_port)
destroy(this.st_1)
end on

event open;
is_Port = Trim(Message.StringParm)

String ls_Notes, ls_Port
Integer li_Red
mt_n_stringfunctions lStr

Select PORT_N,VETT_NOTES,VETT_REDFLAG
Into :ls_Port, :ls_Notes, :li_Red
From PORTS Where PORT_CODE=:is_Port;

If SQLCA.SQLCode<>0 Then is_Port=""

Commit;

If is_Port = "" Then 
	MessageBox("No Port", "Could not load port", Exclamation!)
	tab_1.tabpage_1.cb_Save.Enabled = False
	tab_1.tabpage_1.rb_Y.Enabled = False
	tab_1.tabpage_1.rb_N.Enabled = False
Else
	If li_Red=1 Then tab_1.tabpage_1.rb_Y.Checked = True Else tab_1.tabpage_1.rb_N.Checked = True
	tab_1.tabpage_1.mle_Notes.Text = ls_Notes
	st_port.Text =  lStr.of_replace(is_Port+" - "+ls_Port, "&", "&&")
	tab_1.tabpage_2.dw_Hist.SetTransObject(SQLCA)
	tab_1.tabpage_2.dw_Hist.Retrieve(is_Port)	
End If
end event

type tab_1 from tab within w_redflag
event create ( )
event destroy ( )
integer x = 37
integer y = 144
integer width = 2158
integer height = 1936
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2121
integer height = 1808
long backcolor = 67108864
string text = "Port Details"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_save cb_save
mle_reason mle_reason
st_4 st_4
mle_notes mle_notes
st_3 st_3
rb_n rb_n
rb_y rb_y
st_2 st_2
end type

on tabpage_1.create
this.cb_save=create cb_save
this.mle_reason=create mle_reason
this.st_4=create st_4
this.mle_notes=create mle_notes
this.st_3=create st_3
this.rb_n=create rb_n
this.rb_y=create rb_y
this.st_2=create st_2
this.Control[]={this.cb_save,&
this.mle_reason,&
this.st_4,&
this.mle_notes,&
this.st_3,&
this.rb_n,&
this.rb_y,&
this.st_2}
end on

on tabpage_1.destroy
destroy(this.cb_save)
destroy(this.mle_reason)
destroy(this.st_4)
destroy(this.mle_notes)
destroy(this.st_3)
destroy(this.rb_n)
destroy(this.rb_y)
destroy(this.st_2)
end on

type cb_save from commandbutton within tabpage_1
integer x = 1701
integer y = 1696
integer width = 366
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update"
end type

event clicked;Integer li_Red

mle_Notes.Text = Trim(mle_Notes.Text, True)
mle_Reason.Text = Trim(mle_Reason.Text, True)

If rb_Y.Checked and mle_Notes.Text = "" Then
	Messagebox("Notes Required", "Please specify Red Flag Notes if port is a red-flag port.", Exclamation!)
	Return
End If

If mle_Reason.Text = "" Then
	Messagebox("Reason Required", "Please specify the Reason for updating this port.", Exclamation!)
	Return
End If

If rb_Y.Checked Then li_Red=1 Else li_Red=0

Insert Into VETT_REDFLAGHIST( PORT_CODE,MODIFIEDBY,FLAGGED,VETT_NOTES,REASON)
Values (:is_Port,:g_Obj.UserID,:li_Red,:mle_Notes.Text,:mle_Reason.Text);

If SQLCA.SQLCode = 0 Then
	Commit;
Else
	Messagebox("DB Error", "Unable to add history record: " + SQLCA.SQLErrText, Exclamation!)
	Rollback;
	Return
End If

Update PORTS Set VETT_REDFLAG=:li_Red, VETT_NOTES=:mle_Notes.Text
Where PORT_CODE=:is_Port;

If SQLCA.SQLCode = 0 Then
	Commit;
Else
	Messagebox("DB Error", "Unable to update port: " + SQLCA.SQLErrText, Exclamation!)
	Rollback;
	Return
End If

tab_1.tabpage_2.dw_Hist.Retrieve(is_Port)

Messagebox("Updated", "Red Flag status and notes for this port were successfully updated.")

mle_Reason.Text = ""

end event

type mle_reason from multilineedit within tabpage_1
integer x = 55
integer y = 1344
integer width = 2011
integer height = 336
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
integer limit = 1000
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within tabpage_1
integer x = 55
integer y = 1264
integer width = 535
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reason for Change:"
boolean focusrectangle = false
end type

type mle_notes from multilineedit within tabpage_1
integer x = 55
integer y = 256
integer width = 2011
integer height = 976
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
integer limit = 2500
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within tabpage_1
integer x = 55
integer y = 176
integer width = 430
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Red Flag Notes:"
boolean focusrectangle = false
end type

type rb_n from radiobutton within tabpage_1
integer x = 677
integer y = 48
integer width = 238
integer height = 112
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
end type

type rb_y from radiobutton within tabpage_1
integer x = 421
integer y = 48
integer width = 238
integer height = 112
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
end type

type st_2 from statictext within tabpage_1
integer x = 55
integer y = 64
integer width = 293
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Red Flag:"
boolean focusrectangle = false
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2121
integer height = 1808
long backcolor = 67108864
string text = "History"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_6 st_6
st_5 st_5
dw_hist dw_hist
end type

on tabpage_2.create
this.st_6=create st_6
this.st_5=create st_5
this.dw_hist=create dw_hist
this.Control[]={this.st_6,&
this.st_5,&
this.dw_hist}
end on

on tabpage_2.destroy
destroy(this.st_6)
destroy(this.st_5)
destroy(this.dw_hist)
end on

type st_6 from statictext within tabpage_2
integer x = 585
integer y = 32
integer width = 379
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "(Newer on top)"
boolean focusrectangle = false
end type

type st_5 from statictext within tabpage_2
integer x = 18
integer y = 32
integer width = 549
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Change History for Port:"
boolean focusrectangle = false
end type

type dw_hist from datawindow within tabpage_2
integer x = 18
integer y = 96
integer width = 2066
integer height = 1680
integer taborder = 20
string title = "none"
string dataobject = "d_sq_ff_redflaghist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_redflag
integer x = 878
integer y = 2112
integer width = 439
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type st_port from statictext within w_redflag
integer x = 274
integer y = 32
integer width = 1902
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_1 from statictext within w_redflag
integer x = 55
integer y = 32
integer width = 219
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port:"
boolean focusrectangle = false
end type

