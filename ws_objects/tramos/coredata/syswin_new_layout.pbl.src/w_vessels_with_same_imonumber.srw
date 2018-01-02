$PBExportHeader$w_vessels_with_same_imonumber.srw
$PBExportComments$Window used from vessels maintainance window showing vessels with the same IMO# or without an IMO#
forward
global type w_vessels_with_same_imonumber from mt_w_response
end type
type cbx_active from checkbox within w_vessels_with_same_imonumber
end type
type rb_without from radiobutton within w_vessels_with_same_imonumber
end type
type rb_with from radiobutton within w_vessels_with_same_imonumber
end type
type dw_vessellist from u_datagrid within w_vessels_with_same_imonumber
end type
type gb_1 from groupbox within w_vessels_with_same_imonumber
end type
end forward

global type w_vessels_with_same_imonumber from mt_w_response
integer width = 2153
integer height = 1556
string title = "Vessels with same IMO #"
boolean ib_setdefaultbackgroundcolor = true
cbx_active cbx_active
rb_without rb_without
rb_with rb_with
dw_vessellist dw_vessellist
gb_1 gb_1
end type
global w_vessels_with_same_imonumber w_vessels_with_same_imonumber

type variables
s_vessels_with_same_imonumber_parm		istr_parm
end variables

on w_vessels_with_same_imonumber.create
int iCurrent
call super::create
this.cbx_active=create cbx_active
this.rb_without=create rb_without
this.rb_with=create rb_with
this.dw_vessellist=create dw_vessellist
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_active
this.Control[iCurrent+2]=this.rb_without
this.Control[iCurrent+3]=this.rb_with
this.Control[iCurrent+4]=this.dw_vessellist
this.Control[iCurrent+5]=this.gb_1
end on

on w_vessels_with_same_imonumber.destroy
call super::destroy
destroy(this.cbx_active)
destroy(this.rb_without)
destroy(this.rb_with)
destroy(this.dw_vessellist)
destroy(this.gb_1)
end on

event open;call super::open;n_service_manager		lnv_service_manager
n_dw_style_service	lnv_dwstyle

istr_parm = message.powerObjectParm

this.title += " "+string(istr_parm.imo_number)

dw_vessellist.setTransObject(sqlca)
dw_vessellist.post retrieve(istr_parm.imo_number, istr_parm.vessel_number)

lnv_service_manager.of_loadservice(lnv_dwstyle, "n_dw_style_service")
lnv_dwstyle.of_dwlistformater(dw_vessellist, false)

end event

type cbx_active from checkbox within w_vessels_with_same_imonumber
integer x = 1696
integer y = 1188
integer width = 411
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Active vessels"
end type

event clicked;if this.checked then
	dw_vessellist.setFilter("vessel_active=1")
	dw_vessellist.filter()
else
	dw_vessellist.setFilter("")
	dw_vessellist.filter()
end if

end event

type rb_without from radiobutton within w_vessels_with_same_imonumber
integer x = 82
integer y = 1344
integer width = 786
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessels without IMO number"
end type

event clicked;n_service_manager		lnv_service_manager
n_dw_style_service	lnv_dwstyle

dw_vessellist.dataObject = "d_sq_tb_vessels_without_imonumber"
dw_vessellist.setTransObject(sqlca)
dw_vessellist.post retrieve()

lnv_service_manager.of_loadservice(lnv_dwstyle, "n_dw_style_service")
lnv_dwstyle.of_dwlistformater(dw_vessellist, false)

end event

type rb_with from radiobutton within w_vessels_with_same_imonumber
integer x = 82
integer y = 1260
integer width = 786
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessels with same IMO number"
boolean checked = true
end type

event clicked;n_service_manager		lnv_service_manager
n_dw_style_service	lnv_dwstyle

dw_vessellist.dataObject = "d_sq_tb_vessels_with_same_imonumber"
dw_vessellist.setTransObject(sqlca)
dw_vessellist.post retrieve(istr_parm.imo_number, istr_parm.vessel_number)

lnv_service_manager.of_loadservice(lnv_dwstyle, "n_dw_style_service")
lnv_dwstyle.of_dwlistformater(dw_vessellist, false)

end event

type dw_vessellist from u_datagrid within w_vessels_with_same_imonumber
integer x = 37
integer y = 32
integer width = 2071
integer height = 1136
integer taborder = 10
string dataobject = "d_sq_tb_vessels_with_same_imonumber"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

type gb_1 from groupbox within w_vessels_with_same_imonumber
integer x = 37
integer y = 1188
integer width = 864
integer height = 260
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select report..."
end type

