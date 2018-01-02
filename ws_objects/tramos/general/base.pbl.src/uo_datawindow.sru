$PBExportHeader$uo_datawindow.sru
$PBExportComments$The Base object for datawindows
forward
global type uo_datawindow from mt_u_datawindow
end type
end forward

global type uo_datawindow from mt_u_datawindow
integer width = 494
integer height = 360
integer taborder = 1
event ue_childmodified pbm_custom75
end type
global uo_datawindow uo_datawindow

type variables
Boolean ib_auto = false

end variables

forward prototypes
public subroutine auto ()
public subroutine uf_select_row (long al_row)
public function integer filter ()
public subroutine uf_clearfilter ()
public subroutine documentation ()
public subroutine display_error_code (ref dwbuffer adwbuffer, long arow, integer aerrorcode, string aerrormessage)
end prototypes

public subroutine auto ();ib_auto = true

ScrollToRow(1)
SelectRow(1,True)

end subroutine

public subroutine uf_select_row (long al_row);This.SelectRow(0,false)
This.ScrollToRow(al_row)
This.SelectRow(al_row,True)
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

public subroutine documentation ();/********************************************************************
   n_object_name:uo_datawindow 
	
	<OBJECT>
		previously standalone, now merged into MT framework
	</OBJECT>
   <DESC>
		historic object used in many userobjects as the datawindow container.
	</DESC>
   <USAGE>
		Brought into framework, still at a high level.
	</USAGE>
   <ALSO>
		mt_u_datawindow	
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	23/06/15 	?      	AGL027			Ancestor changed from datawindow to mt_u_datawindow
	01/01/13
********************************************************************/
end subroutine

public subroutine display_error_code (ref dwbuffer adwbuffer, long arow, integer aerrorcode, string aerrormessage);Boolean lb_showerror

If uo_global.ib_developer  Then
	lb_showerror = true // Force full debug info if developer
End if

CHOOSE CASE aerrorcode
	CASE 233
		MessageBox("Update Error",  &
		"Please populate the mandatory fields before updating! ~r", StopSign!)
	CASE 229
		MessageBox("Update Error",  &
		"You do not have access to this Functionality!", StopSign!)
	CASE 546 //30002
		MessageBox("Update Error",  &
		"You are using a value that does not exist in the system!~nThis is probably a drop down list box you have written a wrong value/string in!", StopSign!)
	CASE 2601
		MessageBox("Update Error",  &
		"You are attempting to create a duplicate!", StopSign!)
	CASE 30006
		MessageBox("Update Error",  &
		"There exists dependent data on what you are deleting!~r~nThis operation cannot be performed!~rFor example, you are deleting a system type that is used in the system!", StopSign!)
	CASE ELSE
		lb_showerror = true
END CHOOSE

If lb_showerror then
		
	string err_type,err_msg
	long row
	
	choose case adwbuffer
		case delete!
			err_type = "Deleting"
		case primary!
			
			choose case this.getItemstatus(arow, 0, adwbuffer)
				Case New!, newmodified!
					err_type = "Inserting"
				Case Else
					err_type = "Updating"
			End choose
	end choose

	err_msg = "Error while "+err_type+" row "+string(row)
	err_msg = err_msg + "~r~nData Base error Number is: " + string(aErrorCode )
	err_msg = err_msg + "~r~nData Base error Message is:~r~n~r~n" + aerrormessage

	window win
	If Parent.TypeOf() = Window! Then
		win = parent
		f_error_box(win.title,err_msg)
	Else
		f_error_box("unknown parent", err_msg)
	End if

	this.setfocus()
	this.setrow(row)
	this.scrolltorow(row)
End if

end subroutine

on rowfocuschanged;If ib_auto Then
	Long ll_row

	ll_row = GetRow()
	
	If ll_row <> GetSelectedRow(0) Then
		SelectRow(0,False)
		SelectRow(ll_row,True)
		SetRow(ll_Row)
	End if
End if


end on

event clicked;/************************************************************************************

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
28-7-15					AGL	access ancestor click event code
************************************************************************************/
super::event clicked( xpos, ypos, row, dwo)
if ib_auto then
	if row = 0 then row = GetSelectedRow(0)
	if (row > 0) and (row <> getselectedrow(row - 1)) then 
		selectrow(0,false)
		setrow(row)
		selectrow(row,true)
	end if
end if


end event

event itemchanged;Parent.TriggerEvent("ue_childmodified")
end event

on uo_datawindow.create
call super::create
end on

on uo_datawindow.destroy
call super::destroy
end on

event constructor;IF uo_global.ii_access_level = -1 THEN
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
end event

event dberror;call super::dberror;display_error_code(buffer,row,sqldbcode,sqlerrtext)

// Stop PowerBuilder from displaying its message

Return 1
//SetActionCode(1)

end event

