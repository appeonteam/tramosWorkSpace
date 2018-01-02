$PBExportHeader$uo_global_vars.sru
$PBExportComments$Global variables incapsulated
forward
global type uo_global_vars from nonvisualobject
end type
end forward

global type uo_global_vars from nonvisualobject
end type
global uo_global_vars uo_global_vars

type prototypes
function boolean GetUserNameA(ref string lpBuffer, ref int nSize) library "ADVAPI32.DLL" alias for "GetUserNameA;Ansi"

end prototypes

type variables
private integer goi_vessel_nr
private String goi_voyage_nr
private string gos_port_code
private string gos_proc_text
private integer goi_pcn
private integer goi_agent
private integer goi_chart
private integer goi_parm
private string gos_layout
private string gos_grade
private string gos_group
private int goi_bol_nr
public string gos_userid
private string gos_windows_userid
private string gos_password
private int profit_center_no
private string programversion = "30.01.0"  // version MUST be in format xx.xx.x
string utf8flag = "UTF8=1" //option should be "" or "UTF8=1"
private string programdate = String(Today(),"dd. mmm yyyy")
private string gos_ExeName  // Name of executable file
private string is_app_path //Path to application
string gs_bp_path // Path to BP distance table
string gs_AtoBviaC_path // Path to new distance table (AtoBviaC) 
string gs_wizard_path // Path to Wizard.pbl
string gs_help_path // Path to help files
string gs_template_path // Path to MS Word templates
string gs_calc_wizard // Default wizard
string gs_startup_menu // Default startup menu
string gs_paper_size // Paper Size for printing
string is_pdfdriver    //PDF Printer Driver
string gs_checkid = "checklogin"    //userid for checking if user is allowed to login
string gs_checkpw = "checklogin" //password for gs_checkid
										   //this is moved to be a hardcoded value as the ini-file is not used any more

boolean ib_developer
// Load windows on startup
Boolean ib_load_calc_manager
boolean ib_load_positionlist
boolean ib_load_fixturelist
boolean ib_load_proceeding
boolean ib_load_portofcall
boolean ib_load_cargo
boolean ib_load_FinanceControl
boolean ib_load_mvv
boolean ib_load_vc
boolean ib_load_alertview

decimal {1} gd_finder_speed   //Distance finder default speed
decimal id_calcdefaultspeed	//Default itinerary speed
Boolean ib_usedefaultspeed 	//True, use the User Specified Speed

// Inserted by FR 150702 - used to find out whether there should be rowsindicator
Boolean ib_rowsindicator
// For calculation manager FR 210702
Boolean 	ib_template
Boolean 	ib_estimated
Boolean 	ib_working
Boolean 	ib_fixtured
Boolean 	ib_calculated
Boolean 	ib_offer
Boolean 	ib_loadload
string 	gs_creator
integer 	gi_days
string 	gs_order_by
Boolean 	gb_order_type // true for ASC, false for DSC
Boolean 	gb_collapsed
Boolean 	ib_full_speed //indicates if calculation should use full or slow speed as default
boolean  ib_cpact_save_prompt = true
boolean  ib_pocautoschedule
boolean	ib_pocnotification		//CR2535 & 2536 Added by ZSW001 on 02/11/2011
integer  ii_defaultagentnr
boolean	ib_sendfixedemail	//Automatically send notification email to operations when calculation is fixed

//Vessel Selection
integer	ii_vesselstatus				// 1= All, 2=Active and 3=IN-Active
integer	ii_mvv_vesselstatus			// 1= All, 2=Active and 3=IN-Active
integer	ii_vc_vesselstatus			// 1= All, 2=Active and 3=IN-Active
string	is_showText    				//text shown on vesselselection object
string	is_mvv_showText    			//text shown on vesselselection object
string	is_vc_showText    			//text shown on vesselselection object
integer 	ii_vesselnumber[]
integer	ii_mvv_vesselnumber[]
integer	ii_vc_vesselnumber[]
integer	ii_vesselfilterstatus		// 1=All Vessels;2=My Vessels;0=Filter Active
integer	ii_mvv_vesselfilterstatus	// 1=All Vessels;2=My Vessels;0=Filter Active
integer	ii_vc_vesselfilterstatus	// 1=All Vessels;2=My Vessels;0=Filter Active
integer  ii_default_cons_zone       // 1=Normal;2=ECA-NWE;3=ECA-US
integer  ii_eca_zone
integer  ii_non_eca_zone

//Co2 Emission
decimal 	id_co2_constant_hfo, id_co2_constant_lshfo, id_co2_constant_go, id_co2_constant_do

// Variables copied from uo_global_system_vars
string 	is_program_name
integer 	ii_access_level				// User Access Level 
integer 	ii_user_profile				// User Profile
integer 	ii_redraw = 0
string 	is_dbms									// DB related variables
string 	is_database						
string 	is_servername
string	is_userid								// Display name
string 	is_logid									// Connection name
string	is_password  
string 	is_dbparm								// SSO related DB variable - db parameter used across the application, depends on SSO enabled or not
string	is_sec_server_principal 			// SSO related DB variable - received by the command line, its the flag that manages whether SSO is used or not.
Boolean 	ib_autoretrieve=True
private integer	ii_app_started_from		// 1 = local c-drive (users at the office)
													// 2 = tramos citrix setup 
													// 3 = citrix backup
// CR3136
string is_clienttype = "unknown"


//CR2535 & 2536 Added by ZSW001 on 16/11/2011
integer	ii_steamingtime_unit, ii_poc_portstay_unit

//MSPS message 
integer ii_msps_days						//Msps expired days

//MSPS setup
boolean ib_msps_visible  				//True, MSPS is visible
boolean ib_msps_shownoon				//True, show Noon reports
boolean ib_msps_noonbuttons			
boolean ib_msps_showheating			//True, show Heating reports
boolean ib_msps_heatingbuttons		
boolean ib_msps_showarrival			//True, show Arrival reports
boolean ib_msps_arrivalbuttons		
boolean ib_msps_showcanal				//True, show Canal reports
boolean ib_msps_canalbuttons			
boolean ib_msps_showfwodrift			//True, show FWO/Drift reports
boolean ib_msps_fwodriftbuttons		
boolean ib_msps_showload				//True, show Load reports
boolean ib_msps_loadbuttons			
boolean ib_msps_loadcargo				//True, approve load cargo
boolean ib_msps_showdischarge		 	//True, show Discharge reports
boolean ib_msps_dischargebuttons		
boolean ib_msps_dischargecargo		//True, apprvoe discharge cargo

boolean ib_rul_generatealerts			//True, generate alerts
boolean ib_rul_generatenotdefined	//True, not generating white alerts
integer ii_rul_delayminute
integer ii_rul_alertviewdays

mt_n_datastore gds_chmmapping

end variables

forward prototypes
public function integer getvessel_nr ()
public subroutine setvessel_nr (integer vessel_nr)
public subroutine setproc_text (string proc_text)
public subroutine setport_code (string port_code)
public subroutine setpcn (integer pcn)
public function string getproc_text ()
public function string getport_code ()
public function integer getpcn ()
public subroutine setparm (integer parm)
public function integer getparm ()
public function string getvoyage_nr ()
public subroutine setvoyage_nr (string voyage_nr)
public subroutine setagent_nr (integer agent_nr)
public function integer getagent_nr ()
public subroutine setchart_nr (integer chart_nr)
public function integer getchart_nr ()
public subroutine setlayout (string layout)
public function string getlayout ()
public subroutine setgrade (string grade)
public subroutine setbol_nr (integer bol_nr)
public function integer getbol_nr ()
public subroutine setgroup (string group)
public function string getgroup ()
public function string getuserid ()
public function string getpassword ()
public subroutine setuserid (string userid)
public subroutine setpassword (string password)
public function integer get_profitcenter_no ()
public subroutine set_profitcenter_no (integer pi_profitcenter_no)
public function string getprogramversion ()
public function string getprogramdate ()
public subroutine uf_load ()
public function string getgrade ()
public subroutine setwindowsuserid ()
public function string getwindowsuserid ()
public subroutine defaulttransactionobject (ref transaction pt_transaction)
public function integer of_getappstartedfrom ()
public function integer of_setappstartedfrom ()
public subroutine uf_new_trans_db_connect (ref transaction pt_transaction, string pt_database, string pt_server)
public subroutine uf_set_menu (string as_controll_name, boolean as_on_off)
public function string get_appexename ()
public function string getprogramfullversion ()
public subroutine documentation ()
public function boolean getnewversion (ref datetime adt_begintime, ref datetime adt_endtime, ref decimal adec_downtime, ref long al_releaseid, ref string as_releasever)
public function boolean istestuser (long al_releaseid)
public function string of_getapplicationpath ()
end prototypes

public function integer getvessel_nr ();return (goi_vessel_nr)
end function

public subroutine setvessel_nr (integer vessel_nr);goi_vessel_nr = vessel_nr
end subroutine

public subroutine setproc_text (string proc_text);gos_proc_text = proc_text
end subroutine

public subroutine setport_code (string port_code);gos_port_code = port_code
end subroutine

public subroutine setpcn (integer pcn);goi_pcn = pcn
end subroutine

public function string getproc_text ();return (gos_proc_text)
end function

public function string getport_code ();return (gos_port_code)
end function

public function integer getpcn ();return goi_pcn
end function

public subroutine setparm (integer parm);goi_parm = parm
end subroutine

public function integer getparm ();return (goi_parm)
end function

public function string getvoyage_nr ();return (goi_voyage_nr)
end function

public subroutine setvoyage_nr (string voyage_nr);goi_voyage_nr = voyage_nr
end subroutine

public subroutine setagent_nr (integer agent_nr);goi_agent = agent_nr
end subroutine

public function integer getagent_nr ();return goi_agent
end function

public subroutine setchart_nr (integer chart_nr);goi_chart = chart_nr
end subroutine

public function integer getchart_nr ();return goi_chart
end function

public subroutine setlayout (string layout);gos_layout = layout
end subroutine

public function string getlayout ();return gos_layout
end function

public subroutine setgrade (string grade);gos_grade = grade
end subroutine

public subroutine setbol_nr (integer bol_nr);goi_bol_nr = bol_nr
end subroutine

public function integer getbol_nr ();return goi_bol_nr
end function

public subroutine setgroup (string group);gos_group = group
end subroutine

public function string getgroup ();return gos_group
end function

public function string getuserid ();RETURN gos_userid
end function

public function string getpassword ();RETURN gos_password
end function

public subroutine setuserid (string userid);gos_userid = userid
end subroutine

public subroutine setpassword (string password);gos_password = password
end subroutine

public function integer get_profitcenter_no ();Return(profit_center_no)
end function

public subroutine set_profitcenter_no (integer pi_profitcenter_no);profit_center_no = pi_profitcenter_no
end subroutine

public function string getprogramversion ();Return(programversion)
end function

public function string getprogramdate ();Return(programdate)
end function

public subroutine uf_load ();string 	ls_temp
integer 	li_pcnr
long		ll_row, ll_rows
string 	ls_vessels, ls_mvv_vessels, ls_vc_vessels
mt_n_datastore lds_systemoptions, lds_useroptions, lds_uservessel

lds_systemoptions = create mt_n_datastore
lds_systemoptions.dataObject = "d_sq_ff_system_options"
lds_systemoptions.setTransObject( sqlca )
lds_systemoptions.retrieve()

lds_useroptions = create mt_n_datastore
lds_useroptions.dataobject = "d_sq_ff_user_options_all"
lds_useroptions.setTransObject( sqlca )
if uo_global.is_userid = "sa" then
	/* if the user i 'sa' there will not be any settings to retrieve for the user */
	lds_useroptions.insertRow(0)
else
	lds_useroptions.retrieve( uo_global.is_userid )
end if

choose case uo_global.of_getappstartedfrom( )
	case 1	// Started from Local Drive
		gs_bp_path 				= lds_systemoptions.getItemString(1, "bp_distance_path")
		gs_AtoBviaC_path 		= lds_systemoptions.getItemString(1, "abc_distance_path")
		gs_wizard_path 			= lds_systemoptions.getItemString(1, "calc_wizard_path")
		gs_help_path 				= lds_systemoptions.getItemString(1, "help_path")
		gs_template_path 		= lds_systemoptions.getItemString(1, "word_template_path")
	case 2	// Started from Citrix Server
		gs_bp_path 				= lds_systemoptions.getItemString(1, "ctx_bp_distance_path")
		gs_AtoBviaC_path 		= lds_systemoptions.getItemString(1, "ctx_abc_distance_path")
		gs_wizard_path 			= lds_systemoptions.getItemString(1, "ctx_calc_wizard_path")
		gs_help_path 				= lds_systemoptions.getItemString(1, "ctx_help_path")
		gs_template_path 		= lds_systemoptions.getItemString(1, "ctx_word_template_path")
	case 3	// Started from P-drive Citrix Backup, no longer used
		gs_bp_path 				= lds_systemoptions.getItemString(1, "ctxb_bp_distance_path")
		gs_AtoBviaC_path 		= lds_systemoptions.getItemString(1, "ctxb_abc_distance_path")
		gs_wizard_path 			= lds_systemoptions.getItemString(1, "ctxb_calc_wizard_path")
		gs_help_path 				= lds_systemoptions.getItemString(1, "ctxb_help_path")
		gs_template_path 		= lds_systemoptions.getItemString(1, "ctxb_word_template_path")
end choose

ib_rowsindicator 			= FALSE

ib_developer				= lds_useroptions.getItemNumber(1, "delevoper") = 1
gs_paper_size 				= lds_useroptions.getItemString(1, "print_paper_size")
is_pdfdriver 				= lds_useroptions.getItemString(1, "pdf_driver")
gs_calc_wizard 			= lds_useroptions.getItemString(1, "calc_default_wizard")
gs_startup_menu 			= "Tramos"  // !!!!! This has to be replaced by a link to the user profile !!!!!
ib_load_calc_manager 	= lds_useroptions.getItemNumber(1, "load_calc_manager_on_startup") = 1
ib_load_positionlist	 	= lds_useroptions.getItemNumber(1, "load_positionlist_on_startup") = 1
ib_load_fixturelist		= lds_useroptions.getItemNumber(1, "load_fixturelist_on_startup") = 1
ib_load_proceeding	 	= lds_useroptions.getItemNumber(1, "load_proceeding_on_startup") = 1
ib_load_portofcall		= lds_useroptions.getItemNumber(1, "load_portofcall_on_startup") = 1
ib_load_cargo			 	= lds_useroptions.getItemNumber(1, "load_cargo_on_startup") = 1
ib_load_financecontrol 	= lds_useroptions.getItemNumber(1, "load_fincontrol_on_startup") = 1
ib_load_mvv             = lds_useroptions.getitemnumber(1, "load_mvv_on_startup") = 1
ib_load_vc					= lds_useroptions.getitemnumber(1, "load_vc_on_startup") = 1
ib_load_alertview			=lds_useroptions.getitemnumber(1, "load_alertview_on_startup") = 1

ib_template 				= lds_useroptions.getItemNumber(1, "calc_load_template") = 1 
ib_estimated 				= lds_useroptions.getItemNumber(1, "calc_load_estimated") = 1 
ib_working 					= lds_useroptions.getItemNumber(1, "calc_load_working") = 1 
ib_fixtured 				= lds_useroptions.getItemNumber(1, "calc_load_fixed") = 1 
ib_calculated 				= lds_useroptions.getItemNumber(1, "calc_load_calculated") = 1 
ib_offer 					= lds_useroptions.getItemNumber(1, "calc_load_offer") = 1 
ib_loadload 				= lds_useroptions.getItemNumber(1, "calc_load_loadload") = 1 
ib_cpact_save_prompt		= lds_useroptions.getItemNumber(1, "calc_cpact_confirm_close") = 1
gs_creator 					= lds_useroptions.getItemString(1, "calc_creator") 
gi_days 						= lds_useroptions.getItemNumber(1, "calculation_load_days") 
gs_order_by 				= lds_useroptions.getItemString(1, "calc_sort_by")  
gb_order_type 				= lds_useroptions.getItemNumber(1, "calc_sort_order") = 1 
gb_collapsed 				= lds_useroptions.getItemNumber(1, "calc_load_manager_collapsed") = 1 
ib_full_speed 				= lds_useroptions.getItemNumber(1, "calc_full_speed") = 1 
ib_usedefaultspeed		= lds_useroptions.getItemNumber(1, "calc_full_speed") = 2
id_calcdefaultspeed		= lds_useroptions.getitemnumber(1, "calc_default_speed")
gd_finder_speed 			= lds_useroptions.getItemNumber(1, "distance_finder_speed") 
ib_pocautoschedule      = lds_useroptions.getItemNumber(1, "poc_enable_auto_schedule") = 1
ib_pocnotification      = lds_useroptions.getItemNumber(1, "poc_enabled_notification") = 1			//CR2535 & 2536 Added by ZSW001 on 02/11/2011
ii_defaultagentnr       = lds_useroptions.getitemNumber(1, "agent_nr")
ii_rul_delayminute 		=  lds_useroptions.getitemnumber(1, "rul_delay_minute") 
ii_rul_alertviewdays 	=  lds_useroptions.getitemnumber(1, "rul_alertview_days")

//CR2535 & 2536 Begin added by ZSW001 on 16/11/2011
ii_steamingtime_unit    = lds_useroptions.getitemNumber(1, "steamingtime_unit")
ii_poc_portstay_unit    = lds_useroptions.getitemNumber(1, "poc_portstay_unit")

//CR20 show msps message days
ii_msps_days 				= lds_useroptions.getitemnumber(1,"msps_days")

ii_default_cons_zone = lds_useroptions.getitemnumber(1,"DEFAULT_CONS_ZONE")
ii_eca_zone          = lds_useroptions.getitemnumber(1, "eca_zone")
ii_non_eca_zone      = lds_useroptions.getitemnumber(1, "non_eca_zone")

//MSPS setup
ib_msps_visible  				= lds_systemoptions.getitemnumber(1, "msps_visible") = 1
ib_msps_shownoon		      = lds_systemoptions.getitemnumber(1, "msps_shownoon") = 1
ib_msps_noonbuttons		   = lds_systemoptions.getitemnumber(1, "msps_noonbuttons") = 1
ib_msps_showheating		 	= lds_systemoptions.getitemnumber(1, "msps_showheating") = 1
ib_msps_heatingbuttons		= lds_systemoptions.getitemnumber(1, "msps_heatingbuttons") = 1
ib_msps_showarrival		 	= lds_systemoptions.getitemnumber(1, "msps_showarrival") = 1
ib_msps_arrivalbuttons		= lds_systemoptions.getitemnumber(1, "msps_arrivalbuttons") = 1
ib_msps_showcanal				= lds_systemoptions.getitemnumber(1, "msps_showcanal") = 1
ib_msps_canalbuttons		 	= lds_systemoptions.getitemnumber(1, "msps_canalbuttons") = 1
ib_msps_showfwodrift		 	= lds_systemoptions.getitemnumber(1, "msps_showfwodrift") = 1
ib_msps_fwodriftbuttons		= lds_systemoptions.getitemnumber(1, "msps_fwodriftbuttons") = 1
ib_msps_showload			 	= lds_systemoptions.getitemnumber(1, "msps_showload") = 1
ib_msps_loadbuttons			= lds_systemoptions.getitemnumber(1, "msps_loadbuttons") = 1
ib_msps_loadcargo				= lds_systemoptions.getitemnumber(1, "msps_loadcargo") = 1
ib_msps_showdischarge	 	= lds_systemoptions.getitemnumber(1, "msps_showdischarge") = 1
ib_msps_dischargebuttons	= lds_systemoptions.getitemnumber(1, "msps_dischargebuttons") = 1
ib_msps_dischargecargo		= lds_systemoptions.getitemnumber(1, "msps_dischargecargo") = 1
ib_rul_generatealerts      = lds_systemoptions.getitemnumber(1, "rul_generatealerts") = 1
ib_rul_generatenotdefined	= lds_systemoptions.getitemnumber(1, "rul_generatenotdefined") = 1

//CR2406 Begin added by JMY014 on 10-05-2011 Changed desc: Loading vessel selection from user vessel table
lds_uservessel = create mt_n_datastore
lds_uservessel.dataobject = "d_sq_gr_user_vessels"
lds_uservessel.settransobject( sqlca )

if (lds_uservessel.retrieve( uo_global.is_userid ) = 1) then
	//After reducing the profit centers range, unavailable vessels should be filtered out
	ii_vesselstatus = lds_uservessel.getitemnumber(1, "vessel_selection_status") 
	ii_vesselfilterstatus = lds_uservessel.getitemnumber(1, "vessel_filter_status") 
	ls_vessels = lds_uservessel.getitemstring(1, "vessel_list")	
	ii_mvv_vesselstatus = lds_uservessel.getitemnumber(1, "mvv_vessel_selection_status") 
	ii_mvv_vesselfilterstatus = lds_uservessel.getitemnumber(1, "mvv_vessel_filter_status") 
	ls_mvv_vessels = lds_uservessel.getitemstring(1, "mvv_vessel_list")
	ii_vc_vesselstatus = lds_uservessel.getitemnumber(1, "vc_vessel_selection_status") 
	ii_vc_vesselfilterstatus = lds_uservessel.getitemnumber(1, "vc_vessel_filter_status") 
	ls_vc_vessels = lds_uservessel.getitemstring(1, "vc_vessel_list")
	
	if len(ls_vessels) > 0 or len(ls_mvv_vessels) > 0 or len(ls_vc_vessels) > 0  then
		//Retrive vessels that the current login user has access to
		lds_uservessel.dataobject = "d_sq_tb_dddw_vessel_selection"
		lds_uservessel.settransobject(sqlca)
		lds_uservessel.retrieve(uo_global.is_userid)
		
		//Filter out the selected vessels from above retrive results
		if len(ls_vessels) > 0 then
			lds_uservessel.setfilter(" vessel_nr in (" + ls_vessels + ") ")
			lds_uservessel.filter()
			ll_rows = lds_uservessel.rowcount()
			for ll_row = 1 to ll_rows
				ii_vesselnumber[ll_row] = lds_uservessel.getitemnumber(ll_row, "vessel_nr")
			next
		end if
		
		//Filter out the MVV selected vessels from above retrive results
		if len(ls_mvv_vessels) > 0 then
			lds_uservessel.setfilter(" vessel_nr in (" + ls_mvv_vessels + ") ")
			lds_uservessel.filter()
			ll_rows = lds_uservessel.rowcount()
			for ll_row = 1 to ll_rows
				ii_mvv_vesselnumber[ll_row] = lds_uservessel.getitemnumber(ll_row, "vessel_nr")
			next
		end if

		//Filter out the VC selected vessels from above retrive results
		if len(ls_vc_vessels) > 0 then
			lds_uservessel.setfilter(" vessel_nr in (" + ls_vc_vessels + ") ")
			lds_uservessel.filter()
			ll_rows = lds_uservessel.rowcount()
			for ll_row = 1 to ll_rows
				ii_vc_vesselnumber[ll_row] = lds_uservessel.getitemnumber(ll_row, "vessel_nr")
			next
		end if
end if
end if
//CR2406 End added by JMY014 on 10-05-2011

//load co2 emission constants
id_co2_constant_hfo	= lds_systemoptions.getItemNumber(1, "co2_constant_hfo")
id_co2_constant_lshfo = lds_systemoptions.getItemNumber(1, "co2_constant_lshfo")
id_co2_constant_do = lds_systemoptions.getItemNumber(1, "co2_constant_do")
id_co2_constant_go = lds_systemoptions.getItemNumber(1, "co2_constant_go")

//CR3708 added by CCY018 26/08/14
gds_chmmapping = create mt_n_datastore
gds_chmmapping.dataobject = "d_sq_gr_chmmapping_index"
gds_chmmapping.settransobject( sqlca)
gds_chmmapping.retrieve()
//CR3708 end,added by CCY018 26/08/14

//Automatically send notification email to operations when calculation is fixed
ib_sendfixedemail = lds_systemoptions.getitemnumber(1, "send_calc_fixed_email") = 1

destroy lds_systemoptions
destroy lds_useroptions
destroy lds_uservessel
end subroutine

public function string getgrade ();return gos_grade
end function

public subroutine setwindowsuserid ();string 	ls_name
int 		li_size = 255
boolean	lb_rc

ls_name = space(li_size)

lb_rc = GetUserNameA( ls_name, li_size)

if not lb_rc THEN
	gos_windows_userid =  "N/A"
else
	gos_windows_userid = trim(ls_name)
end if
end subroutine

public function string getwindowsuserid ();return gos_windows_userid
end function

public subroutine defaulttransactionobject (ref transaction pt_transaction);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : uo_global_system_vars
  
 Event	 : 

 Function : defaulttransactionobject

 Scope     : Global

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Loads default transaction values into transaction object. If transactionobject is null, it will
	be created

 Arguments : Transactionobject

 Returns   :Transactionobject

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version

		Date      		CR-Ref			Author			Comments
	24/10/16				CR3754 			AGL027			SSO
************************************************************************************/


if not isvalid(pt_transaction) then 
	pt_transaction = create transaction;
end if

pt_transaction.dbms			= uo_global.is_dbms
pt_transaction.database   	= uo_global.is_database
pt_transaction.servername	= uo_global.is_servername
pt_transaction.userid		= uo_global.is_userid
pt_transaction.dbpass		= uo_global.is_password
pt_transaction.logid 		= uo_global.is_logid
pt_transaction.logPass		= uo_global.is_password
pt_transaction.dbparm 		= uo_global.is_dbparm


end subroutine

public function integer of_getappstartedfrom ();/* Returns where the application was started from 
	1 - Locally from C-drive
	2 - From Citrix Server
*/

return ii_app_started_from
end function

public function integer of_setappstartedfrom ();/* sets from which location TRAMOS is started from based on the command line parm */
string ls_startfrom

ls_startfrom = trim(lower(uo_global.is_clienttype))

if ls_startfrom <> "citrix" then 
	ii_app_started_from = 1 // Started from Local Drive (internal)
else
	ii_app_started_from = 2 // Started from Citrix Server	
end if

return 1
end function

public subroutine uf_new_trans_db_connect (ref transaction pt_transaction, string pt_database, string pt_server);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : uo_global_system_vars
  
 Event	 : 

 Function :  uf_new_trans_db_connect

 Scope     : Global

 ************************************************************************************

 Author    : Leith Noval
   
 Date       : 19/6-97

 Description : Makes default transaction values into transaction object. If transactionobject is null, it will
	be created. Connect to wished database, on wished database.

 Arguments : Transactionobject

 Returns   :Transactionobject

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
19/6-97	         5.0			LN		Initial version
  
************************************************************************************/


If Not IsValid(pt_transaction) Then 
	pt_transaction = CREATE transaction;
End if

pt_transaction.dbms		= uo_global.is_dbms
pt_transaction.Database   	= pt_database
pt_transaction.Servername	= pt_server
pt_transaction.UserID		= uo_global.is_userid
pt_transaction.DBPass		= uo_global.is_password
pt_transaction.Logid 		= uo_global.is_userid
pt_transaction.LogPass		= uo_global.is_password
end subroutine

public subroutine uf_set_menu (string as_controll_name, boolean as_on_off);/****************************************************************************
Author		: Teit Aunt
Date			: 9-1-98
Description	: Disables the menu button that the function is called with.
Arguments	: as_controll_name as string and as_on_off as boolean where True 
				  is on and False is off. 
Returns		: None
*****************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-----------------------------------------------------------------------------
08-01-98		1.0			TA			Initial version
13-04-10      21.12		RMO		CR#1980
****************************************************************************/

/* Only valid for Exit menu Item */
if as_controll_name <> "m_exit" then return

CHOOSE CASE w_tramos_main.menuName
	CASE "m_sysmain"
			m_sysmain.m_file.m_exit.Enabled = as_on_off
	CASE "m_tramosmain"
			m_tramosmain.m_file.m_exit.Enabled = as_on_off
	CASE "m_calcmain"
			m_calcmain.m_file.m_exit.Enabled = as_on_off
	CASE "m_salemain"
			m_salemain.m_file.m_exit.Enabled = as_on_off
	CASE "m_tcmain"
			m_tcmain.m_file.m_exit.Enabled = as_on_off
END CHOOSE

end subroutine

public function string get_appexename ();// CR 2532 Begin - Added by CONASW 01 Aug 2011: Get name of executable file

If Len(gos_ExeName) = 0 Then    // If running function for first time
	Long ll_Temp
	ll_Temp = Handle(GetApplication())
	gos_ExeName = Space(200)
	GetModuleFilename(ll_Temp, gos_ExeName, 200)
	gos_ExeName = Trim(gos_ExeName)
	ll_Temp = LastPos(gos_ExeName, "\")
	If ll_Temp > 0 Then gos_ExeName = Right(gos_ExeName, Len(gos_ExeName)-ll_Temp)
End If

Return gos_ExeName
end function

public function string getprogramfullversion ();
Return('Version ' + Left(programversion,6) + ' Build ' + Right(programversion,1))
end function

public subroutine documentation ();/********************************************************************
   uo_global_vars
   <OBJECT>			</OBJECT>
   <USAGE>					</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
		Date      		CR-Ref			Author			Comments
		18-10-2013		CR3340			LHC010			Differentiate vessels filter selection in VC
		19-12-2013		CR3240			XSZ004			Rules engine
		16-07-2014		CR3562			KSH092			Add Variables Default Consumption Zone
		26-08-2014		CR3708			CCY018			Add variable:gds_chmmapping,retrieve CHMMapping	
		15-01-2015		CR3624			LHG008			Avoid dependency on P: drive mapping
		15-06-2015		CR4015			AGL027			Modified logic inside of_setappstartedfrom()
		08/10/15  		CR4161			XSZ004			Remove informaker reports.
		11/09/15  		CR4112			LHG008			Send email to the general operations when chartering fixes a calculation
		25/11/15  		CR3248			XSZ004			Add ECA zone.
		22/03/16  		CR4157			LHG008			Default Speed extended(Remove the "ask for speed when calculating" feature)
		05/09/2016 		CR3754			AGL027			Single Sign On modifications
   </HISTORY>
********************************************************************/

end subroutine

public function boolean getnewversion (ref datetime adt_begintime, ref datetime adt_endtime, ref decimal adec_downtime, ref long al_releaseid, ref string as_releasever);/********************************************************************
   getnewversion
   <DESC>	Description	</DESC>
   <RETURN>	boolean:
            <LI> true, success
            <LI> false, failure	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adt_begintime  : output
		adt_endtime    : output
		adec_downtime  : output
		al_releaseid   : output
   </ARGS>
   <USAGE>	Called when user login the system	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		08/10/14 CR3831        Shawn    First Version
   </HISTORY>
********************************************************************/

SELECT TOP 1 RELEASE_ID, RELEASE_VER, RELEASE_STDATE, RELEASE_ENDATE, DOWNTIME
INTO :al_releaseid, :as_releasever, :adt_begintime, :adt_endtime, :adec_downtime
FROM TRAMOS_RELEASES
WHERE RELEASE_VER >= :programversion
    AND ISACTIVE = 1 AND START_RELEASE = 1 AND FINISH_RELEASE = 0
ORDER BY RELEASE_STDATE ASC;

return (SQLCA.SQLCode = 0)

end function

public function boolean istestuser (long al_releaseid);/********************************************************************
   istestuser
   <DESC>	Description	</DESC>
   <RETURN>	boolean:
            <LI> c#return.Success: true, ok
            <LI> c#return.Failure: false, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_releaseid
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		08/10/14 CR3831        SSX014   First Version
   </HISTORY>
********************************************************************/

string ls_userid

SELECT USER_ID INTO :ls_userid
FROM TEST_USERS
WHERE RELEASE_ID=:al_releaseid
AND USER_ID=:is_userid;

return (SQLCA.SQLCode = 0)
end function

public function string of_getapplicationpath ();return is_app_path
end function

on uo_global_vars.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_global_vars.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;destroy gds_chmmapping
end event

event constructor;is_app_path = getcurrentdirectory()
end event

