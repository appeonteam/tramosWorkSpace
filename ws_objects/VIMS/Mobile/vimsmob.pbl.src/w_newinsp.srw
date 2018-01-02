$PBExportHeader$w_newinsp.srw
forward
global type w_newinsp from window
end type
type cbx_active from checkbox within w_newinsp
end type
type cb_vsl from commandbutton within w_newinsp
end type
type sle_vessel from singlelineedit within w_newinsp
end type
type st_9 from statictext within w_newinsp
end type
type st_2 from statictext within w_newinsp
end type
type dp_comp from datepicker within w_newinsp
end type
type sle_ce from singlelineedit within w_newinsp
end type
type sle_capt from singlelineedit within w_newinsp
end type
type st_17 from statictext within w_newinsp
end type
type st_16 from statictext within w_newinsp
end type
type sle_last from singlelineedit within w_newinsp
end type
type sle_first from singlelineedit within w_newinsp
end type
type st_8 from statictext within w_newinsp
end type
type st_7 from statictext within w_newinsp
end type
type st_6 from statictext within w_newinsp
end type
type dw_comp from datawindow within w_newinsp
end type
type st_5 from statictext within w_newinsp
end type
type cb_cancel from commandbutton within w_newinsp
end type
type cb_find from commandbutton within w_newinsp
end type
type sle_port from singlelineedit within w_newinsp
end type
type dw_port from datawindow within w_newinsp
end type
type st_4 from statictext within w_newinsp
end type
type dw_model from datawindow within w_newinsp
end type
type st_3 from statictext within w_newinsp
end type
type dp_comm from datepicker within w_newinsp
end type
type st_1 from statictext within w_newinsp
end type
type gb_1 from groupbox within w_newinsp
end type
type ln_3 from line within w_newinsp
end type
type cb_save from commandbutton within w_newinsp
end type
end forward

global type w_newinsp from window
integer width = 2834
integer height = 1888
boolean titlebar = true
string title = "New Inspection"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cbx_active cbx_active
cb_vsl cb_vsl
sle_vessel sle_vessel
st_9 st_9
st_2 st_2
dp_comp dp_comp
sle_ce sle_ce
sle_capt sle_capt
st_17 st_17
st_16 st_16
sle_last sle_last
sle_first sle_first
st_8 st_8
st_7 st_7
st_6 st_6
dw_comp dw_comp
st_5 st_5
cb_cancel cb_cancel
cb_find cb_find
sle_port sle_port
dw_port dw_port
st_4 st_4
dw_model dw_model
st_3 st_3
dp_comm dp_comm
st_1 st_1
gb_1 gb_1
ln_3 ln_3
cb_save cb_save
end type
global w_newinsp w_newinsp

type variables

Integer ii_ModelID, ii_EditMode
Long il_IMO
String is_Port, is_Purpose, is_Group, is_Grade, is_Resp, is_ModelFilter
Boolean ibool_Completed, ibool_ClosedOut

n_inspio in_insp
end variables

forward prototypes
public subroutine wf_getpurpose (long al_imonumber, datetime adt_inspdate)
end prototypes

public subroutine wf_getpurpose (long al_imonumber, datetime adt_inspdate);Long ll_VslNr
String ls_VoyNo, ls_Port
Integer li_PCN
DateTime ldt_dep, ldt_arr

SetNull(is_Purpose)
SetNull(is_Grade)
SetNull(is_Group)

ldt_arr = DateTime(Date(adt_inspdate), Time("23:59:59.9"))
ldt_dep = DateTime(Date(adt_inspdate), Time("00:00:00.0"))

Select TOP 1 VESSEL_NR into :ll_VslNr from VESSELS where (IMO_NUMBER = :al_imonumber) and (VESSEL_ACTIVE = 1);

If SQLCA.SQLcode <> 0 then
	Rollback;
	Return
End If

Commit;

Select PURPOSE_CODE, VOYAGE_NR, PORT_CODE, PCN into :is_Purpose, :ls_VoyNo, :ls_Port, :li_PCN from POC Where (VESSEL_NR = :ll_VslNr) and (PORT_ARR_DT <= :ldt_arr) and (PORT_DEPT_DT >= :ldt_dep);

If SQLCA.SQLcode <> 0 then
	Rollback;
	Return
End If

Commit;

Select GRADE_GROUP, GRADE_NAME into :is_group, :is_grade from CD where (VESSEL_NR = :ll_VslNr) and (VOYAGE_NR = :ls_VoyNo ) and (PORT_CODE = :ls_Port) and (PCN = :li_PCN);

If SQLCA.SQLcode <> 0 then
	Rollback;
	Return
End If

Commit;

end subroutine

on w_newinsp.create
this.cbx_active=create cbx_active
this.cb_vsl=create cb_vsl
this.sle_vessel=create sle_vessel
this.st_9=create st_9
this.st_2=create st_2
this.dp_comp=create dp_comp
this.sle_ce=create sle_ce
this.sle_capt=create sle_capt
this.st_17=create st_17
this.st_16=create st_16
this.sle_last=create sle_last
this.sle_first=create sle_first
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.dw_comp=create dw_comp
this.st_5=create st_5
this.cb_cancel=create cb_cancel
this.cb_find=create cb_find
this.sle_port=create sle_port
this.dw_port=create dw_port
this.st_4=create st_4
this.dw_model=create dw_model
this.st_3=create st_3
this.dp_comm=create dp_comm
this.st_1=create st_1
this.gb_1=create gb_1
this.ln_3=create ln_3
this.cb_save=create cb_save
this.Control[]={this.cbx_active,&
this.cb_vsl,&
this.sle_vessel,&
this.st_9,&
this.st_2,&
this.dp_comp,&
this.sle_ce,&
this.sle_capt,&
this.st_17,&
this.st_16,&
this.sle_last,&
this.sle_first,&
this.st_8,&
this.st_7,&
this.st_6,&
this.dw_comp,&
this.st_5,&
this.cb_cancel,&
this.cb_find,&
this.sle_port,&
this.dw_port,&
this.st_4,&
this.dw_model,&
this.st_3,&
this.dp_comm,&
this.st_1,&
this.gb_1,&
this.ln_3,&
this.cb_save}
end on

on w_newinsp.destroy
destroy(this.cbx_active)
destroy(this.cb_vsl)
destroy(this.sle_vessel)
destroy(this.st_9)
destroy(this.st_2)
destroy(this.dp_comp)
destroy(this.sle_ce)
destroy(this.sle_capt)
destroy(this.st_17)
destroy(this.st_16)
destroy(this.sle_last)
destroy(this.sle_first)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.dw_comp)
destroy(this.st_5)
destroy(this.cb_cancel)
destroy(this.cb_find)
destroy(this.sle_port)
destroy(this.dw_port)
destroy(this.st_4)
destroy(this.dw_model)
destroy(this.st_3)
destroy(this.dp_comm)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.ln_3)
destroy(this.cb_save)
end on

event open;Datastore lds_insp
Integer li_Row
String ls_Name

SetPointer(HourGlass!)

dw_model.SetTransObject(SQLCA)
dw_port.SetTransObject(SQLCA)
dw_comp.SetTransObject(SQLCA)

f_Write2Log("w_NewInsp Open; Mode: " + g_Obj.ParamString)

If dw_model.Retrieve() = 0 then
	MessageBox("New Inspection", "A new inspection cannot be created as no inspection models are present in the system.~n~nThe VIMS database need to be updated.", Exclamation!)
	g_Obj.ParamString = ""
	Close(This)
	Return
End If

dw_port.Retrieve()
dw_comp.Retrieve()

dp_Comm.Value = DateTime(Today())
dp_Comp.Value = DateTime(Today())

If g_Obj.Install = 0 then  // Vessel Installation
	il_IMO = g_Obj.VesselIMO
	sle_vessel.Text = g_Obj.VesselNumber + ' - ' + g_Obj.VesselName
	cb_Vsl.Enabled = False	
	sle_vessel.Enabled = False
Else   // Inspector installation
	SetNull(il_IMO)
	sle_first.Text = g_Obj.inspfirstname
	sle_last.Text = g_Obj.insplastname
	sle_first.Enabled = False
	sle_last.Enabled = False
End If

If g_Obj.Login = 1 then   // For vessel login, hide internal models and companies
	is_ModelFilter = "(name not like '%(Internal%') and (name not like 'MIRE%')"
	dw_comp.SetFilter("name not like 'MAERSK -%'" )
Else   // For inspector login, show only internal models and companies
	is_ModelFilter = "((name like '%(Internal%') Or (name like 'MIRE%'))"
	dw_comp.SetFilter("name like 'MAERSK -%'" )
End If

dw_Model.SetFilter(is_ModelFilter)
dw_Model.Filter( )
dw_Comp.Filter( )

If g_Obj.ParamString = "Edit" then
	ii_EditMode = 1
	w_newinsp.Title = "Modify Inspection Details"
	cb_save.Text = "Save"
	lds_insp = create datastore
	lds_insp.Dataobject = "d_sq_ff_inspheader"
	lds_insp.SetTransobject(SQLCA)
	li_row = lds_insp.Retrieve(g_Obj.InspID)
	If lds_insp.RowCount( ) = 0 then
		Destroy lds_insp
		MessageBox("DW Error", "Could not retrieve inspection header.",Exclamation!)
		f_Write2Log("w_NewInsp > DW Retrieve Failed")
		cb_Save.Enabled = False
		Return
	End If
	This.Title = "Edit Inspection Header"
	dp_Comm.Value = lds_insp.GetItemDateTime( 1, "Commenced")
	dp_comp.Value = lds_insp.GetItemDateTime( 1, "Inspdate")
	If g_Obj.Install = 1 then  // Inspector's Installation
		il_imo = lds_insp.GetItemnumber( 1, "vesselimo")
		sle_Vessel.Text = lds_insp.getItemString( 1, "vesselname")
	End If	
	li_Row = dw_model.Find("IM_ID = " + String(lds_insp.GetItemNumber(1, "ImID")), 1, dw_model.RowCount() )
	if li_Row > 0 then
		cbx_Active.Checked = False
		dw_Model.SetRow(li_Row)
		dw_Model.ScrollToRow(li_Row)
	Else	
		MessageBox("DW Error", "Unable to set Inspection Model Type.",Exclamation!)
		cb_Save.Enabled = False
	End If
	If lds_insp.GetItemNumber(1, "ItemCount") > 0 then
		dw_model.Enabled = False
		dw_model.Modify("DataWindow.Color='12632256'")
		dw_model.VScrollbar = False
		cbx_Active.Visible = False
	End If
	li_Row = dw_comp.Find("Comp_ID = " + String(lds_insp.GetItemNumber(1, "CompID")), 1, dw_comp.RowCount() )
	if li_Row > 0 then
		dw_Comp.SetRow(li_Row)
		dw_Comp.ScrollToRow(li_Row)
	Else	
		MessageBox("DW Error", "Unable to set Inspection Company.",Exclamation!)
	End If
	li_Row = dw_Port.Find("Port_Code = '" + lds_insp.GetItemString(1, "Port") + "'", 1, dw_Port.RowCount() )
	if li_Row > 0 then
		dw_Port.SetRow(li_Row)
		dw_Port.ScrollToRow(li_Row)
	Else	
		MessageBox("DW Error", "Unable to set Port of Inspection.",Exclamation!)
	End If
	sle_first.Text = lds_insp.GetItemString(1, "vett_insp_insp_fname")
	sle_last.Text = lds_insp.GetItemString(1, "vett_insp_insp_lname")
	sle_capt.Text = lds_insp.GetItemString(1, "master")
	sle_CE.Text = lds_insp.GetItemString(1, "cheng")
	Destroy lds_insp
Else
	ii_Editmode = 0
	If f_Config("CAPT", ls_Name, 0) = 0 then sle_capt.Text = ls_Name
	If f_Config("CENG", ls_Name, 0) = 0 then sle_ce.Text = ls_Name
	cbx_Active.Event Clicked( )
End If
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 2600)
end event

type cbx_active from checkbox within w_newinsp
integer x = 969
integer y = 304
integer width = 347
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Active Only"
boolean checked = true
end type

event clicked;
If This.Checked then dw_Model.SetFilter(is_ModelFilter + " and (Active=1)") Else dw_Model.SetFilter(is_ModelFilter)

dw_Model.Filter()
end event

type cb_vsl from commandbutton within w_newinsp
integer x = 2597
integer y = 144
integer width = 128
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;
g_Obj.ParamLong = il_imo

Open(w_vslsel)

If g_Obj.Paramlong > 0 then 
	il_imo = g_Obj.ParamLong
	sle_vessel.Text = g_Obj.ParamString
End If
end event

type sle_vessel from singlelineedit within w_newinsp
integer x = 1518
integer y = 144
integer width = 1079
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_9 from statictext within w_newinsp
integer x = 1518
integer y = 80
integer width = 219
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_newinsp
integer x = 823
integer y = 80
integer width = 530
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Completed:"
boolean focusrectangle = false
end type

type dp_comp from datepicker within w_newinsp
string tag = "2538454"
integer x = 823
integer y = 144
integer width = 475
integer height = 80
integer taborder = 20
boolean border = true
borderstyle borderstyle = stylelowered!
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2099-12-31")
date mindate = Date("2005-01-01")
datetime value = DateTime(Date("2008-03-13"), Time("07:36:25.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendartextsize = -8
integer calendarfontweight = 400
fontcharset calendarfontcharset = ansi!
fontpitch calendarfontpitch = variable!
fontfamily calendarfontfamily = swiss!
string calendarfontname = "Arial"
weekday firstdayofweek = monday!
boolean todaysection = true
boolean todaycircle = true
boolean valueset = true
end type

event valuechanged;
If dtm < dp_Comm.Value then	dp_Comm.Value = dtm
end event

type sle_ce from singlelineedit within w_newinsp
integer x = 1902
integer y = 1440
integer width = 823
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event losefocus;
f_ValidateName(This.Text, 0)
end event

type sle_capt from singlelineedit within w_newinsp
integer x = 1902
integer y = 1248
integer width = 823
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event losefocus;
f_ValidateName(This.Text, 0)
end event

type st_17 from statictext within w_newinsp
integer x = 1518
integer y = 1456
integer width = 347
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Chief Engineer:"
boolean focusrectangle = false
end type

type st_16 from statictext within w_newinsp
integer x = 1518
integer y = 1264
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Master:"
boolean focusrectangle = false
end type

type sle_last from singlelineedit within w_newinsp
integer x = 1902
integer y = 1072
integer width = 823
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event losefocus;
f_ValidateName(This.Text, 2)
end event

type sle_first from singlelineedit within w_newinsp
integer x = 1902
integer y = 976
integer width = 823
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event losefocus;
f_ValidateName(This.Text, 1)
end event

type st_8 from statictext within w_newinsp
integer x = 1609
integer y = 1088
integer width = 128
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Last:"
boolean focusrectangle = false
end type

type st_7 from statictext within w_newinsp
integer x = 1609
integer y = 992
integer width = 128
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "First:"
boolean focusrectangle = false
end type

type st_6 from statictext within w_newinsp
integer x = 1518
integer y = 912
integer width = 407
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspector~'s Name:"
boolean focusrectangle = false
end type

type dw_comp from datawindow within w_newinsp
integer x = 91
integer y = 976
integer width = 1207
integer height = 576
integer taborder = 70
string title = "none"
string dataobject = "d_sq_tb_compsel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;
If rowcount = 0 then cb_Save.Enabled = False
end event

type st_5 from statictext within w_newinsp
integer x = 91
integer y = 912
integer width = 658
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Conducted by:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_newinsp
integer x = 1664
integer y = 1664
integer width = 640
integer height = 112
integer taborder = 130
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;

f_Write2Log("w_NewInsp Cancel")
g_Obj.ParamString = ""

Close(Parent)
end event

type cb_find from commandbutton within w_newinsp
integer x = 2560
integer y = 768
integer width = 165
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Find"
end type

event clicked;
Integer li_Found

sle_port.Text = Trim(sle_Port.Text)

If sle_Port.Text > "" then
	li_Found = dw_port.Find("(Upper(Port_n) like Upper('" + sle_port.Text + "%')) Or (Upper(Port_Code) = Upper('" + sle_port.Text + "'))", 1, dw_Port.RowCount())
	If li_Found > 0 then
		dw_Port.SetRow(li_Found)
		dw_Port.ScrollToRow(li_Found)
	Else
		MessageBox("Not Found", "The port was not found in the list.")
	End If
Else
	MessageBox("No Text", "Please specify a few characters of the port name to find.",Exclamation!)
End If
end event

type sle_port from singlelineedit within w_newinsp
event ue_keydown pbm_keydown
integer x = 1518
integer y = 768
integer width = 1042
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;
If (key = KeyEnter!) then cb_Find.event clicked( )

end event

type dw_port from datawindow within w_newinsp
integer x = 1518
integer y = 368
integer width = 1207
integer height = 400
integer taborder = 50
string title = "none"
string dataobject = "d_sq_tb_portsel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_newinsp
integer x = 1518
integer y = 304
integer width = 494
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port of Inspection:"
boolean focusrectangle = false
end type

type dw_model from datawindow within w_newinsp
integer x = 91
integer y = 368
integer width = 1207
integer height = 480
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_modelsel"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;

If rowcount = 0 then cb_Save.Enabled = False

end event

type st_3 from statictext within w_newinsp
integer x = 91
integer y = 304
integer width = 494
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Type of Inspection:"
boolean focusrectangle = false
end type

type dp_comm from datepicker within w_newinsp
string tag = "2538454"
integer x = 91
integer y = 144
integer width = 475
integer height = 80
integer taborder = 10
boolean border = true
borderstyle borderstyle = stylelowered!
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2099-12-31")
date mindate = Date("2005-01-01")
datetime value = DateTime(Date("2007-11-28"), Time("08:25:02.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendartextsize = -8
integer calendarfontweight = 400
fontcharset calendarfontcharset = ansi!
fontpitch calendarfontpitch = variable!
fontfamily calendarfontfamily = swiss!
string calendarfontname = "Arial"
weekday firstdayofweek = monday!
boolean todaysection = true
boolean todaycircle = true
boolean valueset = true
end type

event valuechanged;
If dtm > dp_comp.Value then	dp_comp.Value = dtm
end event

type st_1 from statictext within w_newinsp
integer x = 91
integer y = 80
integer width = 585
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Commenced:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_newinsp
integer x = 18
integer width = 2779
integer height = 1632
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type ln_3 from line within w_newinsp
long linecolor = 12632256
integer linethickness = 4
integer beginx = 1682
integer beginy = 240
integer endx = 1682
integer endy = 464
end type

type cb_save from commandbutton within w_newinsp
integer x = 489
integer y = 1664
integer width = 645
integer height = 112
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Create Inspection"
end type

event clicked;String ls_Port, ls_Temp, ls_GlobalID, ls_Modif
Long ll_CompID, ll_Model
Integer li_DB, li_Status
DateTime ldt_Comm, ldt_Comp
DateTime ldt_Now

If DaysAfter(Date(dp_Comm.Value), Date(dp_comp.Value)) > 30 then
	MessageBox("Inspection Duration", "The duration of the inspection cannot not be more than 30 days.", Exclamation!)
	Return
End If

If IsNull(il_IMO) then
	MessageBox("Vessel Selection", "Please select the vessel where this inspection took place.", Exclamation!)
	Return
End If

SetPointer(HourGlass!)

ls_Port = dw_Port.GetItemString(dw_Port.GetRow(), "PORT_CODE")
ll_CompID = dw_Comp.GetItemNumber(dw_Comp.GetRow(), "COMP_ID")
ll_Model = dw_Model.GetItemNumber(dw_Model.GetRow(), "IM_ID")

If (sle_first.Text = "") or (sle_last.Text = "") then 
	MessageBox("Inspector's Name", "Inspector's first and last name is required.", Exclamation!)
	Return
End If

ls_Temp = sle_first.Text + sle_last.Text
If f_CheckInvalid(ls_Temp) then 
	Messagebox("Invalid Characters", "The Inspector's first or last name contains invalid characters.")
	Return
End If

If Sle_Capt.Text = "" then 
	Messagebox("Master's Name", "Please specify the Master's name.", Exclamation!)
	Return
End If

ls_Temp = sle_Capt.Text
If f_CheckInvalid(ls_Temp) then 
	Messagebox("Invalid Characters", "The Master's name contains invalid characters.")
	Return
End If

ls_Temp = sle_CE.Text
If f_CheckInvalid(ls_Temp) then 
	Messagebox("Invalid Characters", "The Chief Engineer's name contains invalid characters.")
	Return
End If

ldt_Comm = dp_Comm.Value
ldt_Comp = dp_Comp.Value

ldt_Now = DateTime(Today(), Now())

If f_Config("DBVR", ls_Temp, 0) = 0 then li_DB = Integer(ls_Temp) Else li_DB = 0

If g_Obj.Login = 2 then 	
	ls_Modif = g_Obj.UserID
Else 
	ls_Modif = "V/L"
End If

li_Status = 0   // New inspection
If g_Obj.Install = 0 and g_Obj.Login = 2 then li_Status = 1   // If inspector is creating an inspection on a vessel installation

If ii_Editmode = 1 then       // Edit Insp
	Update VETT_INSP Set VESSELIMO = :il_IMO, PORT = :ls_Port, COMP_ID = :ll_CompID, INSPDATE = :ldt_Comp, COMMENCED = :ldt_Comm, INSP_FNAME = :sle_first.Text, INSP_LNAME = :sle_last.Text, MASTER = :sle_capt.Text, CHENG = :sle_CE.Text, IM_ID = :ll_Model, MODIFIED = :ls_Modif, LASTEDIT = :ldt_Now, MOBILEVER = :g_Obj.Appver, DBISSUE = :li_DB Where INSP_ID = :g_Obj.Inspid;
Else
	Insert into VETT_INSP (VESSELIMO, PORT, COMP_ID, INSPDATE, COMMENCED, INSP_FNAME, INSP_LNAME, MASTER, CHENG, IM_ID, CREATED, MODIFIED, LASTEDIT, COMPLETED, RATING, VSLSCORE, STATUS, MOBILEVER, DBISSUE, GLOBALID, LASTEXPORT) Values (:il_IMO, :ls_Port, :ll_CompID, :ldt_Comp, :ldt_Comm, :sle_first.Text, :sle_last.Text, :sle_capt.Text, :sle_ce.Text, :ll_Model, :ls_Modif, :ls_Modif, :ldt_Now, 0, 'A+', 100, :li_Status, :g_Obj.AppVer, :li_DB, :ls_GlobalID, '');
End If

If SQLCA.SQlcode <> 0 then
	MessageBox ("DB Error", "Unable to add/edit new inspection.~n~n" + Sqlca.Sqlerrtext,Exclamation!)
	f_Write2Log("w_NewInsp > cb_Save Failed: " + SQLCA.SQLErrText)
	Rollback;	
	Return
End If

Commit;

If ii_EditMode = 0 then  // If new insp
	Select Max(INSP_ID) into :g_Obj.Inspid from VETT_INSP;
	If SQLCA.SQLCode = 0 then
		Commit;
		SetNull(li_DB)
		Insert Into VETT_ITEM (INSP_ID, ANS, DEF, REPORT, RISK, CLOSED, SERIAL) Values (:g_Obj.inspid, :li_DB, :li_DB, :li_DB, :li_DB, :li_DB, 0);
		If SQLCA.SQLCode <> 0 then
			Messagebox("DB Error", "Could not insert ghost item for new inspection.~n~n" + sqlca.Sqlerrtext, Exclamation!)
			f_Write2Log("w_NewInsp > cb_Save Failed to add ghost item: " + SQLCA.SQLErrText)
			Rollback;
		Else
			Commit;
		End If
	Else
		Rollback;
	End If
End If

f_Write2Log("w_NewInsp Save Success")
Close(Parent)

end event

