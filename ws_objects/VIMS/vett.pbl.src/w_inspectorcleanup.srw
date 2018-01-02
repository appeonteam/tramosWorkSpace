$PBExportHeader$w_inspectorcleanup.srw
forward
global type w_inspectorcleanup from window
end type
type cb_rename from commandbutton within w_inspectorcleanup
end type
type sle_nameto from singlelineedit within w_inspectorcleanup
end type
type sle_namefrom from singlelineedit within w_inspectorcleanup
end type
type st_4 from statictext within w_inspectorcleanup
end type
type st_3 from statictext within w_inspectorcleanup
end type
type ddlb_mode from dropdownlistbox within w_inspectorcleanup
end type
type st_2 from statictext within w_inspectorcleanup
end type
type dw_insp from datawindow within w_inspectorcleanup
end type
type rb_first from radiobutton within w_inspectorcleanup
end type
type rb_last from radiobutton within w_inspectorcleanup
end type
type st_1 from statictext within w_inspectorcleanup
end type
type gb_1 from groupbox within w_inspectorcleanup
end type
end forward

global type w_inspectorcleanup from window
integer width = 1495
integer height = 2088
boolean titlebar = true
string title = "Inspector Name Cleanup"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_rename cb_rename
sle_nameto sle_nameto
sle_namefrom sle_namefrom
st_4 st_4
st_3 st_3
ddlb_mode ddlb_mode
st_2 st_2
dw_insp dw_insp
rb_first rb_first
rb_last rb_last
st_1 st_1
gb_1 gb_1
end type
global w_inspectorcleanup w_inspectorcleanup

type variables

String is_Mode = "fname"
end variables

on w_inspectorcleanup.create
this.cb_rename=create cb_rename
this.sle_nameto=create sle_nameto
this.sle_namefrom=create sle_namefrom
this.st_4=create st_4
this.st_3=create st_3
this.ddlb_mode=create ddlb_mode
this.st_2=create st_2
this.dw_insp=create dw_insp
this.rb_first=create rb_first
this.rb_last=create rb_last
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cb_rename,&
this.sle_nameto,&
this.sle_namefrom,&
this.st_4,&
this.st_3,&
this.ddlb_mode,&
this.st_2,&
this.dw_insp,&
this.rb_first,&
this.rb_last,&
this.st_1,&
this.gb_1}
end on

on w_inspectorcleanup.destroy
destroy(this.cb_rename)
destroy(this.sle_nameto)
destroy(this.sle_namefrom)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.ddlb_mode)
destroy(this.st_2)
destroy(this.dw_insp)
destroy(this.rb_first)
destroy(this.rb_last)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
dw_Insp.SetTransObject(SQLCA)
dw_Insp.Retrieve(0)

ddlb_Mode.SelectItem(1)

end event

type cb_rename from commandbutton within w_inspectorcleanup
integer x = 512
integer y = 1824
integer width = 439
integer height = 112
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Rename"
end type

event clicked;
String ls_Confirm, ls_First, ls_Last, ls_New
Integer li_Num

sle_NameTo.Text = Trim(sle_NameTo.Text, True)
ls_New = sle_NameTo.Text

If ls_New = "" then
	Messagebox("Name Required", "Please specify the new " + Lower(ddlb_Mode.Text) + ".", Exclamation!)
	Return
End If

li_Num = dw_Insp.GetItemNumber(dw_Insp.GetRow(), "inspcount")

ls_Confirm = "Rename '" + sle_NameFrom.Text + "' to '" + ls_New + "'?~n~n"
ls_Confirm += "This will affect " + String(li_Num) + " inspection"

If li_Num = 1 then ls_Confirm += " only." Else ls_Confirm += "s."

If Messagebox("Confirm Rename", ls_Confirm, Question!, YesNo!) = 2 then Return

ls_First = dw_Insp.GetItemString(dw_Insp.GetRow(), "FNAME")
ls_Last = dw_Insp.GetItemString(dw_Insp.GetRow(), "LNAME")

If is_Mode = "lname" then
	Update VETT_INSP Set INSP_LNAME=:ls_New Where INSP_LNAME=:ls_Last And INSP_FNAME=:ls_First;
Else
	Update VETT_INSP Set INSP_FNAME=:ls_New Where INSP_LNAME=:ls_Last And INSP_FNAME=:ls_First;
End If

If SQLCA.SQLCode <> 0 Then
	Messagebox("DB Error", "Unable to rename!~n~nError: " + SQLCA.SQLErrtext, Exclamation!)
	Rollback;
	Return
End If

Commit;

dw_Insp.SetRedraw(False)

dw_Insp.Retrieve( )
If rb_First.Checked Then rb_First.event Clicked( )

If is_Mode="lname" then 
	li_Num = dw_Insp.Find("lname='" + ls_New + "' and fname='" + ls_First + "'", 0, dw_Insp.RowCount())
Else
	li_Num = dw_Insp.Find("lname='" + ls_Last + "' and fname='" + ls_New + "'", 0, dw_Insp.RowCount())
End If

If li_Num > 0 then 
	dw_Insp.SetRow(li_Num)
	dw_Insp.ScrollToRow(li_Num)
End If

dw_Insp.SetRedraw(True)
end event

type sle_nameto from singlelineedit within w_inspectorcleanup
integer x = 421
integer y = 1648
integer width = 987
integer height = 96
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_namefrom from singlelineedit within w_inspectorcleanup
integer x = 421
integer y = 1536
integer width = 987
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_inspectorcleanup
integer x = 91
integer y = 1664
integer width = 219
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "To:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_inspectorcleanup
integer x = 91
integer y = 1552
integer width = 219
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "From:"
boolean focusrectangle = false
end type

type ddlb_mode from dropdownlistbox within w_inspectorcleanup
integer x = 421
integer y = 1424
integer width = 640
integer height = 480
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"First Name","Last Name"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
If index = 1 then is_Mode = "fname" Else is_Mode="lname"

dw_Insp.event rowfocuschanged(dw_Insp.GetRow())
end event

type st_2 from statictext within w_inspectorcleanup
integer x = 91
integer y = 1440
integer width = 274
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rename:"
boolean focusrectangle = false
end type

type dw_insp from datawindow within w_inspectorcleanup
integer x = 73
integer y = 176
integer width = 1335
integer height = 1216
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_inspectorunique"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
sle_NameFrom.Text = this.GetItemString(currentrow, is_Mode)
sle_NameTo.Text = ""
end event

type rb_first from radiobutton within w_inspectorcleanup
integer x = 859
integer y = 80
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "First Name"
end type

event clicked;
dw_Insp.Object.Mode.Expression="1"
dw_Insp.Sort( )
end event

type rb_last from radiobutton within w_inspectorcleanup
integer x = 402
integer y = 80
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Last Name"
boolean checked = true
end type

event clicked;
dw_Insp.Object.Mode.Expression="0"
dw_Insp.Sort( )
end event

type st_1 from statictext within w_inspectorcleanup
integer x = 73
integer y = 80
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Order By:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_inspectorcleanup
integer x = 37
integer width = 1408
integer height = 1968
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

