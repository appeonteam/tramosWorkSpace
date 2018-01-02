$PBExportHeader$vo_calweekdisp.sru
forward
global type vo_calweekdisp from userobject
end type
type cb_next1 from commandbutton within vo_calweekdisp
end type
type cb_prev1 from commandbutton within vo_calweekdisp
end type
type cb_print from commandbutton within vo_calweekdisp
end type
type cb_next10 from commandbutton within vo_calweekdisp
end type
type cb_prev10 from commandbutton within vo_calweekdisp
end type
type st_week from statictext within vo_calweekdisp
end type
type st_1 from statictext within vo_calweekdisp
end type
type dw_calmain from datawindow within vo_calweekdisp
end type
end forward

global type vo_calweekdisp from userobject
integer width = 3104
integer height = 1920
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_resize pbm_size
cb_next1 cb_next1
cb_prev1 cb_prev1
cb_print cb_print
cb_next10 cb_next10
cb_prev10 cb_prev10
st_week st_week
st_1 st_1
dw_calmain dw_calmain
end type
global vo_calweekdisp vo_calweekdisp

type variables

Private Date id_Start, id_End, id_DataStartDate, id_DataEndDate
Private Integer ii_numtxtitem, ii_RowHover, ii_Week, ii_numtaskitem
Private String is_Filter
Private DataStore ids_TaskData, ids_CalData

end variables

forward prototypes
public subroutine of_drawcalender ()
private subroutine of_loaddata (date ad_start, date ad_end)
public subroutine of_setweek (date ad_start)
public subroutine of_setfilter (string as_filter)
end prototypes

event ue_resize;Integer li_x

dw_CalMain.width = newwidth - dw_CalMain.x * 2
li_x = newheight - dw_CalMain.y - dw_CalMain.x  //- gb_details.Height
If li_x < 500 then li_x = 500
dw_CalMain.Height = li_x

li_x = newwidth - cb_print.Width - dw_CalMain.x
If li_x < cb_next10.x + cb_next10.width then li_x = cb_next10.x + cb_next10.width

cb_print.x = li_x

//li_x = dw_Cal.width
//If li_x < st_user.x + st_user.width - gb_details.x then li_x = st_user.x + st_user.width - gb_details.x
//gb_details.width = li_x
//gb_details.y = dw_cal.height + dw_cal.y + dw_cal.x
//

//st_l1.y = gb_details.y + 112
//st_r1.y = gb_details.y + 112
//st_Task.y = gb_details.y + 112
//st_User.y = gb_details.y + 112
//
//st_l2.y = gb_details.y + 176
//st_r2.y = gb_details.y + 176
//st_Status.y = gb_details.y + 176
//st_From.y = gb_details.y + 176
//
//st_l3.y = gb_details.y + 240
//st_r3.y = gb_details.y + 240
//st_Vsl.y = gb_details.y + 240
//st_To.y = gb_details.y + 240


end event

public subroutine of_drawcalender ();Integer li_Month, li_Temp, li_LeftEdge, li_RightEdge, li_Pos, li_CurDataRow, li_CurCalRow, li_RowTxtCount
String ls_CurVsl, ls_Error, ls_Vis, ls_Color, ls_X1, ls_Width, ls_Temp, ls_Text, ls_User
Date ld_Date, ld_From, ld_To
DatawindowChild ldwc_Insp, ldwc_Cal, ldwc_Task

SetPointer(HourGlass!)

dw_CalMain.SetRedraw(False)

li_Temp = dw_CalMain.GetChild("dw_Data", ldwc_Cal)
li_Temp = dw_CalMain.GetChild("dw_Task", ldwc_Task)

// Delete all rows
ldwc_Cal.Reset( )  
ldwc_Task.Reset( )

// If any text labels present, destroy all
If ii_numtxtitem > 0 then
	For li_Temp = 1 to ii_numtxtitem
		ldwc_Cal.Modify("destroy t_lbl" + String(li_Temp, "00"))
		ldwc_Cal.Modify("destroy t_usr" + String(li_Temp, "00"))
	Next 
	ii_numtxtitem = 0 // reset to zero
End If
If ii_numtaskitem > 0 then
	For li_Temp = 1 to ii_numtaskitem
		ldwc_Task.Modify("destroy t_lbl" + String(li_Temp, "00"))
		ldwc_Task.Modify("destroy t_usr" + String(li_Temp, "00"))		
	Next 
	ii_numtaskitem = 0 // reset to zero
End If

li_LeftEdge = Integer(ldwc_Cal.Describe("t_w01.x"))
li_RightEdge = Integer(ldwc_Cal.Describe("t_w26.x")) + Integer(ldwc_Cal.Describe("t_w26.width"))

// Set week numbers on the header
ld_Date = id_Start
For li_Temp = 1 to 26
	li_Pos = f_GetWeekNumber(ld_Date, li_Pos)
	ldwc_Cal.Modify("t_w" + String(li_Temp, "00") + ".Text = '" + String(li_Pos, "00") + "'")
	ldwc_Task.Modify("t_w" + String(li_Temp, "00") + ".Text = '" + String(li_Pos, "00") + "'")
	ld_Date = RelativeDate(ld_Date, 7)
Next

// Unhide last months and break indicators
ldwc_Cal.Modify("t_m6.Visible = '1'")
ldwc_Cal.Modify("t_m7.Visible = '1'")
ldwc_Cal.Modify("p_Left.Visible = '1'")
ldwc_Cal.Modify("p_Right.Visible = '1'")
ldwc_Task.Modify("t_m6.Visible = '1'")
ldwc_Task.Modify("t_m7.Visible = '1'")
ldwc_Task.Modify("p_Left.Visible = '1'")
ldwc_Task.Modify("p_Right.Visible = '1'")


// Set month headers
ld_Date = id_Start
li_Temp = 0  // counts the number of days from start
li_Month = 1 // start with the first month
ldwc_Cal.Modify("t_m" + String(li_Month) + ".Text = '" + String(ld_Date, "mmm yy") + "'")
ldwc_Task.Modify("t_m" + String(li_Month) + ".Text = '" + String(ld_Date, "mmm yy") + "'")
If Day(ld_Date) = 1 then 
	ld_Date = RelativeDate(ld_Date, 1)
	li_Temp++
End If
Do 
	Do While Day(ld_Date) > 1  // Loop to the first day of next month
		ld_Date = RelativeDate(ld_Date, 1)
		li_Temp++
	Loop
	li_Month ++    // Inc month
	ldwc_Cal.Modify("t_m" + String(li_Month) + ".Text = '" + String(ld_Date, "mmm yy") + "'")  // Set the month name
	ldwc_Task.Modify("t_m" + String(li_Month) + ".Text = '" + String(ld_Date, "mmm yy") + "'")  // Set the month name
	li_Pos = li_LeftEdge + ((li_Temp/182) * (li_RightEdge - li_LeftEdge))   // calculate left edge of month
	If li_Pos > li_RightEdge then // month is past the end
		li_Pos = li_RightEdge  // limit to right edge
		ldwc_Cal.Modify("t_m" + String(li_Month) + ".Text = ''")  // hide text
		ldwc_Task.Modify("t_m" + String(li_Month) + ".Text = ''")  // hide text
	Else
		If li_Pos = li_RightEdge then 
			ldwc_Cal.Modify("p_Right.Visible = '0'")  // Hide right line
  		ldwc_Task.Modify("p_Right.Visible = '0'") 
		End If
	End If
	ldwc_Cal.Modify("t_m" + String(li_Month) + ".X = '" + String(li_Pos) + "'")  // Set left edge
	ldwc_Task.Modify("t_m" + String(li_Month) + ".X = '" + String(li_Pos) + "'")
	li_Pos = li_Pos - Integer(ldwc_Cal.Describe("t_m" + String(li_Month - 1) + ".X")) + 1 // calc width
	ldwc_Cal.Modify("t_m" + String(li_Month - 1) + ".Width = '" + String(li_Pos) + "'") // set width
	ldwc_Task.Modify("t_m" + String(li_Month - 1) + ".Width = '" + String(li_Pos) + "'")
	If li_Pos < 160 then 
		ldwc_Cal.Modify("t_m" + String(li_Month - 1) + ".Text = ''")  // if width is too less, hide text
		ldwc_Task.Modify("t_m" + String(li_Month - 1) + ".Text = ''")  // if width is too less, hide text
	End If
	ld_Date = RelativeDate(ld_Date, 1)
	li_Temp++
Loop Until li_Month = 8

// Set left break
If (Day(id_Start) = 1) then 
	ldwc_Cal.Modify("p_Left.Visible = '0'")  // Hide left break indicator
	ldwc_Task.Modify("p_Left.Visible = '0'")
End If

// Set today pointer
li_Temp = DaysAfter(id_start, Today())
If (li_Temp < 183) and (li_Temp >= 0) then
	ldwc_Cal.Modify("p_Today.X = '" + String(li_LeftEdge - 22 + (li_Temp/182) * (li_RightEdge - li_LeftEdge)) + "'")  // Set visible
	ldwc_Task.Modify("p_Today.X = '" + String(li_LeftEdge - 22 + (li_Temp/182) * (li_RightEdge - li_LeftEdge)) + "'")  
	ldwc_Cal.Modify("p_Today.Visible = '1'")  // Set visible
	ldwc_Task.Modify("p_Today.Visible = '1'")
Else
	ldwc_Cal.Modify("p_Today.Visible = '0'")  // Hide
	ldwc_Task.Modify("p_Today.Visible = '0'")
End If

// Commence putting in vessels and data
li_CurDataRow = 1
li_CurCalRow = 0

if ids_caldata.rowcount() = 0 then messagebox("Info", "No Vessels")

Do While li_CurDataRow <= ids_CalData.RowCount()
	// create new vessels if necessary and reset all row data
	If ids_CalData.GetItemString(li_CurDataRow, "Vnum") <> ls_CurVsl then 
		li_CurCalRow = ldwc_Cal.InsertRow(0)
		ls_CurVsl = ids_CalData.GetItemString(li_CurDataRow, "Vnum")
		ldwc_Cal.SetItem(li_CurCalRow, "Vslno", ls_CurVsl)
		ldwc_Cal.SetItem(li_CurCalRow, "Vslname", ids_CalData.GetItemString(li_CurDataRow, "Vname"))
		ldwc_Cal.SetItem(li_CurCalRow, "Flag", ids_CalData.GetItemString(li_CurDataRow, "Flag"))
		ldwc_Cal.SetItem(li_CurCalRow, "Resp", ids_CalData.GetItemString(li_CurDataRow, "Resp"))
		li_RowTxtCount = 0
		ls_Vis = ""
		ls_Color = ""
		ls_X1 = ""
		ls_Text = ""
		ls_Width = ""
		ls_User = ""
	End If
	
	//  get the dates
	ld_From = ids_CalData.GetItemDate(li_CurDataRow, "StartMonday")
	ld_To = ids_CalData.GetItemDate(li_CurDataRow, "EndMonday")
	
	// If dates in range
	If ld_To >= id_Start and ld_From <= id_End then
		li_RowTxtCount++
		If li_RowTxtCount > ii_numtxtitem then  // If not enough text boxes, create new one
			// Create 2 boxes
			ls_Error = ldwc_Cal.Modify("create text(band=Detail color='0' alignment='0' border='2'"&
				+ " height.autosize=No pointer='Arrow!' visible='0 ~t If(Len(f_GetStringByIndex(tx_stat, " + String(ii_numtxtitem + 1) + "))>0,1,0)' moveable=0 resizeable=0 x='0 ~t "+String(li_LeftEdge)+"+(("+String(li_RightEdge - li_LeftEdge)+")/182*Integer(Mid(tx_x1,"+String(ii_numtxtitem*3+1)+",3)))'"&
				+ " y='64' height='40' width='0 ~t "+String(li_RightEdge - li_LeftEdge)+" /182 * Integer(Mid(tx_wd, "+String(ii_numtxtitem*3+1)+",3))' text='xx ~t f_GetStringByIndex(tx_stat, " + String(ii_numtxtitem + 1) + ")' "&
				+ " name=t_usr" + String(ii_numtxtitem + 1, "00") + " tag='' font.face='Small Fonts' font.height= '-7' font.weight='400' font.family='0' font.pitch='0' font.charset='0' font.italic='0'"&
				+ " font.strikethrough='0' font.underline='0' background.mode='0' background.color='16777215')")
			If ls_Error > "" then MessageBox("DW Modify Error", "Task Rectangle Error.~n~n" + ls_Error)			
			ls_Error = ldwc_Cal.Modify("create text(band=Detail color='0 ~t If(Long(f_GetStringByIndex(tx_color, " + String(ii_numtxtitem + 1) + "))=16777215, 8421504, 0)' alignment='0' border='2'"&
				+ " height.autosize=No pointer='Arrow!' visible='0 ~t Integer(Mid(tx_vis ," + String(ii_numtxtitem + 1, "0") + ", 1))' moveable=0 resizeable=0 x='0 ~t "+String(li_LeftEdge)+"+("+String((li_RightEdge - li_LeftEdge))+" / 182 * Integer(Mid(tx_x1,"+String(ii_numtxtitem*3+1)+",3)))'"&
				+ " y='4' height='60' width='0 ~t "+String(li_RightEdge - li_LeftEdge)+ " / 182 * Integer(Mid(tx_wd, "+String(ii_numtxtitem*3+1)+",3))' text='xx ~t f_GetStringByIndex(tx_text, " + String(ii_numtxtitem + 1) + ")' "&
				+ " name=t_lbl" + String(ii_numtxtitem + 1, "00") + " tag='' font.face='Arial Narrow' font.height= '-8' font.weight='400' font.family='0' font.pitch='0' font.charset='0' font.italic='0 ~t If(Long(f_GetStringByIndex(tx_color, " + String(ii_numtxtitem + 1) + "))=16777215, 1, 0)'"&
				+ " font.strikethrough='0' font.underline='0' background.mode='0' background.color='0 ~t Long(f_GetStringByIndex(tx_color, " + String(ii_numtxtitem + 1) + "))')")
			If ls_Error > "" then MessageBox("DW Modify Error", "Task Rectangle Error.~n~n" + ls_Error)
			ii_numtxtitem++  // Increment count for textboxes
		End If		
		ls_Vis += "1"
		If ld_From < id_Start then 
			ls_X1 += "000" 
			ls_Width += String(DaysAfter(id_Start, ld_To), "000")
		Else 
			ls_X1 += String(DaysAfter(id_Start, ld_From), "000")
			If ld_To > id_End then ls_Width += String(DaysAfter(ld_From, id_End), "000") Else ls_Width += String(DaysAfter(ld_From, ld_To), "000")		
		End If
		ls_Color += String(ids_CalData.GetItemNumber(li_CurDataRow, "StatColor")) + "°"
		ls_Text += Trim(ids_CalData.GetItemString(li_CurDataRow, "Tagname")) + "°"
		ls_Temp = ids_CalData.GetItemString(li_CurDataRow, "Inspector")
		If IsNull(ls_Temp) then ls_Temp = ""
		ls_User += ls_Temp + "°"
	End If
	li_CurDataRow ++
	
	ldwc_Cal.SetItem(li_CurCalRow, "tx_x1", ls_x1)
	ldwc_Cal.SetItem(li_CurCalRow, "tx_wd", ls_Width)
	ldwc_Cal.SetItem(li_CurCalRow, "tx_vis", ls_Vis)
	ldwc_Cal.SetItem(li_CurCalRow, "tx_color", ls_Color)
	ldwc_Cal.SetItem(li_CurCalRow, "tx_text", ls_Text)
	ldwc_Cal.SetItem(li_CurCalRow, "tx_stat", ls_User)
Loop 


// Commence putting in users and data
li_CurDataRow = 1
li_CurCalRow = 0
ls_CurVsl = ""

if ids_TaskData.rowcount() = 0 then Messagebox("Info", "No User Rows")

Do While li_CurDataRow <= ids_TaskData.RowCount()
	// create new users if necessary and reset all row data
	If ids_TaskData.GetItemString(li_CurDataRow, "UserID") <> ls_CurVsl then 
		li_CurCalRow = ldwc_Task.InsertRow(0)
		ls_CurVsl = ids_TaskData.GetItemString(li_CurDataRow, "UserID")
		ldwc_Task.SetItem(li_CurCalRow, "UserID", ls_CurVsl)
		ldwc_Task.SetItem(li_CurCalRow, "UserName", ids_TaskData.GetItemString(li_CurDataRow, "username"))
		li_RowTxtCount = 0
		ls_Vis = ""
		ls_Color = ""
		ls_X1 = ""
		ls_Text = ""
		ls_Width = ""
		ls_User = ""
	End If
	
	//  get the dates
	ld_From = ids_TaskData.GetItemDate(li_CurDataRow, "StartMonday")
	ld_To = ids_TaskData.GetItemDate(li_CurDataRow, "EndMonday")
	
	// If dates in range
	If ld_To >= id_Start and ld_From <= id_End then
		li_RowTxtCount++
		If li_RowTxtCount > ii_numtaskitem then  // If not enough text boxes, create new one
			// Create 2 boxes
			ls_Error = ldwc_Task.Modify("create text(band=Detail color='0' alignment='0' border='2'"&
				+ " height.autosize=No pointer='Arrow!' visible='0 ~t If(Len(f_GetStringByIndex(tx_stat, " + String(ii_numtaskitem + 1) + "))>0,1,0)' moveable=0 resizeable=0 x='0 ~t "+String(li_LeftEdge)+"+(("+String(li_RightEdge - li_LeftEdge)+")/182*Integer(Mid(tx_x1,"+String(ii_numtaskitem*3+1)+",3)))'"&
				+ " y='64' height='40' width='0 ~t "+String(li_RightEdge - li_LeftEdge)+" /182 * Integer(Mid(tx_wd, "+String(ii_numtaskitem*3+1)+",3))' text='xx ~t f_GetStringByIndex(tx_stat, " + String(ii_numtaskitem + 1) + ")' "&
				+ " name=t_usr" + String(ii_numtaskitem + 1, "00") + " tag='' font.face='Small Fonts' font.height= '-7' font.weight='400' font.family='0' font.pitch='0' font.charset='0' font.italic='0'"&
				+ " font.strikethrough='0' font.underline='0' background.mode='0' background.color='16777215')")
			If ls_Error > "" then MessageBox("DW Modify Error", "Task Rectangle Error.~n~n" + ls_Error)			
			ls_Error = ldwc_Task.Modify("create text(band=Detail color='0 ~t If(Long(f_GetStringByIndex(tx_color, " + String(ii_numtaskitem + 1) + "))=16777215, 8421504, 0)' alignment='0' border='2'"&
				+ " height.autosize=No pointer='Arrow!' visible='0 ~t Integer(Mid(tx_vis ," + String(ii_numtaskitem + 1, "0") + ", 1))' moveable=0 resizeable=0 x='0 ~t "+String(li_LeftEdge)+"+("+String((li_RightEdge - li_LeftEdge))+" / 182 * Integer(Mid(tx_x1,"+String(ii_numtaskitem*3+1)+",3)))'"&
				+ " y='4' height='60' width='0 ~t "+String(li_RightEdge - li_LeftEdge)+ " / 182 * Integer(Mid(tx_wd, "+String(ii_numtaskitem*3+1)+",3))' text='xx ~t f_GetStringByIndex(tx_text, " + String(ii_numtaskitem + 1) + ")' "&
				+ " name=t_lbl" + String(ii_numtaskitem + 1, "00") + " tag='' font.face='Arial Narrow' font.height= '-8' font.weight='400' font.family='0' font.pitch='0' font.charset='0' font.italic='0 ~t If(Long(f_GetStringByIndex(tx_color, " + String(ii_numtaskitem + 1) + "))=16777215, 1, 0)'"&
				+ " font.strikethrough='0' font.underline='0' background.mode='0' background.color='0 ~t Long(f_GetStringByIndex(tx_color, " + String(ii_numtaskitem + 1) + "))')")
			If ls_Error > "" then MessageBox("DW Modify Error", "Task Rectangle Error.~n~n" + ls_Error)
			ii_numtaskitem++  // Increment count for textboxes
		End If		
		ls_Vis += "1"
		If ld_From < id_Start then 
			ls_X1 += "000" 
			ls_Width += String(DaysAfter(id_Start, ld_To), "000")
		Else 
			ls_X1 += String(DaysAfter(id_Start, ld_From), "000")
			If ld_To > id_End then ls_Width += String(DaysAfter(ld_From, id_End), "000") Else ls_Width += String(DaysAfter(ld_From, ld_To), "000")		
		End If
		ls_Color += String(ids_TaskData.GetItemNumber(li_CurDataRow, "StatColor")) + "°"
		ls_Text += Trim(ids_TaskData.GetItemString(li_CurDataRow, "Tagname")) + "°"
		ls_Temp = ids_TaskData.GetItemString(li_CurDataRow, "VNum")
		If IsNull(ls_Temp) then ls_Temp = ""
		ls_User += ls_Temp + "°"
	End If
	li_CurDataRow ++
	
	ldwc_Task.SetItem(li_CurCalRow, "tx_x1", ls_x1)
	ldwc_Task.SetItem(li_CurCalRow, "tx_wd", ls_Width)
	ldwc_Task.SetItem(li_CurCalRow, "tx_vis", ls_Vis)
	ldwc_Task.SetItem(li_CurCalRow, "tx_color", ls_Color)
	ldwc_Task.SetItem(li_CurCalRow, "tx_text", ls_Text)
	ldwc_Task.SetItem(li_CurCalRow, "tx_stat", ls_User)
Loop 


dw_CalMain.SetRedraw(True)



end subroutine

private subroutine of_loaddata (date ad_start, date ad_end);// This function retrieves the data to be displayed on the calendar and populates week numbers

// The start and end dates will be one year prior and one year forward of the current week to
// prevent frequent retrievals

Integer li_Temp, li_Rows, li_New, li_Int
Date ld_Date, li_Jump
String ls_Tag, ls_Vsl

// Retrieve and filter
ids_CalData.Reset()
li_Temp = ids_Caldata.Retrieve(ad_Start, ad_End)

ids_Caldata.SetFilter(is_Filter)
ids_Caldata.Filter()

li_Rows = ids_CalData.RowCount()

// Add due dates to data
For li_Temp = 1 to li_Rows
	ls_Tag = Trim(ids_CalData.GetItemString(li_Temp, "TagName"))
	li_Int = ids_CalData.GetItemNumber(li_Temp, "Interval")
	If li_Int > 0 then  // If insp has interval
		ls_Vsl = ids_CalData.GetItemString(li_Temp, "VNum")
		li_New = ids_CalData.Find("TagName = '" + ls_Tag + "' and VNum = '" + ls_Vsl + "' and Interval > 0", li_Temp + 1, ids_CalData.RowCount() + 1)	
		If li_New = 0 then  // This is the last inspection of this type
			li_New = ids_CalData.InsertRow(0)
			ids_CalData.SetItem(li_New, "VNum", ls_Vsl)
			ids_CalData.SetItem(li_New, "TagName", ls_Tag)
			ids_CalData.SetItem(li_New, "StartDate", f_AddMonths(ids_CalData.GetItemDateTime(li_Temp, "StartDate"), li_Int))
			ids_CalData.SetItem(li_New, "EndDate", f_AddMonths(ids_CalData.GetItemDateTime(li_Temp, "EndDate"), li_Int))
			ids_CalData.SetItem(li_New, "StatColor", 16777215)
			ids_CalData.SetItem(li_New, "Interval", -1)
			ids_CalData.SetItem(li_New, "Inspector", "")
		End If
	End If
Next

li_Rows = ids_caldata.RowCount()

// Set startmondays and endsundays for all inspections
For li_Temp = 1 to li_Rows
	ld_Date = Date(ids_CalData.GetItemDateTime(li_Temp, "StartDate"))
	ld_Date = f_GetLastMonday(ld_Date)
	ids_CalData.SetItem(li_Temp, "StartMonday", ld_Date)
	ld_Date = Date(ids_CalData.GetItemDateTime(li_Temp, "EndDate"))
	ld_Date = RelativeDate(f_GetLastMonday(ld_Date), 7)
	ids_CalData.SetItem(li_Temp, "EndMonday", ld_Date)	
Next

ids_CalData.Sort()


// Get tasks
ids_TaskData.Reset()
ids_TaskData.Retrieve(ad_Start, ad_End)

li_Rows = ids_Taskdata.RowCount()

// Set startmondays and endsundays for all tasks
For li_Temp = 1 to li_Rows
	ld_Date = Date(ids_TaskData.GetItemDateTime(li_Temp, "StartDate"))
	//ld_Date = f_GetLastMonday(ld_Date)
	ids_TaskData.SetItem(li_Temp, "StartMonday", ld_Date)
	ld_Date = Date(ids_TaskData.GetItemDateTime(li_Temp, "EndDate"))
//	ld_Date = RelativeDate(f_GetLastMonday(ld_Date), 7)
  ld_Date = RelativeDate(ld_Date, 1)
	ids_TaskData.SetItem(li_Temp, "EndMonday", ld_Date)	
Next



end subroutine

public subroutine of_setweek (date ad_start);Boolean lbool_Reload
Integer li_Year, li_Week

id_Start = ad_Start

id_End = RelativeDate(id_Start, 181)     // Set end date 26 weeks after start

li_Week = f_GetWeekNumber(id_Start, li_Year)

st_Week.Text = String(li_Week, "00") + " / " + String(li_Year)  // set the label

If IsNull(id_DataStartDate) then lbool_Reload = True   // If no data, load data

If (id_Start < id_DataStartDate) or (id_End > id_DataEndDate) then lbool_Reload = True   // If calender has moved out of data buffer then reload data

If lbool_Reload then  // If data must be reloaded, set dates and reload
	id_DataStartDate = RelativeDate(id_Start, -365)   // -1 year
	id_DataEndDate = RelativeDate(id_Start, 365)      // +1 year
	of_LoadData(id_DataStartDate, id_DataEndDate)     // load data
End If

of_drawcalender()
end subroutine

public subroutine of_setfilter (string as_filter);
is_Filter = as_Filter
end subroutine

on vo_calweekdisp.create
this.cb_next1=create cb_next1
this.cb_prev1=create cb_prev1
this.cb_print=create cb_print
this.cb_next10=create cb_next10
this.cb_prev10=create cb_prev10
this.st_week=create st_week
this.st_1=create st_1
this.dw_calmain=create dw_calmain
this.Control[]={this.cb_next1,&
this.cb_prev1,&
this.cb_print,&
this.cb_next10,&
this.cb_prev10,&
this.st_week,&
this.st_1,&
this.dw_calmain}
end on

on vo_calweekdisp.destroy
destroy(this.cb_next1)
destroy(this.cb_prev1)
destroy(this.cb_print)
destroy(this.cb_next10)
destroy(this.cb_prev10)
destroy(this.st_week)
destroy(this.st_1)
destroy(this.dw_calmain)
end on

event constructor;DatawindowChild ldwc_Insp

// Create datastores
ids_CalData = Create DataStore
ids_TaskData = Create DataStore

SetNull(id_DataStartDate)
SetNull(id_DataEndDate)

is_Filter = ""

// Init datastores
ids_CalData.DataObject = "d_sq_tb_calweekall"
ids_CalData.SetTransObject(SQLCA)

ids_TaskData.DataObject = "d_sq_tb_calweektask"
ids_TaskData.SetTransObject(SQLCA)


end event

event destructor;
Destroy ids_CalData
Destroy ids_TaskData
end event

type cb_next1 from commandbutton within vo_calweekdisp
integer x = 1024
integer y = 32
integer width = 128
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "+1"
end type

event clicked;
id_Start = RelativeDate(id_Start, 7)

of_SetWeek(id_Start)
end event

type cb_prev1 from commandbutton within vo_calweekdisp
integer x = 512
integer y = 32
integer width = 128
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "-1"
end type

event clicked;
id_Start = RelativeDate(id_Start, -7)

of_SetWeek(id_Start)
end event

type cb_print from commandbutton within vo_calweekdisp
integer x = 2523
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
dw_CalMain.Print(True, True)
end event

type cb_next10 from commandbutton within vo_calweekdisp
integer x = 1152
integer y = 32
integer width = 137
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "+10"
end type

event clicked;
id_Start = RelativeDate(id_Start, 70)

of_SetWeek(id_Start)
end event

type cb_prev10 from commandbutton within vo_calweekdisp
integer x = 384
integer y = 32
integer width = 128
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "-10"
end type

event clicked;
id_Start = RelativeDate(id_Start, -70)

of_SetWeek(id_Start)
end event

type st_week from statictext within vo_calweekdisp
integer x = 640
integer y = 32
integer width = 384
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 67108864
string text = "00/2008"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within vo_calweekdisp
integer x = 18
integer y = 32
integer width = 347
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Start Week:"
boolean focusrectangle = false
end type

type dw_calmain from datawindow within vo_calweekdisp
event ue_mousemove pbm_dwnmousemove
integer x = 18
integer y = 128
integer width = 3035
integer height = 1728
integer taborder = 40
string title = "none"
string dataobject = "d_rep_calweekmain"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;
//Integer li_Row
//String ls_Index

// Get row number of source Datastore
//If (dwo.Type = "text") and (row>0) then
//	ls_Index = Right(dwo.Name,2)
//	li_Row = Integer(dw_Cal.Describe('Evaluate("f_GetStringByIndex(tx_rowindex, ' + ls_Index + ')",' + String(Row) + ')'))
//Else
//	li_Row = 0  // nothing under the mouse
//End If
//
// Check if not same as before
//If li_Row <> ii_RowHover then	
//	ii_RowHover = li_Row
//	
	// If something under the mouse
//	If li_Row > 0 then
//		st_task.Text = ids_CalData.GetItemString(li_Row, "taskname")
//		st_from.Text = String(ids_CalData.GetItemDate(li_Row, "fromdate"), "dd mmm yyyy")
//		st_to.Text = String(ids_CalData.GetItemDate(li_Row, "todate"), "dd mmm yyyy")
//		st_User.Text = ids_CalData.GetItemString(li_Row, "username")
//		st_Vsl.Text = ids_CalData.GetItemString(li_Row, "vslname")
//		Choose Case ids_CalData.GetItemNumber(li_Row, "statusval")
//			Case 0
//				ls_Index = "Tentative"
//			Case 1
//				ls_Index = "Fixed"
//			Case 2
//				ls_Index = "Re-Scheduled"
//			Case 3
//				ls_Index = "Completed"
//		End Choose
//		st_Status.Text = ls_Index
//	Else  // Otherwise make all blank
//		st_task.Text = ""
//		st_from.Text = ""
//		st_to.Text = ""
//		st_User.Text = ""
//		st_Vsl.Text = ""
//		st_Status.Text = ""
//	End If
//End If
end event

