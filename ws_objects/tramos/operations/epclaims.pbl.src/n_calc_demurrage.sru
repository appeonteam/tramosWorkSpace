$PBExportHeader$n_calc_demurrage.sru
forward
global type n_calc_demurrage from nonvisualobject
end type
end forward

global type n_calc_demurrage from nonvisualobject autoinstantiate
end type

forward prototypes
public function integer of_update_dem_bol (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr)
public function integer of_update_dem_port (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr, string as_port_code)
public function integer of_recalc_demurrage (integer ai_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_chart_nr, integer ai_claim_nr)
end prototypes

public function integer of_update_dem_bol (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : 
  
 Event	 :  {Open}

 Scope     : {Global/Local}

 ************************************************************************************

 Author    : {Your name}
   
 Date       : {Creation date}

 Description : {Short description}

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
6/8-96					LN		INITIAL
11-12-96		3.0			RM		added COMMIT's  
29/08/16		CR4219	LHG008	Accuracy and improvement in DEM and DEV claims handling(CHO)(REF_CR4111).
************************************************************************************/

long ll_cp
//Decimal {4}  ld_disch_daily, ld_load_daily, ld_disch_hourly, ld_load_hourly, ld_bol_quantity,ld_load_laytime,ld_disch_laytime
Double  ld_disch_daily, ld_load_daily, ld_disch_hourly, ld_load_hourly, ld_bol_quantity,ld_load_laytime,ld_disch_laytime
u_calc_nvo			uo_calc_nvo
s_dem_des_data		lstr_dem[]

SELECT CAL_CERP_ID, LOAD_DAILY_RATE,DISCH_DAILY_RATE,LOAD_HOURLY_RATE,DISCH_HOURLY_RATE
INTO :ll_cp, :ld_load_daily, :ld_disch_daily, :ld_load_hourly, :ld_disch_hourly
FROM DEM_DES_CLAIMS
WHERE VESSEL_NR = :ai_vessel_nr 
	AND VOYAGE_NR = :as_voyage_nr 
	AND CHART_NR = :ai_chart_nr 
	AND CLAIM_NR = :ai_claim_nr
USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN 
	//COMMIT USING SQLCA;
	Return 1
END IF

//COMMIT USING SQLCA;

SELECT SUM(BOL_QUANTITY)
	INTO :ld_bol_quantity
	FROM BOL, LAYTIME_STATEMENTS
	WHERE BOL.VESSEL_NR = :ai_vessel_nr
	AND BOL.VOYAGE_NR = :as_voyage_nr
	AND BOL.CHART_NR = :ai_chart_nr
	AND BOL.CAL_CERP_ID = :ll_cp
	AND BOL.L_D = 1
	AND ( BOL.PCN = LAYTIME_STATEMENTS.PCN ) AND  
		 ( BOL.PORT_CODE = LAYTIME_STATEMENTS.PORT_CODE ) AND  
		( BOL.VESSEL_NR = LAYTIME_STATEMENTS.VESSEL_NR ) AND  
       		( BOL.VOYAGE_NR = LAYTIME_STATEMENTS.VOYAGE_NR ) AND  
       		( BOL.CHART_NR = LAYTIME_STATEMENTS.CHART_NR )
	USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN 
	//COMMIT USING SQLCA;
	Return 2
END IF

//COMMIT USING SQLCA;

IF IsNull(ld_bol_quantity) THEN
	 ld_bol_quantity = 0 
ELSE
	IF ld_load_daily > 0 THEN
		ld_load_laytime = (ld_bol_quantity/ld_load_daily)*24
	ELSEIF  ld_load_hourly > 0 THEN
		ld_load_laytime = ld_bol_quantity/ld_load_hourly
	END IF
	IF ld_load_laytime > 0 THEN
		uo_calc_nvo = CREATE u_calc_nvo
		if uo_calc_nvo.uf_dem_des_data(ai_vessel_nr, as_voyage_nr, ai_chart_nr, ll_cp, lstr_dem) = 1 then
			if lstr_dem[1].d_other_allowed > 0 then
				ld_load_laytime += lstr_dem[1].d_other_allowed
			end if
		end if
		destroy uo_calc_nvo
		
		UPDATE DEM_DES_CLAIMS
		SET LOAD_LAYTIME_ALLOWED = :ld_load_laytime
		WHERE VESSEL_NR = :ai_vessel_nr AND VOYAGE_NR = :as_voyage_nr AND 
			      CHART_NR = :ai_chart_nr AND CLAIM_NR = :ai_claim_nr;
		IF SQLCA.SQLCode <> 0 THEN 
			//ROLLBACK;
			Return 3
		ELSE
			//COMMIT;
		END IF
	END IF
	
	IF ld_disch_daily > 0 THEN
		ld_disch_laytime = (ld_bol_quantity/ld_disch_daily)*24
	ELSEIF  ld_disch_hourly > 0 THEN
		ld_disch_laytime = ld_bol_quantity/ld_disch_hourly
	END IF
	IF ld_disch_laytime > 0 THEN
		UPDATE DEM_DES_CLAIMS
		SET DISCH_LAYTIME_ALLOWED = :ld_disch_laytime
		WHERE VESSEL_NR = :ai_vessel_nr AND VOYAGE_NR = :as_voyage_nr AND 
			      CHART_NR = :ai_chart_nr AND CLAIM_NR = :ai_claim_nr;
		IF SQLCA.SQLCode <> 0 THEN 
			//ROLLBACK;
			Return 4
		ELSE
			//COMMIT;
		END IF
	END IF
	UPDATE DEM_DES_CLAIMS
		SET BOL_LOAD_QUANTITY = :ld_bol_quantity
		WHERE VESSEL_NR = :ai_vessel_nr AND VOYAGE_NR = :as_voyage_nr AND 
			      CHART_NR = :ai_chart_nr AND CLAIM_NR = :ai_claim_nr;
		IF SQLCA.SQLCode <> 0 THEN 
			//ROLLBACK;
			Return 4
		ELSE
			//COMMIT;
		END IF
END IF

Return 0
end function

public function integer of_update_dem_port (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr, string as_port_code);///************************************************************************************
//
// Arthur Andersen PowerBuilder Development
//
// Window  : 
//  
// Object     : 
//  
// Event	 :  {Open}
//
// Scope     : {Global/Local}
//
// ************************************************************************************
//
// Author    : {Your name}
//   
// Date       : {Creation date}
//
// Description : {Short description}
//
// Arguments : {description/none}
//
// Returns   : {description/none}  
//
// Variables : {important variables - usually only used in Open-event scriptcode}
//
// Other : {other comments}
//
//*************************************************************************************
//Development Log 
//DATE		VERSION 	NAME	DESCRIPTION
//-------- 		------- 		----- 		-------------------------------------
//6/8-96					LN		INITIAL
//11-12-96	3.0			RM		added COMMIT's
//  
//************************************************************************************/

Integer li_cp,li_pcn
//Decimal {4}  ld_disch_daily, ld_load_daily, ld_disch_hourly, ld_load_hourly, ld_bol_quantity,ld_load_laytime = -1,ld_disch_laytime = -1
Double ld_disch_daily, ld_load_daily, ld_disch_hourly, ld_load_hourly, ld_bol_quantity,ld_load_laytime = -1,ld_disch_laytime = -1
String ls_purpose
transaction temp_tran
LONG ll_calcaioid
 
/* Create and connect transaction object */
temp_tran = create transaction
uo_global.defaulttransactionobject(temp_tran)
connect using temp_tran;


 DECLARE dem_cur CURSOR FOR  
 SELECT CAL_CERP_ID,   
	       LOAD_DAILY_RATE,   
               DISCH_DAILY_RATE,   
               LOAD_HOURLY_RATE,   
               DISCH_HOURLY_RATE,           
	       DEM_DES_PURPOSE,
	       CAL_CAIO_ID  
               FROM DEM_DES_CLAIMS 
               WHERE VESSEL_NR = :ai_vessel_nr AND VOYAGE_NR = :as_voyage_nr AND CHART_NR = :ai_chart_nr AND 
		                         CLAIM_NR = :ai_claim_nr AND PORT_CODE = :as_port_code
		 USING temp_tran ; 

OPEN dem_cur;
FETCH dem_cur INTO :li_cp, :ld_load_daily, :ld_disch_daily, :ld_load_hourly, :ld_disch_hourly,:ls_purpose,:ll_calcaioid;

DO WHILE temp_tran.SQLCode = 0
	SELECT DISTINCT PCN
	INTO :li_pcn
	FROM CD
	WHERE CAL_CAIO_ID = :ll_calcaioid
	USING SQLCA;

	IF (LEFT(ls_purpose,1) = "L" or  ls_purpose = "CHO" )  AND SQLCA.SQLCode = 0 THEN
		// COMMIT USING SQLCA;		

		SELECT SUM(BOL_QUANTITY)
		INTO :ld_bol_quantity
		FROM BOL, LAYTIME_STATEMENTS,CD
		WHERE BOL.VESSEL_NR = :ai_vessel_nr
		AND BOL.VOYAGE_NR = :as_voyage_nr
		AND BOL.CHART_NR =  :ai_chart_nr
		AND BOL.CAL_CERP_ID = :li_cp
		AND BOL.L_D = 1
		AND BOL.PORT_CODE = :as_port_code
		AND BOL.PCN = :li_pcn
		AND ( BOL.PORT_CODE = LAYTIME_STATEMENTS.PORT_CODE ) AND  
       			( BOL.VESSEL_NR = LAYTIME_STATEMENTS.VESSEL_NR ) AND  
       			( BOL.VOYAGE_NR = LAYTIME_STATEMENTS.VOYAGE_NR ) AND  
        		( BOL.CHART_NR = LAYTIME_STATEMENTS.CHART_NR )
			AND  (BOL.PORT_CODE =CD.PORT_CODE ) AND  
       			( BOL.VESSEL_NR = CD.VESSEL_NR ) AND  
       			( BOL.VOYAGE_NR = CD.VOYAGE_NR ) AND  
        		( BOL.CHART_NR = CD.CHART_NR ) AND
			(BOL.PORT_CODE = CD.PORT_CODE) AND
			(BOL.PCN = CD.PCN) AND
			(BOL.AGENT_NR = CD.AGENT_NR) AND
			(BOL.CAL_CERP_ID = CD.CAL_CERP_ID) AND
			(BOL.LAYOUT = CD.LAYOUT) AND
			CD.CAL_CAIO_ID = :ll_calcaioid 
		USING SQLCA;

		//COMMIT USING SQLCA;

		IF IsNull(ld_bol_quantity) THEN
			 ld_bol_quantity = 0 
		ELSE
				IF ld_load_daily > 0 THEN
					ld_load_laytime = (ld_bol_quantity/ld_load_daily)*24
				ELSEIF  ld_load_hourly > 0 THEN
					ld_load_laytime = ld_bol_quantity/ld_load_hourly
				END IF
				IF ld_load_laytime >= 0 THEN
					UPDATE DEM_DES_CLAIMS
					SET LOAD_LAYTIME_ALLOWED = :ld_load_laytime
			 		WHERE VESSEL_NR = :ai_vessel_nr AND VOYAGE_NR = :as_voyage_nr AND 
			 			    CHART_NR = :ai_chart_nr AND CLAIM_NR = :ai_claim_nr AND PORT_CODE = :as_port_code AND &
			   			    CAL_CAIO_ID = :ll_calcaioid AND SUBSTRING(DEM_DES_PURPOSE,1,1) = "L";
					IF SQLCA.SQLCode <> 0 THEN 
						//ROLLBACK;
						disconnect using temp_tran;
						DESTROY temp_tran;
						Return 3
					ELSE
						//COMMIT;
					END IF
				END IF
				UPDATE DEM_DES_CLAIMS
				SET BOL_LOAD_QUANTITY = :ld_bol_quantity
				WHERE VESSEL_NR = :ai_vessel_nr AND VOYAGE_NR = :as_voyage_nr AND 
			 		    CHART_NR = :ai_chart_nr AND CLAIM_NR = :ai_claim_nr AND PORT_CODE = :as_port_code AND &
			   		    CAL_CAIO_ID = :ll_calcaioid AND SUBSTRING(DEM_DES_PURPOSE,1,1) = "L";
				IF SQLCA.SQLCode <> 0 THEN 
					//ROLLBACK;
					disconnect using temp_tran;
					DESTROY temp_tran;
					Return 3
				ELSE
					//COMMIT;
				END IF
		END IF
	ELSEIF  LEFT(ls_purpose,1) = "D" AND SQLCA.SQLCode = 0 THEN
		SELECT SUM(BOL_QUANTITY)
		INTO :ld_bol_quantity
		FROM BOL, LAYTIME_STATEMENTS,CD
		WHERE BOL.VESSEL_NR = :ai_vessel_nr 
		AND BOL.VOYAGE_NR = :as_voyage_nr 
		AND BOL.CHART_NR =  :ai_chart_nr 
		AND BOL.CAL_CERP_ID = :li_cp 
		AND BOL.L_D = 0 
		AND BOL.PORT_CODE = :as_port_code 
		AND BOL.PCN = :li_pcn 
		AND ( BOL.PORT_CODE = LAYTIME_STATEMENTS.PORT_CODE ) AND  
       			( BOL.VESSEL_NR = LAYTIME_STATEMENTS.VESSEL_NR ) AND  
       			( BOL.VOYAGE_NR = LAYTIME_STATEMENTS.VOYAGE_NR ) AND  
        		( BOL.CHART_NR = LAYTIME_STATEMENTS.CHART_NR ) 
			AND  (BOL.PORT_CODE =CD.PORT_CODE ) AND  
       			( BOL.VESSEL_NR = CD.VESSEL_NR ) AND   
       			( BOL.VOYAGE_NR = CD.VOYAGE_NR ) AND   
        		( BOL.CHART_NR = CD.CHART_NR ) AND 
			(BOL.PORT_CODE = CD.PORT_CODE) AND 
			(BOL.PCN = CD.PCN) AND 
			(BOL.AGENT_NR = CD.AGENT_NR) AND 
			(BOL.CAL_CERP_ID = CD.CAL_CERP_ID) AND 
			(BOL.LAYOUT = CD.LAYOUT) AND 
			CD.CAL_CAIO_ID = :ll_calcaioid 
		USING SQLCA;

		//COMMIT USING SQLCA;

		IF IsNull(ld_bol_quantity) THEN
			 ld_bol_quantity = 0 
		ELSE
			IF ld_disch_daily > 0 THEN
				ld_disch_laytime = (ld_bol_quantity/ld_disch_daily)*24
			ELSEIF ld_disch_hourly > 0 THEN
				ld_disch_laytime = (ld_bol_quantity/ld_disch_hourly)
			END IF
			IF ld_disch_laytime >= 0 THEN
				UPDATE DEM_DES_CLAIMS
				SET DISCH_LAYTIME_ALLOWED = :ld_disch_laytime
				WHERE VESSEL_NR = :ai_vessel_nr AND VOYAGE_NR = :as_voyage_nr AND 
				  	   CHART_NR = :ai_chart_nr AND CLAIM_NR = :ai_claim_nr AND PORT_CODE = :as_port_code AND &
				   	   CAL_CAIO_ID = :ll_calcaioid AND SUBSTRING(DEM_DES_PURPOSE,1,1) = "D";
				IF SQLCA.SQLCode <> 0 THEN 
					//ROLLBACK;
					Disconnect using temp_tran;
					DESTROY temp_tran;
					Return 4
				ELSE
					//COMMIT;
				END IF
			END IF
			UPDATE DEM_DES_CLAIMS
			SET BOL_LOAD_QUANTITY = :ld_bol_quantity
			WHERE VESSEL_NR = :ai_vessel_nr AND VOYAGE_NR = :as_voyage_nr AND 
			  	   CHART_NR = :ai_chart_nr AND CLAIM_NR = :ai_claim_nr AND PORT_CODE = :as_port_code AND &
			   	   CAL_CAIO_ID = :ll_calcaioid AND SUBSTRING(DEM_DES_PURPOSE,1,1) = "D";
			IF SQLCA.SQLCode <> 0 THEN 
				//ROLLBACK;
				disconnect using temp_tran;
				DESTROY temp_tran;
				Return 4
			ELSE
				//COMMIT;
			END IF
		END IF	
	  ELSE
		MessageBox("Error","Update of bill of lading quantity failed with port " + as_port_code + " !! Check bill of lading", Exclamation!)
	  END IF 
FETCH dem_cur INTO :li_cp, :ld_load_daily, :ld_disch_daily, :ld_load_hourly, :ld_disch_hourly,:ls_purpose,:ll_calcaioid;
LOOP
CLOSE dem_cur;
COMMIT USING temp_tran;
//COMMIT USING SQLCA;
disconnect using temp_tran;
DESTROY temp_tran;
Return 0
end function

public function integer of_recalc_demurrage (integer ai_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_chart_nr, integer ai_claim_nr);integer li_pc_nr,li_number_of_dem_ports,li_error_code
s_calc_claim lstr_parm
uo_calc_dem_des_claims uo_calc_dem
double ld_exrate, ldo_cp_id_comm, ldo_cp
decimal{2} ld_amount_usd, ld_amount
uo_auto_commission uo_auto_comm
n_claimcurrencyadjust lnv_claimcurrencyadjust
string ls_claimtype

uo_calc_dem = CREATE uo_calc_dem_des_claims

SELECT PC_NR
	INTO :li_pc_nr
	FROM VESSELS
	WHERE VESSEL_NR = :ai_vessel_nr
	USING SQLCA;
//COMMIT USING SQLCA;

SELECT Count(*)
	INTO :li_number_of_dem_ports
	FROM DEM_DES_CLAIMS
	WHERE VESSEL_NR = :ai_vessel_nr 
	AND VOYAGE_NR = :as_voyage_nr 
	AND CHART_NR = :ai_chart_nr 
	AND CLAIM_NR = :ai_claim_nr
	USING SQLCA;
//COMMIT USING SQLCA;

IF li_pc_nr = 3 OR li_pc_nr = 5 THEN
	IF li_number_of_dem_ports < 2 THEN
		li_error_code = of_update_dem_bol(ai_vessel_nr, as_voyage_nr, ai_chart_nr, ai_claim_nr)
		lstr_parm = uo_calc_dem.uf_get_bulk_amount(ai_vessel_nr, as_voyage_nr, ai_chart_nr,ai_claim_nr)
	ELSE
		li_error_code = of_update_dem_port(ai_vessel_nr, as_voyage_nr, ai_chart_nr, ai_claim_nr, as_port_code)
		lstr_parm = uo_calc_dem.uf_get_bulk_amount_ports(ai_vessel_nr, as_voyage_nr, ai_chart_nr,ai_claim_nr)
	END IF
ELSE
	IF li_number_of_dem_ports < 2 THEN
		li_error_code = of_update_dem_bol(ai_vessel_nr, as_voyage_nr, ai_chart_nr, ai_claim_nr)
		lstr_parm = uo_calc_dem.uf_get_tank_amount(ai_vessel_nr, as_voyage_nr, ai_chart_nr,ai_claim_nr)
	ELSE
		li_error_code = of_update_dem_port(ai_vessel_nr, as_voyage_nr, ai_chart_nr, ai_claim_nr, as_port_code)
		lstr_parm = uo_calc_dem.uf_get_tank_amount_ports(ai_vessel_nr, as_voyage_nr, ai_chart_nr,ai_claim_nr)
	END IF
END IF
	
DESTROY uo_calc_dem

ld_amount = lstr_parm.claim_amount
lnv_claimcurrencyadjust.of_getclaimamounts(ai_vessel_nr, as_voyage_nr, ai_chart_nr,ai_claim_nr, ld_amount, ld_amount_usd, false)

CHOOSE CASE li_error_code
	CASE 0
		UPDATE CLAIMS
		SET CLAIM_AMOUNT = :lstr_parm.claim_amount,
			CLAIM_AMOUNT_USD = :ld_amount_usd
			WHERE VESSEL_NR = :ai_vessel_nr
		AND VOYAGE_NR = :as_voyage_nr
		AND CHART_NR = :ai_chart_nr
		AND CLAIM_NR = :ai_claim_nr ;
		//COMMIT;
//		If uo_auto_comm.of_check_exist(ai_vessel_nr,as_voyage_nr,ai_chart_nr,ai_claim_nr) Then
//			uo_auto_comm.of_generate(ai_vessel_nr,as_voyage_nr,ai_chart_nr,ai_claim_nr,"DEM","OLD",ldo_cp_id_comm)
//		End if
		
		/* START - Updates address commission */
		u_addr_commission lnv_calc_adrcomm
		lnv_calc_adrcomm = create u_addr_commission
		lnv_calc_adrcomm.of_add_com(ai_vessel_nr, as_voyage_nr, ai_chart_nr, ai_claim_nr) 
		destroy lnv_calc_adrcomm
		/* END - Updates address commission */
		
		/* START - Update Broker Commission */
         SELECT CLAIM_TYPE, CP_ID_COMM 
		INTO :ls_claimtype, :ldo_cp
		FROM CLAIMS
		WHERE VESSEL_NR = :ai_vessel_nr
			AND VOYAGE_NR = :as_voyage_nr
			AND CHART_NR = :ai_chart_nr
			AND CLAIM_NR = :ai_claim_nr;	
		uo_auto_comm.of_generate(ai_vessel_nr, as_voyage_nr, ai_chart_nr, ai_claim_nr, ls_claimtype, "OLD", ldo_cp)
		/* END - Update Broker Commission */	
	CASE 1
		MessageBox("ERROR","Claims not updated, because of select error in DEM_DES_CLAIMS. ~r &
		please note data, and contact administrator", Exclamation!)
	CASE 2
		MessageBox("ERROR","Claims not updated, because of select error in BOL. ~r &
		please note data, and contact administrator", Exclamation!)
	CASE 3
		MessageBox("ERROR","Claims not updated, because of update (load) error in DEM_DES_CLAIMS. ~r &
		please note data, and contact administrator", Exclamation!)
	CASE 4
		MessageBox("ERROR","Claims not updated, because of update (disch) error in DEM_DES_CLAIMS. ~r &
		please note data, and contact administrator", Exclamation!)
END CHOOSE
return li_error_code



end function

on n_calc_demurrage.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_calc_demurrage.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

