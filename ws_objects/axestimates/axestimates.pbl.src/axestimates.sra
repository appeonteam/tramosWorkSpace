$PBExportHeader$axestimates.sra
$PBExportComments$Generated Application Object
forward
global type axestimates from application
end type
global n_tr sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
uo_global_vars uo_global
n_cst_appmanager gnv_app
Boolean gb_tram_calc_is_interfaced = True
n_AtoBviaC gnv_AtoBviaC
long gl_batch = 7000000
integer gi_win_pos = 0
integer gi_redraw
string s_w_list_return
Integer gb_bpsdists_usage = -1
Boolean gb_external_apm = false
Boolean gb_tc_payment = false
u_bpdistance_base guo_bpdistance
Boolean gb_developer
string gs_load_or_disch

mt_n_datastore ids_ports, ids_country, ids_area
datawindowchild	idwc_open

end variables

global type axestimates from application
string appname = "axestimates"
end type
global axestimates axestimates

type prototypes
Function Int GetKeyState(Int aKey) Library "user.exe"
Function Long GetKeyState32(Long aKey) Library "user32.dll" Alias for "GetKeyState"
Function Long SetWindowPos(Long whandle, Long topmost, long x, long y, long cx, long cy, long wFlag) Library "user32.dll" Alias for "SetWindowPos"
public FUNCTION unsignedlong FindWindow_NT( long ClassName, string WindowName ) LIBRARY "user32.dll"  ALIAS FOR "FindWindowW"
public Function int SetForegroundWindow_NT( unsignedlong hwnd ) LIBRARY "user32.dll" ALIAS FOR "SetForegroundWindow"
Private Function Long ShellExecute(Long hwnd, String lpOperation, String lpFile, String lpParameters, String lpDirectory, Long nShowCmd) library "shell32.dll" Alias for "ShellExecuteA;ansi"
FUNCTION ulong GetModuleFileName (ulong hinstModule, ref string lpszPath, ulong cchPath )  LIBRARY "KERNEL32.DLL"  ALIAS FOR "GetModuleFileNameA;ansi" 
end prototypes

type variables
long	il_months = 3

end variables

forward prototypes
public function integer of_setperioddates (ref s_axestimatesvars astr_app, string as_selected)
public function integer of_setperiods (ref s_axestimatesvars astr_app, string as_selected)
public subroutine documentation ()
end prototypes

public function integer of_setperioddates (ref s_axestimatesvars astr_app, string as_selected);/********************************************************************
   of_setperioddates
   <DESC>	Calculate the time scope according to the parameter.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_app
		as_selected
   </ARGS>
   <USAGE>	Suggest to use in the open event of application	
	* Currently not used *
	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
		16/04/2012   CR2914       agl027       First Version
   	19/09/2012   CR2413       ZSW001       Expand the time scope from one month to serval months
		27/09/2012	 CR2408		  agl027			not used		
   </HISTORY>
********************************************************************/

date	ld_cal_month, ld_firstday

mt_n_datefunctions	lnv_date_utility

CONSTANT LONG li_MIDMONTH = 15

if astr_app.s_periodref = "" then
	/* process should run a full period based on default setting or what was passed into cmd-line parameter */
	choose case as_selected
		case "this"
			ld_cal_month = today()
		case "last"
			ld_cal_month = lnv_date_utility.of_relativemonth(today(), -1)
		case "next"
			ld_cal_month = lnv_date_utility.of_relativemonth(today(), 1)
		case else
			return c#return.Failure
	end choose
else
	/* user provided us with a period to run instead! */
	if isnumber(astr_app.s_periodref) and len(astr_app.s_periodref) = 6 then
		ld_cal_month = date(long(mid(astr_app.s_periodref, 1, 4)), long(mid(astr_app.s_periodref, 5, 2)), 1)
	else
		return c#return.Failure
	end if
end if

ld_firstday = date(year(ld_cal_month), month(ld_cal_month), 1)
if day(ld_cal_month) < li_MIDMONTH then
	astr_app.dtm_serverperiodfrom = datetime(lnv_date_utility.of_relativemonth(ld_firstday, -il_months))
	astr_app.dtm_serverperiodto   = datetime(lnv_date_utility.of_relativemonth(ld_firstday, 1))
else
	astr_app.dtm_serverperiodfrom = datetime(lnv_date_utility.of_relativemonth(ld_firstday, -il_months + 1))
	astr_app.dtm_serverperiodto   = datetime(lnv_date_utility.of_relativemonth(ld_firstday, 2))
end if

astr_app.s_periodref = string(date(astr_app.dtm_serverperiodfrom), "yyyymm")

return c#return.Success

end function

public function integer of_setperiods (ref s_axestimatesvars astr_app, string as_selected);/********************************************************************
   of_setperiods
   <DESC>	Calculate the time scope according to the parameters received.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_app
		as_selected
   </ARGS>
   <USAGE>	Suggest to use in the open event of application	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
		27/09/2012   CR2914       agl027       First Version
   </HISTORY>
********************************************************************/

integer li_tempmonth, li_tempyear
date ld_cal_month

mt_n_datefunctions	lnv_date_utility

if astr_app.s_periodref="" then
	
	/* process should run a full period based on default setting or what was passed into cmd-line parameter */

	CHOOSE CASE as_selected
		CASE "this"
			ld_cal_month = lnv_date_utility.of_relativemonth(today(), - ( astr_app.i_previousmonths -1 ))
			astr_app.dtm_serverperiodfrom = datetime("01/" + string(ld_cal_month,"mm/yyyy") )
			ld_cal_month = lnv_date_utility.of_relativemonth(today(), 1)
			astr_app.dtm_serverperiodto = datetime("01/" + string(ld_cal_month, "mm/yyyy") )
			astr_app.s_periodref = string(today(),"yyyymm")
			
		CASE "last"
			ld_cal_month = lnv_date_utility.of_relativemonth(today(), - (astr_app.i_previousmonths) )
			astr_app.dtm_serverperiodfrom = datetime("01/" + string(ld_cal_month,"mm/yyyy") )
			ld_cal_month = lnv_date_utility.of_relativemonth(today(), 1)
			astr_app.dtm_serverperiodto = datetime("01/" + string(ld_cal_month, "mm/yyyy") )
			astr_app.s_periodref = string(lnv_date_utility.of_relativemonth(today(), - 1),"yyyymm")
			
		CASE "next"
			ld_cal_month = lnv_date_utility.of_relativemonth(today(), - (astr_app.i_previousmonths - 1) )
			astr_app.dtm_serverperiodfrom = datetime("01/" + string(ld_cal_month,"mm/yyyy") )
			ld_cal_month = lnv_date_utility.of_relativemonth(today(), 2)
			astr_app.dtm_serverperiodto = datetime("01/" + string(ld_cal_month, "mm/yyyy") )
			astr_app.s_periodref = string(lnv_date_utility.of_relativemonth(today(), 1),"yyyymm")
			
		CASE ELSE
			return c#return.Failure
	END CHOOSE		
else
	/* user provided us with a period to run instead! */	
	if isnumber(astr_app.s_periodref) and len(astr_app.s_periodref)=6 then
		li_tempmonth = integer(mid(astr_app.s_periodref,5,2))
		li_tempyear = integer(mid(astr_app.s_periodref,1,4))
		astr_app.dtm_serverperiodfrom = datetime("01/" + string(li_tempmonth) + "/" + string(li_tempyear))
		if li_tempmonth = 12 then
			li_tempmonth = 1
			li_tempyear = year(today()) + 1
		else
			li_tempmonth ++
		end if		
		astr_app.dtm_serverperiodto = datetime("01/" + string(li_tempmonth) + "/" + string(li_tempyear))	
	else
		return c#return.Failure
	end if
	
end if	
	

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: axestimates
	
   <OBJECT> AxEstimates Server Application </OBJECT>
   <DESC>   Used to generate Voyage Estimates from Tramos to AX </DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
	
    Date   		Ref    	Author		Comments
	??/??/??		??			AGL027		First Version
  	??/??/??		CR2908	ZSW001		Amendments
  	27/09/12 	CR2908   AGL027      Changed periodisation method 		
	08/02/16		CR4298	AGL027		Allow application to use its own path for atobviac tables.
	03/11/17		CR4629	AGL027		Moved into trustbroker authentication.
********************************************************************/
end subroutine

on axestimates.create
appname="axestimates"
message=create message
sqlca=create n_tr
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on axestimates.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;/*
AX Finance Server Application for Estimations
Type: Non Persistant  (executed and instantly closed)
*/


string ls_unit, ls_loglevel,ls_periodselected="this", ls_logname="axestimates.log", ls_year, ls_period, ls_voyageyear 
string ls_runas, ls_servername, ls_databasename, ls_showwindow, ls_method="exestimates.open()",  ls_commandline
string ls_app, ls_version, ls_loaddistancesyyyy="", ls_priormonths="3", ls_estimatetype="voyage"
integer li_pos=0, li_tempmonth, li_tempyear
long ll_rows
s_axestimatesvars		lstr_app
n_service_manager lnv_serviceManager
n_error_service lnv_errService
n_versioninfo 				lnv_versioninfo
mt_n_stringfunctions		lnv_stringfunc
n_axestimationcontrol	lnv_est


constant integer ii_STANDARDMODE = 1
constant integer ii_VOYYEARMODE = 2

/* to execute the auto load of distances */
// ls_commandline = "/server:scrbtradkcph101 /db:DEV_CPH /log:1 /logoutput:axestimates_[MM].log /emailto:AGL027 /showwindow:on /loaddistances:2011"
/* standard estimation extract */
// ls_commandline = "/server:scrbtandkbal311 /db:TEST_TRAMOS /log:3 /logoutput:testaxestimates_[MM].log /emailto:AGL027 /execute:last /priormonths:3 /abcpath:C:\testabc"
/* execute annual process */
// ls_commandline = "/server:scrbtradkcph101 /db:DEV_CPH /log:1 /logoutput:axestimates_[MM].log /annual:12 /period:201209"
/* TC-OUT estimates */
//ls_commandline = "/server:scrbtradkcph101 /db:VESSELCOMM /log:3 /logoutput:axestimates_[MM].log /emailto:AGL027 /execute:last /priormonths:1 /type:tcout"
/* New Implementation */
// ls_commandline = "/server:scrbtandkbal311 /db:PRE_TRAMOS /log:3 /emailto:AGL027 /priormonths:3 /execute:this /type:all /abcpath:C:\root\deployment-center\client\2017-10-30-uat-delivery-one\2017-10-26\Tramos\Dist /logoutput:sso_AXEST_[YYYY].log /runas:AGL027 /security:DCRBTANDKBAL311@SHORE.MAERSKTANKERS.COM"
/* " /logid:adminServerApp  /pwd:?????????" */

ls_commandline = commandline



/* get version detail */
lnv_versioninfo = create n_versioninfo
lnv_versioninfo.setispbapp(true)
setnull(ls_app)
ls_version = lnv_versioninfo.getversion(ls_app)
if isnull(ls_version) then ls_version = "n/a"
destroy lnv_versioninfo

/* non critical configuration options from command line */
lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/logoutput:", ls_logname, false)

lnv_serviceManager.of_loadservice( lnv_errService , "n_error_service")
lnv_errService.of_setoutput( 2, ls_logname )

lnv_errservice.of_addmsg( this.classdefinition, "interfacemanager.open()", "*************************", "")
lnv_errservice.of_addmsg( this.classdefinition, "interfacemanager.open()", "info, application started", "")
lnv_errservice.of_addmsg( this.classdefinition, "interfacemanager.open()", "info, version number=" + ls_version, "")


if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/server:", lstr_app.s_servername, true) = c#return.Failure then
	lstr_app.s_servername = "error"
	lnv_errservice.of_addmsg( this.classdefinition, ls_method, "error, missing server information", "")
else
	if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/db:", lstr_app.s_databasename, true) = c#return.Failure then
		lstr_app.s_databasename = "error"	
		lnv_errservice.of_addmsg( this.classdefinition, ls_method, "error, missing database information", "")
	else
		if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/security:", lstr_app.s_security, true) = c#return.Failure then
			lstr_app.s_databasename = "error"	
			lnv_errservice.of_addmsg(this.classdefinition, ls_method, "error, missing database security information", "")
		else
			if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/abcpath:", lstr_app.s_abctablepath, true) = c#return.Failure then
				lstr_app.s_abctablepath = "error"	
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "error, missing atobviac table path information", "")
			else
	
				if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/runas:", ls_runas, true) = c#return.Failure then
					lnv_errservice.of_addmsg( this.classdefinition, ls_method, "Error, missing runas information", "", 0, ls_runas)
					lnv_errservice.of_showmessages( )
					return
				else
					/* configure distances utility if needed */
					lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/loaddistances:", ls_loaddistancesyyyy, false)
					
					
					lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/logid:", lstr_app.s_logid, false)
					lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/pwd:", lstr_app.s_pwd, false)
					
					/* if distance utility not selected try to execute estimate functions */
					if ls_loaddistancesyyyy="" then		
			
						lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/log:", ls_loglevel, false)
				
						ls_loglevel = lower(ls_loglevel)
						CHOOSE CASE ls_loglevel
							CASE "0", "none"
								lstr_app.i_loglevel = 0
							CASE "1", "low", "l"
								lstr_app.i_loglevel = 1
							CASE "2", "med", "medium", "m"
								lstr_app.i_loglevel = 2				
							CASE ELSE
								ls_loglevel = "high"
								lstr_app.i_loglevel = 3				
						END CHOOSE		
				
						lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/type:", ls_estimatetype, false)
						CHOOSE CASE lower(ls_estimatetype)
							CASE "all", "voyage", "tcout", "tcin"
								lstr_app.s_estimatetype = lower(ls_estimatetype)
							CASE ELSE /* default value */
								lstr_app.s_estimatetype = "voyage"
						END CHOOSE
				
						/* any other parameters place here */
						lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/emailto:", lstr_app.s_emailto, false)
						/* clean up later */
						lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/priormonths:", ls_priormonths, false)
						if isnumber(ls_priormonths) then
							lstr_app.i_previousmonths = integer(ls_priormonths)
						else
							lstr_app.i_previousmonths = 3
						end if	
			
						if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/annual:", ls_voyageyear , false)<>c#return.Success then	
							/* standard process so obtain the period dates */
							lstr_app.i_servermode = ii_STANDARDMODE
							if lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/execute:", ls_periodselected , false)<>c#return.Success then	
								/* format must be YYYYPP ie 201204 */
								lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/period:", lstr_app.s_periodref, false)
							end if
						else
							/* server application might request annual process instead of the standard */
							lstr_app.i_servermode = ii_VOYYEARMODE	
							/* TODO validate year */
							/* TODO we do not have period dates to use */
							lstr_app.s_voyageyear = ls_voyageyear	
							lnv_stringfunc.of_getcommandlineparm(ls_commandline,"/period:", lstr_app.s_periodref, false)
						end if		
						// of_setperioddates(lstr_app,ls_periodselected)
						of_setperiods(lstr_app,ls_periodselected)
					end if
				end if // abcpath
				
				lstr_app.s_emailto = upper(lstr_app.s_emailto)
				lnv_errservice.of_addmsg( this.classdefinition, ls_method, "config, server=" + lstr_app.s_servername + ", database=" + lstr_app.s_databasename + ", log mode=" + ls_loglevel + ", email warnings to=" + lstr_app.s_emailto + ", period=" + ls_periodselected + ", type=" + lstr_app.s_estimatetype + ", priormonths=" + string(lstr_app.i_previousmonths) , "")		
			end if
		end if
	end if
end if	

lnv_errservice.of_showmessages( )

// override to allow access without SSO / TrustBroker
if lstr_app.s_pwd<>"" and lstr_app.s_logid<>"" then		
	SQLCA.DBMS 			= "ASE ADAPTIVE SERVER ENTERPRISE"
	SQLCA.ServerName 	= lstr_app.s_servername
	SQLCA.Database 	= lstr_app.s_databasename
	SQLCA.LogPass 		= lstr_app.s_pwd
	SQLCA.LogId 		= lstr_app.s_logid
	SQLCA.AutoCommit 	= False
	SQLCA.DBParm 		= "Release='15',UTF8=1, appname='server_axest' , Host='server_axest'"
else 
	SQLCA.DBMS 			= "ASE ADAPTIVE SERVER ENTERPRISE"
	SQLCA.ServerName 	= lstr_app.s_servername
	SQLCA.Database 	= lstr_app.s_databasename
	SQLCA.AutoCommit 	= False
	SQLCA.DBParm 		= "Release='15',UTF8=1,appname='server_axest',Host='server_axest',Sec_Cred_Timeout=100,Sec_Network_Auth=1,Sec_Server_Principal='" + lstr_app.s_security + "'"
end if

garbagecollect()

connect using SQLCA;
if SQLCA.SQLCode <> 0 then	
	lnv_errService.of_addMsg(this.classdefinition , "open", "unable to connect to database", string(SQLCA.sqlcode) + ":" + SQLCA.sqlerrtext )	
	lnv_errService.of_showmessages( )
	destroy lnv_errService
	return
end if

destroy lnv_errService

uo_global = create uo_global_vars
uo_global.SetVessel_Nr(0)

uo_global.is_userid = ls_runas
uo_global.of_setappstartedfrom()
uo_global.uf_load()

gnv_app = create n_cst_appmanager
gnv_app.event pfc_Open(commandline)

if ls_loaddistancesyyyy = "" then
	/* normal server application */
	lstr_app.b_client = false
	lnv_est = create n_axestimationcontrol
	lnv_est.of_start(lstr_app)
	destroy lnv_est	
else
	/* special utility to run to populate distances (not used very often) */
	n_generatedistances  lnv_gendist
	lnv_gendist = create n_generatedistances
	if integer(ls_loaddistancesyyyy)>1990 and integer(ls_loaddistancesyyyy)<2200 then
		lnv_gendist.of_loaddistances(ls_loaddistancesyyyy,lstr_app.s_abctablepath)
	end if
	destroy lnv_gendist
end if

end event

event close;disconnect using SQLCA;

If IsValid(guo_bpdistance) Then DESTROY guo_bpdistance
//gnv_app.event pfc_Close( )
DESTROY n_cst_appmanager
if isValid(gnv_AtoBviaC) then 
	gnv_atobviac.of_closetables( )
	destroy gnv_AtoBviaC
end if
destroy uo_global


end event

