$PBExportHeader$w_port_of_call_list.srw
$PBExportComments$Lists all ports of call for a vessel.
forward
global type w_port_of_call_list from w_tramos_container_vessel
end type
type dw_port_of_call_list from mt_u_datawindow within w_port_of_call_list
end type
type cb_print from commandbutton within w_port_of_call_list
end type
type cb_refresh from commandbutton within w_port_of_call_list
end type
type st_rows from mt_u_statictext within w_port_of_call_list
end type
type st_allest_lastact from mt_u_statictext within w_port_of_call_list
end type
type em_last_actual_voyages from mt_u_editmask within w_port_of_call_list
end type
type st_topbar_background from u_topbar_background within w_port_of_call_list
end type
type dw_commentpopup from u_popupdw within w_port_of_call_list
end type
end forward

global type w_port_of_call_list from w_tramos_container_vessel
integer x = 0
integer y = 0
integer width = 5888
integer height = 2984
string title = "Multiple Vessel View"
string icon = "images\mvv.ico"
boolean ib_setdefaultbackgroundcolor = true
dw_port_of_call_list dw_port_of_call_list
cb_print cb_print
cb_refresh cb_refresh
st_rows st_rows
st_allest_lastact st_allest_lastact
em_last_actual_voyages em_last_actual_voyages
st_topbar_background st_topbar_background
dw_commentpopup dw_commentpopup
end type
global w_port_of_call_list w_port_of_call_list

type variables
long	il_select_row //Added by LHC010 on 23-05-2011. Change desc: select row

constant integer ii_VESSELNR = 1
constant integer ii_PCN = 2
constant integer ii_VOYAGENR = 1
constant integer ii_PORTCODE = 2
constant integer ii_COLUMNNAME = 3

boolean ib_ignoredefaultbutton




end variables

forward prototypes
public subroutine documentation ()
private function long _getheaderrow ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_port_of_call_list
   <OBJECT>	Ancestor object to w_tramos_container_vessel	</OBJECT>
   <USAGE> n/a </USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
		Date      	Ref    	Author   		Comments
		00/00/07  	?     	Name Here		First Version
		28/10-10  	2165  	RMO003   		This window now inherits from our framework (m_w_sheet)
		15-05-2011	2408  	LHC010   		set the window to the same default size as the Cargo/Fixture List window.
		20-05-2011	2408  	LHC010   		Double-clicking related columns in POC List will open Port of Call or Proceeding or Cargo
		22-05-2011	2408  	LHC010   		adjust Port of Call list
		25-07-2011	2408  	AGL028   		Fix: Double click on datawindow: "parent.bringtotop = false" deleted
		10-08-2011	2408  	JMC112   		Fix: Double click on datawindow: "parent.bringtotop = false" deleted in cargo
		10-08-2011	2408  	JMC112   		Change to post ue_retrieve event.
		01-09-2011	2530  	LGX001   		Add the shortcut keys
		02-09-2011	2528  	LHC010   		remove 'Nom.' and 'LOI',add 'Tasks'
		25-10-2011	cr2536&2535 LHC010		Add steaming time
		04-08-2014	CR3708	AGL027   		F1 help application coverage - change of ancestor
		01/09/2014	CR3781	CCY018   		The window title match with the text of a menu item
		12/09/14  	CR3773	XSZ004   		Change icon absolute path to reference path
		21/11/14		CR3708	CCY018			Change menu "m_tramosmain" to "m_helpmain"
   </HISTORY>
********************************************************************/
end subroutine

private function long _getheaderrow ();string 	ls_obj, ls_name
string 	ls_band
long 		ll_row = 0

ls_band = dw_port_of_call_list.GetBandAtPointer()
if Left( ls_band, Pos( ls_band, "~t") - 1 ) <> "header" then
	ls_obj = dw_port_of_call_list.GetObjectAtPointer()
	ls_name = Left( ls_obj, Pos( ls_obj, "~t") - 1 ) 
	ll_row = Long( Right( ls_obj, Len( ls_obj ) - Pos( ls_obj, "~t") ) ) 	
end if

return ll_row
end function

event open;call super::open;dw_port_of_call_list.SetTrans(SQLCA)
dw_commentpopup.insertrow(0)

uo_vesselselect.of_registerwindow( w_port_of_call_list )
/*
bypass usual vessel selection opening process
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
*/
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

post triggerevent("ue_retrieve")

//LHC010: need to be removed when the new layout uo_vesselselect is ready
uo_vesselselect.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.st_criteria.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.st_criteria.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.dw_vessel.Object.DataWindow.Color = string(c#color.MT_LISTHEADER_BG)

this.menuid.dynamic mf_setcalclink(dw_port_of_call_list, "vessel_nr", "voyage_nr", True)

end event

event ue_retrieve;call super::ue_retrieve;integer	li_last_actual_voyages, li_rowcount,li_pos
string	ls_vessel_nrs
datawindowchild	ldwc_vessels

//CR2408 Added by LHC010 on 10-05-2011. Change desc: Get one or more vessel number separated by commas.
ls_vessel_nrs = uo_vesselselect.of_get_vessels_nr()

li_pos = pos(ls_vessel_nrs, ',')

if li_pos > 0 or len(ls_vessel_nrs) <= 0 or isnull(ls_vessel_nrs) then 
	uo_vesselselect.dw_vessel.setitem( 1, "vessel_ref_nr", "")
	uo_vesselselect.dw_vessel.setitem( 1, "vessel_name","")
end if

uo_vesselselect.dw_vessel.getchild("vessel_ref_nr", ldwc_vessels)
li_rowcount = ldwc_vessels.rowcount()

// if More than 30 vessels are selected! The report generation would take longer than normal.
if li_rowcount > 30 and li_pos > 0 then
	if messagebox("Warning", "More than 30 vessels are selected! The report generation would take longer than normal. Do you really want to proceed?", question!, yesno!, 2) = 2 then
		return
	end if
end if

dw_port_of_call_list.setredraw(false)

li_last_actual_voyages = integer(em_last_actual_voyages.text)

if isnull(li_last_actual_voyages) then li_last_actual_voyages = 0
dw_port_of_call_list.retrieve(li_last_actual_voyages, ls_vessel_nrs, uo_global.is_userid)

st_rows.text = string(dw_port_of_call_list.rowcount()) + " Row(s)"
dw_port_of_call_list.setfocus()

if dw_commentpopup.visible then
	dw_commentpopup.of_setlongarg( ii_VESSELNR , 0)
	dw_commentpopup.of_setlongarg(ii_PCN, 0)
	dw_commentpopup.of_setstringarg(ii_VOYAGENR, "")
	dw_commentpopup.of_setstringarg(ii_PORTCODE, "")
	dw_commentpopup.visible = false
	//dw_port_of_call_list.event ue_rbuttondown( dw_commentpopup.x, dw_commentpopup.y, 3, dw_port_of_call_list.object.compute_tasks)
end if
dw_port_of_call_list.setredraw(true)

end event

on w_port_of_call_list.create
int iCurrent
call super::create
this.dw_port_of_call_list=create dw_port_of_call_list
this.cb_print=create cb_print
this.cb_refresh=create cb_refresh
this.st_rows=create st_rows
this.st_allest_lastact=create st_allest_lastact
this.em_last_actual_voyages=create em_last_actual_voyages
this.st_topbar_background=create st_topbar_background
this.dw_commentpopup=create dw_commentpopup
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_port_of_call_list
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.cb_refresh
this.Control[iCurrent+4]=this.st_rows
this.Control[iCurrent+5]=this.st_allest_lastact
this.Control[iCurrent+6]=this.em_last_actual_voyages
this.Control[iCurrent+7]=this.st_topbar_background
this.Control[iCurrent+8]=this.dw_commentpopup
end on

on w_port_of_call_list.destroy
call super::destroy
destroy(this.dw_port_of_call_list)
destroy(this.cb_print)
destroy(this.cb_refresh)
destroy(this.st_rows)
destroy(this.st_allest_lastact)
destroy(this.em_last_actual_voyages)
destroy(this.st_topbar_background)
destroy(this.dw_commentpopup)
end on

event ue_vesselselection;call super::ue_vesselselection;postevent("ue_retrieve")
end event

event resize;call super::resize;this.setredraw( false )

dw_port_of_call_list.width = newwidth - dw_port_of_call_list.x - 37
dw_port_of_call_list.height = newheight - dw_port_of_call_list.y - 64 - st_rows.height
st_rows.y = dw_port_of_call_list.y + dw_port_of_call_list.height + 36
st_rows.x = newwidth - st_rows.width - 37
cb_refresh.x = newwidth - cb_refresh.width * 2 - 41
cb_print.x = newwidth - cb_print.width - 37

this.setredraw( true )
end event

event activate;uo_vesselselect.of_setshowtext( )

//CR2530 Added by LGX001 on 01/09/2011. Change desc:Implement Shortcut Keys (Links)  
m_helpmain lm_menu
lm_menu = this.menuid
if isvalid(lm_menu) then
	lm_menu.mf_setcalclink(dw_port_of_call_list, "vessel_nr", "voyage_nr", True)
end if
end event

event key;call super::key;graphicobject	lgo_focus

//If the current input places the cursor in the vessel, ignoring the default button functions
if key = keyenter! then
	lgo_focus = getfocus()
	if lgo_focus.classname() = 'dw_vessel' then
		ib_ignoredefaultbutton = true
		send(handle(lgo_focus), 256, 9, 0)
	end if
end if

end event

type st_hidemenubar from w_tramos_container_vessel`st_hidemenubar within w_port_of_call_list
end type

type uo_vesselselect from w_tramos_container_vessel`uo_vesselselect within w_port_of_call_list
integer x = 23
integer taborder = 10
end type

type dw_port_of_call_list from mt_u_datawindow within w_port_of_call_list
event ue_mousemove pbm_dwnmousemove
event ue_rbuttondown pbm_dwnrbuttondown
integer x = 37
integer y = 268
integer width = 5819
integer height = 2508
integer taborder = 50
string dataobject = "d_sp_tb_port_of_call_list"
boolean vscrollbar = true
boolean border = false
end type

event ue_mousemove;/********************************************************************
   event ue_mousemove( /*integer xpos*/, /*integer ypos*/, /*long row*/, /*dwobject dwo */)
   <DESC>   
		monitors the mouse pointer in regards to the popup
	</DESC>
   <RETURN> 
		Long
	</RETURN>
   <ACCESS> 
		Public
	</ACCESS>
   <ARGS>   
		standard powerbuilder arguments for this event
	</ARGS>
   <USAGE>  
	</USAGE>
********************************************************************/
if dw_commentpopup.visible then
	if dw_commentpopup.ib_autoclose then
		if xpos < dw_commentpopup.x - this.x then 
			dw_commentpopup.visible = false
			dw_port_of_call_list.setfocus( )
		end if	
		if ypos < dw_commentpopup.y - this.y then 
			dw_commentpopup.visible = false
			dw_port_of_call_list.setfocus( )
		end if
	end if	
end if
end event

event ue_rbuttondown;/********************************************************************
   user event ue_rbuttondown()
	
<DESC>   
	This event fires the popup with the voyage comment/ poc notes when the 
	user right clicks over either control in the main list.  It needs to
	locate the complete comment in the database due to stored procedure truncating
	unnecessary data for all rows retreived.
	Additonal code has been addded to optimize the calls to the database if the user
	calls the same request in a row.  
</DESC>
<RETURN>
	Integer:
		NA
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	Standard Powerbuilder args for right button down event
</ARGS>
<USAGE>
	As this is retreiving always a single record inline SQL is used here.
</USAGE>
********************************************************************/
string ls_columnname, ls_comment, ls_voyagenr, ls_portcode, ls_header
integer li_vesselnr, li_pcn, li_adjustpos=0
long ll_row

ls_columnname = dwo.name		
if ls_columnname <> "cp_charterer" and ls_columnname <> "poccomments" and ls_columnname <> 'compute_tasks' then
	return
end if

if row = 0 then 
	/* we need to obtain the row if user clicked on a group header too */
	ll_row = _getheaderrow()
else
	ll_row = row
end if

if ll_row <= 0 then return

li_vesselnr = this.getitemnumber(ll_row,"vessel_nr")	
ls_voyagenr = this.getitemstring(ll_row,"voyage_nr")	
ls_portcode = this.getitemstring(ll_row,"port_code") 
li_pcn = this.getitemnumber(ll_row,"pcn")	

/* adjust popup datawindow position according to current mouse pointer */
if (PointerX() + dw_commentpopup.width) > (this.width - 95) then
	li_adjustpos =  (PointerX() + dw_commentpopup.width) - this.width 
	dw_commentpopup.x = parent.PointerX() - li_adjustpos - 95
else
	dw_commentpopup.x = parent.PointerX() 	
end if
if (PointerY() + dw_commentpopup.height) > (this.height - 10) then
	li_adjustpos =  (PointerY() + dw_commentpopup.height) - this.height 
	dw_commentpopup.y = parent.PointerY() - li_adjustpos - 10
else
	dw_commentpopup.y = parent.PointerY() 
end if


parent.setredraw( false )
dw_commentpopup.visible = true

/* test to see if we need to re-retreive the content */
/*CR2528 Begin modified by LHC010 on 05-09-2011*/
/*if clicked different column, need to re-retrieve the content*/
if li_vesselnr <> dw_commentpopup.of_getlongarg(ii_VESSELNR) or &
	li_pcn <> dw_commentpopup.of_getlongarg(ii_PCN) or &
	ls_voyagenr <> dw_commentpopup.of_getstringarg( ii_VOYAGENR) or &
	ls_portcode <> dw_commentpopup.of_getstringarg( ii_PORTCODE) or &
	ls_columnname <> dw_commentpopup.of_getstringarg( ii_COLUMNNAME) then
	
	dw_commentpopup.setitem(1,"comment", "Searching...")
	dw_commentpopup.of_setlongarg( ii_VESSELNR, li_vesselnr )
	dw_commentpopup.of_setlongarg( ii_PCN, li_pcn )
	dw_commentpopup.of_setstringarg( ii_VOYAGENR, ls_voyagenr )		
	dw_commentpopup.of_setstringarg( ii_PORTCODE, ls_portcode )	
	dw_commentpopup.of_setstringarg( ii_COLUMNNAME, ls_columnname )	
else
	/*DW.visible = false if right clicked column is not values */
	if dw_commentpopup.getitemstring( 1,"comment") = "Searching..." then
		dw_commentpopup.visible = false
	end if
	parent.setredraw( true )
	/* user selected the same record so we keep the comment, no need to re-retreive from database */		
	return
end if
/*End modified by LHC010 on 05-09-2011*/
	
/* as the user has requested new data and the list only retreives substring of the complete notes we have to locate the data inside the database */	
choose case ls_columnname
		
	case "cp_charterer"	
		/* voyage comment */
		SELECT VOYAGE_COMMENTS
		INTO :ls_comment 
		FROM VOYAGES
		WHERE VESSEL_NR=:li_vesselnr AND VOYAGE_NR=:ls_voyagenr;
		ls_header = "Voyage Comment : " +  dw_port_of_call_list.getitemstring(ll_row,"vessel_name") + " - " + dw_port_of_call_list.getitemstring(ll_row,"voyage_nr")
		
	case "poccomments"	
		/* port of call comment */
		if upper(this.getitemstring(ll_row,"act_est"))= "EST." then 
			SELECT COMMENTS
			INTO :ls_comment 
			FROM POC_EST
			WHERE VESSEL_NR=:li_vesselnr AND VOYAGE_NR=:ls_voyagenr AND PCN=:li_pcn AND PORT_CODE=:ls_portcode;
		else
			SELECT COMMENTS
			INTO :ls_comment 
			FROM POC
			WHERE VESSEL_NR=:li_vesselnr AND VOYAGE_NR=:ls_voyagenr AND PCN=:li_pcn AND PORT_CODE=:ls_portcode;
		end if
		ls_header = this.getitemstring(ll_row,"proc_text") + " Notes : " +  dw_port_of_call_list.getitemstring(ll_row,"vessel_name") + " - " + dw_port_of_call_list.getitemstring(ll_row,"voyage_nr")
	case "compute_tasks"
		//CR2528 Added by LHC010 on 05-09-2011. Change desc:MVV tasks text 
		ls_comment = this.getitemstring(row, "compute_taskstext")
		ls_header = this.getitemstring(ll_row,"proc_text") + " Tasks : " +  dw_port_of_call_list.getitemstring(ll_row,"vessel_name") + " - " + dw_port_of_call_list.getitemstring(ll_row,"voyage_nr")		
end choose

/* lastly output the new data into the comment column */
if SQLCA.sqlcode=0 and not isnull(ls_comment) and len(ls_comment) > 0 then
	dw_commentpopup.object.t_detail.text = ls_header
	dw_commentpopup.setitem(1,"comment", ls_comment)
	dw_commentpopup.setfocus()
else
	dw_commentpopup.visible = false
end if

parent.setredraw( true )

end event

event doubleclicked;call super::doubleclicked;string ls_act_est, ls_purpose_code, ls_columnname
integer	li_vessel_nr, li_estcargo  //0 actual cargo, >0 estimated cargo

if row > 0 then
	this.selectrow(0, false)
	this.selectrow(row, true)
	li_vessel_nr = this.getitemnumber(row, "vessel_nr")
	li_estcargo = this.getitemnumber(row, "compute_estcargo")
	uo_global.setvessel_nr(li_vessel_nr)
	uo_global.setvoyage_nr(this.getitemstring(row, "voyage_nr"))
	uo_global.setport_code(this.getitemstring(row, "port_code"))
	uo_global.setpcn(this.getitemnumber(row, "pcn"))
	
	//CR2408 Added by LHC010 on 19-05-2011. 
	//Change desc: Double-clicking related columns in POC List will open Port of Call or Proceeding or Cargo.
	il_select_row = row
	if w_tramos_main.windowstate = minimized! then w_tramos_main.windowstate = normal!
	
	ls_columnname = dwo.name
	
	if ls_columnname = "port_code" or ls_columnname = "proc_text" or ls_columnname = "speed_instr" or &
		ls_columnname = "act_est" or ls_columnname = "port_berthing_time" or ls_columnname = "port_arr_dt" or &
		ls_columnname = "port_dept_dt" or ls_columnname = "shortname" or ls_columnname = "purpose_code"  or &
		ls_columnname = "compute_tasks" or (ls_columnname = "compute_cargo_type" and li_estcargo > 0) then

		uo_global.setparm(1)
		if isvalid(w_port_of_call) then
			w_port_of_call.uo_vesselselect.of_setcurrentvessel( li_vessel_nr )
			w_port_of_call.bringtotop = true
		else
			opensheet(w_port_of_call, w_tramos_main, 7, original!)
		end if
	elseif ls_columnname = "voyage_nr" or ls_columnname = "p_voyage_flag" then
		uo_global.setparm(1)
		if isvalid(w_proceeding_list) then
			if not w_proceeding_list.cb_update.enabled then
				w_proceeding_list.uo_vesselselect.of_setcurrentvessel( li_vessel_nr )
			end if
			w_proceeding_list.bringtotop = true
		else
			opensheet(w_proceeding_list, w_tramos_main, 7, original!)
		end if
	elseif ls_columnname = "mtbe" or ls_columnname = "mtbe" or ls_columnname = "mtbe" or (ls_columnname = "compute_cargo_type" and li_estcargo = 0) then
		ls_purpose_code = this.getitemstring( row, "purpose_code")
		if ls_purpose_code = 'D' or ls_purpose_code = 'L' or ls_purpose_code = 'L/D' then
			uo_global.setparm(1)
			if isvalid(w_cargo) then
				if not w_cargo.cb_update_bol.enabled then
					w_cargo.uo_vesselselect.of_setcurrentvessel( li_vessel_nr )
				end if
				w_cargo.bringtotop = true
			else
				opensheet(w_cargo, w_tramos_main, 7, original!)
			end if
		end if		
	end if
end if


end event

event clicked;call super::clicked;if row > 0 then
	selectrow(0, false)
	selectrow(row, true)	
	this.scrolltorow( row)
end if
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)	
	this.scrolltorow( currentrow)
end if
end event

event retrieveend;call super::retrieveend;if rowcount > 0 then
	selectrow(0, false)
	selectrow(1, true)	
	this.scrolltorow(1)
end if
end event

type cb_print from commandbutton within w_port_of_call_list
integer x = 5509
integer y = 32
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;/* If there are no ports of call, inform user and exit event */
if dw_port_of_call_list.rowcount() < 1 then
	messagebox("Notice","There are no Ports of Call to Print!")
	return
end if
/*CR2408 Begin modified by LHC010 on 23-05-2011 Change desc:add print date and page*/
dw_port_of_call_list.setredraw(false)
dw_port_of_call_list.modify("compute_printdate.visible=1")
dw_port_of_call_list.modify("DataWindow.Header.Height='136'")
dw_port_of_call_list.modify("DataWindow.Zoom=85")
dw_port_of_call_list.print()
dw_port_of_call_list.modify("DataWindow.Zoom=100")
dw_port_of_call_list.modify("compute_printdate.visible=0")
dw_port_of_call_list.modify("DataWindow.Header.Height='76'")
dw_port_of_call_list.setredraw(true)
/*End modified by LHC010 on 23-05-2011*/

end event

type cb_refresh from commandbutton within w_port_of_call_list
integer x = 5179
integer y = 32
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
boolean default = true
end type

event clicked;if ib_ignoredefaultbutton then
	ib_ignoredefaultbutton = false
	return
end if

parent.triggerevent("ue_retrieve")


end event

type st_rows from mt_u_statictext within w_port_of_call_list
integer x = 5513
integer y = 2804
integer width = 302
integer height = 56
boolean bringtotop = true
long backcolor = 553648127
boolean enabled = false
string text = "Row(s)"
alignment alignment = right!
end type

type st_allest_lastact from mt_u_statictext within w_port_of_call_list
integer x = 1262
integer y = 124
integer width = 1234
integer height = 56
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 553648127
string text = "Show all estimated and the last              actual voyages."
end type

type em_last_actual_voyages from mt_u_editmask within w_port_of_call_list
integer x = 1957
integer y = 120
integer width = 165
integer height = 68
integer taborder = 20
boolean bringtotop = true
long textcolor = 0
string text = "3"
alignment alignment = center!
borderstyle borderstyle = stylebox!
string mask = "####0"
boolean autoskip = true
string minmax = "0~~99999"
end type

event modified;call super::modified;string ls_vessel_ref_nr

//CR2408 Added by LHC010 on 10-05-2011. Change desc: If selecting one single vessel, do auto retrieval without pressing Refresh
ls_vessel_ref_nr = uo_vesselselect.dw_vessel.getitemstring( 1, "vessel_ref_nr")

if len(ls_vessel_ref_nr) > 0 then
	parent.triggerevent("ue_retrieve")
end if
end event

type st_topbar_background from u_topbar_background within w_port_of_call_list
integer width = 6853
integer height = 232
end type

type dw_commentpopup from u_popupdw within w_port_of_call_list
event ue_mousemove pbm_dwnmousemove
event ue_keypress pbm_dwnkey
integer x = 270
integer y = 572
integer width = 1509
integer height = 728
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_ex_ff_commentpopup"
borderstyle borderstyle = stylebox!
boolean ib_footermessage = true
boolean ib_headermessage = true
boolean ib_autoclose = false
end type

event constructor;call super::constructor;this.of_registerdw(dw_port_of_call_list)
this.of_setlongarg( ii_VESSELNR , 0)
this.of_setlongarg(ii_PCN, 0)
this.of_setstringarg(ii_VOYAGENR, "")
this.of_setstringarg(ii_PORTCODE, "")
this.of_setstringarg(ii_COLUMNNAME, "")

end event

