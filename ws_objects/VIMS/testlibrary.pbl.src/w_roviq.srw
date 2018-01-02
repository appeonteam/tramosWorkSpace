$PBExportHeader$w_roviq.srw
forward
global type w_roviq from window
end type
type cb_update from commandbutton within w_roviq
end type
type cb_2 from commandbutton within w_roviq
end type
type cb_trans from commandbutton within w_roviq
end type
type dw_roviq from datawindow within w_roviq
end type
type cb_imp from commandbutton within w_roviq
end type
type dw_imp from datawindow within w_roviq
end type
end forward

global type w_roviq from window
integer width = 3461
integer height = 2236
boolean titlebar = true
string title = "ROVIQ Import"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_update cb_update
cb_2 cb_2
cb_trans cb_trans
dw_roviq dw_roviq
cb_imp cb_imp
dw_imp dw_imp
end type
global w_roviq w_roviq

on w_roviq.create
this.cb_update=create cb_update
this.cb_2=create cb_2
this.cb_trans=create cb_trans
this.dw_roviq=create dw_roviq
this.cb_imp=create cb_imp
this.dw_imp=create dw_imp
this.Control[]={this.cb_update,&
this.cb_2,&
this.cb_trans,&
this.dw_roviq,&
this.cb_imp,&
this.dw_imp}
end on

on w_roviq.destroy
destroy(this.cb_update)
destroy(this.cb_2)
destroy(this.cb_trans)
destroy(this.dw_roviq)
destroy(this.cb_imp)
destroy(this.dw_imp)
end on

event open;
SQLCA.Database = "TG_TRAMOS_PRIMARY_CPH"
SQLCA.DBMS = "SYC Adaptive Server Enterprise"
SQLCA.Userid = "sa"
SQLCA.LogID = "sa"
SQLCA.LogPass = "TramOS_04"
SQLCA.dbpass	= "TramOS_04"
SQLCA.ServerName = "SCRBTRADKESP001"
SQLCA.DBParm = "Release='12.5'"
SQLCA.Lock	= ""
SQLCA.AutoCommit = false

Connect using SQLCA;


If SQLCA.SQLCode <> 0 then Messagebox("SQL", SQLca.SQLCode)
end event

event close;
disconnect using SQLCA;
end event

type cb_update from commandbutton within w_roviq
integer x = 3017
integer y = 1920
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update"
end type

event clicked;
Messagebox("Update", dw_roviq.update( ))
end event

type cb_2 from commandbutton within w_roviq
integer x = 1499
integer y = 1920
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;


dw_roviq.SetTransObject(SQLCA)

dw_roviq.Retrieve(24)
end event

type cb_trans from commandbutton within w_roviq
integer x = 1243
integer y = 832
integer width = 219
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = ">>>"
end type

event clicked;
Integer li_Imp, li_Exp

li_Imp = 1
li_Exp = 1

Do
	If dw_Imp.GetItemNumber(li_Imp, "Chap") = dw_roviq.GetItemNumber(li_Exp, "Chap") then
		If dw_Imp.GetItemNumber(li_Imp, "Ques") = dw_roviq.GetItemNumber(li_Exp, "Ques") then
			If (dw_Imp.GetItemNumber(li_Imp, "Sub") = dw_roviq.GetItemNumber(li_Exp, "Sub")) or (IsNull(dw_Imp.GetItemNumber(li_Imp, "Sub")) and (dw_roviq.GetItemNumber(li_Exp, "Sub") = -1)) then
				dw_roviq.SetItem(li_Exp, "Serial", dw_imp.GetItemNumber(li_Imp, "Serial"))
				li_Imp ++
				li_Exp ++
			Else
				li_Exp ++
			End If
		Else
			li_Exp ++
		End If
	Else
		li_Exp ++
	End If
	
Loop Until (li_Exp > dw_roviq.RowCount( )) or (li_Imp > dw_Imp.RowCount())
end event

type dw_roviq from datawindow within w_roviq
integer x = 1499
integer y = 112
integer width = 1920
integer height = 1808
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_roviq_import"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_imp from commandbutton within w_roviq
integer x = 91
integer y = 1936
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Import"
end type

event clicked;
dw_imp.Importfile(CSV!, "")

dw_imp.Sort()

end event

type dw_imp from datawindow within w_roviq
integer x = 73
integer y = 112
integer width = 1134
integer height = 1808
integer taborder = 10
string title = "none"
string dataobject = "d_ext_roviq_in"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

