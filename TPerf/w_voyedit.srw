HA$PBExportHeader$w_voyedit.srw
forward
global type w_voyedit from window
end type
type cb_6 from commandbutton within w_voyedit
end type
type cb_5 from commandbutton within w_voyedit
end type
type cb_4 from commandbutton within w_voyedit
end type
type dw_hrbr from datawindow within w_voyedit
end type
type cb_delrep from commandbutton within w_voyedit
end type
type cb_editrep from commandbutton within w_voyedit
end type
type cb_addrep from commandbutton within w_voyedit
end type
type dw_rep from datawindow within w_voyedit
end type
type cb_cancel from commandbutton within w_voyedit
end type
type cb_save from commandbutton within w_voyedit
end type
type dw_voy from datawindow within w_voyedit
end type
type gb_1 from groupbox within w_voyedit
end type
type gb_2 from groupbox within w_voyedit
end type
type gb_3 from groupbox within w_voyedit
end type
end forward

global type w_voyedit from window
integer width = 3598
integer height = 2420
boolean titlebar = true
string title = "Edit Voyage"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
dw_hrbr dw_hrbr
cb_delrep cb_delrep
cb_editrep cb_editrep
cb_addrep cb_addrep
dw_rep dw_rep
cb_cancel cb_cancel
cb_save cb_save
dw_voy dw_voy
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_voyedit w_voyedit

type variables




long il_RepID, il_HrbrID
end variables

forward prototypes
public subroutine w_calcreport (integer ai_row)
end prototypes

public subroutine w_calcreport (integer ai_row);Long ll_rows, ll_loop, ll_Period, ll_Dist

// Calculate period and distance for each report

Setpointer(HourGlass!)

gnv_voyage.ids_saildata.setfilter( "Rep_ID = " + String(dw_rep.getitemnumber( ai_row, "Rep_ID")))
gnv_voyage.ids_saildata.Filter( )

ll_rows = gnv_voyage.ids_saildata.rowcount( )

For ll_loop = 1 to ll_rows
	ll_Period += gnv_voyage.ids_saildata.getitemnumber( ll_loop, "Period")
	ll_Dist += gnv_voyage.ids_saildata.getitemnumber( ll_loop, "Dist")
Next

dw_rep.Setitem(ai_row, "Period", ll_Period)
dw_rep.Setitem(ai_row, "Dist", ll_Dist)
end subroutine

on w_voyedit.create
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_4=create cb_4
this.dw_hrbr=create dw_hrbr
this.cb_delrep=create cb_delrep
this.cb_editrep=create cb_editrep
this.cb_addrep=create cb_addrep
this.dw_rep=create dw_rep
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.dw_voy=create dw_voy
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.Control[]={this.cb_6,&
this.cb_5,&
this.cb_4,&
this.dw_hrbr,&
this.cb_delrep,&
this.cb_editrep,&
this.cb_addrep,&
this.dw_rep,&
this.cb_cancel,&
this.cb_save,&
this.dw_voy,&
this.gb_1,&
this.gb_2,&
this.gb_3}
end on

on w_voyedit.destroy
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.dw_hrbr)
destroy(this.cb_delrep)
destroy(this.cb_editrep)
destroy(this.cb_addrep)
destroy(this.dw_rep)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.dw_voy)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;long ll_rowc, ll_loop
string ls_Tmp

gnv_voyage = Create n_voyage

dw_voy.settransobject(SQLCA)
dw_rep.settransobject(SQLCA)
dw_hrbr.settransobject(SQLCA)

// Share data to dw_voy
ll_rowc = gnv_voyage.ids_voyage.sharedata(dw_Voy)
if ll_rowc <> 1 then 
	MessageBox("Error", "gnv_voyage.ids_voyage.sharedata() failed.")
	Close(This)
	Return
End If

// Share data to dw_Rep
ll_rowc = gnv_voyage.ids_reports.sharedata(dw_Rep)
if ll_rowc <> 1 then 
	MessageBox("Error", "gnv_voyage.ids_reports.sharedata() failed.")
	Close(This)
	Return	
End If

// Load voyage
gnv_voyage.of_retrievevoyage(g_parameters.VoyageID, False)

// Get row (always 1)
ll_rowc = dw_Voy.GetRow( )

// Set the voyage number and leg
ls_Tmp = dw_Voy.GetItemString( ll_rowc, "Voy_Num")
ll_Loop = Pos(ls_Tmp, "|")   // Check format of voyage number and set textboxes accordingly
If ll_Loop > 0 then   
	dw_Voy.SetItem(ll_rowc, "VNum", Left(ls_Tmp, ll_Loop - 1))
	dw_Voy.SetItem(ll_rowc, "Leg", Right(ls_Tmp, Len(ls_Tmp) - ll_Loop))
Else
	dw_Voy.SetItem(ll_rowc, "Leg", Right(ls_Tmp, 2))
	If Mid(ls_Tmp, 6, 2) = "xx" then ls_Tmp = Left(ls_Tmp, 4) Else ls_Tmp = Left(ls_Tmp, 7)
	dw_Voy.SetItem(ll_rowc, "VNum", ls_Tmp)
End If

// Loop through reports and calculate
ll_rowc = dw_rep.Rowcount( )
For ll_loop = 1 to ll_rowc
	w_calcreport( ll_loop )
Next

// Select last row
if (ll_rowc > 0) then
	dw_rep.selectrow( ll_rowc, True)
	dw_rep.scrolltorow( ll_rowc)
	il_RepID = dw_rep.getitemnumber( ll_rowc, "Rep_ID")
end if

// Get harbours and select first
ll_rowc = dw_hrbr.Retrieve (g_parameters.voyageid)
if (ll_rowc > 0) then
	dw_hrbr.selectrow( 1, True)
	il_HrbrID = dw_hrbr.getitemnumber( ll_rowc, "Hrbr_ID")
end if

end event

type cb_6 from commandbutton within w_voyedit
boolean visible = false
integer x = 3127
integer y = 2064
integer width = 402
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

type cb_5 from commandbutton within w_voyedit
boolean visible = false
integer x = 457
integer y = 2064
integer width = 402
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit..."
end type

type cb_4 from commandbutton within w_voyedit
boolean visible = false
integer x = 55
integer y = 2064
integer width = 402
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add..."
end type

type dw_hrbr from datawindow within w_voyedit
integer x = 55
integer y = 1600
integer width = 3474
integer height = 528
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_hrbrsummary"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanging;
this.selectrow( currentrow, False)
this.selectrow( newrow, True)
end event

type cb_delrep from commandbutton within w_voyedit
boolean visible = false
integer x = 3127
integer y = 1392
integer width = 402
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Last"
end type

type cb_editrep from commandbutton within w_voyedit
boolean visible = false
integer x = 475
integer y = 1392
integer width = 402
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit..."
end type

event clicked;
If il_RepID = 0 then 
	MessageBox ("Select Report", "Please select a report to edit.", Exclamation!)
	Return
End if

g_parameters.reportid = il_RepID

open(w_repedit)

w_calcreport( dw_rep.GetRow( ) )





end event

type cb_addrep from commandbutton within w_voyedit
boolean visible = false
integer x = 73
integer y = 1392
integer width = 402
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add..."
end type

type dw_rep from datawindow within w_voyedit
integer x = 55
integer y = 752
integer width = 3474
integer height = 704
integer taborder = 30
string title = "none"
string dataobject = "d_sq_tb_reportsummary"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
If currentrow=0 then Return

this.selectrow( 0, False)
this.selectrow( currentrow, True)

il_repid = this.getitemnumber( currentrow, "Rep_ID")
end event

event clicked;
If row=0 then return

this.scrolltorow( row)

this.selectrow( 0, False)
this.selectrow( row, True)

il_repid = this.getitemnumber( row, "Rep_ID")
end event

type cb_cancel from commandbutton within w_voyedit
integer x = 2194
integer y = 2192
integer width = 658
integer height = 112
integer taborder = 50
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
Destroy gnv_voyage

g_parameters.voyageid = -10     //  To inform calling window that cancel was pressed

Close(parent)
end event

type cb_save from commandbutton within w_voyedit
integer x = 713
integer y = 2192
integer width = 658
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save Changes"
boolean default = true
end type

event clicked;String ls_VoyNum, ls_Leg

//Validate Voyage Number & Leg
ls_VoyNum = Trim(dw_voy.GetItemString(dw_Voy.GetRow( ), "VNum"), True)
ls_Leg = Trim(dw_voy.GetItemString(dw_Voy.GetRow( ), "Leg"), True)

If ls_VoyNum="" or ls_Leg="" then 
	MessageBox ("Voyage/Leg Number", "The voyage and leg number must be specified.", Exclamation!)
	Return
End If

dw_Voy.SetItem(dw_Voy.GetRow(), "Voy_Num", ls_VoyNum + "|" + ls_Leg)

// Save all info
If gnv_Voyage.of_UpdateVoyage() <> 0 then 
	Messagebox ("Update Failed", gnv_Voyage.errtext )
	Return
End If

Destroy gnv_Voyage

Close(Parent)
end event

type dw_voy from datawindow within w_voyedit
integer x = 73
integer y = 96
integer width = 3456
integer height = 528
integer taborder = 10
string title = "none"
string dataobject = "d_sq_ff_voyedit"
boolean border = false
end type

event losefocus;	
dw_voy.AcceptText( )
end event

type gb_1 from groupbox within w_voyedit
integer x = 18
integer y = 16
integer width = 3547
integer height = 640
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voyage Information"
end type

type gb_2 from groupbox within w_voyedit
integer x = 18
integer y = 672
integer width = 3547
integer height = 816
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sailing Reports"
end type

type gb_3 from groupbox within w_voyedit
integer x = 18
integer y = 1504
integer width = 3547
integer height = 656
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Harbour Information"
end type

