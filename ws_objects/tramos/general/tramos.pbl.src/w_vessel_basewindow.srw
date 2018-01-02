$PBExportHeader$w_vessel_basewindow.srw
$PBExportComments$Select of vessel by number or name base window.
forward
global type w_vessel_basewindow from mt_w_sheet
end type
type uo_vesselselect from u_vessel_selection within w_vessel_basewindow
end type
end forward

global type w_vessel_basewindow from mt_w_sheet
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
global w_vessel_basewindow w_vessel_basewindow

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
   ObjectName: w_vessel_basewindow
   <OBJECT> Ancestor object to windows. No longer used for new objects</OBJECT>
   <DESC>   n/a</DESC>
   <USAGE>  Previously the assigned ancestor for objects such as port of call
	proceeding etc</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   		Ref    	Author        		Comments
  00/00/07 	?     	Name Here     	First Version
  28/10-10   2165   RMO003			This window now inherits from our framework (m_w_sheet)
********************************************************************/

end subroutine

event activate;If w_tramos_main.MenuName <> "m_tramosmain" Then
	w_tramos_main.ChangeMenu(m_tramosmain)
End if

uo_vesselselect.of_setshowtext( )


end event

on w_vessel_basewindow.create
int iCurrent
call super::create
this.uo_vesselselect=create uo_vesselselect
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_vesselselect
end on

on w_vessel_basewindow.destroy
call super::destroy
destroy(this.uo_vesselselect)
end on

type uo_vesselselect from u_vessel_selection within w_vessel_basewindow
integer taborder = 20
end type

on uo_vesselselect.destroy
call u_vessel_selection::destroy
end on

