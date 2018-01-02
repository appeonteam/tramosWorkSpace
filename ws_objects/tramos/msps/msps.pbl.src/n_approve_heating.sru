$PBExportHeader$n_approve_heating.sru
forward
global type n_approve_heating from mt_n_nonvisualobject
end type
end forward

global type n_approve_heating from mt_n_nonvisualobject
end type
global n_approve_heating n_approve_heating

type variables
mt_n_datastore	 ids_bunker_lifted_bunker
 
n_port_departure_bunker_value inv_departure_bunker
mt_n_datastore ids_departure_bunker_detail
end variables

forward prototypes
public function integer of_get_previous_voyage_last_actpoc (ref s_poc astr_poc)
public function integer of_set_consumption (long al_row, s_poc astr_poc, s_consumption astr_consumption, ref mt_n_datastore ads_heating_price)
public function integer of_exists_heatingclaims (ref s_poc astr_poc)
public function integer of_get_bunker_quantity (s_poc astr_poc, ref s_consumption astr_consumption)
public function integer of_get_bunker_price (s_poc astr_poc, ref s_consumption astr_consumption)
private function integer _get_bunker_price (s_poc astr_poc, ref s_consumption astr_consumption, string as_bunker_type)
public function integer of_calculate_heating_price (ref s_consumption astr_consumption, string as_consumption_name, string as_consumption_price, decimal ad_diff_qty)
public function integer of_validate_heating_consumption (s_poc astr_poc, s_consumption astr_consumption)
public function integer of_get_consumption (ref s_consumption astr_consumption, s_poc astr_poc)
public function integer of_set_heating_claims (mt_u_datawindow adw_msps_heating, long al_row, s_poc astr_poc, s_consumption astr_consuption, ref mt_n_datastore ads_claims, ref mt_n_datastore ads_heating_price)
public subroutine documentation ()
end prototypes

public function integer of_get_previous_voyage_last_actpoc (ref s_poc astr_poc);/********************************************************************
   of_get_previous_voyage_last_actpoc
   <DESC>	Get previous voyage and last Act. POC info	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc: Current POC structure
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22-03-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/

string 	ls_voyage_nr, ls_port_code
integer	li_pcn
//Get previous voyage last Act. POC info
SELECT P.VOYAGE_NR, P.PORT_CODE, P.PCN
INTO   :ls_voyage_nr, :ls_port_code, :li_pcn
FROM   POC P 
WHERE  P.VESSEL_NR = :astr_poc.vessel_nr
AND    P.VOYAGE_NR < :astr_poc.voyage_nr
AND    SUBSTRING(P.VOYAGE_NR,1,1) <> "9"
AND    P.PORT_ARR_DT = (SELECT MAX(P2.PORT_ARR_DT)
								FROM   POC P2
								WHERE  P2.VESSEL_NR = :astr_poc.vessel_nr
								AND    P2.VOYAGE_NR < :astr_poc.voyage_nr );
//Change the current POC data to be the previous voyage last Act. POC.
if sqlca.sqlcode = 0 then
	astr_poc.previous_voyage_nr = ls_voyage_nr
	astr_poc.previous_port_code = ls_port_code
	astr_poc.previous_pcn       = li_pcn
else
	return c#return.Failure
end if
return c#return.Success
end function

public function integer of_set_consumption (long al_row, s_poc astr_poc, s_consumption astr_consumption, ref mt_n_datastore ads_heating_price);/********************************************************************
   of_set_consuption
   <DESC></DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_row
		astr_poc
		astr_consumption
		ads_heating_price
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-03-12 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
 
select a.CAL_CERP_ID, b.CHART_NR
into :astr_poc.cal_cerp_id, :astr_poc.chart_nr
from CAL_CARG a,CAL_CERP b
where a.CAL_CERP_ID = b.CAL_CERP_ID
and  a.CAL_CALC_ID = :astr_poc.cal_calc_id;

if sqlca.sqlcode = 100 then return c#return.Failure

if astr_poc.claim_nr = 0 then
	select MAX(CLAIM_NR)
	into :astr_poc.claim_nr
	from CLAIMS
	where VESSEL_NR = :astr_poc.vessel_nr
	and VOYAGE_NR = :astr_poc.voyage_nr;

	if isnull(astr_poc.claim_nr) then
		astr_poc.claim_nr = 1
	else
		astr_poc.claim_nr = astr_poc.claim_nr + 1
	end if 
end if

if ads_heating_price.setitem(al_row, 'VESSEL_NR', astr_poc.vessel_nr) = -1 then return c#return.Failure
if ads_heating_price.setitem(al_row, 'VOYAGE_NR', astr_poc.voyage_nr) = -1 then return c#return.Failure 
if ads_heating_price.setitem(al_row, 'CLAIM_NR', astr_poc.claim_nr) = -1 then return c#return.Failure
if ads_heating_price.setitem(al_row, 'CHART_NR', astr_poc.chart_nr) = -1 then return c#return.Failure 

if ads_heating_price.setitem(al_row, 'HFO_TON', astr_consumption.hfo) = -1 then return c#return.Failure  
if ads_heating_price.setitem(al_row, 'DO_TON', astr_consumption.dma) = -1 then return c#return.Failure 
if ads_heating_price.setitem(al_row, 'GO_TON', astr_consumption.go) = -1 then return c#return.Failure
if ads_heating_price.setitem(al_row, 'LSHFO_TON', astr_consumption.lshfo) = -1 then return c#return.Failure

if ads_heating_price.setitem(al_row, 'HEA_DEV_HOURS',astr_consumption.hours) = -1 then return c#return.Failure
if ads_heating_price.setitem(al_row, 'HEA_DEV_PRICE_PR_DAY', 0) = -1 then return c#return.Failure

if ads_heating_price.setitem(al_row, 'HFO_PRICE', astr_consumption.hfo_price ) = -1 then return c#return.Failure 
if ads_heating_price.setitem(al_row, 'GO_PRICE', astr_consumption.go_price) = -1  then return c#return.Failure
if ads_heating_price.setitem(al_row, 'LSHFO_PRICE', astr_consumption.lshfo_price) = -1  then return c#return.Failure
if ads_heating_price.setitem(al_row, 'DO_PRICE', astr_consumption.do_price) = -1 then return c#return.Failure
 
 
return c#return.Success
end function

public function integer of_exists_heatingclaims (ref s_poc astr_poc);/********************************************************************
   of_exists_heatingclaims
   <DESC></DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-03-13 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/

select CLAIM_NR	
into :astr_poc.claim_nr
from CLAIMS
where VESSEL_NR=:astr_poc.vessel_nr
and VOYAGE_NR =:astr_poc.voyage_nr
and CLAIM_TYPE='HEA'
and CHART_NR =:astr_poc.chart_nr
and MSPS_TFV =1;
 
if  astr_poc.claim_nr = 0  then
	return c#return.Failure
else
	return c#return.Success
end if


end function

public function integer of_get_bunker_quantity (s_poc astr_poc, ref s_consumption astr_consumption);/********************************************************************
   of_get_bunker_quantity
   <DESC>	Get previous voyage departure bunker quantity by POC	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc: POC
		astr_consumption: Consumption
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22-03-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/

SELECT isnull(DEPT_HFO,0), isnull(DEPT_DO,0), isnull(DEPT_GO,0), isnull(DEPT_LSHFO,0) 
INTO :astr_consumption.dept_hfo, :astr_consumption.dept_do, :astr_consumption.dept_go, :astr_consumption.dept_lshfo 
FROM POC 
WHERE VESSEL_NR = :astr_poc.vessel_nr
AND VOYAGE_NR= :astr_poc.previous_voyage_nr
AND PORT_CODE= :astr_poc.previous_port_code 
AND PCN= :astr_poc.previous_pcn ;

if sqlca.sqlcode <> 0 then return c#return.Failure

return c#return.Success
end function

public function integer of_get_bunker_price (s_poc astr_poc, ref s_consumption astr_consumption);/********************************************************************
   of_get_bunker_price
   <DESC>	Get departure bunker and weighted price of the POC	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc: POC
		astr_consumption: Consumption
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-03-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/

//HFO
if astr_consumption.dept_hfo <> 0 then
	_get_bunker_price(astr_poc, astr_consumption, "HFO")
end if
//DO
if astr_consumption.dept_do <> 0 then
	_get_bunker_price(astr_poc, astr_consumption, "DO")
end if
//GO
if astr_consumption.dept_go <> 0 then
	_get_bunker_price(astr_poc, astr_consumption, "GO")
end if
//LSHFO
if astr_consumption.dept_lshfo <> 0 then
	_get_bunker_price(astr_poc, astr_consumption, "LSHFO")
end if

return c#return.Success
end function

private function integer _get_bunker_price (s_poc astr_poc, ref s_consumption astr_consumption, string as_bunker_type);/********************************************************************
   _get_bunker_price
   <DESC>	Get previous voyage rest bunker of weighted price in the POC	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc: POC
		astr_consumption: Consumption
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-03-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/

decimal{4}	ld_price, ld_dept_bunker
long			ll_bunkerID[]
long 			ll_row, ll_rows

datastore 	lds_departure_bunker_detail_child
datawindowchild	ldwc_bunker_type

lds_departure_bunker_detail_child = create datastore

//calculate average price of the previous voyage's last port 
inv_departure_bunker.of_calculate(as_bunker_type, astr_poc.vessel_nr, astr_poc.previous_voyage_nr, astr_poc.previous_port_code, astr_poc.previous_pcn, ld_price)
inv_departure_bunker.of_getdetailbunkerid(lds_departure_bunker_detail_child)
ll_rows = lds_departure_bunker_detail_child.rowCount()
for ll_row = 1 to ll_rows
	ll_bunkerID[ll_row] = lds_departure_bunker_detail_child.getItemNumber(ll_row, "bpn")
next
choose case as_bunker_type
	case "HFO"
		ld_dept_bunker = astr_consumption.dept_hfo
		ids_departure_bunker_detail.getChild("dw_hfo", ldwc_bunker_type)
	case "DO"
		ld_dept_bunker = astr_consumption.dept_do
		ids_departure_bunker_detail.getChild("dw_do", ldwc_bunker_type)
	case "GO"
		ld_dept_bunker = astr_consumption.dept_go
		ids_departure_bunker_detail.getChild("dw_go", ldwc_bunker_type)
	case "LSHFO"
		ld_dept_bunker = astr_consumption.dept_lshfo
		ids_departure_bunker_detail.getChild("dw_lshfo", ldwc_bunker_type)
end choose

ldwc_bunker_type.setTransObject(sqlca)
ldwc_bunker_type.retrieve(ll_bunkerID)

ll_rows = ldwc_bunker_type.rowCount()
//set hfo/do/go/lshfo rest quantity of bunker
for ll_row = 1 to ll_rows
	if ld_dept_bunker >= ldwc_bunker_type.getItemDecimal(ll_row, "lifted") then
		ld_dept_bunker -=ldwc_bunker_type.getItemDecimal(ll_row, "lifted")
		ldwc_bunker_type.setItem(ll_row, "rest_ton",ldwc_bunker_type.getItemDecimal(ll_row, "lifted"))
	else
		ldwc_bunker_type.setItem(ll_row, "rest_ton", ld_dept_bunker)
	end if
next

//Get previous voyage rest quantity of bunker and weighted price calculated by FIFO rule
if ldwc_bunker_type.rowcount() > 0 then
	choose case as_bunker_type
		case "HFO"
			astr_consumption.dept_hfo_rest = ldwc_bunker_type.getitemnumber(1, "total_rest_quantity")
			astr_consumption.dept_hfo_weighted_price = ldwc_bunker_type.getitemnumber(1, "compute_2")
		case "DO"
			astr_consumption.dept_do_rest = ldwc_bunker_type.getitemnumber(1, "total_rest_quantity")
			astr_consumption.dept_do_weighted_price = ldwc_bunker_type.getitemnumber(1, "compute_2")
		case "GO"
			astr_consumption.dept_go_rest = ldwc_bunker_type.getitemnumber(1, "total_rest_quantity")
			astr_consumption.dept_go_weighted_price = ldwc_bunker_type.getitemnumber(1, "compute_2")
		case "LSHFO"
			astr_consumption.dept_lshfo_rest = ldwc_bunker_type.getitemnumber(1, "total_rest_quantity")
			astr_consumption.dept_lshfo_weighted_price = ldwc_bunker_type.getitemnumber(1, "compute_2")
	end choose
end if


return c#return.Success
end function

public function integer of_calculate_heating_price (ref s_consumption astr_consumption, string as_consumption_name, string as_consumption_price, decimal ad_diff_qty);/********************************************************************
   of_calculate_heating_price
   <DESC>Calculation of heat consumption of oil price</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_consumption
		as_consumption_name
		as_consumption_price
		ad_diff_qty
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	2012-03-29 20            RJH022        First Version
   </HISTORY>
********************************************************************/

dec{4} ld_bunker_total, ld_resttotal, ld_sum
dec{4} ldc_lifted_bunker, ldc_price
long i, ll_lifted_count
string ls_consumption_type

ll_lifted_count = ids_bunker_lifted_bunker.rowcount()
ls_consumption_type = upper(mid(as_consumption_name,(pos(as_consumption_name,'_') + 1)))
//calclate amount of heating consumption from current voyage
if ad_diff_qty >0 then
	for i = 1 to ll_lifted_count
		ldc_lifted_bunker = ids_bunker_lifted_bunker.getitemdecimal(i, as_consumption_name)
		ldc_price = ids_bunker_lifted_bunker.getitemdecimal(i, as_consumption_price)
		if ad_diff_qty >= ldc_lifted_bunker then
			ad_diff_qty  -= ldc_lifted_bunker
			ld_bunker_total += ldc_lifted_bunker * ldc_price
		else
			ld_bunker_total += ad_diff_qty * ldc_price
			exit
		end if
	next
end if
//calculate average price of consumption type
choose case ls_consumption_type
	case 'HFO'
		if ad_diff_qty > 0 then
			ld_resttotal = astr_consumption.dept_hfo * astr_consumption.dept_hfo_weighted_price
			ld_sum =  ld_resttotal + ld_bunker_total
		else
			ld_sum = astr_consumption.hfo * astr_consumption.dept_hfo_weighted_price
		end if
		astr_consumption.hfo_price = round(ld_sum/astr_consumption.hfo,4)
	case 'DO'
		if ad_diff_qty > 0 then
			ld_resttotal = astr_consumption.dept_do * astr_consumption.dept_do_weighted_price
			ld_sum =  ld_resttotal + ld_bunker_total
		else
			ld_sum = astr_consumption.dma * astr_consumption.dept_do_weighted_price
		end if
		astr_consumption.do_price = round(ld_sum/astr_consumption.dma,4)
	case 'GO'
		if ad_diff_qty > 0 then
			ld_resttotal = astr_consumption.dept_go * astr_consumption.dept_go_weighted_price
			ld_sum =  ld_resttotal + ld_bunker_total
		else
			ld_sum = astr_consumption.go * astr_consumption.dept_go_weighted_price
		end if
		astr_consumption.go_price = round(ld_sum/astr_consumption.go,4)
	case 'LSHFO'
		if ad_diff_qty > 0 then
			ld_resttotal = astr_consumption.dept_lshfo * astr_consumption.dept_lshfo_weighted_price
			ld_sum =  ld_resttotal + ld_bunker_total
		else
			ld_sum = astr_consumption.lshfo * astr_consumption.dept_lshfo_weighted_price
		end if
		astr_consumption.lshfo_price = round(ld_sum/astr_consumption.lshfo,4)
end choose
return c#return.Success

end function

public function integer of_validate_heating_consumption (s_poc astr_poc, s_consumption astr_consumption);/********************************************************************
   of_validate_heating_consumption
   <DESC> Heating consumption quantity should be less than current voyage buying or selling fuel + previous voyage last port fuel </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
		astr_consumption
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-03-02 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/

dec{4} ldc_sell_hfo,ldc_buy_hfo,ldc_sell_do,ldc_buy_do,ldc_sell_go,ldc_buy_go,ldc_sell_lshfo,ldc_buy_lshfo
dec{4} ldc_total_hfo, ldc_total_do, ldc_total_go, ldc_total_lshfo
string ls_voyage_nr, ls_port_code
long li_pcn

//get current voyage buying or selling fuel
SELECT 
		isnull(sum(case when BUY_SELL = 1 then LIFTED_HFO end ), 0) as sell_LIFTED_HFO,
		isnull(sum(case when BUY_SELL = 0 then LIFTED_HFO end), 0) as buy_LIFTED_HFO,
		isnull(sum(case when BUY_SELL = 1 then LIFTED_DO end), 0) as sell_LIFTED_DO,
		isnull(sum(case when BUY_SELL = 0 then LIFTED_DO end), 0) as buy_LIFTED_DO,
		isnull(sum(case when BUY_SELL = 1 then LIFTED_GO end), 0) as sell_LIFTED_GO,
		isnull(sum(case when BUY_SELL = 0 then LIFTED_GO end), 0) as buy_LIFTED_GO,
		isnull(sum(case when BUY_SELL = 1 then LIFTED_LSHFO end), 0) as sell_LIFTED_LSHFO,
		isnull(sum(case when BUY_SELL = 0 then LIFTED_LSHFO end), 0) as buy_LIFTED_LSHFO
 INTO :ldc_sell_hfo, :ldc_buy_hfo, :ldc_sell_do, :ldc_buy_do, :ldc_sell_go, :ldc_buy_go, :ldc_sell_lshfo, :ldc_buy_lshfo
 FROM BP_DETAILS 
WHERE VESSEL_NR = :astr_poc.vessel_nr AND VOYAGE_NR = :astr_poc.voyage_nr;

//get previous voyage last port
if of_get_previous_voyage_last_actpoc(astr_poc) = c#return.Failure then return c#return.Failure

//get previous voyage last port fuel
if of_get_bunker_quantity(astr_poc, astr_consumption) = c#return.Failure then return c#return.Failure

ldc_total_hfo	 = astr_consumption.dept_hfo + ldc_sell_hfo + ldc_buy_hfo
ldc_total_do 	 = astr_consumption.dept_do + ldc_sell_do + ldc_buy_do
ldc_total_go 	 = astr_consumption.dept_go + ldc_sell_go + ldc_buy_go
ldc_total_lshfo = astr_consumption.dept_lshfo + ldc_sell_lshfo + ldc_buy_lshfo

//consumption quantity should be less than current voyage buying or selling fuel + previous voyage last port fuel
if astr_consumption.hfo > ldc_total_hfo or + &
   astr_consumption.dma > ldc_total_do or +&
	astr_consumption.go > ldc_total_go or +&
	astr_consumption.lshfo > ldc_total_lshfo then
	return c#return.Failure
else
	return c#return.Success
end if

end function

public function integer of_get_consumption (ref s_consumption astr_consumption, s_poc astr_poc); /********************************************************************
   of_get_consumption
   <DESC>Initialize all consumption of heating oil</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_consumption
		astr_poc
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	2012-03-29 20            RJH022        First Version
   </HISTORY>
********************************************************************/
decimal{4}			ld_hfo_qty, ld_do_qty, ld_go_qty, ld_lshfo_qty
long					ll_lifted_count
long					i
ids_bunker_lifted_bunker.settransobject(sqlca)
ll_lifted_count = ids_bunker_lifted_bunker.retrieve(astr_poc.vessel_nr,astr_poc.voyage_nr)

//get previous voyage last actpoc
if of_get_previous_voyage_last_actpoc(astr_poc) = c#return.Failure  then return c#return.Failure
//get previous voyage  departure bunker quantity
if of_get_bunker_quantity(astr_poc,astr_consumption) = c#return.Failure then return c#return.Failure
//get previous voyage  departure bunker price
if of_get_bunker_price(astr_poc,astr_consumption) = c#return.Failure then return c#return.Failure

//HFO
if astr_consumption.hfo <> 0 then
	ld_hfo_qty = astr_consumption.hfo - astr_consumption.dept_hfo_rest 
	of_calculate_heating_price(astr_consumption, "lifted_hfo", "price_hfo", ld_hfo_qty)
else
	astr_consumption.hfo_price = 0
end if

//DO 
if astr_consumption.dma <> 0 then
	ld_do_qty = astr_consumption.dma - astr_consumption.dept_do_rest 
	of_calculate_heating_price(astr_consumption, "lifted_do", "price_do", ld_do_qty)
else
	astr_consumption.do_price = 0 
end if

//GO
if astr_consumption.go <> 0 then
	ld_go_qty = astr_consumption.go - astr_consumption.dept_go_rest 
 	of_calculate_heating_price(astr_consumption, "lifted_go", "price_go", ld_go_qty)
else
	astr_consumption.go_price = 0 
end if

//LSHFO
if astr_consumption.lshfo <> 0 then
	ld_lshfo_qty = astr_consumption.lshfo - astr_consumption.dept_lshfo_rest
	of_calculate_heating_price(astr_consumption, "lifted_lshfo", "price_lshfo", ld_lshfo_qty)
else
	astr_consumption.lshfo_price = 0
end if
 
return c#return.Success
end function

public function integer of_set_heating_claims (mt_u_datawindow adw_msps_heating, long al_row, s_poc astr_poc, s_consumption astr_consuption, ref mt_n_datastore ads_claims, ref mt_n_datastore ads_heating_price);/********************************************************************
   of_set_heating_claims
   <DESC></DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_row
		astr_poc
		astr_consuption
		ads_claims
		ads_heating_price
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-03-13 CR20         	RJH022             First Version
   	25/07/2013 CR3238       	LHG008             Fix bug for departure date
   </HISTORY>
********************************************************************/

int li_chart_nr
datetime ld_discharge_date
dec{4} ldc_amount, ldc_amount_usd, ldc_add_comm
string ls_chart_name, ls_office_sn
Double ldo_cp_id_comm

s_claim_base_data lstr_claim_base_data

u_calc_nvo uo_calc_nvo 
uo_calc_nvo = create u_calc_nvo

//get charter ID from Cargo
SELECT DISTINCT CHART.CHART_NR,   
		 CHART.CHART_N_1
  INTO :li_chart_nr, :ls_chart_name
  FROM CARGO,   
       CHART
 WHERE (CHART.CHART_NR = CARGO.CHART_NR) and  
       (CARGO.VESSEL_NR = :astr_poc.vessel_nr) and
       (CARGO.VOYAGE_NR = :astr_poc.voyage_nr);
		 
if sqlca.sqlcode =100 then return c#return.Failure

if astr_poc.claim_nr = 0 then
	SELECT MAX(CLAIM_NR)
	  INTO :astr_poc.claim_nr
	  FROM CLAIMS
	 WHERE VESSEL_NR = :astr_poc.vessel_nr
	   AND VOYAGE_NR = :astr_poc.voyage_nr;

	if isnull(astr_poc.claim_nr) then
		astr_poc.claim_nr = 1
	else
		astr_poc.claim_nr = astr_poc.claim_nr + 1
	end if 
end if

//get calculation CERP ID
SELECT a.CAL_CERP_ID 
  INTO :astr_poc.cal_cerp_id
  FROM CAL_CARG a, CAL_CERP b
 WHERE a.CAL_CERP_ID = b.CAL_CERP_ID
   AND a.CAL_CALC_ID = :astr_poc.cal_calc_id;

if sqlca.sqlcode = 100 then return c#return.Failure

uo_calc_nvo.uf_claim_base_data(astr_poc.vessel_nr, astr_poc.voyage_nr, li_chart_nr, astr_poc.cal_cerp_id, lstr_claim_base_data )

if lstr_claim_base_data.fixed_exrate_enabled = 1 then
	ads_claims.SetItem(al_row, "curr_code", lstr_claim_base_data.claim_curr)
else
	ads_claims.SetItem(al_row, "curr_code", lstr_claim_base_data.frt_curr_code)
end if

ads_claims.SetItem(al_row, "vessel_nr", astr_poc.vessel_nr)
ads_claims.SetItem(al_row, "voyage_nr", astr_poc.voyage_nr)
ads_claims.SetItem(al_row, "chart_nr", li_chart_nr)
ads_claims.SetItem(al_row, "claim_type", 'HEA')
ads_claims.SetItem(al_row, "claim_nr", astr_poc.claim_nr)

ads_claims.SetItem(al_row, "chart_chart_n_1", ls_chart_name)

setnull(ld_discharge_date)
SELECT MAX(PORT_DEPT_DT)
  INTO :ld_discharge_date
  FROM POC
 WHERE VESSEL_NR = :astr_poc.vessel_nr
   AND VOYAGE_NR = :astr_poc.voyage_nr
 USING sqlca;

//if departure date doesn't exist in the POC, the claims discharge date is set as the message sent date.
if isnull(ld_discharge_date) then
	ld_discharge_date = adw_msps_heating.getitemdatetime(1, "sent_date_utc")
end if

SELECT OFFICE_SN
  INTO :ls_office_sn
  FROM OFFICES
 WHERE OFFICE_NR = :lstr_claim_base_data.office_nr
 USING sqlca;

ads_claims.setitem(al_row, "discharge_date", date(ld_discharge_date))
ads_claims.setitem(al_row, "cp_date", lstr_claim_base_data.cp_date)
ads_claims.setitem(al_row, "cp_text", lstr_claim_base_data.cp_text)
ads_claims.setitem(al_row, "timebar_days", lstr_claim_base_data.timebar_days)
ads_claims.setitem(al_row, "notice_days", lstr_claim_base_data.noticebar_days)
ads_claims.setitem(al_row, "claims_laycan_start", lstr_claim_base_data.laycan_start)
ads_claims.setitem(al_row, "claims_laycan_end", lstr_claim_base_data.laycan_end)
ads_claims.setitem(al_row, "claims_address_com", lstr_claim_base_data.address_com)
ads_claims.setitem(al_row, "office_nr", lstr_claim_base_data.office_nr)
ads_claims.setitem(al_row, "offices_office_sn", ls_office_sn)
ads_claims.setitem(al_row, "msps_tfv", 1)
ads_claims.setitem(1, "timebar_date", relativedate(date(ld_discharge_date), lstr_claim_base_data.timebar_days))
ldc_amount = ads_heating_price.getitemnumber(ads_heating_price.getrow(), "hea_dev_amount")
ads_claims.setitem(al_row, "claim_amount", ldc_amount)

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   n_approve_heating
   <OBJECT>		Approve heating	</OBJECT>
   <USAGE></USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	29/07/2013 CR3238       LHG008        Fix bug for departure date
		20/04/2016 CR2428       SSX014        Change currency code refrerence
   </HISTORY>
********************************************************************/
end subroutine

on n_approve_heating.create
call super::create
end on

on n_approve_heating.destroy
call super::destroy
end on

event constructor;call super::constructor;//Bunker component
inv_departure_bunker = create n_port_departure_bunker_value
//Departure bunker FIFO detail
ids_departure_bunker_detail = create mt_n_datastore
//current voyage lifted bunker
ids_bunker_lifted_bunker = create mt_n_datastore

ids_departure_bunker_detail.dataobject = "d_sq_cm_bunker_dept_value"
ids_bunker_lifted_bunker.dataobject='d_sq_ff_lifted_bunker'
end event

event destructor;call super::destructor;destroy	inv_departure_bunker
destroy	ids_departure_bunker_detail
end event

