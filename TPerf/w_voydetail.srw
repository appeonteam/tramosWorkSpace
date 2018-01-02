HA$PBExportHeader$w_voydetail.srw
forward
global type w_voydetail from window
end type
type cb_print from commandbutton within w_voydetail
end type
type cb_close from commandbutton within w_voydetail
end type
type dw_report from datawindow within w_voydetail
end type
end forward

global type w_voydetail from window
integer width = 3776
integer height = 2292
boolean titlebar = true
string title = "Voyage Leg Details"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "Information!"
boolean center = true
cb_print cb_print
cb_close cb_close
dw_report dw_report
end type
global w_voydetail w_voydetail

on w_voydetail.create
this.cb_print=create cb_print
this.cb_close=create cb_close
this.dw_report=create dw_report
this.Control[]={this.cb_print,&
this.cb_close,&
this.dw_report}
end on

on w_voydetail.destroy
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.dw_report)
end on

event open;datawindowchild dw_child
String ls_Return
Decimal{1} ld_min, ld_max, ld_val
Integer li_Count

dw_report.SetTransObject(SQLCA)

// Select correct logo on report
If g_userInfo.PC_Logo = 2 then  // If Handytankers
	dw_report.object.p_handy.Visible = 1
	dw_report.object.p_maersk.Visible = 0
	dw_report.object.t_company.Text = "Handytankers"
End If

dw_report.retrieve( g_parameters.voyageid)

If dw_report.GetChild( "dw_grspd", dw_Child) = 1 then
	
	// Determine the min and max speeds
	ld_max = 0
	ld_min = 50
	For li_Count = 1 to dw_child.Rowcount( )
		ld_val = dw_child.GetItemNumber( li_Count, "Spd")
		If ld_max < ld_val then ld_max = ld_val 
		If ld_Min > ld_val then ld_min = ld_val
		ld_val = dw_child.GetItemNumber( li_Count, "OrderVal")
		If Not IsNull(ld_Val) then
			If ld_max < ld_val then ld_max = ld_val 
			If ld_Min > ld_val then ld_min = ld_val
		End If					
	Next 
	ld_max = Ceiling(ld_max / 2) * 2 
	ld_min = Int(ld_min / 2) * 2	

	// If min and max is same
	if ld_max = ld_min then ld_max = ld_min + 4
	
	// If no sailing, then make range 0 to 20.
	If ld_min = 50 then 
		ld_min = 0
		ld_max = 20
	End If

	// Set max value
	ls_Return = dw_Child.Modify("gr_1.Values.MaximumValue=" + String(ld_max, "0"))
	If ls_Return > "" then MessageBox("Ret", ls_Return)
	
	// Set min value
	ls_Return = dw_Child.Modify("gr_1.Values.MinimumValue=" + String(ld_min, "0"))
	If ls_Return > "" then MessageBox("Ret", ls_Return)
	
	// Set the interval
	ls_Return = dw_Child.Modify("gr_1.Category.DisplayEveryNLabels=" + String(Int(dw_Child.Rowcount( ) / 10),"0"))
	If ls_Return > "" then MessageBox("Ret", ls_Return)
	
	// I need to write code here to modify the line colors of gr_1 and
	// also remove the symbols from the 'Ordered Speed' line (if present).
	
	// Somehow this is not possible in the current version of powerbuilder (11.2)
	
End If

If dw_report.GetChild( "dw_grcon", dw_Child) = 1 then
	
	// Determine the min and max consumption
	ld_max = 0
	ld_min = 300
	For li_Count = 1 to dw_child.Rowcount( )
		ld_val = dw_child.GetItemNumber( li_Count, "Cons")
		If ld_max < ld_val then ld_max = ld_val 
		If ld_Min > ld_val then ld_min = ld_val
		ld_val = dw_child.GetItemNumber( li_Count, "OrderVal")
		If Not IsNull(ld_Val) then
			If ld_max < ld_val then ld_max = ld_val 
			If ld_Min > ld_val then ld_min = ld_val
		End If			
	Next 
	ld_max = Ceiling(ld_max / 30) * 30
	ld_min = Int(ld_min / 30) * 30

	// If min and max is same
	if ld_max = ld_min then ld_max = ld_min + 10
	
	// If no sailing, then make range 0 to 50.
	If ld_min = 300 then 
		ld_min = 0
		ld_max = 50
	End If
  
	// Set max value
	ls_Return = dw_Child.Modify("gr_1.Values.MaximumValue=" + String(ld_max, "0"))
	If ls_Return > "" then MessageBox("Ret", ls_Return)
	
	// Set min value
	ls_Return = dw_Child.Modify("gr_1.Values.MinimumValue=" + String(ld_min, "0"))
	If ls_Return > "" then MessageBox("Ret", ls_Return)
	
	// Set the interval
	ls_Return = dw_Child.Modify("gr_1.Category.DisplayEveryNLabels=" + String(Int(dw_Child.Rowcount( ) / 10),"0"))
	If ls_Return > "" then MessageBox("Ret", ls_Return)
	
	// I need to write code here to modify the line colors of gr_1 and
	// also remove the symbols from the 'Ordered Consumption' line (if present).
	
	// Somehow this is not possible in the current version of powerbuilder (11.2)
	
End If
end event

event resize;Integer li_tmpx

dw_report.width = newwidth - dw_report.x * 2
dw_report.height = newheight - dw_report.y * 3 - cb_close.height

li_tmpx = (newwidth  - (cb_Print.width * 2)) / 3
if li_tmpx < 0 then li_tmpx = 0
cb_Print.x = li_tmpx
cb_Print.y = newheight - dw_report.y - cb_Print.height

li_tmpx = cb_print.width + li_tmpx * 2
If li_tmpx < cb_Print.x + cb_Print.width then li_tmpx = cb_print.x + cb_print.width

cb_close.x = li_tmpx

cb_close.y = cb_Print.y


end event

type cb_print from commandbutton within w_voydetail
integer x = 640
integer y = 2048
integer width = 603
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print"
end type

event clicked;
dw_report.Print(true, true)
end event

type cb_close from commandbutton within w_voydetail
integer x = 1920
integer y = 2048
integer width = 603
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;

close(parent)


end event

type dw_report from datawindow within w_voydetail
integer x = 18
integer y = 16
integer width = 3694
integer height = 1984
integer taborder = 10
string title = "none"
string dataobject = "d_ff_voyagedetail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

