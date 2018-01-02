$PBExportHeader$w_interface_log.srw
forward
global type w_interface_log from w_vessel_basewindow
end type
type dw_start_to from datawindow within w_interface_log
end type
type dw_start_from from datawindow within w_interface_log
end type
type dw_trans_to from datawindow within w_interface_log
end type
type dw_trans_from from datawindow within w_interface_log
end type
type st_start_to from statictext within w_interface_log
end type
type st_trans_to from statictext within w_interface_log
end type
type st_start_from from statictext within w_interface_log
end type
type st_trans_from from statictext within w_interface_log
end type
type rb_ax from radiobutton within w_interface_log
end type
type cbx_deleted from checkbox within w_interface_log
end type
type cbx_modified from checkbox within w_interface_log
end type
type cbx_created from checkbox within w_interface_log
end type
type cbx_laidup from checkbox within w_interface_log
end type
type cbx_offservice from checkbox within w_interface_log
end type
type cbx_position from checkbox within w_interface_log
end type
type cbx_tcout from checkbox within w_interface_log
end type
type cbx_idlevoyage from checkbox within w_interface_log
end type
type cbx_singlevoyage from checkbox within w_interface_log
end type
type cb_refresh from commandbutton within w_interface_log
end type
type gb_voyage_type from groupbox within w_interface_log
end type
type gb_status from groupbox within w_interface_log
end type
type gb_trans from groupbox within w_interface_log
end type
type gb_start_date from groupbox within w_interface_log
end type
type dw_transaction_log_list from mt_u_datawindow within w_interface_log
end type
type gb_trans_type from groupbox within w_interface_log
end type
type st_topbar_background from u_topbar_background within w_interface_log
end type
type st_1 from statictext within w_interface_log
end type
type st_2 from statictext within w_interface_log
end type
type st_3 from statictext within w_interface_log
end type
type sle_voyageno from singlelineedit within w_interface_log
end type
type em_lastday from editmask within w_interface_log
end type
type dw_popup_modify_detail_preview from u_popupdw within w_interface_log
end type
end forward

global type w_interface_log from w_vessel_basewindow
string tag = "Interface Log"
integer width = 4215
integer height = 2560
string title = "Interface Log"
boolean maxbox = false
boolean resizable = false
long backcolor = 67108864
dw_start_to dw_start_to
dw_start_from dw_start_from
dw_trans_to dw_trans_to
dw_trans_from dw_trans_from
st_start_to st_start_to
st_trans_to st_trans_to
st_start_from st_start_from
st_trans_from st_trans_from
rb_ax rb_ax
cbx_deleted cbx_deleted
cbx_modified cbx_modified
cbx_created cbx_created
cbx_laidup cbx_laidup
cbx_offservice cbx_offservice
cbx_position cbx_position
cbx_tcout cbx_tcout
cbx_idlevoyage cbx_idlevoyage
cbx_singlevoyage cbx_singlevoyage
cb_refresh cb_refresh
gb_voyage_type gb_voyage_type
gb_status gb_status
gb_trans gb_trans
gb_start_date gb_start_date
dw_transaction_log_list dw_transaction_log_list
gb_trans_type gb_trans_type
st_topbar_background st_topbar_background
st_1 st_1
st_2 st_2
st_3 st_3
sle_voyageno sle_voyageno
em_lastday em_lastday
dw_popup_modify_detail_preview dw_popup_modify_detail_preview
end type
global w_interface_log w_interface_log

type variables
private string is_getsql
string	is_status, is_filter_voyagetype, is_voyagenr
private long _il_popupactiverow=0


end variables

forward prototypes
public subroutine wf_get_filter_voyagetype ()
public subroutine wf_get_filter_status ()
public subroutine documentation ()
public subroutine wf_change_cbx_checked (boolean ab_checked)
public subroutine wf_refresh_showlog (integer al_vessel_nr, string as_voyage_nr)
public subroutine wf_show_alllog ()
end prototypes

public subroutine wf_get_filter_voyagetype ();/********************************************************************
   wf_get_filter_voyagetype
   <DESC>	construct where condition	</DESC>
   <RETURN>	(None):	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	This function is used to get the filter of voyage type.	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	21/12/2011 M5-1         WWG004        First Version
   </HISTORY>
********************************************************************/

string ls_filter

ls_filter = ''

if cbx_singlevoyage.checked then
	if ls_filter <> '' then ls_filter += " OR "
	ls_filter += "VOYAGE_TYPE = 'S'"
end if

if cbx_position.checked then
	if ls_filter <> '' then ls_filter += " OR "
	ls_filter += "VOYAGE_TYPE = 'P'"
end if

if cbx_tcout.checked then
	if ls_filter <> '' then ls_filter += " OR "
	ls_filter += "VOYAGE_TYPE = 'T'"
end if

if cbx_idlevoyage.checked then
	if ls_filter <> '' then ls_filter += " OR "
	ls_filter += "VOYAGE_TYPE = 'I'"
end if

if cbx_offservice.checked then
	if ls_filter <> '' then ls_filter += " OR "
	ls_filter += "VOYAGE_TYPE = 'O'"
end if

if cbx_laidup.checked then
	if ls_filter <> '' then ls_filter += " OR "
	ls_filter += "VOYAGE_TYPE = 'L'"
end if

if len(ls_filter) > 0 then
	ls_filter += " OR VOYAGE_TYPE IS NULL"
	ls_filter = '(' + ls_filter + ')'
end if

is_filter_voyagetype = ls_filter

cb_refresh.triggerevent(clicked!)
end subroutine

public subroutine wf_get_filter_status ();/********************************************************************
   wf_get_filter_status
   <DESC>	construct where condition	</DESC>
   <RETURN>	(None):	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	This function is used to get the filter of status.	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	21/12/2011 M5-1         WWG004        First Version
   </HISTORY>
********************************************************************/

string ls_filter

ls_filter = ''

if cbx_created.checked then
	if ls_filter <> '' then ls_filter += " OR "
	ls_filter += "STATUS = 'C'"
end if

if cbx_modified.checked then
	if ls_filter <> '' then ls_filter += " OR "
	ls_filter += "STATUS = 'M'"
end if

if cbx_deleted.checked then
	if ls_filter <> '' then ls_filter += " OR "
	ls_filter += "STATUS = 'D'"
end if

if len(ls_filter) > 0 then
	ls_filter = '(' + ls_filter + ')'
end if

is_status = ls_filter

cb_refresh.triggerevent(clicked!)
end subroutine

public subroutine documentation ();/***************************************************************************************
   w_interface_log
   <OBJECT>		Display interface log	</OBJECT>
   <USAGE>		Display interface log	</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date       	CR-Ref       	Author        	Comments
   	15/12/2011 	M5-1 Finance	WWG004        	First Version
		15/12/2011 	M5-1 Finance	WWG004        	Add function wf_get_filter_status
		15/12/2011 	M5-1 Finance	WWG004        	Add function wf_get_filter_voyagestatus
		15/12/2011 	M5-1 Finance	WWG004        	Add function wf_change_cbx_checked
		21/12/2011	M5-1 Finance	WWG004		  	Add function wf_refresh_showlog
		20/09/2016	CR3320			AGL027			Expand the columns available, add popupdw and modify filter to handle existing where clause in SQL
   </HISTORY>
****************************************************************************************/
end subroutine

public subroutine wf_change_cbx_checked (boolean ab_checked);/********************************************************************
   wf_change_cbx_checked
   <DESC>	Change all checkbox's status	</DESC>
   <RETURN>	(none) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_checked
   </ARGS>
   <USAGE>	If the vessel or voyage and other filter are all null
				then all the checkbox are auto unchecked, otherwise all
				checkbox auto checked.</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	21/12/2011 M5-1         WWG004        First Version
   </HISTORY>
********************************************************************/

cbx_created.checked = ab_checked
cbx_modified.checked = ab_checked
cbx_deleted.checked = ab_checked
cbx_singlevoyage.checked = ab_checked
cbx_idlevoyage.checked = ab_checked
cbx_offservice.checked = ab_checked
cbx_position.checked = ab_checked
cbx_tcout.checked = ab_checked
cbx_laidup.checked = ab_checked

end subroutine

public subroutine wf_refresh_showlog (integer al_vessel_nr, string as_voyage_nr);/********************************************************************
   wf_refresh_showlog
   <DESC>	Description	</DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
   </ARGS>
   <USAGE>	This is a interface function, when this window is opended
				from other window, this function will work.</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	22/12/2011 M5-1         WWG004        First Version
   </HISTORY>
********************************************************************/

is_voyagenr = as_voyage_nr
sle_voyageno.text = is_voyagenr

if al_vessel_nr >= 0 then wf_change_cbx_checked(true)

uo_vesselselect.of_setcurrentvessel(al_vessel_nr)



end subroutine

public subroutine wf_show_alllog ();dw_transaction_log_list.retrieve()
dw_transaction_log_list.setfilter("TRANS_DATE >= '" + string(relativedate(today(), - 10)) + "'")

end subroutine

on w_interface_log.create
int iCurrent
call super::create
this.dw_start_to=create dw_start_to
this.dw_start_from=create dw_start_from
this.dw_trans_to=create dw_trans_to
this.dw_trans_from=create dw_trans_from
this.st_start_to=create st_start_to
this.st_trans_to=create st_trans_to
this.st_start_from=create st_start_from
this.st_trans_from=create st_trans_from
this.rb_ax=create rb_ax
this.cbx_deleted=create cbx_deleted
this.cbx_modified=create cbx_modified
this.cbx_created=create cbx_created
this.cbx_laidup=create cbx_laidup
this.cbx_offservice=create cbx_offservice
this.cbx_position=create cbx_position
this.cbx_tcout=create cbx_tcout
this.cbx_idlevoyage=create cbx_idlevoyage
this.cbx_singlevoyage=create cbx_singlevoyage
this.cb_refresh=create cb_refresh
this.gb_voyage_type=create gb_voyage_type
this.gb_status=create gb_status
this.gb_trans=create gb_trans
this.gb_start_date=create gb_start_date
this.dw_transaction_log_list=create dw_transaction_log_list
this.gb_trans_type=create gb_trans_type
this.st_topbar_background=create st_topbar_background
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.sle_voyageno=create sle_voyageno
this.em_lastday=create em_lastday
this.dw_popup_modify_detail_preview=create dw_popup_modify_detail_preview
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_start_to
this.Control[iCurrent+2]=this.dw_start_from
this.Control[iCurrent+3]=this.dw_trans_to
this.Control[iCurrent+4]=this.dw_trans_from
this.Control[iCurrent+5]=this.st_start_to
this.Control[iCurrent+6]=this.st_trans_to
this.Control[iCurrent+7]=this.st_start_from
this.Control[iCurrent+8]=this.st_trans_from
this.Control[iCurrent+9]=this.rb_ax
this.Control[iCurrent+10]=this.cbx_deleted
this.Control[iCurrent+11]=this.cbx_modified
this.Control[iCurrent+12]=this.cbx_created
this.Control[iCurrent+13]=this.cbx_laidup
this.Control[iCurrent+14]=this.cbx_offservice
this.Control[iCurrent+15]=this.cbx_position
this.Control[iCurrent+16]=this.cbx_tcout
this.Control[iCurrent+17]=this.cbx_idlevoyage
this.Control[iCurrent+18]=this.cbx_singlevoyage
this.Control[iCurrent+19]=this.cb_refresh
this.Control[iCurrent+20]=this.gb_voyage_type
this.Control[iCurrent+21]=this.gb_status
this.Control[iCurrent+22]=this.gb_trans
this.Control[iCurrent+23]=this.gb_start_date
this.Control[iCurrent+24]=this.dw_transaction_log_list
this.Control[iCurrent+25]=this.gb_trans_type
this.Control[iCurrent+26]=this.st_topbar_background
this.Control[iCurrent+27]=this.st_1
this.Control[iCurrent+28]=this.st_2
this.Control[iCurrent+29]=this.st_3
this.Control[iCurrent+30]=this.sle_voyageno
this.Control[iCurrent+31]=this.em_lastday
this.Control[iCurrent+32]=this.dw_popup_modify_detail_preview
end on

on w_interface_log.destroy
call super::destroy
destroy(this.dw_start_to)
destroy(this.dw_start_from)
destroy(this.dw_trans_to)
destroy(this.dw_trans_from)
destroy(this.st_start_to)
destroy(this.st_trans_to)
destroy(this.st_start_from)
destroy(this.st_trans_from)
destroy(this.rb_ax)
destroy(this.cbx_deleted)
destroy(this.cbx_modified)
destroy(this.cbx_created)
destroy(this.cbx_laidup)
destroy(this.cbx_offservice)
destroy(this.cbx_position)
destroy(this.cbx_tcout)
destroy(this.cbx_idlevoyage)
destroy(this.cbx_singlevoyage)
destroy(this.cb_refresh)
destroy(this.gb_voyage_type)
destroy(this.gb_status)
destroy(this.gb_trans)
destroy(this.gb_start_date)
destroy(this.dw_transaction_log_list)
destroy(this.gb_trans_type)
destroy(this.st_topbar_background)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_voyageno)
destroy(this.em_lastday)
destroy(this.dw_popup_modify_detail_preview)
end on

event open;call super::open;string					ls_messageparm
long						ll_lastdays
n_service_manager		lnv_serviceMgr
n_dw_style_service	lnv_style

dw_trans_from.insertrow(0)
dw_trans_to.insertrow(0)
dw_start_from.insertrow(0)
dw_start_to.insertrow(0)

//Other window open this, get the open message
ls_messageparm = message.stringparm
if ls_messageparm <> '' then
	sle_voyageno.text = ls_messageparm
end if

ii_vessel_nr = uo_global.getvessel_nr()
if ii_vessel_nr >= 0 then wf_change_cbx_checked(true)

//Format window control.
lnv_serviceMgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_transaction_log_list, false)
uo_vesselselect.of_registerwindow(w_interface_log)
uo_vesselselect.of_setcurrentvessel(ii_vessel_nr)
uo_vesselselect.dw_vessel.setColumn("vessel_nr")
uo_vesselselect.dw_vessel.setfocus()
uo_vesselselect.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.st_criteria.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.st_criteria.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.dw_vessel.object.datawindow.color = string(c#color.MT_LISTHEADER_BG)

//Get the original datawindow SQL.
dw_transaction_log_list.settransobject(sqlca)
is_getsql = dw_transaction_log_list.getsqlselect()

//Default show all vessels's last 10 days interface log.
if ii_vessel_nr <= 0 then
	ll_lastdays = -long(em_lastday.text)
	
	dw_transaction_log_list.retrieve()
	dw_transaction_log_list.setfilter("TRANS_DATE > relativedate(today(), " + string(ll_lastdays) + ")")
	dw_transaction_log_list.filter()
end if

//Format datawindow.
dw_transaction_log_list.object.datawindow.readonly = "Yes"

dw_popup_modify_detail_preview.settransobject( SQLCA)


end event

event ue_retrieve;call super::ue_retrieve;/********************************************************************
   ue_retrieve
   <DESC>	Retrieve voyage.	</DESC>
   <RETURN>		</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		wparam
		lparam
   </ARGS>
   <USAGE>	In case change vessel, voyage datawindow will auto
				retrieve according the selected vessel.</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	22/12/2011 M5-1         WWG004        First Version
		20/10/2016	CR3320		AGL027		  Popup helper for transactions on modify
   </HISTORY>
********************************************************************/

cb_refresh.triggerevent(clicked!)
end event

event ue_vesselselection;call super::ue_vesselselection;postevent("ue_retrieve")
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_interface_log
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_interface_log
integer x = 18
integer y = 16
integer taborder = 10
end type

type dw_start_to from datawindow within w_interface_log
integer x = 3474
integer y = 400
integer width = 251
integer height = 68
integer taborder = 170
string title = "none"
string dataobject = "d_ex_gr_date_filter"
boolean border = false
boolean livescroll = true
end type

type dw_start_from from datawindow within w_interface_log
integer x = 3109
integer y = 400
integer width = 251
integer height = 68
integer taborder = 160
string title = "none"
string dataobject = "d_ex_gr_date_filter"
boolean border = false
boolean livescroll = true
end type

type dw_trans_to from datawindow within w_interface_log
integer x = 2615
integer y = 400
integer width = 251
integer height = 68
integer taborder = 150
string title = "none"
string dataobject = "d_ex_gr_date_filter"
boolean border = false
boolean livescroll = true
end type

type dw_trans_from from datawindow within w_interface_log
integer x = 2249
integer y = 400
integer width = 251
integer height = 68
integer taborder = 140
string title = "none"
string dataobject = "d_ex_gr_date_filter"
boolean border = false
boolean livescroll = true
end type

type st_start_to from statictext within w_interface_log
integer x = 3401
integer y = 404
integer width = 87
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "To"
boolean focusrectangle = false
end type

type st_trans_to from statictext within w_interface_log
integer x = 2542
integer y = 404
integer width = 87
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "To"
boolean focusrectangle = false
end type

type st_start_from from statictext within w_interface_log
integer x = 2981
integer y = 404
integer width = 123
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "From"
boolean focusrectangle = false
end type

type st_trans_from from statictext within w_interface_log
integer x = 2121
integer y = 404
integer width = 123
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "From"
boolean focusrectangle = false
end type

type rb_ax from radiobutton within w_interface_log
integer x = 2121
integer y = 244
integer width = 411
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "AX Operations"
boolean checked = true
end type

type cbx_deleted from checkbox within w_interface_log
integer x = 3479
integer y = 240
integer width = 251
integer height = 56
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Deleted"
end type

event clicked;wf_get_filter_status()

end event

type cbx_modified from checkbox within w_interface_log
integer x = 3479
integer y = 160
integer width = 270
integer height = 56
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Modified"
end type

event clicked;wf_get_filter_status()

end event

type cbx_created from checkbox within w_interface_log
integer x = 3479
integer y = 80
integer width = 270
integer height = 56
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Created"
end type

event clicked;wf_get_filter_status()

end event

type cbx_laidup from checkbox within w_interface_log
integer x = 3054
integer y = 240
integer width = 256
integer height = 56
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Laid Up"
end type

event clicked;wf_get_filter_voyagetype()
end event

type cbx_offservice from checkbox within w_interface_log
integer x = 3054
integer y = 80
integer width = 338
integer height = 56
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Off Service"
end type

event clicked;wf_get_filter_voyagetype()
end event

type cbx_position from checkbox within w_interface_log
integer x = 3054
integer y = 160
integer width = 256
integer height = 56
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Position"
end type

event clicked;wf_get_filter_voyagetype()
end event

type cbx_tcout from checkbox within w_interface_log
integer x = 2651
integer y = 240
integer width = 274
integer height = 56
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "T/C Out"
end type

event clicked;wf_get_filter_voyagetype()
end event

type cbx_idlevoyage from checkbox within w_interface_log
integer x = 2651
integer y = 160
integer width = 338
integer height = 56
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Idle Voyage"
end type

event clicked;wf_get_filter_voyagetype()
end event

type cbx_singlevoyage from checkbox within w_interface_log
integer x = 2651
integer y = 80
integer width = 393
integer height = 56
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Single Voyage"
end type

event clicked;wf_get_filter_voyagetype()
end event

type cb_refresh from commandbutton within w_interface_log
integer x = 3831
integer y = 32
integer width = 343
integer height = 100
integer taborder = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;string	ls_vesselnr, ls_voyagenr, ls_sql, ls_where, ls_showlast
string	ls_trans_from, ls_trans_to, ls_start_from, ls_start_to
long 		ll_where_pos, ll_transid = -1, ll_foundrow
long ll_firstrowincurrentview,ll_rowincurrentview,ll_detail_height,ll_dwpopup_height

ls_where	= ''
ls_sql	= ''
ls_sql	= is_getsql

if dw_popup_modify_detail_preview.visible and dw_transaction_log_list.rowcount() > 0 then
	ll_transid = dw_transaction_log_list.getitemnumber(_il_popupactiverow,"trans_id")
end if	

dw_transaction_log_list.reset()
dw_transaction_log_list.setfilter('')
dw_transaction_log_list.filter()

//M5-1 added by WWG004 on 20/01/2012. Change desc:fix bug, when clear vessel this window will display all data.
ls_vesselnr = uo_vesselselect.dw_vessel.getitemstring(1, "vessel_ref_nr")

//Get date filter
dw_trans_from.accepttext()
dw_trans_to.accepttext()
dw_start_from.accepttext()
dw_start_to.accepttext()
ls_trans_from	= string(dw_trans_from.getitemdate(1, "date_value"))
ls_trans_to		= string(dw_trans_to.getitemdate(1, "date_value")) + " 23:59:59"
ls_start_from 	= string(dw_start_from.getitemdate(1, "date_value"))
ls_start_to		= string(dw_start_to.getitemdate(1, "date_value")) + " 23:59:59"

ls_voyagenr = trim(sle_voyageno.text)
ls_showlast = trim(em_lastday.text)

if ls_vesselnr <> '' then
	if ls_where <> '' then ls_where += " AND "
	ls_where += "UPPER(VESSEL_REF_NR) = '" + ls_vesselnr + "'"
end if

if ls_showlast <> '' then
	if ls_where <> '' then ls_where += " AND "
	ls_where += "TRANS_DATE >= '" + string(relativedate(today(), - long(ls_showlast)), 'yyyy-MM-dd') + "'"
end if

if ls_voyagenr <> '' then
	if ls_where <> '' then ls_where += " AND "
	ls_where += "VOYAGE_NR = '" + ls_voyagenr + "'"
end if

if is_status <> '' then
	if ls_where <> '' then ls_where += " AND "
	ls_where += is_status
end if

if is_filter_voyagetype <> '' then
	if ls_where <> '' then ls_where += " AND "
	ls_where += is_filter_voyagetype
end if

if not isnull(ls_trans_from) then
	if ls_where <> '' then ls_where += " AND "
	ls_where += " TRANS_DATE >= '" + ls_trans_from + "'"
end if

if not isnull(ls_trans_to) then
	if ls_where <> '' then ls_where += " AND "
	ls_where += " TRANS_DATE <= '" + ls_trans_to + "'"
end if

if not isnull(ls_start_from) then
	if ls_where <> '' then ls_where += " AND "
	ls_where += " START_DATE >= '" + ls_start_from + "'"
end if

if not isnull(ls_start_to) then
	if ls_where <> '' then ls_where += " AND "
	ls_where += " START_DATE <= '" + ls_start_to + "'"
end if


if ls_where <> '' then
	/* allow for a where clause to already exist */
	ll_where_pos = pos(ls_sql,"WHERE")
	if ll_where_pos > 0 then	
		ls_sql = Replace(ls_sql, ll_where_pos, 5, " WHERE " + ls_where + " AND " )
	else 
		ls_where = " WHERE " + ls_where
		ls_sql += ls_where
	end if
end if

//Re-retrieve data.
if dw_transaction_log_list.setsqlselect(ls_sql) = 1 then
	dw_transaction_log_list.retrieve()
	// check if VM modify status popupdw is visible?
	if dw_popup_modify_detail_preview.visible or ll_transid <> -1 then
		ll_foundrow = dw_transaction_log_list.find("trans_id=" + string(ll_transid),1,dw_transaction_log_list.rowcount())
		if ll_foundrow > 0 then
			dw_transaction_log_list.scrolltorow(ll_foundrow)
			dw_transaction_log_list.selectrow( 0, false)
			dw_transaction_log_list.selectrow( ll_foundrow, true)
			dw_transaction_log_list.setrow(ll_foundrow)
			dw_popup_modify_detail_preview.retrieve(ll_transid)
			dw_popup_modify_detail_preview.selectrow(0,false)
			dw_popup_modify_detail_preview.setfocus( )
			/* get the y position inside dw_transaction_log_list to assist positioning the popupdw */
			ll_firstrowincurrentview =  long( dw_transaction_log_list.object.datawindow.firstrowonpage)
			ll_rowincurrentview = ll_foundrow - ll_firstrowincurrentview + 1
			ll_detail_height = long(dw_transaction_log_list.object.datawindow.detail.height)
			ll_dwpopup_height = dw_popup_modify_detail_preview.height
			if (( ll_detail_height * ll_rowincurrentview ) + ll_detail_height + ll_dwpopup_height > dw_transaction_log_list.height) then
				dw_popup_modify_detail_preview.y = dw_transaction_log_list.y + ( ll_detail_height * ll_rowincurrentview ) - ll_dwpopup_height
			else
				dw_popup_modify_detail_preview.y = dw_transaction_log_list.y + ( ll_detail_height * ll_rowincurrentview ) + ll_detail_height
			end if
			
			_il_popupactiverow = ll_foundrow
		else
			dw_popup_modify_detail_preview.visible=false
		end if
	end if	
	
else
	messagebox("Status", "Failed to retrieve data.")
end if
end event

type gb_voyage_type from groupbox within w_interface_log
integer x = 2615
integer y = 16
integer width = 791
integer height = 308
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Voyage Type"
end type

type gb_status from groupbox within w_interface_log
integer x = 3442
integer y = 16
integer width = 325
integer height = 308
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Status"
end type

type gb_trans from groupbox within w_interface_log
integer x = 2085
integer y = 336
integer width = 823
integer height = 168
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Trans Date"
end type

type gb_start_date from groupbox within w_interface_log
integer x = 2944
integer y = 336
integer width = 823
integer height = 168
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Start Date"
end type

type dw_transaction_log_list from mt_u_datawindow within w_interface_log
event ue_rbuttondown pbm_dwnrbuttondown
event ue_mousemove pbm_dwnmousemove
integer x = 37
integer y = 624
integer width = 4133
integer height = 1824
integer taborder = 190
boolean bringtotop = true
string dataobject = "d_sq_gr_interface_log"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

event clicked;n_service_manager	lnv_sm
n_dw_sort_service	lnv_sort
boolean lb_showpopup=false
long ll_firstrowincurrentview
long ll_rowincurrentview
long ll_detail_height
long ll_dwpopup_height


//Sort
if row = 0 then
	lnv_sm.of_loadService(lnv_sort, "n_dw_sort_service")
	lnv_sort.of_headersort(dw_transaction_log_list, row, dwo)
	return
else
	/* extention for the popup detail on modify VM txs when claims have already been sent to AX */
	if right(dwo.name,8) = "p_more" then
		if dw_popup_modify_detail_preview.visible and row <> _il_popupactiverow then
			dw_popup_modify_detail_preview.visible = false
			lb_showpopup = true
		elseif dw_popup_modify_detail_preview.visible then
			lb_showpopup = false
		else
			lb_showpopup = true
		end if
		
		if lb_showpopup then
			this.selectrow(0, false)
			this.selectrow( row, true)
			dw_popup_modify_detail_preview.retrieve(this.getitemnumber(row,"trans_id"))
			dw_popup_modify_detail_preview.x = Parent.PointerX() 
			/* get the y position inside dw_transaction_log_list to assist positioning the popupdw */
			ll_firstrowincurrentview =  long( dw_transaction_log_list.object.datawindow.firstrowonpage)
			ll_rowincurrentview = row - ll_firstrowincurrentview + 1
			ll_detail_height = long(dw_transaction_log_list.object.datawindow.detail.height)
			ll_dwpopup_height = dw_popup_modify_detail_preview.height
			if (( ll_detail_height * ll_rowincurrentview ) + ll_detail_height + ll_dwpopup_height > dw_transaction_log_list.height) then
				dw_popup_modify_detail_preview.y = dw_transaction_log_list.y + ( ll_detail_height * ll_rowincurrentview ) - ll_dwpopup_height
			else
				dw_popup_modify_detail_preview.y = dw_transaction_log_list.y + ( ll_detail_height * ll_rowincurrentview ) + ll_detail_height
			end if
			dw_popup_modify_detail_preview.selectrow(0,false)
			dw_popup_modify_detail_preview.setfocus( )
			_il_popupactiverow = row
		end if
		
		dw_popup_modify_detail_preview.visible = lb_showpopup
	else
		dw_popup_modify_detail_preview.visible = false
		this.selectrow(0, false)
		this.selectrow(row, true)		
		this.setrow(row)
	end if
end if
end event

type gb_trans_type from groupbox within w_interface_log
integer x = 2085
integer y = 184
integer width = 494
integer height = 140
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Transaction Type"
end type

type st_topbar_background from u_topbar_background within w_interface_log
integer width = 4215
integer height = 592
end type

type st_1 from statictext within w_interface_log
integer x = 2085
integer y = 112
integer width = 238
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Show last"
boolean focusrectangle = false
end type

type st_2 from statictext within w_interface_log
integer x = 2473
integer y = 112
integer width = 105
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "days"
boolean focusrectangle = false
end type

type st_3 from statictext within w_interface_log
integer x = 2085
integer y = 32
integer width = 270
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Voyage No"
boolean focusrectangle = false
end type

type sle_voyageno from singlelineedit within w_interface_log
integer x = 2341
integer y = 32
integer width = 238
integer height = 48
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean border = false
end type

type em_lastday from editmask within w_interface_log
integer x = 2341
integer y = 112
integer width = 114
integer height = 56
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "10"
boolean border = false
string mask = "#####"
end type

type dw_popup_modify_detail_preview from u_popupdw within w_interface_log
integer x = 498
integer y = 872
integer width = 2921
integer height = 356
integer taborder = 200
boolean bringtotop = true
string dataobject = "d_sq_gr_voymaster_modify_preview"
boolean resizable = false
borderstyle borderstyle = stylebox!
integer ii_maxheight = 744
integer ii_maxwidth = 3118
boolean ib_autoclose = false
end type

