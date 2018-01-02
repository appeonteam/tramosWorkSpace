$PBExportHeader$w_calc_calculation.srw
$PBExportComments$Calculation main window
forward
global type w_calc_calculation from mt_w_sheet_calc
end type
type cb_schedule from commandbutton within w_calc_calculation
end type
type cb_calculate from uo_cb_base within w_calc_calculation
end type
type cb_select_vessel from uo_cb_base within w_calc_calculation
end type
type cb_summary from uo_cb_base within w_calc_calculation
end type
type cb_itinerary from uo_cb_base within w_calc_calculation
end type
type cb_cargo from uo_cb_base within w_calc_calculation
end type
type cb_result from uo_cb_base within w_calc_calculation
end type
type st_vessel from uo_st_base within w_calc_calculation
end type
type ddlb_cargo from dropdownlistbox within w_calc_calculation
end type
type cb_wizard from uo_cb_base within w_calc_calculation
end type
type sle_vessel from uo_sle_base within w_calc_calculation
end type
type cb_debug from commandbutton within w_calc_calculation
end type
type uo_calculation from u_calculation within w_calc_calculation
end type
end forward

global type w_calc_calculation from mt_w_sheet_calc
integer x = 23
integer y = 56
integer width = 4608
integer height = 2568
string title = "Calculation"
boolean maxbox = false
boolean resizable = false
event ue_sensitivityitem pbm_custom42
event ue_loadports pbm_custom05
event ue_dischports pbm_custom06
event ue_summary pbm_custom07
event ue_claims_item pbm_custom08
cb_schedule cb_schedule
cb_calculate cb_calculate
cb_select_vessel cb_select_vessel
cb_summary cb_summary
cb_itinerary cb_itinerary
cb_cargo cb_cargo
cb_result cb_result
st_vessel st_vessel
ddlb_cargo ddlb_cargo
cb_wizard cb_wizard
sle_vessel sle_vessel
cb_debug cb_debug
uo_calculation uo_calculation
end type
global w_calc_calculation w_calc_calculation

type prototypes
// Subroutine SetWindowLong(Int Handle, Int Index, Long Value) library 'user.exe'
FUNCTION integer GetAsyncKeyState(long vkey) LIBRARY "User32.dll"
end prototypes

type variables
long	il_vessel_id, il_clarkson_id
Long il_calc_id
Boolean ib_loaded
constant integer ii_MAX_INSTANCES = w_atobviac_calc_calculation.ii_MAX_INSTANCES
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
public subroutine documentation ()
public function integer wf_validation_profit_center (ref integer ii_not_open)
public function integer wf_checkmaxinstances ()
end prototypes

event ue_sensitivityitem;call super::ue_sensitivityitem;/************************************************************************************

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
		OpenWithParm(w_calc_sensitivity, uo_calculation)
	End if
Else
	MessageBox("Information","It is not possible to do a Sensitivity Analysis on a Ballast Voyage.")
End if

end event

event ue_loadports;call super::ue_loadports;/************************************************************************************

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

 Description : Updates the window title with calculation name, status and calculated status

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

String ls_tmp

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
	CASE 5
		ls_tmp = "Calculated"
	CASE 6	
		ls_tmp = "Estimated"
END CHOOSE

// Create the first part of the window title
ls_tmp += " Calcule ["+uo_calculation.uf_get_calculation_title()+"]"

// Add information about modified and calculated status
If uo_calculation.ib_modified Then ls_tmp += " (modified)"
If uo_calculation.ib_calculated Then ls_tmp += " (calculated)" Else ls_tmp += " (not calculated)"
ls_tmp += " (ID="+string(il_calc_id)+")"

// and set the title
This.Title = ls_tmp

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
		ls_tmp += "laytime_allowed: "+String(lstr_dem_des_data[li_count].laytime_allowed) + " other purpos:"+ String(lstr_dem_des_data[li_count].d_other_allowed) +"~r~n"
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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Integer li_status
Boolean lb_tmp

// Allow only updates, if the current menu is the calculation menu
If Upper(w_tramos_main.menuname) = "M_CALCMAIN" Then

	// Get the status from the calculation. This is used for additional
	// checking for the menuitems.
	
	li_status = uo_calculation.uf_get_status(0)

	m_calcmain.m_menutop2.m_close.enabled = ab_enabled
	m_calcmain.m_menutop2.m_new.enabled = (ab_enabled) and (li_status<>4) and (li_status<>6) and (not uo_calculation.uf_get_ballast_voyage())

	m_calcmain.m_menutop2.m_save.enabled =ab_enabled and uo_calculation.ib_modified
	m_calcmain.m_menutop2.m_saveas.enabled =ab_enabled
	m_calcmain.m_menutop2.m_status.enabled = (ab_enabled) and (li_status<4)
	m_calcmain.m_menutop2.m_delete.enabled = true and (li_status<>4) and (li_status<>6)
	m_calcmain.m_menutop3.m_cp.enabled = ab_enabled and (il_vessel_id>0 or il_clarkson_id>0)
	m_calcmain.m_menutop3.m_fixture.enabled = ab_enabled and (li_status<>4) and (li_status<>6)
	m_calcmain.m_menutop3.m_print.enabled = ab_enabled
	m_calcmain.m_menutop3.m_sensitivity.enabled = ab_enabled
	m_calcmain.m_menutop3.m_sendcalctoweeklyfixture.enabled = ab_enabled

	m_calcmain.m_menutop2.m_ballastvoyage.enabled = ab_enabled and (uo_calculation.uf_get_calc_id()=0) and (not cb_wizard.visible)
	m_calcmain.m_menutop2.m_ballastvoyage.checked = uo_calculation.uf_get_ballast_voyage()

	lb_tmp = ab_enabled and (uo_calculation.uf_get_wizard())
	m_calcmain.m_menutop2.m_wizard.enabled = lb_tmp
	m_calcmain.m_menutop2.m_wizard.checked = lb_tmp

	m_calcmain.m_menutop3.m_claims.enabled = li_status > 4
	
	m_calcmain.m_menutop2.m_unlockcalculation.enabled = (li_status = 5) // And (uo_global.ii_access_level = 3)
End if



end subroutine

public subroutine wf_select_vessel ();/************************************************************************************

 Arthur Andersen PowerBuilder Development
 Author    :Teit Aunt 
   
 Date       : 24-7-96

 Description : Sets a new vessel Id, either as vessel_type, vessel or clarkson. 
 					If no ID given, a search window 	will prompt the user for vessel.

 Arguments : 	AL_VESSEL_TYPE_ID as Long
					AL_VESSEL_ID as Long
					AL_CLARKSON_ID as long

 Returns   :   None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
24-7-96		1.0 			TA		Initial version
						MI		Smaller fixes
************************************************************************************/
long ll_vessel_nr, ll_null

uo_calculation.uf_get_vessel(ll_null, ll_vessel_nr, ll_null)

OpenWithParm(w_calc_vessel_list, ll_vessel_nr)

setnull(ll_null)

ll_vessel_nr = Message.doubleparm

If ll_vessel_nr > 0 Then
	
	uo_calculation.uf_set_vessel(ll_null, ll_vessel_nr, ll_null)
	
	sle_vessel.text = uo_calculation.uf_get_vessel_name()
	il_vessel_id    = ll_vessel_nr
	il_clarkson_id  = 0
else
	il_vessel_id   = 0
	il_clarkson_id = 0
End if







end subroutine

public function boolean uf_weekly_fix_ok (long al_calc_id);// SEE IF THE CALCULE NEEDS TO BE REPORTED TO THE WEEKELY FIXTURE LIST BEFORE IT CAN BE FIXED

integer li_row_count, li_report_before, li_return_value, li_vessel_nr
boolean lb_ok
n_ds lds_profit, lds_pool, lds_report

SELECT CAL_CALC.CAL_CALC_VESSEL_ID  
INTO :li_vessel_nr  
FROM CAL_CALC  
WHERE CAL_CALC.CAL_CALC_ID = :al_calc_id;
Commit;

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
			li_row_count = lds_report.Retrieve(al_calc_id)			
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

public subroutine documentation ();/********************************************************************
   ObjectName: mt_w_master
	
	<OBJECT>
	Ancestor object for all windows inside the mt framework
	</OBJECT>
   	<DESC>
		Contains standard settings along with functions utilizing helper services
		such as error and window style
	</DESC>
   	<USAGE>
		Do not directly inherit from this object.  use one of the child/descendents instead
		which are designed to fit requirements. 
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
		Date    		CR-Ref		Author		Comments
		00/00/07		???    		RMO   		First Version
		29/07/11		CR2403		AGL			Added APPEON window/control style service functionality in new function 
										       		_setfontandcolor()
		02/08/11		CR2403		ZSW001		Added APPEON window/control style service functionality in new function 
										      		_setbackgroundcolor()
		29/08/11		N/A   		ZSW001		Add event ue_addignoredcolorandobject() 
		28/07/14		CR3421		KSH092		Add a validation on profit center of vessel and CP
		20/01/16		CR3381		XSZ004		Remove ship type and competitor vessel.
		04/04/16		CR4258		AGL027		Remove call to calculation conumption lookup window
		03/08/16		CR4219		LHG008		Accuracy and improvement in DEM and DEV claims handling(CHO)(REF_CR4111)
		24-11-16		CR3145		LHG008		Enable Tramos to have up to 25 calculations open at the same time
********************************************************************/

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
		28/07/14	CR3519        KSH092  First Version
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
   
elseif il_clarkson_id > 0 then
	
	SELECT PC_NR
   INTO :ll_vessel_pc
   FROM CAL_CLAR
   WHERE CAL_CLRK_ID = :il_clarkson_id;
   
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
				if li_status < 4 then
					ll_message = ll_message + 1

               uo_calculation.uf_set_cerp_id( ll_row, ll_null)
							 
			   else
					
				   ii_not_open = ii_not_open + 1
				end if
			end if 
			  
	   end if
			
  end if
	
	 if ll_message > 0 then//working
		 wf_updatemenu(true)
		 
		 messagebox('Validation',"C/P detached because you do not have access to the C/P's profit center: "+ls_cp_pc_name+ ".")
	end if
	if ii_not_open > 0 then//fixture
		messagebox('Validation',"You do not have access to the C/P's profit center: "+ls_cp_pc_name+".")
	end if
end if
return ll_not_equal

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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

s_calc_saveas lstr_calc_saveas
Long 			ll_tmp
datetime		ldt_null;setNull(ldt_null)

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
	uo_calculation.uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_expiry_date", relativeDate(today(), 180))	
	uo_calculation.uo_calc_summary.dw_calc_summary.SetItem(1,"cal_calc_start_date", ldt_null)	
	uo_calculation.uf_saveas(lstr_calc_saveas.s_description,lstr_calc_saveas.i_calctype,true)

	// Enable the select vessel and calculate button
	cb_select_vessel.enabled = true
	cb_calculate.enabled = true

	// Request the manager to re-retrieve data next time it's activated
	wf_manager_retrieve()
	
	// and update the title
	wf_updatetitle()
End if


end event

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 15-07-96

 Description : Calculation main window. Receives a LSTR_OPENCALC_PARM, that
 					contains information about what to load (New calculation,
					New wizard or existing calculation). 

 Arguments : LSTR_OPENCALC_PARM as S_OPENCALC_PARM

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
15-07-96		1.0 			MI		Initial version
25-07-96										Added closequery and saveas  
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

// Get the LSTR_OPENCALC_PARM from the message object
lstr_opencalc_parm = Message.PowerObjectParm
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
	End if
End if

// This was an early attempt to disable the resize...
//SetWindowLong(Handle(This), -16, 1456144384)

// Post the master retrieve event
PostEvent("ue_retrieve")


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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_result 
LONG ll_calc_id
Boolean lb_ok

s_voyage_return lstr_return

// See if the vessel is attached to a pool where the calcule needs to be send to the weekely fixture list before it can be fixed

ll_calc_id = uo_calculation.uo_calc_summary.dw_calc_summary.getItemNumber(1, "cal_calc_id")

 Select count(*) into :li_result
    From CAL_CALC A,CAL_CARG B,VESSELS C,CAL_CERP D
    where A.CAL_CALC_VESSEL_ID = C.VESSEL_NR and A.CAL_CALC_ID =B.CAL_CALC_ID and A.CAL_CALC_STATUS < 4
            and B.CAL_CERP_ID = D.CAL_CERP_ID and C.PC_NR <> D.CAL_CERP_PROFIT_CENTER_NO
            and A.CAL_CALC_ID = :ll_calc_id;

if li_result>0 then
	Messagebox("System Info", "The CP’s profit center must be the same as the vessel’s profit center.")
	return -1
end if

lb_ok = uf_weekly_fix_ok(ll_calc_id)

IF lb_ok = TRUE THEN
	// Open the fixture window
	OpenWithParm(w_calc_fixture, uo_calculation)
	
	lstr_return = message.powerobjectparm
	li_result = lstr_return.al_return	
	//li_result = Message.DoubleParm

	// Ask the manager to re-retrieve data upon next activation
	wf_manager_retrieve()

	// And close the calculation if the fixture went through
	If li_result = 1 Then Close(This)
ELSE
	Messagebox("Not send to fixture list", "The selected calcule needs to be send to weekly fixture list, before it can be fixed")
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

If ib_loaded then wf_updatemenu(true)
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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
15/03/16    CR4114   SSX014   Remove Yield() to avoid crashing
************************************************************************************/
long		ll_vessel_type
integer li_leftShift, li_rightShift

// Retrieve data or insert blank calculation. The IB_LOADED is current false

uo_calculation.uf_retrieve(il_calc_id)

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
	If not (li_leftShift < 0 or li_rightShift < 0) then wf_select_vessel()  
Else
	// We're retrieving an exisiting calculation. Update the Vessel name in
	// the vessel name box, the select vessel button 
	sle_vessel.text = uo_calculation.uf_get_vessel_name()
	uo_calculation.uf_get_vessel(ll_vessel_type, il_vessel_id, il_clarkson_id)
	cb_select_vessel.enabled = not uo_calculation.uo_calc_cargos.ib_vessellocked

	// Update the cargo list
	wf_update_cargo_list()
	
	// And change the text on the "cargo" button to "data", if it's a ballast voyage
	If uo_calculation.uf_get_ballast_voyage() Then
		cb_cargo.text = "&Data"
	End if

	// Disable calculate button if this is a fixtured calculation
	if uo_calculation.uf_get_status(0)=4 Then cb_calculate.enabled = false
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
	st_vessel.visible = lb_tmp
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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
24/11/16 	CR3145	LHG008		Enable Tramos to have up to 25 calculations open at the same time
************************************************************************************/

if _ib_forceclose then return

Integer li_return

// If calculation modified then prompt user for action
If uo_calculation.ib_modified Then
	CHOOSE CASE MessageBox("Warning", "The calcule have been changed. ~rSave calcule before closing ?", Exclamation!, YesNoCancel!)
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
End if

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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Boolean lb_result

// Call save
lb_result= uo_calculation.uf_save(true) 

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
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
integer li_not_open
long ll_not_equal
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
uo_calculation.uf_update(0)
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

on w_calc_calculation.create
int iCurrent
call super::create
this.cb_schedule=create cb_schedule
this.cb_calculate=create cb_calculate
this.cb_select_vessel=create cb_select_vessel
this.cb_summary=create cb_summary
this.cb_itinerary=create cb_itinerary
this.cb_cargo=create cb_cargo
this.cb_result=create cb_result
this.st_vessel=create st_vessel
this.ddlb_cargo=create ddlb_cargo
this.cb_wizard=create cb_wizard
this.sle_vessel=create sle_vessel
this.cb_debug=create cb_debug
this.uo_calculation=create uo_calculation
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_schedule
this.Control[iCurrent+2]=this.cb_calculate
this.Control[iCurrent+3]=this.cb_select_vessel
this.Control[iCurrent+4]=this.cb_summary
this.Control[iCurrent+5]=this.cb_itinerary
this.Control[iCurrent+6]=this.cb_cargo
this.Control[iCurrent+7]=this.cb_result
this.Control[iCurrent+8]=this.st_vessel
this.Control[iCurrent+9]=this.ddlb_cargo
this.Control[iCurrent+10]=this.cb_wizard
this.Control[iCurrent+11]=this.sle_vessel
this.Control[iCurrent+12]=this.cb_debug
this.Control[iCurrent+13]=this.uo_calculation
end on

on w_calc_calculation.destroy
call super::destroy
destroy(this.cb_schedule)
destroy(this.cb_calculate)
destroy(this.cb_select_vessel)
destroy(this.cb_summary)
destroy(this.cb_itinerary)
destroy(this.cb_cargo)
destroy(this.cb_result)
destroy(this.st_vessel)
destroy(this.ddlb_cargo)
destroy(this.cb_wizard)
destroy(this.sle_vessel)
destroy(this.cb_debug)
destroy(this.uo_calculation)
end on

type st_hidemenubar from mt_w_sheet_calc`st_hidemenubar within w_calc_calculation
end type

type cb_schedule from commandbutton within w_calc_calculation
integer x = 2866
integer y = 16
integer width = 302
integer height = 108
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
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

type cb_calculate from uo_cb_base within w_calc_calculation
integer x = 2030
integer y = 16
integer width = 279
integer taborder = 70
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

uo_calculation.uf_calculate() 

end event

type cb_select_vessel from uo_cb_base within w_calc_calculation
integer x = 750
integer y = 16
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

type cb_summary from uo_cb_base within w_calc_calculation
integer x = 859
integer y = 16
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

type cb_itinerary from uo_cb_base within w_calc_calculation
integer x = 1445
integer y = 16
integer width = 283
integer taborder = 50
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

type cb_cargo from uo_cb_base within w_calc_calculation
integer x = 1152
integer y = 16
integer width = 283
integer taborder = 40
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

type cb_result from uo_cb_base within w_calc_calculation
integer x = 1737
integer y = 16
integer width = 283
integer taborder = 60
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

type st_vessel from uo_st_base within w_calc_calculation
integer x = 18
integer y = 32
integer width = 165
integer height = 64
long backcolor = 81324524
string text = "Vessel:"
alignment alignment = left!
end type

type ddlb_cargo from dropdownlistbox within w_calc_calculation
integer x = 2341
integer y = 16
integer width = 494
integer height = 496
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
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

type cb_wizard from uo_cb_base within w_calc_calculation
boolean visible = false
integer x = 1061
integer y = 16
integer width = 283
integer taborder = 30
string text = "Wi&zard"
end type

on clicked;call uo_cb_base::clicked;uo_calculation.uf_select_page(1)
end on

type sle_vessel from uo_sle_base within w_calc_calculation
integer x = 201
integer y = 16
integer width = 530
integer height = 80
integer taborder = 0
long backcolor = 16776960
boolean displayonly = true
end type

type cb_debug from commandbutton within w_calc_calculation
boolean visible = false
integer y = 16
integer width = 183
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
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

type uo_calculation from u_calculation within w_calc_calculation
integer x = 18
integer y = 128
integer width = 4571
integer height = 2100
integer taborder = 110
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
call u_calculation::destroy
end on

