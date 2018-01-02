$PBExportHeader$w_findinspectors.srw
forward
global type w_findinspectors from window
end type
type cb_newtask from commandbutton within w_findinspectors
end type
type cb_tasks from commandbutton within w_findinspectors
end type
type st_vessel from statictext within w_findinspectors
end type
type cb_search from commandbutton within w_findinspectors
end type
type cb_close from commandbutton within w_findinspectors
end type
type dw_results from datawindow within w_findinspectors
end type
type cbx_fix from checkbox within w_findinspectors
end type
type cbx_tent from checkbox within w_findinspectors
end type
type st_6 from statictext within w_findinspectors
end type
type st_5 from statictext within w_findinspectors
end type
type em_buffer from editmask within w_findinspectors
end type
type st_4 from statictext within w_findinspectors
end type
type cb_cal from commandbutton within w_findinspectors
end type
type dp_to from datepicker within w_findinspectors
end type
type dp_from from datepicker within w_findinspectors
end type
type st_3 from statictext within w_findinspectors
end type
type st_2 from statictext within w_findinspectors
end type
type st_1 from statictext within w_findinspectors
end type
type gb_1 from groupbox within w_findinspectors
end type
type gb_2 from groupbox within w_findinspectors
end type
end forward

global type w_findinspectors from window
integer width = 2162
integer height = 2224
boolean titlebar = true
string title = "Inspector Search"
boolean maxbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_newtask cb_newtask
cb_tasks cb_tasks
st_vessel st_vessel
cb_search cb_search
cb_close cb_close
dw_results dw_results
cbx_fix cbx_fix
cbx_tent cbx_tent
st_6 st_6
st_5 st_5
em_buffer em_buffer
st_4 st_4
cb_cal cb_cal
dp_to dp_to
dp_from dp_from
st_3 st_3
st_2 st_2
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_findinspectors w_findinspectors

type variables

Integer ii_VslType
Long il_IMO
String is_VesselName
end variables

on w_findinspectors.create
this.cb_newtask=create cb_newtask
this.cb_tasks=create cb_tasks
this.st_vessel=create st_vessel
this.cb_search=create cb_search
this.cb_close=create cb_close
this.dw_results=create dw_results
this.cbx_fix=create cbx_fix
this.cbx_tent=create cbx_tent
this.st_6=create st_6
this.st_5=create st_5
this.em_buffer=create em_buffer
this.st_4=create st_4
this.cb_cal=create cb_cal
this.dp_to=create dp_to
this.dp_from=create dp_from
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_newtask,&
this.cb_tasks,&
this.st_vessel,&
this.cb_search,&
this.cb_close,&
this.dw_results,&
this.cbx_fix,&
this.cbx_tent,&
this.st_6,&
this.st_5,&
this.em_buffer,&
this.st_4,&
this.cb_cal,&
this.dp_to,&
this.dp_from,&
this.st_3,&
this.st_2,&
this.st_1,&
this.gb_1,&
this.gb_2}
end on

on w_findinspectors.destroy
destroy(this.cb_newtask)
destroy(this.cb_tasks)
destroy(this.st_vessel)
destroy(this.cb_search)
destroy(this.cb_close)
destroy(this.dw_results)
destroy(this.cbx_fix)
destroy(this.cbx_tent)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.em_buffer)
destroy(this.st_4)
destroy(this.cb_cal)
destroy(this.dp_to)
destroy(this.dp_from)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;
st_vessel.Text = g_Obj.ObjString

ii_VslType = g_obj.Objid
il_IMO = g_Obj.Vesselimo
is_VesselName = g_Obj.Sql

dp_From.Value = DateTime(Today())
dp_To.Value = DateTime(Today())

end event

type cb_newtask from commandbutton within w_findinspectors
integer x = 585
integer y = 1888
integer width = 530
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Assign Task..."
end type

event clicked;String ls_UserID

ls_UserID = dw_Results.GetItemString(dw_Results.GetRow(), "userid")

g_obj.ObjString = "Auto" + String(dp_from.Value, "yyyy-mm-dd") + String(dp_to.Value, "yyyy-mm-dd") + is_Vesselname
g_obj.VesselIMO = il_IMO
g_obj.Sql = ls_userid

Open(w_taskedit)

If g_obj.Objid > 0 then  // New task added
	If Messagebox("Task Added", "The task was assigned successfully.~n~nDo you want to open the Task Scheduler?", Question!, YesNo!) = 1 then cb_Tasks.event clicked( )
End If

end event

type cb_tasks from commandbutton within w_findinspectors
integer x = 55
integer y = 1888
integer width = 530
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Open Task Scheduler"
end type

event clicked;
OpenSheet(w_Tasks, w_Main, 0, Original!)

w_Tasks.is_userid = dw_Results.GetItemString(dw_Results.GetRow(), "userid")
w_Tasks.dw_tasks.Retrieve(w_Tasks.is_userid)
w_Tasks.st_name.Text = w_Tasks.is_userid + " - " + dw_Results.GetItemString(dw_Results.GetRow(), "fullname")
w_Tasks.dw_usage.Retrieve(Integer(w_Tasks.ddlb_Year.Text), w_Tasks.is_UserID )

end event

type st_vessel from statictext within w_findinspectors
integer x = 457
integer y = 144
integer width = 1609
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type cb_search from commandbutton within w_findinspectors
integer x = 622
integer y = 736
integer width = 914
integer height = 96
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Start Search"
end type

event clicked;n_Search ln_SearchObj
Integer li_Status

If dp_from.Value > dp_to.Value then
	MessageBox("Incorrect Period", "The 'To' date must be after the 'From' date.", Exclamation!)
	Return
End If

SetPointer(HourGlass!)
This.Text = "Searching..."
This.Enabled = False
cb_tasks.Enabled = False
cb_newtask.Enabled = False

ln_SearchObj = Create n_Search

li_Status = -1
If cbx_Tent.Checked then li_Status = 0
If cbx_Fix.Checked then li_Status = 2

ln_SearchObj.of_StartSearch( Date(dp_From.Value), Date(dp_To.Value), ii_VslType, Integer(em_Buffer.Text), li_Status, dw_results)

Destroy ln_SearchObj

This.Text = "Start Search"
This.Enabled = True

If (dw_results.RowCount( ) > 0) then
	If ((g_Obj.DeptID = 1) and (g_Obj.Access = 2)) Or (g_Obj.Access = 3) then	
		cb_newtask.Enabled = True
		cb_tasks.Enabled = True
	End If
End If
end event

type cb_close from commandbutton within w_findinspectors
integer x = 841
integer y = 2016
integer width = 475
integer height = 112
integer taborder = 80
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

type dw_results from datawindow within w_findinspectors
integer x = 55
integer y = 928
integer width = 2030
integer height = 960
integer taborder = 70
string title = "none"
string dataobject = "d_ext_results"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
This.SetRedraw(False)
This.SetRedraw(True)

end event

event doubleclicked;
If (row > 0) and (cb_tasks.Enabled) then cb_tasks.event clicked( )
end event

type cbx_fix from checkbox within w_findinspectors
integer x = 896
integer y = 560
integer width = 677
integer height = 96
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fixed / Re-Scheduled"
end type

event clicked;
If This.Checked then cbx_tent.Checked = True
end event

type cbx_tent from checkbox within w_findinspectors
integer x = 457
integer y = 560
integer width = 402
integer height = 96
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tentative"
end type

event clicked;
If Not This.Checked then cbx_fix.Checked = False
end event

type st_6 from statictext within w_findinspectors
integer x = 91
integer y = 576
integer width = 201
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Status:"
boolean focusrectangle = false
end type

type st_5 from statictext within w_findinspectors
integer x = 695
integer y = 432
integer width = 238
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "Days"
boolean focusrectangle = false
end type

type em_buffer from editmask within w_findinspectors
integer x = 457
integer y = 416
integer width = 219
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "3"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "#0"
boolean spin = true
string minmax = "0~~20"
end type

type st_4 from statictext within w_findinspectors
integer x = 91
integer y = 432
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
string text = "Buffer:"
boolean focusrectangle = false
end type

type cb_cal from commandbutton within w_findinspectors
integer x = 1719
integer y = 272
integer width = 366
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Calender..."
end type

event clicked;
	g_obj.Objstring = String(dp_from.Value, "yyyy-mm-dd") + String(dp_To.Value, "yyyy-mm-dd")	
	
	Open(w_CalSelect)
	
	If g_Obj.ObjString > "" then
		dp_From.Value = DateTime(Left(g_Obj.ObjString,10))
		dp_To.Value = DateTime(Right(g_Obj.ObjString,10))
	End If

end event

type dp_to from datepicker within w_findinspectors
integer x = 1152
integer y = 272
integer width = 421
integer height = 80
integer taborder = 30
boolean border = true
borderstyle borderstyle = stylelowered!
boolean allowedit = true
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2199-12-31")
date mindate = Date("2006-01-01")
datetime value = DateTime(Date("2009-05-08"), Time("09:17:21.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type dp_from from datepicker within w_findinspectors
integer x = 457
integer y = 272
integer width = 421
integer height = 80
integer taborder = 20
boolean border = true
borderstyle borderstyle = stylelowered!
boolean allowedit = true
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2199-12-31")
date mindate = Date("2006-01-01")
datetime value = DateTime(Date("2009-05-08"), Time("09:17:21.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type st_3 from statictext within w_findinspectors
integer x = 1024
integer y = 288
integer width = 110
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

type st_2 from statictext within w_findinspectors
integer x = 91
integer y = 288
integer width = 201
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

type st_1 from statictext within w_findinspectors
integer x = 91
integer y = 144
integer width = 352
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Type:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_findinspectors
integer x = 18
integer y = 16
integer width = 2103
integer height = 688
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Criteria"
end type

type gb_2 from groupbox within w_findinspectors
integer x = 18
integer y = 848
integer width = 2103
integer height = 1136
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Results"
end type

