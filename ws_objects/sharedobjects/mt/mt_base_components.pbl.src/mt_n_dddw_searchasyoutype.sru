$PBExportHeader$mt_n_dddw_searchasyoutype.sru
forward
global type mt_n_dddw_searchasyoutype from nonvisualobject
end type
end forward

global type mt_n_dddw_searchasyoutype from nonvisualobject autoinstantiate
event mt_editchanged ( ref long al_row,  ref dwobject adwo_object,  ref string as_data,  ref datawindow adw_requestor )
end type

type variables
long		il_rowprev
string	is_colprev
string 	is_textprev
integer 	ii_currentindex
private boolean	_ib_autofilter = false

end variables

forward prototypes
public subroutine documentation ()
public subroutine of_setautofilter (boolean ab_autofilter)
end prototypes

event mt_editchanged(ref long al_row, ref dwobject adwo_object, ref string as_data, ref datawindow adw_requestor);/********************************************************************
   mt_editchanged
   <DESC>	Used for autofill search as you type 	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_row       : The number of the row containing the item whose value is being changed.
		adwo_object  : A reference to the column containing the item whose value is being changed.
		as_data      : The current contents of the DataWindow edit control.
		adw_requestor: The current DataWindow edit control.
   </ARGS>
   <USAGE>	Called in the EditChanged event of datawindow </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	09/03/09 	   ?      	  RMO003     First Version
   	06/08/10       ?          AGL027	    Added Filter dropdown as you type functionality
   	30/08/10       ?          AGL027	    Improved functionality
   	07/11/11     CR2531       ZSW001     Improved functionality
   </HISTORY>
********************************************************************/

string	ls_searchcolname, ls_searchtext, ls_findexp, ls_foundtext
string	ls_dddw_displaycol, ls_lines, ls_filter
long		ll_findrow, ll_searchtextlen

datawindowchild	ldwc

// Check requirements.
if isnull(adwo_object) or not isvalid(adwo_object) then return
if adwo_object.edit.style <> "dddw" then return

if isnull(as_data) then as_data = ""

// Get information on the column and text.
ls_searchcolname = adwo_object.name
ls_searchtext = as_data
if al_row = il_rowprev and ls_searchcolname = is_colprev and ls_searchtext = is_textprev then return
ll_searchtextlen = len(ls_searchtext)
ls_dddw_displaycol = adwo_object.dddw.displaycolumn

adw_requestor.getchild(adwo_object.name, ldwc)

/* filter */
if _ib_autofilter then
	if (al_row <> il_rowprev or ls_searchcolname <> is_colprev) and not (al_row = 1 and il_rowprev = 0) then
		ls_filter = ldwc.describe("datawindow.table.filter")
		if len(ls_filter) > 1 then
			ldwc.setfilter("")
			ldwc.filter()
		end if
	elseif ls_searchtext <> is_textprev then
		ldwc.setfilter("lower(" + ls_dddw_displaycol + ") like '" + lower(ls_searchtext) + "%'")
		ldwc.filter()
	end if
end if

if as_data <> "" then
	ls_findexp = "lower(left(" + ls_dddw_displaycol + ", " + &
					 string(ll_searchtextlen) + ")) = '" + lower(ls_searchtext) + "'"
	
	// Perform the Search on the dddw.
	ll_findrow = ldwc.find(ls_findexp, 1, ldwc.rowcount())
	//  if a match was found on the dddw, Set the found text if found on the dddw.
	if ll_findrow > 0 then
		if (al_row = il_rowprev and is_colprev = ls_searchcolname or il_rowprev = 0 and is_colprev = "") and len(ls_searchtext) > len(is_textprev) then
			// Get the text found.
			ls_foundtext =	ldwc.getitemstring(ll_findrow, ls_dddw_displaycol)
			// Set the text.
			adw_requestor.settext(ls_foundtext)
			// Hightlight the portion the user has not actually typed.
			adw_requestor.selecttext(ll_searchtextlen + 1, len(ls_foundtext) - ll_searchtextlen)
		end if
	end if
end if

il_rowprev  = al_row
is_colprev  = ls_searchcolname
is_textprev = ls_searchtext

end event

public subroutine documentation ();/********************************************************************
   ObjectName: mt_n_dddw_searchAsYouType - Drop Down Datawindow Search as you type function
   <OBJECT> This object is used to add search as you type functionality to 
	drop down datawindows. The object is autoinstantiated, and has only
	one event mt_editchanged</OBJECT>
   <DESC>  </DESC>
   <USAGE> 
	declare the object as an instance variable for the datawindow.
	in the editchanged event call the mt_editchanged event using
		- row
		- dwo
		- data
		- and reference to datawindow
		</USAGE>
   <ALSO>   </ALSO>
  Date   		Ref    Author        Comments
  09/03/09 	?      	RMO003     First Version
  06/08/10  ?        AGL027	 Added Filter dropdown as you type functionality
  30/08/10  ?        AGL027	 Improved functionality
  07/11/11  CR2531   ZSW001    Improved functionality
********************************************************************/

end subroutine

public subroutine of_setautofilter (boolean ab_autofilter);_ib_autofilter = ab_autofilter

end subroutine

on mt_n_dddw_searchasyoutype.create
call super::create
TriggerEvent( this, "constructor" )
end on

on mt_n_dddw_searchasyoutype.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

