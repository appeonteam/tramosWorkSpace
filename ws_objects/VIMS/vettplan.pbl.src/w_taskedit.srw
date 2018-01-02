$PBExportHeader$w_taskedit.srw
forward
global type w_taskedit from window
end type
type st_1 from statictext within w_taskedit
end type
type dw_task from datawindow within w_taskedit
end type
type cb_save from commandbutton within w_taskedit
end type
type cb_cancel from commandbutton within w_taskedit
end type
type gb_1 from groupbox within w_taskedit
end type
end forward

global type w_taskedit from window
integer width = 1751
integer height = 1080
boolean titlebar = true
string title = "Task Details"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
dw_task dw_task
cb_save cb_save
cb_cancel cb_cancel
gb_1 gb_1
end type
global w_taskedit w_taskedit

type variables

end variables

on w_taskedit.create
this.st_1=create st_1
this.dw_task=create dw_task
this.cb_save=create cb_save
this.cb_cancel=create cb_cancel
this.gb_1=create gb_1
this.Control[]={this.st_1,&
this.dw_task,&
this.cb_save,&
this.cb_cancel,&
this.gb_1}
end on

on w_taskedit.destroy
destroy(this.st_1)
destroy(this.dw_task)
destroy(this.cb_save)
destroy(this.cb_cancel)
destroy(this.gb_1)
end on

event open;datastore lds_insp
Integer li_Row

SetPointer(HourGlass!)

dw_task.SetTransObject(SQLCA)

If g_obj.ObjString = "Edit" then
	dw_task.Retrieve(g_obj.objid)
	dw_task.SetItem(1, "vslname", g_obj.sql)
ElseIf Left(g_Obj.ObjString,4) = "Auto" then
	dw_task.InsertRow(0)
	dw_task.SetItem(1, "fromdate", DateTime(Mid(g_Obj.ObjString, 5, 10)))
	dw_task.SetItem(1, "Todate", DateTime(Mid(g_Obj.ObjString, 15, 10)))
	dw_task.SetItem(1, "status", 0)
	dw_task.SetItem(1, "userid", g_obj.sql)
	dw_task.SetItem(1, "VesselIMO", g_Obj.Vesselimo)
	dw_task.SetItem(1, "VslName", Right(g_Obj.ObjString, Len(g_Obj.ObjString)-24))
Else
	dw_task.InsertRow(0)
	dw_task.SetItem(1, "fromdate", DateTime(Today()))
	dw_task.SetItem(1, "Todate", DateTime(Today()))
	dw_task.SetItem(1, "status", 0)
	dw_task.SetItem(1, "userid", g_obj.sql)
End If

end event

type st_1 from statictext within w_taskedit
integer x = 1243
integer y = 464
integer width = 402
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 12632256
long backcolor = 67108864
string text = "(Optional)"
boolean focusrectangle = false
end type

type dw_task from datawindow within w_taskedit
integer x = 55
integer y = 64
integer width = 1627
integer height = 768
integer taborder = 10
string title = "none"
string dataobject = "d_sq_ff_taskedit"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;
If dwo.name = "b_vsl" then  // Vessel selection button
	g_obj.vesselimo = dw_task.GetItemNumber(1, "Vesselimo")
	g_obj.Sql = dw_task.GetItemString(1, "userid")
	
	open(w_vslselect)
	
	If g_obj.Vesselimo > 0 then 
		dw_task.SetItem(1, "Vesselimo", g_obj.Vesselimo)
		dw_task.SetItem(1, "Vslname", g_obj.Sql)
	End If
Else  // Calender button
	
	This.Accepttext( )
	
	g_obj.Objstring = String(dw_task.GetItemDateTime(1, "FromDate"), "yyyy-mm-dd") + String(dw_task.GetItemDateTime(1, "ToDate"), "yyyy-mm-dd")	
	
	Open(w_CalSelect)
	
	If g_Obj.ObjString > "" then
		dw_Task.SetItem(1, "FromDate", DateTime(Left(g_Obj.ObjString,10)))
		dw_Task.SetItem(1, "ToDate", DateTime(Right(g_Obj.ObjString,10)))
	End If
End If

end event

type cb_save from commandbutton within w_taskedit
integer x = 329
integer y = 880
integer width = 343
integer height = 92
integer taborder = 160
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;Integer li_Num
DateTime ldt_From, ldt_To
String ls_UserID

SetPointer(HourGlass!)

dw_task.Accepttext( )

ldt_From = dw_task.GetItemDateTime(1, "Fromdate")
ldt_To = dw_task.GetItemDateTime(1, "Todate")
ls_UserID = dw_task.GetItemString(1, "userid")

If DaysAfter(Date(ldt_From), Date(ldt_To)) < 0 then
	MessageBox("Invalid Dates", "The 'To' date must be same or later than the 'From' date.", Exclamation!)
	Return
End If

If DaysAfter(Date(ldt_From), Date(ldt_To)) >= 90 then
	MessageBox("Invalid Dates", "The period between 'From' and 'To' dates cannot exceed 90 days.", Exclamation!)
	Return
End If

// Check dates
li_Num = f_FindTaskOverlap( ls_UserID, ldt_From, ldt_To, g_Obj.ObjID )

If li_Num < 0 then Return  // Error in function

If li_Num > 0 then 
	MessageBox("Task Dates", "The Task date range selected overlaps with another task. Please check the dates.", Exclamation!)
	Return
End If

li_Num = dw_task.GetItemNumber( 1, "tasktype_id")
If IsNull(li_Num) then
	MessageBox("Task Type", "You must select a task type.", Exclamation!)
	Return
End If

Select ISTASK into :li_Num from VETT_TASKTYPE Where TASKTYPE_ID = :li_Num;

If SQLCA.SQLCode <> 0 then
	MessageBox("DB Error", "Could not check task type.~n~n" + SQLCA.SQLErrText, Exclamation!)
	Rollback;
	Return	
End If

Commit;

If li_Num = 0 then    // If non-work task, then deselect vessel
	SetNull(li_Num)
	dw_task.SetItem(1, "VesselImo", li_Num)
End If	

li_Num = dw_task.GetItemNumber( 1, "status")
If li_Num = 3 then
	If ldt_From >= DateTime(Today()) then
		If Messagebox("Confirm Status", "You have chosen mark a future task as completed.~n~nAre you sure you want to continue?", Question!, YesNo!) = 2 then Return	
	End If
End If

If (ldt_From < DateTime(Today())) and (ldt_To < DateTime(Today())) and (li_Num < 3) then
	If Messagebox("Confirm Status", "The task is in the past and not marked as 'completed'.~n~nDo you want to continue?", Question!, YesNo!) = 2 then Return	
End If

li_Num = dw_task.Update( )	
	
If li_Num < 0 then 
	Messagebox("Update Failed", "Could not save task details.", Exclamation!)
	Return
End If

Commit;

g_obj.Objid = dw_task.GetItemNumber(1, "Task_ID")

Close(Parent)

end event

type cb_cancel from commandbutton within w_taskedit
integer x = 1079
integer y = 880
integer width = 343
integer height = 92
integer taborder = 170
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;

g_obj.ObjId = 0

Close(Parent)
end event

type gb_1 from groupbox within w_taskedit
integer x = 18
integer width = 1701
integer height = 848
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

