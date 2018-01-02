$PBExportHeader$w_tramos_container.srw
$PBExportComments$window container that is outside w_tramos_main container. Only shortcut [F1] available. No vessel selection or additonal links
forward
global type w_tramos_container from mt_w_main
end type
end forward

global type w_tramos_container from mt_w_main
integer width = 3168
integer height = 1876
event type integer ue_pcgroupchanged ( integer ai_pcgroupid )
event ue_postopen ( )
event ue_preopen ( )
event ue_keydown pbm_keydown
end type
global w_tramos_container w_tramos_container

type variables
long ll_winheightadjust = 0
end variables

forward prototypes
public subroutine documentation ()
end prototypes

event type integer ue_pcgroupchanged(integer ai_pcgroupid);/* insert code if we have something comumn*/
//messageBox("","please code something here")
return 1
end event

event ue_postopen();/* called when u_pcgroup user object can not find a valid profit center*/
messagebox("Error","You have no access to any profit center that is currently used.  Please contact the Tramos support team.")
close(this)
end event

public subroutine documentation ();/********************************************************************
   ObjectName: w_tramos_container
   <OBJECT> Ancestor object to general windows that fit outside Tramos 
	main container window.  These include (may not be complete list) - 
					pflist::w_position_list
					pflist::w_fixture_list
					googlemaps::w_vesselpos
					pflist::w_blueboard
	</OBJECT>
   <DESC>   Used as an ancestor object to control event when Profit
	center group is changed</DESC>
   <USAGE>Also supports profit center group processing</USAGE>
   <ALSO>   Ancestor being mt_w_main</ALSO>
    Date   Ref    	Author        	Comments
  11/10/10 ?      	AGL     			Changed ancestor from window to mt_w_main
  07/07/14 CR3708		AGL				Created new version of window so it sits under 
  												correct parent.
********************************************************************/

end subroutine

on w_tramos_container.create
call super::create
end on

on w_tramos_container.destroy
call super::destroy
end on

type st_hidemenubar from mt_w_main`st_hidemenubar within w_tramos_container
end type

