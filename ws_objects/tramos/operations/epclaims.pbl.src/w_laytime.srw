$PBExportHeader$w_laytime.srw
$PBExportComments$Shows Laytime for all Ports connected to a Vessel, Voyage and DEM_DES Claim.
forward
global type w_laytime from w_vessel_basewindow
end type
type dw_list_claims from uo_datawindow within w_laytime
end type
type dw_list_laytime_ports from uo_datawindow within w_laytime
end type
type dw_laytime_statement from uo_datawindow within w_laytime
end type
type dw_lay_deductions from uo_datawindow within w_laytime
end type
type cb_update from commandbutton within w_laytime
end type
type cb_cancel from commandbutton within w_laytime
end type
type cb_delete from commandbutton within w_laytime
end type
type cb_close from commandbutton within w_laytime
end type
type cb_new_reason from commandbutton within w_laytime
end type
type dw_new_deductions from uo_datawindow within w_laytime
end type
type cb_1 from commandbutton within w_laytime
end type
type uo_bal from u_claimbalance within w_laytime
end type
end forward

global type w_laytime from w_vessel_basewindow
integer width = 3049
integer height = 1716
string title = "Laytime"
boolean maxbox = false
boolean resizable = false
event ue_update_new pbm_custom01
event ue_update_modified pbm_custom02
event ue_reload ( s_vessel_voyage_chart_claim astr_newdata )
dw_list_claims dw_list_claims
dw_list_laytime_ports dw_list_laytime_ports
dw_laytime_statement dw_laytime_statement
dw_lay_deductions dw_lay_deductions
cb_update cb_update
cb_cancel cb_cancel
cb_delete cb_delete
cb_close cb_close
cb_new_reason cb_new_reason
dw_new_deductions dw_new_deductions
cb_1 cb_1
uo_bal uo_bal
end type
global w_laytime w_laytime

type variables
integer  ii_chart_nr, ii_pcn, ii_claim_nr
string is_voyage_nr, is_port_code, is_sum_reason, is_gross_laytime
s_port_array istr_port_array
end variables

forward prototypes
public subroutine wp_select_enabled (boolean pb_new_reason, boolean pb_value)
public function integer wf_set_dem_settled (integer vessel, string voyage, integer charter, integer claim_nr)
public function integer wf_update_dem_bol ()
public function integer wf_update_dem_port ()
public subroutine wf_recalc_demurrage ()
public subroutine documentation ()
public function integer wf_getkeydata (ref s_vessel_voyage_chart_claim astr_currentdata)
public subroutine wf_setcolor ()
public function integer wf_validate ()
public function integer wf_ismandatory ()
public function integer wf_update_laytimemissing_flag (boolean ab_commit)
end prototypes

event ue_update_new;IF dw_new_deductions.Update() = 1 THEN
	COMMIT USING SQLCA;
	dw_lay_deductions.Retrieve(ii_vessel_nr,is_voyage_nr,ii_chart_nr,is_port_code,ii_pcn)
	COMMIT USING SQLCA;
	
	wp_select_enabled(true,true)
	wf_recalc_demurrage()
		/* START - Updates address commission */
	u_addr_commission lnv_calc_adrcomm
	lnv_calc_adrcomm = create u_addr_commission
	if lnv_calc_adrcomm.of_add_com(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr) = -1 then
		rollback;
	else
		commit;
	end if
	destroy lnv_calc_adrcomm
	/* END - Updates address commission */
	uo_bal.of_claimbalance(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr) 
ELSE
	ROLLBACK USING SQLCA;
END IF
end event

event ue_update_modified;dw_lay_deductions.accepttext( )
dw_lay_deductions.SetTabOrder("reason",0)
dw_lay_deductions.SetTabOrder("reason_start",0)
dw_lay_deductions.SetTabOrder("reason_end",0)
dw_lay_deductions.SetTabOrder("deduction_pct",0)

IF dw_lay_deductions.Update() = 1 THEN
	COMMIT USING SQLCA;
	wf_recalc_demurrage()
	/* START - Updates address commission */
	u_addr_commission lnv_calc_adrcomm
	lnv_calc_adrcomm = create u_addr_commission
	if lnv_calc_adrcomm.of_add_com(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr) = -1 then
		rollback;
	else
		commit;
	end if
	destroy lnv_calc_adrcomm
	/* END - Updates address commission */
	uo_bal.of_claimbalance(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr) 
ELSE
	ROLLBACK USING SQLCA;
END IF

wp_select_enabled(False,True)
dw_laytime_statement.enabled=true

end event

event ue_reload(s_vessel_voyage_chart_claim astr_newdata);/********************************************************************
   ue_reload
   <DESC>   
		Implemented to be used when a charterer has changed in C/P data.  This event is
		called when vessel matches amended vessel attached to C/P.  The datawindow has to
		be re-retrieved with new data.
	</DESC>
   <RETURN>	(none) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		s_vessel_voyage_chart_claim: astr_newdata
   </ARGS>
   <USAGE>
		business logic specific to C/P is left there.  Expected process is to obtain data from window
		using wf_getkeydata().  Manipulate according to implementation and then reload laytime window
		if required.
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/2012 CR3083       LGX001        First Version
   </HISTORY>
********************************************************************/

if astr_newdata.status = "VESSEL" or astr_newdata.status = "RELOAD" then
	this.dw_list_claims.setredraw(false)
	this.dw_list_claims.retrieve(astr_newdata.vessel_nr)
	this.dw_list_claims.event clicked(0, 0, astr_newdata.claim_nr, this.dw_list_claims.object)
	this.dw_list_claims.scrolltorow(astr_newdata.claim_nr)
	this.dw_list_claims.setredraw(true)
end if
end event

public subroutine wp_select_enabled (boolean pb_new_reason, boolean pb_value);uo_vesselselect.enabled = pb_value
dw_list_claims.Enabled = pb_value
dw_list_laytime_ports.Enabled = pb_value
dw_lay_deductions.Enabled = pb_value
cb_update.Enabled = not pb_value
cb_cancel.Enabled = not pb_value
cb_update.Default = not pb_value
cb_cancel.Default = pb_value
cb_delete.enabled = pb_value
cb_close.enabled = pb_value



If pb_new_reason then
	dw_laytime_statement.enabled = pb_value
	If pb_value then 
		dw_new_deductions.Hide() 
		cb_new_reason.Default = True
	else
		dw_new_deductions.Show()
	end if
else
	cb_new_reason.enabled = pb_value
end if
end subroutine

public function integer wf_set_dem_settled (integer vessel, string voyage, integer charter, integer claim_nr);/************************************************************************************

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
{ 24-07-96	1.0 			LN	Initial version}
11-12-96		3.0			RM	added COMMIT's 
 
************************************************************************************/


String ls_port, la_ports[50]
Integer li_counter,li_pcn[50],li_index=1
Long ll_cpid,ll_calcaioid,ll_cai_array[]

SELECT DISTINCT DEM_DES_CLAIMS.CAL_CERP_ID
INTO :ll_cpid
FROM DEM_DES_CLAIMS  
WHERE ( DEM_DES_CLAIMS.VESSEL_NR = :vessel  ) AND  
              ( DEM_DES_CLAIMS.VOYAGE_NR = :voyage ) AND  
              ( DEM_DES_CLAIMS.CHART_NR = :charter )  AND
	      ( DEM_DES_CLAIMS.CLAIM_NR = :claim_nr ) 
USING SQLCA;

 DECLARE dem_cur CURSOR FOR  
 SELECT DEM_DES_CLAIMS.PORT_CODE  
 FROM DEM_DES_CLAIMS  
 WHERE ( DEM_DES_CLAIMS.VESSEL_NR = :vessel  ) AND  
              ( DEM_DES_CLAIMS.VOYAGE_NR = :voyage ) AND  
              ( DEM_DES_CLAIMS.CHART_NR = :charter )  AND
	      ( DEM_DES_CLAIMS.CLAIM_NR = :claim_nr )  AND
	      (DEM_DES_CLAIMS.DEM_DES_SETTLED = 0)	  ;

OPEN dem_cur;
FETCH dem_cur INTO :ls_port;

DO WHILE SQLCA.SQLCode = 0
	FOR li_counter = 1 TO 50
		IF istr_port_array.ports[li_counter] = ls_port THEN
			la_ports[li_counter] = ls_port
			li_pcn[li_counter] =  istr_port_array.pcn[li_counter]
			li_counter = 50			
		END IF
	NEXT
FETCH dem_cur INTO :ls_port;
LOOP
CLOSE dem_cur;
COMMIT USING SQLCA;

 DECLARE cd_cur CURSOR FOR  
  SELECT CD.CAL_CAIO_ID  
    FROM CD  
   WHERE ( CD.VESSEL_NR = :vessel ) AND  
         ( CD.VOYAGE_NR = :voyage ) AND  
         ( CD.PORT_CODE = :la_ports[li_counter] ) AND  
         ( CD.PCN = :li_pcn[li_counter] ) AND  
         ( CD.CAL_CERP_ID = :ll_cpid ) AND  
         ( CD.CHART_NR = :charter )   ;

FOR li_counter = 1 TO 50 

IF li_pcn[li_counter] > 0 THEN 
	OPEN cd_cur;
	FETCH cd_cur INTO :ll_calcaioid;
	DO WHILE SQLCA.SQLCode = 0
   		
		ll_cai_array[li_index] = ll_calcaioid
		li_index++
	
	FETCH cd_cur INTO :ll_calcaioid;
	LOOP
	CLOSE cd_cur;
	COMMIT USING SQLCA;
END IF
NEXT

li_index --
IF li_index > 0 THEN
   FOR li_counter = 1 TO li_index
	UPDATE DEM_DES_CLAIMS
	SET DEM_DES_CLAIMS.DEM_DES_SETTLED = 1
	 WHERE DEM_DES_CLAIMS.CAL_CAIO_ID = :ll_cai_array[li_counter];
			
	IF SQLCA.SQLCode = 0 THEN
		COMMIT USING SQLCA;
	ELSE
		MessageBox("Error", "An error has occured updating dem/des settled,  please  ~r~n &
				      note vessel,voyage,charter and port, and contact system administration.")
		ROLLBACK USING SQLCA;
		Return(0)
	END IF 
   NEXT
END IF
Return(0)
end function

public function integer wf_update_dem_bol ();/************************************************************************************

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
WHERE VESSEL_NR = :ii_vessel_nr 
	AND VOYAGE_NR = :is_voyage_nr 
	AND CHART_NR = :ii_chart_nr 
	AND CLAIM_NR = :ii_claim_nr
USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN 
	COMMIT USING SQLCA;
	Return 1
END IF

COMMIT USING SQLCA;

SELECT SUM(BOL_QUANTITY)
	INTO :ld_bol_quantity
	FROM BOL, LAYTIME_STATEMENTS
	WHERE BOL.VESSEL_NR = :ii_vessel_nr
	AND BOL.VOYAGE_NR = :is_voyage_nr
	AND BOL.CHART_NR = :ii_chart_nr
	AND BOL.CAL_CERP_ID = :ll_cp
	AND BOL.L_D = 1
	AND ( BOL.PCN = LAYTIME_STATEMENTS.PCN ) AND  
		 ( BOL.PORT_CODE = LAYTIME_STATEMENTS.PORT_CODE ) AND  
		( BOL.VESSEL_NR = LAYTIME_STATEMENTS.VESSEL_NR ) AND  
       		( BOL.VOYAGE_NR = LAYTIME_STATEMENTS.VOYAGE_NR ) AND  
       		( BOL.CHART_NR = LAYTIME_STATEMENTS.CHART_NR )
	USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN 
	COMMIT USING SQLCA;
	Return 2
END IF

COMMIT USING SQLCA;

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
		if uo_calc_nvo.uf_dem_des_data(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ll_cp, lstr_dem) = 1 then
			if lstr_dem[1].d_other_allowed > 0 then
				ld_load_laytime += lstr_dem[1].d_other_allowed
			end if
		end if
		destroy uo_calc_nvo
		
		UPDATE DEM_DES_CLAIMS
		SET LOAD_LAYTIME_ALLOWED = :ld_load_laytime
		WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :is_voyage_nr AND 
			      CHART_NR = :ii_chart_nr AND CLAIM_NR = :ii_claim_nr;
		IF SQLCA.SQLCode <> 0 THEN 
			ROLLBACK;
			Return 3
		ELSE
			COMMIT;
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
		WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :is_voyage_nr AND 
			      CHART_NR = :ii_chart_nr AND CLAIM_NR = :ii_claim_nr;
		IF SQLCA.SQLCode <> 0 THEN 
			ROLLBACK;
			Return 4
		ELSE
			COMMIT;
		END IF
	END IF
	UPDATE DEM_DES_CLAIMS
		SET BOL_LOAD_QUANTITY = :ld_bol_quantity
		WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :is_voyage_nr AND 
			      CHART_NR = :ii_chart_nr AND CLAIM_NR = :ii_claim_nr;
		IF SQLCA.SQLCode <> 0 THEN 
			ROLLBACK;
			Return 4
		ELSE
			COMMIT;
		END IF
END IF

Return 0
end function

public function integer wf_update_dem_port ();///************************************************************************************
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
//
//
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
               WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :is_voyage_nr AND CHART_NR = :ii_chart_nr AND 
		                         CLAIM_NR = :ii_claim_nr AND PORT_CODE = :is_port_code
		 USING temp_tran ; 

OPEN dem_cur;
FETCH dem_cur INTO :li_cp, :ld_load_daily, :ld_disch_daily, :ld_load_hourly, :ld_disch_hourly,:ls_purpose,:ll_calcaioid;

DO WHILE temp_tran.SQLCode = 0
	SELECT DISTINCT PCN
	INTO :li_pcn
	FROM CD
	WHERE CAL_CAIO_ID = :ll_calcaioid
	USING SQLCA;

	IF LEFT(ls_purpose,1) = "L" AND SQLCA.SQLCode = 0 THEN
		COMMIT USING SQLCA;		

		SELECT SUM(BOL_QUANTITY)
		INTO :ld_bol_quantity
		FROM BOL, LAYTIME_STATEMENTS,CD
		WHERE BOL.VESSEL_NR = :ii_vessel_nr
		AND BOL.VOYAGE_NR = :is_voyage_nr
		AND BOL.CHART_NR =  :ii_chart_nr
		AND BOL.CAL_CERP_ID = :li_cp
		AND BOL.L_D = 1
		AND BOL.PORT_CODE = :is_port_code
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

		COMMIT USING SQLCA;

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
			 		WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :is_voyage_nr AND 
			 			    CHART_NR = :ii_chart_nr AND CLAIM_NR = :ii_claim_nr AND PORT_CODE = :is_port_code AND &
			   			    CAL_CAIO_ID = :ll_calcaioid AND SUBSTRING(DEM_DES_PURPOSE,1,1) = "L";
					IF SQLCA.SQLCode <> 0 THEN 
						ROLLBACK;
						disconnect using temp_tran;
						DESTROY temp_tran;
						Return 3
					ELSE
						COMMIT;
					END IF
				END IF
				UPDATE DEM_DES_CLAIMS
				SET BOL_LOAD_QUANTITY = :ld_bol_quantity
				WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :is_voyage_nr AND 
			 		    CHART_NR = :ii_chart_nr AND CLAIM_NR = :ii_claim_nr AND PORT_CODE = :is_port_code AND &
			   		    CAL_CAIO_ID = :ll_calcaioid AND SUBSTRING(DEM_DES_PURPOSE,1,1) = "L";
				IF SQLCA.SQLCode <> 0 THEN 
					ROLLBACK;
					disconnect using temp_tran;
					DESTROY temp_tran;
					Return 3
				ELSE
					COMMIT;
				END IF
		END IF
	ELSEIF  LEFT(ls_purpose,1) = "D" AND SQLCA.SQLCode = 0 THEN
		SELECT SUM(BOL_QUANTITY)
		INTO :ld_bol_quantity
		FROM BOL, LAYTIME_STATEMENTS,CD
		WHERE BOL.VESSEL_NR = :ii_vessel_nr 
		AND BOL.VOYAGE_NR = :is_voyage_nr 
		AND BOL.CHART_NR =  :ii_chart_nr 
		AND BOL.CAL_CERP_ID = :li_cp 
		AND BOL.L_D = 0 
		AND BOL.PORT_CODE = :is_port_code 
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

		COMMIT USING SQLCA;

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
				WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :is_voyage_nr AND 
				  	   CHART_NR = :ii_chart_nr AND CLAIM_NR = :ii_claim_nr AND PORT_CODE = :is_port_code AND &
				   	   CAL_CAIO_ID = :ll_calcaioid AND SUBSTRING(DEM_DES_PURPOSE,1,1) = "D";
				IF SQLCA.SQLCode <> 0 THEN 
					ROLLBACK;
					Disconnect using temp_tran;
					DESTROY temp_tran;
					Return 4
				ELSE
					COMMIT;
				END IF
			END IF
			UPDATE DEM_DES_CLAIMS
			SET BOL_LOAD_QUANTITY = :ld_bol_quantity
			WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :is_voyage_nr AND 
			  	   CHART_NR = :ii_chart_nr AND CLAIM_NR = :ii_claim_nr AND PORT_CODE = :is_port_code AND &
			   	   CAL_CAIO_ID = :ll_calcaioid AND SUBSTRING(DEM_DES_PURPOSE,1,1) = "D";
			IF SQLCA.SQLCode <> 0 THEN 
				ROLLBACK;
				disconnect using temp_tran;
				DESTROY temp_tran;
				Return 4
			ELSE
				COMMIT;
			END IF
		END IF	
	  ELSE
		MessageBox("Error","Update of bill of lading quantity failed with port " + is_port_code + " !! Check bill of lading")
	  END IF 
FETCH dem_cur INTO :li_cp, :ld_load_daily, :ld_disch_daily, :ld_load_hourly, :ld_disch_hourly,:ls_purpose,:ll_calcaioid;
LOOP
CLOSE dem_cur;
COMMIT USING temp_tran;
COMMIT USING SQLCA;
disconnect using temp_tran;
DESTROY temp_tran;
Return 0
end function

public subroutine wf_recalc_demurrage ();integer li_pc_nr,li_number_of_dem_ports,li_error_code
s_calc_claim lstr_parm
uo_calc_dem_des_claims uo_calc_dem
double ld_exrate, ldo_cp_id_comm
decimal{2} ld_amount_usd, ld_amount
uo_auto_commission uo_auto_comm
n_claimcurrencyadjust lnv_claimcurrencyadjust

uo_calc_dem = CREATE uo_calc_dem_des_claims

SELECT PC_NR
	INTO :li_pc_nr
	FROM VESSELS
	WHERE VESSEL_NR = :ii_vessel_nr
	USING SQLCA;
COMMIT USING SQLCA;

SELECT Count(*)
	INTO :li_number_of_dem_ports
	FROM DEM_DES_CLAIMS
	WHERE VESSEL_NR = :ii_vessel_nr 
	AND VOYAGE_NR = :is_voyage_nr 
	AND CHART_NR = :ii_chart_nr 
	AND CLAIM_NR = :ii_claim_nr
	USING SQLCA;
COMMIT USING SQLCA;

IF li_pc_nr = 3 OR li_pc_nr = 5 THEN
	IF li_number_of_dem_ports < 2 THEN
		li_error_code = wf_update_dem_bol()
		lstr_parm = uo_calc_dem.uf_get_bulk_amount(ii_vessel_nr, is_voyage_nr, ii_chart_nr,ii_claim_nr)
	ELSE
		li_error_code = wf_update_dem_port()
		lstr_parm = uo_calc_dem.uf_get_bulk_amount_ports(ii_vessel_nr, is_voyage_nr, ii_chart_nr,ii_claim_nr)
	END IF
ELSE
	IF li_number_of_dem_ports < 2 THEN
		li_error_code = wf_update_dem_bol()
		lstr_parm = uo_calc_dem.uf_get_tank_amount(ii_vessel_nr, is_voyage_nr, ii_chart_nr,ii_claim_nr)
	ELSE
		li_error_code = wf_update_dem_port()
		lstr_parm = uo_calc_dem.uf_get_tank_amount_ports(ii_vessel_nr, is_voyage_nr, ii_chart_nr,ii_claim_nr)
	END IF
END IF
	
DESTROY uo_calc_dem

ld_amount = lstr_parm.claim_amount
lnv_claimcurrencyadjust.of_getclaimamounts(ii_vessel_nr, is_voyage_nr, ii_chart_nr,ii_claim_nr, ld_amount, ld_amount_usd, false)


CHOOSE CASE li_error_code
	CASE 0
		UPDATE CLAIMS
		SET CLAIM_AMOUNT = :lstr_parm.claim_amount,
			CLAIM_AMOUNT_USD = :ld_amount_usd
			WHERE VESSEL_NR = :ii_vessel_nr
		AND VOYAGE_NR = :is_voyage_nr
		AND CHART_NR = :ii_chart_nr
		AND CLAIM_NR = :ii_claim_nr ;

		COMMIT;
		If uo_auto_comm.of_check_exist(ii_vessel_nr,is_voyage_nr,ii_chart_nr,ii_claim_nr) Then
			uo_auto_comm.of_generate(ii_vessel_nr,is_voyage_nr,ii_chart_nr,ii_claim_nr,"DEM","OLD",ldo_cp_id_comm)
		End if
	CASE 1
		MessageBox("ERROR","Claims not updated, because of select error in DEM_DES_CLAIMS. ~r &
		please note data, and contact administrator")
	CASE 2
		MessageBox("ERROR","Claims not updated, because of select error in BOL. ~r &
		please note data, and contact administrator")
	CASE 3
		MessageBox("ERROR","Claims not updated, because of update (load) error in DEM_DES_CLAIMS. ~r &
		please note data, and contact administrator")
	CASE 4
		MessageBox("ERROR","Claims not updated, because of update (disch) error in DEM_DES_CLAIMS. ~r &
		please note data, and contact administrator")
END CHOOSE
return
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_laytime
   <OBJECT>Window object for Laytime data</OBJECT>
   <DESC></DESC>
   <USAGE></USAGE>
   <ALSO>u_claimbalance</ALSO>
    Date   Ref    Author        Comments
  01/03/11 1549      JSU     Multi currencies
  02/03/11 2294      AGL     attached new balance object to reflect currencies used.
  03/08/11 2468		AKH		Corrected negative laytime calculation
  22/06/12	2808		JMC112	Disable print option
  26/06/12	2808	JMC112	Button disabled.
  15/11/12	2987	LGX001	Add laytime missed column to dw_list_laytime_ports
  20/12/12	3083	LGX001	Added new function wf_getkeydata() & event ue_reload() to assist C/P update
  									when laytime window is still open.
  01/08/13	2947	LGX001	fixed the bug when int data overflow  
  01/09/14	CR3781	CCY018	The window title match with the text of a menu item
  21/07/16	CR4111	XSZ004		Add port with 'CHO' purpose for laytime.
  29/08/16	CR4219	LHG008	Accuracy and improvement in DEM and DEV claims handling(CHO)(REF_CR4111).
********************************************************************/

end subroutine

public function integer wf_getkeydata (ref s_vessel_voyage_chart_claim astr_currentdata);/********************************************************************
   wf_getkeydata
   <DESC>
		Implemented to be used when a charterer has changed in C/P data.  This function 
		gets the important data from the selected claim.
	</DESC>
   <RETURN>	integer:
            c#return.Success
				c#return.NoAction
	</RETURN>			
   <ACCESS> public </ACCESS>
   <ARGS>
		s_vessel_voyage_chart_claim: astr_currentdata
   </ARGS>
  <USAGE>
		business logic specific to C/P is left in cp object.  Expected process is to obtain data from window
		then manipulate according to implementation and then reload laytime window using event ue_reload()
		if needed.
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/2012 CR3083       LGX001        First Version
   </HISTORY>
********************************************************************/
long ll_row

ll_row = dw_list_claims.getrow()
if ll_row > 0 then
	astr_currentdata.vessel_nr = dw_list_claims.getitemnumber(ll_row, "vessel_nr")
	astr_currentdata.voyage_nr = dw_list_claims.getitemstring(ll_row, "voyage_nr")
	astr_currentdata.chart_nr =  dw_list_claims.getitemnumber(ll_row, "chart_nr")
	astr_currentdata.claim_nr =  ll_row
	astr_currentdata.status = "OPEN"
	return c#return.Success	
else
	return c#return.NoAction	
end if

end function

public subroutine wf_setcolor ();/********************************************************************
   wf_secolor
   <DESC>	</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		21/07/16		CR4111		XSZ004		First version
   </HISTORY>
********************************************************************/

int li_ret
long ll_color

li_ret = wf_ismandatory()

if li_ret = c#return.success then
	ll_color = c#color.MT_MAERSK
else
	ll_color = c#color.MT_LIST_BG
end if

dw_laytime_statement.modify("lay_event_d_1.background.color = " + string(ll_color))
dw_laytime_statement.modify("lay_event_d_2.background.color = " + string(ll_color))
dw_laytime_statement.modify("lay_event_d_3.background.color = " + string(ll_color))
dw_laytime_statement.modify("lay_commenced.background.color = " + string(ll_color))
dw_laytime_statement.modify("lay_completed.background.color = " + string(ll_color))
end subroutine

public function integer wf_validate ();/********************************************************************
   wf_validate
   <DESC>	Datawindow validation	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		21/07/16		CR4111		XSZ004		First version
   </HISTORY>
********************************************************************/

int li_ret

li_ret = wf_ismandatory()

if li_ret = c#return.failure then
	if dw_lay_deductions.rowcount() > 0 then
		messagebox("Validation error", "There are deductions but no laytime information, you must either enter laytime or delete deductions.", StopSign!)
		li_ret = c#return.failure
	else
		dw_laytime_statement.deleterow(0)
		li_ret = c#return.success
	end if
end if

return li_ret
end function

public function integer wf_ismandatory ();/********************************************************************
   wf_check_laytime
   <DESC>	Datawindow validation	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		21/07/16		CR4111		XSZ004		First version
   </HISTORY>
********************************************************************/

string   ls_column[]
integer  li_row, li_ret
datetime ldt_value

ls_column = {"lay_event_d_1", "lay_event_d_2", "lay_event_d_3", "lay_commenced", "lay_completed"}

li_ret = c#return.failure

if dw_laytime_statement.rowcount() > 0 then 
	for li_row = 1 to upperbound(ls_column)
	
		ldt_value = dw_laytime_statement.getitemdatetime(1, ls_column[li_row])
		
		if not isnull(ldt_value) then
			li_ret = c#return.success
			exit
		end if
	next
end if

return li_ret
end function

public function integer wf_update_laytimemissing_flag (boolean ab_commit);/********************************************************************
   wf_update_laytimemissing_flag
   <DESC>	Description	</DESC>
   <RETURN>	(none)
          
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE> this would be called from dw_list_laytime_ports.clicked() event: if select Missing or deselect </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/11/2012 CR2987       LGX001        First Version
		26/07/16		CR4111		XSZ004 				Adjust function.
   </HISTORY>
********************************************************************/

int    li_selectrow, li_vesselnr, li_pcn, li_laytime_missed, li_ret
string ls_voyagenr, ls_portcode

li_selectrow = dw_list_laytime_ports.getselectedrow(0)

li_ret = c#return.success

if li_selectrow > 0 then
	ls_voyagenr = dw_list_laytime_ports.getitemstring(li_selectrow, "cargo_voyage_nr")
	ls_portcode = dw_list_laytime_ports.getitemstring(li_selectrow, "cargo_port_code")
	li_pcn      = dw_list_laytime_ports.getitemnumber(li_selectrow, "cargo_pcn")
	
	if ab_commit then
		li_laytime_missed = dw_list_laytime_ports.getitemnumber(li_selectrow, "poc_laytime_missed")
	else
		li_laytime_missed = 1
	end if
	
	UPDATE POC 
	   SET LAYTIME_MISSED = :li_laytime_missed
	 WHERE POC.VESSEL_NR = :ii_vessel_nr AND POC.VOYAGE_NR = :ls_voyagenr AND POC.PORT_CODE = :ls_portcode AND POC.PCN = :li_pcn;

	if sqlca.sqlcode = 0 then
		li_ret = c#return.success
	else
		li_ret = c#return.failure
	end if
	
	if ab_commit then
		if li_ret = c#return.success then
			commit;
		else
			rollback;
		end if	
	end if
end if

return li_ret
end function

event open;call super::open;this.Move(5,5)
dw_list_claims.SetTransObject(SQLCA)
dw_list_laytime_ports.SetTransObject(SQLCA)
dw_laytime_statement.SetTransObject(SQLCA)
dw_lay_deductions.SetTransObject(SQLCA)
dw_new_deductions.SetTransObject(SQLCA)
//dw_lay_deductions.SetRowFocusIndicator(p_dot,10,15)

uo_vesselselect.of_registerwindow( w_laytime )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

IF (uo_global.ib_rowsindicator) then
	dw_list_claims.setrowfocusindicator(FOCUSRECT!)
end if
end event

event ue_retrieve;call super::ue_retrieve;long ll_rc
ll_rc = dw_list_claims.Retrieve(ii_vessel_nr)
COMMIT USING SQLCA;
dw_list_claims.ScrollToRow(ll_rc)
end event

on w_laytime.create
int iCurrent
call super::create
this.dw_list_claims=create dw_list_claims
this.dw_list_laytime_ports=create dw_list_laytime_ports
this.dw_laytime_statement=create dw_laytime_statement
this.dw_lay_deductions=create dw_lay_deductions
this.cb_update=create cb_update
this.cb_cancel=create cb_cancel
this.cb_delete=create cb_delete
this.cb_close=create cb_close
this.cb_new_reason=create cb_new_reason
this.dw_new_deductions=create dw_new_deductions
this.cb_1=create cb_1
this.uo_bal=create uo_bal
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list_claims
this.Control[iCurrent+2]=this.dw_list_laytime_ports
this.Control[iCurrent+3]=this.dw_laytime_statement
this.Control[iCurrent+4]=this.dw_lay_deductions
this.Control[iCurrent+5]=this.cb_update
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_delete
this.Control[iCurrent+8]=this.cb_close
this.Control[iCurrent+9]=this.cb_new_reason
this.Control[iCurrent+10]=this.dw_new_deductions
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.uo_bal
end on

on w_laytime.destroy
call super::destroy
destroy(this.dw_list_claims)
destroy(this.dw_list_laytime_ports)
destroy(this.dw_laytime_statement)
destroy(this.dw_lay_deductions)
destroy(this.cb_update)
destroy(this.cb_cancel)
destroy(this.cb_delete)
destroy(this.cb_close)
destroy(this.cb_new_reason)
destroy(this.dw_new_deductions)
destroy(this.cb_1)
destroy(this.uo_bal)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(dw_list_claims, "vessel_nr", "voyage_nr", True)
end event

event ue_vesselselection;call super::ue_vesselselection;	PostEvent("ue_retrieve")
	dw_list_laytime_ports.Reset()
	dw_laytime_statement.Reset()
	dw_lay_deductions.Reset()
	dw_new_deductions.Reset()
	uo_bal.of_setnull( )
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_laytime
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_laytime
integer x = 18
end type

type dw_list_claims from uo_datawindow within w_laytime
integer x = 37
integer y = 224
integer width = 677
integer height = 1228
integer taborder = 130
string dataobject = "dw_list_dem_des_claims"
boolean vscrollbar = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_laytime
  
 Object     : 
  
 Event	 :clicked

 Scope     : Local

 ************************************************************************************

 Author    : Leith Noval
   
 Date       : 01-01-1996

 Description : 

 Arguments :

 Returns   :

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01.01.96          2.0                   RM              Initial
04.03.96          2.15                 LN              Calculate and show net laytime for ports on selected voyage.
11.12.96		3.0			RM		  added COMMIT's  and deleted CREATE transaction
								  
************************************************************************************/
/* Declaring variables */
Integer li_rows, li_row_counter, li_pcn_nr
Long ll_gross_laytime, ll_deduct_laytime, ll_sum_gross_laytime, ll_sum_deduct_laytime, ll_net_laytime, ll_net_lay_port
Long ll_net_previus, ll_show_net_lay
String ls_port_code

/* Set redraw off because off dummy column cargo_vessel_nr in port list window,*/
/* that will be used for showing net laytime. */
Redraw_off(parent)
/* Highlight clicked row and get retrieval arguments for dw_list_laytime_ports */
//row = GetClickedRow()
/* Performed when clicked event is triggered from outside this datawindow */
IF isnull(row) or row = -1 THEN row = GetRow()

IF row > 0 THEN
	cb_new_reason.enabled = false
	SelectRow(0,FALSE)
	SetRow(row)
	SelectRow(row,TRUE)
	ii_vessel_nr = GetItemNumber(row,"vessel_nr")
	is_voyage_nr = GetItemString(row,"voyage_nr")
	ii_chart_nr = GetItemNumber(row,"chart_nr")
	ii_claim_nr = GetItemNumber(row,"claim_nr")
	
	sqlca.autocommit = true
	
	dw_list_laytime_ports.Retrieve(ii_vessel_nr,is_voyage_nr, ii_chart_nr)
	
	sqlca.autocommit = false
	
	COMMIT USING SQLCA;
	dw_laytime_statement.Reset()
	dw_lay_deductions.Reset()
	uo_bal.of_claimbalance(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr)
ELSE
	SetNull(ii_vessel_nr)
	SetNull(is_voyage_nr)
	SetNull(ii_chart_nr)
END IF

/* Count ports for selected voyage */
li_rows = dw_list_laytime_ports.RowCount()

/* For all ports of selected voyage, get port code and pcn for collection key for laytime and deductions */
FOR li_row_counter = 1 TO li_rows
	ls_port_code = dw_list_laytime_ports.GetItemString(li_row_counter,"cargo_port_code")
	li_pcn_nr = dw_list_laytime_ports.GetItemNumber(li_row_counter,"cargo_pcn")

/* Declare cursor for laytime */
 DECLARE lay_cur CURSOR FOR  
  SELECT	 LAYTIME_STATEMENTS.LAY_MINUTES  
  FROM LAYTIME_STATEMENTS  
   WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :is_voyage_nr AND CHART_NR = :ii_chart_nr AND
		PORT_CODE = :ls_port_code AND PCN = :li_pcn_nr 
 USING SQLCA;

OPEN lay_cur;

FETCH lay_cur INTO :ll_gross_laytime;

if sqlca.sqlcode = 100 then
	dw_list_laytime_ports.SetItem(li_row_counter, "laytime_flag" , 1)
end if


/* Get sum of laytime */
DO WHILE SQLCA.SQLCode = 0
	ll_sum_gross_laytime = ll_sum_gross_laytime + ll_gross_laytime
	FETCH lay_cur INTO :ll_gross_laytime;
LOOP
CLOSE lay_cur;
COMMIT USING SQLCA;

/* Declare cursor for deductions */
 DECLARE ded_cur CURSOR FOR  
  SELECT  LAY_DEDUCTIONS.DEDUCTION_MINUTES 
  FROM   LAY_DEDUCTIONS 
   WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :is_voyage_nr AND CHART_NR = :ii_chart_nr AND
		PORT_CODE = :ls_port_code AND PCN = :li_pcn_nr
 USING SQLCA;

OPEN ded_cur;

FETCH ded_cur INTO :ll_deduct_laytime;

/* Get sum of deductions */
DO WHILE SQLCA.SQLCode = 0
	ll_sum_deduct_laytime =  ll_sum_deduct_laytime + ll_deduct_laytime
	FETCH ded_cur INTO :ll_deduct_laytime;
LOOP
CLOSE ded_cur;
COMMIT USING SQLCA;

/*calculate net laytime in minutes. Is not shown in datawindow, but used in a computed field.*/
ll_net_lay_port =  (ll_sum_gross_laytime - ll_sum_deduct_laytime)
ll_show_net_lay = ll_net_lay_port - ll_net_previus
dw_list_laytime_ports.SetItem(li_row_counter, "cargo_vessel_nr" , ll_show_net_lay)
ll_net_previus = ll_net_lay_port

NEXT

Redraw_on(parent)
end event

type dw_list_laytime_ports from uo_datawindow within w_laytime
integer x = 731
integer y = 232
integer width = 1184
integer height = 572
integer taborder = 100
string dataobject = "d_sp_tb_laytimeports"
boolean vscrollbar = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_laytime
  
 Object     : dw_list_laytime_ports
  
 Event	 :  clicked

 Scope     : Local

 ************************************************************************************

 Author    : Leith Noval
   
 Date       : 01-01-96

 Description : 

 Arguments : none

 Returns   : none

 Variables : is_gross_laytime, is_sum_reason 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01-01-96		2.0			RM		Initial Version
04-03-96		2.15 		LN 		Compute and show net laytime for selected port. 
								Net laytime = Gross laytime - Deductions
11-12-96		3.0			RM		added COMMIT's  
************************************************************************************/
/* Declare local variables */
long ll_row
integer li_rc, li_pc_nr
long    ll_gross, ll_deduct, ll_net
String  ls_net_laytime
Dec {2}  ld_net_laytime


/* get the clicked row */
ll_row = GetClickedRow()
/* if clicked row returns error, then set row as previously selected row */
If ll_row = -1 Then ll_row = GetSelectedRow(0)

if isvalid(dwo) then
	if dwo.name = "poc_laytime_missed" then parent.post wf_update_laytimemissing_flag(true)
end if

/* if row is valid then ... */
IF ll_row > 0 THEN
	cb_new_reason.enabled = true
	/* deselect all rows */
	SelectRow(0,FALSE)

	/* set row to new row */
	SetRow(ll_row)

	/* highlight new row */
	SelectRow(ll_row,TRUE)

	/* get clicked rows port_code and call number */
	is_port_code = GetItemString(ll_row, "cargo_port_code")
	ii_pcn = GetItemNumber(ll_row, "cargo_pcn")

	/* retrieve laytime statment with arguments from selected row */
	
	ls_net_laytime = " "
	dw_laytime_statement.Modify("net_laytime.text='"+ ls_net_laytime + "'")

	li_rc = dw_laytime_statement.Retrieve(ii_vessel_nr, is_voyage_nr, ii_chart_nr, is_port_code, ii_pcn)
	COMMIT USING SQLCA;
	
	IF li_rc > 0 THEN is_gross_laytime = String(dw_laytime_statement.GetItemNumber(1,"LAY_MINUTES"))
	/* If no rows retrieved then reset laytime statement. */		
	IF li_rc = 0 THEN
		dw_laytime_statement.Reset()
		dw_laytime_statement.InsertRow(0)
		dw_laytime_statement.SetItem(1,"vessel_nr",ii_vessel_nr)
		dw_laytime_statement.SetItem(1,"voyage_nr",is_voyage_nr)
		dw_laytime_statement.SetItem(1,"chart_nr",ii_chart_nr)
		dw_laytime_statement.SetItem(1,"port_code",is_port_code)
		dw_laytime_statement.SetItem(1,"pcn",ii_pcn)
		SELECT PC_NR
		INTO :li_pc_nr
		FROM VESSELS
		WHERE VESSEL_NR = :ii_vessel_nr
		USING SQLCA;
		COMMIT USING SQLCA; 
		IF (li_pc_nr = 3 OR li_pc_nr = 5) THEN
			dw_laytime_statement.SetItem(1,"lay_event_t1","Nor tendered")
			dw_laytime_statement.SetItem(1,"lay_event_t2","Berthed (all fast)")
			dw_laytime_statement.SetItem(1,"lay_event_t3"," ")
		ELSE
			dw_laytime_statement.SetItem(1,"lay_event_t1","Nor tendered")
			dw_laytime_statement.SetItem(1,"lay_event_t2","Berthed (all fast)")
			dw_laytime_statement.SetItem(1,"lay_event_t3","Hoses disconnected")
		END IF
		dw_laytime_statement.SetItem(1,"lay_finish",0)	
	END IF
	li_rc = dw_lay_deductions.Retrieve(ii_vessel_nr, is_voyage_nr, ii_chart_nr, is_port_code, ii_pcn)
	COMMIT USING SQLCA;
/* else if row is NOT valid then ... */	
ELSE	
	SetNull(is_port_code)
	SetNull(ii_pcn) 
END IF

/* Compute net laytime in minutes = li_net */ 
ll_gross = long(double(is_gross_laytime))
ll_deduct = long(double(is_sum_reason))
ll_net = ll_gross - ll_deduct

/* Compute minutes in form hours,minutes */
if ll_net < 0 then 
	ld_net_laytime = -((long(-ll_net/60)) + (mod(-ll_net,60)/100))
else
	ld_net_laytime = long(ll_net/60) + (mod(ll_net,60)/100)	
end if

/* Convert to string */
ls_net_laytime = string(ld_net_laytime)
/* Replace '.' (comma) with ':' (colon) */
ls_net_laytime = replace(ls_net_laytime, Pos(ls_net_laytime, ".", 1),1,":")

/*IF no laytime (net laytime = 0) then set blank space */
IF (ld_net_laytime = 0 OR li_rc = 0 ) THEN ls_net_laytime = " "

/* Show net laytime in dw_laytime_statement */
dw_laytime_statement.Modify("net_laytime.text='"+ ls_net_laytime + "'")

wf_setcolor()
end event

type dw_laytime_statement from uo_datawindow within w_laytime
integer x = 1938
integer y = 232
integer width = 1074
integer height = 572
integer taborder = 90
string dataobject = "dw_laytime_statement"
end type

event itemchanged;call super::itemchanged;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : w_laytime
 Object     : 
 Event	 : Itemchanged
 Scope     : Local
 ************************************************************************************
 Author    : Leith Noval
 Date       : 01-01-1996
 Description : Calculate and set gross laytime in minutes. Is not shown in window.
 Arguments : none
 Returns   : none
 Variables : 
 Other : 
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01-01-96		2.0 			RM		Initial version
  
************************************************************************************/
integer 	li_response, li_vessel, li_pcn
string	ls_voyage, ls_portcode
long 		ll_minutes, ll_row
datetime	ldt_port_arr_date, ldt_nor_tender

AcceptText()
ll_row = GetRow()
/* Calculate gross laytime in minutes */

ll_minutes = f_timedifference(GetItemDateTime(ll_row,"lay_commenced"), GetItemDateTime(ll_row,"lay_completed"))
SetItem(ll_row,"lay_minutes",ll_minutes)

wf_setcolor()

IF ll_row > 0 THEN

	// Added by FR 01-10-02 - START
	if (this.GetColumnName() = "lay_commenced" or this.getcolumnName() = "lay_event_d_1") then
		if (getitemdatetime(ll_row, "lay_commenced") < getitemdatetime(ll_row, "lay_event_d_1")) then
			li_response = Messagebox("Datetime mismatch", "Datetime for laytime commenced is earlier than datetime for NOR tendered - do you want to proceed ?",&
								Exclamation!, YesNo!, 1)
			if (li_response = 1) then
				//Return 0
			else
				this.setitem(ll_row, this.getcolumnName(),this.getitemdatetime(ll_row, this.getcolumnName(),Primary!, TRUE))
				Return 1
			end if
		end if
	end if
	// Added by FR 01-10-02 - END
	
	// Added by REM 23-12-03 - START
	if this.GetColumnName() = "lay_completed" then
		li_vessel 	= this.getitemnumber(ll_row, "vessel_nr")
		ls_voyage 	= this.getitemstring(ll_row, "voyage_nr")
		ls_portcode = this.getitemstring(ll_row, "port_code")
		li_pcn		= this.getitemnumber(ll_row, "pcn")
		SELECT PORT_DEPT_DT
			INTO :ldt_port_arr_date
			FROM POC
			WHERE VESSEL_NR = :li_vessel
			AND VOYAGE_NR = :ls_voyage
			AND PORT_CODE = :ls_portcode
			AND PCN = :li_pcn ;
		if IsNull(ldt_port_arr_date) then
			li_response = Messagebox("Datetime mismatch", "No Port Departure date entered in POC - do you want to proceed ?",&
								Exclamation!, YesNo!, 1)
			if (li_response = 1) then
				//Return 0
			else
				this.setcolumn(this.getcolumnName())
				Return 1
			end if
		end if			
		if abs(f_timedifference(GetItemDateTime(ll_row,"lay_completed"), ldt_port_arr_date)/60) >=12 then
			li_response = Messagebox("Datetime warning", "Datetime for laytime completed differs from departure with more than 12 hours - do you want to proceed ?",&
								Exclamation!, YesNo!, 1)
			if (li_response = 1) then
				//Return 0
			else
				this.setcolumn(this.getcolumnName())
				Return 1
			end if
		end if
	end if
	// Added by REM 23-12-03 - END

END IF
end event

event editchanged;call super::editchanged;wp_select_enabled(false, false)













end event

event itemerror;call super::itemerror;return 1
end event

type dw_lay_deductions from uo_datawindow within w_laytime
integer x = 731
integer y = 820
integer width = 2286
integer height = 564
integer taborder = 30
string dataobject = "dw_lay_deductions"
boolean vscrollbar = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_laytime

 Object     : 
  
 Event	 :  clicked

 Scope     : Local

 ************************************************************************************

 Author    : Leith Noval
   
 Date       : 01-01-1996

 Description : Highlights clicked row in reasons.

 Arguments : none

 Returns   : none

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
 01-01-96 	2.0		       RM 		Initial version
  
************************************************************************************/
/* declaring variable*/
long ll_row
/*Highlight clicked row */
ll_row = GetClickedRow()
IF ll_row > 0 THEN
	SelectRow(0,FALSE)
	SelectRow(ll_row,TRUE)
END IF
end event

on retrieveend;call uo_datawindow::retrieveend;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_laytime
  
 Object     : 
  
 Event	 :  retrievend

 Scope     : Local

 ************************************************************************************

 Author    : Leith Noval
   
 Date       : 01-01-1996

 Description : 

 Arguments : none

 Returns   : none

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
 04-03 -96  	2.15 		LN 	        Initial version
  
************************************************************************************/
/* Get sum of reason time in minutes for instance variable is_sum_reason.  */

String ls_expr

ls_expr = dw_lay_deductions.Describe("sum_reason.expression")
ls_expr = "evaluate('"+ls_expr+"',0)"
is_sum_reason = dw_lay_deductions.Describe(ls_expr)

end on

event doubleclicked;call super::doubleclicked;long ll_row
ll_row = GetClickedRow()
IF ll_row > 0 THEN

	IF dwo.name="gr_deductions" then
		IF GetItemNumber(ll_row,"gr_deductions") = 1 THEN
			s_group_deductions_parm lstr_parametre
			lstr_parametre.vessel_nr = GetItemNumber(ll_row,"vessel_nr")
			lstr_parametre.voyage_nr = GetItemString(ll_row,"voyage_nr")
			lstr_parametre.chart_nr = GetItemNumber(ll_row,"chart_nr")
			lstr_parametre.port_code = GetItemString(ll_row,"port_code")
			lstr_parametre. pcn = GetItemNumber(ll_row,"pcn")
			lstr_parametre.reason_nr = GetItemNumber(ll_row,"reason_nr")
			lstr_parametre.modify = TRUE
			lstr_parametre.modify_rownr = ll_row
			openwithparm(w_group_deductions, lstr_parametre)
		END IF
	ELSE
		
	
		SetTabOrder("reason",10)
		SetTabOrder("reason_start",20)
		SetTabOrder("reason_end",30)
		SetTabOrder("deduction_pct",40)
		wp_select_enabled( false, false)
		dw_lay_deductions.enabled=true
		dw_laytime_statement.enabled = false
		

		
//		cb_update.enabled=true
//		cb_cancel.enabled=true
		
	END IF
END IF
end event

event itemchanged;call super::itemchanged;decimal {2} ld_pct
long ll_minutes
AcceptText()

// wp_select_enabled(true,false)

ll_minutes = f_timedifference(GetItemDateTime(row,"reason_start"), GetItemDateTime(row,"reason_end"))
ld_pct = GetItemNumber(row,"deduction_pct")
SetItem(row,"deduction_minutes",Round(ll_minutes * ld_pct / 100,0))
end event

event editchanged;call super::editchanged;// wp_select_enabled(true,false)
end event

event rowfocuschanged;call super::rowfocuschanged;IF cb_update.enabled THEN
	IF currentrow > 0 THEN
		SelectRow(0,FALSE)
		SelectRow(currentrow,TRUE)
	END IF
END IF
end event

type cb_update from commandbutton within w_laytime
integer x = 1225
integer y = 1504
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Update"
end type

event clicked;Integer 	li_in_log, li_rtn
long   ll_row, ll_listrow
string ls_claimtype
double ldo_cp

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF
	
uo_find_layt_ports uo_layt_ports
uo_layt_ports = CREATE uo_find_layt_ports

this.default = False

if dw_laytime_statement.Enabled Then
	
	dw_laytime_statement.accepttext()
	
	dw_laytime_statement.setredraw(false)
	
	if wf_validate() = c#return.failure then 
		dw_laytime_statement.setredraw(true)
		return
	end if
	
	IF dw_laytime_statement.Update() = 1 THEN
		
		if dw_laytime_statement.rowcount() < 1 then
			if wf_update_laytimemissing_flag(false) = c#return.failure then
				
				rollback;
				
				dw_laytime_statement.setredraw(true)
				DESTROY uo_layt_ports
				dw_new_deductions.reset( )
				
				return 
			end if
		end if
		
		COMMIT;
		
		uo_layt_ports.uf_layt_ports(ii_vessel_nr, is_voyage_nr, ii_chart_nr,istr_port_array)
		wf_set_dem_settled(ii_vessel_nr, is_voyage_nr, ii_chart_nr,ii_claim_nr)
		wf_recalc_demurrage()
		/* START - Updates address commission */
		u_addr_commission lnv_calc_adrcomm
		lnv_calc_adrcomm = create u_addr_commission
		if lnv_calc_adrcomm.of_add_com(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr) = -1 then
			rollback;
		else
			commit;
		end if
		destroy lnv_calc_adrcomm
		/* END - Updates address commission */
		/* START - Update Broker Commission */
		uo_auto_commission	lnv_calc_brokercomm   /* autoinstantiated */
		ls_claimtype = dw_list_claims.getItemString(dw_list_claims.getrow(), "claim_type")
		ldo_cp = dw_list_claims.getItemNumber(dw_list_claims.getrow(), "cp_id_comm")
		if lnv_calc_brokercomm.of_generate(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr, ls_claimtype, "OLD", ldo_cp) = -1 then
			rollback;
		else
			commit;
		end if
		/* END - Update Broker Commission */
		uo_bal.of_claimbalance(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr)
		wp_select_enabled(False,True)
		//  Recalc net laytime in datawindow - dw_list_laytime_ports
//		dw_list_laytime_ports.SetRedraw(FALSE)
		ll_row = dw_list_laytime_ports.GetRow()
		ll_listrow = dw_list_claims.getselectedrow(0)
		dw_list_claims.Event Clicked(0,0,ll_listrow, dw_list_claims.object)
		dw_list_laytime_ports.SetRow(ll_row)
		dw_list_laytime_ports.SelectRow(ll_row,TRUE)
		dw_list_laytime_ports.TriggerEvent(Clicked!)
//		dw_list_laytime_ports.SetRedraw(TRUE)
	ELSE
		ROLLBACK;
	END IF
	
	dw_laytime_statement.setredraw(true)
Else
	// modify existing deduction
	if dw_new_deductions.rowcount() = 0 then		
		Parent.TriggerEvent("ue_update_modified")
	else	
		Parent.TriggerEvent("ue_update_new")
	end if
	ll_row = dw_list_laytime_ports.GetRow()
	ll_listrow = dw_list_claims.getselectedrow(0)
	dw_list_claims.Event Clicked(0,0,ll_listrow, dw_list_claims.object)
	dw_list_laytime_ports.SetRow(ll_row)
	dw_list_laytime_ports.SelectRow(ll_row,TRUE)
	dw_list_laytime_ports.TriggerEvent(Clicked!)
	cb_new_reason.Default = TRUE
END IF

DESTROY uo_layt_ports

dw_new_deductions.reset( )

end event

type cb_cancel from commandbutton within w_laytime
integer x = 1577
integer y = 1504
integer width = 343
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "C&ancel"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

If dw_laytime_statement.Enabled Then dw_list_laytime_ports.TriggerEvent(Clicked!)

if dw_lay_deductions.modifiedcount( )>0 then
	dw_lay_deductions.retrieve(ii_vessel_nr,is_voyage_nr,ii_chart_nr,is_port_code,ii_pcn)
end if	

dw_new_deductions.reset( )

wp_select_enabled(not dw_laytime_statement.enabled,true)
dw_lay_deductions.SetTabOrder("reason",0)
dw_lay_deductions.SetTabOrder("reason_start",0)
dw_lay_deductions.SetTabOrder("reason_end",0)
dw_lay_deductions.SetTabOrder("deduction_pct",0)
cb_new_reason.enabled = true
cb_new_reason.default=true




end event

type cb_delete from commandbutton within w_laytime
integer x = 1938
integer y = 1504
integer width = 343
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;long ll_row
integer li_returncode, li_reason_nr

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row= dw_lay_deductions.GetRow()
IF ll_row > 0 THEN
	IF dw_lay_deductions.GetItemNumber(ll_row,"gr_deductions") = 1 THEN
		li_returncode = MessageBox("Confirm delete of Deduction!","Please confirm delete of current selected Deduction, which will include delete of:~r~n~r~n- Group Deductions",Question!,OKCancel!,2)
		IF li_returncode = 2 THEN 
			return
		ELSE
			li_reason_nr = dw_lay_deductions.GetItemNumber(ll_row,"reason_nr")
			DELETE 
				FROM GROUP_DEDUCTIONS
				WHERE VESSEL_NR = :ii_vessel_nr
				AND VOYAGE_NR = :is_voyage_nr
				AND CHART_NR = :ii_chart_nr
				AND PORT_CODE = :is_port_code
				AND PCN = :ii_pcn
				AND REASON_NR = :li_reason_nr  ;
			IF SQLCA.SQLCode = 0 THEN
				dw_lay_deductions.DeleteRow(ll_row)
 				IF dw_lay_deductions.Update() = 1 THEN
					COMMIT;
					cb_update.Event Clicked()
				ELSE
					ROLLBACK;
				END IF
			ELSE
				ROLLBACK;
			END IF
		END IF
	ELSE
		li_returncode = MessageBox("Confirm delete of Deduction!","Please confirm delete of current selected Deduction",Question!,OKCancel!,2)
		IF li_returncode = 2 THEN 
			return
		ELSE
			dw_lay_deductions.DeleteRow(ll_row)
			IF dw_lay_deductions.Update() = 1 THEN
				COMMIT;
				cb_update.Event Clicked()
			ELSE
				ROLLBACK;
			END IF
		END IF
	END IF
END IF

cb_new_reason.Default = TRUE
this.Default = FALSE
				

end event

type cb_close from commandbutton within w_laytime
integer x = 2661
integer y = 1504
integer width = 343
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

on clicked;close(parent)
end on

type cb_new_reason from commandbutton within w_laytime
integer x = 2299
integer y = 1504
integer width = 343
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&New Reason"
boolean default = true
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_laytime_statement.rowCount() < 1 or isNull(dw_laytime_statement.getItemdatetime(1, "lay_completed")) then 
	MessageBox("Validation error", "Please enter laytime information before deductions")
	return
end if

wp_select_enabled(True,false)
//cb_delete.Enabled = FALSE
this.Default = FALSE

long ll_max_reason_nr
SetNull(ll_max_reason_nr)
SELECT MAX(REASON_NR)
	INTO :ll_max_reason_nr
	FROM LAY_DEDUCTIONS
	WHERE VESSEL_NR = :ii_vessel_nr
	AND VOYAGE_NR = :is_voyage_nr
	AND CHART_NR = :ii_chart_nr
	AND PORT_CODE = :is_port_code
	AND PCN = :ii_pcn
USING SQLCA ;

COMMIT USING SQLCA;

IF IsNull(ll_max_reason_nr) THEN
	ll_max_reason_nr = 1
ELSE
	ll_max_reason_nr += 1
END IF
dw_new_deductions.Reset()
dw_new_deductions.InsertRow(0)
dw_new_deductions.SetItem(1,"vessel_nr",ii_vessel_nr)
dw_new_deductions.SetItem(1,"voyage_nr",is_voyage_nr)
dw_new_deductions.SetItem(1,"chart_nr",ii_chart_nr)
dw_new_deductions.SetItem(1,"port_code",is_port_code)
dw_new_deductions.SetItem(1,"pcn",ii_pcn)
dw_new_deductions.SetItem(1,"reason_nr",ll_max_reason_nr)
dw_new_deductions.SetItem(1,"gr_deductions",0)
dw_new_deductions.SetItem(1,"deduction_pct",100)
dw_new_deductions.Show()


end event

type dw_new_deductions from uo_datawindow within w_laytime
integer x = 731
integer y = 1400
integer width = 2103
integer height = 80
integer taborder = 10
string dataobject = "dw_new_deductions"
boolean border = false
end type

event itemchanged;call super::itemchanged;decimal {2} ld_pct
long ll_minutes
AcceptText()

// Validate that "deduction_pct" is a positive number
CHOOSE CASE GetColumnName()
	CASE "deduction_pct"
		If GetItemNumber(row,"deduction_pct") < 0 Then Return 1
END CHOOSE

ll_minutes = f_timedifference(GetItemDateTime(1,"reason_start"), GetItemDateTime(1,"reason_end"))
ld_pct = GetItemNumber(1,"deduction_pct")
SetItem(1,"deduction_minutes",Round(ll_minutes * ld_pct / 100,0))

CHOOSE CASE GetColumnName()
	CASE "gr_deductions"
		s_group_deductions_parm lstr_parametre

		SetItem(1,"gr_deductions",1)
		SetColumn("reason")
		lstr_parametre.vessel_nr = ii_vessel_nr
		lstr_parametre.voyage_nr = is_voyage_nr
		lstr_parametre.chart_nr = ii_chart_nr
		lstr_parametre.port_code = is_port_code
		lstr_parametre. pcn = ii_pcn
		lstr_parametre.reason_nr = GetItemNumber(1,"reason_nr")
		lstr_parametre.modify = FALSE
		openwithparm(w_group_deductions, lstr_parametre)
END CHOOSE

end event

type cb_1 from commandbutton within w_laytime
integer x = 2231
integer y = 32
integer width = 603
integer height = 100
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Print Laytime Statement"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_laytime
  
 Object     : 
  
 Event	 :  clicked

 Scope     : Local

 ************************************************************************************

 Author    : Leith Noval

 Date       : 01-01-96

 Description : Opens print window for this laytime.

 Arguments : 

 Returns   : 

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01-01-96  	2.0 			RM     	Initial version
28-12-11		M5-2  		LGX001  
22-06-12		CR2808		JMC112	Disable print option
  
************************************************************************************/

Messagebox("Warning", "This functionality is temporary disabled. Please use the Print option from the Claims window.")

return

long ll_row
s_vessel_voyage_chart_claim lstr_parm

ll_row = dw_list_claims.getrow()
if ll_row > 0 then
	lstr_parm.claim_title = 'Print Laytime Statement'
	lstr_parm.vessel_nr  = ii_vessel_nr
	lstr_parm.voyage_nr  = dw_list_claims.GetItemString(ll_row, "voyage_nr")
	lstr_parm.chart_nr   = dw_list_claims.GetItemNumber(ll_row, "chart_nr")
	lstr_parm.claim_nr   = dw_list_claims.GetItemNumber(ll_row, "claim_nr")
	lstr_parm.claim_type = dw_list_claims.GetItemString(ll_row, "claim_type")
	lstr_parm.discharge_date    = dw_list_claims.getitemdatetime(ll_row, "discharge_date")
	lstr_parm.ax_invoice_nr     = dw_list_claims.getitemstring(ll_row, "invoice_nr")
	lstr_parm.send_to_ax_locked = dw_list_claims.getitemnumber(ll_row, "locked")
	lstr_parm.claim_id = dw_list_claims.getitemnumber(ll_row, "claim_id")
	lstr_parm.cp_date  = dw_list_claims.getitemdatetime(ll_row,"cp_date")
	
	openwithparm(w_print_support_documents_dem, lstr_parm)
end if
cb_update.default = true
end event

type uo_bal from u_claimbalance within w_laytime
integer x = 41
integer y = 1456
integer taborder = 40
boolean bringtotop = true
end type

on uo_bal.destroy
call u_claimbalance::destroy
end on

