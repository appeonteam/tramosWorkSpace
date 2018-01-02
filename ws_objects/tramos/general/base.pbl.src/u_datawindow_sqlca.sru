$PBExportHeader$u_datawindow_sqlca.sru
$PBExportComments$SQLCA aware uo_datawindow
forward
global type u_datawindow_sqlca from mt_u_datawindow
end type
end forward

global type u_datawindow_sqlca from mt_u_datawindow
end type
global u_datawindow_sqlca u_datawindow_sqlca

type variables
Boolean ib_auto = false
boolean ib_autochildmodified = true  /* allow validation on data objects before push to update modification is made */

private boolean _ib_itemerror	//specifies whether the item has occurs error
private boolean _ib_dwhasfocus	//specifies whether the datawindow currently has focus

boolean ib_autoaccept	//use to specifies whether we need auto accept or not when column lost focus
end variables

forward prototypes
public subroutine auto ()
public function integer filter ()
public subroutine uf_clearfilter ()
public subroutine uf_select_row (long al_row)
public subroutine documentation ()
private subroutine _resetitemerrorflag ()
private subroutine _dataacceptance ()
end prototypes

public subroutine auto ();ib_auto = true

ScrollToRow(1)
SelectRow(1,True)

end subroutine

public function integer filter ();Integer li_tmp

li_tmp = super::filter()

// Adjust row
SelectRow(0,False)
TriggerEvent(RowFocusChanged!)
TriggerEvent(RetrieveEnd!)

Return(li_tmp)
end function

public subroutine uf_clearfilter ();This.SetFilter("")
This.Filter()
end subroutine

public subroutine uf_select_row (long al_row);if ib_newstandard = false then
	This.SelectRow(0,false)
	This.ScrollToRow(al_row)
	This.SelectRow(al_row,True)
end if
end subroutine

public subroutine documentation ();/********************************************************************
   u_datawindow_sqlca
   <OBJECT>		Inherited from mt_u_datawindow	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	23/10/13     CR2877       ZSW001        Move functions uf_redraw_on() and uf_redraw_off() to mt_u_datawindow
   	15/04/15     CR3835       LHG008        Fix the usability issue of data displayed format and data transfer between normal view and compact view when the column loses focus
   </HISTORY>
********************************************************************/

end subroutine

private subroutine _resetitemerrorflag ();/********************************************************************
   _resetitemerrorflag
   <DESC>	Reset instance variables _ib_itemerror to false	</DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Post this function in event itemerror.	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		30/04/15 CR3835        LHG008   First Version
   </HISTORY>
********************************************************************/

_ib_itemerror = false
end subroutine

private subroutine _dataacceptance ();/********************************************************************
   _dataacceptance
   <DESC>	When datawindow lose focus, make the data acceptance and show as specifies format	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	If ib_autoaccept = true, then post this function in event losefocus	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		05/05/15 CR3835        LHG008   First Version
   </HISTORY>
********************************************************************/

if _ib_dwhasfocus = false then
	this.setcolumn(this.getcolumn())
end if
end subroutine

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_datawindow_sqlca
  
 Event	 : 

 Scope     : Global 

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 15-07-96

 Description : database aware uo_datawindow 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
15-07-96		1.0 			MI		Initial version
  
************************************************************************************/
IF uo_global.ii_access_level = -1 THEN
	/* There seems to be a problem when readOnly is set for wizard datawindow
		therefore this workaround */
	if this.DataObject="d_wizard" &
	or this.DataObject="d_calc_manager_filter" then 
		//
	else
		this.Object.Datawindow.ReadOnly="Yes"
	end if
	/* It is OK that All External Users have access to distance finder */
	if this.DataObject="d_calc_distance_finder" then this.Object.Datawindow.ReadOnly="No"
END IF

This.SetTransObject(SQLCA)
end event

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : uo_datawindow
  
 Event	 :  clicked!

 Scope     : Global

 ************************************************************************************

 Author    : Martin Israelsen, m.fl.
   
 Date       : 1/1-96

 Description : Default ancestor datawindow

 Arguments : None

 Returns   : None

 Variables :  None

 Other : By setting ib_auto to true, the datawindow itself will control 
             clicked events and keypresses (up and down) 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0					Initial version
17-4-96					MI		Added auto-clicked and rowfocuschanged control
17-7-96					MI		Added ue_childmodified event, sent to parent upon modification 
28-8-97					MI		Changed to PB 5
************************************************************************************/

If ib_auto Then
     if ib_newstandard = false then
		if row = 0 Then row = GetSelectedRow(0)
	
		If (Row > 0) And (row <> GetSelectedRow(row - 1)) Then 
			SelectRow(0,false)
			SetRow(row)
			SelectRow(row,True)
		End if
	end if
End if


end event

on u_datawindow_sqlca.create
call super::create
end on

on u_datawindow_sqlca.destroy
call super::destroy
end on

event itemchanged;call super::itemchanged;if ib_autochildmodified then parent.TriggerEvent("ue_childmodified")
end event

event rowfocuschanged;call super::rowfocuschanged;If ib_auto Then
	Long ll_row
     
	ll_row = GetRow()
	if ib_newstandard = false then
		If ll_row <> GetSelectedRow(0) Then
			SelectRow(0,False)
			SelectRow(ll_row,True)
			SetRow(ll_Row)
		End if
	end if
End if
end event

event losefocus;call super::losefocus;_ib_dwhasfocus = false

if ib_autoaccept then
	this.post _dataacceptance()
end if
end event

event itemerror;call super::itemerror;if _ib_itemerror then
	return 1
else
	_ib_itemerror = true
	this.post _resetitemerrorflag()
end if
end event

event getfocus;call super::getfocus;_ib_dwhasfocus = true
end event

