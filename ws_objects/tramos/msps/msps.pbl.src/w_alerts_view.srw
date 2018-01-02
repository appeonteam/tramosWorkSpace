$PBExportHeader$w_alerts_view.srw
forward
global type w_alerts_view from w_vessel_basewindow
end type
type gb_1 from groupbox within w_alerts_view
end type
type dw_alertstree from mt_u_datawindow within w_alerts_view
end type
type dw_severity from u_datagrid within w_alerts_view
end type
type cb_refresh from mt_u_commandbutton within w_alerts_view
end type
type cbx_unacknowledge from mt_u_checkbox within w_alerts_view
end type
type cbx_myvessels from mt_u_checkbox within w_alerts_view
end type
type st_2 from mt_u_statictext within w_alerts_view
end type
type dw_uservessel from u_datagrid within w_alerts_view
end type
type em_lastdays from mt_u_editmask within w_alerts_view
end type
type st_banner from u_topbar_background within w_alerts_view
end type
type cbx_selectall from checkbox within w_alerts_view
end type
type pb_expandcollapse from picturebutton within w_alerts_view
end type
end forward

global type w_alerts_view from w_vessel_basewindow
integer width = 4599
integer height = 2588
string title = "Alerts View"
boolean maxbox = false
boolean resizable = false
string icon = ""
boolean ib_setdefaultbackgroundcolor = true
gb_1 gb_1
dw_alertstree dw_alertstree
dw_severity dw_severity
cb_refresh cb_refresh
cbx_unacknowledge cbx_unacknowledge
cbx_myvessels cbx_myvessels
st_2 st_2
dw_uservessel dw_uservessel
em_lastdays em_lastdays
st_banner st_banner
cbx_selectall cbx_selectall
pb_expandcollapse pb_expandcollapse
end type
global w_alerts_view w_alerts_view

type variables
mt_n_stringfunctions inv_string

integer ii_vesselnr_list[] 		//vessel select dropdown list all vessel's NR

private boolean _ib_expanded 		//used exclusively with the alerts treeview
private boolean _ib_ack				//Access right for acknowledge or un-acknowledge for alerts
end variables

forward prototypes
public subroutine documentation ()
public subroutine wf_filter ()
public subroutine wf_get_myvessel ()
private subroutine _set_permission ()
public subroutine wf_acknowledge (integer ai_ack)
end prototypes

public subroutine documentation ();/********************************************************************
   w_alerts_view
   <OBJECT>		Provide an overview to VMs of the status of the vessels	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
		17/12/2013		CR3240		XSZ004		First Version
   </HISTORY>
********************************************************************/
end subroutine

public subroutine wf_filter ();/********************************************************************
   wf_filter
   <DESC>	Filter the data of dw_alertstree datawindow	</DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>	</ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date				CR-Ref       	Author		Comments
		18-12-2013		CR3240			XSZ004		First Version
   </HISTORY>
********************************************************************/
constant string ls_AND = " and "
string ls_filter, ls_myvessel

this.setredraw(false)

ls_filter = dw_severity.inv_filter_multirow.of_getfilter()

if len(ls_filter) > 0 then
	//Show unacknowledge alerts
	if cbx_unacknowledge.checked then	
		ls_filter += ls_AND + " acknowledge = 0 "
	end if

	//Show my vessels
	if cbx_myvessels.checked then
		ls_myvessel = dw_uservessel.inv_filter_multirow.of_getfilter()
		if ls_myvessel <> "" then
			ls_filter += ls_AND +  ls_myvessel
		else
			ls_filter += ls_AND + " 1 = 2 "
		end if
	end if
	
	//selected vessel
	if ii_vessel_nr > 0 then
		ls_filter += ls_AND + " vessel_nr = " + string(ii_vessel_nr) + " "
	end if
else
	ls_filter = " 1 = 2 "
end if

dw_alertstree.setfilter(ls_filter)
dw_alertstree.filter()

dw_alertstree.post groupcalc()

this.post setredraw(true)

end subroutine

public subroutine wf_get_myvessel ();/********************************************************************
   wf_get_myvessel
   <DESC> Get vessels belong to VM,VEO,Charterer </DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>	</ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       		CR-Ref      Author		Comments
		13-01-2014		CR3240		XSZ004		First Version
   </HISTORY>
********************************************************************/
string ls_sql

choose case uo_global.ii_user_profile
	 case 1 //Charterer profile
			ls_sql = " SELECT VESSEL_NR FROM VESSELS WHERE VESSEL_CHARTERER = '" + uo_global.is_userid + "' "
	 case 2 //Operator user/advanced_user profile
		if uo_global.ii_access_level = c#usergroup.#SUPERUSER then 
			ls_sql = " SELECT VESSEL_NR FROM VESSELS  WHERE VESSEL_OPERATOR = '" + uo_global.is_userid + "' "
		elseif uo_global.ii_access_level = c#usergroup.#USER then 
			ls_sql = " SELECT VESSEL_NR FROM VESSEL_VEOS WHERE USERID = '" + uo_global.is_userid + "' "
		else
			cbx_myvessels.enabled = false
		end if
	case else
		cbx_myvessels.enabled = false
end choose 

dw_uservessel.setsqlselect(ls_sql)
dw_uservessel.retrieve( )

dw_uservessel.selectrow(0, true)
dw_uservessel.inv_filter_multirow.of_dofilter()
end subroutine

private subroutine _set_permission ();/********************************************************************
   _set_permissions
   <DESC>Set Access right for acknowledge or un-acknowledge the alert</DESC>
   <RETURN>	(none)
     
   <ACCESS> private </ACCESS>
   <ARGS>
		
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
  		25/12/2013		CR3240		XSZ004		First Version	      
   </HISTORY>
********************************************************************/
if uo_global.ii_user_profile = 2 and uo_global.ii_access_level = c#usergroup.#SUPERUSER then
	_ib_ack = true 
else
	_ib_ack = false
end if
end subroutine

public subroutine wf_acknowledge (integer ai_ack);/********************************************************************
   wf_acknowledge
   <DESC>	Acknowledge or unacknowledge the selected alert	</DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
			ai_ack:
			1 acknowledge
			0 unacknowledge
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date				CR-Ref		Author			Comments
		25-12-2013		CR3240		XSZ004			First Version
   </HISTORY>
********************************************************************/
long ll_getrow, ll_alertid

ll_getrow = dw_alertstree.getrow()
if ll_getrow < 1 then return

ll_alertid = dw_alertstree.getitemnumber(ll_getrow, 'rul_alerts_alerts_id')

dw_alertstree.setitem(ll_getrow, 'acknowledge', ai_ack)
dw_alertstree.setitem(ll_getrow, 'ackn_by', uo_global.is_userid)
dw_alertstree.setitem(ll_getrow, 'ackn_date', today())

if dw_alertstree.update() = 1 then
	COMMIT USING SQLCA;
else
	ROLLBACK USING SQLCA;
	MessageBox("Error","Did not save !")
end if

end subroutine

on w_alerts_view.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.dw_alertstree=create dw_alertstree
this.dw_severity=create dw_severity
this.cb_refresh=create cb_refresh
this.cbx_unacknowledge=create cbx_unacknowledge
this.cbx_myvessels=create cbx_myvessels
this.st_2=create st_2
this.dw_uservessel=create dw_uservessel
this.em_lastdays=create em_lastdays
this.st_banner=create st_banner
this.cbx_selectall=create cbx_selectall
this.pb_expandcollapse=create pb_expandcollapse
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.dw_alertstree
this.Control[iCurrent+3]=this.dw_severity
this.Control[iCurrent+4]=this.cb_refresh
this.Control[iCurrent+5]=this.cbx_unacknowledge
this.Control[iCurrent+6]=this.cbx_myvessels
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.dw_uservessel
this.Control[iCurrent+9]=this.em_lastdays
this.Control[iCurrent+10]=this.st_banner
this.Control[iCurrent+11]=this.cbx_selectall
this.Control[iCurrent+12]=this.pb_expandcollapse
end on

on w_alerts_view.destroy
call super::destroy
destroy(this.gb_1)
destroy(this.dw_alertstree)
destroy(this.dw_severity)
destroy(this.cb_refresh)
destroy(this.cbx_unacknowledge)
destroy(this.cbx_myvessels)
destroy(this.st_2)
destroy(this.dw_uservessel)
destroy(this.em_lastdays)
destroy(this.st_banner)
destroy(this.cbx_selectall)
destroy(this.pb_expandcollapse)
end on

event open;call super::open;uo_vesselselect.of_registerwindow( w_alerts_view )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setfocus()

uo_vesselselect.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.st_criteria.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.st_criteria.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.dw_vessel.object.datawindow.color = string(c#color.MT_LISTHEADER_BG)

dw_severity.selectrow(0, true)
dw_severity.inv_filter_multirow.of_dofilter()

em_lastdays.text = string(uo_global.ii_rul_alertviewdays)

_set_permission()

ii_vessel_nr = uo_global.getvessel_nr()

this.post event ue_vesselselection(ii_vessel_nr)
post wf_get_myvessel()





end event

event ue_retrieve;call super::ue_retrieve;wf_filter()

dw_alertstree.settransobject(sqlca)
dw_alertstree.retrieve(ii_vesselnr_list, integer(em_lastdays.text), uo_global.ii_rul_delayminute, c#msps.ii_APPROVED)

//Expand all levels when selecting a vessel 
if ii_vessel_nr > 0 then
	dw_alertstree.expandall()
end if

end event

event ue_vesselselection;call super::ue_vesselselection;string	ls_vesselsnr
integer	li_null[]

if ai_vessel = 0 then setnull(ai_vessel)

ii_vesselnr_list = li_null
if isnull(ai_vessel) then
	ls_vesselsnr = uo_vesselselect.of_get_vessels_nr( )
	inv_string.of_parsetoarray( ls_vesselsnr, ",", ii_vesselnr_list)
else
	ii_vesselnr_list[1] = ai_vessel 
end if

this.postevent("ue_retrieve")




end event

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_alerts_view
integer x = 18
integer taborder = 10
end type

event uo_vesselselect::ue_itemchanged;call super::ue_itemchanged;if isnull(vessel_nr) then
	parent.event ue_vesselselection(vessel_nr)
end if

	


end event

type gb_1 from groupbox within w_alerts_view
integer x = 1262
integer width = 750
integer height = 208
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Vessel Severity"
end type

type dw_alertstree from mt_u_datawindow within w_alerts_view
integer x = 37
integer y = 272
integer width = 4517
integer height = 2112
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_sq_tv_alertview"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
end type

event doubleclicked;call super::doubleclicked;string ls_band
integer li_tab, li_tmprow, li_sel

ls_band = this.GetBandAtPointer()

if pos(ls_band, "detail") > 0 then return

li_tab 	 = Pos(ls_band, "~t", 1)
li_tmpRow = Integer(Mid(ls_band, li_tab + 1))
ls_band 	 = Left(ls_band, li_tab - 1)
li_sel	 = integer(right(ls_band,1))

if this.isexpanded(li_tmprow, li_sel) then
	this.Collapse(li_tmprow, li_sel)
else
	this.Expand(li_tmprow, li_sel)
end if
end event

event clicked;call super::clicked;int li_ack

if row < 1 then 
	return 
else
	this.setrow(row)
end if

//Access right for acknowledge or un-acknowledge the alert
if _ib_ack then
	if dwo.name = "acknowledge" then
		li_ack = this.getitemnumber(row, "acknowledge")
		if li_ack = 1 then
			wf_acknowledge(0)
		else
			wf_acknowledge(1)
		end if
	end if
end if
end event

type dw_severity from u_datagrid within w_alerts_view
integer x = 1298
integer y = 64
integer width = 677
integer height = 112
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sq_gr_ruleseverity"
boolean vscrollbar = true
boolean border = false
boolean ib_multicolumnsort = false
boolean ib_multirow = true
end type

event clicked;call super::clicked;wf_filter()
dw_alertstree.collapseall()



end event

event constructor;call super::constructor;s_filter_multirow lstr_module

this.retrieve( )

lstr_module.self_dw = dw_severity
lstr_module.self_column_name = 'severity_level'       // The column name is getitem column name.
lstr_module.report_column_name = 'compute_vessel_severity'

this.inv_filter_multirow.of_register(lstr_module)
end event

type cb_refresh from mt_u_commandbutton within w_alerts_view
integer x = 4210
integer y = 32
integer taborder = 70
boolean bringtotop = true
string text = "&Refresh"
end type

event clicked;call super::clicked;if uo_vesselselect.dw_vessel.accepttext() = -1 then 
	uo_vesselselect.dw_vessel.setfocus()
	return
end if

parent.triggerevent("ue_retrieve")

end event

type cbx_unacknowledge from mt_u_checkbox within w_alerts_view
integer x = 2889
integer y = 32
integer width = 846
integer height = 64
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Show only unacknowledged alerts"
boolean checked = true
end type

event clicked;call super::clicked;wf_filter()
dw_alertstree.expandall()


end event

type cbx_myvessels from mt_u_checkbox within w_alerts_view
integer x = 2048
integer y = 32
integer width = 567
integer height = 64
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Show only my vessels"
end type

event clicked;call super::clicked;wf_filter()
dw_alertstree.collapseall()


end event

type st_2 from mt_u_statictext within w_alerts_view
integer x = 2048
integer y = 112
integer width = 1143
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Show approved messages of the last               days"
end type

type dw_uservessel from u_datagrid within w_alerts_view
boolean visible = false
integer x = 3511
integer y = 128
integer width = 347
integer height = 96
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_sq_gr_uservessel"
boolean vscrollbar = true
boolean border = false
boolean ib_multicolumnsort = false
boolean ib_multirow = true
end type

event clicked;call super::clicked;wf_filter()
end event

event constructor;call super::constructor;s_filter_multirow lstr_module

lstr_module.self_dw = dw_uservessel
lstr_module.self_column_name = 'vessel_nr'       // The column name is getitem column name.
lstr_module.report_column_name = 'vessel_nr'

this.inv_filter_multirow.of_register(lstr_module)
end event

type em_lastdays from mt_u_editmask within w_alerts_view
event ue_key pbm_keydown
integer x = 2889
integer y = 112
integer width = 146
integer height = 56
integer taborder = 50
boolean bringtotop = true
long textcolor = 0
long backcolor = 16777215
string text = ""
boolean border = false
alignment alignment = center!
borderstyle borderstyle = stylebox!
string mask = "###0"
string minmax = "~~"
end type

event ue_key;if key = keyenter! then
	cb_refresh.event clicked( )
end if
end event

type st_banner from u_topbar_background within w_alerts_view
integer width = 7991
integer height = 240
integer taborder = 60
end type

type cbx_selectall from checkbox within w_alerts_view
integer x = 1664
integer width = 325
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Deselect all"
boolean checked = true
end type

event clicked;if cbx_selectall.checked then
	cbx_selectall.text = "Deselect all"
else
	cbx_selectall.text = "Select all"	
end if

dw_severity.selectrow(0, cbx_selectall.checked)
dw_severity.inv_filter_multirow.of_dofilter()

wf_filter()
end event

type pb_expandcollapse from picturebutton within w_alerts_view
integer x = 37
integer y = 2400
integer width = 110
integer height = 96
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "TreeView!"
alignment htextalign = left!
string powertiptext = "Expand/Collapse All"
end type

event clicked;_ib_expanded = not _ib_expanded

if _ib_expanded then
	dw_alertstree.expandall()
else
	dw_alertstree.collapseall()
end if
end event

