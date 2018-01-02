$PBExportHeader$n_messagebox.sru
forward
global type n_messagebox from mt_n_nonvisualobject
end type
end forward

global type n_messagebox from mt_n_nonvisualobject autoinstantiate
end type

type variables
constant string is_TYPE_UNSAVED_DATA = "Data not saved"
constant string is_TYPE_CONFIRM_DELETE = "Confirm delete"
constant string is_TYPE_VALIDATION_ERROR = "Validation error"
constant string is_TYPE_GENERAL_ERROR = "Error"
constant string is_TYPE_WARNING = "Warning"
constant string is_TYPE_QUESTION = "Question"
constant string is_TYPE_INFORMATION = "Information"
end variables

forward prototypes
public function integer of_messagebox (string as_type, string as_message, powerobject apo_object)
public function integer of_messagebox (string as_type, string as_message, powerobject apo_object, string aas_tab[])
public function integer of_messagebox (string as_type, powerobject apo_object)
public subroutine documentation ()
public function integer of_messagebox (string as_type, string as_message, powerobject apo_object, string as_title)
public function integer of_messagebox (string as_type, string as_message, powerobject apo_object, string aas_tab[], string as_title)
end prototypes

public function integer of_messagebox (string as_type, string as_message, powerobject apo_object);//If NOT in tabpage

string	aas_tab[]

return of_messagebox(as_type, as_message, apo_object, aas_tab)
end function

public function integer of_messagebox (string as_type, string as_message, powerobject apo_object, string aas_tab[]);/********************************************************************
   of_messagebox
   <DESC>	Pop-up messagebox, according to latest UX standard	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_type: message Type. Difined in this object
		as_message: 
		apo_object: 
		aas_tab[]: tabpage array
   </ARGS>
   <USAGE>	eg. In delete button and click event: 
					 lnv_messagebox.of_messagebox(lnv_messagebox.is_TYPE_CONFIRM_DELETE, this)	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		11/10/16 CR4501        LHG008   First Version
		22/03/17 CR4439        HHX010	  
   </HISTORY>
********************************************************************/

return of_messagebox(as_type, as_message, apo_object, aas_tab, as_type)

end function

public function integer of_messagebox (string as_type, powerobject apo_object);//For is_TYPE_UNSAVED_DATA, is_TYPE_CONFIRM_DELETE

string	as_message, aas_tab[]

return of_messagebox(as_type, as_message, apo_object, aas_tab)
end function

public subroutine documentation ();/********************************************************************
   n_messagebox
   <OBJECT>		Use to show messagebox	</OBJECT>
   <USAGE> </USAGE>
   <ALSO> </ALSO>
   <HISTORY>
		Date     CR-Ref         Author   Comments
		11/10/16	CR4501         LHG008   First Version
		22/03/17 CR4439		HHX010	Overload	function of_messagebox()
		10/09/17 CR4667       EPE080   modify of_messagebox():is_TYPE_UNSAVED_DATA,
   </HISTORY>
********************************************************************/
end subroutine

public function integer of_messagebox (string as_type, string as_message, powerobject apo_object, string as_title);//If NOT in tabpage

string	aas_tab[]

return of_messagebox(as_type, as_message, apo_object, aas_tab, as_title)
end function

public function integer of_messagebox (string as_type, string as_message, powerobject apo_object, string aas_tab[], string as_title);/********************************************************************
   of_messagebox
   <DESC>	Pop-up messagebox, according to latest UX standard	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_type: message Type. Difined in this object
		as_message: 
		apo_object: 
		aas_tab[]: tabpage array
		as_title:
   </ARGS>
   <USAGE>	eg. In delete button and click event: 
					 lnv_messagebox.of_messagebox(lnv_messagebox.is_TYPE_CONFIRM_DELETE, this)	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		22/03/17 CR4501        HHX010   First Version
		10/09/17 CR4667        EPE080    modify of_messagebox()
   </HISTORY>
********************************************************************/

integer	li_return, li_index
string	ls_message, ls_tabs
powerobject		lpo_parent
window			lw_parent

lpo_parent = apo_object

do while lpo_parent.typeof() <> Window!
	lpo_parent = lpo_parent.getparent()
loop
lw_parent = lpo_parent

choose case as_type
	case is_TYPE_GENERAL_ERROR
		li_return = messagebox(as_title, as_message, StopSign!)
		
	case is_TYPE_WARNING
		li_return = messagebox(as_title, as_message, Exclamation!)
		
	case is_TYPE_QUESTION
		li_return = messagebox(as_title, as_message, Question!, YesNo!, 2)
		
	case is_TYPE_INFORMATION
		li_return = messagebox(as_title, as_message, Information!)
		
	case is_TYPE_VALIDATION_ERROR
		li_return = messagebox(as_title, as_message, StopSign!)
		
	case is_TYPE_UNSAVED_DATA
		if upperbound(aas_tab) > 0 then
			for li_index = 1 to upperbound(aas_tab)
				if len(trim(aas_tab[li_index])) > 0 then
					ls_tabs += "~r~n- " + aas_tab[li_index]
				end if
			next
			/*eg. "You have modified the following tabs in Vessels:
					-	General
					-	Financial
					-	Consumption
					
					Would you like to save before continuing?"
			*/
			ls_message = "You have modified the following tab(s) in " + lw_parent.title + ":" + ls_tabs
		elseif len(trim(as_message)) > 0 then
			/*eg. "You have modified <as_message>.
					
					Would you like to save before continuing?"
			*/
			ls_message = "You have modified " + as_message + "."
		else
			/*eg. "You have modified the C/P.
					
					Would you like to save before continuing?"
			*/
			ls_message = "You have modified the " + lw_parent.title + "."
		end if
		
		li_return = messagebox(as_title, ls_message + "~r~n~r~nWould you like to save before continuing?", Exclamation!, YesNoCancel!, 1)
		
	case is_TYPE_CONFIRM_DELETE
		if len(trim(as_message)) > 0 then
			//eg. "Are you sure you want to delete <as_message>?"
			ls_message = "Are you sure you want to delete " + as_message + "?"
		else
			//eg. "Are you sure you want to delete the selected Vessel?"
			ls_message = "Are you sure you want to delete the selected " + lw_parent.title + "?"
		end if
		
		li_return = messagebox(as_title, ls_message, Exclamation!, YesNo!, 2)
		
end choose

return li_return
end function

on n_messagebox.create
call super::create
end on

on n_messagebox.destroy
call super::destroy
end on

