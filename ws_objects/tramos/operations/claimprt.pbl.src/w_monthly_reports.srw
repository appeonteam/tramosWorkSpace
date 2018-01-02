$PBExportHeader$w_monthly_reports.srw
$PBExportComments$Window to select monthly reports
forward
global type w_monthly_reports from window
end type
type rb_5 from radiobutton within w_monthly_reports
end type
type rb_4 from radiobutton within w_monthly_reports
end type
type rb_print from radiobutton within w_monthly_reports
end type
type rb_excel from radiobutton within w_monthly_reports
end type
type dw_enddate from datawindow within w_monthly_reports
end type
type dw_startdate from datawindow within w_monthly_reports
end type
type em_2 from editmask within w_monthly_reports
end type
type em_1 from editmask within w_monthly_reports
end type
type st_5 from statictext within w_monthly_reports
end type
type st_4 from statictext within w_monthly_reports
end type
type cbx_7 from checkbox within w_monthly_reports
end type
type st_3 from statictext within w_monthly_reports
end type
type dw_stats from uo_datawindow within w_monthly_reports
end type
type cb_report from commandbutton within w_monthly_reports
end type
type cbx_no_desp from checkbox within w_monthly_reports
end type
type rb_3 from radiobutton within w_monthly_reports
end type
type rb_2 from radiobutton within w_monthly_reports
end type
type rb_1 from radiobutton within w_monthly_reports
end type
type dw_misc_by_vessel_charterer from uo_datawindow within w_monthly_reports
end type
type dw_dem_by_vessel_charterer from uo_datawindow within w_monthly_reports
end type
type dw_misc_summary from uo_datawindow within w_monthly_reports
end type
type cbx_6 from checkbox within w_monthly_reports
end type
type cbx_5 from checkbox within w_monthly_reports
end type
type cbx_4 from checkbox within w_monthly_reports
end type
type cbx_3 from checkbox within w_monthly_reports
end type
type cbx_2 from checkbox within w_monthly_reports
end type
type cbx_1 from checkbox within w_monthly_reports
end type
type lb_profitcenter from listbox within w_monthly_reports
end type
type cb_close from commandbutton within w_monthly_reports
end type
type st_2 from statictext within w_monthly_reports
end type
type st_1 from statictext within w_monthly_reports
end type
type dw_demurrage_summary from datawindow within w_monthly_reports
end type
type gb_5 from groupbox within w_monthly_reports
end type
type gb_4 from groupbox within w_monthly_reports
end type
type gb_1 from groupbox within w_monthly_reports
end type
type gb_3 from groupbox within w_monthly_reports
end type
type gb_2 from groupbox within w_monthly_reports
end type
type gb_6 from groupbox within w_monthly_reports
end type
end forward

global type w_monthly_reports from window
integer x = 5
integer width = 1792
integer height = 1592
boolean titlebar = true
string title = "Monthly Reports"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 81324524
rb_5 rb_5
rb_4 rb_4
rb_print rb_print
rb_excel rb_excel
dw_enddate dw_enddate
dw_startdate dw_startdate
em_2 em_2
em_1 em_1
st_5 st_5
st_4 st_4
cbx_7 cbx_7
st_3 st_3
dw_stats dw_stats
cb_report cb_report
cbx_no_desp cbx_no_desp
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
dw_misc_by_vessel_charterer dw_misc_by_vessel_charterer
dw_dem_by_vessel_charterer dw_dem_by_vessel_charterer
dw_misc_summary dw_misc_summary
cbx_6 cbx_6
cbx_5 cbx_5
cbx_4 cbx_4
cbx_3 cbx_3
cbx_2 cbx_2
cbx_1 cbx_1
lb_profitcenter lb_profitcenter
cb_close cb_close
st_2 st_2
st_1 st_1
dw_demurrage_summary dw_demurrage_summary
gb_5 gb_5
gb_4 gb_4
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
gb_6 gb_6
end type
global w_monthly_reports w_monthly_reports

type prototypes
/*  This function is used to obtain various information regarding the
  run-time environment, such as the current screen resolution, and
  the dimensions of the different components of a window.  */

FUNCTION integer GetSystemMetrics (int nIndex) Library "user.exe"

end prototypes

type variables
string is_pc_name
integer ii_pc_nr[], ii_gas_group
string is_pc_nrs
datetime id_startdate, id_enddate
str_progress parm
double id_DEM_sum = -1, id_MISC_sum = -1
end variables

forward prototypes
public function integer wf_summary (boolean pb_summary_demurrage)
public function integer wf_stats (ref datawindow dw_name, string dem_misc)
public subroutine documentation ()
end prototypes

public function integer wf_summary (boolean pb_summary_demurrage);
/*
  MI 19-02-96. Combined MISC and DEM summary in same script. Actual type is selected 
                       by pb_summary_demurrage (true = DEM, false = MISC)
*/

datawindowchild dwc
datawindow dw_summary
Decimal {2} ld_amount = 0

if pb_summary_demurrage Then
	dw_summary = dw_demurrage_summary
Else
	dw_summary = dw_misc_summary
End if

dw_summary.GetChild("forwarded",dwc)
dwc.SetTransObject(SQLCA)
dwc.Retrieve(id_startdate,id_enddate,ii_pc_nr[])
COMMIT USING SQLCA;


IF pb_summary_demurrage THEN
	IF ii_gas_group = 1 THEN
       		//FORWARDED, DEMMURRAGE, J TYPES
				SELECT sum(CLAIMS.CLAIM_AMOUNT_USD)  
		  		INTO :ld_amount
        	 	FROM CLAIMS, VESSELS								
        	 	WHERE
         	( CLAIMS.FORWARDING_DATE >= :id_startdate ) AND  
         	( CLAIMS.FORWARDING_DATE <= :id_enddate ) AND         	
				(CLAIMS.CLAIM_TYPE = 'DEM' OR  
         	CLAIMS.CLAIM_TYPE = 'DES' ) AND  
         	CLAIMS.CLAIM_AMOUNT_USD > 0 AND
				(VESSELS.PC_NR = 9 ) AND 						
				(VESSELS.CAL_VEST_TYPE_ID = 4) AND 				
				( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR )  
	 	USING SQLCA;
		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;		
		IF IsNull(ld_amount) THEN ld_amount = 0
		dwc.SetITem(1,"compute_0001", ld_amount)
	
	ELSEIF  ii_gas_group = 2 THEN
		 	//FORWARDED, DEMMURRAGE, NOT J TYPES 	 
		 	SELECT sum(CLAIMS.CLAIM_AMOUNT_USD)  
		 	INTO :ld_amount
         FROM CLAIMS, VESSELS							
        	 WHERE
    	 	 ( CLAIMS.FORWARDING_DATE >= :id_startdate ) AND  
      	 ( CLAIMS.FORWARDING_DATE <= :id_enddate ) AND  
     		 (CLAIMS.CLAIM_TYPE = 'DEM' OR  
     		  CLAIMS.CLAIM_TYPE = 'DES' ) AND  
     		  CLAIMS.CLAIM_AMOUNT_USD > 0 AND
			 (VESSELS.PC_NR = 9 ) AND 						
				(VESSELS.CAL_VEST_TYPE_ID = 4) AND 				
			 ( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR ) 
		USING SQLCA;
		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;		
		IF IsNull(ld_amount) THEN ld_amount = 0
		dwc.SetITem(1,"compute_0001", ld_amount)
	END IF

ELSE
	IF ii_gas_group = 1THEN
       		//FORWARDED, MISCELLANEOUS, J TYPES
				SELECT sum(CLAIMS.CLAIM_AMOUNT_USD)  
		  		INTO :ld_amount
        	 	FROM CLAIMS, VESSELS								
        	 	WHERE
         	( CLAIMS.FORWARDING_DATE >= :id_startdate ) AND  
         	( CLAIMS.FORWARDING_DATE <= :id_enddate ) AND  
         	(CLAIMS.CLAIM_TYPE <> "DEM" AND  
         	CLAIMS.CLAIM_TYPE <> "DES" AND CLAIMS.CLAIM_TYPE <> "NULL" AND
				CLAIMS.CLAIM_TYPE <> "FRT") AND  
         	CLAIMS.CLAIM_AMOUNT_USD > 0 AND
				(VESSELS.PC_NR = 9 ) AND 						
				(VESSELS.CAL_VEST_TYPE_ID = 4) AND 				
				( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR )  
	 	USING SQLCA;
		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;		
		IF IsNull(ld_amount) THEN ld_amount = 0
		dwc.SetITem(1,"compute_0001", ld_amount)
		
	ELSEIF  ii_gas_group = 2 THEN
		 //FORWARDED, MISCELLANEOUS, NOT J TYPES
		 SELECT sum(CLAIMS.CLAIM_AMOUNT_USD)  
		 INTO :ld_amount
       FROM CLAIMS, VESSELS							
       WHERE
    	 ( CLAIMS.FORWARDING_DATE >= :id_startdate ) AND  
       ( CLAIMS.FORWARDING_DATE <= :id_enddate ) AND  
     	 ( CLAIMS.CLAIM_TYPE <> 'DEM' AND  
        	CLAIMS.CLAIM_TYPE <> 'DES' AND CLAIMS.CLAIM_TYPE <> 'NULL' AND
			  CLAIMS.CLAIM_TYPE <> 'FRT') AND  
     		CLAIMS.CLAIM_AMOUNT_USD > 0 AND
		 (VESSELS.PC_NR = 9 ) AND 						
				(VESSELS.CAL_VEST_TYPE_ID = 4) AND 				
		 ( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR ) 
		USING SQLCA;
		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;				
		IF IsNull(ld_amount) THEN ld_amount = 0
		 dwc.SetITem(1,"compute_0001", ld_amount)
	END IF
END IF

ld_amount = 0
dw_summary.GetChild("received",dwc)
dwc.SetTransObject(SQLCA)
dwc.Retrieve(id_startdate,id_enddate,ii_pc_nr[])

IF pb_summary_demurrage THEN
	IF ii_gas_group = 1 THEN
		   //RECIEVED, DEMMURRAGE, J TYPES
		   SELECT sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD)  
         INTO :ld_amount
     		FROM VESSELS,   
              CLAIM_TRANSACTION,   
        	 	  CLAIMS  
       	WHERE ( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
      			( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
     		 		( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
       		 ( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
      		 ( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR ) and  
       		 (( CLAIM_TRANSACTION.C_TRANS_VAL_DATE >= :id_startdate ) AND  
        	 		( CLAIM_TRANSACTION.C_TRANS_VAL_DATE <= :id_enddate ) AND  
         		(VESSELS.PC_NR = 9 ) AND
				(VESSELS.CAL_VEST_TYPE_ID = 4) AND 				
         		(CLAIMS.CLAIM_TYPE = 'DEM' OR  
         		CLAIMS.CLAIM_TYPE = 'DES' ) AND  
         		(CLAIM_TRANSACTION.C_TRANS_CODE = 'R' OR CLAIM_TRANSACTION.C_TRANS_CODE = 'C' ))
		USING SQLCA;
		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;		
		IF IsNull(ld_amount) THEN ld_amount = 0
	 	dwc.SetITem(1,"compute_0001", ld_amount)	
	
	ELSEIF ii_gas_group = 2 THEN
			//RECIEVED, DEMMURRAGE, NOT J TYPES
			SELECT sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD)  
	 		INTO :ld_amount
			FROM 	VESSELS,
     	   	 	CLAIM_TRANSACTION,   
     	   	 	CLAIMS  
 	  	 	WHERE ( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
     			  	( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
     		 	  	( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
      		  	( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
				  	( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR ) and  
       		  	(( CLAIM_TRANSACTION.C_TRANS_VAL_DATE >= :id_startdate ) AND  
       		  	( CLAIM_TRANSACTION.C_TRANS_VAL_DATE <= :id_enddate ) AND       
		 			(VESSELS.PC_NR = 9 ) AND
				(VESSELS.CAL_VEST_TYPE_ID <> 4) AND 				
      			(CLAIMS.CLAIM_TYPE = 'DEM' OR  
         		 CLAIMS.CLAIM_TYPE = 'DES' ) AND  
      			 (CLAIM_TRANSACTION.C_TRANS_CODE = 'R' OR CLAIM_TRANSACTION.C_TRANS_CODE = 'C' )) 
		USING SQLCA;
		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;
		IF IsNull(ld_amount) THEN ld_amount = 0
		dwc.SetITem(1,"compute_0001", ld_amount)
	END IF
	
ELSE
	IF ii_gas_group = 1THEN
		  //RECIEVED, MISCELLANEOUS, J TYPES
		  SELECT sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD)  
        INTO :ld_amount
     	  FROM VESSELS,   
         	 CLAIM_TRANSACTION,   
      	  	 CLAIMS  
       	  WHERE	( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
      		  	 	( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
     		 		 	( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
       		 		( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
      		 		( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR ) and  
       		 		( ( CLAIM_TRANSACTION.C_TRANS_VAL_DATE >= :id_startdate ) AND  
        	 			( CLAIM_TRANSACTION.C_TRANS_VAL_DATE <= :id_enddate ) AND  
         			(VESSELS.PC_NR = 9 ) AND
				(VESSELS.CAL_VEST_TYPE_ID = 4) AND 				
         			(CLAIMS.CLAIM_TYPE <> 'DEM' AND  
         			CLAIMS.CLAIM_TYPE <> 'DES' AND CLAIMS.CLAIM_TYPE <> 'NULL' 
						AND CLAIMS.CLAIM_TYPE <> 'FRT') AND 
         			(CLAIM_TRANSACTION.C_TRANS_CODE = 'R' OR CLAIM_TRANSACTION.C_TRANS_CODE = 'C') ) 
		USING SQLCA;	
		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;
		IF IsNull(ld_amount) THEN ld_amount = 0
	 	dwc.SetITem(1,"compute_0001", ld_amount)
		 
	ELSEIF ii_gas_group = 2 THEN
		//RECIEVED, MISCELLANEOUS, NOT J TYPES
			SELECT sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD)  
	 		INTO :ld_amount
			FROM 	VESSELS,
       	 	 	CLAIM_TRANSACTION,   
       	 	 	CLAIMS  
 		 	WHERE ( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
     		  		( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
      		   ( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
       		   ( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
		   		( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR ) and  
       		  	(( CLAIM_TRANSACTION.C_TRANS_VAL_DATE >= :id_startdate ) AND  
       		  	( CLAIM_TRANSACTION.C_TRANS_VAL_DATE <= :id_enddate ) AND       
					(VESSELS.PC_NR = 9 ) AND
				(VESSELS.CAL_VEST_TYPE_ID <> 4) AND 				
      			(CLAIMS.CLAIM_TYPE <> 'DEM' AND  
         		CLAIMS.CLAIM_TYPE <> 'DES' AND CLAIMS.CLAIM_TYPE <> 'NULL' AND
					CLAIMS.CLAIM_TYPE <> 'FRT') AND  
      		 	( CLAIM_TRANSACTION.C_TRANS_CODE = 'R' OR CLAIM_TRANSACTION.C_TRANS_CODE = 'C'))
		USING SQLCA;
		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;
		IF IsNull(ld_amount) THEN ld_amount = 0
		dwc.SetITem(1,"compute_0001", ld_amount)
	END IF	
END IF


ld_amount = 0
dw_summary.GetChild("adjusted",dwc)
dwc.SetTransObject(SQLCA)
dwc.Retrieve(id_startdate,id_enddate,ii_pc_nr[])


IF pb_summary_demurrage THEN
	IF ii_gas_group = 1THEN
		 	//ADJUSTED, DEMMURRAGE, J TYPES
			 SELECT sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD)  
      	 INTO :ld_amount
     		 FROM VESSELS,   
      		   CLAIM_TRANSACTION,   
      		   CLAIMS  
     	 	 WHERE( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
     			  	( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and
					( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR) AND	 
     	  	  		( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
      		   ( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR ) and  
     		    	( ( CLAIM_TRANSACTION.C_TRANS_VAL_DATE >= :id_startdate ) AND  
      		   ( CLAIM_TRANSACTION.C_TRANS_VAL_DATE <= :id_enddate ) AND  
    		    	( VESSELS.PC_NR = 9 ) AND
				(VESSELS.CAL_VEST_TYPE_ID = 4) AND 				
   				(CLAIMS.CLAIM_TYPE = 'DEM' OR  
         		CLAIMS.CLAIM_TYPE = 'DES') AND  
       		  	CLAIM_TRANSACTION.C_TRANS_CODE <> 'R' AND CLAIM_TRANSACTION.C_TRANS_CODE <> 'C')
		USING SQLCA;
		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;
		IF IsNull(ld_amount) THEN ld_amount = 0
		dwc.SetITem(1,"compute_0001", ld_amount)
		
	ELSEIF ii_gas_group = 2 THEN
		 //ADJUSTED, DEMMURRAGE, NOT J TYPES
		 SELECT sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD)  
		 INTO :ld_amount
		 FROM VESSELS,												
    	  	   CLAIM_TRANSACTION,   
      		CLAIMS  
 		  WHERE ( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
      		  ( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
      		  ( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
      		  ( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
     	  	  	  (( CLAIM_TRANSACTION.C_TRANS_VAL_DATE >= :id_startdate ) AND  
       		  ( CLAIM_TRANSACTION.C_TRANS_VAL_DATE <= :id_enddate ) AND  
     			  (CLAIMS.CLAIM_TYPE = 'DEM' OR  
         		CLAIMS.CLAIM_TYPE = 'DES' ) AND
					( VESSELS.PC_NR = 9 ) AND						
				(VESSELS.CAL_VEST_TYPE_ID <> 4) AND 				
     	 	   	CLAIM_TRANSACTION.C_TRANS_CODE <> 'R' AND CLAIM_TRANSACTION.C_TRANS_CODE <> 'C' ) 
		USING SQLCA;

		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;
		IF IsNull(ld_amount) THEN ld_amount = 0
		dwc.SetITem(1,"compute_0001", ld_amount)
	END IF
	
ELSE
	IF ii_gas_group = 1 THEN
		 //ADJUSTED, MISCELLANEOUS, J TYPES
		 SELECT sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD)  
       INTO :ld_amount
     	 FROM VESSELS,   
      	   CLAIM_TRANSACTION,   
      	   CLAIMS  
     	   WHERE ( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
     	  		  	( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and 
					( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR) AND		
     	  		  	( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
      		   ( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR ) and  
     		    ( ( CLAIM_TRANSACTION.C_TRANS_VAL_DATE >= :id_startdate ) AND  
      		   ( CLAIM_TRANSACTION.C_TRANS_VAL_DATE <= :id_enddate ) AND  
    		    	( VESSELS.PC_NR = 9 ) AND
				(VESSELS.CAL_VEST_TYPE_ID = 4) AND 				
   				(CLAIMS.CLAIM_TYPE <> "DEM" AND  
         		CLAIMS.CLAIM_TYPE <> "DES" AND CLAIMS.CLAIM_TYPE <> "NULL" AND 
					CLAIMS.CLAIM_TYPE <> "FRT" ) AND  
       		  	CLAIM_TRANSACTION.C_TRANS_CODE <> 'R' AND CLAIM_TRANSACTION.C_TRANS_CODE <> 'C' )
		USING SQLCA;
		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;
		IF IsNull(ld_amount) THEN ld_amount = 0
		dwc.SetITem(1,"compute_0001", ld_amount)
		
	ELSEIF ii_gas_group = 2 THEN
		 //ADJUSTED, MISCELLANEOUS, NOT J TYPES
		 SELECT sum(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD)  
		 INTO :ld_amount
		 FROM VESSELS,							
    	  	   CLAIM_TRANSACTION,   
      		CLAIMS  
 		  WHERE 	( CLAIMS.CHART_NR = CLAIM_TRANSACTION.CHART_NR ) and  
      		   ( CLAIMS.VESSEL_NR = CLAIM_TRANSACTION.VESSEL_NR ) and  
      		   ( CLAIMS.VOYAGE_NR = CLAIM_TRANSACTION.VOYAGE_NR ) and  
      		   ( CLAIMS.CLAIM_NR = CLAIM_TRANSACTION.CLAIM_NR ) and  
     	  	  		(( CLAIM_TRANSACTION.C_TRANS_VAL_DATE >= :id_startdate ) AND  
       		  	( CLAIM_TRANSACTION.C_TRANS_VAL_DATE <= :id_enddate ) AND  
					( VESSELS.PC_NR = 9 ) AND					
				(VESSELS.CAL_VEST_TYPE_ID = 4) AND 				
			  		(CLAIMS.CLAIM_TYPE <> 'DEM' AND  
         		CLAIMS.CLAIM_TYPE <> 'DES' AND CLAIMS.CLAIM_TYPE <> 'NULL' AND
					CLAIMS.CLAIM_TYPE <> 'FRT') AND  
     	 	   	CLAIM_TRANSACTION.C_TRANS_CODE <> 'R' AND CLAIM_TRANSACTION.C_TRANS_CODE <> 'C' ) 
		USING SQLCA;
		IF SQLCA.SQLCode <> 0 THEN Messagebox("Error",SQLCA.SQLErrText)
		COMMIT USING SQLCA;
		IF IsNull(ld_amount) THEN ld_amount = 0
		dwc.SetITem(1,"compute_0001", ld_amount)
		
	END IF
END IF    
dw_summary.Modify("start_end_date.text='"+string(id_startdate,"dd/mm-yy")+" - "+string(id_enddate,"dd/mm-yy")+"'")
dw_summary.Modify("enddate.text='"+ string(id_enddate,"dd/mm-yy")+"'")
IF rb_1.checked THEN
	dw_summary.Modify("profitcenter.text=' GAS J-TYPE SHIPS ' ")
ELSEIF  rb_2.checked THEN
	dw_summary.Modify("profitcenter.text=' GAS NOT J-TYPE SHIPS' ")
ELSE
	dw_summary.Modify("profitcenter.text='"+ is_pc_name+"'")
END IF
if pb_summary_demurrage then
	dw_summary.Modify("amount.text='"+string(id_DEM_sum,"#,##0.00")+"'")
else
	dw_summary.Modify("amount.text='"+string(id_MISC_sum,"#,##0.00")+"'")
end if


/* Alt OK, datavinduerne fyldt op */
return(0)
end function

public function integer wf_stats (ref datawindow dw_name, string dem_misc);/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_monthly_report
  
 Function  : wf_stats
  
 Event	 : 

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft, Martin Israelsen m.fl.
   
 Date       : 1/1-96

 Description : Script for statisticsgeneration

 Arguments : none

 Returns   : 1 = OK, Datawindow ready to print
        		-1 = Not OK, Error has occured


 Variables : None

 Other : 

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  1/1-96		1			PBT	
  16/4-96	         2.19                MI            Changed outstanding days and not settled to be average.
  12/12-96	3.0			rm		added COMMIT's
  
*************************************************************************************************************************************************/

// Local Variables //
///////////////////
Integer li_charterer_nr, li_vessel_nr, li_claim_nr
Long ll_number_of_rows, ll_loop_counter, ll_limit_desp
String ls_sql_insertion, ls_sql_string, ls_voyage_nr
Decimal {2} ld_received_amount, ld_reduced_amount, ld_original_claim
DateTime ldt_forwarding_date, ldt_max_val_date

//IF cbx_no_desp.checked AND dem_misc = "DEM" THEN
//	ll_limit_desp = 0
//ELSE
	// If no despatch then the rows with calim amount < 0 are not included in dw_name, 
	// and therefore the loop does not sum on transactions other than what should be
	// included. Leith 14/7-98
	ll_limit_desp = -2000000000
//END IF


//////////////////////////////////////////////////////////////////////////////
// Find out if the 2nd parm makes this a demurrage or miscellaneous stats report //
//////////////////////////////////////////////////////////////////////////////
CHOOSE CASE Upper(dem_misc)
	CASE "DEM"
		ls_sql_insertion = 'in'
	CASE "MISC"
		ls_sql_insertion = 'not in ("FRT") and CLAIMS.CLAIM_TYPE not in'
	CASE ELSE
		Return -1
END CHOOSE

//////////////////////////////////////////////
// Set the datawindows SQL to DEM or MISC //
//////////////////////////////////////////////
ls_sql_string = '  SELECT CHART.CHART_N_1, CLAIMS.CHART_NR, CLAIMS.CLAIM_AMOUNT_USD, ' + &
			'CLAIMS.VESSEL_NR, CLAIMS.VOYAGE_NR, CLAIMS.CLAIM_NR ,0,0,0,0 ' + &
			'FROM CLAIMS, CHART, VESSELS ' + &
		        'WHERE ( CHART.CHART_NR = CLAIMS.CHART_NR ) and ' + &
			'( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR ) and ( ( VESSELS.PC_NR in ( :pc_numbers ) ) AND ' + &
			'( CLAIMS.FORWARDING_DATE <= :end_date ) ' + &
			'AND ( CLAIMS.CLAIM_TYPE ' + ls_sql_insertion + ' ("DEM","DES") ) ) ' + &
		        'ORDER BY CHART.CHART_N_1 ASC '
dw_name.Modify("DataWindow.Table.Select='"+ls_sql_string+"'")

///////////////////////////////////////
// Retrive Datawindow and set header //
///////////////////////////////////////
IF cbx_no_desp.checked THEN
	dw_name.SetFilter("claims_claim_amount_usd >= 0")
	dw_name.Filter()
ELSE 
	dw_name.SetFilter("")
	dw_name.Filter()
END IF
dw_name.Retrieve(ii_pc_nr[],id_startdate,id_enddate)
COMMIT USING SQLCA;
dw_name.Modify("overskrift2.Text='"+is_pc_name+"'")
CHOOSE CASE Upper(dem_misc)
	CASE "DEM"
	dw_name.Modify("overskrift1.text='DEMURRAGE pr. "+string(id_enddate,"dd/mm-yy")+"'")
	CASE "MISC"
	dw_name.Modify("overskrift1.text='MISCELLANEOUS pr. "+string(id_enddate,"dd/mm-yy")+"'")
END CHOOSE


//////////////////////////////////////
// Return 1 if no row in datawindow() //
//////////////////////////////////////
ll_number_of_rows = dw_name.RowCount()
IF ll_number_of_rows < 1 THEN Return 1

///////////////////////////////////////////////
// Calculate the other fields on the datawindow //
///////////////////////////////////////////////
FOR ll_loop_counter=1 TO ll_number_of_rows
	ld_received_amount = 0
	li_charterer_nr = dw_name.GetItemNumber(ll_loop_counter,"claims_chart_nr")
	li_vessel_nr = dw_name.GetItemNumber(ll_loop_counter,"claims_vessel_nr")
	ls_voyage_nr = dw_name.GetItemString(ll_loop_counter,"claims_voyage_nr")
	li_claim_nr = dw_name.GetItemNumber(ll_loop_counter,"claims_claim_nr")
	ld_original_claim = dw_name.GetItemNumber(ll_loop_counter,"claims_claim_amount_usd")
	//////////////////////////////////////////////////////////////////////////////
	// Get Received amount from claim transaction table and set field in datawindow //
	//////////////////////////////////////////////////////////////////////////////
	SELECT sum(C_TRANS_AMOUNT_USD)
	INTO :ld_received_amount
	FROM CLAIM_TRANSACTION
	WHERE 	CHART_NR = :li_charterer_nr AND
			VESSEL_NR = :li_vessel_nr AND
			VOYAGE_NR = :ls_voyage_nr AND
			CLAIM_NR = :li_claim_nr AND
			C_TRANS_VAL_DATE <= :id_enddate AND
			(C_TRANS_CODE = "R" or C_TRANS_CODE = "C") AND
			C_TRANS_AMOUNT_USD >= :ll_limit_desp ;
	Commit;
	IF IsNull(ld_received_amount) THEN ld_received_amount = 0
	dw_name.SetItem(ll_loop_counter,"receive_amount",ld_received_amount)

	//////////////////////////////////////////////////////////////////////////////
	// Get Reduced amount from claim transaction table and set field in datawindow //
	//////////////////////////////////////////////////////////////////////////////
	SELECT sum(C_TRANS_AMOUNT_USD)
	INTO :ld_reduced_amount
	FROM CLAIM_TRANSACTION
	WHERE 	CHART_NR = :li_charterer_nr AND
			VESSEL_NR = :li_vessel_nr AND
			VOYAGE_NR = :ls_voyage_nr AND
			CLAIM_NR = :li_claim_nr AND
			C_TRANS_VAL_DATE <= :id_enddate AND
			C_TRANS_CODE <> "R" AND C_TRANS_CODE <> "C" ;
	Commit;
	IF IsNull(ld_reduced_amount) THEN ld_reduced_amount = 0
	dw_name.SetItem(ll_loop_counter,"reduce_amount",ld_reduced_amount)

	//////////////////////////////////////////////
	// Get Forwarding date and maximum val date //
	//////////////////////////////////////////////
	SELECT FORWARDING_DATE
	INTO :ldt_forwarding_date
	FROM CLAIMS
	WHERE	CHART_NR = :li_charterer_nr AND
			VESSEL_NR = :li_vessel_nr AND
			VOYAGE_NR = :ls_voyage_nr AND
			CLAIM_NR = :li_claim_nr AND 
			CLAIMS.CLAIM_AMOUNT_USD >= :ll_limit_desp ;

	SELECT max(C_TRANS_VAL_DATE)
	INTO :ldt_max_val_date
	FROM CLAIM_TRANSACTION
	WHERE	CHART_NR = :li_charterer_nr AND
			VESSEL_NR = :li_vessel_nr AND
			VOYAGE_NR = :ls_voyage_nr AND
			CLAIM_NR = :li_claim_nr AND
			C_TRANS_AMOUNT_USD >= :ll_limit_desp ;
	Commit;

	/////////////////////////////////////////
	// Set Outstanding Days in Datawindow //
	/////////////////////////////////////////
	IF (ld_original_claim - ld_reduced_amount - ld_received_amount) = 0 THEN
		dw_name.SetItem(ll_loop_counter,"out_days",DaysAfter(Date(ldt_forwarding_date),Date(ldt_max_val_date)))
	END IF

	////////////////////////////////////////////////
	// Set Outstanding (Not Settled) in Datawindow //
	////////////////////////////////////////////////
	IF (ld_original_claim - ld_reduced_amount - ld_received_amount) > 0 THEN
		dw_name.SetItem(ll_loop_counter,"not_set_days",DaysAfter(Date(ldt_forwarding_date),Date(id_enddate)))
	END IF
NEXT

return 1
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29/08/14		CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

event open;////////////////////////////
// Place Window Correctly //
////////////////////////////
Move(200,200)

/////////////////////////
// Set dates for Reports //
/////////////////////////
dw_startdate.InsertRow(0)
dw_enddate.InsertRow(0)
dw_startdate.SetItem(1,1,relativedate(today(),-30))
dw_enddate.SetItem(1,1,today())
//set default values for watch list filter
//em_1.text = '0'
//em_2.text = '0'
//////////////////////
// Set Trans Objects //
//////////////////////
dw_dem_by_vessel_charterer.SetTRansObject(SQLCA)
dw_misc_by_vessel_charterer.SetTRansObject(SQLCA)
dw_stats.SetTransObject(SQLCA)

/* Fill listbox with profitcenter_no and name */
int profitcenter_no
string profitcenter_name

if uo_global.ii_access_level = -2 then
	//External Partners only access to profitcenter 4 - Product
	lb_profitcenter.AddItem(string(4,"00")+"  Product")
else
	DECLARE profit_cur CURSOR FOR  
	  SELECT PROFIT_C.PC_NR,   
				PROFIT_C.PC_NAME  
		 FROM PROFIT_C, USERS_PROFITCENTER 
		 WHERE PROFIT_C.PC_NR = USERS_PROFITCENTER.PC_NR
		 AND USERS_PROFITCENTER.USERID = :uo_global.is_userid
		 ORDER BY PC_NR ASC ;
	
	OPEN profit_cur;
	FETCH profit_cur INTO :profitcenter_no, :profitcenter_name;
	
	DO WHILE SQLCA.SQLCode = 0 
		lb_profitcenter.AddItem(string(profitcenter_no,"00")+"  "+profitcenter_name)
		FETCH profit_cur INTO :profitcenter_no, :profitcenter_name;	
	LOOP
	
	CLOSE profit_cur;
end if

end event

event closequery;IF cb_close.Enabled = FALSE THEN
	MessageBox("Info","You can't close this window while print function is active")
	Message.ReturnValue = 1
END IF


end event

on w_monthly_reports.create
this.rb_5=create rb_5
this.rb_4=create rb_4
this.rb_print=create rb_print
this.rb_excel=create rb_excel
this.dw_enddate=create dw_enddate
this.dw_startdate=create dw_startdate
this.em_2=create em_2
this.em_1=create em_1
this.st_5=create st_5
this.st_4=create st_4
this.cbx_7=create cbx_7
this.st_3=create st_3
this.dw_stats=create dw_stats
this.cb_report=create cb_report
this.cbx_no_desp=create cbx_no_desp
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_misc_by_vessel_charterer=create dw_misc_by_vessel_charterer
this.dw_dem_by_vessel_charterer=create dw_dem_by_vessel_charterer
this.dw_misc_summary=create dw_misc_summary
this.cbx_6=create cbx_6
this.cbx_5=create cbx_5
this.cbx_4=create cbx_4
this.cbx_3=create cbx_3
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.lb_profitcenter=create lb_profitcenter
this.cb_close=create cb_close
this.st_2=create st_2
this.st_1=create st_1
this.dw_demurrage_summary=create dw_demurrage_summary
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_6=create gb_6
this.Control[]={this.rb_5,&
this.rb_4,&
this.rb_print,&
this.rb_excel,&
this.dw_enddate,&
this.dw_startdate,&
this.em_2,&
this.em_1,&
this.st_5,&
this.st_4,&
this.cbx_7,&
this.st_3,&
this.dw_stats,&
this.cb_report,&
this.cbx_no_desp,&
this.rb_3,&
this.rb_2,&
this.rb_1,&
this.dw_misc_by_vessel_charterer,&
this.dw_dem_by_vessel_charterer,&
this.dw_misc_summary,&
this.cbx_6,&
this.cbx_5,&
this.cbx_4,&
this.cbx_3,&
this.cbx_2,&
this.cbx_1,&
this.lb_profitcenter,&
this.cb_close,&
this.st_2,&
this.st_1,&
this.dw_demurrage_summary,&
this.gb_5,&
this.gb_4,&
this.gb_1,&
this.gb_3,&
this.gb_2,&
this.gb_6}
end on

on w_monthly_reports.destroy
destroy(this.rb_5)
destroy(this.rb_4)
destroy(this.rb_print)
destroy(this.rb_excel)
destroy(this.dw_enddate)
destroy(this.dw_startdate)
destroy(this.em_2)
destroy(this.em_1)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.cbx_7)
destroy(this.st_3)
destroy(this.dw_stats)
destroy(this.cb_report)
destroy(this.cbx_no_desp)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_misc_by_vessel_charterer)
destroy(this.dw_dem_by_vessel_charterer)
destroy(this.dw_misc_summary)
destroy(this.cbx_6)
destroy(this.cbx_5)
destroy(this.cbx_4)
destroy(this.cbx_3)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.lb_profitcenter)
destroy(this.cb_close)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_demurrage_summary)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_6)
end on

type rb_5 from radiobutton within w_monthly_reports
integer x = 187
integer y = 1152
integer width = 727
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "With Transactions/Actions"
end type

type rb_4 from radiobutton within w_monthly_reports
integer x = 187
integer y = 1088
integer width = 786
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "Without Transactions/Actions"
boolean checked = true
end type

type rb_print from radiobutton within w_monthly_reports
integer x = 507
integer y = 440
integer width = 325
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Print"
boolean checked = true
end type

type rb_excel from radiobutton within w_monthly_reports
integer x = 507
integer y = 528
integer width = 549
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Excel file (only 3 && 4)"
end type

type dw_enddate from datawindow within w_monthly_reports
integer x = 517
integer y = 200
integer width = 297
integer height = 84
integer taborder = 152
string dataobject = "d_date"
boolean livescroll = true
end type

type dw_startdate from datawindow within w_monthly_reports
integer x = 517
integer y = 100
integer width = 297
integer height = 84
integer taborder = 160
string dataobject = "d_date"
boolean livescroll = true
end type

type em_2 from editmask within w_monthly_reports
integer x = 1353
integer y = 1328
integer width = 247
integer height = 80
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "#####"
string displaydata = "Ä"
end type

type em_1 from editmask within w_monthly_reports
integer x = 512
integer y = 1328
integer width = 320
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "###########"
string displaydata = " "
end type

type st_5 from statictext within w_monthly_reports
integer x = 914
integer y = 1332
integer width = 434
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
boolean enabled = false
string text = "Days Outstanding:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_monthly_reports
integer x = 73
integer y = 1332
integer width = 434
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
boolean enabled = false
string text = "Exceeding Amount:"
boolean focusrectangle = false
end type

type cbx_7 from checkbox within w_monthly_reports
integer x = 987
integer y = 960
integer width = 713
integer height = 72
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "&7 Demurrage Watch List"
end type

type st_3 from statictext within w_monthly_reports
boolean visible = false
integer x = 658
integer y = 296
integer width = 1093
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 81324524
boolean enabled = false
string text = "DataWindows to the right ->"
boolean focusrectangle = false
end type

type dw_stats from uo_datawindow within w_monthly_reports
boolean visible = false
integer x = 2167
integer y = 468
integer width = 242
integer height = 164
integer taborder = 170
string dataobject = "dw_stats"
end type

type cb_report from commandbutton within w_monthly_reports
integer x = 37
integer y = 400
integer width = 439
integer height = 96
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Create &reports"
boolean default = true
end type

event clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_monthly_report
  
 Object     : cb_report 
  
 Event	 : Clicked

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Martin Israelsen m.fl.
   
 Date       : 1/1-96

 Description : Script for reportgeneration

 Arguments : none

 Returns   : None

 Variables : None

 Other : Be carefull when editing the dw_dem_by_vessel_charter report/code. Due to our group-by sybase problem, some
 of the reportwork is done in the script, eg. setting filter for values > 0, sorts etc. etc.

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  27/2-96          2.11                 MI            Fixed problem when printing more than 1 dem_by_vessel_charter report
  12/12-96	3.0			RM		added COMMIT's  
	22/06-98					KFN	added Watch List
*************************************************************************************************************************************************/


////////////////////
// Local Variables //
////////////////////
cb_close.Enabled = FALSE
cb_report.Enabled = FALSE

int total_profitcentre=0, ll_nr_rows, xx, yy, li_count, li_progress_stages = 13
boolean frst = TRUE
String ls_andor // Is used when building the filter string, can contain AND or OR
String ls_where // Is used when building the filter string, can contain = or <>
dec ld_tot_sum
String ls_filters, ls_voyage, ls_filter, ls_filter_sum
Decimal {2} ld_min_amount, ld_claim, ld_trans
Decimal {2} ld_sum_before_filter, ld_sum_after_filter, ld_outstanding
Long ll_min_days,ll_vessel,ll_chart,ll_claimnr,ll_upper,ll_counter
Date ld_forw, ld_end
Datetime ldt_forw
Datastore ds_Vessel_store, ds_watch_list_store

// Select whether old or new misc. report should be printed
if (rb_4.checked) then
	dw_misc_by_vessel_charterer.dataobject = "dw_misc_by_vessel_charterer"
	dw_misc_by_vessel_charterer.settransobject(SQLCA)
elseif (rb_5.checked) then
	dw_misc_by_vessel_charterer.dataobject = "dw_misc_by_vessel_charterer_ta"
	dw_misc_by_vessel_charterer.settransobject(SQLCA)
end if


// Create vessel Datastore and assign Dataobject
ds_vessel_store = CREATE datastore
ds_vessel_store.dataobject ="d_gas_vessels" // Contains Vessel Table
ds_vessel_store.SetTransObject(SQLCA)
// Create Demurrage atch list data store and assign object
ds_watch_list_store = CREATE datastore
ds_watch_list_store.dataobject ="dw_dem_watch_list" // Contains watch list
ds_watch_list_store.SetTransObject(SQLCA)

ii_gas_group = 0
// Select search criterias
IF w_monthly_reports.rb_1.checked THEN			//If Vessel Type is J 
	ls_andor = " OR "
	ls_where = "="
	ii_gas_group = 1
Elseif w_monthly_reports.rb_2.checked Then	//If Vessel Type is NOT J 
	ls_andor = " AND "
	ls_where = "<>"
	ii_gas_group = 2
Else														//All Vessel Types 
	ls_filter = "claims_vessel_nr > 0"			
End if	
		
If (not w_monthly_reports.rb_3.checked) AND (ii_gas_group = 1 OR ii_gas_group = 2) Then	//If NOT all Vessel Types 
	ds_vessel_store.retrieve()						//Retrieve from Datastore
	ll_nr_rows = ds_vessel_store.rowcount()	//Count rows in Datastore
	FOR li_Count = 1 to (ll_nr_rows)				//For all rows in Datastore Ds_vessel_store do
		// If string is not empty, then add OR or AND 
		If ls_filter <> "" Then ls_filter += ls_andor
		// Add search string ( = or <>) to our filter 
		ls_filter += " claims_vessel_nr " + ls_where +" " + &
			string(ds_vessel_store.GetItemNumber(li_count, "vessel_nr")) 
	NEXT
	DESTROY ds_vessel_store							// Destroys the Datastore
End if
	
///////////////////////
// Set Local Variables //
///////////////////////
parm.title = "Generating Monthly Reports"
parm.cancel_window = w_monthly_reports
parm.cancel_event = "none"
is_pc_name = ""
is_pc_nrs = ""

/////////////////////////////////////////////////////////
// Find out which Profit centers are clicked and set Profit //
// center array and text string //
/////////////////////////////////////////////////////////
total_profitcentre = lb_profitcenter.TotalItems()
FOR xx=1 TO total_profitcentre
	ii_pc_nr[xx] = 0
	IF lb_profitcenter.State(xx) = 1 THEN
		IF frst THEN
			is_pc_nrs = "(" + left(lb_profitcenter.Text(xx),2)
			is_pc_name = right(lb_profitcenter.Text(xx),len(lb_profitcenter.Text(xx))-3)
			frst = FALSE
		ELSE 
			is_pc_nrs = is_pc_nrs + "," + left(lb_profitcenter.Text(xx),2)
			is_pc_name = is_pc_name +  ", " + right(lb_profitcenter.Text(xx),len(lb_profitcenter.Text(xx))-3)
		END IF
			ii_pc_nr[xx] = integer(mid(lb_profitcenter.Text(xx),1,2))
	END IF
NEXT
is_pc_nrs = is_pc_nrs + ")"

/////////////////////////////////
// Check if profitcenter selected //
/////////////////////////////////
IF frst THEN
	MessageBox("Error","Please Select Profitcenter......")
	cb_close.Enabled = TRUE
	cb_report.Enabled = TRUE
	Return
END IF

/////////////////////
// Get Dates to use //
/////////////////////

id_startdate = datetime(dw_startdate.GetItemDate(1,1))
id_enddate = datetime(dw_enddate.GetItemDate(1,1),time("23:59.59"))

IF Not cbx_1.Checked AND Not cbx_2.Checked &
	AND Not cbx_3.Checked AND Not cbx_4.Checked &
	AND Not cbx_5.Checked AND Not cbx_6.Checked AND Not cbx_7.Checked THEN
	MessageBox("Error","Please Select Report Type......")
	cb_close.Enabled = TRUE
	cb_report.Enabled = TRUE
	Return
END IF

///////////////////////////////////////////////////
// Recalculate DEM, DES, FRT CLAIMS
/////////////////////////////////////////////////////
//int li_returncode
//li_returncode = f_recalc_dem_des_frt_claims()
//IF li_returncode = -1 THEN
//	MessageBox("ERROR","Der er opstået en fejl ved recalculering af DEM, DES, FRT Claims")
//END IF



///////////////////////////
// Open Progress window //
///////////////////////////
OpenWithParm(w_progress_no_cancel, parm)

// Starting w/ DEM and MISC reports due to Powerbuilder sum problems.

//////////////////////////////////////////////////////////////
// Create and Print Demurrage By Vessel/Charterer                   //
//////////////////////////////////////////////////////////////

Long ll_Count

if cbx_3.checked then
	 w_progress_no_cancel.wf_progress(1/li_progress_stages,"Generating Demurrage By Vessel/Charterer Report.~r~nSorted by Vessel!")
	cbx_3.TextColor = RGB(255,0,0)
end if

if cbx_3.checked or cbx_1.checked then	
	dw_dem_by_vessel_charterer.SetFilter(ls_filter)
//	dw_dem_by_vessel_charterer.SetFilter("")
	dw_dem_by_vessel_charterer.Filter()	
	dw_dem_by_vessel_charterer.SetSort("vessels_vessel_ref_nr, claims_voyage_nr, claims_chart_nr, claims_claim_nr")
	dw_dem_by_vessel_charterer.Retrieve(ii_pc_nr[],date(id_enddate))
	COMMIT USING SQLCA;
	ls_filter_sum = "(Round(total_sum,2) <> 0) AND (" + ls_filter + ")"
	dw_dem_by_vessel_charterer.SetFilter(ls_filter_sum)
//	dw_dem_by_vessel_charterer.SetFilter("Round(Total_sum,2) > 0")
	dw_dem_by_vessel_charterer.Filter()
end if

// Calculate DEM sum.
if cbx_1.checked then

	id_DEM_sum = 0
	ll_count = dw_dem_by_vessel_charterer.FindGroupChange(0,1)
	DO WHILE ll_count > 0
		id_DEM_sum += dw_dem_by_vessel_charterer.GetItemNumber(ll_count,"total_sum")
		ll_count = dw_dem_by_vessel_charterer.FindGroupChange(ll_count+1,1)
	LOOP
end if

if cbx_3.checked then
	IF rb_1.checked THEN
		dw_dem_by_vessel_charterer.Modify("overskrift2.Text=' GAS J-TYPE SHIPS '")
	ELSEIF rb_2.checked THEN
		dw_dem_by_vessel_charterer.Modify("overskrift2.Text='GAS NOT J-TYPE SHIPS '")
	ELSE
		dw_dem_by_vessel_charterer.Modify("overskrift2.Text='"+is_pc_name+"'")
	END IF
	dw_dem_by_vessel_charterer.Modify("overskrift1.text='DEMURRAGE pr. "+string(id_enddate,"dd/mm-yy")+"'")
	dw_dem_by_vessel_charterer.Modify("Datawindow.Print.Orientation = 1")
	dw_dem_by_vessel_charterer.SetSort("vessels_vessel_name, claims_voyage_nr, claims_chart_nr, claims_claim_nr")
	dw_dem_by_vessel_charterer.Sort()
	dw_dem_by_vessel_charterer.Modify("vessels_vessel_name.Font.Weight='700'")
	dw_dem_by_vessel_charterer.GroupCalc()
	IF rb_print.checked then
		dw_dem_by_vessel_charterer.Print(FALSE)
	else
		dw_dem_by_vessel_charterer.SaveAs()
	END IF
	dw_dem_by_vessel_charterer.SetSort("chart_chart_n_1, claims_voyage_nr, claims_chart_nr, claims_claim_nr")
	dw_dem_by_vessel_charterer.Sort()

	dw_dem_by_vessel_charterer.Modify("vessels_vessel_name.Font.Weight='400'")
	dw_dem_by_vessel_charterer.Modify("chart_chart_n_1.Font.Weight='700'")
	w_progress_no_cancel.wf_progress(2/li_progress_stages,"Generating Demurrage By Vessel/Charterer Report.~r~nSorted by Charterer!")
	dw_dem_by_vessel_charterer.GroupCalc()
	IF rb_print.checked then
		dw_dem_by_vessel_charterer.Print(FALSE)
	else
		/* Only save file once */
//		dw_dem_by_vessel_charterer.SaveAs()
	END IF
	dw_dem_by_vessel_charterer.SetSort("brokers_broker_name, claims_voyage_nr, claims_chart_nr, claims_claim_nr")
	dw_dem_by_vessel_charterer.Sort()

	dw_dem_by_vessel_charterer.Modify("chart_chart_n_1.Font.Weight='400'")
	dw_dem_by_vessel_charterer.Modify("brokers_broker_name.Font.Weight='700'")
	w_progress_no_cancel.wf_progress(3/li_progress_stages,"Generating Demurrage By Vessel/Charterer Report.~r~nSorted by Broker!")
	dw_dem_by_vessel_charterer.GroupCalc()
	IF rb_print.checked then
		dw_dem_by_vessel_charterer.Print(FALSE)
	else
		/* Only save file once */
//		dw_dem_by_vessel_charterer.SaveAs()
	END IF
	dw_dem_by_vessel_charterer.Modify("brokers_broker_name.Font.Weight='400'")

	cbx_3.TextColor = RGB(0,0,0)
END IF

//////////////////////////////////////////////////////////////
// Create and Print Miscellaneous by Vessel/Charterer                //
//////////////////////////////////////////////////////////////
IF cbx_4.Checked THEN
	w_progress_no_cancel.wf_progress(4/li_progress_stages,"Generating Miscellaneous By Vessel/Charterer Report.~r~nSorted by Vessel!")
	cbx_4.TextColor = RGB(255,0,0)
End if

if cbx_4.checked or cbx_2.checked then
	dw_misc_by_vessel_charterer.SetFilter(ls_filter)
//	dw_misc_by_vessel_charterer.SetFilter("")
	dw_misc_by_vessel_charterer.Filter()
	dw_misc_by_vessel_charterer.Retrieve(ii_pc_nr[],date(id_enddate))
	COMMIT USING SQLCA;
	ls_filter_sum = "(Round(total_sum,2) <> 0 ) AND (" + ls_filter + ")"
	dw_misc_by_vessel_charterer.SetFilter(ls_filter_sum)
//	dw_misc_by_vessel_charterer.SetFilter("Round(total_sum,2) > 0.0")
	dw_misc_by_vessel_charterer.Filter()
end if

// Calculate MISC sum
if cbx_2.checked then

	id_MISC_sum = 0
	ll_count = dw_misc_by_vessel_charterer.FindGroupChange(0,1)
	DO WHILE ll_count > 0
		id_MISC_sum += dw_misc_by_vessel_charterer.GetItemNumber(ll_count,"total_sum")
		ll_count = dw_misc_by_vessel_charterer.FindGroupChange(ll_count+1,1)
	LOOP
end if

if cbx_4.checked then 
	IF rb_1.checked THEN
		dw_misc_by_vessel_charterer.Modify("overskrift2.Text=' GAS J-TYPE SHIPS '")
	ELSEIF rb_2.checked THEN
		dw_misc_by_vessel_charterer.Modify("overskrift2.Text=' GAS NOT J-TYPE SHIPS '")
	ELSE
		dw_misc_by_vessel_charterer.Modify("overskrift2.Text='"+is_pc_name+"'")
	END IF
	dw_misc_by_vessel_charterer.Modify("overskrift1.text='MISCELLANEOUS pr. "+string(id_enddate,"dd/mm-yy")+"'")
	dw_misc_by_vessel_charterer.Modify("Datawindow.Print.Orientation = 1")
	
	dw_misc_by_vessel_charterer.SetSort("vessels_vessel_name, claims_voyage_nr, claims_chart_nr, claims_claim_nr")
	dw_misc_by_vessel_charterer.Sort()
	dw_misc_by_vessel_charterer.Modify("vessels_vessel_name.Font.Weight='700'")
	dw_misc_by_vessel_charterer.GroupCalc()
	
	IF rb_print.checked then
		dw_misc_by_vessel_charterer.Print(FALSE)
	else
		dw_misc_by_vessel_charterer.SaveAs()
	END IF
	dw_misc_by_vessel_charterer.SetSort("chart_chart_n_1, claims_voyage_nr, claims_chart_nr, claims_claim_nr")
	dw_misc_by_vessel_charterer.Sort()
	dw_misc_by_vessel_charterer.Modify("vessels_vessel_name.Font.Weight='400'")
	dw_misc_by_vessel_charterer.Modify("chart_chart_n_1.Font.Weight='700'")
	w_progress_no_cancel.wf_progress(5/li_progress_stages,"Generating Miscellaneous By Vessel/Charterer Report.~r~nSorted by Charterer!")
	dw_misc_by_vessel_charterer.GroupCalc()
	IF rb_print.checked then
		dw_misc_by_vessel_charterer.Print(FALSE)
	else
		/* Only save file once */
//		dw_misc_by_vessel_charterer.SaveAs()
	END IF
	dw_misc_by_vessel_charterer.SetSort("brokers_broker_name, claims_voyage_nr, claims_chart_nr, claims_claim_nr")
	dw_misc_by_vessel_charterer.Sort()
	dw_misc_by_vessel_charterer.Modify("chart_chart_n_1.Font.Weight='400'")
	dw_misc_by_vessel_charterer.Modify("brokers_broker_name.Font.Weight='700'")
	w_progress_no_cancel.wf_progress(6/li_progress_stages,"Generating Miscellaneous By Vessel/Charterer Report.~r~nSorted by Broker!")
	dw_misc_by_vessel_charterer.GroupCalc()
	IF rb_print.checked then
		dw_misc_by_vessel_charterer.Print(FALSE)
	else
		/* Only save file once */
//		dw_misc_by_vessel_charterer.SaveAs()
	END IF
	cbx_4.TextColor = RGB(0,0,0)
END IF


///////////////////////////////////////////////////////////
// Create and Print Demurrage Summary Report if Checked //
///////////////////////////////////////////////////////////
w_progress_no_cancel.wf_progress(7/li_progress_stages,"Generating Demurrage Summary Report")
IF cbx_1.Checked THEN
	cbx_1.TextColor = RGB(255,0,0)
	wf_summary(true)
	dw_demurrage_summary.Print(FALSE)
	cbx_1.TextColor = RGB(0,0,0)
END IF

//////////////////////////////////////////////////////////////
// Create and Print Miscellaneous Summary Report if Checked  //
//////////////////////////////////////////////////////////////
w_progress_no_cancel.wf_progress(8/li_progress_stages,"Generating Miscellaneous Summary Report")
IF cbx_2.Checked THEN
	cbx_2.TextColor = RGB(255,0,0)
	wf_summary(false)
	dw_misc_summary.Print(FALSE)
	cbx_2.TextColor = RGB(0,0,0)
END IF


/////////////////////////////////////////
// Create and Print Demurrage Statistics  //
/////////////////////////////////////////
w_progress_no_cancel.wf_progress(9/li_progress_stages,"Generating Demurrage Statistics!")
IF cbx_5.Checked THEN
	cbx_5.TextColor = RGB(255,0,0)
	wf_stats(dw_stats,"dem")
	w_progress_no_cancel.wf_progress(10/li_progress_stages,"Generating Demurrage Statistics!")
	dw_stats.GroupCalc()
	dw_stats.Print(FALSE)
	cbx_5.TextColor = RGB(0,0,0)
END IF


////////////////////////////////////////////
// Create and Print Miscellaneous Statistics//
////////////////////////////////////////////
w_progress_no_cancel.wf_progress(11/li_progress_stages,"Generating Miscellaneous Statistics!")
IF cbx_6.Checked THEN
	cbx_6.TextColor = RGB(255,0,0)
	wf_stats(dw_stats,"misc")
	w_progress_no_cancel.wf_progress(12/li_progress_stages,"Generating Miscellaneous Statistics!")
	dw_stats.GroupCalc()
	dw_stats.Print(FALSE)
	cbx_6.TextColor = RGB(0,0,0)
END IF


/////////////////////////////////
//Generate Demurrage watch list//
/////////////////////////////////
if cbx_7.checked then
	 w_progress_no_cancel.wf_progress(1/li_progress_stages,"Generating Demurrage Watch List.~r~nSorted by Charterer!")
	cbx_7.TextColor = RGB(255,0,0)
end if

if cbx_7.checked then	
	ds_watch_list_store.SetFilter(ls_filter)
	ds_watch_list_store.Filter()	
	ds_watch_list_store.SetSort("vessels_vessel_ref_nr, claims_voyage_nr, claims_chart_nr, claims_claim_nr")
	ds_watch_list_store.Retrieve(ii_pc_nr[],date(id_enddate))
	COMMIT USING SQLCA;
	
	//Exclude amounts with value zerro and get demurrage amount total
	ls_filter_sum = "(Round(total_sum,2) > 0) AND (" + ls_filter + ")"
	ds_watch_list_store.SetFilter(ls_filter_sum)
	ds_watch_list_store.Filter()
	//ld_tot_sum = ds_watch_list_store.GetItemNumber(1,"dem_watch_sum")
	//Test Print before sort 
	//ds_watch_list_store.Print(FALSE)
	//set new filter (from user)
	//if NOT len(em_1.text) > 0 then em_1.text = '0'
	//if NOT len(em_2.text) > 0 then em_2.text = '0'
	
	// Create Filter Strings and text at report
	IF len(em_1.text) > 0 AND len(em_2.text) > 0 THEN
		//Exceeding Amount or Days
		ls_filter_sum = "((Round(total_sum,2) > "+ string(em_1.text) +") OR ((daysafter(claims_forwarding_date,enddate)) > "+ string(em_2.text) +")) AND (Round(total_sum,2) > 10000) AND (" + ls_filter + ")"
		ds_watch_list_store.Modify("overskrift3.text='Outstanding Demurrage exceeding USD "+ string(em_1.text) +", or "+ string(em_2.text) +" days outstanding (exceeding USD 10.000)'")
		ls_filters = "BOTH" //Used in "retrieve case"
	ELSEIF len(em_1.text) > 0 THEN
		//Exceeding Amount
		ls_filter_sum = "(Round(total_sum,2) > "+ string(em_1.text) +")  AND (Round(total_sum,2) > 10000) AND (" + ls_filter + ")"
		ds_watch_list_store.Modify("overskrift3.text='Outstanding Demurrage exceeding USD "+ string(em_1.text) +" (exceeding USD 10.000)'")
		ls_filters = "AMOUNT" //Used in "retrieve case"
	ELSEIF len(em_2.text) > 0 THEN
		//Exceeding Days
		ls_filter_sum = "((daysafter(claims_forwarding_date,enddate)) > "+ string(em_2.text) +") AND (Round(total_sum,2) > 10000) AND (" + ls_filter + ")"
		ds_watch_list_store.Modify("overskrift3.text='Outstanding Demurrage exceeding "+ string(em_2.text) +" days outstanding (exceeding USD 10.000)'")
		ls_filters = "DAYS" //Used in "retrieve case"
	ELSE
		//Just exceeding standard criterias (amount>10000)
		ls_filter_sum = "(Round(total_sum,2) > 10000) AND (" + ls_filter + ")"
		ds_watch_list_store.Modify("overskrift3.text='Outstanding Demurrage exceeding USD 10.000'")
		ls_filters = "NONE" //Used in "retrieve case"
	END IF
	//ls_filter_sum = "((Round(total_sum,2) > "+ string(em_1.text) +") OR ((daysafter(claims_forwarding_date,enddate)) > "+ string(em_2.text) +")) AND (Round(total_sum,2) > 10000) AND (" + ls_filter + ")"
	ds_watch_list_store.SetFilter(ls_filter_sum)
	ds_watch_list_store.Filter()
	//deliver demurrage amount total
	//ds_watch_list_store.modify ("dem_tot.expression = '"+string(ld_tot_sum,"####0")+"'")	
end if


if cbx_7.checked then
	//Create text strings in report according to the chosen vessel
	IF rb_1.checked THEN
		ds_watch_list_store.Modify("overskrift2.Text=' GAS J-TYPE SHIPS '")
	ELSEIF rb_2.checked THEN
		ds_watch_list_store.Modify("overskrift2.Text='GAS NOT J-TYPE SHIPS '")
	ELSE
		ds_watch_list_store.Modify("overskrift2.Text='"+is_pc_name+"'")
	END IF
	//Format text in report
	ds_watch_list_store.Modify("overskrift1.text='DEMURRAGE WATCH LIST pr. "+string(id_enddate,"dd/mm-yy")+"'")
	ds_watch_list_store.Modify("Datawindow.Print.Orientation = 1")
	ds_watch_list_store.SetSort("chart_chart_n_1, vessels_vessel_name, claims_voyage_nr")
	ds_watch_list_store.Sort()
	ds_watch_list_store.Modify("chart_chart_n_1.Font.Weight='700'")
	ds_watch_list_store.GroupCalc()

	// Get min amount and min days
	ld_min_amount = Dec(em_1.text)
	ll_min_days = Long(em_2.text)
	ld_end = Date(id_enddate)
	
	// Make cursor for watch list
	
	
	// MAKE TRANSOBJECT FOR CURSOR
	transaction sqlwatch
	
	uo_global.defaulttransactionobject(sqlwatch)
	
	CONNECT USING sqlwatch;
	
	//Find upperbound in profit center array
	ll_upper = upperbound(ii_pc_nr)
	ll_upper++
	For ll_counter = ll_upper TO 15
		//Insert last value in empty places
		ii_pc_nr[ll_counter] = ii_pc_nr[ll_upper - 1]
	NEXT
	
	DECLARE 	w_cur CURSOR FOR
	SELECT 	CLAIMS.VESSEL_NR, CLAIMS.VOYAGE_NR, CLAIMS.CHART_NR, CLAIMS.CLAIM_NR, 
			 	CLAIMS.FORWARDING_DATE, IsNull(CLAIMS.CLAIM_AMOUNT_USD,0)
	FROM		CLAIMS, VESSELS
	WHERE 	( CLAIMS.VESSEL_NR = VESSELS.VESSEL_NR ) and  
				( ( CLAIMS.CLAIM_TYPE = 'DEM' ) AND  
				( CLAIMS.FORWARDING_DATE <= :id_enddate ) AND  
				( CLAIMS.CLAIM_AMOUNT_USD > 0 ) AND  
				( VESSELS.PC_NR = :ii_pc_nr[1] OR 
	 		     VESSELS.PC_NR = :ii_pc_nr[2] OR  
		   	  VESSELS.PC_NR = :ii_pc_nr[3] OR 
				  VESSELS.PC_NR = :ii_pc_nr[4] OR 
				  VESSELS.PC_NR = :ii_pc_nr[5] OR 
				  VESSELS.PC_NR = :ii_pc_nr[6] OR 
				  VESSELS.PC_NR = :ii_pc_nr[7] OR 
				  VESSELS.PC_NR = :ii_pc_nr[8] OR 
				  VESSELS.PC_NR = :ii_pc_nr[9] OR 
				  VESSELS.PC_NR = :ii_pc_nr[10] OR 
				  VESSELS.PC_NR = :ii_pc_nr[11] OR 
				  VESSELS.PC_NR = :ii_pc_nr[12] OR 
				  VESSELS.PC_NR = :ii_pc_nr[13] OR 
				  VESSELS.PC_NR = :ii_pc_nr[14] OR 
				  VESSELS.PC_NR = :ii_pc_nr[15] ) )   
	ORDER BY CLAIMS.VESSEL_NR ASC,   
				CLAIMS.VOYAGE_NR ASC,   
				CLAIMS.CHART_NR ASC,   
				CLAIMS.CLAIM_NR ASC 
	USING 	sqlwatch ; 
	
	OPEN w_cur ; 
	
	FETCH w_cur INTO :ll_vessel, :ls_voyage, :ll_chart, :ll_claimnr, :ldt_forw, :ld_claim ;  
	
	DO WHILE sqlwatch.SQLCode = 0
		
		SELECT IsNull(SUM(CLAIM_TRANSACTION.C_TRANS_AMOUNT_USD),0)
		INTO :ld_trans
		FROM CLAIM_TRANSACTION
		WHERE ( CLAIM_TRANSACTION.CHART_NR = :ll_chart ) and  
				( CLAIM_TRANSACTION.VESSEL_NR = :ll_vessel ) and  
				( CLAIM_TRANSACTION.VOYAGE_NR = :ls_voyage) and  
				( CLAIM_TRANSACTION.CLAIM_NR = :ll_claimnr) and 
				( CLAIM_TRANSACTION.C_TRANS_VAL_DATE <= :id_enddate ) ;
		IF SQLCA.SQLCode = 0 THEN
			Commit;
		ELSE
			Rollback;
			MessageBox("Error","Select for sum amounts in watch report")
		END IF
	
		
		ld_end = Date(id_enddate)
		ld_forw = Date(ldt_forw)
		
		/*CALCULATE OUTSTANDING AMOUNTS*/
		ld_outstanding = ld_claim -ld_trans
		
//		IF ld_outstanding > 0 THEN
			//calculate amount before filter
			ld_sum_before_filter += ld_outstanding
//		END IF
		
		//Choose filter criterias
		IF ld_outstanding > 10000 THEN
			CHOOSE CASE ls_filters
				CASE "BOTH"
					//Exceeding amount and days
					IF (ld_outstanding > ld_min_amount) OR &
							(DAYSAFTER(ld_forw,ld_end) > ll_min_days) THEN
								ld_sum_after_filter += ld_outstanding
					END IF
				CASE "AMOUNT"
					//Exceeding amount
					IF (ld_outstanding > ld_min_amount) THEN
								ld_sum_after_filter += ld_outstanding
					END IF
				CASE "DAYS"
					//Exceeding days
					IF DAYSAFTER(ld_forw,ld_end) > ll_min_days THEN
								ld_sum_after_filter += ld_outstanding
					END IF
				CASE "NONE"
					//Just exceeding standard criterias (amount>10000)
					ld_sum_after_filter += ld_outstanding
			END CHOOSE
		END IF
	FETCH w_cur INTO :ll_vessel, :ls_voyage, :ll_chart, :ll_claimnr, :ldt_forw, :ld_claim;
	LOOP
	
	CLOSE w_cur ;
	DISCONNECT USING sqlwatch ; 
	DESTROY sqlwatch ; 
	
	//insert values in sum fields in watch list store
	ds_watch_list_store.modify ("dem_tot.expression = '"+string(ld_sum_before_filter,"####0")+"'")
	ds_watch_list_store.modify ("dem_watch_sum.expression = '"+string(ld_sum_after_filter,"####0")+"'")
	
	// PRINT Watch list
	ds_watch_list_store.Print(FALSE)
	cbx_7.TextColor = RGB(0,0,0)
	
	Destroy ds_watch_list_store
End if

w_progress_no_cancel.wf_progress(li_progress_stages/li_progress_stages,"Monthly Report Generation Complete")
Close(w_progress_no_cancel)
cb_close.Enabled = TRUE
cb_report.Enabled = TRUE
Return

end event

type cbx_no_desp from checkbox within w_monthly_reports
integer x = 73
integer y = 672
integer width = 1001
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "No Despatch On Statistics (Report 5 / 6)"
end type

type rb_3 from radiobutton within w_monthly_reports
boolean visible = false
integer x = 1152
integer y = 656
integer width = 297
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "All types"
end type

on clicked;rb_1.checked = FALSE
rb_2.checked = FALSE
end on

type rb_2 from radiobutton within w_monthly_reports
boolean visible = false
integer x = 1152
integer y = 576
integer width = 352
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "NOT J-type"
end type

type rb_1 from radiobutton within w_monthly_reports
boolean visible = false
integer x = 1152
integer y = 496
integer width = 247
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "J-type"
end type

type dw_misc_by_vessel_charterer from uo_datawindow within w_monthly_reports
boolean visible = false
integer x = 2181
integer y = 664
integer width = 238
integer height = 188
integer taborder = 190
string dataobject = "dw_misc_by_vessel_charterer_ta"
boolean border = false
end type

type dw_dem_by_vessel_charterer from uo_datawindow within w_monthly_reports
boolean visible = false
integer x = 2185
integer y = 888
integer width = 233
integer height = 188
integer taborder = 0
string dataobject = "dw_dem_by_vessel_charterer"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type dw_misc_summary from uo_datawindow within w_monthly_reports
boolean visible = false
integer x = 2167
integer y = 260
integer width = 242
integer height = 176
integer taborder = 0
string dataobject = "dw_monthly_misc"
boolean border = false
end type

type cbx_6 from checkbox within w_monthly_reports
integer x = 987
integer y = 896
integer width = 713
integer height = 72
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "&6 Miscellaneous - Statistics"
end type

type cbx_5 from checkbox within w_monthly_reports
integer x = 987
integer y = 832
integer width = 695
integer height = 72
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "&5 Demurrage - Statistics"
end type

type cbx_4 from checkbox within w_monthly_reports
integer x = 73
integer y = 1024
integer width = 905
integer height = 72
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "&4 Miscellaneous by Vessel/Charterer "
end type

type cbx_3 from checkbox within w_monthly_reports
integer x = 73
integer y = 960
integer width = 887
integer height = 72
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "&3 Demurrage by Vessel/Charterer "
end type

type cbx_2 from checkbox within w_monthly_reports
integer x = 73
integer y = 896
integer width = 864
integer height = 72
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "&2 Miscellaneous - Summary"
end type

type cbx_1 from checkbox within w_monthly_reports
integer x = 73
integer y = 832
integer width = 773
integer height = 72
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "&1 Demurrage - Summary"
end type

type lb_profitcenter from listbox within w_monthly_reports
integer x = 1134
integer y = 96
integer width = 549
integer height = 320
integer taborder = 150
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean multiselect = true
end type

on selectionchanged;String ls_pc_nrs
Boolean lb_gas = FALSE
Long total_profitcentre,xx

total_profitcentre = lb_profitcenter.TotalItems()
FOR xx=1 TO total_profitcentre
	IF lb_profitcenter.State(xx) = 1 THEN
			ls_pc_nrs = left(lb_profitcenter.Text(xx),2)
			IF ls_pc_nrs = "09" THEN
				lb_gas = TRUE
			ELSE
				lb_gas = FALSE
				xx = total_profitcentre + 1
			END IF
	END IF
NEXT
IF lb_gas THEN
	gb_4.visible = TRUE
	rb_1.visible = TRUE
	rb_2.visible = TRUE
	rb_3.visible = TRUE
ELSE
	gb_4.visible = FALSE	
	rb_1.checked = FALSE
	rb_1.visible = FALSE		
	rb_2.checked = FALSE
	rb_2.visible = FALSE
	rb_3.checked = FALSE		
	rb_3.visible = FALSE
END IF
end on

type cb_close from commandbutton within w_monthly_reports
integer x = 37
integer y = 528
integer width = 439
integer height = 96
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

on clicked;Close(parent)
end on

type st_2 from statictext within w_monthly_reports
integer x = 110
integer y = 208
integer width = 384
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
boolean enabled = false
string text = "Ending date:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_monthly_reports
integer x = 110
integer y = 104
integer width = 393
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
boolean enabled = false
string text = "Starting date:"
boolean focusrectangle = false
end type

type dw_demurrage_summary from datawindow within w_monthly_reports
boolean visible = false
integer x = 2162
integer y = 52
integer width = 242
integer height = 176
string dataobject = "dw_monthly_demurrage"
boolean border = false
boolean livescroll = true
end type

type gb_5 from groupbox within w_monthly_reports
integer x = 37
integer y = 1248
integer width = 1682
integer height = 192
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "Watch List Filter"
end type

type gb_4 from groupbox within w_monthly_reports
boolean visible = false
integer x = 1097
integer y = 448
integer width = 631
integer height = 304
integer taborder = 180
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "Rep. 1-4 Subgroups"
end type

type gb_1 from groupbox within w_monthly_reports
integer x = 37
integer y = 768
integer width = 1682
integer height = 468
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "Choose Reports to Print"
end type

type gb_3 from groupbox within w_monthly_reports
integer x = 1097
integer y = 32
integer width = 622
integer height = 416
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "Profitcenter"
end type

type gb_2 from groupbox within w_monthly_reports
integer x = 37
integer y = 32
integer width = 878
integer height = 304
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "Report Period"
end type

type gb_6 from groupbox within w_monthly_reports
integer x = 489
integer y = 372
integer width = 585
integer height = 260
integer taborder = 162
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Outp. Type Rep. 3,4"
end type

