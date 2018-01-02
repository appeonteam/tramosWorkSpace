HA$PBExportHeader$w_wrr.srw
forward
global type w_wrr from window
end type
type ddlb_consordmin from dropdownlistbox within w_wrr
end type
type ddlb_spdordmin from dropdownlistbox within w_wrr
end type
type ddlb_conswrrmin from dropdownlistbox within w_wrr
end type
type ddlb_spdwrrmin from dropdownlistbox within w_wrr
end type
type rb_max from radiobutton within w_wrr
end type
type st_lastmodif from statictext within w_wrr
end type
type cbx_per from checkbox within w_wrr
end type
type rb_linear from radiobutton within w_wrr
end type
type rb_admirality from radiobutton within w_wrr
end type
type st_15 from statictext within w_wrr
end type
type st_14 from statictext within w_wrr
end type
type cbx_wrrtype from checkbox within w_wrr
end type
type st_13 from statictext within w_wrr
end type
type em_aux from editmask within w_wrr
end type
type st_12 from statictext within w_wrr
end type
type ddlb_consord from dropdownlistbox within w_wrr
end type
type ddlb_conswrr from dropdownlistbox within w_wrr
end type
type ddlb_spdord from dropdownlistbox within w_wrr
end type
type ddlb_spdwrr from dropdownlistbox within w_wrr
end type
type st_11 from statictext within w_wrr
end type
type st_10 from statictext within w_wrr
end type
type st_9 from statictext within w_wrr
end type
type st_8 from statictext within w_wrr
end type
type ddlb_bfsea from dropdownlistbox within w_wrr
end type
type ddlb_bfwind from dropdownlistbox within w_wrr
end type
type st_7 from statictext within w_wrr
end type
type st_6 from statictext within w_wrr
end type
type st_5 from statictext within w_wrr
end type
type st_4 from statictext within w_wrr
end type
type cb_delbl from commandbutton within w_wrr
end type
type cb_delld from commandbutton within w_wrr
end type
type cb_addbl from commandbutton within w_wrr
end type
type cb_addld from commandbutton within w_wrr
end type
type dw_bl from datawindow within w_wrr
end type
type dw_ld from datawindow within w_wrr
end type
type cb_cancel from commandbutton within w_wrr
end type
type cb_ok from commandbutton within w_wrr
end type
type st_3 from statictext within w_wrr
end type
type st_2 from statictext within w_wrr
end type
type st_1 from statictext within w_wrr
end type
type rr_1 from roundrectangle within w_wrr
end type
type ln_1 from line within w_wrr
end type
type ln_2 from line within w_wrr
end type
type st_16 from statictext within w_wrr
end type
type st_17 from statictext within w_wrr
end type
type st_18 from statictext within w_wrr
end type
type st_19 from statictext within w_wrr
end type
end forward

global type w_wrr from window
integer width = 2135
integer height = 2760
boolean titlebar = true
string title = "Warranted Settings"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
ddlb_consordmin ddlb_consordmin
ddlb_spdordmin ddlb_spdordmin
ddlb_conswrrmin ddlb_conswrrmin
ddlb_spdwrrmin ddlb_spdwrrmin
rb_max rb_max
st_lastmodif st_lastmodif
cbx_per cbx_per
rb_linear rb_linear
rb_admirality rb_admirality
st_15 st_15
st_14 st_14
cbx_wrrtype cbx_wrrtype
st_13 st_13
em_aux em_aux
st_12 st_12
ddlb_consord ddlb_consord
ddlb_conswrr ddlb_conswrr
ddlb_spdord ddlb_spdord
ddlb_spdwrr ddlb_spdwrr
st_11 st_11
st_10 st_10
st_9 st_9
st_8 st_8
ddlb_bfsea ddlb_bfsea
ddlb_bfwind ddlb_bfwind
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
cb_delbl cb_delbl
cb_delld cb_delld
cb_addbl cb_addbl
cb_addld cb_addld
dw_bl dw_bl
dw_ld dw_ld
cb_cancel cb_cancel
cb_ok cb_ok
st_3 st_3
st_2 st_2
st_1 st_1
rr_1 rr_1
ln_1 ln_1
ln_2 ln_2
st_16 st_16
st_17 st_17
st_18 st_18
st_19 st_19
end type
global w_wrr w_wrr

type variables
integer ii_idx, ii_Inter, ii_Percent
integer ii_BFSea, ii_BFWind, ii_VslNum, ii_WrrVer, ii_WrrType
Decimal id_DevOSpd, id_DevWSpd, id_DevOCon, id_DevWCon, id_AuxCon
Decimal id_DevOSpdMin, id_DevWSpdMin, id_DevOConMin, id_DevWConMin
string is_VName

end variables

forward prototypes
public subroutine wf_populateddl (boolean abool_percent)
end prototypes

public subroutine wf_populateddl (boolean abool_percent);// Fills up allowed ranges dropdown lists   (CR 1892: Include percentage option)

ddlb_spdord.reset( )
ddlb_spdwrr.reset( )
ddlb_consord.reset( )
ddlb_conswrr.reset( )
ddlb_spdordmin.reset( )
ddlb_spdwrrmin.reset( )
ddlb_consordmin.reset( )
ddlb_conswrrmin.reset( )

If abool_Percent then
	For ii_idx = 0 to 40
		ddlb_spdord.Additem('+ ' + string(ii_Idx / 2, "0.0") + '%')
		ddlb_spdwrr.Additem('+ ' + string(ii_Idx / 2, "0.0") + '%')
		ddlb_spdordmin.Additem('- ' + string(ii_Idx / 2, "0.0") + '%')
		ddlb_spdwrrmin.Additem('- ' + string(ii_Idx / 2, "0.0") + '%')		
	Next
	ddlb_spdord.SelectItem(11)
	ddlb_spdwrr.SelectItem(11)
	ddlb_spdordmin.SelectItem(11)
	ddlb_spdwrrmin.SelectItem(11)	
	For ii_idx = 1 to 40
		ddlb_consord.Additem('+ ' + string(ii_Idx / 2, "0.0") + '%')
		ddlb_conswrr.Additem('+ ' + string(ii_Idx / 2, "0.0") + '%')
		ddlb_consordmin.Additem('- ' + string(ii_Idx / 2, "0.0") + '%')
		ddlb_conswrrmin.Additem('- ' + string(ii_Idx / 2, "0.0") + '%')
	Next	
	ddlb_consord.SelectItem(10)
	ddlb_conswrr.SelectItem(10)
	ddlb_consordmin.SelectItem(10)
	ddlb_conswrrmin.SelectItem(10)	
Else
	For ii_idx = 0 to 20
		ddlb_spdord.Additem('+ ' + string(ii_Idx / 4, "0.00"))
		ddlb_spdwrr.Additem('+ ' + string(ii_Idx / 4, "0.00"))
		ddlb_spdordmin.Additem('- ' + string(ii_Idx / 4, "0.00"))
		ddlb_spdwrrmin.Additem('- ' + string(ii_Idx / 4, "0.00"))		
	Next
	ddlb_spdord.SelectItem(5)
	ddlb_spdwrr.SelectItem(5)	
	ddlb_spdordmin.SelectItem(5)
	ddlb_spdwrrmin.SelectItem(5)		
	For ii_idx = 1 to 40
		ddlb_consord.Additem('+ ' + string(ii_Idx / 2, "0.0"))
		ddlb_conswrr.Additem('+ ' + string(ii_Idx / 2, "0.0"))
		ddlb_consordmin.Additem('- ' + string(ii_Idx / 2, "0.0"))
		ddlb_conswrrmin.Additem('- ' + string(ii_Idx / 2, "0.0"))		
	Next
	ddlb_consord.SelectItem(6)
	ddlb_conswrr.SelectItem(6)
	ddlb_consordmin.SelectItem(6)
	ddlb_conswrrmin.SelectItem(6)	
End If


end subroutine

on w_wrr.create
this.ddlb_consordmin=create ddlb_consordmin
this.ddlb_spdordmin=create ddlb_spdordmin
this.ddlb_conswrrmin=create ddlb_conswrrmin
this.ddlb_spdwrrmin=create ddlb_spdwrrmin
this.rb_max=create rb_max
this.st_lastmodif=create st_lastmodif
this.cbx_per=create cbx_per
this.rb_linear=create rb_linear
this.rb_admirality=create rb_admirality
this.st_15=create st_15
this.st_14=create st_14
this.cbx_wrrtype=create cbx_wrrtype
this.st_13=create st_13
this.em_aux=create em_aux
this.st_12=create st_12
this.ddlb_consord=create ddlb_consord
this.ddlb_conswrr=create ddlb_conswrr
this.ddlb_spdord=create ddlb_spdord
this.ddlb_spdwrr=create ddlb_spdwrr
this.st_11=create st_11
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.ddlb_bfsea=create ddlb_bfsea
this.ddlb_bfwind=create ddlb_bfwind
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.cb_delbl=create cb_delbl
this.cb_delld=create cb_delld
this.cb_addbl=create cb_addbl
this.cb_addld=create cb_addld
this.dw_bl=create dw_bl
this.dw_ld=create dw_ld
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.rr_1=create rr_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.st_16=create st_16
this.st_17=create st_17
this.st_18=create st_18
this.st_19=create st_19
this.Control[]={this.ddlb_consordmin,&
this.ddlb_spdordmin,&
this.ddlb_conswrrmin,&
this.ddlb_spdwrrmin,&
this.rb_max,&
this.st_lastmodif,&
this.cbx_per,&
this.rb_linear,&
this.rb_admirality,&
this.st_15,&
this.st_14,&
this.cbx_wrrtype,&
this.st_13,&
this.em_aux,&
this.st_12,&
this.ddlb_consord,&
this.ddlb_conswrr,&
this.ddlb_spdord,&
this.ddlb_spdwrr,&
this.st_11,&
this.st_10,&
this.st_9,&
this.st_8,&
this.ddlb_bfsea,&
this.ddlb_bfwind,&
this.st_7,&
this.st_6,&
this.st_5,&
this.st_4,&
this.cb_delbl,&
this.cb_delld,&
this.cb_addbl,&
this.cb_addld,&
this.dw_bl,&
this.dw_ld,&
this.cb_cancel,&
this.cb_ok,&
this.st_3,&
this.st_2,&
this.st_1,&
this.rr_1,&
this.ln_1,&
this.ln_2,&
this.st_16,&
this.st_17,&
this.st_18,&
this.st_19}
end on

on w_wrr.destroy
destroy(this.ddlb_consordmin)
destroy(this.ddlb_spdordmin)
destroy(this.ddlb_conswrrmin)
destroy(this.ddlb_spdwrrmin)
destroy(this.rb_max)
destroy(this.st_lastmodif)
destroy(this.cbx_per)
destroy(this.rb_linear)
destroy(this.rb_admirality)
destroy(this.st_15)
destroy(this.st_14)
destroy(this.cbx_wrrtype)
destroy(this.st_13)
destroy(this.em_aux)
destroy(this.st_12)
destroy(this.ddlb_consord)
destroy(this.ddlb_conswrr)
destroy(this.ddlb_spdord)
destroy(this.ddlb_spdwrr)
destroy(this.st_11)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.ddlb_bfsea)
destroy(this.ddlb_bfwind)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.cb_delbl)
destroy(this.cb_delld)
destroy(this.cb_addbl)
destroy(this.cb_addld)
destroy(this.dw_bl)
destroy(this.dw_ld)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.st_16)
destroy(this.st_17)
destroy(this.st_18)
destroy(this.st_19)
end on

event open;
dw_Ld.SetTransObject(SQLCA)
dw_Bl.SetTransObject(SQLCA)

If dw_Ld.Retrieve( g_parameters.vesselid, 0)>0 then cb_delld.enabled = True
If dw_Bl.Retrieve( g_parameters.vesselid, 1)>0 then cb_delbl.enabled = True

ddlb_bfwind.Reset( )
ddlb_bfsea.Reset( )

For ii_idx = 3 to 7
	ddlb_bfWind.additem('BF ' + (string(ii_Idx)))
	ddlb_bfsea.additem ('BF ' + (string(ii_Idx)))
Next

SELECT VESSEL_NAME, VESSEL_NR, TPERF_W_WIND, TPERF_W_SEA, TPERF_WRR_PERCENT, TPERF_DEV_OSPD, TPERF_DEV_WSPD, TPERF_DEV_OCON, TPERF_DEV_WCON, TPERF_DEV_OSPD_MIN, TPERF_DEV_WSPD_MIN, TPERF_DEV_OCON_MIN, TPERF_DEV_WCON_MIN, TPERF_WRR_VER, TPERF_AUXCON, TPERF_WRRTYPE, TPERF_INTERPOLATION 
INTO :is_VName, :ii_VslNum, :ii_BFWind, :ii_BFSea, :ii_Percent, :id_DevOSpd, :id_DevWSpd, :id_DevOCon, :id_DevWCon, :id_DevOSpdMin, :id_DevWSpdMin, :id_DevOConMin, :id_DevWConMin, :ii_WrrVer, :id_AuxCon, :ii_wrrtype, :ii_Inter FROM VESSELS WHERE VESSEL_ID = :g_parameters.vesselid;

If SQLCA.SQLCode<>0 then
	MessageBox ('Database Error', 'Could not retrieve warranted settings from the database')
	cb_ok.Enabled = False
Else
	If IsNull(id_DevWSpd) then id_DevWSpd = 1.0
	this.title = "Warranted Settings: " + String(ii_VslNum, "000") + " - " + is_VName	
	ddlb_BFWind.selectitem (ii_BFWind - 2)
	ddlb_BFSea.selectitem (ii_BFSea - 2)
	If ii_Percent = 0 then
		cbx_Per.Checked = False
		wf_PopulateDDL(False)
		ddlb_spdwrr.selectitem (Int(id_DevWSpd * 4)+1)
		ddlb_spdord.selectitem (Int(id_DevOSpd * 4)+1)
		ddlb_spdwrrmin.selectitem (Int(id_DevWSpdMin * 4)+1)
		ddlb_spdordmin.selectitem (Int(id_DevOSpdMin * 4)+1)		
	Else
		wf_PopulateDDL(True)
		cbx_Per.Checked = True		
		ddlb_spdwrr.selectitem (Int(id_DevWSpd * 2)+1)
		ddlb_spdord.selectitem (Int(id_DevOSpd * 2)+1)
		ddlb_spdwrrmin.selectitem (Int(id_DevWSpdMin * 2)+1)
		ddlb_spdordmin.selectitem (Int(id_DevOSpdMin * 2)+1)		
	End If
	ddlb_conswrr.selectitem (Int(id_DevWCon * 2))
	ddlb_consord.selectitem (Int(id_DevOCon * 2))
	ddlb_conswrrmin.selectitem (Int(id_DevWConMin * 2))
	ddlb_consordmin.selectitem (Int(id_DevOConMin * 2))
	em_aux.text = string(id_auxcon, "0.0")
	If ii_WrrType = 0 then cbx_wrrtype.checked = False else cbx_wrrtype.checked = True
	If ii_Inter = 0 then rb_Admirality.Checked = True 
	If ii_Inter = 1 then rb_Linear.Checked = True
	If ii_Inter = 2 then rb_Max.Checked = True
End If

Commit;

DateTime ldt_Modif
String ls_Modif
Select TPERF_WRR_LASTMODIFIED, TPERF_WRR_MODIFIEDBY into :ldt_Modif, :ls_Modif From VESSELS Where VESSEL_ID = :g_Parameters.VesselID;

Commit;

If Not IsNull(ls_Modif) then st_LastModif.Text = "Last modified by " + ls_Modif + " on " + String(ldt_Modif, "dd MMM yyyy")


// Below commented to give full access to regular users as well (CR 1845)

//If g_userinfo.access = 1 then    // user is not a super user
//	ddlb_bfsea.Enabled = False
//	ddlb_bfwind.Enabled = False
//	ddlb_consord.Enabled = False
//	ddlb_conswrr.Enabled = False
//	ddlb_spdord.Enabled = False
//	ddlb_spdwrr.Enabled = False
//	em_aux.Enabled = False
//	cbx_wrrtype.Enabled = False
//	cb_addbl.Enabled=False
//	cb_addld.Enabled=False
//	cb_delbl.Enabled=False
//	cb_delld.Enabled=False
//	cb_ok.Visible = False
//	cb_Cancel.Text= "Close"
//	dw_ld.Enabled = False
//	dw_bl.Enabled = False
//	dw_ld.SelectRow(0, False)
//	dw_bl.SelectRow(0, False)
//	cb_Cancel.X=(This.Width - cb_Cancel.Width)/2
//	rb_admirality.Enabled = False
//	rb_linear.Enabled = False
//	cbx_Per.Enabled = False
//End If
end event

type ddlb_consordmin from dropdownlistbox within w_wrr
integer x = 1371
integer y = 2288
integer width = 293
integer height = 368
integer taborder = 160
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"3","4","5","6","7",""}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
id_DevOConMin = Index / 2
end event

type ddlb_spdordmin from dropdownlistbox within w_wrr
integer x = 1371
integer y = 2176
integer width = 293
integer height = 368
integer taborder = 120
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"3","4","5","6","7",""}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
If ii_Percent = 0 then id_DevOSpdMin = (Index - 1) / 4 Else id_DevOSpdMin = (Index - 1) / 2
end event

type ddlb_conswrrmin from dropdownlistbox within w_wrr
integer x = 512
integer y = 2288
integer width = 293
integer height = 368
integer taborder = 140
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"3","4","5","6","7",""}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
id_DevWConMin = Index / 2
end event

type ddlb_spdwrrmin from dropdownlistbox within w_wrr
integer x = 512
integer y = 2176
integer width = 293
integer height = 368
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"3","4","5","6","7",""}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
If ii_Percent = 0 then id_DevWSpdMin = (Index - 1) / 4 Else id_DevWSpdMin = (Index - 1) / 2
end event

type rb_max from radiobutton within w_wrr
integer x = 1408
integer y = 1552
integer width = 494
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Max Only"
end type

type st_lastmodif from statictext within w_wrr
integer x = 183
integer y = 2448
integer width = 1755
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_per from checkbox within w_wrr
integer x = 603
integer y = 1984
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
string text = "In Percent"
end type

event clicked;
If This.Checked then ii_Percent = 1 Else ii_Percent = 0

wf_PopulateDDL(This.Checked)
end event

type rb_linear from radiobutton within w_wrr
integer x = 750
integer y = 1552
integer width = 603
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Linear Interpolation"
end type

type rb_admirality from radiobutton within w_wrr
integer x = 146
integer y = 1552
integer width = 567
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Admirality Curve"
end type

type st_15 from statictext within w_wrr
integer x = 55
integer y = 1456
integer width = 1221
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Speed-Consumption Interpolation Method"
boolean focusrectangle = false
end type

type st_14 from statictext within w_wrr
integer x = 1189
integer y = 1728
integer width = 768
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 67108864
string text = "( Upto and including )"
boolean focusrectangle = false
end type

type cbx_wrrtype from checkbox within w_wrr
integer x = 1189
integer y = 1264
integer width = 859
integer height = 128
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Exclude Aux Warranted"
end type

event clicked;
If cbx_wrrtype.checked then ii_WrrType = 1 else ii_WrrType = 0

end event

type st_13 from statictext within w_wrr
integer x = 859
integer y = 1296
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 10789024
long backcolor = 67108864
string text = "MT / Day"
boolean focusrectangle = false
end type

type em_aux from editmask within w_wrr
integer x = 585
integer y = 1280
integer width = 256
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#0.0"
double increment = 0.1
string minmax = "0~~29.9"
end type

event modified;
id_auxcon = Dec(em_aux.text)
end event

type st_12 from statictext within w_wrr
integer x = 146
integer y = 1296
integer width = 439
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aux Warranted:"
boolean focusrectangle = false
end type

type ddlb_consord from dropdownlistbox within w_wrr
integer x = 1719
integer y = 2288
integer width = 293
integer height = 368
integer taborder = 150
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"3","4","5","6","7",""}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
id_DevOCon = Index / 2

end event

type ddlb_conswrr from dropdownlistbox within w_wrr
integer x = 859
integer y = 2288
integer width = 293
integer height = 368
integer taborder = 130
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"3","4","5","6","7",""}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
id_DevWCon = Index / 2
end event

type ddlb_spdord from dropdownlistbox within w_wrr
integer x = 1719
integer y = 2176
integer width = 293
integer height = 368
integer taborder = 110
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"3","4","5","6","7",""}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
If ii_Percent = 0 then id_DevOSpd = (Index - 1) / 4 Else id_DevOSpd = (Index - 1) / 2
end event

type ddlb_spdwrr from dropdownlistbox within w_wrr
integer x = 859
integer y = 2176
integer width = 293
integer height = 368
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"3","4","5","6","7",""}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
If ii_Percent = 0 then id_DevWSpd = (Index - 1) / 4 Else id_DevWSpd = (Index - 1) / 2

end event

type st_11 from statictext within w_wrr
integer x = 1371
integer y = 2096
integer width = 622
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Ordered Range"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_10 from statictext within w_wrr
integer x = 549
integer y = 2096
integer width = 617
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Warranted Range"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_9 from statictext within w_wrr
integer x = 73
integer y = 2304
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consumption:"
boolean focusrectangle = false
end type

type st_8 from statictext within w_wrr
integer x = 73
integer y = 2192
integer width = 256
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Speed:"
boolean focusrectangle = false
end type

type ddlb_bfsea from dropdownlistbox within w_wrr
integer x = 1408
integer y = 1824
integer width = 311
integer height = 560
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"3","4","5","6","7",""}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_BFSea = Index + 2

end event

type ddlb_bfwind from dropdownlistbox within w_wrr
integer x = 421
integer y = 1824
integer width = 311
integer height = 560
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"","","","","",""}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
ii_BFWind = Index + 2     // Get actual BF
end event

type st_7 from statictext within w_wrr
integer x = 1042
integer y = 1840
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sea State:"
boolean focusrectangle = false
end type

type st_6 from statictext within w_wrr
integer x = 73
integer y = 1840
integer width = 347
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Wind Force:"
boolean focusrectangle = false
end type

type st_5 from statictext within w_wrr
integer x = 55
integer y = 2000
integer width = 530
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Allowed Ranges"
boolean focusrectangle = false
end type

type st_4 from statictext within w_wrr
integer x = 55
integer y = 1728
integer width = 1152
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Warranted Sea and Wind Conditions"
boolean focusrectangle = false
end type

type cb_delbl from commandbutton within w_wrr
integer x = 1536
integer y = 1120
integer width = 439
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Entry"
end type

event clicked;Integer li_SelRow

li_SelRow = dw_Bl.GetSelectedRow(0)

If li_SelRow > 0 then
	If MessageBox("Confirm Delete", "Delete selected entry?", Question!, YesNo!) = 1 then
		dw_Bl.DeleteRow( li_SelRow)
		li_SelRow --
		If li_SelRow > 0 then
			dw_Bl.scrolltorow( li_SelRow)
			dw_Bl.selectrow( li_SelRow, True)
		Else
			This.enabled = False
		End if
	End If
Else
	MessageBox("No Selection", "Please select a row to delete.")
End if
end event

type cb_delld from commandbutton within w_wrr
integer x = 585
integer y = 1120
integer width = 439
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Entry"
end type

event clicked;Integer li_SelRow

li_SelRow = dw_Ld.GetSelectedRow(0)

If li_SelRow > 0 then
	If MessageBox("Confirm Delete", "Delete selected entry?", Question!, YesNo!) = 1 then
		dw_Ld.DeleteRow( li_SelRow)
		li_SelRow --
		If li_SelRow > 0 then
			dw_Ld.scrolltorow( li_SelRow)
			dw_Ld.selectrow( li_SelRow, True)
		else
			this.enabled = False
		End if
	End If
Else
	MessageBox("No Selection", "Please select a row to delete.")
End if
end event

type cb_addbl from commandbutton within w_wrr
integer x = 1097
integer y = 1120
integer width = 439
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Entry"
end type

event clicked;integer li_row

li_row = dw_Bl.Insertrow(0)

dw_Bl.SetItem( li_row, "spd", 0)
dw_Bl.SetItem( li_row, "con", 0)
dw_Bl.SetItem( li_row, "WType", 1)
dw_Bl.SetItem( li_row, "Vessel_ID", g_parameters.vesselid )

cb_delbl.enabled = True
end event

type cb_addld from commandbutton within w_wrr
integer x = 146
integer y = 1120
integer width = 439
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Entry"
end type

event clicked;integer li_row

li_row = dw_Ld.Insertrow(0)

dw_Ld.SetItem( li_row, "spd", 0)
dw_Ld.SetItem( li_row, "con", 0)
dw_Ld.SetItem( li_row, "WType", 0)
dw_Ld.SetItem( li_row, "Vessel_ID", g_parameters.vesselid )

cb_delld.enabled = True
end event

type dw_bl from datawindow within w_wrr
integer x = 1097
integer y = 288
integer width = 887
integer height = 832
integer taborder = 200
string title = "none"
string dataobject = "d_sq_tb_vslwrrtable"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
this.SelectRow( 0, False)
this.SelectRow( currentrow, True)
end event

event itemchanged;//string ls_status
//
//if this.getitemstatus( row, 0, Primary!) = NewModified! then 
//	ls_status = "NewModified!"
//elseif this.getitemstatus( row, 0, Primary!) = New! then 
//	ls_status = "New!"
//elseif this.getitemstatus( row, 0, Primary!) = DataModified! then 
//	ls_status = "DataModified!"
//elseif this.getitemstatus( row, 0, Primary!) = NotModified! then 
//	ls_status = "NotModified!"
//end if	
//	
//MessageBox("Before", ls_status)
//if this.getitemstatus( row, 0, Primary!) = NewModified! then Return
//
//
//Messagebox ("", "Old: " + string(this.getitemnumber(row, 1,Primary!,true)) + "    New:" + String(this.getitemnumber(row, 1,Primary!,False)))
//
//if (this.getitemnumber(row, 1,Primary!,true) = this.getitemnumber(row, 1,Primary!,false)) and (this.getitemnumber(row, 2,Primary!,true) = this.getitemnumber(row, 2,Primary!,false)) then
////	this.post setitemstatus( row, 0, Primary!, NotModified!)
//end if	
//
//if this.getitemstatus( row, 0, Primary!) = NewModified! then 
//	ls_status = "NewModified!"
//elseif this.getitemstatus( row, 0, Primary!) = New! then 
//	ls_status = "New!"
//elseif this.getitemstatus( row, 0, Primary!) = DataModified! then 
//	ls_status = "DataModified!"
//elseif this.getitemstatus( row, 0, Primary!) = NotModified! then 
//	ls_status = "NotModified!"
//end if	
//	
//MessageBox("After", ls_status)
//
end event

type dw_ld from datawindow within w_wrr
integer x = 146
integer y = 288
integer width = 887
integer height = 832
integer taborder = 170
string title = "none"
string dataobject = "d_sq_tb_vslwrrtable"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
this.SelectRow( 0, False)
this.SelectRow( currentrow, True)
end event

type cb_cancel from commandbutton within w_wrr
integer x = 1243
integer y = 2560
integer width = 549
integer height = 96
integer taborder = 190
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
close(parent)

end event

type cb_ok from commandbutton within w_wrr
integer x = 311
integer y = 2560
integer width = 549
integer height = 96
integer taborder = 180
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save"
boolean default = true
end type

event clicked;
Integer li_loop, li_rows, li_Inter
Boolean lbool_error
String ls_ErrorCode

// Check all entries for validity
dw_Bl.AcceptText()
dw_Ld.AcceptText()

// At least one entry is required for both Bll and Ldd
If dw_ld.Rowcount() < 1 or dw_bl.RowCount() < 1 then 
	MessageBox ("Warranted Table Incomplete", "Both 'Loaded Condition' and 'Ballast Condition' tables must have at least one speed and consumption entry.", Exclamation!)
	Return
End If

// Check Aux consumption
If dec(em_aux.text) <= 0 then
	MessageBox ("Aux Consumption", "Please specify the warranted consumption for auxiliary engines.", Exclamation!)
	em_aux.setfocus( )	
	Return
End If

li_rows = dw_ld.rowcount( )

// Check ascending order of values of Ldd table
For li_loop =  2 to li_rows 
	if dw_ld.GetItemNumber(li_loop, "spd") <= dw_ld.GetItemNumber(li_loop - 1, "spd") then lbool_error = true
	if dw_ld.GetItemNumber(li_loop, "con") <= dw_ld.GetItemNumber(li_loop - 1, "con") then lbool_error = true
	if lbool_error then exit
Next

// Do basic checking of values of Ldd table
For li_loop = 1 to li_rows
	if dw_ld.GetItemNumber(li_loop, "spd") <= 10 then lbool_error = true
	if dw_ld.GetItemNumber(li_loop, "spd") > 25 then lbool_error = true
	if dw_ld.GetItemNumber(li_loop, "con") < 10 then lbool_error = true
	if dw_ld.GetItemNumber(li_loop, "con") > 300 then lbool_error = true
	if lbool_error then exit	
Next 

If lbool_error then  // If any error found
	Messagebox("Invalid Table Entry", "The Loaded Speed & Consumption table contains an invalid entry. All figures of speed and consumption must be in ascending order and in the correct range.") 
	dw_ld.Selectrow( 0,False)
	dw_ld.Selectrow( li_loop,True)
Else  
	li_rows = dw_Bl.rowcount( )
	
	// Check ascending order of values of Ldd table
	For li_loop =  2 to li_rows 
		if dw_Bl.GetItemNumber(li_loop, "spd") <= dw_Bl.GetItemNumber(li_loop - 1, "spd") then lbool_error = true
		if dw_Bl.GetItemNumber(li_loop, "con") <= dw_Bl.GetItemNumber(li_loop - 1, "con") then lbool_error = true
		if lbool_error then exit
	Next
	
	// Do basic checking of values of Bll table
	For li_loop = 1 to li_rows
		if dw_Bl.GetItemNumber(li_loop, "spd") <= 10 then lbool_error = true
		if dw_Bl.GetItemNumber(li_loop, "spd") > 25 then lbool_error = true
		if dw_Bl.GetItemNumber(li_loop, "con") < 10 then lbool_error = true
		if dw_Bl.GetItemNumber(li_loop, "con") > 300 then lbool_error = true
		if lbool_error then exit	
	Next 
	
	// If any errors
	If lbool_error then
		Messagebox("Invalid Table Entry", "The Ballast Speed & Consumption table contains an invalid entry. All figures of speed and consumption must be in ascending order.") 
		dw_Bl.Selectrow( 0,False)
		dw_Bl.Selectrow( li_loop,True)
	End If	
End If

If not lbool_error then

	If MessageBox("Confirm Save", "Setting should be saved only if you have made changes. Please confirm if you want to save all warranted settings?", Question!, YesNo!) = 2 then return	
		
	ii_wrrver++     //  Increment Wrr version number
	
	li_rows = dw_ld.Update( )
	
	If li_rows = 1 then li_rows = li_rows + dw_bl.Update()
	
	if li_rows = 2 then  // both DW updated successfully
	
		If rb_admirality.Checked then li_Inter = 0 
		If rb_Linear.Checked then li_Inter = 1
		If rb_Max.Checked then li_Inter = 2 
	
		UPDATE VESSELS SET TPERF_W_SEA = :ii_BFSea, TPERF_W_WIND = :ii_BFWind, TPERF_WRR_PERCENT = :ii_Percent, TPERF_DEV_WSPD = :id_DevWSpd, TPERF_DEV_OSPD = :id_DevOSpd, TPERF_DEV_WCON = :id_DevWCon, TPERF_DEV_OCON = :id_DevOCon, TPERF_DEV_WSPD_MIN = :id_DevWSpdMin, TPERF_DEV_OSPD_MIN = :id_DevOSpdMin, TPERF_DEV_WCON_MIN = :id_DevWConMin, TPERF_DEV_OCON_MIN = :id_DevOConMin, TPERF_WRR_VER = :ii_WrrVer, TPERF_AUXCON = :id_AuxCon, TPERF_WRRTYPE = :ii_wrrtype, TPERF_INTERPOLATION = :li_Inter, TPERF_WRR_LASTMODIFIED = getdate(), TPERF_WRR_MODIFIEDBY = :g_UserInfo.userid  WHERE VESSEL_ID = :g_parameters.vesselid;

		If SQLCA.SQLCode <> 0 then
		  ls_ErrorCode = SQLCA.SQLerrtext
		  li_rows=0 
		End if
	Else
		ls_ErrorCode = "Datawindow Update() Function failed. Return Value = " + String(li_rows) 
	End If	
	
	If li_rows = 2 then     //  All successfull
		Commit;
		close(parent)
	Else
		Rollback;
		MessageBox("DB Update Error", ls_ErrorCode)
	End If
End if
end event

type st_3 from statictext within w_wrr
integer x = 1262
integer y = 192
integer width = 549
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Ballast Condition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_wrr
integer x = 329
integer y = 192
integer width = 549
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Loaded Condition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_wrr
integer x = 55
integer y = 64
integer width = 1152
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Warranted Speed and Consumption"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_wrr
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 67108864
integer x = 18
integer y = 16
integer width = 2085
integer height = 2512
integer cornerheight = 40
integer cornerwidth = 46
end type

type ln_1 from line within w_wrr
long linecolor = 12632256
integer linethickness = 4
integer beginx = 1152
integer beginy = 2224
integer endx = 1371
integer endy = 2336
end type

type ln_2 from line within w_wrr
long linecolor = 12632256
integer linethickness = 4
integer beginx = 1152
integer beginy = 2336
integer endx = 1371
integer endy = 2224
end type

type st_16 from statictext within w_wrr
integer x = 805
integer y = 2208
integer width = 73
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "to"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_17 from statictext within w_wrr
integer x = 805
integer y = 2320
integer width = 73
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "to"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_18 from statictext within w_wrr
integer x = 1664
integer y = 2208
integer width = 73
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "to"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_19 from statictext within w_wrr
integer x = 1664
integer y = 2320
integer width = 73
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "to"
alignment alignment = center!
boolean focusrectangle = false
end type

