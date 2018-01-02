$PBExportHeader$w_atobviac_calc_calculation.srw
$PBExportComments$Calculation main window. After implementation of AtoBviaC distance table.
forward
global type w_atobviac_calc_calculation from mt_w_sheet_calc
end type
type cb_arrange from mt_u_commandbutton within w_atobviac_calc_calculation
end type
type cb_closeall from mt_u_commandbutton within w_atobviac_calc_calculation
end type
type cb_compactcalc from commandbutton within w_atobviac_calc_calculation
end type
type cb_wingrow from commandbutton within w_atobviac_calc_calculation
end type
type cb_copywindow from commandbutton within w_atobviac_calc_calculation
end type
type cb_winshrink from commandbutton within w_atobviac_calc_calculation
end type
type cb_schedule from commandbutton within w_atobviac_calc_calculation
end type
type cb_calculate from uo_cb_base within w_atobviac_calc_calculation
end type
type cb_select_vessel from uo_cb_base within w_atobviac_calc_calculation
end type
type cb_summary from uo_cb_base within w_atobviac_calc_calculation
end type
type cb_itinerary from uo_cb_base within w_atobviac_calc_calculation
end type
type cb_cargo from uo_cb_base within w_atobviac_calc_calculation
end type
type cb_result from uo_cb_base within w_atobviac_calc_calculation
end type
type ddlb_cargo from dropdownlistbox within w_atobviac_calc_calculation
end type
type cb_wizard from uo_cb_base within w_atobviac_calc_calculation
end type
type sle_vessel from uo_sle_base within w_atobviac_calc_calculation
end type
type cb_debug from commandbutton within w_atobviac_calc_calculation
end type
type uo_calculation from u_atobviac_calculation within w_atobviac_calc_calculation
end type
type r_1 from rectangle within w_atobviac_calc_calculation
end type
end forward

global type w_atobviac_calc_calculation from mt_w_sheet_calc
string tag = "used"
integer x = 23
integer y = 56
integer width = 4608
integer height = 2568
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
long backcolor = 16777215
string icon = "images\calcmenu.ico"
event ue_sensitivityitem pbm_custom42
event ue_loadports pbm_custom05
event ue_dischports pbm_custom06
event ue_summary pbm_custom07
event ue_claims_item pbm_custom08
event ue_create_loadload_calculation ( )
event ue_rightclick ( string as_object )
event ue_rbuttondown pbm_rbuttondown
event ue_contextmenuclick ( integer ai_menuitem )
event ue_refreshcp ( )
event ue_getvesselpc ( ref long al_pcnr )
cb_arrange cb_arrange
cb_closeall cb_closeall
cb_compactcalc cb_compactcalc
cb_wingrow cb_wingrow
cb_copywindow cb_copywindow
cb_winshrink cb_winshrink
cb_schedule cb_schedule
cb_calculate cb_calculate
cb_select_vessel cb_select_vessel
cb_summary cb_summary
cb_itinerary cb_itinerary
cb_cargo cb_cargo
cb_result cb_result
ddlb_cargo ddlb_cargo
cb_wizard cb_wizard
sle_vessel sle_vessel
cb_debug cb_debug
uo_calculation uo_calculation
r_1 r_1
end type
global w_atobviac_calc_calculation w_atobviac_calc_calculation

type prototypes
// Subroutine SetWindowLong(Int Handle, Int Index, Long Value) library 'user.exe'
FUNCTION integer GetAsyncKeyState(long vkey) LIBRARY "User32.dll"
end prototypes

type variables
Long il_calc_id, il_vessel_id, il_clarkson_id
Boolean ib_loaded, ib_closed=false
integer ii_saved_page
constant integer ii_MAX_INSTANCES= 25
private integer _ii_winindex=0
private m_cpact_contextmenu im_contextmenu
private boolean _ib_forceclose
end variables

forward prototypes
public subroutine wf_manager_retrieve ()
public subroutine wf_updatetitle ()
public subroutine wf_update_cargo_list ()
public subroutine wf_debug_u_calc_nvo ()
private subroutine wf_updatemenu (boolean ab_enabled)
public subroutine wf_select_vessel ()
public function boolean uf_weekly_fix_ok (long al_calc_id)
public function integer wf_cpact_copydw (datawindow adw_source, ref datawindow adw_target)
public function integer wf_cpact_copy ()
public function integer wf_cpact_get_winid ()
public subroutine documentation ()
public function integer wf_cpact_arrangeall ()
public function integer wf_cpact_set_winid ()
private function integer wf_cpact_construct_copy (u_atobviac_calculation auo_calculation)
public function integer wf_cpact_close (boolean ab_all)
public function integer wf_cpact_change_winsize (integer ai_adjust)
private function integer wf_setportvalidator ()
public subroutine wf_recalculate ()
public subroutine wf_setconstype (mt_u_datawindow adw_source, string as_colname, string as_constype[], string as_conszone[])
public function integer wf_validation_profit_center (ref integer ii_not_open)
public function integer wf_getconstypezone (mt_u_datawindow adw_source, long al_row, string as_colname, ref string as_type, ref string as_zone)
public function integer wf_checkmaxinstances ()
end prototypes

event ue_sensitivityitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when the user selects sensitivity from the menu or toolbar

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Allow only sensitivity on normal (not ballast) voyages and if the calculation
// can be deactived (it will validate and save eventual data in the edit-buffers 
// to the actual fields
If Not(uo_calculation.uf_get_ballast_voyage()) Then
	If uo_calculation.uf_deactivate()=1 Then
		OpenWithParm(w_atobviac_calc_sensitivity, uo_calculation)
	End if
Else
	MessageBox("Information","It is not possible to do a Sensitivity Analysis on a Ballast Voyage.")
End if

end event

event ue_loadports;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Jumps to the loadports if the (hidden) loadport item in the 
 					mainmenu is selected by typing CTRL-L. On the summary page
					it selectes the cargo list instead. 

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

CHOOSE CASE uo_calculation.uf_get_current_page() 
	CASE 1
		uo_calculation.uo_calc_summary.dw_calc_summary_list.SetFocus()
	CASE 3
		uo_calculation.uo_calc_cargos.dw_loadports.SetFocus()
END CHOOSE
end event

event ue_dischports;call super::ue_dischports;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Jumps to the dischports if the (hidden) dischport item in the 
 					mainmenu is selected by typing CTRL-D

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If uo_calculation.uf_get_current_page() = 3 Then &
	uo_calculation.uo_calc_cargos.dw_dischports.SetFocus()
end event

event ue_summary;call super::ue_summary;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when the user selects summary from the (hidden) menuitem,
 					using CTRL-S
 
 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
***********************************************************************************/

CHOOSE CASE uo_calculation.uf_get_current_page() 
	CASE 1 // Summary	
		uo_calculation.uo_calc_summary.dw_calc_summary.SetFocus()
	CASE 3 // Cargos	
		uo_calculation.uo_calc_cargos.dw_cargo_summary.SetFocus()
END CHOOSE
end event

event ue_claims_item;call super::ue_claims_item;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Opens the Claims window when the user select claims from the menu
 					or the toolbar. The cargo needs to be saved before the user
					can open the claims window. 

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_tmp
Long ll_cargo_id
ll_cargo_id = uo_calculation.uf_get_cargo_id()

// Open the claims for the given cargo or display a Notice box, if the
// cargo hasn't been saved.
If ll_cargo_id > 0 Then
	OpenWithParm(w_calc_claims,uo_calculation.uo_calc_cargos)
Else
	MessageBox("Notice", "The claims-window can only be opend for saved fixtured, estimated and calculated calculations", StopSign!)
End if

// Check to see if anything was changed (Message.Doubleparm = 1), and update
// the calculation if so.
li_tmp = Message.DoubleParm

If li_tmp = 1 Then
	uo_calculation.TriggerEvent("ue_childModified")
	uo_calculation.ib_modified = True
End if
end event

event ue_create_loadload_calculation();/* This event should call functions to create a loadload calculation based on the estimated calculation */
u_atobviac_loadload_calculation  lnv_loadcalc

choose case uo_calculation.uo_calc_summary.uf_get_status( )
	case 5, 6			/* Estimated or Calculated */
		lnv_loadcalc = create u_atobviac_loadload_calculation 
		lnv_loadcalc.of_create_new_loadload(il_calc_id, uo_calculation.uo_calc_summary.uf_get_status( )  )
		destroy lnv_loadcalc
	case else
		MessageBox("Information", "You can't create LoadLoad calculation unless the active calculation is Estimated or Actual")
end choose

end event

event ue_rightclick(string as_object);/********************************************************************
   ue_rightclick
   <DESC>	Controls the context level menu	</DESC>
   <RETURN>	(none)   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_object
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		??/??/?? CR????        ???      First Version
		27/01/15 CR3433        LHG008   Fix the bug for failed to add new load port feature from the compact window
		10/02/15	CR3921        LHG008   Fix the bug when colunm locked but the backcolor is not changed
   </HISTORY>
********************************************************************/

integer li_status
GraphicObject lo_tmp

lo_tmp = GetFocus()

this.bringtotop = True
// control load/discharge port.
If Not isNull(lo_tmp) Then
	If lo_tmp.TypeOf() = DataWindow! Then
		If lo_tmp.ClassName() = "dw_loadports"  Then
			im_contextmenu.m_addnewport.text="Add new Load Port"
			im_contextmenu.m_deletecurrentport.text="Delete selected Load Port"
		Elseif lo_tmp.Classname() = "dw_dischports" Then
			im_contextmenu.m_addnewport.text="Add new Discharge Port"
			im_contextmenu.m_deletecurrentport.text="Delete selected Discharge Port"
		End if
		
		li_status = uo_calculation.uf_get_status(0)
		
		If (lo_tmp.ClassName() = "dw_loadports" or lo_tmp.Classname() = "dw_dischports") &
			and (li_status <> c#calculationstatus.il_FIXTURE) and (li_status <> c#calculationstatus.il_ESTIMATED) &
			and (not uo_calculation.uf_get_ballast_voyage()) Then
			
			im_contextmenu.m_addnewport.enabled=true
			im_contextmenu.m_deletecurrentport.enabled=true
		Else
			im_contextmenu.m_addnewport.enabled=false
			im_contextmenu.m_deletecurrentport.enabled=false
		End If
		
		im_contextmenu.m_calculate.enabled = (li_status <> c#calculationstatus.il_FIXTURE)
	End if
End if

this.im_contextmenu.popmenu( this.X + this.pointerX(), this.Y + this.pointerY() )


end event

event ue_rbuttondown;// event ue_rightclick("window")
end event

event ue_contextmenuclick(integer ai_menuitem);/********************************************************************
   event ue_contextmenuclick( /*integer ai_menuitem */)
   <DESC>   Picks the user selection made from the context right click menu</DESC>
   <RETURN></RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   ai_menuitem: Description
            </ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/

constant integer li_DO_MINIMSE=1, li_DO_MAXIMISE=2, li_DO_CALC=3, li_DO_COPY=4, li_DO_ADDNEWPORT=5
constant integer li_DO_TILE=7, li_DO_CLOSESOME=8, li_DO_DELETECURRENTPORT=9
long ll_retval
u_datawindow_sqlca  ldw
string ls_dwname

	choose case ai_menuitem
		case li_DO_MINIMSE
			wf_cpact_change_winsize(-1)
		case li_DO_MAXIMISE
			wf_cpact_change_winsize(1)
		case li_DO_CALC
			uo_calculation.uf_calculate() 
		case li_DO_COPY
			wf_cpact_copy()
		case li_DO_ADDNEWPORT, li_DO_DELETECURRENTPORT
			ll_retval = uo_calculation.uo_calc_compact.of_getdatawindowfocus( ldw, ls_dwname)
			if ll_retval = c#return.Success then
				CHOOSE CASE ls_dwname
					CASE "dw_dischports", "dw_loadports"
						/* keep the delete business logic inside the cargo object */
						if ai_menuitem = li_DO_ADDNEWPORT then
							uo_calculation.uo_calc_cargos.of_insertport(ldw)
						else	
							uo_calculation.uo_calc_cargos.of_deleteport(ldw)
						end if	
					CASE ELSE
						/* do nothing */
				END CHOOSE	
			end if	
			
		case li_DO_TILE
			wf_cpact_arrangeall( )
		case li_DO_CLOSESOME
			wf_cpact_close(true)
	end choose
end event

event ue_refreshcp();/********************************************************************
   ue_refreshcp
   <DESC>	Refresh the CP date and the charterer name	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	After the selected CP is updated	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	20/11/2013   CR2867       ZSW001       First Version
   </HISTORY>
********************************************************************/

long		ll_loop, ll_count, ll_cerp_id
datetime	ldt_cerp_date
string	ls_chart_sn

mt_u_datawindow	ldw_cplist

ldw_cplist = uo_calculation.uo_calc_summary.dw_calc_summary_list

ll_count = ldw_cplist.rowcount()
for ll_loop = 1 to ll_count
	ll_cerp_id = ldw_cplist.getitemnumber(ll_loop, "cal_carg_cal_cerp_id")
	
	if isnull(ll_cerp_id) then
		setnull(ldt_cerp_date)
		setnull(ls_chart_sn)
	else
		SELECT CAL_CERP.CAL_CERP_DATE,
				 CHART.CHART_SN
		  INTO :ldt_cerp_date, 
		       :ls_chart_sn
		  FROM CAL_CERP, CHART
		 WHERE CAL_CERP.CHART_NR = CHART.CHART_NR AND
				 CAL_CERP.CAL_CERP_ID = :ll_cerp_id;
	end if
	ldw_cplist.setitem(ll_loop, "cal_cerp_cal_cerp_date", ldt_cerp_date)
	ldw_cplist.setitem(ll_loop, "compute_0046", ls_chart_sn)
next

end event

event ue_getvesselpc(ref long al_pcnr);/********************************************************************
   ue_getvesselpc
   <DESC>		</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		11/04/16		CR3767		XSZ004		First Version
   </HISTORY>
********************************************************************/

long ll_vesselnr

if this.uo_calculation.uo_calc_summary.dw_calc_summary.rowcount() > 0 then
	ll_vesselnr = this.uo_calculation.uo_calc_summary.dw_calc_summary.GetItemNumber(1,"cal_calc_vessel_id")
	SELECT PC_NR INTO :al_pcnr FROM VESSELS WHERE VESSEL_NR = :ll_vesselnr;
else
	al_pcnr = 0
end if

end event

public subroutine wf_manager_retrieve ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Tell the manager that's somethings changed, and it should re-retrieve 
 					data upon next activation

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If IsValid(w_calc_manager) Then w_calc_manager.TriggerEvent("ue_datachanged")

end subroutine

public subroutine wf_updatetitle ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 12-10-96

 Description : Updates the window title and sidepanel of compact window with 
 calculation name, status and calculated status

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE			VERSION	NAME  		DESCRIPTION
--------		-------	------		-------------------------------------
26/01/12		D-CALC	AGL   		Update window objects CalcId if previously unsaved calc.
26/02/15		CR3921	LHG008		It should not be possible to save any changes in a Fixture calculation  
************************************************************************************/

String ls_tmp, ls_sidepanel_tmp, ls_status

s_port_parm  lstr_port_parm
integer li_no_of_ports, li_count, li_pos
string ls_port_name_purpose, ls_port_name, ls_purpose
boolean lb_multi_load=false

if uo_calculation.ib_show_messages = false then return

// Get the verbal status from the calculation
CHOOSE CASE uo_calculation.uf_get_status(0) 
	CASE 0
		// Cannot happen, this status identifies a deleted calculation
	CASE 1
		ls_tmp = "Template"
	CASE 2
		ls_tmp = "Working"
	CASE 3
		ls_tmp = "Offer"
	CASE 4
		ls_tmp = "Fixture"
		uo_calculation.ib_modified = false
		uo_calculation.ib_calculated = true
	CASE 5
		ls_tmp = "Calculated"
	CASE 6	
		ls_tmp = "Estimated"
	CASE 7	
		ls_tmp = "LoadLoad"
END CHOOSE

ls_sidepanel_tmp = ls_tmp + " " + upper(uo_calculation.uf_get_vessel_name()) + " "

// Create the first part of the window title
ls_tmp += " Calcule ["+uo_calculation.uf_get_calculation_title()+"]"

// Add information about modified and calculated status
If uo_calculation.ib_modified Then ls_status = " (modified)"
If uo_calculation.ib_calculated Then ls_status += " (calculated)" Else ls_status += " (not calculated)"
ls_tmp += ls_status

/* any change to the calc id (most likely a new calc saved for first time) 
be aware of issue in retrieval of calc_id in summary object !
*/
if il_calc_id=0 and uo_calculation.uf_get_status(0)<4 then
	il_calc_id = uo_calculation.uf_get_calc_id( )
end if
ls_tmp += " (ID="+string(il_calc_id)+")"


// and set the title
This.Title = ls_tmp

if (uo_calculation.uf_cpact_get_win_mode()>1 and cb_wizard.visible=false) then cb_winshrink.enabled = true
if uo_calculation.uf_get_current_page() = 5 then // compact window
	// update the sidepanel text
	li_no_of_ports = uo_calculation.uf_get_no_loadports(uo_calculation.uf_get_cargo( ))
	// Get the name and purpose of a load port and append it to the name
	For li_count = 1 to li_no_of_ports
		lstr_port_parm.i_port_no = li_count
		ls_port_name_purpose = uo_calculation.uf_get_lport_name_purpose(lstr_port_parm)
		li_pos = Pos(ls_port_name_purpose,"&&")
		ls_port_name = Left(ls_port_name_purpose, li_pos - 1)
		ls_purpose  = Mid(ls_port_name_purpose, li_pos + 2, 5)
		If ls_purpose = "L" then 
			if lb_multi_load then ls_sidepanel_tmp +=","
			ls_sidepanel_tmp += ls_port_name
			lb_multi_load=true
		End if
	Next
	ls_sidepanel_tmp += " - "
	// Get the name and purpose of a disch port and append it to the name
	li_no_of_ports = uo_calculation.uf_get_no_dischports(uo_calculation.uf_get_cargo( ))
	For li_count = 1  to li_no_of_ports
		lstr_port_parm.i_port_no = li_count
		ls_port_name_purpose = uo_calculation.uf_get_dport_name_purpose(lstr_port_parm)
		li_pos = Pos(ls_port_name_purpose,"&&")
		ls_port_name = Left(ls_port_name_purpose, li_pos - 1)
		if li_count>1 then ls_sidepanel_tmp += ","
		ls_sidepanel_tmp += ls_port_name
	Next
	
	If uo_calculation.ib_modified then ls_sidepanel_tmp+=" (mod)"
	If uo_calculation.ib_calculated Then ls_sidepanel_tmp += " (calc)" Else ls_sidepanel_tmp += " (uncalc)"
	ls_sidepanel_tmp += " #" + string(wf_cpact_get_winid())
	
	uo_calculation.uo_calc_compact.dw_sidepanel.setitem(1,"calc_side_panel", ls_sidepanel_tmp )
end if

end subroutine

public subroutine wf_update_cargo_list ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 10-11-96

 Description : Updates the cargo-drop-down listbox with data from uo_calculation

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_max, ll_count

// Reset the contents in the cargo drop-down listbox
ddlb_cargo.Reset()

// Get the number of cargos, and stuff the desciptions for each cargo into
// the drop-down list
ll_max = uo_calculation.uf_get_no_cargos()

For ll_count = 1 To ll_max 
	ddlb_cargo.AddItem(uo_calculation.uf_get_cargo_description(ll_count))
Next

// Select the current cargo in the drop-down listbox
ddlb_cargo.text = uo_calculation.uf_get_cargo_description(uo_calculation.uf_get_cargo())


end subroutine

public subroutine wf_debug_u_calc_nvo ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : This code was only used for debugging purpose and is obsolete

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE    		VERSION	NAME  	DESCRIPTION
--------		-------	------	------------------------------------
03/08/16		CR4219	LHG008	Accuracy and improvement in DEM and DEV claims handling(CHO)(REF_CR4111)
************************************************************************************/

u_calc_nvo uo_calc_nvo
Long ll_calc_id, ll_cerp_id
s_dem_des_data lstr_dem_des_data[]
Integer li_tmp, li_count, li_vessel_nr, li_chart_nr
String ls_tmp, ls_voyage_nr

uo_calc_nvo = CREATE u_calc_nvo

// Testing of Leith's interface

ll_calc_id = uo_calculation.uf_get_calc_id()
ll_cerp_id = uo_calculation.uf_get_cerp_id(1)

SELECT VESSEL_NR,
	VOYAGE_NR
INTO :li_vessel_nr,
	:ls_voyage_nr
FROM VOYAGES
WHERE CAL_CALC_ID = :ll_calc_id;

SELECT CHART_NR
INTO :li_chart_nr
FROM CAL_CERP
WHERE CAL_CERP_ID = :ll_cerp_id;

li_tmp = uo_calc_nvo.uf_dem_des_data(li_vessel_nr, ls_voyage_nr, li_chart_nr , ll_cerp_id, lstr_dem_des_data)

If MessageBox("Info", "dem_des returns "+String(li_tmp)+"~r~n~r~nDo you want to se ?", Exclamation!, YesNO!, 2) = 1 Then

	For li_count = 1 To li_tmp 
		ls_tmp = "Count: "+String(li_tmp)+"~r~n"
		ls_tmp += "port: "+lstr_dem_des_data[li_count].ports+"~r~n"
		ls_tmp += "Purpose: "+lstr_dem_des_data[li_count].Purpose+"~r~n"
		ls_tmp += "hour rate: "+String(lstr_dem_des_data[li_count].hour_rate)+"~r~n"
		ls_tmp += "daily rate: "+String(lstr_dem_des_data[li_count].daily_rate)+"~r~n"
		ls_tmp += "laytime_allowed: "+String(lstr_dem_des_data[li_count].laytime_allowed)+ " other purpos:"+ String(lstr_dem_des_data[li_count].d_other_allowed) + "~r~n"
		ls_tmp += "dem rate: "+String(lstr_dem_des_data[li_count].dem_rate)+" desrate: "+String(lstr_dem_des_data[li_count].des_rate)+"~r~n"
		ls_tmp += "hours: "+String(lstr_dem_des_data[li_count].hours)+"~r~n"
		ls_tmp +="disch hour: "+String(lstr_dem_des_data[li_count].disch_hour_rate)+" dialy: "+String(lstr_dem_des_data[li_count].disch_daily_rate)+"~r~n"
		ls_tmp += "terms: "+String(lstr_dem_des_data[li_count].terms)+" disch_allowed: "+String(lstr_dem_des_data[li_count].disch_allowed)
		ls_tmp += "~r~n caio_id: "+String(lstr_dem_des_data[li_count].calcaioid)

		If isNull(ls_tmp) Then ls_tmp = "String is NULL"
			
		MessageBox("Data: ", ls_tmp)
	Next
End if

DESTROY uo_calc_nvo
end subroutine

private subroutine wf_updatemenu (boolean ab_enabled);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1-9-96

 Description : Updates enabled status on the calculation menu item. If a calculation
 					is loaded, AB_ENABLED should be set to true (this will enable save, 
					CP etc. etc). Otherwise it should be set to false

 Arguments : AB_ENALBED as boolean
 
 Returns   : None

*************************************************************************************
Development Log 
DATE			VERSION	NAME  		DESCRIPTION
--------		-------	------		-------------------------------------
26/02/15		CR3921	LHG008		It should not be possible to save any changes in a Fixture calculation  
************************************************************************************/

Integer li_status
Boolean lb_tmp

// Allow only updates, if the current menu is the calculation menu
If Upper(w_tramos_main.menuname) = "M_CALCMAIN" Then

	// Get the status from the calculation. This is used for additional
	// checking for the menuitems.
	
	li_status = uo_calculation.uf_get_status(0)
	
	uo_calculation.ib_modified = (uo_calculation.ib_modified) and (li_status <> c#calculationstatus.il_FIXTURE)
	uo_calculation.ib_calculated = (uo_calculation.ib_calculated) or (li_status = c#calculationstatus.il_FIXTURE)
	
	m_calcmain.m_menutop2.m_close.enabled = ab_enabled
	m_calcmain.m_menutop2.m_new.enabled = (ab_enabled) and (li_status <> c#calculationstatus.il_FIXTURE) and (li_status<> c#calculationstatus.il_ESTIMATED) and (not uo_calculation.uf_get_ballast_voyage())
	
	m_calcmain.m_menutop2.m_save.enabled = (ab_enabled) and (li_status <> c#calculationstatus.il_FIXTURE) and uo_calculation.ib_modified
	m_calcmain.m_menutop2.m_saveas.enabled = ab_enabled
	m_calcmain.m_menutop2.m_status.enabled = (ab_enabled) and (li_status < c#calculationstatus.il_FIXTURE)
	//m_calcmain.m_menutop2.m_delete.enabled = true and (li_status<>c#calculationstatus.il_FIXTURE) and (li_status<>c#calculationstatus.il_ESTIMATED)
	m_calcmain.m_menutop3.m_cp.enabled = ab_enabled and  (il_vessel_id>0 or il_clarkson_id>0)
	m_calcmain.m_menutop3.m_fixture.enabled = ab_enabled and (li_status <> c#calculationstatus.il_FIXTURE) and (li_status<>c#calculationstatus.il_ESTIMATED)
	m_calcmain.m_menutop3.m_print.enabled = ab_enabled
	m_calcmain.m_menutop3.m_sensitivity.enabled = ab_enabled
	m_calcmain.m_menutop3.m_combinecalculations.enabled = ab_enabled
	m_calcmain.m_menutop3.m_sendcalctoweeklyfixture.enabled = ab_enabled

	m_calcmain.m_menutop2.m_ballastvoyage.enabled = ab_enabled and (uo_calculation.uf_get_calc_id()=0) and (not cb_wizard.visible)
	m_calcmain.m_menutop2.m_ballastvoyage.checked = uo_calculation.uf_get_ballast_voyage()

	lb_tmp = ab_enabled and (uo_calculation.uf_get_wizard())
	m_calcmain.m_menutop2.m_wizard.enabled = lb_tmp
	m_calcmain.m_menutop2.m_wizard.checked = lb_tmp

	m_calcmain.m_menutop3.m_claims.enabled = li_status > c#calculationstatus.il_FIXTURE
	
	m_calcmain.m_menutop2.m_unlockcalculation.enabled = (li_status = c#calculationstatus.il_CALCULATED) // And (uo_global.ii_access_level = 3)
End if



end subroutine

public subroutine wf_select_vessel ();/********************************************************************
	wf_select_vessel
	<DESC>
		Sets a new vessel Id, either as vessel_type, vessel or clarkson. 
 		If no ID given, a search window 	will prompt the user for vessel.
	</DESC>
	<RETURN>	</RETURN>
	<ACCESS> public </ACCESS>
	<ARGS>
		AL_VESSEL_TYPE_ID as Long
		AL_VESSEL_ID      as Long
		AL_CLARKSON_ID    as long
	</ARGS>
	<USAGE>	</USAGE>
	<HISTORY>
		Date    		CR-Ref		Author		Comments
		24/07/96		?     		TA    		First version
		?       		?     		MI    		Smaller fixes
		04/12/13		CR2658		LHG008		call uf_activate() to init consumption dropdown list
		08/21/14		CR3528		XSZ004		Init consumption dropdown list for idle,bunker and various
		27/01/15		CR3433		LHG008		Fix the bug for failed to add new load port feature from the compact window
		29/01/15		CR3935		LHG008		Pre-select a default consumption type for Idle, Bunkering, Various
		20/12/16		CR4050		LHG008		Change additionals Laden and Ballasted logic
	</HISTORY>
********************************************************************/

string  	ls_loadconstype[], ls_dischconstype[], ls_ballastcontype[], ls_ladencontype[]
string  	ls_loadconszone[], ls_dischconszone[], ls_ballastconzone[], ls_ladenconzone[]	//used for future improvement
string  	ls_bunkerconstype[], ls_idleconstype[], ls_variousconstype[]
string  	ls_bunkerconszone[], ls_idleconszone[], ls_variousconszone[]
long    	ll_loop, ll_loadcount, ll_dischcount, ls_cargocount, ll_vessel_type, ll_null
long    	ll_load_filters, ll_disch_filters, ll_current_load_filters, ll_current_disch_filters
Integer 	li_current_cargo, I, li_pre_vesselnr
long    	ll_cal_cerp_id, ll_cp_pc, ll_prepcnr, ll_currpcnr
datetime	ldt_null; setnull(ldt_null)
string  	ls_null; setnull(ls_null); 

setnull(ll_null)

constant string ls_SAILING_LADEN = "Sailing - Laden"
constant string ls_SAILING_BALLAST = "Sailing - Ballast"

mt_u_datawindow ldw_loadports, ldw_dischports, ldw_cargosummary

this.event ue_getvesselpc(ll_prepcnr)

li_pre_vesselnr = il_vessel_id
OpenWithParm(w_calc_vessel_list, il_vessel_id)

il_vessel_id = Message.doubleparm

If il_vessel_id > 0 Then
	
	uf_redraw_off()
	
	ldw_loadports    = uo_calculation.uo_calc_cargos.dw_loadports
	ldw_dischports   = uo_calculation.uo_calc_cargos.dw_dischports
	ldw_cargosummary = uo_calculation.uo_calc_cargos.dw_cargo_summary
	ll_load_filters  = ldw_loadports.filteredcount()
	ll_disch_filters = ldw_dischports.filteredcount()
	
	if ll_load_filters > 0 then ldw_loadports.rowsmove(1, ll_load_filters, filter!, ldw_loadports, 1, primary!)
	if ll_disch_filters > 0 then ldw_dischports.rowsmove(1, ll_disch_filters, filter!, ldw_dischports, 1, primary!)
	
	ll_loadcount = ldw_loadports.rowcount()
	for ll_loop = 1 to ll_loadcount
		ls_loadconstype[upperbound(ls_loadconstype) + 1] = ldw_loadports.describe("evaluate('lookupdisplay(port_cons_id)', " + string(ll_loop) + ")")
	next
	
	ll_dischcount = ldw_dischports.rowcount()
	for ll_loop = 1 to ll_dischcount
		ls_dischconstype[upperbound(ls_dischconstype) + 1] = ldw_dischports.describe("evaluate('lookupdisplay(port_cons_id)', " + string(ll_loop) + ")")
	next
	
	ls_cargocount = ldw_cargosummary.rowcount()
	for ll_loop = 1 to ls_cargocount
		ls_ballastcontype[upperbound(ls_ballastcontype) + 1]   = ls_SAILING_BALLAST
		ls_ladencontype[upperbound(ls_ladencontype) + 1]       = ls_SAILING_LADEN
		wf_getconstypezone(ldw_cargosummary, ll_loop, "cal_carg_bunker_cons_id", ls_bunkerconstype[ll_loop], ls_bunkerconszone[ll_loop])
		wf_getconstypezone(ldw_cargosummary, ll_loop, "cal_carg_idle_cons_id", ls_idleconstype[ll_loop], ls_idleconszone[ll_loop])
		wf_getconstypezone(ldw_cargosummary, ll_loop, "cal_carg_various_cons_id", ls_variousconstype[ll_loop], ls_variousconszone[ll_loop])
	next
	
	uo_calculation.uf_set_vessel(ll_null, il_vessel_id, ll_null)
	
	sle_vessel.text = uo_calculation.uf_get_vessel_name()
	
	if uo_calculation.uf_cpact_get_win_mode( )<3 then wf_updatetitle( )
	
	uo_calculation.uo_calc_cargos.of_getconsdropdown()
	
	wf_setconstype(ldw_loadports, "port_cons_id", ls_loadconstype, ls_loadconszone)
	wf_setconstype(ldw_dischports, "port_cons_id", ls_dischconstype, ls_dischconszone)
//	wf_setconstype(ldw_cargosummary, "cal_carg_laden_cons_id", ls_ladencontype, ls_ballastconzone)
//	wf_setconstype(ldw_cargosummary, "cal_carg_ballast_cons_id", ls_ballastcontype, ls_ladenconzone)
	wf_setconstype(ldw_cargosummary, "cal_carg_bunker_cons_id", ls_bunkerconstype, ls_bunkerconszone)
	wf_setconstype(ldw_cargosummary, "cal_carg_idle_cons_id", ls_idleconstype, ls_idleconszone)
	wf_setconstype(ldw_cargosummary, "cal_carg_various_cons_id", ls_variousconstype, ls_variousconszone)
	
	if ls_cargocount > 1 then
		ll_current_load_filters  = ldw_loadports.filteredcount()
		ll_current_disch_filters = ldw_dischports.filteredcount()
		
		if ll_current_load_filters < 1 then 
			ldw_loadports.rowsmove(1, ll_load_filters, primary!, ldw_loadports, 1, filter!)
		end if
		
		if ll_current_disch_filters < 1 then 
			ldw_dischports.rowsmove(1, ll_disch_filters, primary!, ldw_dischports, 1, filter!)
		end if
	end if
	
	if uo_calculation.uf_get_current_page() = 2 then //itinerary
		uo_calculation.uo_calc_itinerary.uf_activate()
	elseif uo_calculation.uf_get_current_page() = 3 then //cargo
		uo_calculation.uo_calc_cargos.uf_activate()
	end if
	
	uf_redraw_on()
else
   uo_calculation.uf_get_vessel(ll_vessel_type,il_vessel_id,il_clarkson_id)
End if
if il_vessel_id < 1 or isnull(il_vessel_id) then
	uo_calculation.uo_calc_summary.cb_stock_value.enabled = false
	uo_calculation.uo_calc_summary.cb_refresh_bunker.enabled = false
else
	uo_calculation.uo_calc_summary.cb_stock_value.enabled = true
	uo_calculation.uo_calc_summary.cb_refresh_bunker.enabled = true
end if

uo_calculation.of_set_profit_center(il_vessel_id, il_clarkson_id)

this.event ue_getvesselpc(ll_currpcnr)

if ll_prepcnr <> ll_currpcnr then
	uo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.cb_reset.event clicked( )
end if

if isnull(li_pre_vesselnr) or li_pre_vesselnr = 0 then
	uo_calculation.uo_calc_cargos.of_insertaddbuncons()
end if
end subroutine

public function boolean uf_weekly_fix_ok (long al_calc_id);// SEE IF THE CALCULE NEEDS TO BE REPORTED TO THE WEEKELY FIXTURE LIST BEFORE IT CAN BE FIXED

integer li_row_count, li_report_before, li_return_value, li_vessel_nr
boolean lb_ok
n_ds lds_profit, lds_pool, lds_report
integer 	li_status
long		ll_calc_id, ll_fixid

ll_calc_id = al_calc_id

SELECT CAL_CALC.CAL_CALC_VESSEL_ID, CAL_CALC_STATUS, CAL_CALC_FIX_ID  
INTO :li_vessel_nr, :li_status, :ll_fixid  
FROM CAL_CALC  
WHERE CAL_CALC.CAL_CALC_ID = :al_calc_id;
Commit;

/* If the calculation is calculated or estimated, get the fixtured calculation ID */
if li_status = 5 OR li_status = 6 then
	SELECT CAL_CALC_ID
	INTO :ll_calc_id
	FROM CAL_CALC
	WHERE CAL_CALC_FIX_ID = :ll_fixid
	AND CAL_CALC_STATUS = 4 ;
END IF	
commit;

lds_profit = CREATE n_ds
lds_profit.dataObject = "d_calc_weekly_fix_profit"
lds_profit.setTransObject(SQLCA)
li_row_count = lds_profit.Retrieve(li_vessel_nr)

lds_pool = CREATE n_ds
lds_pool.dataObject = "d_calc_weekly_fix_pool"
lds_pool.setTransObject(SQLCA)

lds_report = CREATE n_ds
lds_report.dataObject = "d_calc_weekly_fix_report"
lds_report.setTransObject(SQLCA)

IF li_row_count > 0 THEN
	li_report_before = lds_profit.GetItemnumber(1, "profit_c_report_before_fixture")
	IF li_report_before = 0 THEN
		lb_ok = True
	ELSE
		li_row_count = lds_pool.Retrieve(li_vessel_nr)	
		IF li_row_count = 0 THEN
			lb_ok =  True
		ELSE
			li_row_count = lds_report.Retrieve(ll_calc_id)			
			IF li_row_count > 0 THEN
				lb_ok = True
			ELSE
				lb_ok = False
			END IF
		END IF
	END IF
ELSE
	lb_ok = True
END IF

DESTROY lds_profit
DESTROY lds_pool
DESTROY lds_report

RETURN lb_ok
end function

public function integer wf_cpact_copydw (datawindow adw_source, ref datawindow adw_target);/********************************************************************
   wf_cpact_copydw( , )
   <DESC>   Copies the complete datawindow contents from one dw into
	another.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   adw source/*datawindow adw_source*/ : Description
            adw_target /*ref datawindow adw_target */ : Description</ARGS>
   <USAGE>  Carefully! It uses blob variable to store all that is needed.</USAGE>
	DATE			VERSION		NAME		DESCRIPTION
--------		-------		-----		-------------------------------------
21-11-13		CR2658UAT 	LGX001 	Fixed the bug:the compact calculation copy fails when calculation has more than 1 cargo, 
																only 1 cargo is fully copied to the new calculation.

********************************************************************/

adw_target.reset()
adw_source.rowscopy(1, adw_source.rowcount(), primary!, adw_target, 1, primary!)
adw_source.rowscopy(1, adw_source.filteredcount(), filter!, adw_target, 1, filter!)

adw_target.settransobject(sqlca)

return adw_target.rowcount()

end function

public function integer wf_cpact_copy ();/********************************************************************
   wf_cpact_copy( )
   <DESC>   Attempts to copy the data in the window instance into a 
				new window</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   </ARGS>
   <USAGE>  From a button normally.</USAGE>
********************************************************************
Development Log 
DATE			VERSION		NAME		DESCRIPTION
--------		-------		-----		-------------------------------------
26-03-13		CR2658		WWG004	TCE/Day field changed to editable. 
06-11-13		CR2658UAT	WWG004	Init the copied calculation's ballast consumption type and speed.
21-11-13		CR2658UAT 	LGX001 	Fixed the bug:the compact calculation copy fails when calculation has more than 1 cargo, 
																only 1 cargo is fully copied to the new calculation.
27/01/15		CR3433		LHG008 	Fix the bug for failed to add new load port feature from the compact window
29/01/15		CR3935		LHG008 	Pre-select a default consumption type for Idle, Bunkering, Various
24/11/16		CR3145		LHG008 	Enable Tramos to have up to 25 calculations open at the same time
************************************************************************************/

integer	li_return
long		ll_contypeid
double	ld_speed
	
w_atobviac_calc_calculation w_newcopy

li_return = opensheetwithparm(w_newcopy, uo_calculation, w_tramos_main, 0, Original!)
if isvalid(w_newcopy) then
	ll_contypeid = uo_calculation.uo_calc_summary.dw_calc_ballast.getitemnumber(1, "cal_cons_id")
	ld_speed		 = uo_calculation.uo_calc_summary.dw_calc_ballast.getitemnumber(1, "cal_ball_leg_speed")
	
	w_newcopy.uo_calculation.uo_calc_summary.dw_calc_ballast.setitem(1, "cal_cons_id", ll_contypeid)
	w_newcopy.uo_calculation.uo_calc_summary.dw_calc_ballast.setitem(1, "cal_ball_leg_speed", ld_speed)
	
	w_newcopy.uf_redraw_off()
	w_newcopy.uo_calculation.uf_load_speedlist()
	w_newcopy.uo_calculation.uo_calc_cargos.uf_activate()
	w_newcopy.uo_calculation.uo_calc_compact.uf_activate()
	w_newcopy.uf_redraw_on()
	
	//	w_newcopy.uo_calculation.uo_calc_compact.of_init_data()
end if

return li_return
end function

public function integer wf_cpact_get_winid ();/********************************************************************
   wf_cpact_get_winid( )
   <DESC>   Returns an integer of the id of the current window</DESC>
   <RETURN> Integer:
            <LI> >1, ok
   </RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   </ARGS>
   <USAGE>  Normally property get</USAGE>
********************************************************************/
return _ii_winindex
end function

public subroutine documentation ();/********************************************************************
	ObjectName: w_atobviac_calc_calculation
	<OBJECT> Object Description </OBJECT>
	<DESC>
		Existing (archive) documentation can be found in:
		H:\TRAMOS.DEV\Documentation\Objects\GUI\w_calc_calculation.doc
		H:\TRAMOS.DEV\Documentation\Business Logic\Calculation\Calculation.doc

		Notes:
		AGL 16-2-10
		Added new functions prefixed with wf_cpact.. to support new compact window comparison.
		Also new command buttons have been added.
		
		The main amendment here is in the Open event of the window.  The window may be opened in 
		2 different ways.  
		
		1. The standard way (from the calculation manager for example)
		-------------------------------------------------------------------------------------
		Nothing really changed here from the original code.  The open method openwithparm 
		passes the structure s_opencalc_parm to this window.  

		2. Creating a copy of the instance (event clicking the cb_copywindow button)
		-------------------------------------------------------------------------------------
		Only on this event will the open method openwithparm pass the user object
		uo_calculation instead.
		
		Back to the open event of the window, there is a check to see what classname the parameter
		received has.  If the classname="s_opencalc_parm" carry on as normal, otherwise we attempt
		to copy as much as we can from the received uo_calculation user object into the new instance.
	</DESC>
	<USAGE>  Object Usage	</USAGE>
	<ALSO>   Other Objects	</ALSO>
	<HISTORY> 
		Date			CR-Ref		Author		Comments
	  	?       		?     		MI    		Initial version  
		30-07-96		?     		?                
		16-02-10		?         	AGL   		Added compact comparison functionaility
		21-09-11		CR2502   	AGL   		Allow users to use compact with all status'
		23-11-11		D-CALC   	AGL   		Changed inheritence + Minor improvements in functionality and code
		16-05-12		CR2413   	LGX001		allocate calculation to voyage if needed 
		04-02-13		CR2877   	WWA048		Merge the two windows(C/P-list, C/P-data), 
		        		         	      		When click CP button will open the C/P-data window replace the C/P-list window.
		03-04-13		CR3183   	WWA048		When the data in calculated status calculation is changed,
		        		         	      		the estimated status calculation will be recalculated.
		08-08-13		CR2867   	ZSW001		The CP date should be transfered from the CP into the summary page
		01-10-13		CR3316   	AGL027		atobviac 2013 implementation
		13-11-13		CR2658UAT	WWG004		New function wf_setconstype.
		21-11-13		CR2658UAT	LGX001 		Fixed the bug:the compact calculation copy fails when calculation has more than 1 cargo, 
		        		         	      		only 1 cargo is fully copied to the new calculation.
		28-11-13		CR2658UAT	ZSW001		Fixed Consumption Type displayed as number when changing to another vessel.
		12-11-13		CR2658UAT	ZSW001		Fixed system error in calculation
		12-12-13		CR2658UAT	AGL027		Fixed issue with compact calc copy where itinerary data was not copied
		19-06-14		CR3421   	AZX004		Add a validation on profit center of vessel and CP
		19-06-14		CR3519   	KSH092		when select ship_type or Competitor then CP must be detached automatically
		19-06-14		CR3519   	KSH092		Add a validation to check that CP’s profit center is equal to vessel’s profit center before save calculation
		08-21-14		CR3528   	XSZ004		Init consumption dropdown list for idle,bunker and various when change vessel
		28/08/14		CR3708   	CCY018		F1 help application coverage - modified event ue_getwindowname
		12/09/14		CR3773		XSZ004		Change icon absolute path to reference path
		20/11/14		CR3832		KSH092		C/P not accessible when copying calculation in compact view
		21/01/15		CR3921		LHG008		Fix the bug when colunm locked but the backcolor is not changed
		27/01/15		CR3433		LHG008		Fix the bug for failed to add new load port feature from the compact window
		29/01/15		CR3935		LHG008		Pre-select a default consumption type for Idle, Bunkering, Various
		15/04/15		CR3712		LHG008		When copy a calculation all routing points should be exactly as in the source calculation
		16/07/15		CR4104		LHG008		Change messagebox content for pool commission entered when do fixture
		24/07/15		CR3226		XSZ004		Change label for Bunkers type.
		22/12/15		CR3248		LHG008		ECA zone implementation
		19/01/16		CR3381		CCY018		Remove Ship type and Competitor.
		04/04/16		CR4258		AGL027		Remove call to calculation conumption lookup window
		22/02/16		CR3767		XSZ004		When a user opens Simple or Advanced Distance Finder or creates a new calculation or clicks Reset 
	        		      	      				Routing Points button, the default settings should be taken from the user's Primary Profit Center.		
		14/06/16		CR4411		CCY018		Copy route map
		03/08/16		CR4219		LHG008		Accuracy and improvement in DEM and DEV claims handling(CHO)(REF_CR4111)
		24/11/16		CR3145		LHG008		Enable Tramos to have up to 25 calculations open at the same time
	</HISTORY>    
********************************************************************/
end subroutine

public function integer wf_cpact_arrangeall ();/********************************************************************
   wf_cpact_arrangeall( )
   <DESC>   Tiles all windows</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
   </RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   </ARGS>
   <USAGE>  From a command button.  Uses the tag property to determine
	what state the calcule window has.</USAGE>
********************************************************************/

	
	boolean bValid
	long ll_posx=0, ll_posy=0
	window wSheet, wParent
	
	wParent=Parentwindow( )
	wSheet = wParent.GetFirstSheet()
	bValid = IsValid (wSheet)
	do
		if bValid and wSheet.classname() = "w_atobviac_calc_calculation" then
			 if wSheet.tag="min" or wSheet.tag="compact" then
				if ll_posx + wSheet.width >= wParent.width then
					ll_posx = 0
					ll_posy += wSheet.height
				end if
				wSheet.move(ll_posx,ll_posy)
				ll_posx += wSheet.width		
				wSheet.Post Function SetFocus() 
			end if
		end if	
		wSheet = wParent.GetNextSheet(wSheet)	
		bValid = IsValid (wSheet)
	loop while bValid
/*
set this current window to have focus again.
*/
	this.Post Function SetFocus()

return 1
end function

public function integer wf_cpact_set_winid ();/********************************************************************
   wf_cpact_set_winid( )
   <DESC></DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS></ARGS>
   <USAGE>  Designed to be called from the window open event. 
	Locates the highest window 'id' and uses this
	to add new reference value. This is stored in a private var.</USAGE>
********************************************************************/
boolean bValid
integer li_maxwindow=0, li_temp
window wSheet
	
	wSheet = w_tramos_main.GetFirstSheet()
	bValid = IsValid (wSheet)
	do
		if bValid and wSheet.classname() = "w_atobviac_calc_calculation" then
			li_temp = wSheet.dynamic wf_cpact_get_winid()
			if li_temp > li_maxwindow then
				li_maxwindow=li_temp
			end if	
		end if	
		wSheet = w_tramos_main.GetNextSheet(wSheet)	
		bValid = IsValid (wSheet)
	loop while bValid
	_ii_winindex = li_maxwindow + 1
return 1
end function

private function integer wf_cpact_construct_copy (u_atobviac_calculation auo_calculation);/********************************************************************
   wf_cpact_construct_copy( /*u_atobviac_calculation auo_calculation */)
   
	<DESC>   This function copies detail from previous activesheet 
	into new window.
	</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
   </RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   auo_calculation: a reference to the userobject from the previous window.
	It contains all dw's, instance vars etc needed to create a new instance 
	exactly the same as the previous window.
	</ARGS>
   <USAGE>  Should be called from the windows open event and only if the user
	has requested a copy.</USAGE>
	<HISTORY>
		Date     CR-Ref        Author   Comments
		15/04/15 CR3712        LHG008   All routing points should be exactly as in the source calculation
		22/12/15 CR3248        LHG008   ECA zone implementation
		14/03/16 CR4292        LHG008   Add function to change bunch speed
		22/03/16 CR4157        LHG008   Default Speed extended(Remove the "ask for speed when calculating" feature)
		03/05/16 CR2428        SSX014   Clear the fixed exchange rate flag
		14/06/16	 CR4411		  CCY018	  Copy route map
   </HISTORY>
********************************************************************/

long ll_posx, ll_posy, ll_row,ll_vessel_type
integer li_rowcount, li_colcount, li_col
string ls_coltype, ls_AtoBviaCSequence[]
ulong lul_bitmap
long ll_bitmapx, ll_bitmapy, ll_leftmapx, ll_rightmapx, ll_bitmapw, ll_bitmaph
boolean lb_showportname, lb_showecazone, lb_showpiracyareas
integer li_maplevel

//position the window next to the previously active 'compact' 
ll_posx = GetActiveSheet().x + GetActiveSheet().width
ll_posy = GetActiveSheet().y
this.move(ll_posx,ll_posy)

//load instance variables from received userobject into new userobject in this window.
ib_loaded = true
il_calc_id=0
uo_calculation.uf_retrieve(il_calc_id)
this.sle_vessel.text=auo_calculation.uf_get_vessel_name( )
uo_calculation.ib_calculated = auo_calculation.ib_calculated
uo_calculation.ib_modified=true  // default new copies to modified
uo_calculation.ib_no_vesseldata_reload=auo_calculation.ib_no_vesseldata_reload
uo_calculation.ib_no_ws_reload=auo_calculation.ib_no_ws_reload
uo_calculation.ib_show_messages=auo_calculation.ib_show_messages
uo_calculation.is_message=auo_calculation.is_message
uo_calculation.uo_calc_cargos.ib_ballastvoyage=auo_calculation.uo_calc_cargos.ib_ballastvoyage
uo_calculation.uo_calc_cargos.ib_vessellocked=auo_calculation.uo_calc_cargos.ib_vessellocked
uo_calculation.uo_calc_cargos.ii_current_cargo=auo_calculation.uo_calc_cargos.ii_current_cargo
uo_calculation.uo_calc_cargos.uf_set_no_cargos(auo_calculation.uf_get_no_cargos( ))
// uo_calculation.uo_calc_cargos.il_estimated_calc_id=auo_calculation.uo_calc_cargos.il_estimated_calc_id

//atobviac 2013
uo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.is_defaultenginestate = auo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.is_defaultenginestate

uo_calculation.uo_calc_cargos.istr_revers_sens=auo_calculation.uo_calc_cargos.istr_revers_sens
uo_calculation.uo_calc_cargos.istr_hea_dev_misc_parm	=auo_calculation.uo_calc_cargos.istr_hea_dev_misc_parm
uo_calculation.uf_select_page(auo_calculation.uf_get_current_page( ))  	
	
//window level defaults
wf_cpact_set_winid( )
wf_cpact_change_winsize(-1)
ii_saved_page=1

//load datawindows with the original values
wf_cpact_copydw(auo_calculation.uo_calc_summary.dw_calc_summary,uo_calculation.uo_calc_summary.dw_calc_summary)

/*
for hidden ballast datawindow, manually copy all values except the 
cal_calc_id which must remain null.	
*/
datawindow ldw_ball
ldw_ball = auo_calculation.uo_calc_summary.dw_calc_ballast
li_rowcount=ldw_ball.rowcount()
li_colcount=integer(ldw_ball.Object.DataWindow.Column.Count)
for ll_row = 1 to li_rowcount
	for li_col = 1 to li_colcount
		if ldw_ball.Describe("#" + string(li_col) + ".Name") <> "cal_calc_id" then
			ls_coltype = left(ldw_ball.Describe("#" + string(li_col) + ".ColType"),3)
			choose case ls_coltype
				case "cha"
					uo_calculation.uo_calc_summary.dw_calc_ballast.SetItem(ll_row,li_col,ldw_ball.getItemString(ll_row, li_col))	
				case "dec", "num"	
					uo_calculation.uo_calc_summary.dw_calc_ballast.SetItem(ll_row,li_col,ldw_ball.getItemNumber(ll_row, li_col))
			end choose
		end if
	next 			
next

//load remaining datawindows with the original values
wf_cpact_copydw(auo_calculation.uo_calc_summary.dw_calc_summary_list,uo_calculation.uo_calc_summary.dw_calc_summary_list)
wf_cpact_copydw(auo_calculation.uo_calc_cargos.dw_cargo_summary,uo_calculation.uo_calc_cargos.dw_cargo_summary)
wf_cpact_copydw(auo_calculation.uo_calc_cargos.dw_dischports,uo_calculation.uo_calc_cargos.dw_dischports)	
wf_cpact_copydw(auo_calculation.uo_calc_cargos.dw_loadports,uo_calculation.uo_calc_cargos.dw_loadports)	
wf_cpact_copydw(auo_calculation.uo_calc_result.dw_calc_result ,uo_calculation.uo_calc_result.dw_calc_result)	
wf_cpact_copydw(auo_calculation.uo_calc_cargos.dw_calc_lumpsum,uo_calculation.uo_calc_cargos.dw_calc_lumpsum)	
wf_cpact_copydw(auo_calculation.uo_calc_cargos.dw_addbuncons, uo_calculation.uo_calc_cargos.dw_addbuncons)

// copy itinerary data and prepare atobviac routing
post wf_cpact_copydw(auo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.dw_primary_rp,uo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.dw_primary_rp)	
post wf_cpact_copydw(auo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.dw_advanced_rp,uo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.dw_advanced_rp)	
post wf_cpact_copydw(auo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.dw_constraints,uo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.dw_constraints)	
post wf_cpact_copydw(auo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.dw_route,uo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.dw_route)	
lul_bitmap = auo_calculation.uo_calc_itinerary.tab_itinerary.tp_map.uo_map.of_copymap(ll_bitmapx, ll_bitmapy, ll_leftmapx, ll_rightmapx, ll_bitmapw, ll_bitmaph, lb_showportname, lb_showecazone, lb_showpiracyareas, li_maplevel)
uo_calculation.uo_calc_itinerary.tab_itinerary.tp_map.uo_map.post of_drawmapfromcopy(lul_bitmap, ll_bitmapx, ll_bitmapy, ll_leftmapx, ll_rightmapx, ll_bitmapw, ll_bitmaph, lb_showportname, lb_showecazone, lb_showpiracyareas, li_maplevel)

auo_calculation.uo_calc_itinerary. of_getabcportsequence(auo_calculation.uo_calc_itinerary.dw_itinerary, ls_AtoBviaCSequence)
uo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_engineControl.of_setportsequence( ls_AtoBviaCSequence )

wf_cpact_copydw(auo_calculation.uo_calc_itinerary.tab_itinerary.tp_itinerary.dw_itinerary, uo_calculation.uo_calc_itinerary.tab_itinerary.tp_itinerary.dw_itinerary)
wf_cpact_copydw(auo_calculation.uo_calc_itinerary.dw_applyspeed, uo_calculation.uo_calc_itinerary.dw_applyspeed)
wf_cpact_copydw(auo_calculation.uo_calc_itinerary.tab_itinerary.tp_itinerary.dw_itinerary_route,uo_calculation.uo_calc_itinerary.tab_itinerary.tp_itinerary.dw_itinerary_route)
if auo_calculation.uf_get_status(0) <> c#calculationstatus.il_FIXTURE then auo_calculation.uo_calc_itinerary.tab_itinerary.tp_routecontrol.uo_enginecontrol.of_refreshroute( )

//Init itinerary(reset row_id for new cargo)
uo_calculation.uo_calc_itinerary.of_datasync("init")

uo_calculation.uo_calc_itinerary.of_defzoneindicating(false, 0)

//call helper functions
wf_update_cargo_list( )

// addition to allow all calculations to be copied */
if uo_calculation.uf_get_status(0) > 2 then
	destroy uo_calculation.inv_opdata
	uo_calculation.uf_set_status( 0, 2)
	uo_calculation.uo_calc_summary.uf_set_fixture_id(0)
	uo_calculation.uo_calc_summary.uf_unlock()
	uo_calculation.uo_calc_cargos.uf_unlock( )
	uo_calculation.uo_calc_itinerary.uf_unlock( )
end if

uo_calculation.uo_calc_summary.uf_mark_new( )
uo_calculation.uo_calc_cargos.uf_clearfixedexrate()
uo_calculation.uf_get_vessel(ll_vessel_type,il_vessel_id,il_clarkson_id)
wf_updatetitle( )

return 1	
end function

public function integer wf_cpact_close (boolean ab_all);/********************************************************************
   wf_cpact_close
   <DESC>   Closes all compact mode windows except the active one.  If only
	the active window is the open, close that instead.</DESC>
   <RETURN> Integer:
            <LI> >=0, ok the number of windows closed
            <LI> -1, failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS></ARGS>
   <USAGE>  On a command button</USAGE>
********************************************************************/

boolean lb_Valid
long ll_retvalue = 0
integer li_closed, li_winindex, li_cpact_index, li_retval, li_otherinstances=0

window lw_Parent
w_atobviac_calc_calculation lw_cpactSheet[], lw_calcActive, lw_Sheet
w_confirmsave w_confirm
n_confirmsave lnv_confirm	

lw_Parent=Parentwindow( )
/* build array of windows w_atobviac_calculation that are open */	
if ab_all then
	lw_sheet = lw_Parent.GetFirstSheet()
	lb_Valid = IsValid(lw_sheet)
	do while lb_Valid
		if lw_sheet.classname( ) = "w_atobviac_calc_calculation" then
			if lw_sheet.uo_calculation.uf_cpact_get_win_mode( )<3 then
				if lw_sheet.wf_cpact_get_winid() <> this.wf_cpact_get_winid() then
					lw_cpactSheet[upperbound(lw_cpactSheet)+1] = lw_sheet
				end if
			end if
		end if
		lw_sheet = lw_Parent.GetNextSheet(lw_sheet)	
		lb_Valid = IsValid (lw_sheet)
	loop
end if

if upperbound(lw_cpactSheet)=0 then
	lw_cpactSheet[1] = this
end if

/* run through confirmation process */	
lnv_confirm = create n_confirmsave
lnv_confirm.ii_returnvalue=0

/* single element.  No need for All option */	
if upperbound(lw_cpactSheet) = 1 then
	lnv_confirm.is_prompt_text = "~rDo you want to save calcule before closing?"
	lnv_confirm.is_cmdbtn_caption2=""
	lnv_confirm.is_cmdbtn_caption4=""
else
	lnv_confirm.is_prompt_text = "~rDo you want to save this other calcule before closing?"		
end if

/* loop through all compact windows prompting user */	
for li_cpact_index = 1 to upperbound(lw_cpactSheet)
	
	lw_sheet = lw_cpactsheet[li_cpact_index]
	
	if lw_sheet.uo_calculation.uf_get_status(0) = c#calculationstatus.il_FIXTURE or not lw_sheet.uo_calculation.ib_modified then
		lw_sheet.ib_closed = true
		close(lw_sheet)
		continue
	end if
	
	if lnv_confirm.ib_execute_once=false and uo_global.ib_cpact_save_prompt then
		lnv_confirm.is_confirm_title = "Compact Calculation #" + string(lw_sheet.wf_cpact_get_winid( ))
		openwithparm(w_confirm,lnv_confirm)
		lnv_confirm = message.powerobjectparm
	end if
	
	if lnv_confirm.ii_returnvalue <5 then 
		if lnv_confirm.ii_returnvalue <3 and uo_global.ib_cpact_save_prompt then 
			if lw_sheet.uo_calculation.uf_save(true) then 
				wf_manager_retrieve()
			end if
		end if
		lw_sheet.ib_closed=true
		Close(lw_sheet)
	else
		/* only on the last window */	
		ll_retvalue = 1
		li_cpact_index = upperbound(lw_cpactSheet)
	end if			
next

return ll_retvalue
end function

public function integer wf_cpact_change_winsize (integer ai_adjust);/********************************************************************
   wf_cpact_change_winsize( /*integer ai_adjust */)
   <DESC>   manages the size of the calculation window when the 
	compact facility is enabled.</DESC>
   <RETURN> Integer:
            <LI> 1, ok
            <LI> 0, nothing to do</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   ai_adjust: minimise or maximise</ARGS>
   <USAGE>  Uses the tag property of the window to </USAGE>
	
********************************************************************/

constant integer li_IS_COMPACT = 2, li_IS_MINIMISED=1, li_IS_STANDARD = 3
constant integer li_COMPACT_PAGE = 5
integer li_orig_mode, li_new_mode

li_orig_mode = uo_calculation.uf_cpact_get_win_mode()
if (li_orig_mode = li_IS_MINIMISED and ai_adjust < 0) or (li_orig_mode = li_IS_STANDARD and ai_adjust > 0) then
	return 0
else
	li_new_mode = uo_calculation.uf_cpact_set_win_mode( li_orig_mode + ai_adjust )
	if li_new_mode = li_IS_MINIMISED then
		this.width = 164
		this.tag = "min"
		im_contextmenu.m_deletecurrentport.enabled = false
		im_contextmenu.m_addnewport.enabled = false
		im_contextmenu.m_calculate.enabled = false
		im_contextmenu.m_minimize.enabled = false
//			st_vessel.visible = false
		sle_vessel.visible = false
		cb_winshrink.enabled = false
		//this.controlmenu=false
	elseif li_new_mode = li_IS_COMPACT then
		if li_orig_mode = li_IS_STANDARD then
			im_contextmenu = CREATE  m_cpact_contextmenu
			ii_saved_page = uo_calculation.uf_get_current_page()
			uo_calculation.uf_select_page(li_COMPACT_PAGE)
			cb_summary.visible = false
			cb_calculate.visible = false
			cb_cargo.visible = false
			cb_itinerary.visible = false
			cb_result.visible = false
			cb_schedule.visible = false
			ddlb_cargo.visible = false
			cb_wingrow.enabled = true
		end if
		this.tag = "compact"		
		this.width = 945
		cb_copywindow.visible = true
		cb_compactcalc.visible = true		
		cb_arrange.visible = true
		cb_closeall.visible = true
		if li_orig_mode = li_IS_MINIMISED then
			sle_vessel.visible = true
			cb_winshrink.enabled = true
			im_contextmenu.m_deletecurrentport.enabled = true
			im_contextmenu.m_addnewport.enabled = true
			im_contextmenu.m_calculate.enabled = true
			im_contextmenu.m_minimize.enabled = true
		end if
		
		uo_calculation.uo_calc_compact.of_init_data()
	else	//IS_STANDARD
		if isvalid(im_contextmenu) then
			DESTROY im_contextmenu 
		end if
		uo_calculation.uf_select_page(ii_saved_page)	
		this.tag = ""
		this.width = 4603
		cb_summary.visible = true
		cb_calculate.visible = true
		cb_cargo.visible = true
		cb_itinerary.visible = true
		cb_result.visible = true
		cb_arrange.visible = false
		cb_closeall.visible = false
		cb_copywindow.visible = false
		cb_compactcalc.visible = false
		cb_wingrow.enabled = false
		cb_schedule.visible = true
		ddlb_cargo.visible = true
		/* new inclusion due to possibility of jumping from minimised to normal mode */		
		sle_vessel.visible = true
		cb_winshrink.enabled = true
	end if
end if

return 1
end function

private function integer wf_setportvalidator ();/********************************************************************
   wf_runvalidator( )
<DESC>   
	Used to align the current portvalidator window with the calculation,
	only updates if window is open and if calculation is mismatched.
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	n/a
</ARGS>
<USAGE>
	in the window activate event
</USAGE>
********************************************************************/

n_portvalidator lnv_validator

integer li_vesselnr=0
string ls_voyagenr=""

/* this validation checks if calculation is 
	a) not a working/template 
	b) allocated	
*/
if uo_calculation.of_getcheckvesselnr( ) > 0 then
	lnv_validator = create n_portvalidator	
	if isvalid(w_portvalidator) then
		/* obtain current calcs vessel/voyage detail */
		li_vesselnr = uo_calculation.of_getcheckvesselnr()
		ls_voyagenr = uo_calculation.of_getcheckvoyagenr()
		/* this checks if calc is allocated or not.. */	
		if li_vesselnr>0 and ls_voyagenr<>"" then
			lnv_validator.of_start( "CALCACTIVATE" , uo_calculation.of_getcheckvesselnr(), uo_calculation.of_getcheckvoyagenr(), 3)
		end if
	end if
	destroy n_portvalidator
end if


return c#return.Success

end function

public subroutine wf_recalculate ();/********************************************************************
   wf_recalculate
   <DESC> When the data in calculated status calculation is changed,
			 the estimated status calculation will be recalculated. </DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	03/04/2013 CR3183       WWA048             First Version
   </HISTORY>
********************************************************************/

open(w_calc_recalc)

//Set the calculation object not to show messages, WS reload and VESSEL data reload
w_calc_recalc.uo_calculation.ib_show_messages = false
w_calc_recalc.uo_calculation.ib_no_ws_reload = false
w_calc_recalc.uo_calculation.ib_no_vesseldata_reload = false
w_calc_recalc.uo_calculation.uo_calc_cargos.ib_ballastvoyage = true

// Retrieve the calculation into the calculation object
w_calc_recalc.uo_calculation.uf_retrieve(uo_calculation.of_getestcalcid())

//save the data
w_calc_recalc.uo_calculation.ib_calculated = false
w_calc_recalc.uo_calculation.uf_save(false)

close(w_calc_recalc)

end subroutine

public subroutine wf_setconstype (mt_u_datawindow adw_source, string as_colname, string as_constype[], string as_conszone[]);/********************************************************************
   wf_setconstype
   <OBJECT> </OBJECT>
   <USAGE>When switch vessel, fill the new consumption type</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	13/11/2013	CR2658UAT	WWG004		First Version
		23/06/2014  CR3562      KSH092	   ConsType must be pre-selected automatically when change vessel
		03/03/2015	CR3935		LHG008	   Pre-select a default consumption type for Idle, Bunkering, Various
   </HISTORY>
********************************************************************/

long	ll_null, ll_count, ll_foundsource, ll_cons_id, ll_find, ll_row, ll_current_row, ll_found
long  ll_ldwc_count
string ls_purpose_code, ls_orig_focuscolumn, ls_check_colunm, ls_findexpr
int i
boolean lb_preselect
dwobject	ldwo_object
datawindowchild	ldwc_child

setnull(ll_null)

ll_row = adw_source.getrow()
ll_count = adw_source.rowcount()

ls_orig_focuscolumn = adw_source.getcolumnname()
adw_source.getchild(as_colname, ldwc_child)

ldwo_object = adw_source.object.__get_attribute(as_colname, false)
adw_source.setcolumn(1)

if ll_count > 0 then
	if as_colname = 'cal_carg_bunker_cons_id' or as_colname = 'cal_carg_idle_cons_id' or as_colname = 'cal_carg_various_cons_id' then
		choose case as_colname
			case 'cal_carg_bunker_cons_id'
				ls_purpose_code = uo_calculation.uo_calc_cargos.is_BUNKERING
				ls_check_colunm = "cal_carg_cal_carg_bunkering_days"
			case 'cal_carg_idle_cons_id'
				ls_purpose_code = uo_calculation.uo_calc_cargos.is_IDEL
				ls_check_colunm = "cal_carg_cal_carg_idle_days"
			case 'cal_carg_various_cons_id'
				ls_purpose_code = uo_calculation.uo_calc_cargos.is_VARIOUS
				ls_check_colunm = "cal_carg_add_days_other"
		end choose
		
		for ll_current_row = 1 to ll_count
			lb_preselect = false
			
			ll_cons_id = adw_source.getitemnumber(ll_current_row, as_colname)
			
			if isnull(ll_cons_id) then
				if len(ls_check_colunm) > 0 then
					if adw_source.getitemnumber(ll_current_row, ls_check_colunm) > 0 then lb_preselect = true
				end if
			else
				ls_findexpr = "cons_type = '" + as_constype[ll_current_row] + "' and zone_sn = '" + as_conszone[ll_current_row] + "' and cal_cons_active = 1"
				ll_find = ldwc_child.find(ls_findexpr, 1, ldwc_child.rowcount())
				
				if ll_find > 0 then
					ll_cons_id = ldwc_child.getitemnumber(ll_find, "cal_cons_id")
					
					adw_source.setrow(ll_current_row)
					adw_source.setcolumn(as_colname)
					adw_source.setitem(ll_current_row, as_colname, ll_cons_id)
					adw_source.event itemchanged(ll_current_row, ldwo_object, string(ll_cons_id))
				else
					lb_preselect = true
				end if
			end if
			
			if lb_preselect then uo_calculation.uo_calc_cargos.of_preselect_contype(ll_current_row, ls_purpose_code, adw_source, as_colname)
		next
		
		if ll_row > 0 then adw_source.setrow(ll_row)
		if len(ls_orig_focuscolumn) > 0 then adw_source.setcolumn(ls_orig_focuscolumn)
		return
	end if
end if

do
   ll_foundsource = adw_source.find("isnumber(lookupdisplay(" + as_colname + "))", ll_foundsource + 1, ll_count + 1)
	
	if ll_foundsource <= 0 then exit
	ll_find = ldwc_child.find("cons_type = '" + as_constype[ll_foundsource] + "' and cal_cons_active = 1", 1, ldwc_child.rowcount())
	if ll_find > 0 then 
		ll_cons_id = ldwc_child.getitemnumber(ll_find, "cal_cons_id") 
	else 
		if ldwc_child.rowcount() = 1 then
			
			if ldwc_child.GetitemNumber(1,'zone_id') = uo_global.ii_default_cons_zone and ldwc_child.getitemnumber(1,'cal_cons_active') = 1 then
			   ll_cons_id = ldwc_child.getitemnumber(1, "cal_cons_id")
			end if
			
		elseif ldwc_child.rowcount() > 1 then
			
			if as_colname ='port_cons_id' then
			   ls_purpose_code = adw_source.getitemstring(ll_foundsource,'purpose_code')
				
			   if ls_purpose_code = 'L' then
			      ll_found = ldwc_child.find("cal_cons_type = 3 and string(zone_id) = '"+string(uo_global.ii_default_cons_zone)+"' and cal_cons_active = 1", 1, ldwc_child.rowcount())
			   elseif ls_purpose_code = 'WD' then
			      ll_found = ldwc_child.find("cal_cons_type = 7 and string(zone_id) = '"+string(uo_global.ii_default_cons_zone)+"'  and cal_cons_active = 1", 1, ldwc_child.rowcount())
		      elseif ls_purpose_code = 'D' then
			      ll_found = ldwc_child.find("cal_cons_type = 6 and string(zone_id) = '"+string(uo_global.ii_default_cons_zone)+"'  and cal_cons_active = 1", 1, ldwc_child.rowcount())
		      end if
				
		      if ll_found <= 0 then
			      ll_found = ldwc_child.find("cal_cons_type = 4 and string(zone_id) = '"+string(uo_global.ii_default_cons_zone)+"'  and cal_cons_active = 1", 1, ldwc_child.rowcount())
		      end if
				
		      if ll_found > 0 then
				   ll_cons_id = ldwc_child.getitemnumber(ll_found,"cal_cons_id")
			   else
		         ll_cons_id = ll_null
			   end if
				
		   else
			  ll_cons_id = ll_null
		   end if
			
		else
			ll_cons_id = ll_null
		end if
		
	end if
	
	adw_source.setrow(ll_foundsource)
	adw_source.setcolumn(as_colname)
	adw_source.setitem(ll_foundsource, as_colname, ll_cons_id)
	adw_source.event itemchanged(ll_foundsource, ldwo_object, string(ll_cons_id))
loop while true

if as_colname ='port_cons_id' then
	
   for i = 1 to ll_count
	    ll_cons_id = adw_source.getitemnumber(i,as_colname)
	    if isnull(ll_cons_id) then
	       ll_ldwc_count = ldwc_child.rowcount()
			 
		    if ll_ldwc_count >=1 then
			    choose case ll_ldwc_count
				    case 1
						
				       if ldwc_child.GetitemNumber(1,'zone_id') = uo_global.ii_default_cons_zone and ldwc_child.getitemnumber(1,'cal_cons_active') = 1 then
			             ll_cons_id = ldwc_child.getitemnumber(1, "cal_cons_id")
			          end if
						 
			       case else
						
					    ls_purpose_code = adw_source.getitemstring(i,'purpose_code')
			          if ls_purpose_code = 'L' then
			             ll_found = ldwc_child.find("cal_cons_type = 3 and string(zone_id) = '"+string(uo_global.ii_default_cons_zone)+"'  and cal_cons_active = 1", 1, ldwc_child.rowcount())
			          elseif ls_purpose_code = 'WD' then
			             ll_found = ldwc_child.find("cal_cons_type = 7 and string(zone_id) = '"+string(uo_global.ii_default_cons_zone)+"'  and cal_cons_active = 1", 1, ldwc_child.rowcount())
		             elseif ls_purpose_code = 'D' then
			             ll_found = ldwc_child.find("cal_cons_type = 6 and string(zone_id) = '"+string(uo_global.ii_default_cons_zone)+"'  and cal_cons_active = 1", 1, ldwc_child.rowcount())
		             end if
						 
		             if ll_found <= 0 then
			             ll_found = ldwc_child.find("cal_cons_type = 4 and string(zone_id) = '"+string(uo_global.ii_default_cons_zone)+"'  and cal_cons_active = 1", 1, ldwc_child.rowcount())
		             end if
						 
		             if ll_found > 0 then
				          ll_cons_id = ldwc_child.getitemnumber(ll_found,"cal_cons_id")
			          else
		                ll_cons_id = ll_null
			          end if
						 
		          end choose
					 
		       else
			       ll_cons_id = ll_null
		       end if
		
		       adw_source.setrow(i)
	          adw_source.setcolumn(as_colname)
	          adw_source.setitem(i, as_colname, ll_cons_id)
	          adw_source.event itemchanged(i, ldwo_object, string(ll_cons_id))
				 
	       end if
     next
end if	
if ll_row > 0 then adw_source.setrow(ll_row)

end subroutine

public function integer wf_validation_profit_center (ref integer ii_not_open);/********************************************************************
   wf_validation_profit_center()
   <DESC>	Add a validation to check that CP’s profit center is equal to vessel’s profit center before save calculation
   <RETURN>	integer:
           	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	ue_cpitem event clicked	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		24/06/14	CR3519        KSH092  First Version
		19/01/16	CR3381		CCY018	Remove Ship type and Competitor.
   </HISTORY>
********************************************************************/
Long ll_cal_cerp_id,ll_not_equal = 0,ll_message = 0,ll_null;setnull(ll_null)
Long ll_vessel_pc,ll_cp_pc,li_count,li_status,li_cargo,ll_row

string ls_pc_name,ls_cp_pc_name


li_status = uo_calculation.uf_get_status(0)

if il_vessel_id > 0 then
	
   SELECT PC_NR
   INTO :ll_vessel_pc
   FROM VESSELS
   WHERE VESSEL_NR = :il_vessel_id;
end if

ll_row = uo_calculation.uo_calc_summary.dw_calc_summary_list.getrow()
if not isnull(ll_vessel_pc) then
	ll_message = 0
	ii_not_open = 0
	ll_cal_cerp_id = uo_calculation.uo_calc_summary.dw_calc_summary_list.GetItemNumber(ll_row,'CAL_CARG_CAL_CERP_ID')
	if not isnull(ll_cal_cerp_id) then
		SELECT CAL_CERP_PROFIT_CENTER_NO
      INTO :ll_cp_pc
      FROM CAL_CERP
      WHERE CAL_CERP_ID = :ll_cal_cerp_id;
      if ll_cp_pc <> ll_vessel_pc then
		   // if usaged for ue_cpitem.event clicked( )
			SELECT COUNT(*)
			INTO :LI_COUNT
         FROM   USERS_PROFITCENTER  
         WHERE ( USERS_PROFITCENTER.PC_NR = :ll_cp_pc  ) and  
               ( USERS_PROFITCENTER.USERID = :uo_global.is_userid);
					
			SELECT PC_NAME
         INTO :ls_cp_pc_name
         FROM PROFIT_C
         WHERE PC_NR = :ll_cp_pc;
			if li_count < 1 then
				
              
				   ii_not_open = ii_not_open + 1
				
			end if 
			  
	   end if
			
  end if
	
	
	if ii_not_open > 0 then
		messagebox('Validation',"You do not have access to the C/P's profit center: "+ls_cp_pc_name+".")
	end if
end if
return ll_not_equal

end function

public function integer wf_getconstypezone (mt_u_datawindow adw_source, long al_row, string as_colname, ref string as_type, ref string as_zone);/********************************************************************
   wf_getconstypezone
   <DESC>	Use to get consumption type and zone_sn from datawindowchild	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_source
		al_row
		as_colname
		as_type
		as_zone
   </ARGS>
   <USAGE>	Ref:wf_select_vessel()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		05/03/15 CR3935        LHG008   First Version
   </HISTORY>
********************************************************************/

long  	ll_calconsid, ll_find
datawindowchild	ldwc_consdddw

if not isvalid(adw_source) or isnull(adw_source) then return c#return.Failure

if adw_source.getchild(as_colname, ldwc_consdddw) > 0 then
	
	ll_calconsid = adw_source.getitemnumber(al_row, as_colname)
	
	if isnull(ll_calconsid) then return c#return.Failure
	
	ll_find = ldwc_consdddw.find("cal_cons_id = " + string(ll_calconsid), 1, ldwc_consdddw.rowcount())
	if ll_find > 0 then
		as_type = ldwc_consdddw.getitemstring(ll_find, "cons_type")
		as_zone = ldwc_consdddw.getitemstring(ll_find, "zone_sn")
		
		return c#return.Success
	end if
end if

return c#return.Failure
end function

public function integer wf_checkmaxinstances ();/********************************************************************
   wf_checkmaxinstances
   <DESC>	 Check whether the number of Calculation windows is greater than ii_MAX_INSTANCES	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call by window open event	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		22/11/16 CR3145        LHG008   First Version
   </HISTORY>
********************************************************************/

long ll_wincount = 0
window lw_sheet

lw_sheet = w_tramos_main.getfirstsheet()
do while isvalid(lw_sheet)
	if lw_sheet.classname() = "w_atobviac_calc_calculation" or lw_sheet.classname() = "w_calc_calculation" then
		ll_wincount++
	end if
	
	lw_sheet = w_tramos_main.getnextsheet(lw_sheet)	
loop

if ll_wincount > ii_MAX_INSTANCES then return c#return.Failure

return c#return.Success
end function

event ue_ballastvoyageitem;call super::ue_ballastvoyageitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Shifts between ballast and non-ballast voyage. Is called from the
 					mainmenu

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Boolean lb_tmp

// Toggle the ballast voyage status
lb_tmp = not uo_calculation.uf_get_ballast_voyage()
uo_calculation.uf_set_ballast_voyage(lb_tmp)
// Select cargo 1 so the user doesn't ends on a cargo that's not there
uo_calculation.uf_select_cargo(1)

// Update the menu
wf_updatemenu(true)

// Change the text on the cargo button between "Cargo" (for normal voyages) and 
// "Data" (for ballast voyages).
CHOOSE CASE lb_tmp
	CASE false
		cb_cargo.text = "C&argoes"
	CASE true
		cb_cargo.text = "D&ata"
END CHOOSE
end event

event ue_saveasitem;call super::ue_saveasitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when the user selects save-as from the menu or the toolbar.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE           CR-Ref      NAME        DESCRIPTION
--------       -------     -----       -------------------------------------
21/01/15       CR3921      LHG008      Fix the bug when colunm locked but the backcolor is not changed
************************************************************************************/

s_calc_saveas lstr_calc_saveas
Long ll_tmp

SetNull(ll_tmp)

// Open the save-as window, with the calculation description as default
OpenWithParm(w_calc_saveas, uo_calculation.uf_get_description(0))

lstr_calc_saveas = Message.PowerObjectParm

If IsValid(lstr_calc_saveas) Then

	// LSTR_CALC_SAVEAS will only be valid if the user selected OK in the
	// W_CALC_SAVEAS window. So now we're saving the calculation. 
	
	// Set the FIXTURE_ID to NULL and call UF_SAVEAS with the new description
	// and calculation type.
	uo_calculation.uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_fix_id", ll_tmp)
	uo_calculation.uf_saveas(lstr_calc_saveas.s_description,lstr_calc_saveas.i_calctype,true)

	// Request the manager to re-retrieve data next time it's activated
	wf_manager_retrieve()
	
	// force an update of the calc number calc status is either working or template
	il_calc_id = uo_calculation.uf_get_calc_id( )
	
	//retrieve new calculation
	this.triggerevent("ue_retrieve")
End if


end event

event open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 15-07-96

 Description : Calculation main window. Receives a single parameter, but can be of 2 types.
 					LSTR_OPENCALC_PARM, this contains information about what to load (New calculation,
					New wizard or existing calculation).  This is from the original process.
				

 Arguments : LSTR_OPENCALC_PARM as S_OPENCALC_PARM
 				 LUO_CALCULATION as UO_CALCULATION

 Returns   : None

*************************************************************************************
Development Log 
DATE			VERSION 	   NAME	      DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
15-07-96		1.0 			MI		      Initial version
25-07-96							         Added closequery and saveas  
22-03-10		1.1   		AGL			Added compact window functionality
23-11-11		D-CALC		AGL			Facility to pass default page.  (Only working currently from the portvalidator)		
24-11-16		CR3145		LHG008		Enable Tramos to have up to 25 calculations open at the same time
************************************************************************************/

if wf_checkmaxinstances() = c#return.Failure then
	messagebox("Calculation windows - error", "You can only have a maximum of " + string(ii_MAX_INSTANCES) + " calculations open at once. " &
				+ "Close any of the currently open calculations before you continue.", StopSign!)
	
	_ib_forceclose = true
	close(this)
	return
end if

s_opencalc_parm lstr_opencalc_parm

if isvalid(w_atobviac_calc_sensitivity) then w_atobviac_calc_sensitivity.wf_setmodified(true)

if message.powerobjectparm.classname( )="s_opencalc_parm" then
	lstr_opencalc_parm = Message.PowerObjectParm
	/*
	Normal open event triggered from Manager 
	compact window handling
	*/
	this.move(0,0)
	wf_cpact_set_winid( )
	// Set the instance CALC_ID to the CALC_ID given in LSTR_OPENCALC_PARM
	il_calc_id = lstr_opencalc_parm.l_calc_id
	// Select wizard mode if CALC_ID is zero and (s_wizard <> default)
	If (il_calc_id = 0) And (lstr_opencalc_parm.s_wizard<>"default") Then
		If uo_calculation.uf_load_wizard(lstr_opencalc_parm.s_wizard) Then
			// If the Wizard was loaded, then disable the cargo, itinerary,
			// summary buttons and dropdown cargo list box. Enabled the
			// wizard button and set the Wizard button to the same position
			// as the Itinerary button
			cb_cargo.visible = false
			cb_itinerary.visible = false
			cb_summary.visible = false
			cb_wizard.visible = true
			ddlb_cargo.visible = false
			cb_wizard.x = cb_itinerary.x
		end if
	else
		if lstr_opencalc_parm.b_compact=true then
			uo_calculation.uf_select_page(5)
			wf_cpact_change_winsize( -1)
			ii_saved_page=1
		end if
	end if
	// Post the master retrieve event
	if lstr_opencalc_parm.i_defaultpage>0 then
		/* called from the portvalidator */
		triggerevent("ue_retrieve")
		uo_calculation.uf_select_page(lstr_opencalc_parm.i_defaultpage)
	else	
		postevent("ue_retrieve")
	end if
else	
 	/* 
   User request to make a copy of compact calcule
	PowerObjectParm is of type uo_calculation.  
	*/
	wf_cpact_construct_copy(message.powerobjectparm)
end if
end event

event ue_wizarditem;call super::ue_wizarditem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when the user selects Wizard from the menu. The Wizard menu
 					item is only enabled when the Wizard is active

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Ask user if he/she really want's to do this
If MessageBox("Warning", "Exit Wizard mode ?", Exclamation!, YesNo!) = 1 Then

	// ... OK, now call the calculation and see if it can be done
	If uo_calculation.uf_set_wizard(false) Then
		
		// It could. Update the cargo list, and the set the
		// summary, cargo, itinerary buttons and the cargo-listbox visible, 
		// and the Wizard button invisible
		wf_update_cargo_list()

		cb_cargo.visible = true
		cb_itinerary.visible = true
		cb_summary.visible = true
		cb_wizard.visible = false
		ddlb_cargo.visible = true
		cb_winshrink.enabled = true

		// update menu items
		wf_updatemenu(true)
	End if
End if
end event

event ue_unlockcalculationitem;call super::ue_unlockcalculationitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when the user selects UNLOCK from the menu.

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If MessageBox("Warning", "Unlocking will enable you to insert, delete and change cargoes, but can damage existing data integrity.~r~n~r~n"+&
	"Do you want to continue ?", StopSign!, YesNo!, 2) = 1 Then
	If not uo_calculation.uf_unlock() Then
		MessageBox("System error", "Unable to unlock calculation")
	End if
End if


end event

event ue_fixtureitem;call super::ue_fixtureitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when the user selectes "fixture" from the mainmenu or 
 					the toolbar. 

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE			VERSION 		NAME			DESCRIPTION
-------- 	------- 		----- 		-------------------------------------
16/07/15		CR4104		LHG008		Change messagebox content for pool commission entered
************************************************************************************/

Integer li_result , li_status
LONG ll_calc_id,ll_cp_id,ll_cp_pc_nr,ll_pc_nr
Boolean lb_ok
string ls_pc_name,ls_description
int i
s_voyage_return lstr_return
u_atobviac_loadload_calculation  lnv_loadcalc

// See if the vessel is attached to a pool where the calcule needs to be send to the weekely fixture list before it can be fixed

ll_calc_id = uo_calculation.uo_calc_summary.dw_calc_summary.getItemNumber(1, "cal_calc_id")
if isNull(ll_calc_id) or ll_calc_id = 0 then
	MessageBox("Save Calculation", "Please save calculation before fixture!")
	return
end if
//	Add a validation to check that CP’s profit center is equal to vessel’s profit center
if il_vessel_id > 0 then
	
   SELECT count(*) 
	INTO :li_result
   FROM CAL_CALC A,CAL_CARG B,VESSELS C,CAL_CERP D
   WHERE A.CAL_CALC_VESSEL_ID = C.VESSEL_NR and 
	      A.CAL_CALC_ID =B.CAL_CALC_ID and 
			A.CAL_CALC_STATUS < 4 and 
			B.CAL_CERP_ID = D.CAL_CERP_ID and 
			C.PC_NR <> D.CAL_CERP_PROFIT_CENTER_NO and 
			A.CAL_CALC_ID = :ll_calc_id;
			
	SELECT P.PC_NAME,P.PC_NR
	INTO   :ls_pc_name,:ll_pc_nr
	FROM VESSELS C,PROFIT_C P,CAL_CALC A
	WHERE A.CAL_CALC_ID = :ll_calc_id and
	      A.CAL_CALC_VESSEL_ID = C.VESSEL_NR AND
			C.PC_NR = P.PC_NR ;
end if

if li_result>0 then
	ls_description = ''
	for i = 1 to  uo_calculation.uo_calc_summary.dw_calc_summary_list.rowcount()
	   ll_cp_id =  uo_calculation.uo_calc_summary.dw_calc_summary_list.GetItemNumber(i,'CAL_CARG_CAL_CERP_ID')
		SELECT CAL_CERP_PROFIT_CENTER_NO
		INTO :ll_cp_pc_nr
		FROM   CAL_CERP
		WHERE CAL_CERP_ID = :ll_pc_nr;
		if ll_pc_nr <> ll_cp_pc_nr then
			if ls_description = '' then
				ls_description =  uo_calculation.uo_calc_summary.dw_calc_summary_list.GetItemString(i,'cal_carg_description') +"~r~n"
			else
			  ls_description = ls_description + uo_calculation.uo_calc_summary.dw_calc_summary_list.GetItemString(i,'cal_carg_description') +"~r~n"
		end if
		end if
	next
	Messagebox("Validation", "The C/P's profit center for the cargo with description:~r~n"+ls_description+"must be the same as the vessel's profit center: "+ls_pc_name+"."+'~r~n')
	return 
end if

if MessageBox("Warning", "Important for Broström, Handytankers and MR:" &
	+ "~r~n~r~nFor all voyages starting after 01-08-2015,~r~nHave you checked that pool commission has NOT been entered?", Question!, YesNo!,2) = 2 then
	return
end if


lb_ok = uf_weekly_fix_ok(ll_calc_id)

IF lb_ok = TRUE THEN
	// Open the fixture window
	OpenWithParm(w_calc_fixture, uo_calculation)
	lstr_return = message.powerobjectparm
	//li_result = Message.DoubleParm
	
	/* allocate calc to voyage */
	if lstr_return.al_return = 1 and lstr_return.ab_allocatefixture then
		uo_calculation.of_allocatevoyage( )
	end if
		
	/* This event should call functions to create a loadload calculation based on the estimated calculation */
	li_status = uo_calculation.uo_calc_summary.uf_get_status( )
	if li_status = 5 or li_status = 6 then
		lnv_loadcalc = create u_atobviac_loadload_calculation 
		lnv_loadcalc.of_fixture (il_calc_id, li_status  )
		destroy lnv_loadcalc
	end if
	
	// Ask the manager to re-retrieve data upon next activation
	wf_manager_retrieve()
	// And close the calculation if the fixture went through
	If lstr_return.al_return = 1 then close(this)
ELSE
	Messagebox("Not sent to fixture list", "The selected calcule needs to be sent to weekly fixture list, before it can be fixed")
END IF
end event

event activate;call super::activate;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the Activate event for the W_CALC_CALCULATION window,
 					by updating the calculation menu (enabling/disabling) the
					different menuitems.

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
************************************************************************************/

// Update the mainmenu if we're NOT currently loading the calculation (this will
// save some processing power, since the menu otherwise would be update quite
// a few times during the load


If ib_loaded then 
	wf_updatemenu(true)
	wf_setportvalidator()
end if

m_calcmain.mf_setlink(uo_calculation.uo_calc_summary.dw_calc_summary,"cal_calc_vessel_id","cal_calc_fix_id",True)
end event

event ue_retrieve;call super::ue_retrieve;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Main UE_RETRIEVE for the calculation. This event is posten upon
 					initial load from the open event

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE			VERSION	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
02-04-13		CR2658	WWG004	Init the compact window data.  
21/01/15		CR3921	LHG008	Fix the bug when colunm locked but the backcolor is not changed
24/03/16    CR4114   SSX014   Remove Yield to stop Tramos from crashing
************************************************************************************/
// Retrieve data or insert blank calculation. The IB_LOADED is current false
long	ll_vessel_type
integer li_leftShift = 0, li_rightShift = 0

uo_calculation.uf_retrieve(il_calc_id)

//Init the compact datawindow data.
uo_calculation.uo_calc_compact.of_init_data()

// Mark the the IB_LOADED to true, and update the title and menu. The IB_LOADED is
// used to disable updates to the menu and title during load (to save processing power).
ib_loaded = true

wf_updatetitle()

// If it's a new calculation then trigger the "select vessel" window, otherwise 
// update misc. fields
If il_calc_id = 0 Then
	li_leftShift = GetAsyncKeyState(160)
	li_rightShift = GetAsyncKeyState(161)
	
	// Disable open vessel select if shift! is hold during retrieval
	If not (li_leftShift < 0 or li_rightShift < 0) Then wf_select_vessel()
Else
	// We're retrieving an exisiting calculation. Update the Vessel name in
	// the vessel name box, the select vessel button 
	sle_vessel.text = uo_calculation.uf_get_vessel_name()
	uo_calculation.uf_get_vessel(ll_vessel_type, il_vessel_id, il_clarkson_id)
	
	if uo_calculation.uo_calc_cargos.ib_vessellocked then
		sle_vessel.backcolor = c#color.MT_FORM_BG
		cb_select_vessel.enabled = false
	else
		sle_vessel.backcolor = c#color.MT_MAERSK
		cb_select_vessel.enabled = true
	end if
	
	// Update the cargo list
	wf_update_cargo_list()
	
	// And change the text on the "cargo" button to "data", if it's a ballast voyage
	If uo_calculation.uf_get_ballast_voyage() Then
		cb_cargo.text = "&Data"
	End if

	// Disable calculate button if this is a fixtured calculation
	if uo_calculation.uf_get_status(0) = c#calculationstatus.il_FIXTURE Then
		cb_calculate.enabled = false
		cb_schedule.enabled = false
		cb_compactcalc.enabled = false
	else
		cb_calculate.enabled = true
		cb_schedule.enabled = true
		cb_compactcalc.enabled = true
	end if
End if

wf_updatemenu(true)
end event

event doubleclicked;call super::doubleclicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Switched to debugging mode, if "DEBUG" is specified in the
 					TRAMOS.INI file

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Check to see if debugging sw-should be enabled
Boolean lb_tmp

If uo_global.ib_developer Then
	lb_tmp = cb_debug.Visible 
	cb_debug.visible = not lb_tmp
//	st_vessel.visible = lb_tmp
End if

end event

event ue_global_change;call super::ue_global_change;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : This event is sent from the system data windows, upon data change

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If Message.WordParm = 4 Then
	// Wordparm = 4 identifies change in the global consumption list
	// now reload the speedlist

	uo_calculation.uf_reload_speedlist()
End if
end event

event closequery;call super::closequery;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Asks the user if he/she want to save the calculation before exitting
 					the calculation module

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE			VERSION	NAME  		DESCRIPTION
--------		-------	------		-------------------------------------
26/02/15		CR3921	LHG008		It should not be possible to save any changes in a Fixture calculation  
24/11/16		CR3145	LHG008		Enable Tramos to have up to 25 calculations open at the same time
************************************************************************************/

if _ib_forceclose then return

Integer li_return,li_not_open
string ls_calc_index=""
long ll_not_equal

// If calculation modified then prompt user for action

uo_calculation.uo_calc_compact.dw_calc_summary.accepttext()
uo_calculation.uo_calc_summary.dw_calc_summary.accepttext()
uo_calculation.uo_calc_cargos.dw_cargo_summary.accepttext()
uo_calculation.uo_calc_cargos.dw_loadports.accepttext()
uo_calculation.uo_calc_cargos.dw_dischports.accepttext()
uo_calculation.uo_calc_summary.dw_calc_summary_list.accepttext()

if uo_calculation.uf_cpact_get_win_mode()<3 and uo_calculation.ib_modified and not this.ib_closed then
	li_return = wf_cpact_close(false)
elseIf (uo_calculation.uf_get_status(0) <> c#calculationstatus.il_FIXTURE and uo_calculation.ib_modified and uo_calculation.uf_cpact_get_win_mode()=3) then
	
	CHOOSE CASE MessageBox("Warning", "The calcule " + ls_calc_index + " has changed. ~rSave calcule before closing ?", Exclamation!, YesNoCancel!)
		CASE 1
			// Yes, save calculate
			If uo_calculation.uf_save(true) Then 
				wf_manager_retrieve()
			Else
				li_return = 1
			End if
		CASE 2
			// No, just exit
		CASE 3
			// Cancel, dont close
			li_return = 1
	END CHOOSE

End If

Message.ReturnValue = li_return


end event

event ue_saveitem;call super::ue_saveitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when the user selects save from the menu or toolbar

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		      VERSION 	   NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
03/04/13			CR3183		WWA048		When the data in calculated status calculation is changed,
													the estimated status calculation will be recalculated.
************************************************************************************/
integer 	li_status,li_not_open
Boolean lb_result
u_atobviac_loadload_calculation  lnv_loadcalc

// Call save
lb_result= uo_calculation.uf_save(true) 

/* This event should call functions to create a loadload calculation based on the estimated calculation */
li_status = uo_calculation.uo_calc_summary.uf_get_status( )
if li_status = 5 or li_status = 6 then
	lnv_loadcalc = create u_atobviac_loadload_calculation 
	lnv_loadcalc.of_calculation_modified (il_calc_id, li_status  )
	destroy lnv_loadcalc
	if li_status = 5 then
		wf_recalculate()
	end if
end if

// If it succeded, then as the Manager to re-retrieve data next time it's activate
If lb_result Then	wf_manager_retrieve()

// Update the menu and the title
wf_updatemenu(true)
wf_updatetitle()




end event

event ue_deleteitem;call super::ue_deleteitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles delete-clicks from the mainmenu or the toolbar, by calling
 					UF_DELETE in the calculationobject. 

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Call delete in the calculation object
uo_calculation.uf_delete()

// and update the cargo list
wf_update_cargo_list()

end event

event ue_newitem;call super::ue_newitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when the user selects "new" from the mainmenu or toolbar.

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Let the calculation do the insert in the active page
uo_calculation.uf_insert()

// and update the cargo list
wf_update_cargo_list()

end event

event ue_cpitem;call super::ue_cpitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Opens the Claims window, when the user clicks on the claims menuitem
 					in the main menu or the toolbar

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
04/09-09  	20.02			RMO003	Error from CR#1743 fixed
************************************************************************************/
long ll_rc,ll_not_equal
integer li_not_open
int li_status
//Get profit center
il_vessel_id = uo_calculation.uo_calc_summary.dw_calc_summary.getitemnumber(1, "cal_calc_vessel_id")
il_clarkson_id = 0

if isnull(il_vessel_id) then il_vessel_id = 0
if isnull(il_clarkson_id) then il_clarkson_id = 0

uo_calculation.of_set_profit_center(il_vessel_id, il_clarkson_id)
//add validation profit center where status = 'fixture or Estimated & Calculated Calc'

   ll_not_equal = wf_validation_profit_center(li_not_open)
   if isnull(li_not_open) then li_not_open = 0
	if li_not_open > 0 then
	   return
   end if

//end validation

// Pass the calculation as argument
OpenWithParm(w_calc_cp_data, uo_calculation)
// And get the calculation to update it's data 
ll_rc = message.doubleparm
if ll_rc = 1 and il_calc_id > 1 then   //CP changed  and calculation not new
	uo_calculation.uf_retrieve( il_calc_id )
// change request #1743
//else
//	uo_calculation.uf_update(0)
end if	

this.event ue_refreshcp()

end event

event ue_printitem;call super::ue_printitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when the user selects print from the mainmenu or toolbar

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

uo_calculation.uf_print()
end event

event ue_statusitem;call super::ue_statusitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when the user selects change status from the menu 

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Calls w_calc_change_status w/ calculation as parameter

OpenWithParm(w_calc_change_status,uo_calculation)


end event

event deactivate;call super::deactivate;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the Deactivate event for the W_CALC_CALCULATION window,
 					by updating the calculation menu, e.i. enabling/disabling the
					different menuitems. 

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Update the mainmenu if we're NOT currently loading the calculation (this will
// save some processing power, since the menu otherwise would be update quite
// a few times during the load

If ib_loaded then wf_updatemenu(false)


end event

on w_atobviac_calc_calculation.create
int iCurrent
call super::create
this.cb_arrange=create cb_arrange
this.cb_closeall=create cb_closeall
this.cb_compactcalc=create cb_compactcalc
this.cb_wingrow=create cb_wingrow
this.cb_copywindow=create cb_copywindow
this.cb_winshrink=create cb_winshrink
this.cb_schedule=create cb_schedule
this.cb_calculate=create cb_calculate
this.cb_select_vessel=create cb_select_vessel
this.cb_summary=create cb_summary
this.cb_itinerary=create cb_itinerary
this.cb_cargo=create cb_cargo
this.cb_result=create cb_result
this.ddlb_cargo=create ddlb_cargo
this.cb_wizard=create cb_wizard
this.sle_vessel=create sle_vessel
this.cb_debug=create cb_debug
this.uo_calculation=create uo_calculation
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_arrange
this.Control[iCurrent+2]=this.cb_closeall
this.Control[iCurrent+3]=this.cb_compactcalc
this.Control[iCurrent+4]=this.cb_wingrow
this.Control[iCurrent+5]=this.cb_copywindow
this.Control[iCurrent+6]=this.cb_winshrink
this.Control[iCurrent+7]=this.cb_schedule
this.Control[iCurrent+8]=this.cb_calculate
this.Control[iCurrent+9]=this.cb_select_vessel
this.Control[iCurrent+10]=this.cb_summary
this.Control[iCurrent+11]=this.cb_itinerary
this.Control[iCurrent+12]=this.cb_cargo
this.Control[iCurrent+13]=this.cb_result
this.Control[iCurrent+14]=this.ddlb_cargo
this.Control[iCurrent+15]=this.cb_wizard
this.Control[iCurrent+16]=this.sle_vessel
this.Control[iCurrent+17]=this.cb_debug
this.Control[iCurrent+18]=this.uo_calculation
this.Control[iCurrent+19]=this.r_1
end on

on w_atobviac_calc_calculation.destroy
call super::destroy
destroy(this.cb_arrange)
destroy(this.cb_closeall)
destroy(this.cb_compactcalc)
destroy(this.cb_wingrow)
destroy(this.cb_copywindow)
destroy(this.cb_winshrink)
destroy(this.cb_schedule)
destroy(this.cb_calculate)
destroy(this.cb_select_vessel)
destroy(this.cb_summary)
destroy(this.cb_itinerary)
destroy(this.cb_cargo)
destroy(this.cb_result)
destroy(this.ddlb_cargo)
destroy(this.cb_wizard)
destroy(this.sle_vessel)
destroy(this.cb_debug)
destroy(this.uo_calculation)
destroy(this.r_1)
end on

event close;call super::close;// wf_cpact_close( false )
if isvalid(w_atobviac_calc_sensitivity) then w_atobviac_calc_sensitivity.wf_setmodified(true)

if isvalid(im_contextmenu) then
	DESTROY im_contextmenu 
end if
end event

event ue_getwindowname;call super::ue_getwindowname;constant integer li_IS_COMPACT = 2, li_IS_MINIMISED=1, li_IS_STANDARD = 3
integer li_mode

li_mode = uo_calculation.uf_cpact_get_win_mode()

if li_mode <> li_IS_STANDARD then
	as_windowname = this.classname() + "_compact"
else
	as_windowname = this.classname()
end if
end event

type st_hidemenubar from mt_w_sheet_calc`st_hidemenubar within w_atobviac_calc_calculation
end type

type cb_arrange from mt_u_commandbutton within w_atobviac_calc_calculation
boolean visible = false
integer x = 457
integer y = 116
integer width = 146
integer height = 80
integer taborder = 130
string text = "Tile"
end type

event clicked;call super::clicked;wf_cpact_arrangeall( )
end event

type cb_closeall from mt_u_commandbutton within w_atobviac_calc_calculation
boolean visible = false
integer x = 306
integer y = 116
integer width = 146
integer height = 80
integer taborder = 120
string text = "..x."
end type

event clicked;call super::clicked;wf_cpact_close(true)
end event

type cb_compactcalc from commandbutton within w_atobviac_calc_calculation
boolean visible = false
integer x = 759
integer y = 116
integer width = 146
integer height = 80
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Calc"
end type

event clicked;uo_calculation.uo_calc_compact.dw_calc_summary.accepttext()
uo_calculation.uo_calc_compact.dw_cargo_summary.accepttext()
uo_calculation.uo_calc_compact.dw_dischports.accepttext()
uo_calculation.uo_calc_compact.dw_loadports.accepttext()
uo_calculation.setredraw(false)
uo_calculation.uo_calc_cargos.uf_deactivate()
uo_calculation.uf_calculate() 
uo_calculation.uf_select_page(5)
uo_calculation.setredraw(true)

uo_calculation.uo_calc_compact.of_init_data()
end event

type cb_wingrow from commandbutton within w_atobviac_calc_calculation
integer x = 69
integer y = 116
integer width = 69
integer height = 80
integer taborder = 110
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = ">"
end type

event clicked;wf_cpact_change_winsize(1)
end event

type cb_copywindow from commandbutton within w_atobviac_calc_calculation
boolean visible = false
integer x = 608
integer y = 116
integer width = 146
integer height = 80
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Copy"
end type

event clicked;wf_cpact_copy()

end event

type cb_winshrink from commandbutton within w_atobviac_calc_calculation
integer x = 5
integer y = 116
integer width = 69
integer height = 80
integer taborder = 100
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "<"
end type

event clicked;wf_cpact_change_winsize(-1)
wf_updatetitle( )


end event

type cb_schedule from commandbutton within w_atobviac_calc_calculation
integer x = 2994
integer y = 28
integer width = 279
integer height = 108
integer taborder = 90
integer textsize = -8
string text = "Sched&uler"
end type

event clicked;s_scheduler_parm lstr_parm
long ll_row
datawindow ldw

if m_calcmain.m_menutop2.m_save.enabled then
	MessageBox("Information", "Please save Calculation before accessing Scheduler")
else
	ldw = uo_calculation.uo_calc_summary.dw_calc_summary
	ll_row = ldw.getrow()
	if ll_row > 0 then
		lstr_parm.l_calc_id = ldw.getItemNumber(ll_row, "cal_calc_id")
		lstr_parm.l_fix_id = ldw.getItemNumber(ll_row, "cal_calc_fix_id")
		lstr_parm.dt_voyage_start = ldw.getItemDateTime(ll_row, "cal_calc_start_date")
		openwithparm(w_calc_schedule, lstr_parm)
	else
		MessageBox("Error", "No Calculation data available!")
	end if
end if
end event

type cb_calculate from uo_cb_base within w_atobviac_calc_calculation
integer x = 2139
integer y = 28
integer width = 279
integer taborder = 60
string text = "&Calculate"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Asks the calculation object to calculate

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
uo_calculation.uf_deactivate()
uo_calculation.uf_calculate() 

end event

type cb_select_vessel from uo_cb_base within w_atobviac_calc_calculation
integer x = 814
integer y = 28
integer width = 91
integer height = 80
integer taborder = 10
string text = "?"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : The user can change the vessel by clicking on this button

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Call WF_SELECT_VESSEL
wf_select_vessel()
wf_updatemenu(true)


end event

type cb_summary from uo_cb_base within w_atobviac_calc_calculation
integer x = 987
integer y = 28
integer width = 283
integer taborder = 20
string text = "S&ummary"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Selects the summary page.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
uo_calculation.uf_select_page(1)
end event

type cb_itinerary from uo_cb_base within w_atobviac_calc_calculation
integer x = 1563
integer y = 28
integer width = 283
integer taborder = 40
string text = "&Itinerary"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Selects the itineray page

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

uo_calculation.uf_select_page(2)

end event

type cb_cargo from uo_cb_base within w_atobviac_calc_calculation
integer x = 1275
integer y = 28
integer width = 283
integer taborder = 30
string text = "C&argo"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description: Selects the cargo page, by calling UF_SELECT_CARGO with -1 as 
 				  argument	

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
uo_calculation.uf_select_cargo(-1)

end event

type cb_result from uo_cb_base within w_atobviac_calc_calculation
integer x = 1851
integer y = 28
integer width = 283
integer taborder = 50
string text = "&Result"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Selects the result page

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

uo_calculation.uf_select_page(4)
end event

type ddlb_cargo from dropdownlistbox within w_atobviac_calc_calculation
integer x = 2469
integer y = 28
integer width = 494
integer height = 496
integer taborder = 70
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean sorted = false
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Selects the cargo given as argument INDEX

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


uo_calculation.uf_select_cargo(index)

end event

type cb_wizard from uo_cb_base within w_atobviac_calc_calculation
boolean visible = false
integer x = 987
integer y = 28
integer width = 283
integer taborder = 80
string text = "Wi&zard"
end type

on clicked;call uo_cb_base::clicked;uo_calculation.uf_select_page(1)
end on

type sle_vessel from uo_sle_base within w_atobviac_calc_calculation
integer x = 23
integer y = 28
integer width = 791
integer height = 80
integer taborder = 0
long backcolor = 32430488
boolean displayonly = true
end type

type cb_debug from commandbutton within w_atobviac_calc_calculation
boolean visible = false
integer x = 18
integer y = 28
integer width = 183
integer height = 80
integer taborder = 160
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Debug"
end type

on clicked;
CHOOSE CASE  MessageBox("Debug", "Show u_calc_nvo data ?", Exclamation!, YesNoCancel!)
	CASE 1
		 wf_debug_u_calc_nvo()
	CASE 2
		// Do noting
	CASE 3
		Return
END CHOOSE


end on

type uo_calculation from u_atobviac_calculation within w_atobviac_calc_calculation
integer y = 216
integer width = 4613
integer height = 2400
integer taborder = 170
end type

event ue_page_changed;call super::ue_page_changed;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : This event happens whenever uo_calculation changes the current page, 
 					e.g. when updating and the database returns an error. This event
					selects updates the buttons, so they reflect the current page shown.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_page_no

// Get the page no. from the message object
li_page_no = Message.WordParm

// If the wizard is visible (checked by the CB_WIZARD button) then 
// process the following code.
If cb_wizard.Visible Then
	cb_wizard.enabled = li_page_no = 4
	cb_result.enabled = not cb_wizard.enabled

	CHOOSE CASE li_page_no
		CASE 1,2,3
			cb_calculate.Default = true
			cb_calculate.SetFocus()
		CASE 4
			cb_wizard.Default = true
			cb_wizard.SetFocus()
	END CHOOSE
	
Else
	// This code is processed if the Wizard is not active.
	cb_summary.enabled = li_page_no <> 1
	cb_itinerary.enabled = li_page_no <> 2
	cb_cargo.enabled = li_page_no <> 3
	cb_result.enabled = li_page_no <> 4

	// Update the name of the groupbox (gb_page) and the buttons
	// depending on the current page.
	CHOOSE CASE li_page_no
		CASE 1
			cb_cargo.Default = true
		CASE 2
			cb_calculate.Default = true
			cb_calculate.SetFocus()
		CASE 3
			CHOOSE CASE uo_calculation.uf_get_ballast_voyage()
				CASE false
					cb_itinerary.Default = true
				CASE true
					//
			END CHOOSE
		CASE 4
			cb_cargo.Default = true
			cb_cargo.SetFocus()
	END CHOOSE
End if
end event

event ue_calc_changed;call super::ue_calc_changed;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when something is changed in the calculation, by updating
 					the title, the menu and the cargo list in the drop-down cargo listbox

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

wf_updatetitle()
wf_updatemenu(true)
wf_update_cargo_list()

end event

event ue_show_cargo_row;call super::ue_show_cargo_row;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Updates the drop-down cargo listbox, when the current cargo changes

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

ddlb_cargo.text = uo_calculation.uf_get_cargo_description(uo_calculation.uf_get_cargo())

end event

event ue_cargo_row_changed;call super::ue_cargo_row_changed;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles when a cargo row number (current cargo) has changed, by
 					changing the current cargo in the cargo drop-down listbox

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_tmp

ll_tmp = Message.WordParm
If (ll_tmp > 0) And (ll_tmp <= uo_calculation.uf_get_no_cargos()) Then
	ddlb_cargo.text = uo_calculation.uf_get_cargo_description(ll_tmp)
End if
end event

on uo_calculation.destroy
call u_atobviac_calculation::destroy
end on

event ue_rightclick;call super::ue_rightclick;
parent.event ue_rightclick(as_object)


end event

type r_1 from rectangle within w_atobviac_calc_calculation
integer linethickness = 4
long fillcolor = 22628899
integer width = 4608
integer height = 216
end type

