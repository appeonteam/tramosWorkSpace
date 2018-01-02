$PBExportHeader$n_autoschedule.sru
forward
global type n_autoschedule from mt_n_nonvisualobject
end type
type ids_est_poc from mt_n_datastore within n_autoschedule
end type
type ids_cur_proceed_poc from mt_n_datastore within n_autoschedule
end type
type ids_ori_proceed_poc from mt_n_datastore within n_autoschedule
end type
end forward

global type n_autoschedule from mt_n_nonvisualobject
ids_est_poc ids_est_poc
ids_cur_proceed_poc ids_cur_proceed_poc
ids_ori_proceed_poc ids_ori_proceed_poc
end type
global n_autoschedule n_autoschedule

type variables
CONSTANT integer ii_ACTUAL    = 1
CONSTANT integer ii_ESTIMATED = 2

mt_n_datefunctions	inv_date_utility

long		il_shiptype_portstay		//Port Stay(seconds)
long		il_proceeding_st			//Proceeding steaming time(seconds)
long		il_vessel_nr

datetime	idt_last_eta, idt_last_etb, idt_last_etd

boolean	ib_etd_manual

CONSTANT string is_PETDISNULL  = "It is not possible to calculate the arrival date because the previous port's ETD/ATD is empty."
CONSTANT string is_PSTISNULL   = "It is not possible to calculate the arrival date because the steaming time is empty."
CONSTANT string is_ADDITIONMSG = "Auto schedule failed. You need to update the dates in Port of Call manually."

CONSTANT integer ii_MANUAL  = 0
CONSTANT integer ii_AUTOCAL = 1

end variables

forward prototypes
public subroutine documentation ()
public function long of_get_atobviacdistance (string as_from_port, string as_to_port)
public function long of_get_shiptype_portstay (long al_vessel_nr, string as_purpose_code, boolean as_disperrinfor)
public subroutine of_new_poc (datawindow adw_proc_pcnc, datawindow adw_poc, integer ai_type)
public function boolean of_calculateschedule (datawindow adw_proc_pcnc, datawindow adw_poc, integer ai_type, boolean ab_onlythisyear)
public subroutine of_get_proceed_poc (long al_vessel_nr, string al_year)
public function boolean of_checkautoschedule ()
public function boolean of_cal_currentport (datawindow adw_proc_pcnc, datawindow adw_poc, integer ai_type)
public function boolean of_autoschedule_proceeding (long al_vessel_nr, string al_year)
public function boolean of_autoschedule_poc (s_autoschedule astr_autoschedule)
public subroutine of_set_steamingtime (datawindow adw_proc_pcnc, datawindow adw_poc, integer ai_type)
public subroutine of_set_portstay (datawindow adw_poc, integer ai_type, boolean as_disperrinfor)
public function string of_getpterrtext (string as_shiptype, string as_purpose_code)
public function boolean of_validate_proceeding (integer ai_vesselnr, string as_voyagenr, integer ai_pcn, string as_portcode, datetime adt_procdate)
public function integer of_distancechanged (integer ai_vesselnr, string as_voyagenr, string as_year)
public function integer of_speedchanged (datawindow adw_proceedinglist, integer ai_vesselnr, string as_voyagenr, long al_row, string as_year)
public subroutine of_setetdmodified (boolean ab_etd_manual)
public function long of_get_poc_before (datetime adt_proceed_dt)
public function boolean of_check_proceedingdate (datawindow adw_proceedinglist, long al_row, datetime adt_procdate)
public function integer of_setdistances (integer ai_vesselnr, string as_voyagenr)
public function boolean of_checkautoschedule_proceeding (integer ai_vesselnr, string as_voyagenr, datetime adt_originalprocdate, datetime adt_currentprocdate)
public function boolean of_checkautoschedule_proceeding (integer ai_vesselnr, string as_voyagenr, datetime adt_procdate)
public function long of_get_departuredate (mt_n_datastore ads_poc, ref datetime adt_ori_etd, ref datetime adt_cur_etd, ref long al_seconds)
public function integer of_init (string as_abctablepath)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_autoschedule
	
	<OBJECT> 
		
	</OBJECT>
   <DESC>
		
	</DESC>
   	<USAGE>  	
					of_autoshedule()
					
	</USAGE>
   	<ALSO>
		
	</ALSO>
	
    Date   		Ref    			Author	Comments
  25/10/11 	CR#2536&2535      WWG004  	First Version
  													Add function: of_autoschedule_poc()
  28/10/11 	CR#2536&2535      ZSW001  	Add function: of_autoschedule_proceeding
																	  of_cal_currentport
																	  of_calculateschedule
																	  of_checkautoschedule
																	  of_get_proceed_poc
																	  of_get_shiptype_portstay
																	  of_getpterrtext
																	  of_new_poc
																	  of_set_portstay
																	  of_set_steamingtime
  10/11/11 CR#2535&2536			TTY004	Add function: of_autoschedule_distancechanged() // do autoschedule for distance-changed
  																	  of_autoschedule_speedchanged()     //do autoschedule for speed-changed
																	  of_checkautoschedule_proceeding() //check the condition if do autoschedule or not
																	  of_checkautoschedule_proceeding()// reload  from of_checkautoschedule_proceeding()
																	  of_validate_proceeding()         // validate the proc_date could changed or not
																	  of_check_proceedingdate()      //check the proceeding orders has been changed or not.
  06/03/12	FINANCE08			AGL027	Added function: 
  																		of_setdistances()		// used by axestimations loaddistance option (should be 1 off)																	  
  31/05/12	FINANCE08			JMC112	Changed function 	of_setdistances()
  31/10/12  CR#3019				RJH022	changed function of_speedchanged()
  06/11-12	CR2870				WWG004	Not display the deleted departure date.
  24/11/12	CR2870				ZSW001	Add auto generate status for arrival, berthing and departure column
  25/03/13	CR3049				LGX001	Change of_validate_proceeding() & of_checkautoschedule_proceeding()
  23/09/13	CR2790				WWA048	Get the distance between two ports.
  19/02/14	CR2790				ZSW001	After using the new engine, the return value of distance between two ports is &
                                       less than zero if it is not possible to calculate.
  26/02/14	CR3340				LHG008	Fix the bug about poping up warning message twice 
                                       when the port stay duration time was not defined in Shiptye system table.
  08/02/16	CR4298				AGL027	Allow AXEstimate application to use its own path for atobviac tables	

********************************************************************/

end subroutine

public function long of_get_atobviacdistance (string as_from_port, string as_to_port);/********************************************************************
   of_get_atobviacdistance
   <DESC>calculate the distance between two ports</DESC>
   <RETURN>	long:
            <LI> return the distance between two ports
           </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_from_port  
		as_to_port
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref                  Author             Comments
   	26/10/11   CR2535&CR2536           TTY004        First Version
   </HISTORY>
********************************************************************/

long	ll_distance

if as_from_port = as_to_port then return 0

if not isvalid(gnv_atobviac) then gnv_atobviac = create n_atobviac
if not gnv_atobviac.of_gettableopen()  then
	gnv_atobviac.of_opentable()
	gnv_atobviac.of_resetToDefaultState()
end if

ll_distance = gnv_atobviac.of_getporttoportdistance(as_from_port,as_to_port)
if ll_distance <= 0 then setnull(ll_distance)
string ls_test 
ls_test = gnv_atobviac.of_getenginestate()
return ll_distance

end function

public function long of_get_shiptype_portstay (long al_vessel_nr, string as_purpose_code, boolean as_disperrinfor);/********************************************************************
   of_get_shiptype_portstay
   <DESC>	Get the port stay according vessel_nr and purpose_code </DESC>
   <RETURN>	long:
            return the value of the port stay
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr    : vessel_nr
		as_purpose_code : purpose_code
		as_disperrinfor : whether display error information if port stay is null
   </ARGS>
   <USAGE>	When get the port stay of the purpose of the shiptype's </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	28/10/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

decimal	ld_port_stay
string	ls_shiptype

SELECT CAL_VEST_PORTSTAY.PORT_STAY,
		 CAL_VEST.CAL_VEST_TYPE_NAME
  INTO :ld_port_stay,
  		 :ls_shiptype
  FROM VESSELS,
       CAL_VEST,
       CAL_VEST_PORTSTAY
 WHERE VESSELS.CAL_VEST_TYPE_ID = CAL_VEST.CAL_VEST_TYPE_ID AND
       CAL_VEST.CAL_VEST_TYPE_ID = CAL_VEST_PORTSTAY.CAL_VEST_TYPE_ID AND
       VESSELS.VESSEL_NR = :al_vessel_nr AND
       CAL_VEST_PORTSTAY.PURPOSE_CODE = :as_purpose_code;

if (isnull(ld_port_stay) or ld_port_stay = 0) and as_disperrinfor then
	messagebox("Auto Schedule Info", of_getpterrtext(ls_shiptype, as_purpose_code))
end if

return ld_port_stay * 60 * 60		//Convert hours to seconds

end function

public subroutine of_new_poc (datawindow adw_proc_pcnc, datawindow adw_poc, integer ai_type);/********************************************************************
   of_new_poc
   <DESC>	Auto calculate and set arrive time	</DESC>
   <RETURN>	(none)
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_proc_pcnc
		adw_poc
		ai_type
   </ARGS>
   <USAGE>	When new a POC	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	27/10/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_columnprefix
long		ll_currow, ll_pocautoschedule, ll_count
datetime	ldt_eta, ldt_petd, ldt_proceed_dt

ll_currow = adw_poc.getrow()
if ll_currow <= 0 then return

if ai_type = ii_ESTIMATED then
	ls_columnprefix = "poc_est_"
	adw_poc.setitem(1, "users_steamingtime_unit", uo_global.ii_steamingtime_unit)
	adw_poc.setitem(1, "users_poc_portstay_unit", uo_global.ii_poc_portstay_unit)
	if uo_global.ib_pocautoschedule then ll_pocautoschedule = 1
	adw_poc.setitem(1, "users_poc_enable_auto_schedule", ll_pocautoschedule)
	
	adw_poc.setitemstatus(1, "users_steamingtime_unit", primary!, notmodified!)
	adw_poc.setitemstatus(1, "users_poc_portstay_unit", primary!, notmodified!)
	adw_poc.setitemstatus(1, "users_poc_enable_auto_schedule", primary!, notmodified!)
end if

//Refresh proceeding steaming time and port stay
of_set_steamingtime(adw_proc_pcnc, adw_poc, ai_type)

if not uo_global.ib_pocautoschedule then return

ldt_petd = adw_poc.getitemdatetime(ll_currow, "previous_etd")
if isnull(ldt_petd) then
	ldt_proceed_dt = adw_proc_pcnc.getitemdatetime(adw_proc_pcnc.getselectedrow(0), "proceed_proc_date")
	ll_count = of_get_poc_before(ldt_proceed_dt)
	if ll_count > 0 then
		messagebox("Auto Schedule Info", is_PETDISNULL)
		return
	end if
end if

if isnull(il_proceeding_st) then
	messagebox("Auto Schedule Info", is_PSTISNULL)
	return
end if

//Initialize ETA
ldt_eta = inv_date_utility.of_relativedatetime(ldt_petd, il_proceeding_st)
adw_poc.setitem(ll_currow, ls_columnprefix + "port_arr_dt", ldt_eta)
adw_poc.setitem(ll_currow, "auto_arr_status", ii_AUTOCAL)

end subroutine

public function boolean of_calculateschedule (datawindow adw_proc_pcnc, datawindow adw_poc, integer ai_type, boolean ab_onlythisyear);/********************************************************************
   of_calculateschedule
   <DESC>	Calculate the difference and call of_autoschedule	</DESC>
   <RETURN>	boolean:
            <true>  ok
            <false> failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_proc_pcnc
		adw_poc
		ai_type
		ab_onlythisyear
   </ARGS>
   <USAGE>	After deleting and updating POC	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	27/10/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_columnprefix, ls_ori_purp
long		ll_row, ll_currow, ll_foundact, ll_foundest
long		ll_count, ll_steamingtime, ll_actual_portstay
datetime	ldt_cal_eta, ldt_pre_etd
datetime	ldt_ori_eta, ldt_cur_eta
datetime	ldt_ori_etb, ldt_cur_etb
datetime	ldt_ori_etd, ldt_cur_etd

s_autoschedule	str_autoschedule

if not uo_global.ib_pocautoschedule then return true

ll_currow = adw_proc_pcnc.getselectedrow(0)
if ll_currow <= 0 then return true

ll_count = adw_proc_pcnc.rowcount()
ll_foundact = adw_proc_pcnc.find("compute_1 = 'Actual'", ll_currow + 1, ll_count + 1)
ll_foundest = adw_proc_pcnc.find("compute_1 = 'Estimated'", ll_currow + 1, ll_count + 1)
if ll_foundact > 0 or ll_foundest <= 0 then return true

//Set ship type port stay to actual port stay as default
ll_actual_portstay = il_shiptype_portstay

if adw_poc.rowcount() = 0 then		//delete POC
	if ai_type = ii_ACTUAL then
		ldt_cur_eta = adw_proc_pcnc.getitemdatetime(ll_currow, "poc_port_arr_dt")
		ldt_cur_etd = adw_proc_pcnc.getitemdatetime(ll_currow, "poc_port_dept_dt")
	else
		ldt_cur_eta = adw_proc_pcnc.getitemdatetime(ll_currow, "poc_est_port_arr_dt")
		ldt_cur_etd = adw_proc_pcnc.getitemdatetime(ll_currow, "poc_est_port_dept_dt")
	end if
	//Get actual port stay as seconds_after when deleting POC
	if not isnull(ldt_cur_eta) then
		if isnull(ldt_cur_etd) then
			str_autoschedule.seconds_after = -ll_actual_portstay
		else
			str_autoschedule.seconds_after = -inv_date_utility.of_secondsafter(ldt_cur_eta, ldt_cur_etd)
		end if
	end if
else
	if ai_type = ii_ESTIMATED then ls_columnprefix = "poc_est_"
	
	ldt_ori_eta = adw_poc.getitemdatetime(1, ls_columnprefix + "port_arr_dt", primary!, true)
	ldt_cur_eta = adw_poc.getitemdatetime(1, ls_columnprefix + "port_arr_dt", primary!, false)
	
	ldt_ori_etb = adw_poc.getitemdatetime(1, ls_columnprefix + "port_berthing_time", primary!, true)
	ldt_cur_etb = adw_poc.getitemdatetime(1, ls_columnprefix + "port_berthing_time", primary!, false)
	
	ldt_ori_etd = adw_poc.getitemdatetime(1, ls_columnprefix + "port_dept_dt", primary!, true)
	ldt_cur_etd = adw_poc.getitemdatetime(1, ls_columnprefix + "port_dept_dt", primary!, false)
	
	ls_ori_purp = adw_poc.getitemstring(1, ls_columnprefix + "purpose_code", primary!, true)
	
	//Check whether current row is new
	if adw_poc.getitemstatus(1, 0, primary!) = newmodified! then	//New POC
		ldt_pre_etd = adw_poc.getitemdatetime(1, "previous_etd")
		str_autoschedule.seconds_after = inv_date_utility.of_secondsafter(ldt_pre_etd, ldt_cur_etd) - il_proceeding_st
	else
		//Current row is not new
		if isnull(ldt_ori_etd) then
			ll_actual_portstay = of_get_shiptype_portstay(il_vessel_nr, ls_ori_purp, false)
			if isnull(ldt_ori_etb) then
				str_autoschedule.seconds_after = inv_date_utility.of_secondsafter(inv_date_utility.of_relativedatetime(ldt_ori_eta, ll_actual_portstay), ldt_cur_etd)
			else
				str_autoschedule.seconds_after = inv_date_utility.of_secondsafter(inv_date_utility.of_relativedatetime(ldt_ori_etb, ll_actual_portstay), ldt_cur_etd)
			end if
		else
			if isnull(ldt_cur_etd) then
				//Calculate new ETD
				if isnull(ldt_cur_etb) then
					ldt_cur_etd = inv_date_utility.of_relativedatetime(ldt_cur_eta, ll_actual_portstay)
				else
					ldt_cur_etd = inv_date_utility.of_relativedatetime(ldt_cur_etb, ll_actual_portstay)
				end if
			end if
			str_autoschedule.seconds_after = inv_date_utility.of_secondsafter(ldt_ori_etd, ldt_cur_etd)
		end if
	end if
	
	//if the current departure date is later than the arrival date of next port, then recalculate the arrival date of next port.
	ldt_ori_eta = adw_proc_pcnc.getitemdatetime(ll_foundest, "poc_est_port_arr_dt")
	ldt_cal_eta = inv_date_utility.of_relativedatetime(ldt_ori_eta, str_autoschedule.seconds_after)
	if ldt_cal_eta < ldt_cur_etd then
		ldt_pre_etd = adw_proc_pcnc.getitemdatetime(ll_foundest, "previous_etd")
		ll_steamingtime = adw_proc_pcnc.getitemnumber(ll_foundest, "steamingtime") * 60 * 60
		ldt_cal_eta = inv_date_utility.of_relativedatetime(ldt_pre_etd, ll_steamingtime)
		
		str_autoschedule.seconds_after += inv_date_utility.of_secondsafter(ldt_ori_eta, ldt_cal_eta)
	end if
end if

//Assignment the structure and then call autoschedule
if str_autoschedule.seconds_after <> 0 then
	str_autoschedule.vessel_nr = adw_proc_pcnc.getitemnumber(ll_foundest, "proceed_vessel_nr")
	str_autoschedule.voyage_nr = adw_proc_pcnc.getitemstring(ll_foundest, "proceed_voyage_nr")
	str_autoschedule.port_code = adw_proc_pcnc.getitemstring(ll_foundest, "proceed_port_code")
	str_autoschedule.pcn       = adw_proc_pcnc.getitemnumber(ll_foundest, "proceed_pcn")
	if ab_onlythisyear then str_autoschedule.year = right(string(today(), "yyyy"), 2)
	return of_autoschedule_poc(str_autoschedule)
end if

return true

end function

public subroutine of_get_proceed_poc (long al_vessel_nr, string al_year);/********************************************************************
   of_get_proceed_poc
   <DESC>	Get proceed poc list	</DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		al_year
   </ARGS>
   <USAGE>	Before updating Proceeding	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	04/11/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

//initialize proceed poc list
ids_ori_proceed_poc.dataobject = "d_sp_tb_proceed_poc_list"
ids_ori_proceed_poc.settrans(sqlca)
ids_ori_proceed_poc.retrieve(al_vessel_nr, al_year, 0)

end subroutine

public function boolean of_checkautoschedule ();/********************************************************************
   of_checkautoschedule
   <DESC>	Check whether need to do autoschedule	</DESC>
   <RETURN>	boolean:
            true : Need to do autoschedule
				false: Needn't to do autoschedule	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	When need to confirm whether to do autoschedule	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	11/11/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_msgtext
boolean	lb_doschedule = true

if not uo_global.ib_pocautoschedule then return false

if uo_global.ib_pocnotification then
	ls_msgtext = "Do you want all subsequent dates to be recalculated and updated automatically?"
					 
	if messagebox("Confirm Date Calculation", ls_msgtext, question!, yesno!, 1) <> 1 then
		lb_doschedule = false
	end if
end if

return lb_doschedule

end function

public function boolean of_cal_currentport (datawindow adw_proc_pcnc, datawindow adw_poc, integer ai_type);/********************************************************************
   of_cal_currentport
   <DESC>	Auto schedule current row	</DESC>
   <RETURN>	boolean:
             true:  do autoschedule
             false: not do auto schedule
				 null:  did not pass validation	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_poc
		ai_type
   </ARGS>
   <USAGE>	Before updating POC	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	09/11/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

long		ll_actual_portstay, ll_currow, ll_count, ll_foundact, ll_foundest
string	ls_columnprefix, ls_purpose
boolean	lb_doschedule, lb_curportneed, lb_nextportneed, lb_autodeptstatus
boolean	lb_eta_modified, lb_etb_modified, lb_pur_modified, lb_null
datetime	ldt_ori_eta, ldt_cur_eta, ldt_ori_etb, ldt_cur_etb, ldt_ori_etd, ldt_cur_etd, ldt_proceed_dt

if not uo_global.ib_pocautoschedule then return false
if adw_poc.rowcount() <= 0 then return false

/*
//if this vessel doesn't have any port of call before current port then don't do auto schedule
if adw_poc.getitemstatus(1, 0, primary!) = newmodified! then
	if isnull(adw_poc.getitemdatetime(1, "previous_etd")) then
		ldt_proceed_dt = adw_proc_pcnc.getitemdatetime(adw_proc_pcnc.getselectedrow(0), "proceed_proc_date")
		ll_count = of_get_poc_before(ldt_proceed_dt)
		if ll_count <= 0 then return false
	end if
end if
*/

ll_currow = adw_proc_pcnc.getselectedrow(0)
ll_count = adw_proc_pcnc.rowcount()
ll_foundact = adw_proc_pcnc.find("compute_1 = 'Actual'", ll_currow + 1, ll_count + 1)
ll_foundest = adw_proc_pcnc.find("compute_1 = 'Estimated'", ll_currow + 1, ll_count + 1)
if ll_foundact > 0 then return false

if ai_type = ii_ESTIMATED then ls_columnprefix = "poc_est_"

//Get original value and current value of ETA, ETB, ETD
ldt_ori_eta = adw_poc.getitemdatetime(1, ls_columnprefix + "port_arr_dt", primary!, true)
ldt_cur_eta = adw_poc.getitemdatetime(1, ls_columnprefix + "port_arr_dt", primary!, false)
ldt_ori_etb = adw_poc.getitemdatetime(1, ls_columnprefix + "port_berthing_time", primary!, true)
ldt_cur_etb = adw_poc.getitemdatetime(1, ls_columnprefix + "port_berthing_time", primary!, false)
ldt_ori_etd = adw_poc.getitemdatetime(1, ls_columnprefix + "port_dept_dt", primary!, true)
ldt_cur_etd = adw_poc.getitemdatetime(1, ls_columnprefix + "port_dept_dt", primary!, false)
lb_autodeptstatus = (adw_poc.getitemnumber(1, "auto_dept_status") = ii_AUTOCAL) 

//Check to be modified
lb_pur_modified = (adw_poc.getitemstatus(1, ls_columnprefix + "purpose_code", primary!) = datamodified!)
lb_etb_modified = (adw_poc.getitemstatus(1, ls_columnprefix + "port_berthing_time", primary!) = datamodified!)
lb_eta_modified = (adw_poc.getitemstatus(1, ls_columnprefix + "port_arr_dt", primary!) = datamodified!)

//Check whether the current row need to be recalculated
if ldt_cur_eta >= ldt_cur_etb or (isnull(ldt_cur_etd) and lb_autodeptstatus) or (not ib_etd_manual and (lb_pur_modified or lb_etb_modified or lb_eta_modified)) then
	lb_curportneed = true
end if

//Check whether the rest row need to be recalculated
if ib_etd_manual and ll_foundact <= 0 and ll_foundest > 0 then
	lb_nextportneed = true
end if

if not lb_curportneed and not lb_nextportneed then return false

//Check whether need to do autoschedule
lb_doschedule = of_checkautoschedule()
if not lb_doschedule then return false

//recalculated current row
if lb_curportneed then
	setnull(lb_null)
	ls_purpose = adw_poc.getitemstring(1, ls_columnprefix + "purpose_code")
	ll_actual_portstay = of_get_shiptype_portstay(il_vessel_nr, ls_purpose, true)
	if isnull(ll_actual_portstay) or ll_actual_portstay <= 0 then return lb_null
	il_shiptype_portstay = ll_actual_portstay
	
	//if ETA >= ETB, Set ETB to Null
	if not isnull(ldt_cur_eta) and not isnull(ldt_cur_etb) then
		if ldt_cur_eta >= ldt_cur_etb then
			setnull(ldt_cur_etb)
			adw_poc.setitem(1, ls_columnprefix + "port_berthing_time", ldt_cur_etb)
			adw_poc.setitem(1, "auto_ber_status", ii_AUTOCAL)
		end if
	end if
	
	//ETD need to be recalculated
	if (isnull(ldt_cur_etd) and not ib_etd_manual) or (not ib_etd_manual and (lb_pur_modified or lb_etb_modified or lb_eta_modified)) then
		if not isnull(ldt_cur_etd) and not isnull(ldt_ori_etd) and not lb_pur_modified then
			//Calculate original port stay
			if isnull(ldt_ori_etb) then
				ll_actual_portstay = inv_date_utility.of_secondsafter(ldt_ori_eta, ldt_ori_etd)
			else
				ll_actual_portstay = inv_date_utility.of_secondsafter(ldt_ori_etb, ldt_ori_etd)
			end if
		end if
		//Calculate new ETD
		if isnull(ldt_cur_etb) then
			ldt_cur_etd = inv_date_utility.of_relativedatetime(ldt_cur_eta, ll_actual_portstay)
		else
			ldt_cur_etd = inv_date_utility.of_relativedatetime(ldt_cur_etb, ll_actual_portstay)
		end if
		adw_poc.setitem(1, ls_columnprefix + "port_dept_dt", ldt_cur_etd)
		adw_poc.setitem(1, "auto_dept_status", ii_AUTOCAL)
	end if
end if

return true

end function

public function boolean of_autoschedule_proceeding (long al_vessel_nr, string al_year);/********************************************************************
   of_autoschedule_proceeding
   <DESC>	Auto re-calculate port of call	</DESC>
   <RETURN>	boolean:
            <LI> true,  calculate OK or it needn't calculate
            <LI> false, calculate not OK				</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		al_year
   </ARGS>
   <USAGE>	After updating Proceeding	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	04/11/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

long			ll_row, ll_ori_rows, ll_cur_rows, ll_est_rows, ll_found, ll_start, ll_last_actual
long			ll_vessel_nr, ll_pcn, ll_prerownum, ll_currownum, ll_rownum[], ll_portstay, ll_diff
dec			ld_steamingtime
string		ls_exp, ls_voyage_nr, ls_port_code, ls_errtext, ls_purpose
datetime		ldt_pre_etd
datetime		ldt_cur_eta, ldt_cur_etb, ldt_cur_etd
datetime		ldt_ori_eta, ldt_ori_etb, ldt_ori_etd
boolean		lb_needrecalculated

ids_cur_proceed_poc.dataobject = "d_sp_tb_proceed_poc_list"
ids_cur_proceed_poc.settrans(sqlca)
ll_cur_rows = ids_cur_proceed_poc.retrieve(al_vessel_nr, al_year, 0)		//Current number of records for proceeding
if ll_cur_rows <= 0 then return true

ids_est_poc.dataobject = "d_sq_gr_poc_est"
ids_est_poc.settransobject(sqlca)
ll_est_rows = ids_est_poc.retrieve(al_vessel_nr, al_year)
if ll_est_rows <= 0 then return true

//Set all rownum column to zero
ll_rownum[ll_cur_rows] = 0
ids_cur_proceed_poc.object.rownum.primary = ll_rownum

//Reposition the rownum column
ll_ori_rows = ids_ori_proceed_poc.rowcount()
for ll_row = 1 to ll_ori_rows
	ll_vessel_nr = ids_ori_proceed_poc.getitemnumber(ll_row, "vessel_nr")
	ls_voyage_nr = ids_ori_proceed_poc.getitemstring(ll_row, "voyage_nr")
	ls_port_code = ids_ori_proceed_poc.getitemstring(ll_row, "port_code")
	ll_pcn       = ids_ori_proceed_poc.getitemnumber(ll_row, "pcn")
	
	ls_exp = "vessel_nr = " + string(ll_vessel_nr) + " and voyage_nr = '" + ls_voyage_nr + "' and port_code = '" + ls_port_code + "' and pcn = " + string(ll_pcn)
	ll_found = ids_cur_proceed_poc.find(ls_exp, 1, ll_cur_rows)
	if ll_found > 0 then
		ids_cur_proceed_poc.setitem(ll_found, "rownum", ll_row)
	end if
next

//Find the first change of the rownum
ll_start = ids_cur_proceed_poc.find("getrow() <> rownum", 1, ll_cur_rows)
if ll_start > 0 then
	ll_last_actual = ids_cur_proceed_poc.find("not isnull(port_arr_dt)", ll_cur_rows, ll_start)
	if ll_last_actual > 0 then
		ll_start = ids_cur_proceed_poc.find("rownum = 0 or rownum <> rownum[-1] + 1", ll_last_actual + 1, ll_cur_rows + 1)
	end if
	if ll_start > 0 then
		lb_needrecalculated = true
		//From the first change to the end of the datastore
		for ll_row = ll_start to ll_cur_rows
			ll_currownum = ids_cur_proceed_poc.getitemnumber(ll_row, "rownum")
			
			ll_vessel_nr = ids_cur_proceed_poc.getitemnumber(ll_row, "vessel_nr")
			ls_voyage_nr = ids_cur_proceed_poc.getitemstring(ll_row, "voyage_nr")
			ls_port_code = ids_cur_proceed_poc.getitemstring(ll_row, "port_code")
			ll_pcn       = ids_cur_proceed_poc.getitemnumber(ll_row, "pcn")
			
			if not lb_needrecalculated then
				if ll_prerownum = 0 or ll_currownum <> ll_prerownum + 1 then		//recalculate the date for serial proceeding
					lb_needrecalculated = true
				end if
			end if
			
			ls_exp = "vessel_nr = " + string(ll_vessel_nr) + " and voyage_nr = '" + ls_voyage_nr + "' and port_code = '" + ls_port_code + "' and pcn = " + string(ll_pcn)
			ll_found = ids_est_poc.find(ls_exp, 1, ll_est_rows)
			if ll_found > 0 then				//proceeding was filled with data in poc
				ldt_ori_eta = ids_est_poc.getitemdatetime(ll_found, "port_arr_dt")
				ldt_ori_etb = ids_est_poc.getitemdatetime(ll_found, "port_berthing_time")
				ldt_ori_etd = ids_est_poc.getitemdatetime(ll_found, "port_dept_dt")
				
				if not lb_needrecalculated then		//don't need to recalculate
					ldt_cur_eta = inv_date_utility.of_relativedatetime(ldt_ori_eta, ll_diff)
					ldt_cur_etb = inv_date_utility.of_relativedatetime(ldt_ori_etb, ll_diff)
					ldt_cur_etd = inv_date_utility.of_relativedatetime(ldt_ori_etd, ll_diff)
				else											//need to recalculate
					ldt_pre_etd = ids_cur_proceed_poc.getitemdatetime(ll_row, "previous_etd")
					if isnull(ldt_pre_etd) then
						messagebox("Auto Schedule Info", is_PETDISNULL + "~r~n~r~n" + is_ADDITIONMSG)
						return false
					end if
					
					ld_steamingtime = ids_cur_proceed_poc.getitemdecimal(ll_row, "steamingtime") * 60 * 60			//Hours to seconds
					if isnull(ld_steamingtime) then
						messagebox("Auto Schedule Info", is_PSTISNULL + "~r~n~r~n" + is_ADDITIONMSG)
						return false
					end if
					
					ldt_cur_eta = inv_date_utility.of_relativedatetime(ldt_pre_etd, ld_steamingtime)
					
					setnull(ldt_cur_etb)
					//Get port stay of ship type or calculate the actual port stay
					if isnull(ldt_ori_etd) then		//port stay = the port stay of ship type
						ls_purpose = ids_est_poc.getitemstring(ll_found, "purpose_code")
						ll_portstay = of_get_shiptype_portstay(ll_vessel_nr, ls_purpose, true)
						if isnull(ll_portstay) or ll_portstay <= 0 then return false
					else
						if isnull(ldt_ori_etb) then	// port stay = ori_etd - ori_eta
							ll_portstay = inv_date_utility.of_secondsafter(ldt_ori_eta, ldt_ori_etd)
						else									// port stay = ori_etd - ori_etb
							ll_portstay = inv_date_utility.of_secondsafter(ldt_ori_etb, ldt_ori_etd)
						end if
					end if
					//calculate new departure
					ldt_cur_etd = inv_date_utility.of_relativedatetime(ldt_cur_eta, ll_portstay)
					//Calculate the number of seconds current etd occurs after original etd
					ll_diff = inv_date_utility.of_secondsafter(ldt_ori_etd, ldt_cur_etd)
					lb_needrecalculated = false
				end if
				//Assignment new value.
				ids_est_poc.setitem(ll_found, "port_arr_dt", ldt_cur_eta)
				ids_est_poc.setitem(ll_found, "auto_arr_status", ii_AUTOCAL)
				
				ids_est_poc.setitem(ll_found, "port_berthing_time", ldt_cur_etb)
				ids_est_poc.setitem(ll_found, "auto_ber_status", ii_AUTOCAL)
				
				ids_est_poc.setitem(ll_found, "port_dept_dt", ldt_cur_etd)
				ids_est_poc.setitem(ll_found, "auto_dept_status", ii_AUTOCAL)
				
				ids_est_poc.setitem(ll_found, "autoschedule_status", 1)
				ids_est_poc.setitem(ll_found, "dates_updated_by", uo_global.is_userid)
				ids_est_poc.setitem(ll_found, "local_dates_updated", now())
				
				if ll_row < ll_cur_rows then
					ids_cur_proceed_poc.setitem(ll_row + 1, "previous_etd", ldt_cur_etd)
				end if
			else		//proceeding wasn't filled with data in poc
				if ll_row < ll_cur_rows then
					ldt_pre_etd = ids_cur_proceed_poc.getitemdatetime(ll_row, "previous_etd")
					if isnull(ldt_pre_etd) then
						messagebox("Auto Schedule Info", is_PETDISNULL + "~r~n~r~n" + is_ADDITIONMSG)
						return false
					end if
					
					ld_steamingtime = ids_cur_proceed_poc.getitemdecimal(ll_row, "steamingtime") * 60 * 60			//Hours to seconds
					if isnull(ld_steamingtime) then
						messagebox("Auto Schedule Info", is_PSTISNULL + "~r~n~r~n" + is_ADDITIONMSG)
						return false
					end if
					
					ldt_cur_etd = inv_date_utility.of_relativedatetime(ldt_pre_etd, ld_steamingtime)
					ids_cur_proceed_poc.setitem(ll_row + 1, "previous_etd", ldt_cur_etd)
				end if
			end if
			ll_prerownum = ll_currownum
		next
	end if
end if

if ids_est_poc.update() = 1 then
	COMMIT;
	ids_ori_proceed_poc.reset()
	return true
else
	ls_errtext = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", "Failed to do auto schedule.~r~n~r~n" + ls_errtext, stopsign!)
	return false
end if

end function

public function boolean of_autoschedule_poc (s_autoschedule astr_autoschedule);/********************************************************************
   of_autoschedule_poc
   <DESC>	Description	</DESC>
   <RETURN>	boolean:
            <LI> true, calculate OK or it needn't calculate
            <LI> false, calculate not OK				</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS> as_autoschedule
   </ARGS>
   <USAGE>	of_autoschedule(s_autoschedule)	</USAGE>
   <HISTORY>
   	Date       CR-Ref       		Author        Comments
   	27/10/2011 CR2535 & CR2536    WWG004        First Version
   </HISTORY>
********************************************************************/

datetime	ldt_ori_eta, ldt_ori_etb, ldt_ori_etd
datetime ldt_new_eta, ldt_new_etb, ldt_new_etd
long		ll_secondsafter, ll_rowcount, ll_option_row
long		ll_port_stay, ll_findrow
string	ls_findexp, ls_shiptype, ls_purpose, ls_errtext
boolean	lb_return

ll_secondsafter = astr_autoschedule.seconds_after
if ll_secondsafter = 0 then return true

ids_est_poc.dataobject = "d_sq_gr_poc_est"
ids_est_poc.settransobject(sqlca)
ll_rowcount = ids_est_poc.retrieve(astr_autoschedule.vessel_nr, astr_autoschedule.year)

ls_findexp = "vessel_nr = " + string(astr_autoschedule.vessel_nr) + " and voyage_nr = '" + astr_autoschedule.voyage_nr + &
	          "' and port_code = '" + astr_autoschedule.port_code + "' and pcn = " + string(astr_autoschedule.pcn)
ll_findrow = ids_est_poc.find(ls_findexp, ll_rowcount, 1)
if ll_findrow = 0 then return true

for ll_option_row = ll_findrow to ll_rowcount
	if ll_secondsafter = 0 then exit
	
	ldt_ori_etd  = ids_est_poc.getitemdatetime(ll_option_row, "port_dept_dt", Primary!, true)
	ll_port_stay = ids_est_poc.getitemnumber(ll_option_row, "port_stay")	* 60 * 60		//Get Port Stay and switch it to seconds.
	if isnull(ldt_ori_etd) and (isnull(ll_port_stay) or ll_port_stay = 0) then	//if port stay is null, can't calculate departure date.
		ls_shiptype = ids_est_poc.getitemstring(ll_option_row, "cal_vest_type_name")
		ls_purpose  = ids_est_poc.getitemstring(ll_option_row, "purpose_code")
		messagebox("Auto Schedule Info", of_getpterrtext(ls_shiptype, ls_purpose) + "~r~n~r~n" + is_ADDITIONMSG)
		return false
	end if
	
	ldt_ori_eta  = ids_est_poc.getitemdatetime(ll_option_row, "port_arr_dt", Primary!, true)
	ldt_ori_etb  = ids_est_poc.getitemdatetime(ll_option_row, "port_berthing_time", Primary!, true)
	
	ldt_new_eta = inv_date_utility.of_relativedatetime(ldt_ori_eta, ll_secondsafter)	//Get NETA value.
	if isnull(ldt_ori_etb) then	//OETB is null, next row's secondsafter is same the current row's.
		setnull(ldt_new_etb)
		if isnull(ldt_ori_etd) then
			ldt_new_etd = inv_date_utility.of_relativedatetime(ldt_new_eta, ll_port_stay)
		else
			ldt_new_etd = inv_date_utility.of_relativedatetime(ldt_ori_etd, ll_secondsafter)
		end if
	else	//OETB is not null
		if ldt_ori_eta > ldt_ori_etb then	//OETA is after OETB
			setnull(ldt_new_etb)
			ldt_new_etd = inv_date_utility.of_relativedatetime(ldt_new_eta, ll_port_stay)
		else
			if ldt_new_eta >= ldt_ori_etb then	//NETA is after OETB
				setnull(ldt_new_etb)
				//Nextdiff = NETD - OETD = (NETA + PT) - (OETB + PT) = NETA - OETB
				ll_secondsafter = inv_date_utility.of_secondsafter(ldt_ori_etb, ldt_new_eta)
				if isnull(ldt_ori_etd) then		//OETD is null. NETD = NETA + PT
					ldt_new_etd = inv_date_utility.of_relativedatetime(ldt_new_eta, ll_port_stay)
				else	//OETD is not null. NETD = NETA + OPT = NETA + (OETD - OETB)
					ldt_new_etd = inv_date_utility.of_relativedatetime(ldt_new_eta, inv_date_utility.of_secondsafter(ldt_ori_etb, ldt_ori_etd))
				end if
			else
				ldt_new_etb = ldt_ori_etb
				ldt_new_etd = ldt_ori_etd
				ll_secondsafter = 0
			end if
		end if
	end if
		
	ids_est_poc.setitem(ll_option_row, "port_arr_dt", ldt_new_eta)
	ids_est_poc.setitem(ll_option_row, "auto_arr_status", ii_AUTOCAL)
	
	if (ldt_new_etb <> ldt_ori_etb) or (isnull(ldt_new_etb) and not isnull(ldt_ori_etb)) or (not isnull(ldt_new_etb) and isnull(ldt_ori_etb)) then
		ids_est_poc.setitem(ll_option_row, "port_berthing_time", ldt_new_etb)
		ids_est_poc.setitem(ll_option_row, "auto_ber_status", ii_AUTOCAL)
	end if
	
	ids_est_poc.setitem(ll_option_row, "port_dept_dt", ldt_new_etd)
	ids_est_poc.setitem(ll_option_row, "auto_dept_status", ii_AUTOCAL)
	
	ids_est_poc.setitem(ll_option_row, "autoschedule_status", 1)
	ids_est_poc.setitem(ll_option_row, "dates_updated_by", uo_global.is_userid)
	ids_est_poc.setitem(ll_option_row, "local_dates_updated", now())
next

return (ids_est_poc.update() = 1 )

end function

public subroutine of_set_steamingtime (datawindow adw_proc_pcnc, datawindow adw_poc, integer ai_type);/********************************************************************
   of_set_steamingtime
   <DESC>	Reset proceeding steaming time and port stay	</DESC>
   <RETURN>	(none)
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_proc_pcnc
		adw_poc
		ai_type
   </ARGS>
   <USAGE>	When retrieveend or new a poc	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	26/10/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_columnprefix
long		ll_currow
datetime	ldt_petd, ldt_letd

il_proceeding_st = 0

if ai_type = ii_ESTIMATED then ls_columnprefix = "poc_est_"

ll_currow = adw_proc_pcnc.getselectedrow(0)
if 0 < ll_currow and ll_currow <= adw_proc_pcnc.rowcount() then
	il_proceeding_st = adw_proc_pcnc.getitemdecimal(ll_currow, "steamingtime") * 60 * 60			//Hours to seconds
	
	if adw_poc.rowcount() > 0 then
		//Refresh previous_etd and calc_petd
		ldt_petd = adw_proc_pcnc.getitemdatetime(ll_currow, "previous_etd")
		ldt_letd = adw_proc_pcnc.getitemdatetime(ll_currow, "calc_petd")
		
		adw_poc.setitem(1, "previous_etd", ldt_petd)
		adw_poc.setitemstatus(1, "previous_etd", primary!, notmodified!)
		adw_poc.setitem(1, "calc_petd", ldt_letd)
		adw_poc.setitemstatus(1, "calc_petd", primary!, notmodified!)		
	end if
end if

end subroutine

public subroutine of_set_portstay (datawindow adw_poc, integer ai_type, boolean as_disperrinfor);/********************************************************************
   of_set_portstay
   <DESC>	Reset port stay	</DESC>
   <RETURN>	(none)
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_poc
		ai_type
   </ARGS>
   <USAGE>	When change a purpose_code	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	14/11/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_columnprefix, ls_purpose_code

il_shiptype_portstay = 0

if ai_type = ii_ESTIMATED then ls_columnprefix = "poc_est_"

if adw_poc.rowcount() > 0 then
	//Refresh port stay
	ls_purpose_code = adw_poc.getitemstring(1, ls_columnprefix + "purpose_code")
	if not isnull(ls_purpose_code) then
		il_shiptype_portstay = of_get_shiptype_portstay(il_vessel_nr, ls_purpose_code, as_disperrinfor)
		if ai_type = ii_ESTIMATED then
			adw_poc.setitem(1, "shiptype_portstay", il_shiptype_portstay)
			adw_poc.setitemstatus(1, "shiptype_portstay", primary!, notmodified!)
		end if
	end if
end if

end subroutine

public function string of_getpterrtext (string as_shiptype, string as_purpose_code);/********************************************************************
   of_getpterrtext
   <DESC>	build an error text 	</DESC>
   <RETURN>	string:
            error text	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_shiptype
		as_purpose_code
   </ARGS>
   <USAGE>	when port stay of ship type is null	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	15/11/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_text

ls_text = "Please update the port stay duration for the purpose '" + as_purpose_code + &
			 "' in System Tables > General > Ship Type for '" + as_shiptype + &
			 "', otherwise the system will not be able to calculate the vessel schedule."

return ls_text

end function

public function boolean of_validate_proceeding (integer ai_vesselnr, string as_voyagenr, integer ai_pcn, string as_portcode, datetime adt_procdate);/********************************************************************
   of_checkautoschedule_proceeding
   <DESC> the proceeding date valid to be changed by autoschedule  </DESC>
   <RETURN>	boolean:
            <LI> false ,not valid to run autoschedule .
            <LI> true,need to run autoschedule	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vesselnr
		as_voyagenr
		ai_pcn
		as_portcode
		adt_procdate
   </ARGS>
   <USAGE>When modifying the proceeding date in proceeding window</USAGE>
   <HISTORY>
   	Date       CR-Ref                Author             Comments
   	14/11/11   CR2535&CR2536         TTY004        First Version
		02/04/13   CR3049						LGX001		  Include the check when the date is equal to proceeding date  
   </HISTORY>
********************************************************************/

integer li_count, li_countport
string ls_construct_voyagenr //Construct voyage_nr from 11503 to 2011503

if isnull(ai_vesselnr) or isnull(as_voyagenr) or isnull(ai_pcn) or isnull(adt_procdate) then return false

SELECT count(PORT_CODE)
  INTO:li_count
  FROM POC_EST
 WHERE VESSEL_NR =:ai_vesselnr
   AND VOYAGE_NR =:as_voyagenr
   AND PCN =:ai_pcn
   AND PORT_CODE =:as_portcode;
	
if li_count > 0 then//if current proceeding is exists est port of all 

	SELECT count(POC.PORT_CODE)
	  INTO:li_countport
	  FROM PROCEED,POC
	 WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR
		AND PROCEED.VOYAGE_NR = POC.VOYAGE_NR
		AND PROCEED.PCN = POC.PCN
		AND PROCEED.PORT_CODE = POC.PORT_CODE
		AND PROCEED.VESSEL_NR = :ai_vesselnr
		AND PROCEED.VOYAGE_NR = :as_voyagenr
		AND DATEDIFF(Second, :adt_procdate, PROCEED.PROC_DATE) >= 0; 
				
	//if exists act port of call follows then ,do not allow to move port order(date) and reject the value.
	if li_countport > 0  then 
		messagebox("Validation", "You are trying to change the proceeding order of an Estimated "+&
      "Port of Call, so that it would be placed before an already existing Actual Port of Call. "+&
		"This is not allowed; therefore your change will not be updated.")
		return false
	end if 

else
	//if current proceeding is not  exists est POC ,search if exists a actual POC
	li_count = 0
	li_countport = 0 
	
	SELECT count(PORT_CODE)
	  INTO:li_count
	  FROM POC
	 WHERE VESSEL_NR =:ai_vesselnr
		AND VOYAGE_NR =:as_voyagenr
		AND PCN =:ai_pcn
		AND PORT_CODE =:as_portcode;
		
	if li_count > 0 then //if current proceeding exists actual port of call
		
		SELECT count(POC_EST.PORT_CODE)
		  INTO:li_countport
		  FROM PROCEED,POC_EST
		 WHERE PROCEED.VESSEL_NR = POC_EST.VESSEL_NR
			AND PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR
			AND PROCEED.PCN = POC_EST.PCN
			AND PROCEED.PORT_CODE = POC_EST.PORT_CODE
			AND PROCEED.VESSEL_NR = :ai_vesselnr
			AND PROCEED.VOYAGE_NR = :as_voyagenr
			AND DATEDIFF(Second, :adt_procdate, PROCEED.PROC_DATE) <= 0;
			
		//if exists est port of call previous then ,do not allow to move port order(date) and reject the value.
		if li_countport > 0 then 
			messagebox("Validation", "You are trying to change the proceeding order of an Actual Port of Call, "+&
			"so that it would be placed after an already existing Estimated Port of Call. This is not allowed; "+&
			"therefore your change will not be updated.")
			return false
		end if 
		
	end if 	
end if 

return true
end function

public function integer of_distancechanged (integer ai_vesselnr, string as_voyagenr, string as_year);/********************************************************************
of_autoschedule_distancechanged
<DESC>Is autoschedule required after distance is changed 		</DESC>
<RETURN>	integer:
			<LI> c#return.noaction, no autoschedule required
			<LI> c#return.success,run autoschedule 	</RETURN>
<ACCESS> public </ACCESS>
<ARGS>
	ai_vesselnr
	as_voyagenr
	as_year
</ARGS>
<USAGE>When new, cancel,delete proceeding</USAGE>
<HISTORY>
	Date       CR-Ref       		  Author             Comments
	14/11/11   CR2535&CR2536        TTY004        First Version
	12/08/13   CR2790			        WWA048	       Calculate the distance for canal 			
</HISTORY>
********************************************************************/


mt_n_datastore lds_proceeding_list
long ll_foundrow, ll_rowcount, ll_row, ll_previousvoyage, ll_fromport
string ls_voyagenr, ls_portcode, ls_construct_voyagenr
long ll_distance, ll_begin, ll_end
datetime ldt_procdate
integer li_pcn, li_return
string ls_fromport, ls_toport, ls_estportcode, ls_begin, ls_end
boolean lb_validate, lb_autoschedule

if as_voyagenr = '' or isnull(as_voyagenr) then return c#return.Noaction

lds_proceeding_list = create mt_n_datastore
lds_proceeding_list.dataobject = "d_sq_vessel_allvoyages"
lds_proceeding_list.settransobject(sqlca)
lds_proceeding_list.retrieve(ai_vesselnr)
ll_rowcount = lds_proceeding_list.rowcount()

//if only one proceed record of vessel ,do not need to recalculate distance
if ll_rowcount  <= 1 then 
	destroy(lds_proceeding_list)
	return c#return.noaction
end if 

if left(as_voyagenr, 2) > '90' then
	ls_construct_voyagenr = '19' + as_voyagenr
else
	ls_construct_voyagenr = '20' + as_voyagenr
end if

ll_foundrow = lds_proceeding_list.find("cons_voyage >= '"+ls_construct_voyagenr+"'", 1, ll_rowcount)
if ll_foundrow < 1 then 
	destroy(lds_proceeding_list)
	return c#return.noaction
end if 

//Added by ZSW001 on 29/05/2012. find the row number of previous voyages. 
ll_previousvoyage = lds_proceeding_list.find("cons_voyage < '" + ls_construct_voyagenr + "'", ll_foundrow, 1)
if ll_previousvoyage > 0 then
	ls_construct_voyagenr = lds_proceeding_list.getitemstring(ll_previousvoyage, "cons_voyage")
	ll_previousvoyage = lds_proceeding_list.find("cons_voyage = '" + ls_construct_voyagenr + "'", 1, ll_previousvoyage)
end if

ls_voyagenr = lds_proceeding_list.getitemstring(ll_foundrow, "voyage_nr")
ldt_procdate = lds_proceeding_list.getitemdatetime(ll_foundrow, "proc_date")
li_pcn = lds_proceeding_list.getitemnumber(ll_foundrow, "pcn")
ls_portcode = lds_proceeding_list.getitemstring(ll_foundrow, "port_code")

for ll_row = ll_foundrow to ll_rowcount
	if ll_row = 1 then 		
		lds_proceeding_list.setitem(ll_row, "atobviac_distance", 0)		
		continue;
	end if
	
	ll_fromport = ll_row - 1
	ls_fromport = lds_proceeding_list.getitemstring(ll_fromport, "abc_portcode")
	ls_toport = lds_proceeding_list.getitemstring(ll_row, "abc_portcode")
	
	ll_distance = of_get_atobviacdistance(ls_fromport, ls_toport)
	
	if isnull(ll_distance) then
		ll_begin = lds_proceeding_list.find("via_point = 0", ll_row - 1, 1)
		ll_end = lds_proceeding_list.find("via_point = 0", ll_row, ll_rowcount)
		
		if ll_begin > 0 and ll_end > 0 then
			ls_begin = lds_proceeding_list.getitemstring(ll_begin, "abc_portcode")
			ls_end = lds_proceeding_list.getitemstring(ll_end, "abc_portcode")
			
			ll_distance = gnv_atobviac.of_getporttoportdistance(ls_fromport, ls_toport, ls_begin, ls_end)
		end if
	end if
	
	//Distance calculation Begin added by ZSW001 on 29/05/2012
	do while isnull(ll_distance)
		ll_fromport --
		if ll_fromport <= 0 or ll_fromport < ll_previousvoyage then exit
		
		ls_fromport = lds_proceeding_list.getitemstring(ll_fromport, "abc_portcode")
		ll_distance = of_get_atobviacdistance(ls_fromport, ls_toport)
	loop
	//Distance calculation End added by ZSW001 on 29/05/2012
	
	lds_proceeding_list.setitem(ll_row, "atobviac_distance", ll_distance)	
	if lds_proceeding_list.getitemstring(ll_row, "voyage_nr") <> ls_voyagenr then exit;
next

li_return = c#return.noaction

if lds_proceeding_list.update(true, true) = 1 then 
	commit ;	
	if (ids_ori_proceed_poc.rowcount() > 0) then
		of_autoschedule_proceeding(ai_vesselnr, as_year)				
		li_return = c#return.success	
	end if
else 
	rollback;	
	li_return = c#return.failure
end if 

destroy lds_proceeding_list
return li_return


end function

public function integer of_speedchanged (datawindow adw_proceedinglist, integer ai_vesselnr, string as_voyagenr, long al_row, string as_year);/********************************************************************
   of_autoschedule_speedchanged
   <DESC>run autoschedule by speed-changed</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, execute and recalculate by autoschedule 
            <LI> c#return.noaction, no need to run autoschedule 	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_proceedinglist
		as_voyagenr
		al_row
   </ARGS>
   <USAGE>When changing speed in proceeding window</USAGE>
   <HISTORY>
   	Date       CR-Ref       			Author             Comments
   	14/11/11  CR2535&CR2536          TTY004        First Version
   </HISTORY>
********************************************************************/

string ls_estportcode, ls_voyagenr, ls_portcode, ls_errtext
integer li_pcn, li_count = 0
datetime ldt_procdate
decimal{2} ldc_speed, ldc_original_speed
long ll_distance, ll_seconds_after
boolean lb_return, lb_doautoschedule = false
s_autoschedule lstr_autoschedule
n_autoschedule lnv_autoschedule

if isnull(as_voyagenr) or isnull(aI_vesselnr) or isnull(al_row) or isnull(as_year) then return c#return.noaction

ldt_procdate = adw_proceedinglist.getitemdatetime(al_row, "proc_date")
li_pcn = adw_proceedinglist.getitemnumber(al_row, "pcn")
ls_portcode = adw_proceedinglist.getitemstring(al_row, "port_code")
ll_distance = adw_proceedinglist.getitemnumber(al_row, "atobviac_distance")
ldc_speed = adw_proceedinglist.getitemnumber(al_row, "speed")
ldc_original_speed = adw_proceedinglist.getitemnumber(al_row, "speed", primary!, true)

if ll_distance = 0 or isnull(ll_distance) or isnull(ldc_speed) or isnull(ldc_original_speed) or &
ldc_speed = 0.00 or ldc_original_speed = 0.00 then return c#return.noaction

SELECT count(POC.PORT_CODE)
  INTO :li_count
  FROM PROCEED, POC
 WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR AND 
       PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND 
		 PROCEED.PCN       = POC.PCN AND 
		 PROCEED.PORT_CODE = POC.PORT_CODE AND
		 PROCEED.VESSEL_NR = :ai_vesselnr AND
		 Convert(int, Left(PROCEED.VOYAGE_NR, 2)) < 90 AND
		 ((PROCEED.VOYAGE_NR = :as_voyagenr AND DATEDIFF(Second, PROCEED.PROC_DATE, :ldt_procdate) < 0) OR PROCEED.VOYAGE_NR > :as_voyagenr);

if li_count > 0 then 
	return c#return.noaction
else
	li_count = 0 
	
	SELECT count(POC_EST.PORT_CODE)
	  INTO :li_count
	  FROM PROCEED, POC_EST
	 WHERE PROCEED.VESSEL_NR = POC_EST.VESSEL_NR AND 
	       PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR AND 
			 PROCEED.PCN       = POC_EST.PCN AND 
			 PROCEED.PORT_CODE = POC_EST.PORT_CODE AND 
			 PROCEED.VESSEL_NR = :ai_vesselnr AND
			 Convert(int, Left(PROCEED.VOYAGE_NR, 2)) < 90 AND
			  ((PROCEED.VOYAGE_NR = :as_voyagenr AND DATEDIFF(Second, PROCEED.PROC_DATE, :ldt_procdate) <= 0) OR PROCEED.VOYAGE_NR > :as_voyagenr) ;
   
	if li_count > 0 then
		lb_doautoschedule = true
	end if
	
end if

if lb_doautoschedule then
	SELECT POC_EST.PORT_CODE,POC_EST.PCN,POC_EST.VOYAGE_NR
	  INTO :ls_estportcode, :li_pcn, :ls_voyagenr
	  FROM PROCEED, POC_EST
	 WHERE PROCEED.VESSEL_NR = POC_EST.VESSEL_NR AND
	       PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR AND 
			 PROCEED.PCN       = POC_EST.PCN AND
			 PROCEED.PORT_CODE = POC_EST.PORT_CODE AND
			 POC_EST.VESSEL_NR = :ai_vesselnr AND
			 Convert(int, Left(PROCEED.VOYAGE_NR, 2)) < 90 AND
			 ((PROCEED.VOYAGE_NR = :as_voyagenr AND DATEDIFF(Second, PROCEED.PROC_DATE, :ldt_procdate) <= 0) OR PROCEED.VOYAGE_NR > :as_voyagenr)
	ORDER BY PROCEED.VOYAGE_NR, PROCEED.PROC_DATE ASC;
	
	if len(ls_estportcode) > 1 and uo_global.ib_pocautoschedule then
		if Messagebox("Speed Changed","You have changed a speed that is used in auto schedule calculation. "+&
		"Do you want to re-schedule and update all subsequent dates in Port of Call automatically?", question!,yesno!,2) = 1 then
			ll_seconds_after = ll_distance/ldc_speed*3600 - ll_distance/ldc_original_speed*3600
			lstr_autoschedule.pcn           = li_pcn
			lstr_autoschedule.vessel_nr     = ai_vesselnr
			lstr_autoschedule.voyage_nr     = ls_voyagenr
			lstr_autoschedule.year          = as_year
			lstr_autoschedule.port_code     = ls_estportcode
			lstr_autoschedule.seconds_after = ll_seconds_after
			
			lb_return = of_autoschedule_poc(lstr_autoschedule)
			if lb_return then 
				commit ;
				return c#return.success
			else 
				rollback;
				messagebox("Error", "Failed to do auto schedule.~r~n~r~n" + ls_errtext, stopsign!)
				return c#return.failure
			end if 
		end if
	end if
end if

return c#return.noaction



end function

public subroutine of_setetdmodified (boolean ab_etd_manual);/********************************************************************
   of_setetdmodified
   <DESC>	set the modify status of departure	</DESC>
   <RETURN>	(None):
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_modified
   </ARGS>
   <USAGE>	When departure date is modified or after retrieve end	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	17/11/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

ib_etd_manual = ab_etd_manual

end subroutine

public function long of_get_poc_before (datetime adt_proceed_dt);/********************************************************************
   of_get_poc_before
   <DESC>	Get the count of poc before adt_proceed_dt 	</DESC>
   <RETURN>	long:
            the count of poc before adt_proceed_dt	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adt_proceed_dt
   </ARGS>
   <USAGE>	When need to get the count of poc	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	17/11/2011   2535 & 2536  ZSW001       First Version
   </HISTORY>
********************************************************************/

long	ll_act_count, ll_est_count

SELECT count(*)
  INTO :ll_act_count
  FROM POC, PROCEED
 WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR AND
		 PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
		 PROCEED.PORT_CODE = POC.PORT_CODE AND
		 PROCEED.PCN = POC.PCN AND
		 PROCEED.VESSEL_NR = :il_vessel_nr AND
		 DATEDIFF(Second, :adt_proceed_dt, PROCEED.PROC_DATE) < 0;
		 
SELECT count(*)
  INTO :ll_est_count
  FROM POC_EST, PROCEED
 WHERE PROCEED.VESSEL_NR = POC_EST.VESSEL_NR AND
		 PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR AND
		 PROCEED.PORT_CODE = POC_EST.PORT_CODE AND
		 PROCEED.PCN = POC_EST.PCN AND
		 PROCEED.VESSEL_NR = :il_vessel_nr AND
		 DATEDIFF(Second, :adt_proceed_dt, PROCEED.PROC_DATE) < 0;
		 
return ll_act_count + ll_est_count

end function

public function boolean of_check_proceedingdate (datawindow adw_proceedinglist, long al_row, datetime adt_procdate);/********************************************************************
   of_check_proceedingdate
   <DESC>check if the order of proceeding order is effected by the modified
	      proc_date</DESC>
   <RETURN>	boolean:
            <LI> true, the orders of proceeding have been changed
            <LI> false,the orders of proceeding have not been changed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_proceedinglist
		al_row
		adt_procdate
   </ARGS>
   <USAGE>	when changed proc_date in proceeding window	</USAGE>
   <HISTORY>
   	Date       CR-Ref       			Author             Comments
   	17/11/11  CR2535&CR2536           TTY004        First Version
   </HISTORY>
********************************************************************/
datetime ldt_min_date, ldt_max_date
long ll_rowcount
string ls_pre_voyagenr, ls_curr_voyagenr, ls_next_voyagenr

ldt_min_date = datetime('1900-01-01 00:00:00')
ldt_max_date = datetime('2049-12-12 23:59:59')
ll_rowcount = adw_proceedinglist.rowcount()
ls_curr_voyagenr = adw_proceedinglist.getitemstring(al_row , "voyage_nr")

if al_row = 1 and al_row < ll_rowcount then
	ls_next_voyagenr = adw_proceedinglist.getitemstring(al_row + 1, "voyage_nr")
	if ls_curr_voyagenr = ls_next_voyagenr then
		ldt_max_date = adw_proceedinglist.getitemdatetime(al_row + 1, "proc_date")
	end if
end if

if al_row > 1 and al_row = ll_rowcount then
	ls_pre_voyagenr = adw_proceedinglist.getitemstring(al_row - 1, "voyage_nr")
	if ls_curr_voyagenr = ls_pre_voyagenr then
		ldt_min_date = adw_proceedinglist.getitemdatetime(al_row - 1, "proc_date")
	end if 
end if

if al_row > 1 and al_row < ll_rowcount  then 
	ls_pre_voyagenr = adw_proceedinglist.getitemstring(al_row - 1, "voyage_nr")
	if ls_curr_voyagenr = ls_pre_voyagenr then
		ldt_min_date = adw_proceedinglist.getitemdatetime(al_row - 1, "proc_date")
	end if
	ls_next_voyagenr = adw_proceedinglist.getitemstring(al_row + 1, "voyage_nr")
	if ls_curr_voyagenr = ls_next_voyagenr then
		ldt_max_date = adw_proceedinglist.getitemdatetime(al_row + 1, "proc_date")
	end if
end if 
if adt_procdate > ldt_min_date and adt_procdate < ldt_max_date then
	return false
end if
return true
	

end function

public function integer of_setdistances (integer ai_vesselnr, string as_voyagenr);/********************************************************************
of_setdistances

<DESC>Is autoschedule required after distance is changed 		</DESC>
<RETURN>	integer:
			<LI> c#return.failure  
			<LI> c#return.success 	</RETURN>
<ACCESS> public </ACCESS>
<ARGS>
	ai_vesselnr
	as_voyagenr
	as_year
</ARGS>
<USAGE>From AX estimations process that sets historic distances in proceeding</USAGE>
<HISTORY>
	Date       CR-Ref       		  Author             Comments
	15/02/12   FINANCE-M08       		AGL027        First Version
	31/05/12   FINANCE-M08       		JMC112        It calculates the distance between from the last port with distance.
	12/08/13   CR2790		       		WWA048        Add the distance for canal
</HISTORY>
********************************************************************/


mt_n_datastore lds_proceeding_list
long ll_foundrow, ll_rowcount, ll_row
string ls_voyagenr, ls_portcode, ls_construct_voyagenr
long ll_distance, ll_begin, ll_end
datetime ldt_procdate
integer li_pcn, li_return
string ls_fromport, ls_toport, ls_estportcode, ls_previousport, ls_begin, ls_end
boolean lb_validate, lb_autoschedule

if as_voyagenr = '' or isnull(as_voyagenr) then return c#return.Noaction

lds_proceeding_list = create mt_n_datastore
lds_proceeding_list.dataobject = "d_sq_vessel_allvoyages"
lds_proceeding_list.settransobject(sqlca)
lds_proceeding_list.retrieve(ai_vesselnr)
ll_rowcount = lds_proceeding_list.rowcount()

//if only one proceed record of vessel ,do not need to recalculate distance
if ll_rowcount  <= 1 then 
	destroy(lds_proceeding_list)
	return c#return.noaction
end if 

if left(as_voyagenr, 2) > '90' then
	ls_construct_voyagenr = '19' + as_voyagenr
else
	ls_construct_voyagenr = '20' + as_voyagenr
end if
ll_foundrow = lds_proceeding_list.find("cons_voyage >= '"+ls_construct_voyagenr+"'", 1, ll_rowcount)

if ll_foundrow < 1 then 
	destroy(lds_proceeding_list)
	return c#return.noaction
end if 

ls_voyagenr = lds_proceeding_list.getitemstring(ll_foundrow, "voyage_nr")
ldt_procdate = lds_proceeding_list.getitemdatetime(ll_foundrow, "proc_date")
li_pcn = lds_proceeding_list.getitemnumber(ll_foundrow, "pcn")
ls_portcode = lds_proceeding_list.getitemstring(ll_foundrow, "port_code")

for ll_row = ll_foundrow to ll_rowcount
	if ll_row = 1 then 		
		lds_proceeding_list.setitem(ll_row, "atobviac_distance", 0)		
		continue;
	end if 
	
	ls_fromport = lds_proceeding_list.getitemstring(ll_row - 1, "abc_portcode")
	ls_toport = lds_proceeding_list.getitemstring(ll_row, "abc_portcode")

	/* required due to possibility that a port can not be found. */
	TRY
		ll_distance = of_get_atobviacdistance(ls_fromport, ls_toport)
		
		if isnull(ll_distance) then
			ll_begin = lds_proceeding_list.find("via_point = 0", ll_row - 1, 1)
			ll_end = lds_proceeding_list.find("via_point = 0", ll_row, ll_rowcount)
			
			if ll_begin > 0 and ll_end > 0 then
				ls_begin = lds_proceeding_list.getitemstring(ll_begin, "abc_portcode")
				ls_end = lds_proceeding_list.getitemstring(ll_end, "abc_portcode")
				ll_distance = gnv_atobviac.of_getporttoportdistance(ls_fromport, ls_toport, ls_begin, ls_end)
			end if
		end if
		
		lds_proceeding_list.setitem(ll_row, "atobviac_distance", ll_distance)		
	CATCH ( Throwable ex )
	//	_addmessage( this.classdefinition, "of_setdistances()", "error in loading distance between port " + ls_fromport + " and " + ls_toport, "")
	FINALLY
		/* no action  here */
	END TRY

next

li_return = c#return.noaction

if lds_proceeding_list.update(true, true) = 1 then 
	commit;	
	li_return = c#return.success
else 
	rollback;	
	li_return = c#return.failure
end if 

destroy lds_proceeding_list
return li_return
end function

public function boolean of_checkautoschedule_proceeding (integer ai_vesselnr, string as_voyagenr, datetime adt_originalprocdate, datetime adt_currentprocdate);/********************************************************************
   of_checkautoschedule_proceeding
   <DESC>check if need to run autoschedule</DESC>
   <RETURN>	boolean:
            <LI> flase,no need to run autoschedule .
            <LI> true,run autoschedule	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vesselnr
		as_voyagenr
		ai_pcn
		adt_originalprocdate
		adt_currentprocdate
   </ARGS>
   <USAGE>When new,delete,cancel,changing speed in proceeding window	</USAGE>
   <HISTORY>
   	Date       CR-Ref       			Author             Comments
   	14/11/11   CR2535&CR2536         TTY004        First Version
		02/04/13   CR3049						LGX001		  1.Include the check when the date is equal to proceeding date
																	  2. Fixed histrory bug when dyn setting uo_global.ib_pocautoschedule
********************************************************************/

integer	li_act_count, li_est_count

if not uo_global.ib_pocautoschedule then
	ids_ori_proceed_poc.reset()
	return false
end if

if isnull(as_voyagenr) or isnull(adt_originalprocdate) then return false

//Current port is actual
SELECT count(POC.PORT_CODE)
  INTO :li_act_count
  FROM PROCEED, POC
 WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR AND
       PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
		 PROCEED.PCN       = POC.PCN AND
		 PROCEED.PORT_CODE = POC.PORT_CODE AND
		 PROCEED.VESSEL_NR = :ai_vesselnr AND
		 (PROCEED.VOYAGE_NR = :as_voyagenr AND DATEDIFF(Second, PROCEED.PROC_DATE, :adt_originalprocdate) = 0) ;

if li_act_count > 0 then return false

//Exist actual port(s) after the moved port
SELECT count(POC.PORT_CODE)
  INTO :li_act_count
  FROM PROCEED, POC
 WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR AND
       PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
		 PROCEED.PCN       = POC.PCN AND
		 PROCEED.PORT_CODE = POC.PORT_CODE AND
		 PROCEED.VESSEL_NR = :ai_vesselnr AND
		 Convert(int, Left(PROCEED.VOYAGE_NR, 2)) < 90 AND
		 ((PROCEED.VOYAGE_NR = :as_voyagenr AND DATEDIFF(Second, PROCEED.PROC_DATE, :adt_currentprocdate) <= 0) OR PROCEED.VOYAGE_NR > :as_voyagenr) ;

if li_act_count > 0 then return false

//Current port is estimate
SELECT count(POC_EST.PORT_CODE)
  INTO :li_est_count
  FROM PROCEED, POC_EST
 WHERE PROCEED.VESSEL_NR = POC_EST.VESSEL_NR AND
       PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR AND
		 PROCEED.PCN       = POC_EST.PCN AND
		 PROCEED.PORT_CODE = POC_EST.PORT_CODE AND
		 PROCEED.VESSEL_NR = :ai_vesselnr AND
		 (PROCEED.VOYAGE_NR = :as_voyagenr AND DATEDIFF(Second, PROCEED.PROC_DATE, :adt_originalprocdate) = 0) ;

if li_est_count <= 0 then
	//Exist estimate port(s) after the moved port
	SELECT count(POC_EST.PORT_CODE)
	  INTO :li_est_count
	  FROM PROCEED, POC_EST
	 WHERE PROCEED.VESSEL_NR = POC_EST.VESSEL_NR AND
			 PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR AND
			 PROCEED.PCN       = POC_EST.PCN AND
			 PROCEED.PORT_CODE = POC_EST.PORT_CODE AND
			 PROCEED.VESSEL_NR = :ai_vesselnr AND
			 Convert(int, Left(PROCEED.VOYAGE_NR, 2)) < 90 AND
			 ((PROCEED.VOYAGE_NR = :as_voyagenr AND DATEDIFF(Second, PROCEED.PROC_DATE, :adt_currentprocdate) <= 0 AND 
			   DATEDIFF(Second, PROCEED.PROC_DATE, :adt_originalprocdate) <> 0) OR PROCEED.VOYAGE_NR >: as_voyagenr) ;
end if

if li_est_count <= 0 then
	//Exist actual port(s) before the port to be moved
	SELECT count(POC.PORT_CODE)
	  INTO :li_act_count
	  FROM PROCEED, POC
	 WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR AND
			 PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
			 PROCEED.PCN       = POC.PCN AND
			 PROCEED.PORT_CODE = POC.PORT_CODE AND
			 PROCEED.VESSEL_NR = :ai_vesselnr AND
			 Convert(int, Left(PROCEED.VOYAGE_NR, 2)) < 90 AND
			 ((PROCEED.VOYAGE_NR = :as_voyagenr AND DATEDIFF(Second, PROCEED.PROC_DATE, :adt_originalprocdate) < 0) OR PROCEED.VOYAGE_NR > :as_voyagenr) ;

	if li_act_count <= 0 then
		//Exist estimate port(s) before the port to be moved
		SELECT count(POC_EST.PORT_CODE)
		  INTO :li_est_count
		  FROM PROCEED, POC_EST
		 WHERE PROCEED.VESSEL_NR = POC_EST.VESSEL_NR AND
				 PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR AND
				 PROCEED.PCN       = POC_EST.PCN AND
				 PROCEED.PORT_CODE = POC_EST.PORT_CODE AND
				 PROCEED.VESSEL_NR = :ai_vesselnr AND
				 Convert(int, Left(PROCEED.VOYAGE_NR, 2)) < 90 AND
				 ((PROCEED.VOYAGE_NR = :as_voyagenr AND DATEDIFF(Second, PROCEED.PROC_DATE, :adt_originalprocdate) < 0) OR PROCEED.VOYAGE_NR >: as_voyagenr) ;
	end if
end if

if li_est_count > 0 then
	if Messagebox("Distance Changed", "The distance between ports has been changed. Do you want to re-schedule"+&
		" and update all subsequent dates in Port of Call automatically? ",question!, yesno!, 2 ) = 1 then
		return true
	end if
end if

return false

end function

public function boolean of_checkautoschedule_proceeding (integer ai_vesselnr, string as_voyagenr, datetime adt_procdate);/********************************************************************
   of_checkautoschedule_proceeding
   <DESC>reload funtion of_checkautoschedule(ai_vesselnr,as_voyagenr,ai_pcn,adt_original_date,
	      adt_current_date)</DESC>
   <RETURN>	boolean:
	        of_checkautoschedule()'s return value
          	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vesselnr
		as_voyagenr
		ai_pcn
		adt_procdate
   </ARGS>
   <USAGE>set adt_current_date null and call of_checkautoschedule(ai_vesselnr,as_voyagenr,
	ai_pcn,adt_original_date,adt_current_date)	</USAGE>
   <HISTORY>
   	Date       CR-Ref       			Author             Comments
   	17/11/11   CR2535&CR2536         TTY004        First Version
   </HISTORY>
********************************************************************/
datetime ldt_null
setnull(ldt_null)
return of_checkautoschedule_proceeding(ai_vesselnr, as_voyagenr, adt_procdate, ldt_null)

end function

public function long of_get_departuredate (mt_n_datastore ads_poc, ref datetime adt_ori_etd, ref datetime adt_cur_etd, ref long al_seconds);/********************************************************************
   of_get_departuredate
   <DESC>	get the original date, current departure date and delay seconds	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_poc
		adt_ori_etd
		adt_cur_etd
		al_seconds
   </ARGS>
   <USAGE>	Suggest to use in the n_approve_vesselmsg.of_get_autoschedule_seconds() function	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	23/05/2012   CR20         ZSW001       First Version
		26/07/2013	 CR3238		  LHC010			Code Review
		26/02/2014	 CR3340		  LHG008			Fix the bug about poping up warning message twice 
                     			 		  			when the port stay duration time was not defined in Shiptye system table.
   </HISTORY>
********************************************************************/

long		ll_vessel_nr, ll_pcn, ll_found, ll_count, ll_steamingtime, ll_cur_portstay, ll_ori_portstay, ll_seconds
string	ls_voyage_nr, ls_port_code, ls_find, ls_ori_purpose, ls_cur_purpose
datetime	ldt_ori_eta, ldt_cal_eta, ldt_ori_etb, ldt_cur_eta, ldt_cur_etb, ldt_pre_etd
boolean	lb_recalculate

mt_n_datastore	lds_proc_pcnc
dwitemstatus	ldwis_status

if ads_poc.rowcount() <> 1 then return c#return.Failure

//Get key information
ll_vessel_nr = ads_poc.getitemnumber(1, "vessel_nr")
ls_voyage_nr = ads_poc.getitemstring(1, "voyage_nr")
ls_port_code = ads_poc.getitemstring(1, "port_code")
ll_pcn       = ads_poc.getitemnumber(1, "pcn")

if isnull(ll_vessel_nr) or isnull(ls_voyage_nr) or isnull(ls_port_code) or isnull(ll_pcn) then return c#return.Failure

//Get current eta, etb, etd and purpose
ldt_cur_eta = ads_poc.getitemdatetime(1, "port_arr_dt")
ldt_cur_etb = ads_poc.getitemdatetime(1, "port_berthing_time")
adt_cur_etd = ads_poc.getitemdatetime(1, "port_dept_dt")
ls_cur_purpose = ads_poc.getitemstring(1, "purpose_code")

if isnull(ldt_cur_eta) or isnull(ls_cur_purpose) then return c#return.Failure

ldwis_status = ads_poc.getitemstatus(1, 0, primary!)
if ldwis_status = new! or ldwis_status = newmodified! then
	if isnull(adt_cur_etd) then		//calculate current departure date
		ll_cur_portstay = of_get_shiptype_portstay(ll_vessel_nr, ls_cur_purpose, true)
		if isnull(ll_cur_portstay) or ll_cur_portstay = 0 then return c#return.Failure
		if isnull(ldt_cur_etb) then
			adt_cur_etd = inv_date_utility.of_relativedatetime(ldt_cur_eta, ll_cur_portstay)
		else
			adt_cur_etd = inv_date_utility.of_relativedatetime(ldt_cur_etb, ll_cur_portstay)
		end if
	end if
	
	//get port of call list
	lds_proc_pcnc = create mt_n_datastore
	lds_proc_pcnc.dataobject = "dw_proc_pcnc"
	lds_proc_pcnc.settrans(sqlca)
	ll_count = lds_proc_pcnc.retrieve(ll_vessel_nr, "", 1)
	
	ls_find = "proceed_vessel_nr = " + string(ll_vessel_nr) + " and proceed_voyage_nr = '" + ls_voyage_nr + &
	          "' and proceed_port_code = '" + ls_port_code + "' and proceed_pcn = " + string(ll_pcn)
	ll_found = lds_proc_pcnc.find(ls_find, 1, ll_count)
	if ll_found <= 0 then return c#return.Failure
	
	ldt_pre_etd = lds_proc_pcnc.getitemdatetime(ll_found, "previous_etd")
	ll_steamingtime = lds_proc_pcnc.getitemnumber(ll_found, "steamingtime") * 60 * 60
	if isnull(ll_steamingtime) or ll_steamingtime = 0 then return c#return.Failure
	
	//calculate original departure date
	adt_ori_etd = inv_date_utility.of_relativedatetime(ldt_pre_etd, ll_steamingtime)
	
	//calculate the delay senconds
	ll_found = lds_proc_pcnc.find("not isnull(poc_est_port_arr_dt)", ll_found + 1, ll_count + 1)
	if ll_found > 0 then
		ldt_ori_eta = lds_proc_pcnc.getitemdatetime(ll_found, "poc_est_port_arr_dt")
		ll_seconds  = inv_date_utility.of_secondsafter(adt_ori_etd, adt_cur_etd)
		
		if inv_date_utility.of_relativedatetime(ldt_ori_eta, ll_seconds) < adt_cur_etd then
			ldt_pre_etd = lds_proc_pcnc.getitemdatetime(ll_found, "previous_etd")
			ll_steamingtime = lds_proc_pcnc.getitemnumber(ll_found, "steamingtime") * 60 * 60		//hours to seconds
			if isnull(ll_steamingtime) or ll_steamingtime = 0 then return c#return.Failure
			
			ldt_cal_eta = inv_date_utility.of_relativedatetime(ldt_pre_etd, ll_steamingtime + ll_seconds)
			
			//calculate the delay seconds
			al_seconds = inv_date_utility.of_secondsafter(ldt_ori_eta, ldt_cal_eta)
			lb_recalculate = true
		end if
	end if
	
	destroy lds_proc_pcnc
else
	ldt_ori_eta = ads_poc.getitemdatetime(1, "port_arr_dt", primary!, true)
	ldt_ori_etb = ads_poc.getitemdatetime(1, "port_berthing_time", primary!, true)
	adt_ori_etd = ads_poc.getitemdatetime(1, "port_dept_dt", primary!, true)
	ls_ori_purpose = ads_poc.getitemstring(1, "purpose_code", primary!, true)
	
	if isnull(ldt_ori_eta) or isnull(ls_ori_purpose) then return c#return.Failure
	
	//calculate original departure date
	if isnull(adt_ori_etd) then
		ll_ori_portstay = of_get_shiptype_portstay(ll_vessel_nr, ls_ori_purpose, true)
		if isnull(ll_ori_portstay) then return c#return.Failure
		if isnull(ldt_ori_etb) then
			adt_ori_etd = inv_date_utility.of_relativedatetime(ldt_ori_eta, ll_ori_portstay)
		else
			adt_ori_etd = inv_date_utility.of_relativedatetime(ldt_ori_etb, ll_ori_portstay)
		end if
	end if
	
	//calculate current departure date
	if isnull(adt_cur_etd) then
		if ls_cur_purpose = ls_ori_purpose then
			ll_cur_portstay = ll_ori_portstay
		else
			ll_cur_portstay = of_get_shiptype_portstay(ll_vessel_nr, ls_cur_purpose, true)
		end if
		
		if isnull(ll_cur_portstay) or ll_cur_portstay = 0 then return c#return.Failure
		if isnull(ldt_cur_etb) then
			adt_cur_etd = inv_date_utility.of_relativedatetime(ldt_cur_eta, ll_cur_portstay)
		else
			adt_cur_etd = inv_date_utility.of_relativedatetime(ldt_cur_etb, ll_cur_portstay)
		end if
	elseif ads_poc.getitemstatus(1, "port_dept_dt", primary!) = notmodified! then
		if isnull(ldt_ori_etb) then
			ll_ori_portstay = inv_date_utility.of_secondsafter(ldt_ori_eta, adt_ori_etd)
		else
			ll_ori_portstay = inv_date_utility.of_secondsafter(ldt_ori_etb, adt_cur_etd)
		end if
		
		if isnull(ldt_cur_etb) then
			adt_cur_etd = inv_date_utility.of_relativedatetime(ldt_cur_eta, ll_ori_portstay)
		else
			adt_cur_etd = inv_date_utility.of_relativedatetime(ldt_cur_etb, ll_cur_portstay)
		end if
	end if
end if

if not lb_recalculate then
	al_seconds = inv_date_utility.of_secondsafter(adt_ori_etd, adt_cur_etd)
end if

return c#return.Success

end function

public function integer of_init (string as_abctablepath);/********************************************************************
of_init( /*string as_abctablepath */) 

<DESC>
	If atobviac is called outside the application this function allows
	access to load table data file from another location
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	as_abctablepath: file path where BPSTables.bin resides
</ARGS>
<USAGE>
	Usage of this function
	can be found in AXEstimates.
</USAGE>
********************************************************************/

if not isvalid(gnv_atobviac) then gnv_atobviac = create n_atobviac
if not gnv_atobviac.of_gettableopen()  then
	gnv_atobviac.of_opentable(as_abctablepath)
	gnv_atobviac.of_resetToDefaultState()
end if

return c#return.Success
end function

on n_autoschedule.create
call super::create
this.ids_est_poc=create ids_est_poc
this.ids_cur_proceed_poc=create ids_cur_proceed_poc
this.ids_ori_proceed_poc=create ids_ori_proceed_poc
end on

on n_autoschedule.destroy
call super::destroy
destroy(this.ids_est_poc)
destroy(this.ids_cur_proceed_poc)
destroy(this.ids_ori_proceed_poc)
end on

type ids_est_poc from mt_n_datastore within n_autoschedule descriptor "pb_nvo" = "true" 
end type

on ids_est_poc.create
call super::create
end on

on ids_est_poc.destroy
call super::destroy
end on

type ids_cur_proceed_poc from mt_n_datastore within n_autoschedule descriptor "pb_nvo" = "true" 
end type

on ids_cur_proceed_poc.create
call super::create
end on

on ids_cur_proceed_poc.destroy
call super::destroy
end on

type ids_ori_proceed_poc from mt_n_datastore within n_autoschedule descriptor "pb_nvo" = "true" 
end type

on ids_ori_proceed_poc.create
call super::create
end on

on ids_ori_proceed_poc.destroy
call super::destroy
end on

