$PBExportHeader$w_planbak.srw
forward
global type w_planbak from window
end type
type ddlb_type from dropdownlistbox within w_planbak
end type
type st_type from statictext within w_planbak
end type
type ddlb_flag from dropdownlistbox within w_planbak
end type
type st_flag from statictext within w_planbak
end type
type st_resp from statictext within w_planbak
end type
type ddlb_users from dropdownlistbox within w_planbak
end type
type cb_print from commandbutton within w_planbak
end type
type cb_stat from commandbutton within w_planbak
end type
type cb_close from commandbutton within w_planbak
end type
type dw_plan from datawindow within w_planbak
end type
end forward

global type w_planbak from window
integer width = 4389
integer height = 2392
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
windowstate windowstate = maximized!
long backcolor = 16777215
string icon = "C:\Vetting DB\Graphics\Status.ico"
boolean center = true
ddlb_type ddlb_type
st_type st_type
ddlb_flag ddlb_flag
st_flag st_flag
st_resp st_resp
ddlb_users ddlb_users
cb_print cb_print
cb_stat cb_stat
cb_close cb_close
dw_plan dw_plan
end type
global w_planbak w_planbak

type variables

//w_Calender iw_WinCal

String is_Sort

// is_Sort stored the DW sort column so it can be applied to the print DW also

String ls_Resp, ls_Flag, ls_Type
end variables

forward prototypes
public subroutine wf_applyfilter ()
end prototypes

public subroutine wf_applyfilter ();
dw_plan.SetFilter(ls_Resp + " And " + ls_Flag + " And " + ls_Type)

dw_plan.Filter()

If dw_plan.RowCount( ) = 0 then 
//	cb_edit.Enabled = False
//	cb_cal.Enabled = False
//	cb_poc.Enabled = False
//	cb_find.Enabled = False
Else
//	cb_cal.Enabled = True
//	cb_poc.Enabled = True
//	cb_find.Enabled = True	
//	If (g_obj.Access > 1) and (g_Obj.deptid = 1) then cb_edit.Enabled = True
	dw_Plan.SelectRow(0, False)
	dw_Plan.SelectRow(dw_Plan.GetRow(), True)
End If

end subroutine

event open;Datastore lds_gen
Integer li_Loop, li_Count, li_Wid, li_Hgt
String ls_Temp

lds_gen= Create DataStore

// Populate vessel types
lds_gen.DataObject = "d_sq_tb_vetttype"
lds_gen.SetTransobject(SQLCA)
li_Count = lds_gen.Retrieve( )
For li_Loop = 1 to li_Count
	ddlb_type.AddItem(lds_gen.GetItemString(li_Loop, "type_name"))
Next
ddlb_type.SelectItem(1)

// Populate flags
lds_gen.DataObject = "d_sq_tb_rep_flag"
lds_gen.SetTransobject(SQLCA)
li_Count = lds_gen.Retrieve( )
For li_Loop = 1 to li_Count
	ddlb_flag.AddItem(lds_gen.GetItemString(li_Loop, "code"))	
Next
ddlb_flag.SelectItem(1)

// Get users
lds_gen.DataObject = "d_sq_tb_vettusers"
lds_gen.SetTransobject(SQLCA)
li_Count = lds_gen.Retrieve( )
For li_Loop = 1 to li_Count
	ddlb_users.AddItem(lds_gen.GetItemString(li_Loop, "userid"))
Next
ddlb_users.SelectItem(1)

dw_plan.SetTransobject( SQLCA)
dw_plan.Retrieve( )

is_Sort = "#3 A"
ls_Resp = "(Resp > '')"
ls_Flag = "(Flag > '')"
ls_Type = "(Type_Name > '')"

//If (g_obj.Access > 1) and (g_obj.Deptid = 1) then cb_edit.Enabled = True

//If g_obj.Deptid > 1 then 
//	ddlb_users.Visible = False
//	st_resp.Visible = False
//End If
//
Destroy lds_gen

// Get last window height and width
//f_Registry("w_plan_w", ls_Temp, False)
//li_Wid = Integer(ls_Temp)
//f_Registry("w_plan_h", ls_Temp, False)
//li_Hgt = Integer(ls_Temp)
//
//If (li_wid > 500) and (li_Hgt > 500) then
//	If li_Wid > This.Parentwindow( ).WorkspaceWidth( ) then li_Wid = This.Parentwindow( ).WorkspaceWidth( )
//	If li_Hgt > This.Parentwindow( ).WorkspaceHeight( ) then li_Hgt = This.Parentwindow( ).WorkspaceHeight( )
//	This.Width = li_Wid
//	This.Height = li_Hgt
//	This.X = (this.parentwindow( ).workspaceWidth( ) - li_Wid) / 2
//	This.Y = (this.parentwindow( ).workspaceHeight( ) - li_Hgt) / 2
//End If
end event

on w_planbak.create
this.ddlb_type=create ddlb_type
this.st_type=create st_type
this.ddlb_flag=create ddlb_flag
this.st_flag=create st_flag
this.st_resp=create st_resp
this.ddlb_users=create ddlb_users
this.cb_print=create cb_print
this.cb_stat=create cb_stat
this.cb_close=create cb_close
this.dw_plan=create dw_plan
this.Control[]={this.ddlb_type,&
this.st_type,&
this.ddlb_flag,&
this.st_flag,&
this.st_resp,&
this.ddlb_users,&
this.cb_print,&
this.cb_stat,&
this.cb_close,&
this.dw_plan}
end on

on w_planbak.destroy
destroy(this.ddlb_type)
destroy(this.st_type)
destroy(this.ddlb_flag)
destroy(this.st_flag)
destroy(this.st_resp)
destroy(this.ddlb_users)
destroy(this.cb_print)
destroy(this.cb_stat)
destroy(this.cb_close)
destroy(this.dw_plan)
end on

event resize;integer li_x

dw_plan.width = newwidth - dw_plan.x * 2

li_x = newheight - dw_plan.x * 3 - cb_close.Height
if li_x < 400 then li_x = 400

dw_plan.Height = li_x

cb_stat.y = dw_plan.x + li_x + dw_plan.x
cb_close.y = cb_stat.y
//cb_stat.y = cb_edit.y
cb_print.y = cb_stat.y
//cb_Cal.y = cb_Edit.y
//cb_Poc.y = cb_stat.y
//cb_Find.y = cb_Edit.y
st_Resp.y = cb_stat.y + 24
st_flag.y = st_Resp.y
st_type.y = st_Resp.y
ddlb_users.y = cb_stat.y + 8
ddlb_flag.y = ddlb_users.y
ddlb_type.y = ddlb_users.y

li_x = newwidth - cb_close.Width - dw_plan.x
If li_x < ddlb_type.x + ddlb_type.width then li_x = ddlb_type.x + ddlb_type.Width
cb_close.x = li_x

end event

event close;String ls_Temp


end event

type ddlb_type from dropdownlistbox within w_planbak
integer x = 1902
integer y = 1424
integer width = 567
integer height = 448
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"< All >"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
If Index > 1 then ls_type = "(type_name = '" + This.Text(index) + "')" Else ls_type = "(type_name > '')"
	
wf_ApplyFilter()

end event

type st_type from statictext within w_planbak
integer x = 1737
integer y = 1440
integer width = 146
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Type:"
boolean focusrectangle = false
end type

type ddlb_flag from dropdownlistbox within w_planbak
integer x = 1390
integer y = 1424
integer width = 256
integer height = 448
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"< All >"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
If Index > 1 then ls_flag = "(flag = '" + This.Text(index) + "')" Else ls_flag = "(flag > '')"
	
wf_ApplyFilter()

end event

type st_flag from statictext within w_planbak
integer x = 1243
integer y = 1440
integer width = 146
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Flag:"
boolean focusrectangle = false
end type

type st_resp from statictext within w_planbak
integer x = 768
integer y = 1440
integer width = 146
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Resp:"
boolean focusrectangle = false
end type

type ddlb_users from dropdownlistbox within w_planbak
integer x = 914
integer y = 1424
integer width = 256
integer height = 448
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"< All >"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
If Index > 1 then ls_Resp = "(resp = '" + This.Text + "')" else ls_Resp = "(resp > '')"
	
wf_ApplyFilter()
	


end event

type cb_print from commandbutton within w_planbak
integer x = 329
integer y = 1424
integer width = 311
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print"
end type

event clicked;
SetPointer(HourGlass!)

//OpenSheet(w_preview, w_main, 0, Original!)
//
//w_preview.dw_rep.dataobject = "d_sq_tb_planprint"
//w_preview.dw_rep.SetTransObject(SQLCA)
//w_preview.dw_rep.Modify("DataWindow.Print.Preview = True")
//
//w_preview.dw_rep.SetFilter(ls_Resp + " And " + ls_Flag + " And " + ls_Type)
//w_preview.dw_rep.Filter()
//
//w_preview.dw_rep.SetSort(is_Sort)
//w_preview.dw_rep.Sort()
//
//w_preview.dw_rep.Retrieve()    // Retrieve Master
//
//w_preview.wf_ShowReport()

end event

type cb_stat from commandbutton within w_planbak
integer x = 18
integer y = 1424
integer width = 311
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Due ?"
end type

event clicked;
Open(w_planhelp)
end event

type cb_close from commandbutton within w_planbak
integer x = 1079
integer y = 1600
integer width = 402
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

type dw_plan from datawindow within w_planbak
event ue_mousemove pbm_dwnmousemove
integer x = 18
integer y = 16
integer width = 2542
integer height = 1408
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_plan"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
This.SelectRow( 0, False)
This.SelectRow( This.GetRow(), True)
end event

event clicked;
If (dwo.type = "text") then
	If (Left(dwo.tag, 1) <> "#") then Return
	is_sort = dwo.Tag
	if right(is_sort,1) = "A" then 
		is_sort = replace(is_sort, len(is_sort),1, "D")
	else
		is_sort = replace(is_sort, len(is_sort),1, "A")
	end if
	dwo.Tag = is_sort
	this.SetSort(is_sort)
	this.Sort()	
	This.SelectRow(0, False)
	This.SelectRow(This.GetRow(), True)
end if

end event

