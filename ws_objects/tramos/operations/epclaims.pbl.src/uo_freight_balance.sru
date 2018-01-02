$PBExportHeader$uo_freight_balance.sru
$PBExportComments$Claculate Freight Claims Balance - Visual
forward
global type uo_freight_balance from mt_u_visualobject
end type
type st_balance from statictext within uo_freight_balance
end type
type st_received from statictext within uo_freight_balance
end type
type st_net_freight from statictext within uo_freight_balance
end type
type st_addr_comm from statictext within uo_freight_balance
end type
type st_freight from statictext within uo_freight_balance
end type
type st_dead_freight from statictext within uo_freight_balance
end type
type st_overage from statictext within uo_freight_balance
end type
type st_base_freight from statictext within uo_freight_balance
end type
type st_8 from statictext within uo_freight_balance
end type
type st_7 from statictext within uo_freight_balance
end type
type st_6 from statictext within uo_freight_balance
end type
type st_5 from statictext within uo_freight_balance
end type
type st_4 from statictext within uo_freight_balance
end type
type st_3 from statictext within uo_freight_balance
end type
type st_2 from statictext within uo_freight_balance
end type
type st_1 from statictext within uo_freight_balance
end type
type ln_1 from line within uo_freight_balance
end type
type ln_2 from line within uo_freight_balance
end type
type ln_3 from line within uo_freight_balance
end type
end forward

global type uo_freight_balance from mt_u_visualobject
integer width = 791
integer height = 652
boolean border = true
long backcolor = 81324524
st_balance st_balance
st_received st_received
st_net_freight st_net_freight
st_addr_comm st_addr_comm
st_freight st_freight
st_dead_freight st_dead_freight
st_overage st_overage
st_base_freight st_base_freight
st_8 st_8
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
end type
global uo_freight_balance uo_freight_balance

type variables
double id_ws, id_ws_rate, id_per_mt, id_addr_com_pct,id_main_lumpsum, id_lumpsum[]
double id_min1, id_min2,id_bol_quantity
double id_overage1, id_overage2, id_balance, id_received
double id_base_freight, id_overage, id_dead_freight, id_freight, id_addr_com, id_net_freight
boolean ib_lumpsum_commission
string  is_lumpsum_comment[]
boolean ib_reload = false
boolean ib_reload_revised = false


end variables

forward prototypes
public subroutine uf_set_empty ()
public function decimal uf_get_freight ()
public function decimal uf_calculate_balance (integer vessel_nr, string voyage_nr, integer chart_nr, integer claim_nr)
public function decimal uf_get_addrcomm ()
public function decimal uf_get_bol_quantity (long al_vessel_nr, string as_voyage_nr, long al_chart_nr)
public function decimal uf_get_max_bol_quantity_departure (long al_vessel_nr, string as_voyage_nr, long al_chart_nr)
public function integer uf_get_calc_freight_type (long al_vessel_nr, string as_voyage_nr, long al_chart_nr, long al_claim_nr)
public subroutine uf_set_bol_quantity_reload (boolean ab_reload_revised, boolean ab_reload)
public subroutine documentation ()
end prototypes

public subroutine uf_set_empty ();st_base_freight.text = ""
st_overage.text = ""
st_dead_freight.text = ""
st_freight.text = ""
st_addr_comm.text = ""
st_net_freight.text = ""
st_received.text = ""
st_balance.text = ""
end subroutine

public function decimal uf_get_freight ();Return id_freight
end function

public function decimal uf_calculate_balance (integer vessel_nr, string voyage_nr, integer chart_nr, integer claim_nr);mt_n_datastore	lds_add_lumpsums
integer	li_add_lump, li_reload = 0
double	ld_addr_comm, ld_lumpsum_single, ld_empty[]
string 	ls_empty[]

lds_add_lumpsums = create mt_n_datastore
lds_add_lumpsums.dataobject = "d_sq_tb_add_lumpsums"
lds_add_lumpsums.settransobject( SQLCA)
lds_add_lumpsums.retrieve(vessel_nr, voyage_nr, chart_nr, claim_nr)

if vessel_nr = 0 then
	id_ws=0
	id_ws_rate=0
	id_per_mt=0
	id_main_lumpsum=0
	id_lumpsum = ld_empty
	id_min1=0
	id_min2=0
	id_overage1=0
	id_overage2=0
end if

SELECT 	FREIGHT_WS,
			FREIGHT_WS_RATE,
			FREIGHT_PER_MTS,
			FREIGHT_MAIN_LUMPSUM,
			FREIGHT_MIN_1,
			FREIGHT_MIN_2,
			FREIGHT_OVERAGE_1,
			FREIGHT_OVERAGE_2,
			FREIGHT_RELOAD
	INTO	:id_ws, 
			:id_ws_rate,
			:id_per_mt,
			:id_main_lumpsum,
			:id_min1,
			:id_min2,
			:id_overage1,
			:id_overage2,
			:li_reload
	FROM 	FREIGHT_CLAIMS
	WHERE 	VESSEL_NR = :vessel_nr
	AND 	VOYAGE_NR = :voyage_nr
	AND 	CHART_NR = :chart_nr
	AND 	CLAIM_NR = :claim_nr
	USING SQLCA;

	SELECT ADDRESS_COM
	INTO :id_addr_com_pct
	FROM CLAIMS
	WHERE 	VESSEL_NR = :vessel_nr
		AND VOYAGE_NR = :voyage_nr
		AND CHART_NR = :chart_nr
		AND CLAIM_NR = :claim_nr
	USING SQLCA;

if ib_reload_revised then
	if ib_reload then
		id_bol_quantity = this.uf_get_max_bol_quantity_departure(vessel_nr, voyage_nr, chart_nr)
	else
		id_bol_quantity = this.uf_get_bol_quantity(vessel_nr, voyage_nr, chart_nr)
	end if
elseif li_reload = 1 then
	id_bol_quantity = this.uf_get_max_bol_quantity_departure(vessel_nr, voyage_nr, chart_nr)
else
	id_bol_quantity = this.uf_get_bol_quantity(vessel_nr, voyage_nr, chart_nr)
end if

SELECT SUM(FREIGHT_RECEIVED_LOCAL_CURR)
  INTO :id_received 
  FROM FREIGHT_RECEIVED
 WHERE VESSEL_NR = :vessel_nr
   AND VOYAGE_NR = :voyage_nr
   AND CHART_NR = :chart_nr
   AND CLAIM_NR = :claim_nr
   AND TRANS_CODE <> 'C'
 USING SQLCA;

if not isnull(id_ws) then
/* WS Filled in */
	if isnull(id_min2) and isnull(id_min1) then
		/* Min_1 og Min_2 ikke indtastet */
		id_base_freight = id_bol_quantity * (id_ws / 100) * id_ws_rate
		id_overage = 0
		id_dead_freight = 0
	elseif isnull(id_min2) then
		/* Min_2 ikke indtastet */
		if id_bol_quantity >= id_min1 then
			id_base_freight = id_min1 * (id_ws / 100) * id_ws_rate
			id_overage = (id_bol_quantity - id_min1) * (id_overage1 * id_ws / 10000) * id_ws_rate
			id_dead_freight = 0
		else
			id_base_freight = id_bol_quantity * (id_ws / 100) * id_ws_rate
			id_overage = 0
			id_dead_freight = (id_min1 - id_bol_quantity) * (id_ws / 100) * id_ws_rate
		end if
	else
		if id_bol_quantity >= id_min2 then
			id_base_freight = id_min1 * (id_ws / 100) * id_ws_rate
			id_overage = (id_bol_quantity - id_min2) * (id_overage2 * id_ws / 10000) * id_ws_rate  &
							+(id_min2 - id_min1) * (id_overage1 * id_ws / 10000) * id_ws_rate
			id_dead_freight = 0
	elseif id_bol_quantity >= id_min1 then
			id_base_freight = id_min1 * (id_ws / 100) * id_ws_rate
			id_overage = (id_bol_quantity - id_min1) * (id_overage1 * id_ws /10000) * id_ws_rate 
			id_dead_freight = 0
		else
			id_base_freight = id_bol_quantity * (id_ws / 100) * id_ws_rate
			id_overage = 0
			id_dead_freight = (id_min1 - id_bol_quantity) * (id_ws / 100) * id_ws_rate
		end if	
	end if		
elseif not isnull(id_per_mt) then
/* Per mt filled in */
	if isnull(id_min2) and isnull(id_min1) then
		/* Min_1 og Min_2 ikke indtastet */
		id_base_freight = id_bol_quantity * id_per_mt
		id_overage = 0
		id_dead_freight = 0
	elseif isnull(id_min2) then
		/* Min_2 ikke indtastet */
		if id_bol_quantity >= id_min1 then
			id_base_freight = id_min1 * id_per_mt
			id_overage = (id_bol_quantity - id_min1) * (id_overage1 * id_per_mt / 100)
			id_dead_freight = 0
		else
			id_base_freight = id_bol_quantity * id_per_mt
			id_overage = 0
			id_dead_freight = (id_min1 - id_bol_quantity) * id_per_mt
		end if
	else
		if id_bol_quantity >= id_min2 then
			id_base_freight = id_min1 * id_per_mt
			id_overage = (id_bol_quantity - id_min2) * (id_overage2 * id_per_mt / 100)  &
							+(id_min2 - id_min1) * (id_overage1 * id_per_mt / 100) 
			id_dead_freight = 0
		elseif id_bol_quantity >= id_min1 then
			id_base_freight = id_min1 * id_per_mt
			id_overage = (id_bol_quantity - id_min1) * (id_overage1 * id_per_mt /100) 
			id_dead_freight = 0
		else
			id_base_freight = id_bol_quantity * id_per_mt
			id_overage = 0
			id_dead_freight = (id_min1 - id_bol_quantity) * id_per_mt
		end if	
	end if		
elseif not isnull(id_main_lumpsum) then
/* lumpsum filled in */
	/* base freight */
	id_base_freight = id_main_lumpsum
	/* overage */
	id_overage = 0
	/* dead freight */
	id_dead_freight = 0
else
	/* base freight */
	id_base_freight = 0
	/* overage */
	id_overage = 0
	/* dead freight */
	id_dead_freight = 0
end if

id_lumpsum = ld_empty
is_lumpsum_comment = ls_empty
if not isnull(id_main_lumpsum) then
	for li_add_lump = 1 to lds_add_lumpsums.rowcount( )
		ld_lumpsum_single =  lds_add_lumpsums.getitemnumber(li_add_lump, "add_lumpsums")
		id_lumpsum[li_add_lump] = lds_add_lumpsums.getitemnumber(li_add_lump, "add_lumpsums")
		is_lumpsum_comment[li_add_lump] = lds_add_lumpsums.getitemstring(li_add_lump, "comment")
		if not isnull(id_lumpsum) then
			id_base_freight += ld_lumpsum_single
		end if
	next
end if

if isnull(id_base_freight) then id_base_freight = 0
if isnull(id_overage) then id_overage = 0
if isnull(id_dead_freight) then id_dead_freight = 0
id_freight = id_base_freight + id_overage + id_dead_freight

if isnull(id_addr_com_pct) then
	id_addr_com = 0
else
	ld_addr_comm = id_freight
	for li_add_lump = 1 to lds_add_lumpsums.rowcount( )
		ld_lumpsum_single = lds_add_lumpsums.getitemnumber(li_add_lump, "add_lumpsums")
		IF not isnull(id_lumpsum) and lds_add_lumpsums.getitemnumber(li_add_lump, "adr_comm") = 0 then
			ld_addr_comm -= ld_lumpsum_single
		end if
	next
	id_addr_com = ld_addr_comm * (id_addr_com_pct / 100)
end if

id_net_freight = dec(string(id_freight, "0.00")) - dec(string(id_addr_com,"0.00"))
if isnull(id_received) then id_received = 0
id_balance = round(id_net_freight - dec(string(id_received, "0.00")), 2)

st_base_freight.text = string(Round(id_base_freight,2),"#,##0.00")
st_overage.text = string(Round(id_overage,2),"#,##0.00")
st_dead_freight.text = string(Round(id_dead_freight,2),"#,##0.00")
st_freight.text = string(Round(id_freight,2),"#,##0.00")
st_addr_comm.text = string(Round(id_addr_com,2),"#,##0.00")
st_net_freight.text = string(Round(id_net_freight,2),"#,##0.00")
st_received.text = string(Round(id_received,2),"#,##0.00")
st_balance.text = string(Round(id_balance,2),"#,##0.00")

return(id_balance)

		
end function

public function decimal uf_get_addrcomm ();return id_addr_com
end function

public function decimal uf_get_bol_quantity (long al_vessel_nr, string as_voyage_nr, long al_chart_nr);/********************************************************************
   uf_get_bol_quantity
   <DESC> get bol quantity	</DESC>
   <RETURN>	decimal </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
		al_chart_nr
   </ARGS>
   <USAGE> call from 1: this.uf_calculate_balance() 
	                  2: w_claims.dw_list_claims.clicked() 
							3: w_claims.dw_freight_claims.itemchanged()
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22/02/2012 M5-6         LGX001        First Version
   </HISTORY>
********************************************************************/
dec ld_bol_quantity = 0

SELECT SUM(BOL_QUANTITY) INTO :ld_bol_quantity FROM BOL 
WHERE VESSEL_NR  = :al_vessel_nr 
	AND VOYAGE_NR = :as_voyage_nr
	AND CHART_NR  = :al_chart_nr
	AND	L_D     = 1
	USING SQLCA;

return ld_bol_quantity
end function

public function decimal uf_get_max_bol_quantity_departure (long al_vessel_nr, string as_voyage_nr, long al_chart_nr);/********************************************************************
   wf_get_max_bol_quantity_departure
   <DESC>	When the checkbox 'Reload' is checked in the claims window,
	         the freight claims amount would be recalculated with the max bol quantity when departuring
	</DESC>
   <RETURN>	decimal </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
		al_chart_nr
   </ARGS>
   <USAGE> call from 1: this.uf_calculate_balance() 
	                  2: w_claims.dw_list_claims.clicked() 
							3: w_claims.dw_freight_claims.itemchanged()
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13/02/2012 M5-6         LGX001        First Version
   </HISTORY>
********************************************************************/
long ll_row, ll_rowcount
dec  ld_max_quantity_departure, ld_port_quantity_difference, ld_port_quantity_departure 

n_ds lds_port_bol_quantity

lds_port_bol_quantity = create n_ds
lds_port_bol_quantity.dataobject= "d_sq_tb_port_bol_quantity"
lds_port_bol_quantity.settransobject(sqlca)
ll_rowcount = lds_port_bol_quantity.retrieve(al_vessel_nr, as_voyage_nr, al_chart_nr)

ld_max_quantity_departure = 0 
ld_port_quantity_departure = 0 
for ll_row = 1 to ll_rowcount
	// get quantity difference between Load quantity and discharge quantity at the port 
	ld_port_quantity_difference = lds_port_bol_quantity.getitemdecimal(ll_row, "bol_l_quantity") - lds_port_bol_quantity.getitemdecimal(ll_row, "bol_d_quantity")
	
	ld_port_quantity_departure = ld_port_quantity_departure + ld_port_quantity_difference
	
	if ld_port_quantity_departure > ld_max_quantity_departure then
		ld_max_quantity_departure = ld_port_quantity_departure
	end if
next

destroy lds_port_bol_quantity

if ld_max_quantity_departure = 0 then setnull(ld_max_quantity_departure) 
return ld_max_quantity_departure

end function

public function integer uf_get_calc_freight_type (long al_vessel_nr, string as_voyage_nr, long al_chart_nr, long al_claim_nr);/********************************************************************
   uf_get_calc_freight_type
   <DESC>	get cargo freight type in the calculation	</DESC>
   <RETURN>	integer </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
		al_chart_nr
		al_claim_nr
   </ARGS>
   <USAGE> call from 1: w_claims.dw_list_claims.clicked() </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21/02/2012 M5-6         LGX001        First Version
   </HISTORY>
********************************************************************/
long ll_freight_type = 0	

SELECT TOP 1 CAL_CARG.CAL_CARG_FREIGHT_TYPE
INTO: ll_freight_type
FROM CAL_CARG, CAL_CAIO, VOYAGES, FREIGHT_CLAIMS
WHERE CAL_CARG.CAL_CARG_ID     = CAL_CAIO.CAL_CARG_ID       AND
		CAL_CARG.CAL_CALC_ID     = VOYAGES.CAL_CALC_ID        AND
		CAL_CARG.CAL_CERP_ID     = FREIGHT_CLAIMS.CAL_CERP_ID AND
	   FREIGHT_CLAIMS.VESSEL_NR = VOYAGES.VESSEL_NR          AND 
	   FREIGHT_CLAIMS.VOYAGE_NR = VOYAGES.VOYAGE_NR          AND  
	   FREIGHT_CLAIMS.VESSEL_NR = :al_vessel_nr              AND
	  	FREIGHT_CLAIMS.VOYAGE_NR = :as_voyage_nr              AND
	  	FREIGHT_CLAIMS.CHART_NR  = :al_chart_nr               AND
	  	FREIGHT_CLAIMS.CLAIM_NR  = :al_claim_nr;	
		  
return ll_freight_type
end function

public subroutine uf_set_bol_quantity_reload (boolean ab_reload_revised, boolean ab_reload);/********************************************************************
   uf_set_bol_quantity_reload
   <DESC> set bol quantity flag	</DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_reload_revised
		ab_reload
   </ARGS>
   <USAGE>	call from 1: w_claims.dw_freight_claims.itemchanged()
	                      ib_reload_revised always set to true
	  				   else: always set ib_reload_revise = false 	
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/02/2012 M5-6         LGX001        First Version
   </HISTORY>
********************************************************************/

ib_reload_revised = ab_reload_revised
ib_reload = ab_reload
end subroutine

public subroutine documentation ();/********************************************************************
   uo_freight_balance
   <OBJECT> uo_freight_balance </OBJECT>
   <USAGE> Use to calculate and show FRT balance in w_claims window </USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
		Date     CR-Ref         Author   Comments
		??/??/?? ???            ???      First Version
		29/09/15 CR3778         LHG008   Add Transaction C in Actions/Transactions window for FRT claims.
   </HISTORY>
********************************************************************/
end subroutine

on uo_freight_balance.create
int iCurrent
call super::create
this.st_balance=create st_balance
this.st_received=create st_received
this.st_net_freight=create st_net_freight
this.st_addr_comm=create st_addr_comm
this.st_freight=create st_freight
this.st_dead_freight=create st_dead_freight
this.st_overage=create st_overage
this.st_base_freight=create st_base_freight
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_balance
this.Control[iCurrent+2]=this.st_received
this.Control[iCurrent+3]=this.st_net_freight
this.Control[iCurrent+4]=this.st_addr_comm
this.Control[iCurrent+5]=this.st_freight
this.Control[iCurrent+6]=this.st_dead_freight
this.Control[iCurrent+7]=this.st_overage
this.Control[iCurrent+8]=this.st_base_freight
this.Control[iCurrent+9]=this.st_8
this.Control[iCurrent+10]=this.st_7
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.st_2
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.ln_1
this.Control[iCurrent+18]=this.ln_2
this.Control[iCurrent+19]=this.ln_3
end on

on uo_freight_balance.destroy
call super::destroy
destroy(this.st_balance)
destroy(this.st_received)
destroy(this.st_net_freight)
destroy(this.st_addr_comm)
destroy(this.st_freight)
destroy(this.st_dead_freight)
destroy(this.st_overage)
destroy(this.st_base_freight)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
end on

type st_balance from statictext within uo_freight_balance
integer x = 338
integer y = 564
integer width = 421
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type st_received from statictext within uo_freight_balance
integer x = 338
integer y = 484
integer width = 421
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type st_net_freight from statictext within uo_freight_balance
integer x = 338
integer y = 404
integer width = 421
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type st_addr_comm from statictext within uo_freight_balance
integer x = 338
integer y = 324
integer width = 421
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type st_freight from statictext within uo_freight_balance
integer x = 338
integer y = 244
integer width = 421
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type st_dead_freight from statictext within uo_freight_balance
integer x = 338
integer y = 164
integer width = 421
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type st_overage from statictext within uo_freight_balance
integer x = 338
integer y = 84
integer width = 421
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type st_base_freight from statictext within uo_freight_balance
integer x = 338
integer y = 4
integer width = 421
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type st_8 from statictext within uo_freight_balance
integer x = 18
integer y = 564
integer width = 247
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Balance"
boolean focusrectangle = false
end type

type st_7 from statictext within uo_freight_balance
integer x = 18
integer y = 484
integer width = 247
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Received"
boolean focusrectangle = false
end type

type st_6 from statictext within uo_freight_balance
integer x = 18
integer y = 404
integer width = 283
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Net Freight"
boolean focusrectangle = false
end type

type st_5 from statictext within uo_freight_balance
integer x = 18
integer y = 324
integer width = 306
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Addr comm"
boolean focusrectangle = false
end type

type st_4 from statictext within uo_freight_balance
integer x = 18
integer y = 244
integer width = 247
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Freight"
boolean focusrectangle = false
end type

type st_3 from statictext within uo_freight_balance
integer x = 18
integer y = 164
integer width = 325
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Dead Freight"
boolean focusrectangle = false
end type

type st_2 from statictext within uo_freight_balance
integer x = 18
integer y = 84
integer width = 247
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Overage"
boolean focusrectangle = false
end type

type st_1 from statictext within uo_freight_balance
integer x = 18
integer y = 4
integer width = 325
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Base Freight"
boolean focusrectangle = false
end type

type ln_1 from line within uo_freight_balance
integer linethickness = 5
integer beginx = 18
integer beginy = 236
integer endx = 773
integer endy = 236
end type

type ln_2 from line within uo_freight_balance
integer linethickness = 5
integer beginx = 18
integer beginy = 476
integer endx = 773
integer endy = 476
end type

type ln_3 from line within uo_freight_balance
integer linethickness = 5
integer beginx = 18
integer beginy = 548
integer endx = 773
integer endy = 548
end type

