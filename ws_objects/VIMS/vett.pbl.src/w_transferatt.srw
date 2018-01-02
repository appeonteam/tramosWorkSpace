$PBExportHeader$w_transferatt.srw
forward
global type w_transferatt from window
end type
type rb_obj from radiobutton within w_transferatt
end type
type rb_comp from radiobutton within w_transferatt
end type
type rb_att from radiobutton within w_transferatt
end type
type st_msg from statictext within w_transferatt
end type
type st_fail from statictext within w_transferatt
end type
type st_1 from statictext within w_transferatt
end type
type hpb_prg from hprogressbar within w_transferatt
end type
type dw_target from datawindow within w_transferatt
end type
type dw_source from datawindow within w_transferatt
end type
type cb_move from commandbutton within w_transferatt
end type
type gb_1 from groupbox within w_transferatt
end type
type gb_2 from groupbox within w_transferatt
end type
end forward

global type w_transferatt from window
integer width = 2656
integer height = 2020
boolean titlebar = true
string title = "Transfer Attachments"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
rb_obj rb_obj
rb_comp rb_comp
rb_att rb_att
st_msg st_msg
st_fail st_fail
st_1 st_1
hpb_prg hpb_prg
dw_target dw_target
dw_source dw_source
cb_move cb_move
gb_1 gb_1
gb_2 gb_2
end type
global w_transferatt w_transferatt

type variables

n_VimsAtt in_Source, in_Target

Boolean ibool_Stop = False

String is_Table = "VETT_ATT"
end variables

on w_transferatt.create
this.rb_obj=create rb_obj
this.rb_comp=create rb_comp
this.rb_att=create rb_att
this.st_msg=create st_msg
this.st_fail=create st_fail
this.st_1=create st_1
this.hpb_prg=create hpb_prg
this.dw_target=create dw_target
this.dw_source=create dw_source
this.cb_move=create cb_move
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.rb_obj,&
this.rb_comp,&
this.rb_att,&
this.st_msg,&
this.st_fail,&
this.st_1,&
this.hpb_prg,&
this.dw_target,&
this.dw_source,&
this.cb_move,&
this.gb_1,&
this.gb_2}
end on

on w_transferatt.destroy
destroy(this.rb_obj)
destroy(this.rb_comp)
destroy(this.rb_att)
destroy(this.st_msg)
destroy(this.st_fail)
destroy(this.st_1)
destroy(this.hpb_prg)
destroy(this.dw_target)
destroy(this.dw_source)
destroy(this.cb_move)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;

in_Source = Create n_VimsAtt
in_Target = Create n_VimsAtt

If in_Source.of_Connect("") < 0 then cb_Move.Enabled = False
If in_Target.of_Connect("") < 0 then cb_Move.Enabled = False

dw_Source.SetTransObject(SQLCA)
dw_Target.SetTransObject(in_Target.itr_FileDB)

dw_Source.Retrieve( )
dw_Target.Retrieve( )
end event

event close;
Destroy in_Source
Destroy in_Target
end event

type rb_obj from radiobutton within w_transferatt
integer x = 1115
integer y = 368
integer width = 411
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VETT_OBJ"
end type

event clicked;
dw_Source.SetSQLSelect("SELECT OBJ_ID as ATT_ID, DataLength(ATT) as FILESIZE FROM VETT_OBJ Where DataLength(ATT) > 0 Order By OBJ_ID")

dw_Source.Retrieve()

dw_Target.Reset()

is_Table = "VETT_OBJ"
end event

type rb_comp from radiobutton within w_transferatt
integer x = 1115
integer y = 272
integer width = 411
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VETT_COMP"
end type

event clicked;
dw_Source.SetSQLSelect("SELECT COMP_ID as ATT_ID, DataLength(ATTACH) as FILESIZE FROM VETT_COMP Where DataLength(ATTACH) > 0 Order By COMP_ID")

dw_Source.Retrieve()

dw_Target.Reset()

is_Table = "VETT_COMP"
end event

type rb_att from radiobutton within w_transferatt
integer x = 1115
integer y = 176
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VETT_ATT"
boolean checked = true
end type

event clicked;
dw_Source.SetSQLSelect("SELECT VETT_ATT.ATT_ID as ATT_ID, VETT_ATT.FILESIZE as FILESIZE FROM VETT_ATT Order By ATT_ID")

dw_Source.Retrieve()

dw_Target.Reset()

is_Table = "VETT_ATT"
end event

type st_msg from statictext within w_transferatt
integer x = 896
integer y = 1776
integer width = 823
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type st_fail from statictext within w_transferatt
integer x = 1189
integer y = 1152
integer width = 238
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "0"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_transferatt
integer x = 1189
integer y = 1088
integer width = 238
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Failed"
alignment alignment = center!
boolean focusrectangle = false
end type

type hpb_prg from hprogressbar within w_transferatt
integer x = 18
integer y = 1856
integer width = 2597
integer height = 64
unsignedinteger maxposition = 100
integer setstep = 1
end type

type dw_target from datawindow within w_transferatt
integer x = 1774
integer y = 80
integer width = 805
integer height = 1728
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_att_transfer"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_source from datawindow within w_transferatt
integer x = 55
integer y = 80
integer width = 786
integer height = 1728
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_att_transfer"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_move from commandbutton within w_transferatt
integer x = 1024
integer y = 912
integer width = 567
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = ">>>"
end type

event clicked;
If This.Text = "Stop" then 
	ibool_Stop = True
	Return
End If

If Messagebox("Confirm Transfer", "Start Transfer of attachments?", Question!, YesNo!) = 2 then Return

Long ll_Count, ll_AttID, ll_FileSize, ll_Fail = 0
Blob lblob_Data

This.Text = "Stop"

hpb_prg.MaxPosition = dw_Source.RowCount()
hpb_prg.Position = 0

//dw_Target.Reset()

For ll_Count = 1 to dw_Source.RowCount()
	ll_AttID = dw_Source.GetItemNumber(ll_Count, "Att_ID")
	ll_FileSize = dw_Source.GetItemNumber(ll_Count, "FileSize")
	st_Msg.Text = "Reading..."
	If dw_Target.Find("Att_ID = " + String(ll_AttID), 0, dw_Target.RowCount()+1) = 0 then
		If	in_Source.of_GetAtt(is_Table, ll_AttID, lblob_Data) = 1 then // Read att
			st_Msg.Text = "Writing..."
			If in_Target.of_AddAtt(is_Table, ll_AttID, lblob_Data, ll_FileSize) = 0 then  // Write att
				If dw_Target.Find("Att_ID = " + String(ll_AttID), 0, dw_Target.RowCount()+1) = 0 then
					dw_Target.InsertRow(0)
					dw_Target.SetItem(dw_Target.RowCount(), "Att_ID", ll_AttID)
					dw_Target.SetItem(dw_Target.RowCount(), "FileSize", ll_FileSize)
					dw_Target.ScrollToRow(dw_Target.RowCount())
				End If
			Else
				ll_Fail ++
			End If
		Else
			ll_Fail ++
		End If
	End If
	If mod(ll_Count, 500) = 0 then 
		st_Msg.Text = "Dumping Log..."
		in_Target.of_DumpTrans()
	End If
	Yield()
	st_Fail.Text=String(ll_Fail)
	If ibool_Stop then Exit
	hpb_prg.StepIt()
Next

This.Text = ">>>"
st_Msg.Text = ""
end event

type gb_1 from groupbox within w_transferatt
integer x = 18
integer width = 859
integer height = 1840
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tramos Database"
end type

type gb_2 from groupbox within w_transferatt
integer x = 1737
integer width = 878
integer height = 1840
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Files Database"
end type

