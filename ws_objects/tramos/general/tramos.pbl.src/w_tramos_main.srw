$PBExportHeader$w_tramos_main.srw
$PBExportComments$Main window
forward
global type w_tramos_main from mt_w_frame
end type
type timing_trans from timing within w_tramos_main
end type
end forward

global type w_tramos_main from mt_w_frame
integer width = 4686
integer height = 2920
string title = "TRAMOS"
string menuname = "m_tramosmain"
windowtype windowtype = mdi!
long backcolor = 81324524
string icon = ""
boolean toolbarvisible = false
event ue_loadwindow pbm_custom01
timing_trans timing_trans
end type
global w_tramos_main w_tramos_main

type variables
String ls_programname
Integer ii_iconcount = 1

end variables

forward prototypes
public subroutine insertwindow (string ps_windowname)
private subroutine wf_loadwindow ()
private subroutine documentation ()
end prototypes

event ue_loadwindow;String ls_Tmp
Integer li_count = 0

redraw_off(w_tramos_main)
Open(w_share)
This.SetFocus()

/* if User Profile = Charterer default to Calculation menu. All other users Operations */ 
if uo_global.ii_user_profile = 1 then
	This.ChangeMenu(m_calcmain)
elseif uo_global.ii_user_profile = 5 then
	This.ChangeMenu(m_support)	
else
	This.ChangeMenu(m_tramosmain)
	
	m_tramosmain.m_menutop2.m_vcautomation.visible = uo_global.ib_msps_visible
	m_tramosmain.m_menutop2.m_vcautomation.m_mspsmessageslist.Toolbaritemvisible = uo_global.ib_msps_visible
end if

/* Load the selected windows */
post wf_loadwindow( )

Integer li_security
li_security = uo_global.ii_access_level

if uo_global.getuserid()="sa" then li_security = 3

this.toolbarVisible=TRUE
redraw_on(w_tramos_main)


end event

public subroutine insertwindow (string ps_windowname);String  ls_windowname
Window lw_tmp

ls_windowName = upper(ps_windowname)

If ls_WindowName = "W_DISBURSEMENTS" Then
   OpenSheet(w_disbursements,w_tramos_main,gi_win_pos,Original!)
ElseIF ls_windowName = "W_IDLE_DAYS" Then
   OpenSheet(w_idle_days,w_tramos_main,gi_win_pos,Original!)
Else
    If OpenSheet(lw_tmp,ls_WindowName,w_tramos_main,gi_win_pos,Original!) <> 1 Then &
       MessageBox("Error", "Error loading window "+ls_windowName, StopSign!)

End if
end subroutine

private subroutine wf_loadwindow ();/* Open windows based on user selection if any
	Reason for having them separated is because we have to post this in order to 
	have things loaded in the correct order */
if uo_global.ib_load_calc_manager Then OpenSheet(w_calc_manager, w_tramos_main, 0, original!)
if uo_global.ib_load_positionlist Then
	if uo_global.ii_access_level <> -1 then Open(w_position_list)  // External APM no access
end if
if uo_global.ib_load_fixturelist Then
	if uo_global.ii_access_level <> -1 then Open(w_fixture_list)  // External APM no access
end if
If uo_global.ib_load_proceeding Then OpenSheet(w_proceeding_list, w_tramos_main, 0, original!)
If uo_global.ib_load_portofcall Then OpenSheet(w_port_of_call, w_tramos_main, 0, original!)
If uo_global.ib_load_cargo Then OpenSheet(w_cargo, w_tramos_main, 0, original!)
If uo_global.ib_load_financecontrol then OpenSheet(w_fin_controlpanel, w_tramos_main, 0, original!)
if uo_global.ib_load_mvv then open(w_port_of_call_list)
if uo_global.ib_load_vc then open(w_msps_messages_list)
if uo_global.ib_load_alertview then OpenSheet(w_alerts_view, w_tramos_main, 0, original!)

/* If there exists an developer.ini file, read this, and open the window that is entered there */
string ls_windowname
window lw_mywindow
ls_windowname = profileString("c:\developer.ini","openwindow","windowname", "n/a")
if ls_windowname <> "n/a" then
	OpenSheet(lw_mywindow, ls_windowname, w_tramos_main, 0, original!)
end if

end subroutine

private subroutine documentation ();/********************************************************************
	w_tramos_main
	
	<OBJECT>
	</OBJECT>
	<DESC>
		Main Tramos Window/Container
	</DESC>
  	<USAGE>
		Most windows are contained within this window.
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
   	08/06/11		CR2460	JMC112	Support user has only access to m_support menu
		28/07/11 	CR2375	CONASW	If running on citrix (P or T), do not animate icon when minimized	
		12/07/13 	CR3286	LHC010	Add MSPS setup
		30/07/13		CR3238	LHG008	Close Vessel Messages List if open
		01/08/13		CR3279	WWA048	Remove Tramos Mail and related features.
		17-10/13 	CR3340	LHC010	Add load window for VC
		08-01-14 	CR3240	XSZ004	Add load window for AlertsView
		08-04-14 	CR3549	AZX004	Add Timer timing_trans for avoid database connection was interrupt     
	  	08/08/14 	CR3708   AGL027	F1 help application coverage - added ancestor w_tramos_container
		25/08/14 	CR3708   CCY018	F1 help application coverage - modified ancestor
		11/09/14  	CR3773	XSZ004	Change icon absolute path to reference path
		17/03/15		CR3987	AGL027	Remove hardcoded reference to db so we use constants variable instead
		08/09/16		CR4495	KSH092	When close tramos,close Position List
		14/08/17     CR3350   Ksh092	When close tramos, close Fixture/Cargo List
	</HISTORY>
********************************************************************/

end subroutine

event open;ls_programname = Message.StringParm
this.Title = This.Title + "  Database (" + SQLCA.Database + ") - Server (" + SQLCA.Servername + ") - User (" +uo_global.Getuserid()+")"
/* If not the production database change the color to dark red */
if SQLCA.Database <> c#connectivity.PRODUCTIONDB then this.mdi_1.backcolor = rgb(128,0,0)
PostEvent("ue_loadwindow")

timer(60,this)

//CR3549 To avoid database connection was interrupt. 
timing_trans.start(1800)


end event

event timer;
// CR 2376 - Animate icon only if running locally
if this.WindowState = Minimized! and uo_global.of_getappstartedfrom( ) = 1  Then
	Timer(0,this)
	Icon = "images\TRAMOS" + String (ii_iconcount) + ".ICO"
	ii_iconcount ++
	If ii_iconcount = 33 Then ii_iconcount = 1
	timer(0.75,this)
	return
End if




end event

on resize;If this.windowState =  Minimized! Then
	Timer(0.75,this)	
End if

end on

on w_tramos_main.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_tramosmain" then this.MenuID = create m_tramosmain
this.timing_trans=create timing_trans
end on

on w_tramos_main.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.timing_trans)
end on

event closequery;/************************************************************************************
 Author  : Teit Aunt 
 Date    : 8-1-98
 Description : Close query used only is the active window is the VAS window
 Arguments   : None
 Returns     : None
*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
---------------------------------------------------------
08-01-98		1.0			TA			Initial version
08-01-09		17.01			RMO003	Code removed as VAS report screen is now a sheet
************************************************************************************/
// Variables
//integer li_messg
//
//If IsValid(w_super_vas_reports) then
//	li_messg = MessageBox("Close Query","You can't close TRAMOS as VAS reports are beeing generated?")
//	Return 1
//End if

if isvalid(w_position_list) then
	if w_position_list.event closequery() = 0 then
		close(w_position_list)
	else
		return 1
	end if
end if

if isvalid(w_fixture_list) then
	if w_fixture_list.event closequery() = 0 then
		close(w_fixture_list)
	else
		return 1
	end if
end if
end event

event close;//close(w_position_list)
close(w_fixture_list)

// Close Google maps window if open
If IsValid(w_VesselPos) Then Close(w_VesselPos)

// Close Blueboard if open
If IsValid(w_Blueboard) Then Close(w_Blueboard)

//Added by LHC010 on 19-05-2011. CR2408 Change desc: Close Port of call list if open
If isvalid(w_port_of_call_list) then close(w_port_of_call_list)

//Close Vessel Messages List if open
if isvalid(w_msps_messages_list) then close(w_msps_messages_list)


end event

type timing_trans from timing within w_tramos_main descriptor "pb_nvo" = "true" 
end type

event timer;string  ls_version

select CURRENT_VERSION into :ls_version from TRAMOS_VERSION;

end event

on timing_trans.create
call super::create
TriggerEvent( this, "constructor" )
end on

on timing_trans.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

