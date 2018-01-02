$PBExportHeader$w_bunker_ifrs.srw
forward
global type w_bunker_ifrs from mt_w_sheet
end type
type dw_report from mt_u_datawindow within w_bunker_ifrs
end type
type dw_date from mt_u_datawindow within w_bunker_ifrs
end type
type st_2 from mt_u_statictext within w_bunker_ifrs
end type
type cb_retrieve from mt_u_commandbutton within w_bunker_ifrs
end type
type cb_saveas from mt_u_commandbutton within w_bunker_ifrs
end type
type cb_print from mt_u_commandbutton within w_bunker_ifrs
end type
type st_1 from u_topbar_background within w_bunker_ifrs
end type
end forward

global type w_bunker_ifrs from mt_w_sheet
string tag = "d_ex_tb_outstanding_frt_date"
integer width = 3483
integer height = 2568
string title = "IFRS 15 Bunker Report"
boolean maxbox = false
boolean resizable = false
boolean center = false
boolean ib_setdefaultbackgroundcolor = true
dw_report dw_report
dw_date dw_date
st_2 st_2
cb_retrieve cb_retrieve
cb_saveas cb_saveas
cb_print cb_print
st_1 st_1
end type
global w_bunker_ifrs w_bunker_ifrs

type variables
n_messagebox inv_messagebox

end variables

forward prototypes
public subroutine wf_retrieve ()
public subroutine documentation ()
end prototypes

public subroutine wf_retrieve ();/********************************************************************
   wf_retrieve
   <DESC>Retrieve data for report.</DESC>
   <RETURN>	(none)  </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date          	CR-Ref		Author		Comments
		02-08-2017		CR4629		XSZ004		First Version	      
   </HISTORY>
********************************************************************/

datetime ldt_date

dw_date.accepttext( )
dw_report.reset()

ldt_date = datetime(dw_date.getitemdate(1, "date_value"))

if isnull(ldt_date) then
	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You must enter a Report Date.", this)
	dw_date.setfocus()
else
	dw_report.retrieve(uo_global.gos_userid, ldt_date)
end if

if dw_report.rowcount() > 0 then
	cb_saveas.enabled = true
	cb_print.enabled  = true
else
	cb_saveas.enabled = false
	cb_print.enabled  = false
end if

end subroutine

public subroutine documentation ();/********************************************************************
   w_bunker_ifrs
   <DESC></DESC>
   <RETURN>	(none)  </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date          	CR-Ref		Author		Comments
		02-08-2017		CR4629		XSZ004		First Version	      
   </HISTORY>
********************************************************************/
end subroutine

on w_bunker_ifrs.create
int iCurrent
call super::create
this.dw_report=create dw_report
this.dw_date=create dw_date
this.st_2=create st_2
this.cb_retrieve=create cb_retrieve
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
this.Control[iCurrent+2]=this.dw_date
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_retrieve
this.Control[iCurrent+5]=this.cb_saveas
this.Control[iCurrent+6]=this.cb_print
this.Control[iCurrent+7]=this.st_1
end on

on w_bunker_ifrs.destroy
call super::destroy
destroy(this.dw_report)
destroy(this.dw_date)
destroy(this.st_2)
destroy(this.cb_retrieve)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.st_1)
end on

event open;call super::open;n_service_manager lnv_servicemgr
n_dw_style_service lnv_style

lnv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_report, false)

dw_report.settransobject( sqlca)

dw_date.insertrow(0)
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_bunker_ifrs
end type

type dw_report from mt_u_datawindow within w_bunker_ifrs
integer x = 37
integer y = 240
integer width = 3401
integer height = 2120
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sp_gr_bunker_ifrs"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
boolean ib_setselectrow = true
end type

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0, false)
this.selectrow(currentrow, true)
end event

type dw_date from mt_u_datawindow within w_bunker_ifrs
integer x = 324
integer y = 32
integer width = 352
integer height = 72
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_ex_tb_bunker_rpt_date"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type st_2 from mt_u_statictext within w_bunker_ifrs
integer x = 37
integer y = 32
integer width = 279
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 553648127
string text = "Report Date"
end type

type cb_retrieve from mt_u_commandbutton within w_bunker_ifrs
integer x = 2400
integer y = 2376
integer taborder = 30
boolean bringtotop = true
string text = "&Retrieve"
end type

event clicked;call super::clicked;wf_retrieve()
end event

type cb_saveas from mt_u_commandbutton within w_bunker_ifrs
integer x = 2747
integer y = 2376
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "&Save As..."
end type

event clicked;call super::clicked;dw_report.of_save_dw_content()
end event

type cb_print from mt_u_commandbutton within w_bunker_ifrs
integer x = 3095
integer y = 2376
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "&Print"
end type

event clicked;call super::clicked;n_dataprint lnv_print

lnv_print.of_print(dw_report)
end event

type st_1 from u_topbar_background within w_bunker_ifrs
end type

