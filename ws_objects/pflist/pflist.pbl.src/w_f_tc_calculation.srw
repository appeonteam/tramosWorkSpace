$PBExportHeader$w_f_tc_calculation.srw
$PBExportComments$TC and TC Days Calculation in Fixture details form
forward
global type w_f_tc_calculation from mt_w_response
end type
type uo_calculation from u_tccalculation within w_f_tc_calculation
end type
type cb_close from commandbutton within w_f_tc_calculation
end type
type cb_save from commandbutton within w_f_tc_calculation
end type
type st_9 from statictext within w_f_tc_calculation
end type
end forward

global type w_f_tc_calculation from mt_w_response
integer width = 3406
integer height = 1780
string title = "TC rate calculation"
uo_calculation uo_calculation
cb_close cb_close
cb_save cb_save
st_9 st_9
end type
global w_f_tc_calculation w_f_tc_calculation

type variables
datawindow	idw_fixturedetails
dec{2}		id_owntc, id_owntcdays

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_f_tc_calculation
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_f_tc_calculation.create
int iCurrent
call super::create
this.uo_calculation=create uo_calculation
this.cb_close=create cb_close
this.cb_save=create cb_save
this.st_9=create st_9
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_calculation
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.cb_save
this.Control[iCurrent+4]=this.st_9
end on

on w_f_tc_calculation.destroy
call super::destroy
destroy(this.uo_calculation)
destroy(this.cb_close)
destroy(this.cb_save)
destroy(this.st_9)
end on

event open;integer	li_pc_nr, li_pcgroup
long	ll_vesselid, ll_clarkid
long	ll_flatrateyear, ll_ratetypeid,ll_tradeid
string ls_errormessage, ls_dportid,ls_lportid

dec{2}	ld_rate, ld_cargoSize,ld_waitingdays

idw_fixturedetails = message.powerObjectParm

ll_vesselid = idw_fixturedetails.getitemnumber( 1, "vesselid")
ll_clarkid = idw_fixturedetails.getitemnumber( 1, "pf_fixture_vesselid_web")
ld_rate = idw_fixturedetails.getitemnumber( 1, "rate")
ll_flatrateyear = idw_fixturedetails.getitemnumber( 1, "flatrateyear")
ll_ratetypeid = idw_fixturedetails.getitemnumber( 1, "ratetypeid")
ld_cargoSize = idw_fixturedetails.getitemnumber( 1, "cargosize")
ll_tradeid =  idw_fixturedetails.getitemnumber( 1, "pf_fixture_tradeid")
ld_waitingdays = idw_fixturedetails.getitemnumber( 1, "waitindays")

 ls_dportid = idw_fixturedetails.getitemstring ( 1, "lportcode")
 ls_lportid =  idw_fixturedetails.getitemstring( 1, "dportcode")
 // li_pc_nr = idw_fixturedetails.getitemnumber( 1, "pc_nr")
 li_pcgroup = idw_fixturedetails.getitemnumber( 1, "pcgroup_id")
  
// if uo_calculation.uf_tccalculation(li_pc_nr, ll_vesselid, ll_clarkid, ld_rate, ll_flatrateyear,ll_ratetypeid,  ll_tradeid, ls_lportid,ls_dportid,   ld_cargoSize, ld_waitingdays,id_owntc, id_owntcdays, ls_errormessage)<>0 then
if uo_calculation.uf_tccalculation(li_pcgroup, ll_vesselid, ll_clarkid, ld_rate, ll_flatrateyear,ll_ratetypeid,  ll_tradeid, ls_lportid,ls_dportid,   ld_cargoSize, ld_waitingdays,id_owntc, id_owntcdays, ls_errormessage)<>0 then
	cb_save.enabled= false
	if ls_errormessage<>"" then
		Messagebox("TC calculation", ls_errormessage)
		close(this)
		return 0
	end if
end if


end event

type uo_calculation from u_tccalculation within w_f_tc_calculation
integer y = 140
integer height = 1384
integer taborder = 10
end type

on uo_calculation.destroy
call u_tccalculation::destroy
end on

type cb_close from commandbutton within w_f_tc_calculation
integer x = 3035
integer y = 1564
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

event clicked;close(parent)
end event

type cb_save from commandbutton within w_f_tc_calculation
integer x = 2464
integer y = 1564
integer width = 530
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Accept TC Calculation"
end type

event clicked;if id_owntc<>0 then
	idw_fixturedetails.setitem( 1, "maersktcrt", id_owntc)
end if
if id_owntcdays<>0 then
	idw_fixturedetails.setitem( 1, "maersktcrtdays", id_owntcdays)
end if

idw_fixturedetails.accepttext( )

close(parent)
end event

type st_9 from statictext within w_f_tc_calculation
integer x = 55
integer y = 36
integer width = 558
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "TC Calculation"
boolean focusrectangle = false
end type

