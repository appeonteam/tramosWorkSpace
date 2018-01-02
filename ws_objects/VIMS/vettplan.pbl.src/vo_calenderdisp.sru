$PBExportHeader$vo_calenderdisp.sru
forward
global type vo_calenderdisp from userobject
end type
type st_to from statictext within vo_calenderdisp
end type
type st_from from statictext within vo_calenderdisp
end type
type st_user from statictext within vo_calenderdisp
end type
type st_vsl from statictext within vo_calenderdisp
end type
type st_status from statictext within vo_calenderdisp
end type
type st_task from statictext within vo_calenderdisp
end type
type st_r1 from statictext within vo_calenderdisp
end type
type st_l3 from statictext within vo_calenderdisp
end type
type st_l2 from statictext within vo_calenderdisp
end type
type st_r3 from statictext within vo_calenderdisp
end type
type st_r2 from statictext within vo_calenderdisp
end type
type st_l1 from statictext within vo_calenderdisp
end type
type cb_print from commandbutton within vo_calenderdisp
end type
type st_2 from statictext within vo_calenderdisp
end type
type ddlb_period from dropdownlistbox within vo_calenderdisp
end type
type cb_next from commandbutton within vo_calenderdisp
end type
type cb_prev from commandbutton within vo_calenderdisp
end type
type st_month from statictext within vo_calenderdisp
end type
type st_1 from statictext within vo_calenderdisp
end type
type dw_cal from datawindow within vo_calenderdisp
end type
type gb_details from groupbox within vo_calenderdisp
end type
end forward

global type vo_calenderdisp from userobject
integer width = 2715
integer height = 1720
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_resize pbm_size
st_to st_to
st_from st_from
st_user st_user
st_vsl st_vsl
st_status st_status
st_task st_task
st_r1 st_r1
st_l3 st_l3
st_l2 st_l2
st_r3 st_r3
st_r2 st_r2
st_l1 st_l1
cb_print cb_print
st_2 st_2
ddlb_period ddlb_period
cb_next cb_next
cb_prev cb_prev
st_month st_month
st_1 st_1
dw_cal dw_cal
gb_details gb_details
end type
global vo_calenderdisp vo_calenderdisp

type variables

Private Date id_Start, id_End
Private Integer ii_numtxtitem, ii_RowHover

Private DataStore ids_CalData
end variables

forward prototypes
public subroutine of_drawcalender ()
public subroutine of_setstartdate (integer ai_month, integer ai_year)
public subroutine of_setsourcedata (blob ab_blob)
public subroutine of_settitle (string as_title1, string as_name1, string as_title2, string as_name2)
end prototypes

event ue_resize;Integer li_x

dw_cal.width = newwidth - dw_cal.x * 2
li_x = newheight - dw_cal.y - dw_cal.x * 2 - gb_details.Height
If li_x < 500 then li_x = 500
dw_Cal.Height = li_x

li_x = newwidth - cb_print.Width - dw_Cal.x
If li_x < ddlb_period.x + ddlb_period.width then li_x = ddlb_period.x + ddlb_period.width

cb_print.x = li_x

li_x = dw_Cal.width
If li_x < st_user.x + st_user.width - gb_details.x then li_x = st_user.x + st_user.width - gb_details.x
gb_details.width = li_x
gb_details.y = dw_cal.height + dw_cal.y + dw_cal.x


st_l1.y = gb_details.y + 112
st_r1.y = gb_details.y + 112
st_Task.y = gb_details.y + 112
st_User.y = gb_details.y + 112

st_l2.y = gb_details.y + 176
st_r2.y = gb_details.y + 176
st_Status.y = gb_details.y + 176
st_From.y = gb_details.y + 176

st_l3.y = gb_details.y + 240
st_r3.y = gb_details.y + 240
st_Vsl.y = gb_details.y + 240
st_To.y = gb_details.y + 240


end event

public subroutine of_drawcalender ();Integer  li_NumMonths, li_Month[], li_Year[], li_NewRow, li_Tasks, li_RowTxtCount, li_Temp
Date ld_curdate, ld_From, ld_To
String ls_Error, ls_Vis, ls_Color, ls_StatColor, ls_Text, ls_width, ls_x1, ls_CurM
String ls_TaskFrom, ls_TaskTo, ls_Row, ls_ShortText

ld_curdate = id_Start

// Turn off drawing and delete all rows
dw_Cal.SetRedraw(False)
dw_Cal.Reset( )  

// If any text labels present, destroy all
If ii_numtxtitem > 0 then
	For li_NewRow = 1 to ii_numtxtitem
		dw_Cal.Modify("destroy t_lbl" + String(li_NewRow, "00"))
		dw_Cal.Modify("destroy r" + String(li_NewRow, "00"))
	Next 
	ii_numtxtitem = 0 // reset to zero
End If

// Destroy all background boxes
For li_NewRow = 1 to 31 Step 2
	dw_Cal.Modify("destroy r" + String(li_NewRow))
	dw_Cal.Modify("destroy r" + String(li_NewRow+1))
Next

// Insert rows for all months
Do 
	li_NewRow = dw_Cal.insertrow(0)	
	dw_Cal.SetItem(li_NewRow, "monthname", String(ld_curdate, "mmm yy"))
	dw_Cal.SetItem(li_NewRow, "numdays", f_DaysInMonth(Month(ld_curdate),Year(ld_curdate)))	
	dw_Cal.SetItem(li_NewRow, "IsCurMonth", 0)
	li_NumMonths++
	li_Month[li_NumMonths] = Month(ld_curdate)
	li_Year[li_NumMonths] = Year(ld_curdate)
	If (li_Month[li_NumMonths] = Month(Today())) and (li_Year[li_NumMonths] = Year(Today())) then dw_Cal.SetItem(li_NewRow, "IsCurMonth", 1)
	ld_curdate = Date(f_addmonths(DateTime(ld_curdate), 1))
Loop Until ld_curdate > id_End

// Insert alternate background boxes
For li_NewRow = 1 to 31 Step 2
	dw_Cal.Modify("Create rectangle(band=detail x='" + String(332 + 140*(li_NewRow - 1)) + "' y='0' height='108' width='132' name=r" + String(li_NewRow) + " visible='0~tIf(numdays>=" + String(li_NewRow)+ ",1,0)' brush.hatch='6' brush.color='15790320' pen.style='0' pen.width='5' pen.color='15790320'  background.mode='2' background.color='15790320'")
	dw_Cal.Modify("Create rectangle(band=detail x='" + String(332 + 140*li_NewRow) + "' y='0' height='108' width='132' name=r" + String(li_NewRow+1) + " visible='0~tIf(numdays>=" + String(li_NewRow+1)+ ",1,0)' brush.hatch='6' brush.color='14737632' pen.style='0' pen.width='5' pen.color='14737632'  background.mode='2' background.color='14737632'")	
Next

// Loop thru all months
For li_NewRow = 1 to li_NumMonths
	
	// Reset Rowtext count to 0 and reset all columns
	li_RowTxtCount = 0   
	ls_Vis = ""
	ls_Color = ""
	ls_StatColor = ""
	ls_Text = ""
	ls_Width = ""
	ls_X1 = ""
	ls_Row = ""
	ls_CurM = String(li_Year[li_NewRow], "0000") + String(li_Month[li_NewRow], "00")
	
	For li_Tasks = 1 to ids_CalData.RowCount()    //  Loop thru all tasks
		
		// Get the task start and end dates
		ld_From = ids_CalData.GetItemDate(li_Tasks, "FromDate")
		ld_To = ids_CalData.GetItemDate(li_Tasks, "ToDate")

		// Get string form for dates:  yyyymm
		ls_TaskFrom = String(ld_From, "yyyymm")
		ls_TaskTo = String(ld_To, "yyyymm") 
		

		// If the task lies in the month (fully or partially)
		If (ls_TaskFrom = ls_CurM) or (ls_TaskTo = ls_CurM) or ((ls_TaskFrom < ls_CurM) and (ls_TaskTo > ls_CurM)) then
			li_RowTxtCount++
			If li_RowTxtCount > ii_numtxtitem then  // If not enough text boxes, create new one
				// Create box for status
				ls_Error = dw_Cal.Modify("Create rectangle(band=detail x='0 ~t 192 + 140 * Integer(f_GetStringByIndex(tx_x1, " + String(ii_numtxtitem + 1, "0") + "))' y='72' height='22' width='0 ~t 140 * Integer(f_GetStringByIndex(tx_wd, "&
					+ String(ii_numtxtitem + 1, "0") + ")) - 9' name=r" + String(ii_numtxtitem + 1, "00") + " visible='0 ~t Integer( Mid(tx_vis ," + String(ii_numtxtitem + 1, "00") + ", 1))'"&
					+ "brush.hatch='6' brush.color='0 ~t Long(f_GetStringByIndex(tx_stat, " + String(ii_numtxtitem + 1, "0") + "))' pen.style='5' pen.width='5' pen.color='0' background.mode='0' background.color='0')")						
				If ls_Error > "" then MessageBox("DW Modify Error", "Status Rectangle Error!~n~n" + ls_Error)			
				ls_Error = dw_Cal.Modify("create text(band=Detail color='0' alignment='2' border='2'"&
					+ " height.autosize=No pointer='Arrow!' visible='0 ~t Integer( Mid(tx_vis ," + String(ii_numtxtitem + 1, "0") + ", 1))' moveable=0 resizeable=0 x='0 ~t 192 + 140 * Integer(f_GetStringByIndex(tx_x1, " + String(ii_numtxtitem + 1, "0") + "))'"&
					+ " y='12' height='60' width='0 ~t 140 * Integer(f_GetStringByIndex(tx_wd, " + String(ii_numtxtitem + 1, "0") + ")) - 9' text='xx ~t f_GetStringByIndex(tx_text, " + String(ii_numtxtitem + 1) + ")'"&
					+ " name=t_lbl" + String(ii_numtxtitem + 1, "00") + " tag='' font.face='Arial Narrow' font.height= '-8' font.weight='400' font.family='0' font.pitch='0' font.charset='0' font.italic='0'"&
					+ " font.strikethrough='0' font.underline='0' background.mode='0' background.color='0 ~t Long(f_GetStringByIndex(tx_color, " + String(ii_numtxtitem + 1, "0") + "))')")
				If ls_Error > "" then MessageBox("DW Modify Error", "Task Rectangle Error.~n~n" + ls_Error)
				ii_numtxtitem++  // Increment count for textboxes
			End If
			
			ls_Vis += "1"
			If ls_TaskFrom < ls_CurM then   // If task starts before the current month
				ls_x1 += "1°"   // Set to first of month
				If ls_TaskTo > ls_CurM then  // If task ends after the current month
					li_Temp = dw_Cal.GetItemNumber(li_NewRow, "numdays")  // Till end of month
				Else    // otherwise set to date
					li_Temp = Day(ld_To)
				End If				
			Else  //  otherwise set to date
				ls_x1 += String(Day(ld_From)) + "°"
				If ls_TaskTo > ls_CurM then  // If task ends after the current month
					li_Temp = dw_Cal.GetItemNumber(li_NewRow, "numdays") - Day(ld_From) + 1   // Till end of month
				Else    // otherwise set to date
					li_Temp = Day(ld_To) - Day(ld_From) + 1
				End If				
			End If
			ls_width += String(li_Temp) + "°"		
			ls_ShortText = ids_CalData.GetItemString(li_Tasks, "ShortName")			
			ls_Text += ls_ShortText + "°"
			ls_Color += String(ids_CalData.GetItemNumber(li_Tasks, "Color")) + "°"
			ls_StatColor += String(ids_CalData.GetItemNumber(li_Tasks, "StatColor")) + "°"
			ls_Row += String(li_Tasks) + "°"			
		End If
	Next
	dw_Cal.SetItem(li_NewRow, "tx_vis", ls_Vis)
	dw_Cal.SetItem(li_NewRow, "tx_text", ls_Text)
	dw_Cal.SetItem(li_NewRow, "tx_x1", ls_x1)
	dw_Cal.SetItem(li_NewRow, "tx_wd", ls_width)
	dw_Cal.SetItem(li_NewRow, "tx_color", ls_Color)
	dw_Cal.SetItem(li_NewRow, "tx_stat", ls_StatColor)
	dw_Cal.SetItem(li_NewRow, "tx_rowindex", ls_Row)
Next

dw_Cal.SetRedraw(True)

end subroutine

public subroutine of_setstartdate (integer ai_month, integer ai_year);
id_Start = Date(ai_Year, ai_Month, 1)

ddlb_period.SelectItem(3)

id_End = Date(f_addmonths(DateTime(id_Start), 17))

st_month.Text = String(id_Start, "mmm yyyy")

of_drawcalender()
end subroutine

public subroutine of_setsourcedata (blob ab_blob);
ids_caldata.SetFullstate(ab_blob)

ids_CalData.SetSort("fromdate asc")
ids_CalData.Sort( )
end subroutine

public subroutine of_settitle (string as_title1, string as_name1, string as_title2, string as_name2);
dw_Cal.Object.t_title1.Text = as_title1 + ":"
dw_Cal.Object.t_name1.Text = as_name1

If as_title2 > "" then
	dw_Cal.Object.t_title2.Text = as_title2 + ":"
	dw_Cal.Object.t_name2.Text = as_name2
Else
	dw_Cal.Object.t_title2.Text = ""
	dw_Cal.Object.t_name2.Text = ""	
End If
end subroutine

on vo_calenderdisp.create
this.st_to=create st_to
this.st_from=create st_from
this.st_user=create st_user
this.st_vsl=create st_vsl
this.st_status=create st_status
this.st_task=create st_task
this.st_r1=create st_r1
this.st_l3=create st_l3
this.st_l2=create st_l2
this.st_r3=create st_r3
this.st_r2=create st_r2
this.st_l1=create st_l1
this.cb_print=create cb_print
this.st_2=create st_2
this.ddlb_period=create ddlb_period
this.cb_next=create cb_next
this.cb_prev=create cb_prev
this.st_month=create st_month
this.st_1=create st_1
this.dw_cal=create dw_cal
this.gb_details=create gb_details
this.Control[]={this.st_to,&
this.st_from,&
this.st_user,&
this.st_vsl,&
this.st_status,&
this.st_task,&
this.st_r1,&
this.st_l3,&
this.st_l2,&
this.st_r3,&
this.st_r2,&
this.st_l1,&
this.cb_print,&
this.st_2,&
this.ddlb_period,&
this.cb_next,&
this.cb_prev,&
this.st_month,&
this.st_1,&
this.dw_cal,&
this.gb_details}
end on

on vo_calenderdisp.destroy
destroy(this.st_to)
destroy(this.st_from)
destroy(this.st_user)
destroy(this.st_vsl)
destroy(this.st_status)
destroy(this.st_task)
destroy(this.st_r1)
destroy(this.st_l3)
destroy(this.st_l2)
destroy(this.st_r3)
destroy(this.st_r2)
destroy(this.st_l1)
destroy(this.cb_print)
destroy(this.st_2)
destroy(this.ddlb_period)
destroy(this.cb_next)
destroy(this.cb_prev)
destroy(this.st_month)
destroy(this.st_1)
destroy(this.dw_cal)
destroy(this.gb_details)
end on

event constructor;
ids_CalData = Create DataStore


end event

event destructor;
Destroy ids_CalData
end event

type st_to from statictext within vo_calenderdisp
integer x = 1902
integer y = 1456
integer width = 530
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_from from statictext within vo_calenderdisp
integer x = 1902
integer y = 1392
integer width = 530
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_user from statictext within vo_calenderdisp
integer x = 1902
integer y = 1328
integer width = 713
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_vsl from statictext within vo_calenderdisp
integer x = 421
integer y = 1456
integer width = 1134
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_status from statictext within vo_calenderdisp
integer x = 421
integer y = 1392
integer width = 1207
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_task from statictext within vo_calenderdisp
integer x = 421
integer y = 1328
integer width = 1207
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_r1 from statictext within vo_calenderdisp
integer x = 1627
integer y = 1328
integer width = 238
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspector:"
boolean focusrectangle = false
end type

type st_l3 from statictext within vo_calenderdisp
integer x = 110
integer y = 1456
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel:"
boolean focusrectangle = false
end type

type st_l2 from statictext within vo_calenderdisp
integer x = 110
integer y = 1392
integer width = 201
integer height = 64
integer textsize = -8
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

type st_r3 from statictext within vo_calenderdisp
integer x = 1627
integer y = 1456
integer width = 110
integer height = 64
integer textsize = -8
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

type st_r2 from statictext within vo_calenderdisp
integer x = 1627
integer y = 1392
integer width = 146
integer height = 64
integer textsize = -8
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

type st_l1 from statictext within vo_calenderdisp
integer x = 110
integer y = 1328
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Task / Insp:"
boolean focusrectangle = false
end type

type cb_print from commandbutton within vo_calenderdisp
integer x = 2121
integer y = 32
integer width = 402
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print Calender"
end type

event clicked;
dw_cal.Print(True, True)
end event

type st_2 from statictext within vo_calenderdisp
integer x = 1262
integer y = 40
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
string text = "Period:"
boolean focusrectangle = false
end type

type ddlb_period from dropdownlistbox within vo_calenderdisp
integer x = 1499
integer y = 32
integer width = 411
integer height = 324
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"6 Months","12 Months","18 Months"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
id_End = Date(f_addmonths(DateTime(id_Start), Index * 6 - 1))

of_drawcalender()
end event

type cb_next from commandbutton within vo_calenderdisp
integer x = 969
integer y = 32
integer width = 91
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = ">"
end type

event clicked;
id_Start = Date(f_addmonths(DateTime(id_Start), 1))
id_End = Date(f_addmonths(DateTime(id_End), 1))
st_Month.Text = String(id_Start, "mmm yyyy")

of_drawcalender( )
end event

type cb_prev from commandbutton within vo_calenderdisp
integer x = 878
integer y = 32
integer width = 91
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "<"
end type

event clicked;
id_Start = Date(f_addmonths(DateTime(id_Start), -1))
id_End = Date(f_addmonths(DateTime(id_End), -1))
st_Month.Text = String(id_Start, "mmm yyyy")

of_drawcalender( )
end event

type st_month from statictext within vo_calenderdisp
integer x = 439
integer y = 32
integer width = 439
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "none"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within vo_calenderdisp
integer x = 18
integer y = 40
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
string text = "Start Month:"
boolean focusrectangle = false
end type

type dw_cal from datawindow within vo_calenderdisp
event ue_mousemove pbm_dwnmousemove
integer x = 18
integer y = 128
integer width = 1993
integer height = 1072
integer taborder = 40
string title = "none"
string dataobject = "d_ext_tb_calender"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;
Integer li_Row
String ls_Index

// Get row number of source Datastore
If (dwo.Type = "text") and (row>0) then
	ls_Index = Right(dwo.Name,2)
	li_Row = Integer(dw_Cal.Describe('Evaluate("f_GetStringByIndex(tx_rowindex, ' + ls_Index + ')",' + String(Row) + ')'))
Else
	li_Row = 0  // nothing under the mouse
End If

// Check if not same as before
If li_Row <> ii_RowHover then	
	ii_RowHover = li_Row
	
	// If something under the mouse
	If li_Row > 0 then
		st_task.Text = ids_CalData.GetItemString(li_Row, "taskname")
		st_from.Text = String(ids_CalData.GetItemDate(li_Row, "fromdate"), "dd mmm yyyy")
		st_to.Text = String(ids_CalData.GetItemDate(li_Row, "todate"), "dd mmm yyyy")
		st_User.Text = ids_CalData.GetItemString(li_Row, "username")
		st_Vsl.Text = ids_CalData.GetItemString(li_Row, "vslname")
		Choose Case ids_CalData.GetItemNumber(li_Row, "statusval")
			Case 0
				ls_Index = "Tentative"
			Case 1
				ls_Index = "Fixed"
			Case 2
				ls_Index = "Re-Scheduled"
			Case 3
				ls_Index = "Completed"
		End Choose
		st_Status.Text = ls_Index
	Else  // Otherwise make all blank
		st_task.Text = ""
		st_from.Text = ""
		st_to.Text = ""
		st_User.Text = ""
		st_Vsl.Text = ""
		st_Status.Text = ""
	End If
End If
end event

type gb_details from groupbox within vo_calenderdisp
integer x = 18
integer y = 1216
integer width = 2615
integer height = 320
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Task / Inspection Details"
end type

