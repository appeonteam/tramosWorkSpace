$PBExportHeader$w_export.srw
forward
global type w_export from window
end type
type hpb_prg from hprogressbar within w_export
end type
type cbx_all from checkbox within w_export
end type
type cbx_other from checkbox within w_export
end type
type cbx_stop from checkbox within w_export
end type
type cbx_badwx from checkbox within w_export
end type
type cbx_conf from checkbox within w_export
end type
type cbx_adj from checkbox within w_export
end type
type cbx_eco from checkbox within w_export
end type
type cbx_full from checkbox within w_export
end type
type cbx_draft from checkbox within w_export
end type
type gb_3 from groupbox within w_export
end type
type cbx_depdest from checkbox within w_export
end type
type cbx_period from checkbox within w_export
end type
type gb_2 from groupbox within w_export
end type
type st_1 from statictext within w_export
end type
type cb_export from commandbutton within w_export
end type
type cb_cancel from commandbutton within w_export
end type
type cbx_vsl from checkbox within w_export
end type
type cbx_voynum from checkbox within w_export
end type
type cbx_voytype from checkbox within w_export
end type
type cbx_inst from checkbox within w_export
end type
type dw_export from datawindow within w_export
end type
end forward

global type w_export from window
integer width = 1824
integer height = 1356
boolean titlebar = true
string title = "Excel Export"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
hpb_prg hpb_prg
cbx_all cbx_all
cbx_other cbx_other
cbx_stop cbx_stop
cbx_badwx cbx_badwx
cbx_conf cbx_conf
cbx_adj cbx_adj
cbx_eco cbx_eco
cbx_full cbx_full
cbx_draft cbx_draft
gb_3 gb_3
cbx_depdest cbx_depdest
cbx_period cbx_period
gb_2 gb_2
st_1 st_1
cb_export cb_export
cb_cancel cb_cancel
cbx_vsl cbx_vsl
cbx_voynum cbx_voynum
cbx_voytype cbx_voytype
cbx_inst cbx_inst
dw_export dw_export
end type
global w_export w_export

type variables

Long il_VoyList[]
end variables

forward prototypes
public function decimal wf_null2zero (decimal adec_value)
end prototypes

public function decimal wf_null2zero (decimal adec_value);
// Function to return 0 for nulls when argument is to be used in expressions

If IsNull(adec_value) then Return 0 Else Return adec_value

end function

on w_export.create
this.hpb_prg=create hpb_prg
this.cbx_all=create cbx_all
this.cbx_other=create cbx_other
this.cbx_stop=create cbx_stop
this.cbx_badwx=create cbx_badwx
this.cbx_conf=create cbx_conf
this.cbx_adj=create cbx_adj
this.cbx_eco=create cbx_eco
this.cbx_full=create cbx_full
this.cbx_draft=create cbx_draft
this.gb_3=create gb_3
this.cbx_depdest=create cbx_depdest
this.cbx_period=create cbx_period
this.gb_2=create gb_2
this.st_1=create st_1
this.cb_export=create cb_export
this.cb_cancel=create cb_cancel
this.cbx_vsl=create cbx_vsl
this.cbx_voynum=create cbx_voynum
this.cbx_voytype=create cbx_voytype
this.cbx_inst=create cbx_inst
this.dw_export=create dw_export
this.Control[]={this.hpb_prg,&
this.cbx_all,&
this.cbx_other,&
this.cbx_stop,&
this.cbx_badwx,&
this.cbx_conf,&
this.cbx_adj,&
this.cbx_eco,&
this.cbx_full,&
this.cbx_draft,&
this.gb_3,&
this.cbx_depdest,&
this.cbx_period,&
this.gb_2,&
this.st_1,&
this.cb_export,&
this.cb_cancel,&
this.cbx_vsl,&
this.cbx_voynum,&
this.cbx_voytype,&
this.cbx_inst,&
this.dw_export}
end on

on w_export.destroy
destroy(this.hpb_prg)
destroy(this.cbx_all)
destroy(this.cbx_other)
destroy(this.cbx_stop)
destroy(this.cbx_badwx)
destroy(this.cbx_conf)
destroy(this.cbx_adj)
destroy(this.cbx_eco)
destroy(this.cbx_full)
destroy(this.cbx_draft)
destroy(this.gb_3)
destroy(this.cbx_depdest)
destroy(this.cbx_period)
destroy(this.gb_2)
destroy(this.st_1)
destroy(this.cb_export)
destroy(this.cb_cancel)
destroy(this.cbx_vsl)
destroy(this.cbx_voynum)
destroy(this.cbx_voytype)
destroy(this.cbx_inst)
destroy(this.dw_export)
end on

event open;
struct_voylist lstruct_List

dw_Export.SetTransObject(SQLCA)

lstruct_List = Message.PowerObjectParm
il_VoyList = lstruct_List.Voylist
end event

type hpb_prg from hprogressbar within w_export
integer x = 55
integer y = 1040
integer width = 1701
integer height = 64
unsignedinteger maxposition = 100
integer setstep = 1
end type

type cbx_all from checkbox within w_export
integer x = 1006
integer y = 912
integer width = 512
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Overall"
boolean checked = true
end type

type cbx_other from checkbox within w_export
integer x = 1006
integer y = 816
integer width = 549
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Other Consumption"
boolean checked = true
end type

type cbx_stop from checkbox within w_export
integer x = 1006
integer y = 720
integer width = 640
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Stoppage / Breakdown"
boolean checked = true
end type

type cbx_badwx from checkbox within w_export
integer x = 1006
integer y = 624
integer width = 512
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bad Weather"
end type

type cbx_conf from checkbox within w_export
integer x = 1006
integer y = 528
integer width = 494
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Confined Waters"
end type

type cbx_adj from checkbox within w_export
integer x = 1006
integer y = 432
integer width = 567
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Adjusted Speed"
end type

type cbx_eco from checkbox within w_export
integer x = 1006
integer y = 336
integer width = 603
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Economical Speed"
end type

type cbx_full from checkbox within w_export
integer x = 1006
integer y = 240
integer width = 512
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Full Speed"
end type

type cbx_draft from checkbox within w_export
integer x = 128
integer y = 816
integer width = 512
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mean Draft"
end type

type gb_3 from groupbox within w_export
integer x = 933
integer y = 144
integer width = 823
integer height = 880
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sailing Data"
end type

type cbx_depdest from checkbox within w_export
integer x = 128
integer y = 720
integer width = 585
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "From / To"
boolean checked = true
end type

type cbx_period from checkbox within w_export
integer x = 128
integer y = 624
integer width = 622
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Started / Completed"
boolean checked = true
end type

type gb_2 from groupbox within w_export
integer x = 55
integer y = 144
integer width = 823
integer height = 880
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "General"
end type

type st_1 from statictext within w_export
integer x = 37
integer y = 32
integer width = 1371
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please select the data you would like to export:"
boolean focusrectangle = false
end type

type cb_export from commandbutton within w_export
integer x = 274
integer y = 1136
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Export"
boolean default = true
end type

event clicked;Integer li_loop, li_Status, li_ColCount
Long ll_Rows
String ls_Temp
Decimal ldec_Temp
OLEObject lole_Excel

This.Enabled = False
cb_Cancel.Enabled = False

SetPointer(HourGlass!)

lole_Excel = Create OLEObject
li_Status = lole_Excel.ConnectToNewObject("Excel.Application")

If li_Status < 0 then
	Messagebox("OLE Error", "Unable to open MS-Excel.~n~nReturn Code: " + String(li_Status))
	This.Enabled = True
  cb_Cancel.Enabled = True
	Return
End If

//Messagebox("Len", Upperbound(il_VoyList))

ll_Rows = dw_Export.Retrieve(il_Voylist)

If ll_Rows <= 0 then
	Messagebox("DW Error", "Could not retrieve voyage data.", Exclamation!)
	This.Enabled = True
	cb_Cancel.Enabled = True
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
	
	// Start of headers
	lole_Excel.Cells(6, 1).Value = "Vsl ID"
	lole_Excel.Cells(6, 2).Value = "Vessel Name"
  lole_Excel.Range(lole_Excel.Cells(8, 1), lole_Excel.Cells(ll_Rows + 7, 1)).HorizontalAlignment = 4294963188  // Center
  lole_Excel.Range(lole_Excel.Cells(8, 2), lole_Excel.Cells(ll_Rows + 7, 2)).HorizontalAlignment = 4294963165  // Left
	li_ColCount = 3
	If cbx_Voynum.Checked then  // Voyage Number
		lole_Excel.Cells(6, li_ColCount).Value = "Voy No."
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).HorizontalAlignment = 4294963165  // Left
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "@"	
		li_ColCount ++
		lole_Excel.Cells(6, li_ColCount).Value = "Leg"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).HorizontalAlignment = 4294963188  // Center
		li_ColCount ++		
	End If
	If cbx_VoyType.Checked then  // Voyage Type
		lole_Excel.Cells(6, li_ColCount).Value = "Voy Type"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).HorizontalAlignment = 4294963165  // Left		
		li_ColCount ++
	End If
	If cbx_Inst.Checked then  // Instructions
		lole_Excel.Cells(6, li_ColCount).Value = "Instructions"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).HorizontalAlignment = 4294963188  // Center		
		li_ColCount ++
		lole_Excel.Cells(6, li_ColCount).Value = "Order"
		lole_Excel.Cells(7, li_ColCount).Value = "Knots or MT/Day"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"	
		li_ColCount ++		
	End If
	If cbx_Period.Checked then  // Commenced/Completed
		lole_Excel.Cells(6, li_ColCount).Value = "Commenced"
		lole_Excel.Cells(7, li_ColCount).Value = "hh:mm dd-mm-yy"		
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).HorizontalAlignment = 4294963188  // Center
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "hh:mm dd-mm-yy"  // Center
		li_ColCount ++		
		lole_Excel.Cells(6, li_ColCount).Value = "Completed"
		lole_Excel.Cells(7, li_ColCount).Value = "hh:mm dd-mm-yy"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).HorizontalAlignment = 4294963188  // Center		
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "hh:mm dd-mm-yy"  // Center
		li_ColCount ++				
	End If
	If cbx_DepDest.Checked then  // Dep & Dest
		lole_Excel.Cells(6, li_ColCount).Value = "From"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).HorizontalAlignment = 4294963165  // Left				
		li_ColCount ++		
		lole_Excel.Cells(6, li_ColCount).Value = "To"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).HorizontalAlignment = 4294963165  // Left		
		li_ColCount ++				
	End If	
	If cbx_Draft.Checked then   // Mean Draft
		lole_Excel.Cells(6, li_ColCount).Value = "Mean Draft"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"
		li_ColCount ++		
	End If
	lole_Excel.Range(lole_Excel.Cells(5, 1), lole_Excel.Cells(5, li_ColCount - 1)).Merge
	lole_Excel.Cells(5, 1).Value = "General"	
	If cbx_Full.Checked then  // Full Speed
		lole_Excel.Range(lole_Excel.Cells(5, li_ColCount), lole_Excel.Cells(5, li_ColCount + 4)).Merge
    lole_Excel.Cells(5, li_ColCount).Value = "Full Speed"
		lole_Excel.Cells(6, li_ColCount).Value = "Period"
		lole_Excel.Cells(7, li_ColCount).Value = "Hours"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.00"			
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "Obs Dist"
		lole_Excel.Cells(7, li_ColCount).Value = "N. Miles"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"	
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "Speed"
		lole_Excel.Cells(7, li_ColCount).Value = "Knots"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.00"			
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "ME FO"
		lole_Excel.Cells(7, li_ColCount).Value = "Tons"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"			
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "ME Daily"
		lole_Excel.Cells(7, li_ColCount).Value = "Tons/Day"	
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"	
		li_ColCount++
	End If
	If cbx_Eco.Checked then  // Economical Speed
		lole_Excel.Range(lole_Excel.Cells(5, li_ColCount), lole_Excel.Cells(5, li_ColCount + 4)).Merge
    lole_Excel.Cells(5, li_ColCount).Value = "Economic Speed"
		lole_Excel.Cells(6, li_ColCount).Value = "Period"
		lole_Excel.Cells(7, li_ColCount).Value = "Hours"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.00"			
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "Obs Dist"
		lole_Excel.Cells(7, li_ColCount).Value = "N. Miles"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"			
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "Speed"
		lole_Excel.Cells(7, li_ColCount).Value = "Knots"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.00"			
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "ME FO"
		lole_Excel.Cells(7, li_ColCount).Value = "Tons"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"			
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "ME Daily"
		lole_Excel.Cells(7, li_ColCount).Value = "Tons/Day"	
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"			
		li_ColCount++
	End If
	If cbx_Adj.Checked then  // Adjusted Speed
		lole_Excel.Range(lole_Excel.Cells(5, li_ColCount), lole_Excel.Cells(5, li_ColCount + 4)).Merge
    lole_Excel.Cells(5, li_ColCount).Value = "Adjusted Speed"
		lole_Excel.Cells(6, li_ColCount).Value = "Period"
		lole_Excel.Cells(7, li_ColCount).Value = "Hours"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.00"			
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "Obs Dist"
		lole_Excel.Cells(7, li_ColCount).Value = "N. Miles"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "Speed"
		lole_Excel.Cells(7, li_ColCount).Value = "Knots"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.00"			
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "ME FO"
		lole_Excel.Cells(7, li_ColCount).Value = "Tons"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"			
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "ME Daily"
		lole_Excel.Cells(7, li_ColCount).Value = "Tons/Day"	
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"
		li_ColCount++
	End If
	If cbx_Conf.Checked then  // Confined Waters
		lole_Excel.Range(lole_Excel.Cells(5, li_ColCount), lole_Excel.Cells(5, li_ColCount + 4)).Merge
    lole_Excel.Cells(5, li_ColCount).Value = "Confined Waters"
		lole_Excel.Cells(6, li_ColCount).Value = "Period"
		lole_Excel.Cells(7, li_ColCount).Value = "Hours"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.00"		
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "Obs Dist"
		lole_Excel.Cells(7, li_ColCount).Value = "N. Miles"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"		
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "Speed"
		lole_Excel.Cells(7, li_ColCount).Value = "Knots"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.00"
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "ME FO"
		lole_Excel.Cells(7, li_ColCount).Value = "Tons"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"		
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "ME Daily"
		lole_Excel.Cells(7, li_ColCount).Value = "Tons/Day"	
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"		
		li_ColCount++
	End If	
	If cbx_BadWx.Checked then   // Bad Weather
		lole_Excel.Range(lole_Excel.Cells(5, li_ColCount), lole_Excel.Cells(5, li_ColCount + 4)).Merge
    lole_Excel.Cells(5, li_ColCount).Value = "Bad Weather"
		lole_Excel.Cells(6, li_ColCount).Value = "Period"
		lole_Excel.Cells(7, li_ColCount).Value = "Hours"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.00"		
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "Obs Dist"
		lole_Excel.Cells(7, li_ColCount).Value = "N. Miles"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"		
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "Speed"
		lole_Excel.Cells(7, li_ColCount).Value = "Knots"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.00"		
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "ME FO"
		lole_Excel.Cells(7, li_ColCount).Value = "Tons"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"		
		li_ColCount++
		lole_Excel.Cells(6, li_ColCount).Value = "ME Daily"
		lole_Excel.Cells(7, li_ColCount).Value = "Tons/Day"	
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.0"		
		li_ColCount++
	End If	
	If cbx_Stop.Checked then  // Stoppages
		lole_Excel.Cells(6, li_ColCount).Value = "Stoppage"
		lole_Excel.Cells(7, li_ColCount).Value = "Hours"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).NumberFormat = "0.00"		
		li_ColCount ++
	End If
	If cbx_Other.Checked Then  // Other Consumption
		lole_Excel.Range(lole_Excel.Cells(5, li_ColCount), lole_Excel.Cells(5, li_ColCount + 5)).Merge
		lole_Excel.Cells(5, li_ColCount).Value = "Other Consumption"
		lole_Excel.Cells(6, li_ColCount).Value = "Total Aux"
		lole_Excel.Cells(6, li_ColCount + 1).Value = "Pumping"
		lole_Excel.Cells(6, li_ColCount + 2).Value = "Boiler"
		lole_Excel.Cells(6, li_ColCount + 3).Value = "Inerting"
		lole_Excel.Cells(6, li_ColCount + 4).Value = "Cool/Heat"
		lole_Excel.Cells(6, li_ColCount + 5).Value = "Misc."
		lole_Excel.Range(lole_Excel.Cells(7, li_ColCount), lole_Excel.Cells(7, li_ColCount + 5)).Value = "Tons"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount + 5)).NumberFormat = "0.0"
		li_ColCount += 6
	End If	
	If cbx_All.Checked Then
		lole_Excel.Range(lole_Excel.Cells(5, li_ColCount), lole_Excel.Cells(5, li_ColCount + 5)).Merge
		lole_Excel.Cells(5, li_ColCount).Value = "Voyage Total"
		lole_Excel.Cells(6, li_ColCount).Value = "Period"
		lole_Excel.Cells(6, li_ColCount + 1).Value = "Obs Dist"
		lole_Excel.Cells(6, li_ColCount + 2).Value = "Speed"
		lole_Excel.Cells(6, li_ColCount + 3).Value = "ME FO"
		lole_Excel.Cells(6, li_ColCount + 4).Value = "ME Daily"
		lole_Excel.Cells(6, li_ColCount + 5).Value = "Total FO"
		lole_Excel.Cells(7, li_ColCount).Value = "Hours"
		lole_Excel.Cells(7, li_ColCount + 1).Value = "N. Miles"
		lole_Excel.Cells(7, li_ColCount + 2).Value = "Knots"
		lole_Excel.Cells(7, li_ColCount + 3).Value = "Tons"
		lole_Excel.Cells(7, li_ColCount + 4).Value = "Tons/Day"
		lole_Excel.Cells(7, li_ColCount + 5).Value = "Tons"
		lole_Excel.Range(lole_Excel.Cells(8, li_ColCount), lole_Excel.Cells(ll_Rows + 7, li_ColCount + 5)).NumberFormat = "0.0"		
		li_ColCount += 6
	End If
	li_ColCount --
  lole_Excel.Range(lole_Excel.Cells(5, 1), lole_Excel.Cells(5, li_ColCount)).Borders(9).LineStyle = 1
	For li_Loop = 7 To 11
		lole_Excel.Range(lole_Excel.Cells(5, 1), lole_Excel.Cells(7, li_ColCount)).Borders(li_Loop).LineStyle = 1
	Next 

	For li_Loop = 1 to ll_Rows
		lole_Excel.Cells(li_Loop + 7, 1).Value = dw_Export.GetItemString(li_Loop, "Vessel_no")
		lole_Excel.Cells(li_Loop + 7, 2).Value = dw_Export.GetItemString(li_Loop, "Vessel_name")
		li_ColCount = 3
		If cbx_VoyType.Checked then 
			ls_Temp = dw_Export.GetItemString(li_Loop, "Voyage_Number")
			If Pos(ls_Temp , "|") > 0 then
				lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = Left(ls_Temp, Pos(ls_Temp, "|") - 1)
				li_ColCount ++
				lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = Right(ls_Temp, Len(ls_Temp) - Pos(ls_temp, "|"))
			Else
				If Mid(ls_Temp, 6, 2) = "xx" then lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = Left(ls_Temp, 4) Else lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = Left(ls_Temp, 7)
				li_ColCount ++
				lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = Right(ls_Temp, 2)
			End If
			li_ColCount ++
		End If
		If cbx_VoyType.Checked then 
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemString(li_Loop, "Voyage_Type")
			li_ColCount ++
		End If
		If cbx_Inst.Checked then
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemString(li_Loop, "Voyage_Order")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "Order_Value")
			li_ColCount ++			
		End If
		If cbx_Period.Checked then 
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemDateTime(li_Loop, "Started")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemDateTime(li_Loop, "Completed")
			li_ColCount ++			
		End If
		If cbx_DepDest.Checked then 
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemString(li_Loop, "Departure")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemString(li_Loop, "Arrival")
			li_ColCount ++			
		End If
		If cbx_Draft.Checked then 
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "Mean_Draft")
			li_ColCount ++
		End If
    If cbx_Full.Checked then
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "FullSpd_Period")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "FullSpd_Distance")
			li_ColCount ++
			If dw_Export.GetItemNumber(li_Loop, "FullSpd_Period") > 0 then lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "FullSpd_Distance") / dw_Export.GetItemNumber(li_Loop, "FullSpd_Period")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "FullSpd_ME_Cons")
			li_ColCount ++
			If dw_Export.GetItemNumber(li_Loop, "FullSpd_Period") > 0 then lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "FullSpd_ME_Cons") * 24 / dw_Export.GetItemNumber(li_Loop, "FullSpd_Period")			
			li_ColCount ++
		End If
    If cbx_Eco.Checked then
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "EcoSpd_Period")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "EcoSpd_Distance")
			li_ColCount ++
			If dw_Export.GetItemNumber(li_Loop, "EcoSpd_Period") > 0 then lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "EcoSpd_Distance") / dw_Export.GetItemNumber(li_Loop, "EcoSpd_Period")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "EcoSpd_ME_Cons")
			li_ColCount ++
			If dw_Export.GetItemNumber(li_Loop, "EcoSpd_Period") > 0 then lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "EcoSpd_ME_Cons") * 24 / dw_Export.GetItemNumber(li_Loop, "EcoSpd_Period")			
			li_ColCount ++
		End If
    If cbx_Adj.Checked then
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "AdjSpd_Period")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "AdjSpd_Distance")
			li_ColCount ++
			If dw_Export.GetItemNumber(li_Loop, "AdjSpd_Period") > 0 then lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "AdjSpd_Distance") / dw_Export.GetItemNumber(li_Loop, "AdjSpd_Period")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "AdjSpd_ME_Cons")
			li_ColCount ++
			If dw_Export.GetItemNumber(li_Loop, "AdjSpd_Period") > 0 then lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "AdjSpd_ME_Cons") * 24 / dw_Export.GetItemNumber(li_Loop, "AdjSpd_Period")			
			li_ColCount ++
		End If
    If cbx_Conf.Checked then
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "ConfWaters_Period")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "ConfWaters_Distance")
			li_ColCount ++
			If dw_Export.GetItemNumber(li_Loop, "ConfWaters_Period") > 0 then lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "ConfWaters_Distance") / dw_Export.GetItemNumber(li_Loop, "ConfWaters_Period")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "ConfWaters_ME_Cons")
			li_ColCount ++
			If dw_Export.GetItemNumber(li_Loop, "ConfWaters_Period") > 0 then lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "ConfWaters_ME_Cons") * 24 / dw_Export.GetItemNumber(li_Loop, "ConfWaters_Period")			
			li_ColCount ++
		End If
    If cbx_BadWx.Checked then
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "BadWx_Period")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "BadWx_Distance")
			li_ColCount ++
			If dw_Export.GetItemNumber(li_Loop, "BadWx_Period") > 0 then lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "BadWx_Distance") / dw_Export.GetItemNumber(li_Loop, "BadWx_Period")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "BadWx_ME_Cons")
			li_ColCount ++
			If dw_Export.GetItemNumber(li_Loop, "BadWx_Period") > 0 then lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "BadWx_ME_Cons") * 24 / dw_Export.GetItemNumber(li_Loop, "BadWx_Period")			
			li_ColCount ++
		End If
		If cbx_Stop.Checked then 
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "Stoppage_Period")
			li_ColCount ++
		End If
		If cbx_Other.Checked then
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = wf_Null2Zero(dw_Export.GetItemNumber(li_Loop, "Stoppage_AE_Cons")) + wf_Null2Zero(dw_Export.GetItemNumber(li_Loop, "FullSpd_AE_Cons")) + wf_Null2Zero(dw_Export.GetItemNumber(li_Loop, "EcoSpd_AE_Cons")) + wf_Null2Zero(dw_Export.GetItemNumber(li_Loop, "AdjSpd_AE_Cons")) + wf_Null2Zero(dw_Export.GetItemNumber(li_Loop, "ConfWaters_AE_Cons")) + wf_Null2Zero(dw_Export.GetItemNumber(li_Loop, "BadWx_AE_Cons"))
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "Pumping_Cons")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "Boiler_Cons")
			li_ColCount ++
  		lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "Inerting_Cons")
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "HeatCool_Cons")
			li_ColCount ++			
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "Misc_Cons")
			li_ColCount ++			
		End If
		If cbx_All.Checked then 
			ldec_Temp = dw_Export.GetItemNumber(li_Loop, "Stoppage_Period")+dw_Export.GetItemNumber(li_Loop, "FullSpd_Period")+dw_Export.GetItemNumber(li_Loop, "EcoSpd_Period")+dw_Export.GetItemNumber(li_Loop, "AdjSpd_Period")+dw_Export.GetItemNumber(li_Loop, "ConfWaters_Period")+dw_Export.GetItemNumber(li_Loop, "BadWx_Period")
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = ldec_Temp
			li_ColCount ++
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "FullSpd_Distance") + dw_Export.GetItemNumber(li_Loop, "EcoSpd_Distance") + dw_Export.GetItemNumber(li_Loop, "AdjSpd_Distance")+dw_Export.GetItemNumber(li_Loop, "ConfWaters_Distance")+dw_Export.GetItemNumber(li_Loop, "BadWx_Distance")
			li_ColCount ++
			If ldec_Temp > 0 then	lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = (dw_Export.GetItemNumber(li_Loop, "FullSpd_Distance")+dw_Export.GetItemNumber(li_Loop, "EcoSpd_Distance")+dw_Export.GetItemNumber(li_Loop, "AdjSpd_Distance")+dw_Export.GetItemNumber(li_Loop, "ConfWaters_Distance")+dw_Export.GetItemNumber(li_Loop, "BadWx_Distance")) / ldec_Temp
			li_ColCount ++
  		lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "FullSpd_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "EcoSpd_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "AdjSpd_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "ConfWaters_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "BadWx_ME_Cons")
			li_ColCount ++
			If ldec_Temp > 0 then	lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = (dw_Export.GetItemNumber(li_Loop, "FullSpd_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "EcoSpd_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "AdjSpd_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "ConfWaters_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "BadWx_ME_Cons")) / ldec_Temp * 24
			li_ColCount ++			
			lole_Excel.Cells(li_Loop + 7, li_ColCount).Value = dw_Export.GetItemNumber(li_Loop, "FullSpd_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "EcoSpd_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "AdjSpd_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "ConfWaters_ME_Cons")+dw_Export.GetItemNumber(li_Loop, "BadWx_ME_Cons") + dw_Export.GetItemNumber(li_Loop, "Stoppage_AE_Cons")+dw_Export.GetItemNumber(li_Loop, "FullSpd_AE_Cons")+dw_Export.GetItemNumber(li_Loop, "EcoSpd_AE_Cons")+dw_Export.GetItemNumber(li_Loop, "AdjSpd_AE_Cons")+dw_Export.GetItemNumber(li_Loop, "ConfWaters_AE_Cons")+dw_Export.GetItemNumber(li_Loop, "BadWx_AE_Cons") + dw_Export.GetItemNumber(li_Loop, "Pumping_Cons") + dw_Export.GetItemNumber(li_Loop, "Boiler_Cons")+dw_Export.GetItemNumber(li_Loop, "Inerting_Cons")+dw_Export.GetItemNumber(li_Loop, "HeatCool_Cons")+dw_Export.GetItemNumber(li_Loop, "Misc_Cons")
			li_ColCount ++					
		End If
		hpb_prg.StepIt()
	Next 
	
	li_ColCount --
	lole_Excel.Range(lole_Excel.Cells(6, 1), lole_Excel.Cells(li_Loop, li_ColCount)).Columns.AutoFit
	lole_Excel.Cells(1, 6).Select
    For li_Loop = 7 To 11
      lole_Excel.Range(lole_Excel.Cells(5, 1), lole_Excel.Cells(ll_Rows + 7, li_ColCount)).Borders(li_Loop).LineStyle = 1
    Next
  lole_Excel.Visible = True
	
	Close(Parent)	
Catch (RuntimeError re)
	Messagebox("Excel Error", "An error occurred while exporting to MS-Excel.", Exclamation!)
	lole_Excel.DisplayAlerts = False
	lole_Excel.Quit
	cb_Cancel.Enabled = True
	Return
End Try



//    llp = llp - 1: ColCount = ColCount - 1
//    .Range(.Cells(5, 1), .Cells(llp, ColCount)).Columns.AutoFit
//    For Period = 7 To 11
//      .Range(.Cells(5, 1), .Cells(llp, ColCount)).Borders(Period).LineStyle = 1
//    Next Period
//    .Cells(1, 5).Select
//    .Visible = True
//  End With
//  Unload Me
//  Exit Sub
//ErrHnd:
//  MsgBox "An error occured when attempting to export to MS-Excel." & vb2CR & "Error:" & Err.Description, vbExclamation, "Export Error"
//  Me.Enabled = True
//  If Not (Exc Is Nothing) Then
//    Exc.DisplayAlerts = False
//    Exc.Quit
//    Set Exc = Nothing
//  End If
//  Unload Me
//End Sub
end event

type cb_cancel from commandbutton within w_export
integer x = 1115
integer y = 1136
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type cbx_vsl from checkbox within w_export
integer x = 128
integer y = 240
integer width = 526
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Vessel No. && Name"
boolean checked = true
end type

type cbx_voynum from checkbox within w_export
integer x = 128
integer y = 336
integer width = 567
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Number"
boolean checked = true
end type

type cbx_voytype from checkbox within w_export
integer x = 128
integer y = 432
integer width = 512
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Type"
boolean checked = true
end type

type cbx_inst from checkbox within w_export
integer x = 128
integer y = 528
integer width = 494
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Instructions"
boolean checked = true
end type

type dw_export from datawindow within w_export
boolean visible = false
integer x = 1042
integer y = 32
integer width = 695
integer height = 112
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sq_tb_voyexport"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

