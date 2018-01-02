$PBExportHeader$w_calc_manager.srw
$PBExportComments$Calculation open (manager) window
forward
global type w_calc_manager from mt_w_sheet_calc
end type
type cb_refresh from uo_cb_base within w_calc_manager
end type
type cbx_slf from checkbox within w_calc_manager
end type
type st_profit from statictext within w_calc_manager
end type
type dw_select_profitcenter from datawindow within w_calc_manager
end type
type cbx_stf from checkbox within w_calc_manager
end type
type cbx_swf from checkbox within w_calc_manager
end type
type cbx_scf from checkbox within w_calc_manager
end type
type cbx_sff from checkbox within w_calc_manager
end type
type cbx_sef from checkbox within w_calc_manager
end type
type cb_filter from commandbutton within w_calc_manager
end type
type dw_todate from datawindow within w_calc_manager
end type
type dw_fromdate from datawindow within w_calc_manager
end type
type st_5 from statictext within w_calc_manager
end type
type st_no_rows from statictext within w_calc_manager
end type
type dw_filter from u_datawindow_sqlca within w_calc_manager
end type
type cbx_collapsed from uo_cbx_base within w_calc_manager
end type
type cb_new from uo_cb_base within w_calc_manager
end type
type mle_1 from multilineedit within w_calc_manager
end type
type cb_recalc from commandbutton within w_calc_manager
end type
type cbx_compact from mt_u_checkbox within w_calc_manager
end type
type dw_manager from u_datawindow_sqlca within w_calc_manager
end type
type st_4 from statictext within w_calc_manager
end type
type sle_1 from mt_u_singlelineedit within w_calc_manager
end type
end forward

shared variables
Boolean sb_first = true
end variables

global type w_calc_manager from mt_w_sheet_calc
integer y = 232
integer width = 4416
integer height = 2568
string title = "Calculation Manager"
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
string icon = "images\calcmenu.ICO"
boolean ib_enablef1help = false
event ue_setfilter pbm_custom70
event ue_refreshafterdelete ( unsignedlong wparam,  long lparam )
event ue_create_loadload_calculation ( )
event ue_contextmenuclick ( integer ai_menuselected )
cb_refresh cb_refresh
cbx_slf cbx_slf
st_profit st_profit
dw_select_profitcenter dw_select_profitcenter
cbx_stf cbx_stf
cbx_swf cbx_swf
cbx_scf cbx_scf
cbx_sff cbx_sff
cbx_sef cbx_sef
cb_filter cb_filter
dw_todate dw_todate
dw_fromdate dw_fromdate
st_5 st_5
st_no_rows st_no_rows
dw_filter dw_filter
cbx_collapsed cbx_collapsed
cb_new cb_new
mle_1 mle_1
cb_recalc cb_recalc
cbx_compact cbx_compact
dw_manager dw_manager
st_4 st_4
sle_1 sle_1
end type
global w_calc_manager w_calc_manager

type variables
Private Boolean ib_retrieve
Private String is_filter, is_creator, is_status
Private Long il_current_calc_id = 0
Private Long il_next_calc_id = 0 //used to move the cursor to the next calculation when a calculation is deleted
u_dddw_search iuo_dddw_search_charterer
Integer ii_current_height, ii_original_width
Private Boolean ib_first = True

n_service_manager inv_serviceMgr
n_dw_style_service   inv_style
private integer _ii_hiderecalc=0
end variables

forward prototypes
public subroutine wf_copymove (integer ai_function_code)
public subroutine wf_setfilter ()
public subroutine wf_setsort ()
public subroutine wf_addfilter (string as_field, string as_value)
public subroutine wf_refreshafterdelete ()
public subroutine wf_updatemenu (boolean ab_enable)
public subroutine documentation ()
end prototypes

event ue_setfilter;call super::ue_setfilter;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the UE_SETFILTER event, by calling the WF_SETFILTER

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

wf_setfilter()
end event

event ue_refreshafterdelete(unsignedlong wparam, long lparam);/************************************************************************************

 Deloitte PowerBuilder Development

 Author    : MIS 
   
 Date       : 2004

 Description : Refresh the dw_manager DataWindow after a calculation has been deletet 
 
 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
long ll_row


If il_next_calc_id > 0 Then
	ll_row = dw_manager.Find("cal_calc_cal_calc_ID = "+ String(il_next_calc_id),0,99999)
	If ll_row > 0 Then 
		dw_manager.uf_select_row(ll_row)
	END IF
END IF
end event

event ue_create_loadload_calculation();/* This event should call functions to create a loadload calculation based on the estimated calculation */
long 		ll_row, ll_calc_id
integer	li_status
u_atobviac_loadload_calculation  lnv_loadcalc

ll_row = dw_manager.GetRow() 
If ll_row > 0 Then
	li_status= dw_manager.GetItemNumber(ll_row, "cal_calc_cal_calc_status")
	ll_calc_id= dw_manager.GetItemNumber(ll_row, "cal_calc_cal_calc_id")
	choose case li_status
		case 5, 6			/* Estimated or Calculated */
			lnv_loadcalc = create u_atobviac_loadload_calculation 
			lnv_loadcalc.of_create_new_loadload(ll_calc_id, li_status  )
			destroy lnv_loadcalc
			postevent("ue_refresh")
		case else
			MessageBox("Information", "You can't create LoadLoad calculation unless the active calculation is Estimated or Actual")
	end choose
end if
end event

event ue_contextmenuclick(integer ai_menuselected);messagebox("BOO",ai_menuselected)
end event

public subroutine wf_copymove (integer ai_function_code);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Copies/moves cargoes between calculations. AI_FUNCTION_CODE 
 					determines if it's a copy or a move, and is passed on to the
					W_CALC_COPY_MOVE window. 	
					
					AI_FUNCTION_CODE:
					1 = Copy
					2 = Move

 Arguments : AI_FUNCTION_CODE as integer

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_row, ll_tmp
s_calc_copymove_parm lstr_parm

// Get the current row, and check that it's > 0
ll_row = dw_manager.GetRow()
If ll_row > 0 Then
	
	// Show errorbox if the user is trying to move a cargo on a fixture, calculated
	// or estimated calculation
	If (dw_manager.GetItemNumber(ll_row,"cal_carg_cal_carg_status")>=4) And (ai_function_code=2) Then
		MessageBox("Error", "You cannot move fixtured cargos")
		Return
	End if

	// Pass the AI_FUNCTION_CODE, CARGO_ID and CALCULATION_ID to the W_CALC_COPY_MOVE
	// window
	lstr_parm.i_function_code = ai_function_code
	lstr_parm.l_cargo = dw_manager.GetItemNumber(ll_row, "cal_carg_cal_carg_id")
	il_current_calc_id = dw_manager.GetItemNumber(ll_row, "cal_calc_cal_calc_id")
	lstr_parm.l_from_calc = il_current_calc_id
	lstr_parm.s_filter_create_user = dw_filter.getitemstring( 1,"creator")
	
	OpenWithParm(w_calc_copy_move, lstr_parm)

	// Get the return value. If it's 1, then a copy of move was done, and the
	// manager datawindow should be re-retrieved
	ll_tmp = Message.DoubleParm

	If ll_tmp = 1 Then PostEvent("ue_retrieve")
End if
end subroutine

public subroutine wf_setfilter ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Applies the filter to the manager datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

String ls_tmp, ls_voyage
Char ls_ch
Long ll_fix_id

// Turn redraw off
dw_manager.uf_redraw_off()

// The filter is build-up in the following code, so it finally contains
// all filter values.
//
// E.g.: CAL_CALC_CAL_CALC_STATUS = 1 AND 
//       VESSEL = "Maersk Josephine" AND
//       LEFT(UPPER(CAL_CARG_CAL_CARG_DESCRIPTION), 1, 7) = "BANANER"
//
// Note the use of LEFT and POS to do partial search in the description
//

// Reset the filter string
is_filter = ""

// Add vessel, startport and endport to the filter string
wf_addFilter("vessel", dw_filter.GetItemString(1,"vessel"))
wf_addfilter("ports_start_port", Upper(dw_filter.GetItemString(1,"first_port")))
wf_addfilter("ports_end_port", Upper(dw_filter.GetItemString(1,"last_port")))

// Add the description, allowing for partial search using "*"
ls_tmp = dw_filter.GetItemString(1,"description")
If Not(isnull(ls_tmp)) And (ls_tmp<>"") Then

	If not cbx_collapsed.checked then
		If Left(ls_tmp,1) = "*" Then
			is_filter += "(Pos(Upper(cal_carg_cal_carg_description), '" + Right(ls_tmp,Len(ls_tmp)-1) + "') > 0 or "
		Else
			is_filter += "(Left(Upper(cal_carg_cal_carg_description), " + String(Len(ls_tmp)) + ") = '"+ls_tmp+"' or  "
		End if

		ls_ch = ")"
	Else
		ls_ch = " "
	End if

	If Left(ls_tmp,1) = "*" Then
		is_filter += "Pos(Upper(cal_calc_cal_calc_description), '" + Right(ls_tmp,Len(ls_tmp)-1) + "') > 0"+ls_ch+" and "
	Else
		is_filter += "Left(Upper(cal_calc_cal_calc_description), " + String(Len(ls_tmp)) + ") = '"+ls_tmp+"'"+ls_ch+" and  "
	End if
End if

// If search for voyage, then retrieve all CALC and FIXTURE_ID's for that
// voyage number, is several ID's found, the add them with an or into
// the filter string, 
//
// e.g.:
// E.g.: CAL_CALC_CAL_CALC_STATUS = 1 AND 
//       VESSEL = "Maersk Josephine" AND
//       LEFT(UPPER(CAL_CARG_CAL_CARG_DESCRIPTION), 1, 7) = "BANANER" AND
//			(CAL_CALC_CAL_CALC_FIX_ID = 11 OR
//			 CAL_CALC_CAL_CALC_FIX_ID = 12 OR
//			 CAL_CALC_CAL_CALC_FIX_ID = 13)			 

ls_voyage = dw_filter.GetItemString(1,"voyage")
If not (isNull(ls_voyage)) And (ls_voyage <> "") Then

	DECLARE ll_fix_cursor CURSOR FOR
	SELECT DISTINCT CAL_CALC_FIX_ID
	FROM CAL_CALC
	WHERE CAL_CALC_ID IN
	(SELECT CAL_CALC_ID
 	FROM VOYAGES
 	WHERE (VOYAGE_NR = :ls_voyage) AND (CAL_CALC_ID >1));

	OPEN ll_fix_cursor;

	ls_tmp = ""

	DO WHILE SQLCA.SQLCode = 0
		FETCH ll_fix_cursor
		INTO :ll_fix_id;

		If SQLCA.SQLCode = 0 Then
			If ls_tmp <> "" Then ls_tmp += " or "
			ls_tmp += "CAL_CALC_CAL_CALC_FIX_ID = "+String(ll_fix_id)
		End if
	LOOP

	CLOSE ll_fix_cursor;
	COMMIT;

	If ls_tmp <> "" Then 
		ls_tmp = "("+ls_tmp+") and " 
	Else 
		MessageBox("Notice", "No calculations found with voyage no. "+String(ls_voyage))
		dw_filter.SetItem(1,"voyage", "")
	End if

	If ls_tmp <> "" Then is_filter += ls_tmp
End if

// If not collapsed wiew, then add the charterer into the filter string
If not cbx_collapsed.checked then
	ls_tmp = dw_filter.GetItemString(1, "charterer")
	If not isNull(ls_tmp) Then
		is_filter += "charterer="+ls_tmp+" and "
	End if
End if

//Profitcenter if any
dw_select_profitcenter.acceptText()
if not isNull(dw_select_profitcenter.getItemNumber(1, "pc_nr")) and dw_select_profitcenter.getItemNumber(1, "pc_nr") > 0 then
	is_filter += "pc_nr="+string(dw_select_profitcenter.getItemNumber(1, "pc_nr"))+" and "
end if

// If the lenght if the filterstring is > 4, then remove the last 5 char's
// which is the final " AND ".
If Len(is_filter) > 4 Then is_filter = Left(is_filter,Len(is_filter)-5)

// Unselect all rows
dw_manager.SelectRow(0,False)
// Apply the filter, refilter and to a groupcalc to get everything updated
dw_manager.SetFilter(is_filter)
dw_manager.Filter()
dw_manager.Groupcalc()

// Trigger a RetrieveEnd! event, so the rowcounter will be update
dw_manager.TriggerEvent(RetrieveEnd!)

// and turn redraw back on
dw_manager.uf_redraw_on()

end subroutine

public subroutine wf_setsort ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Applies the sorting order to the manager datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

String ls_tmp

// Turn redraw off
dw_manager.uf_redraw_off()

// Build the sorting string line-by-line. Finally it will contain all the
// sorting instructions, eg:
//
// VESSEL A, CAL_CALC_CAL_CALC_ID, CAL_CARG_CAL_CARG_ID
// 
// or
//
// CAL_CALC_CAL_CALC_LAST_EDITED A, CAL_CALC_CAL_CALC_ID, CAL_CARG_CAL_CARG_ID
//
// CALC_ID and CARG_ID MUST be specified in the string, for getting the 
// grouping of fixtured, estimated and calculated calculations to work

// add the mandatory CAL_CALC and CAL_CARG ID 
ls_tmp = ls_tmp + ", cal_calc_cal_calc_id, cal_carg_cal_carg_id"

// Unselect all rows, set the new sorting string, sort and do the group calc.
dw_manager.SelectRow(0,False)
dw_manager.SetSort(ls_tmp)
dw_manager.Sort()
dw_manager.groupcalc()

// Trigger a RetrieveEnd! event, to update the rownumber text
dw_manager.TriggerEvent(retrieveend!)

// and turn the redraw back on
dw_manager.uf_redraw_on()

end subroutine

public subroutine wf_addfilter (string as_field, string as_value);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Add the filter given in AS_VALUE to the field given in AS_FIELD. 
 					Enables the use of "*" in the beginning af the AS_VALUE for
					partial search. "*" is automatically implemented in the end.
					
					Example:
					AS_VALUE:			Allows:
					*GRAM					Program, Lettergram, Polygram, Gramophone
					GRAM					Gramophone

 Arguments : AS_VALUE, AS_FIELD as String

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
20-11-99	2.0		TEA	Retrieve modified to handle externalusers who has limited rights to view
								information in TRAMOS. They may only see specifik vessels and only on 
								existing calculations  
************************************************************************************/

// Check that value is given
If as_value<>"" and as_value<>"%" Then
	
	// If first character is a "*" then do the first partial search, otherwise do
	// the normal end-partial search
	If Left(as_value,1) = "*" Then
		is_filter += "Pos(Upper(" + as_field + "), '" + Right(as_value,Len(as_value)-1) + "') > 0 and "
	Elseif Left(as_value,1) = "%" Then
		is_filter += "(Upper(" + as_field + ") like '%" + Right(as_value,Len(as_value)-1) + "%') and "
	Else	
		is_filter += "Left(Upper(" + as_field + "), " + String(Len(as_value)) + ") = '"+as_value+"' and  "
	End if
End if

	
end subroutine

public subroutine wf_refreshafterdelete ();
end subroutine

public subroutine wf_updatemenu (boolean ab_enable);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Updates the menu, enabling/disabling the different menuitems. 
 					AB_ENABLE must be set to true, if the manager is the active window

 Arguments : AB_ENABLE as boolean

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Boolean lb_additional, lb_tmp

// Check if the CALCMENU is the current menu
If Upper(w_tramos_main.menuname)="M_CALCMAIN" Then
	
	// And update the different menuitems
	if ab_enable then  lb_additional = dw_manager.getRow()>0

	m_calcmain.m_menutop2.m_open.enabled = (lb_additional or (ab_enable = false))

	m_calcmain.m_menutop2.m_new.enabled = ab_enable
	m_calcmain.m_menutop2.m_close.enabled = ab_enable
	cb_new.enabled = ab_enable

	//m_calcmain.m_menutop2.m_copy.enabled = lb_additional

	if uo_global.ii_access_level < 3 Then
		lb_tmp = false
	Else
		lb_tmp = ab_enable
	End if

	//m_calcmain.m_menutop2.m_delete.enabled = lb_tmp

	m_calcmain.m_menutop2.m_refresh.enabled = ab_enable
End if


end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_calc_manager
	
	<OBJECT>
		Main window where user can select/create calculations
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
		Date    		Ref   	Author   	Comments
		00/00/07		?     	Name Here	First Version
		23/11/11		D-CALC	AGL      	Make sure user can only open 1 est/calc belonging to a single fixture
		26/07/12		CR2695	LGX001   	Add a refresh button
		28/08/14		CR3708	CCY018   	F1 help application coverage - fixed a problem
		12/09/14		CR3773	XSZ004   	Change icon absolute path to reference path
********************************************************************/
end subroutine

event ue_retrieve;call super::ue_retrieve;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1-9-96

 Description : Retrieves data for the manager

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_max, ll_count, ll_row, ll_color
String ls_tmp
DataWindowChild dwc_tmp
Long ll_id, ll_rows
integer li_status[] = {1,2,3,4,5,6,7}, li_status_nr=1, li_protect
date ld_date_from, ld_date_to

// Turn redraw off and show the hourglass
dw_manager.uf_redraw_off()
SetPointer(Hourglass!)

// If this is the FIRST time the UE_RETRIEVE is execute (IB_FIRST = TRUE) then
// share the two charterer fields with the charterer source
If ib_first Then
	dw_filter.GetChild("charterer", dwc_tmp)
	
	If uf_sharechild("dw_calc_chart_dddw", dwc_tmp)<>1 Then &
		MessageBox("System error", "Error sharing filter-lookup to charter-dddw")

	dw_manager.GetChild("charterer", dwc_tmp)
	If uf_sharechild("dw_calc_chart_dddw", dwc_tmp)<>1 Then &
		MessageBox("System error", "Error sharing charterer-lookup to charter-dddw")
End if

// Clear current filter
dw_manager.reset()
dw_manager.SetFilter("")
dw_manager.Filter()

ib_first = false

dw_fromdate.accepttext()
dw_todate.accepttext()


ld_date_from = dw_fromdate.GetItemDate(1, "date_value")
ld_date_to = dw_todate.GetItemDate(1, "date_value")
ld_date_to = date(relativedate(date(ld_date_to), 1))

// Retrieve data with CREATOR as the only database WHERE clause
// Changed July 02 by FR, so we now have 4 retrieval arguments
// is_creator = dw_filter.GetItemString(1, "creator")
is_creator = dw_filter.getitemstring( 1,"creator")
is_creator = "%"+is_creator+"%"
if isnull(is_creator) then is_creator = ""
dw_manager.Retrieve(is_creator, datetime(ld_date_from), li_status, datetime(ld_date_to), uo_global.is_userid )

// Now loop through all entries in the manager, updating the vessel name, if
// the vessel is a VESSEL_TYPE or CLARKSON. APM vessel name is automaticly retrieved
// together with the manager datawindow.
//
// The reason for this way to retrieve the vessel names is optimization: Doing
// the retrieval with joins to the three vessel tables is rahter slow. Instead
// it only got 1 join to the APM vessel table, and VESSEL_TYPES and CLARKSON
// ships are retrieved afterwards, since these ships usually ain't used that much.
ll_max = dw_manager.RowCount()
For ll_count = 1 To ll_max
	If isnull(dw_manager.GetItemString(ll_count, "vessel")) Then
		ll_id = dw_manager.GetItemNumber(ll_count, "cal_calc_cal_vest_type_id")
		if not IsNull(ll_id) Then  
			SELECT CAL_VEST_TYPE_NAME 
			INTO :ls_tmp
			FROM CAL_VEST
			WHERE CAL_VEST_TYPE_ID = :ll_id;
		Else
			ll_id = dw_manager.GetItemNumber(ll_count, "cal_calc_cal_clrk_id")
			If not isnull(ll_id) Then
				SELECT CAL_CLRK_NAME
				INTO :ls_tmp
				FROM CAL_CLAR
				WHERE CAL_CLRK_ID = :ll_id;
			Else
				ls_tmp = "????"
			End if
		End if

		dw_manager.SetItem(ll_count, "vessel", ls_tmp)
	End if
Next

// If there's any rows at all, then select the first one, and enable the open button.
// If there's no rows, then disable the open button
ll_rows = dw_manager.RowCount()

If ll_rows > 0 Then 
	dw_manager.uf_select_row(1)
	dw_manager.TriggerEvent(RowFocusChanged!)
End if

// Apply filter and sort the manager datawindow
// wf_setfilter()
cb_filter.triggerevent(Clicked!)
wf_setsort()

// Turn redraw on
dw_manager.uf_redraw_on()
SetPointer(Arrow!)

// If the user was positioned on a calculation before (IL_CURRENT_CALC_ID >0) then
// check if we can find it, and reposition the current row on that calculation.
If il_current_calc_id > 0 Then
	ll_row = dw_manager.Find("cal_calc_cal_calc_ID = "+ String(il_current_calc_id),0,99999)
	If ll_row > 0 Then 
		dw_manager.uf_select_row(ll_row)
	Else
		il_current_calc_id = 0
	End if
Else
	// Else select row 1
	dw_manager.uf_select_row(1)
End if

// If this is the FIRST time within TRAMOS' lifetime, then open the expiry window
If sb_first and uo_global.ii_access_level > 0 Then /* No access for External User and External Partner */
	mt_n_datastore lds_calc_expiry
	lds_calc_expiry = create mt_n_datastore
	lds_calc_expiry.dataobject = "d_calc_expiry"
	lds_calc_expiry.settransobject( sqlca)
	if lds_calc_expiry.retrieve(today(), uo_global.is_userid) > 0 then
		Openwithparm(w_calc_expiry, lds_calc_expiry)
	end if
	
	destroy lds_calc_expiry
	sb_first = false
End if

end event

event ue_deleteitem;call super::ue_deleteitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 20-9-96

 Description : Deletes cargo or the hole calculation if only one cargo is left.

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_status, li_tmp
Long ll_row, ll_tmp, ll_fix_id, ll_tmp_id, ll_next_fix_id, ll_test_row
String ls_tmp, ls_created_by
Long ll_current_calc_id_temp1, ll_current_calc_id_temp2, ll_loadload_calc_id
s_calc_manager_delete_parm lstr_parm 

// Get current row
ll_row = dw_manager.GetRow()
If ll_row > 0 Then

	// Get status and ID for current calculation
	li_status = dw_manager.GetItemNumber(ll_row, "cal_calc_cal_calc_status")
	il_current_calc_id = dw_manager.GetItemNumber(ll_row, "cal_calc_cal_calc_id")
	ls_created_by = dw_manager.GetItemString(ll_row, "cal_calc_cal_calc_created_by")
	
	// Check if the calculation is fixtured, estimated or calculated. The calculation
	// must only be deleted, if it's not used in operations.
	If li_status >=4  and li_status < 7 Then   /* 4=fixture, 5=estimated, 6=calculated */

		// If we're not on the estimated calculation, then load the estimated calcuation,
		// since Operations is hooked to that calculation
		If li_status <> 6 Then
	
			// Use the fixture ID to retrieve the estimated ID into IL_CURRENT_CALC_ID
			SELECT CAL_CALC_FIX_ID
			INTO :ll_fix_id
			FROM CAL_CALC
			WHERE CAL_CALC_ID = :il_current_calc_id;
			COMMIT;

			SELECT CAL_CALC_ID
			INTO :ll_tmp_id
			FROM CAL_CALC
			WHERE CAL_CALC_FIX_ID = :ll_fix_id And
				CAL_CALC_STATUS = 6;
			COMMIT;

			// Delete all calculation fixtured, estimated and calculated
			
			SELECT CAL_CALC_ID
			INTO :ll_current_calc_id_temp1
			FROM CAL_CALC
			WHERE CAL_CALC_FIX_ID = :ll_fix_id And
				CAL_CALC_STATUS = 6;
			COMMIT;

			IF li_status = 4 THEN
				SELECT CAL_CALC_ID
				INTO :ll_current_calc_id_temp2
				FROM CAL_CALC
				WHERE CAL_CALC_FIX_ID = :ll_fix_id And
					CAL_CALC_STATUS = 5;
				COMMIT;
			ELSE
				SELECT CAL_CALC_ID
				INTO :ll_current_calc_id_temp2
				FROM CAL_CALC
				WHERE CAL_CALC_FIX_ID = :ll_fix_id And
					CAL_CALC_STATUS = 4;
				COMMIT;
			END IF

			SELECT CAL_CALC_ID
			INTO :ll_loadload_calc_id
			FROM CAL_CALC
			WHERE CAL_CALC_FIX_ID = :ll_fix_id And
				CAL_CALC_STATUS = 7;
			COMMIT;

			If IsNull(ll_tmp_id) Then
				MessageBox("System Error", "Error retrieving ID for fixtured calculation")
				Return
			End if
		Else
			ll_tmp_id = il_current_calc_id

			// Delete all calculation fixtured, estimated and calculated

			SELECT CAL_CALC_FIX_ID 
			INTO :ll_fix_id
			FROM CAL_CALC
			WHERE CAL_CALC_ID = :il_current_calc_id;
			COMMIT;

			SELECT CAL_CALC_ID
			INTO :ll_current_calc_id_temp1
			FROM CAL_CALC
			WHERE CAL_CALC_FIX_ID = :ll_fix_id And
					CAL_CALC_STATUS = 4;
			COMMIT;
			
			SELECT CAL_CALC_ID
			INTO :ll_current_calc_id_temp2
			FROM CAL_CALC
			WHERE CAL_CALC_FIX_ID = :ll_fix_id And
					CAL_CALC_STATUS = 5;
			COMMIT;
			
			SELECT CAL_CALC_ID
			INTO :ll_loadload_calc_id
			FROM CAL_CALC
			WHERE CAL_CALC_FIX_ID = :ll_fix_id And
				CAL_CALC_STATUS = 7;
			COMMIT;
			
		End if

		// Get ID for next calulation 
		
		il_next_calc_id = il_current_calc_id
		ll_next_fix_id = ll_fix_id
		ll_test_row = 1
		
		DO UNTIL ll_next_fix_id <> ll_fix_id Or dw_manager.RowCount() < ll_row + ll_test_row
			il_next_calc_id = dw_manager.GetItemNumber(ll_row+ll_test_row, "cal_calc_cal_calc_id")
			
			SELECT CAL_CALC_FIX_ID 
			INTO :ll_next_fix_id
			FROM CAL_CALC
			WHERE CAL_CALC_ID = :il_next_calc_id;
			COMMIT;
			
			ll_test_row = ll_test_row + 1
		LOOP

		ll_test_row = 1 
		
		DO UNTIL ll_next_fix_id <> ll_fix_id OR ll_row - ll_test_row <= 0 
			il_next_calc_id = dw_manager.GetItemNumber(ll_row - ll_test_row, "cal_calc_cal_calc_id")
			
			SELECT CAL_CALC_FIX_ID 
			INTO :ll_next_fix_id
			FROM CAL_CALC
			WHERE CAL_CALC_ID = :il_next_calc_id;
			COMMIT;
			
			ll_test_row = ll_test_row + 1
		LOOP
				
		
		// See if any voyages is created in the VOYAGES table, that is hooked to this
		// calculation.
		SELECT VOYAGE_NR
		INTO :ls_tmp
		FROM VOYAGES
		WHERE CAL_CALC_ID = :ll_tmp_id;

		li_tmp = SQLCA.SQLCode;
		COMMIT;

		// If it's used, then return
		If li_tmp=0 Then
			MessageBox("Delete error", "This calculation is used on voyage "+ls_tmp+" and cannot be deleted")
			Return
		End if

		// Otherwise check if the user has administrator rights. If not reject the deletion
		If (uo_global.ii_access_level >= 3) or (ls_created_by = uo_global.is_userid) then  
			If MessageBox("Warning", "You are about to delete a fixtured, estimated and calculated cargo/calculation~r~n~r~nContinue ?", StopSign!, YesNo!, 2) = 2 Then
				Return
			End if
		Else
			MessageBox("Error", "You can not delete a fixtured, estimated or calculated cargo/calculation created by another user unless you are an administrator", StopSign!)
			Return
		End if
	Else
		// Otherwise check if the user has administrator rights. If not reject the deletion
		If (ls_created_by <> uo_global.is_userid) and (uo_global.ii_access_level <> 3) then  
			MessageBox("Error", "You can not delete cargo/calculation created by another user unless you are an administrator", StopSign!)
			Return
		End if
		
		IF dw_manager.RowCount() > ll_row THEN
			il_next_calc_id = dw_manager.GetItemNumber(ll_row+1, "cal_calc_cal_calc_id")
		ELSE
			IF dw_manager.Rowcount() > 1 THEN
				il_next_calc_id = dw_manager.GetItemNumber(ll_row - 1, "cal_calc_cal_calc_id")
			ELSE
				il_next_calc_id = il_current_calc_id
			END IF
		END IF
	End if

	// Get the number of cargoes,
	SELECT COUNT(*)
	INTO :ll_tmp
	FROM CAL_CARG
	WHERE CAL_CARG.CAL_CALC_ID = :il_current_calc_id;
	COMMIT;

	// and set up the S_CALC_MANAGER_DELETE_PARM to call the W_CALC_MANAGER_DELETE
	lstr_parm.i_no_cargoes = ll_tmp
	lstr_parm.s_calc_description = dw_manager.GetitemString(ll_row, "cal_calc_cal_calc_description")

	if (cbx_collapsed.checked) then
		if messagebox("Warning", "You are about to delete the calculation <" + lstr_parm.s_calc_description + ">~r~n~r~nContinue?",  StopSign!, YesNo!, 2) = 1 then
			ll_tmp = 2
		else
			return
		end if
	else
		lstr_parm.s_cargo_description = dw_manager.GetitemString(ll_row, "cal_carg_cal_carg_description")
		OpenWithParm(w_calc_manager_delete, lstr_parm)
		ll_tmp = Message.DoubleParm
	end if

	// Delete according to results from the W_CALC_MANAGER_DELETE;
	// 2 = Delete whole calculation
	// 1 = Delete selected cargo
	CHOOSE CASE ll_tmp
		CASE 2 // Delete calculation
			If li_status >=4 Then //You have to delete fixtured, estimated and calculated if you delete one of them
				f_delete_calculation(il_current_calc_id,0)
				f_delete_calculation(ll_current_calc_id_temp1,0)
				f_delete_calculation(ll_current_calc_id_temp2,0)
				if not isnull(ll_loadload_calc_id) and ll_loadload_calc_id > 0 then
					f_delete_calculation(ll_loadload_calc_id ,0)
				end if				
			Else
				f_delete_calculation(il_current_calc_id,0)
			END IF
		CASE 1
				f_delete_calculation(0, dw_manager.GetItemNumber(ll_row, "cal_carg_cal_carg_id"))
	CASE ELSE
			Return
	END CHOOSE

	// Post a new UE_RETRIEVE
	PostEvent("ue_retrieve")
	PostEvent("ue_refreshafterdelete")
End if

end event

event open;call super::open;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Author    : Martin Israelsen
 Date       : 15-07-96
 Description : Opens the manager for the calculation module. 
 Arguments : None
 Returns   : None  
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
15-07-96		1.0			MI		Initial version
25-07-96					MI		Added some filtering and vesselname  
30-10-96					MI		Added "load manager on startup" button
18-07-02					FR		Added new filter and retrieve functionality
30-08-10		23.01		JSU	Filters redesign
************************************************************************************/
String ls_tmp
long ll_date, ll_color
date ldt_date
integer li_days, li_protect
datawindowchild	ldwc_profitcenter

// Set the manager datawindow to process clicked event automatically
dw_manager.ib_auto=True

// FR180702
cbx_stf.checked = uo_global.ib_template
cbx_sef.checked = uo_global.ib_estimated
cbx_swf.checked = uo_global.ib_working
cbx_sff.checked = uo_global.ib_fixtured
cbx_scf.checked = uo_global.ib_calculated
cbx_slf.checked = uo_global.ib_loadload
cbx_collapsed.checked = uo_global.gb_collapsed

// Inserted by FR 19-08-02
If cbx_collapsed.Checked Then
	dw_manager.DataObject = "d_calc_manager_collapsed"
	dw_manager.settransobject(SQLCA)
	ll_color = rgb(236,236,236)
	li_protect = 1
Else
	dw_manager.DataObject = "d_calc_manager"
	dw_manager.settransobject(SQLCA)
	ll_color = 16777215
	li_protect = 0
End if

// Update the color and locked status for the charterer field
dw_filter.modify("charterer.background.color = "+String(ll_color)+" charterer.protect = "+String(li_protect))

li_days = uo_global.gi_days

dw_fromdate.insertrow(0)
dw_todate.insertrow(0)

ll_date = f_datetime2long(datetime(today(),now()))
ll_date = ll_date - (li_days*24*60*60)
ldt_date = date(f_long2datetime(ll_date))

dw_fromdate.setitem(1,"date_value" , ldt_date)
dw_todate.setitem(1,"date_value" , date(today()))

dw_select_profitcenter.insertRow(0)
dw_select_profitcenter.getchild( "pc_nr", ldwc_profitcenter )
ldwc_profitcenter.setTransObject(sqlca)
ldwc_profitcenter.POST retrieve( uo_global.is_userid )

// and post the UE_RETRIEVE event
PostEvent("ue_retrieve")

// Insert a row in the filter-datawindow
dw_filter.ScrollToRow(dw_filter.InsertRow(0))

// And set the creator in that filter
ls_tmp = Upper(uo_global.gs_creator)
// FR 180702
dw_filter.SetItem(1,"creator", ls_tmp)

// Enable the recalc button only if the user has developer=1 in the INI file
// cb_recalc.visible = uo_global.ib_developer  

// Create the search-as-you-type object for the charterer field
iuo_dddw_search_charterer = CREATE u_dddw_search
iuo_dddw_search_charterer.uf_setup(dw_filter, "charterer", "chart_n_1",true)

// And remember the current width & height for this window (used in the resize event)
ii_current_height = height
ii_original_width = width

// This code can expand the manager window to fill the whole screen
//If Height<w_tramos_main.mdi_1.height Then Height=w_tramos_main.mdi_1.height

// If user is external then limit functionality
If uo_global.ii_access_level = -1 THEN
	// Modified FR
	cbx_stf.checked = false
	cbx_stf.enabled = false
	cbx_swf.enabled = false
	cbx_swf.checked = false
	
	dw_filter.Modify("creator.Tabsequence = 0")
	dw_filter.Modify("creator.Background.color = "+String(rgb(236,236,236))+" ")
	dw_filter.Modify("charterer.Tabsequence = 0")
	dw_filter.Modify("charterer.Background.color = "+String(rgb(236,236,236))+" ")
	dw_filter.Modify("first_port.Tabsequence = 0")
	dw_filter.Modify("first_port.Background.color = "+String(rgb(236,236,236))+" ")
	dw_filter.Modify("last_port.Tabsequence = 0")
	dw_filter.Modify("last_port.Background.color = "+String(rgb(236,236,236))+" ")
	dw_filter.Modify("description.Tabsequence = 0")
	dw_filter.Modify("description.Background.color = "+String(rgb(236,236,236))+" ")
	dw_filter.Modify("voyage.Tabsequence = 0")
	dw_filter.Modify("voyage.Background.color = "+String(rgb(236,236,236))+" ")
End if

dw_manager.POST setFocus()

inv_serviceMgr.of_loadservice( inv_style, "n_dw_style_service")
inv_style.of_dwlistformater(dw_manager,false)
end event

event close;call super::close;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the close event, by updating the INI file with the current
 					settings for the manager.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

String ls_tmp

// Destroy the search object 
DESTROY iuo_dddw_search_charterer

// And write the current view settings down to the INI file

ls_tmp = dw_filter.GetItemString(1, "creator")
if  trim(ls_tmp) <> "" then 
	uo_global.gs_creator = ls_tmp
end if

end event

event activate;call super::activate;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the activate event for this window, by updating the main menu.
 					If the IB_RETRIEVE is true, a UE_RETRIEVE event will be posted, and
					the IB_RETRIEVE will be set to false.
 					
 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

wf_updatemenu(true)

If ib_retrieve Then 
	PostEvent("ue_retrieve")
	ib_retrieve = false
End if
end event

event ue_refresh;call super::ue_refresh;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles a UE_REFRESH sent by the mainmenu, by triggering a 
 					UE_RETRIVE event

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

TriggerEvent("ue_retrieve")
end event

event ue_newitem;call super::ue_newitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles UE_NEWITEMS sent from the mainmenu, by triggering a 
 					clicked on the new button

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


cb_new.TriggerEvent(Clicked!)
end event

event ue_moveitem;call super::ue_moveitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles move by calling WF_COPYMOVE

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

wf_copymove(2)


end event

event ue_copyitem;call super::ue_copyitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles copy by calling WF_COPYMOVE

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/



if cbx_collapsed.checked = true then
	messageBox("Warning","Please change to expanded view and select a cargo.")
	return
end if

wf_copymove(1)

end event

event deactivate;call super::deactivate;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Deactivates the manager by updating the menu

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

wf_updatemenu(false)
end event

event ue_openitem;call super::ue_openitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles a UE_OPENITEM sent from the mainmenu or toolbar, by triggering
 					a doubleclicked event on the manager datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_manager.TriggerEvent(doubleclicked!)
end event

on w_calc_manager.create
int iCurrent
call super::create
this.cb_refresh=create cb_refresh
this.cbx_slf=create cbx_slf
this.st_profit=create st_profit
this.dw_select_profitcenter=create dw_select_profitcenter
this.cbx_stf=create cbx_stf
this.cbx_swf=create cbx_swf
this.cbx_scf=create cbx_scf
this.cbx_sff=create cbx_sff
this.cbx_sef=create cbx_sef
this.cb_filter=create cb_filter
this.dw_todate=create dw_todate
this.dw_fromdate=create dw_fromdate
this.st_5=create st_5
this.st_no_rows=create st_no_rows
this.dw_filter=create dw_filter
this.cbx_collapsed=create cbx_collapsed
this.cb_new=create cb_new
this.mle_1=create mle_1
this.cb_recalc=create cb_recalc
this.cbx_compact=create cbx_compact
this.dw_manager=create dw_manager
this.st_4=create st_4
this.sle_1=create sle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_refresh
this.Control[iCurrent+2]=this.cbx_slf
this.Control[iCurrent+3]=this.st_profit
this.Control[iCurrent+4]=this.dw_select_profitcenter
this.Control[iCurrent+5]=this.cbx_stf
this.Control[iCurrent+6]=this.cbx_swf
this.Control[iCurrent+7]=this.cbx_scf
this.Control[iCurrent+8]=this.cbx_sff
this.Control[iCurrent+9]=this.cbx_sef
this.Control[iCurrent+10]=this.cb_filter
this.Control[iCurrent+11]=this.dw_todate
this.Control[iCurrent+12]=this.dw_fromdate
this.Control[iCurrent+13]=this.st_5
this.Control[iCurrent+14]=this.st_no_rows
this.Control[iCurrent+15]=this.dw_filter
this.Control[iCurrent+16]=this.cbx_collapsed
this.Control[iCurrent+17]=this.cb_new
this.Control[iCurrent+18]=this.mle_1
this.Control[iCurrent+19]=this.cb_recalc
this.Control[iCurrent+20]=this.cbx_compact
this.Control[iCurrent+21]=this.dw_manager
this.Control[iCurrent+22]=this.st_4
this.Control[iCurrent+23]=this.sle_1
end on

on w_calc_manager.destroy
call super::destroy
destroy(this.cb_refresh)
destroy(this.cbx_slf)
destroy(this.st_profit)
destroy(this.dw_select_profitcenter)
destroy(this.cbx_stf)
destroy(this.cbx_swf)
destroy(this.cbx_scf)
destroy(this.cbx_sff)
destroy(this.cbx_sef)
destroy(this.cb_filter)
destroy(this.dw_todate)
destroy(this.dw_fromdate)
destroy(this.st_5)
destroy(this.st_no_rows)
destroy(this.dw_filter)
destroy(this.cbx_collapsed)
destroy(this.cb_new)
destroy(this.mle_1)
destroy(this.cb_recalc)
destroy(this.cbx_compact)
destroy(this.dw_manager)
destroy(this.st_4)
destroy(this.sle_1)
end on

event ue_datachanged;call super::ue_datachanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles UE_DATACHANGED event, by setting the IB_RETRIEVE to true. 
 					This will make the manager re-retrieve data upon next activate event

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

ib_retrieve = true // Force retrieve
end event

type st_hidemenubar from mt_w_sheet_calc`st_hidemenubar within w_calc_manager
end type

type cb_refresh from uo_cb_base within w_calc_manager
integer x = 3694
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 150
string text = "&Refresh"
end type

event clicked;call super::clicked;Parent.TriggerEvent("ue_retrieve")
end event

type cbx_slf from checkbox within w_calc_manager
integer x = 3758
integer y = 132
integer width = 297
integer height = 72
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "LoadLoad"
end type

event clicked;cb_filter.triggerevent(clicked!)
end event

type st_profit from statictext within w_calc_manager
integer x = 3127
integer y = 24
integer width = 274
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Profitcenter"
boolean focusrectangle = false
end type

type dw_select_profitcenter from datawindow within w_calc_manager
event ue_keydown pbm_dwnkey
integer x = 3127
integer y = 84
integer width = 622
integer height = 92
integer taborder = 40
string title = "none"
string dataobject = "d_calc_select_profitcenter"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;integer ls_null

if key = KeyDelete! then
	setNull(ls_null)
	choose case this.getColumnName()
		case "pc_nr" 
			this.setItem(this.getRow(), "pc_nr", ls_null)
			cb_filter.event clicked( )
	end choose
end if
		
		

end event

event getfocus;cb_filter.default = true
end event

event itemerror;integer li_null; setNull(li_null)
this.setItem(1, "pc_nr", li_null)
return 2
end event

type cbx_stf from checkbox within w_calc_manager
integer x = 3758
integer y = 12
integer width = 288
integer height = 72
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Template"
end type

event clicked;cb_filter.triggerevent(clicked!)
end event

type cbx_swf from checkbox within w_calc_manager
integer x = 3758
integer y = 72
integer width = 279
integer height = 72
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Working"
end type

event clicked;cb_filter.triggerevent(clicked!)
end event

type cbx_scf from checkbox within w_calc_manager
integer x = 4073
integer y = 72
integer width = 320
integer height = 72
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Calculated"
end type

event clicked;cb_filter.triggerevent(clicked!)
end event

type cbx_sff from checkbox within w_calc_manager
integer x = 4073
integer y = 12
integer width = 279
integer height = 72
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Fixtured"
end type

event clicked;cb_filter.triggerevent(clicked!)
end event

type cbx_sef from checkbox within w_calc_manager
integer x = 4073
integer y = 132
integer width = 320
integer height = 72
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Estimated"
end type

event clicked;cb_filter.triggerevent(clicked!)
end event

type cb_filter from commandbutton within w_calc_manager
integer x = 4626
integer y = 68
integer width = 256
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Filter"
end type

event clicked;/************************************************************************************
 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Applies the filter to the manager datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
240702			10.6			FR				New filter functionality implemented. This code
													should be in a function if done properly.
													
30-08-10           23.01              JSU        New filter is implemented. Removed search function.
************************************************************************************/

String ls_tmp, ls_voyage, ls_filter
Char ls_ch
Long ll_fix_id
date ld_date_from, ld_date_to

// Turn redraw off
dw_manager.uf_redraw_off()

dw_filter.accepttext()

// Reset the filter string
is_filter = ""

If cbx_stf.checked Then is_filter += " cal_calc_cal_calc_status = 1 or"

if cbx_sef.checked then 	is_filter += " cal_calc_cal_calc_status = 6  or"

if cbx_swf.checked then is_filter += " cal_calc_cal_calc_status = 2 or"

if cbx_sff.checked then is_filter += " cal_calc_cal_calc_status = 4 or"

if cbx_scf.checked then 	is_filter += " cal_calc_cal_calc_status = 5 or"

if cbx_slf.checked then is_filter += " cal_calc_cal_calc_status = 7 or"

if is_filter <> "" then
	is_filter = "(" + mid(is_filter,1,len(is_filter)-2) + ") and "
else // none of the checkbox is checked.
	is_filter = " cal_calc_cal_calc_status = 999 and  " //put a none-existing satus code.
end if

//Add creator
ls_tmp = lefttrim(dw_filter.getitemstring(1, "creator"))
if ls_tmp<>"" then
	is_filter += " (cal_calc_cal_calc_created_by like '%" + ls_tmp + "%') and " 
end if

// Add vessel, description, startport and endport to the filter string
wf_addFilter("vessel", "%" + dw_filter.GetItemString(1,"vessel"))
wf_addfilter("ports_start_port", "%" + Upper(dw_filter.GetItemString(1,"first_port")))
wf_addfilter("ports_end_port", "%" + Upper(dw_filter.GetItemString(1,"last_port")))
wf_addfilter("cal_calc_cal_calc_description", "%" + Upper(dw_filter.GetItemString(1,"description")))

// If search for voyage, then retrieve all CALC and FIXTURE_ID's for that
// voyage number, is several ID's found, the add them with an or into
// the filter string, 

ls_voyage = dw_filter.GetItemString(1,"voyage")
If not (isNull(ls_voyage)) And (ls_voyage <> "") Then

	DECLARE ll_fix_cursor CURSOR FOR
	SELECT DISTINCT CAL_CALC_FIX_ID
	FROM CAL_CALC
	WHERE CAL_CALC_ID IN
	(SELECT CAL_CALC_ID
 	FROM VOYAGES
 	WHERE (VOYAGE_NR = :ls_voyage) AND (CAL_CALC_ID >1));

	OPEN ll_fix_cursor;

	ls_tmp = ""

	DO WHILE SQLCA.SQLCode = 0
		FETCH ll_fix_cursor
		INTO :ll_fix_id;

		If SQLCA.SQLCode = 0 Then
			If ls_tmp <> "" Then ls_tmp += " or "
			ls_tmp += "CAL_CALC_CAL_CALC_FIX_ID = "+String(ll_fix_id)
		End if
	LOOP

	CLOSE ll_fix_cursor;
	COMMIT;

	If ls_tmp <> "" Then 
		ls_tmp = "("+ls_tmp+") and " 
	Else 
		MessageBox("Notice", "No calculations found with voyage no. "+String(ls_voyage))
		dw_filter.SetItem(1,"voyage", "")
	End if

	If ls_tmp <> "" Then is_filter += ls_tmp
End if

// If not collapsed wiew, then add the charterer into the filter string
If not cbx_collapsed.checked then
	ls_tmp = dw_filter.GetItemString(1, "charterer")
	If not isNull(ls_tmp) Then
		is_filter += "charterer="+ls_tmp+" and "
	End if
End if

//Profitcenter if any
dw_select_profitcenter.acceptText()
if not isNull(dw_select_profitcenter.getItemNumber(1, "pc_nr")) and dw_select_profitcenter.getItemNumber(1, "pc_nr")> 0 then
	is_filter += "pc_nr="+string(dw_select_profitcenter.getItemNumber(1, "pc_nr"))+" and "
end if

//Add date limitation
dw_fromdate.accepttext()
dw_todate.accepttext()
ld_date_from = dw_fromdate.GetItemDate(1, "date_value")
ld_date_to = dw_todate.GetItemDate(1, "date_value")
ld_date_to = date(relativedate(date(ld_date_to), 1))
ls_filter = "cal_calc_cal_calc_last_edited >= date('" + string(ld_date_from) + "') and "
ls_filter += "cal_calc_cal_calc_last_edited <= date('" + string(ld_date_to) + "') and "
if pos(is_filter,"cal_calc_cal_calc_last_edited") <> 0 then
	is_filter = left(is_filter,pos(is_filter,"cal_calc_cal_calc_last_edited")-1) +ls_filter
else
	is_filter = is_filter + ls_filter
end if

// If the lenght if the filterstring is > 4, then remove the last 5 char's
// which is the final " AND ".
If Len(is_filter) > 4 Then is_filter = Left(is_filter,Len(is_filter)-5)

// Unselect all rows
dw_manager.SelectRow(0,False)
// Apply the filter, refilter and to a groupcalc to get everything updated
dw_manager.SetFilter(is_filter)
dw_manager.Filter()
dw_manager.Groupcalc()

// Trigger a RetrieveEnd! event, so the rowcounter will be update
dw_manager.TriggerEvent(RetrieveEnd!)

dw_manager.POST setfocus()

// and turn redraw back on
dw_manager.uf_redraw_on()


end event

type dw_todate from datawindow within w_calc_manager
integer x = 2894
integer y = 92
integer width = 215
integer height = 64
integer taborder = 30
string title = "none"
string dataobject = "d_date"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event getfocus;cb_filter.default = false
end event

event itemchanged;dw_filter.accepttext()
Parent.TriggerEvent("ue_retrieve")
end event

type dw_fromdate from datawindow within w_calc_manager
integer x = 2656
integer y = 92
integer width = 215
integer height = 64
integer taborder = 20
string title = "none"
string dataobject = "d_date"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event getfocus;cb_filter.default = false
end event

event itemchanged;dw_filter.accepttext()
Parent.TriggerEvent("ue_retrieve")

end event

type st_5 from statictext within w_calc_manager
integer x = 2894
integer y = 24
integer width = 206
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "To Date"
boolean focusrectangle = false
end type

type st_no_rows from statictext within w_calc_manager
integer x = 32
integer y = 2384
integer width = 421
integer height = 48
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "0 row(s)"
boolean focusrectangle = false
end type

event doubleclicked;/* show recalc button if user doubleclicks * 5 with ctrl depressed */
if KeyDown(KeyControl!) then
	if _ii_hiderecalc=4 then
		cb_recalc.visible = true
	else
		_ii_hiderecalc++
	end if
end if
end event

type dw_filter from u_datawindow_sqlca within w_calc_manager
event ue_keydown pbm_dwnkey
integer x = 14
integer y = 16
integer width = 2619
integer height = 176
integer taborder = 10
string dataobject = "d_calc_manager_filter"
boolean border = false
end type

event ue_keydown;string ls_null

if key = KeyDelete! then
	setNull(ls_null)
	choose case this.getColumnName()
		case "charterer" 
			this.setItem(this.getRow(), "charterer", ls_null)
			cb_filter.event clicked( )
	end choose
end if
end event

event itemchanged;call super::itemchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the itemchanged event by calling the search-as-you-type 
 					object for the charterer field

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		   VERSION 	     NAME	         DESCRIPTION
-------- 		------- 		----- 		     -------------------------------------
30/08/10                       JSU042       changed with the new filter.
  
************************************************************************************/
if dwo.name = "creator" then
	dw_filter.accepttext()
	Parent.TriggerEvent("ue_retrieve")
	cb_filter.default = false
else
	iuo_dddw_search_charterer.uf_itemchanged()
	// Set the filter button to default if not already default
	If not cb_filter.default then cb_filter.default = true
end if

end event

event getfocus;call super::getfocus;cb_filter.default = true
end event

type cbx_collapsed from uo_cbx_base within w_calc_manager
integer x = 896
integer y = 2384
integer width = 549
integer height = 64
integer taborder = 140
long backcolor = 32304364
string text = "Show Collapsed &View"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Switches between the collapsed and normal view
 
 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
Long ll_color
Integer li_protect

n_object_usage_log use_log
use_log.uf_log_object(this.text)
	
// Set the appropritate datawindow object in the manager datawindow, the color and 
// locked status for the charterer field should be set to grey, locked on collapsed
// views, since the charterer isn't displayed when in collapsed view. Otherwise it
// should be set to white and unlocked
If this.Checked Then
	dw_manager.DataObject = "d_calc_manager_collapsed"
	dw_manager.settransobject(SQLCA)
//	if uo_global.ii_access_level < 0 THEN
//		dw_manager.object.datawindow.table.select = dw_manager.Object.DataWindow.Table.SQLSelect + " and CAL_CALC.CAL_CALC_VESSEL_ID in (SELECT VESSELNO FROM EXTERNALS WHERE USERID = '"+uo_global.is_userid+"')"
//	end if
//	ll_color = 12632256
	ll_color = rgb(236,236,236)//80269524
	li_protect = 1
Else
	dw_manager.DataObject = "d_calc_manager"
	dw_manager.settransobject(SQLCA)
//	if uo_global.ii_access_level < 0 THEN
//		dw_manager.object.datawindow.table.select = dw_manager.Object.DataWindow.Table.SQLSelect + " and CAL_CALC.CAL_CALC_VESSEL_ID in (SELECT VESSELNO FROM EXTERNALS WHERE USERID = '"+uo_global.is_userid+"')"
//	end if
	ll_color = 16777215
	li_protect = 0
End if

// Set the transaction object and trigger a retrieve
Parent.TriggerEvent("ue_retrieve")

// Update the color and locked status for the charterer field
dw_filter.modify("charterer.background.color = "+String(ll_color)+" charterer.protect = "+String(li_protect))

inv_style.of_dwlistformater(dw_manager,false)

end event

type cb_new from uo_cb_base within w_calc_manager
integer x = 4046
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 120
string text = "&New"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Opens the "Create new calculation" window

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

s_opencalc_parm lstr_opencalc_parm

choose case uo_global.ii_access_level 
	case -1, -3   /* External APM and External Other no access */
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
end choose

// Open W_CALC_SELECT_WIZARD window
OpenWithParm(w_calc_select_wizard,0)

// Results from W_CALC_SELECT_WIZARD is returned in the Message object
lstr_opencalc_parm = Message.PowerObjectParm

lstr_opencalc_parm.b_compact = cbx_compact.checked

// If a Wizard name is given in the S_WIZARD string, then create the calculation
// with the LSTR_OPENCALC_PARM as argument
If lstr_opencalc_parm.s_wizard<>"" Then
	w_atobviac_calc_calculation lw_calculation
	SetPointer(hourglass!)
	/* If not already active create instance */
	if NOT isValid(gnv_atobviac) then gnv_atobviac = create n_atobviac
	/* If not open open tables - can take several seconds */
	if NOT gnv_atobviac.of_getTableOpen( ) then
		open(w_startup_screen)
		gnv_AtoBviaC.of_OpenTable()
		gnv_AtoBviaC.of_resetToDefaultState()
		close(w_startup_screen)
	end if 
	OpenSheetWithParm(lw_calculation, lstr_opencalc_parm,w_tramos_main,0,Original!)
End if
end event

type mle_1 from multilineedit within w_calc_manager
boolean visible = false
integer x = 2025
integer y = 1724
integer width = 658
integer height = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Hidden things on right (resize window), Order by and Ascending is being used"
borderstyle borderstyle = stylelowered!
end type

type cb_recalc from commandbutton within w_calc_manager
boolean visible = false
integer x = 3383
integer y = 2368
integer width = 242
integer height = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Recalc"
end type

event clicked;Open(w_atobviac_calc_recalc)
end event

type cbx_compact from mt_u_checkbox within w_calc_manager
integer x = 480
integer y = 2384
integer width = 389
integer height = 64
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
long backcolor = 32304364
string text = "&Use Compact"
end type

event clicked;call super::clicked;n_object_usage_log use_log
use_log.uf_log_object(this.text)

end event

type dw_manager from u_datawindow_sqlca within w_calc_manager
integer x = 18
integer y = 240
integer width = 4370
integer height = 2112
integer taborder = 110
string dataobject = "d_calc_manager"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event retrieveend;call super::retrieveend;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the retrieve end, by updating the number of rows in the
 					textfield below the manager datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
st_no_rows.text = String(dw_manager.RowCount()) + " row(s)"

end event

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles clicked events, by updating the menu, and setting the
 					open button to default

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
230702			10.6			FR				Sort functionality added 
16/09/2011		????			AGL			Sort functionality removed
************************************************************************************/

wf_updateMenu(true)
end event

event doubleclicked;call super::doubleclicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the doubleclicked event, by opening the selected calculation

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_row
integer li_status
s_opencalc_parm 				lstr_opencalc_parm
w_calc_calculation 				lw_calculation
w_atobviac_calc_calculation 	lw_calc

// If row is 0 (header clicked) then exit (CR 2345)
If row=0 then Return

Choose case uo_global.ii_access_level 
	case -1, -3   /* External APM and External Other no access */
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
End choose

// Get the current row. If it's above zero, then get the CALC_ID into a 
// S_OPENCALC_PARM structure and open the calculation with that
ll_Row = GetRow()

If ll_Row > 0 Then
	il_current_calc_id = dw_manager.GetItemNumber(ll_row,"cal_calc_cal_calc_ID")
	If il_current_calc_id > 0 Then

		n_calcwindowcontrol			lnv_calcwincontrol 
		integer							li_retval
		/* validate user can only open 1 of either est/calc in a fixtured calc */
		lnv_calcwincontrol = create n_calcwindowcontrol		
		lw_calc = lnv_calcwincontrol.of_getavailablecalc( il_current_calc_id, dw_manager.GetItemNumber(ll_row,"cal_calc_cal_calc_fix_id")  , dw_manager.GetItemNumber(ll_row,"cal_calc_cal_calc_status"), li_retval)
		destroy lnv_calcwincontrol
		if isvalid(lw_calc) then
			/* same calc */
			lw_calc.setfocus()
		else
			if li_retval = 2 then /* modified open */
				lw_calc.setfocus()
			else		
				SetPointer(hourglass!)
				/* test to see if status allows compact viewer */
				lstr_opencalc_parm.b_compact = cbx_compact.checked
				lstr_opencalc_parm.l_calc_id = il_current_calc_id
				
				if dw_manager.GetItemNumber(ll_row,"cal_calc_use_atobviac_distance") = 1 then
					/* If not already active create instance */
					if not isValid(gnv_atobviac) then gnv_atobviac = create n_atobviac
					/* If not open open tables - can take several seconds */
					if not gnv_atobviac.of_getTableOpen( ) then
						open(w_startup_screen)
						gnv_AtoBviaC.of_OpenTable()
						gnv_AtoBviaC.of_resetToDefaultState()
						close(w_startup_screen)
					end if 
					OpenSheetWithParm(lw_calc, lstr_opencalc_parm,w_tramos_main,0,Original!)
				else	
					OpenSheetWithParm(lw_calculation, lstr_opencalc_parm,w_tramos_main,0,Original!)
				end if
			end if
		end if
	End if
End if
end event

event rowfocuschanged;call super::rowfocuschanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles rowfocuschanged events, by updating the menu, and setting
 					the open button to default

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

wf_updatemenu(true)

end event

type st_4 from statictext within w_calc_manager
integer x = 2656
integer y = 24
integer width = 187
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "From..."
boolean focusrectangle = false
end type

type sle_1 from mt_u_singlelineedit within w_calc_manager
integer width = 4599
integer height = 216
long backcolor = 22628899
string text = ""
boolean border = false
end type

