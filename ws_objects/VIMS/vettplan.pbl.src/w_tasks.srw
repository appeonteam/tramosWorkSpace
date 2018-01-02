$PBExportHeader$w_tasks.srw
forward
global type w_tasks from window
end type
type cb_pw from commandbutton within w_tasks
end type
type cb_pending from commandbutton within w_tasks
end type
type ddlb_year from dropdownlistbox within w_tasks
end type
type dw_usage from datawindow within w_tasks
end type
type em_year from editmask within w_tasks
end type
type cb_usage from commandbutton within w_tasks
end type
type cb_reassign from commandbutton within w_tasks
end type
type cb_calender from commandbutton within w_tasks
end type
type cb_close from commandbutton within w_tasks
end type
type cb_del from commandbutton within w_tasks
end type
type cb_edit from commandbutton within w_tasks
end type
type cb_new from commandbutton within w_tasks
end type
type cbx_nontask from checkbox within w_tasks
end type
type cbx_comp from checkbox within w_tasks
end type
type dw_tasks from datawindow within w_tasks
end type
type st_name from statictext within w_tasks
end type
type cb_seluser from commandbutton within w_tasks
end type
type st_1 from statictext within w_tasks
end type
type gb_1 from groupbox within w_tasks
end type
type gb_2 from groupbox within w_tasks
end type
end forward

global type w_tasks from window
integer width = 4425
integer height = 2308
boolean titlebar = true
string title = "Task Scheduler"
boolean controlmenu = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Cal.ico"
boolean center = true
cb_pw cb_pw
cb_pending cb_pending
ddlb_year ddlb_year
dw_usage dw_usage
em_year em_year
cb_usage cb_usage
cb_reassign cb_reassign
cb_calender cb_calender
cb_close cb_close
cb_del cb_del
cb_edit cb_edit
cb_new cb_new
cbx_nontask cbx_nontask
cbx_comp cbx_comp
dw_tasks dw_tasks
st_name st_name
cb_seluser cb_seluser
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_tasks w_tasks

type variables

String is_UserID
w_Calender iw_WinCal
end variables

forward prototypes
public subroutine wf_setfilter ()
public subroutine wf_updatecalender ()
end prototypes

public subroutine wf_setfilter ();String ls_Filter

If cbx_comp.Checked then ls_Filter = "(Status<3)"

If cbx_nontask.Checked then 
	If ls_Filter > "" then ls_Filter += " and "
	ls_Filter += "(IsTask=1)"
End If

dw_Tasks.SetFilter(ls_Filter)

dw_Tasks.Filter()

dw_Tasks.SetSort("#2 A")
dw_Tasks.Sort( )

If dw_Tasks.rowcount() = 0 then
	cb_edit.Enabled = False
	cb_reassign.Enabled = False
	cb_del.Enabled = False
Else
	If ((g_obj.deptid = 1) or (is_userid=g_Obj.UserID)) and (g_obj.access > 1) then
		cb_edit.Enabled = True
		If g_obj.deptid = 1 then cb_reassign.Enabled = True else cb_reassign.Enabled = False
		cb_del.Enabled = True
	Else
		cb_edit.Enabled = False
		cb_reassign.Enabled = False
		cb_del.Enabled = False		
	End If	
	dw_Tasks.SetRow(dw_Tasks.RowCount())
	dw_Tasks.ScrollToRow(dw_Tasks.RowCount())
End If
end subroutine

public subroutine wf_updatecalender ();
If IsValid(iw_WinCal) then   // Check if calender is open. If so, close and reopen to refresh
	cb_calender.event clicked( )
	This.setfocus( ) 
End If
end subroutine

on w_tasks.create
this.cb_pw=create cb_pw
this.cb_pending=create cb_pending
this.ddlb_year=create ddlb_year
this.dw_usage=create dw_usage
this.em_year=create em_year
this.cb_usage=create cb_usage
this.cb_reassign=create cb_reassign
this.cb_calender=create cb_calender
this.cb_close=create cb_close
this.cb_del=create cb_del
this.cb_edit=create cb_edit
this.cb_new=create cb_new
this.cbx_nontask=create cbx_nontask
this.cbx_comp=create cbx_comp
this.dw_tasks=create dw_tasks
this.st_name=create st_name
this.cb_seluser=create cb_seluser
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_pw,&
this.cb_pending,&
this.ddlb_year,&
this.dw_usage,&
this.em_year,&
this.cb_usage,&
this.cb_reassign,&
this.cb_calender,&
this.cb_close,&
this.cb_del,&
this.cb_edit,&
this.cb_new,&
this.cbx_nontask,&
this.cbx_comp,&
this.dw_tasks,&
this.st_name,&
this.cb_seluser,&
this.st_1,&
this.gb_1,&
this.gb_2}
end on

on w_tasks.destroy
destroy(this.cb_pw)
destroy(this.cb_pending)
destroy(this.ddlb_year)
destroy(this.dw_usage)
destroy(this.em_year)
destroy(this.cb_usage)
destroy(this.cb_reassign)
destroy(this.cb_calender)
destroy(this.cb_close)
destroy(this.cb_del)
destroy(this.cb_edit)
destroy(this.cb_new)
destroy(this.cbx_nontask)
destroy(this.cbx_comp)
destroy(this.dw_tasks)
destroy(this.st_name)
destroy(this.cb_seluser)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;Integer li_Year, li_Count

is_UserID = g_Obj.UserID

st_Name.Text = g_Obj.UserID + " - " + gs_fullname

em_Year.Text = String(Year(Today()))

If g_obj.Access < 2 then cb_New.Enabled = False

dw_tasks.SetTransobject(SQLCA)
dw_tasks.Retrieve(is_UserID)

dw_usage.SetTransObject(SQLCA)

li_Year = Year(Today()) - 4

For li_Count = li_Year to li_Year + 4
	ddlb_year.Additem(String(li_Count))
Next

ddlb_year.SelectItem(5)
ddlb_year.event SelectionChanged(5)

If (g_obj.Deptid > 1) and (g_Obj.Access < 3) then Return

// Check for overdue tasks
Post OpenwithParm(w_TaskNotify, "Auto")

end event

event close;
If IsValid(iw_WinCal) then Close(iw_WinCal)
end event

type cb_pw from commandbutton within w_tasks
integer x = 3310
integer y = 32
integer width = 549
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "VIMS Mobile Password"
end type

event clicked;
g_obj.ObjParent = is_userid

Open(w_mobilepassword)
end event

type cb_pending from commandbutton within w_tasks
integer x = 3858
integer y = 32
integer width = 530
integer height = 80
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show All Pending..."
end type

event clicked;
Open(w_tasknotify)

end event

type ddlb_year from dropdownlistbox within w_tasks
integer x = 2944
integer y = 1712
integer width = 311
integer height = 400
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
dw_usage.Retrieve(Integer(This.Text), is_UserID )
end event

type dw_usage from datawindow within w_tasks
integer x = 55
integer y = 1808
integer width = 3200
integer height = 368
integer taborder = 130
string title = "none"
string dataobject = "d_sq_tb_indusage"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;
If dwo.name = "b_cmm" then
	Messagebox("Offset Days", "Offset Days: " + String(GetItemNumber(row, "offsetdays")) + "~n~nComments: " + String(GetItemString(row, "comments")))
End If
end event

type em_year from editmask within w_tasks
integer x = 3749
integer y = 1792
integer width = 256
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "0000"
boolean spin = true
double increment = 1
string minmax = "2000~~2999"
end type

type cb_usage from commandbutton within w_tasks
integer x = 3602
integer y = 1888
integer width = 549
integer height = 112
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Utilization Report"
end type

event clicked;
SetPointer(HourGlass!)

OpenSheet(w_preview, w_main, 0, Original!)

w_preview.dw_rep.dataobject = "d_rep_usage"

w_preview.dw_rep.SetTransObject(SQLCA)

w_preview.dw_rep.Retrieve(Integer(em_Year.Text))

w_preview.dw_rep.Object.Footer.Text = g_Obj.Footer 

w_preview.wf_ShowReport()
end event

type cb_reassign from commandbutton within w_tasks
integer x = 1207
integer y = 1600
integer width = 384
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Re-Assign..."
end type

event clicked;Long ll_Task

If dw_Tasks.GetItemNumber(dw_Tasks.GetRow(), "Status") = 3 then 
	MessageBox("Task Completed", "A completed task cannot be re-assigned.", Exclamation!)
	Return
End If

ll_Task = dw_tasks.GetItemNumber(dw_Tasks.GetRow(), "Task_ID")

g_obj.objstring = is_userid

Open(w_userSelect)

If (g_Obj.Objstring > "") and (g_obj.ObjString<>is_userid) then
	
	If f_findtaskoverlap(g_obj.ObjString, dw_tasks.GetItemDateTime(dw_Tasks.GetRow(), "FromDate"), dw_tasks.GetItemDateTime(dw_Tasks.GetRow(), "ToDate"), ll_Task) > 0 then
		MessageBox("Task Overlap", "This task cannot be re-assigned to user " + g_Obj.ObjString + " as it overlaps with another task of the user.", Exclamation!)
		Return
	End If
	
	Update VETT_TASKS Set USERID = :g_obj.Objstring Where TASK_ID = :ll_Task;
	
	If SQLCA.SQLCode <> 0 then
		MessageBox("DB Error", "Could not re-assign user.~n~n" + SQLCA.SQLErrtext, Exclamation!)
		Rollback;
		Return
	Else
		Commit;
	End If
	dw_tasks.Retrieve(is_userid)
	wf_UpdateCalender()
	dw_usage.Retrieve(Integer(ddlb_Year.Text), is_UserID )
	Messagebox("Task Re-Assigned", "The selected task was assigned to user " + g_obj.objstring + ".")
End If
end event

type cb_calender from commandbutton within w_tasks
integer x = 3803
integer y = 1600
integer width = 549
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "View Calender"
end type

event clicked;Integer li_Tasks, li_Status, li_NewRow
Long ll_StatColor
Date ld_Start
DataStore lds_CalData
Blob lb_blob

lds_CalData = Create DataStore

lds_CalData.DataObject = "d_ext_tb_caldata"

For li_Tasks = 1 to dw_Tasks.RowCount()
	li_Status = dw_Tasks.GetItemNumber(li_Tasks, "Status")
	Choose Case li_Status
		Case 0 
			ll_StatColor = rgb(255, 255, 0)
		Case 1, 2
			 ll_StatColor = rgb(0, 255, 0)
		Case 3
			 ll_StatColor = rgb(128, 128, 128)
	End Choose

	If (DaysAfter(Date(dw_Tasks.GetItemDateTime(li_Tasks, "FromDate")), Today()) > 7) and (li_Status < 3) then ll_StatColor = 255
		
	li_NewRow = lds_CalData.InsertRow(0)	
	lds_CalData.SetItem(li_NewRow, "Taskname", dw_Tasks.GetItemString(li_Tasks, "Taskname"))
	lds_CalData.SetItem(li_NewRow, "Shortname", dw_Tasks.GetItemString(li_Tasks, "Shortname"))
	lds_CalData.SetItem(li_NewRow, "StatColor", ll_StatColor)
	ll_StatColor = dw_Tasks.GetItemNumber(li_Tasks, "Color")
	If ll_StatColor > 16777215 then ll_StatColor = 16777215
	lds_CalData.SetItem(li_NewRow, "Color", ll_StatColor)
	lds_CalData.SetItem(li_NewRow, "FromDate", Date(dw_Tasks.GetItemDateTime(li_Tasks, "FromDate")))
	lds_CalData.SetItem(li_NewRow, "ToDate", Date(dw_Tasks.GetItemDateTime(li_Tasks, "ToDate")))
	lds_CalData.SetItem(li_NewRow, "IsDue", 0)
	lds_CalData.SetItem(li_NewRow, "UserName", st_Name.Text)
	lds_CalData.SetItem(li_NewRow, "Vslname", dw_Tasks.GetItemString(li_Tasks, "Vessel_Name"))
	lds_CalData.SetItem(li_NewRow, "StatusVal", dw_Tasks.GetItemNumber(li_Tasks, "Status"))
Next

For li_Tasks = 1 to dw_Tasks.FilteredCount( )
	li_Status = dw_Tasks.GetItemNumber(li_Tasks, "Status", Filter!, True)
	Choose Case li_Status
		Case 0 
			ll_StatColor = rgb(255, 255, 0)
		Case 1, 2
			 ll_StatColor = rgb(0, 255, 0)
		Case 3
			 ll_StatColor = rgb(128, 128, 128)
	End Choose

	If (DaysAfter(Date(dw_Tasks.GetItemDateTime(li_Tasks, "FromDate", Filter!, True)), Today()) > 7) and (li_Status < 3) then ll_StatColor = 255
		
	li_NewRow = lds_CalData.InsertRow(0)	
	lds_CalData.SetItem(li_NewRow, "Taskname", dw_Tasks.GetItemString(li_Tasks, "Taskname", Filter!, False))
	lds_CalData.SetItem(li_NewRow, "Color", dw_Tasks.GetItemNumber(li_Tasks, "Color", Filter!, False))
	lds_CalData.SetItem(li_NewRow, "StatColor", ll_StatColor)
	lds_CalData.SetItem(li_NewRow, "FromDate", Date(dw_Tasks.GetItemDateTime(li_Tasks, "FromDate", Filter!, False)))
	lds_CalData.SetItem(li_NewRow, "ToDate", Date(dw_Tasks.GetItemDateTime(li_Tasks, "ToDate", Filter!, False)))
	lds_CalData.SetItem(li_NewRow, "IsDue", 0)
	lds_CalData.SetItem(li_NewRow, "UserName", st_Name.Text)
	lds_CalData.SetItem(li_NewRow, "Vslname", dw_Tasks.GetItemString(li_Tasks, "Vessel_Name", Filter!, False))	
	lds_CalData.SetItem(li_NewRow, "StatusVal", dw_Tasks.GetItemNumber(li_Tasks, "Status", Filter!, False))
Next

OpenSheet(iw_WinCal, w_Main, 0, Original!)

lds_CalData.GetFullState(lb_blob)

iw_WinCal.uo_Cal.of_SetSourceData(lb_blob)

ld_Start = Date(f_AddMonths(DateTime(Today()), -3))

iw_WinCal.uo_Cal.of_SetStartDate(Month(ld_Start), Year(ld_Start))

iw_WinCal.uo_Cal.of_SetTitle("Inspector", st_name.Text, "", "")

iw_WinCal.uo_Cal.of_DrawCalender()

end event

type cb_close from commandbutton within w_tasks
integer x = 3602
integer y = 2080
integer width = 549
integer height = 112
integer taborder = 120
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;

Close(Parent)

end event

type cb_del from commandbutton within w_tasks
integer x = 823
integer y = 1600
integer width = 384
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Delete"
end type

event clicked;Integer li_Status

g_obj.Objid = dw_tasks.GetItemNumber(dw_tasks.GetRow(), "Task_ID")

li_Status = dw_tasks.GetItemNumber(dw_Tasks.GetRow(), "Status")

If (li_Status = 3) and (g_obj.Deptid > 1) then
	MessageBox("Access Denied", "This task has been marked as completed. Only a VIMS superuser can delete this task.", Exclamation!)
	Return
End If

If MessageBox("Confirm Delete", "Are you sure you want to delete this task?", Question!, YesNo!) = 2 then Return

Delete from VETT_TASKS Where TASK_ID = :g_obj.Objid;

If SQLCA.SQLCode < 0 then 
	MessageBox("DB Error", "Could not delete the task.~n~n" + SQLCA.SQLErrtext)
	Rollback;
Else
	Commit;
	dw_tasks.Retrieve(is_userid)
	wf_UpdateCalender()
	dw_usage.Retrieve(Integer(ddlb_Year.Text), is_UserID )
End if


end event

type cb_edit from commandbutton within w_tasks
integer x = 439
integer y = 1600
integer width = 384
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Edit..."
end type

event clicked;Integer li_Task

g_Obj.Objid = dw_tasks.GetItemNumber( dw_tasks.GetRow(), "Task_ID")
g_Obj.SQL = dw_tasks.GetItemString( dw_tasks.GetRow(), "Vessel_Name")

g_obj.ObjString = "Edit"

Open(w_Taskedit)

If g_obj.Objid > 0 then  // Task changed
	dw_tasks.Retrieve(is_userid)
	li_Task = dw_tasks.Find("Task_ID = " + String(g_obj.Objid), 1, dw_tasks.RowCount())  // Find task
	If li_Task > 0 then   // If found, select task
		dw_tasks.SetRow(li_Task)
		dw_tasks.ScrolltoRow(li_Task)		
		wf_UpdateCalender()
		dw_usage.Retrieve(Integer(ddlb_Year.Text), is_UserID )
	End If
End If
end event

type cb_new from commandbutton within w_tasks
integer x = 55
integer y = 1600
integer width = 384
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "New..."
end type

event clicked;Integer li_Task

g_obj.ObjString = ""
g_obj.Sql = is_userid
g_obj.Objid = 0

open(w_taskedit)

If g_obj.Objid > 0 then  // New task added
	dw_tasks.Retrieve(is_userid)
	li_Task = dw_tasks.Find("Task_ID = " + String(g_obj.Objid), 1, dw_tasks.RowCount())  // Find last added task
	If li_Task > 0 then   // If found, select task
		dw_tasks.SetRow(li_Task)
		dw_tasks.ScrolltoRow(li_Task)
		wf_UpdateCalender()
		dw_usage.Retrieve(Integer(ddlb_Year.Text), is_UserID )
	End If
End If


end event

type cbx_nontask from checkbox within w_tasks
integer x = 2560
integer y = 16
integer width = 475
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hide Non-Tasks"
end type

event clicked;
wf_setfilter( )
end event

type cbx_comp from checkbox within w_tasks
integer x = 1975
integer y = 16
integer width = 475
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hide Completed"
end type

event clicked;
wf_setfilter( )
end event

type dw_tasks from datawindow within w_tasks
integer x = 55
integer y = 208
integer width = 4297
integer height = 1392
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_tasks"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
If rowcount = 0 then
	cb_edit.Enabled = False
	cb_reassign.Enabled = False
	cb_del.Enabled = False
Else
	If (g_Obj.Access = 3) or ((g_Obj.Access = 2) and (is_userid = g_Obj.UserID)) then
		cb_Edit.Enabled = True
		cb_del.Enabled = True
		If (g_Obj.Access = 3) or (g_Obj.DeptID = 1) then cb_ReAssign.Enabled = True Else cb_ReAssign.Enabled = False		
	Else
		cb_Edit.Enabled = False
		cb_ReAssign.Enabled = False
		cb_Del.Enabled = False		
	End If
	This.SetRow(RowCount)
	This.ScrollToRow(RowCount)
End If
end event

event rowfocuschanged;
This.SetRedraw(False)
This.SetRedraw(True)

end event

event clicked;string ls_sort

If (dwo.type = "text") then
	If (dwo.tag>"") then
		ls_sort = dwo.Tag
		this.setSort(ls_sort)
		this.Sort()
		if right(ls_sort,1) = "A" then 
			ls_sort = replace(ls_sort, len(ls_sort),1, "D")
		else
			ls_sort = replace(ls_sort, len(ls_sort),1, "A")
		end if
		dwo.Tag = ls_sort
	End If
end if
end event

event doubleclicked;
If (row > 0) and cb_Edit.Enabled then cb_Edit.event clicked( )
end event

type st_name from statictext within w_tasks
integer x = 512
integer y = 24
integer width = 1207
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "Arjun"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_seluser from commandbutton within w_tasks
integer x = 1719
integer y = 20
integer width = 110
integer height = 80
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;
g_obj.objstring = is_userid

Open(w_userSelect)

if g_Obj.Objstring > "" then
	is_userid = g_Obj.Objstring
	dw_tasks.Retrieve(is_userid)
	st_name.Text = is_userid + " - " + g_obj.Sql
	dw_usage.Retrieve(Integer(ddlb_Year.Text), is_UserID )
	If ((g_obj.deptid = 1) or (is_userid=g_Obj.UserID)) and (g_obj.access > 1) then 
		cb_new.Enabled = True 
		cb_PW.Enabled = True
	Else 
		cb_new.Enabled = False
		cb_PW.Enabled = False
	End If
End If
end event

type st_1 from statictext within w_tasks
integer x = 37
integer y = 32
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
string text = "User ID / Name:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_tasks
integer x = 18
integer y = 128
integer width = 4370
integer height = 1568
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Scheduled Task List"
end type

type gb_2 from groupbox within w_tasks
integer x = 18
integer y = 1712
integer width = 3255
integer height = 496
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Utilization"
end type

