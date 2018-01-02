$PBExportHeader$w_accruals_control.srw
$PBExportComments$Accruals control/configuration and report lookup.
forward
global type w_accruals_control from mt_w_main
end type
type pb_1 from picturebutton within w_accruals_control
end type
type uo_searchbox from u_searchbox within w_accruals_control
end type
type rb_vessel from radiobutton within w_accruals_control
end type
type rb_pc from radiobutton within w_accruals_control
end type
type rb_period from radiobutton within w_accruals_control
end type
type uo_att from u_fileattach within w_accruals_control
end type
type gb_1 from groupbox within w_accruals_control
end type
type r_1 from rectangle within w_accruals_control
end type
type dw_byvessel from mt_u_datawindow within w_accruals_control
end type
type dw_bypc from mt_u_datawindow within w_accruals_control
end type
type dw_byperiod from mt_u_datawindow within w_accruals_control
end type
end forward

global type w_accruals_control from mt_w_main
integer width = 2711
integer height = 2272
string title = "Accruals Control"
long backcolor = 32304364
pb_1 pb_1
uo_searchbox uo_searchbox
rb_vessel rb_vessel
rb_pc rb_pc
rb_period rb_period
uo_att uo_att
gb_1 gb_1
r_1 r_1
dw_byvessel dw_byvessel
dw_bypc dw_bypc
dw_byperiod dw_byperiod
end type
global w_accruals_control w_accruals_control

type variables
boolean _ib_expanded = false
end variables

forward prototypes
public function integer _changetreeview (integer ai_option)
public subroutine documentation ()
end prototypes

public function integer _changetreeview (integer ai_option);_ib_expanded = false

if ai_option = 1 then
	dw_bypc.visible = false
	dw_byvessel.visible = false
	dw_byperiod.setsort("description A vessel_fullname A voyage_nr A")		
	dw_byperiod.sort()
	dw_byperiod.groupcalc()
	dw_byperiod.visible = true
elseif ai_option = 2 then
	dw_byperiod.visible = false
	dw_byvessel.visible = false
	dw_bypc.setsort("pc_name A vessel_fullname A voyage_nr A")	
	dw_bypc.sort()
	dw_bypc.groupcalc()
	dw_bypc.visible = true
elseif ai_option=3 then
	dw_byperiod.visible = false
	dw_bypc.visible = false
	dw_byvessel.setsort("vessel_fullname A voyage_nr A description A")	
	dw_byvessel.sort()
	dw_byvessel.groupcalc()
	dw_byvessel.visible = true
end if
return c#return.Success

// 
// 
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_accruals_control.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.uo_searchbox=create uo_searchbox
this.rb_vessel=create rb_vessel
this.rb_pc=create rb_pc
this.rb_period=create rb_period
this.uo_att=create uo_att
this.gb_1=create gb_1
this.r_1=create r_1
this.dw_byvessel=create dw_byvessel
this.dw_bypc=create dw_bypc
this.dw_byperiod=create dw_byperiod
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.uo_searchbox
this.Control[iCurrent+3]=this.rb_vessel
this.Control[iCurrent+4]=this.rb_pc
this.Control[iCurrent+5]=this.rb_period
this.Control[iCurrent+6]=this.uo_att
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.r_1
this.Control[iCurrent+9]=this.dw_byvessel
this.Control[iCurrent+10]=this.dw_bypc
this.Control[iCurrent+11]=this.dw_byperiod
end on

on w_accruals_control.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.uo_searchbox)
destroy(this.rb_vessel)
destroy(this.rb_pc)
destroy(this.rb_period)
destroy(this.uo_att)
destroy(this.gb_1)
destroy(this.r_1)
destroy(this.dw_byvessel)
destroy(this.dw_bypc)
destroy(this.dw_byperiod)
end on

event open;call super::open;/* setup datawindow formatter service */
n_service_manager		lnv_serviceMgr
n_dw_style_service   	lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_bypc)
lnv_style.of_dwlistformater(dw_byvessel)
lnv_style.of_dwlistformater(dw_byperiod)

dw_bypc.settransobject( sqlca )
dw_byvessel.settransobject( sqlca )
dw_byperiod.settransobject( sqlca )

dw_byperiod.retrieve( )
dw_byperiod.sharedata(dw_bypc)
dw_byperiod.sharedata(dw_byvessel)

uo_SearchBox.of_initialize(dw_byperiod, "vessel_fullname+'~'+description")

end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_accruals_control
end type

type pb_1 from picturebutton within w_accruals_control
integer x = 55
integer y = 2060
integer width = 110
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "TreeView!"
alignment htextalign = left!
end type

event clicked;_ib_expanded = not(_ib_expanded)

if _ib_expanded then
	if rb_pc.checked then dw_bypc.expandall( )
	if rb_period.checked then dw_byperiod.expandall( )
	if rb_vessel.checked then dw_byvessel.expandall( )
else
	if rb_pc.checked then dw_bypc.collapseall( )
	if rb_period.checked then dw_byperiod.collapseall( )
	if rb_vessel.checked then dw_byvessel.collapseall( )
end if
end event

type uo_searchbox from u_searchbox within w_accruals_control
integer x = 1760
integer y = 28
integer width = 901
integer taborder = 60
long backcolor = 22628899
end type

event constructor;call super::constructor;this.st_search.backcolor = c#color.MT_LISTHEADER_BG
this.st_search.textcolor = c#color.White

end event

on uo_searchbox.destroy
call u_searchbox::destroy
end on

type rb_vessel from radiobutton within w_accruals_control
integer x = 1285
integer y = 76
integer width = 279
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Vessel"
end type

event clicked;_changetreeview(3)
end event

type rb_pc from radiobutton within w_accruals_control
integer x = 786
integer y = 76
integer width = 411
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Profit Center"
end type

event clicked;_changetreeview(2)
end event

type rb_period from radiobutton within w_accruals_control
integer x = 384
integer y = 76
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Period"
boolean checked = true
end type

event clicked;_changetreeview(1)
end event

type uo_att from u_fileattach within w_accruals_control
boolean visible = false
integer x = 155
integer y = 740
integer width = 1678
integer height = 428
integer taborder = 40
boolean border = true
end type

on uo_att.destroy
call u_fileattach::destroy
end on

type gb_1 from groupbox within w_accruals_control
integer x = 55
integer y = 16
integer width = 1550
integer height = 156
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 32304364
long backcolor = 22628899
string text = "View by"
end type

type r_1 from rectangle within w_accruals_control
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 22628899
integer y = 4
integer width = 2679
integer height = 200
end type

type dw_byvessel from mt_u_datawindow within w_accruals_control
boolean visible = false
integer x = 55
integer y = 236
integer width = 2578
integer height = 1792
integer taborder = 50
string dataobject = "d_sq_tv_accruals_by_vessel_file_listing"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;if right(dwo.name,8) = "openfile" then
	uo_att.of_openattachment(row, dw_bypc)
end if
end event

type dw_bypc from mt_u_datawindow within w_accruals_control
boolean visible = false
integer x = 55
integer y = 236
integer width = 2578
integer height = 1792
integer taborder = 40
string dataobject = "d_sq_tv_accruals_by_pc_file_listing"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;if right(dwo.name,8) = "openfile" then
	uo_att.of_openattachment(row, dw_bypc)
end if
end event

type dw_byperiod from mt_u_datawindow within w_accruals_control
integer x = 55
integer y = 236
integer width = 2583
integer height = 1792
integer taborder = 40
string dataobject = "d_sq_tv_accruals_by_period_file_listing"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;if right(dwo.name,8) = "openfile" then
	uo_att.of_openattachment(row, dw_byvessel)
end if
end event

