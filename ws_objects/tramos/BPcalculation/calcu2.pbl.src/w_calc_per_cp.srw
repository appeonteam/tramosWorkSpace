$PBExportHeader$w_calc_per_cp.srw
$PBExportComments$Calculations connected to a CP. Used when changing CP information so that user can confirm modification
forward
global type w_calc_per_cp from mt_w_response_calc
end type
type st_msg from statictext within w_calc_per_cp
end type
type dw_voyage from datawindow within w_calc_per_cp
end type
type cb_no from commandbutton within w_calc_per_cp
end type
type cb_yes from commandbutton within w_calc_per_cp
end type
type st_1 from statictext within w_calc_per_cp
end type
type dw_calc from datawindow within w_calc_per_cp
end type
end forward

global type w_calc_per_cp from mt_w_response_calc
integer width = 3822
integer height = 1616
string title = "Affected Calculations..."
boolean controlmenu = false
long backcolor = 32304364
string icon = "AppIcon!"
st_msg st_msg
dw_voyage dw_voyage
cb_no cb_no
cb_yes cb_yes
st_1 st_1
dw_calc dw_calc
end type
global w_calc_per_cp w_calc_per_cp

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_calc_per_cp
	
	<OBJECT>

	</OBJECT>
	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
	<ALSO>
	</ALSO>
   <HISTORY>
   	Date       	CR-Ref		Author            Comments
   	19/08/2013 	CR2950		WWA048        		Move the validation of claim balance from CP window to Affected Calculations window,
																disable 'Yes' button when there is a claim settled.
     	07/08/2014 	CR3708   	AGL027				F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_calc_per_cp.create
int iCurrent
call super::create
this.st_msg=create st_msg
this.dw_voyage=create dw_voyage
this.cb_no=create cb_no
this.cb_yes=create cb_yes
this.st_1=create st_1
this.dw_calc=create dw_calc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_msg
this.Control[iCurrent+2]=this.dw_voyage
this.Control[iCurrent+3]=this.cb_no
this.Control[iCurrent+4]=this.cb_yes
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dw_calc
end on

on w_calc_per_cp.destroy
call super::destroy
destroy(this.st_msg)
destroy(this.dw_voyage)
destroy(this.cb_no)
destroy(this.cb_yes)
destroy(this.st_1)
destroy(this.dw_calc)
end on

event open;long		ll_cerpid
string	ls_msg

u_modify_cp	lnv_modify_cp

ll_cerpid = message.doubleparm

dw_calc.setTransObject(sqlca)
dw_calc.post retrieve (ll_cerpid)

dw_voyage.setTransObject(sqlca)
dw_voyage.post retrieve (ll_cerpid)

n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_calc,false)
lnv_style.of_dwlistformater(dw_voyage,false)

if w_calc_cp_data.dw_calc_broker_data.modifiedcount() <= 0 and &
	(w_calc_cp_data.dw_calc_cp_data.getItemStatus(1, "cal_cerp_contract_type", Primary!) = dataModified! &
	or w_calc_cp_data.dw_calc_cp_data.getItemStatus(1, "cal_cerp_description", Primary!) = dataModified! &
	or w_calc_cp_data.dw_calc_cp_data.getItemStatus(1, "cal_cerp_date", Primary!) = dataModified!) and &
	(w_calc_cp_data.dw_calc_cp_data.getItemStatus(1, "chart_nr", Primary!) <> dataModified! and &
	w_calc_cp_data.dw_calc_cp_data.getItemStatus(1, "cal_cerp_city", Primary!) <> dataModified! and &
	w_calc_cp_data.dw_calc_cp_data.getItemStatus(1, "offices_office_sn", Primary!) <> dataModified! and &
	w_calc_cp_data.dw_calc_cp_data.getItemStatus(1, "cal_cerp_add_comm", Primary!) <> dataModified! and &
	w_calc_cp_data.dw_calc_cp_data.getItemStatus(1, "cal_cerp_timebar_days", Primary!) <> dataModified! and &
	w_calc_cp_data.dw_calc_cp_data.getItemStatus(1, "cal_cerp_noticebar_days", Primary!) <> dataModified! and &
	w_calc_cp_data.dw_calc_cp_data.getItemStatus(1, "cal_cerp_term", Primary!) <> dataModified!)  then
	return
else
	lnv_modify_cp = create u_modify_cp
	if lnv_modify_cp.of_checksettlement(ll_cerpid, ls_msg) = c#return.Failure then
		st_msg.text = ls_msg
		cb_yes.enabled = false
	end if
	destroy lnv_modify_cp
end if
end event

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_per_cp
end type

type st_msg from statictext within w_calc_per_cp
integer x = 32
integer y = 1392
integer width = 2441
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217857
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_voyage from datawindow within w_calc_per_cp
integer x = 2551
integer y = 164
integer width = 1225
integer height = 1200
integer taborder = 20
string title = "none"
string dataobject = "d_sq_gp_claims_per_cp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_no from commandbutton within w_calc_per_cp
integer x = 3429
integer y = 1400
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&No"
boolean default = true
end type

event clicked;closewithreturn(parent,0)
end event

type cb_yes from commandbutton within w_calc_per_cp
integer x = 3067
integer y = 1400
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Yes"
end type

event clicked;closewithreturn(parent,1)

end event

type st_1 from statictext within w_calc_per_cp
integer x = 37
integer y = 20
integer width = 3291
integer height = 144
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Following Calculations and Voyages/Claims are connected to the C/P that you are about to change. Are you sure you want to complete the changes? "
boolean focusrectangle = false
end type

type dw_calc from datawindow within w_calc_per_cp
integer x = 32
integer y = 164
integer width = 2441
integer height = 1200
integer taborder = 10
string title = "none"
string dataobject = "d_sq_gp_calc_per_cp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

