$PBExportHeader$uo_afc_freight_balance.sru
$PBExportComments$Calculate Balance for Freight Claims
forward
global type uo_afc_freight_balance from userobject
end type
type st_balance from statictext within uo_afc_freight_balance
end type
type st_received from statictext within uo_afc_freight_balance
end type
type st_net_freight from statictext within uo_afc_freight_balance
end type
type st_addr_comm from statictext within uo_afc_freight_balance
end type
type st_freight from statictext within uo_afc_freight_balance
end type
type st_dead_freight from statictext within uo_afc_freight_balance
end type
type st_overage from statictext within uo_afc_freight_balance
end type
type st_base_freight from statictext within uo_afc_freight_balance
end type
type st_8 from statictext within uo_afc_freight_balance
end type
type st_7 from statictext within uo_afc_freight_balance
end type
type st_6 from statictext within uo_afc_freight_balance
end type
type st_5 from statictext within uo_afc_freight_balance
end type
type st_4 from statictext within uo_afc_freight_balance
end type
type st_3 from statictext within uo_afc_freight_balance
end type
type st_2 from statictext within uo_afc_freight_balance
end type
type st_1 from statictext within uo_afc_freight_balance
end type
type ln_1 from line within uo_afc_freight_balance
end type
type ln_2 from line within uo_afc_freight_balance
end type
type ln_3 from line within uo_afc_freight_balance
end type
end forward

global type uo_afc_freight_balance from userobject
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
global uo_afc_freight_balance uo_afc_freight_balance

type variables
//decimal {2} id_ws, id_ws_rate, id_per_mt, id_lumpsum, id_addr_com_pct,id_main_lumpsum
//decimal {3} id_min1, id_min2, id_bol_quantity
//decimal {2} id_overage1, id_overage2, id_received
//decimal {2} id_base_freight, id_overage, id_dead_freight, id_freight, id_addr_com, id_net_freight, id_balance
double id_ws, id_ws_rate, id_per_mt, id_lumpsum[], id_addr_com_pct,id_main_lumpsum
double id_min1, id_min2, id_bol_quantity
double id_overage1, id_overage2, id_received
double id_base_freight, id_overage, id_dead_freight, id_freight, id_addr_com, id_net_freight, id_balance
boolean ib_lumpsum_commission
string   is_lumpsum_comment[]
end variables

forward prototypes
public function decimal uf_get_freight ()
public function decimal uf_calculate_balance (integer vessel_nr, string voyage_nr, integer chart_nr, integer claim_nr, integer afc_nr)
public subroutine uf_set_empty ()
end prototypes

public function decimal uf_get_freight ();Return id_freight
end function

public function decimal uf_calculate_balance (integer vessel_nr, string voyage_nr, integer chart_nr, integer claim_nr, integer afc_nr);Boolean  lb_found = TRUE
n_ds	lds_add_lumpsums
integer	li_add_lump
double	ld_addr_comm, ld_lumpsum_single, ld_empty[]
string		ls_empty[]

lds_add_lumpsums = create n_ds
lds_add_lumpsums.dataobject = "d_sq_tb_add_lumpsums_afc"
lds_add_lumpsums.settransobject( SQLCA)
lds_add_lumpsums.retrieve(vessel_nr, voyage_nr, chart_nr, claim_nr, afc_nr)

SELECT ADDRESS_COM
INTO :id_addr_com_pct
FROM CLAIMS
WHERE 	VESSEL_NR = :vessel_nr
		AND VOYAGE_NR = :voyage_nr
		AND CHART_NR = :chart_nr
		AND CLAIM_NR = :claim_nr
USING SQLCA;
COMMIT USING SQLCA;

SELECT 		AFC_WS,
			AFC_WS_RATE,
			AFC_PER_MTS,
			AFC_MAIN_LUMPSUM,
			AFC_MIN_1,
			AFC_MIN_2,
			AFC_OVERAGE_1,
			AFC_OVERAGE_2
	INTO		:id_ws, 
			:id_ws_rate,
			:id_per_mt,
			:id_main_lumpsum,
			:id_min1,
			:id_min2,
			:id_overage1,
			:id_overage2
	FROM 	FREIGHT_ADVANCED
	WHERE 	VESSEL_NR = :vessel_nr
	AND 	VOYAGE_NR = :voyage_nr
	AND 	CHART_NR = :chart_nr
	AND 	CLAIM_NR = :claim_nr
	AND        AFC_NR = :afc_nr
USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN lb_found = FALSE
COMMIT USING SQLCA;

SELECT 		AFC_BOL_QUANTITY
	INTO		:id_bol_quantity 
	FROM 	FREIGHT_ADVANCED
	WHERE 	VESSEL_NR = :vessel_nr
	AND 	VOYAGE_NR = :voyage_nr
	AND 	CHART_NR = :chart_nr
	AND 	CLAIM_NR = :claim_nr
	AND         AFC_NR = :afc_nr
USING SQLCA;
COMMIT USING SQLCA;

SELECT 		SUM(AFC_RECEIVED_LOCAL_CURR)
	INTO		:id_received 
	FROM 	FREIGHT_ADVANCED_RECIEVED
	WHERE 	VESSEL_NR = :vessel_nr
	AND 	VOYAGE_NR = :voyage_nr
	AND 	CHART_NR = :chart_nr
	AND 	CLAIM_NR = :claim_nr
	AND         AFC_NR = :afc_nr
USING SQLCA;
COMMIT USING SQLCA;

IF Not IsNull(id_ws) THEN
/* WS Filled in */
	IF Isnull(id_min2) AND Isnull(id_min1) THEN
		/* Min_1 og Min_2 ikke indtastet */
		id_base_freight = id_bol_quantity * (id_ws / 100) * id_ws_rate
		id_overage = 0
		id_dead_freight = 0
	ELSEIF IsNull(id_min2) THEN
		/* Min_2 ikke indtastet */
		IF id_bol_quantity >= id_min1 THEN
			id_base_freight = id_min1 * (id_ws / 100) * id_ws_rate
			id_overage = (id_bol_quantity - id_min1) * (id_overage1 * id_ws / 10000) * id_ws_rate
			id_dead_freight = 0
		ELSE
			id_base_freight = id_bol_quantity * (id_ws / 100) * id_ws_rate
			id_overage = 0
			id_dead_freight = (id_min1 - id_bol_quantity) * (id_ws / 100) * id_ws_rate
		END IF
	ELSE
		IF id_bol_quantity >= id_min2 THEN
			id_base_freight = id_min1 * (id_ws / 100) * id_ws_rate
			id_overage = (id_bol_quantity - id_min2) * (id_overage2 * id_ws / 10000) * id_ws_rate  &
							+(id_min2 - id_min1) * (id_overage1 * id_ws / 10000) * id_ws_rate
			id_dead_freight = 0
	ELSEIF id_bol_quantity >= id_min1 THEN
			id_base_freight = id_min1 * (id_ws / 100) * id_ws_rate
			id_overage = (id_bol_quantity - id_min1) * (id_overage1 * id_ws /10000) * id_ws_rate 
			id_dead_freight = 0
		ELSE
			id_base_freight = id_bol_quantity * (id_ws / 100) * id_ws_rate
			id_overage = 0
			id_dead_freight = (id_min1 - id_bol_quantity) * (id_ws / 100) * id_ws_rate
		END IF	
	END IF		
ELSEIF Not IsNull(id_per_mt) THEN
/* Per mt filled in */
	IF Isnull(id_min2) AND Isnull(id_min1) THEN
		/* Min_1 og Min_2 ikke indtastet */
		id_base_freight = id_bol_quantity * id_per_mt
		id_overage = 0
		id_dead_freight = 0
	ELSEIF IsNull(id_min2) THEN
		/* Min_2 ikke indtastet */
		IF id_bol_quantity >= id_min1 THEN
			id_base_freight = id_min1 * id_per_mt
			id_overage = (id_bol_quantity - id_min1) * (id_overage1 * id_per_mt / 100)
			id_dead_freight = 0
		ELSE
			id_base_freight = id_bol_quantity * id_per_mt
			id_overage = 0
			id_dead_freight = (id_min1 - id_bol_quantity) * id_per_mt
		END IF
	ELSE
		IF id_bol_quantity >= id_min2 THEN
			id_base_freight = id_min1 * id_per_mt
			id_overage = (id_bol_quantity - id_min2) * (id_overage2 * id_per_mt / 100)  &
							+(id_min2 - id_min1) * (id_overage1 * id_per_mt / 100) 
			id_dead_freight = 0
		ELSEIF id_bol_quantity >= id_min1 THEN
			id_base_freight = id_min1 * id_per_mt
			id_overage = (id_bol_quantity - id_min1) * (id_overage1 * id_per_mt /100) 
			id_dead_freight = 0
		ELSE
			id_base_freight = id_bol_quantity * id_per_mt
			id_overage = 0
			id_dead_freight = (id_min1 - id_bol_quantity) * id_per_mt
		END IF	
	END IF		
ELSEIF Not Isnull(id_main_lumpsum) THEN
/* Lumpsum filled in */
	/* Base Freight */
	id_base_freight = id_main_lumpsum
	/* Overage */
	id_overage = 0
	/* Dead Freight */
	id_dead_freight = 0
ELSE
	/* Base Freight */
	id_base_freight = 0
	/* Overage */
	id_overage = 0
	/* Dead Freight */
	id_dead_freight = 0
END IF

id_lumpsum = ld_empty
is_lumpsum_comment = ls_empty
IF Not Isnull(id_main_lumpsum) THEN
	FOR li_add_lump = 1 TO lds_add_lumpsums.rowcount( )
		ld_lumpsum_single =  lds_add_lumpsums.getitemnumber(li_add_lump, "add_lumpsums")
		id_lumpsum[li_add_lump] = lds_add_lumpsums.getitemnumber(li_add_lump, "add_lumpsums")
		if isnull(lds_add_lumpsums.getitemstring(li_add_lump, "comment")) then  lds_add_lumpsums.setitem(li_add_lump, "comment", "")
		is_lumpsum_comment[li_add_lump] = lds_add_lumpsums.getitemstring(li_add_lump, "comment")
		IF not isnull(id_lumpsum) THEN
			id_base_freight += ld_lumpsum_single
		END IF
	NEXT
END IF

IF IsNull(id_base_freight) THEN id_base_freight = 0
IF IsNull(id_overage) THEN id_overage = 0
IF IsNull(id_dead_freight) THEN id_dead_freight = 0
id_freight = id_base_freight + id_overage + id_dead_freight
IF IsNull(id_addr_com_pct) THEN
	id_addr_com = 0
ELSE
ld_addr_comm = id_freight
FOR li_add_lump = 1 TO lds_add_lumpsums.rowcount( )
	ld_lumpsum_single = lds_add_lumpsums.getitemnumber(li_add_lump, "add_lumpsums")
	IF not isnull(id_lumpsum) and lds_add_lumpsums.getitemnumber(li_add_lump, "adr_comm") = 0 THEN
		ld_addr_comm -= ld_lumpsum_single
	END IF
NEXT
id_addr_com = ld_addr_comm * (id_addr_com_pct / 100)
END IF
id_net_freight = dec(string(id_freight,"0.00")) - dec(string(id_addr_com, "0.00"))
IF IsNull(id_received) THEN id_received = 0
id_balance = round(id_net_freight - dec(string(id_received, "0.00")), 2)

IF lb_found = TRUE THEN
	st_base_freight.text = string(id_base_freight,"#,##0.00")
	st_overage.text = string(id_overage,"#,##0.00")
	st_dead_freight.text = string(id_dead_freight,"#,##0.00")
	st_freight.text = string(id_freight,"#,##0.00")
	st_addr_comm.text = string(id_addr_com,"#,##0.00")
	st_net_freight.text = string(id_net_freight,"#,##0.00")
	st_received.text = string(id_received,"#,##0.00")
	st_balance.text = string(id_balance,"#,##0.00")
ELSE
	st_base_freight.text = ""
	st_overage.text = ""
	st_dead_freight.text = ""
	st_freight.text = ""
	st_addr_comm.text = ""
	st_net_freight.text = ""
	st_received.text = ""
	st_balance.text = ""
END IF

return(id_balance)

		
end function

public subroutine uf_set_empty ();st_base_freight.text = ""
st_overage.text = ""
st_dead_freight.text = ""
st_freight.text = ""
st_addr_comm.text = ""
st_net_freight.text = ""
st_received.text = ""
st_balance.text = ""
end subroutine

on uo_afc_freight_balance.create
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
this.Control[]={this.st_balance,&
this.st_received,&
this.st_net_freight,&
this.st_addr_comm,&
this.st_freight,&
this.st_dead_freight,&
this.st_overage,&
this.st_base_freight,&
this.st_8,&
this.st_7,&
this.st_6,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.ln_1,&
this.ln_2,&
this.ln_3}
end on

on uo_afc_freight_balance.destroy
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

type st_balance from statictext within uo_afc_freight_balance
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

type st_received from statictext within uo_afc_freight_balance
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

type st_net_freight from statictext within uo_afc_freight_balance
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

type st_addr_comm from statictext within uo_afc_freight_balance
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

type st_freight from statictext within uo_afc_freight_balance
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

type st_dead_freight from statictext within uo_afc_freight_balance
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

type st_overage from statictext within uo_afc_freight_balance
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

type st_base_freight from statictext within uo_afc_freight_balance
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

type st_8 from statictext within uo_afc_freight_balance
integer x = 14
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

type st_7 from statictext within uo_afc_freight_balance
integer x = 14
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

type st_6 from statictext within uo_afc_freight_balance
integer x = 14
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

type st_5 from statictext within uo_afc_freight_balance
integer x = 14
integer y = 324
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Addr com"
boolean focusrectangle = false
end type

type st_4 from statictext within uo_afc_freight_balance
integer x = 14
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

type st_3 from statictext within uo_afc_freight_balance
integer x = 14
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

type st_2 from statictext within uo_afc_freight_balance
integer x = 14
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

type st_1 from statictext within uo_afc_freight_balance
integer x = 14
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

type ln_1 from line within uo_afc_freight_balance
integer linethickness = 5
integer beginx = 18
integer beginy = 236
integer endx = 773
integer endy = 236
end type

type ln_2 from line within uo_afc_freight_balance
integer linethickness = 5
integer beginx = 18
integer beginy = 476
integer endx = 773
integer endy = 476
end type

type ln_3 from line within uo_afc_freight_balance
integer linethickness = 5
integer beginx = 18
integer beginy = 548
integer endx = 773
integer endy = 548
end type

