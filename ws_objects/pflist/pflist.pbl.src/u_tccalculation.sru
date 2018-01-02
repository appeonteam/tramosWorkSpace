$PBExportHeader$u_tccalculation.sru
forward
global type u_tccalculation from userobject
end type
type st_13 from statictext within u_tccalculation
end type
type st_flatrate from statictext within u_tccalculation
end type
type st_9 from statictext within u_tccalculation
end type
type st_8 from statictext within u_tccalculation
end type
type dw_tradeinfo from datawindow within u_tccalculation
end type
type dw_clarkvessels from datawindow within u_tccalculation
end type
type st_1 from statictext within u_tccalculation
end type
type st_2 from statictext within u_tccalculation
end type
type st_3 from statictext within u_tccalculation
end type
type st_4 from statictext within u_tccalculation
end type
type st_5 from statictext within u_tccalculation
end type
type st_6 from statictext within u_tccalculation
end type
type st_7 from statictext within u_tccalculation
end type
type dw_ownvessels from datawindow within u_tccalculation
end type
type st_tcformula from statictext within u_tccalculation
end type
type st_daysladen from statictext within u_tccalculation
end type
type st_ballastdays from statictext within u_tccalculation
end type
type st_totaldays from statictext within u_tccalculation
end type
type st_consladen from statictext within u_tccalculation
end type
type st_consballast from statictext within u_tccalculation
end type
type st_consport from statictext within u_tccalculation
end type
type st_constotal from statictext within u_tccalculation
end type
type st_rateformula from statictext within u_tccalculation
end type
type st_rate from statictext within u_tccalculation
end type
type st_tc from statictext within u_tccalculation
end type
type st_10 from statictext within u_tccalculation
end type
type st_11 from statictext within u_tccalculation
end type
type st_12 from statictext within u_tccalculation
end type
type st_inrate from statictext within u_tccalculation
end type
type st_cargosize from statictext within u_tccalculation
end type
type st_waitingdays from statictext within u_tccalculation
end type
end forward

global type u_tccalculation from userobject
integer width = 3355
integer height = 1392
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_13 st_13
st_flatrate st_flatrate
st_9 st_9
st_8 st_8
dw_tradeinfo dw_tradeinfo
dw_clarkvessels dw_clarkvessels
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
dw_ownvessels dw_ownvessels
st_tcformula st_tcformula
st_daysladen st_daysladen
st_ballastdays st_ballastdays
st_totaldays st_totaldays
st_consladen st_consladen
st_consballast st_consballast
st_consport st_consport
st_constotal st_constotal
st_rateformula st_rateformula
st_rate st_rate
st_tc st_tc
st_10 st_10
st_11 st_11
st_12 st_12
st_inrate st_inrate
st_cargosize st_cargosize
st_waitingdays st_waitingdays
end type
global u_tccalculation u_tccalculation

type variables
long	ii_flatrate_year
string	is_flatrate
end variables

forward prototypes
public function decimal uf_flatrate_calculation (long al_flatrateyear, long al_tradeid, string as_dportcode, string as_lportcode)
public function integer uf_tccalculation (integer al_pcgroup, long al_vesselid, long al_clarkid, long al_rate, long al_flatrateyear, long al_ratetypeid, long al_tradeid, string as_lportid, string as_dportid, long al_cargosize, long al_waitingdays, ref decimal ad_tcrate, ref decimal ad_tcdays, ref string as_errormessage)
end prototypes

public function decimal uf_flatrate_calculation (long al_flatrateyear, long al_tradeid, string as_dportcode, string as_lportcode);Dec ld_rate
Dec ld_rate_fixture_LoadDisc_Ports
Dec ld_rate_fixture_default_trade

s_param_flatrate	lstr_param

string	as_rate_fixture_LoadDisc_Ports, as_rate_fixture_default_trade

if as_dportcode<>"" and as_lportcode<>"" then	
	COMMIT;
	SELECT isnull(CAL_WSCA_RATE,0) as CAL_WSCA_RATE , "Fixture load and discharge ports: " + CAL_WSCA_PORT_LIST
	INTO :ld_rate_fixture_LoadDisc_Ports, :as_rate_fixture_LoadDisc_Ports
	FROM CAL_WSCA
	WHERE LEFT(CAL_WSCA_PORT_LIST,3) = :as_lportcode AND RIGHT(RTRIM(CAL_WSCA_PORT_LIST),3) = :as_dportcode
	AND LEN(RTRIM(CAL_WSCA_PORT_LIST))=6 AND CAL_WSCA_YEAR=:al_flatrateyear
	COMMIT USING sqlca;
end if

if al_tradeid <> 0 then
	COMMIT;
	SELECT  isnull(CAL_WSCA_RATE,0)  AS RATE, ("Load and discharge default ports for the trade: " + RIGHT(RTRIM(CAL_WSCA_PORT_LIST),3) + "-" +  LEFT(CAL_WSCA_PORT_LIST,3)) AS INFO
	INTO :ld_rate_fixture_default_trade, :as_rate_fixture_default_trade
	FROM  PF_FIXTURE_TRADE,CAL_WSCA
	WHERE  LEFT(CAL_WSCA_PORT_LIST,3) = LPORTCODE AND RIGHT(RTRIM(CAL_WSCA_PORT_LIST),3)=DPORTCODE
	AND LEN(RTRIM(CAL_WSCA_PORT_LIST))=6 AND TRADEID =:al_tradeid AND CAL_WSCA_YEAR=:al_flatrateyear ;
	COMMIT USING sqlca;
end if

lstr_param.ll_year = ii_flatrate_year
lstr_param.ls_fixture_trade=is_flatrate

lstr_param.ld_flatrate_defaultports = ld_rate_fixture_default_trade
lstr_param.ls_msg_defaultports=as_rate_fixture_default_trade

lstr_param.ld_flatrateports = ld_rate_fixture_LoadDisc_Ports
lstr_param.ls_msg_ports=as_rate_fixture_LoadDisc_Ports

openwithparm(w_f_tc_calculation_add,lstr_param)

lstr_param = message.powerobjectparm

ld_rate =lstr_param.ld_flatrateports

return ld_rate
end function

public function integer uf_tccalculation (integer al_pcgroup, long al_vesselid, long al_clarkid, long al_rate, long al_flatrateyear, long al_ratetypeid, long al_tradeid, string as_lportid, string as_dportid, long al_cargosize, long al_waitingdays, ref decimal ad_tcrate, ref decimal ad_tcdays, ref string as_errormessage);//uo_calculation.uf_tccalculation(li_pcgroup, ll_vesselid, ll_clarkid, ld_rate, ll_flatrateyear,ll_ratetypeid,  ll_tradeid, ls_lportid,ls_dportid,   ld_cargoSize, ld_waitingdays,id_owntc, id_owntcdays, ls_errormessage)<>0 then

//INPUT:		al_pc_nr, al_vesselid, al_clarkid, al_rate, al_flatrateyear, al_ratetypeid,  al_tradeid, as_lportid,  as_dportid, al_cargosize, al_waitingdays, 
//RETURN:	ad_tcrate, ad_tcdays, as_errormessage

datawindow dw_selectedwindow

string 	ls_ratetype, ls_nf, ls_flatrate_message
dec{2} 	ld_daysLaden, ld_daysBallast, ld_speedLaden, ld_speedBallast, ld_consLaden, ld_consBallast, ld_consPort
dec{2}	ld_calcDays, ld_daysPort
dec{2} 	ld_tmp, ld_totaldays
dec{2}	 ld_flatRate, ld_expenses, ld_commission, ld_daysinport
dec{2}	ld_calcRate, ld_calcCommission, ld_TC, ld_calcConsumption
long 		ll_flaterateid

ls_nf="#,###.0"

ad_tcrate=0 
ad_tcdays = 0 

if isnull(al_rate) then al_rate=0

 
if isnull(al_flatrateyear) then al_flatrateyear=0
if al_flatrateyear =0 then
	al_flatrateyear = year(today())
end if

if isnull(al_ratetypeid) then al_ratetypeid=0

if isnull(al_cargosize) then al_cargosize=0

if al_cargosize=0 or al_rate=0 then
	as_errormessage = "Please fill in mandatory fields: Cargo size and Rate "
	return -1
end if

if isnull(al_tradeid) then al_tradeid=0

if isnull(al_waitingdays) then al_waitingdays=0

COMMIT;
SELECT NAME
INTO :ls_ratetype
FROM PF_FIXTURE_RATETYPE
WHERE RATETYPEID=:al_ratetypeid
COMMIT USING SQLCA;
if SQLCA.sqlcode=-1 then
	as_errormessage =  "Error: Rate type selection (" + SQLCA.sqlerrtext + ")"
	return -1
end if

if ls_ratetype<>"WS" and ls_ratetype<>"LS" and ls_ratetype<>"$/MT" and  ls_ratetype<>"$/BBLS" then
	as_errormessage = "Rate type not recognized (Valid types: WS, LS, $/MT, $/BBLS )!"
	return -1
end if

st_inrate.text = string(al_rate)
st_cargosize.text = string(al_cargosize)
st_waitingdays.text = string(al_waitingdays)

//dw_clarkvessels.visible = false
//dw_ownvessels.visible = false
st_rateFormula.visible = true
st_rate.visible = false
st_TCFormula.visible = false
st_TC.visible = false

dw_tradeinfo.settransobject(SQLCA)
dw_tradeinfo.retrieve(al_tradeid,al_flatrateyear)
if SQLCA.sqlcode=-1 then
	as_errormessage = "Error: Trade information not found. (" + SQLCA.sqlerrtext + ")"
	return -1
end if

ii_flatrate_year = al_flatrateyear

if dw_tradeinfo.rowcount( )=0 then
	as_errormessage =  "Error: Trade information not found."
	return -1
end if
if  ls_ratetype = "WS" and dw_tradeinfo.getitemnumber(1, "flatrate") =0  then
	is_flatrate=dw_tradeinfo.getitemstring( 1,"name")

	ld_flatRate = uf_flatrate_calculation(al_flatrateyear, al_tradeid, as_dportid, as_lportid) 

	dw_tradeinfo.setitem(1, "flatrate", ld_flatRate)

	if ld_flatRate = 0 then
	 	as_errormessage =  "Error: Flatrate information not found."
		return -1
	end if
	
	COMMIT;
	SELECT FIXTUREFLATRATEID
	INTO :ll_flaterateid
	FROM PF_FIXTURE_FLATRATE
	WHERE TRADEID=:al_tradeid AND FLATRATEYEAR= :al_flatrateyear AND PCGROUP_ID=:al_pcgroup 
	COMMIT USING SQLCA;
	
	if ll_flaterateid = 0 then
		//add flat rate
		INSERT INTO PF_FIXTURE_FLATRATE (TRADEID, FLATRATE, FLATRATEYEAR, PCGROUP_ID)
		VALUES (:al_tradeid , :ld_flatRate , :al_flatrateyear , :al_pcgroup )
		COMMIT USING SQLCA;
		IF SQLCA.SQLcode <> 0 THEN
			 MessageBox("Warning", "Flat rate was not saved. " +SQLCA.sqlerrtext )
		END IF
	else
		//update flatrate
		UPDATE PF_FIXTURE_FLATRATE SET FLATRATE = :ld_flatRate
		WHERE FIXTUREFLATRATEID=:ll_flaterateid 
		COMMIT USING SQLCA;
		IF SQLCA.SQLcode <> 0 THEN
			 MessageBox("Warning", "Flat rate was not updated. " +SQLCA.sqlerrtext )
		END IF
	end if


else
	ld_flatRate=dw_tradeinfo.getitemnumber(1, "flatrate")
end if

//st_flatrate.text = ls_flatrate_message
dw_tradeinfo.setitem( 1,"flatrate" , ld_flatRate)

dw_tradeinfo.visible = true

if al_vesselid>0  then
	dw_ownvessels.visible =  true
	dw_clarkvessels.visible=false
	dw_selectedwindow = dw_ownvessels
	dw_selectedwindow.settransobject(SQLCA)
	dw_selectedwindow.retrieve(al_vesselid)
	if SQLCA.sqlcode=-1 then
		as_errormessage =  "Error: Vessel information not found. (" + SQLCA.sqlerrtext + ")"
		return -1
	end if
	
elseif al_clarkid>0 then
	dw_clarkvessels.visible=true
	dw_ownvessels.visible =  false
	
	dw_selectedwindow = dw_clarkvessels
	dw_selectedwindow.settransobject(SQLCA)
	dw_selectedwindow.retrieve(al_clarkid, al_pcgroup)
	if SQLCA.sqlcode=-1 then
		as_errormessage =  "Error: Competitor vessel information not found. (" + SQLCA.sqlerrtext + ")"
		return -1
	end if
else
	as_errormessage =  "Warning: Please choose a vessel."
	return -1
end if

if dw_selectedwindow.rowcount() =0 then
	as_errormessage =  "Warning: Vessel information not found. "
	return -1 
end if

//Start Calculations
ld_daysLaden=0
ld_speedLaden=dw_selectedwindow.getitemnumber(1,"LadenSpeed")
if ld_speedLaden=0 then
	ld_speedLaden=dw_selectedwindow.getitemnumber(1,"LadenSpeedDefault")
end if
if ld_speedLaden=0 and al_clarkid>0 then
	ld_speedLaden=dw_selectedwindow.getitemnumber(1,"LadenSpeedPC")
end if
if ld_speedLaden=0 then
else
	ld_daysLaden= dw_tradeinfo.getitemnumber( 1,"distance") / ld_speedLaden /24
end if
ld_totaldays=ld_daysLaden
st_daysladen.text =  string( ld_daysLaden,ls_nf)

ld_speedBallast=dw_selectedwindow.getitemnumber(1,"BallastSpeed")
if ld_speedBallast=0 then
	ld_speedBallast=dw_selectedwindow.getitemnumber(1,"BallastSpeedDefault")
end if
if ld_speedBallast=0 and al_clarkid>0 then
	ld_speedBallast=dw_selectedwindow.getitemnumber(1,"BallastSpeedPC")
end if
if ld_speedBallast=0 then
else
	ld_daysBallast=dw_tradeinfo.getitemnumber( 1,"distance") / ld_speedBallast /24 
end if
ld_totaldays=ld_totaldays + ld_daysBallast
st_ballastdays.text =  string( ld_daysBallast,ls_nf) 
	 
st_totaldays.text = string(ld_totaldays,ls_nf)

ld_daysPort = dw_tradeinfo.getitemnumber( 1,"daysinport") + al_waitingdays

ld_calcDays = ld_totaldays + ld_daysPort

ld_tmp = dw_tradeinfo.getitemnumber( 1,"price") 

ld_consLaden =  dw_selectedwindow.getitemnumber( 1, "ladencons")
if ld_consLaden =0 then
	ld_consLaden = dw_selectedwindow.getitemnumber( 1, "ladenconsdefault")
end if
if ld_consLaden =0 and al_clarkid>0 then
	ld_consLaden = dw_selectedwindow.getitemnumber( 1, "ladenconsPC")
end if

ld_consLaden = ld_daysLaden *ld_consLaden * ld_tmp

st_consladen.text = string(ld_consLaden,ls_nf)

ld_consBallast =  dw_selectedwindow.getitemnumber( 1, "ballastcons")
if ld_consBallast =0 then
	ld_consBallast = dw_selectedwindow.getitemnumber( 1, "ballastconsdefault")
end if
if ld_consBallast =0 and al_clarkid>0 then
	ld_consBallast = dw_selectedwindow.getitemnumber( 1, "ballastconsPC")
end if

ld_consBallast = ld_daysBallast * ld_consBallast * ld_tmp

st_consballast.text = string(ld_consBallast,ls_nf)

ld_consPort =  dw_selectedwindow.getitemnumber( 1, "portcons")
if ld_consPort =0 then
	ld_consPort = dw_selectedwindow.getitemnumber( 1, "portconsdefault")
end if
if ld_consPort =0 and al_clarkid>0 then
	ld_consPort = dw_selectedwindow.getitemnumber( 1, "portconsPC")
end if

ld_consPort= ld_daysPort * ld_consPort  * ld_tmp

st_consport.text = string(ld_consPort,ls_nf)

ld_tmp = ld_consLaden + ld_consBallast + ld_consPort
ld_calcConsumption=ld_tmp

st_constotal.text = string( ld_tmp,ls_nf)

//ld_flatRate = dw_tradeinfo.getitemnumber( 1, "flatrate")
ld_expenses= dw_tradeinfo.getitemnumber( 1, "expenses")
ld_commission= dw_tradeinfo.getitemnumber( 1, "commission")
ld_daysinport= dw_tradeinfo.getitemnumber( 1, "daysinport")
	
if ls_ratetype = "WS" then
	
	//if al_rate=0 or al_cargosize=0 or ld_flatRate=0 or ld_expenses=0 or ld_commission=0 or ld_daysinport=0 or ld_totaldays=0 or ld_consLaden=0 then
	if al_rate=0 or al_cargosize=0 or ld_flatRate=0  then
		st_rateFormula.text = "Information is not enough (Check the following information: rate, cargo size, flat rate)"
	else
		ld_calcRate = al_cargosize * 1000 * ((al_rate * ld_flatRate) /100)
		ld_calcCommission = (ld_calcRate*ld_commission)/100
		
		st_rateFormula.text  = "Calculated Rate = Cargo Size * 1000 * ( ( Rate * Flatrate ) / 100 )" 
		st_rate.text = string(ld_calcRate,ls_nf) + " = " + string(al_cargosize,ls_nf) + " * 1000 * ( ( " + string(al_rate,ls_nf) + " * " + string(ld_flatRate,ls_nf) + " ) / 100 )" 
		
		st_rateFormula.visible = true 
		st_rate.visible = true
		if ld_calcDays=0 then
			ld_TC = 0
		else
			ld_TC = (ld_calcRate - ld_calcCommission - ld_expenses - ld_calcConsumption) / ld_calcDays
			st_TCFormula.text  = "TC = ( Calculated rate - Commission - Expenses - Consumption ) / Days" 
			st_TC.text = string(ld_TC,ls_nf) + " = ( " + string(ld_calcRate,ls_nf) + " - " + string(ld_calcCommission,ls_nf) + " - " + string(ld_expenses,ls_nf) + " - " + string(ld_calcConsumption,ls_nf) + " ) / " + string(ld_calcDays,ls_nf) 
			st_TCFormula.visible = true
			st_TC.visible = true
		end if
	end if

elseif ls_ratetype = "LS" then
	
	//if al_rate=0 or ld_consLaden=0 or ld_expenses=0 or ld_commission=0 or ld_daysinport=0 or ld_totaldays=0  then
	if al_rate=0  then
		st_rateFormula.text = "Information is not enough (rate is missing)"
	else
		ld_calcRate=al_rate
		ld_calcCommission=(ld_calcRate*ld_commission)/100
		if ld_calcDays=0 then
			ld_TC = 0
		else
			ld_TC = (ld_calcRate - ld_calcCommission - ld_expenses - ld_calcConsumption) / ld_calcDays
			st_TCFormula.text  = "TC = ( Rate - Commission - Expenses - Consumption ) / Days" 
			st_TC.text = string(ld_TC,ls_nf) + " = ( " + string(ld_calcRate,ls_nf) + " - " + string(ld_calcCommission,ls_nf) + " - " + string(ld_expenses,ls_nf) + " - " + string(ld_calcConsumption,ls_nf) + " ) / " + string(ld_calcDays,ls_nf) 
			st_TCFormula.visible = true
			st_TC.visible = true
			st_rateFormula.visible = false
			st_rate.visible = false
		end if
	end if

elseif ls_ratetype = "$/MT" or ls_ratetype = "$/BBLS" then

	if al_rate=0 or al_cargosize=0 then
		st_rateFormula.text = "Information is not enough (Check the following information: rate, cargo size)"
	else
		ld_calcRate = al_cargosize * 1000 * al_rate
		ld_calcCommission = (ld_calcRate*ld_commission)/100
		if ld_calcDays=0 then
			ld_TC = 0
		else
			ld_TC = (ld_calcRate - ld_calcCommission - ld_expenses - ld_calcConsumption) / ld_calcDays
			st_TCFormula.text  = "TC = ( Rate - Commission - Expenses - Consumption ) / Days" 
			st_TC.text = string(ld_TC,ls_nf) + " = ( " + string(ld_calcRate,ls_nf) + " - " + string(ld_calcCommission,ls_nf) + " - " + string(ld_expenses,ls_nf) + " - " + string(ld_calcConsumption,ls_nf) + " ) / " + string(ld_calcDays,ls_nf) 
			st_TCFormula.visible = true
			st_TC.visible = true
			st_rateFormula.visible = false
			st_rate.visible = false
		end if
	end if

else
	st_rateFormula.text = "Rate type not recognized (Valid types: WS, LS, $/MT, $/BBLS )!"
	return -1
end if 

ad_tcrate = ld_TC
ad_tcdays = ld_calcDays
		
return 0

end function

on u_tccalculation.create
this.st_13=create st_13
this.st_flatrate=create st_flatrate
this.st_9=create st_9
this.st_8=create st_8
this.dw_tradeinfo=create dw_tradeinfo
this.dw_clarkvessels=create dw_clarkvessels
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.dw_ownvessels=create dw_ownvessels
this.st_tcformula=create st_tcformula
this.st_daysladen=create st_daysladen
this.st_ballastdays=create st_ballastdays
this.st_totaldays=create st_totaldays
this.st_consladen=create st_consladen
this.st_consballast=create st_consballast
this.st_consport=create st_consport
this.st_constotal=create st_constotal
this.st_rateformula=create st_rateformula
this.st_rate=create st_rate
this.st_tc=create st_tc
this.st_10=create st_10
this.st_11=create st_11
this.st_12=create st_12
this.st_inrate=create st_inrate
this.st_cargosize=create st_cargosize
this.st_waitingdays=create st_waitingdays
this.Control[]={this.st_13,&
this.st_flatrate,&
this.st_9,&
this.st_8,&
this.dw_tradeinfo,&
this.dw_clarkvessels,&
this.st_1,&
this.st_2,&
this.st_3,&
this.st_4,&
this.st_5,&
this.st_6,&
this.st_7,&
this.dw_ownvessels,&
this.st_tcformula,&
this.st_daysladen,&
this.st_ballastdays,&
this.st_totaldays,&
this.st_consladen,&
this.st_consballast,&
this.st_consport,&
this.st_constotal,&
this.st_rateformula,&
this.st_rate,&
this.st_tc,&
this.st_10,&
this.st_11,&
this.st_12,&
this.st_inrate,&
this.st_cargosize,&
this.st_waitingdays}
end on

on u_tccalculation.destroy
destroy(this.st_13)
destroy(this.st_flatrate)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.dw_tradeinfo)
destroy(this.dw_clarkvessels)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.dw_ownvessels)
destroy(this.st_tcformula)
destroy(this.st_daysladen)
destroy(this.st_ballastdays)
destroy(this.st_totaldays)
destroy(this.st_consladen)
destroy(this.st_consballast)
destroy(this.st_consport)
destroy(this.st_constotal)
destroy(this.st_rateformula)
destroy(this.st_rate)
destroy(this.st_tc)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.st_12)
destroy(this.st_inrate)
destroy(this.st_cargosize)
destroy(this.st_waitingdays)
end on

type st_13 from statictext within u_tccalculation
integer x = 2043
integer width = 302
integer height = 132
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Default by profit center"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_flatrate from statictext within u_tccalculation
boolean visible = false
integer x = 1033
integer y = 784
integer width = 2025
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_9 from statictext within u_tccalculation
boolean visible = false
integer x = 1033
integer y = 728
integer width = 338
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Flat rate info:"
boolean focusrectangle = false
end type

type st_8 from statictext within u_tccalculation
integer x = 1737
integer width = 315
integer height = 132
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Default by vessel type"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_tradeinfo from datawindow within u_tccalculation
integer y = 196
integer width = 891
integer height = 624
integer taborder = 20
string title = "TC Calculation"
string dataobject = "d_f_tc_calculation"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type dw_clarkvessels from datawindow within u_tccalculation
integer x = 1015
integer y = 152
integer width = 1330
integer height = 556
integer taborder = 20
string title = "TC Calculation"
string dataobject = "d_f_tc_clarkvessels"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within u_tccalculation
integer x = 2418
integer y = 144
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Days Laden:"
boolean focusrectangle = false
end type

type st_2 from statictext within u_tccalculation
integer x = 2418
integer y = 244
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Days Ballast:"
boolean focusrectangle = false
end type

type st_3 from statictext within u_tccalculation
integer x = 2418
integer y = 344
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Total:"
boolean focusrectangle = false
end type

type st_4 from statictext within u_tccalculation
integer x = 2418
integer y = 744
integer width = 544
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Total:"
boolean focusrectangle = false
end type

type st_5 from statictext within u_tccalculation
integer x = 2418
integer y = 544
integer width = 544
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ballast Consumption:"
boolean focusrectangle = false
end type

type st_6 from statictext within u_tccalculation
integer x = 2418
integer y = 444
integer width = 544
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Laden Consumption:"
boolean focusrectangle = false
end type

type st_7 from statictext within u_tccalculation
integer x = 2418
integer y = 644
integer width = 544
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Port Consumption:"
boolean focusrectangle = false
end type

type dw_ownvessels from datawindow within u_tccalculation
integer x = 1056
integer y = 148
integer width = 965
integer height = 556
integer taborder = 20
string title = "TC Calculation"
string dataobject = "d_f_tc_ownvessels"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type st_tcformula from statictext within u_tccalculation
integer x = 1024
integer y = 1172
integer width = 2299
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type st_daysladen from statictext within u_tccalculation
integer x = 3045
integer y = 140
integer width = 270
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ballastdays from statictext within u_tccalculation
integer x = 3045
integer y = 244
integer width = 270
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_totaldays from statictext within u_tccalculation
integer x = 3045
integer y = 348
integer width = 270
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_consladen from statictext within u_tccalculation
integer x = 2994
integer y = 452
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_consballast from statictext within u_tccalculation
integer x = 2994
integer y = 556
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_consport from statictext within u_tccalculation
integer x = 2994
integer y = 660
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_constotal from statictext within u_tccalculation
integer x = 2994
integer y = 764
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_rateformula from statictext within u_tccalculation
integer x = 1033
integer y = 892
integer width = 2299
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type st_rate from statictext within u_tccalculation
integer x = 1029
integer y = 1024
integer width = 2299
integer height = 68
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type st_tc from statictext within u_tccalculation
integer x = 1029
integer y = 1284
integer width = 2299
integer height = 68
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type st_10 from statictext within u_tccalculation
integer x = 82
integer y = 824
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Waiting Days:"
boolean focusrectangle = false
end type

type st_11 from statictext within u_tccalculation
integer x = 78
integer y = 120
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cargo Size:"
boolean focusrectangle = false
end type

type st_12 from statictext within u_tccalculation
integer x = 82
integer y = 20
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rate:"
boolean focusrectangle = false
end type

type st_inrate from statictext within u_tccalculation
integer x = 512
integer y = 20
integer width = 270
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_cargosize from statictext within u_tccalculation
integer x = 512
integer y = 120
integer width = 270
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_waitingdays from statictext within u_tccalculation
integer x = 512
integer y = 824
integer width = 270
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

