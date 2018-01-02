$PBExportHeader$w_off_service_file.srw
$PBExportComments$Used to export Off Service Information to file
forward
global type w_off_service_file from mt_w_sheet
end type
type dw_date from u_datagrid within w_off_service_file
end type
type cbx_selectall from mt_u_checkbox within w_off_service_file
end type
type st_pleasewait from mt_u_statictext within w_off_service_file
end type
type dw_office from u_datagrid within w_off_service_file
end type
type cbx_showactualearnings from mt_u_checkbox within w_off_service_file
end type
type cb_retrieve from mt_u_commandbutton within w_off_service_file
end type
type cb_saveas from mt_u_commandbutton within w_off_service_file
end type
type hpb_loadingbunker from mt_u_hprogressbar within w_off_service_file
end type
type dw_1 from u_datagrid within w_off_service_file
end type
type cbx_office from mt_u_checkbox within w_off_service_file
end type
type gb_3 from mt_u_groupbox within w_off_service_file
end type
type gb_1 from mt_u_groupbox within w_off_service_file
end type
type st_background from u_topbar_background within w_off_service_file
end type
type dw_2 from u_datagrid within w_off_service_file
end type
type st_rows from statictext within w_off_service_file
end type
end forward

global type w_off_service_file from mt_w_sheet
integer width = 4626
integer height = 2604
string title = "Off-Hire File"
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
dw_date dw_date
cbx_selectall cbx_selectall
st_pleasewait st_pleasewait
dw_office dw_office
cbx_showactualearnings cbx_showactualearnings
cb_retrieve cb_retrieve
cb_saveas cb_saveas
hpb_loadingbunker hpb_loadingbunker
dw_1 dw_1
cbx_office cbx_office
gb_3 gb_3
gb_1 gb_1
st_background st_background
dw_2 dw_2
st_rows st_rows
end type
global w_off_service_file w_off_service_file

type variables
string is_office_filter
n_service_manager inv_servicemgr

end variables

forward prototypes
public function long of_seconds (datetime ld_start_datetime, datetime ld_end_datetime)
public function decimal of_offservice (datetime user_start_date, datetime start_date, datetime user_end_date, datetime end_date)
public subroutine of_dmy_seconds (ref long al_days, ref long al_hours, ref long al_minutes, decimal adc_percentage)
private function decimal wf_getbunkervalue (string as_fueltype, datastore ads_offservice_detail, long al_offservice_id)
public function long wf_selectall (u_datagrid adw_filter, checkbox acbx_selectall)
end prototypes

public function long of_seconds (datetime ld_start_datetime, datetime ld_end_datetime);date ld_start_date, ld_end_date
time lt_start_time, lt_end_time
long ll_days, ll_seconds_start, ll_seconds_end, ll_seconds_total


ld_start_date = date(ld_start_datetime)
ld_end_date = date(ld_end_datetime)
lt_start_time = time(ld_start_datetime)
lt_end_time = time(ld_end_datetime)

ll_days = daysafter (ld_start_date, ld_end_date)-1	

ll_seconds_start = secondsafter (lt_start_time, 23:59:59)+1
ll_seconds_end = secondsafter (00:00:00, lt_end_time)
ll_seconds_total = ll_seconds_start + ll_seconds_end + (ll_days*24*60*60)

return ll_seconds_total
end function

public function decimal of_offservice (datetime user_start_date, datetime start_date, datetime user_end_date, datetime end_date);decimal lde_percentage
long ll_seconds_period, ll_seconds_fraction, ll_seconds_total

ll_seconds_period = of_seconds(start_date,end_date)

if (ll_seconds_period <> 0) then


	// Denne er ok
	if (user_start_date > start_date) and (user_end_date >= end_date) then
		ll_seconds_fraction = of_seconds(user_start_date, end_date)
		lde_percentage = ll_seconds_fraction/ll_seconds_period
		return lde_percentage
	end if	
	
	// Denne er ok. 	
	if (user_start_date <= start_date) and (user_end_date >= end_date) then
		return 1
	end if
	
	// Denne er ok
	if (start_date >= user_start_date) and (end_date > user_end_date) then
		ll_seconds_fraction = of_seconds(start_date, user_end_date)
		lde_percentage = ll_seconds_fraction/ll_seconds_period
		return lde_percentage
	end if	
	
	//Denne er ok
	if (user_start_date > start_date and user_end_date < end_date) then
		ll_seconds_fraction = of_seconds(user_start_date, user_end_date)	
		lde_percentage = ll_seconds_fraction / ll_seconds_period
		return lde_percentage
	end if

end if

return 1



end function

public subroutine of_dmy_seconds (ref long al_days, ref long al_hours, ref long al_minutes, decimal adc_percentage);long ll_seconds, ll_days_adjusted, ll_hours_adjusted, ll_minutes_adjusted

ll_seconds = ((al_days*24*60*60)+(al_hours*60*60)+(al_minutes*60))*adc_percentage
ll_days_adjusted = (ll_seconds - mod(ll_seconds, (24*60*60)))/(24*60*60)
ll_hours_adjusted = (mod(ll_seconds, (24*60*60)) - mod(mod(ll_seconds, (24*60*60)), (60*60)))/(60*60)
ll_minutes_adjusted = mod(mod(ll_seconds, (24*60*60)), (60*60)) / 60

al_days = ll_days_adjusted
al_hours = ll_hours_adjusted
al_minutes = ll_minutes_adjusted
end subroutine

private function decimal wf_getbunkervalue (string as_fueltype, datastore ads_offservice_detail, long al_offservice_id);long ll_row, ll_vessel
string ls_voyage
decimal ld_used, ld_startstock, ld_priceperton, ld_total

//		ll_row = ads_offservice_detail.retrieve( al_offservice_id )
//		// verify that there is exactly one row 
//		if (ll_row <> 1) then
//			MessageBox("Information", &
//				"Not able to retrieve OffService or too many OffService Items Retrieved. "+&
//				"(Object: n_voyage_offservice_bunker_consumption, Function: of_showcalculation)" &
//				)
//			return -1
//		end if
//
//		ll_vessel 		= ads_offservice_detail.getItemNumber(ll_row, "vessel_nr")
//		ls_voyage 		= ads_offservice_detail.getItemString(ll_row, "voyage_nr")
//
//
//		// update of bunker price columns is set in overridden method below
//		// if lnv_bunker.of_showcalculation(  ll_ops_offserviceID, dw_1, li_row)=-1 then exit
//
//		ld_total=0
//		// grab HFO used
//		ld_used	= lds_data.getItemDecimal(ll_row, "off_fuel_oil_used")
//		// if this is a legal value
//		if ((not isnull(ld_used)) and (ld_used <> 0)) then
//			// how much did we start with? 
//			ld_startstock	= lds_data.getItemDecimal(ll_row, "hfo_stock_start")
//			// compute the price of HFO used during that period 
//			lnv_bunker.of_price_proposal( "HFO", ll_vessel, ls_voyage, ldt_start, ld_startstock, ld_used, ld_priceperton, ldt_end )
//			// the total is the amount used time the price per ton
//			ld_total = ld_used * ld_priceperton
//		end if			
//
return ld_total
end function

public function long wf_selectall (u_datagrid adw_filter, checkbox acbx_selectall);/********************************************************************
   wf_selectall
   <DESC>	Change select all checkbox text and 
				filter change request report	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_filter: Filter datawindow
		acbx_selectall: checkbox for select all
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date             CR-Ref       Author             Comments
   	2014/06/10   CR3426      SSX014           First Version
   </HISTORY>
********************************************************************/

if acbx_selectall.checked then	
	acbx_selectall.text = "Deselect all"
else
	acbx_selectall.text = "Select all"
end if

acbx_selectall.textcolor = c#color.White

// Change the filter selection status
adw_filter.selectrow(0, acbx_selectall.checked)

return 1
end function

on w_off_service_file.create
int iCurrent
call super::create
this.dw_date=create dw_date
this.cbx_selectall=create cbx_selectall
this.st_pleasewait=create st_pleasewait
this.dw_office=create dw_office
this.cbx_showactualearnings=create cbx_showactualearnings
this.cb_retrieve=create cb_retrieve
this.cb_saveas=create cb_saveas
this.hpb_loadingbunker=create hpb_loadingbunker
this.dw_1=create dw_1
this.cbx_office=create cbx_office
this.gb_3=create gb_3
this.gb_1=create gb_1
this.st_background=create st_background
this.dw_2=create dw_2
this.st_rows=create st_rows
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_date
this.Control[iCurrent+2]=this.cbx_selectall
this.Control[iCurrent+3]=this.st_pleasewait
this.Control[iCurrent+4]=this.dw_office
this.Control[iCurrent+5]=this.cbx_showactualearnings
this.Control[iCurrent+6]=this.cb_retrieve
this.Control[iCurrent+7]=this.cb_saveas
this.Control[iCurrent+8]=this.hpb_loadingbunker
this.Control[iCurrent+9]=this.dw_1
this.Control[iCurrent+10]=this.cbx_office
this.Control[iCurrent+11]=this.gb_3
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.st_background
this.Control[iCurrent+14]=this.dw_2
this.Control[iCurrent+15]=this.st_rows
end on

on w_off_service_file.destroy
call super::destroy
destroy(this.dw_date)
destroy(this.cbx_selectall)
destroy(this.st_pleasewait)
destroy(this.dw_office)
destroy(this.cbx_showactualearnings)
destroy(this.cb_retrieve)
destroy(this.cb_saveas)
destroy(this.hpb_loadingbunker)
destroy(this.dw_1)
destroy(this.cbx_office)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.st_background)
destroy(this.dw_2)
destroy(this.st_rows)
end on

event open;call super::open;datetime ldt_start
datetime ldt_end
integer li_pc[], li_row, li_row_count, li_count
datawindowchild ldwc
n_dw_style_service   lnv_style

// Set today as default value for both start and end
ldt_start = datetime(today(),time("00:00:00"))
ldt_end = ldt_start
dw_date.setitem(1,"start_dt", ldt_start)
dw_date.setitem(1,"end_dt", ldt_end)
dw_date.Modify("start_dt.background.color="+string(c#color.MT_MAERSK))
dw_date.Modify("end_dt.background.color="+string(c#color.MT_MAERSK))


dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_office.SetTransobject( SQLCA)
dw_2.Retrieve( uo_global.is_userid )

inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_1, false)

li_row_count=dw_2.rowcount( )
if li_row_count > 0 then
	FOR li_row = 1 TO li_row_count
		li_pc[li_row] = dw_2.getitemnumber(li_row, "PC_NR")
	NEXT
end if

dw_office.getchild("office_nr", ldwc)
ldwc.settransobject(SQLCA)
ldwc.retrieve( li_pc )

dw_office.Retrieve(uo_global.is_userid)


if (uo_global.ib_rowsindicator) then
	dw_2.setrowfocusindicator(FOCUSRECT!)
	dw_1.setrowfocusindicator(FOCUSRECT!)
end if
end event

event ue_addignoredcolorandobject;call super::ue_addignoredcolorandobject;anv_guistyle.of_addignoredobject(cbx_selectall)
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_off_service_file
integer x = 2336
integer y = 0
end type

type dw_date from u_datagrid within w_off_service_file
integer x = 1696
integer y = 32
integer width = 475
integer height = 160
integer taborder = 20
string dataobject = "d_start_end_date"
boolean border = false
end type

event constructor;this.InsertRow(0)
end event

type cbx_selectall from mt_u_checkbox within w_off_service_file
integer x = 613
integer y = 16
integer width = 329
integer height = 56
integer taborder = 10
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Select all"
end type

event clicked;call super::clicked;parent.wf_selectall(dw_2, this )

end event

type st_pleasewait from mt_u_statictext within w_off_service_file
boolean visible = false
integer x = 1865
integer y = 1204
integer width = 658
integer height = 160
string text = "  Please wait..."
boolean border = true
end type

type dw_office from u_datagrid within w_off_service_file
boolean visible = false
integer x = 1125
integer y = 172
integer width = 421
integer height = 64
integer taborder = 30
boolean enabled = false
string dataobject = "d_office_user_pc"
boolean border = false
end type

type cbx_showactualearnings from mt_u_checkbox within w_off_service_file
integer x = 1042
integer y = 92
integer width = 603
integer height = 56
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Include Actual Earnings"
end type

event clicked;if this.checked and cbx_office.checked then
	cbx_office.checked=false
	cbx_office.text="Office breakdown"
	dw_office.visible=false
end if
end event

type cb_retrieve from mt_u_commandbutton within w_off_service_file
integer x = 3890
integer y = 2392
integer taborder = 70
string text = "&Retrieve"
end type

event clicked;/********************************************************************
   cb_retrieve.event clicked( )
   <DESC>Determines the datawindow to use and populates some calculated columns</DESC>
   <RETURN></RETURN>
   <ACCESS>Public</ACCESS>
   <ARGS></ARGS>
   <USAGE>  How to use this function.</USAGE>
	<LASTUPDATED>AGL027 - 20091016</LASTUPDATED>
********************************************************************/

datetime ld_start_date, ld_end_date
datetime ldt_start, ldt_end
integer li_count=0, a[], li_row, li_row_count
long ll_days, ll_hours, ll_minutes, ll_ops_offserviceID, ll_vessel
decimal lde_percentage, ld_priceperton, ld_used, ld_startstock, ld_HFO, ld_DO, ld_GO, ld_LSHFO
string ls_voyage
pointer oldpointer
n_voyage_offservice_bunker_consumption lnv_bunker
n_dw_style_service   lnv_style

if cbx_showactualearnings.checked then
	// off service plus actual earning records
	dw_1.dataobject =	"d_off_services_file_actual_earnings"
elseif cbx_office.checked and dw_office.getitemnumber( dw_office.getrow() ,"office_nr" )>0 then
	// off service with office number and bunker quantities
	dw_1.dataobject =	"d_off_services_file_office"
else
	// original dw containing off service records
	dw_1.dataobject =	"d_off_services_file"
end if

dw_1.settransobject(SQLCA)
inv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_1, false)

li_row_count = dw_2.rowcount()

if li_row_count > 0 then
	for li_row = 1 TO li_row_count
		if (dw_2.isselected(li_row)) then
			li_count++
			a[li_count] = dw_2.getitemnumber(li_row, "PC_NR")
		end if
	next
	if li_count = 0 then
		MessageBox("Select profitcenter", "Please select one or more profitcenter(s)", Information!, Ok!, 1)
		Return
	end if 
end if

// validate user criteria for dates
dw_date.accepttext( )
ld_start_date = dw_date.GetItemDatetime(1,"start_dt")
ld_end_date = dw_date.GetItemDatetime(1,"end_dt")

if (ld_end_date < ld_start_date) then
	messagebox ("Date Error", "Your end date comes before your start date. Please enter a new end date", Information!, Ok!)
	return
end if

if cbx_office.checked then
	if dw_office.getitemnumber( dw_office.getrow() ,"office_nr" )>0 then
			st_pleasewait.visible=true
			hpb_loadingbunker.position=0
			hpb_loadingbunker.visible=true
	end if
end if

dw_1.retrieve(ld_start_date, ld_end_date,a)

if hpb_loadingbunker.visible then
	hpb_loadingbunker.position = 20
end if

// filter the list if office checked
if cbx_office.checked then
	if dw_office.getitemnumber( dw_office.getrow() ,"office_nr" )>0 then
		oldpointer = SetPointer(HourGlass!)
		lnv_bunker = create n_voyage_offservice_bunker_consumption	
		is_office_filter="claim_office_office_nr=" + string(dw_office.getitemnumber( dw_office.getrow() ,"office_nr" ))
		dw_1.setfilter(is_office_filter)
		dw_1.filter()
		dw_1.selectrow( 0, false)
		dw_1.selectrow( dw_1.getrow(), true)
		st_rows.text = string(dw_1.rowcount()) + " row(s)"
	else
		return
	end if
end if

li_row_count = dw_1.rowcount()

if li_row_count > 0 then
	
	for li_row = 1 to li_row_count
		ldt_start=dw_1.getitemdatetime(li_row,"off_services_off_start") 
		ldt_end=dw_1.getitemdatetime(li_row,"off_services_off_end") 		
		
		// use voyage char length to test if Actual Earning record, calculate adjusted days/hours/minutes		
		if len(dw_1.getitemstring( li_row, "off_services_voyage_nr"))<5 then
			if	dw_1.getitemdatetime(li_row,"off_services_off_start")>datetime(ld_start_date) then 
				// do nothing
			else
				ldt_start=datetime(ld_start_date)
			end if
			if	dw_1.getitemdatetime(li_row,"off_services_off_end")<datetime(ld_end_date) then 
				// do nothing
			else
				ldt_end=datetime(ld_end_date)
			end if

			ll_minutes = f_timedifference(dw_1.getitemdatetime(li_row,"off_services_off_start"),dw_1.getitemdatetime(li_row,"off_services_off_end"))
			ll_days = Int(ll_minutes/1440)
			ll_hours = ( ll_minutes - ( ll_days * 1440 ) ) / 60 
			ll_minutes = ll_minutes - (ll_days * 1440 ) - ( ll_hours * 60 )
			dw_1.setitem(li_row, "off_services_off_time_days", ll_days)
			dw_1.setitem(li_row, "off_services_off_time_hours", ll_hours)
			dw_1.setitem(li_row, "off_services_off_time_minutes", ll_minutes)						
			
			ll_minutes = f_timedifference(ldt_start,ldt_end)
			ll_days = Int(ll_minutes/1440)
			ll_hours = ( ll_minutes - ( ll_days * 1440 ) ) / 60 
			ll_minutes = ll_minutes - (ll_days * 1440 ) - ( ll_hours * 60 )
		else	
			// original code for off service records
			lde_percentage = of_offservice(datetime(ld_start_date), dw_1.GetItemDatetime(li_row, "off_services_off_start"), datetime(ld_end_date),dw_1.GetItemDatetime(li_row, "off_services_off_end"))
			ll_days = dw_1.getitemnumber(li_row,"off_services_off_time_days")
			ll_hours = dw_1.getitemnumber(li_row,"off_services_off_time_hours")
			ll_minutes = dw_1.getitemnumber(li_row,"off_services_off_time_minutes")
			of_dmy_seconds (ll_days, ll_hours, ll_minutes, lde_percentage)
		end if
		dw_1.setitem(li_row, "Adjusted_days", ll_days)
		dw_1.setitem(li_row, "Adjusted_hours", ll_hours)
		dw_1.setitem(li_row, "Adjusted_minutes", ll_minutes)			
		// locate bunker prices for offservice if office option checked
		if cbx_office.checked then

			ll_ops_offserviceID=dw_1.getitemnumber( li_row, "off_services_ops_off_service_id")	
			if lnv_bunker.of_loadbunkervalues( ll_ops_offserviceID, ld_hfo, ld_do, ld_go, ld_lshfo ) <> -1 then 
				dw_1.setitem(li_row, "hfo_value", ld_hfo)
				dw_1.setitem(li_row, "do_value", ld_do)
				dw_1.setitem(li_row, "go_value", ld_go)			
				dw_1.setitem(li_row, "lshfo_value", ld_lshfo)
			end if
			hpb_loadingbunker.position = 20 + int((80/li_row_count)*li_row) 			
		end if
	next

end if

if cbx_office.checked then 
	destroy lnv_bunker		
	st_pleasewait.visible=false
	hpb_loadingbunker.visible=false
	SetPointer(oldpointer)
end if

end event

type cb_saveas from mt_u_commandbutton within w_off_service_file
integer x = 4238
integer y = 2392
integer taborder = 80
string text = "&Save As..."
end type

event clicked;dw_1.SaveAs("", Excel8!, true)
end event

type hpb_loadingbunker from mt_u_hprogressbar within w_off_service_file
boolean visible = false
integer x = 1883
integer y = 1268
boolean bringtotop = true
integer setstep = 5
end type

type dw_1 from u_datagrid within w_off_service_file
integer x = 37
integer y = 624
integer width = 4544
integer height = 1736
integer taborder = 60
string dataobject = "d_off_services_file"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;this.selectrow( 0, false)
this.selectrow( currentrow, true)
end event

event retrieveend;call super::retrieveend;st_rows.text = string(this.rowcount()) + " row(s)"
end event

type cbx_office from mt_u_checkbox within w_off_service_file
integer x = 1042
integer y = 172
integer width = 585
integer height = 56
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Office breakdown"
end type

event clicked;if this.checked then
	dw_office.visible=true
	dw_office.enabled=true
	cbx_showactualearnings.checked=false
	this.text=""
else
	dw_office.visible=false
	dw_office.enabled=false
	this.text="Office breakdown"
	is_office_filter=""
//	dw_1.setfilter(is_office_filter)
//	dw_1.filter()
end if


end event

type gb_3 from mt_u_groupbox within w_off_service_file
integer x = 37
integer y = 16
integer width = 933
integer height = 544
integer taborder = 10
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Profit Center(s)"
end type

type gb_1 from mt_u_groupbox within w_off_service_file
integer x = 1006
integer y = 16
integer width = 677
integer height = 260
integer taborder = 10
integer weight = 400
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Options"
end type

type st_background from u_topbar_background within w_off_service_file
integer width = 7954
integer height = 592
end type

type dw_2 from u_datagrid within w_off_service_file
integer x = 73
integer y = 80
integer width = 859
integer height = 448
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
end type

event constructor;call super::constructor;this.retrieve(uo_global.is_userid)
end event

event clicked;call super::clicked;if (row > 0) then
	this.SelectRow(row, not this.IsSelected(row) )
end if

end event

type st_rows from statictext within w_off_service_file
integer x = 37
integer y = 2392
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "0 Row(s)"
boolean focusrectangle = false
end type

