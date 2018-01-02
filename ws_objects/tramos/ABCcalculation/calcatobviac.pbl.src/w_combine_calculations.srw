$PBExportHeader$w_combine_calculations.srw
forward
global type w_combine_calculations from mt_w_sheet_calc
end type
type st_excludedcalcwarning from statictext within w_combine_calculations
end type
type cb_comb_calc from mt_u_commandbutton within w_combine_calculations
end type
type cb_refresh from mt_u_commandbutton within w_combine_calculations
end type
type st_total_laden_days from mt_u_statictext within w_combine_calculations
end type
type st_8 from mt_u_statictext within w_combine_calculations
end type
type st_total_ball_days from mt_u_statictext within w_combine_calculations
end type
type st_6 from mt_u_statictext within w_combine_calculations
end type
type st_total_days from mt_u_statictext within w_combine_calculations
end type
type st_4 from mt_u_statictext within w_combine_calculations
end type
type st_averge_tce from mt_u_statictext within w_combine_calculations
end type
type st_2 from mt_u_statictext within w_combine_calculations
end type
type st_1 from mt_u_statictext within w_combine_calculations
end type
type dw_calc_list from u_datagrid within w_combine_calculations
end type
end forward

global type w_combine_calculations from mt_w_sheet_calc
integer width = 3616
integer height = 1816
string title = "Combine Calculations"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
st_excludedcalcwarning st_excludedcalcwarning
cb_comb_calc cb_comb_calc
cb_refresh cb_refresh
st_total_laden_days st_total_laden_days
st_8 st_8
st_total_ball_days st_total_ball_days
st_6 st_6
st_total_days st_total_days
st_4 st_4
st_averge_tce st_averge_tce
st_2 st_2
st_1 st_1
dw_calc_list dw_calc_list
end type
global w_combine_calculations w_combine_calculations

type variables

end variables

forward prototypes
public subroutine documentation ()
public function integer wf_loadcombine_data (ref integer ai_counter, ref integer ai_excludedcounter)
end prototypes

public subroutine documentation ();/********************************************************************
   w_combine_calculations
   <OBJECT>		Combine two or more opened calculations	</OBJECT>
   <USAGE> </USAGE>
   <ALSO>		m_calcmain, w_atobviac_calc_calculation	</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	03-15-2013	CR2658		LHG008		First Version
		20-11-2013	CR2658UAT	WWG004		Change dw_calc_list as an extral datastore.
   </HISTORY>
********************************************************************/
end subroutine

public function integer wf_loadcombine_data (ref integer ai_counter, ref integer ai_excludedcounter);/********************************************************************
   wf_loadcombine_data
   <OBJECT>		Calculate combine calculation	</OBJECT>
   <USAGE>		Initnal combine data			</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	20/11/2013	CR2658UAT	WWG004		First Version
   </HISTORY>
********************************************************************/

w_atobviac_calc_calculation lw_calculation
s_calculation_combine		 lstr_calc_combine

window	lw_parent, lw_sheet
integer 	li_insertrow
long 		ll_vessel_type_id, ll_clarkson_id, ll_vesselid

lw_parent = w_tramos_main
lw_sheet	 = lw_parent.getfirstsheet()

dw_calc_list.reset()

do while isvalid(lw_sheet)
	if lw_sheet.classname() = "w_atobviac_calc_calculation" then	
		lw_calculation = lw_sheet
		
		//Get vessel id of last active calculation.
		if ai_counter = 0 then
			lw_calculation.uo_calculation.uf_get_vessel(ll_vessel_type_id, ll_vesselid, ll_clarkson_id)
		end if
		
		lw_calculation.uo_calculation.of_getcombinedata()
		
		lstr_calc_combine = lw_calculation.uo_calculation.istr_calc_combine
		
		//Only the same vessel and except Deleted, Offer and Loadload calculation can import to combine.
		if lstr_calc_combine.l_vesselid = ll_vesselid and &
			(lstr_calc_combine.i_status <> c#calculationstatus.il_DELETED and &
			lstr_calc_combine.i_status <> c#calculationstatus.il_OFFER and &
			lstr_calc_combine.i_status <> c#calculationstatus.il_LOADLOAD) then
				
			ai_counter ++
			
			if lstr_calc_combine.b_calculated then
				li_insertrow = dw_calc_list.insertrow(0)
				dw_calc_list.setitem(li_insertrow, "calc_status", lstr_calc_combine.i_status)
				dw_calc_list.setitem(li_insertrow, "vessel", lstr_calc_combine.s_vessel)
				dw_calc_list.setitem(li_insertrow, "description", lstr_calc_combine.s_calc_desc)
				dw_calc_list.setitem(li_insertrow, "ballast_from", lstr_calc_combine.s_ballastfrom)
				dw_calc_list.setitem(li_insertrow, "first_port", lstr_calc_combine.s_firstport)
				dw_calc_list.setitem(li_insertrow, "last_port", lstr_calc_combine.s_lastport)
				dw_calc_list.setitem(li_insertrow, "last_edited", lstr_calc_combine.dt_lastedited)
				dw_calc_list.setitem(li_insertrow, "created_by", lstr_calc_combine.s_createdby)
				dw_calc_list.setitem(li_insertrow, "tce_day", lstr_calc_combine.d_tceperday)
				dw_calc_list.setitem(li_insertrow, "total_days", lstr_calc_combine.d_totaldays)
				dw_calc_list.setitem(li_insertrow, "ballast_days", lstr_calc_combine.d_ballastdays)
				dw_calc_list.setitem(li_insertrow, "laden_days", lstr_calc_combine.d_ladendays)
			else
				ai_excludedcounter ++
			end if
		end if
	end if
	
	lw_sheet = lw_parent.getnextsheet(lw_sheet)
loop

return c#return.Success
end function

on w_combine_calculations.create
int iCurrent
call super::create
this.st_excludedcalcwarning=create st_excludedcalcwarning
this.cb_comb_calc=create cb_comb_calc
this.cb_refresh=create cb_refresh
this.st_total_laden_days=create st_total_laden_days
this.st_8=create st_8
this.st_total_ball_days=create st_total_ball_days
this.st_6=create st_6
this.st_total_days=create st_total_days
this.st_4=create st_4
this.st_averge_tce=create st_averge_tce
this.st_2=create st_2
this.st_1=create st_1
this.dw_calc_list=create dw_calc_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_excludedcalcwarning
this.Control[iCurrent+2]=this.cb_comb_calc
this.Control[iCurrent+3]=this.cb_refresh
this.Control[iCurrent+4]=this.st_total_laden_days
this.Control[iCurrent+5]=this.st_8
this.Control[iCurrent+6]=this.st_total_ball_days
this.Control[iCurrent+7]=this.st_6
this.Control[iCurrent+8]=this.st_total_days
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.st_averge_tce
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.dw_calc_list
end on

on w_combine_calculations.destroy
call super::destroy
destroy(this.st_excludedcalcwarning)
destroy(this.cb_comb_calc)
destroy(this.cb_refresh)
destroy(this.st_total_laden_days)
destroy(this.st_8)
destroy(this.st_total_ball_days)
destroy(this.st_6)
destroy(this.st_total_days)
destroy(this.st_4)
destroy(this.st_averge_tce)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_calc_list)
end on

event open;call super::open;n_dw_style_service	lnv_styleservice
n_service_manager		lnv_servicemanager

lnv_servicemanager.of_loadservice( lnv_styleservice , "n_dw_style_service")
lnv_styleservice.of_dwlistformater(dw_calc_list)

cb_refresh.triggerevent(clicked!)

dw_calc_list.object.datawindow.readonly = "Yes"
end event

type st_excludedcalcwarning from statictext within w_combine_calculations
integer x = 1833
integer y = 1568
integer width = 1029
integer height = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_comb_calc from mt_u_commandbutton within w_combine_calculations
integer x = 3232
integer y = 1568
integer width = 370
integer taborder = 30
string text = "&Combine Calc"
boolean default = true
end type

event clicked;call super::clicked;/********************************************************************
   clicked
   <DESC>	Combine two or more calculations	</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author	Comments
		03-15-2013	CR2658		LHG008	First Version
		20-11-2013	CR2658UAT	WWG004	Change datawindow to extral datasource
   </HISTORY>
********************************************************************/

decimal{4}	ldc_total_days, ldc_total_laden, ldc_total_ballast, ldc_total_tce, ldc_avg_tce
long			ll_row

if dw_calc_list.rowcount() <= 0 then return

ll_row = dw_calc_list.getselectedrow(ll_row)
do while ll_row > 0
	ldc_total_tce		+= dw_calc_list.getitemdecimal(ll_row, "tce_day") / c#decimal.AvgMonthDays
	ldc_total_days		+= dw_calc_list.getitemdecimal(ll_row, "total_days")
	ldc_total_laden	+= dw_calc_list.getitemdecimal(ll_row, "laden_days")
	ldc_total_ballast += dw_calc_list.getitemdecimal(ll_row, "ballast_days")
		
	ll_row = dw_calc_list.getselectedrow(ll_row)
loop

if ldc_total_days > 0 then
	ldc_avg_tce = ldc_total_tce / ldc_total_days
end if

st_averge_tce.text		 = string(round(ldc_avg_tce, 2), "#,##0.00")
st_total_days.text		 = string(round(ldc_total_days, 2), "#,##0.00")
st_total_ball_days.text  = string(round(ldc_total_ballast, 2), "#,##0.00")
st_total_laden_days.text = string(round(ldc_total_laden, 2), "#,##0.00")

end event

type cb_refresh from mt_u_commandbutton within w_combine_calculations
integer x = 2885
integer y = 1568
integer taborder = 20
string text = "&Refresh"
end type

event clicked;call super::clicked;integer li_excluded = 0, li_counter = 0

wf_loadcombine_data(li_counter, li_excluded)

if li_excluded > 0 then
	st_excludedcalcwarning.text = string(li_excluded) + " of " + string(li_counter) + " calculation(s) are excluded in selection due to having a (not calculated) state."
else
	st_excludedcalcwarning.text = ""
end if

uf_redraw_off()
st_averge_tce.text = "0.00"
st_total_days.text = "0.00"
st_total_ball_days.text = "0.00"
st_total_laden_days.text = "0.00"
uf_redraw_on()
end event

type st_total_laden_days from mt_u_statictext within w_combine_calculations
integer x = 1408
integer y = 1648
integer width = 366
boolean enabled = false
string text = "0.00"
alignment alignment = right!
boolean border = true
long bordercolor = 12632256
end type

type st_8 from mt_u_statictext within w_combine_calculations
integer x = 987
integer y = 1648
boolean enabled = false
string text = "Total laden days"
alignment alignment = right!
end type

type st_total_ball_days from mt_u_statictext within w_combine_calculations
integer x = 1408
integer y = 1568
integer width = 366
boolean enabled = false
string text = "0.00"
alignment alignment = right!
boolean border = true
long bordercolor = 12632256
end type

type st_6 from mt_u_statictext within w_combine_calculations
integer x = 987
integer y = 1568
boolean enabled = false
string text = "Total ballast days"
alignment alignment = right!
end type

type st_total_days from mt_u_statictext within w_combine_calculations
integer x = 457
integer y = 1648
integer width = 366
boolean enabled = false
string text = "0.00"
alignment alignment = right!
boolean border = true
long bordercolor = 12632256
end type

type st_4 from mt_u_statictext within w_combine_calculations
integer x = 37
integer y = 1648
boolean enabled = false
string text = "Total days"
alignment alignment = right!
end type

type st_averge_tce from mt_u_statictext within w_combine_calculations
integer x = 457
integer y = 1568
integer width = 366
boolean enabled = false
string text = "0.00"
alignment alignment = right!
boolean border = true
long bordercolor = 12632256
end type

type st_2 from mt_u_statictext within w_combine_calculations
integer x = 37
integer y = 1568
integer width = 398
boolean enabled = false
string text = "Average TCE/day"
alignment alignment = right!
end type

type st_1 from mt_u_statictext within w_combine_calculations
integer x = 37
integer y = 16
integer width = 951
boolean enabled = false
string text = "Please select a calculation to combine with."
end type

type dw_calc_list from u_datagrid within w_combine_calculations
integer x = 37
integer y = 96
integer width = 3547
integer height = 1456
integer taborder = 10
string dataobject = "d_ex_gr_combinecalcs"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event clicked;call super::clicked;if row > 0 then
	this.selectrow(row, not this.isselected(row))
end if
end event

