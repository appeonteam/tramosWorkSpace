$PBExportHeader$w_bunker_rpt_poc.srw
forward
global type w_bunker_rpt_poc from w_bunker_rpt_base
end type
end forward

global type w_bunker_rpt_poc from w_bunker_rpt_base
string title = "Bunker Report (PoC)"
end type
global w_bunker_rpt_poc w_bunker_rpt_poc

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: w_bunker_rpt_poc
	
	<OBJECT>
		Decendent object of w_bunker_base a member of report group for Bunker Stock.  
	</OBJECT>
  	<DESC>
		Business refer to this as the 'PoC' version of the Bunker Stock report.  
		This item uses bunker data held within the vessel table to assist calculations
	</DESC>
  	<USAGE>
		Pulled from menu item "Reports>Bunker Report>Bunker Report (PoC)"
	</USAGE>
   <ALSO>
		Uses a different stored procedure to the ancestor standard report.  Also retreive click button
		calls upon different business logic inside the n_voyage_bunker_consupmtion report.
	</ALSO>
    	Date   		Ref    	Author   		Comments
  		24/05/12 	cr#2777	AGL      		First Version, bases on copy of w_bunker_report
		20/12/16		CR2879	CCY018		Adjust UI
********************************************************************/
end subroutine

on w_bunker_rpt_poc.create
call super::create
end on

on w_bunker_rpt_poc.destroy
call super::destroy
end on

type st_hidemenubar from w_bunker_rpt_base`st_hidemenubar within w_bunker_rpt_poc
end type

type cbx_excludetcout from w_bunker_rpt_base`cbx_excludetcout within w_bunker_rpt_poc
integer width = 965
end type

type cbx_exclude from w_bunker_rpt_base`cbx_exclude within w_bunker_rpt_poc
end type

type st_status from w_bunker_rpt_base`st_status within w_bunker_rpt_poc
end type

type hpb_1 from w_bunker_rpt_base`hpb_1 within w_bunker_rpt_poc
end type

type cb_saveas from w_bunker_rpt_base`cb_saveas within w_bunker_rpt_poc
end type

type st_1 from w_bunker_rpt_base`st_1 within w_bunker_rpt_poc
end type

type dw_date from w_bunker_rpt_base`dw_date within w_bunker_rpt_poc
end type

type cb_print from w_bunker_rpt_base`cb_print within w_bunker_rpt_poc
end type

type cb_retrieve from w_bunker_rpt_base`cb_retrieve within w_bunker_rpt_poc
end type

type dw_finresp from w_bunker_rpt_base`dw_finresp within w_bunker_rpt_poc
end type

type dw_saveas from w_bunker_rpt_base`dw_saveas within w_bunker_rpt_poc
string dataobject = "d_sp_tb_bunker_vesselstock_rpt_saveas"
end type

type dw_imolist from w_bunker_rpt_base`dw_imolist within w_bunker_rpt_poc
end type

type cbx_selectall_pc from w_bunker_rpt_base`cbx_selectall_pc within w_bunker_rpt_poc
end type

type gb_profitcenter from w_bunker_rpt_base`gb_profitcenter within w_bunker_rpt_poc
end type

type dw_pc from w_bunker_rpt_base`dw_pc within w_bunker_rpt_poc
end type

type gb_criteria from w_bunker_rpt_base`gb_criteria within w_bunker_rpt_poc
end type

type st_3 from w_bunker_rpt_base`st_3 within w_bunker_rpt_poc
end type

type rb_finresp from w_bunker_rpt_base`rb_finresp within w_bunker_rpt_poc
end type

type rb_vessel from w_bunker_rpt_base`rb_vessel within w_bunker_rpt_poc
end type

type sle_vessels from w_bunker_rpt_base`sle_vessels within w_bunker_rpt_poc
end type

type cb_sel_vessel from w_bunker_rpt_base`cb_sel_vessel within w_bunker_rpt_poc
end type

type dw_info from w_bunker_rpt_base`dw_info within w_bunker_rpt_poc
end type

type dw_report from w_bunker_rpt_base`dw_report within w_bunker_rpt_poc
string dataobject = "d_sp_tb_bunker_vesselstock_rpt"
end type

