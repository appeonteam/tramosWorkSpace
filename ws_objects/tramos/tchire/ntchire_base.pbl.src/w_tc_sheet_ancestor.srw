$PBExportHeader$w_tc_sheet_ancestor.srw
forward
global type w_tc_sheet_ancestor from mt_w_master
end type
end forward

global type w_tc_sheet_ancestor from mt_w_master
event ue_dwgotfocus ( datawindow adw_control )
event ue_eventroute ( string as_event )
end type
global w_tc_sheet_ancestor w_tc_sheet_ancestor

type variables
datawindow	idw_current
end variables

event ue_dwgotfocus(datawindow adw_control);//////////////////////////////////////////////////////////////////////////////
//
//	Event:  ue_dwgotfocus
//
//	Arguments:
//	adw_control   Datawindow Control which just got focus
//
//	Returns:  none
//
//	Description:
//	Keeps track of last active DataWindow
//
//////////////////////////////////////////////////////////////////////////////

If adw_control.TypeOf() = DataWindow! Then
	if isvalid(idw_current) then
		idw_current.border = false
	end if
	idw_current = adw_control
	idw_current.border = true
End If
end event

on w_tc_sheet_ancestor.create
call super::create
end on

on w_tc_sheet_ancestor.destroy
call super::destroy
end on

event activate;call super::activate;If w_tramos_main.MenuName <> "m_tcmain" Then 
	w_tramos_main.ChangeMenu(m_tcmain)
End if
end event

event open;call super::open;move(0,0)
end event

