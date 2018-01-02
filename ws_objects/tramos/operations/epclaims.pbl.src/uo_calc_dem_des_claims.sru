$PBExportHeader$uo_calc_dem_des_claims.sru
$PBExportComments$Calculates Demurrage and Despatch Claims
forward
global type uo_calc_dem_des_claims from nonvisualobject
end type
end forward

global type uo_calc_dem_des_claims from nonvisualobject
end type
global uo_calc_dem_des_claims uo_calc_dem_des_claims

type variables
long il_laytime_min, il_deduction_min, il_load_laytime, il_disch_laytime
long il_load_deduction_min, il_disch_deduction_min
//decimal {4} id_allowed_load, id_allowed_discharge, id_rate_hours[]
//decimal {2} id_dem_rates[], id_des_rates[]
//decimal {2} id_claim_amount, id_claim_dem, id_claim_des
//decimal {4} id_days_decimal           // f.eks. 4.2345 days
//decimal {4} id_load_days_decimal
//decimal {4} id_disch_days_decimal  
double id_allowed_load, id_allowed_discharge, id_rate_hours[]
double id_dem_rates[], id_des_rates[]
double id_claim_amount, id_claim_dem, id_claim_des
double id_days_decimal           // f.eks. 4.2345 days
double id_load_days_decimal
double id_disch_days_decimal  
long il_claim_nr
integer ii_nr_of_rates
end variables

forward prototypes
public function s_calc_claim uf_get_bulk_amount (integer vessel_nr, string voyage_nr, integer chart_nr, integer claim_nr)
public function s_calc_claim uf_get_bulk_amount_ports (integer vessel, string voyage, integer charter, integer claim)
public function s_calc_claim uf_bulk_port_claim_amount (integer vessel, string voyage, integer charter, integer claim, string port, string purpose, long calcaioid)
public function s_calc_claim uf_get_tank_amount (integer vessel_nr, string voyage_nr, integer chart_nr, integer claim_nr)
public function s_calc_claim uf_get_tank_amount_ports (integer vessel, string voyage, integer charter, integer claim)
public function s_calc_claim uf_tank_port_claim_amount (integer vessel, string voyage, integer charter, integer claim, string port, string purpose, long calcaioid)
end prototypes

public function s_calc_claim uf_get_bulk_amount (integer vessel_nr, string voyage_nr, integer chart_nr, integer claim_nr);s_calc_claim lstr_parm

decimal {6} ld_rates_days
decimal {6} ld_days_rest                          // hvor mange dage er tilbage 
long ld_load_minutes
integer xx

/* Select sum of all laytime statements for load ports in minutes */
SELECT sum(LAYTIME_STATEMENTS.LAY_MINUTES)  
  INTO :il_load_laytime
  FROM LAYTIME_STATEMENTS,   
       POC  
 WHERE ( POC.PORT_CODE = LAYTIME_STATEMENTS.PORT_CODE ) and  
     	 ( POC.VESSEL_NR = LAYTIME_STATEMENTS.VESSEL_NR ) and  
     	 ( POC.VOYAGE_NR = LAYTIME_STATEMENTS.VOYAGE_NR ) and  
     	 ( POC.PCN = LAYTIME_STATEMENTS.PCN ) and  
     	 ( ( LAYTIME_STATEMENTS.VESSEL_NR = :vessel_nr ) AND  
     	 ( LAYTIME_STATEMENTS.VOYAGE_NR = :voyage_nr ) AND  
     	 ( LAYTIME_STATEMENTS.CHART_NR = :chart_nr ) AND  
     	 ( POC.PURPOSE_CODE <> 'D' ) )   ;

IF SQLCA.SQLCode < 0 THEN 
	MessageBox("Calculation ERROR","No laytime Statement entered for~r~n~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	SetNull(lstr_parm.claim_amount)
	Return (lstr_parm)
END IF

IF IsNull(il_load_laytime) THEN il_load_laytime = 0

/* Select sum of all laytime statements for discharge ports in minutes */
SELECT sum(LAYTIME_STATEMENTS.LAY_MINUTES)  
  INTO :il_disch_laytime
  FROM LAYTIME_STATEMENTS,   
       POC  
 WHERE ( POC.PORT_CODE = LAYTIME_STATEMENTS.PORT_CODE ) and  
       ( POC.VESSEL_NR = LAYTIME_STATEMENTS.VESSEL_NR ) and  
       ( POC.VOYAGE_NR = LAYTIME_STATEMENTS.VOYAGE_NR ) and  
       ( POC.PCN = LAYTIME_STATEMENTS.PCN ) and  
       ( ( LAYTIME_STATEMENTS.VESSEL_NR = :vessel_nr ) AND  
       ( LAYTIME_STATEMENTS.VOYAGE_NR = :voyage_nr ) AND  
       ( LAYTIME_STATEMENTS.CHART_NR = :chart_nr ) AND  
       ( POC.PURPOSE_CODE = 'D' ) ) ;
		 
IF SQLCA.SQLCode < 0  THEN 
	MessageBox("Calculation ERROR","No laytime Statement entered for~r~n~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	SetNull(lstr_parm.claim_amount)
	Return (lstr_parm)
END IF

IF IsNull(il_disch_laytime) THEN il_disch_laytime = 0

/* Select sum of all laytime deductions for load ports in minutes */
SELECT sum(LAY_DEDUCTIONS.DEDUCTION_MINUTES)  
  INTO :il_load_deduction_min  
  FROM LAY_DEDUCTIONS,   
       POC  
 WHERE ( LAY_DEDUCTIONS.PORT_CODE = POC.PORT_CODE ) and  
       ( LAY_DEDUCTIONS.VESSEL_NR = POC.VESSEL_NR ) and  
       ( LAY_DEDUCTIONS.VOYAGE_NR = POC.VOYAGE_NR ) and  
       ( LAY_DEDUCTIONS.PCN = POC.PCN ) and  
       ( ( LAY_DEDUCTIONS.VESSEL_NR = :vessel_nr ) AND  
       ( LAY_DEDUCTIONS.VOYAGE_NR = :voyage_nr ) AND  
       ( LAY_DEDUCTIONS.CHART_NR = :chart_nr ) AND  
       ( POC.PURPOSE_CODE <> 'D' ) )   ;
		 
IF SQLCA.SQLCode < 0  THEN 
	MessageBox("Calculation ERROR","Error reading LAY_DEDUCTIONS for ~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

IF IsNull(il_load_deduction_min) THEN il_load_deduction_min = 0

/* Select sum of all laytime deductions for discharge ports in minutes */
SELECT sum(LAY_DEDUCTIONS.DEDUCTION_MINUTES)  
  INTO :il_disch_deduction_min  
  FROM LAY_DEDUCTIONS,   
       POC  
 WHERE ( LAY_DEDUCTIONS.PORT_CODE = POC.PORT_CODE ) and  
       ( LAY_DEDUCTIONS.VESSEL_NR = POC.VESSEL_NR ) and  
       ( LAY_DEDUCTIONS.VOYAGE_NR = POC.VOYAGE_NR ) and  
       ( LAY_DEDUCTIONS.PCN = POC.PCN ) and  
       ( ( LAY_DEDUCTIONS.VESSEL_NR = :vessel_nr ) AND  
       ( LAY_DEDUCTIONS.VOYAGE_NR = :voyage_nr ) AND  
       ( LAY_DEDUCTIONS.CHART_NR = :chart_nr ) AND  
       ( POC.PURPOSE_CODE = 'D' ) )   ;
		 
IF SQLCA.SQLCode < 0  THEN 
	MessageBox("Calculation ERROR","Error reading LAY_DEDUCTIONS for ~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

IF IsNull(il_disch_deduction_min) THEN il_disch_deduction_min = 0

/* Select claim number for use when selecting from table DEM_DES_CLAIMS */

il_claim_nr = claim_nr

/* Select laytime allowed DISCH_LAYTIME_ALLOWED */
SELECT LOAD_LAYTIME_ALLOWED,
	      DISCH_LAYTIME_ALLOWED
	INTO :id_allowed_load ,
		 :id_allowed_discharge
	FROM DEM_DES_CLAIMS
	WHERE VESSEL_NR = :vessel_nr
	AND VOYAGE_NR = :voyage_nr
	AND CHART_NR = :chart_nr 
	AND CLAIM_NR = :il_claim_nr;
IF SQLCA.SQLCode < 0 OR SQLCA.SQLCode = 100 THEN 
	MessageBox("Calculation ERROR","No laytime Allowed entered for~r~n~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

IF IsNull(id_allowed_load) THEN id_allowed_load = 0
IF IsNull(id_allowed_discharge) THEN id_allowed_discharge = 0

/* Select number of rates */
SELECT COUNT(*)
	INTO :ii_nr_of_rates
	FROM DEM_DES_RATES
	WHERE VESSEL_NR = :vessel_nr
	AND VOYAGE_NR = :voyage_nr
	AND CHART_NR = :chart_nr 
	AND CLAIM_NR = :il_claim_nr;
IF SQLCA.SQLCode < 0 OR SQLCA.SQLCode = 100 THEN 
	MessageBox("Calculation ERROR","No Rates entered for~r~n~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

DECLARE RATES_CUR CURSOR FOR
	SELECT RATE_HOURS,
			DEM_RATE_DAY,
			DES_RATE_DAY
	FROM DEM_DES_RATES
	WHERE VESSEL_NR = :vessel_nr
	AND VOYAGE_NR = :voyage_nr
	AND CHART_NR = :chart_nr 
	AND CLAIM_NR = :il_claim_nr
	ORDER BY RATE_NUMBER;
IF SQLCA.SQLCode < 0 THEN 
	MessageBox("Calculation ERROR","No Rates entered for~r~n~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

xx = 1
OPEN RATES_CUR;
IF SQLCA.SQLCode < 0 THEN 
	MessageBox("Calculation ERROR","Error when opening RATES_CUR")
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

FETCH RATES_CUR INTO :id_rate_hours[xx], :id_dem_rates[xx], :id_des_rates[xx];
IF SQLCA.SQLCode < 0 THEN 
	MessageBox("Calculation ERROR","Error when fetch RATES_CUR")
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

DO WHILE SQLCA.SQLCode = 0
	xx ++
	FETCH RATES_CUR INTO :id_rate_hours[xx], :id_dem_rates[xx], :id_des_rates[xx];
	IF SQLCA.SQLCode < 0 THEN 
		MessageBox("Calculation ERROR","Error when fetch RATES_CUR")
		lstr_parm.return_code = -1
		Return (lstr_parm)
	END IF
LOOP
CLOSE RATES_CUR;
IF SQLCA.SQLCode < 0 THEN 
	MessageBox("Calculation ERROR","Error when closing RATES_CUR")
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

id_claim_des = 0
id_claim_dem = 0
//
// Beregn load days on demurrage or despatch udfra antal minutter	
//
ld_load_minutes = il_load_laytime - il_load_deduction_min - (round(id_allowed_load * 60,0))
id_load_days_decimal = round(ld_load_minutes / 1440,6)
IF id_load_days_decimal < 0 THEN
	lstr_parm.des_minutes += ld_load_minutes * -1
	ld_days_rest = id_load_days_decimal * -1 
	id_claim_amount = 0
	FOR xx = 1 TO ii_nr_of_rates
		ld_rates_days = round(id_rate_hours[xx] / 24 , 6)
		IF (ld_days_rest >= ld_rates_days) AND (ld_rates_days <> 0)  THEN
			id_claim_amount += ld_rates_days * id_des_rates[xx]
			ld_days_rest -= ld_rates_days
			lstr_parm.des_hours[xx] += ld_rates_days
			lstr_parm.des_rates[xx] = id_des_rates[xx]
			lstr_parm.des_amount[xx] += 	ld_rates_days * id_des_rates[xx]			  
		ELSE
			id_claim_amount += ld_days_rest * id_des_rates[xx]
			lstr_parm.des_hours[xx] += ld_days_rest
			lstr_parm.des_rates[xx] = id_des_rates[xx]
			lstr_parm.des_amount[xx] += 	ld_days_rest * id_des_rates[xx]			  
		END IF
	NEXT
	lstr_parm.load_des =  id_claim_amount
	id_claim_des += id_claim_amount
ELSE
	lstr_parm.dem_minutes += ld_load_minutes
	ld_days_rest = id_load_days_decimal 
	id_claim_amount = 0
	FOR xx = 1 TO ii_nr_of_rates
		ld_rates_days = round(id_rate_hours[xx] / 24 , 6)
		IF (ld_days_rest >= ld_rates_days) AND (ld_rates_days <> 0)  THEN
			id_claim_amount += ld_rates_days * id_dem_rates[xx]
			ld_days_rest -= ld_rates_days
			lstr_parm.dem_hours[xx] += ld_rates_days
			lstr_parm.dem_rates[xx] = id_dem_rates[xx]
			lstr_parm.dem_amount[xx] += ld_rates_days * id_dem_rates[xx]			  
		ELSE
			id_claim_amount += ld_days_rest * id_dem_rates[xx]
			lstr_parm.dem_hours[xx] += ld_days_rest
			lstr_parm.dem_rates[xx] = id_dem_rates[xx]
			lstr_parm.dem_amount[xx] += ld_days_rest * id_dem_rates[xx]			  
		END IF
	NEXT
	lstr_parm.load_dem =  id_claim_amount
	id_claim_dem += id_claim_amount
END IF

//
// Beregn discharge days on demurrage or despatch udfra antal minutter	
//
long ld_disch_minutes
ld_disch_minutes = il_disch_laytime - il_disch_deduction_min - (round(id_allowed_discharge * 60,0))
id_disch_days_decimal = round(ld_disch_minutes / 1440,6)

IF id_disch_days_decimal < 0 THEN
	lstr_parm.des_minutes += ld_disch_minutes * -1
	ld_days_rest = id_disch_days_decimal * -1 
	id_claim_amount = 0
	FOR xx = 1 TO ii_nr_of_rates
		ld_rates_days = round(id_rate_hours[xx] / 24 , 6)
		IF (ld_days_rest >= ld_rates_days) AND (ld_rates_days <> 0)  THEN
			id_claim_amount += ld_rates_days * id_des_rates[xx]
			ld_days_rest -= ld_rates_days
			lstr_parm.des_hours[xx] += ld_rates_days
			lstr_parm.des_rates[xx] = id_des_rates[xx]
			lstr_parm.des_amount[xx] += 	ld_rates_days * id_des_rates[xx]			  
		ELSE
			id_claim_amount += ld_days_rest * id_des_rates[xx]
			lstr_parm.des_hours[xx] += ld_days_rest
			lstr_parm.des_rates[xx] = id_des_rates[xx]
			lstr_parm.des_amount[xx] += 	ld_days_rest * id_des_rates[xx]			  
		END IF
	NEXT
	lstr_parm.disch_des =  id_claim_amount
	id_claim_des += id_claim_amount
ELSE
	lstr_parm.dem_minutes += ld_disch_minutes
	ld_days_rest = id_disch_days_decimal 
	id_claim_amount = 0
	FOR xx = 1 TO ii_nr_of_rates
		ld_rates_days = round(id_rate_hours[xx] / 24 , 6)
		IF (ld_days_rest >= ld_rates_days) AND (ld_rates_days <> 0)  THEN
			id_claim_amount += ld_rates_days * id_dem_rates[xx]
			ld_days_rest -= ld_rates_days
			lstr_parm.dem_hours[xx] += ld_rates_days
			lstr_parm.dem_rates[xx] = id_dem_rates[xx]
			lstr_parm.dem_amount[xx] += ld_rates_days * id_dem_rates[xx]			  
		ELSE
			id_claim_amount += ld_days_rest * id_dem_rates[xx]
			lstr_parm.dem_hours[xx] += ld_days_rest
			lstr_parm.dem_rates[xx] = id_dem_rates[xx]
			lstr_parm.dem_amount[xx] += ld_days_rest * id_dem_rates[xx]			  
		END IF
	NEXT
	lstr_parm.disch_dem =  id_claim_amount
	id_claim_dem += id_claim_amount
END IF

id_claim_amount = id_claim_dem - id_claim_des
lstr_parm.claim_amount = id_claim_amount
lstr_parm.return_code = 0
RETURN lstr_parm
end function

public function s_calc_claim uf_get_bulk_amount_ports (integer vessel, string voyage, integer charter, integer claim);String ls_port, ls_purpose
Decimal {4} ld_sum_port_amount = 0
s_calc_claim lstr_parm
long ll_calcaioid
Transaction SQLPorts
uo_global_vars uo_vars

uo_vars = CREATE uo_global_vars

uo_vars.defaulttransactionobject(SQLPorts)
CONNECT USING SQLPorts;

 DECLARE dem_cur CURSOR FOR  
 SELECT DEM_DES_CLAIMS.PORT_CODE, DEM_DES_CLAIMS.DEM_DES_PURPOSE,DEM_DES_CLAIMS.CAL_CAIO_ID
 FROM DEM_DES_CLAIMS  
 WHERE ( DEM_DES_CLAIMS.VESSEL_NR = :vessel  ) AND  
         ( DEM_DES_CLAIMS.VOYAGE_NR = :voyage ) AND  
         ( DEM_DES_CLAIMS.CHART_NR = :charter ) AND  
         ( DEM_DES_CLAIMS.CLAIM_NR = :claim  ) AND
	 ( DEM_DES_CLAIMS.DEM_DES_SETTLED = 1  ) 
USING SQLPorts;

OPEN dem_cur;

FETCH dem_cur INTO :ls_port, :ls_purpose,:ll_calcaioid;

DO WHILE SQLPorts.SQLCode = 0
	lstr_parm = uf_bulk_port_claim_amount(vessel, voyage, charter, claim, ls_port, left(ls_purpose,1), ll_calcaioid)
	ld_sum_port_amount += lstr_parm.claim_amount 
	FETCH dem_cur INTO :ls_port, :ls_purpose,:ll_calcaioid;
LOOP

CLOSE dem_cur;
DISCONNECT USING SQLPorts;

DESTROY SQLPorts;
DESTROY uo_vars;

lstr_parm.claim_amount = ld_sum_port_amount
Return (lstr_parm)
end function

public function s_calc_claim uf_bulk_port_claim_amount (integer vessel, string voyage, integer charter, integer claim, string port, string purpose, long calcaioid);long ll_load_laytime, ll_disch_laytime, ld_disch_minutes,ll_load_deduction_min, ll_disch_deduction_min
decimal {6} ld_allowed_load, ld_allowed_discharge,ld_load_days_decimal, ld_disch_days_decimal  
decimal {2} ld_dem_rate, ld_des_rate, ld_claim_dem = 0, ld_claim_des = 0
s_calc_claim lstr_parm
String ls_pcn, ls_purpose
long ld_load_minutes

/* Select sum of all laytime statements for load and other port in minutes */
SELECT IsNull(sum(LAYTIME_STATEMENTS.LAY_MINUTES),0)  
	INTO :ll_load_laytime
    	FROM LAYTIME_STATEMENTS,   
        	 POC  
	 WHERE ( POC.PORT_CODE = LAYTIME_STATEMENTS.PORT_CODE ) and  
        	 ( POC.VESSEL_NR = LAYTIME_STATEMENTS.VESSEL_NR ) and  
         	( POC.VOYAGE_NR = LAYTIME_STATEMENTS.VOYAGE_NR ) and  
         	( POC.PCN = LAYTIME_STATEMENTS.PCN ) and  
         	( ( LAYTIME_STATEMENTS.VESSEL_NR = :vessel ) AND  
         	( LAYTIME_STATEMENTS.VOYAGE_NR = :voyage ) AND  
         	( LAYTIME_STATEMENTS.CHART_NR = :charter ) AND
		(LAYTIME_STATEMENTS.PORT_CODE = :port ) AND
         	( POC.PURPOSE_CODE <> 'D' ) )   ;
IF SQLCA.SQLCode < 0 THEN 
	MessageBox("Calculation ERROR","No laytime Statement entered for~r~n~r~nVessel nr.: "+string(vessel)+"~r~nVoyage nr.: "+voyage)
	SetNull(lstr_parm.claim_amount)
	Return (lstr_parm)
END IF

/* Select sum of all laytime statements for discharge port in minutes */
SELECT IsNull(sum(LAYTIME_STATEMENTS.LAY_MINUTES),0)  
	INTO :ll_disch_laytime
    	FROM LAYTIME_STATEMENTS,   
         	POC  
  	 WHERE ( POC.PORT_CODE = LAYTIME_STATEMENTS.PORT_CODE ) and  
         	( POC.VESSEL_NR = LAYTIME_STATEMENTS.VESSEL_NR ) and  
         	( POC.VOYAGE_NR = LAYTIME_STATEMENTS.VOYAGE_NR ) and  
         	( POC.PCN = LAYTIME_STATEMENTS.PCN ) and  
         	( ( LAYTIME_STATEMENTS.VESSEL_NR = :vessel ) AND  
         	( LAYTIME_STATEMENTS.VOYAGE_NR = :voyage ) AND  
         	( LAYTIME_STATEMENTS.CHART_NR = :charter ) AND  
		(LAYTIME_STATEMENTS.PORT_CODE = :port ) AND
         	( POC.PURPOSE_CODE = 'D' ) )   ;
IF SQLCA.SQLCode < 0  THEN 
	MessageBox("Calculation ERROR","No laytime Statement entered for~r~n~r~nVessel nr.: "+string(vessel)+"~r~nVoyage nr.: "+voyage)
	SetNull(lstr_parm.claim_amount)
	Return (lstr_parm)
END IF

/* Select sum of all laytime deductions for load and other port in minutes */
SELECT IsNull(sum(LAY_DEDUCTIONS.DEDUCTION_MINUTES) ,0) 
	INTO :ll_load_deduction_min  
    	FROM LAY_DEDUCTIONS,   
         	POC  
  	 WHERE ( LAY_DEDUCTIONS.PORT_CODE = POC.PORT_CODE ) and  
         	( LAY_DEDUCTIONS.VESSEL_NR = POC.VESSEL_NR ) and  
         	( LAY_DEDUCTIONS.VOYAGE_NR = POC.VOYAGE_NR ) and  
         	( LAY_DEDUCTIONS.PCN = POC.PCN ) and  
         	( ( LAY_DEDUCTIONS.VESSEL_NR = :vessel ) AND  
         	( LAY_DEDUCTIONS.VOYAGE_NR = :voyage ) AND  
         	( LAY_DEDUCTIONS.CHART_NR = :charter ) AND
		(LAY_DEDUCTIONS.PORT_CODE = :port ) AND  
         	( POC.PURPOSE_CODE <> 'D' ) )   ;
IF SQLCA.SQLCode < 0  THEN 
	MessageBox("Calculation ERROR","Error reading LAY_DEDUCTIONS for ~r~nVessel nr.: "+string(vessel)+"~r~nVoyage nr.: "+voyage)
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

/* Select sum of all laytime deductions for discharge port in minutes */
SELECT IsNull(sum(LAY_DEDUCTIONS.DEDUCTION_MINUTES),0)  
	INTO :ll_disch_deduction_min  
    	FROM LAY_DEDUCTIONS,   
         	POC  
  	 WHERE ( LAY_DEDUCTIONS.PORT_CODE = POC.PORT_CODE ) and  
         	( LAY_DEDUCTIONS.VESSEL_NR = POC.VESSEL_NR ) and  
         	( LAY_DEDUCTIONS.VOYAGE_NR = POC.VOYAGE_NR ) and  
         	( LAY_DEDUCTIONS.PCN = POC.PCN ) and  
         	( ( LAY_DEDUCTIONS.VESSEL_NR = :vessel ) AND  
         	( LAY_DEDUCTIONS.VOYAGE_NR = :voyage ) AND  
         	( LAY_DEDUCTIONS.CHART_NR = :charter ) AND
		(LAY_DEDUCTIONS.PORT_CODE = :port ) AND    
         	( POC.PURPOSE_CODE = 'D' ) )   ;
IF SQLCA.SQLCode < 0  THEN 
	MessageBox("Calculation ERROR","Error reading LAY_DEDUCTIONS for ~r~nVessel nr.: "+string(vessel)+"~r~nVoyage nr.: "+voyage)
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

/* Select laytime allowed LOAD-, and DISCH_LAYTIME_ALLOWED */
SELECT IsNull(LOAD_LAYTIME_ALLOWED,0),
	      IsNull(DISCH_LAYTIME_ALLOWED,0),
			DEM_DES_PURPOSE,
	      SUBSTRING(DEM_DES_PURPOSE,2,1)
	INTO :ld_allowed_load ,
		 :ld_allowed_discharge,
		 :ls_purpose,
		 :ls_pcn
	FROM DEM_DES_CLAIMS
	WHERE VESSEL_NR = :vessel
	AND VOYAGE_NR = :voyage
	AND CHART_NR = :charter 
	AND CLAIM_NR = :claim
	AND PORT_CODE = :port
	AND CAL_CAIO_ID = :calcaioid ;
IF SQLCA.SQLCode < 0 OR SQLCA.SQLCode = 100 THEN 
	MessageBox("Calculation ERROR","No laytime Allowed entered for~r~n~r~nVessel nr.: "+string(vessel)+"~r~nVoyage nr.: "+voyage)
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

//SELECT IsNull(CAL_CAIO_DEMURRAGE,0), IsNull(CAL_CAIO_DESPATCH,0)
//INTO :ld_dem_rate,:ld_des_rate
//FROM CAL_CAIO
//WHERE CAL_CAIO_ID = :calcaioid;
//

  SELECT DEM_DES_RATES.DEM_RATE_DAY,   
         DEM_DES_RATES.DES_RATE_DAY  
    INTO :ld_dem_rate,   
         :ld_des_rate  
    FROM DEM_DES_RATES  
    WHERE VESSEL_NR = :vessel
	AND VOYAGE_NR = :voyage
	AND CHART_NR = :charter 
	AND CLAIM_NR = :claim
	AND PORT_CODE = :port
	AND DEM_DES_PURPOSE = :ls_purpose;

IF SQLCA.SQLCode < 0 OR SQLCA.SQLCode = 100 THEN 
	MessageBox("Calculation ERROR","Error searching for rates")
	lstr_parm.return_code = -1
	Return (lstr_parm)
END IF

//
// Beregn load days on demurrage or despatch udfra antal minutter	
//
ld_load_minutes = ll_load_laytime - ll_load_deduction_min - (round(ld_allowed_load * 60,0))
ld_load_days_decimal = round(ld_load_minutes / 1440,6)
IF ld_load_days_decimal < 0 THEN 
	lstr_parm.des_minutes += ld_load_minutes * -1
	ld_load_days_decimal = ld_load_days_decimal * -1 
	lstr_parm.des_hours[1] += ld_load_days_decimal
	lstr_parm.des_rates[1] = ld_des_rate
	lstr_parm.des_amount[1] += ld_load_days_decimal * ld_des_rate		  
	ld_claim_des += ld_load_days_decimal * ld_des_rate	
ELSE
	lstr_parm.dem_minutes += ld_load_minutes 
	lstr_parm.dem_hours[1] += ld_load_days_decimal
	lstr_parm.dem_rates[1] = ld_dem_rate
	lstr_parm.dem_amount[1] += ld_load_days_decimal * ld_dem_rate		  
	ld_claim_dem += ld_load_days_decimal * ld_dem_rate	
END IF

//
// Beregn discharge days on demurrage or despatch udfra antal minutter	
//

ld_disch_minutes = ll_disch_laytime - ll_disch_deduction_min - (round(ld_allowed_discharge * 60,0))
ld_disch_days_decimal = round(ld_disch_minutes / 1440,6)
IF ld_disch_days_decimal < 0 THEN 
	lstr_parm.des_minutes += ld_disch_minutes * -1
	ld_disch_days_decimal = ld_disch_days_decimal * -1 
	lstr_parm.des_hours[1] += ld_disch_days_decimal
	lstr_parm.des_rates[1] = ld_des_rate
	lstr_parm.des_amount[1] += ld_disch_days_decimal * ld_des_rate		  
	ld_claim_des += ld_disch_days_decimal * ld_des_rate	
ELSE
	lstr_parm.dem_minutes += ld_disch_minutes 
	lstr_parm.dem_hours[1] += ld_disch_days_decimal
	lstr_parm.dem_rates[1] = ld_dem_rate
	lstr_parm.dem_amount[1] += ld_disch_days_decimal * ld_dem_rate		  
	ld_claim_dem += ld_disch_days_decimal * ld_dem_rate	
END IF

lstr_parm.claim_amount  = ld_claim_dem - ld_claim_des
lstr_parm.return_code = 0
RETURN lstr_parm
end function

public function s_calc_claim uf_get_tank_amount (integer vessel_nr, string voyage_nr, integer chart_nr, integer claim_nr);s_calc_claim lstr_parm
long ld_minutes
decimal {6} ld_rates_days
decimal {6} ld_days_rest  // hvor mange dage er er tilbage 
integer xx

/* Select sum of all laytime statements in minutes */
SELECT SUM(LAY_MINUTES)
	INTO :il_laytime_min
	FROM LAYTIME_STATEMENTS
	WHERE VESSEL_NR = :vessel_nr
	AND VOYAGE_NR = :voyage_nr
	AND CHART_NR = :chart_nr ;
IF SQLCA.SQLCode < 0 OR SQLCA.SQLCode = 100 THEN 
	MessageBox("Calculation ERROR","No laytime Statement entered for~r~n~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	SetNull(id_claim_amount)
	Return (lstr_parm)
END IF

/* Select sum of all laytime deductions in minutes */
SELECT SUM(DEDUCTION_MINUTES)
	INTO :il_deduction_min
	FROM LAY_DEDUCTIONS
	WHERE VESSEL_NR = :vessel_nr
	AND VOYAGE_NR = :voyage_nr
	AND CHART_NR = :chart_nr ;
IF SQLCA.SQLCode < 0  THEN 
	MessageBox("Calculation ERROR","Error reading LAY_DEDUCTIONS for ~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	lstr_parm.Return_code = -1
	Return (lstr_parm)
END IF

IF IsNull(il_deduction_min) THEN il_deduction_min = 0

/* Select claim number for use when selecting from table DEM_DES_CLAIMS */

il_claim_nr = claim_nr

/* Select laytime allowed DISCH_LAYTIME_ALLOWED */
SELECT LOAD_LAYTIME_ALLOWED,
	      DISCH_LAYTIME_ALLOWED
	INTO :id_allowed_load ,
		 :id_allowed_discharge
	FROM DEM_DES_CLAIMS
	WHERE VESSEL_NR = :vessel_nr
	AND VOYAGE_NR = :voyage_nr
	AND CHART_NR = :chart_nr 
	AND CLAIM_NR = :il_claim_nr;
IF SQLCA.SQLCode < 0 OR SQLCA.SQLCode = 100 THEN 
	MessageBox("Calculation ERROR","No laytime Allowed entered for~r~n~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	lstr_parm.Return_code = -1
	Return (lstr_parm)
END IF

/* Select number of rates */
SELECT COUNT(*)
	INTO :ii_nr_of_rates
	FROM DEM_DES_RATES
	WHERE VESSEL_NR = :vessel_nr
	AND VOYAGE_NR = :voyage_nr
	AND CHART_NR = :chart_nr 
	AND CLAIM_NR = :il_claim_nr;
IF SQLCA.SQLCode < 0 OR SQLCA.SQLCode = 100 THEN 
	MessageBox("Calculation ERROR","No Rates entered for~r~n~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	lstr_parm.Return_code = -1
	Return (lstr_parm)
END IF

DECLARE RATES_CUR CURSOR FOR
	SELECT RATE_HOURS,
			DEM_RATE_DAY,
			DES_RATE_DAY
	FROM DEM_DES_RATES
	WHERE VESSEL_NR = :vessel_nr
	AND VOYAGE_NR = :voyage_nr
	AND CHART_NR = :chart_nr 
	AND CLAIM_NR = :il_claim_nr
	ORDER BY RATE_NUMBER;
IF SQLCA.SQLCode < 0 THEN 
	MessageBox("Calculation ERROR","No Rates entered for~r~n~r~nVessel nr.: "+string(vessel_nr)+"~r~nVoyage nr.: "+voyage_nr)
	lstr_parm.Return_code = -1
	Return (lstr_parm)
END IF

xx = 1
OPEN RATES_CUR;
IF SQLCA.SQLCode < 0 THEN 
	MessageBox("Calculation ERROR","Error when opening RATES_CUR")
	lstr_parm.Return_code = -1
	Return (lstr_parm)
END IF

FETCH RATES_CUR INTO :id_rate_hours[xx], :id_dem_rates[xx], :id_des_rates[xx];
IF SQLCA.SQLCode < 0 THEN 
	MessageBox("Calculation ERROR","Error when fetch RATES_CUR")
	lstr_parm.Return_code = -1
	Return (lstr_parm)
END IF

DO WHILE SQLCA.SQLCode = 0
	xx ++
	FETCH RATES_CUR INTO :id_rate_hours[xx], :id_dem_rates[xx], :id_des_rates[xx];
	IF SQLCA.SQLCode < 0 THEN 
		MessageBox("Calculation ERROR","Error when fetch RATES_CUR")
		lstr_parm.Return_code = -1
		Return (lstr_parm)
	END IF
LOOP

CLOSE RATES_CUR;

IF SQLCA.SQLCode < 0 THEN 
	MessageBox("Calculation ERROR","Error when closing RATES_CUR")
	lstr_parm.Return_code = -1
	Return (lstr_parm)
END IF

// Beregn days on demurrage or despatch udfra antal minutter	
IF IsNull(id_allowed_load) THEN id_allowed_load = 0
IF IsNull(id_allowed_discharge) THEN id_allowed_discharge = 0
ld_minutes = il_laytime_min - il_deduction_min - (round((id_allowed_discharge + id_allowed_load) * 60,0))
lstr_parm.dem_minutes = ld_minutes
id_days_decimal = round(ld_minutes / 1440,6)
ld_days_rest = id_days_decimal 
id_claim_amount = 0
FOR xx = 1 TO ii_nr_of_rates
	ld_rates_days = round(id_rate_hours[xx] / 24 , 6)
	IF (ld_days_rest >= ld_rates_days) AND (ld_rates_days <> 0)  THEN
		id_claim_amount += ld_rates_days * id_dem_rates[xx]
		lstr_parm.dem_hours[xx] = ld_rates_days
		lstr_parm.dem_rates[xx] = id_dem_rates[xx]
		lstr_parm.dem_amount[xx] = ld_rates_days * id_dem_rates[xx]
		ld_days_rest -= ld_rates_days
	ELSE
		id_claim_amount += ld_days_rest * id_dem_rates[xx]
		lstr_parm.dem_hours[xx] = ld_days_rest
		lstr_parm.dem_rates[xx] = id_dem_rates[xx]
		lstr_parm.dem_amount[xx] = ld_days_rest * id_dem_rates[xx]
		EXIT
	END IF
NEXT

lstr_parm.return_code = 1
lstr_parm.claim_amount = id_claim_amount
RETURN lstr_parm
end function

public function s_calc_claim uf_get_tank_amount_ports (integer vessel, string voyage, integer charter, integer claim);String ls_port, ls_purpose
//Decimal {4} ld_sum_port_amount = 0
Double ld_sum_port_amount = 0
s_calc_claim lstr_parm
long ll_calcaioid
Transaction SQLPorts
uo_global_vars uo_vars

uo_vars = CREATE uo_global_vars

uo_vars.defaulttransactionobject(SQLPorts)
CONNECT USING SQLPorts;

 DECLARE dem_cur CURSOR FOR  
 SELECT DEM_DES_CLAIMS.PORT_CODE, DEM_DES_CLAIMS.DEM_DES_PURPOSE,DEM_DES_CLAIMS.CAL_CAIO_ID
 FROM DEM_DES_CLAIMS  
 WHERE ( DEM_DES_CLAIMS.VESSEL_NR = :vessel  ) AND  
         ( DEM_DES_CLAIMS.VOYAGE_NR = :voyage ) AND  
         ( DEM_DES_CLAIMS.CHART_NR = :charter ) AND  
         ( DEM_DES_CLAIMS.CLAIM_NR = :claim  ) AND
	 ( DEM_DES_CLAIMS.DEM_DES_SETTLED = 1  )
USING SQLPorts;

OPEN dem_cur;

FETCH dem_cur INTO :ls_port, :ls_purpose,:ll_calcaioid;

DO WHILE SQLPorts.SQLCode = 0
	lstr_parm = uf_tank_port_claim_amount(vessel, voyage, charter, claim, ls_port, left(ls_purpose,1), ll_calcaioid)
	IF lstr_parm.claim_amount < 0 THEN lstr_parm.claim_amount = 0
	ld_sum_port_amount += lstr_parm.claim_amount 
	FETCH dem_cur INTO :ls_port, :ls_purpose,:ll_calcaioid;
LOOP

CLOSE dem_cur;
DISCONNECT USING SQLPorts;

DESTROY SQLPorts;
DESTROY uo_vars;

lstr_parm.claim_amount = ld_sum_port_amount
Return (lstr_parm)


end function

public function s_calc_claim uf_tank_port_claim_amount (integer vessel, string voyage, integer charter, integer claim, string port, string purpose, long calcaioid);long ll_laytime_min, ll_deduction_min,ll_minutes
//decimal {4} ld_allowed_load, ld_allowed_discharge,ld_days_decimal           // f.eks. 4.2345 days
//decimal {2} ld_dem_rate
double ld_allowed_load, ld_allowed_discharge,ld_days_decimal           // f.eks. 4.2345 days
double ld_dem_rate
s_calc_claim lstr_parm
String ls_pcn, ls_purpose

/* Select sum of port laytime statements in minutes */
SELECT SUM(LAY_MINUTES)
	INTO :ll_laytime_min
	FROM LAYTIME_STATEMENTS
	WHERE VESSEL_NR = :vessel
	AND VOYAGE_NR = :voyage
	AND CHART_NR = :charter
	AND PORT_CODE = :port ;
IF SQLCA.SQLCode < 0 OR SQLCA.SQLCode = 100 THEN 
	MessageBox("Calculation ERROR","No laytime Statement entered for~r~n~r~nVessel nr.: "+string(vessel)+"~r~nVoyage nr.: "+voyage)
	SetNull(id_claim_amount)
	Return (lstr_parm)
END IF

/* Select sum of all laytime deductions in minutes */
SELECT IsNull(SUM(DEDUCTION_MINUTES),0)
	INTO :ll_deduction_min
	FROM LAY_DEDUCTIONS
	WHERE VESSEL_NR = :vessel
	AND VOYAGE_NR = :voyage
	AND CHART_NR = :charter
	AND PORT_CODE = :port ;
IF SQLCA.SQLCode < 0  THEN 
	MessageBox("Calculation ERROR","Error reading LAY_DEDUCTIONS for ~r~nVessel nr.: "+string(vessel)+"~r~nVoyage nr.: "+voyage)
	lstr_parm.Return_code = -1
	Return (lstr_parm)
END IF

/* Select laytime allowed DISCH_LAYTIME_ALLOWED */
SELECT IsNull(LOAD_LAYTIME_ALLOWED,0),
	     IsNull(DISCH_LAYTIME_ALLOWED,0),
		  DEM_DES_PURPOSE,
	     SUBSTRING(DEM_DES_PURPOSE,2,1)
	INTO :ld_allowed_load ,
		  :ld_allowed_discharge,
		  :ls_purpose,
	     :ls_pcn
	FROM DEM_DES_CLAIMS
	WHERE VESSEL_NR = :vessel
	AND VOYAGE_NR = :voyage
	AND CHART_NR = :charter 
	AND CLAIM_NR = :claim
	AND PORT_CODE = :port
	AND CAL_CAIO_ID = :calcaioid ;
IF SQLCA.SQLCode < 0 OR SQLCA.SQLCode = 100 THEN 
	MessageBox("Calculation ERROR","No laytime Allowed entered for~r~n~r~nVessel nr.: "+string(vessel)+"~r~nVoyage nr.: "+voyage)
	lstr_parm.Return_code = -1
	Return (lstr_parm)
END IF

//  Hent dem rate fra calculen

//SELECT CAL_CAIO_DEMURRAGE
//INTO :ld_dem_rate
//FROM CAL_CAIO
//WHERE CAL_CAIO_ID = :calcaioid;

  SELECT DEM_DES_RATES.DEM_RATE_DAY
    INTO :ld_dem_rate
    FROM DEM_DES_RATES  
    WHERE VESSEL_NR = :vessel
	AND VOYAGE_NR = :voyage
	AND CHART_NR = :charter 
	AND CLAIM_NR = :claim
	AND PORT_CODE = :port
	AND DEM_DES_PURPOSE = :purpose;

IF SQLCA.SQLCode < 0 OR SQLCA.SQLCode = 100 THEN 
	MessageBox("Calculation ERROR","Error in searching for rates in calculation")
	lstr_parm.Return_code = -1
	Return (lstr_parm)
END IF

// Beregn demurrage or despatch udfra antal minutter	

ll_minutes = ll_laytime_min - ll_deduction_min - (round((ld_allowed_discharge + ld_allowed_load) * 60,0))
lstr_parm.dem_minutes = ll_minutes
ld_days_decimal = round(ll_minutes / 1440,6)

lstr_parm.dem_hours[1] = ld_days_decimal
lstr_parm.dem_rates[1] = ld_dem_rate
lstr_parm.dem_amount[1] = ld_days_decimal * ld_dem_rate
lstr_parm.claim_amount = ld_days_decimal * ld_dem_rate
lstr_parm.return_code = 1

RETURN lstr_parm

end function

on uo_calc_dem_des_claims.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_calc_dem_des_claims.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

