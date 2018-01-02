$PBExportHeader$n_vessel_modify.sru
$PBExportComments$This object is used to change vessel numbers
forward
global type n_vessel_modify from nonvisualobject
end type
end forward

global type n_vessel_modify from nonvisualobject
end type
global n_vessel_modify n_vessel_modify

forward prototypes
public function integer of_modifyvessel (integer al_vessel, integer al_new_vessel)
end prototypes

public function integer of_modifyvessel (integer al_vessel, integer al_new_vessel);/************************************************************************************
 Author  : Regin mortensen
 Date    : 09/05-2006
 Description :	The user choose the vessel to be modified and to what number. 
 					It is only possible to modify vessel number in two ways
					 1) FROM number from 1 to 999 TO number between 1 to 999 (ex. 005 -> 347)
					 2) FROM number from 1 to 999 TO same number plus 10000 (ex. 251 -> 10251)
					 
					The new vessel number is created and the old is deleted.
					After this a report about the modification is printed.
 Arguments 	: {description/none}
 Returns   	: {description/none}  
 Variables 	: {important variables - usually only used in Open-event scriptcode}
 Other 		: {other comments}
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-----------		---------- 		------ 			-------------------------------------
09/05-06			14.14			RMO			First release
************************************************************************************/
n_sql_table_function inv_sql
string 		ls_columns[], ls_insert, ls_insert_sql, ls_table[]
string			ls_sql_delete, ls_update, ls_update_history
long 			ll_counter, ll_table_count,ll_max, ll_selected_row
integer 		li_pos[], li_array_size, li_vessel_number_position
datetime 	ld_date
boolean 		lb_vessel_count
string 		ls_vessel_comment, ls_names

/* Validate to and from vessel number */
/* 1) Find out if the vessel number already exists, inform user and return if unavailable */
SELECT isnull(COUNT(VESSEL_NR),0)
	into :lb_vessel_count
	FROM VESSELS
	WHERE VESSEL_NR=:al_new_vessel;
if lb_vessel_count then
	messagebox("Validation Error","The vessel number you are trying to change to already exists")
	return -1
end if

/* 2) Check if changed */
if al_new_vessel > 9999 then 
	if (al_vessel + 10000) <> al_new_vessel then
		MessageBox("Validation Error", "Entered Vessel number not correct. Must be current number + 10000.")
		return -1
	end if
else
	if al_new_vessel < 1 then
		MessageBox("Validation Error", "Entered Vessel number not correct. Must be > 0.")
		return -1
	end if
end if		

/* Set tables to modify */
ls_table ={"VESSELS", "VOYAGES","IOM_SIN_VESSELS", "OFF_SERVICES","CLAIMS","IDLE_DAYS","PROCEED", "TCHIRES", "COMMISSIONS","FREIGHT_ADVANCED",&
		"HEA_DEV_CLAIMS","FREIGHT_CLAIMS","DEM_DES_CLAIMS","CLAIM_TRANSACTION","CLAIM_ACTION","POC","POC_EST","BP_DETAILS",&
		"DISBURSEMENTS","FREIGHT_ADVANCED_RECIEVED","FREIGHT_RECEIVED","DEM_DES_RATES","CARGO","LAYTIME_STATEMENTS",&
		"DISB_EXPENSES","DISB_PAYMENTS","CD","LAY_DEDUCTIONS","BOL","GROUP_DEDUCTIONS", "TRA_NCAG", "TRA_VOYH", &
		"VAS_FILE_DATA", "FIN_RESP_HISTORY", "DAILY_RUNNING_COSTS", "TCHIRERATES", "TCHIREOFFHIRES", "TANK", "CAL_CONS", "VSL_CNSTR",&
		"GRADE_COND_FACTOR", "TCHIREEXPENSES", "TRA_STCB", "TCCOMMISSION", /*"AUDITLOG", "REJECTED_IMPORT_EXPENSES",*/ "NTC_TC_CONTRACT",&
		"NTC_POOL_VESSELS", "POOL_WEEKLY_FIXTURE"}

/* Create function used to get which columns are in a given table */
inv_sql = create n_sql_table_function

/*  Give the user a chance to stop the action */
if Messagebox("Notice","You are about to change the vessel number for Vessel "  +string(al_vessel)+ " to " + string(al_new_vessel) +".~r~nDo you wish to do this?",Question!,OkCancel!) = 1 then 
	/* Set pointer to hourglass */
	setpointer(hourglass!)

	//Go through all the tables containing voyagenumber 
	ll_max = upperbound (ls_table)
  	for ll_table_count = 1 to ll_max
		ls_insert= ""
		ls_columns = {""}
		/* Call the userobject function. It returns the  columns in the current table*/	
		li_vessel_number_position = inv_sql.uf_get_columns_vessel ( ls_table[ll_table_count], ls_columns[] )
		/* Create the insert line using all the columns we recieved from the userobject function.*/
		/* We insert the new vessel number In the column vessel_nr */
		li_array_size = upperbound(ls_columns)
		for ll_counter = 1 to li_array_size
			/* spring over autoincrement nøgle i BP_DETAILS, TC Hire contract, Off Services.................... */
			if ll_counter = 1 and ls_table[ll_table_count] = "BP_DETAILS" then continue
			if ll_counter = 1 and ls_table[ll_table_count] = "NTC_TC_CONTRACT" then continue
			if ll_counter = 1 and ls_table[ll_table_count] = "OFF_SERVICES" then continue
			if ll_counter = 1 and ls_table[ll_table_count] = "IOM_SIN_VESSELS" then continue
			if ll_counter = 1 and ls_table[ll_table_count] = "VAS_FILE_DATA" then continue
			if ll_counter = 1 and ls_table[ll_table_count] = "FIN_RESP_HISTORY" then continue
			if ll_counter = 1 and ls_table[ll_table_count] = "TANK" then continue
			if ll_counter = 1 and ls_table[ll_table_count] = "CAL_CONS" then continue
			if ll_counter = 1 and ls_table[ll_table_count] = "VSL_CNSTR" then continue
			if ll_counter = 1 and ls_table[ll_table_count] = "GRADE_COND_FACTOR" then continue
			if ll_counter = 1 and ls_table[ll_table_count] = "NTC_POOL_VESSELS" then continue
			if ll_counter = 1 and ls_table[ll_table_count] = "POOL_WEEKLY_FIXTURE" then continue
			
			/* Sæt vessel reference number = nyt skibsnummer */
			if ls_table[ll_table_count] = "VESSELS" and  ls_columns[ll_counter] = "VESSEL_REF_NR" then
				ls_insert = ls_insert + "'"+string(al_new_vessel) + "'," 
				continue
			end if
			
			/* Alle normale cases kører denne del */
			if ll_counter = li_vessel_number_position then 
			 	ls_insert = ls_insert + string( al_new_vessel) + ","  
			else
				 ls_insert = ls_insert + ls_columns[ll_counter] + "," 
			end if
		next /* ll_counter */
		ls_insert = mid (ls_insert, 1, len(ls_insert) -1)
		ls_insert_sql = "insert into " +  ls_table[ll_table_count] + " select " + ls_insert + " from " + ls_table[ll_table_count] + " where VESSEL_NR=" + string(al_vessel)
		/* Execute the sql-statement */
		EXECUTE IMMEDIATE :ls_insert_sql using sqlca;
		if sqlca.sqlcode <>0 then
			messagebox("1 Vessel Number Modification Error","The Vessel Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
			destroy inv_sql
			/* Set pointer back to arrow */
			setpointer(arrow!)
			return -1
		end if
	next /* ll_table_count */
	
	/* Here comes the part where we update the CALCULATIONS */
	UPDATE CAL_CALC
		SET CAL_CALC_VESSEL_ID = :al_new_vessel
		WHERE CAL_CALC_VESSEL_ID = :al_vessel;
	if sqlca.sqlcode <> 0 then
		messagebox("2 Vessel Number Modification Error","The Vessel Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		destroy inv_sql
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	
	/* here comes the part where we delete the old vessel number from the tables */
	for ll_table_count= ll_max to 1 step -1
		ls_sql_delete="DELETE FROM " +ls_table[ll_table_count] + " WHERE VESSEL_NR = " +string(al_vessel) 
		EXECUTE IMMEDIATE: ls_sql_delete using sqlca;
		if sqlca.sqlcode <> 0 then
			messagebox("6 Vessel Number Modification Error","The Vessel Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
			/* Set pointer back to arrow */
			setpointer(arrow!)
			return -1
		end if
	next
	
	/* Here comes the part where we edit the vessel comment in vessels table. Add comment that this vessel former number was */	
	
	SELECT VESSEL_COMMENT
		INTO :ls_vessel_comment  
		FROM VESSELS 
		WHERE VESSEL_NR= :al_new_vessel;
	If IsNull(ls_vessel_comment) Then ls_vessel_comment = ""
	/* We append our text about the change of voyagenumber to the text already written in the field */
	SELECT FIRST_NAME + " " + LAST_NAME INTO :ls_names FROM USERS WHERE USERID=:uo_global.is_userid;
	ls_vessel_comment += "~r~n"+string(today(),"dd mmm yyyy")+" - Vessel number changed from "+string(al_vessel) + " to " + string(al_new_vessel)+ " by " +ls_names 
	UPDATE VESSELS
		SET VESSEL_COMMENT = :ls_vessel_comment
		WHERE VESSEL_NR= :al_new_vessel;
	if sqlca.sqlcode <> 0 then
		messagebox(" 7 Vessel Number Modification Error","The Vessel Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
		/* Set pointer back to arrow */
		setpointer(arrow!)
		return -1
	end if
	if al_new_vessel > 9999 then
		UPDATE VESSELS
			SET VESSEL_ACTIVE = 0
			WHERE VESSEL_NR= :al_new_vessel;
		if sqlca.sqlcode <> 0 then
			messagebox(" 8 Vessel Number Modification Error","The Vessel Number has not been modified. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
			/* Set pointer back to arrow */
			setpointer(arrow!)
			return -1
		end if
	end if	
	/* Set pointer back to arrow */
	setpointer(arrow!)
	
	return 1
end if

return -1
end function

on n_vessel_modify.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_vessel_modify.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

