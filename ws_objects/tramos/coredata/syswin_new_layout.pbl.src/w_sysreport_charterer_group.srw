$PBExportHeader$w_sysreport_charterer_group.srw
forward
global type w_sysreport_charterer_group from w_sysreport_master
end type
end forward

global type w_sysreport_charterer_group from w_sysreport_master
integer width = 3410
integer height = 2088
string title = "Charterers in Charterer Groups"
end type
global w_sysreport_charterer_group w_sysreport_charterer_group

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/*****************************************************************************************
   w_charterer_group
   <OBJECT> system report	</OBJECT>
   <USAGE>	List all charterers  </USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
		Date     	CR-Ref   Author      Comments
		10/07/12		CRM		WWG004		Add system report charterers.
		10/10/14		CR3781	CCY018		The window title match with the text of a menu item.
   </HISTORY>
******************************************************************************************/
end subroutine

on w_sysreport_charterer_group.create
call super::create
end on

on w_sysreport_charterer_group.destroy
call super::destroy
end on

event ue_open;call super::ue_open;n_service_manager 	lnv_sm
n_dw_style_service  	lnv_dwstyle

lnv_sm.of_loadservice(lnv_dwstyle, "n_dw_style_service")

dw_table.settransobject(sqlca)

lnv_dwstyle.of_dwlistformater(dw_table)

dw_table.retrieve()

if dw_table.rowcount() > 0 then dw_table.selectrow(1, true)

dw_table.object.datawindow.readonly = "Yes"
end event

type st_hidemenubar from w_sysreport_master`st_hidemenubar within w_sysreport_charterer_group
end type

type dw_table from w_sysreport_master`dw_table within w_sysreport_charterer_group
integer width = 3310
string dataobject = "d_sq_gr_charterers_group_rpt"
end type

type cb_saveasexcel from w_sysreport_master`cb_saveasexcel within w_sysreport_charterer_group
integer x = 2967
end type

type cb_print from w_sysreport_master`cb_print within w_sysreport_charterer_group
integer x = 2615
end type

