$PBExportHeader$n_vas_data_periodresult.sru
forward
global type n_vas_data_periodresult from mt_n_nonvisualobject
end type
end forward

global type n_vas_data_periodresult from mt_n_nonvisualobject autoinstantiate
end type

type variables
decimal id_offs_mins, id_idle_mins, id_offs_mins_periodresult, id_idle_mins_periodresult
end variables

forward prototypes
public subroutine documentation ()
public function integer of_getvasdatapermonth (integer ai_pc_nr[], datetime adt_start_date, datetime adt_end_date, ref datawindow adw_vasdata_per_month, ref hprogressbar vpb_progress_voyages, ref datawindow adw_vas_report, string as_vessel_filter, ref hprogressbar vpb_progress_pcs)
private subroutine _setoffserviceidledays (datetime adt_start_date, datetime adt_end_date, integer ai_vessel_nr, string as_voyage_nr, datawindow adw_to, integer ai_to_row, datawindow adw_vas_report, boolean abl_set_idle_days)
private subroutine _setvasdetailbymonth (ref datawindow adw_from, ref datawindow adw_to, integer ai_to_row, decimal ld_percent, decimal ld_percent_days)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_vas_data_periodresult

   <OBJECT>This object is used to handle all business logic for getting the VAS report by a date range.</OBJECT>
	
   <DESC>Uses a store procedure(SP_GETVOYAGELIST) in dataobject to generate voyage/vessel list conatined in 
			  date range and profit center array. Then loops through each voyage/vessel to obtain values needed 
			  from VAS report.</DESC>
			  
   <USAGE>  Called from w_super_vas_reports_periodresults retrieve button</USAGE>
	
   Date   	Ref   	Author      Comments
  20/01/11	2318     JSU042   	initial version
  09/06/11				AGL027		<maintenance> changed to use common datefunction
  08/08/11	2501		JSU042		days should be the exact days within the period, not prorated.
  											earnings and costs should be prorated, 
											% = exact net days within the period / voayge's total net days
  13/09/11	2576		JSU042		use two %
  											one for profit
											one for days,idle days are taken out when calculating the % for days											
  16/10/12	CR2978	ZSW001		Divide by zero error
  21/07/15	CR3644	CCY018		Add Grade Group column to Reports.
********************************************************************/

end subroutine

public function integer of_getvasdatapermonth (integer ai_pc_nr[], datetime adt_start_date, datetime adt_end_date, ref datawindow adw_vasdata_per_month, ref hprogressbar vpb_progress_voyages, ref datawindow adw_vas_report, string as_vessel_filter, ref hprogressbar vpb_progress_pcs);/********************************************************************
   of_getvasdatapermonth()
   <DESC>   This function runs through each voyages and break down the
	VAS detail by month.</DESC>
   <RETURN> Integer:
            <LI> >0, X Succed
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   </ARGS>
   <USAGE>  When user clicks the retreive button</USAGE>
********************************************************************/

long 						ll_number_of_voyages, ll_row, ll_tce_row, ll_type, ll_grade, ll_grade_counts
u_vas_control 			lu_vas_control
s_vessel_voyage_list  lstr_vessel_voyage_list[]
integer 					li_year, li_control_return, li_key[], li_month, li_month_lastday, li_row, ll_count ,li_contract, li_vessel_nr
decimal					ld_calcid, ld_percent,ld_percent_days, ld_year_overlap, ld_secs_offs, ld_secs_idle, ld_secs_net
datetime					ldt_voyagestart, ldt_voyageend, ldt_start, ldt_end, ldt_temp, ldt_month_start, ldt_month_end
mt_n_datastore 		ids_voyages, lds_tccontract, lds_grade_group
mt_n_datefunctions	lnv_mt_datefunc
string					ls_profitcenter, ls_voyage_nr, ls_grade_group, ls_grade_list
integer li_act_year, li_act_month

lds_tccontract = create mt_n_datastore
lds_tccontract.dataobject = "d_sq_tb_tccontract_by_vessel"
lds_tccontract.settransobject(sqlca)

lds_grade_group = create mt_n_datastore
lds_grade_group.dataobject = "d_sq_tb_periodresult_gradegroup"
lds_grade_group.settransobject(sqlca)

// set the progress bar
vpb_progress_pcs.maxPosition = upperbound(ai_pc_nr)
	
//run through each profitcenter
for ll_count = 1 to upperbound(ai_pc_nr)
	// set the progress bar 
	vpb_progress_pcs.position = ll_count
		
	// retrieve voyages list
	ids_voyages = create mt_n_datastore
   ids_voyages.dataobject = "d_sp_tb_voyages_list_by_pc_by_period"
   ids_voyages.settrans(sqlca)
   ids_voyages.retrieve(ai_pc_nr[ll_count], adt_start_date, adt_end_date)

	//apply vessel filter for voyages list
	ids_voyages.setfilter("vessel_nr in ("+as_vessel_filter+")")
	ids_voyages.filter()
	ll_number_of_voyages = ids_voyages.rowcount()
	
	if ll_number_of_voyages <= 0 then continue
		
	// create user object
	lu_vas_control = create u_vas_control
	
	// set the progress bar
	vpb_progress_voyages.maxPosition = ll_number_of_voyages
	
	// run through each voyages, save the VAS detail by month on a basic datastore (dw_vas_report_base) for late use 
	for ll_row = 1 to ll_number_of_voyages
		// set the progress bar 
		vpb_progress_voyages.position = ll_row
		
		li_vessel_nr = ids_voyages.getItemNumber(ll_row, "vessel_nr")
		ls_voyage_nr = ids_voyages.getItemString(ll_row, "voyage_nr")
		lstr_vessel_voyage_list[1].vessel_nr = li_vessel_nr
		lstr_vessel_voyage_list[1].voyage_nr = ls_voyage_nr
		li_year = integer(mid(lstr_vessel_voyage_list[1].voyage_nr,1,2))
		
		// if voyage not allocated to calculation continue 
		SELECT CAL_CALC_ID, VOYAGE_TYPE INTO :ld_calcid, :ll_type FROM VOYAGES WHERE VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr AND VOYAGE_NR like :lstr_vessel_voyage_list[1].voyage_nr+"%" ;
	
		if ld_calcid < 2 and ll_type <> 2 then continue   

		// locates the VAS detail in dw_vas_report 
		adw_vas_report.reset()
		li_control_return = lu_vas_control.of_master_control( 1, li_key[], lstr_vessel_voyage_list[], li_year, adw_vas_report)
		
		if adw_vas_report.rowcount() <= 0 then continue
		
		if IsValid(w_super_vas_reports_periodresults) then
			w_super_vas_reports_periodresults.st_progress.text = "Retrieving data for " + adw_vas_report.getitemstring(1,"profit_center") + " profitcenter, please wait."
		end if
	
		/* seperate the VAS detail by month and store in adw_vasdata_per_month */
		
		//get voyage's start and end dates
		ldt_voyagestart = adw_vas_report.getItemDatetime(1, "voyage_startdate")
		ldt_voyageend = adw_vas_report.getItemDatetime(1, "voyage_enddate")	
		//get dates
		if ldt_voyagestart >= adt_start_date and ldt_voyageend <= adt_end_date then
			ldt_start = ldt_voyagestart
			ldt_end = ldt_voyageend
		end if
		if ldt_voyagestart <= adt_start_date and ldt_voyageend <= adt_end_date then
			ldt_start = adt_start_date
			ldt_end = ldt_voyageend
		end if
		if ldt_voyagestart >= adt_start_date and ldt_voyageend >= adt_end_date then
			ldt_start = ldt_voyagestart
			ldt_end = adt_end_date
		end if	
		if ldt_voyagestart <= adt_start_date and ldt_voyageend >= adt_end_date then
			ldt_start = adt_start_date
			ldt_end = adt_end_date
		end if
		 
		// get voyage's total net days 
		ld_secs_net = lnv_mt_datefunc.of_secondsafter(ldt_voyagestart, ldt_voyageend)

		for li_month = month(date(ldt_start)) to lnv_mt_datefunc.of_monthsafter(date(ldt_start), date(ldt_end)) 
			//dates prepare for breaking down into detail by month
			if li_month = month(date(ldt_start)) then // first month
				if month(date(ldt_start)) = month(date(ldt_end)) and year(date(ldt_start)) = year(date(ldt_end)) then //period is in the same month
					ldt_month_start = ldt_start
					ldt_month_end = ldt_end
				else//period is in the different month
					ldt_month_start = ldt_start
					ldt_month_end = datetime(string(year(date(ldt_start)) + integer(li_month / 12)) + "/" + string(mod(li_month, 12) + 1) + "/01")
				end if
			elseif li_month = lnv_mt_datefunc.of_monthsafter(date(ldt_start), date(ldt_end)) then //Last month
				ldt_month_start = datetime(lnv_mt_datefunc.of_firstdateinmonth(date(ldt_end)))
				ldt_month_end = ldt_end
			else // middle month
				ld_year_overlap = li_month/month(date(ldt_start))
				if li_month > 12 then
					li_month_lastday = lnv_mt_datefunc.of_lastdayofmonth(date(string(year(date(ldt_start)) + integer(ld_year_overlap) )+"/"+string( li_month - 12*integer(ld_year_overlap) )+"/01"))
				else
					li_month_lastday = lnv_mt_datefunc.of_lastdayofmonth(date(string(year(date(ldt_start)))+"/"+string(li_month)+"/01"))
				end if
				ldt_month_start = datetime(string(year(date(ldt_start)) + integer((li_month - 1) / 12)) + "/" + string(mod(li_month - 1, 12) + 1) + "/01")
				ldt_month_end = datetime(string(year(date(ldt_start)) + integer(li_month / 12)) + "/" + string(mod(li_month, 12) + 1) + "/01")
			end if
			/* set VAS detail figures per vessel per voyage per month into adw_vasdata_per_month */
			li_row = adw_vasdata_per_month.insertrow(0)
			//set dates 
			adw_vasdata_per_month.setitem(li_row,"date_range",  string(adt_start_date, "d-mmm-yy hh:mm") + " - " +  string(adt_end_date, "d-mmm-yy hh:mm"))
			adw_vasdata_per_month.setitem(li_row,"month",  li_month)
			adw_vasdata_per_month.setitem(li_row,"year", year(date(ldt_start)))
			
			li_act_year = year(date(ldt_start)) + int((li_month -1)/12)
			li_act_month = mod(li_month -1, 12) + 1
			ll_grade_counts = lds_grade_group.retrieve(li_vessel_nr, ls_voyage_nr, li_act_year, li_act_month)
		
			ls_grade_list = ""
			for ll_grade = 1 to ll_grade_counts
				ls_grade_group = lds_grade_group.getitemstring( ll_grade, "grade_group")
				if isnull(ls_grade_group) then ls_grade_group = ""
				if trim(ls_grade_group) <> "" then 
					if ls_grade_list <> "" then ls_grade_list = ls_grade_list + ","
					ls_grade_list = ls_grade_list + ls_grade_group
				end if
			next
			
			adw_vasdata_per_month.setitem(li_row,"grade_group",  ls_grade_list)
			
			//set exact offhire/idle days within the period
			if li_month = month(date(ldt_start)) then
				_setoffserviceidledays(ldt_month_start,ldt_month_end, li_vessel_nr, ls_voyage_nr, adw_vasdata_per_month, li_row, adw_vas_report, true)
			else
				_setoffserviceidledays(ldt_month_start,ldt_month_end, li_vessel_nr, ls_voyage_nr, adw_vasdata_per_month, li_row, adw_vas_report, false)
			end if
			/***************get the percentage*******************/
			//the percentage for profit, 
			//CR2978: Divide by zero error.
			if ld_secs_net = id_offs_mins * 60 then
				ld_percent = 0
			else
				ld_percent = (lnv_mt_datefunc.of_secondsafter(ldt_month_start, ldt_month_end)- id_offs_mins_periodresult*60)  / (ld_secs_net - id_offs_mins*60)
			end if
			//the percentage for days, the idle days are taken out 
			if ld_secs_net = id_idle_mins * 60 + id_offs_mins * 60 then
				ld_percent_days = 0
			else
				ld_percent_days = (lnv_mt_datefunc.of_secondsafter(ldt_month_start, ldt_month_end)- id_idle_mins_periodresult*60 - id_offs_mins_periodresult*60)  / (ld_secs_net - id_idle_mins*60 - id_offs_mins*60)
			end if
			//set amounts by the percentage
			_setvasdetailbymonth(adw_vas_report, adw_vasdata_per_month, li_row, ld_percent, ld_percent_days)
			//set charterer for tcout voyages
			lds_tccontract.retrieve(ids_voyages.getItemNumber(ll_row, "vessel_nr"))
			for li_contract = 1 to lds_tccontract.rowcount( )
				if ldt_voyagestart >= lds_tccontract.getitemdatetime(li_contract, "periode_start") and ldt_voyageend <= lds_tccontract.getitemdatetime(li_contract, "periode_end") then
					adw_vasdata_per_month.setitem(li_row,"charterer",  lds_tccontract.getitemstring(li_contract, "chart_chart_n_1"))
					exit
				end if
			next
		next
	next
next

if adw_vasdata_per_month.rowcount() <= 0 then 
	_addmessage(this.classdefinition , "n_vas_data_periodresult.of_getvasdatapermonth()", "No data on the current selection criteria, please try again.", "User warning.")
	if IsValid(w_super_vas_reports_periodresults) then
		w_super_vas_reports_periodresults.st_progress.text = "No data."
	end if
else
	if IsValid(w_super_vas_reports_periodresults) then
		w_super_vas_reports_periodresults.st_progress.text = "Retrieving data successfully."
	end if
end if

destroy lds_grade_group
destroy lu_vas_control
return c#return.Success





end function

private subroutine _setoffserviceidledays (datetime adt_start_date, datetime adt_end_date, integer ai_vessel_nr, string as_voyage_nr, datawindow adw_to, integer ai_to_row, datawindow adw_vas_report, boolean abl_set_idle_days);mt_n_datastore 	lds_days_offs_periodresult, lds_days_idle_periodresult

// Get periodical OFF Services days for vessel/voyage in a datastore
lds_days_offs_periodresult = CREATE mt_n_datastore
lds_days_offs_periodresult.DataObject = "d_sq_tb_days_offs_periodresult"
lds_days_offs_periodresult.SetTransObject(SQLCA)
lds_days_offs_periodresult.Retrieve(ai_vessel_nr,as_voyage_nr,adt_start_date,adt_end_date)

// Get periodical idle days for vessel/voyage in a datastore
lds_days_idle_periodresult = CREATE mt_n_datastore
lds_days_idle_periodresult.DataObject = "d_sq_tb_days_idle_periodresult"
lds_days_idle_periodresult.SetTransObject(SQLCA)
lds_days_idle_periodresult.Retrieve(ai_vessel_nr,as_voyage_nr,adt_start_date,adt_end_date)

id_offs_mins = lds_days_offs_periodresult.getitemdecimal(1,"minutessum")
id_offs_mins_periodresult = lds_days_offs_periodresult.getitemdecimal(1,"minutessum_periodresult")
id_idle_mins = lds_days_idle_periodresult.getitemdecimal(1,"minutessum")
id_idle_mins_periodresult = lds_days_idle_periodresult.getitemdecimal(1,"minutessum_periodresult")

//set values for days (est_act)
adw_to.setitem(ai_to_row,"est_act_days_off_service", id_offs_mins_periodresult/24/60)
if id_idle_mins > 0 then //if idle days exist in Operation, save it to est_act_days_idle
	if id_idle_mins_periodresult > 0 then
		adw_to.setitem(ai_to_row,"est_act_days_idle", id_idle_mins_periodresult/24/60)
	else
		adw_to.setitem(ai_to_row,"est_act_days_idle", 0)
	end if
else//if not, use idle days from calculation. But only save the idle days once, since we do not know when the idle days happen
	if abl_set_idle_days then 
		adw_to.setitem(ai_to_row,"est_act_days_idle", adw_vas_report.getitemdecimal(1,"est_act_days_idle"))
		id_idle_mins = adw_vas_report.getitemdecimal(1,"est_act_days_idle")* 24 * 60
		id_idle_mins_periodresult = adw_vas_report.getitemdecimal(1,"est_act_days_idle")* 24 * 60
	else
		adw_to.setitem(ai_to_row,"est_act_days_idle", 0)
	end if
end if 

//set values for days (act)
adw_to.setitem(ai_to_row,"act_days_off_service", id_offs_mins_periodresult/24/60)
adw_to.setitem(ai_to_row,"act_days_idle", id_idle_mins_periodresult/24/60)

end subroutine

private subroutine _setvasdetailbymonth (ref datawindow adw_from, ref datawindow adw_to, integer ai_to_row, decimal ld_percent, decimal ld_percent_days);/********************************************************************
   _setvasdetailbymonth()
   <DESC>   This function runs through each vas report set the figures to the destination DW.</DESC>
   <RETURN>None</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   </ARGS>
   <USAGE>  Call from of_getvasdatapermonth</USAGE>
********************************************************************/
string ls_type[2]= {"","est_"}, ls_prefix
integer ll_typeindex

//set title
adw_to.setitem(ai_to_row,"percent",  ld_percent * 100)
adw_to.setitem(ai_to_row,"vessel",  adw_from.getitemstring(1,"vessel"))
adw_to.setitem(ai_to_row,"voyage", adw_from.getitemstring(1,"voyage"))
adw_to.setitem(ai_to_row,"profit_center", adw_from.getitemstring(1,"profit_center"))

//set charterers
if adw_from.Object.t_50.text = "Estimated" then
	adw_to.setitem(ai_to_row,"charterer", "T/C OUT")	
else
	adw_to.setitem(ai_to_row,"charterer", adw_from.getitemstring(1,"charterers"))
end if

for ll_typeindex = 1 to upperbound(ls_type)
	ls_prefix = ls_type[ll_typeindex]
	//set values for profit
	adw_to.setitem(ai_to_row,ls_prefix + "act_freight", adw_from.getitemdecimal(1,ls_prefix + "act_freight") * ld_percent)
	adw_to.setitem(ai_to_row,ls_prefix + "act_dem_des", adw_from.getitemdecimal(1,ls_prefix + "act_dem_des") * ld_percent)
	adw_to.setitem(ai_to_row,ls_prefix + "act_broker_comm", adw_from.getitemdecimal(1,ls_prefix + "act_broker_comm") * ld_percent)
	adw_to.setitem(ai_to_row,ls_prefix + "act_port_exp", adw_from.getitemdecimal(1,ls_prefix + "act_port_exp") * ld_percent)
	adw_to.setitem(ai_to_row,ls_prefix + "act_bunk_exp", adw_from.getitemdecimal(1,ls_prefix + "act_bunk_exp") * ld_percent)
	adw_to.setitem(ai_to_row,ls_prefix + "act_misc_exp", adw_from.getitemdecimal(1,ls_prefix + "act_misc_exp") * ld_percent)
	//set values for days 
	adw_to.setitem(ai_to_row,ls_prefix + "act_days_loading", adw_from.getitemdecimal(1,ls_prefix + "act_days_loading")* ld_percent_days)
	adw_to.setitem(ai_to_row,ls_prefix + "act_days_discharge", adw_from.getitemdecimal(1,ls_prefix + "act_days_discharge")* ld_percent_days)
	adw_to.setitem(ai_to_row,ls_prefix + "act_days_load_and_disch", adw_from.getitemdecimal(1,ls_prefix + "act_days_load_and_disch")* ld_percent_days)
	adw_to.setitem(ai_to_row,ls_prefix + "act_days_bunkering", adw_from.getitemdecimal(1,ls_prefix + "act_days_bunkering")* ld_percent_days)
	adw_to.setitem(ai_to_row,ls_prefix + "act_days_canal", adw_from.getitemdecimal(1,ls_prefix + "act_days_canal")* ld_percent_days)
	adw_to.setitem(ai_to_row,ls_prefix + "act_days_dry_dock", adw_from.getitemdecimal(1,ls_prefix + "act_days_dry_dock")* ld_percent_days)
	adw_to.setitem(ai_to_row,ls_prefix + "act_days_loaded", adw_from.getitemdecimal(1,ls_prefix + "act_days_loaded")* ld_percent_days)
	adw_to.setitem(ai_to_row,ls_prefix + "act_days_ballast", adw_from.getitemdecimal(1,ls_prefix + "act_days_ballast")* ld_percent_days)
	adw_to.setitem(ai_to_row,ls_prefix + "act_days_other", adw_from.getitemdecimal(1,ls_prefix + "act_days_other")* ld_percent_days)
next	


end subroutine

on n_vas_data_periodresult.create
call super::create
end on

on n_vas_data_periodresult.destroy
call super::destroy
end on

