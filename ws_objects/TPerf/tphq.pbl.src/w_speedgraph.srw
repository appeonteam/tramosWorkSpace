$PBExportHeader$w_speedgraph.srw
forward
global type w_speedgraph from window
end type
type rb_cons from radiobutton within w_speedgraph
end type
type rb_speed from radiobutton within w_speedgraph
end type
type st_msg from statictext within w_speedgraph
end type
type cbx_avg from checkbox within w_speedgraph
end type
type cbx_data from checkbox within w_speedgraph
end type
type st_warn from statictext within w_speedgraph
end type
type dw_vsl from datawindow within w_speedgraph
end type
type cb_print from commandbutton within w_speedgraph
end type
type cb_draw from commandbutton within w_speedgraph
end type
type dw_type from datawindow within w_speedgraph
end type
type ddlb_speed from dropdownlistbox within w_speedgraph
end type
type st_1 from statictext within w_speedgraph
end type
type lb_speed from listbox within w_speedgraph
end type
type st_speed from statictext within w_speedgraph
end type
type ddlb_sail from dropdownlistbox within w_speedgraph
end type
type st_period from statictext within w_speedgraph
end type
type ddlb_length from dropdownlistbox within w_speedgraph
end type
type st_2 from statictext within w_speedgraph
end type
type dw_graph from datawindow within w_speedgraph
end type
type gb_1 from groupbox within w_speedgraph
end type
type gb_2 from groupbox within w_speedgraph
end type
type st_limit from statictext within w_speedgraph
end type
type htb_limit from htrackbar within w_speedgraph
end type
type cbx_trend from checkbox within w_speedgraph
end type
type gb_3 from groupbox within w_speedgraph
end type
end forward

global type w_speedgraph from window
integer width = 4882
integer height = 2828
boolean titlebar = true
string title = "Vessel Speed Trend"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "H:\Tramos.Dev\Resource\TPerf\spdgraph.ico"
boolean center = true
rb_cons rb_cons
rb_speed rb_speed
st_msg st_msg
cbx_avg cbx_avg
cbx_data cbx_data
st_warn st_warn
dw_vsl dw_vsl
cb_print cb_print
cb_draw cb_draw
dw_type dw_type
ddlb_speed ddlb_speed
st_1 st_1
lb_speed lb_speed
st_speed st_speed
ddlb_sail ddlb_sail
st_period st_period
ddlb_length ddlb_length
st_2 st_2
dw_graph dw_graph
gb_1 gb_1
gb_2 gb_2
st_limit st_limit
htb_limit htb_limit
cbx_trend cbx_trend
gb_3 gb_3
end type
global w_speedgraph w_speedgraph

type variables

Byte ib_Length = 3, ib_Sail = 1, ib_Speed = 2


end variables

forward prototypes
public subroutine wf_generategraph ()
public subroutine wf_getdata (ref datastore ads_data, long al_vesselid, date ad_start)
public subroutine wf_smooth (ref datastore ads_data, string as_datacol)
end prototypes

public subroutine wf_generategraph ();// This function draws the whole graph

Integer li_Temp, li_Loop, li_Height, li_Width, li_X, li_Y, li_Year, li_Month, li_NumDays
Date ldt_Date
String ls_DataCol

// Get sizes. Remember to change if you change X or Y axis position in DW.
li_Width = 1020
li_Height = 600
li_X = 40
li_Y = 700

dw_graph.DataObject = "d_rep_speedgraph"   // This erases all lines and text
dw_graph.Modify("Datawindow.Print.Preview='Yes'")

// Select correct logo on report
If g_userInfo.PC_Logo = 2 then  // If Handytankers
	dw_graph.object.p_handy.Visible = 1
	dw_graph.object.p_maersk.Visible = 0
End If

dw_Graph.SetRedraw(False)  // Disable redraw of DW

// Calculate start date
li_Month = Month(Today())
li_Year = Year(Today())
li_Temp = ib_Length * 6 + 6    // li_Temp hold number of months
For li_Loop = li_Temp to 1 Step -1
	li_Month --
	If li_Month = 0 then
		li_Year --
		li_Month = 12
	End If
Next
ldt_Date = Date(li_Year, li_Month, 1)

// Get number of days in graph
li_NumDays = DaysAfter(ldt_Date, Today())

// ======= Draw the X-Axis ticks and labels =======
For li_Loop = 1 to li_NumDays
	ldt_Date = RelativeDate(ldt_Date, 1)
	If Day(ldt_Date) = 1 then
		f_DrawOnDW(dw_Graph, 40 + li_Loop * li_Width / li_NumDays, 701, 0, 4, 0, 1, 0)
		f_WriteOnDW(dw_Graph, 40 + (li_Loop - 30) * li_Width / li_NumDays, 701, li_Width / li_NumDays * 30, String(RelativeDate(ldt_Date, -1), "mmmyy"), 0)
	End If
Next

ldt_Date = RelativeDate(ldt_Date, -li_NumDays)  // revert to start date

// Set labels
If rb_Cons.Checked Then 
	dw_Graph.Modify("t_Title.Text = 'Vessel Consumption Trend'")  
	dw_Graph.Modify("t_YAxisLabel.Text = 'Consumption --->'")  
	ls_DataCol = "AvgCon"
Else
	dw_Graph.Modify("t_Title.Text = 'Vessel Speed Trend'")  
	dw_Graph.Modify("t_YAxisLabel.Text = 'Speed --->'")  
	ls_DataCol = "Speed"
End If

// Loop thru DW to find vessels, get data for each vessel and draw graph
Integer li_Vsl = 0, li_VesselID
Long ll_Color, ll_Pix, ll_MinY, ll_RangeY
String ls_SQL
Datastore lds_Speed[]

li_Vsl = 0
ll_MinY = 10000
ll_RangeY = 0
For li_Loop = 1 to dw_Vsl.RowCount( )
	If dw_Vsl.IsSelected(li_Loop) Then
		li_Vsl ++
		lds_Speed[li_Vsl] = Create Datastore
		lds_Speed[li_Vsl].DataObject = "d_sq_tb_vslspdcon"
		lds_Speed[li_Vsl].SetTransObject(SQLCA)
		wf_GetData(lds_Speed[li_Vsl], dw_Vsl.GetItemNumber(li_Loop, "Vessel_ID"), ldt_Date)
		For ll_Pix = 1 to lds_Speed[li_Vsl].RowCount()
			ll_Color = Int(lds_Speed[li_Vsl].GetItemNumber(ll_Pix, ls_DataCol))
			If ll_Color < ll_MinY then ll_MinY = ll_Color
			If ll_Color > ll_RangeY then ll_RangeY = ll_Color
		Next
	End If
Next

// Init Y axis scale
If ll_MinY = 10000 then ll_MinY = 0
ll_MinY = Int(ll_MinY / 10) * 10
ll_RangeY = Int(ll_RangeY / 10) * 10 + 10
ll_RangeY -= ll_MinY
dw_Graph.SetItem(1, "ymin", ll_MinY)
dw_Graph.SetItem(1, "yrng", ll_RangeY)

li_Vsl = 0
For li_Loop = 1 to dw_Vsl.RowCount()
	If dw_Vsl.IsSelected(li_Loop) then   // If vessel is selected
		li_Vsl ++
		li_VesselID = dw_Vsl.GetItemNumber(li_Loop, "Vessel_ID")
		dw_graph.Modify("vname" + String(li_Vsl) + ".text = '" + dw_Vsl.GetItemString(li_Loop, "Vessel_Nr") + " - " + dw_Vsl.GetItemString(li_Loop, "Vessel_Name") + "'")
		dw_graph.Modify("vname" + String(li_Vsl) + ".visible = '1'")
		dw_graph.Modify("r_" + String(li_Vsl) + ".visible = '1'")
		
		ll_Color = Long(dw_graph.Describe("r_" + String(li_Vsl) + ".Brush.Color"))
		
		If cbx_Data.Checked then   // If data points are selected
			For li_Temp = 1 to lds_Speed[li_Vsl].RowCount( )
				ll_Pix = li_X + (lds_Speed[li_Vsl].GetItemNumber(li_Temp, "daysdiff") * li_Width / li_NumDays)				
				f_DrawOnDW(dw_Graph, ll_Pix, li_Y - ((lds_Speed[li_Vsl].GetItemNumber(li_Temp, ls_DataCol) - ll_MinY) / ll_RangeY * li_Height), 0, 0, ll_Color, 2, 0)
			Next
		End If
		
		If cbx_Avg.Checked then   // If average is selected
			ll_Pix = (lds_Speed[li_Vsl].GetItemNumber(lds_Speed[li_Vsl].RowCount(), "daysdiff") * li_Width / li_NumDays) - (lds_Speed[li_Vsl].GetItemNumber(1, "daysdiff") * li_Width / li_NumDays)
			f_DrawOnDW(dw_Graph, li_X + (lds_Speed[li_Vsl].GetItemNumber(1, "daysdiff") * li_Width / li_NumDays), li_Y - ((lds_Speed[li_Vsl].GetItemNumber(1, "Overall" + ls_DataCol)-ll_MinY) / ll_RangeY * li_Height), ll_Pix, 0, ll_Color, 0, 2)
		End If
		
		If cbx_Trend.Checked then  // If smooth curve is selected
			If lds_Speed[li_Vsl].RowCount() < 50 then
				Messagebox("Insufficient Data", "There isn't sufficient data to generate a meaningful trend curve for vessel " + dw_Vsl.GetItemString(li_Loop, "Vessel_Name") + ".~n~nThe trend curve for this vessel will not be displayed.", Information!)
			Else
				wf_Smooth(lds_Speed[li_Vsl], ls_DataCol)
				For li_Temp = 1 to lds_Speed[li_Vsl].RowCount( )
					ll_Pix = li_X + (lds_Speed[li_Vsl].GetItemNumber(li_Temp, "daysdiff") * li_Width / li_NumDays)
					f_DrawOnDW(dw_Graph, ll_Pix, li_Y - ((lds_Speed[li_Vsl].GetItemNumber(li_Temp, "AvgCalc") - ll_MinY) / ll_RangeY * li_Height), 0, 0, ll_Color, 4, 0)
				Next							
			End If

		End If
		
		Destroy lds_Speed[li_Vsl]
	End If
Next

dw_Graph.SetRedraw(True)   // Refresh DW


end subroutine

public subroutine wf_getdata (ref datastore ads_data, long al_vesselid, date ad_start);// This function retrieves all data for a vessel based on the filters and returns it in the datastore

String ls_SQL, ls_Temp = "Sailing Type: "
Integer li_Temp
	
ls_SQL = "SELECT UTC, Sum(PERIOD) T_PERIOD, Sum(DIST) T_DIST, 0.000 as AVGCALC, Sum (MEHFO+MEDO+MELSHFO+MEGO) as T_CON FROM TPERF_VOY Inner Join TPERF_REPORTS On TPERF_REPORTS.VOY_ID = TPERF_VOY.VOY_ID Inner Join TPERF_SAILDATA On TPERF_REPORTS.REP_ID = TPERF_SAILDATA.REP_ID "
ls_SQL += "Where (VESSEL_ID = :VesselID) and (UTC>=:StartDate) "

If lb_Speed.TotalSelected( ) < 5 then
	ls_SQL += " And TPERF_SAILDATA.TYPE In ("
	For li_Temp = 1 to 5
		If lb_Speed.State(li_Temp)=1 then
			ls_SQL += String(li_Temp - 1) + ","
			If li_Temp = 0 then ls_Temp += "Full, "
			If li_Temp = 1 then ls_Temp += "Eco, "
			If li_Temp = 2 then ls_Temp += "Adj, "
			If li_Temp = 3 then ls_Temp += "Conf, "
			If li_Temp = 4 then ls_Temp += "Bad Wx, "
		End If
	Next
	ls_SQL = Left(ls_SQL, Len(ls_SQL) - 1) + ")"
	ls_Temp = Left(ls_Temp , Len(ls_Temp) - 2)
Else
	ls_Temp = "Full, Eco, Adj, Conf, Bad Wx"
End If
dw_graph.Object.t_SailType.Text = ls_Temp

ls_SQL += " Group By UTC Order By UTC"

ads_Data.Reset()
ads_Data.SetSQLSelect(ls_SQL)
li_Temp = ads_Data.Retrieve(al_VesselID, Datetime(ad_Start))

ls_SQL = ""

If ib_Sail > 1 then
	ls_SQL = " (T_Period >= "
	Choose Case ib_Sail
		Case 2
			ls_SQL += "6.0)"
			dw_graph.Object.t_Period.Text = "Sailing over 6 hours only"
		Case 3
			ls_SQL += "12.0)"
			dw_graph.Object.t_Period.Text = "Sailing over 12 hours only"
		Case 4
			ls_SQL += "20.0)"
			dw_graph.Object.t_Period.Text = "Sailing over 20 hours only"
	End Choose
Else
	dw_graph.Object.t_Period.Text = "Any sailing period"
End If

If ls_SQL > "" then ls_SQL += " And "
ls_SQL += "(Speed>=" + String(ib_Speed * 2 + 8, "0.0") + ")"
dw_graph.Object.t_Speed.Text = "Speed over " + String(ib_Speed * 2 + 8, "0") + " knots only"

ads_Data.SetFilter(ls_SQL)
ads_Data.Filter()

end subroutine

public subroutine wf_smooth (ref datastore ads_data, string as_datacol);// Perform curve smoothing using LOESS algorithm

Integer li_Temp, li_X, li_X2, li_Loop
Double Distance[], Weight[], maxDist, SumWts, SumWtX, SumWtX2, SumWtY, SumWtXY
Double WLRSlope, WLRIntercept, Denom, li_Y, li_Y2
Integer li_Limit, li_S1, li_S2

li_Limit = htb_Limit.Position

For li_Temp = 1 to ads_Data.RowCount()
	
	li_X = ads_Data.GetItemNumber(li_Temp, "daysdiff")
	li_Y = ads_Data.GetItemNumber(li_Temp, as_DataCol)

	// Calc data subset
	li_S1 = li_Temp - li_Limit
	li_S2 = li_Temp + li_Limit
	If li_S1<1 then li_S1 = 1	
	If li_S2 > ads_data.RowCount() then li_S2 = ads_data.RowCount()

	// Calc distance and max dist
	maxDist = -1
	For li_Loop = li_S1 to li_S2
		li_X2 = ads_Data.GetItemNumber(li_Loop, "daysdiff")
		li_Y2 = ads_Data.GetItemNumber(li_Loop, as_DataCol)
		Distance[li_Loop] = sqrt((li_X - li_X2)^2 + (li_Y - li_Y2)^2)
		If Distance[li_Loop] > maxDist then maxDist = Distance[li_Loop]
	Next
	
	//Calc scaled distances
	For li_Loop = li_S1 to li_S2
		Distance[li_Loop] = (1 - (Distance[li_Loop] / maxDist) ^ 3) ^ 3
	Next

	SumWts = 0 
	SumWtX = 0 
	SumWtX2 = 0 
	SumWtY = 0 
	SumWtXY = 0

	For li_Loop = li_S1 to li_S2
		li_X2 = ads_Data.GetItemNumber(li_Loop, "daysdiff")
		li_Y2 = ads_Data.GetItemNumber(li_Loop, as_DataCol)
		SumWts = SumWts + Distance[li_Loop]
		SumWtX = SumWtX + li_X2 * Distance[li_Loop]
		SumWtX2 = SumWtX2 + (li_X2 ^ 2) * Distance[li_Loop]
		SumWtY = SumWtY + li_Y2 * Distance[li_Loop]
		SumWtXY = SumWtXY + li_X2 * li_Y2 * Distance[li_Loop]
	Next
	Denom = SumWts * SumWtX2 - SumWtX ^ 2

	//Calculate the regression coefficients, and finally the loess value
	WLRSlope = (SumWts * SumWtXY - SumWtX * SumWtY) / Denom
	WLRIntercept = (SumWtX2 * SumWtY - SumWtX * SumWtXY) / Denom 
	
	ads_Data.SetItem(li_Temp, "AvgCalc", WLRSlope * li_X + WLRIntercept)
	
Next


	
end subroutine

on w_speedgraph.create
this.rb_cons=create rb_cons
this.rb_speed=create rb_speed
this.st_msg=create st_msg
this.cbx_avg=create cbx_avg
this.cbx_data=create cbx_data
this.st_warn=create st_warn
this.dw_vsl=create dw_vsl
this.cb_print=create cb_print
this.cb_draw=create cb_draw
this.dw_type=create dw_type
this.ddlb_speed=create ddlb_speed
this.st_1=create st_1
this.lb_speed=create lb_speed
this.st_speed=create st_speed
this.ddlb_sail=create ddlb_sail
this.st_period=create st_period
this.ddlb_length=create ddlb_length
this.st_2=create st_2
this.dw_graph=create dw_graph
this.gb_1=create gb_1
this.gb_2=create gb_2
this.st_limit=create st_limit
this.htb_limit=create htb_limit
this.cbx_trend=create cbx_trend
this.gb_3=create gb_3
this.Control[]={this.rb_cons,&
this.rb_speed,&
this.st_msg,&
this.cbx_avg,&
this.cbx_data,&
this.st_warn,&
this.dw_vsl,&
this.cb_print,&
this.cb_draw,&
this.dw_type,&
this.ddlb_speed,&
this.st_1,&
this.lb_speed,&
this.st_speed,&
this.ddlb_sail,&
this.st_period,&
this.ddlb_length,&
this.st_2,&
this.dw_graph,&
this.gb_1,&
this.gb_2,&
this.st_limit,&
this.htb_limit,&
this.cbx_trend,&
this.gb_3}
end on

on w_speedgraph.destroy
destroy(this.rb_cons)
destroy(this.rb_speed)
destroy(this.st_msg)
destroy(this.cbx_avg)
destroy(this.cbx_data)
destroy(this.st_warn)
destroy(this.dw_vsl)
destroy(this.cb_print)
destroy(this.cb_draw)
destroy(this.dw_type)
destroy(this.ddlb_speed)
destroy(this.st_1)
destroy(this.lb_speed)
destroy(this.st_speed)
destroy(this.ddlb_sail)
destroy(this.st_period)
destroy(this.ddlb_length)
destroy(this.st_2)
destroy(this.dw_graph)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.st_limit)
destroy(this.htb_limit)
destroy(this.cbx_trend)
destroy(this.gb_3)
end on

event open;
ddlb_Length.SelectItem(3)
ddlb_Sail.SelectItem(1)
ddlb_Speed.SelectItem(2)
lb_Speed.SetState(1, True)

dw_type.SetTransObject(SQLCA)
dw_type.Retrieve(g_UserInfo.UserID)

dw_vsl.SetTransObject(SQLCA)

dw_graph.Modify("Datawindow.Print.Preview='Yes'")
end event

event resize;
dw_Graph.Width = This.WorkSpaceWidth( ) - dw_Graph.X * 2
dw_Graph.Height = This.WorkSpaceHeight( ) - dw_Graph.Y - dw_Graph.X

cb_Draw.X = (This.WorkSpaceWidth( ) - cb_Draw.Width) / 2
cb_Print.X = This.Workspacewidth( ) - cb_Print.Width - dw_Graph.X
If cb_Print.X < cb_Draw.X + cb_draw.Width then cb_print.X = cb_draw.X + cb_draw.width

end event

type rb_cons from radiobutton within w_speedgraph
integer x = 750
integer y = 16
integer width = 389
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consumption"
end type

event clicked;
Parent.Title = "Vessel Consumption Trend"
end event

type rb_speed from radiobutton within w_speedgraph
integer x = 475
integer y = 16
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Speed"
boolean checked = true
end type

event clicked;
Parent.Title = "Vessel Consumption Trend"
end event

type st_msg from statictext within w_speedgraph
boolean visible = false
integer x = 1920
integer y = 1104
integer width = 1298
integer height = 112
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
string text = "Computing graph. Please wait..."
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cbx_avg from checkbox within w_speedgraph
integer x = 3785
integer y = 192
integer width = 384
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Average"
boolean checked = true
end type

type cbx_data from checkbox within w_speedgraph
integer x = 3785
integer y = 112
integer width = 366
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Data Points"
boolean checked = true
end type

type st_warn from statictext within w_speedgraph
integer x = 3273
integer y = 16
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "( Selected 0 of 5 )"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_vsl from datawindow within w_speedgraph
integer x = 2706
integer y = 96
integer width = 969
integer height = 336
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_vslsel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
If Row>0 then 

	Integer li_Count = 0, li_Rows

	For li_Rows = 1 to This.RowCount( )
		If This.IsSelected(li_Rows) then li_Count ++
	Next

	If This.IsSelected(Row) then
		This.SelectRow(Row, False)
		st_Warn.Text = "( Selected " + String(li_Count - 1) + " of 5 )"
	Else
		If li_Count < 5 then 
			This.SelectRow( Row, True)
			st_Warn.Text = "( Selected " + String(li_Count + 1) + " of 5 )"
		End If
	End If
	
End If
end event

type cb_print from commandbutton within w_speedgraph
integer x = 1097
integer y = 480
integer width = 274
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print..."
end type

event clicked;
dw_graph.Print(True,True)
end event

type cb_draw from commandbutton within w_speedgraph
integer x = 18
integer y = 480
integer width = 1079
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generate Graph"
end type

event clicked;
If lb_Speed.TotalSelected( ) = 0 then 
	Messagebox("Sailing Type Selection", "You must select at least one type of sailing.", Exclamation!)
	Return
End If

If dw_Vsl.Rowcount( ) = 0 then
	Messagebox("Vessel Selection", "You must select one or more ship types to display the list of vessels.", Exclamation!)
	Return
End If

If Pos(st_Warn.Text, "0") > 0 then
	Messagebox("Vessel Selection", "You must select one or more vessels to display.", Exclamation!)
	Return	
End If

If Not (cbx_Data.Checked or cbx_Avg.Checked or cbx_trend.Checked) then
	Messagebox("Display Options", "You must select something to display on the graph.", Exclamation!)
	Return
End If

st_msg.Visible = True

SetPointer(HourGlass!)

wf_GenerateGraph()

st_msg.Visible = False
end event

type dw_type from datawindow within w_speedgraph
integer x = 1957
integer y = 96
integer width = 731
integer height = 336
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_vtype"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Long ll_VslType[], ll_Count = 1, li_Loop

If Row>0 then 
	This.SelectRow(row, Not This.IsSelected( row))
	For li_Loop = 1 to This.RowCount( )
		If This.IsSelected(li_Loop) then 
			ll_VslType[ll_Count] = This.GetItemNumber(li_Loop, "TypeID")
			ll_Count ++
		End If
	Next
	If ll_Count = 1 then
		dw_Vsl.Reset()
	Else
		dw_Vsl.Retrieve(g_userinfo.Userid, ll_VslType)
	End If
	st_Warn.Text = "( Selected 0 of 5 )"
End If
end event

type ddlb_speed from dropdownlistbox within w_speedgraph
integer x = 384
integer y = 336
integer width = 603
integer height = 560
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"10 knots and above","12 knots and above","14 knots and above","16 knots and above"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ib_Speed = index
end event

type st_1 from statictext within w_speedgraph
integer x = 91
integer y = 352
integer width = 297
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Daily Speed:"
boolean focusrectangle = false
end type

type lb_speed from listbox within w_speedgraph
integer x = 1262
integer y = 112
integer width = 603
integer height = 304
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
boolean multiselect = true
string item[] = {"Full Speed","Economical Speed","Adjusted Speed","Confined Waters","Bad Weather"}
borderstyle borderstyle = stylelowered!
end type

type st_speed from statictext within w_speedgraph
integer x = 1024
integer y = 128
integer width = 242
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sail Type:"
boolean focusrectangle = false
end type

type ddlb_sail from dropdownlistbox within w_speedgraph
integer x = 384
integer y = 224
integer width = 603
integer height = 560
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Any Sailing","Over 6 hrs only","Over 12 hrs only","Over 20 hrs only"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ib_Sail = index
end event

type st_period from statictext within w_speedgraph
integer x = 91
integer y = 240
integer width = 297
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Daily Period:"
boolean focusrectangle = false
end type

type ddlb_length from dropdownlistbox within w_speedgraph
integer x = 384
integer y = 112
integer width = 603
integer height = 560
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Last 1 Year","Last 1.5 Years","Last 2 Years","Last 2.5 Years"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ib_Length = index
end event

type st_2 from statictext within w_speedgraph
integer x = 91
integer y = 128
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Length:"
boolean focusrectangle = false
end type

type dw_graph from datawindow within w_speedgraph
integer x = 18
integer y = 608
integer width = 4041
integer height = 2096
integer taborder = 10
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieverow;
yield()
end event

type gb_1 from groupbox within w_speedgraph
integer x = 18
integer y = 16
integer width = 1883
integer height = 448
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Data Selection:      "
end type

type gb_2 from groupbox within w_speedgraph
integer x = 1920
integer y = 16
integer width = 1792
integer height = 448
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Selection"
end type

type st_limit from statictext within w_speedgraph
integer x = 3858
integer y = 384
integer width = 288
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
long textcolor = 33554432
long backcolor = 67108864
string text = "Smoothness"
alignment alignment = center!
boolean focusrectangle = false
end type

type htb_limit from htrackbar within w_speedgraph
integer x = 3858
integer y = 336
integer width = 293
integer height = 80
integer minposition = 25
integer maxposition = 200
integer position = 150
integer tickfrequency = 10
htickmarks tickmarks = hticksonneither!
end type

type cbx_trend from checkbox within w_speedgraph
integer x = 3785
integer y = 272
integer width = 384
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trend curve"
boolean checked = true
end type

event clicked;
htb_Limit.Visible = This.Checked
st_Limit.Visible = This.Checked
end event

type gb_3 from groupbox within w_speedgraph
integer x = 3730
integer y = 16
integer width = 603
integer height = 448
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Display Options"
end type

