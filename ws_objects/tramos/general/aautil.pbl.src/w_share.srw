$PBExportHeader$w_share.srw
$PBExportComments$Our magnificient datastore for cached updates
forward
global type w_share from window
end type
type dw_sq_tb_dddw_vesselname_selection from u_datawindow_sqlca within w_share
end type
type dw_sq_tb_dddw_vesselnr_selection from u_datawindow_sqlca within w_share
end type
type dw_sq_tb_cache_atobviacports from u_datawindow_sqlca within w_share
end type
type dw_calc_chart_dddw from u_datawindow_sqlca within w_share
end type
type dw_ports_list from u_datawindow_sqlca within w_share
end type
type dw_port_name_list_share from u_datawindow_sqlca within w_share
end type
type dw_vessel_name_list from u_datawindow_sqlca within w_share
end type
type dw_vessel_nr_list from u_datawindow_sqlca within w_share
end type
type dw_calc_port_dddw from u_datawindow_sqlca within w_share
end type
type s_sharelist from structure within w_share
end type
end forward

type s_sharelist from structure
    string s_datawindowname
    datawindow dw_datawindow
    integer instances
end type

global type w_share from window
integer x = 672
integer y = 264
integer width = 1550
integer height = 2364
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = popup!
long backcolor = 81324524
event ue_retrieve pbm_custom40
dw_sq_tb_dddw_vesselname_selection dw_sq_tb_dddw_vesselname_selection
dw_sq_tb_dddw_vesselnr_selection dw_sq_tb_dddw_vesselnr_selection
dw_sq_tb_cache_atobviacports dw_sq_tb_cache_atobviacports
dw_calc_chart_dddw dw_calc_chart_dddw
dw_ports_list dw_ports_list
dw_port_name_list_share dw_port_name_list_share
dw_vessel_name_list dw_vessel_name_list
dw_vessel_nr_list dw_vessel_nr_list
dw_calc_port_dddw dw_calc_port_dddw
end type
global w_share w_share

type variables
private s_sharelist istr_sharelist[]
end variables

forward prototypes
public function integer wf_share (string as_datawindowname, ref datawindow adw_datawindow, ref datawindowchild adw_datawindowchild, boolean ab_shareon)
end prototypes

event ue_retrieve;string 	ls_sql

/* if administrator(3), external APM(-1) or finance profile(3), update access to all profitccenters */
if uo_global.ii_access_level = 3 &			
or uo_global.ii_access_level = -1 &		
or uo_global.ii_user_profile = 3 then		
	INSERT 
	INTO USERS_PROFITCENTER (USERID, PC_NR)
		SELECT :uo_global.is_userid, PC_NR 
		FROM PROFIT_C 
		WHERE PC_NR NOT IN (SELECT PC_NR 
									FROM  USERS_PROFITCENTER
									WHERE USERID = :uo_global.is_userid);
	commit;								
end if

dw_calc_port_dddw.Retrieve()
dw_vessel_nr_list.Retrieve()
dw_vessel_name_list.retrieve()
dw_port_name_list_share.retrieve()
dw_ports_list.retrieve()
dw_calc_chart_dddw.Retrieve()
dw_sq_tb_cache_atobviacports.retrieve()

dw_sq_tb_dddw_vesselnr_selection.retrieve( uo_global.is_userid )
dw_sq_tb_dddw_vesselnr_selection.setSort("vessel_ref_nr A")
dw_sq_tb_dddw_vesselnr_selection.Sort()
dw_sq_tb_dddw_vesselname_selection.retrieve( uo_global.is_userid )
dw_sq_tb_dddw_vesselname_selection.setSort("vessel_name A")
dw_sq_tb_dddw_vesselname_selection.Sort()

COMMIT;

Integer li_max, li_count

li_max = UpperBound(istr_sharelist)
For li_count = 1 To li_max
	If istr_sharelist[li_count].instances = -1 Then istr_sharelist[li_count].instances = 0
Next
end event

public function integer wf_share (string as_datawindowname, ref datawindow adw_datawindow, ref datawindowchild adw_datawindowchild, boolean ab_shareon);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_share
  
 Object     : 
  
 Function : wf_share 
  
 Event	 : 

 Scope     : 

 ************************************************************************************

 Author    : MIS
   
 Date       : 1996

 Description : Function to share a datawindow to datawindows in w_share.

 Arguments : as_datawindowname: String = Name of Datawindow that you want to share to
 				 adw_datawindow: Datawindw = Datawindow that you want to share to
				 adw_datawindowchild: Datawindowchild = Datawindowchild that you want to share to
				 ab_shareon: Boolean = True if you want to start sharing, false if you
				 			want to end sharing.

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
09/10-08  	16.05			RMO		Change Request #1320
************************************************************************************/

Integer li_max, li_count, li_no, li_result

as_dataWindowname = Upper(as_datawindowname)

// Find datawindow in our list of know datawindows, that can be shared from.
li_max = Upperbound(istr_sharelist)
For li_count = 1 To li_max
	If as_datawindowname = istr_sharelist[li_count].s_datawindowname Then
		li_no = li_count
		
		Exit
	End if
Next	

If li_no = 0 Then
	// System error and return 0 if unable to find sharewindow
	MessageBox("System Error", "Unable to share "+as_datawindowname+", unknown type", StopSign!)
	Return(0)
End if

li_result = 1

If istr_sharelist[li_no].instances = -1 Then
	// Retrieve data in datawindow if instancecount = -1 (not initialized)
	
	istr_sharelist[li_no].dw_datawindow.Retrieve()
	COMMIT;
	istr_sharelist[li_no].instances = 0
End if		

// Datawindow & datawindowchilds needs each own code !
If Not(IsNull(adw_datawindow)) Then

	// Turn sharing on or off, depending on ab_shareon
	If ab_shareon Then
		li_result = istr_sharelist[li_no].dw_datawindow.ShareData(adw_datawindow)
	Else
		li_result = adw_datawindow.ShareDataOff()
	End if

ElseIf Not (IsNull(adw_datawindowchild)) Then

	// Same for childs
	If ab_shareOn Then
		li_Result = istr_sharelist[li_no].dw_datawindow.ShareData(adw_datawindowchild)
	Else
		li_result = adw_datawindowchild.ShareDataOff()
	End if
End if

If li_result=1 Then
	
	// Update instance counter depending on result
	If ab_shareon Then 
		istr_sharelist[li_no].instances ++ 
	Else 
		istr_sharelist[li_no].instances --
	End if
End if

// Check result and display errorbox if any errors
If li_result<>1 Then 
	If not isNull(adw_datawindow) Then
		MessageBox("Error", "Error sharing datawindow "+as_datawindowname+", performing normal retrieve instead", StopSign!)
		adw_datawindow.Retrieve()
	Elseif not isNull(adw_datawindowchild) Then
		MessageBox("Error", "Error sharing datawindow "+as_datawindowname, StopSign!)
	End if	
End if

Return(li_result)
end function

event open;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : w_share
 Object     : 
 Event	 : open
 Scope     : 
 ************************************************************************************
 Author    : MIS
 Date       : 1997
 Description : The W_share is actually a PB4 datastore. It's done by having datawindows
 	in this window, that other windows can share data from. W_share is always open -
	 and always hidden. To keep track of with datawindows that are active, an array
	 with dw-name and usage count is included.

 Arguments : {description/none}
 Returns   : {description/none}  
 Variables : {important variables - usually only used in Open-event scriptcode}
 Other : {other comments}
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
// Set up the sharelist, that contains dw name, dw and instance (usage) count
istr_sharelist[1].s_datawindowname = "DW_CALC_PORT_DDDW"
istr_sharelist[1].dw_datawindow = dw_calc_port_dddw
istr_sharelist[1].instances = -1

istr_sharelist[2].s_datawindowname = "DW_VESSEL_NAME_LIST"
istr_sharelist[2].dw_datawindow = dw_vessel_name_list
istr_sharelist[2].instances = -1

istr_sharelist[3].s_datawindowname = "DW_VESSEL_NR_LIST"
istr_sharelist[3].dw_datawindow = dw_vessel_nr_list
istr_sharelist[3].instances = -1

istr_sharelist[4].s_datawindowname = "DW_PORT_NAME_LIST_SHARE"
istr_sharelist[4].dw_datawindow = dw_port_name_list_share
istr_sharelist[4].instances = -1

istr_sharelist[5].s_datawindowname = "DW_PORTS_LIST"
istr_sharelist[5].dw_datawindow = dw_ports_list
istr_sharelist[5].instances = -1

istr_sharelist[6].s_datawindowname = "DW_CALC_CHART_DDDW"
istr_sharelist[6].dw_datawindow = dw_calc_chart_dddw
istr_sharelist[6].instances = -1

istr_sharelist[7].s_datawindowname = "DW_SQ_TB_CACHE_ATOBVIACPORTS"
istr_sharelist[7].dw_datawindow = dw_sq_tb_cache_atobviacports
istr_sharelist[7].instances = -1

istr_sharelist[8].s_datawindowname = "D_SQ_TB_DDDW_VESSELNR_SELECTION"
istr_sharelist[8].dw_datawindow = dw_sq_tb_dddw_vesselnr_selection
istr_sharelist[8].instances = -1

istr_sharelist[9].s_datawindowname = "D_SQ_TB_DDDW_VESSELNAME_SELECTION"
istr_sharelist[9].dw_datawindow = dw_sq_tb_dddw_vesselname_selection
istr_sharelist[9].instances = -1

This.Hide()

// Retrieve tables if autoretrieve is on
If uo_global.ib_autoretrieve Then PostEvent("ue_retrieve")
end event

on w_share.create
this.dw_sq_tb_dddw_vesselname_selection=create dw_sq_tb_dddw_vesselname_selection
this.dw_sq_tb_dddw_vesselnr_selection=create dw_sq_tb_dddw_vesselnr_selection
this.dw_sq_tb_cache_atobviacports=create dw_sq_tb_cache_atobviacports
this.dw_calc_chart_dddw=create dw_calc_chart_dddw
this.dw_ports_list=create dw_ports_list
this.dw_port_name_list_share=create dw_port_name_list_share
this.dw_vessel_name_list=create dw_vessel_name_list
this.dw_vessel_nr_list=create dw_vessel_nr_list
this.dw_calc_port_dddw=create dw_calc_port_dddw
this.Control[]={this.dw_sq_tb_dddw_vesselname_selection,&
this.dw_sq_tb_dddw_vesselnr_selection,&
this.dw_sq_tb_cache_atobviacports,&
this.dw_calc_chart_dddw,&
this.dw_ports_list,&
this.dw_port_name_list_share,&
this.dw_vessel_name_list,&
this.dw_vessel_nr_list,&
this.dw_calc_port_dddw}
end on

on w_share.destroy
destroy(this.dw_sq_tb_dddw_vesselname_selection)
destroy(this.dw_sq_tb_dddw_vesselnr_selection)
destroy(this.dw_sq_tb_cache_atobviacports)
destroy(this.dw_calc_chart_dddw)
destroy(this.dw_ports_list)
destroy(this.dw_port_name_list_share)
destroy(this.dw_vessel_name_list)
destroy(this.dw_vessel_nr_list)
destroy(this.dw_calc_port_dddw)
end on

type dw_sq_tb_dddw_vesselname_selection from u_datawindow_sqlca within w_share
integer x = 27
integer y = 1868
integer width = 1047
integer height = 204
integer taborder = 70
boolean titlebar = true
string title = "d_sq_tb_dddw_vessel_selection"
string dataobject = "d_sq_tb_dddw_vessel_selection"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

type dw_sq_tb_dddw_vesselnr_selection from u_datawindow_sqlca within w_share
integer x = 27
integer y = 1640
integer width = 1047
integer height = 204
integer taborder = 60
boolean titlebar = true
string title = "d_sq_tb_dddw_vessel_selection"
string dataobject = "d_sq_tb_dddw_vessel_selection"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

type dw_sq_tb_cache_atobviacports from u_datawindow_sqlca within w_share
integer x = 23
integer y = 1416
integer width = 1047
integer height = 204
integer taborder = 50
boolean titlebar = true
string title = "d_sq_tb_cache_atobviacports"
string dataobject = "d_sq_tb_cache_atobviacports"
end type

type dw_calc_chart_dddw from u_datawindow_sqlca within w_share
integer x = 23
integer y = 1188
integer width = 1047
integer height = 212
integer taborder = 40
boolean titlebar = true
string title = "d_calc_chart_dddw"
string dataobject = "d_calc_chart_dddw"
end type

type dw_ports_list from u_datawindow_sqlca within w_share
integer x = 23
integer y = 964
integer width = 1047
integer height = 208
integer taborder = 30
boolean titlebar = true
string title = "dw_ports_list"
string dataobject = "dw_ports_list"
end type

type dw_port_name_list_share from u_datawindow_sqlca within w_share
integer x = 23
integer y = 732
integer width = 1047
integer height = 216
integer taborder = 20
boolean titlebar = true
string title = "dw_port_name_list_share"
string dataobject = "dw_port_name_list_share"
end type

type dw_vessel_name_list from u_datawindow_sqlca within w_share
integer x = 23
integer y = 496
integer width = 1047
integer height = 216
integer taborder = 10
boolean titlebar = true
string title = "d_vessel_name_list"
string dataobject = "dw_vessel_name_list"
end type

type dw_vessel_nr_list from u_datawindow_sqlca within w_share
integer x = 23
integer y = 252
integer width = 1047
integer height = 228
integer taborder = 60
boolean titlebar = true
string title = "d_vessel_nr_list"
string dataobject = "dw_vessel_nr_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

type dw_calc_port_dddw from u_datawindow_sqlca within w_share
integer x = 23
integer y = 16
integer width = 1047
integer height = 220
integer taborder = 50
boolean titlebar = true
string title = "d_calc_port_dddw"
string dataobject = "d_calc_port_dddw"
end type

