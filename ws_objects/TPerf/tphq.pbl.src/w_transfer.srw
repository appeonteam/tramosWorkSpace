$PBExportHeader$w_transfer.srw
forward
global type w_transfer from window
end type
type st_6 from statictext within w_transfer
end type
type st_5 from statictext within w_transfer
end type
type dw_target from datawindow within w_transfer
end type
type cb_cancel from commandbutton within w_transfer
end type
type st_4 from statictext within w_transfer
end type
type st_3 from statictext within w_transfer
end type
type st_2 from statictext within w_transfer
end type
type st_source from statictext within w_transfer
end type
type st_1 from statictext within w_transfer
end type
type cb_transfer from commandbutton within w_transfer
end type
type gb_1 from groupbox within w_transfer
end type
end forward

global type w_transfer from window
integer width = 1984
integer height = 1436
boolean titlebar = true
string title = "Transfer Voyages"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_6 st_6
st_5 st_5
dw_target dw_target
cb_cancel cb_cancel
st_4 st_4
st_3 st_3
st_2 st_2
st_source st_source
st_1 st_1
cb_transfer cb_transfer
gb_1 gb_1
end type
global w_transfer w_transfer

type variables


end variables

on w_transfer.create
this.st_6=create st_6
this.st_5=create st_5
this.dw_target=create dw_target
this.cb_cancel=create cb_cancel
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_source=create st_source
this.st_1=create st_1
this.cb_transfer=create cb_transfer
this.gb_1=create gb_1
this.Control[]={this.st_6,&
this.st_5,&
this.dw_target,&
this.cb_cancel,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_source,&
this.st_1,&
this.cb_transfer,&
this.gb_1}
end on

on w_transfer.destroy
destroy(this.st_6)
destroy(this.st_5)
destroy(this.dw_target)
destroy(this.cb_cancel)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_source)
destroy(this.st_1)
destroy(this.cb_transfer)
destroy(this.gb_1)
end on

event open;
String ls_Name
Long ll_IMO

Select VESSEL_REF_NR + ' - ' + VESSEL_NAME, IMO_NUMBER Into :ls_Name, :ll_IMO from VESSELS Where VESSEL_ID = :g_Parameters.VesselID;

If SQLCA.SQLCode <> 0 then
	Rollback;
	cb_transfer.Enabled = False
	Messagebox("DB Error", "Unable to retrieve vessel information.~n~n" + SQLCA.SQLErrText, Exclamation!)
	Return
End If

st_Source.Text = ls_Name

dw_Target.SetTransObject(SQLCA)
If dw_Target.Retrieve(ll_IMO, g_Parameters.VesselID) = 0 then
	cb_Transfer.Enabled  = False
	Post MessageBox("No Target Vessels", "No target vessels were found. Please ensure that the target vessel has the same IMO number as the source vessel.", Exclamation!)
End If

end event

type st_6 from statictext within w_transfer
integer x = 128
integer y = 992
integer width = 1765
integer height = 144
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 67108864
string text = "Please ensure vessel T-Perf software has been updated with the VIC for the Target vessel."
boolean focusrectangle = false
end type

type st_5 from statictext within w_transfer
integer x = 55
integer y = 528
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 67108864
string text = "Notes"
boolean focusrectangle = false
end type

type dw_target from datawindow within w_transfer
integer x = 530
integer y = 224
integer width = 1371
integer height = 240
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_sameimo"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type cb_cancel from commandbutton within w_transfer
integer x = 1207
integer y = 1216
integer width = 402
integer height = 112
integer taborder = 20
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
g_Parameters.VesselID = 0
Close(Parent)
end event

type st_4 from statictext within w_transfer
integer x = 128
integer y = 608
integer width = 1751
integer height = 192
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 67108864
string text = "List of target vessels displays all vessel with the same IMO Number as the source vessel. If Target vessel is not included in list, please check the vessel~'s IMO Number."
boolean focusrectangle = false
end type

type st_3 from statictext within w_transfer
integer x = 128
integer y = 832
integer width = 1737
integer height = 144
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 67108864
string text = "All voyage legs will be transferred from the Source Vessel to the selected Target vessel."
boolean focusrectangle = false
end type

type st_2 from statictext within w_transfer
integer x = 55
integer y = 232
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
string text = "Target Vessel:"
boolean focusrectangle = false
end type

type st_source from statictext within w_transfer
integer x = 530
integer y = 96
integer width = 1390
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_1 from statictext within w_transfer
integer x = 55
integer y = 96
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
string text = "Source Vessel:"
boolean focusrectangle = false
end type

type cb_transfer from commandbutton within w_transfer
integer x = 366
integer y = 1216
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Transfer"
end type

event clicked;
Integer li_Row, li_VslID

li_Row = dw_Target.GetSelectedRow(0)

If li_Row<=0 then 
	Messagebox("No Vessel Selected", "Please select a Target Vessel!", Exclamation!)
	Return
End If

If Messagebox("Confirm Transfer", "Are you sure you want to transfer all voyage legs from vessel~n~n" + st_Source.Text + "~n~nTo~n~n" + dw_Target.GetItemString(li_Row, "VesselName"), Question!, YesNo!) = 2 then Return

li_VslID = dw_Target.GetItemNumber(li_Row, "Vessel_ID")

n_voyage ln_voy

ln_voy = Create n_voyage

li_Row = ln_Voy.of_TransferVoyages(g_Parameters.VesselID, li_VslID)

If li_Row < 0 then 
	Messagebox("DB Error", "An error occurred during transfer.", Exclamation!)
	g_Parameters.VesselID = 0	
ElseIf li_Row = 0 then 
	Messagebox("No Voyage Legs", "No voyage legs were found for transfer.", Information!)
	g_Parameters.VesselID = 0
Else
	Messagebox("Transferred", "Number of voyage legs transferred successfully: " + String(li_Row), Information!)	
End If

Close(Parent)
end event

type gb_1 from groupbox within w_transfer
integer x = 18
integer width = 1920
integer height = 1184
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

