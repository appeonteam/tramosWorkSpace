$PBExportHeader$w_capexport.srw
forward
global type w_capexport from window
end type
type dw_caps from datawindow within w_capexport
end type
type st_1 from statictext within w_capexport
end type
type st_new from statictext within w_capexport
end type
type st_all from statictext within w_capexport
end type
type rb_new from radiobutton within w_capexport
end type
type rb_all from radiobutton within w_capexport
end type
type cb_export from commandbutton within w_capexport
end type
type cb_cancel from commandbutton within w_capexport
end type
type gb_1 from groupbox within w_capexport
end type
type gb_2 from groupbox within w_capexport
end type
end forward

global type w_capexport from window
integer width = 2363
integer height = 1756
boolean titlebar = true
string title = "Export CAPs"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_caps dw_caps
st_1 st_1
st_new st_new
st_all st_all
rb_new rb_new
rb_all rb_all
cb_export cb_export
cb_cancel cb_cancel
gb_1 gb_1
gb_2 gb_2
end type
global w_capexport w_capexport

type variables

Long il_InspID
end variables

on w_capexport.create
this.dw_caps=create dw_caps
this.st_1=create st_1
this.st_new=create st_new
this.st_all=create st_all
this.rb_new=create rb_new
this.rb_all=create rb_all
this.cb_export=create cb_export
this.cb_cancel=create cb_cancel
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.dw_caps,&
this.st_1,&
this.st_new,&
this.st_all,&
this.rb_new,&
this.rb_all,&
this.cb_export,&
this.cb_cancel,&
this.gb_1,&
this.gb_2}
end on

on w_capexport.destroy
destroy(this.dw_caps)
destroy(this.st_1)
destroy(this.st_new)
destroy(this.st_all)
destroy(this.rb_new)
destroy(this.rb_all)
destroy(this.cb_export)
destroy(this.cb_cancel)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;
il_InspID = Long(Message.DoubleParm)

dw_CAPs.SetTransObject(SQLCA)
dw_Caps.Retrieve(il_InspID)




end event

type dw_caps from datawindow within w_capexport
integer x = 91
integer y = 864
integer width = 2158
integer height = 576
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_capexp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_capexport
integer x = 91
integer y = 784
integer width = 1751
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Based on the above selection, the following CAPs will be exported:"
boolean focusrectangle = false
end type

type st_new from statictext within w_capexport
integer x = 311
integer y = 504
integer width = 1774
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "All observations marked as CAP that have never been exported before will be exported. Use this option for newly created CAPs."
boolean focusrectangle = false
end type

type st_all from statictext within w_capexport
integer x = 311
integer y = 224
integer width = 1838
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "All observations marked as CAP will be exported even if they have been exported before. Use this option for new exports or if a previous export has failed."
boolean focusrectangle = false
end type

type rb_new from radiobutton within w_capexport
integer x = 201
integer y = 400
integer width = 713
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Export New CAPs Only"
end type

event clicked;
dw_CAPs.SetFilter("cap_gen=0")
dw_CAps.Filter()
end event

type rb_all from radiobutton within w_capexport
integer x = 201
integer y = 128
integer width = 603
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Export All CAPs"
boolean checked = true
end type

event clicked;
dw_CAPs.SetFilter("")
dw_CAps.Filter()
end event

type cb_export from commandbutton within w_capexport
integer x = 512
integer y = 1536
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Export"
end type

event clicked;
Integer li_Exp

If dw_Caps.RowCount() = 0 then 
	Messagebox("Nothing to Export", "There are no CAPs to export!")
	Return
End If

// Get Insp CAP export status
Select CAPEXPFLAG into :li_Exp from VETT_INSP Where INSP_ID = :il_InspID;

If SQLCA.SQLCode <> 0 then
	Rollback;
	Messagebox("DB Error", "Unable to retrieve inspection export status~n~n" + SQLCA.SQLErrText, Exclamation!)
	Return
End If

Commit;

/* Check current flag value

0 = Never exported
1 = Export all CAPS
2 = Export all new CAPS
10 = Export completed
11 = Re-Export all CAPS
12 = Re-Export all new CAPs

*/

If (li_Exp > 0 and li_Exp <> 10) or IsNull(li_Exp) then
	Messagebox("DB Error", "Inspection export status is invalid.~n~nPlease contact the system administrator.", Exclamation!)
	Return
End If

// Update flag
If rb_All.Checked then li_Exp += 1 Else li_Exp += 2

Update VETT_INSP Set CAPEXPFLAG = :li_Exp Where INSP_ID = :il_InspID;

// If SQL error
If SQLCA.SQLCode <> 0 then
	Rollback;
	Messagebox("DB Error", "Unable to update inspection export status~n~n" + SQLCA.SQLErrText, Exclamation!)
	Return
End If

Commit;

guo_Global.of_AddInspHist(il_InspID, 15, "CAPs selected: " + String(dw_Caps.RowCount()))

Messagebox("Export Initiated", "The inspection has been flagged for export. The CAPs will be exported to ShipNet within the hour.")

Close(Parent)
end event

type cb_cancel from commandbutton within w_capexport
integer x = 1463
integer y = 1536
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
end type

event clicked;
Close(Parent)
end event

type gb_1 from groupbox within w_capexport
integer x = 18
integer y = 16
integer width = 2304
integer height = 640
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Export Option"
end type

type gb_2 from groupbox within w_capexport
integer x = 18
integer y = 688
integer width = 2304
integer height = 816
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Export Preview"
end type

