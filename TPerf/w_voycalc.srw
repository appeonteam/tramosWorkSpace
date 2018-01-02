HA$PBExportHeader$w_voycalc.srw
forward
global type w_voycalc from window
end type
type cbx_detail from checkbox within w_voycalc
end type
type hpb_prg from hprogressbar within w_voycalc
end type
type cb_export from commandbutton within w_voycalc
end type
type cbx_ballast from checkbox within w_voycalc
end type
type cbx_laden from checkbox within w_voycalc
end type
type cb_calc from commandbutton within w_voycalc
end type
type cb_print from commandbutton within w_voycalc
end type
type st_unit from statictext within w_voycalc
end type
type cbx_neg from checkbox within w_voycalc
end type
type st_6 from statictext within w_voycalc
end type
type dw_calc from datawindow within w_voycalc
end type
type cbx_stop from checkbox within w_voycalc
end type
type cbx_wx from checkbox within w_voycalc
end type
type cbx_conf from checkbox within w_voycalc
end type
type cbx_adj from checkbox within w_voycalc
end type
type cbx_econ from checkbox within w_voycalc
end type
type cbx_full from checkbox within w_voycalc
end type
type st_5 from statictext within w_voycalc
end type
type st_oil4 from statictext within w_voycalc
end type
type st_oil3 from statictext within w_voycalc
end type
type st_oil2 from statictext within w_voycalc
end type
type st_oil1 from statictext within w_voycalc
end type
type gb_2 from groupbox within w_voycalc
end type
type em_timecost from editmask within w_voycalc
end type
type st_tunit from statictext within w_voycalc
end type
type st_costlabel from statictext within w_voycalc
end type
type rb_bunk from radiobutton within w_voycalc
end type
type rb_time from radiobutton within w_voycalc
end type
type st_4 from statictext within w_voycalc
end type
type st_voysel from statictext within w_voycalc
end type
type dw_voy2 from datawindow within w_voycalc
end type
type dw_voy1 from datawindow within w_voycalc
end type
type cb_close from commandbutton within w_voycalc
end type
type dw_vsl from datawindow within w_voycalc
end type
type st_1 from statictext within w_voycalc
end type
type rr_1 from roundrectangle within w_voycalc
end type
type st_2 from statictext within w_voycalc
end type
type st_3 from statictext within w_voycalc
end type
type gb_1 from groupbox within w_voycalc
end type
type rb_spec from radiobutton within w_voycalc
end type
type rb_voy from radiobutton within w_voycalc
end type
type em_do from editmask within w_voycalc
end type
type em_go from editmask within w_voycalc
end type
type em_lsfo from editmask within w_voycalc
end type
type em_hsfo from editmask within w_voycalc
end type
end forward

global type w_voycalc from window
integer width = 4201
integer height = 2680
boolean titlebar = true
string title = "Voyage Calculation"
boolean controlmenu = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "H:\Tramos.Dev\Resource\TPerf\Money.ico"
boolean center = true
cbx_detail cbx_detail
hpb_prg hpb_prg
cb_export cb_export
cbx_ballast cbx_ballast
cbx_laden cbx_laden
cb_calc cb_calc
cb_print cb_print
st_unit st_unit
cbx_neg cbx_neg
st_6 st_6
dw_calc dw_calc
cbx_stop cbx_stop
cbx_wx cbx_wx
cbx_conf cbx_conf
cbx_adj cbx_adj
cbx_econ cbx_econ
cbx_full cbx_full
st_5 st_5
st_oil4 st_oil4
st_oil3 st_oil3
st_oil2 st_oil2
st_oil1 st_oil1
gb_2 gb_2
em_timecost em_timecost
st_tunit st_tunit
st_costlabel st_costlabel
rb_bunk rb_bunk
rb_time rb_time
st_4 st_4
st_voysel st_voysel
dw_voy2 dw_voy2
dw_voy1 dw_voy1
cb_close cb_close
dw_vsl dw_vsl
st_1 st_1
rr_1 rr_1
st_2 st_2
st_3 st_3
gb_1 gb_1
rb_spec rb_spec
rb_voy rb_voy
em_do em_do
em_go em_go
em_lsfo em_lsfo
em_hsfo em_hsfo
end type
global w_voycalc w_voycalc

type variables

long il_vslid

String is_From, is_To

end variables

forward prototypes
public subroutine wf_calcfromto ()
public subroutine wf_calcvoyages ()
end prototypes

public subroutine wf_calcfromto ();String ls_from, ls_to
Integer li_Pos

li_Pos = Pos(is_from, '|')
If li_Pos>0 then 
	ls_from = Left(is_from, li_Pos - 1) + " / " + Right(is_from, Len(is_from) - li_Pos)
Else 
	If mid(is_from, 6, 2) = "xx" then ls_from = left(is_from, 4) + " / " + right(is_from, 2) else ls_from = is_from
End If

li_Pos = Pos(is_to, '|')
If li_Pos>0 then 
	ls_to = Left(is_to, li_Pos - 1) + " / " + Right(is_to, Len(is_to) - li_Pos)
Else
	If mid(is_to, 6, 2) = "xx" then ls_to = left(is_to, 4) + " / " + right(is_to, 2) else ls_to = is_to	
End If

st_voysel.text = ls_from + "  to  " + ls_to

end subroutine

public subroutine wf_calcvoyages ();
String ls_SpdSel
Byte lb_CalCsel, lb_BunkSel, lb_Stop, lb_Neg, lb_VoyType

Setpointer(HourGlass!)

If dw_Voy1.rowcount( ) > 0 then
	// Get retrival parameters	
	If cbx_Full.checked then ls_SpdSel = '0'
	If cbx_Econ.checked then ls_SpdSel += '1'
	If cbx_Adj.checked then ls_SpdSel += '2'
   If cbx_Conf.checked then ls_SpdSel += '3'
	If cbx_Wx.checked then ls_Spdsel += '4'	
	If cbx_Stop.checked then lb_Stop = 1 else lb_Stop = 0
	If cbx_Neg.checked then lb_Neg = 1 else lb_Neg = 0

	If rb_Time.checked then lb_CalcSel = 0 else lb_CalcSel = 1
	If rb_Voy.checked then lb_Bunksel = 0 else lb_Bunksel = 1
	
	If cbx_Laden.Checked then lb_VoyType = 0
	If cbx_Ballast.Checked then lb_VoyType = 1
	If cbx_Laden.Checked and cbx_Ballast.Checked then lb_VoyType = 2
	
	dw_Calc.retrieve( il_VslID, is_From, is_To, dec(em_TimeCost.text), dec(em_HSFO.text), dec(em_LSFO.text), dec(em_DO.text), dec(em_GO.text), lb_CalcSel, lb_Stop, ls_SpdSel, lb_Neg, lb_BunkSel, lb_VoyType)
	
Else  // No voyages
	dw_Calc.retrieve( il_vslid, "", "", 0, 0, 0, 0, 0, 0, 0, "", 0, 0, 0)
End if

// Display current warranted settings in header
Integer li_BFWind, li_BFSea, li_Percent, li_WrrVer, li_WrrType
Decimal ld_DevOSpd, ld_DevWSpd, ld_DevOCon, ld_DevWCon
SELECT TPERF_W_WIND, TPERF_W_SEA, TPERF_WRR_PERCENT, TPERF_DEV_OSPD, TPERF_DEV_WSPD, TPERF_DEV_OCON, TPERF_DEV_WCON, TPERF_WRR_VER, TPERF_WRRTYPE 
INTO :li_BFWind, :li_BFSea, :li_Percent, :ld_DevOSpd, :ld_DevWSpd, :ld_DevOCon, :ld_DevWCon, :li_WrrVer, :li_WrrType FROM VESSELS WHERE VESSEL_ID = :il_VslID;

If SQLCA.SQLCode < 0 then
	Rollback;
	dw_Calc.Object.t_wrr1.Text = "< Not available >"
	dw_Calc.Object.t_wrr2.Text = ""
	dw_Calc.Object.t_wrr3.Text = ""
	dw_Calc.Object.t_wrr4.Text = ""
	Return
Else
	If li_Percent = 0 then ls_SpdSel = "MT" else ls_SpdSel = "%"
	If lb_CalcSel = 0 then dw_Calc.Object.t_wrr1.Text = "1) Allowed speed tolerance: $$HEX1$$b100$$ENDHEX$$" + String(ld_DevOSpd, "0.0") + " " + ls_SpdSel Else dw_Calc.Object.t_wrr1.Text = "1) Allowed consumption tolerance: $$HEX1$$b100$$ENDHEX$$" + String(ld_DevWCon, "0.0") + " " + ls_SpdSel
	If li_Percent = 0 then ls_SpdSel = String(ld_DevOSpd, "0.00") + " Knots" Else ls_SpdSel = String(ld_DevOSpd, "0.0") + " %"
	//dw_Calc.Object.t_wrr2.Text = "2) Allowed speed margin: $$HEX1$$b100$$ENDHEX$$" + ls_SpdSel
	dw_Calc.Object.t_wrr2.Text = "2) Weather excluded: Wind Force above " + String(li_BFWind) + " BF; Sea state above " + String(li_BFSea) + " BF"
	dw_Calc.Object.t_wrr3.Text = "3) Warranted consumption excludes cargo heating and tank cleaning"
	Commit;
End If
end subroutine

on w_voycalc.create
this.cbx_detail=create cbx_detail
this.hpb_prg=create hpb_prg
this.cb_export=create cb_export
this.cbx_ballast=create cbx_ballast
this.cbx_laden=create cbx_laden
this.cb_calc=create cb_calc
this.cb_print=create cb_print
this.st_unit=create st_unit
this.cbx_neg=create cbx_neg
this.st_6=create st_6
this.dw_calc=create dw_calc
this.cbx_stop=create cbx_stop
this.cbx_wx=create cbx_wx
this.cbx_conf=create cbx_conf
this.cbx_adj=create cbx_adj
this.cbx_econ=create cbx_econ
this.cbx_full=create cbx_full
this.st_5=create st_5
this.st_oil4=create st_oil4
this.st_oil3=create st_oil3
this.st_oil2=create st_oil2
this.st_oil1=create st_oil1
this.gb_2=create gb_2
this.em_timecost=create em_timecost
this.st_tunit=create st_tunit
this.st_costlabel=create st_costlabel
this.rb_bunk=create rb_bunk
this.rb_time=create rb_time
this.st_4=create st_4
this.st_voysel=create st_voysel
this.dw_voy2=create dw_voy2
this.dw_voy1=create dw_voy1
this.cb_close=create cb_close
this.dw_vsl=create dw_vsl
this.st_1=create st_1
this.rr_1=create rr_1
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
this.rb_spec=create rb_spec
this.rb_voy=create rb_voy
this.em_do=create em_do
this.em_go=create em_go
this.em_lsfo=create em_lsfo
this.em_hsfo=create em_hsfo
this.Control[]={this.cbx_detail,&
this.hpb_prg,&
this.cb_export,&
this.cbx_ballast,&
this.cbx_laden,&
this.cb_calc,&
this.cb_print,&
this.st_unit,&
this.cbx_neg,&
this.st_6,&
this.dw_calc,&
this.cbx_stop,&
this.cbx_wx,&
this.cbx_conf,&
this.cbx_adj,&
this.cbx_econ,&
this.cbx_full,&
this.st_5,&
this.st_oil4,&
this.st_oil3,&
this.st_oil2,&
this.st_oil1,&
this.gb_2,&
this.em_timecost,&
this.st_tunit,&
this.st_costlabel,&
this.rb_bunk,&
this.rb_time,&
this.st_4,&
this.st_voysel,&
this.dw_voy2,&
this.dw_voy1,&
this.cb_close,&
this.dw_vsl,&
this.st_1,&
this.rr_1,&
this.st_2,&
this.st_3,&
this.gb_1,&
this.rb_spec,&
this.rb_voy,&
this.em_do,&
this.em_go,&
this.em_lsfo,&
this.em_hsfo}
end on

on w_voycalc.destroy
destroy(this.cbx_detail)
destroy(this.hpb_prg)
destroy(this.cb_export)
destroy(this.cbx_ballast)
destroy(this.cbx_laden)
destroy(this.cb_calc)
destroy(this.cb_print)
destroy(this.st_unit)
destroy(this.cbx_neg)
destroy(this.st_6)
destroy(this.dw_calc)
destroy(this.cbx_stop)
destroy(this.cbx_wx)
destroy(this.cbx_conf)
destroy(this.cbx_adj)
destroy(this.cbx_econ)
destroy(this.cbx_full)
destroy(this.st_5)
destroy(this.st_oil4)
destroy(this.st_oil3)
destroy(this.st_oil2)
destroy(this.st_oil1)
destroy(this.gb_2)
destroy(this.em_timecost)
destroy(this.st_tunit)
destroy(this.st_costlabel)
destroy(this.rb_bunk)
destroy(this.rb_time)
destroy(this.st_4)
destroy(this.st_voysel)
destroy(this.dw_voy2)
destroy(this.dw_voy1)
destroy(this.cb_close)
destroy(this.dw_vsl)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.rb_spec)
destroy(this.rb_voy)
destroy(this.em_do)
destroy(this.em_go)
destroy(this.em_lsfo)
destroy(this.em_hsfo)
end on

event open;
dw_vsl.settransobject( SQLCA)
dw_voy1.settransobject( SQLCA)
dw_voy2.settransobject( SQLCA)
dw_calc.settransobject( SQLCA)


dw_vsl.setfilter( '(vessel_active=1) and (numvoy>0)')

If dw_vsl.retrieve(g_userinfo.userid) > 0 then
	dw_vsl.selectrow( 0, False)
	dw_vsl.selectrow( 1, True)
	dw_vsl.SetRow(1)
	dw_vsl.scrolltorow( 1)
Else
  Return
End If

// Select correct logo on report
If g_userInfo.PC_Logo = 2 then  // If Handytankers
	dw_calc.object.p_handy.Visible = 1
	dw_calc.object.p_maersk.Visible = 0
	dw_calc.object.t_company.Text = "Handytankers"
End If

rb_time.checked = True
end event

event resize;Integer li_Pos, li_X

dw_calc.width=this.workspacewidth( )-dw_calc.x*2
dw_calc.height=this.workspaceheight( )-dw_calc.y - cb_close.height - dw_calc.x * 2
cb_close.y = dw_calc.y + dw_calc.height + dw_calc.x
cb_export.y = cb_close.y 
cb_print.y = cb_close.y 
hpb_prg.y = cb_close.y + 32

li_Pos = dw_calc.x + dw_calc.width - cb_close.width
If li_Pos < cb_Export.x + cb_Export.Width then li_Pos = cb_Export.x + cb_Export.width
hpb_prg.width = li_Pos - hpb_prg.x
cb_Close.x = li_Pos

end event

event key;If Key = KeyF1! then f_LaunchWiki("Office%20Program.aspx")
end event

type cbx_detail from checkbox within w_voycalc
integer x = 3566
integer y = 1232
integer width = 549
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show Bunker Details"
boolean checked = true
end type

event clicked;
If This.Checked then
	dw_Calc.Object.DataWindow.Detail.Height = 156
Else
	dw_Calc.Object.DataWindow.Detail.Height = 64
End If
end event

type hpb_prg from hprogressbar within w_voycalc
boolean visible = false
integer x = 1079
integer y = 2464
integer width = 1170
integer height = 64
unsignedinteger maxposition = 100
integer setstep = 1
end type

type cb_export from commandbutton within w_voycalc
integer x = 549
integer y = 2432
integer width = 530
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Export..."
end type

event clicked;Integer li_loop, li_Status, li_ColCount
Long ll_Rows
String ls_Temp
Decimal ldec_Temp
OLEObject lole_Excel

ll_Rows = dw_calc.RowCount( )

If ll_Rows = 0 then
	Messagebox("Export Error", "No data to export!", Exclamation!)
	Return
End If

SetPointer(HourGlass!)
This.Enabled = False
hpb_prg.Visible = True

lole_Excel = Create OLEObject
li_Status = lole_Excel.ConnectToNewObject("Excel.Application")

If li_Status < 0 then
	Messagebox("OLE Error", "Unable to open MS-Excel.~n~nReturn Code: " + String(li_Status))
	This.Enabled = True
	hpb_prg.Visible = False
	Return
End If

hpb_prg.MaxPosition = ll_Rows

Try
	lole_Excel.WorkBooks.Add   // Add a new workbook
	lole_Excel.ActiveWorkbook.Windows(1).WindowState = 4294963159    // Maximize workbook
	lole_Excel.ActiveWorkbook.Windows(1).DisplayGridlines = False    // No Gridlines
  Do While lole_Excel.ActiveWorkbook.Worksheets.Count > 1  // Delete any extra sheets
    lole_Excel.ActiveWorkbook.Worksheets(2).Delete
	Loop
	lole_Excel.Rows("5:7").HorizontalAlignment = 4294963188 // Center
	lole_Excel.Rows("5:7").VerticalAlignment = 4294963188 // Center
	lole_Excel.Rows("7:7").Font.Size = 8
	lole_Excel.Rows("7:7").Font.Color = RGB(128, 128, 128)
	lole_Excel.Rows("5:6").Font.Bold = True
	lole_Excel.Cells(1, 1).Value = "Tramper Performance Analysis"  // Heading	
	lole_Excel.Cells(1, 1).Font.Bold = True
	lole_Excel.Cells(1, 1).Font.Underline = True
	lole_Excel.Cells(1, 1).Font.Size = 12
	lole_Excel.Cells(3, 1).Value = Title
	lole_Excel.Cells(3, 1).Font.Bold = True
	lole_Excel.Cells(3, 1).Font.Underline = True
	
	// Write headers
	lole_Excel.Cells(6, 1).Value = "Voy No. / Leg"
	lole_Excel.Cells(6, 2).Value = "Voy Type"
	lole_Excel.Cells(6, 3).Value = "Started"
	lole_Excel.Cells(6, 4).Value = "Instructions"
	lole_Excel.Cells(6, 5).Value = "From"
	lole_Excel.Cells(6, 6).Value = "To"
	lole_Excel.Cells(6, 7).Value = "Distance"
	lole_Excel.Cells(6, 8).Value = "Average Speed"
	lole_Excel.Cells(6, 9).Value = "Sailing Period"
	lole_Excel.Cells(6, 10).Value = "Total Consumption"
	lole_Excel.Cells(6, 11).Value = "Allowed"
	lole_Excel.Cells(6, 12).Value = "Actual $"
	lole_Excel.Cells(6, 13).Value = "Actual $"
	lole_Excel.Cells(6, 14).Value = "Difference $"
	
	// Draw border around headers

	For li_Loop = 7 To 11
		lole_Excel.Range(lole_Excel.Cells(6, 1), lole_Excel.Cells(7, 14)).Borders(li_Loop).LineStyle = 1
	Next 
	
	// Write all rows
	For li_Loop = 1 to ll_Rows
		lole_Excel.Cells(li_Loop + 7, 1).Value = dw_Calc.GetItemString(li_Loop, "voyage_number")
		lole_Excel.Cells(li_Loop + 7, 2).Value = dw_Calc.GetItemString(li_Loop, "voyage_type")
		lole_Excel.Cells(li_Loop + 7, 3).Value = dw_Calc.GetItemDateTime(li_Loop, "start")
		lole_Excel.Cells(li_Loop + 7, 4).Value = dw_Calc.GetItemString(li_Loop, "instructions")
		lole_Excel.Cells(li_Loop + 7, 5).Value = dw_Calc.GetItemString(li_Loop, "dep")
		lole_Excel.Cells(li_Loop + 7, 6).Value = dw_Calc.GetItemString(li_Loop, "arr")
		lole_Excel.Cells(li_Loop + 7, 7).Value = dw_Calc.GetItemNumber(li_Loop, "tdist")
		lole_Excel.Cells(li_Loop + 7, 8).Value = dw_Calc.GetItemNumber(li_Loop, "avgspd")
		lole_Excel.Cells(li_Loop + 7, 9).Value = dw_Calc.GetItemNumber(li_Loop, "tperiod")
		lole_Excel.Cells(li_Loop + 7, 10).Value = dw_Calc.GetItemNumber(li_Loop, "tcons")
		lole_Excel.Cells(li_Loop + 7, 11).Value = dw_Calc.GetItemNumber(li_Loop, "allowed")
		lole_Excel.Cells(li_Loop + 7, 12).Value = dw_Calc.GetItemNumber(li_Loop, "actual")
		lole_Excel.Cells(li_Loop + 7, 13).Value = dw_Calc.GetItemNumber(li_Loop, "rate")
		lole_Excel.Cells(li_Loop + 7, 14).Value = dw_Calc.GetItemNumber(li_Loop, "diff")
		hpb_prg.StepIt()
	Next

	lole_Excel.Range(lole_Excel.Cells(6, 1), lole_Excel.Cells(li_Loop, 14)).Columns.AutoFit
	lole_Excel.Cells(1, 6).Select
	For li_Loop = 7 To 11
		lole_Excel.Range(lole_Excel.Cells(5, 1), lole_Excel.Cells(ll_Rows + 7, 14)).Borders(li_Loop).LineStyle = 1
	Next
		
	lole_Excel.Visible = True

Catch (RuntimeError re)
	Messagebox("Excel Error", "An error occurred while exporting to MS-Excel.", Exclamation!)
	lole_Excel.DisplayAlerts = False
	lole_Excel.Quit	
Finally
	This.Enabled = True
	hpb_prg.Visible = False
	hpb_prg.Position = 0
End Try


end event

type cbx_ballast from checkbox within w_voycalc
integer x = 3675
integer y = 880
integer width = 311
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ballast"
boolean checked = true
end type

event clicked;
If This.Checked = False then cbx_Laden.Checked = True
end event

type cbx_laden from checkbox within w_voycalc
integer x = 3675
integer y = 800
integer width = 311
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Laden"
boolean checked = true
end type

event clicked;
If This.Checked = False then cbx_Ballast.Checked = True
end event

type cb_calc from commandbutton within w_voycalc
integer x = 2176
integer y = 1088
integer width = 1920
integer height = 96
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Calculate Voyage List"
end type

event clicked;
wf_Calcvoyages( )
end event

type cb_print from commandbutton within w_voycalc
integer x = 18
integer y = 2432
integer width = 530
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;
dw_calc.print(True, True )
end event

type st_unit from statictext within w_voycalc
boolean visible = false
integer x = 3657
integer y = 352
integer width = 238
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 67108864
string text = "$ / MT"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_neg from checkbox within w_voycalc
integer x = 3675
integer y = 960
integer width = 366
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Negative"
end type

type st_6 from statictext within w_voycalc
integer x = 2231
integer y = 160
integer width = 494
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Range:"
boolean focusrectangle = false
end type

type dw_calc from datawindow within w_voycalc
integer x = 18
integer y = 1296
integer width = 4114
integer height = 1104
integer taborder = 100
string title = "none"
string dataobject = "d_sq_tb_voycalc"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_stop from checkbox within w_voycalc
integer x = 2907
integer y = 960
integer width = 677
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Stoppage / Breakdown"
end type

type cbx_wx from checkbox within w_voycalc
integer x = 2907
integer y = 880
integer width = 585
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bad Weather"
end type

type cbx_conf from checkbox within w_voycalc
integer x = 2907
integer y = 800
integer width = 585
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Confined Waters"
end type

type cbx_adj from checkbox within w_voycalc
integer x = 2286
integer y = 960
integer width = 585
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Adjusted Speed"
end type

type cbx_econ from checkbox within w_voycalc
integer x = 2286
integer y = 880
integer width = 585
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Economical Speed"
end type

type cbx_full from checkbox within w_voycalc
integer x = 2286
integer y = 800
integer width = 585
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Full Speed"
boolean checked = true
end type

type st_5 from statictext within w_voycalc
integer x = 2231
integer y = 720
integer width = 494
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sailing Selection:"
boolean focusrectangle = false
end type

type st_oil4 from statictext within w_voycalc
boolean visible = false
integer x = 3474
integer y = 672
integer width = 183
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "GO:"
boolean focusrectangle = false
end type

type st_oil3 from statictext within w_voycalc
boolean visible = false
integer x = 3474
integer y = 592
integer width = 183
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "DO:"
boolean focusrectangle = false
end type

type st_oil2 from statictext within w_voycalc
boolean visible = false
integer x = 3474
integer y = 512
integer width = 183
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "LSFO:"
boolean focusrectangle = false
end type

type st_oil1 from statictext within w_voycalc
boolean visible = false
integer x = 3474
integer y = 432
integer width = 183
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "HSFO:"
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_voycalc
boolean visible = false
integer x = 2761
integer y = 384
integer width = 585
integer height = 240
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type em_timecost from editmask within w_voycalc
integer x = 2798
integer y = 400
integer width = 347
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "0.00"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##,##0.00"
end type

type st_tunit from statictext within w_voycalc
integer x = 3182
integer y = 424
integer width = 238
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 67108864
string text = "$ / Day"
boolean focusrectangle = false
end type

type st_costlabel from statictext within w_voycalc
integer x = 2231
integer y = 424
integer width = 494
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Charter Rate:"
boolean focusrectangle = false
end type

type rb_bunk from radiobutton within w_voycalc
integer x = 3145
integer y = 272
integer width = 402
integer height = 96
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bunker"
end type

event clicked;
st_CostLabel.text = 'Bunker Rate:'
em_timecost.visible = False
st_TUnit.Visible = False

rb_spec.visible = True
rb_Voy.Visible = True

st_Oil1.Visible = rb_spec.checked
st_Oil2.Visible = rb_spec.checked
st_Oil3.Visible = rb_spec.checked
st_Oil4.Visible = rb_spec.checked
st_Unit.Visible = rb_spec.checked
em_hsfo.visible = rb_spec.checked
em_lsfo.visible = rb_spec.checked
em_do.visible = rb_spec.checked
em_go.visible = rb_spec.checked


end event

type rb_time from radiobutton within w_voycalc
integer x = 2798
integer y = 272
integer width = 219
integer height = 96
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Time"
end type

event clicked;
st_CostLabel.text = 'Charter Rate:'
em_timecost.visible = True
st_TUnit.Visible = True

rb_spec.visible = False
rb_Voy.Visible = False
st_Oil1.Visible = False
st_Oil2.Visible = False
st_Oil3.Visible = False
st_Oil4.Visible = False
st_Unit.Visible = False
em_hsfo.visible = False
em_lsfo.visible = False
em_do.visible = False
em_go.visible = False


end event

type st_4 from statictext within w_voycalc
integer x = 2231
integer y = 288
integer width = 494
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Calculation Type:"
boolean focusrectangle = false
end type

type st_voysel from statictext within w_voycalc
integer x = 2798
integer y = 160
integer width = 1061
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_voy2 from datawindow within w_voycalc
integer x = 1609
integer y = 112
integer width = 512
integer height = 1088
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_voysel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
this.selectrow(0, False)
this.selectrow(currentrow, True)

if currentrow>0 then is_To = dw_voy2.getitemstring (currentrow, "Voy_Num")

wf_calcfromto( )


end event

event clicked;
//if row>0 then
//	this.selectRow( 0 , false )
//	this.selectRow( row , true )
//	is_To = dw_voy2.getitemstring (row, "Voy_Num")
//	wf_calcfromto( )
//end if
end event

type dw_voy1 from datawindow within w_voycalc
integer x = 1024
integer y = 112
integer width = 512
integer height = 1088
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_voysel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;

this.selectrow(0, False)
this.selectrow(currentrow, True)

if currentrow>0 then 
	is_From = dw_voy1.getitemstring(currentrow, "Voy_Num") 
	
	dw_voy2.setfilter( "Voy_Num >= '" + is_From + "'")
	dw_voy2.filter( )
	
	dw_voy2.selectrow( 0, False)
	dw_voy2.selectrow( dw_voy2.rowcount( ) , True)
	
	wf_calcfromto( )
end if

end event

event clicked;
//if row>0 then
//	this.selectRow( 0 , false )
//	this.selectRow( row , true )
//	
//	is_From = this.getitemstring(row, "Voy_Num") 
//	
//	dw_voy2.setfilter( "Voy_Num >= '" + is_From + "'")
//	dw_voy2.filter( )
//	
//	dw_voy2.selectrow( 0, False)
//	dw_voy2.selectrow( dw_voy2.rowcount( ) , True)
//	
//	is_to = this.getitemstring(this.rowcount(), "Voy_Num") 
//	
//	wf_calcfromto( )
//end if
end event

event retrieveend;
If rowcount = 0 then st_voysel.text = ""
end event

type cb_close from commandbutton within w_voycalc
integer x = 2615
integer y = 2432
integer width = 530
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

event clicked;
close(parent)
end event

type dw_vsl from datawindow within w_voycalc
integer x = 55
integer y = 112
integer width = 896
integer height = 1088
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_vsllist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
string ls_sort
if dwo.type = "text" then
	ls_sort = dwo.Tag
	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort
end if

if row>0 then
	this.selectRow( 0 , false )
	this.selectRow( row , true )
	this.SetRow(row)
end if
end event

event rowfocuschanged;
long ll_rows

If currentrow = 0 then 
	dw_voy1.reset( )
	dw_voy2.reset( )
	st_voysel.text = ""
	Return
End If

il_vslid = this.GetItemNumber(Getrow(), "vessel_id")

ll_rows = dw_voy1.retrieve(il_vslid)
ll_rows = dw_voy2.retrieve(il_vslid)

if ll_rows >0 then
	dw_voy1.selectrow( 0, False)
	dw_voy1.selectrow( ll_rows , true)
   dw_voy2.scrolltorow( ll_rows)
	dw_voy1.scrolltorow( ll_rows)
end if

this.selectRow( 0 , false )
this.selectRow( currentrow , true )
end event

type st_1 from statictext within w_voycalc
integer x = 55
integer y = 48
integer width = 457
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Vessel:"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_voycalc
long linecolor = 10789024
integer linethickness = 4
long fillcolor = 67108864
integer x = 18
integer y = 16
integer width = 4114
integer height = 1200
integer cornerheight = 40
integer cornerwidth = 46
end type

type st_2 from statictext within w_voycalc
integer x = 1024
integer y = 48
integer width = 457
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "From:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_voycalc
integer x = 1609
integer y = 48
integer width = 457
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "To:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_voycalc
integer x = 2176
integer y = 48
integer width = 1920
integer height = 1024
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Calculation"
end type

type rb_spec from radiobutton within w_voycalc
boolean visible = false
integer x = 2798
integer y = 416
integer width = 507
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "User Specfied"
boolean checked = true
end type

event clicked;

st_oil1.Visible = True
st_oil2.Visible = True
st_oil3.Visible = True
st_oil4.Visible = True
st_Unit.Visible = True
em_hsfo.visible = True
em_lsfo.visible = True
em_do.visible = True
em_go.visible = True


end event

type rb_voy from radiobutton within w_voycalc
boolean visible = false
integer x = 2798
integer y = 512
integer width = 439
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "From Voyage"
end type

event clicked;

st_oil1.Visible = False
st_oil2.Visible = False
st_oil3.Visible = False
st_oil4.Visible = False
st_Unit.Visible = False
em_hsfo.visible = False
em_lsfo.visible = False
em_do.visible = False
em_go.visible = False


end event

type em_do from editmask within w_voycalc
boolean visible = false
integer x = 3657
integer y = 576
integer width = 238
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##0.00"
end type

type em_go from editmask within w_voycalc
boolean visible = false
integer x = 3657
integer y = 656
integer width = 238
integer height = 80
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##0.00"
end type

type em_lsfo from editmask within w_voycalc
boolean visible = false
integer x = 3657
integer y = 496
integer width = 238
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##0.00"
end type

type em_hsfo from editmask within w_voycalc
boolean visible = false
integer x = 3657
integer y = 416
integer width = 238
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##0.00"
end type

