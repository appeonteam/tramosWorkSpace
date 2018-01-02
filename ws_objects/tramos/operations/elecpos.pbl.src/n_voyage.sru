$PBExportHeader$n_voyage.sru
$PBExportComments$This object is used to change/delete voyage number
forward
global type n_voyage from mt_n_nonvisualobject
end type
end forward

global type n_voyage from mt_n_nonvisualobject
end type
global n_voyage n_voyage

type variables
long	il_SINGLEVOYAGE   = 1
long	il_TIMECHARTEROUT = 2

end variables

forward prototypes
public function integer of_modifyvoyage (ref datawindow adw_proceeding_list)
public function integer of_repostbunker (ref datawindow adw_proceeding_list, string as_new_voyagenumber)
private subroutine of_replacecharacter (ref string as_string, character ac_from, string as_to)
public subroutine documentation ()
public function integer of_modifyvoyagevalidation (ref datawindow adw_proceeding_list)
public function s_voyageinfo of_get_voyageinfo (long al_vessel_nr, string as_voyage_nr)
public function long of_log_voyagechanges (s_voyageinfo astr_voyage)
public function long of_checkvoyage (long al_vessel_nr, string as_old_voyage_nr, string as_new_voyage_nr)
public function long of_checkvoyage (long al_vessel_nr, string as_voyage_nr)
public function long of_modify_voyagetype (long al_vessel_nr, string as_voyage_nr, long al_voyagetype)
public function long of_check_proceed_itenerary (long al_vessel_nr, string as_voyage_nr)
public subroutine of_ownermatter_sendemail (long al_vesselnr, string as_voyagenr)
public function datetime of_get_pocvoyagestart (integer ai_vesselnr, string as_voyagenr)
public function datetime of_get_pocvoyageend (integer ai_vesselnr, string as_voyagenr)
public function integer of_get_pocvoyagestartend (integer ai_vesselnr, string as_voyagenr, ref datetime adt_voyagestart, ref datetime adt_voyageend)
public function string of_get_fullvoyagenr (string as_voyagenr)
public function integer of_deletevoyage (ref datawindow adw_proceeding_list)
public function integer of_repostclaim (ref mt_n_datastore ads_claim_list, string as_new_voyagenumber, ref s_voyageinfo_claim astr_claims[])
public function integer of_get_outstanding_voymaster_trans_count (string as_vessel_ref_nr, string as_voyage_nr, ref string as_waitingtime, ref long al_trans_id)
public function integer of_get_outstanding_voymaster_data (long al_trans_id, ref string as_status, ref integer ai_voyage_type)
public function integer of_validate_ax_voymaster_state (integer ai_sender, long al_vessel_nr, string as_voyage_nr, string as_modified_voyage_nr, ref integer ai_voyage_type, ref string as_vessel_ref_nr)
public function integer of_refresh_task_list (long al_vessel, string as_voyage)
end prototypes

public function integer of_modifyvoyage (ref datawindow adw_proceeding_list);/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : w_proceeding_list
 Object  : cb_modify_voyage_number
 Event	: clicked
 Scope   : button
 ************************************************************************************
 Author  : Bettina Olsen
 Date    : 14-01-97
 Description :	The user choose the voyage to be modified in the datawindow. When 
					the user has chosen the voyage and clicks on the modify_voyage_number
					button a window pops up. In the window the user writes the new voyage number.
					The new voyage number is created and the old is deleted.
					After this a report about the modification is printed.
 Arguments 	: {description/none}
 Returns   	: {description/none}  
 Variables 	: {important variables - usually only used in Open-event scriptcode}
 Other 		: {other comments}
*************************************************************************************
Development Log 
DATE				VERSION 	NAME			DESCRIPTION
-------- 			------- 		----- 		-------------------------------------
12-96				1.0			bho			First release
25-11-97			1.1			bho			New tables were inserted in script.
23-03-98			1.2			bho			Dropped the position-array where the voyage number
													position is coded. The position is now found in
													the user object.
26-02-03			1.3			KMY			Removed references to the table TCHIRES; i.e. removed
													the table from the ls_table array
12-10-05		  	14.08			RMO			Changed the implementation of OFF Serviced to hold Identity key
13/10-10		   	23.03       	RMO             Change voyagenumber in special claim added
15/11/10			23.06			JMC			Change voyage number in POC_TASK_LIST
20/12-10			24.03			RMO003		Not possible to modiy voyage number from
													'single' to 'tc-out' or vice versa if bunker posted
													in CODA
13/01-11			24.05			AGL			Added new table IDLE_VOYAGE_VAS_FIGURES to be updated when modifying		
09/01/12			27.00			JMC			Changed copy of CLAIMS table, because CLAIM ID is an identity collumn

DATE				CR# 			NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
29/01/13			CR3002		LGX001		You cannot change the voyage type from TC-out to Single Voyage, because there is cargo registered.
08/03/13			CR3112		LGX001		Create credit note for claims/TC when change voyage number 
29/07/14			CR3700		LHG008		Update CLAIM_SENT.VOYAGE_NR when change voyage number.
28/07/15			CR3872		AGL027		BMVM processing 
08/09/16			CR3320 		AGL027		BMVM processing II - validate using VOYMASTER if we are allowed to modify selected voyage's number
22/03/17			CR4439		HHX010		Refresh task list
************************************************************************************/
n_sql_table_function inv_sql
mt_n_datastore			lds_report, lds_claim_trans 
s_voyageinfo			lstr_voyage
s_voyageinfo_claim	lstr_voyage_claims[]
string 		ls_columns[], ls_insert, ls_insert_sql, ls_table[], ls_copy, ls_voyage, ls_msg
string			ls_sql_delete, ls_update, ls_update_history, ls_text, ls_voyage_notes
long 			ll_counter, ll_table_count,ll_max,ll_vessel, ll_selected_row, ll_count, ll_return, ll_voyagetype
long 			ll_remaining_tcout_voyages, ll_trans_id_creditnote_ref[], ll_trans_id_claims_ref[], ll_trans_id
integer 		li_pos[], li_array_size, li_voyage_number_position, li_voyage_type=0
datetime 	ld_date
boolean 		lb_voyage_count, lb_modifytype
string 		ls_update_voyage_notes, ls_names, ls_vessel_ref_nr
decimal		ld_bunker_posted, ld_calcid  


/* Set tables to modify */
/* Items marked as removed are tables where an identity key is added and therefore can be modified by update */
ls_table ={"VOYAGES",/* removed by RMO:"OFF_SERVICES",*/"CLAIMS","IDLE_DAYS","PROCEED",/*removed by KMY: "TCHIRES",*/ /*"COMMISSIONS",*/"FREIGHT_ADVANCED",&
		"HEA_DEV_CLAIMS","FREIGHT_CLAIMS","DEM_DES_CLAIMS","CLAIM_TRANSACTION",/*"CLAIM_ACTION",*/"POC","POC_EST","BP_DETAILS",&
		"DISBURSEMENTS","FREIGHT_ADVANCED_RECIEVED","FREIGHT_RECEIVED","DEM_DES_RATES","CARGO","LAYTIME_STATEMENTS",&
		"DISB_EXPENSES","DISB_PAYMENTS",/* removed by RMO:"CD",*/ "LAY_DEDUCTIONS",/* removed by RMO:"BOL",*/"GROUP_DEDUCTIONS", "TRA_NCAG", "POC_TASK_LIST"}

/* Disabled on the 23-03-98 */
/* li_pos	={2,3,3,3,3,9,4,3,3,3,3,3,3,2,3,4,3,3,3,2,3,4,4,2,2,2,3} */

/* Get the voyage, where the user wants to modify the voyage number. And then  get the new voyagenumber to insert */
/* Get row that is selected in proceeding dw */
ll_selected_row = adw_proceeding_list.getrow()
/* If no row is selected, then */
if ll_selected_row < 1 then
	/* Inform user and return */
	messagebox("Notice","You have not selected a Vessel/Voyage to modify")
	return -1
/* else if a row is selected */
else
	/* Get vessel and voyage number for selected row */
	ls_voyage =adw_proceeding_list.GetItemString(ll_selected_row,"voyage_nr")
	ll_vessel =adw_proceeding_list.GetItemnumber(ll_selected_row,"vessel_nr")	
/* end if */
end if
/* Open window to get new voyage number */
ls_copy = f_get_string("Enter New Voyage Number", 7, "N", "", true)
/* If user has cancelled operation, then... */
if isnull(ls_copy) then
	/* Return from function */
	return -1 
/* else if user has added a voyage number */
else
	//M5-1 Begin added by ZSW001 on 02/04/2012
	ll_return = of_checkvoyage(ll_vessel, ls_voyage, ls_copy)
	if ll_return < 0 then return -1
	//M5-1 End added by ZSW001 on 02/04/2012	
end if

/* 	If old voyage number = 'single' and new = 'tc-out' 
	Check if this voyage is allocated to a calculation. Modify not allowed */
if len(ls_voyage) =5 and len(ls_copy) = 7 then
	SELECT VOYAGES.CAL_CALC_ID  
		INTO :ld_calcid  
		FROM VOYAGES
		WHERE VESSEL_NR = :ll_vessel
			AND VOYAGE_NR = :ls_voyage;
	
	if ld_calcid > 1 then
		MessageBox("Information", "This voyage is allocated to a calculation. Please de-allocate before changing voyage from 'single' to 'tc-out'!")
		return -1
	end if
end if

//check if this voyage is tc out and new voyage is 5 
if len(ls_voyage) = 7 and len(ls_copy) = 5 then
	SELECT COUNT(*)
	INTO:ll_counter
	FROM CARGO
	WHERE VESSEL_NR = :ll_vessel
	AND   VOYAGE_NR = :ls_voyage;
	if ll_counter > 0 then
		messagebox("Information", "You cannot change the voyage type from TC-out to Single Voyage, because there is cargo registered.")
		return -1
	end if
end if
	

/* If the voyage number length of old and new voyage number is not the same = TC-OUT to single or vice versa
	Check if there is posted any bunker to CODA. Modify not allowed */
if len(ls_voyage) <> len(ls_copy) then
	SELECT VOYAGES.BUNKER_POSTED_HFO +   
		VOYAGES.BUNKER_POSTED_DO +   
		VOYAGES.BUNKER_POSTED_GO +   
		VOYAGES.BUNKER_POSTED_LSHFO +   
		VOYAGES.BUNKER_POSTED_BUY +   
		VOYAGES.BUNKER_POSTED_LOSSPROFIT +   
		VOYAGES.BUNKER_POSTED_OFFSERVICE +   
		VOYAGES.BUNKER_POSTED_SELL  
	INTO :ld_bunker_posted  
	FROM VOYAGES   
	WHERE VESSEL_NR = :ll_vessel
		AND VOYAGE_NR = :ls_voyage ;
	commit;
	
	if ld_bunker_posted <> 0 then
		messagebox("Notice","You can't modify the voyage number from TC-OUT to 'single' or vice versa, the voyage has bunker posted to CODA!")
		return -1
	end if
end if

/* Voyage master processing - validate if we are allowed to modify selected voyage */
if of_validate_ax_voymaster_state( 4, ll_vessel, ls_voyage, ls_copy, li_voyage_type, ls_vessel_ref_nr)=c#return.Failure then
	return c#return.Failure	
end if	

/* Create report datastore */
lds_report = create mt_n_datastore
lds_report.dataObject = "d_update_report"
lds_report.setTransObject(SQLCA)

/* Create function used to get which columns are in a given table */
inv_sql = create n_sql_table_function

//M5-1 Begin added by ZSW001 on 03/04/2012
ls_msg = "You are about to change the voyage number for Vessel " + ls_vessel_ref_nr + " from " + ls_voyage + " to " + ls_copy + ".~r~n~r~n"

if len(ls_voyage) = 5 and len(ls_copy) = 7 then
	ls_msg += "It is not possible to create a non TC-out voyage with 7 digits. Do you want to change voyage type to TC-out voyage?"
	ll_voyagetype = il_TIMECHARTEROUT
	lb_modifytype = true
elseif len(ls_voyage) = 7 and len(ls_copy) = 5 then
	ls_msg += "It is not possible to create a TC-out voyage with 5 digits. Do you want to change voyage type to Single voyage?"
	ll_voyagetype = il_SINGLEVOYAGE
	lb_modifytype = true
else
	ls_msg += "Do you wish to do this?"
	lb_modifytype = false
end if
//M5-1 End added by ZSW001 on 03/04/2012

/*  Give the user a chance to stop the action */
if messagebox("Notice", ls_msg, question!, yesno!) = 1 then
	if lb_modifytype then
		ll_return = of_modify_voyagetype(ll_vessel, ls_voyage, ll_voyagetype)
		if ll_return < 0 then return -1
	end if
	
	/* Set pointer to hourglass */
	setpointer(hourglass!)
	/*Prepare report */
	lds_report.settransobject(sqlca)
	lds_report.retrieve(ls_voyage,ll_vessel)
	lds_report.modify("Old_voyage.text='" +ls_voyage +"'")
	lds_report.modify("Vessel.text='"+ls_vessel_ref_nr+"'")
	lds_report.modify("New_voyage.text='"+ls_copy+"'")
	SELECT FIRST_NAME + " " + LAST_NAME INTO :ls_names FROM USERS WHERE USERID=:uo_global.is_userid;
	lds_report.modify("name.text='"+ls_names+"'")

	//Go through all the tables containing voyagenumber 
	ll_max = upperbound (ls_table)
  	for ll_table_count = 1 to ll_max
		ls_insert= ""
		ls_columns = {""}
		/* Call the userobject function. It returns the  columns in the current table*/	
		li_voyage_number_position = inv_sql.uf_get_columns ( ls_table[ll_table_count], ls_columns[] )
		/* Create the insert line using all the columns we recieved from the userobject function.*/
		/* We insert the new voyagenumber In the column voyagenumber */
		li_array_size = upperbound(ls_columns)
		for ll_counter = 1 to li_array_size
			/* spring over autoincrement nøgle i BP_DETAILS */
		
			if ll_counter = li_voyage_number_position then 
			 	ls_insert = ls_insert + "'" + ls_copy + "',"  
			else
				 ls_insert = ls_insert + ls_columns[ll_counter] + "," 
			end if
		next /* ll_counter */
		ls_insert = mid (ls_insert, 1, len(ls_insert) -1)
		ls_insert_sql = "insert into " +  ls_table[ll_table_count] + " select " + ls_insert + " from " + ls_table[ll_table_count] + " where VOYAGE_NR =   '" + ls_voyage +"' and VESSEL_NR=" + string(ll_vessel)
		/* Execute the sql-statement */
		EXECUTE IMMEDIATE :ls_insert_sql using sqlca;
		if sqlca.sqlcode <>0 then
			messagebox("Voyage Number Modification Error (01)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
			destroy inv_sql
			/* Set pointer back to arrow */
			setpointer(arrow!)
			return -1
		end if
	next /* ll_table_count */
	
	if len(ls_voyage) <> len(ls_copy) then 
		of_refresh_task_list(ll_vessel, ls_copy)
	end if
	
	/* Here comes the part where we update the Cargo Detail */
	ls_update = "UPDATE CD SET  VOYAGE_NR ='" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (02)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if

	/* Here comes the part where we update the Bill of Lading */
	ls_update = "UPDATE BOL SET  VOYAGE_NR ='" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (03)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	
	//Here comes the part where we update the OWNER_MATTERS_DEPARTMENT
	ls_update = "UPDATE OWNER_MATTERS_DEPARTMENT SET VOYAGE_NR = '" + ls_copy + "' WHERE VESSEL_NR = " + string(ll_vessel) + " and VOYAGE_NR = '" + ls_voyage + "'"
	EXECUTE IMMEDIATE:ls_update using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (17)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	
	/* Here comes the part where we update the Off Service */
	ls_update = "UPDATE OFF_SERVICES SET  VOYAGE_NR ='" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (04)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if

	/* Here comes the part where we update the DataWarehouse */
	ls_update = "UPDATE CCS_DATAWAREHOUSE SET  VOYAGE_NR ='" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (05)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	
	/* Here comes the part where we update the Special Claiml */
	ls_update = "UPDATE CLAIM_ACTION SET  VOYAGE_NR ='" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (06)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	
	/* Here comes the part where we update the Special Claiml */
	ls_update = "UPDATE SPECIAL_CLAIM SET  VOYAGE_NR ='" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (07)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if

	/* Here comes the part where we update the Additional Lumpsums */
	ls_update = "UPDATE FREIGHT_CLAIM_ADD_LUMPSUMS SET  VOYAGE_NR ='" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (08)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	ls_update = "UPDATE FREIGHT_ADVANCED_ADD_LUMPSUMS SET  VOYAGE_NR ='" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (09)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if

	/* Here comes the part where we insert the old voyagenumber in the TRA_VOYH -table */
	ld_date =datetime( today(),now())
	ls_update_history = "UPDATE TRA_VOYH SET  VOYAGE_NR = '" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update_history  using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (10)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	
	/* Here comes the part where we insert the old voyagenumber in the VOYAGE_DOCUMENT -table */
	ls_update_history = "UPDATE VOYAGE_DOCUMENT SET  VOYAGE_NR = '" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update_history  using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (11)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if

	/* Modify the voyage number in the IDLE_VOYAGE_VAS_FIGURES table if required */
	ls_update_history = "UPDATE IDLE_VOYAGE_VAS_FIGURES SET VOYAGE_NR = '" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update_history  using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (12)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if

	/* Modify the voyage number in the COMMISSIONS table if required */
	ls_update_history = "UPDATE COMMISSIONS SET VOYAGE_NR = '" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update_history  using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (13)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	
	// Modify the voyage number in the CLAIM_SENT table if required
	ls_update_history = "UPDATE CLAIM_SENT SET VOYAGE_NR = '" + ls_copy +"'  WHERE VESSEL_NR= " +string(ll_vessel) + " and VOYAGE_NR= '" +ls_voyage+"' "
	EXECUTE IMMEDIATE:ls_update_history  using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (13)", "The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	
	ls_update_history = "INSERT INTO TRA_VOYH (VESSEL_NR, VOYAGE_NR, TRA_VOYH_MOD_DT, TRA_VOYH_OLD_VOY_NR)	VALUES	 (" + string(ll_vessel) + ",'" + ls_copy+ "','" + string(ld_date,"YYYY-MM-DD HH:MM") + "','" + ls_voyage + "')"
	EXECUTE IMMEDIATE:ls_update_history  using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (13)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	destroy inv_sql
	
	//store the old voyage claim in order to create credit note later and create new claim transaction for new voyage
	lds_claim_trans = create mt_n_datastore
	lds_claim_trans.dataobject = "d_sq_gr_claim_trans"
	lds_claim_trans.settransobject(sqlca)
	if lds_claim_trans.retrieve(ll_vessel, ls_voyage, ls_copy) <= 0 then
		destroy lds_claim_trans
	end if			
	
	/* here comes the part where we delete the old voyagenumber from the tables */
	for ll_table_count= ll_max to 1 step -1		
		ls_sql_delete="DELETE FROM " +ls_table[ll_table_count] + " WHERE VOYAGE_NR = '" + ls_voyage + "' AND VESSEL_NR = " +string(ll_vessel) 
		EXECUTE IMMEDIATE: ls_sql_delete using sqlca;
		if sqlca.sqlcode <> 0 then
			messagebox("Voyage Number Modification Error (14)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
			/* Set pointer back to arrow */
			setpointer(arrow!)
			return -1
		end if
	next
	
	/* Here comes the part where we insert some text about the change in the voyages table */	
	
	/* We construct the text we want to insert */
	ls_text=" ~r~n~r~n System Message:This voyage number was changed from "+ls_voyage+" to "+ls_copy+ " on the "+string(today())+" by "+ls_names  
	/* We get the field voyage_notes */
	SELECT VOYAGE_NOTES INTO :ls_voyage_notes  FROM VOYAGES WHERE VOYAGE_NR= :ls_copy  AND VESSEL_NR= :ll_vessel;
	If IsNull(ls_voyage_notes) Then ls_voyage_notes = ""
	/* If there are any ' or " characters in the string 	*/
	of_replacecharacter( ls_voyage_notes , char(34) , " " )  // " -> space
	of_replacecharacter( ls_voyage_notes , char(39) , " " )  // ' -> space
	/* We append our text about the change of voyagenumber to the text already written in the field */
	ls_voyage_notes= ls_voyage_notes + ls_text
	ls_update_voyage_notes="UPDATE VOYAGES SET VOYAGE_NOTES = '"+ls_voyage_notes+ "',OLD_VOYAGE_NR = '" + ls_voyage + "' WHERE VOYAGE_NR='"+ ls_copy+"' AND VESSEL_NR="+string(ll_vessel)
	EXECUTE IMMEDIATE: ls_update_voyage_notes using sqlca;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Modification Error (15)","The Voyage Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	
	/* Set pointer back to arrow */
	setpointer(arrow!)
	
	// Repost claim Coda Transactions
	if isvalid(lds_claim_trans) then
		if of_repostclaim(lds_claim_trans, ls_copy, lstr_voyage_claims[] ) = -1 then 
			destroy lds_claim_trans
			setpointer(arrow!)
			return -1
		end if
		destroy lds_claim_trans
	end if
		
	// Repost Bunker Coda Transactions 
	if of_repostBunker(adw_proceeding_list, ls_copy) = -1 then 
		destroy lds_report
		setpointer(arrow!)
		return -1
	end if
	destroy lds_report
	
	//M5-1 Begin added by ZSW001 on 25/04/2012
	lstr_voyage = of_get_voyageinfo(ll_vessel, ls_copy)
	if len(ls_voyage) = 5 then //Single Voyage
		if len(ls_copy) = 5 then //Single to Single
			lstr_voyage.status = 'M'
			lstr_voyage.old_voyage_nr = ls_voyage
			lstr_voyage.str_claims = lstr_voyage_claims
			// CR4346 only set Voyage Master 'M' record to "pending" state if claims are attached to voyage.
			if upperbound(lstr_voyage.str_claims[]) > 0 then
				lstr_voyage.file_name = "pending"
			end if
		else //Single to Time Charter Out
			if lstr_voyage.voyagecount = 0 then //not exist Time Charter Out
				lstr_voyage.status = 'M'
				lstr_voyage.old_voyage_nr = ls_voyage
			else
				lstr_voyage.status = 'D'
				lstr_voyage.voyage_nr = ls_voyage
			end if
		end if
		of_log_voyagechanges(lstr_voyage)
	else			//Time Charter Out
		SELECT count(*) INTO :ll_count FROM VOYAGES WHERE VOYAGES.VESSEL_NR = :ll_vessel AND Left(VOYAGES.VOYAGE_NR, 5) = Left(:ls_voyage, 5);
		if len(ls_copy) = 5 then //Time Charter Out to Single
			if ll_count = 0 then
				lstr_voyage.status = 'M'
				lstr_voyage.old_voyage_nr = ls_voyage
			else
				lstr_voyage.status = 'C'
			end if
			of_log_voyagechanges(lstr_voyage)
		else //Time Charter Out to Time Charter Out
			if left(ls_voyage, 5) <> left(ls_copy, 5) then
				if ll_count = 0 then
					if lstr_voyage.voyagecount = 0 then
						lstr_voyage.status = 'M'
						lstr_voyage.old_voyage_nr = ls_voyage
					else
						lstr_voyage.status = 'D'
						lstr_voyage.voyage_nr = ls_voyage
					end if
					of_log_voyagechanges(lstr_voyage)
				else
					if lstr_voyage.voyagecount = 0 then
						lstr_voyage.status = 'C'
						of_log_voyagechanges(lstr_voyage)
					end if
				end if
			end if
		end if
	end if
	//M5-1 End added by ZSW001 on 25/04/2012
	return 1
end if

return -1
end function

public function integer of_repostbunker (ref datawindow adw_proceeding_list, string as_new_voyagenumber);/* This function is for re-posting bunker transactions of type "Bunker" */

mt_n_datastore 	lds_bunker_apost, lds_bunker_bpost
mt_n_datastore 	lds_new_apost, lds_new_bpost

long 		ll_row, ll_vessel, ll_transkey
long 		ll_bunker_brows, ll_bunker_brow 
long		ll_bunker_arows, ll_bunker_arow
long 		ll_new_brows, ll_new_brow
string 	ls_voyage, ls_vessel_refnr
string		ls_null; setNull(ls_null)
datetime	ldt_null; setNull(ldt_null)

ll_row = adw_proceeding_list.getrow()
ls_voyage =adw_proceeding_list.GetItemString(ll_row,"voyage_nr")
ll_vessel =adw_proceeding_list.GetItemnumber(ll_row,"vessel_nr")	

ls_vessel_refnr = f_get_vsl_ref(ll_vessel)
if isnull(ls_vessel_refnr) or ls_vessel_refnr = "" then
	messagebox("Error reading vessel refnr", "The Voyage Number cannot be modified due to error :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
	//Set pointer back to arrow
	setpointer(arrow!)
	return c#return.Failure
end if

/* Find out if there are transactions */
lds_bunker_apost = create mt_n_datastore
lds_bunker_apost.dataobject = "d_modify_voyage_bunker_trans_log_a"
lds_bunker_apost.setTransObject(SQLCA)
ll_bunker_arows = lds_bunker_apost.retrieve("V"+ls_vessel_refnr, "T"+ls_voyage)

/* Check if any records, otherwise return - no bunker trans to repost */
if ll_bunker_arows < 1 then
	destroy lds_bunker_apost
	return 1
end if

/* There are transactions to repost */
lds_bunker_bpost = create mt_n_datastore
lds_bunker_bpost.dataobject = "d_modify_voyage_bunker_trans_log_b"
lds_bunker_bpost.setTransObject(SQLCA)

lds_new_apost = create mt_n_datastore
lds_new_apost.dataobject = "d_trans_log_main_a"
lds_new_apost.setTransObject(SQLCA)

lds_new_bpost = create mt_n_datastore
lds_new_bpost.dataobject = "d_trans_log_b"
lds_new_bpost.setTransObject(SQLCA)

for ll_bunker_arow = 1 to ll_bunker_arows
	/************************************************************/
	/* FIRST GENERATE REVERT POST                               */
	/************************************************************/
	lds_new_apost.reset()
	lds_new_bpost.reset()
	ll_transkey = lds_bunker_apost.getItemNumber(ll_bunker_arow, "trans_key")
	ll_bunker_brows = lds_bunker_bpost.retrieve(ll_transkey)

	/* move bunker a post to revert (new) apost without transkey */
	lds_new_apost.insertRow(0)
	lds_new_apost.object.data[1,2,1,56] = lds_bunker_apost.object.data[ll_bunker_arow,2,ll_bunker_arow,56]
	lds_new_apost.setItem(1, "file_date", ldt_null)
	lds_new_apost.setItem(1, "file_user", ls_null)
	lds_new_apost.setItem(1, "file_name", ls_null)
	lds_new_apost.setItem(1, "f03_yr", year(today()))
	lds_new_apost.setItem(1, "f04_period", month(Today()))
	lds_new_apost.setItem(1, "f07_docnum", ls_null)
	lds_new_apost.SetItem(1, "trans_date", Today()) 
	lds_new_apost.SetItem(1, "trans_user", uo_global.Getuserid())
	if lds_new_apost.getItemNumber(1, "f29_debitcredit") = 160 then
		lds_new_apost.setItem(1, "f29_debitcredit", 161)
	else
		lds_new_apost.setItem(1, "f29_debitcredit", 160)
	end if
	/* move bunker b post to revert (new) bpost without transkey */
	DO WHILE lds_new_bpost.insertRow(0) < ll_bunker_brows
		/* insert rows into b-post */
	LOOP
	lds_new_bpost.object.data[1,2,ll_bunker_brows,25] = lds_bunker_bpost.object.data[1,2,ll_bunker_brows,25]
	for ll_bunker_brow = 1 to ll_bunker_brows
		lds_new_bpost.setItem(ll_bunker_brow, "f03_yr", year(today()))
		lds_new_bpost.setItem(ll_bunker_brow, "f04_period", month(Today()))
		if lds_new_bpost.getItemNumber(ll_bunker_brow, "f29_debitcredit") = 160 then
			lds_new_bpost.setItem(ll_bunker_brow, "f29_debitcredit", 161)
		else
			lds_new_bpost.setItem(ll_bunker_brow, "f29_debitcredit", 160)
		end if
	next		
	/* Save apost and fill transkey in bpost and save bpost */
	IF lds_new_apost.Update() = 1 THEN
		ll_transkey = lds_new_apost.GetItemNumber(1,"trans_key")
		IF IsNull(ll_transkey) OR ll_transkey = 0 THEN
			MessageBox("Generate transaction error", "No value found for transaction key")
			destroy lds_bunker_apost
			destroy lds_bunker_bpost
			destroy lds_new_apost
			destroy lds_new_bpost
			Return(-1)
		ELSE
			ll_new_brows = lds_new_bpost.RowCount()
			FOR ll_new_brow = 1 TO ll_new_brows
				lds_new_bpost.SetItem(ll_new_brow, "trans_key", ll_transkey)
			NEXT
			lds_new_bpost.AcceptText()
			IF lds_new_bpost.Update() = 1 THEN
				/* continue with next step */
			ELSE
				Messagebox("Error","ids_Apost ok, but ids_Bpost went wrong in update")
				destroy lds_bunker_apost
				destroy lds_bunker_bpost
				destroy lds_new_apost
				destroy lds_new_bpost
				Return(-1)
			END IF
		END IF
	ELSE
		Messagebox("Error","Update of ids_Apost went wrong" + SQLCA.SqlErrText)
		destroy lds_bunker_apost
		destroy lds_bunker_bpost
		destroy lds_new_apost
		destroy lds_new_bpost
		Return(-1)
	END IF

	/************************************************************/
	/* NEXT GENERATE NEW POST FOR NEW VOYAGE NUMBER             */
	/************************************************************/
	lds_new_apost.reset()
	lds_new_bpost.reset()
	/* move bunker a post to revert (new) apost without transkey */
	lds_new_apost.insertRow(0)
	lds_new_apost.object.data[1,2,1,56] = lds_bunker_apost.object.data[ll_bunker_arow,2,ll_bunker_arow,56]
	lds_new_apost.setItem(1, "file_date", ldt_null)
	lds_new_apost.setItem(1, "file_user", ls_null)
	lds_new_apost.setItem(1, "file_name", ls_null)
	lds_new_apost.setItem(1, "f03_yr", year(today()))
	lds_new_apost.setItem(1, "f04_period", month(Today()))
	lds_new_apost.setItem(1, "f07_docnum", ls_null)
	lds_new_apost.setItem(1, "f16_el6", "T"+as_new_voyagenumber)
	lds_new_apost.SetItem(1, "trans_date", Today()) 
	lds_new_apost.SetItem(1, "trans_user", uo_global.Getuserid())
	/* move bunker b post to revert (new) bpost without transkey */
	DO WHILE lds_new_bpost.insertRow(0) < ll_bunker_brows
		/* insert rows into b-post */
	LOOP
	lds_new_bpost.object.data[1,2,ll_bunker_brows,25] = lds_bunker_bpost.object.data[1,2,ll_bunker_brows,25]
	for ll_bunker_brow = 1 to ll_bunker_brows
		lds_new_bpost.setItem(ll_bunker_brow, "f03_yr", year(today()))
		lds_new_bpost.setItem(ll_bunker_brow, "f04_period", month(Today()))
		lds_new_bpost.setItem(ll_bunker_brow, "f16_el6_b", "T"+as_new_voyagenumber)
	next		
	/* Save apost and fill transkey in bpost and save bpost */
	IF lds_new_apost.Update() = 1 THEN
		ll_transkey = lds_new_apost.GetItemNumber(1,"trans_key")
		IF IsNull(ll_transkey) OR ll_transkey = 0 THEN
			MessageBox("Generate transaction error", "No value found for transaction key")
			destroy lds_bunker_apost
			destroy lds_bunker_bpost
			destroy lds_new_apost
			destroy lds_new_bpost
			Return(-1)
		ELSE
			ll_new_brows = lds_new_bpost.RowCount()
			FOR ll_new_brow = 1 TO ll_new_brows
				lds_new_bpost.SetItem(ll_new_brow, "trans_key", ll_transkey)
			NEXT
			lds_new_bpost.AcceptText()
			IF lds_new_bpost.Update() = 1 THEN
				/* continue with next step */
			ELSE
				Messagebox("Error","ids_Apost ok, but ids_Bpost went wrong in update")
				destroy lds_bunker_apost
				destroy lds_bunker_bpost
				destroy lds_new_apost
				destroy lds_new_bpost
				Return(-1)
			END IF
		END IF
	ELSE
		Messagebox("Error","Update of ids_Apost went wrong" + SQLCA.SqlErrText)
		destroy lds_bunker_apost
		destroy lds_bunker_bpost
		destroy lds_new_apost
		destroy lds_new_bpost
		Return(-1)
	END IF
next

destroy lds_bunker_apost
destroy lds_bunker_bpost
destroy lds_new_apost
destroy lds_new_bpost
return 1
end function

private subroutine of_replacecharacter (ref string as_string, character ac_from, string as_to);long start_pos=1

// Find the first occurrence of from string
start_pos = Pos(as_string, ac_from, start_pos)
// Only enter the loop if you find from string
DO WHILE start_pos > 0
    // Replace from string with to string
    as_string = Replace(as_string, start_pos, 1, as_to)
    // Find the next occurrence of from string
    start_pos = Pos(as_string, ac_from, start_pos+Len(as_to))
LOOP

end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: n_voyage
   <OBJECT> Used for encapsulating all functions related to a voyage</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
	Date			Ref		Author			Comments
  	
  	29/10-10		2165		RMO003			Added a of_deletevoyage function to be able to 
	  												control the printing of a report or not
	20/12-10		2228		RMO003			Not possible to delete voyage if bunker posted 
													in CODA
													Not possible to modiy voyage number from
													'single' to 'tc-out' or vice versa if bunker posted
													in CODA
	28/07-11		2247		CONASW			When changing voyage number, if PDF report fails, the 
													whole operation is rolled back.
	09/01/12		2421		JMC112			Changed of_modifyvoyage
	
	28/03/12    M5-1     ZSW001         Add of_get_voyageinfo(), of_get_voyagetype()
	                                    and of_log_voyagechanges() function
	28/05/12    CR2413   ZSW001         Add of_check_proceed_itenerary() function
  	19/06/12		CR#2831	AGL027			Removed obsolete code concerned with portvalidator
	29/01/13		CR3002	LGX001			You cannot change the voyage type from TC-out to Single Voyage, because there is cargo registered.
	08/03/13		CR3112	LGX001			Create credit note for claims/TC-Hire when change voyage number 
	12/11/13		CR3390	LHC010			Modify function of_checkmodify and rollback the code for TC-Hire section in CR3112 .
	25/12/13		CR3085	WWG004			When delete a voyage, the attachment to the voyage's Ports will auto send email.
	29/07/14		CR3700   LHG008			Update CLAIM_SENT.VOYAGE_NR when change voyage number.
	28/07/15		CR3872	AGL027			BMVM - Batch Management Voyage number Modification
	01/04/16		CR4346	AGL027			BMVM - fix bug where VM 'modify' record stays in pending state when no claims exist
	14/04/16		CR3099	CCY018			Add function
	12/10/16		CR3320	AGL027			BMVM II - improve the voyage master transaction handling
	10/11/16		CR3320	AGL027			Modified comments, added claim type event detail and modified logic to include TC-OUT
	25/11/16		CR3320	AGL027			Removed unused function and excluded TCOUT from existing AX tx's validation on delete voyage 
	22/03/17		CR4439	HHX010			Refresh task list
	*******************************************************************/

end subroutine

public function integer of_modifyvoyagevalidation (ref datawindow adw_proceeding_list);/************************************************************************************
 Window  : w_proceeding_list
 Object  : cb_modify_voyage_number
 Event	: clicked
 Scope   : button
 Description :	Open the feature for Brostrom users to modify the voyage numbers with restriction that there is no
 					outgoing is in Disbursement, TC payment and commission and incoming in claims, TC and actions/transactions
					 (need to be deleted when the swopping vessel function is in place4)
*************************************************************************************
Development Log 
DATE			VERSION 	NAME			DESCRIPTION
-------- 		------- 		----- 			-------------------------------------
04/04/2011   initial	    JSU             CR2363
************************************************************************************/
string  ls_voyage
long  ll_vessel, ll_selected_row, ll_counter, ll_contract_id, ll_row, ll_voyagedocuments
boolean lb_voyage_count
n_fileattach_service lnv_attachmentservice
decimal ld_bunker_posted

/* Get the voyage, that the user wants to modify.That is the selected row in proceeding dw */
ll_selected_row = adw_proceeding_list.getrow()
if ll_selected_row < 1 then
	messagebox("Notice","You have not selected a Vessel/Voyage to modify")
	return -1
else
	ls_voyage =adw_proceeding_list.GetItemString(ll_selected_row,"voyage_nr")
	ll_vessel =adw_proceeding_list.GetItemnumber(ll_selected_row,"vessel_nr")	
end if

/*Here comes the part where we check if it´s legal to modify the voyage */

SELECT isnull(COUNT(DISTINCT VESSEL_NR),0)
into :lb_voyage_count
FROM CLAIMS
WHERE VOYAGE_NR=:ls_voyage AND VESSEL_NR=:ll_vessel;
if lb_voyage_count then
	messagebox("Notice","You can´t modify this voyage, the voyage has claims!")
	return -1
end if

SELECT isnull(COUNT(DISTINCT VESSEL_NR),0)
into :lb_voyage_count
FROM SPECIAL_CLAIM
WHERE VOYAGE_NR=:ls_voyage AND VESSEL_NR=:ll_vessel;
if lb_voyage_count then
	messagebox("Notice","You can´t modify this voyage, the voyage has special claims!")
	return -1
end if

SELECT isnull(COUNT(DISTINCT VESSEL_NR),0)
into :lb_voyage_count
FROM DISB_EXPENSES
WHERE VOYAGE_NR=:ls_voyage AND VESSEL_NR=:ll_vessel AND SETTLED=1;
if lb_voyage_count then
	messagebox("Notice","You can´t modify this voyage, the voyage has disbursement expenses!")
	return -1
end if

SELECT isnull(COUNT(DISTINCT VESSEL_NR),0)
into :lb_voyage_count
FROM DISB_PAYMENTS
WHERE VOYAGE_NR=:ls_voyage AND VESSEL_NR=:ll_vessel AND PAYMENT_PRINT_DATE<> null;
if lb_voyage_count then
	messagebox("Notice","You can´t modify this voyage, the voyage has disbursement payments!")
	return -1
end if

/* Check if there is posted any bunker to CODA. Modify not allowed */
SELECT VOYAGES.BUNKER_POSTED_HFO +   
	VOYAGES.BUNKER_POSTED_DO +   
	VOYAGES.BUNKER_POSTED_GO +   
	VOYAGES.BUNKER_POSTED_LSHFO +   
	VOYAGES.BUNKER_POSTED_BUY +   
	VOYAGES.BUNKER_POSTED_LOSSPROFIT +   
	VOYAGES.BUNKER_POSTED_OFFSERVICE +   
	VOYAGES.BUNKER_POSTED_SELL  
INTO :ld_bunker_posted  
FROM VOYAGES   
WHERE VESSEL_NR = :ll_vessel
	AND VOYAGE_NR = :ls_voyage ;

if ld_bunker_posted <> 0 then
	messagebox("Notice","You can´t modify this voyage, the voyage has bunker posted to CODA!")
	return -1
end if

/**********************For TC out voyages only***********************/

SELECT NTC_TC_CONTRACT.CONTRACT_ID
INTO :ll_contract_id
FROM NTC_TC_CONTRACT, NTC_TC_PERIOD
WHERE VESSEL_NR = :ll_vessel
AND NTC_TC_CONTRACT.TC_HIRE_IN = 0
AND NTC_TC_CONTRACT.CONTRACT_ID = NTC_TC_PERIOD.CONTRACT_ID
AND (NTC_TC_PERIOD.PERIODE_START <= (SELECT MIN(POC1.PORT_ARR_DT) FROM POC POC1 WHERE POC1.VESSEL_NR = :ll_vessel  AND POC1.VOYAGE_NR = :ls_voyage))   
AND (NTC_TC_PERIOD.PERIODE_END >= (SELECT MIN(POC2.PORT_ARR_DT) FROM POC POC2 WHERE POC2.VESSEL_NR = :ll_vessel AND POC2.VOYAGE_NR = :ls_voyage))    
;

if isNull(ll_contract_id) then return 1

/* Check if there are payments with status > 2 (final, part-paid, paid) */
SELECT count(*)  
  INTO :ll_counter  
  FROM NTC_PAYMENT  
  WHERE ( NTC_PAYMENT.CONTRACT_ID = :ll_contract_id ) AND  
        ( NTC_PAYMENT.PAYMENT_STATUS > 2 ) ;

if ll_counter > 0 then
	MessageBox("Delete Error", "You can´t modify this voyage, the voyage has settled payments.") 
	return -1 
end if
	
/* Check if there are off-services transferred from operation */
SELECT count(NTC_OFF_SERVICE.OFF_SERVICE_ID)  
  INTO :ll_counter  
  FROM NTC_OFF_SERVICE,   
       NTC_PAYMENT  
  WHERE ( NTC_PAYMENT.PAYMENT_ID = NTC_OFF_SERVICE.PAYMENT_ID ) and  
         ( ( NTC_PAYMENT.CONTRACT_ID = :ll_contract_id ))   ;

if ll_counter > 0 then
	MessageBox("Delete Error", "You can´t modify this voyage, the voyage has transferred off-services from Operations") 
	return -1 
end if

/* Check if there are port expenses transferred from disbursements */
SELECT count(NTC_PORT_EXP.PORT_EXP_ID)  
  INTO :ll_counter  
  FROM NTC_PORT_EXP,   
       NTC_PAYMENT  
  WHERE ( NTC_PAYMENT.PAYMENT_ID = NTC_PORT_EXP.PAYMENT_ID ) and  
         ( ( NTC_PAYMENT.CONTRACT_ID = :ll_contract_id ))   ;

if ll_counter > 0 then
	MessageBox("Delete Error", "You can´t modify this voyage, the voyage has transferred port expenses from Disbursements") 
	return -1 
end if

/* Check if there are lifted bunker on delivery/redelivery attached to contract */
SELECT count(BP_DETAILS.PAYMENT_ID)  
	INTO :ll_counter  
   FROM BP_DETAILS,   
         NTC_PAYMENT  
   WHERE ( NTC_PAYMENT.PAYMENT_ID = BP_DETAILS.PAYMENT_ID ) and  
         ( ( NTC_PAYMENT.CONTRACT_ID = :ll_contract_id ))   ;

if ll_counter > 0 then
	MessageBox("Delete Error", "You can´t modify this voyage, the voyage has lifted bunkers on delivery/redelivery") 
	return -1 
end if

return 1
end function

public function s_voyageinfo of_get_voyageinfo (long al_vessel_nr, string as_voyage_nr);/********************************************************************
   of_get_voyageinfo
   <DESC>	Get voyage related information	</DESC>
   <RETURN>	s_voyageinfo	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
   </ARGS>
   <USAGE>	Suggest to use when creating/modifying/deleting voyages	</USAGE>
   <HISTORY>
   	Date			CR-Ref	Author	Comments
   	27/03/2012	M5-1		ZSW001	First Version
   </HISTORY>
********************************************************************/

s_voyageinfo	lstr_voyage

//Get voyage type
SELECT VOYAGES.VOYAGE_TYPE, 
       VOYAGE_TYPE.AX_CODE
  INTO :lstr_voyage.voyage_type, 
       :lstr_voyage.voyage_axcode
  FROM VOYAGES, VOYAGE_TYPE
 WHERE VOYAGES.VOYAGE_TYPE = VOYAGE_TYPE.ID AND
       VOYAGES.VESSEL_NR   = :al_vessel_nr  AND
       VOYAGES.VOYAGE_NR   = :as_voyage_nr;

//Get the number of existing voyages
if lstr_voyage.voyage_type = il_TIMECHARTEROUT then		//Time Charter Out
	SELECT count(*)
	  INTO :lstr_voyage.voyagecount
	  FROM VOYAGES
	 WHERE (VOYAGES.VESSEL_NR = :al_vessel_nr AND VOYAGES.VOYAGE_NR <> :as_voyage_nr) AND
			 Left(VOYAGES.VOYAGE_NR, 5) = Left(:as_voyage_nr, 5);
end if

lstr_voyage.voyage_nr     = as_voyage_nr
lstr_voyage.userid        = uo_global.is_userid
lstr_voyage.voyage_status = 'A'

//Get vessel ref number and company code
SELECT VESSELS.VESSEL_REF_NR,
       PROFIT_C.CODA_COMPANY_CODE, 
		 getdate()
  INTO :lstr_voyage.vessel_ref_nr,
       :lstr_voyage.company_code, 
		 :lstr_voyage.trans_date
  FROM VESSELS, PROFIT_C
 WHERE VESSELS.PC_NR = PROFIT_C.PC_NR AND
       VESSELS.VESSEL_NR = :al_vessel_nr;

//Get last known arrival or departure date from previous voyage
SELECT Max(IsNull(POC_EST.PORT_DEPT_DT, POC_EST.PORT_ARR_DT))
  INTO :lstr_voyage.start_date
  FROM POC_EST
 WHERE POC_EST.VESSEL_NR = :al_vessel_nr AND
       ((Convert(int, Left(:as_voyage_nr, 2)) < 90 AND (Convert(int, Left(POC_EST.VOYAGE_NR, 2)) >= 90 OR POC_EST.VOYAGE_NR < :as_voyage_nr)) OR
		  (Convert(int, Left(:as_voyage_nr, 2)) >= 90 AND (Convert(int, Left(POC_EST.VOYAGE_NR, 2)) >= 90 AND POC_EST.VOYAGE_NR < :as_voyage_nr)));

if isnull(lstr_voyage.start_date) then
	SELECT Max(IsNull(POC.PORT_DEPT_DT, POC.PORT_ARR_DT))
	  INTO :lstr_voyage.start_date
	  FROM POC
	 WHERE POC.VESSEL_NR = :al_vessel_nr AND
			 ((Convert(int, Left(:as_voyage_nr, 2)) < 90 AND (Convert(int, Left(POC.VOYAGE_NR, 2)) >= 90 OR POC.VOYAGE_NR < :as_voyage_nr)) OR
		     (Convert(int, Left(:as_voyage_nr, 2)) >= 90 AND (Convert(int, Left(POC.VOYAGE_NR, 2)) >= 90 AND POC.VOYAGE_NR < :as_voyage_nr)));
end if

//Get first arrival date from current voyage
if isnull(lstr_voyage.start_date) then
	SELECT Min(POC.PORT_ARR_DT)
	  INTO :lstr_voyage.start_date
	  FROM VOYAGES, POC
	 WHERE VOYAGES.VESSEL_NR = POC.VESSEL_NR AND VOYAGES.VOYAGE_NR = POC.VOYAGE_NR AND
			 VOYAGES.VESSEL_NR = :al_vessel_nr AND VOYAGES.VOYAGE_NR = :as_voyage_nr;
end if

if isnull(lstr_voyage.start_date) then
	SELECT Min(POC_EST.PORT_ARR_DT)
	  INTO :lstr_voyage.start_date
	  FROM VOYAGES, POC_EST
	 WHERE VOYAGES.VESSEL_NR = POC_EST.VESSEL_NR AND VOYAGES.VOYAGE_NR = POC_EST.VOYAGE_NR AND
			 VOYAGES.VESSEL_NR = :al_vessel_nr AND VOYAGES.VOYAGE_NR = :as_voyage_nr;
end if

if isnull(lstr_voyage.start_date) then
	lstr_voyage.start_date = lstr_voyage.trans_date
end if

return lstr_voyage

end function

public function long of_log_voyagechanges (s_voyageinfo astr_voyage);/********************************************************************
   of_log_voyagechanges
   <DESC>	Log the related information of the voyage to VOYAGE_MASTER. Previously this was SQL statements but
				updated due to requiring reference between trans_id in voyage_master and voyage_master_modify data tables</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_voyage
   </ARGS>
   <USAGE>	Suggest to use	after creating/modifying/deleting voyages </USAGE>
   <HISTORY>
   	Date			CR-Ref	Author	Comments
   	27/03/2012	M5-1		ZSW001	First Version
		20/07/2015	CR3872	AGL027	Modify handling of voyage master data
		08/09/2016	CR3320	AGL027	Remove attempt counters from voyage master modify update
   </HISTORY>
********************************************************************/

integer li_claimindex
long  ll_voymasterrow, ll_row
mt_n_datastore	lds_voymastermod, lds_voymaster

if trim(astr_voyage.old_voyage_nr) = "" then setnull(astr_voyage.old_voyage_nr)

lds_voymaster = create mt_n_datastore
lds_voymaster.dataobject = "d_sq_gr_bmvm_insert_voymaster"
lds_voymaster.settransobject(sqlca)

ll_voymasterrow = lds_voymaster.insertrow(0)

lds_voymaster.setitem(ll_voymasterrow,"trans_date", astr_voyage.trans_date) 
lds_voymaster.setitem(ll_voymasterrow,"userid", astr_voyage.userid)
lds_voymaster.setitem(ll_voymasterrow,"status", astr_voyage.status)
lds_voymaster.setitem(ll_voymasterrow,"vessel_ref_nr", astr_voyage.vessel_ref_nr)
lds_voymaster.setitem(ll_voymasterrow,"voyage_nr", left(astr_voyage.voyage_nr, 5))
lds_voymaster.setitem(ll_voymasterrow,"start_date", astr_voyage.start_date)
lds_voymaster.setitem(ll_voymasterrow,"voyage_type", astr_voyage.voyage_axcode)
lds_voymaster.setitem(ll_voymasterrow,"voyage_status", astr_voyage.voyage_status)
lds_voymaster.setitem(ll_voymasterrow,"company_code", astr_voyage.company_code)
lds_voymaster.setitem(ll_voymasterrow,"old_voyage_nr", left(astr_voyage.old_voyage_nr, 5))
lds_voymaster.setitem(ll_voymasterrow,"file_name", astr_voyage.file_name)

if lds_voymaster.update() = 1 then

	/* only add new record when voyage number is modified */
	if astr_voyage.status = "M" and astr_voyage.old_voyage_nr <> "" then
		lds_voymastermod = create mt_n_datastore
		lds_voymastermod.dataobject = "d_sq_gr_bmvm_insert_voymastermod"
		lds_voymastermod.settransobject(sqlca)
	
		for li_claimindex = 1 to upperbound(astr_voyage.str_claims[])
			/* record for each claim that supposidly needs to be synced with AX */
			ll_row = lds_voymastermod.insertrow(0)
			lds_voymastermod.setitem(ll_row,"trans_id",lds_voymaster.getitemnumber(ll_voymasterrow,"trans_id"))
			lds_voymastermod.setitem(ll_row,"claim_nr",astr_voyage.str_claims[li_claimindex].i_claim_nr)
			lds_voymastermod.setitem(ll_row,"claim_type",astr_voyage.str_claims[li_claimindex].s_claim_type)
			lds_voymastermod.setitem(ll_row,"cnote_trans_key",astr_voyage.str_claims[li_claimindex].l_cnote_trans_id_ref)
			lds_voymastermod.setitem(ll_row,"cnote_finished", 0)				
			lds_voymastermod.setitem(ll_row,"claim_trans_key",astr_voyage.str_claims[li_claimindex].l_claim_trans_id_ref)
			lds_voymastermod.setitem(ll_row,"claim_finished", 0)				
		next
		if lds_voymastermod.update() <> 1 then
			return c#return.Failure
		end if
	end if
	return c#return.Success	
else	
	return c#return.Failure
end if
end function

public function long of_checkvoyage (long al_vessel_nr, string as_old_voyage_nr, string as_new_voyage_nr);/********************************************************************
   of_checkvoyage
   <DESC>	Check voyage number	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_old_voyage_nr
		as_new_voyage_nr
   </ARGS>
   <USAGE>	Suggest to use when modifying voyages	</USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
   	02/04/2012		M5-1			ZSW001		First Version
		12/11/2013		CR3390		LHC010		Add validation: not allowed to change the voyage number if transaction is generated.
   </HISTORY>
********************************************************************/

long		ll_count, ll_len, ll_old_voyagetype
string	ls_msg, ls_vessel_refnr, ls_voyagenr
boolean	lb_new

CONSTANT string ls_TITLE = "Info"

if as_old_voyage_nr = "" then lb_new = true

//Voyage number should only be composed by numbers
if not isnumber(as_new_voyage_nr) then
	ls_msg = "The voyage number should only be composed by numbers."
	messagebox(ls_TITLE, ls_msg)
	return c#return.failure
end if

//The length of voyage number should only be 5 or 7 digit numbers
ll_len = len(as_new_voyage_nr)
if ll_len <> 5 and ll_len <> 7 then
	ls_msg = "Voyage number format is YYXXX or YYXXX-XX(for TC Out),~r~nPlease try again."
	messagebox(ls_TITLE, ls_msg)
	return c#return.failure
end if

//Modify Voyage Number
if not lb_new then
	//It should return error if the voyage number already exists
	SELECT count(*) INTO :ll_count FROM VOYAGES WHERE VESSEL_NR = :al_vessel_nr AND VOYAGE_NR = :as_new_voyage_nr;
	if ll_count > 0 then
		ls_msg = "The voyage number " + as_new_voyage_nr + " already exists, please assign a different voyage number."
		messagebox(ls_TITLE, ls_msg)
		return c#return.failure
	end if
	
	SELECT COUNT(*) INTO :ll_count FROM CLAIMS WHERE VESSEL_NR = :al_vessel_nr AND VOYAGE_NR = :as_old_voyage_nr and LOCKED = 1;
	if ll_count > 0 then
		ls_msg = "A claim for voyage number " + as_old_voyage_nr + " is in locked status. The voyage number cannot be modified."
		messagebox(ls_TITLE, ls_msg)
		return c#return.failure
	end if
	ls_vessel_refnr = f_get_vsl_ref(al_vessel_nr)
	if isnull(ls_vessel_refnr) or ls_vessel_refnr = "" then
	   return c#return.failure
	end if
	ls_vessel_refnr = "V" + ls_vessel_refnr
	ls_voyagenr    = "T" + left(as_old_voyage_nr, 5)
	
	
	if len(as_old_voyage_nr) = 7  and left(as_old_voyage_nr, 5) <> left(as_new_voyage_nr,5) then
		
		SELECT COUNT(1) INTO :ll_count
		FROM TRANS_LOG_MAIN_A,
			  TRANS_LOG_B
		WHERE	TRANS_LOG_MAIN_A.TRANS_KEY = TRANS_LOG_B.TRANS_KEY
			AND	TRANS_LOG_MAIN_A.TRANS_TYPE LIKE "TCCODA%"
			AND	TRANS_LOG_MAIN_A.PAYMENT_ID > 0
			AND	TRANS_LOG_MAIN_A.F15_EL5 = :ls_vessel_refnr
			AND	TRANS_LOG_B.F16_EL6_B = :ls_voyagenr;
		
		if ll_count > 0 then
			messagebox(ls_TITLE, "It is not possible to change the voyage number, because there are invoice transactions linked to the voyage. Please contact the system administrator.")
			return c#return.failure
		end if		
		
		SELECT COUNT(NTC_PAYMENT.PAYMENT_ID) INTO :ll_count
		FROM TRANS_LOG_MAIN_A,
			  TRANS_LOG_B,
			  NTC_PAYMENT
		WHERE	TRANS_LOG_MAIN_A.TRANS_KEY = TRANS_LOG_B.TRANS_KEY   AND
				TRANS_LOG_MAIN_A.TRANS_TYPE LIKE "TCCODA%"           AND
				TRANS_LOG_MAIN_A.PAYMENT_ID = NTC_PAYMENT.PAYMENT_ID AND
				NTC_PAYMENT.LOCKED = 1                               AND
				TRANS_LOG_MAIN_A.F15_EL5 = :ls_vessel_refnr          AND
				TRANS_LOG_B.F16_EL6_B = :ls_voyagenr;
		if ll_count > 0 then
			ls_msg = "A TC payment for voyage number " + as_old_voyage_nr + " is in locked status. The voyage number cannot be modified."
			messagebox(ls_TITLE, ls_msg)
			return c#return.failure
		end if
	end if
	//Get old voyage type
	SELECT VOYAGE_TYPE INTO :ll_old_voyagetype FROM VOYAGES WHERE VESSEL_NR = :al_vessel_nr AND VOYAGE_NR = :as_old_voyage_nr;
 	
end if

if ll_len = 5 then		//Non Time Charter Out
	SELECT count(*)
	  INTO :ll_count
	  FROM VOYAGES
	 WHERE VESSEL_NR = :al_vessel_nr AND
	       Left(VOYAGE_NR, 5) = :as_new_voyage_nr AND
			 VOYAGE_TYPE = :il_TIMECHARTEROUT;
	if ll_count > 0 then
		ls_msg = "This voyage has same 5 digits identical to a TC out voyage. This is not allowed! Please assign a different voyage number."
		messagebox(ls_TITLE, ls_msg)
		return c#return.failure
	end if
elseif ll_len = 7 then	//Time Charter Out
	SELECT count(*)
	  INTO :ll_count
	  FROM VOYAGES
	 WHERE VESSEL_NR = :al_vessel_nr AND
	       Left(VOYAGE_NR, 5) = Left(:as_new_voyage_nr, 5) AND
			 VOYAGE_TYPE <> :il_TIMECHARTEROUT;
	if ll_count > 0 then
		ls_msg = "This TC out voyage has same 5 digits identical to a non TC out voyage. This is not allowed! Please assign a different voyage number."
		messagebox(ls_TITLE, ls_msg)
		return c#return.failure
	end if
end if

return c#return.success

end function

public function long of_checkvoyage (long al_vessel_nr, string as_voyage_nr);/********************************************************************
   of_checkvoyage
   <DESC>	Check voyage number	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
   </ARGS>
   <USAGE>	Suggest to use when creating voyages	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	02/04/2012   M5-1         ZSW001       First Version
   </HISTORY>
********************************************************************/

return of_checkvoyage(al_vessel_nr, "", as_voyage_nr)

end function

public function long of_modify_voyagetype (long al_vessel_nr, string as_voyage_nr, long al_voyagetype);/********************************************************************
   of_modify_voyagetype
   <DESC>	Modify voyage type	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
		al_voyagetype
   </ARGS>
   <USAGE>	Suggest to use when modifying voyages number	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	03/04/2012   M5-1         ZSW001       First Version
   </HISTORY>
********************************************************************/

long		ll_pcn, ll_tcowner, ll_tcincontracts
dec		ld_calcid, ld_bunker_posted

//Check if this voyage is allocated to a calculation. Modify not allowed
SELECT CAL_CALC_ID
  INTO :ld_calcid
  FROM VOYAGES
 WHERE VESSEL_NR = :al_vessel_nr AND
       VOYAGE_NR = :as_voyage_nr;

if ld_calcid > 1 then
	messagebox("Information", "This voyage is allocated to a calculation. Please de-allocate before changing voyage type.")
	return c#return.failure
end if

//Check if there are registred bunker on DEL/RED port. Modify not allowed
setnull(ll_pcn)

SELECT BP_DETAILS.PCN
  INTO :ll_pcn
  FROM BP_DETAILS, POC
 WHERE BP_DETAILS.PORT_CODE = POC.PORT_CODE AND
       BP_DETAILS.VESSEL_NR = POC.VESSEL_NR AND
		 BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR AND
		 BP_DETAILS.PCN = POC.PCN AND
		 POC.VESSEL_NR  = :al_vessel_nr AND
		 POC.VOYAGE_NR  = :as_voyage_nr AND
		 POC.PURPOSE_CODE in ("DEL", "RED");

if not isnull(ll_pcn) then
	messagebox("Information", "This is registered Bunker Purchase on delivery/redelivery port(s). Please delete before changing voyage type.")
	return c#return.failure
end if

//Check if there is posted any bunker to CODA. Modify not allowed
SELECT BUNKER_POSTED_HFO +
       BUNKER_POSTED_DO  +
		 BUNKER_POSTED_GO  +
		 BUNKER_POSTED_LSHFO +
       BUNKER_POSTED_BUY   +
		 BUNKER_POSTED_LOSSPROFIT +
		 BUNKER_POSTED_OFFSERVICE +
		 BUNKER_POSTED_SELL
  INTO :ld_bunker_posted
  FROM VOYAGES
 WHERE VESSEL_NR = :al_vessel_nr AND
       VOYAGE_NR = :as_voyage_nr;

if ld_bunker_posted <> 0 then
	messagebox("Information", "There exist bunker postings on this voyage. Please correct before changing voyage type.")
	return c#return.failure
end if

if al_voyagetype = il_TIMECHARTEROUT then
	ld_calcid = 1
else
	SELECT IsNull(VESSELS.TCOWNER_NR, 0)
	  INTO :ll_tcowner
	  FROM VESSELS
	 WHERE VESSEL_NR = :al_vessel_nr;
	 
	SELECT Count(*)
	  INTO :ll_tcincontracts
	  FROM NTC_TC_CONTRACT
	 WHERE VESSEL_NR = :al_vessel_nr AND TC_HIRE_IN = 1;

	if ll_tcowner > 0 and ll_tcincontracts <= 0 then
		messagebox("Error", "This Vessel has a TC Owner but no TC IN Contract. Voyage is not allowed!")
		return c#return.failure
	end if
	
	setnull(ld_calcid)
end if

//Modify voyage type
UPDATE VOYAGES
   SET VOYAGE_TYPE = :al_voyagetype, 
       CAL_CALC_ID = :ld_calcid
 WHERE VESSEL_NR = :al_vessel_nr AND
       VOYAGE_NR = :as_voyage_nr;

return c#return.success

end function

public function long of_check_proceed_itenerary (long al_vessel_nr, string as_voyage_nr);/********************************************************************
   of_check_proceed_itenerary
   <DESC>	validate if proceeding matches itenerary	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	14/05/2012   CR2413       ZSW001       First Version
		25/03/2013   CR3049		  LGX001       Add VP recheck & Purpose recheck 
   </HISTORY>
********************************************************************/

string	ls_return

n_portvalidator			lnv_validator
u_tramos_nvo				lnv_tramos

/* check if proceeding matches itenerary in the calculation */
if f_atobviac_used(al_vessel_nr, as_voyage_nr) then
	lnv_validator = create n_portvalidator
	lnv_validator.of_set_checkitin_vp(true)
	/* portvalidator object called, only interested in the return value */
	ls_return = string(lnv_validator.of_start("VOYALLOCATOR", al_vessel_nr, as_voyage_nr, 3))
	destroy lnv_validator
else
	/* support bp calculations too */
	lnv_tramos = create u_tramos_nvo
	ls_return = lnv_tramos.uf_check_proceed_itenerary(al_vessel_nr, as_voyage_nr, true)
	destroy lnv_tramos
end if

if ls_return = "-1" or ls_return = "0" then
	return c#return.Failure
else
	return c#return.Success
end if


end function

public subroutine of_ownermatter_sendemail (long al_vesselnr, string as_voyagenr);/********************************************************************
   of_ownermatter_sendemail
   <OBJECT>		send email	</OBJECT>
   <USAGE>		when delete voyage	</USAGE>
   <ALSO>									</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
		25/12/2013	CR3085		WWG004		First Version
   </HISTORY>
********************************************************************/

long		ll_count_pocs, ll_count_pocs_est, ll_row
integer	li_pcn
string	ls_portcode

mt_n_datastore				lds_poc_estactomd
n_ownersmatter_sendmail lnv_owner_sendmail

lnv_owner_sendmail = CREATE n_ownersmatter_sendmail
lds_poc_estactomd	 = CREATE mt_n_datastore

lds_poc_estactomd.dataobject = "d_sq_gr_estact_poc"
lds_poc_estactomd.settransobject(sqlca)
ll_count_pocs = lds_poc_estactomd.retrieve(al_vesselnr, as_voyagenr)

if ll_count_pocs > 0 then
	for ll_row = 1 to ll_count_pocs
		li_pcn		= lds_poc_estactomd.getitemnumber(ll_row, "pcn")
		ls_portcode = lds_poc_estactomd.getitemstring(ll_row, "port_code")
		
		lnv_owner_sendmail.of_send_email(al_vesselnr, as_voyagenr, ls_portcode, li_pcn)
	next
end if

end subroutine

public function datetime of_get_pocvoyagestart (integer ai_vesselnr, string as_voyagenr);/********************************************************************
   of_get_pocvoyagestart
   <DESC>	Get the voyage start from POC	</DESC>
   <RETURN>	datetime</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vesselnr
		as_voyagenr
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/04/16		CR3099		CCY018        First Version
   </HISTORY>
********************************************************************/

datetime ldt_voyagestart

SELECT TOP 1 dbo.FN_GET_POCVOYAGESTART(:ai_vesselnr, :as_voyagenr)
INTO :ldt_voyagestart
FROM SYSTEM_OPTION;

return ldt_voyagestart
end function

public function datetime of_get_pocvoyageend (integer ai_vesselnr, string as_voyagenr);/********************************************************************
   of_get_pocvoyageend
   <DESC>	Get the voyage end from POC	</DESC>
   <RETURN>	datetime</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vesselnr
		as_voyagenr
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/04/16		CR3099		CCY018        First Version
   </HISTORY>
********************************************************************/

datetime ldt_voyageend

SELECT TOP 1 dbo.FN_GET_POCVOYAGEEND(:ai_vesselnr, :as_voyagenr)
INTO :ldt_voyageend
FROM SYSTEM_OPTION;

return ldt_voyageend
end function

public function integer of_get_pocvoyagestartend (integer ai_vesselnr, string as_voyagenr, ref datetime adt_voyagestart, ref datetime adt_voyageend);/********************************************************************
   of_get_pocvoyageend
   <DESC>	Get the voyage start and voyage end from POC	</DESC>
   <RETURN>integer </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vesselnr
		as_voyagenr
		adt_voyagestart
		adt_voyageend
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/04/16		CR3099		CCY018        First Version
   </HISTORY>
********************************************************************/

datetime ldt_voyageend

SELECT TOP 1 dbo.FN_GET_POCVOYAGESTART(:ai_vesselnr, :as_voyagenr), dbo.FN_GET_POCVOYAGEEND(:ai_vesselnr, :as_voyagenr)
INTO :adt_voyagestart, :adt_voyageend
FROM SYSTEM_OPTION;

return sqlca.sqlcode
end function

public function string of_get_fullvoyagenr (string as_voyagenr);/********************************************************************
   of_get_fullvoyagenr
   <DESC>Get the full voyage number</DESC>
   <RETURN>	string</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_voyagenr
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/04/16		CR3099		CCY018        First Version
   </HISTORY>
********************************************************************/

if left(as_voyagenr, 1) = "9" or left(as_voyagenr, 1) = "" then
	return "19" + as_voyagenr
else
	return "20" + as_voyagenr
end if
end function

public function integer of_deletevoyage (ref datawindow adw_proceeding_list);/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : w_proceeding_list
 Object     : cb_delete_voyage_number
 Event	 : clicked
 Scope     : button
 ************************************************************************************
 Author    : Bettina Olsen
 Date       : 14-01-97
 Description : if there´s no claims, disbursement expenses or disbursement payments
			the chosen voyage is deleted from voyage table. A report about the deletion 
			is generated and printed.
 Arguments : {description/none}
 Returns   : {description/none}  
 Variables : {important variables - usually only used in Open-event scriptcode}
 Other : {other comments}
*************************************************************************************
Development Log 
DATE			VERSION 	NAME			DESCRIPTION
-------- 		------- 		----- 			-------------------------------------
14-01-97			1.0		BHO		INITIAL VERSION
13-02-97			1.1		BHO		Change the where-clauses in the 
											part where we check if it´s legal
											to delete the voyage.
25-11-97			1.2		BHO		Insert an update of Electronic_file_status
26-02-03			1.3		KMY		Removed references to TCHIRES table; i.e. removed
											the table from the ls_table array
12-10-05		  14.08		RMO		Changed the implementation of OFF Serviced to hold Identity key
13/10/10       23.03         RMO003	Restriction implemented, that voyage can't be deleted if Special Claim Registered
29/10-10		  23.05         RMO003	Added parameter to control printing of report or not
01/11-10		  23.05        AGL027  added deletion of system generated attachments	
15/11/10		  23.06		JMC		Delete Task List
17/12-10		  24.03		RMO		added extra check if any bunker posting to CODA - not allowed to delete

DATE				CR# 			NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
08/09/16			CR3320 		AGL027		BMVM processing II - validate using VOYMASTER & TRANS_LOG if we are allowed to delete selected voyage
08/11/16			CR3320		AGL027		removed override due to no longer sending delete voyage report to default printer
************************************************************************************/
string  ls_table[],ls_voyage, ls_begin_tran = "begin transaction",ls_sql_delete,ls_end_tran = "commit transaction", ls_rollback = "rollback transaction",ls_names
long  ll_table_count,ll_max,ll_vessel, ll_selected_row, ll_trans_id
boolean lb_voyage_count
n_service_manager lnv_serviceMgr
n_fileattach_service lnv_attachmentservice
string ls_tablename, ls_vessel_ref_nr, ls_waitingtime, ls_voymaster_status, ls_voymaster_voyage_type, ls_voymaster_voyage
long ll_row, ll_voyagedocuments, ll_nbr_of_ax_transactions, ll_remaining_tcout_voyages
mt_n_datastore lds_systemattach
decimal ld_bunker_posted
integer li_voyage_type=0

s_voyageinfo	lstr_voyage

/* Set tables to delete in */
ls_table ={"VOYAGES","TRA_VOYH","OFF_SERVICES", /* removed by RMO: "NTC_OFF_SERVICE",*/ "IDLE_DAYS","PROCEED",/*removed by KMY: "TCHIRES",*/&
		"POC","POC_EST","BP_DETAILS","DISBURSEMENTS","CARGO","LAYTIME_STATEMENTS","TRA_NCAG","CD","LAY_DEDUCTIONS",&
		"BOL","GROUP_DEDUCTIONS","CCS_DATAWAREHOUSE","DISB_EXPENSES","DISB_PAYMENTS", "POC_TASK_LIST", "IDLE_VOYAGE_VAS_FIGURES"}
 
/* Get the voyage, that the user wants to delete.That is the selected row in proceeding dw */
ll_selected_row = adw_proceeding_list.getrow()

if ll_selected_row < 1 then
	/* Inform user and return */
	messagebox("Notice","You have not selected a Vessel/Voyage to delete")
	return -1
else
	/* Get vessel and voyage number for selected row */
	ls_voyage =adw_proceeding_list.GetItemString(ll_selected_row,"voyage_nr")
	ls_voymaster_voyage = left(ls_voyage,5)
	ll_vessel =adw_proceeding_list.GetItemnumber(ll_selected_row,"vessel_nr")	
end if

/* Voyage master processing - validate if we are allowed to delete selected voyage */
if of_validate_ax_voymaster_state( 3, ll_vessel, ls_voyage, "", li_voyage_type, ls_vessel_ref_nr)=c#return.Failure then
	return c#return.Failure	
end if	

/*Here comes the part where we check if it´s legal to delete the voyage */
/*It's only legal to delete if there are no attachments created by users */
SELECT isnull(COUNT(DISTINCT VESSEL_NR),0)
into :lb_voyage_count
FROM VOYAGE_DOCUMENT
WHERE VOYAGE_NR=:ls_voyage AND VESSEL_NR=:ll_vessel and (DOC_TYPE <> 2 or DOC_TYPE IS NULL);
commit;
if lb_voyage_count then
	messagebox("Notice","You can't delete this voyage, the voyage has either user documents attached or accruals generated!")
	rollback;
	return -1
end if

SELECT isnull(COUNT(DISTINCT VESSEL_NR),0)
into :lb_voyage_count
FROM CLAIMS
WHERE VOYAGE_NR=:ls_voyage AND VESSEL_NR=:ll_vessel;
commit;
if lb_voyage_count then
	messagebox("Notice","You can't delete this voyage, the voyage has claims!")
	rollback;
	return -1
end if

SELECT isnull(COUNT(DISTINCT VESSEL_NR),0)
into :lb_voyage_count
FROM SPECIAL_CLAIM
WHERE VOYAGE_NR=:ls_voyage AND VESSEL_NR=:ll_vessel;
commit;
if lb_voyage_count then
	messagebox("Notice","You can't delete this voyage, the voyage has special claims!")
	rollback;
	return -1
end if

SELECT isnull(COUNT(DISTINCT VESSEL_NR),0)
into :lb_voyage_count
FROM DISB_EXPENSES
WHERE VOYAGE_NR=:ls_voyage AND VESSEL_NR=:ll_vessel AND SETTLED=1;
commit;
if lb_voyage_count then
	messagebox("Notice","You can't delete this voyage, the voyage has disbursement expenses!")
	rollback;
	return -1
end if

SELECT isnull(COUNT(DISTINCT VESSEL_NR),0)
into :lb_voyage_count
FROM DISB_PAYMENTS
WHERE VOYAGE_NR=:ls_voyage AND VESSEL_NR=:ll_vessel AND PAYMENT_PRINT_DATE<> null;
commit;
if lb_voyage_count then
	messagebox("Notice","You can't delete this voyage, the voyage has disbursement payments!")
	rollback;
	return -1
end if

/* Check if there is posted any bunker to CODA. Modify not allowed */
SELECT VOYAGES.BUNKER_POSTED_HFO +   
	VOYAGES.BUNKER_POSTED_DO +   
	VOYAGES.BUNKER_POSTED_GO +   
	VOYAGES.BUNKER_POSTED_LSHFO +   
	VOYAGES.BUNKER_POSTED_BUY +   
	VOYAGES.BUNKER_POSTED_LOSSPROFIT +   
	VOYAGES.BUNKER_POSTED_OFFSERVICE +   
	VOYAGES.BUNKER_POSTED_SELL  
INTO :ld_bunker_posted  
FROM VOYAGES   
WHERE VESSEL_NR = :ll_vessel
	AND VOYAGE_NR = :ls_voyage ;
commit;

if ld_bunker_posted <> 0 then
	messagebox("Notice","You can't delete this voyage, the voyage has bunker posted to CODA!")
	return -1
end if

/*  Give the user a chance to stop the action */
if Messagebox("Notice","You are about to delete the voyage number " + ls_voyage +" for Vessel "  + ls_vessel_ref_nr +".~r~nDo you wish to do this?",Question!,OkCancel!,2) = 1 then 
	/* Set pointer to hourglass */
	setpointer(hourglass!)
	
	/* Start transaction */
	EXECUTE IMMEDIATE :ls_begin_tran using sqlca;

	/* First delete all off service relevant tables, as they now have identity columns, and can't be part of the loop */
	DELETE NTC_OFF_SERVICE_DETAIL  
		FROM  OFF_SERVICES, 
			NTC_OFF_SERVICE,   
			NTC_OFF_SERVICE_DETAIL   
		WHERE NTC_OFF_SERVICE_DETAIL.OFF_SERVICE_ID = NTC_OFF_SERVICE.OFF_SERVICE_ID and  
			OFF_SERVICES.OPS_OFF_SERVICE_ID = NTC_OFF_SERVICE.OPS_OFF_SERVICE_ID and  
			OFF_SERVICES.VESSEL_NR = :ll_vessel AND  
			OFF_SERVICES.VOYAGE_NR = :ls_voyage  ;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Deletion Error","The Voyage Number has not been deleted. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		EXECUTE IMMEDIATE:ls_rollback using sqlca;
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if

	DELETE NTC_OFS_DEPENDENT_CONTRACT_EXP  
		FROM  OFF_SERVICES, 
			NTC_OFF_SERVICE,   
			NTC_OFS_DEPENDENT_CONTRACT_EXP   
		WHERE NTC_OFS_DEPENDENT_CONTRACT_EXP.OFF_SERVICE_ID = NTC_OFF_SERVICE.OFF_SERVICE_ID and  
			OFF_SERVICES.OPS_OFF_SERVICE_ID = NTC_OFF_SERVICE.OPS_OFF_SERVICE_ID and  
			OFF_SERVICES.VESSEL_NR = :ll_vessel AND  
			OFF_SERVICES.VOYAGE_NR = :ls_voyage  ;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Deletion Error","The Voyage Number has not been deleted. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		EXECUTE IMMEDIATE:ls_rollback using sqlca;
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if

	DELETE  NTC_OFF_SERVICE 
		FROM  OFF_SERVICES, 
			NTC_OFF_SERVICE   
		WHERE OFF_SERVICES.OPS_OFF_SERVICE_ID = NTC_OFF_SERVICE.OPS_OFF_SERVICE_ID and  
			OFF_SERVICES.VESSEL_NR = :ll_vessel AND  
			OFF_SERVICES.VOYAGE_NR = :ls_voyage  ;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Deletion Error","The Voyage Number has not been deleted. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		EXECUTE IMMEDIATE:ls_rollback using sqlca;
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if

	/* deleting any system generated attachments in both Tramos and the Files db */
	lds_systemattach = create mt_n_datastore
	lds_systemattach.dataobject= "d_sq_tb_voyage_document_file_listing"
	lds_systemattach.settransobject( sqlca)
	ll_voyagedocuments = lds_systemattach.retrieve(ll_vessel, ls_voyage )
	if ll_voyagedocuments>0 then
		lnv_serviceMgr.of_loadservice( lnv_attachmentService, "n_fileattach_service" )
		lnv_attachmentservice.of_activate()
		ls_tablename = lds_systemattach.Object.DataWindow.Table.UpdateTable + "_FILES"	
		// prepare the files database table VOYAGE_DOCUMENT_FILES to remove system generated attachments	
		for ll_row = 1 to ll_voyagedocuments
			if lnv_attachmentService.of_deleteblob(ls_tablename, lds_systemattach.getitemnumber(ll_row,"file_id"),false) = 0 then
				_addmessage( this.classdefinition, "of_deletevoyage()", "error, unable to delete system generated attachment for this voyage" , "n/a")
				EXECUTE IMMEDIATE:ls_rollback using sqlca;
				lnv_attachmentservice.of_rollback( )
				destroy lnv_attachmentservice
				return c#return.Failure
			end if
		next
	end if
	destroy lds_systemattach
	
	DELETE  VOYAGE_DOCUMENT 
	WHERE VOYAGE_DOCUMENT.VESSEL_NR = :ll_vessel AND  
			VOYAGE_DOCUMENT.VOYAGE_NR = :ls_voyage;

	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Deletion Error","The Voyage Number has not been deleted. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		EXECUTE IMMEDIATE:ls_rollback using sqlca;
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return c#return.Failure
	end if
	
	lstr_voyage = of_get_voyageinfo(ll_vessel, ls_voyage)		//M5-1 Added by ZSW001 on 27/03/2012
	
	of_ownermatter_sendemail(ll_vessel, ls_voyage)
	DELETE  
	  FROM OWNER_MATTERS_DEPARTMENT   
	 WHERE VESSEL_NR = :ll_vessel 
	   AND VOYAGE_NR = :ls_voyage;
	if sqlca.sqlcode <> 0 then
		messagebox("Voyage Number Deletion Error", "The Voyage Number has not been deleted. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		EXECUTE IMMEDIATE:ls_rollback using sqlca;
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	
	/* here comes the part where we delete the old voyage number from all all the tables containing voyage number*/
	ll_max = upperbound (ls_table)
	for ll_table_count= ll_max to 1 step -1
		ls_sql_delete="DELETE FROM " +ls_table[ll_table_count] + " WHERE VOYAGE_NR = '" + ls_voyage + "' AND VESSEL_NR = " +string(ll_vessel) 
		EXECUTE IMMEDIATE: ls_sql_delete using sqlca;
		if sqlca.sqlcode <> 0 then
			messagebox("Voyage Number Deletion Error","The Voyage Number has not been deleted. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
			EXECUTE IMMEDIATE:ls_rollback using sqlca;
			/* Set pointer back to arrow */
			setpointer(arrow!)
			return -1
		end if
	next
	
	//M5-1 Begin added by ZSW001 on 27/03/2012
	if lstr_voyage.voyagecount = 0 then
		lstr_voyage.status = 'D'
		of_log_voyagechanges(lstr_voyage)
	end if
	//M5-1 End added by ZSW001 on 27/03/2012

	/* end transaction */
	EXECUTE IMMEDIATE:ls_end_tran using sqlca;
	
	/* commit any voyage documents in files database */
	if ll_voyagedocuments>0 then
		lnv_attachmentservice.of_commit( )
		lnv_attachmentservice.of_deactivate()
	end if
	if isvalid(lnv_attachmentservice) then destroy lnv_attachmentservice
	setpointer(arrow!)
	return 1
end if

return -1
end function

public function integer of_repostclaim (ref mt_n_datastore ads_claim_list, string as_new_voyagenumber, ref s_voyageinfo_claim astr_claims[]);/********************************************************************
   of_repostclaim
   <DESC> This function is for re-posting claim transactions of type "Claims" 
	       when change voyage number
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_claim_list
		as_old_voyagenumber
		as_new_voyagenumber
   </ARGS>
   <USAGE>	this is called from of_modifyvoyage()</USAGE>
   <HISTORY>
   	Date       	CR-Ref	Author	Comments
   	26/02/2013 	CR3112	LGX001	First Version
		28/07/15		CR3872	AGL027	BMVM - Batch Management Voyage number Modification
		07/08/2016 	CR3320	AGL027	BMVM - Batch Management of Voyage master management.
   </HISTORY>
********************************************************************/
mt_n_datastore	lds_claim_apost, lds_claim_bpost
mt_n_datastore	lds_new_apost, lds_new_bpost

long 		ll_vessel, ll_transkey
long 		ll_claim_brows, ll_claim_brow 
long		ll_claim_arows, ll_claim_arow
long 		ll_new_brows, ll_new_brow, ll_paymentid, ll_found, ll_row
string 	ls_vessel_refnr
string	ls_null
datetime	ldt_null
long ll_claimid[], ll_new_claimid[], ll_claim_id
long ll_null

setnull(ll_null)
setnull(ldt_null)
setnull(ls_null)

if ads_claim_list.rowcount() <= 0 then
	return c#return.Success
end if

ll_vessel = ads_claim_list.GetItemnumber(1, "claims_vessel_nr")
ls_vessel_refnr = f_get_vsl_ref(ll_vessel)
if isnull(ls_vessel_refnr) or ls_vessel_refnr = "" then
	messagebox("Error reading vessel refnr", "The Voyage Number cannot be modified due to error :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
	//Set pointer back to arrow
	setpointer(arrow!)
	return c#return.Failure
end if

ll_claimid = ads_claim_list.object.claim_id.primary
ll_new_claimid = ads_claim_list.object.claims_new_claim_id.primary

// Find out if there are transactions
lds_claim_apost = create mt_n_datastore
lds_claim_apost.dataobject = "d_sq_gr_repost_claim_trans_log_a"
lds_claim_apost.settransobject(sqlca)
ll_claim_arows = lds_claim_apost.retrieve(ll_claimid)

// Check if any records, otherwise return - claim trans to repost 
if ll_claim_arows < 1 then
	destroy lds_claim_apost
	return c#return.Success
end if

// There are transactions to repost
lds_claim_bpost = create mt_n_datastore
lds_claim_bpost.dataobject = "d_sq_gr_repost_trans_log_b"
lds_claim_bpost.settransobject(sqlca)

lds_new_apost = create mt_n_datastore
lds_new_apost.dataobject = "d_trans_log_main_a"
lds_new_apost.settransobject(sqlca)

lds_new_bpost = create mt_n_datastore
lds_new_bpost.dataobject = "d_trans_log_b"
lds_new_bpost.settransobject(sqlca)

for ll_claim_arow = 1 to ll_claim_arows
	/************************************************************/
	/* FIRST GENERATE REVERT POST                               */
	/************************************************************/
	lds_new_apost.reset()
	lds_new_bpost.reset()
	ll_transkey = lds_claim_apost.getitemnumber(ll_claim_arow, "trans_key")
	ll_claim_brows = lds_claim_bpost.retrieve(ll_transkey)
	
	// must set the payment id = NULL before reverting
	ll_paymentid = lds_claim_apost.getitemnumber(ll_claim_arow, "payment_id")
	lds_claim_apost.setitem(ll_claim_arow, "payment_id", ll_null)

	// move claim a post to revert (new) apost without transkey
	lds_new_apost.insertRow(0)
	lds_new_apost.object.data[1, 2, 1, 56] = lds_claim_apost.object.data[ll_claim_arow, 2, ll_claim_arow, 56]
	lds_new_apost.setitem(1, "file_date", ldt_null)
	lds_new_apost.setitem(1, "file_user", ls_null)
	lds_new_apost.setitem(1, "file_name", ls_null)
	lds_new_apost.setitem(1, "f03_yr", year(today()))
	lds_new_apost.setitem(1, "f04_period", month(Today()))
	lds_new_apost.setitem(1, "f07_docnum", ls_null)
	lds_new_apost.setitem(1, "trans_date", datetime(today(), now()))
	lds_new_apost.setitem(1, "f09_docdate", datetime(today(), now()))
	lds_new_apost.setitem(1, "trans_user", uo_global.getuserid())
	lds_new_apost.setitem(1, "f05_auth_user", uo_global.getuserid())
	if lds_new_apost.getitemnumber(1, "f29_debitcredit") = 160 then
		lds_new_apost.setitem(1, "f29_debitcredit", 161)
	else
		lds_new_apost.setitem(1, "f29_debitcredit", 160)
	end if
		
	lds_new_apost.setitem(1, "f41_linedesr", "ClaimsCreditNote")
	
	// move claim b post to revert (new) bpost without transkey
	do while lds_new_bpost.insertrow(0) < ll_claim_brows
		// insert rows into b-post
	loop
	lds_new_bpost.object.data[1, 2, ll_claim_brows, 25] = lds_claim_bpost.object.data[1, 2, ll_claim_brows, 25]
	for ll_claim_brow = 1 to ll_claim_brows
		// get the claim type
		if ll_claim_brow = 1 then
			astr_claims[ll_claim_arow].s_claim_type = lds_claim_bpost.getitemstring(1, "f41_linedesr")	
		end if	
		lds_new_bpost.setitem(ll_claim_brow, "f03_yr", year(today()))
		lds_new_bpost.setitem(ll_claim_brow, "f04_period", month(Today()))
		if lds_new_bpost.getitemnumber(ll_claim_brow, "f29_debitcredit") = 160 then
			lds_new_bpost.setitem(ll_claim_brow, "f29_debitcredit", 161)
		else
			lds_new_bpost.setitem(ll_claim_brow, "f29_debitcredit", 160)
		end if
	next		
	// Save apost and fill transkey in bpost and save bpost
	if lds_new_apost.update() = 1 then
		
		astr_claims[ll_claim_arow].l_cnote_trans_id_ref = lds_new_apost.getitemnumber(1, "trans_key")
		astr_claims[ll_claim_arow].i_claim_nr = lds_new_apost.getitemnumber(1, "claim_pcn_nr")	

//		al_trans_id_creditnote_ref[ll_claim_arow] = lds_new_apost.getitemnumber(1, "trans_key")
		if isnull(astr_claims[ll_claim_arow].l_cnote_trans_id_ref) or astr_claims[ll_claim_arow].l_cnote_trans_id_ref = 0 then
			messagebox("Generate transaction error", "No value found for transaction key")
			destroy lds_claim_apost
			destroy lds_claim_bpost
			destroy lds_new_apost
			destroy lds_new_bpost
			return c#return.Failure
		else
			
			ll_new_brows = lds_new_bpost.rowcount()
			for ll_new_brow = 1 to ll_new_brows
				lds_new_bpost.setitem(ll_new_brow, "trans_key", astr_claims[ll_claim_arow].l_cnote_trans_id_ref)
			next
			lds_new_bpost.accepttext()
			if lds_new_bpost.update() = 1 then
				// continue with next step
			else
				messagebox("Error", "ids_Apost ok, but ids_Bpost went wrong in update")
				destroy lds_claim_apost
				destroy lds_claim_bpost
				destroy lds_new_apost
				destroy lds_new_bpost
				return c#return.Failure
			end if
		end if
	else
		messagebox("Error", "Update of ids_Apost went wrong" + SQLCA.SqlErrText)
		destroy lds_claim_apost
		destroy lds_claim_bpost
		destroy lds_new_apost
		destroy lds_new_bpost
		return c#return.Failure
	end if

	/************************************************************/
	/* NEXT GENERATE NEW POST FOR NEW VOYAGE NUMBER             */
	/************************************************************/
	lds_new_apost.reset()
	lds_new_bpost.reset()
	// move claim a post to revert (new) apost without transkey
	lds_new_apost.insertRow(0)
	lds_new_apost.object.data[1, 2, 1, 56] = lds_claim_apost.object.data[ll_claim_arow, 2, ll_claim_arow, 56]
	lds_new_apost.setitem(1, "file_date", ldt_null)
	lds_new_apost.setitem(1, "file_user", ls_null)
	lds_new_apost.setitem(1, "file_name", ls_null)
	lds_new_apost.setitem(1, "f03_yr", year(today()))
	lds_new_apost.setitem(1, "f04_period", month(Today()))
	lds_new_apost.setitem(1, "f07_docnum", ls_null)
	lds_new_apost.setitem(1, "trans_date", Today()) 
	lds_new_apost.setitem(1, "trans_user", uo_global.getuserid())
	// this is created & prepared here, but not sent from tramos client.
	lds_new_apost.setitem(1, "file_name", "pending") 
	
	// set new voyage and new linked payment id (new claim id) 
	lds_new_apost.setitem(1, "f16_el6", "T"+as_new_voyagenumber)
	for ll_row = 1 to upperbound(ll_claimid)
		if ll_claimid[ll_row] = ll_paymentid then
			ll_claim_id = ll_new_claimid[ll_row]
			lds_new_apost.setitem(1, "payment_id", ll_new_claimid[ll_row])
		   exit
		end if
	next
	
	// move claim b post to revert (new) bpost without transkey
	do while lds_new_bpost.insertrow(0) < ll_claim_brows
		// insert rows into b-post
	loop
	lds_new_bpost.object.data[1, 2, ll_claim_brows, 25] = lds_claim_bpost.object.data[1, 2, ll_claim_brows, 25]
	for ll_claim_brow = 1 to ll_claim_brows
		lds_new_bpost.setitem(ll_claim_brow, "f03_yr", year(today()))
		lds_new_bpost.setitem(ll_claim_brow, "f04_period", month(Today()))
		lds_new_bpost.setitem(ll_claim_brow, "f16_el6_b", "T"+as_new_voyagenumber)
	next		
	// Save apost and fill transkey in bpost and save bpost
	if lds_new_apost.update() = 1 then
		astr_claims[ll_claim_arow].l_claim_trans_id_ref = lds_new_apost.getitemnumber(1, "trans_key")
		if isnull(astr_claims[ll_claim_arow].l_claim_trans_id_ref) or astr_claims[ll_claim_arow].l_claim_trans_id_ref = 0 then
			messageBox("Generate transaction error", "No value found for transaction key")
			destroy lds_claim_apost
			destroy lds_claim_bpost
			destroy lds_new_apost
			destroy lds_new_bpost
			return c#return.Failure
		else
			ll_new_brows = lds_new_bpost.rowcount()
			for ll_new_brow = 1 to ll_new_brows
				lds_new_bpost.setitem(ll_new_brow, "trans_key", astr_claims[ll_claim_arow].l_claim_trans_id_ref)
			next
			lds_new_bpost.accepttext()
			if lds_new_bpost.update() = 1 then
				// continue with next step
			else
				messagebox("Error", "ids_Apost ok, but ids_Bpost went wrong in update")
				destroy lds_claim_apost
				destroy lds_claim_bpost
				destroy lds_new_apost
				destroy lds_new_bpost
				return c#return.Failure
			end if
		end if
	else
		messagebox("Error", "Update of ids_Apost went wrong" + SQLCA.SqlErrText)
		destroy lds_claim_apost
		destroy lds_claim_bpost
		destroy lds_new_apost
		destroy lds_new_bpost
		return c#return.Failure
	end if
	
	UPDATE CLAIMS
      SET LOCKED = 1, INVOICE_NR = ''
    WHERE CLAIM_ID = :ll_claim_id;
	
	if sqlca.sqlcode <> 0 then
		messagebox("Error", "Update of table CLAIMS went wrong. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy lds_claim_apost
		destroy lds_claim_bpost
		destroy lds_new_apost
		destroy lds_new_bpost
		return c#return.Failure
	end if
	
	//last row
	if ll_claim_arow = ll_claim_arows then
		// update apost to set payment id = NULL
		if lds_claim_apost.update() <> 1 then
			messagebox("Error", "Update of trans Apost went wrong" + SQLCA.SqlErrText)
			destroy lds_claim_apost
			destroy lds_claim_bpost
			destroy lds_new_apost
			destroy lds_new_bpost
			return c#return.Failure
		end if
	end if	
next

destroy lds_claim_apost
destroy lds_claim_bpost
destroy lds_new_apost
destroy lds_new_bpost

return c#return.Success
end function

public function integer of_get_outstanding_voymaster_trans_count (string as_vessel_ref_nr, string as_voyage_nr, ref string as_waitingtime, ref long al_trans_id);/********************************************************************
of_get_outstanding_vomaster_trans_count( /*string as_vessel_ref_nr*/, /*string as_voyage_nr */)

<DESC>
	function used to validate following user actions:
		create a new voyage
		modify voyage number
		delete voyage number
	It should not be possible to complete above actions (this is just 1 of many validations) if Tramos 
	has not received confirmation from AX that is simply 'Success'	
</DESC>
<RETURN> 
	Integer:
		<LI> count of transactions that are considered pending., when its 0 (zero) all is well to proceed.
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	as_vessel_ref_nr: reference of the vessel
	as_voyage_nr: 		this is used to validate both VOYAGE_NR and OLD_VOYAGE_NR.  We cannot have a NEW/MODIFY voyage event 
							in a voyage that has not been confirmed after a modify.
</ARGS>
<USAGE>
	Used inside this object for delete and modify processes.  
	Called from object w_voyage cb_update.clicked() event for the new voyage.
</USAGE>
********************************************************************/

integer li_count=0
long ll_total_secs=0
as_waitingtime = ""
mt_n_datefunctions	lnv_datefunc

SELECT count(1)
INTO :li_count
FROM VOYAGE_MASTER 
WHERE VESSEL_REF_NR = :as_vessel_ref_nr 
AND (VOYAGE_NR = :as_voyage_nr OR OLD_VOYAGE_NR = :as_voyage_nr)  
AND (UPPER(AX_MESSAGE)<>"SUCCESS" OR AX_MESSAGE is null) 
commit;

if li_count>0 then
	SELECT top 1 datediff(ss,TRANS_DATE,getdate()), TRANS_ID
	INTO :ll_total_secs, :al_trans_id
	FROM VOYAGE_MASTER 
	WHERE VESSEL_REF_NR = :as_vessel_ref_nr 
	AND (VOYAGE_NR = :as_voyage_nr OR OLD_VOYAGE_NR = :as_voyage_nr)  
	AND (UPPER(AX_MESSAGE)<>"SUCCESS" OR AX_MESSAGE is null) 
	commit;
	as_waitingtime = lnv_datefunc.of_get_nice_time_format(ll_total_secs,true)	
end if

return li_count
end function

public function integer of_get_outstanding_voymaster_data (long al_trans_id, ref string as_status, ref integer ai_voyage_type);/********************************************************************
of_get_outstanding_voyage_data( /*string as_vessel_ref_nr*/, /*string as_voyage_nr */)

<DESC>
	function used to assist validation of user actions:
		create a new TC-OUT voyage
		modify last TC-OUT voyage number
		delete last TC-OUT voyage number
</DESC>
<RETURN> 
	Integer:
		<LI> provide status (Modify/New/Delete) and type of voyage.
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	al_trans_id: reference the voyage master record 
</ARGS>
<USAGE>
	Used inside this object for additional TC-OUT validations.  
	Called from object w_voyage cb_update.clicked() event for the new voyage.
	We only expect 1 record to be retreived
</USAGE>
********************************************************************/
string ls_voyage_type
SELECT STATUS, VOYAGE_TYPE
INTO :as_status, :ls_voyage_type
FROM VOYAGE_MASTER 
WHERE TRANS_ID = :al_trans_id
commit;

if ls_voyage_type = 'T' then
	ai_voyage_type = 2
else
	ai_voyage_type = 1
end if

return c#return.Success
end function

public function integer of_validate_ax_voymaster_state (integer ai_sender, long al_vessel_nr, string as_voyage_nr, string as_modified_voyage_nr, ref integer ai_voyage_type, ref string as_vessel_ref_nr);/********************************************************************
of_validate_ax_voymaster_state( /*integer ai_sender*/, /*long al_vessel_nr*/, /*string as_voyage_nr*/, /*string as_modified_voyage_nr*/, /*ref integer ai_voyage_type*/, /*ref string as_vessel_ref_nr */)

<DESC>
	this function contains all the logic required to validate if AX has updates pending inside its system.  (CR3320)
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	integer ai_sender					:identifier that allows different workflow through the code depending on where this function is called from. 
	long al_vessel_nr					:vessel number
	string as_voyage_nr				:fully formed original voyage number (17001; 1750101 etc)
	string as_modified_voyage_nr	:only when sender is li_MODIFY(4) will we have the fully formed voyage number that user wants to modify to
	ref integer ai_voyage_type		:type of voyage, 0=EMPTY; 1=SINGLE; 2=TCOUT
	ref string as_vessel_ref_nr	:the reference number of vessel is found here and passed back as a reference
</ARGS>
<USAGE>
	called from this object of_deletevoyage() and of_modifyvoyage()
	also from w_voyage on cb_update.clicked() event where there are 2 calls.
</USAGE>
********************************************************************/

string ls_message, ls_vessel_ref_nr, ls_voymaster_voyage, ls_voyage_type, ls_status, ls_waitingtime, ls_voymaster_modfified_voyage
long ll_remaining_tcout_voyages, ll_vessel, ll_trans_id, ll_nbr_of_ax_transactions
integer li_modified_voyage_type

/* sender type */
constant int li_SIMPLECREATE = 1
constant int li_CREATE = 2
constant int li_DELETE = 3
constant int li_MODIFY = 4

as_vessel_ref_nr = f_get_vsl_ref(al_vessel_nr)
ls_voymaster_voyage = left(as_voyage_nr,5)
ls_voymaster_modfified_voyage = left(as_modified_voyage_nr,5)

/* additional logic dedicted to delete voyage event */
if ai_sender = li_DELETE and len(as_voyage_nr)=5 then

	SELECT TOP 1 TRANS_KEY 
	INTO :ll_nbr_of_ax_transactions
	FROM TRANS_LOG_MAIN_A 
	WHERE F15_EL5 = 'V' + :as_vessel_ref_nr AND 
	F16_EL6 = 'T' + :ls_voymaster_voyage AND
	dateadd(second,10,TRANS_DATE) > (SELECT MAX(TRANS_DATE) FROM VOYAGE_MASTER WHERE VOYAGE_MASTER.VOYAGE_NR = :ls_voymaster_voyage AND
	VOYAGE_MASTER.VESSEL_REF_NR = :as_vessel_ref_nr)
	commit;
	
	if ll_nbr_of_ax_transactions > 0 then
		rollback;
		messagebox("Notice","Sorry, you cannot delete this voyage, the voyage has AX transactions generated.")
		return c#return.Failure	
	end if
end if

/* test if voyage master has any record for vessel/voyage pair that is not set to 'Success' */
if of_get_outstanding_voymaster_trans_count(as_vessel_ref_nr, ls_voymaster_voyage, ls_waitingtime, ll_trans_id)>0 &
and ls_voymaster_voyage<>ls_voymaster_modfified_voyage then
	if ai_sender = li_SIMPLECREATE then
		/* the simple case of yes there is a record pending, show the message and return */
		rollback;
		messagebox("Notice","You cannot create this voyage right now because it has updates pending inside AX." + c#string.cr + c#string.cr + &
		"Voyage transaction created " + ls_waitingtime + " ago, it is normally completed in approx. 5 minutes.")
		return c#return.Failure
	else
		/* verify the voyage type */
		if ai_voyage_type=0 then
			of_get_outstanding_voymaster_data(ll_trans_id, ls_status, ai_voyage_type)
		end if
		if ai_voyage_type=il_TIMECHARTEROUT then		
			/* locate in VOYAGES if there are any other TC-OUT main voyage numbers matching the old main voyage number */
			SELECT count(1) 
			INTO :ll_remaining_tcout_voyages
			FROM VOYAGES 
			WHERE VESSEL_NR=:al_vessel_nr AND (LEFT(VOYAGE_NR,5) =:ls_voymaster_voyage AND VOYAGE_NR<>:as_voyage_nr)
			commit;
		end if
		if ll_remaining_tcout_voyages = 0 then	
			/* if either SPOT or TC-OUT with no existing other segments (e.g. if only TC-OUT voyage is the one we are wanting to update) */
			CHOOSE CASE ai_sender
				CASE li_CREATE
					ls_message = "You cannot create this voyage because it has updates pending inside AX." + c#string.cr + c#string.cr + &
					"Voyage transaction created " + ls_waitingtime + " ago, it is normally completed in approx. 5 minutes."
				CASE li_DELETE
					ls_message = "You cannot delete this voyage because it has updates pending inside AX." + c#string.cr + c#string.cr + &
					"Voyage transaction created " + ls_waitingtime + " ago, it is normally completed in approx. 5 minutes."					
				CASE li_MODIFY	
					ls_message = "You cannot modify because the existing voyage number has updates pending inside AX." + c#string.cr + c#string.cr + &
					"Voyage transaction created " + ls_waitingtime + " ago, it is normally completed in approx. 5 minutes."
					
			END CHOOSE
			rollback;
			messagebox("Notice",ls_message)
			return c#return.Failure
		end if 	
	end if
else 
	if ai_sender = li_MODIFY then
		/* now we validate the new voyage number in similar way to above */
		if of_get_outstanding_voymaster_trans_count(as_vessel_ref_nr, ls_voymaster_modfified_voyage, ls_waitingtime, ll_trans_id) > 0  &
		and ls_voymaster_voyage<>ls_voymaster_modfified_voyage then
			of_get_outstanding_voymaster_data(ll_trans_id, ls_status, li_modified_voyage_type)
			
			if li_modified_voyage_type=il_TIMECHARTEROUT then
				/* locate in VOYAGES if there are any TC-OUT main voyage numbers matching the new voyage */				
				SELECT count(1) 
				INTO :ll_remaining_tcout_voyages
				FROM VOYAGES 
				WHERE VESSEL_NR=:al_vessel_nr AND LEFT(VOYAGE_NR,5) = :ls_voymaster_modfified_voyage
				commit;
			end if

			if ll_remaining_tcout_voyages = 0 then	
				/* if either SPOT or TC-OUT voyage with no main voyage numbers matching the new already */
				rollback;
				messagebox("Notice","You cannnot modify because the new voyage number has updates pending inside AX." + c#string.cr + c#string.cr + &
				"Voyage transaction created " + ls_waitingtime + " ago, it is normally completed in approx. 5 minutes.")
				return c#return.Failure
			end if
		end if	
	end if
end if

return c#return.Success
end function

public function integer of_refresh_task_list (long al_vessel, string as_voyage);/********************************************************************
of_refresh_task_list
   <DESC>Refresh task list for a specific port of call </DESC> 
   <RETURN> </RETURN>
   <ACCESS> Public 	</ACCESS>
   <ARGS>	al_vessel: Vessel number
            	as_voyagenr: Voyage number
	</ARGS>
   <USAGE> Refresh task list when voyage type changes</USAGE>
  <HISTORY>
		Date     CR-Ref        Author   Comments
	22/03/17		CR4439		HHX010		First Version
   </HISTORY>	
********************************************************************/
long li_pc_nr

SELECT  PC_NR
INTO  :li_pc_nr
FROM VESSELS
WHERE VESSEL_NR = :al_vessel;
if sqlca.sqlcode <> 0 then 
	return -1
end if

//Delete tasks not done
DELETE 
FROM POC_TASK_LIST
WHERE VESSEL_NR = :al_vessel
AND VOYAGE_NR = :as_voyage
AND TASK_NA <> 1 AND TASK_DONE <> 1;
if sqlca.sqlcode <> 0 then 
	return -1
end if

INSERT INTO POC_TASK_LIST (VESSEL_NR, VOYAGE_NR, PORT_CODE, PCN, TASK_ID, TASK_SORT)
SELECT POC.VESSEL_NR,   
		   POC.VOYAGE_NR,   
		   POC.PORT_CODE,   
		   POC.PCN  ,
		   POC_TASKS_CONFIG_PC.TASK_ID,
		   POC_TASKS_CONFIG_PC.TASK_SORT
		FROM POC, POC_TASKS_CONFIG_PC, VOYAGES
		WHERE POC.VESSEL_NR = :al_vessel
			AND POC.VOYAGE_NR = :as_voyage
			AND POC_TASKS_CONFIG_PC.PURPOSE_CODE = POC.PURPOSE_CODE
			AND	POC_TASKS_CONFIG_PC.PC_NR = :li_pc_nr
			AND VOYAGES.VESSEL_NR = POC.VESSEL_NR
           	AND VOYAGES.VOYAGE_NR = POC.VOYAGE_NR 
			AND ((VOYAGES.VOYAGE_TYPE <> 2 AND POC_TASKS_CONFIG_PC.TASK_USE_TCOUT = 0) OR (VOYAGES.VOYAGE_TYPE = 2))		
			AND POC_TASKS_CONFIG_PC.TASK_ID NOT IN 
					(SELECT POC_TASK_LIST.TASK_ID 
						FROM POC_TASK_LIST
						WHERE POC_TASK_LIST.VESSEL_NR = :al_vessel
							AND POC_TASK_LIST.VOYAGE_NR = :as_voyage
							AND POC_TASK_LIST.PORT_CODE = POC.PORT_CODE
							AND POC_TASK_LIST.PCN = POC.PCN);
if sqlca.sqlcode <> 0 then 
	return -1
end if							
							
INSERT INTO POC_TASK_LIST (VESSEL_NR, VOYAGE_NR, PORT_CODE, PCN, TASK_ID, TASK_SORT)							
SELECT POC_EST.VESSEL_NR,   
		   POC_EST.VOYAGE_NR,   
		   POC_EST.PORT_CODE,   
		   POC_EST.PCN  ,
		   POC_TASKS_CONFIG_PC.TASK_ID,
		   POC_TASKS_CONFIG_PC.TASK_SORT
	FROM POC_EST, POC_TASKS_CONFIG_PC, VOYAGES
	WHERE POC_EST.VESSEL_NR =  :al_vessel
		AND   POC_EST.VOYAGE_NR = :as_voyage
		AND POC_TASKS_CONFIG_PC.PURPOSE_CODE = POC_EST.PURPOSE_CODE
		AND	POC_TASKS_CONFIG_PC.PC_NR = :li_pc_nr
		AND VOYAGES.VESSEL_NR = POC_EST.VESSEL_NR
		AND VOYAGES.VOYAGE_NR = POC_EST.VOYAGE_NR
		AND (( VOYAGES.VOYAGE_TYPE <> 2 AND POC_TASKS_CONFIG_PC.TASK_USE_TCOUT = 0) OR (VOYAGES.VOYAGE_TYPE = 2))		
		AND 	POC_TASKS_CONFIG_PC.TASK_ID NOT IN 
				(SELECT POC_TASK_LIST.TASK_ID 
					FROM POC_TASK_LIST
					WHERE POC_TASK_LIST.VESSEL_NR =  :al_vessel
						AND POC_TASK_LIST.VOYAGE_NR = :as_voyage
						AND POC_TASK_LIST.PORT_CODE = POC_EST.PORT_CODE
						AND POC_TASK_LIST.PCN = POC_EST.PCN );	
if sqlca.sqlcode <> 0 then 
	return -1
end if						
																												
return 1
end function

on n_voyage.create
call super::create
end on

on n_voyage.destroy
call super::destroy
end on

