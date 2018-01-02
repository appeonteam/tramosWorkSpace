HA$PBExportHeader$w_vslgraph.srw
forward
global type w_vslgraph from window
end type
type cb_generate from commandbutton within w_vslgraph
end type
type st_to from statictext within w_vslgraph
end type
type dp_from from datepicker within w_vslgraph
end type
type rb_date from radiobutton within w_vslgraph
end type
type ddlb_period from dropdownlistbox within w_vslgraph
end type
type ddlb_year from dropdownlistbox within w_vslgraph
end type
type rb_period from radiobutton within w_vslgraph
end type
type rb_year from radiobutton within w_vslgraph
end type
type cb_sailnone from commandbutton within w_vslgraph
end type
type cb_sailall from commandbutton within w_vslgraph
end type
type lb_sail from listbox within w_vslgraph
end type
type cb_invyard from commandbutton within w_vslgraph
end type
type cb_noneyard from commandbutton within w_vslgraph
end type
type cb_allyard from commandbutton within w_vslgraph
end type
type dw_yard from datawindow within w_vslgraph
end type
type cb_invown from commandbutton within w_vslgraph
end type
type cb_noneown from commandbutton within w_vslgraph
end type
type cb_allown from commandbutton within w_vslgraph
end type
type dw_owner from datawindow within w_vslgraph
end type
type rb_cons from radiobutton within w_vslgraph
end type
type rb_spd from radiobutton within w_vslgraph
end type
type st_2 from statictext within w_vslgraph
end type
type st_1 from statictext within w_vslgraph
end type
type cb_typeinv from commandbutton within w_vslgraph
end type
type cb_typenone from commandbutton within w_vslgraph
end type
type cb_typeall from commandbutton within w_vslgraph
end type
type dw_type from datawindow within w_vslgraph
end type
type cb_close from commandbutton within w_vslgraph
end type
type cb_print from commandbutton within w_vslgraph
end type
type dw_voy from datawindow within w_vslgraph
end type
type gb_1 from groupbox within w_vslgraph
end type
type gb_2 from groupbox within w_vslgraph
end type
type gb_period from groupbox within w_vslgraph
end type
type dp_to from datepicker within w_vslgraph
end type
type st_wait from statictext within w_vslgraph
end type
end forward

global type w_vslgraph from window
integer width = 4119
integer height = 2624
boolean titlebar = true
string title = "Performance Graphs"
boolean controlmenu = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "Report5!"
boolean center = true
cb_generate cb_generate
st_to st_to
dp_from dp_from
rb_date rb_date
ddlb_period ddlb_period
ddlb_year ddlb_year
rb_period rb_period
rb_year rb_year
cb_sailnone cb_sailnone
cb_sailall cb_sailall
lb_sail lb_sail
cb_invyard cb_invyard
cb_noneyard cb_noneyard
cb_allyard cb_allyard
dw_yard dw_yard
cb_invown cb_invown
cb_noneown cb_noneown
cb_allown cb_allown
dw_owner dw_owner
rb_cons rb_cons
rb_spd rb_spd
st_2 st_2
st_1 st_1
cb_typeinv cb_typeinv
cb_typenone cb_typenone
cb_typeall cb_typeall
dw_type dw_type
cb_close cb_close
cb_print cb_print
dw_voy dw_voy
gb_1 gb_1
gb_2 gb_2
gb_period gb_period
dp_to dp_to
st_wait st_wait
end type
global w_vslgraph w_vslgraph

type variables


Integer ii_profit[], ii_vtype[], ii_owner[], ii_yard[], ii_sail[]
Date idt_From, idt_To
Integer ii_Period = 12


end variables

forward prototypes
public subroutine wf_retrievenext (ref datawindow adw_parent, ref datawindow adw_child, string as_parentcolumn)
end prototypes

public subroutine wf_retrievenext (ref datawindow adw_parent, ref datawindow adw_child, string as_parentcolumn);
Integer li_PC[], li_Count, li_Index

li_Index = 0
li_Count = 0

Do
	li_Count = adw_Parent.GetSelectedRow(li_Count)
	If li_Count > 0 then
		li_Index ++
		li_PC[li_Index] = adw_Parent.GetItemNumber(li_Count, as_ParentColumn)
	End If
Loop Until li_Count = 0

adw_Child.Reset()

If li_Index > 0 then adw_Child.Retrieve(li_PC, g_UserInfo.UserID )


end subroutine

on w_vslgraph.create
this.cb_generate=create cb_generate
this.st_to=create st_to
this.dp_from=create dp_from
this.rb_date=create rb_date
this.ddlb_period=create ddlb_period
this.ddlb_year=create ddlb_year
this.rb_period=create rb_period
this.rb_year=create rb_year
this.cb_sailnone=create cb_sailnone
this.cb_sailall=create cb_sailall
this.lb_sail=create lb_sail
this.cb_invyard=create cb_invyard
this.cb_noneyard=create cb_noneyard
this.cb_allyard=create cb_allyard
this.dw_yard=create dw_yard
this.cb_invown=create cb_invown
this.cb_noneown=create cb_noneown
this.cb_allown=create cb_allown
this.dw_owner=create dw_owner
this.rb_cons=create rb_cons
this.rb_spd=create rb_spd
this.st_2=create st_2
this.st_1=create st_1
this.cb_typeinv=create cb_typeinv
this.cb_typenone=create cb_typenone
this.cb_typeall=create cb_typeall
this.dw_type=create dw_type
this.cb_close=create cb_close
this.cb_print=create cb_print
this.dw_voy=create dw_voy
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_period=create gb_period
this.dp_to=create dp_to
this.st_wait=create st_wait
this.Control[]={this.cb_generate,&
this.st_to,&
this.dp_from,&
this.rb_date,&
this.ddlb_period,&
this.ddlb_year,&
this.rb_period,&
this.rb_year,&
this.cb_sailnone,&
this.cb_sailall,&
this.lb_sail,&
this.cb_invyard,&
this.cb_noneyard,&
this.cb_allyard,&
this.dw_yard,&
this.cb_invown,&
this.cb_noneown,&
this.cb_allown,&
this.dw_owner,&
this.rb_cons,&
this.rb_spd,&
this.st_2,&
this.st_1,&
this.cb_typeinv,&
this.cb_typenone,&
this.cb_typeall,&
this.dw_type,&
this.cb_close,&
this.cb_print,&
this.dw_voy,&
this.gb_1,&
this.gb_2,&
this.gb_period,&
this.dp_to,&
this.st_wait}
end on

on w_vslgraph.destroy
destroy(this.cb_generate)
destroy(this.st_to)
destroy(this.dp_from)
destroy(this.rb_date)
destroy(this.ddlb_period)
destroy(this.ddlb_year)
destroy(this.rb_period)
destroy(this.rb_year)
destroy(this.cb_sailnone)
destroy(this.cb_sailall)
destroy(this.lb_sail)
destroy(this.cb_invyard)
destroy(this.cb_noneyard)
destroy(this.cb_allyard)
destroy(this.dw_yard)
destroy(this.cb_invown)
destroy(this.cb_noneown)
destroy(this.cb_allown)
destroy(this.dw_owner)
destroy(this.rb_cons)
destroy(this.rb_spd)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_typeinv)
destroy(this.cb_typenone)
destroy(this.cb_typeall)
destroy(this.dw_type)
destroy(this.cb_close)
destroy(this.cb_print)
destroy(this.dw_voy)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_period)
destroy(this.dp_to)
destroy(this.st_wait)
end on

event open;Integer li_row 
datawindowchild dw_child

For li_row = 2005 to Year(Today())
	ddlb_Year.AddItem(String(li_row))
Next
ddlb_Year.SelectItem(ddlb_Year.TotalItems())

ddlb_Period.SelectItem(3)

dp_From.value = DateTime(Date(Year(Today()),1,1))
dp_To.Value = DateTime(Today())

dw_Type.SetTransobject( SQLCA)
dw_Owner.SetTransobject( SQLCA)
dw_Yard.SetTransobject( SQLCA)
dw_voy.SetTransobject( SQLCA)

// Select correct logo on report
If g_userInfo.PC_Logo = 2 then  // If Handytankers
	dw_voy.object.p_handy.Visible = 1
	dw_voy.object.p_maersk.Visible = 0
	dw_voy.object.t_company.Text = "Handytankers"
End If

dw_Type.Retrieve(g_userinfo.userid )

lb_sail.SetState( 1, True)


end event

event resize;Integer li_Pos 

dw_voy.width=this.workspacewidth( )-dw_voy.x*2
dw_voy.height=this.workspaceheight( )-dw_voy.y - cb_close.height - dw_voy.x * 2
cb_close.y = dw_voy.y + dw_voy.height + dw_voy.x
cb_print.y = dw_voy.y + dw_voy.height + dw_voy.x

li_Pos = dw_voy.x + (dw_voy.width - cb_close.width * 2) / 3

if li_Pos < dw_voy.x then li_pos = dw_voy.x

cb_Print.x = li_Pos

li_Pos = li_Pos * 2 + cb_close.width - dw_voy.x

If li_Pos < cb_Print.x + cb_Print.Width then li_Pos = cb_print.x + cb_print.width

cb_close.x = li_pos
end event

event key;If Key = KeyF1! then f_LaunchWiki("Office%20Program.aspx")
end event

type cb_generate from commandbutton within w_vslgraph
integer x = 2176
integer y = 640
integer width = 1719
integer height = 112
integer taborder = 220
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generate Comparison Graph"
end type

event clicked;
Integer li_rows, li_arrcount, li_empty[]

This.Enabled = False
st_Wait.Visible = True

Setpointer(HourGlass!)

// Reset all arrays
ii_owner = li_empty
ii_vtype = li_empty
ii_yard = li_empty
ii_sail = li_empty

li_arrcount = 1; SetNull(ii_vtype[1])
For li_rows = 1 to dw_type.Rowcount( )
	If dw_type.IsSelected( li_rows) then
		li_arrcount++
		ii_vtype[li_arrcount] = dw_type.GetItemNumber( li_rows, "typeid")
	End If
Next

li_arrcount = 1; SetNull(ii_owner[1])
For li_rows = 1 to dw_owner.Rowcount( )
	If dw_owner.IsSelected( li_rows) then
		li_arrcount++
		ii_owner[li_arrcount] = dw_owner.GetItemNumber( li_rows, "owner_nr")
	End If
Next

li_arrcount = 1; SetNull(ii_Yard[1])
For li_rows = 1 to dw_yard.Rowcount( )
	If dw_yard.IsSelected( li_rows) then
		li_arrcount++
		ii_yard[li_arrcount] = dw_yard.GetItemNumber( li_rows, "yard_id")
	End If
Next

li_arrcount = 1; SetNull(ii_Sail[1])
For li_rows = 1 to 5
	If lb_Sail.State( li_rows) = 1 then
		li_arrcount++
		ii_Sail[li_arrcount] = li_rows - 1
	End If
Next

If rb_year.Checked then
	idt_From = date(Integer(ddlb_Year.Text),1,1)
	idt_To = date(Integer(ddlb_Year.Text),12,31)
End If

If rb_Period.Checked then
	idt_To = Today()
	If ii_Period = 100 then
		idt_From = Date(2005,1,1)
	Else
		Integer li_Day = Day(Today())
		Integer li_Month = Month(Today())
		Integer li_Year = Year(Today())
		li_Month -= ii_Period
		Do While li_Month < 0
			li_Month += 12
			li_Year -= 1
		Loop
		If li_Day > 28 then li_Day = 28
		idt_From = Date(li_Year, li_Month, li_Day)
	End If
End If

If rb_date.Checked then
	idt_From = date(dp_From.Value)
	idt_To = date(dp_To.Value)
End If

datawindowchild dw_gr

dw_voy.GetChild( "dw_graph", dw_gr)
dw_gr.SetTransobject( SQLCA)
If rb_spd.checked then
	dw_gr.Modify("gr_1.values = '(LdDist/ldPer), (BlDist/BlPer)'")
	dw_gr.Modify("gr_1.values.label = 'Speed (Knots)'")
	dw_gr.Modify("gr_1.title = 'Vessel Speed Comparison'")
	dw_gr.Modify("gr_1.values.MaximumValue='20'")
	dw_gr.Modify("gr_1.values.Autoscale='0'")
Else
	dw_gr.Modify("gr_1.values = '(LdCon*24/ldPer), (BlCon*24/BlPer)'")
	dw_gr.Modify("gr_1.values.label = 'Consumption (MT/Day)'")	
	dw_gr.Modify("gr_1.title = 'Vessel Consumption Comparison'")
	dw_gr.Modify("gr_1.values.Autoscale='1'")
End If

SetPointer(HourGlass!)
dw_gr.Retrieve(ii_vType, ii_Owner,ii_Yard, ii_Sail, g_userinfo.userid, idt_From, idt_To )

This.Enabled = True
st_Wait.Visible = False

end event

type st_to from statictext within w_vslgraph
integer x = 2469
integer y = 416
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "To"
alignment alignment = center!
boolean focusrectangle = false
boolean disabledlook = true
end type

type dp_from from datepicker within w_vslgraph
integer x = 2469
integer y = 336
integer width = 421
integer height = 80
integer taborder = 210
boolean border = true
borderstyle borderstyle = stylelowered!
boolean enabled = false
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2099-12-31")
date mindate = Date("2005-01-01")
datetime value = DateTime(Date("2010-02-26"), Time("13:38:47.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
end type

event valuechanged;
If dp_to.Value < This.Value then dp_to.Value = This.value


end event

type rb_date from radiobutton within w_vslgraph
integer x = 2066
integer y = 352
integer width = 329
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Date:"
end type

event clicked;
ddlb_Period.Enabled = False
ddlb_Year.Enabled = False
dp_From.Enabled = True
dp_To.Enabled = True
st_To.Enabled = True


end event

type ddlb_period from dropdownlistbox within w_vslgraph
integer x = 2469
integer y = 224
integer width = 421
integer height = 640
integer taborder = 210
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean sorted = false
string item[] = {"Last 3 months","Last 6 months","Last 1 year","Last 2 years","All voyages"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
Choose Case index
	Case 1
		ii_Period = 3
	Case 2
		ii_Period = 6
	Case 3
		ii_Period = 12
	Case 4
		ii_Period = 24
	Case Else
		ii_Period = 100
End Choose


end event

type ddlb_year from dropdownlistbox within w_vslgraph
integer x = 2469
integer y = 112
integer width = 421
integer height = 1088
integer taborder = 210
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type rb_period from radiobutton within w_vslgraph
integer x = 2066
integer y = 240
integer width = 329
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Period:"
end type

event clicked;
ddlb_Period.Enabled = True
ddlb_Year.Enabled = False
dp_From.Enabled = False
dp_To.Enabled = False
st_To.Enabled = False

end event

type rb_year from radiobutton within w_vslgraph
integer x = 2066
integer y = 128
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "By Year:"
boolean checked = true
end type

event clicked;
ddlb_Period.Enabled = False
ddlb_Year.Enabled = True
dp_From.Enabled = False
dp_To.Enabled = False
st_To.Enabled = False
end event

type cb_sailnone from commandbutton within w_vslgraph
integer x = 3493
integer y = 416
integer width = 128
integer height = 56
integer taborder = 200
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "None"
boolean default = true
end type

event clicked;
lb_Sail.SetState(0, False)

end event

type cb_sailall from commandbutton within w_vslgraph
integer x = 3365
integer y = 416
integer width = 128
integer height = 56
integer taborder = 190
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "All"
boolean default = true
end type

event clicked;
lb_sail.SetState(0, True)

Setpointer(HourGlass!)


end event

type lb_sail from listbox within w_vslgraph
integer x = 3365
integer y = 112
integer width = 603
integer height = 304
integer taborder = 200
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
boolean disablenoscroll = true
end type

type cb_invyard from commandbutton within w_vslgraph
integer x = 1591
integer y = 672
integer width = 128
integer height = 56
integer taborder = 180
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "Invert"
boolean default = true
end type

event clicked;integer li_rows

For li_rows = 1 to dw_yard.Rowcount( )
	dw_yard.SelectRow(li_rows, Not dw_yard.IsSelected( li_rows))
Next

Setpointer(HourGlass!)

end event

type cb_noneyard from commandbutton within w_vslgraph
integer x = 1463
integer y = 672
integer width = 128
integer height = 56
integer taborder = 170
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "None"
boolean default = true
end type

event clicked;
dw_Yard.SelectRow(0, False)


end event

type cb_allyard from commandbutton within w_vslgraph
integer x = 1335
integer y = 672
integer width = 128
integer height = 56
integer taborder = 160
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "All"
boolean default = true
end type

event clicked;
dw_yard.SelectRow(0, True)

Setpointer(HourGlass!)

end event

type dw_yard from datawindow within w_vslgraph
integer x = 1335
integer y = 96
integer width = 622
integer height = 576
integer taborder = 190
string title = "none"
string dataobject = "d_sq_tb_vyard"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
If Row>0 then	This.SelectRow( row, Not This.IsSelected( row))
	
end event

event retrieveend;
//wf_applyfilter( )
end event

type cb_invown from commandbutton within w_vslgraph
integer x = 951
integer y = 672
integer width = 128
integer height = 56
integer taborder = 180
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "Invert"
boolean default = true
end type

event clicked;integer li_rows

For li_rows = 1 to dw_owner.Rowcount( )
	dw_owner.SelectRow(li_rows, Not dw_owner.IsSelected( li_rows))
Next

Setpointer(HourGlass!)

wf_retrievenext( dw_owner, dw_yard, "owner_nr")
end event

type cb_noneown from commandbutton within w_vslgraph
integer x = 823
integer y = 672
integer width = 128
integer height = 56
integer taborder = 170
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "None"
boolean default = true
end type

event clicked;
dw_owner.SelectRow(0, False)

dw_yard.Reset()

end event

type cb_allown from commandbutton within w_vslgraph
integer x = 695
integer y = 672
integer width = 128
integer height = 56
integer taborder = 160
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "All"
boolean default = true
end type

event clicked;
dw_owner.SelectRow(0, True)

Setpointer(HourGlass!)

wf_retrievenext(dw_owner, dw_yard, "owner_nr")
end event

type dw_owner from datawindow within w_vslgraph
integer x = 695
integer y = 96
integer width = 622
integer height = 576
integer taborder = 50
string title = "none"
string dataobject = "d_sq_tb_vowner"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
If Row>0 then
	This.SelectRow( row, Not This.IsSelected( row))
	wf_retrievenext( dw_owner, dw_yard, "owner_nr")
End if
end event

event retrieveend;
dw_yard.Reset()

//wf_applyfilter( )
end event

type rb_cons from radiobutton within w_vslgraph
integer x = 3621
integer y = 512
integer width = 402
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

type rb_spd from radiobutton within w_vslgraph
integer x = 3365
integer y = 512
integer width = 293
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

type st_2 from statictext within w_vslgraph
integer x = 3035
integer y = 512
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Compare:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_vslgraph
integer x = 3035
integer y = 128
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sailing Type:"
boolean focusrectangle = false
end type

type cb_typeinv from commandbutton within w_vslgraph
integer x = 311
integer y = 672
integer width = 128
integer height = 56
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "Invert"
end type

event clicked;
integer li_rows

For li_rows = 1 to dw_type.Rowcount( )
	dw_type.SelectRow(li_rows, Not dw_type.IsSelected( li_rows))
Next

Setpointer(HourGlass!)

wf_retrievenext( dw_type, dw_owner, "typeid")
end event

type cb_typenone from commandbutton within w_vslgraph
integer x = 183
integer y = 672
integer width = 128
integer height = 56
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "None"
end type

event clicked;
dw_type.SelectRow(0, False)

dw_owner.Reset()
dw_yard.Reset()


end event

type cb_typeall from commandbutton within w_vslgraph
integer x = 55
integer y = 672
integer width = 128
integer height = 56
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
string text = "All"
end type

event clicked;
dw_type.SelectRow(0, True)

Setpointer(HourGlass!)

wf_retrievenext( dw_type, dw_owner, "typeid")
end event

type dw_type from datawindow within w_vslgraph
integer x = 55
integer y = 96
integer width = 622
integer height = 576
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_vtype"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
If Row>0 then
	This.SelectRow( row, Not This.IsSelected( row))
	wf_retrievenext( dw_type, dw_owner, "typeid")
End if
end event

event retrieveend;
dw_owner.Reset()
dw_yard.Reset()

//wf_applyfilter( )
end event

type cb_close from commandbutton within w_vslgraph
integer x = 2377
integer y = 2336
integer width = 530
integer height = 112
integer taborder = 170
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

type cb_print from commandbutton within w_vslgraph
integer x = 969
integer y = 2336
integer width = 530
integer height = 112
integer taborder = 160
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;
dw_voy.print(True, True )
end event

type dw_voy from datawindow within w_vslgraph
integer x = 18
integer y = 784
integer width = 3877
integer height = 1488
integer taborder = 150
string title = "none"
string dataobject = "d_rep_graphreport"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieverow;
yield()
end event

type gb_1 from groupbox within w_vslgraph
integer x = 18
integer y = 16
integer width = 1975
integer height = 736
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Selection"
end type

type gb_2 from groupbox within w_vslgraph
integer x = 2981
integer y = 16
integer width = 1061
integer height = 592
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Graph Selection"
end type

type gb_period from groupbox within w_vslgraph
integer x = 2011
integer y = 16
integer width = 951
integer height = 592
integer taborder = 210
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Period"
end type

type dp_to from datepicker within w_vslgraph
integer x = 2469
integer y = 472
integer width = 421
integer height = 80
integer taborder = 210
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
boolean enabled = false
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2099-12-31")
date mindate = Date("2005-01-01")
datetime value = DateTime(Date("2010-02-26"), Time("13:38:47.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
end type

event valuechanged;
If dp_From.Value > This.Value then dp_From.Value = This.value
end event

type st_wait from statictext within w_vslgraph
boolean visible = false
integer x = 1920
integer y = 1440
integer width = 1280
integer height = 112
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12639424
string text = "Creating graph. Please wait..."
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

