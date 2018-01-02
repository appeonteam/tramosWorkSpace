$PBExportHeader$w_events_pcgroup.srw
forward
global type w_events_pcgroup from mt_w_sheet
end type
end forward

global type w_events_pcgroup from mt_w_sheet
integer width = 3168
integer height = 1876
event type integer ue_pcgroupchanged ( integer ai_pcgroupid )
event ue_postopen ( )
end type
global w_events_pcgroup w_events_pcgroup

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
   ObjectName: w_events_pcgroup
   <OBJECT> Ancestor object to w_position_list, w_fixture_list etc.
	any window in pflist that has profit center group detail.</OBJECT>
   <DESC>   Used as an ancestor object to control event when Profit
	center group is changed</DESC>
   <USAGE>  </USAGE>
   <ALSO>   Ancestor being mt_w_main</ALSO>
    Date   Ref    Author        	Comments
  11/10/10 ?      AGL     			Changed ancestor from window to mt_w_main
********************************************************************/

end subroutine

on w_events_pcgroup.create
call super::create
end on

on w_events_pcgroup.destroy
call super::destroy
end on

