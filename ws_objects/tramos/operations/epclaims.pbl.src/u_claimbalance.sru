$PBExportHeader$u_claimbalance.sru
$PBExportComments$Calculate Balance for All Claims - Visual
forward
global type u_claimbalance from mt_u_visualobject
end type
type st_balance_usd from statictext within u_claimbalance
end type
type st_bal_usd from statictext within u_claimbalance
end type
type st_balance_local from statictext within u_claimbalance
end type
type st_bal_local from statictext within u_claimbalance
end type
end forward

global type u_claimbalance from mt_u_visualobject
integer width = 667
integer height = 160
long backcolor = 32304364
st_balance_usd st_balance_usd
st_bal_usd st_bal_usd
st_balance_local st_balance_local
st_bal_local st_bal_local
end type
global u_claimbalance u_claimbalance

type variables
private long _il_claim_percentage = 0
string _is_currcode
end variables

forward prototypes
public subroutine documentation ()
public function decimal of_getvalue_usd ()
public function decimal of_getvalue_local ()
public subroutine of_setnull ()
public function string of_getcurrcode ()
public subroutine of_displayvalues (decimal ad_value_local, decimal ad_value_usd)
public function long of_get_claimpercentage ()
public function decimal of_claimbalance (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: u_claim_balance
	
   <OBJECT>Visual representation of the balances</OBJECT>
   <DESC>Version 2.0 of object</DESC>
   <USAGE>  Used to display current outstanding balances in claim currency and USD.</USAGE>
   <ALSO>   n_claimcurrencycalc</ALSO>
    Date   Ref    Author        Comments
  16/02/11 ?      AGL     	First Version
  30/10/12 2949	LGX001	Recalc the claim balance When DEM claim has negative balance AND percentage xy%
********************************************************************/

end subroutine

public function decimal of_getvalue_usd ();return dec(st_balance_usd.text)
end function

public function decimal of_getvalue_local ();return dec(st_balance_local.text)
end function

public subroutine of_setnull ();st_balance_local.text = " "
st_balance_usd.text = " "
end subroutine

public function string of_getcurrcode ();return  _is_currcode

end function

public subroutine of_displayvalues (decimal ad_value_local, decimal ad_value_usd);st_balance_local.text = String(ad_value_local)
st_balance_usd.text = String(ad_value_usd)
end subroutine

public function long of_get_claimpercentage ();return _il_claim_percentage
end function

public function decimal of_claimbalance (integer ai_vessel_nr, string as_voyage_nr, integer ai_chart_nr, integer ai_claim_nr);n_claimcurrencyadjust	lnv_curradjust
decimal {2}					ld_balance_local, ld_balance_usd
decimal                 ld_claim_amount
mt_n_datastore		lds_claim_dem

lds_claim_dem = create mt_n_datastore
lds_claim_dem.dataobject="d_sq_tb_cc_singleclaim"
lds_claim_dem.settransobject(sqlca)
lds_claim_dem.retrieve(ai_vessel_nr, as_voyage_nr, ai_chart_nr, ai_claim_nr)

lnv_curradjust.of_set_dembalance_flag(false)

if lds_claim_dem.rowcount( ) = 1 then
	if lds_claim_dem.getitemstring(1, "claim_type") = "DEM"  then
		ld_claim_amount = lds_claim_dem.getitemdecimal(1, "claimamount_local")
		_il_claim_percentage = lds_claim_dem.getitemdecimal(1, "claim_percentage")
		if isnull(ld_claim_amount) then ld_claim_amount = 0
		if isnull(_il_claim_percentage) then _il_claim_percentage = 0
		if ld_claim_amount < 0 and _il_claim_percentage > 0 then
			lnv_curradjust.of_set_dembalance_flag(true)
		end if
	end if
end if

destroy lds_claim_dem

lnv_curradjust.of_getclaimamounts(ai_vessel_nr, as_voyage_nr, ai_chart_nr, ai_claim_nr, ld_balance_local, ld_balance_usd, _is_currcode)	
if _is_currcode = "USD" then
	st_balance_local.visible = false
	st_bal_local.visible = false
	if  isnull(ld_balance_local) then 
		ld_balance_local = 0
		ld_balance_usd = 0
	end if
		//st_balance.textcolor = c#color.White
		//st_bal_xxx.textcolor = c#color.White
else
	st_balance_local.visible = true
	st_bal_local.visible = true
		//st_balance.textcolor = c#color.MT_LISTHEADER_BG
		//st_bal_xxx.textcolor = c#color.MT_LISTHEADER_BG
end if

st_balance_local.text = string(ld_balance_local,"#,##0.00")
st_balance_usd.text = string(ld_balance_usd,"#,##0.00")
st_bal_local.text = "Bal. " + _is_currcode + ":"

return ld_balance_local
end function

on u_claimbalance.create
int iCurrent
call super::create
this.st_balance_usd=create st_balance_usd
this.st_bal_usd=create st_bal_usd
this.st_balance_local=create st_balance_local
this.st_bal_local=create st_bal_local
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_balance_usd
this.Control[iCurrent+2]=this.st_bal_usd
this.Control[iCurrent+3]=this.st_balance_local
this.Control[iCurrent+4]=this.st_bal_local
end on

on u_claimbalance.destroy
call super::destroy
destroy(this.st_balance_usd)
destroy(this.st_bal_usd)
destroy(this.st_balance_local)
destroy(this.st_bal_local)
end on

event constructor;call super::constructor;powerobject  lpo_parent
userobject luo_parent
window lw_parent
long ll_backcolor
tab ltab_parent
boolean lb_ignore = false

lpo_parent = this.getparent( )
choose case lpo_parent.typeof( )

	case Window!
		lw_parent = lpo_parent
		ll_backcolor = lw_parent.backcolor
		
	case Tab!	
		ltab_parent = lpo_parent
		ll_backcolor = ltab_parent.backcolor

	case UserObject!
		luo_parent = lpo_parent
		ll_backcolor = luo_parent.backcolor
		
	case else
		// do nothing
		lb_ignore = true	

end choose
		
if not( lb_ignore) then
	this.backcolor = ll_backcolor
	st_bal_local.backcolor =ll_backcolor
	st_bal_usd.backcolor = ll_backcolor
	st_balance_local.backcolor = ll_backcolor
	st_balance_usd.backcolor = ll_backcolor
end if

end event

type st_balance_usd from statictext within u_claimbalance
integer x = 274
integer y = 84
integer width = 370
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 22628899
long backcolor = 32304364
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bal_usd from statictext within u_claimbalance
integer x = 18
integer y = 84
integer width = 229
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 22628899
long backcolor = 32304364
boolean enabled = false
string text = "Bal. USD"
boolean focusrectangle = false
end type

type st_balance_local from statictext within u_claimbalance
boolean visible = false
integer x = 274
integer y = 4
integer width = 370
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 22628899
long backcolor = 32304364
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bal_local from statictext within u_claimbalance
boolean visible = false
integer x = 18
integer y = 4
integer width = 229
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 22628899
long backcolor = 32304364
boolean enabled = false
string text = "Balance"
boolean focusrectangle = false
end type

