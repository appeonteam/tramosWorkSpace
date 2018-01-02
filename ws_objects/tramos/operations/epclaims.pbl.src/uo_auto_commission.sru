$PBExportHeader$uo_auto_commission.sru
forward
global type uo_auto_commission from nonvisualobject
end type
end forward

global type uo_auto_commission from nonvisualobject autoinstantiate
end type

type variables
Public Integer ii_vessel_no, ii_charter_no, ii_broker_comm, ii_pool_comm
Public String is_voyage_no, is_claim_type, is_new_old
Public Long il_claim_no, il_cp_no
Public Datastore ids_comm_trans
Public Decimal {4} id_add_comm
Public Double ido_cp_id_comm
Public u_datawindow_sqlca idw_callfromcp_broker
string _is_currcode
end variables

forward prototypes
public function long of_get_cp_id_demurrage ()
public function datastore of_find_broker ()
public function boolean of_check_exist (integer ai_vessel, string as_voyage, integer ai_chart, long al_claim)
public function long of_find_check_cp ()
public function integer of_calc_commission ()
public function integer of_set_values (long al_broker, decimal ad_amount, string as_type_commission)
public function decimal of_get_trans_amount ()
public function decimal of_generate (any ai_vessel_no, string as_voyage_no, integer ai_charter_no, long al_claim_no, string as_claim_type, string as_new_old, ref double as_cp_id_comm)
public function integer of_calc_broker (datastore ads_broker, decimal ad_amount)
private subroutine documentation ()
public function integer of_calc_broker_pool (datastore ads_broker, decimal ad_amount)
public function integer of_setcurrcode (string as_currcode)
public subroutine of_get_last_calc_status (ref s_cp_id astr_cp_id)
public function decimal of_generate (any ai_vessel_no, string as_voyage_no, integer ai_charter_no, long al_claim_no, string as_claim_type, string as_new_old, ref double as_cp_id_comm, ref u_datawindow_sqlca adw_cpbroker)
public subroutine of_save_last_calc_status ()
public function decimal of_generate (any ai_vessel_no, string as_voyage_no, integer ai_charter_no, long al_claim_no, string as_claim_type, string as_new_old, ref double as_cp_id_comm, boolean ab_force)
public function decimal of_generate (any ai_vessel_no, string as_voyage_no, integer ai_charter_no, long al_claim_no, string as_claim_type, string as_new_old, ref double as_cp_id_comm, ref u_datawindow_sqlca adw_cpbroker, boolean ab_force)
end prototypes

public function long of_get_cp_id_demurrage ();/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
06-06-2001  1.0	DOM	Initial version. Retrieve cp id for demurrage 
************************************************************************************/

long ll_cp_no  

  SELECT DEM_DES_CLAIMS.CAL_CERP_ID  
    INTO :ll_cp_no  
    FROM DEM_DES_CLAIMS  
   WHERE ( DEM_DES_CLAIMS.VESSEL_NR = :ii_vessel_no ) AND  
         ( DEM_DES_CLAIMS.VOYAGE_NR = :is_voyage_no ) AND  
         ( DEM_DES_CLAIMS.CHART_NR = :ii_charter_no ) AND  
         ( DEM_DES_CLAIMS.CLAIM_NR = :il_claim_no )   ;

return ll_cp_no
end function

public function datastore of_find_broker ();/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
06-06-2001  1.0	DOM	Initial version. Retrieve data concerning broker commission
************************************************************************************/

long ll_rc, ll_row, ll_count, ll_found
long ll_broker[], ll_callfrom_cp = 0
int  li_findrow, li_insertrow, li_poolmanager
decimal ld_percent[]

Datastore ds_broker

ds_broker = Create Datastore

IF is_new_old = "NEW" Then
	//Retrieve data concerning Broker
	ds_broker.dataobject = "d_broker_id_percent"
	ds_broker.setTransObject(SQLCA)
	if isvalid(idw_callfromcp_broker) then
		ll_callfrom_cp = 1
		ll_count = idw_callfromcp_broker.rowcount()
		for ll_row = 1 to ll_count
			ll_broker[ll_row] = idw_callfromcp_broker.getitemnumber(ll_row, "cal_comm_broker_nr")
			ld_percent[ll_row] = idw_callfromcp_broker.getitemdecimal(ll_row, "cal_comm_cal_comm_percent")
		next
	else
		ll_broker[1] = -1
	end if
		
	ll_rc = ds_broker.retrieve(il_cp_no, ll_callfrom_cp, ll_broker[])
	if ll_rc = -1 then
		messagebox("Error","Information concerning Broker could not be retrieved", StopSign!, OK!)
		ds_broker.insertrow(1)
		ds_broker.setitem(1, 1, -1)
	end if
	if isvalid(idw_callfromcp_broker) then
		
		for ll_found = 1 to upperbound(ll_broker)
			
			li_findrow = ds_broker.find("broker_nr = " + string(ll_broker[ll_found]), 1, ds_broker.rowcount())
			
			if li_findrow > 0 then
				ds_broker.setitem(li_findrow, "cal_comm_percent", ld_percent[ll_found])
			else
				li_insertrow = ds_broker.insertrow(0)
				
				select BROKER_POOL_MANAGER into :li_poolmanager from BROKERS WHERE BROKER_NR = :ll_broker[ll_found];
				
				ds_broker.setitem(li_insertrow, "broker_nr", ll_broker[ll_found])
				ds_broker.setitem(li_insertrow, "cal_comm_percent", ld_percent[ll_found])
				ds_broker.setitem(li_insertrow, "pool_manager", li_poolmanager)
			end if
		next
	end if		
Else
	//Retrieve data concerning Broker for exsisting commissions
	ds_broker.dataobject = "d_commission_transactions"
	ds_broker.setTransObject(SQLCA)
	 
	ll_rc = ds_broker.Retrieve(il_cp_no, 2, ii_vessel_no, is_voyage_no, ii_charter_no, il_claim_no)
				
	IF ll_rc = -1 then
		Messagebox("Error","Information concerning Broker could not be retrieved", StopSign!, OK!)
		ds_broker.insertrow(1)
		ds_broker.setitem(1, 1, -1)
	END IF	
End if
Return ds_broker
end function

public function boolean of_check_exist (integer ai_vessel, string as_voyage, integer ai_chart, long al_claim);Integer li_exsist

  SELECT Count(*)  
    INTO :li_exsist  
    FROM COMMISSIONS  
   WHERE ( COMMISSIONS.VESSEL_NR = :ai_vessel ) AND  
         ( COMMISSIONS.VOYAGE_NR = :as_voyage ) AND  
         ( COMMISSIONS.CHART_NR = :ai_chart ) AND  
         ( COMMISSIONS.CLAIM_NR = :al_claim ) ;

If li_exsist > 0 Then
	Return True
Else
	Return False
End if

end function

public function long of_find_check_cp ();/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
06-06-2001  1.0	TAU	Initial version. Find cp id and if an error occurs returns 0.
************************************************************************************/
Long ll_cp, ll_return, ll_cp_id, ll_cerp_id[], ll_null, ll_chart_nr, ll_return_cp
Integer li_ret, li_rows, li_u, li_i, li_cp_count, li_chart = 0
Boolean lb_same

DataStore ds_cp_list
s_cp_id lstr_cp_id
s_cp_id_add_comm lstr_cp_comm

// Create and populate datastore with cargo ids, CP ids and charterer ids
ds_cp_list = Create datastore
ds_cp_list.DataObject = "d_cp_list"
ds_cp_list.SetTransObject(SQLCA)

ll_return = ds_cp_list.Retrieve(ii_vessel_no,is_voyage_no)

If ll_return = -1 Then Return 0

// Investigate if a CP id occurs more than once in the CP list
lb_same = False
SetNull(ll_null)
li_rows = ds_cp_list.RowCount()

// If there is just one row then return CP id
If li_rows = 1 Then 
	If is_claim_type <> "DEM" AND is_claim_type <> "FRT" AND is_claim_type <> "AFC FRT" Then
		// Set Address commission in CLAIM
		id_add_comm = ds_cp_list.GetItemNumber(1, "cal_cerp_cal_cerp_add_comm")
	End if

	Return(ds_cp_list.GetItemNumber(1, "cal_cerp_cal_cerp_id"))	
End if	

// If there is more than one row then investigate for dublicate CP ids
If li_rows > 1 Then
	For li_u = 1 To li_rows
		ll_cp_id = ds_cp_list.GetItemNumber(li_u, "cal_cerp_cal_cerp_id")
		li_cp_count = UpperBound(ll_cerp_id[])

		For li_i = 1 To li_cp_count
			If ll_cerp_id[li_i] = ll_cp_id Then lb_same = True
		Next
		
		If Not lb_same Then
			ll_cerp_id[li_cp_count + 1] = ll_cp_id
		Else
			// Set duplicate chart id to null for later test of duplicate charter ids
			ds_cp_list.SetItem(li_i, "cal_cerp_chart_nr",ll_null)
		End if
		lb_same = False
	Next
End if

// Check if charterer id occurs more than once in the datastore list
For li_i = 1 To li_rows
	If ii_charter_no = ds_cp_list.GetItemNumber(li_i, "cal_cerp_chart_nr") Then li_chart++
Next

If li_chart = 1 Then	

	// If charterer occurs once then return CP id
	For li_i = 1 To li_rows
		If ii_charter_no = ds_cp_list.GetItemNumber(li_i, "cal_cerp_chart_nr") Then 
		
			If is_claim_type <> "DEM" AND is_claim_type <> "FRT" AND is_claim_type <> "AFC FRT" Then
				// Set Address commission in CLAIM
				id_add_comm = ds_cp_list.GetItemNumber(1, "cal_cerp_cal_cerp_add_comm")
			End if
					
			Return ds_cp_list.GetItemNumber(li_i, "cal_cerp_cal_cerp_id")
		End if
	Next

Elseif li_chart > 1 Then

	// If charterer id occurs more than once and type is freight then
	If is_claim_type = "FRT" Or is_claim_type = "AFC FRT" Then
		MessageBox("Error","There are more than one CP with the charterer name. ~n~r" + &
									" It is not possible to auto generate the commissions!",StopSign!,OK!)
		Return 0
	Else

		// Charterer id occurs more than once and type is HEA, DEV, MISC
		// Display a message to the User explaining the problem and show the CP information
		ds_cp_list.Retrieve(ii_vessel_no,is_voyage_no) // Renew content of datastore
		For li_i = 1 To li_rows
			If Not IsNull(ds_cp_list.GetItemNumber(li_i, "cal_cerp_cal_cerp_id")) &
						Then lstr_cp_id.cp_id[li_i] = ds_cp_list.GetItemNumber(li_i, "cal_cerp_cal_cerp_id")
		Next
	
		OpenWithParm(w_select_cp,lstr_cp_id)
		
		// Get the user choise for a CP id to use
		lstr_cp_comm = Message.PowerObjectParm	
		
		// Set Address commission in CLAIM
		id_add_comm = lstr_cp_comm.add_comm
		ll_return_cp = lstr_cp_comm.cp_id
		
		Return ll_return_cp
	End if
End if

end function

public function integer of_calc_commission ();/********************************************************************
   of_calc_commission
   <DESC>	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		06/06/01		1.0   		DOM   		Initial version. Checks whether its a new commission if not
		        		      		      		check whether the existing commission can be updated.
		21/06/16		CR4386		XSZ004		Fix bug.
   </HISTORY>
********************************************************************/

long 			ll_ok, ll_row_b
Decimal 		ld_amount, ld_ok
Datastore 	ds_broker


//Retrieve information concerning brokers
ds_broker = of_find_broker()
	
ll_row_b = ds_broker.rowcount()
If ll_row_b > 0 Then
	ld_ok = ds_broker.GetItemDecimal(1, 1)
	If ld_ok = -1 Then 
		Destroy ds_broker
		Return -1
	End if	
End if	

/* Calculate Broker Commission - "Normal" Brokers */
ds_broker.setFilter("pool_manager=0")
ds_broker.filter()
ll_row_b = ds_broker.rowCount() 
If ll_row_b > 0 Then
	
	//Retrieve claim transaction amounts 
	ld_amount = of_get_trans_amount() 

	
	//Calculate commission broker
	ll_ok = of_calc_broker(ds_broker, ld_amount)
	If ll_ok = -1 Then 
		Destroy ds_broker
		Return -1
	End if
End if

/* Calculate Broker Commission - Brokers marked as Pool Managers */
ds_broker.setFilter("pool_manager=1")
ds_broker.filter()
ll_row_b = ds_broker.rowCount() 
If ll_row_b > 0 Then
	
	//Retrieve claim transaction amounts 
	ld_amount = of_get_trans_amount() 
	
	//Calculate commission broker
	ll_ok = of_calc_broker_pool(ds_broker, ld_amount)
	If ll_ok = -1 Then 
		Destroy ds_broker
		Return -1
	End if
End if

Destroy ds_broker
Return 1
end function

public function integer of_set_values (long al_broker, decimal ad_amount, string as_type_commission);/**************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
06-06-2001  1.0	DOM	Initial version. Set values in table: COMMISSION
28-01-2011  2.0    JSU    Rewirte the function due to CR2273
***************************************************************************************/

Long ll_row, ll_exists, ll_comm_row
String ls_auto, ls_curr_code
Datastore ds_commission
decimal{2} ld_acount_diff, ld_amount_usd, ld_amount
boolean lb_settled
n_claimcurrencyadjust lnv_claimcurrencyadjust
string ls_claim_type
long ll_cerp_id

if ad_amount < 0 then return 1

SELECT CURR_CODE, CLAIM_TYPE, CAL_CERP_ID
INTO :ls_curr_code, :ls_claim_type, :ll_cerp_id
FROM CLAIMS
WHERE VESSEL_NR = :ii_vessel_no 
AND VOYAGE_NR = :is_voyage_no
AND CHART_NR = :ii_charter_no 
AND CLAIM_NR = :il_claim_no; 

if sqlca.sqlcode = 100 then
	messagebox("Error","The currency code is not specified, therefor the broker commission can not be calculated.")
	if not isvalid(idw_callfromcp_broker) then 
		ROLLBACK;
	end if
	return -1
end if
if _is_currcode <> "" then ls_curr_code = _is_currcode

ds_commission = Create Datastore
ds_commission.dataobject = "d_auto_commission"
ds_commission.setTransObject(SQLCA)
ll_exists = ds_commission.retrieve(ii_vessel_no, is_voyage_no, ii_charter_no, il_claim_no, al_broker)

IF ll_exists = 0 THEN	//if no commission exists
	if ad_amount > 0 then
		ll_row = ds_commission.InsertRow(0)
		ds_commission.SetItem(ll_row, "Broker_nr", al_broker)
		ds_commission.SetItem(ll_row, "Chart_nr", ii_charter_no)
		ds_commission.SetItem(ll_row, "Vessel_nr", ii_vessel_no)
		ds_commission.SetItem(ll_row, "Voyage_nr", is_voyage_no)
		ds_commission.SetItem(ll_row, "Claim_nr", il_claim_no)
		ds_commission.SetItem(ll_row, "Comm_settled", 0)
		ds_commission.SetItem(ll_row, "Comm_auto", "Auto")
		ds_commission.SetItem(ll_row, "Invoice_nr", "DO NOT SETTLE CP")
		ds_commission.SetItem(ll_row, "cp_pool", 2)
		ds_commission.SetItem(ll_row, "Comm_amount_local_curr", ad_amount)
		lnv_claimcurrencyadjust.of_getamountusd(ii_vessel_no, is_voyage_no, ii_charter_no, ls_claim_type, ll_cerp_id, ls_curr_code, ad_amount, ld_amount_usd)
		ds_commission.SetItem(ll_row, "Comm_amount", ld_amount_usd)
	end if
ELSE //Commission already exsist update amount
	ld_acount_diff = ad_amount - ds_commission.getitemnumber(1, "sum_amount")

	for ll_comm_row = 1 to ll_exists //if exists a unsettled auto bro_comm, update the difference with this unsettled one.
		if ds_commission.getitemnumber(ll_comm_row, "Comm_settled") = 0 and ds_commission.getitemstring(ll_comm_row, "Comm_auto") = "Auto" then
			if ds_commission.getitemnumber(ll_comm_row, "Comm_amount_local_curr") + ld_acount_diff = 0 then
				ds_commission.deleterow(ll_comm_row)
			else
				ld_amount = ds_commission.getitemnumber(ll_comm_row, "Comm_amount_local_curr") + ld_acount_diff
				ds_commission.SetItem(ll_comm_row, "Comm_amount_local_curr", ld_amount)	
				lnv_claimcurrencyadjust.of_getamountusd(ii_vessel_no, is_voyage_no, ii_charter_no, ls_claim_type, ll_cerp_id,ls_curr_code,  ld_amount, ld_amount_usd)
				ds_commission.SetItem(ll_comm_row, "Comm_amount", ld_amount_usd)	
			end if
			lb_settled = true
			exit
		end if
	next
	if not lb_settled then //otherwise create a new entry
		if ld_acount_diff <> 0 then
			ll_row = ds_commission.InsertRow(0)
			ds_commission.SetItem(ll_row, "Broker_nr", al_broker)
			ds_commission.SetItem(ll_row, "Chart_nr", ii_charter_no)
			ds_commission.SetItem(ll_row, "Vessel_nr", ii_vessel_no)
			ds_commission.SetItem(ll_row, "Voyage_nr", is_voyage_no)
			ds_commission.SetItem(ll_row, "Claim_nr", il_claim_no)
			ds_commission.SetItem(ll_row, "Comm_settled", 0)
			ds_commission.SetItem(ll_row, "Comm_auto", "Auto")
			ds_commission.SetItem(ll_row, "Invoice_nr", "DO NOT SETTLE EXT")
			ds_commission.SetItem(ll_row, "cp_pool", 2)
			ds_commission.SetItem(ll_row, "Comm_amount_local_curr", ld_acount_diff)	
			lnv_claimcurrencyadjust.of_getamountusd(ii_vessel_no, is_voyage_no, ii_charter_no, ls_claim_type, ll_cerp_id, ls_curr_code, ld_acount_diff, ld_amount_usd)
			ds_commission.SetItem(ll_comm_row, "Comm_amount", ld_amount_usd)
		end if
	end if

END IF

if ds_commission.update() = -1 then
	messagebox("Error", "Broker commission could not be generated for vessel " + string(ii_vessel_no) + " voyage " + string(is_voyage_no) + " claim " + string(il_claim_no) + " " + string(is_claim_type), Stopsign!) 
	if not isvalid(idw_callfromcp_broker) then
		ROLLBACK;
	end if
	destroy ds_commission
	return -1
else
	if not isvalid(idw_callfromcp_broker) then
		COMMIT;
	end if
	destroy ds_commission
	return 1
end if
end function

public function decimal of_get_trans_amount ();/********************************************************************
   of_get_trans_amount
   <DESC>	</DESC>
   <RETURN> decimal </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		06/06/01		1.0   		DOM   		Initial version.
		21/06/16		CR4386		XSZ004		Fix bug.
		17/11/17		CR4652		HHX010	Address and broker commission should never be calculated for the bunker parts of a claim.		
   </HISTORY>
********************************************************************/

decimal ld_amount, ld_trans_amount, ld_claim_amount, ld_received_amount, ld_addrcomm, ld_add_lumpsum, ld_balance, ld_brocomm, ld_add_lump_all, ld_bunker_amount
boolean		lb_addrcomm_add_lumpsum
Datastore 	lds_add_lumpsums
integer		li_add_lump, li_adrcomm_add_lumpsum

SELECT IsNull(Sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT),0)  
INTO :ld_trans_amount  
FROM CLAIM_TRANSACTION  
WHERE ( CLAIM_TRANSACTION.VESSEL_NR = :ii_vessel_no ) AND  
      ( CLAIM_TRANSACTION.VOYAGE_NR = :is_voyage_no ) AND  
      ( CLAIM_TRANSACTION.CHART_NR = :ii_charter_no ) AND  
      ( CLAIM_TRANSACTION.CLAIM_NR = :il_claim_no ) AND  
      (CLAIM_TRANSACTION.C_TRANS_CODE = "A" OR  
      CLAIM_TRANSACTION.C_TRANS_CODE = "W");

CHOOSE CASE is_claim_type
	
	CASE "HEA", "DEV"
		  SELECT isnull((HEA_DEV_CLAIMS.HEA_DEV_HOURS*(HEA_DEV_CLAIMS.HEA_DEV_PRICE_PR_DAY/24)),0) as AMOUNT
    INTO :ld_amount  
    FROM HEA_DEV_CLAIMS  
   WHERE ( HEA_DEV_CLAIMS.CHART_NR = :ii_charter_no ) AND  
         ( HEA_DEV_CLAIMS.VOYAGE_NR = :is_voyage_no ) AND  
         ( HEA_DEV_CLAIMS.VESSEL_NR = :ii_vessel_no ) AND  
         ( HEA_DEV_CLAIMS.CLAIM_NR = :il_claim_no );
	
		ld_amount -= ld_trans_amount
	CASE "DEM" // ,"HEA","DEV"
		// Get amount from table: CLAIMS
		  SELECT CLAIM_AMOUNT 
			 INTO :ld_amount  
			 FROM CLAIMS  
			WHERE VESSEL_NR = :ii_vessel_no AND  
					VOYAGE_NR = :is_voyage_no AND  
					CHART_NR = :ii_charter_no AND  
					CLAIM_NR = :il_claim_no AND  
					CLAIMS.CLAIM_TYPE = :is_claim_type;
			ld_amount -= ld_trans_amount		
		CASE "FRT"
		SELECT ABS(CL.CLAIM_AMOUNT  - 
			ISNULL((SELECT SUM(CT.C_TRANS_AMOUNT) 
			FROM CLAIM_TRANSACTION CT 
			WHERE CT.VESSEL_NR = CL.VESSEL_NR
			AND CT.VOYAGE_NR = CL.VOYAGE_NR
			AND CT.CHART_NR = CL.CHART_NR
			AND CT.CLAIM_NR = CL.CLAIM_NR),0))
		INTO :ld_balance
		FROM CLAIMS CL
		WHERE CL.VESSEL_NR = :ii_vessel_no  AND  
			CL.CHART_NR = :ii_charter_no  AND  
			CL.CLAIM_NR = :il_claim_no AND  
			CL.VOYAGE_NR = :is_voyage_no AND  
			CL.CLAIM_TYPE = :is_claim_type    ;
		
		if ld_balance < 1 then
			SELECT sum(FREIGHT_RECEIVED.FREIGHT_RECEIVED_LOCAL_CURR)
			 INTO :ld_amount
			 FROM FREIGHT_RECEIVED
			WHERE FREIGHT_RECEIVED.VESSEL_NR = :ii_vessel_no  AND  
					FREIGHT_RECEIVED.CHART_NR = :ii_charter_no  AND  
					FREIGHT_RECEIVED.CLAIM_NR = :il_claim_no AND  
					FREIGHT_RECEIVED.VOYAGE_NR = :is_voyage_no AND FREIGHT_RECEIVED.TRANS_CODE <> 'C';
			uo_freight_balance lv_freight
			lv_freight = create uo_freight_balance
			lv_freight.uf_calculate_balance( ii_vessel_no, is_voyage_no, ii_charter_no, il_claim_no)
			ld_amount += lv_freight.uf_get_addrcomm( )
			destroy lv_freight
		else	
			// Get amount from table: CLAIMS and FREIGHT_RECEIVED
			SELECT isnull(CLAIMS.CLAIM_AMOUNT,0),   
					sum(FREIGHT_RECEIVED.FREIGHT_RECEIVED_LOCAL_CURR),//
					isnull(CLAIMS.ADDRESS_COM,0),
					isnull(CLAIMS.BROKER_COM,0)
			 INTO :ld_claim_amount,
					:ld_received_amount,
					 :ld_addrcomm,
					 :ld_brocomm
			 FROM CLAIMS,   
					FREIGHT_RECEIVED
			WHERE CLAIMS.CHART_NR *= FREIGHT_RECEIVED.CHART_NR and  
					CLAIMS.VESSEL_NR *= FREIGHT_RECEIVED.VESSEL_NR and  
					CLAIMS.VOYAGE_NR *= FREIGHT_RECEIVED.VOYAGE_NR and  
					CLAIMS.CLAIM_NR *= FREIGHT_RECEIVED.CLAIM_NR and  
					CLAIMS.VESSEL_NR = :ii_vessel_no  AND  
					CLAIMS.CHART_NR = :ii_charter_no  AND  
					CLAIMS.CLAIM_NR = :il_claim_no AND  
					CLAIMS.VOYAGE_NR = :is_voyage_no AND  
					CLAIMS.CLAIM_TYPE = :is_claim_type AND FREIGHT_RECEIVED.TRANS_CODE <> 'C'   
			GROUP BY CLAIMS.VESSEL_NR,   
					CLAIMS.VOYAGE_NR,   
					CLAIMS.CHART_NR,   
					CLAIMS.CLAIM_NR;
						
			If IsNull(ld_received_amount) Then ld_received_amount = 0
			ld_amount = ld_claim_amount + ld_received_amount
			if ld_addrcomm > 0 then
				lds_add_lumpsums = create datastore
				lds_add_lumpsums.dataobject = "d_sq_tb_add_lumpsums"
				lds_add_lumpsums.settransobject( SQLCA)
				lds_add_lumpsums.retrieve(ii_vessel_no,is_voyage_no,ii_charter_no,il_claim_no)
				for li_add_lump = 1 to lds_add_lumpsums.rowcount()
					li_adrcomm_add_lumpsum = lds_add_lumpsums.getitemnumber( li_add_lump, "adr_comm")
					ld_add_lumpsum = lds_add_lumpsums.getitemdecimal( li_add_lump, "add_lumpsums")
					if ld_add_lumpsum <> 0 then
						if  li_adrcomm_add_lumpsum = 0 then
							ld_add_lump_all += ld_add_lumpsum
						end if
					end if
				next
				ld_amount = (((ld_amount - ld_add_lump_all)/ (100 - ld_addrcomm)) *100) + ld_add_lump_all
			end if
		end if
	CASE "AFC FRT"
		  // Get amount from table: CLAIMS and FREIGHT_ADVANCED_RECIEVED
		  SELECT CLAIMS.CLAIM_AMOUNT,   
					SUM(FREIGHT_ADVANCED_RECIEVED.AFC_RECEIVED_LOCAL_CURR),
					isnull(CLAIMS.ADDRESS_COM,0)
			 INTO :ld_claim_amount,   
					:ld_received_amount,
					 :ld_addrcomm 
			 FROM CLAIMS,   
					FREIGHT_ADVANCED_RECIEVED  
			WHERE ( CLAIMS.CHART_NR *= FREIGHT_ADVANCED_RECIEVED.CHART_NR ) and 
					( CLAIMS.VESSEL_NR *= FREIGHT_ADVANCED_RECIEVED.VESSEL_NR ) and  
					( CLAIMS.VOYAGE_NR *= FREIGHT_ADVANCED_RECIEVED.VOYAGE_NR ) and   
					( CLAIMS.CLAIM_NR *= FREIGHT_ADVANCED_RECIEVED.CLAIM_NR ) and   
					( ( CLAIMS.VESSEL_NR = :ii_vessel_no ) AND  
					( CLAIMS.CHART_NR = :ii_charter_no ) AND  
					( CLAIMS.CLAIM_NR = :il_claim_no ) AND  
					( CLAIMS.VOYAGE_NR = :is_voyage_no ) )   
		GROUP BY CLAIMS.VESSEL_NR,   
					CLAIMS.VOYAGE_NR,   
					CLAIMS.CHART_NR,   
					CLAIMS.CLAIM_NR;   

			If IsNull(ld_claim_amount) Then ld_claim_amount = 0
			If IsNull(ld_received_amount) Then ld_received_amount = 0
			ld_amount = ld_claim_amount + ld_received_amount	
		//	ld_amount = w_claims.uo_afc.id_freight		
			//before CR1017 there is no deduction for addr_comm, it is a bug.
			if ld_addrcomm > 0 then
				lds_add_lumpsums = create datastore
				lds_add_lumpsums.dataobject = "d_sq_tb_add_lumpsums_afc_all"
				lds_add_lumpsums.settransobject( SQLCA)
				lds_add_lumpsums.retrieve(ii_vessel_no,is_voyage_no,ii_charter_no,il_claim_no)
				for li_add_lump = 1 to lds_add_lumpsums.rowcount()
					li_adrcomm_add_lumpsum = lds_add_lumpsums.getitemnumber( li_add_lump, "adr_comm")
					ld_add_lumpsum = lds_add_lumpsums.getitemdecimal( li_add_lump, "add_lumpsums")
					if ld_add_lumpsum <> 0 then
						if  li_adrcomm_add_lumpsum = 0 then
							ld_add_lump_all += ld_add_lumpsum
						end if
					end if
				next
				ld_amount = (((ld_amount - ld_add_lump_all)/ (100 - ld_addrcomm)) *100) + ld_add_lump_all
			end if
	CASE ELSE //Misc
		// Get amount from table: CLAIMS
		  SELECT CLAIM_AMOUNT  
			 INTO :ld_amount  
			 FROM CLAIMS  
			WHERE VESSEL_NR = :ii_vessel_no AND  
					VOYAGE_NR = :is_voyage_no AND  
					CHART_NR = :ii_charter_no AND  
					CLAIM_NR = :il_claim_no AND  
					CLAIMS.CLAIM_TYPE = :is_claim_type;
							    
		SELECT ISNULL(HFO_TON,0)*ISNULL(HFO_PRICE,0) + ISNULL(DO_TON,0)*ISNULL(DO_PRICE,0) + ISNULL(GO_TON,0)*ISNULL(GO_PRICE,0)+ ISNULL(LSHFO_TON,0)*ISNULL(LSHFO_PRICE,0)
		INTO :ld_bunker_amount
		FROM  HEA_DEV_CLAIMS
		WHERE VESSEL_NR =  :ii_vessel_no  AND VOYAGE_NR = :is_voyage_no 
			 AND  CHART_NR =  :ii_charter_no  AND CLAIM_NR = :il_claim_no;
		IF ISNULL(ld_bunker_amount) THEN ld_bunker_amount = 0 
		
		ld_amount = ld_amount - ld_bunker_amount - ld_trans_amount

END CHOOSE

IF isnull(ld_amount) then ld_amount = 0

Return ld_amount
end function

public function decimal of_generate (any ai_vessel_no, string as_voyage_no, integer ai_charter_no, long al_claim_no, string as_claim_type, string as_new_old, ref double as_cp_id_comm);/* *****************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
23-05-2001  1.0	TAU	Initial version. Generate broker and pool commission automatically.
28-11-2028 CR2828 LGX001 Override this function
****************************************************************************************** */
u_datawindow_sqlca ldw_broker
return of_generate(ai_vessel_no, as_voyage_no, ai_charter_no, al_claim_no, as_claim_type, as_new_old, as_cp_id_comm, ldw_broker)



end function

public function integer of_calc_broker (datastore ads_broker, decimal ad_amount);/********************************************************************
   of_calc_broker
   <DESC>	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		06/06/01		1.0   		DOM   		Initial version. Run through all pool management brokers and calculate 
		        		      		      		commission for each one. Calls function of_set_values which 
		        		      		      		add/update values in commission.
		21/06/16		CR4386		XSZ004		Fix bug.
   </HISTORY>
********************************************************************/

long    ll_row, ll_counter, ll_broker, ll_ok
decimal ld_pct
decimal {2}ld_amount, ld_amount_lumpsums
integer li_add_lump, li_brocomm_add_lumpsum
double  ld_add_lumpsum

Datastore 	lds_add_lumpsums

ll_row = ads_broker.rowcount()

FOR ll_counter = 1 TO ll_row
	
	If is_new_old = "NEW" Then
		ld_pct = ads_broker.GetItemDecimal(ll_counter, "cal_comm_percent")/100
	Else
		ld_pct = ads_broker.GetItemDecimal(ll_counter, "cal_comm_cal_comm_percent")/100
	End if
	
	ll_broker = ads_broker.GetItemNumber(ll_counter, "broker_nr")
	
	lds_add_lumpsums = create datastore
	choose case is_claim_type
	case "FRT"
		lds_add_lumpsums.dataobject = "d_sq_tb_add_lumpsums"
	case "AFC FRT"
		lds_add_lumpsums.dataobject = "d_sq_tb_add_lumpsums_afc_all"
	end choose
	lds_add_lumpsums.settransobject( SQLCA)
	lds_add_lumpsums.retrieve(ii_vessel_no,is_voyage_no,ii_charter_no,il_claim_no)
	ld_amount_lumpsums = 0
	for li_add_lump = 1 to lds_add_lumpsums.rowcount()
		li_brocomm_add_lumpsum = lds_add_lumpsums.getitemnumber( li_add_lump, "bro_comm")
		ld_add_lumpsum = lds_add_lumpsums.getitemdecimal( li_add_lump, "add_lumpsums")
		if ll_counter = 1 then ad_amount -= ld_add_lumpsum
		if ld_add_lumpsum <> 0 then
			if  li_brocomm_add_lumpsum = 1 then
				ld_amount_lumpsums += ld_add_lumpsum * ld_pct
			end if
		end if
	next	
	
	ld_amount = ad_amount * ld_pct + ld_amount_lumpsums
	
	if (ii_broker_comm = 1 and ld_amount <= 0) or ii_broker_comm = 0 then
		ld_amount = 0
	end if
	
	ll_ok = of_set_values(ll_broker, ld_amount, "broker")
	
	if ll_ok = -1 then return -1
	
NEXT

/* refresh commission window if open */
if isValid(w_commission) then w_commission.retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used

Return 1
end function

private subroutine documentation ();/********************************************************************
   ObjectName: Object Short Description
   <OBJECT> 	Object Description	</OBJECT>
   <USAGE>  	Object Usage	</USAGE>
   <ALSO>   	other Objects	</ALSO>
	<HISTORY> 
		Date    		CR-Ref		Author		Comments
		12-09-10		CR1017		JSU042		change the way of calculating broker commissions to handiling 
										      		multipul addtional lumpsums. Brokers marked as Pool Managers 
										      		should always get the commissions for addtional lumpsums. 
										      		Normal brokers should be decided by the checkboxes in the
										      		additonal lumpsums table.
		13-10-10		CR2149		JSU042		broker commisssion is calculated base on Claim Type settings
		27-01-11		CR2273		JSU042		rewirte of_set_values() function
		22-02-11		CR1549		JSU042		multi currencies - set the USD amount for broker commissions
		28/11/12		CR2828		LGX001		The claim broker percent and commission should be updated when changing a broker commission or brokek in a CP
		24/12/15		CR4260		XSZ004		Fix a history bug.
		25/08/16    CR4307      SSX014      Do not pop up a window if only amount usd is changed
		07/09/16		CR4386		XSZ004		Fix a bug.
		17/11/17		CR4652		HHX010	Address and broker commission should never be calculated for the bunker parts of a claim.
	</HISTORY>    
********************************************************************/

end subroutine

public function integer of_calc_broker_pool (datastore ads_broker, decimal ad_amount);/********************************************************************
   of_calc_broker_pool
   <DESC>	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		21/09/10		1.0   		JSU042		Initial version. Run through all pool management brokers and calculate 
		        		      		      		commission for each one. Calls function of_set_values which 
		        		      		      		add/update values in commission.
		21/06/16		CR4386		XSZ004		Fix bug.
   </HISTORY>
********************************************************************/

long    ll_row, ll_counter, ll_broker, ll_ok
decimal ld_pct
decimal {2} ld_amount

ll_row = ads_broker.rowcount()

FOR ll_counter = 1 TO ll_row
	
	If is_new_old = "NEW" Then
		ld_pct = ads_broker.GetItemDecimal(ll_counter, "cal_comm_percent")/100
	Else
		ld_pct = ads_broker.GetItemDecimal(ll_counter, "cal_comm_cal_comm_percent")/100
	End if
	
	ll_broker = ads_broker.GetItemNumber(ll_counter, "broker_nr")
	
	ld_amount = ad_amount * ld_pct
	
	if (ii_pool_comm = 1 and ld_amount <= 0) or ii_pool_comm = 0 then
		ld_amount = 0
	end if
	
	ll_ok = of_set_values(ll_broker, ld_amount, "broker")
	
	if ll_ok = -1 then return -1
NEXT

/* refresh commission window if open */
if isValid(w_commission) then w_commission.retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used

Return 1
end function

public function integer of_setcurrcode (string as_currcode);_is_currcode = as_currcode
return c#return.Success

end function

public subroutine of_get_last_calc_status (ref s_cp_id astr_cp_id);/********************************************************************
   of_get_last_calc_status
   <DESC>	Get the last status	</DESC>
   <RETURN>	(None):
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_cp_id
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		15/02/12		M5-6  		ZSW001		First Version
		06/07/15		CR3893		XSZ004		Fix a bug
   </HISTORY>
********************************************************************/

long ll_calc_broker, ll_calc_pool, ll_broker_count, ll_pool_count, ll_brokernr
int  li_poolmanager, li_rowcount, li_row

if isvalid(idw_callfromcp_broker) then
	
	li_rowcount = idw_callfromcp_broker.rowcount()
	
	for li_row = 1 to li_rowcount
		ll_brokernr = idw_callfromcp_broker.getitemnumber(li_row, "cal_comm_broker_nr")
		
		select BROKER_POOL_MANAGER into :li_poolmanager from BROKERS WHERE BROKER_NR = :ll_brokernr;
		
		if li_poolmanager = 1 then
			ll_pool_count++
		else
			ll_broker_count++
		end if
	next
	
else
	SELECT count(*)
	  INTO :ll_broker_count
	  FROM VOYAGES, CAL_CARG, CAL_COMM, BROKERS
	 WHERE VOYAGES.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID AND
			 CAL_CARG.CAL_CERP_ID = CAL_COMM.CAL_CERP_ID AND
			 CAL_COMM.BROKER_NR = BROKERS.BROKER_NR AND
			 BROKERS.BROKER_POOL_MANAGER = 0 AND
			 VOYAGES.VESSEL_NR = :ii_vessel_no AND
			 VOYAGES.VOYAGE_NR = :is_voyage_no;
	
	SELECT count(*)
	  INTO :ll_pool_count
	  FROM VOYAGES, CAL_CARG, CAL_COMM, BROKERS
	 WHERE VOYAGES.CAL_CALC_ID = CAL_CARG.CAL_CALC_ID AND
			 CAL_CARG.CAL_CERP_ID = CAL_COMM.CAL_CERP_ID AND
			 CAL_COMM.BROKER_NR = BROKERS.BROKER_NR AND
			 BROKERS.BROKER_POOL_MANAGER = 1 AND
			 VOYAGES.VESSEL_NR = :ii_vessel_no AND
			 VOYAGES.VOYAGE_NR = :is_voyage_no;
end if			 

SELECT CLAIMS.BROKER_COMMISSION,
       CLAIM_TYPES.POOL_MANAGER_COMMISSION
  INTO :ll_calc_broker,
       :ll_calc_pool
  FROM CLAIMS, CLAIM_TYPES
 WHERE CLAIMS.CLAIM_TYPE = CLAIM_TYPES.CLAIM_TYPE AND
       CLAIMS.CHART_NR  = :ii_charter_no AND
       CLAIMS.VESSEL_NR = :ii_vessel_no AND
		 CLAIMS.VOYAGE_NR = :is_voyage_no AND
		 CLAIMS.CLAIM_NR  = :il_claim_no;

if ll_broker_count > 0 then
	astr_cp_id.broker = ll_calc_broker
else
	setnull(astr_cp_id.broker)		//Normal Broker does not exist
end if

if ll_pool_count > 0 then
	astr_cp_id.pool = ll_calc_pool
else
	setnull(astr_cp_id.pool)		//Pool Manager does not exist
end if

end subroutine

public function decimal of_generate (any ai_vessel_no, string as_voyage_no, integer ai_charter_no, long al_claim_no, string as_claim_type, string as_new_old, ref double as_cp_id_comm, ref u_datawindow_sqlca adw_cpbroker);/* *****************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
23-05-2001  1.0	TAU	Initial version. Generate broker and pool commission automatically.
28-11-2028 CR2828 LGX001 Override this function 
25/08/2016 CR4307 SSX014 Call the overloaded one
****************************************************************************************** */
return of_generate(ai_vessel_no, as_voyage_no, ai_charter_no, al_claim_no, as_claim_type, as_new_old, as_cp_id_comm, adw_cpbroker, false)

end function

public subroutine of_save_last_calc_status ();/********************************************************************
   of_save_last_calc_status
   <DESC>	Remember the last selection 	</DESC>
   <RETURN>	None:
            	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	16/02/2012   M5-6         ZSW001       First Version
		28/11/2012	 CR2828		  LGX001			The claim broker percent and commission should be updated when changing a broker commission or brokek in a CP
   </HISTORY>
********************************************************************/

long ll_row, ll_broker, ll_found = 0
decimal ld_percent

if isvalid(idw_callfromcp_broker) then
	SELECT BROKER_NR, BROKER_COM INTO :ll_broker, :ld_percent
	FROM CLAIMS
	WHERE CHART_NR  = :ii_charter_no AND
       VESSEL_NR = :ii_vessel_no AND
		 VOYAGE_NR = :is_voyage_no AND
		 CLAIM_NR  = :il_claim_no;
	
	ll_found = idw_callfromcp_broker.find("cal_comm_broker_nr =" + string(ll_broker), 1, idw_callfromcp_broker.rowcount())
	if ll_found > 0 then
		ld_percent = idw_callfromcp_broker.getitemdecimal(ll_found, "cal_comm_cal_comm_percent")
	end if	
	UPDATE CLAIMS
   SET BROKER_COMMISSION = :ii_broker_comm,
       POOL_MANAGER_COMMISSION = :ii_pool_comm,
		 BROKER_COM = :ld_percent
 	WHERE CHART_NR  = :ii_charter_no AND
	 		VESSEL_NR = :ii_vessel_no AND
			VOYAGE_NR = :is_voyage_no AND
			CLAIM_NR  = :il_claim_no;	
else
	UPDATE CLAIMS
	SET BROKER_COMMISSION = :ii_broker_comm,
       POOL_MANAGER_COMMISSION = :ii_pool_comm
	WHERE CHART_NR  = :ii_charter_no AND
			VESSEL_NR = :ii_vessel_no AND
			VOYAGE_NR = :is_voyage_no AND
			CLAIM_NR  = :il_claim_no;
	if sqlca.sqlcode = 0 then
		COMMIT;
	else
		ROLLBACK;		 
	end if
end if
end subroutine

public function decimal of_generate (any ai_vessel_no, string as_voyage_no, integer ai_charter_no, long al_claim_no, string as_claim_type, string as_new_old, ref double as_cp_id_comm, boolean ab_force);/* *****************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
23-05-2001  1.0	TAU	Initial version. Generate broker and pool commission automatically.
28-11-2028 CR2828 LGX001 Override this function
****************************************************************************************** */
u_datawindow_sqlca ldw_broker
return of_generate(ai_vessel_no, as_voyage_no, ai_charter_no, al_claim_no, as_claim_type, as_new_old, as_cp_id_comm, ldw_broker, ab_force)



end function

public function decimal of_generate (any ai_vessel_no, string as_voyage_no, integer ai_charter_no, long al_claim_no, string as_claim_type, string as_new_old, ref double as_cp_id_comm, ref u_datawindow_sqlca adw_cpbroker, boolean ab_force);/* *****************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
23-05-2001  1.0	TAU	Initial version. Generate broker and pool commission automatically.
28-11-2028 CR2828 LGX001 Override this function 
****************************************************************************************** */
Long 		ll_cp_no, ll_ok, ll_count
Integer 	li_misc, li_pool_required, li_broker_required, ll_voyage_type
s_cp_id	lstr_cp_id

ii_vessel_no 		= ai_vessel_no
ii_charter_no 		= ai_charter_no
is_voyage_no 		= as_voyage_no
is_claim_type 		= as_claim_type
is_new_old 			= as_new_old
il_claim_no 		= al_claim_no
ido_cp_id_comm 	= as_cp_id_comm

/* Always "NEW" due to changes made December 2009 */
is_new_old = "NEW"

//CR2828 call from cp
idw_callfromcp_broker = adw_cpbroker

//M5-6 Begin modified by ZSW001 on 15/02/2012
SELECT VOYAGE_TYPE INTO :ll_voyage_type FROM VOYAGES WHERE VESSEL_NR = :ii_vessel_no AND VOYAGE_NR = :is_voyage_no;

if ll_voyage_type = 2 then			//TC-Hire Out
	ii_broker_comm = 0
	ii_pool_comm = 0
else
	if ab_force then
		of_get_last_calc_status(lstr_cp_id)
		if isnull(lstr_cp_id.broker) then
			ii_broker_comm = 0
		else
			ii_broker_comm = 1
		end if
		if isnull(lstr_cp_id.pool) then
			ii_pool_comm = 0
		else
			ii_pool_comm = 1
		end if
	else
		of_get_last_calc_status(lstr_cp_id)
		
		if not isnull(lstr_cp_id.broker) or lstr_cp_id.pool = 1 then		//Existing Normal Broker or Pool Manager option is equal to 1
			//Ask the user which commission option would be calculated
			openwithparm(w_select_commission, lstr_cp_id)		//Check box status (0: not checked; 1: checked; null: disabled)
			lstr_cp_id = message.powerobjectparm
			if lstr_cp_id.broker < 0 or lstr_cp_id.pool < 0 then return -1
		else		//Both Normal Broker and Pool Manager are not existing
			lstr_cp_id.broker = 0
			lstr_cp_id.pool = 0
		end if
		
		ii_broker_comm = lstr_cp_id.broker
		ii_pool_comm = lstr_cp_id.pool
		
		of_save_last_calc_status()	
	end if
end if
//M5-6 End modified by ZSW001 on 15/02/2012

CHOOSE CASE as_claim_type
	CASE "HEA","DEV"
		// Find CP id and investigate if charterer occurs more than once on the CP's
		il_cp_no = of_find_check_cp ()
		If il_cp_no = 0 Then 
			Return -1
		Else
			as_cp_id_comm = il_cp_no
		End if
		
		ll_ok = of_calc_commission()
		If ll_ok = -1 Then Return -1
		
		if ii_broker_comm = 0 and ii_pool_comm = 0 then return -1
	CASE "FRT", "AFC FRT"
		// Find CP id and investigate if charterer occurs more than once on the CP's
		il_cp_no = of_find_check_cp()
		If il_cp_no = 0 Then Return -1
		ll_ok = of_calc_commission()
		If ll_ok = -1 Then Return -1
	CASE "DEM"
		// Calculate commission for demurrage and copy into commissions
		il_cp_no = of_get_cp_id_demurrage()
		ll_ok = of_calc_commission()
		If ll_ok = -1 Then Return -1
	CASE ELSE // Type = Misc
		// Check if type is = Misc
		  SELECT CLAIM_TYPES.MISC_CLAIM, CLAIM_TYPES.BROKER_COMMISSION, CLAIM_TYPES.POOL_MANAGER_COMMISSION
  		    INTO :li_misc, :li_broker_required, :li_pool_required
	       FROM CLAIM_TYPES,
      		   CLAIMS  
		   WHERE ( CLAIMS.CLAIM_TYPE = CLAIM_TYPES.CLAIM_TYPE ) and  
      		   ( ( CLAIMS.VESSEL_NR = :ii_vessel_no ) AND  
		         ( CLAIMS.CHART_NR = :ii_charter_no ) AND  
		         ( CLAIMS.VOYAGE_NR = :is_voyage_no ) AND  
      		   ( CLAIMS.CLAIM_NR = :il_claim_no ) )   ;
		
		If li_misc = 1 Then //Type = Misc
			// Find CP id and investigate if charterer occurs more than once on the CP's
			il_cp_no = of_find_check_cp ()
			If il_cp_no = 0 Then 
				Return -1
			Else
				as_cp_id_comm = il_cp_no
			End if
			ll_ok = of_calc_commission()
			If ll_ok = -1 Then Return -1
			
			if (li_broker_required = 0 and li_pool_required = 0) or (ii_broker_comm = 0 and ii_pool_comm = 0) then return -1
		Else
			// If it is an old claim do the following
			// Find CP id and investigate if charterer occurs more than once on the CP's
			il_cp_no = of_find_check_cp ()
			ll_ok = of_calc_commission()
			If ll_ok = -1 Then Return -1
		End if
END CHOOSE

If is_claim_type <> "DEM" AND is_claim_type <> "FRT" AND is_claim_type <> "AFC FRT" Then
	Return id_add_comm
Else
	Return 1
End if
end function

on uo_auto_commission.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_auto_commission.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

