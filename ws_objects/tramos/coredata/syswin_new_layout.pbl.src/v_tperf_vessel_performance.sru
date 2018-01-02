$PBExportHeader$v_tperf_vessel_performance.sru
forward
global type v_tperf_vessel_performance from userobject
end type
type st_3 from statictext within v_tperf_vessel_performance
end type
type st_noballast from statictext within v_tperf_vessel_performance
end type
type st_noladen from statictext within v_tperf_vessel_performance
end type
type st_ballast from statictext within v_tperf_vessel_performance
end type
type st_laden from statictext within v_tperf_vessel_performance
end type
type st_2 from statictext within v_tperf_vessel_performance
end type
type cbx_aux from checkbox within v_tperf_vessel_performance
end type
type ddlb_voyageperiod from dropdownlistbox within v_tperf_vessel_performance
end type
type st_1 from statictext within v_tperf_vessel_performance
end type
type dw_ballast from datawindow within v_tperf_vessel_performance
end type
type dw_laden from datawindow within v_tperf_vessel_performance
end type
type gb_1 from groupbox within v_tperf_vessel_performance
end type
end forward

global type v_tperf_vessel_performance from userobject
integer width = 1289
integer height = 1928
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_3 st_3
st_noballast st_noballast
st_noladen st_noladen
st_ballast st_ballast
st_laden st_laden
st_2 st_2
cbx_aux cbx_aux
ddlb_voyageperiod ddlb_voyageperiod
st_1 st_1
dw_ballast dw_ballast
dw_laden dw_laden
gb_1 gb_1
end type
global v_tperf_vessel_performance v_tperf_vessel_performance

type variables

DateTime ldt_Start

Integer ii_VesselID
end variables

forward prototypes
public subroutine of_retrievedata ()
public subroutine of_loadvessel (integer ai_vesselnr)
end prototypes

public subroutine of_retrievedata ();// This function retrieves the data. If distance is less than MinDist, the DW is not shown

Integer li_Wrr, li_MinDist = 1000

If cbx_Aux.Checked then li_Wrr = 0 Else li_Wrr = 1

dw_Laden.Retrieve(ii_VesselID, 0, li_Wrr, ldt_Start)
dw_Ballast.Retrieve(ii_VesselID, 1, li_Wrr, ldt_Start)

If dw_Laden.GetItemNumber(1, "TotalDist") < li_MinDist then 
	dw_Laden.Visible = False
	st_NoLaden.Visible = True
Else
	dw_Laden.Visible = True
	st_NoLaden.Visible = False
End If

If dw_Ballast.GetItemNumber(1, "TotalDist") < li_MinDist then 
	dw_Ballast.Visible = False
	st_NoBallast.Visible = True
Else
	dw_Ballast.Visible = True
	st_NoBallast.Visible = False
End If
end subroutine

public subroutine of_loadvessel (integer ai_vesselnr);// This function loads a vessel

Integer li_Wrr = 0

Select TPERF_WRRTYPE, VESSEL_ID Into :li_Wrr, :ii_VesselID From VESSELS Where VESSEL_NR = :ai_VesselNr;

Commit;

cbx_Aux.Checked = (li_Wrr = 0)

// Reset all
ddlb_VoyagePeriod.SelectItem(0)
dw_Ballast.Visible = False
dw_Laden.Visible = False
dw_Ballast.Reset()
dw_Laden.Reset()
st_NoLaden.Visible = False
st_NoBallast.Visible = False
st_Laden.Visible = False
st_Ballast.Visible = False


end subroutine

on v_tperf_vessel_performance.create
this.st_3=create st_3
this.st_noballast=create st_noballast
this.st_noladen=create st_noladen
this.st_ballast=create st_ballast
this.st_laden=create st_laden
this.st_2=create st_2
this.cbx_aux=create cbx_aux
this.ddlb_voyageperiod=create ddlb_voyageperiod
this.st_1=create st_1
this.dw_ballast=create dw_ballast
this.dw_laden=create dw_laden
this.gb_1=create gb_1
this.Control[]={this.st_3,&
this.st_noballast,&
this.st_noladen,&
this.st_ballast,&
this.st_laden,&
this.st_2,&
this.cbx_aux,&
this.ddlb_voyageperiod,&
this.st_1,&
this.dw_ballast,&
this.dw_laden,&
this.gb_1}
end on

on v_tperf_vessel_performance.destroy
destroy(this.st_3)
destroy(this.st_noballast)
destroy(this.st_noladen)
destroy(this.st_ballast)
destroy(this.st_laden)
destroy(this.st_2)
destroy(this.cbx_aux)
destroy(this.ddlb_voyageperiod)
destroy(this.st_1)
destroy(this.dw_ballast)
destroy(this.dw_laden)
destroy(this.gb_1)
end on

event constructor;
ddlb_VoyagePeriod.SelectItem(0)

dw_Laden.SetTransObject(SQLCA)
dw_Ballast.SetTransObject(SQLCA)
end event

type st_3 from statictext within v_tperf_vessel_performance
integer x = 55
integer y = 1816
integer width = 1189
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 67108864
string text = "( Sailings under 12 hours are not included)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_noballast from statictext within v_tperf_vessel_performance
boolean visible = false
integer x = 91
integer y = 1312
integer width = 1097
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 67108864
string text = "Insufficient data"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_noladen from statictext within v_tperf_vessel_performance
boolean visible = false
integer x = 91
integer y = 576
integer width = 1097
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 67108864
string text = "Insufficient data"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_ballast from statictext within v_tperf_vessel_performance
integer x = 73
integer y = 1088
integer width = 585
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ballast Performance"
boolean focusrectangle = false
end type

type st_laden from statictext within v_tperf_vessel_performance
integer x = 73
integer y = 368
integer width = 585
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Laden Performance"
boolean focusrectangle = false
end type

type st_2 from statictext within v_tperf_vessel_performance
integer x = 55
integer y = 320
integer width = 1170
integer height = 8
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 8421504
boolean border = true
long bordercolor = 8421504
boolean focusrectangle = false
end type

type cbx_aux from checkbox within v_tperf_vessel_performance
integer x = 73
integer y = 192
integer width = 663
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Include Auxiliary Cons"
boolean lefttext = true
end type

event clicked;
of_RetrieveData()
end event

type ddlb_voyageperiod from dropdownlistbox within v_tperf_vessel_performance
integer x = 677
integer y = 80
integer width = 530
integer height = 352
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Last 6 months","Last 1 Year","Last 2 Years","All Data"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
Choose Case index
	Case 1
		ldt_Start = DateTime(RelativeDate(Today(), -180))
	Case 2
		ldt_Start = DateTime(RelativeDate(Today(), -365))
	Case 3
		ldt_Start = DateTime(RelativeDate(Today(), -730))
	Case 4
		ldt_Start = DateTime(Date(2000,1,1))
End Choose
	
st_Laden.Visible = True
st_Ballast.Visible = True
	
of_RetrieveData()
end event

type st_1 from statictext within v_tperf_vessel_performance
integer x = 73
integer y = 96
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Period"
boolean focusrectangle = false
end type

type dw_ballast from datawindow within v_tperf_vessel_performance
integer x = 73
integer y = 1152
integer width = 1152
integer height = 656
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_tperf_vsl_summary"
boolean border = false
boolean livescroll = true
end type

type dw_laden from datawindow within v_tperf_vessel_performance
integer x = 73
integer y = 432
integer width = 1170
integer height = 624
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_tperf_vsl_summary"
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within v_tperf_vessel_performance
integer x = 18
integer width = 1243
integer height = 1888
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "T-Perf Vessel Data"
end type

