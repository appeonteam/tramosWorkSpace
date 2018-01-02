$PBExportHeader$w_tramos_container_vessel.srw
$PBExportComments$Select of vessel by number or name base window.
forward
global type w_tramos_container_vessel from mt_w_main
end type
type uo_vesselselect from u_vessel_selection within w_tramos_container_vessel
end type
end forward

global type w_tramos_container_vessel from mt_w_main
integer x = 672
integer y = 264
integer width = 3557
string title = "BaseWindow"
long backcolor = 80269524
event ue_insert pbm_custom23
event ue_update pbm_custom12
event ue_delete pbm_custom13
event ue_retrieve pbm_custom14
event ue_refresh pbm_custom15
event ue_vesselselection ( integer ai_vessel )
uo_vesselselect uo_vesselselect
end type
global w_tramos_container_vessel w_tramos_container_vessel

type variables
boolean ib_vessel_no_trig = FALSE
boolean ib_vessel_name_trig = FALSE
int ii_vessel_nr


end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_vesselselection(integer ai_vessel);ii_vessel_nr = ai_vessel
end event

public subroutine documentation ();/********************************************************************
   ObjectName: w_tramos_container_vessel
   <OBJECT> Ancestor object to windows.</OBJECT>
   <DESC>   To be used for windows that sit outside main tramos container window
	this version contains functionality to support the vessel selection visual object
	Similar to ancestor object w_vessel_basewindow which is sheet type</DESC>
   <USAGE>  Previously the assigned ancestor for objects such as port of call
	proceeding etc</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   		Ref    	Author        		Comments
  00/00/07 	?     	Name Here     	First Version
  28/10-10   2165   RMO003			This window now inherits from our framework (m_w_sheet)
  ??/??-??	 ?			?				Object copied and type modified	
  07/07/14   3708		AGL027		Created new version of window, renamed 'w_tramos_container_vessel'
  											so it sits under correct parent.
  21/11/14	CR3708	CCY018		Add F1 Link.
********************************************************************/

end subroutine

event activate;uo_vesselselect.of_setshowtext( )


end event

on w_tramos_container_vessel.create
int iCurrent
call super::create
this.uo_vesselselect=create uo_vesselselect
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_vesselselect
end on

on w_tramos_container_vessel.destroy
call super::destroy
destroy(this.uo_vesselselect)
end on

type st_hidemenubar from mt_w_main`st_hidemenubar within w_tramos_container_vessel
end type

event st_hidemenubar::constructor;n_service_manager		lnv_servicemgr
n_menu_service   lnv_menu

if ib_enablef1help then
	lnv_serviceMgr.of_loadservice( lnv_menu, "n_menu_service")	
	lnv_menu.of_addhelpmenu( parent, { & 
		"F1", &
		"F2", &
		"F3",	&
		"F4", &
		"F7", &
		"Shift+F7", &
		"F8", &
		"F9", &
		"F10", &
		"F11", &
		"F12" &
		})
end if
end event

type uo_vesselselect from u_vessel_selection within w_tramos_container_vessel
integer taborder = 20
end type

on uo_vesselselect.destroy
call u_vessel_selection::destroy
end on

