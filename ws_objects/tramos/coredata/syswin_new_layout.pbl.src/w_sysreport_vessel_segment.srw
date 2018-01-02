$PBExportHeader$w_sysreport_vessel_segment.srw
forward
global type w_sysreport_vessel_segment from w_sysreport_master
end type
end forward

global type w_sysreport_vessel_segment from w_sysreport_master
integer width = 2971
integer height = 2052
string title = "Vessels by Commercial Segment"
boolean resizable = false
end type
global w_sysreport_vessel_segment w_sysreport_vessel_segment

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/*****************************************************************************************
   w_vessel_segment
   <OBJECT> system report	</OBJECT>
   <USAGE>	Check the vessel are have segment or not  </USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
		Date     	CR-Ref   Author      Comments
		10/07/12		CRM		WWG004		Add system report Vessels by commercial segment.
		10/10/14		CR3781	CCY018		The window title match with the text of a menu item.
   </HISTORY>
******************************************************************************************/
end subroutine

on w_sysreport_vessel_segment.create
call super::create
end on

on w_sysreport_vessel_segment.destroy
call super::destroy
end on

event ue_open;call super::ue_open;n_service_manager 	lnv_sm
n_dw_style_service  	lnv_dwstyle

lnv_sm.of_loadservice(lnv_dwstyle, "n_dw_style_service")

dw_table.settransobject(sqlca)

lnv_dwstyle.of_dwlistformater(dw_table)

dw_table.retrieve(uo_global.is_userid)

if dw_table.rowcount() > 0 then dw_table.selectrow(1, true)

dw_table.object.datawindow.readonly = "Yes"
end event

type st_hidemenubar from w_sysreport_master`st_hidemenubar within w_sysreport_vessel_segment
end type

type dw_table from w_sysreport_master`dw_table within w_sysreport_vessel_segment
integer width = 2889
integer height = 1800
string dataobject = "d_sq_gr_vessel_commseg_rpt"
end type

type cb_saveasexcel from w_sysreport_master`cb_saveasexcel within w_sysreport_vessel_segment
integer x = 2546
integer y = 1848
end type

type cb_print from w_sysreport_master`cb_print within w_sysreport_vessel_segment
integer x = 2194
integer y = 1848
end type

