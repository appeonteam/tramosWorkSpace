$PBExportHeader$w_appmonitor.srw
forward
global type w_appmonitor from mt_w_main
end type
type dw_monitor from mt_u_datawindow within w_appmonitor
end type
type cb_config from mt_u_commandbutton within w_appmonitor
end type
type cb_refresh from mt_u_commandbutton within w_appmonitor
end type
end forward

global type w_appmonitor from mt_w_main
integer width = 3333
integer height = 1756
string title = "Interface/Server App Monitor"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
dw_monitor dw_monitor
cb_config cb_config
cb_refresh cb_refresh
end type
global w_appmonitor w_appmonitor

on w_appmonitor.create
int iCurrent
call super::create
this.dw_monitor=create dw_monitor
this.cb_config=create cb_config
this.cb_refresh=create cb_refresh
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_monitor
this.Control[iCurrent+2]=this.cb_config
this.Control[iCurrent+3]=this.cb_refresh
end on

on w_appmonitor.destroy
call super::destroy
destroy(this.dw_monitor)
destroy(this.cb_config)
destroy(this.cb_refresh)
end on

event open;call super::open;n_dw_style_service   lnv_style
n_service_manager lnv_servicemgr

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_monitor, false)

cb_refresh.event clicked()
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_appmonitor
end type

type dw_monitor from mt_u_datawindow within w_appmonitor
integer x = 37
integer y = 32
integer width = 3250
integer height = 1504
integer taborder = 10
string dataobject = "d_sq_gr_appmonitor"
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

event doubleclicked;call super::doubleclicked;string ls_null
datetime ldt_null

if (row > 0) then
	choose case dwo.Name
		case "lastkeyword", "lastkeyworddate"
			setnull(ls_null)
			this.setitem(row, "lastkeyword", ls_null)
			setnull(ldt_null)
			this.setitem(row, "lastkeyworddate", ldt_null)
			if this.update() = 1 then
				sqlca.of_commit()
			else
				sqlca.of_rollback()
			end if
	end choose
end if

end event

type cb_config from mt_u_commandbutton within w_appmonitor
integer x = 2597
integer y = 1544
integer taborder = 20
boolean bringtotop = true
string text = "&Config"
end type

event clicked;call super::clicked;opensheet(w_appmonitorconfig, w_tramos_main, 0, original!)
end event

type cb_refresh from mt_u_commandbutton within w_appmonitor
integer x = 2944
integer y = 1544
integer taborder = 30
boolean bringtotop = true
string text = "&Refresh"
end type

event clicked;call super::clicked;dw_monitor.settransobject(sqlca)
dw_monitor.retrieve()

end event

