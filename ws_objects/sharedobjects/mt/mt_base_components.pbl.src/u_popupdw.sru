$PBExportHeader$u_popupdw.sru
$PBExportComments$Used for general popup datawindow functionality
forward
global type u_popupdw from mt_u_datawindow
end type
end forward

global type u_popupdw from mt_u_datawindow
boolean visible = false
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = false
end type
global u_popupdw u_popupdw

type variables
boolean ib_footermessage = false  		/* does text object t_message exist? */
boolean ib_headermessage = false  		/* does text object t_ exist? */
mt_u_datawindow idw_registered 			/* reference to the main datawindow the popup 'belongs to' */
string is_stringarg[] 						/* used to hold string variables that can be used to validate processes, ie. voyage_nr */
long il_longarg[] 							/* used to hold long variables that can be used to validate processes, ie. vessel_nr */
integer ii_maxheight=0, ii_maxwidth=0 	/* set to 0 these properties are disabled.  currently unused.  Not tested */
boolean ib_autoclose = true 				/* use this to auto close datawindow when user moves outside popup, otherwise user
													must click inside window for it to close*/

end variables

forward prototypes
public function long of_getlongarg (integer ai_index)
public function string of_getstringarg (integer ai_index)
public function integer of_registerdw (mt_u_datawindow adw)
public function integer of_setlongarg (integer ai_index, long al_value)
public function integer of_setstringarg (integer ai_index, string as_value)
public subroutine documentation ()
end prototypes

public function long of_getlongarg (integer ai_index);return il_longarg[ai_index]
end function

public function string of_getstringarg (integer ai_index);return is_stringarg[ai_index]
end function

public function integer of_registerdw (mt_u_datawindow adw);idw_registered = adw
return c#return.Success
end function

public function integer of_setlongarg (integer ai_index, long al_value);il_longarg[ai_index] = al_value
return c#return.Success	
end function

public function integer of_setstringarg (integer ai_index, string as_value);is_stringarg[ai_index] = as_value
return c#return.Success	
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_popupdw
	
	<OBJECT>
		An object inherited from mt_u_datawindow to be used as the 
		container for the contents to be shown.
	</OBJECT>
   	<DESC>
		See the port of call list for an example of usage.  This is a supporting
		object to the whole process.
		
		There are 2 options available in the general behaviour of this	object.  
		If ib_autoclose is enabled <default> whenever the mouse falls outside the 
		datawindow the popup should close itself. (leaving the handling to another process) 
		If ib_auoclose is disabled, user must left click on the popup for it to close.
		They are able to click on another record and force the popup to be reset.
	</DESC>
   <USAGE>
		1. Apply over the top of a window/visualuserobject that has a main datawindow
			placed onto it.  
		2. Set the dataobject to this container
		3. Next create supporting events inside the main datawindow.  
			See w_port_of_call_list.dw_port_of_call_list
				a) ue_mousemove()
				b) ue_rbuttondown()
		4. It is possible to store long/string variables inside by using arrays is_stringarg[] and
			il_longarg[].  If working directly with the database, keeping these values can save database hits.
				
	</USAGE>
   	<ALSO>
		otherobjs
		</ALSO>
    	Date   		Ref    			Author   		Comments
  		29/07/11 	cr#2403      	AGL				First Version
		29/07/11    cr#2403			AGL				Added maximum restriction.  Untested!
		01/08/11    cr#2526			AGL				Improved options concerning autoclose.  Also
																changed copy function to be ctrl + left click.
	   02/08/11		cr#2485			LHC010			changed losefocus event
		03/11/11		cr#2528			AGL				fixed bug when user tries to copy header to clipboard instead of comment.
********************************************************************/
end subroutine

event constructor;call super::constructor;if ii_maxheight<>0 and ii_maxheight<this.height then ii_maxheight=this.height
if ii_maxwidth<>0 and ii_maxwidth<this.width then ii_maxwidth=this.width
end event

on u_popupdw.create
call super::create
end on

on u_popupdw.destroy
call super::destroy
end on

event losefocus;call super::losefocus;if ib_footermessage then
	this.object.t_message.visible=0
end if

if this.visible and ib_autoclose then
	this.visible = false
end if
end event

event resize;call super::resize;boolean lb_maxexceeded = false
if not isvalid(idw_registered) then return

if this.height<100 or this.width<100 then
	return
end if


if ii_maxheight <> 0 and this.height > ii_maxheight then 
	lb_maxexceeded=true
	height = ii_maxheight	
end if
if ii_maxwidth <> 0 and this.width > ii_maxwidth then 
	lb_maxexceeded=true
	width = ii_maxwidth	
end if
if lb_maxexceeded then return


if height + 100 > idw_registered.height  then
	height = (idw_registered.height) - 100
elseif height<200 then 
	height = 200
end if
if width + 100 > idw_registered.width then
	width = (idw_registered.width) - 100
elseif width<200 then 
	width = 200
end if	
if this.Describe("comment.type")<>"!" then
	this.object.comment.width = width - 5
end if
end event

event clicked;call super::clicked;string ls_data, ls_columnname
if not keydown(KeyControl!) then
	if not ib_autoclose then
		this.visible = false	
	end if
else
	ls_columnname = dwo.name
	if row>0 then 
		ls_data=this.getitemstring(1,ls_columnname)
		::Clipboard(ls_data)
		if ib_footermessage then
			this.object.t_message.visible=1
		end if
	end if
end if
end event

