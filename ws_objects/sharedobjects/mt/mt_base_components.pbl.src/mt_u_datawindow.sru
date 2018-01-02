$PBExportHeader$mt_u_datawindow.sru
$PBExportComments$Ancestor fro all Datawindow Controlls
forward
global type mt_u_datawindow from datawindow
end type
end forward

global type mt_u_datawindow from datawindow
integer width = 686
integer height = 400
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event type boolean ue_usedefaultbackgroundcolor ( )
event ue_dwrbuttondblck pbm_dwnrbuttondblclk
event ue_dwkeypress pbm_dwnkey
event ue_dwnlbuttonup ( )
event ue_set_column ( )
end type
global mt_u_datawindow mt_u_datawindow

type variables
string	is_dsName
boolean	ib_hasChildren = false
boolean	ib_columntitlesort = false
boolean	ib_multicolumnsort = true
boolean	ib_setdefaultbackgroundcolor
boolean	ib_updatecontinue =false
boolean	ib_sortbygroup = true
boolean  ib_setselectrow = false
boolean  ib_newstandard = false
boolean	ib_usectrl0 = false
boolean	ib_editmaskselect = false
string	is_sortprefix
string   is_hyperlinkshortcut
int      il_mlehyperlinks_startpos
int      il_mlehyperlinks_selectedlen

private string _is_dwoname

public integer ii_redraw

mt_n_dddw_includecurrentvalue inv_dddwincludecurrentvalue
private boolean _ib_dddwincludecurrentvalue, _ib_dw_hasfocus
public u_dddw_search inv_dddwsearch
end variables

forward prototypes
public subroutine documentation ()
public function integer of_showmessage ()
public function integer of_get_selectedvalues (string as_colname, ref string as_ref_string, string as_delimiter)
public function integer of_get_selectedvalues (string as_colname, ref string as_ref_string, string as_delimiter, boolean ab_includenull)
public function string of_getdwoname ()
public function integer of_save_dw_content ()
public function integer of_insert_personal_stamp (string as_stampformat)
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
public function integer of_registerdddw (string as_colname, string as_filterexp)
public function integer of_selectall ()
public function integer of_setnull ()
public subroutine of_editmaskselect ()
public function integer of_set_dddwspecs (boolean ab_enable)
public subroutine of_set_column ()
public function boolean of_get_dddwhasspecs ()
public function integer of_itemchanged ()
end prototypes

event type boolean ue_usedefaultbackgroundcolor();return ib_setdefaultbackgroundcolor

end event

event ue_dwkeypress;/********************************************************************
ue_dwkeypress()

<DESC>
	Key combinations for special features
</DESC>
<RETURN> 
	Long: (not used)
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	standard for pbm_dwnkey event
</ARGS>
<USAGE>
		Ctrl + Period <.> 	: 	apply userid + datetime stamp to column edit field. format >>[AGL027 06/07/13 10:50]: <<
										only works when style is edit & if db column length & column limit > 500 chars
		Ctrl + Comma <,> 		: 	apply userid + date stamp to column edit field. format >>AGL 06/07: <<
										only works when style is edit & if db column length & column limit > 500 chars
		Ctrl + S 				: 	save datawindow content to excel. 
		Ctrl + A					:  select/deselect full text	
		Ctrl + 0					:  clear a number field in a datawindow	
</USAGE>
********************************************************************/
pointer oldpointer 
/* is control key is depressed? */

if keyflags=3 or keyflags=2 then  
	
	CHOOSE CASE key
		CASE KeyPeriod!
			of_insert_personal_stamp("full")
		CASE KeyComma!
			of_insert_personal_stamp("short")
		CASE KeyS!
			oldpointer = setpointer(HourGlass!)
			of_save_dw_content()
			setpointer(oldpointer)
		CASE KeyA!
			of_selectall()	
	END CHOOSE
	
	if ib_usectrl0 and keyflags = 2 and (key = Key0! or key = KeyNumpad0!) then
		of_setnull()
	end if
end if



end event

event ue_dwnlbuttonup();/********************************************************************
  event ue_dwnlbuttonup()
<DESC>   
	if mlehyperlink has been activated this event handles the selected
	text and resets both parameters
</DESC>
<RETURN>
	Long:
		<LI> 0
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	PB standard for dw click event
</ARGS>
<USAGE>
	Use with ue_lbuttondblclk.
</USAGE>
********************************************************************/
if il_mlehyperlinks_startpos <> 0 then
	this.selecttext(il_mlehyperlinks_startpos, il_mlehyperlinks_selectedlen)
	/* reset values */
	il_mlehyperlinks_startpos = 0
	il_mlehyperlinks_selectedlen = 0
end if

end event

event ue_set_column();if this.of_get_dddwhasspecs() then
	this.of_set_column()
end if
end event

public subroutine documentation ();
/********************************************************************
   mt_u_datawindow: mt framework ancestor for datawindow container
	
	<OBJECT>
		inherited from pb datawindow ancester
	</OBJECT>
   <DESC>
		Event Description
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/06/10 	?      	AGL				First Version
	05/09/11		CR2531	   ZSW001			JMC: Merge
	13/09/11		CR2585		AGL				Added multi sort mechanism funcionality
	16/01/13		CR2614		LHC010			Added function:convert the highlight rows into string and seperated by specified delimiter
	00/07/13		CR3254		LHC010			Replace n_string_service
	12/08/13		CR3167		AGL				Added auto-stamp (userid+date+time)
	23/10/13    CR2877      ZSW001         Move functions uf_redraw_on() and uf_redraw_off() from u_datawindow_sqlca
	21/02/14    CR3240UAT   LHG008         Added function of_registerdddw() in the retrieveend event call of_includecurrentvalue()
	16/10/14		CR3760   	AGL027			Added mle hyperlink functionality + select all ctrl+A availability
	25/12/14		CR3796   	LHG008         Fix bug(event doubleclicked)
	16/07/15		CR4119		AGL027			General framework updates. (merged good code outside uo_datawindow into here.)
	03/03/16		CR4291		AGL027			SaveAs shortcut; Allow Shift+Ctrl+S in case Ctrl+S is unavailable
	07/09/16		CR4501		LHG008         Ctrl+0 to clear a number field in a datawindow; Full selection once the editmask field gets focus
	24/03/17		CR4572		XSZ004			Apply latest standard to dddw.
********************************************************************/

end subroutine

public function integer of_showmessage ();/********************************************************************
   of_showmessage
   <DESC>	when occured dberror and need show message to window 	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Noaction, Noaction references.	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	when the asynchronous data update error.	</USAGE>
   <HISTORY>
   	Date       CR-Ref       				Author             Comments
   	06/02/12   CR2535&CR2536            TTY004        First Version
   </HISTORY>
********************************************************************/
if ib_updatecontinue then
	ib_updatecontinue = false
	Messagebox('Update Error','The record has been modified by another application or user since your last retrieval. Update failed. Please refresh to get the latest data.', StopSign!)
	return c#return.success
end if 
return c#return.noaction
end function

public function integer of_get_selectedvalues (string as_colname, ref string as_ref_string, string as_delimiter);/********************************************************************
   of_get_selectedvalues
   <DESC>	Convert the highlight rows into string and seperated by specified delimiter	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_colname:			generate string column name
		as_ref_string: 	return string
		as_delimiter:  	delimiter
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	2013-01-16 ?            LHC010        First Version
   </HISTORY>
********************************************************************/

return of_get_selectedvalues(as_colname, as_ref_string, as_delimiter, false)

end function

public function integer of_get_selectedvalues (string as_colname, ref string as_ref_string, string as_delimiter, boolean ab_includenull);/********************************************************************
   of_get_selectedvalues
   <DESC>	Convert the highlight rows into string and seperated by specified delimiter	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_colname:			generate string column name
		as_ref_string: 	return string
		as_delimiter:  	delimiter
		ab_includenull:	true-> return include 'null' string
   </ARGS>
   <USAGE>		
		col1, col2		  		isselect?
		      <Empty...>		Yes
		1, 	Cargo List		Yes
		2,		Fixture List	No
		3,		Position List	Yes
		
		For exp1
		input: as_colname 		= col1    		
				 as_delimiter 		= ","
				 ab_includenull 	= true
		output: as_ref_string 	= 'null,1,3'
		
		For exp2
		input: as_colname 		= col1			
				 as_delimiter 		= ","
				 ab_includenull 	= false
		output: as_ref_string 	= "1,3"</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	2013-01-16 ?            LHC010        First Version
   </HISTORY>
********************************************************************/

long		ll_findrow, ll_upper
string 	ls_data[], ls_findstring, ls_coltype, ls_value
mt_n_stringfunctions	lnv_string

if isnull(as_colname) or len(as_colname) <= 0 then return c#return.Noaction

ls_coltype = lower(left(this.describe(as_colname + ".coltype"), 4))

ll_findrow = this.getselectedrow(0)

do while ll_findrow > 0 
	ll_upper++
	choose case ls_coltype
		case "long", "numb", "int", "real", "ulon"
			ls_value = string(this.getitemnumber(ll_findrow, as_colname))
		case "deci"
			ls_value = string(this.getitemdecimal(ll_findrow, as_colname))
		case "char"
			ls_value = this.getitemstring(ll_findrow, as_colname)
		case else
			setnull(ls_value)			
	end choose
	
	//true-> return include 'null' string
	if ab_includenull and isnull(ls_value) then ls_value = "null"
	
	ls_data[ll_upper] = ls_value
	
	ll_findrow = this.getselectedrow(ll_findrow)
loop

if upperbound(ls_data) <= 0 then return c#return.NoAction

return lnv_string.of_arraytostring( ls_data, as_delimiter, as_ref_string)

end function

public function string of_getdwoname ();return _is_dwoname
end function

public function integer of_save_dw_content ();/********************************************************************
of_save_dw_content( /*string as_stampformat */)

<DESC>
	save visual datawindow content to excel (includes conputed items)
</DESC>
<RETURN> 
	Integer: 1 Success
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
	called from user event ue_dwkeypress()
</USAGE>
********************************************************************/
n_dataexport lnv_exp
mt_u_datawindow ldw

ldw = this
lnv_exp.of_export(ldw)
return c#return.Success
end function

public function integer of_insert_personal_stamp (string as_stampformat);/********************************************************************
of_insert_personal_stamp( /*string as_stampformat */)

<DESC>
	insert into current data control personal user stamp
</DESC>
<RETURN> 
	Integer: 1 Success
				0 No Action
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	as_stampformat:   full - 		[AGL027 06/07/13 10:50] 
							short -  	AGL 06/07: 
</ARGS>
<USAGE>
	called from user event ue_dwkeypress()
</USAGE>
********************************************************************/

string 	ls_personalstamp			// placeholder for users stamp string
string 	ls_style						// only process edit style not others such as 'dddw' or 'editmask'
string	ls_columntype				// potentially this can be; char(10), datetime, long, number, decimal(10,2) etc
string	ls_dbcolumnlength			// used to extract the numeric value from the column type variable
integer 	li_posindex
long 		ll_presetcolumnlimit		// value obtained from dataobject edit tab, limit property
long 		ll_dbcolumnlength			// the length the dataobject thinks the database column has
constant integer li_MINLIMIT = 500

/* obtain properties from control */
ls_columntype = this.describe(of_getdwoname() +  ".ColType")
ls_style = this.describe(of_getdwoname() + ".Edit.Style")

if (lower(left(ls_columntype,4)) = "char") and (ls_style = "edit") then 	// ignore column types long, datetime, number, decimal etc
	for li_posindex = 1 to len(ls_columntype)  										// extract number for column length */
		if isnumber(mid(ls_columntype,li_posindex,1)) then
			ls_dbcolumnlength+=mid(ls_columntype,li_posindex,1)
		end if	
	next
	ll_dbcolumnlength = long(ls_dbcolumnlength)
	/* validate if we have enough space regarding the database column width */
	if li_MINLIMIT < ll_dbcolumnlength and ll_dbcolumnlength > 0 then
		/* construct personal timestamp string */
		CHOOSE CASE as_stampformat
			CASE "full"	
			ls_personalstamp = "[" + sqlca.userid + " " + string(today(),"dd/mm/yy") + " " + string(now(), "hh:mm") + "]: "
			CASE "short"
			ls_personalstamp = left(sqlca.userid,3) + " " + string(today(),"dd/mm/yy") + ": "
			CASE ELSE
			/* do nothing */
		END CHOOSE			
		/* validate we have enough space in db column to add personal stamp */
		if len(this.gettext()) + len(ls_personalstamp) < ll_dbcolumnlength then
			/* lastly next check if control has additional constraints in dataobject  */
			ll_presetcolumnlimit = long(this.describe(of_getdwoname() + ".Edit.Limit"))
			if (ll_presetcolumnlimit = 0) or (li_MINLIMIT < ll_presetcolumnlimit) then
				this.replacetext(ls_personalstamp) 		// now add personal timestamp to control
				return c#return.Success
			end if	
		end if
	end if
end if

return c#return.NoAction
end function

public subroutine uf_redraw_off ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 

 Function  : uf_redraw_off

 Object     : 
  
 Event	 :  

 Scope     : Object

 ************************************************************************************

 Author    : Martin "Far" Israelsen
   
 Date       : 30/7-96

 Description : Enables nested redraw on/off commands, which otherwise is a problem
		in powerbuilder. This function turns redraw off

 Arguments : none

 Returns   : none

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/
ii_redraw++

this.Setredraw(false)


end subroutine

public subroutine uf_redraw_on ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 

 Function : uf_redraw_on
  
 Object     : 
  
 Event	 :  

 Scope     : Object

 ************************************************************************************

 Author    : Martin "Far" Israelsen
   
 Date       : 30/7-96

 Description : Enables nested redraw on/off commands, which otherwise is a problem
		in powerbuilder. This function turns redraw on

 Arguments : none

 Returns   : none

 Variables :  None

 Other : Will display an error messagebox if nested value is out-of-sync

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/


If ii_redraw > 0 Then 
   ii_redraw --
Else
	MessageBox("Warning", "redraw setting below zero" ,Exclamation!)
End if

If ii_redraw = 0 Then
	this.Setredraw(true)
End if
end subroutine

public function integer of_registerdddw (string as_colname, string as_filterexp);/********************************************************************
   of_registerdddw
   <DESC>	The function use to register dropdown datawindow	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_colname:		master datawindow column name for the dddw.
		as_filterexp:	a string whose value is a boolean expression that you want to use as the filter criterion.  
							The expression will find the data which you want to show in the dropdown.
   </ARGS>
   <USAGE>	Call in window open event.	
				ref: w_veolist.event open()
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author	Comments
		21/02/2014	CR3240UAT	LHG008	First Version
   </HISTORY>
********************************************************************/

integer ll_return

ll_return = inv_dddwincludecurrentvalue.of_registerdddw(this, as_colname, as_filterexp)
if ll_return = c#return.Success then
	_ib_dddwincludecurrentvalue = true
end if

return ll_return
end function

public function integer of_selectall ();
/********************************************************************
<DESC>
	Ctrl-A should toggle selected all/deselected. Cursor moves to end of 
	data when toggled deselected state
</DESC>
<RETURN> 
	Integer: 1 Success
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
	called from user event ue_dwkeypress()
</USAGE>
********************************************************************/
long ll_selectedchars, ll_totalchars

ll_totalchars = len(this.gettext())
ll_selectedchars = this.selectedlength( )

if ll_totalchars<>ll_selectedchars then
	this.selecttext(1, ll_totalchars)
else
	this.selecttext(ll_totalchars +1, 0)	
end if	
return 1
end function

public function integer of_setnull ();/********************************************************************
   of_setnull
   <DESC>	Ctrl+0 to clear a number field in a datawindow	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Tick datawindw properties ib_usectrl0	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		07/09/16 CR4501        LHG008   First Version
   </HISTORY>
********************************************************************/

string ls_columnname, ls_columntype, ls_style, ls_null
long ll_row, ll_null, ll_rtn
dwobject ldwo

if this.describe("DataWindow.ReadOnly") = 'yes' then return ll_rtn

setnull(ll_null)
setnull(ls_null)

ll_row = this.getrow()
ls_columnname = this.getcolumnname()
if ll_row <= 0 or isnull(ls_columnname) or ls_columnname = '' then return ll_rtn

ls_columntype = lower(left(this.describe(ls_columnname +  ".coltype"), 5))
ls_style = this.describe(ls_columnname + ".edit.style")

//Check if column is displayOnly/readonly
if ls_style = "edit" or ls_style = "editmask" then
	if ls_style = "edit" then
		if this.describe(ls_columnname + ".edit.displayonly") = 'yes' then return ll_rtn
	else //if ls_style = "editmask" then
		if this.describe(ls_columnname + ".edit.readonly") = 'yes' then return ll_rtn
	end if
	
	choose case  ls_columntype
		case 'numbe', 'real', "decim", 'long', 'ulong'
			ll_rtn = this.setitem(ll_row, ls_columnname, ll_null)
	end choose
end if

//Trigger itemchanged event, make some validation effective 
if ll_rtn = 1 then
	ldwo = this.object.__get_attribute(ls_columnname, false)
	this.event itemchanged(ll_row, ldwo, ls_null)
end if

return ll_rtn
end function

public subroutine of_editmaskselect ();/********************************************************************
   of_editmaskselect
   <DESC>	Full selection once the editmask field gets focus(Now the only type is number)	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Tick datawindw properties ib_editmaskselect	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		08/09/16 CR4501        LHG008   First Version
   </HISTORY>
********************************************************************/

string ls_style, ls_columntype

ls_style = this.describe(getcolumnname() + ".edit.style")

if ls_style = "editmask" then
	
	ls_columntype = lower(left(this.describe(getcolumnname() +  ".coltype"), 4))
	choose case  ls_columntype
		case 'numb', 'real', "deci", 'long', 'ulon'
			this.selecttext(1, 30)
	end choose
end if

end subroutine

public function integer of_set_dddwspecs (boolean ab_enable);/********************************************************************
   of_set_dddwspecs
   <DESC> Create or destroy serarch service for dddw </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_enable:Use dddw specifications, true
					 Not use dddw specifications, false
   </ARGS>
   <USAGE>	
		Call in window open event.	
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author	Comments
		27/03/2017	CR4572		XSZ004	First Version
   </HISTORY>
********************************************************************/

if ab_enable then
	if not isvalid(inv_dddwsearch) then
		inv_dddwsearch = create u_dddw_search
	end if
	
	inv_dddwsearch.of_set_datawindow(this)
else
	if isvalid(inv_dddwsearch) then
		destroy inv_dddwsearch
	end if
end if

return c#return.Success



end function

public subroutine of_set_column ();/********************************************************************
   of_set_column
   <DESC> Set column when datawindow lose focus </DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
		Call in datawindow ue_set_column event 
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		27/03/17		XSZ004		CR4572		Firsst version
   </HISTORY>
********************************************************************/

if _ib_dw_hasfocus = false then
	this.setcolumn(this.getcolumn())
end if
end subroutine

public function boolean of_get_dddwhasspecs ();/********************************************************************
   of_get_dddwhasspecs
   <DESC> </DESC>
   <RETURN>	boolean	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		27/03/17		XSZ004		CR4572		Firsst version
   </HISTORY>
********************************************************************/

boolean lb_return

lb_return = false

if isvalid(inv_dddwsearch) then
	if inv_dddwsearch.of_get_dddwspecsflag() then
		lb_return = true
	end if
end if

return lb_return
end function

public function integer of_itemchanged ();/********************************************************************
   of_itemchanged
   <DESC> Handles itemchanged for dddw </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
		Call in datawindow itemchanged event 
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		27/03/17		XSZ004		CR4572		Firsst version
   </HISTORY>
********************************************************************/

int li_return

li_return = c#return.success

if this.of_get_dddwhasspecs() then
	
	li_return = inv_dddwsearch.of_itemchanged(false)
	
	if li_return = 1 then
		li_return = c#return.failure
	else
		li_return = c#return.success
	end if
end if

return li_return
end function

on mt_u_datawindow.create
end on

on mt_u_datawindow.destroy
end on

event dberror;n_error_service 		lnv_error
n_service_manager 	lnv_SrvMgr
string 					ls_userfriendlymessage, err_type
constant string METHOD = "dberror"

lnv_SrvMgr.of_loadservice( lnv_error, "n_error_service")
choose case sqldbcode
	case -3 
		ls_userfriendlymessage="The record has been modified by another application or user since your last retrieval. Update failed. Please refresh to get the latest data."
		ib_updatecontinue = true
	case 229
		ls_userfriendlymessage="You do not have access to this Functionality!"
	case 233
		ls_userfriendlymessage="Please populate the mandatory fields before updating!"
	case 546
		ls_userfriendlymessage="You are using a value that does not exist in the system! This is probably a drop down list box you have written a wrong value/string in!"
	case 547
		ls_userfriendlymessage="There is a constraint stopping the system completing this task"
	case 2601
		ls_userfriendlymessage="Can not make change as the record is a duplicate"
	case 30006
		ls_userfriendlymessage="Dependent data exists on what you are deleting! This operation cannot be performed. For example, you maybe deleting a system type that is used elsewhere in the system"			
	case else
		lnv_error.of_dblogging( true )
		ls_userfriendlymessage=string(sqldbcode) + ":Something unexpected has occured.  We have logged the error in the database"
end choose

choose case buffer
	case delete!
		err_type = "Deleting row " + string(row)
	case primary!
		choose case this.getItemstatus(row, 0, buffer)
			Case New!, newmodified!
				err_type = "Inserting row " + string(row)
			Case Else
				err_type = "Updating row " + string(row)
		End choose
end choose

lnv_error.of_addmsg(this.classdefinition, METHOD, ls_userfriendlymessage, "(sqlerrtext=" + sqlerrtext + ")(dbcode=" + string(sqldbcode)+ ")(info=" + err_type + ")" , 2)

return 3

end event

event sqlpreview;if isValid(w_sqlsyntax_spy) then
	n_service_manager  lnv_service
	n_dw_spy_service		lnv_spy
	lnv_service.of_loadservice( lnv_spy , "n_dw_spy_service")
	lnv_spy.of_addMonitorDetail(classdefinition, "sqlpreview", sqlsyntax)
end if

end event

event retrievestart;n_service_manager  lnv_service
n_dw_spy_service		lnv_spy

if isValid(w_sqlsyntax_spy) then
	lnv_service.of_loadservice( lnv_spy , "n_dw_spy_service")
	lnv_spy.of_addMonitorDetail(classdefinition, "sqlpreview", "Retrieve START " &
																				+ string(now(), "HH:mm:ss:fff") &
																				+ " Dataobject = '" + this.dataObject +"'" )
end if

if _ib_dddwincludecurrentvalue then
	uf_redraw_off()
end if
end event

event retrieveend;if isValid(w_sqlsyntax_spy) then
	n_service_manager  lnv_service
	n_dw_spy_service		lnv_spy
	lnv_service.of_loadservice( lnv_spy , "n_dw_spy_service")
	lnv_spy.of_addMonitorDetail(classdefinition, "sqlpreview", "Retrieve END "+ string(now(), "HH:mm:ss:fff")+ " Rows retrieved = "+string(rowcount) )
end if

if _ib_dddwincludecurrentvalue then
	inv_dddwincludecurrentvalue.of_includecurrentvalue(this)
	uf_redraw_on()
end if
end event

event clicked;/********************************************************************
  event clicked()
<DESC>   
	Apply basic sort on single column level
</DESC>
<RETURN>
	Long:
		<LI> 0
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	PB standard for dw click event
</ARGS>
<USAGE>
	if property ib_columntitlesort is true apply.  Column headers must have column name of 
	referenced detail in addition to postfix of "_t".  
	ie column 'vessel_id' has a header text control of 'vessel_id_t'.
</USAGE>
********************************************************************/
n_service_manager	lnv_servmgr
n_dw_sort_service		lnv_sort
mt_u_datawindow 	ldw

if ib_columntitlesort then
	/* trigger only if user clicks on header row */
	if row = 0 then
		ldw=this
		lnv_servmgr.of_loadService(lnv_sort, "n_dw_sort_service")
		lnv_sort.ib_sortbygroup = ib_sortbygroup
		lnv_sort.ib_newstandard = ib_newstandard
		
		if ib_multicolumnsort and KeyDown ( KeyControl! ) then
			lnv_sort.of_advancedheadersort(ldw, row, dwo,ib_setselectrow)
		else
			lnv_sort.of_headersort(ldw, row, dwo,ib_setselectrow)
		end if
		return
	end if
end if

end event

event itemfocuschanged;int li_return
boolean lb_dddwspecsflag

_is_dwoname = dwo.name

if ib_editmaskselect then of_editmaskselect()

if isvalid(inv_dddwsearch) then
	
	if this.describe(_is_dwoname + ".edit.style") = "dddw" then
		
		li_return = inv_dddwsearch.of_get_dddwspecs(_is_dwoname)
		
		if li_return = c#return.success then
			lb_dddwspecsflag = true
		else
			lb_dddwspecsflag = false
		end if
	else
		lb_dddwspecsflag = false
	end if
	
	inv_dddwsearch.of_set_dddwspecsflag(lb_dddwspecsflag)
end if
end event

event doubleclicked;n_open_urloremail n_link

if isvalid(dwo) then
	n_link.of_open_urloremail(is_hyperlinkshortcut, dwo.name, this)
end if
end event

event getfocus;if ib_editmaskselect then of_editmaskselect()

_ib_dw_hasfocus = true
end event

event itemchanged;int li_return

li_return = this.of_itemchanged()

if li_return = c#return.failure then
	return 2
else
	return 0
end if
end event

event editchanged;if this.of_get_dddwhasspecs() then
	inv_dddwsearch.uf_editchanged()
end if	

end event

event losefocus;_ib_dw_hasfocus = false

this.post event ue_set_column()


end event

event destructor;of_set_dddwspecs(false)
end event

event itemerror;if this.of_get_dddwhasspecs() then
	return 3
else
	return 0
end if
end event

