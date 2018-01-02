$PBExportHeader$w_voycomp.srw
forward
global type w_voycomp from window
end type
type cbx_desc from checkbox within w_voycomp
end type
type rb_name from radiobutton within w_voycomp
end type
type rb_type from radiobutton within w_voycomp
end type
type cb_custom from commandbutton within w_voycomp
end type
type dw_export from datawindow within w_voycomp
end type
type cb_export from commandbutton within w_voycomp
end type
type sle_to from singlelineedit within w_voycomp
end type
type sle_from from singlelineedit within w_voycomp
end type
type st_5 from statictext within w_voycomp
end type
type lb_sort from listbox within w_voycomp
end type
type em_con from editmask within w_voycomp
end type
type em_spd from editmask within w_voycomp
end type
type em_per from editmask within w_voycomp
end type
type st_8 from statictext within w_voycomp
end type
type st_7 from statictext within w_voycomp
end type
type st_6 from statictext within w_voycomp
end type
type ddlb_voy from dropdownlistbox within w_voycomp
end type
type ddlb_per from dropdownlistbox within w_voycomp
end type
type ddlb_spd from dropdownlistbox within w_voycomp
end type
type ddlb_cons from dropdownlistbox within w_voycomp
end type
type st_4 from statictext within w_voycomp
end type
type st_3 from statictext within w_voycomp
end type
type st_2 from statictext within w_voycomp
end type
type st_1 from statictext within w_voycomp
end type
type cb_typeinv from commandbutton within w_voycomp
end type
type cb_typenone from commandbutton within w_voycomp
end type
type cb_typeall from commandbutton within w_voycomp
end type
type dw_vsl from datawindow within w_voycomp
end type
type cb_close from commandbutton within w_voycomp
end type
type cb_print from commandbutton within w_voycomp
end type
type dw_voy from datawindow within w_voycomp
end type
type gb_1 from groupbox within w_voycomp
end type
type gb_2 from groupbox within w_voycomp
end type
type gb_3 from groupbox within w_voycomp
end type
end forward

global type w_voycomp from window
integer width = 3963
integer height = 2508
boolean titlebar = true
string title = "Vessel / Voyage Comparison"
boolean controlmenu = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "Report5!"
boolean center = true
cbx_desc cbx_desc
rb_name rb_name
rb_type rb_type
cb_custom cb_custom
dw_export dw_export
cb_export cb_export
sle_to sle_to
sle_from sle_from
st_5 st_5
lb_sort lb_sort
em_con em_con
em_spd em_spd
em_per em_per
st_8 st_8
st_7 st_7
st_6 st_6
ddlb_voy ddlb_voy
ddlb_per ddlb_per
ddlb_spd ddlb_spd
ddlb_cons ddlb_cons
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
cb_typeinv cb_typeinv
cb_typenone cb_typenone
cb_typeall cb_typeall
dw_vsl dw_vsl
cb_close cb_close
cb_print cb_print
dw_voy dw_voy
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_voycomp w_voycomp

type variables


Integer ii_VoyType, ii_Spd, ii_Per, ii_Con, ii_Comm = 1

end variables

forward prototypes
public subroutine wf_applyfilter ()
public subroutine wf_retrievetypes ()
public subroutine wf_retrievevoy ()
public subroutine wf_retrievenames ()
end prototypes

public subroutine wf_applyfilter ();
String ls_Tmp
Integer li_rows 

Setpointer(HourGlass!)

//Create voyage filters
ls_Tmp = "(tperf_saildata_period "
If ii_Per = 1 then ls_Tmp += "< " else ls_Tmp += "> "
ls_Tmp += em_Per.Text + ")"
	 
ls_Tmp += " and (speed " 
If ii_Spd = 1 then ls_Tmp += "< " else ls_Tmp += "> "
ls_Tmp += em_Spd.Text + ")"

ls_Tmp += " and (cons " 
If ii_Con = 1 then ls_Tmp += "< " else ls_Tmp += "> "
ls_Tmp += em_Con.Text + ")"

If Trim(sle_from.Text) > "" Then
	ls_Tmp += " and (Upper(dep) like '" + Upper(Trim(sle_from.Text)) + "%')"
End If

If Trim(sle_To.Text) > "" Then
	ls_Tmp += " and (Upper(arr) like '" + Upper(Trim(sle_To.Text)) + "%')"
End If

If ii_VoyType < 2 then ls_Tmp += " and (tperf_voy_voy_type = " + String(ii_VoyType, "0") + ")"

dw_voy.SetFilter(ls_Tmp)
dw_voy.Filter( )

end subroutine

public subroutine wf_retrievetypes ();
dw_vsl.Retrieve(g_userinfo.userid)

dw_voy.Reset()
end subroutine

public subroutine wf_retrievevoy ();Integer li_PC[], li_Type[], li_Vsl[], li_Rows

// This function retrieves the full list of voyages with selected PC and Type

SetPointer(HourGlass!)

For li_rows = 1 to dw_vsl.Rowcount( )
	If dw_vsl.IsSelected(li_Rows) then 
		If rb_Type.Checked then	li_Type[UpperBound(li_Type) + 1] = dw_vsl.GetItemNumber(li_rows, "typeID") Else li_Vsl[UpperBound(li_Vsl) + 1] = dw_vsl.GetItemNumber(li_rows, "Vessel_ID")
	End If
Next

If UpperBound(li_Type) = 0 then li_Type[1] = -1
If UpperBound(li_Vsl) = 0 then li_Vsl[1] = -1

dw_voy.SetRedraw(False)

dw_Voy.Reset()

dw_Voy.Retrieve(g_userinfo.userid , li_Type, li_Vsl)

dw_voy.SetRedraw(True)
end subroutine

public subroutine wf_retrievenames ();
dw_vsl.Retrieve(g_userinfo.userid )

dw_voy.Reset()
end subroutine

on w_voycomp.create
this.cbx_desc=create cbx_desc
this.rb_name=create rb_name
this.rb_type=create rb_type
this.cb_custom=create cb_custom
this.dw_export=create dw_export
this.cb_export=create cb_export
this.sle_to=create sle_to
this.sle_from=create sle_from
this.st_5=create st_5
this.lb_sort=create lb_sort
this.em_con=create em_con
this.em_spd=create em_spd
this.em_per=create em_per
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.ddlb_voy=create ddlb_voy
this.ddlb_per=create ddlb_per
this.ddlb_spd=create ddlb_spd
this.ddlb_cons=create ddlb_cons
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_typeinv=create cb_typeinv
this.cb_typenone=create cb_typenone
this.cb_typeall=create cb_typeall
this.dw_vsl=create dw_vsl
this.cb_close=create cb_close
this.cb_print=create cb_print
this.dw_voy=create dw_voy
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.Control[]={this.cbx_desc,&
this.rb_name,&
this.rb_type,&
this.cb_custom,&
this.dw_export,&
this.cb_export,&
this.sle_to,&
this.sle_from,&
this.st_5,&
this.lb_sort,&
this.em_con,&
this.em_spd,&
this.em_per,&
this.st_8,&
this.st_7,&
this.st_6,&
this.ddlb_voy,&
this.ddlb_per,&
this.ddlb_spd,&
this.ddlb_cons,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_typeinv,&
this.cb_typenone,&
this.cb_typeall,&
this.dw_vsl,&
this.cb_close,&
this.cb_print,&
this.dw_voy,&
this.gb_1,&
this.gb_2,&
this.gb_3}
end on

on w_voycomp.destroy
destroy(this.cbx_desc)
destroy(this.rb_name)
destroy(this.rb_type)
destroy(this.cb_custom)
destroy(this.dw_export)
destroy(this.cb_export)
destroy(this.sle_to)
destroy(this.sle_from)
destroy(this.st_5)
destroy(this.lb_sort)
destroy(this.em_con)
destroy(this.em_spd)
destroy(this.em_per)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.ddlb_voy)
destroy(this.ddlb_per)
destroy(this.ddlb_spd)
destroy(this.ddlb_cons)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_typeinv)
destroy(this.cb_typenone)
destroy(this.cb_typeall)
destroy(this.dw_vsl)
destroy(this.cb_close)
destroy(this.cb_print)
destroy(this.dw_voy)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;Integer li_row 

dw_vsl.SetTransobject( SQLCA)
dw_voy.SetTransobject( SQLCA)

// Select correct logo on report
If g_userInfo.PC_Logo = 2 then  // If Handytankers
	dw_voy.object.p_handy.Visible = 1
	dw_voy.object.p_maersk.Visible = 0
	dw_voy.object.t_company.Text = "Handytankers"
End If

wf_RetrieveTypes()	

// Initialize voyage filters
ddlb_voy.SelectItem(3)
ddlb_Cons.SelectItem(2)
ddlb_per.SelectItem(2)
ddlb_Spd.SelectItem(2)
ii_VoyType = 2

wf_applyfilter( )

lb_sort.selectitem(2)
dw_voy.setsort( "vessels_vessel_name, tperf_voy_voy_num")
dw_voy.Sort( )

end event

event resize;Integer li_Wid, li_x 

dw_voy.width=This.WorkSpaceWidth( )-dw_voy.x*2
li_x = This.WorkSpaceHeight( )-dw_voy.y - cb_close.height - dw_voy.x * 2
If li_x < 200 then li_x = 200
dw_voy.height = li_x
cb_close.y = dw_voy.y + dw_voy.height
cb_print.y = cb_close.y
cb_export.y = cb_close.y
cb_custom.y = cb_close.y

li_x = dw_voy.x + dw_voy.width - cb_Close.Width

If li_x < cb_Custom.x + cb_Custom.Width then li_x = cb_Custom.x + cb_Custom.width

cb_close.x = li_x
end event

event key;If Key = KeyF1! then f_LaunchWiki("Office%20Program.aspx")
end event

type cbx_desc from checkbox within w_voycomp
integer x = 2432
integer y = 576
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Descending"
end type

event clicked;
lb_sort.event selectionchanged(lb_sort.selectedindex())
end event

type rb_name from radiobutton within w_voycomp
integer x = 402
integer y = 80
integer width = 343
integer height = 80
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Names"
end type

event clicked;
dw_vsl.DataObject = "d_sq_tb_pcvsl"
dw_vsl.SetTransObject(SQLCA)

wf_RetrieveNames()

end event

type rb_type from radiobutton within w_voycomp
integer x = 55
integer y = 80
integer width = 274
integer height = 80
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ship Types"
boolean checked = true
end type

event clicked;
dw_vsl.DataObject = "d_sq_tb_vtype"
dw_vsl.SetTransObject(SQLCA)

wf_RetrieveTypes()

end event

type cb_custom from commandbutton within w_voycomp
integer x = 1079
integer y = 2224
integer width = 530
integer height = 96
integer taborder = 190
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Custom Export..."
end type

event clicked;Long ll_RowCount, ll_Loop, ll_VoyID[]
struct_voylist lstruct_List

ll_RowCount = dw_voy.RowCount( )

If ll_RowCount = 0 then
	Messagebox("Export Error", "No data to export!", Exclamation!)
	Return
End If

If ll_RowCount > 1000 then 
	Messagebox("Export Error", "Number of voyage legs are more than 1000. Please use filters to reduce the number of voyages before exporting.", Exclamation!)
	Return
End If

SetPointer(HourGlass!)

// Put all voyage ids into an array
For ll_Loop = ll_RowCount to 1 Step -1
	ll_VoyID[ll_Loop] = dw_voy.GetItemNumber(ll_Loop, "Voy_ID")
Next 

lstruct_List.Voylist = ll_VoyID

OpenWithParm(w_Export, lstruct_List)




end event

type dw_export from datawindow within w_voycomp
boolean visible = false
integer x = 1883
integer y = 2272
integer width = 677
integer height = 96
integer taborder = 180
string title = "none"
string dataobject = "d_sq_tb_voyexport"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event sqlpreview;String ls_SQL

ls_SQL = sqlsyntax
end event

type cb_export from commandbutton within w_voycomp
integer x = 549
integer y = 2224
integer width = 530
integer height = 96
integer taborder = 180
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Raw Export..."
end type

event clicked;Long ll_RowCount, ll_Loop, ll_VoyID[]

ll_RowCount = dw_voy.RowCount( )

If ll_RowCount = 0 then
	Messagebox("Export Error", "No data to export!", Exclamation!)
	Return
End If

If ll_RowCount > 1000 then 
	Messagebox("Export Error", "Number of voyage legs are more than 1000. Please use filters to reduce the number of voyages before exporting.", Exclamation!)
	Return
End If

SetPointer(HourGlass!)

For ll_Loop = ll_RowCount to 1 Step -1
	ll_VoyID[ll_Loop] = dw_voy.GetItemNumber(ll_Loop, "Voy_ID")
Next 

SetPointer(HourGlass!)

dw_export.SetTransobject(SQLCA)

ll_Rowcount = dw_export.Retrieve(ll_VoyID)

If ll_RowCount = 0 then
	Messagebox("Export Error", "Datastore Retrieve failed!", Exclamation!)
Else
	dw_export.SaveAs("", Excel8!, True)
End If

end event

type sle_to from singlelineedit within w_voycomp
integer x = 1847
integer y = 560
integer width = 402
integer height = 80
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;
wf_applyfilter( )
end event

type sle_from from singlelineedit within w_voycomp
integer x = 1353
integer y = 560
integer width = 402
integer height = 80
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;
wf_applyfilter( )
end event

type st_5 from statictext within w_voycomp
integer x = 933
integer y = 576
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
string text = "From / To:"
boolean focusrectangle = false
end type

type lb_sort from listbox within w_voycomp
integer x = 2432
integer y = 112
integer width = 549
integer height = 464
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
string item[] = {"Vessel No.","Vessel Name","Voyage No.","Voyage Type","Started","From","To","Period","Distance","Stoppage","Speed","Consumption","Daily Consumption"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;String ls_Sort

Choose Case Index
	Case 1
		ls_Sort = "vessels_vessel_nr"
	Case 2
		ls_Sort = "vessels_vessel_name"
	Case 3 
		ls_Sort = "tperf_voy_voy_num"
	Case 4
		ls_Sort = "tperf_voy_voy_type"
	Case 5
		ls_Sort = "start"
	Case 6
		ls_Sort = "dep"
	Case 7
		ls_Sort = "arr"
	Case 8
		ls_Sort = "tperf_saildata_period"
	Case 9
		ls_Sort = "tperf_saildata_dist"
	Case 10
		ls_Sort = "stoppage"
	Case 11
		ls_Sort = "speed"
	Case 12
		ls_Sort = "cons"
	Case 13
		ls_Sort = "daily"
End Choose

If cbx_Desc.Checked then ls_Sort += " desc"

dw_voy.SetSort(ls_Sort)
dw_Voy.Sort( )
end event

type em_con from editmask within w_voycomp
integer x = 1847
integer y = 448
integer width = 256
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "0"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####0.0"
string minmax = "~~"
end type

event modified;
wf_applyfilter( )
end event

type em_spd from editmask within w_voycomp
integer x = 1847
integer y = 336
integer width = 256
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "0"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####0.0"
string minmax = "~~"
end type

event modified;
wf_applyfilter( )
end event

type em_per from editmask within w_voycomp
integer x = 1847
integer y = 224
integer width = 256
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "0"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####0.0"
string minmax = "~~"
end type

event modified;
wf_applyfilter( )
end event

type st_8 from statictext within w_voycomp
integer x = 2121
integer y = 464
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 67108864
string text = "MT/Day"
boolean focusrectangle = false
end type

type st_7 from statictext within w_voycomp
integer x = 2121
integer y = 352
integer width = 169
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 67108864
string text = "Knots"
boolean focusrectangle = false
end type

type st_6 from statictext within w_voycomp
integer x = 2121
integer y = 240
integer width = 128
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 67108864
string text = "Hrs"
boolean focusrectangle = false
end type

type ddlb_voy from dropdownlistbox within w_voycomp
integer x = 1353
integer y = 112
integer width = 768
integer height = 320
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Loaded / Partly Loaded","Ballast","All Types"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_VoyType = Index - 1

wf_applyfilter( )
end event

type ddlb_per from dropdownlistbox within w_voycomp
integer x = 1353
integer y = 224
integer width = 402
integer height = 336
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Less than","More than"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_per = index

wf_applyfilter( )


end event

type ddlb_spd from dropdownlistbox within w_voycomp
integer x = 1353
integer y = 336
integer width = 402
integer height = 336
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Less than","More than"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_spd = index

wf_applyfilter( )
end event

type ddlb_cons from dropdownlistbox within w_voycomp
integer x = 1353
integer y = 448
integer width = 402
integer height = 336
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Less than","More than"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_con = index

wf_applyfilter( )
end event

type st_4 from statictext within w_voycomp
integer x = 933
integer y = 464
integer width = 416
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ME Consumption:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_voycomp
integer x = 933
integer y = 352
integer width = 384
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Overall Speed:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_voycomp
integer x = 933
integer y = 240
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sailing Period:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_voycomp
integer x = 933
integer y = 128
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Type:"
boolean focusrectangle = false
end type

type cb_typeinv from commandbutton within w_voycomp
integer x = 311
integer y = 608
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

For li_rows = 1 to dw_vsl.Rowcount( )
	dw_vsl.SelectRow(li_rows, Not dw_vsl.IsSelected( li_rows))
Next

wf_RetrieveVoy( )
end event

type cb_typenone from commandbutton within w_voycomp
integer x = 183
integer y = 608
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
dw_vsl.SelectRow(0, False)

wf_RetrieveVoy( )
end event

type cb_typeall from commandbutton within w_voycomp
integer x = 55
integer y = 608
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
dw_vsl.SelectRow(0, True)

wf_RetrieveVoy( )
end event

type dw_vsl from datawindow within w_voycomp
integer x = 55
integer y = 160
integer width = 750
integer height = 448
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
	wf_RetrieveVoy( )
End if
end event

type cb_close from commandbutton within w_voycomp
integer x = 3365
integer y = 2240
integer width = 530
integer height = 96
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

type cb_print from commandbutton within w_voycomp
integer x = 18
integer y = 2224
integer width = 530
integer height = 96
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

type dw_voy from datawindow within w_voycomp
integer x = 18
integer y = 688
integer width = 3877
integer height = 1536
integer taborder = 150
string title = "none"
string dataobject = "d_sq_tb_voylistfull"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_voycomp
integer x = 18
integer y = 16
integer width = 841
integer height = 656
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Filters"
end type

type gb_2 from groupbox within w_voycomp
integer x = 896
integer y = 16
integer width = 1445
integer height = 656
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Filters"
end type

type gb_3 from groupbox within w_voycomp
integer x = 2377
integer y = 16
integer width = 658
integer height = 656
integer taborder = 180
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sort Order"
end type

