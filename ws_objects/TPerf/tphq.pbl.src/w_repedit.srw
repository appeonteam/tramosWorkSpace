$PBExportHeader$w_repedit.srw
forward
global type w_repedit from window
end type
type cb_delcon from commandbutton within w_repedit
end type
type cb_addcon from commandbutton within w_repedit
end type
type dw_repcon from datawindow within w_repedit
end type
type cb_del from commandbutton within w_repedit
end type
type cb_add from commandbutton within w_repedit
end type
type dw_sail from datawindow within w_repedit
end type
type cb_cancel from commandbutton within w_repedit
end type
type dw_rep from datawindow within w_repedit
end type
type gb_1 from groupbox within w_repedit
end type
type gb_2 from groupbox within w_repedit
end type
type gb_3 from groupbox within w_repedit
end type
end forward

global type w_repedit from window
integer width = 3758
integer height = 1780
boolean titlebar = true
string title = "Edit Report"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_delcon cb_delcon
cb_addcon cb_addcon
dw_repcon dw_repcon
cb_del cb_del
cb_add cb_add
dw_sail dw_sail
cb_cancel cb_cancel
dw_rep dw_rep
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_repedit w_repedit

type variables

boolean ib_lock

integer ii_row
end variables

on w_repedit.create
this.cb_delcon=create cb_delcon
this.cb_addcon=create cb_addcon
this.dw_repcon=create dw_repcon
this.cb_del=create cb_del
this.cb_add=create cb_add
this.dw_sail=create dw_sail
this.cb_cancel=create cb_cancel
this.dw_rep=create dw_rep
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.Control[]={this.cb_delcon,&
this.cb_addcon,&
this.dw_repcon,&
this.cb_del,&
this.cb_add,&
this.dw_sail,&
this.cb_cancel,&
this.dw_rep,&
this.gb_1,&
this.gb_2,&
this.gb_3}
end on

on w_repedit.destroy
destroy(this.cb_delcon)
destroy(this.cb_addcon)
destroy(this.dw_repcon)
destroy(this.cb_del)
destroy(this.cb_add)
destroy(this.dw_sail)
destroy(this.cb_cancel)
destroy(this.dw_rep)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;Decimal ld_Tmp
String ls_Tmp

dw_rep.settransobject( SQLCA)
dw_sail.settransobject( SQLCA)
dw_repcon.settransobject( SQLCA)

gnv_voyage.ids_reports.sharedata( dw_rep)
gnv_voyage.ids_saildata.sharedata( dw_sail)
gnv_voyage.ids_repcon.sharedata( dw_repcon)

ii_row = dw_rep.Find("Rep_ID=" + String(g_parameters.reportid), 0, dw_rep.RowCount() )

dw_rep.scrolltorow( ii_row)

ld_Tmp = dw_rep.GetItemNumber( ii_row, "Lat")
ls_Tmp = String(Int(Abs(ld_Tmp)/60), "00") + String(Mod(Abs(ld_tmp), 60) * 10, "000") 
If ld_Tmp < 0 then ls_Tmp += "S" else ls_Tmp += "N"
dw_rep.SetItem( ii_row, "LatStr", ls_Tmp)

ld_Tmp = dw_rep.GetItemNumber( ii_row, "Lng")
ls_Tmp = String(Int(Abs(ld_Tmp)/60), "000") + String(Mod(Abs(ld_tmp), 60) * 10, "000") 
If ld_Tmp < 0 then ls_Tmp += "W" else ls_Tmp += "E"
dw_rep.SetItem( ii_row, "LngStr", ls_Tmp)

ib_lock = True

If dw_rep.GetItemNumber( ii_row, "Serial") = 1 then 
	cb_add.Enabled = False
	cb_Del.Enabled = False
End If

dw_sail.setfilter( "Rep_ID = " + string(g_parameters.reportid))
dw_sail.filter( )

dw_repcon.setfilter( "Rep_ID = " + string(g_parameters.reportid))
dw_repcon.filter( )

end event

type cb_delcon from commandbutton within w_repedit
integer x = 2414
integer y = 1424
integer width = 293
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;
If MessageBox("Confirm Delete", "Are you sure you want to delete the selected row?", Question!, YesNo!) = 2 then Return

dw_RepCon.DeleteRow( dw_RepCon.GetRow() )

If dw_RepCon.Rowcount( ) > 0 then
	dw_RepCon.SelectRow(1, True)
	dw_RepCon.ScrollTorow(1)
Else
	cb_delcon.Enabled = False
End If
end event

type cb_addcon from commandbutton within w_repedit
integer x = 2121
integer y = 1424
integer width = 293
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add"
end type

event clicked;long ll_newrow, MaxSerial

MaxSerial = 0

For ll_newrow = 1 to dw_repcon.RowCount( )
	If dw_repcon.GetItemNumber(ll_newrow, "Serial") > MaxSerial then MaxSerial = dw_repcon.GetItemNumber(ll_newrow, "Serial")
Next

ll_newrow = dw_repcon.insertrow(0)

if ll_newrow > 0 then 
	dw_repcon.SetItem( ll_newrow, "Rep_ID", g_parameters.reportid )
	dw_repcon.SetItem( ll_newrow, "Serial", MaxSerial )
	cb_delcon.Enabled = True
Else
	
End If
	
end event

type dw_repcon from datawindow within w_repedit
integer x = 2121
integer y = 1120
integer width = 1554
integer height = 304
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_repconedit"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
this.selectrow(0, False)
this.selectrow(currentrow, True)
end event

type cb_del from commandbutton within w_repedit
integer x = 366
integer y = 1424
integer width = 293
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;
If dw_Sail.Rowcount( ) = 1 then
	MessageBox("Delete Error", "There must be at least 1 sailing period.", Exclamation!)
	Return
End If

If MessageBox("Confirm Delete", "Are you sure you want to delete the selected row?", Question!, YesNo!) = 2 then Return

dw_Sail.DeleteRow( dw_Sail.GetRow() )

dw_Sail.SelectRow(1, True)
dw_Sail.ScrollTorow(1)
end event

type cb_add from commandbutton within w_repedit
integer x = 73
integer y = 1424
integer width = 293
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add"
end type

event clicked;
long ll_newrow

ll_newrow = dw_sail.insertrow(0)

if ll_newrow > 0 then dw_sail.SetItem( ll_newrow, "Rep_ID", g_parameters.reportid )
	
end event

type dw_sail from datawindow within w_repedit
integer x = 73
integer y = 1120
integer width = 1920
integer height = 304
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_saildata"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
this.selectrow(0, False)
this.selectrow(currentrow, True)
end event

type cb_cancel from commandbutton within w_repedit
integer x = 1518
integer y = 1552
integer width = 713
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

event clicked;
integer li_sail
string ls_Tmp
Decimal ld_Tmp
datetime ldt_newutc, ldt_oldutc

dw_rep.accepttext( )
dw_sail.accepttext( )
dw_repcon.accepttext( )

// Validate Lat & Long
ls_Tmp = dw_rep.GetItemString(ii_row, "LatStr")
ld_Tmp = Long(Left(ls_Tmp, 5))
If Mod(ld_Tmp, 1000) > 599 then 
	MessageBox ("Error", "The latitude entered is invalid.", Exclamation!)
	Return
End If
if ld_Tmp > 85000 then 
	MessageBox ("Error", "Latitude cannot be higher than 85° N/S.", Exclamation!)
	Return
End If
ls_Tmp = Right(ls_Tmp,1)
If Not(ls_Tmp="N" or ls_Tmp="S") then
	MessageBox ("Error", "Latitude hemisphere must be N or S.", Exclamation!)
	Return		
End If	
ld_Tmp = Int(ld_Tmp/1000) * 60 + (Mod(ld_Tmp, 1000) / 10)
if ls_Tmp = "S" then ld_Tmp = -ld_Tmp
If dw_Rep.GetItemNumber(ii_row, "Lat") <> ld_Tmp then dw_rep.SetItem(ii_row, "Lat", ld_Tmp)

ls_Tmp = dw_rep.GetItemString(ii_row, "LngStr")
ld_Tmp = Long(Left(ls_Tmp, 6))
If Mod(ld_Tmp, 1000) > 599 then 
	MessageBox ("Error", "The longitude entered is invalid.", Exclamation!)
	Return
End If
if ld_Tmp > 180000 then 
	MessageBox ("Error", "Longitude cannot be higher than 180° E/W.", Exclamation!)
	Return
End If
ls_Tmp = Right(ls_Tmp,1)
If Not(ls_Tmp="E" or ls_Tmp="W") then
	MessageBox ("Error", "Longitude hemisphere must be E or W.", Exclamation!)
	Return		
End If	
ld_Tmp = Int(ld_Tmp/1000) * 60 + (Mod(ld_Tmp, 1000) / 10)
if ls_Tmp = "W" then ld_Tmp = -ld_Tmp
If dw_Rep.GetItemNumber(ii_row, "Lng") <> ld_Tmp then dw_rep.SetItem(ii_row, "Lng", ld_Tmp)

// Saildata validation
For li_sail = 1 to dw_sail.rowcount( ) - 1
	If dw_sail.GetItemNumber(li_sail, "Type") = dw_sail.GetItemNumber(li_sail+1, "Type") then
		MessageBox("Error", "Sailing Data cannot contain 2 sailing of the same type.", Exclamation!)
		Return
	End If
Next

// RepCon validation
For li_sail = 1 to dw_repcon.rowcount( ) - 1
	If dw_repcon.GetItemNumber(li_sail, "ConType") = dw_repcon.GetItemNumber(li_sail+1, "ConType") then
		MessageBox("Error", "Other Consumption cannot contain 2 rows of the same type.", Exclamation!)
		Return
	End If
Next

li_sail = dw_rep.GetItemNumber( ii_Row, "Zone") * -60
ldt_oldutc = dw_rep.GetItemdateTime ( ii_Row, "LocalTime")
Select DateAdd(mi, :li_Sail, :ldt_oldutc) INTO :ldt_newutc FROM TPERF_SYSERR;
ldt_oldutc = dw_rep.GetItemdateTime( ii_Row, "UTC")

if ldt_oldutc <> ldt_newutc then
	dw_rep.SetItem( ii_Row, "UTC", ldt_newutc)
End If

Close(parent)
end event

type dw_rep from datawindow within w_repedit
integer x = 55
integer y = 80
integer width = 3602
integer height = 912
integer taborder = 10
string title = "none"
string dataobject = "d_sq_ff_reportedit"
boolean border = false
boolean livescroll = true
end type

event rowfocuschanging;
if ib_lock then return 1
end event

type gb_1 from groupbox within w_repedit
integer x = 18
integer y = 16
integer width = 3694
integer height = 992
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Details"
end type

type gb_2 from groupbox within w_repedit
integer x = 18
integer y = 1024
integer width = 2048
integer height = 496
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sailing Data"
end type

type gb_3 from groupbox within w_repedit
integer x = 2085
integer y = 1024
integer width = 1627
integer height = 496
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Other Consumption / ROB"
end type

