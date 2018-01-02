$PBExportHeader$w_invoice_basis.srw
$PBExportComments$Faktureringsgrundlag
forward
global type w_invoice_basis from mt_w_sheet
end type
type dw_date_start from u_datagrid within w_invoice_basis
end type
type dw_date_end from u_datagrid within w_invoice_basis
end type
type dw_consultant from u_datagrid within w_invoice_basis
end type
type st_5 from mt_u_statictext within w_invoice_basis
end type
type st_4 from mt_u_statictext within w_invoice_basis
end type
type st_6 from mt_u_statictext within w_invoice_basis
end type
type cb_refresh from mt_u_commandbutton within w_invoice_basis
end type
type cb_save from mt_u_commandbutton within w_invoice_basis
end type
type dw_invoice_basis from u_datagrid within w_invoice_basis
end type
type st_7 from u_topbar_background within w_invoice_basis
end type
end forward

global type w_invoice_basis from mt_w_sheet
integer width = 1911
integer height = 2112
string title = "Invoice Basis"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
dw_date_start dw_date_start
dw_date_end dw_date_end
dw_consultant dw_consultant
st_5 st_5
st_4 st_4
st_6 st_6
cb_refresh cb_refresh
cb_save cb_save
dw_invoice_basis dw_invoice_basis
st_7 st_7
end type
global w_invoice_basis w_invoice_basis

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_invoice_basis
   <OBJECT>		Invoice Basis Report	</OBJECT>
   <USAGE>					</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	02-04-2013 CR2614       LHG008        Change GUI
   	12/07/2013 CR3254       LHG008        1. Default save as Excel8;  2. Give valid name to some objects
   </HISTORY>
********************************************************************/
end subroutine

event open;call super::open;long ll_newrow
n_dw_style_service   lnv_style
n_service_manager lnv_servicemgr

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_invoice_basis, false)

ll_newrow = dw_date_start.insertrow(0)
dw_date_start.setitem(ll_newrow,"date_value",date("01-" + string(month(today())) + "-" + string(year(today()))))

ll_newrow = dw_date_end.insertrow(0)
dw_date_end.setitem(ll_newrow,"date_value",today())

dw_invoice_basis.settransobject(sqlca)
dw_consultant.settransobject(sqlca)

dw_consultant.insertrow(0)
end event

on w_invoice_basis.create
int iCurrent
call super::create
this.dw_date_start=create dw_date_start
this.dw_date_end=create dw_date_end
this.dw_consultant=create dw_consultant
this.st_5=create st_5
this.st_4=create st_4
this.st_6=create st_6
this.cb_refresh=create cb_refresh
this.cb_save=create cb_save
this.dw_invoice_basis=create dw_invoice_basis
this.st_7=create st_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_date_start
this.Control[iCurrent+2]=this.dw_date_end
this.Control[iCurrent+3]=this.dw_consultant
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.cb_refresh
this.Control[iCurrent+8]=this.cb_save
this.Control[iCurrent+9]=this.dw_invoice_basis
this.Control[iCurrent+10]=this.st_7
end on

on w_invoice_basis.destroy
call super::destroy
destroy(this.dw_date_start)
destroy(this.dw_date_end)
destroy(this.dw_consultant)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_6)
destroy(this.cb_refresh)
destroy(this.cb_save)
destroy(this.dw_invoice_basis)
destroy(this.st_7)
end on

event activate;call super::activate;if w_tramos_main.MenuName <> "m_creqmain" then
	w_tramos_main.ChangeMenu(m_creqmain)
	m_creqmain.mf_controlreport()
end if

end event

type dw_date_start from u_datagrid within w_invoice_basis
integer x = 293
integer y = 112
integer width = 329
integer height = 64
integer taborder = 20
string dataobject = "d_input_date"
boolean border = false
end type

event itemchanged;call super::itemchanged;cb_refresh.event clicked()
end event

event losefocus;call super::losefocus;this.accepttext()
end event

type dw_date_end from u_datagrid within w_invoice_basis
integer x = 768
integer y = 112
integer width = 329
integer height = 64
integer taborder = 30
string dataobject = "d_input_date"
boolean border = false
end type

event itemchanged;call super::itemchanged;cb_refresh.event clicked()
end event

event losefocus;call super::losefocus;this.accepttext()
end event

type dw_consultant from u_datagrid within w_invoice_basis
integer x = 293
integer y = 32
integer width = 805
integer height = 64
integer taborder = 10
string dataobject = "d_select_consultant"
boolean border = false
end type

event itemchanged;call super::itemchanged;cb_refresh.event clicked()
end event

type st_5 from mt_u_statictext within w_invoice_basis
integer x = 37
integer y = 40
integer width = 247
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Consultant"
end type

type st_4 from mt_u_statictext within w_invoice_basis
integer x = 37
integer y = 120
integer width = 238
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Start"
alignment alignment = right!
end type

type st_6 from mt_u_statictext within w_invoice_basis
integer x = 640
integer y = 120
integer width = 110
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "End"
alignment alignment = right!
end type

type cb_refresh from mt_u_commandbutton within w_invoice_basis
integer x = 1175
integer y = 32
integer taborder = 40
string text = "&Refresh"
boolean default = true
end type

event clicked;call super::clicked;dw_date_start.accepttext()
dw_date_end.accepttext()
dw_consultant.accepttext()
dw_invoice_basis.retrieve(datetime(dw_date_start.getitemdate(1,"date_value")),datetime(relativedate(dw_date_end.getitemdate(1,"date_value"),1)), dw_consultant.getitemnumber(1,"consultant_id" ))
dw_invoice_basis.event rowfocuschanged(1)
end event

type cb_save from mt_u_commandbutton within w_invoice_basis
integer x = 1522
integer y = 32
integer taborder = 50
string text = "&Save As..."
end type

event clicked;call super::clicked;dw_invoice_basis.saveas("", Excel8!, true)
end event

type dw_invoice_basis from u_datagrid within w_invoice_basis
integer x = 37
integer y = 240
integer width = 1829
integer height = 1760
integer taborder = 60
string dataobject = "d_sq_gr_invoice_basis"
boolean vscrollbar = true
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	this.selectrow(0, false ) 
	this.selectrow(currentrow, true ) 
	this.setrow(currentrow)
end if
end event

type st_7 from u_topbar_background within w_invoice_basis
integer width = 1902
end type

