$PBExportHeader$u_vessel_selection.sru
forward
global type u_vessel_selection from mt_u_visualobject
end type
type st_criteria from statictext within u_vessel_selection
end type
type dw_vessel from mt_u_datawindow within u_vessel_selection
end type
type gb_1 from groupbox within u_vessel_selection
end type
end forward

global type u_vessel_selection from mt_u_visualobject
integer width = 1225
event ue_itemchanged ( integer vessel_nr )
st_criteria st_criteria
dw_vessel dw_vessel
gb_1 gb_1
end type
global u_vessel_selection u_vessel_selection

type variables
datawindow				idw_caller
w_vessel_basewindow	iw_caller
integer					ii_previous_vessel
private integer		_ii_pcnr=0

mt_n_dddw_searchasyoutype inv_dropDownSearch


end variables

forward prototypes
public function integer of_registerdw (ref datawindow adw_caller)
public subroutine of_setcurrentvessel (integer ai_vessel)
private subroutine documentation ()
public subroutine of_setshowtext ()
private subroutine of_generateshowtext ()
public subroutine of_setpreviousvessel ()
public function string of_get_vessels_nr ()
public function integer of_getvesselpc ()
public function integer of_registerwindow (ref powerobject apo_caller)
end prototypes

event ue_itemchanged(integer vessel_nr);/********************************************************************
   ue_itemchanged
   <DESC>when input vessel or empty vessel then triggered event ue_itemchanged</DESC>
   <RETURN>	(None):
            </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		vessel_nr
   </ARGS>
   <USAGE>dw_vessel.itemchanged</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	24-05-2013 CR3238       LHC010        First Version
   </HISTORY>
********************************************************************/
end event

public function integer of_registerdw (ref datawindow adw_caller);/********************************************************************
	of_registerdw
	<DESC>   
	Used to register the datawindow that shall have the ue_retrieve 
	event triggered when the vessel selection is made</DESC>
	<RETURN> Integer:
				<LI> 1, X ok
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Public</ACCESS>
	<ARGS>	adw_caller: reference to datawindow</ARGS>
	<USAGE>
	Call this function if you need the vessel selection to trigger
	a DW event</USAGE>
********************************************************************/
idw_caller = adw_caller

return 1
end function

public subroutine of_setcurrentvessel (integer ai_vessel);/********************************************************************
	of_setcurrentvessel
	<DESC>   
	This function is called to set current vessel. Typically used when
	a new window is opened and there already been selected a vessel</DESC>
	<RETURN> NONE </RETURN>
	<ACCESS>	Public</ACCESS>
	<ARGS>	ai_vessel: Current vessel number</ARGS>
********************************************************************/
datawindowchild	ldwc
long					ll_found

if ai_vessel < 1 then return
dw_vessel.getchild( "vessel_ref_nr", ldwc )
ll_found = ldwc.find("vessel_nr="+string(ai_vessel), 0, 9999999)
if ll_found < 1 then return
dw_vessel.setItem(1, "vessel_ref_nr", ldwc.getItemString(ll_found, "vessel_ref_nr"))
dw_vessel.event itemchanged(1, dw_vessel.object.vessel_ref_nr, ldwc.getItemString(ll_found, "vessel_ref_nr"))

end subroutine

private subroutine documentation ();/********************************************************************
	Object Name: u_vessel_selection - This object is used to select vessels
	
	<OBJECT> 
	This object is a visual object that is used on almost all windows 
	where the user can select a vessel. Encapsulated in this object is
	functionality to filter out vessels that are not needed for selection.
	These filter functions are user specific.
	This object also handles the access rights, so that external users
	are only allowed to select vessels from restricted list</OBJECT>
	
	<USAGE>  
	Object is very easy to use:
	1) Place control on the window
	2a) Register a datawindow that will be triggered from the selection.
		 dw.ue_retrieve_vessel(vessel_nr) will be triggered </USAGE>
	or
	2b) Register a window that will be triggered from the selection.
		 window.ue_vesselselection(vessel_nr) will be triggered
	3) If needed the function of_setCurerntVessel(vessel_nr) can be 
		triggered.
	
	<ALSO>   
	This object is dependant on w_share, where the datawindows with
	allowed vessels are stored (buffered)</ALSO>
	
	Date   		Ref			Author				Comments
	12/11/07						Regin Mortensen	First Version
	14/06/11		CR2406		CMY014				Second Version
	11/07/11		CR2408		LHC010				add function of_get_vessel_nr
	24/11/11		D3-1			AGL027				Allow access to current vessel profit center number
	22-11-2012	CR2582		LHC010				Differentiate vessels filter selection in MVV
	24-05-2013  CR3238		LHC010				Add event ue_itemchanged for VC's window
	29/07/2013	CR3167		AGL027				Undocumented option to jump to the vessel system table on CTRL-O key depressed
	13/08/2013	CR2889		AGL027				Solved control of this vessel obect
	18-10-2013	CR3340		LHC010				Differentiate vessels filter selection in VC
	03-01-2014  CR3240		XSZ004				Same vessel filter selection as in VC for Alerts view and Rules configuration
	04-08-2014 	CR3708		AGL027				F1 help application coverage - of_registerwindow() use a powerobject parameter
	17-09-2014	CR3708		CCY018				Modified function of_registerwindow, fixed a bug.
	20/09-2014	CR3833		AZX004				Fix the select vessel filters display
********************************************************************/
end subroutine

public subroutine of_setshowtext ();string ls_classname

of_generateshowtext( )

if isvalid(iw_caller) then
	ls_classname = classname(iw_caller)
	choose case ls_classname
		case "w_port_of_call_list"
			st_criteria.text = uo_global.is_mvv_showtext
		case "w_msps_messages_list", "w_rules_configuration", "w_alerts_view"
			st_criteria.text = uo_global.is_vc_showtext
		case else
			st_criteria.text = uo_global.is_showtext
	end choose	
else
	st_criteria.text = uo_global.is_showtext
end if
end subroutine

private subroutine of_generateshowtext ();/********************************************************************
	of_generateshowtext( )
	<DESC>This function set the filters on vessel selection boxes, 
	and generates the highlighted text that is shown above the vessel 
	selection boxes.
	The text variable is saved in a global object for easier access
	from other windows.</DESC>
	<RETURN>(None)</RETURN>
	<ACCESS> 
	Private</ACCESS>
	<ARGS>(no arguments)</ARGS>
	<USAGE>Only used internally by the metods in this object</USAGE>
	History:
	22-11-2012	CR2582		 LHC010				 Differentiate vessels filter selection in MVV
	18-10-2013	CR3340		 LHC010				 Differentiate vessels filter selection in VC
	03-01-2014  CR3240		 XSZ004				 Same vessel filter selection as in VC for Alerts view and Rules configuration
********************************************************************/
string 	ls_filter, ls_returntext, ls_classname
long		ll_rows, ll_row, ll_rowcount
integer	li_vesselnumber[], li_vesselfilterstatus
boolean	lb_ismvv_window, lb_isvc_window

if isvalid(iw_caller) then
	ls_classname = classname(iw_caller)
	choose case ls_classname
		case "w_port_of_call_list"
			lb_ismvv_window = true
		case "w_msps_messages_list", "w_alerts_view", "w_rules_configuration"
			lb_isvc_window = true
	end choose
end if

if isvalid(w_share) then	
	if lb_ismvv_window then
		li_vesselnumber = uo_global.ii_mvv_vesselnumber
		li_vesselfilterstatus = uo_global.ii_mvv_vesselfilterstatus
	elseif lb_isvc_window then
		li_vesselnumber = uo_global.ii_vc_vesselnumber
		li_vesselfilterstatus = uo_global.ii_vc_vesselfilterstatus
	else
		li_vesselnumber = uo_global.ii_vesselnumber			
		li_vesselfilterstatus = uo_global.ii_vesselfilterstatus
	end if
	
	//Get vessel filter list
	ll_rows = upperbound(li_vesselnumber)
	for ll_row = 1 to ll_rows
		if ll_row = 1 then
			ls_filter += " vessel_nr in ("+string(li_vesselnumber[ll_row])
		else
			ls_filter += ", "+string(li_vesselnumber[ll_row])
		end if
	next
	if upperbound(li_vesselnumber) > 0 then
		ls_filter +=")"
	else
		ls_filter += " vessel_nr in (9999999)"
	end if
	
	w_share.dw_sq_tb_dddw_vesselnr_selection.setFilter("")
	w_share.dw_sq_tb_dddw_vesselnr_selection.Filter()
	w_share.dw_sq_tb_dddw_vesselname_selection.setFilter("")
	w_share.dw_sq_tb_dddw_vesselname_selection.Filter()
	
	ll_rowcount  = w_share.dw_sq_tb_dddw_vesselname_selection.rowcount()
	if (li_vesselfilterstatus = 1 or li_vesselfilterstatus = 0) then
		//When add a new vessel to a profit center that the current user has access to, status should be changed to "Filter Active"
		if ll_rows = ll_rowcount then
			ls_returntext += "All Vessels" +  " (" + string(ll_rows) + "/" + string(ll_rowcount) + ")"
		else
			ls_returntext += "Filter Active" +  " (" + string(ll_rows) + "/" + string(ll_rowcount) + ")"
		end if
	elseif (li_vesselfilterstatus = 2) then
		ls_returntext += "My Vessels" +  " (" + string(ll_rows) + "/" + string(ll_rowcount) + ")"
	else
		ls_returntext = "Filter Active(0/0)"
	end if
	
	w_share.dw_sq_tb_dddw_vesselnr_selection.setFilter(ls_filter)
	w_share.dw_sq_tb_dddw_vesselnr_selection.Filter()
	w_share.dw_sq_tb_dddw_vesselname_selection.setFilter(ls_filter)
	w_share.dw_sq_tb_dddw_vesselname_selection.Filter()
end if			
			
if lb_ismvv_window then
	uo_global.is_mvv_showtext = ls_returntext		
elseif lb_isvc_window then
	uo_global.is_vc_showtext = ls_returntext		
else
	uo_global.is_showtext = ls_returntext		
end if


end subroutine

public subroutine of_setpreviousvessel ();/********************************************************************
	of_setpreviousvessel
	<DESC>   
	This function is called to reset vessel selection. This typically 
	is the case if the user changes vessel, and there where data not 
	saved. If save failes the vessel change must not take place.</DESC>
	<RETURN> NONE </RETURN>
	<ACCESS>	Public</ACCESS>
	<ARGS>	NONE </ARGS>
********************************************************************/
datawindowchild	ldwc
long					ll_found

dw_vessel.getchild( "vessel_ref_nr", ldwc )
ll_found = ldwc.find("vessel_nr="+string(ii_previous_vessel), 0, 9999999)
if ll_found < 1 then return 
dw_vessel.setItem(1, "vessel_ref_nr", ldwc.getItemString(ll_found, "vessel_ref_nr"))
dw_vessel.setItem(1, "vessel_name", ldwc.getItemString(ll_found, "vessel_name"))
uo_global.setVessel_nr( ii_previous_vessel )




end subroutine

public function string of_get_vessels_nr ();/********************************************************************
   of_get_vessels_nr
   <DESC>	get many vessel_nr or one vessel_nr from dropwindow or input vessel_ref_nr </DESC>
   <RETURN>	string:</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		n/a
   </ARGS>
   <USAGE>	ue_retrieve	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author            Comments
   	11-07-2011 2408         LHC010	       	First Version
		13-01-2012 cr20			LHC010				Fix bug: if vessel number = 0,return 0
   </HISTORY>
********************************************************************/
string	ls_vessel_nrs, ls_vessel_ref_nr
integer	li_vessel_nr, li_rowcount, li_findrow, i
datawindowchild	ldwc_vessels

li_vessel_nr = -1

dw_vessel.getchild("vessel_ref_nr", ldwc_vessels)
li_rowcount = ldwc_vessels.rowcount()

if li_rowcount <= 0 or isnull(li_rowcount) then return ls_vessel_nrs

ls_vessel_ref_nr = dw_vessel.getitemstring(1, "vessel_ref_nr")

li_findrow = ldwc_vessels.find( "vessel_ref_nr = '" + ls_vessel_ref_nr + "'", 1, li_rowcount)

if li_findrow > 0 then
	li_vessel_nr = ldwc_vessels.getitemnumber(li_findrow, "vessel_nr")
end if

//If selection one vessel return vessel number
if li_vessel_nr >= 0 then
	ls_vessel_nrs = string(li_vessel_nr)
	return ls_vessel_nrs
end if

//If you do not choose to return dropwindow in all vessel number
for i = 1 to li_rowcount
	if len(ls_vessel_nrs) = 0 or isnull(ls_vessel_nrs) then
		ls_vessel_nrs = string(ldwc_vessels.getitemnumber(i, "vessel_nr"))
	else
		ls_vessel_nrs += "," + string(ldwc_vessels.getitemnumber(i, "vessel_nr"))
	end if
next

return ls_vessel_nrs
end function

public function integer of_getvesselpc ();return _ii_pcnr
end function

public function integer of_registerwindow (ref powerobject apo_caller);/********************************************************************
	of_registerwindow
	<DESC>   
	Used to register the window that shall have the ue_vesselselection 
	event triggered when the vessel selection is made</DESC>
	<RETURN> Integer:
				<LI> 1, X ok
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Public</ACCESS>
	<ARGS>	aw_caller: reference to window</ARGS>
	<USAGE>
	Call this function if you need the vessel selection to trigger
	a WINDOW event</USAGE>
********************************************************************/

classdefinition cd_ancestorwindef
string ls_ancestorname

if apo_caller.typeof() = Window! then
	cd_ancestorwindef = apo_caller.classdefinition
	ls_ancestorname = cd_ancestorwindef.ancestor.name
	choose case ls_ancestorname
		case "w_tramos_container_vessel", "w_vessel_basewindow", "w_vessel_response"
			iw_caller = apo_caller			
		case else 
			// messagebox("Unexpected ancestor object of window",ls_ancestorname)
	end choose		
end if	

return 1
end function

on u_vessel_selection.create
int iCurrent
call super::create
this.st_criteria=create st_criteria
this.dw_vessel=create dw_vessel
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_criteria
this.Control[iCurrent+2]=this.dw_vessel
this.Control[iCurrent+3]=this.gb_1
end on

on u_vessel_selection.destroy
call super::destroy
destroy(this.st_criteria)
destroy(this.dw_vessel)
destroy(this.gb_1)
end on

type st_criteria from statictext within u_vessel_selection
integer x = 600
integer width = 569
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 67108864
string text = "Filter Active"
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;string ls_classname

if isvalid(iw_caller) then
	ls_classname = classname(iw_caller)
end if

openwithparm(w_vessel_selection_options, ls_classname)

end event

type dw_vessel from mt_u_datawindow within u_vessel_selection
integer x = 41
integer y = 92
integer width = 1147
integer height = 88
integer taborder = 20
string dataobject = "d_sq_tb_vessel_selection"
boolean border = false
boolean livescroll = false
boolean ib_multicolumnsort = false
end type

event itemchanged;call super::itemchanged;datawindowchild	ldwc
string				ls_refnumber, ls_vessel
integer				li_vessel
long					ll_found

choose case dwo.name
	case "vessel_ref_nr"
		this.getchild( "vessel_ref_nr", ldwc )
		ll_found = ldwc.find("vessel_ref_nr='"+data+"'", 0, 9999999)
		if ll_found < 1 then return 1
		this.setItem(1, "vessel_name", ldwc.getItemString(ll_found, "vessel_name"))
	case "vessel_name"
		this.getchild( "vessel_name", ldwc )
		ll_found = ldwc.find("vessel_name='"+data+"'", 0, 9999999)
		if ll_found < 1 then return 1
		this.setItem(1, "vessel_ref_nr", ldwc.getItemString(ll_found, "vessel_ref_nr"))
end choose

li_vessel = ldwc.getItemNumber(ll_found, "vessel_nr")
_ii_pcnr = ldwc.getItemNumber(ll_found, "pc_nr")

parent.post event ue_itemchanged(li_vessel)

if not isNull(li_vessel) then
	ii_previous_vessel = uo_global.GetVessel_Nr( )
	uo_global.SetVessel_Nr(li_vessel)
	f_existsDemurrageAccount(li_vessel)

	if isValid(idw_caller) then
		idw_caller.dynamic post event ue_retrieve_vessel(li_vessel)
	elseif isValid(iw_caller) then
		iw_caller.dynamic post event ue_vesselselection(li_vessel)
	end if
end if

end event

event editchanged;call super::editchanged;if isvalid(inv_dropDownSearch) then
	inv_dropDownSearch.event mt_editchanged(row, dwo, data, dw_vessel)
end if
end event

event constructor;call super::constructor;datawindowchild	ldwc

this.insertRow(0)
this.getchild( "vessel_ref_nr", ldwc)
uf_sharechild("D_SQ_TB_DDDW_VESSELNR_SELECTION", ldwc)

this.getchild( "vessel_name", ldwc)
uf_sharechild("D_SQ_TB_DDDW_VESSELNAME_SELECTION", ldwc)

end event

event doubleclicked;call super::doubleclicked;/********************************************************************
	event doubleclick()
	
	<DESC> 
		user can access vessel selected config window by doubleclicking 
		mouse while depressing ALT key
	</DESC>
	<RETURN> n/a
	<ACCESS> 
	Public</ACCESS>
	<ARGS>standard doubleclick() event</ARGS>
	<USAGE></USAGE>
********************************************************************/
long ll_foundrow
integer li_retval

if keydown(KeyAlt!) then
	if dw_vessel.getitemstring(1, "vessel_ref_nr")="" or isnull(dw_vessel.getitemstring(1, "vessel_ref_nr")) then 
		return
	end if	
	if isvalid(w_vessel) then
		w_vessel.bringtotop=true
		w_vessel.event ue_pcchanged(999,li_retval)
		if li_retval=c#return.Failure then
			return
		end if
		w_vessel.uo_pc.of_setcurrentpc(999)
	else
		opensheet(w_vessel,w_tramos_main,7,Original!)
	end if
	ll_foundrow = w_vessel.dw_list.find("vessel_ref_nr='" + dw_vessel.getitemstring(1, "vessel_ref_nr") + "'",1,10000)
	
	if ll_foundrow>0 then
		w_vessel.dw_list.scrolltorow(ll_foundrow)
		w_vessel.dw_list.event clicked(0,0,ll_foundrow, w_vessel.dw_list.object)
	end if
end if	
end event

event ue_dwkeypress;call super::ue_dwkeypress;/********************************************************************
	event ue_dwkeypress()
	
	<DESC> 
		Force the correct vessel data to be accepted when the enter key
		is pressed.
		user can access vessel selected config window clicking Ctrl+O
	</DESC>
	<RETURN> n/a
	<ACCESS> 
	Public</ACCESS>
	<ARGS>standard pbm_dwnkey() event</ARGS>
	<USAGE></USAGE>
********************************************************************/
long ll_foundrow
integer li_retval

if key = KeyEnter! then
	this.accepttext()
   return 1
end if
if keyflags=2 then  
	CHOOSE CASE key
		CASE KeyO!
			if dw_vessel.getitemstring(1, "vessel_ref_nr")="" or isnull(dw_vessel.getitemstring(1, "vessel_ref_nr")) then 
				return
			end if	
			if isvalid(w_vessel) then
				w_vessel.bringtotop=true
				w_vessel.event ue_pcchanged(999,li_retval)
				if li_retval=c#return.Failure then
					return
				end if
				w_vessel.uo_pc.of_setcurrentpc(999)
			else
				opensheet(w_vessel,w_tramos_main,7,Original!)
			end if
			ll_foundrow = w_vessel.dw_list.find("vessel_ref_nr='" + dw_vessel.getitemstring(1, "vessel_ref_nr") + "'",1,10000)
			if ll_foundrow>0 then
				w_vessel.dw_list.scrolltorow(ll_foundrow)
				w_vessel.dw_list.event clicked(0,0,ll_foundrow, w_vessel.dw_list.object)
			end if
	CASE ELSE
		// do nothing
	END CHOOSE		
end if		
end event

type gb_1 from groupbox within u_vessel_selection
integer x = 14
integer width = 1198
integer height = 208
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Select Vessel"
end type

