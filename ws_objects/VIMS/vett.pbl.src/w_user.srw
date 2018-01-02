$PBExportHeader$w_user.srw
forward
global type w_user from window
end type
type sle_search from singlelineedit within w_user
end type
type st_6 from statictext within w_user
end type
type cbx_mngnotify from checkbox within w_user
end type
type st_5 from statictext within w_user
end type
type dw_mng from datawindow within w_user
end type
type st_name from statictext within w_user
end type
type st_userid from statictext within w_user
end type
type dw_dept from datawindow within w_user
end type
type st_4 from statictext within w_user
end type
type ddlb_access from dropdownlistbox within w_user
end type
type st_3 from statictext within w_user
end type
type cb_save from commandbutton within w_user
end type
type cb_cancel from commandbutton within w_user
end type
type st_2 from statictext within w_user
end type
type st_1 from statictext within w_user
end type
type gb_1 from groupbox within w_user
end type
end forward

global type w_user from window
integer width = 1829
integer height = 1716
boolean titlebar = true
string title = "Edit User"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_search sle_search
st_6 st_6
cbx_mngnotify cbx_mngnotify
st_5 st_5
dw_mng dw_mng
st_name st_name
st_userid st_userid
dw_dept dw_dept
st_4 st_4
ddlb_access ddlb_access
st_3 st_3
cb_save cb_save
cb_cancel cb_cancel
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_user w_user

type variables


Integer ii_Access
end variables

forward prototypes
public subroutine wf_searchuser ()
end prototypes

public subroutine wf_searchuser ();Integer li_Found
String ls_Text

ls_Text = Lower(Trim(sle_Search.Text))

li_Found = dw_Mng.Find("(Lower(Fullname) like '%" + ls_Text + "%') Or (Lower(UserID) like '%" + ls_Text + "%')", 1, dw_Mng.RowCount())

If li_Found > 0 then
	dw_Mng.SetRow(li_Found)
	dw_Mng.ScrollToRow(li_Found)
	dw_Mng.SetRedraw(True)
End If

end subroutine

on w_user.create
this.sle_search=create sle_search
this.st_6=create st_6
this.cbx_mngnotify=create cbx_mngnotify
this.st_5=create st_5
this.dw_mng=create dw_mng
this.st_name=create st_name
this.st_userid=create st_userid
this.dw_dept=create dw_dept
this.st_4=create st_4
this.ddlb_access=create ddlb_access
this.st_3=create st_3
this.cb_save=create cb_save
this.cb_cancel=create cb_cancel
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.sle_search,&
this.st_6,&
this.cbx_mngnotify,&
this.st_5,&
this.dw_mng,&
this.st_name,&
this.st_userid,&
this.dw_dept,&
this.st_4,&
this.ddlb_access,&
this.st_3,&
this.cb_save,&
this.cb_cancel,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_user.destroy
destroy(this.sle_search)
destroy(this.st_6)
destroy(this.cbx_mngnotify)
destroy(this.st_5)
destroy(this.dw_mng)
destroy(this.st_name)
destroy(this.st_userid)
destroy(this.dw_dept)
destroy(this.st_4)
destroy(this.ddlb_access)
destroy(this.st_3)
destroy(this.cb_save)
destroy(this.cb_cancel)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;
st_UserID.Text = Message.StringParm

String ls_Name, ls_Manager
Integer li_Access, li_Dept, li_MngNotify

Select FIRST_NAME + ' ' + LAST_NAME, VETT_ACCESS, VETT_DEPT, VETT_MANAGER, VETT_MNG_NOTIFY
Into :ls_Name, :li_Access, :li_Dept, :ls_Manager, :li_MngNotify
From USERS Where USERID = :st_UserID.Text;

If SQLCA.SQLCode <> 0 then 
	Messagebox("DB Error", "A database error occurred!~n~nError: " + SQLCA.SQLErrText)
	cb_Save.Enabled = False
	ddlb_access.Enabled = False
End If

Commit;

st_Name.Text = ls_Name
ii_Access = li_Access + 1
ddlb_Access.SelectItem(ii_Access)
If li_MngNotify = 1 then cbx_MngNotify.Checked = True

dw_Dept.SetTransObject( SQLCA)
dw_Mng.SetTransObject(SQLCA)
dw_Dept.Retrieve()
dw_Mng.Retrieve()

If IsNull(li_Dept) then dw_Dept.SetRow(1) Else dw_Dept.SetRow(dw_Dept.Find("Dept_ID=" + String(li_Dept), 1, dw_Dept.RowCount()))
dw_Dept.ScrollToRow(dw_Dept.GetRow())

If IsNull(ls_Manager) then dw_Mng.SetRow(1) Else dw_Mng.SetRow(dw_Mng.Find("UserID='" + String(ls_Manager) + "'", 1, dw_Mng.RowCount()))
dw_Mng.ScrollToRow(dw_Mng.GetRow())

If st_UserID.Text = g_Obj.UserID then ddlb_Access.Enabled = False
end event

type sle_search from singlelineedit within w_user
event ue_key pbm_keyup
integer x = 1463
integer y = 656
integer width = 238
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_key;

Post wf_SearchUser()
end event

type st_6 from statictext within w_user
integer x = 91
integer y = 464
integer width = 402
integer height = 144
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Management: Notification"
boolean focusrectangle = false
end type

type cbx_mngnotify from checkbox within w_user
integer x = 603
integer y = 448
integer width = 183
integer height = 112
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type st_5 from statictext within w_user
integer x = 969
integer y = 656
integer width = 530
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Direct Manager:"
boolean focusrectangle = false
end type

type dw_mng from datawindow within w_user
integer x = 969
integer y = 736
integer width = 731
integer height = 656
integer taborder = 40
string dataobject = "d_sq_tb_usersel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;

This.InsertRow(1)

This.SetItem(1, "fullname", "< No Manager >")
This.SetItem(1, "userid", "")
end event

event clicked;
sle_Search.Text = ""
end event

type st_name from statictext within w_user
integer x = 603
integer y = 208
integer width = 1152
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_userid from statictext within w_user
integer x = 603
integer y = 80
integer width = 530
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_dept from datawindow within w_user
integer x = 91
integer y = 736
integer width = 731
integer height = 656
integer taborder = 30
string dataobject = "d_sq_tb_deptsel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
This.InsertRow(1)

This.SetItem(1, "deptname", "< No Department >")
This.SetItem(1, "dept_id", 0)
end event

type st_4 from statictext within w_user
integer x = 91
integer y = 656
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
string text = "Department:"
boolean focusrectangle = false
end type

type ddlb_access from dropdownlistbox within w_user
integer x = 603
integer y = 320
integer width = 1097
integer height = 576
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"No Access","Read-Only Access","Read/Write Access","Super User"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_Access = index
end event

type st_3 from statictext within w_user
integer x = 91
integer y = 336
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
string text = "VIMS Access:"
boolean focusrectangle = false
end type

type cb_save from commandbutton within w_user
integer x = 311
integer y = 1488
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;
If ii_Access > 2 and dw_Dept.GetRow() = 1 then
	MessageBox("Validation Error", "Users with write access must belong to a department.", Exclamation!)
	Return
End If

String ls_Mng
Integer li_Dept, li_MngNotify = 0, li_Access

li_Access = ii_Access - 1
If dw_Mng.GetRow() = 1 then SetNull(ls_Mng) Else ls_Mng = dw_Mng.GetItemString(dw_Mng.GetRow(), "UserID")
If dw_Dept.GetRow() = 1 then SetNull(li_Dept) Else li_Dept = dw_Dept.GetItemNumber(dw_Dept.GetRow(), "Dept_ID")

If cbx_MngNotify.Checked then li_MngNotify = 1

Update USERS Set VETT_MANAGER = :ls_Mng, VETT_ACCESS = :li_Access, VETT_DEPT = :li_Dept, VETT_MNG_NOTIFY = :li_MngNotify
Where USERID=:st_UserID.Text ;

If SQLCA.SQLCode<>0 Then
	Messagebox("DB Error", "An error occurred while saving the user.~n~nError: " + SQLCA.SQLErrText, Exclamation!)
	Rollback;
	Return
End If

Commit;	

CloseWithReturn(Parent, 1)
end event

type cb_cancel from commandbutton within w_user
integer x = 1097
integer y = 1488
integer width = 402
integer height = 112
integer taborder = 20
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
CloseWithReturn(Parent, 0)
end event

type st_2 from statictext within w_user
integer x = 91
integer y = 208
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
string text = "User Name:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_user
integer x = 91
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
string text = "User ID:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_user
integer x = 37
integer width = 1737
integer height = 1456
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

