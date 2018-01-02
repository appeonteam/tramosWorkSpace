$PBExportHeader$u_fin_single_voyage.sru
forward
global type u_fin_single_voyage from userobject
end type
type cb_generateest from mt_u_commandbutton within u_fin_single_voyage
end type
type st_1 from statictext within u_fin_single_voyage
end type
type cb_jump_disbursement from commandbutton within u_fin_single_voyage
end type
type tab_finance from tab within u_fin_single_voyage
end type
type tabpage_poc from userobject within tab_finance
end type
type dw_poc from datawindow within tabpage_poc
end type
type tabpage_poc from userobject within tab_finance
dw_poc dw_poc
end type
type tabpage_frt from userobject within tab_finance
end type
type uo_calcbalance from u_claimbalance within tabpage_frt
end type
type cb_scroll from commandbutton within tabpage_frt
end type
type uo_advancedfreight_calc from uo_afc_freight_balance within tabpage_frt
end type
type uo_freight_calc from uo_freight_balance within tabpage_frt
end type
type dw_frt from datawindow within tabpage_frt
end type
type dw_frt_trans from datawindow within tabpage_frt
end type
type dw_frt_comm from datawindow within tabpage_frt
end type
type tabpage_frt from userobject within tab_finance
uo_calcbalance uo_calcbalance
cb_scroll cb_scroll
uo_advancedfreight_calc uo_advancedfreight_calc
uo_freight_calc uo_freight_calc
dw_frt dw_frt
dw_frt_trans dw_frt_trans
dw_frt_comm dw_frt_comm
end type
type tabpage_claims from userobject within tab_finance
end type
type uo_miscbalance from u_claimbalance within tabpage_claims
end type
type dw_claims from datawindow within tabpage_claims
end type
type dw_claim_trans from datawindow within tabpage_claims
end type
type dw_claim_comm from datawindow within tabpage_claims
end type
type tabpage_claims from userobject within tab_finance
uo_miscbalance uo_miscbalance
dw_claims dw_claims
dw_claim_trans dw_claim_trans
dw_claim_comm dw_claim_comm
end type
type tabpage_bunker from userobject within tab_finance
end type
type dw_bunker from datawindow within tabpage_bunker
end type
type dw_offhire from datawindow within tabpage_bunker
end type
type tabpage_bunker from userobject within tab_finance
dw_bunker dw_bunker
dw_offhire dw_offhire
end type
type tabpage_disbursement from userobject within tab_finance
end type
type st_9 from statictext within tabpage_disbursement
end type
type cb_find_txnumber from commandbutton within tabpage_disbursement
end type
type dw_disb from datawindow within tabpage_disbursement
end type
type cbx_only_port_exp from checkbox within tabpage_disbursement
end type
type tabpage_disbursement from userobject within tab_finance
st_9 st_9
cb_find_txnumber cb_find_txnumber
dw_disb dw_disb
cbx_only_port_exp cbx_only_port_exp
end type
type tabpage_commission from userobject within tab_finance
end type
type dw_comm from datawindow within tabpage_commission
end type
type tabpage_commission from userobject within tab_finance
dw_comm dw_comm
end type
type tabpage_tcin from userobject within tab_finance
end type
type dw_tcperiod from datawindow within tabpage_tcin
end type
type dw_tcbroker from datawindow within tabpage_tcin
end type
type dw_tcin from datawindow within tabpage_tcin
end type
type tabpage_tcin from userobject within tab_finance
dw_tcperiod dw_tcperiod
dw_tcbroker dw_tcbroker
dw_tcin dw_tcin
end type
type tabpage_voyage_notes from userobject within tab_finance
end type
type dw_posted_bunker from datawindow within tabpage_voyage_notes
end type
type dw_voyage_notes from datawindow within tabpage_voyage_notes
end type
type tabpage_voyage_notes from userobject within tab_finance
dw_posted_bunker dw_posted_bunker
dw_voyage_notes dw_voyage_notes
end type
type tab_finance from tab within u_fin_single_voyage
tabpage_poc tabpage_poc
tabpage_frt tabpage_frt
tabpage_claims tabpage_claims
tabpage_bunker tabpage_bunker
tabpage_disbursement tabpage_disbursement
tabpage_commission tabpage_commission
tabpage_tcin tabpage_tcin
tabpage_voyage_notes tabpage_voyage_notes
end type
type dw_charterer from datawindow within u_fin_single_voyage
end type
type gb_1 from groupbox within u_fin_single_voyage
end type
type gb_2 from groupbox within u_fin_single_voyage
end type
end forward

global type u_fin_single_voyage from userobject
integer width = 3941
integer height = 2292
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_generateest cb_generateest
st_1 st_1
cb_jump_disbursement cb_jump_disbursement
tab_finance tab_finance
dw_charterer dw_charterer
gb_1 gb_1
gb_2 gb_2
end type
global u_fin_single_voyage u_fin_single_voyage

type variables
integer ii_vessel_nr
string is_voyage_nr
long il_calc_id
integer ii_maxAFC, ii_currentAFC
end variables

forward prototypes
public subroutine of_setvesselvoyage (integer ai_vesselnr, string as_voyagenr, long ad_calcid)
public subroutine of_retrieve ()
private function integer _generateestimates (integer ai_vesselnr, string as_voyagenr)
private subroutine documentation ()
end prototypes

public subroutine of_setvesselvoyage (integer ai_vesselnr, string as_voyagenr, long ad_calcid);ii_vessel_nr = ai_vesselnr
is_voyage_nr = as_voyagenr
il_calc_id = ad_calcid
return
end subroutine

public subroutine of_retrieve ();dw_charterer.retrieve(il_calc_id)
commit;
tab_finance.TabPostEvent("ue_retrieve")
return
end subroutine

private function integer _generateestimates (integer ai_vesselnr, string as_voyagenr);/********************************************************************
   of_generateestimates( /*integer ai_vesselnr*/, /*string as_voyagenr */)
<DESC>   
	When triggered generates an estimated transaction for current voyage & vessel
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	ai_vesselnr: Vessel Number
	as_voyagenr: Voyage Number
</ARGS>
<USAGE>
	Called from a button
</USAGE>
********************************************************************/

integer li_retval
s_axestimatesvars lstr_app
n_axestimationcontrol	lnv_est

lnv_est = create n_axestimationcontrol
lstr_app.b_client = true
lstr_app.s_estimatetype = "voyage"
lstr_app.i_clientvesselnr = ai_vesselnr
lstr_app.s_clientvoyagenr = as_voyagenr
lstr_app.s_infomessage = "Successfully generated estimated transaction for selected vessel & voyage to send to AX."
li_retval = lnv_est.of_start(lstr_app)
if lstr_app.s_returnmessage<>"" then
	messagebox("Error", "Is not possible to create transaction:" +  lstr_app.s_returnmessage)
end if
	
destroy lnv_est

return li_retval
end function

private subroutine documentation ();/********************************************************************
   ObjectName: documentation
	
   <OBJECT>
		This object is used to display contract and voyage details i n the finance control
		panel. This object is used for allocated voyages.
	</OBJECT>
	
   <USAGE>
	     This is used in the Finance Control Panel.
	</USAGE>

<HISTORY> 
   Date	CR-Ref	 Author	Comments
   00/00/07	?	 Name Here	First Version
   09/03/12	M5-8	AGL027	Add button Generate Estimation Transactions
</HISTORY>    
********************************************************************/
end subroutine

on u_fin_single_voyage.create
this.cb_generateest=create cb_generateest
this.st_1=create st_1
this.cb_jump_disbursement=create cb_jump_disbursement
this.tab_finance=create tab_finance
this.dw_charterer=create dw_charterer
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_generateest,&
this.st_1,&
this.cb_jump_disbursement,&
this.tab_finance,&
this.dw_charterer,&
this.gb_1,&
this.gb_2}
end on

on u_fin_single_voyage.destroy
destroy(this.cb_generateest)
destroy(this.st_1)
destroy(this.cb_jump_disbursement)
destroy(this.tab_finance)
destroy(this.dw_charterer)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event constructor;dw_charterer.setTransObject(SQLCA)
tab_finance.tabpage_poc.dw_poc.setTransObject(SQLCA)
tab_finance.tabpage_frt.dw_frt.setTransObject(SQLCA)
tab_finance.tabpage_frt.dw_frt_trans.setTransObject(SQLCA)
tab_finance.tabpage_frt.dw_frt_comm.setTransObject(SQLCA)
tab_finance.tabpage_claims.dw_claims.setTransObject(SQLCA)
tab_finance.tabpage_claims.dw_claim_trans.setTransObject(SQLCA)
tab_finance.tabpage_claims.dw_claim_comm.setTransObject(SQLCA)
tab_finance.tabpage_bunker.dw_bunker.setTransObject(SQLCA)
tab_finance.tabpage_bunker.dw_offhire.setTransObject(SQLCA)
tab_finance.tabpage_disbursement.dw_disb.setTransObject(SQLCA)
tab_finance.tabpage_commission.dw_comm.setTransObject(SQLCA)
tab_finance.tabpage_tcin.dw_tcin.setTransObject(SQLCA)
tab_finance.tabpage_tcin.dw_tcbroker.setTransObject(SQLCA)
tab_finance.tabpage_tcin.dw_tcperiod.setTransObject(SQLCA)
tab_finance.tabpage_voyage_notes.dw_voyage_notes.settransobject(SQLCA)
tab_finance.tabpage_voyage_notes.dw_posted_bunker.settransobject(SQLCA)




end event

type cb_generateest from mt_u_commandbutton within u_fin_single_voyage
integer x = 3447
integer y = 384
integer taborder = 41
string text = "Generate"
end type

event clicked;call super::clicked;_generateestimates(ii_vessel_nr,is_voyage_nr)
end event

type st_1 from statictext within u_fin_single_voyage
integer x = 3346
integer y = 192
integer width = 530
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "(if no items on tabpage)"
boolean focusrectangle = false
end type

type cb_jump_disbursement from commandbutton within u_fin_single_voyage
integer x = 3447
integer y = 68
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Disbursement"
end type

event clicked;u_jump_disbursement luo_jump_disbursement

luo_jump_disbursement = CREATE u_jump_disbursement
luo_jump_disbursement.of_open_disbursement(ii_vessel_nr, is_voyage_nr)
DESTROY luo_jump_disbursement		

end event

type tab_finance from tab within u_fin_single_voyage
event create ( )
event destroy ( )
event ue_clicked pbm_tcnclicked
integer y = 696
integer width = 3936
integer height = 1584
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_poc tabpage_poc
tabpage_frt tabpage_frt
tabpage_claims tabpage_claims
tabpage_bunker tabpage_bunker
tabpage_disbursement tabpage_disbursement
tabpage_commission tabpage_commission
tabpage_tcin tabpage_tcin
tabpage_voyage_notes tabpage_voyage_notes
end type

on tab_finance.create
this.tabpage_poc=create tabpage_poc
this.tabpage_frt=create tabpage_frt
this.tabpage_claims=create tabpage_claims
this.tabpage_bunker=create tabpage_bunker
this.tabpage_disbursement=create tabpage_disbursement
this.tabpage_commission=create tabpage_commission
this.tabpage_tcin=create tabpage_tcin
this.tabpage_voyage_notes=create tabpage_voyage_notes
this.Control[]={this.tabpage_poc,&
this.tabpage_frt,&
this.tabpage_claims,&
this.tabpage_bunker,&
this.tabpage_disbursement,&
this.tabpage_commission,&
this.tabpage_tcin,&
this.tabpage_voyage_notes}
end on

on tab_finance.destroy
destroy(this.tabpage_poc)
destroy(this.tabpage_frt)
destroy(this.tabpage_claims)
destroy(this.tabpage_bunker)
destroy(this.tabpage_disbursement)
destroy(this.tabpage_commission)
destroy(this.tabpage_tcin)
destroy(this.tabpage_voyage_notes)
end on

type tabpage_poc from userobject within tab_finance
event create ( )
event destroy ( )
event ue_retrieve ( )
integer x = 18
integer y = 104
integer width = 3899
integer height = 1464
long backcolor = 81324524
string text = "Port of Call"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
dw_poc dw_poc
end type

on tabpage_poc.create
this.dw_poc=create dw_poc
this.Control[]={this.dw_poc}
end on

on tabpage_poc.destroy
destroy(this.dw_poc)
end on

event ue_retrieve();this.enabled = dw_poc.retrieve(ii_vessel_nr, is_voyage_nr) > 0
COMMIT;
end event

type dw_poc from datawindow within tabpage_poc
integer width = 3410
integer height = 1456
integer taborder = 10
string title = "none"
string dataobject = "d_fin_port_of_call"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_columnname, ls_agent_sn
long ll_position, ll_row, ll_key
string ls_work
integer li_pcn
string ls_portcode
u_jump_poc luo_jump_poc
u_jump_disbursement luo_jump_disbursement

ls_work = this.getObjectAtPointer()
ll_position = pos(ls_work, "~t")

ls_columnname = left(ls_work, ll_position -1)
ll_row = long(right(ls_work, len(ls_work) - ll_position))

if ll_row < 1 then Return

choose case ls_columnname
	case "agents_agent_sn", "agents_agent_n_1", "agents_nom_acc_nr"
		ll_key = this.getItemNumber(ll_row, "agents_agent_nr")
		if ll_key > 0 then opensheetwithparm(w_agentlist, ll_key, w_tramos_main, 0, original!)
	case "agents_agent_sn_1", "agents_agent_n_1_1", "agents_nom_acc_nr_1"
		ll_key = this.getItemNumber(ll_row, "agents_agent_nr_1")
		if ll_key > 0 then opensheetwithparm(w_agentlist, ll_key, w_tramos_main, 0, original!)
	case "agents_agent_sn_2", "agents_agent_n_1_2", "agents_nom_acc_nr_2"
		ll_key = this.getItemNumber(ll_row, "agents_agent_nr_2")
		if ll_key > 0 then opensheetwithparm(w_agentlist, ll_key, w_tramos_main, 0, original!)
	CASE "poc_port_arr_dt", "poc_port_dept_dt"
		luo_jump_disbursement = CREATE u_jump_disbursement
		ls_portcode = this.getItemString(ll_row, "poc_port_code")
		li_pcn = this.getItemNumber(ll_row, "poc_pcn")
		ls_agent_sn = this.getItemString(ll_row, "agents_agent_sn")
		luo_jump_disbursement.of_open_disbursement(ii_vessel_nr, is_voyage_nr, ls_portcode, li_pcn, ls_agent_sn)
		DESTROY luo_jump_disbursement	
	case else
		luo_jump_poc = CREATE u_jump_poc
		ls_portcode = this.getItemString(ll_row, "poc_port_code")
		li_pcn = this.getItemNumber(ll_row, "poc_pcn")
		luo_jump_poc.of_open_poc(ii_vessel_nr, is_voyage_nr, ls_portcode, li_pcn)
		DESTROY luo_jump_poc		
end choose

end event

type tabpage_frt from userobject within tab_finance
event create ( )
event destroy ( )
event ue_retrieve ( )
integer x = 18
integer y = 104
integer width = 3899
integer height = 1464
long backcolor = 81324524
string text = "Freight"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
uo_calcbalance uo_calcbalance
cb_scroll cb_scroll
uo_advancedfreight_calc uo_advancedfreight_calc
uo_freight_calc uo_freight_calc
dw_frt dw_frt
dw_frt_trans dw_frt_trans
dw_frt_comm dw_frt_comm
end type

on tabpage_frt.create
this.uo_calcbalance=create uo_calcbalance
this.cb_scroll=create cb_scroll
this.uo_advancedfreight_calc=create uo_advancedfreight_calc
this.uo_freight_calc=create uo_freight_calc
this.dw_frt=create dw_frt
this.dw_frt_trans=create dw_frt_trans
this.dw_frt_comm=create dw_frt_comm
this.Control[]={this.uo_calcbalance,&
this.cb_scroll,&
this.uo_advancedfreight_calc,&
this.uo_freight_calc,&
this.dw_frt,&
this.dw_frt_trans,&
this.dw_frt_comm}
end on

on tabpage_frt.destroy
destroy(this.uo_calcbalance)
destroy(this.cb_scroll)
destroy(this.uo_advancedfreight_calc)
destroy(this.uo_freight_calc)
destroy(this.dw_frt)
destroy(this.dw_frt_trans)
destroy(this.dw_frt_comm)
end on

event ue_retrieve();long ll_rows

ll_rows = dw_frt.retrieve(ii_vessel_nr, is_voyage_nr)

if ll_rows > 0 then
	this.enabled = TRUE
	dw_frt.Event Clicked(0,0,1,dw_frt.Object)
else
	dw_frt.reset()
	dw_frt_trans.reset()
	dw_frt_comm.reset()
	uo_freight_calc.uf_calculate_balance(0, "0", 0, 0)
	uo_calcbalance.of_claimbalance(0, "0", 0, 0)	
	this.enabled = FALSE
end if

COMMIT;
end event

type uo_calcbalance from u_claimbalance within tabpage_frt
integer y = 1276
integer taborder = 71
end type

on uo_calcbalance.destroy
call u_claimbalance::destroy
end on

type cb_scroll from commandbutton within tabpage_frt
integer x = 3342
integer y = 1120
integer width = 247
integer height = 72
integer taborder = 61
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "< ? >"
end type

event clicked;long ll_row, ll_chart_nr
integer li_claim_nr

ll_row = dw_frt.getSelectedRow(0)
if ll_row < 1 then return
ll_chart_nr = dw_frt.getItemNumber(ll_row, "claims_chart_nr")
li_claim_nr = dw_frt.getItemNumber(ll_row, "claims_claim_nr")
ii_currentAFC ++
if ii_currentAFC > ii_maxAFC then ii_currentAFC = 1 
cb_scroll.text = "< "+string(ii_currentAFC)+" >"

uo_advancedfreight_calc.uf_calculate_balance(ii_vessel_nr, is_voyage_nr, ll_chart_nr, li_claim_nr, ii_currentAFC)	

end event

type uo_advancedfreight_calc from uo_afc_freight_balance within tabpage_frt
boolean visible = false
integer x = 3045
integer y = 472
integer taborder = 41
end type

on uo_advancedfreight_calc.destroy
call uo_afc_freight_balance::destroy
end on

type uo_freight_calc from uo_freight_balance within tabpage_frt
event destroy ( )
integer x = 3045
integer y = 472
integer taborder = 31
end type

on uo_freight_calc.destroy
call uo_freight_balance::destroy
end on

type dw_frt from datawindow within tabpage_frt
integer width = 3776
integer height = 344
integer taborder = 21
string title = "none"
string dataobject = "d_fin_freight"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer li_claim_nr, li_afc_nr
long ll_chart_nr


if row > 0 then
	this.selectrow(0, FALSE)
	this.selectrow(row, TRUE)
	ll_chart_nr = this.getItemNumber(row, "claims_chart_nr")
	li_claim_nr = this.getItemNumber(row, "claims_claim_nr")
	li_afc_nr = this.getItemNumber(row, "afc")
	if li_afc_nr > 0 then
		uo_freight_calc.visible = false
		uo_advancedfreight_calc.visible = true
		cb_scroll.text = "< 1 >"
		ii_currentAFC = 1
		ii_maxAFC = li_afc_nr
		cb_scroll.visible = true
		uo_advancedfreight_calc.uf_calculate_balance(ii_vessel_nr, is_voyage_nr, ll_chart_nr, li_claim_nr, 1)	
	else
		uo_freight_calc.visible = true
		uo_advancedfreight_calc.visible = false
		cb_scroll.visible = false
		uo_freight_calc.uf_calculate_balance(ii_vessel_nr, is_voyage_nr, ll_chart_nr, li_claim_nr)	
	end if

	uo_calcbalance.of_claimbalance(ii_vessel_nr, is_voyage_nr, ll_chart_nr, li_claim_nr)	
	dw_frt_trans.retrieve(ii_vessel_nr, is_voyage_nr, ll_chart_nr, li_claim_nr)
	dw_frt_comm.retrieve(ii_vessel_nr, is_voyage_nr, ll_chart_nr, li_claim_nr)
end if
end event

event doubleclicked;integer li_claim_nr, li_chart_nr
u_jump_claims luo_jump_claims

if row < 1 then return

li_claim_nr = this.getItemNumber(row, "claims_claim_nr")
li_chart_nr = this.getItemNumber(row, "claims_chart_nr")
luo_jump_claims = CREATE u_jump_claims
luo_jump_claims.of_open_claims(ii_vessel_nr, is_voyage_nr, li_chart_nr, li_claim_nr)
DESTROY luo_jump_claims
end event

type dw_frt_trans from datawindow within tabpage_frt
integer y = 364
integer width = 2373
integer height = 432
integer taborder = 31
string title = "none"
string dataobject = "d_fin_frt_trans"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;integer li_claim_nr, li_chart_nr
u_jump_claims luo_jump_claims
u_jump_actions_trans luo_jump_actions_trans

if row < 1 then return

li_claim_nr = this.getItemNumber(row, "claim_nr")
li_chart_nr = this.getItemNumber(row, "chart_nr")

if this.getItemString(row, "trans_code") = "R" then
	luo_jump_claims = CREATE u_jump_claims
	luo_jump_claims.of_open_claims(ii_vessel_nr, is_voyage_nr, li_chart_nr, li_claim_nr)
	DESTROY luo_jump_claims
else
	luo_jump_actions_trans = CREATE u_jump_actions_trans
	luo_jump_actions_trans.of_open_actions_trans(ii_vessel_nr, is_voyage_nr, li_chart_nr, li_claim_nr)
	DESTROY luo_jump_actions_trans
end if	
	
end event

type dw_frt_comm from datawindow within tabpage_frt
integer y = 820
integer width = 3045
integer height = 432
integer taborder = 41
boolean bringtotop = true
string title = "none"
string dataobject = "d_fin_comm"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;long ll_claim_nr, ll_broker_nr
string ls_claimtype, ls_invoice
decimal ld_amount

u_jump_commission luo_jump_commission

if row < 1 then return

ll_broker_nr = this.getItemNumber(row, "commissions_broker_nr")
ls_claimtype = this.getItemString(row, "claims_claim_type")
ll_claim_nr = this.getItemNumber(row, "commissions_claim_nr")
ls_invoice = this.getItemString(row, "commissions_invoice_nr")
ld_amount = this.getItemDecimal(row, "commissions_comm_amount_local_curr")

luo_jump_commission = CREATE u_jump_commission
luo_jump_commission.of_open_commission(ll_broker_nr, ii_vessel_nr, is_voyage_nr, ls_claimtype, ll_claim_nr, ls_invoice, ld_amount )
DESTROY luo_jump_commission

end event

type tabpage_claims from userobject within tab_finance
event create ( )
event destroy ( )
event ue_retrieve pbm_custom01
integer x = 18
integer y = 104
integer width = 3899
integer height = 1464
long backcolor = 81324524
string text = "Claim"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
uo_miscbalance uo_miscbalance
dw_claims dw_claims
dw_claim_trans dw_claim_trans
dw_claim_comm dw_claim_comm
end type

on tabpage_claims.create
this.uo_miscbalance=create uo_miscbalance
this.dw_claims=create dw_claims
this.dw_claim_trans=create dw_claim_trans
this.dw_claim_comm=create dw_claim_comm
this.Control[]={this.uo_miscbalance,&
this.dw_claims,&
this.dw_claim_trans,&
this.dw_claim_comm}
end on

on tabpage_claims.destroy
destroy(this.uo_miscbalance)
destroy(this.dw_claims)
destroy(this.dw_claim_trans)
destroy(this.dw_claim_comm)
end on

event ue_retrieve;long ll_row

ll_row = dw_claims.retrieve(ii_vessel_nr, is_voyage_nr)

if ll_row > 0 then
	this.enabled = TRUE
	dw_claims.Event Clicked(0,0,1,dw_claims.Object)
else
	dw_claims.reset()
	dw_claim_trans.reset()
	dw_claim_comm.reset()
	uo_miscbalance.of_claimbalance(0, "0", 0, 0)	
	this.enabled = FALSE
end if

COMMIT;
end event

type uo_miscbalance from u_claimbalance within tabpage_claims
integer y = 1276
integer taborder = 81
end type

on uo_miscbalance.destroy
call u_claimbalance::destroy
end on

type dw_claims from datawindow within tabpage_claims
integer width = 3794
integer height = 340
integer taborder = 31
string title = "none"
string dataobject = "d_fin_claims"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer li_claim_nr
long ll_chart_nr


if row > 0 then
	this.selectrow(0, FALSE)
	this.selectrow(row, TRUE)
	ll_chart_nr = this.getItemNumber(row, "claims_chart_nr")
	li_claim_nr = this.getItemNumber(row, "claims_claim_nr")
	uo_miscbalance.of_claimbalance(ii_vessel_nr, is_voyage_nr, ll_chart_nr, li_claim_nr)	
	dw_claim_trans.retrieve(ii_vessel_nr, is_voyage_nr, ll_chart_nr, li_claim_nr)
	dw_claim_comm.retrieve(ii_vessel_nr, is_voyage_nr, ll_chart_nr, li_claim_nr)
end if
end event

event doubleclicked;integer li_claim_nr, li_chart_nr
u_jump_claims luo_jump_claims

if row < 1 then return

li_claim_nr = this.getItemNumber(row, "claims_claim_nr")
li_chart_nr = this.getItemNumber(row, "claims_chart_nr")
luo_jump_claims = CREATE u_jump_claims
luo_jump_claims.of_open_claims(ii_vessel_nr, is_voyage_nr, li_chart_nr, li_claim_nr)
DESTROY luo_jump_claims
end event

type dw_claim_trans from datawindow within tabpage_claims
integer y = 364
integer width = 2373
integer height = 432
integer taborder = 41
string title = "none"
string dataobject = "d_fin_claim_trans"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;integer li_claim_nr, li_chart_nr
u_jump_actions_trans luo_jump_actions_trans

if row < 1 then return

li_claim_nr = this.getItemNumber(row, "claim_nr")
li_chart_nr = this.getItemNumber(row, "chart_nr")

luo_jump_actions_trans = CREATE u_jump_actions_trans
luo_jump_actions_trans.of_open_actions_trans(ii_vessel_nr, is_voyage_nr, li_chart_nr, li_claim_nr)
DESTROY luo_jump_actions_trans
	
end event

type dw_claim_comm from datawindow within tabpage_claims
integer y = 820
integer width = 3086
integer height = 432
integer taborder = 51
string title = "none"
string dataobject = "d_fin_comm"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;long ll_claim_nr, ll_broker_nr
string ls_claimtype, ls_invoice
decimal ld_amount

u_jump_commission luo_jump_commission

if row < 1 then return

ll_broker_nr = this.getItemNumber(row, "commissions_broker_nr")
ls_claimtype = this.getItemString(row, "claims_claim_type")
ll_claim_nr = this.getItemNumber(row, "commissions_claim_nr")
ls_invoice = this.getItemString(row, "commissions_invoice_nr")
ld_amount = this.getItemDecimal(row, "commissions_comm_amount_local_curr")

luo_jump_commission = CREATE u_jump_commission
luo_jump_commission.of_open_commission(ll_broker_nr, ii_vessel_nr, is_voyage_nr, ls_claimtype, ll_claim_nr, ls_invoice, ld_amount )
DESTROY luo_jump_commission

end event

type tabpage_bunker from userobject within tab_finance
event create ( )
event destroy ( )
event ue_retrieve ( )
integer x = 18
integer y = 104
integer width = 3899
integer height = 1464
long backcolor = 81324524
string text = "Bunker/Off-hire"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
dw_bunker dw_bunker
dw_offhire dw_offhire
end type

on tabpage_bunker.create
this.dw_bunker=create dw_bunker
this.dw_offhire=create dw_offhire
this.Control[]={this.dw_bunker,&
this.dw_offhire}
end on

on tabpage_bunker.destroy
destroy(this.dw_bunker)
destroy(this.dw_offhire)
end on

event ue_retrieve();long ll_row

ll_row = dw_bunker.retrieve(ii_vessel_nr, is_voyage_nr)
ll_row += dw_offhire.retrieve(ii_vessel_nr, is_voyage_nr)

this.enabled = ll_row > 0

COMMIT;
end event

type dw_bunker from datawindow within tabpage_bunker
integer width = 3886
integer height = 688
integer taborder = 10
string title = "none"
string dataobject = "d_fin_bunker"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;integer li_pcn
string ls_port_code

u_jump_poc luo_jump_poc

if row < 1 then return

li_pcn = this.getItemNumber(row, "poc_pcn")
ls_port_code = this.getItemString(row, "poc_port_code")
luo_jump_poc = CREATE u_jump_poc
luo_jump_poc.of_open_poc(ii_vessel_nr, is_voyage_nr, ls_port_code, li_pcn)
DESTROY luo_jump_poc
end event

type dw_offhire from datawindow within tabpage_bunker
integer y = 712
integer width = 3890
integer height = 752
integer taborder = 41
string title = "none"
string dataobject = "d_fin_off_services"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_port_code
datetime ldt_startdate

u_jump_offservice luo_jump_offservice

if row < 1 then return

ls_port_code = this.getItemString(row, "port_code")
ldt_startdate = this.getItemDateTime(row, "off_start")
luo_jump_offservice = CREATE u_jump_offservice
luo_jump_offservice.of_open_offservice(ii_vessel_nr, is_voyage_nr, ls_port_code, ldt_startdate)
DESTROY luo_jump_offservice
end event

type tabpage_disbursement from userobject within tab_finance
event create ( )
event destroy ( )
event ue_retrieve ( )
integer x = 18
integer y = 104
integer width = 3899
integer height = 1464
long backcolor = 81324524
string text = "Disbursement"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
st_9 st_9
cb_find_txnumber cb_find_txnumber
dw_disb dw_disb
cbx_only_port_exp cbx_only_port_exp
end type

on tabpage_disbursement.create
this.st_9=create st_9
this.cb_find_txnumber=create cb_find_txnumber
this.dw_disb=create dw_disb
this.cbx_only_port_exp=create cbx_only_port_exp
this.Control[]={this.st_9,&
this.cb_find_txnumber,&
this.dw_disb,&
this.cbx_only_port_exp}
end on

on tabpage_disbursement.destroy
destroy(this.st_9)
destroy(this.cb_find_txnumber)
destroy(this.dw_disb)
destroy(this.cbx_only_port_exp)
end on

event ue_retrieve();this.enabled = dw_disb.retrieve(ii_vessel_nr, is_voyage_nr) > 0

cb_jump_disbursement.enabled = not this.enabled

COMMIT;
end event

type st_9 from statictext within tabpage_disbursement
integer x = 3643
integer y = 236
integer width = 238
integer height = 132
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Only port exp."
boolean focusrectangle = false
end type

type cb_find_txnumber from commandbutton within tabpage_disbursement
integer x = 3630
integer y = 100
integer width = 251
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Find &TX #"
end type

event clicked;long ll_row, ll_txrows
integer li_settled
decimal {0} ld_amount
string ls_vessel
string ls_txnumber
datastore lds

ll_row = dw_disb.getRow()
if ll_row < 1 then Return /* No row selected */

li_settled = dw_disb.getItemNumber(ll_row, "disb_expenses_settled")
if li_settled = 0 then
	MessageBox("Information", "Expense not settled")
	Return
end if

SELECT VESSEL_REF_NR INTO :ls_vessel FROM VESSELS WHERE VESSEL_NR = :ii_vessel_nr;
ls_vessel = "V"+ls_vessel
ld_amount = abs(round(dw_disb.getItemDecimal(ll_row, "disb_expenses_exp_amount_local"), 2) *100)

lds = CREATE datastore
lds.DataObject = "d_fin_find_txnumber"
lds.setTransObject(SQLCA)
ll_txrows = lds.Retrieve(ls_vessel, ld_amount)

if ll_txrows < 1 then
	MessageBox("Error", "An Error occured when trying to get TX #. Please contact System Administrator")
	DESTROY lds
	return
end if

//if ll_txrows = 1 then
//	ls_txnumber = lds.getItemString(1, "trans_log_main_a_f07_docnum")
//	if isnull(ls_txnumber) then
//		MessageBox("Information", "No TX # found. Transaction not yet transferred to CODA")
//		DESTROY lds
//		Return
//	end if
//	MessageBox("TX number found", "TX number for this Expense is: " + ls_txnumber)
//	DESTROY lds
//	return
//else
Openwithparm(w_fin_find_txnumber, lds)
DESTROY lds
//end if
end event

type dw_disb from datawindow within tabpage_disbursement
integer width = 3602
integer height = 1460
integer taborder = 10
string title = "none"
string dataobject = "d_fin_disbursement"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;long ll_position, ll_row
string ls_work
integer li_pcn
string ls_portcode, ls_agent_sn
u_jump_disbursement luo_jump_disbursement

ls_work = this.getObjectAtPointer()
ll_position = pos(ls_work, "~t")

ll_row = long(right(ls_work, len(ls_work) - ll_position))
if ll_row < 1 then Return

luo_jump_disbursement = CREATE u_jump_disbursement
ls_portcode = this.getItemString(ll_row, "proceed_port_code")
li_pcn = this.getItemNumber(ll_row, "proceed_pcn")
ls_agent_sn = this.getItemString(ll_row, "agents_agent_sn")
luo_jump_disbursement.of_open_disbursement(ii_vessel_nr, is_voyage_nr, ls_portcode, li_pcn, ls_agent_sn)
DESTROY luo_jump_disbursement		

end event

event clicked;if row > 0 then
	this.Selectrow(0, FALSE)
	this.SelectRow(row, TRUE)
end if
end event

type cbx_only_port_exp from checkbox within tabpage_disbursement
integer x = 3771
integer y = 284
integer width = 91
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;// Set filter for DW to only include port expenses
string ls_filter

ls_filter = "vouchers_port_expense=1"

IF cbx_only_port_exp.Checked = TRUE THEN
	dw_disb.SetFilter(ls_filter)	
	dw_disb.Filter()
	dw_disb.Sort()
	dw_disb.GroupCalc()
ELSE
	dw_disb.SetFilter("")
	dw_disb.Filter()	
	dw_disb.Sort()
	dw_disb.GroupCalc()
END IF
end event

type tabpage_commission from userobject within tab_finance
event ue_retrieve pbm_custom01
integer x = 18
integer y = 104
integer width = 3899
integer height = 1464
long backcolor = 81324524
string text = "Commission"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
dw_comm dw_comm
end type

event ue_retrieve;this.enabled = dw_comm.retrieve(ii_vessel_nr, is_voyage_nr) > 0

COMMIT;
end event

on tabpage_commission.create
this.dw_comm=create dw_comm
this.Control[]={this.dw_comm}
end on

on tabpage_commission.destroy
destroy(this.dw_comm)
end on

type dw_comm from datawindow within tabpage_commission
integer width = 3424
integer height = 1460
integer taborder = 31
string title = "none"
string dataobject = "d_commissions_vv"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;long ll_claim_nr, ll_broker_nr
string ls_claimtype, ls_invoice
decimal ld_amount

u_jump_commission luo_jump_commission

if row < 1 then return

ll_broker_nr = this.getItemNumber(row, "commissions_broker_nr")
ls_claimtype = this.getItemString(row, "claims_claim_type")
ll_claim_nr = this.getItemNumber(row, "commissions_claim_nr")
ls_invoice = this.getItemString(row, "commissions_invoice_nr")
ld_amount = this.getItemDecimal(row, "commissions_comm_amount_local_curr")

luo_jump_commission = CREATE u_jump_commission
luo_jump_commission.of_open_commission(ll_broker_nr, ii_vessel_nr, is_voyage_nr, ls_claimtype, ll_claim_nr, ls_invoice, ld_amount )
DESTROY luo_jump_commission

end event

type tabpage_tcin from userobject within tab_finance
event ue_retrieve pbm_custom01
integer x = 18
integer y = 104
integer width = 3899
integer height = 1464
long backcolor = 81324524
string text = "TC-in"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
dw_tcperiod dw_tcperiod
dw_tcbroker dw_tcbroker
dw_tcin dw_tcin
end type

event ue_retrieve;long ll_row, ll_contract_id
datetime ldt_date

ll_row = dw_tcin.retrieve(ii_vessel_nr, is_voyage_nr)

IF ll_row > 0 then
	ll_contract_id = dw_tcin.getItemNumber(ll_row, "ntc_tc_contract_contract_id")
	dw_tcbroker.retrieve(ll_contract_id)
	dw_tcperiod.retrieve(ll_contract_id)
ELSE
	dw_tcbroker.retrieve(ll_contract_id)
	dw_tcperiod.retrieve(ll_contract_id)
end if

this.enabled = ll_row > 0

COMMIT;
end event

on tabpage_tcin.create
this.dw_tcperiod=create dw_tcperiod
this.dw_tcbroker=create dw_tcbroker
this.dw_tcin=create dw_tcin
this.Control[]={this.dw_tcperiod,&
this.dw_tcbroker,&
this.dw_tcin}
end on

on tabpage_tcin.destroy
destroy(this.dw_tcperiod)
destroy(this.dw_tcbroker)
destroy(this.dw_tcin)
end on

type dw_tcperiod from datawindow within tabpage_tcin
integer y = 1088
integer width = 1682
integer height = 336
integer taborder = 51
string title = "none"
string dataobject = "d_fin_single_tcperiod"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;long ll_contract_id
u_jump_tchire luo_jump_tchire
	
luo_jump_tchire = CREATE u_jump_tchire
IF isvalid(dw_tcin) then
	ll_contract_id = dw_tcin.getItemNumber(1, "ntc_tc_contract_contract_id")
end if
luo_jump_tchire.of_open_tchire(ii_vessel_nr, ll_contract_id)
DESTROY luo_jump_tchire

end event

type dw_tcbroker from datawindow within tabpage_tcin
integer y = 716
integer width = 3008
integer height = 332
integer taborder = 51
string title = "none"
string dataobject = "d_fin_single_tcbroker"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_columnname
long ll_position, ll_row, ll_key, ll_contract_id
string ls_work
datetime ldt_cp_date


ls_work = this.getObjectAtPointer()
ll_position = pos(ls_work, "~t")

ls_columnname = left(ls_work, ll_position -1)
ll_row = long(right(ls_work, len(ls_work) - ll_position))

if ll_row < 1 then Return

ll_key = this.getItemNumber(ll_row, "brokers_broker_nr")
if ll_key > 0 then opensheetwithparm(w_brokerlist, ll_key, w_tramos_main, 0, original!)

end event

type dw_tcin from datawindow within tabpage_tcin
integer width = 3077
integer height = 684
integer taborder = 20
string title = "none"
string dataobject = "d_fin_single_tcin"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_columnname
long ll_position, ll_row, ll_key, ll_contract_id
string ls_work
datetime ldt_cp_date
u_jump_tchire luo_jump_tchire

ls_work = this.getObjectAtPointer()
ll_position = pos(ls_work, "~t")

ls_columnname = left(ls_work, ll_position -1)
ll_row = long(right(ls_work, len(ls_work) - ll_position))

if ll_row < 1 then Return

choose case ls_columnname
	case "tcowners_tcowner_n_1"
		ll_key = this.getItemNumber(ll_row, "ntc_tc_contract_tcowner_nr")
		if ll_key > 0 then opensheetwithparm(w_tcowner_list, ll_key, w_tramos_main, 0, original!)
	case "tcowners_tcowner_n_1_1"
		ll_key = this.getItemNumber(ll_row, "ntc_tc_contract_contract_tcowner_nr")
		if ll_key > 0 then opensheetwithparm(w_tcowner_list, ll_key, w_tramos_main, 0, original!)
	case "offices_office_name"
		ll_key = this.getItemNumber(ll_row, "offices_office_nr")
		if ll_key > 0 then opensheetwithparm(w_officelist, ll_key, w_tramos_main, 0, original!)
	case "chart_chart_n_1"
		ll_key = this.getItemNumber(ll_row, "ntc_tc_contract_chart_nr")
		if ll_key > 0 then opensheetwithparm(w_chartererlist, ll_key, w_tramos_main, 0, original!)
	case else
		luo_jump_tchire = CREATE u_jump_tchire
		ll_contract_id = this.getItemNumber(ll_row, "ntc_tc_contract_contract_id")
		luo_jump_tchire.of_open_tchire(ii_vessel_nr, ll_contract_id)
		DESTROY luo_jump_tchire
end choose

end event

type tabpage_voyage_notes from userobject within tab_finance
event ue_retrieve pbm_custom01
integer x = 18
integer y = 104
integer width = 3899
integer height = 1464
long backcolor = 32304364
string text = "Voyage Notepad"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
dw_posted_bunker dw_posted_bunker
dw_voyage_notes dw_voyage_notes
end type

event ue_retrieve;this.enabled = dw_voyage_notes.retrieve(ii_vessel_nr, is_voyage_nr) > 0 &
					or dw_posted_bunker.retrieve(ii_vessel_nr, is_voyage_nr) > 0 

dw_voyage_notes.setfocus()
dw_voyage_notes.Object.voyage_notes.TabSequence = 0

COMMIT;
end event

on tabpage_voyage_notes.create
this.dw_posted_bunker=create dw_posted_bunker
this.dw_voyage_notes=create dw_voyage_notes
this.Control[]={this.dw_posted_bunker,&
this.dw_voyage_notes}
end on

on tabpage_voyage_notes.destroy
destroy(this.dw_posted_bunker)
destroy(this.dw_voyage_notes)
end on

type dw_posted_bunker from datawindow within tabpage_voyage_notes
integer x = 2213
integer y = 32
integer width = 914
integer height = 844
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_ff_posted_bunker"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_voyage_notes from datawindow within tabpage_voyage_notes
integer x = 23
integer y = 32
integer width = 2171
integer height = 1404
integer taborder = 20
string dataobject = "d_voyage_notes"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;u_jump_voyage_notepad luo_jump_voyage_notepad

if row <= 0 then Return

luo_jump_voyage_notepad = CREATE u_jump_voyage_notepad
luo_jump_voyage_notepad.of_open_voyage_notepad(ii_vessel_nr, is_voyage_nr)
DESTROY luo_jump_voyage_notepad
end event

type dw_charterer from datawindow within u_fin_single_voyage
integer width = 3264
integer height = 656
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_fin_charterer_broker"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_columnname
long ll_position, ll_row, ll_key
string ls_work

ls_work = this.getObjectAtPointer()
ll_position = pos(ls_work, "~t")

ls_columnname = left(ls_work, ll_position -1)
ll_row = long(right(ls_work, len(ls_work) - ll_position))

if ll_row < 1 then Return

choose case ls_columnname
	case "chart_chart_sn", "chart_chart_n_1"
		ll_key = this.getItemNumber(ll_row, "chart_chart_nr")
		if ll_key > 0 then opensheetwithparm(w_chartererlist, ll_key, w_tramos_main, 0, original!)
	case "brokers_broker_sn", "brokers_broker_name"
		ll_key = this.getItemNumber(ll_row, "brokers_broker_nr")
		if ll_key > 0 then opensheetwithparm(w_brokerlist, ll_key, w_tramos_main, 0, original!)
	case "tcowners_tcowner_sn", "tcowners_tcowner_n_1"
		ll_key = this.getItemNumber(ll_row, "tcowners_tcowner_nr")
		if ll_key > 0 then opensheetwithparm(w_tcowner_list, ll_key, w_tramos_main, 0, original!)
end choose
		
end event

type gb_1 from groupbox within u_fin_single_voyage
integer x = 3328
integer width = 567
integer height = 272
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Jump to"
end type

type gb_2 from groupbox within u_fin_single_voyage
integer x = 3328
integer y = 304
integer width = 567
integer height = 208
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estimation Transaction"
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
03u_fin_single_voyage.bin 
2B00000600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe00000006000000000000000000000001000000010000000000001000fffffffe00000000fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
13u_fin_single_voyage.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
