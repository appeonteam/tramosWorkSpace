$PBExportHeader$w_appmonitorconfig.srw
forward
global type w_appmonitorconfig from w_system_base
end type
end forward

global type w_appmonitorconfig from w_system_base
integer width = 2994
integer height = 1756
string title = "Interface/Server App Monitor - Configuration"
end type
global w_appmonitorconfig w_appmonitorconfig

on w_appmonitorconfig.create
call super::create
end on

on w_appmonitorconfig.destroy
call super::destroy
end on

event open;call super::open;string	ls_mandatory_column[]

ls_mandatory_column = {"monitor_id", "description", "threshold"}
wf_format_datawindow(dw_1, ls_mandatory_column)

end event

type st_hidemenubar from w_system_base`st_hidemenubar within w_appmonitorconfig
end type

type cb_cancel from w_system_base`cb_cancel within w_appmonitorconfig
integer x = 2606
integer y = 1544
end type

type cb_refresh from w_system_base`cb_refresh within w_appmonitorconfig
integer x = 2930
integer y = 1788
end type

type cb_delete from w_system_base`cb_delete within w_appmonitorconfig
integer x = 2258
integer y = 1544
end type

type cb_update from w_system_base`cb_update within w_appmonitorconfig
integer x = 1911
integer y = 1544
end type

type cb_new from w_system_base`cb_new within w_appmonitorconfig
integer x = 1563
integer y = 1544
end type

type dw_1 from w_system_base`dw_1 within w_appmonitorconfig
integer width = 2912
integer height = 1504
string dataobject = "d_sq_gr_appmonitorconfig"
boolean ib_setdefaultbackgroundcolor = true
end type

