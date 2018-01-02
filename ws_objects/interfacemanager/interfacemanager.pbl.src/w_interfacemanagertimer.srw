$PBExportHeader$w_interfacemanagertimer.srw
$PBExportComments$window object with timer event
forward
global type w_interfacemanagertimer from mt_w_main
end type
type st_logprocessed from statictext within w_interfacemanagertimer
end type
type st_3 from statictext within w_interfacemanagertimer
end type
type sle_loglevel from singlelineedit within w_interfacemanagertimer
end type
type st_2 from statictext within w_interfacemanagertimer
end type
type sle_unit from singlelineedit within w_interfacemanagertimer
end type
type st_logcritical from statictext within w_interfacemanagertimer
end type
type st_logerror from statictext within w_interfacemanagertimer
end type
type st_logwarning from statictext within w_interfacemanagertimer
end type
type st_loginfo from statictext within w_interfacemanagertimer
end type
end forward

global type w_interfacemanagertimer from mt_w_main
boolean visible = false
integer width = 3287
integer height = 896
string title = "Interface Manager"
long backcolor = 32304364
string icon = "DataPipeline!"
event ue_settimer ( )
event ue_postopen ( )
st_logprocessed st_logprocessed
st_3 st_3
sle_loglevel sle_loglevel
st_2 st_2
sle_unit sle_unit
st_logcritical st_logcritical
st_logerror st_logerror
st_logwarning st_logwarning
st_loginfo st_loginfo
end type
global w_interfacemanagertimer w_interfacemanagertimer

type prototypes

end prototypes

type variables
n_interfaceprocess inv_processes[]
double id_axtranscounter
constant integer ii_LOG_IMPORTANT = 1
constant integer ii_LOG_NORMAL = 2
constant integer ii_LOG_DEBUG = 3
string is_monitor_id
end variables

forward prototypes
public subroutine documentation ()
public function long wf_matched (string as_interfacegroup, string as_sourcetable, long al_interval)
public function integer wf_checkprocesses ()
public function integer wf_init ()
public function integer wf_writetolog (string as_text, integer ai_loglevel)
protected function integer _addmessage (readonly powerobject apo_classdef, string as_methodname, string as_message, string as_devmessage, boolean ab_showmessage)
end prototypes

event ue_settimer();timer( gl_unit )
end event

event ue_postopen();if wf_init() = c#return.Failure then
	close(this)
else
	/* runs the checkinterfaces() process first before setting the timer event */
	if wf_checkprocesses() = c#return.Failure then 
		close(this)
	else
		post triggerevent("ue_settimer")
	end if
end if
end event

public subroutine documentation ();/********************************************************************
   ObjectName: w_interfacemanagertimer
	
	<OBJECT>
		Window object required due to its timer event. 
	</OBJECT>
  	<DESC>
		Contains array of n_interfaceprocess object(s) 
		Calls upon each n_interfaceprocess to check if interval time has elapsed or not.
		if it does it triggers execution of same object.
	</DESC>
  	<USAGE>
		Called directly from the application object.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   	Ref   	Author   Comments
	06/01/12 	M5-1     AGL027	First Version
	27/03/12		M5-5		AGL027	Added file prefix
	12/10/16		CR3320	AGL027	Voyage Master Transaction Handling (applied SSO connectivity)
********************************************************************/
end subroutine

public function long wf_matched (string as_interfacegroup, string as_sourcetable, long al_interval);// wf_matched(lds_interfaces.getitemstring(li_index,"interface_group"), lds_interfaces.getitemstring(li_index,"source_table"),lds_interfaces.getitemnumber(li_index,"interval"))

long ll_found=0, ll_index

if upperbound(inv_processes)=0 then return 0

for ll_index = 1 to upperbound(inv_processes)
	if inv_processes[ll_index].of_getinterfacegroup() = as_interfacegroup and inv_processes[ll_index].of_getsourcetable() = as_sourcetable and inv_processes[ll_index].of_getinterval() = al_interval then
			ll_found = ll_index
			exit
	end if
next


return ll_found
end function

public function integer wf_checkprocesses ();/********************************************************************
   checkinterfaces()
<DESC>   
	Loops through all active interfaces and for each checks the current date/time against the interval.
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	as_Arg1: Description
	as_Arg2: Description
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/
integer li_interfaceindex
integer li_returnflag = c#return.NoAction
boolean	lb_activity = false

wf_writetolog("info, begin check of all interfaces",ii_LOG_DEBUG)

for li_interfaceindex = 1 to upperbound(inv_processes)
	if inv_processes[li_interfaceindex].of_hastimeelapsed() then
		
		inv_processes[li_interfaceindex].of_writetolog("checking for updates.... " + inv_processes[li_interfaceindex].of_getnoteinterval(),ii_LOG_NORMAL)		
		li_returnflag = inv_processes[li_interfaceindex].of_start(id_axtranscounter)

		CHOOSE CASE li_returnflag
			CASE 	c#return.Success
				lb_activity = true
			CASE 	c#return.NoAction
				inv_processes[li_interfaceindex].of_writetolog("no updates found....",ii_LOG_DEBUG)
			CASE 	c#return.Failure	
				if gs_shutdownonerror="on" then
					inv_processes[li_interfaceindex].of_writetolog("error, :-( FORCED SHUTDOWN !",ii_LOG_IMPORTANT)
					return  c#return.Failure
				end if
		END CHOOSE		
	
	end if	
next
if not lb_activity then
	wf_writetolog("info, nothing to do",ii_LOG_DEBUG)
end if	


return c#return.Success
end function

public function integer wf_init ();mt_n_datastore lds_interfaces
s_interface lstr_interface, lstr_dummy
integer li_index, li_interfacecounter
boolean lb_success = true

SQLCA.DBMS 			= "ASE ADAPTIVE SERVER ENTERPRISE"
SQLCA.ServerName 	= gs_servername
SQLCA.Database 	= gs_databasename
SQLCA.AutoCommit 	= False
SQLCA.DBParm 		= "Release='15',UTF8=1,appname='server_mmtfuelimport',Host='server_mmtfuelimport',Sec_Cred_Timeout=100,Sec_Network_Auth=1,Sec_Server_Principal='" + gs_security + "'"

garbagecollect()

SQLCA.of_connect()
if SQLCA.sqlcode <> 0 then
	_addmessage( this.classdefinition, "_init()", "database error, cannot initalise application, check the server and database parameters" , "cannot connect to db transaction!")
	SQLCA.of_rollback()
	SQLCA.of_disconnect()
	return c#return.Failure
end if
SQLCA.of_commit()

/* get the ax transaction counter value one time */
string ls_max07

SELECT MAX(substring(F07_DOCNUM,3,10))
INTO :ls_max07
FROM 	TRANS_LOG_MAIN_A
WHERE (substring(F07_DOCNUM,1,2)="TX");
	
if isnull(ls_max07) then ls_max07 = "0"		
id_axtranscounter = double(ls_max07)

lds_interfaces = create mt_n_datastore
lds_interfaces.dataobject="d_sq_gr_interfacelist"
lds_interfaces.settransobject(sqlca)
lds_interfaces.retrieve()

/* process has the option of running against an application id parameter */
if gs_appid <> "" then
	lds_interfaces.setfilter("appid like '%" + gs_appid + "%'")
	lds_interfaces.filter()
	/* attempy to filter against application id.  If no  filter applied throw an error */
	if lds_interfaces.filteredcount()=0 then
		_addmessage( this.classdefinition, "wf_init()", "error, command line parameter appid '" + gs_appid + "'  is not recognised.  Please review" , "")
		return c#return.Failure
	end if	
end if

if lds_interfaces.rowcount( )>0 then
	for li_index = 1 to lds_interfaces.rowcount( )
		if lds_interfaces.getitemnumber(li_index,"enabled") = 1 then
			li_interfacecounter = wf_matched(lds_interfaces.getitemstring(li_index,"interface_group"),lds_interfaces.getitemstring(li_index,"source_table"),lds_interfaces.getitemnumber(li_index,"interval"))
			if li_interfacecounter=0 then
				li_interfacecounter = upperbound(inv_processes) + 1
				inv_processes[li_interfacecounter] = create n_interfaceprocess
				inv_processes[li_interfacecounter].of_setmonitorid(is_monitor_id)
				inv_processes[li_interfacecounter].of_createprocess( &
					lds_interfaces.getitemstring(li_index,"interface_group"), &
					lds_interfaces.getitemstring(li_index,"source_table"), &
					lds_interfaces.getitemnumber(li_index,"interval") &
				)
			end if	
			lstr_interface = lstr_dummy
			lstr_interface.l_id = lds_interfaces.getitemnumber(li_index,"id")
			lstr_interface.s_name = lds_interfaces.getitemstring(li_index,"interface_name")
			lstr_interface.s_description = lds_interfaces.getitemstring(li_index,"description")
			lstr_interface.s_folderlocation = lds_interfaces.getitemstring(li_index,"folder_location")
			lstr_interface.s_folderarchive = lds_interfaces.getitemstring(li_index,"folder_archive")
			lstr_interface.s_folderworking = lds_interfaces.getitemstring(li_index,"folder_working")
			lstr_interface.s_folderout = lds_interfaces.getitemstring(li_index,"folder_out")
			lstr_interface.s_filenameprefix = lds_interfaces.getitemstring(li_index,"filename_extension")
			lstr_interface.s_mqqueuemanager = lds_interfaces.getitemstring(li_index,"mq_queue_manager")
			lstr_interface.s_mqqueuename = lds_interfaces.getitemstring(li_index,"mq_queue_name")
			lstr_interface.i_filenamecounter = lds_interfaces.getitemnumber(li_index,"filename_counter")
			lstr_interface.l_sourcereferencecounter = lds_interfaces.getitemnumber(li_index,"sourceref_counter")
			lstr_interface.dtm_lastprocessed = lds_interfaces.getitemdatetime(li_index,"last_processed")
			if inv_processes[li_interfacecounter].of_addinterfacemodel(lstr_interface)=c#return.Failure then
				lb_success = false
			end if	
		end if
	next
else
	_addmessage( this.classdefinition, "wf_init()", "error, no interfaces defined!" , "")
	sqlca.of_disconnect()
	return c#return.Failure
end if	

destroy lds_interfaces

sqlca.of_disconnect()
garbagecollect()

if lb_success=false then
	/* implemented this way so all missing folder detail is written to log before shutdown */
	_addmessage( this.classdefinition, "wf_init()", "error, can not execute when missing folder configuration. correct by applying folder access or disable interface job then restart!" , "")
	sqlca.of_disconnect()
	return c#return.Failure				
end if


return c#return.Success
end function

public function integer wf_writetolog (string as_text, integer ai_loglevel);if ai_loglevel <= gi_loglevel then
	this._addmessage( this.classdefinition, "wf_writetolog()", as_text, "")
end if

if this.visible = true then
	if pos(as_text,"info, ")>0 then
		this.st_loginfo.text = string(now(), "hh:mm:ss - " ) + as_text
	elseif pos(as_text,"processed, ")>0 then	
		this.st_logprocessed.text = string(now(), "hh:mm:ss - " ) + as_text
	elseif pos(as_text,"warning, ")>0 then	
		this.st_logwarning.text = string(now(), "hh:mm:ss - " ) + as_text
	elseif pos(as_text,"critical error, ")>0 then	
		this.st_logcritical.text = string(now(), "hh:mm:ss - " ) + as_text
	elseif pos(as_text,"error, ")>0 then		
		this.st_logerror.text = string(now(), "hh:mm:ss - " ) + as_text
	end if
	
end if

return c#return.Success
end function

protected function integer _addmessage (readonly powerobject apo_classdef, string as_methodname, string as_message, string as_devmessage, boolean ab_showmessage);n_service_manager 	lnv_serviceManager
n_error_service		lnv_errService

lnv_serviceManager.of_loadservice( lnv_errService , "n_error_service")
lnv_errService.of_addMsg(apo_classdef , as_methodname, as_message, as_devmessage, 1, is_monitor_id )
if ab_showmessage then lnv_errService.of_showmessages( )
return c#return.success
end function

event timer;call super::timer;if wf_checkprocesses() = c#return.Failure then close(this)


end event

on w_interfacemanagertimer.create
int iCurrent
call super::create
this.st_logprocessed=create st_logprocessed
this.st_3=create st_3
this.sle_loglevel=create sle_loglevel
this.st_2=create st_2
this.sle_unit=create sle_unit
this.st_logcritical=create st_logcritical
this.st_logerror=create st_logerror
this.st_logwarning=create st_logwarning
this.st_loginfo=create st_loginfo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_logprocessed
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.sle_loglevel
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_unit
this.Control[iCurrent+6]=this.st_logcritical
this.Control[iCurrent+7]=this.st_logerror
this.Control[iCurrent+8]=this.st_logwarning
this.Control[iCurrent+9]=this.st_loginfo
end on

on w_interfacemanagertimer.destroy
call super::destroy
destroy(this.st_logprocessed)
destroy(this.st_3)
destroy(this.sle_loglevel)
destroy(this.st_2)
destroy(this.sle_unit)
destroy(this.st_logcritical)
destroy(this.st_logerror)
destroy(this.st_logwarning)
destroy(this.st_loginfo)
end on

event open;call super::open;string	ls_loglevel

is_monitor_id = message.stringparm
this.visible = gb_showwindow

if this.visible then
	
	/* get version detail */
		n_versioninfo lnv_versioninfo
		string ls_app, ls_version 
		lnv_versioninfo = create n_versioninfo
		lnv_versioninfo.setispbapp(true)
		setnull(ls_app)
		ls_version = lnv_versioninfo.getversion(ls_app)
		if not isnull(ls_version) then this.title += " version " + ls_version  
		destroy lnv_versioninfo
	
end if

CHOOSE CASE gi_loglevel
	CASE 2
		ls_loglevel = "Medium (Normal)"		
	CASE 3
		ls_loglevel = "Maximum (Debug)"
	CASE ELSE
		ls_loglevel = "Minimum"
END CHOOSE		

sle_loglevel.text = ls_loglevel 
sle_unit.text = string(gl_unit) + " seconds"

post triggerevent("ue_postopen")
end event

event closequery;call super::closequery;/* loop through all n_interfaceprocess objects and closes them */
integer li_index

for li_index = 1 to upperbound(inv_processes)
	destroy inv_processes[li_index]
next

wf_writetolog("info, shutdown",3)
wf_writetolog("*************************",3)
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_interfacemanagertimer
end type

type st_logprocessed from statictext within w_interfacemanagertimer
integer x = 59
integer y = 156
integer width = 2400
integer height = 228
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 32768
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_interfacemanagertimer
integer x = 2501
integer y = 128
integer width = 219
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "log level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_loglevel from singlelineedit within w_interfacemanagertimer
integer x = 2743
integer y = 124
integer width = 466
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_interfacemanagertimer
integer x = 2514
integer y = 36
integer width = 206
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "unit:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_unit from singlelineedit within w_interfacemanagertimer
integer x = 2743
integer y = 32
integer width = 466
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_logcritical from statictext within w_interfacemanagertimer
integer x = 59
integer y = 624
integer width = 2400
integer height = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type st_logerror from statictext within w_interfacemanagertimer
integer x = 59
integer y = 504
integer width = 2400
integer height = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type st_logwarning from statictext within w_interfacemanagertimer
integer x = 59
integer y = 384
integer width = 2400
integer height = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388736
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type st_loginfo from statictext within w_interfacemanagertimer
integer x = 59
integer y = 36
integer width = 2400
integer height = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

