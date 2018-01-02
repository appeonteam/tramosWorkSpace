$PBExportHeader$w_specialclaim_actionlist.srw
$PBExportComments$LIsts all user defined actions/tasks
forward
global type w_specialclaim_actionlist from mt_w_sheet
end type
type uo_searchbox from u_searchbox within w_specialclaim_actionlist
end type
type st_2 from mt_u_statictext within w_specialclaim_actionlist
end type
type dw_office from mt_u_datawindow within w_specialclaim_actionlist
end type
type st_1 from mt_u_statictext within w_specialclaim_actionlist
end type
type dw_responsible from mt_u_datawindow within w_specialclaim_actionlist
end type
type st_4 from mt_u_statictext within w_specialclaim_actionlist
end type
type cb_saveas from commandbutton within w_specialclaim_actionlist
end type
type cb_refresh from commandbutton within w_specialclaim_actionlist
end type
type dw_actionlist from mt_u_datawindow within w_specialclaim_actionlist
end type
type r_1 from rectangle within w_specialclaim_actionlist
end type
end forward

global type w_specialclaim_actionlist from mt_w_sheet
integer width = 4635
integer height = 2592
string title = "Special Claims Actions"
long backcolor = 32304364
event ue_postopen ( )
uo_searchbox uo_searchbox
st_2 st_2
dw_office dw_office
st_1 st_1
dw_responsible dw_responsible
st_4 st_4
cb_saveas cb_saveas
cb_refresh cb_refresh
dw_actionlist dw_actionlist
r_1 r_1
end type
global w_specialclaim_actionlist w_specialclaim_actionlist

type variables
n_specialclaim_actionlist_interface		inv_actionlist

end variables

event ue_postopen();constant string METHOD_NAME = "ue_postopen "

n_service_manager 	lnv_SM
n_dw_Style_Service  	lnv_dwStyle
long ll_rows

lnv_SM.of_loadservice( lnv_dwStyle, "n_dw_style_service")
lnv_dwStyle.of_dwlistformater( dw_actionlist, true )

uo_searchbox.of_initialize( dw_actionlist , "debtor")

dw_responsible.insertRow(0)
dw_office.insertRow(0)

dw_actionlist.setRowFocusIndicator( FocusRect!	)

ll_rows = inv_actionlist.of_retrieve()

if ll_rows < 0 then
	_addMessage( this.classdefinition, METHOD_NAME, "Error retrieving the Actionlist data", "n/a")	
	return
end if


end event

on w_specialclaim_actionlist.create
int iCurrent
call super::create
this.uo_searchbox=create uo_searchbox
this.st_2=create st_2
this.dw_office=create dw_office
this.st_1=create st_1
this.dw_responsible=create dw_responsible
this.st_4=create st_4
this.cb_saveas=create cb_saveas
this.cb_refresh=create cb_refresh
this.dw_actionlist=create dw_actionlist
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_searchbox
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.dw_office
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_responsible
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.cb_saveas
this.Control[iCurrent+8]=this.cb_refresh
this.Control[iCurrent+9]=this.dw_actionlist
this.Control[iCurrent+10]=this.r_1
end on

on w_specialclaim_actionlist.destroy
call super::destroy
destroy(this.uo_searchbox)
destroy(this.st_2)
destroy(this.dw_office)
destroy(this.st_1)
destroy(this.dw_responsible)
destroy(this.st_4)
destroy(this.cb_saveas)
destroy(this.cb_refresh)
destroy(this.dw_actionlist)
destroy(this.r_1)
end on

event open;call super::open;constant string METHOD_NAME = "open"

this.move(0,0)
this.setredraw( FALSE )

inv_actionlist = create n_specialclaim_actionlist_interface

if inv_actionlist.of_share( "actionlist", dw_actionlist ) = c#return.failure then
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for the Actionlist", "The interface manager of_share() function failed while sharing the 'actionlist'")	
	return
end if

post event ue_postopen( )
end event

event activate;call super::activate;If w_tramos_main.MenuName <> "m_tramosmain" Then
	w_tramos_main.ChangeMenu(m_tramosmain)
End if
end event

type uo_searchbox from u_searchbox within w_specialclaim_actionlist
integer x = 2757
integer y = 36
integer taborder = 10
end type

event constructor;this.backcolor = c#color.MT_LISTHEADER_BG
this.st_search.text = ""
this.st_search.backcolor = c#color.MT_LISTHEADER_BG

end event

on uo_searchbox.destroy
call u_searchbox::destroy
end on

type st_2 from mt_u_statictext within w_specialclaim_actionlist
integer x = 2501
integer y = 108
integer width = 247
long textcolor = 16777215
long backcolor = 22628899
string text = "Customer"
alignment alignment = right!
end type

event constructor;call super::constructor;this.backcolor = c#color.MT_LISTHEADER_BG
this.textcolor = c#color.MT_LISTHEADER_TEXT

end event

type dw_office from mt_u_datawindow within w_specialclaim_actionlist
event ue_dropdown pbm_dwndropdown
event ue_dwdropdown pbm_dwndropdown
event ue_keydown pbm_dwnkey
integer x = 1833
integer y = 104
integer width = 453
integer height = 72
integer taborder = 40
string dataobject = "d_sq_tb_office_selection"
boolean border = false
end type

event ue_dwdropdown;constant string METHOD_NAME = "ue_dwDRopDown"
long 	ll_rows
datawindowchild	ldwc

if this.getChild( "office_nr", ldwc ) = -1 then
	_addMessage( this.classdefinition, METHOD_NAME, "There was an error while sharing the Child Datawindow behind dropdown", "N/A")
	return 
end if

if ldwc.rowcount() < 1 then
	ldwc.setTRansOBject(SQLCA)
	ldwc.retrieve()
end if
end event

event ue_keydown;long ll_null

if key = KeyDelete! then
	setNull(ll_null)
	choose case this.getColumnName()
		case "office_nr" 
			this.setItem(this.getRow(), "office_nr", ll_null)
			uo_searchbox.cb_clear.event clicked()
			uo_searchbox.of_SetOriginalFilter("") 
			uo_searchbox.of_dofilter( )
	end choose
end if
	
end event

event itemchanged;call super::itemchanged;if row > 0 then
	if not isnull(data) then 
		dw_responsible.setItem(1, "userid", "")
		uo_searchbox.cb_clear.event clicked()
		uo_searchbox.of_SetOriginalFilter("responsible_office="+data) 
	else
		uo_searchbox.of_SetOriginalFilter("") 
	end if
	uo_searchbox.of_DoFilter()
end if
end event

type st_1 from mt_u_statictext within w_specialclaim_actionlist
integer x = 1687
integer y = 108
integer width = 137
long textcolor = 16777215
long backcolor = 22628899
string text = "Office"
alignment alignment = right!
end type

event constructor;call super::constructor;this.backcolor = c#color.MT_LISTHEADER_BG
this.textcolor = c#color.MT_LISTHEADER_TEXT

end event

type dw_responsible from mt_u_datawindow within w_specialclaim_actionlist
event ue_dwdropdown pbm_dwndropdown
event ue_keydown pbm_dwnkey
integer x = 622
integer y = 104
integer width = 882
integer height = 72
integer taborder = 20
string dataobject = "d_sq_tb_responsible_selection"
boolean border = false
end type

event ue_dwdropdown;constant string METHOD_NAME = "ue_dwDRopDown"
long 	ll_rows
datawindowchild	ldwc

if this.getChild( "userid", ldwc ) = -1 then
	_addMessage( this.classdefinition, METHOD_NAME, "There was an error while sharing the Child Datawindow behind dropdown", "N/A")
	return 
end if

if ldwc.rowcount() < 1 then
	ldwc.setTRansOBject(SQLCA)
	ldwc.retrieve()
end if
end event

event ue_keydown;string ls_null

if key = KeyDelete! then
	setNull(ls_null)
	choose case this.getColumnName()
		case "userid" 
			this.setItem(this.getRow(), "userid", ls_null)
			uo_searchbox.cb_clear.event clicked()
			uo_searchbox.of_SetOriginalFilter("") 
			uo_searchbox.of_dofilter( )
	end choose
end if
		
end event

event itemchanged;call super::itemchanged;long  ll_null;SetNUll(ll_null)

if row > 0 then
	if not isnull(data) then 
		dw_office.setITem(1, "office_nr", ll_null)
		uo_searchbox.cb_clear.event clicked()
		uo_searchbox.of_SetOriginalFilter("assigned_to='"+data+"'") 
	else
		uo_searchbox.of_SetOriginalFilter("") 
	end if
	uo_searchbox.of_DoFilter()
end if
end event

type st_4 from mt_u_statictext within w_specialclaim_actionlist
integer x = 329
integer y = 108
integer width = 279
long textcolor = 16777215
long backcolor = 22628899
string text = "Responsible"
alignment alignment = right!
end type

event constructor;call super::constructor;this.backcolor = c#color.MT_LISTHEADER_BG
this.textcolor = c#color.MT_LISTHEADER_TEXT

end event

type cb_saveas from commandbutton within w_specialclaim_actionlist
integer x = 411
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_actionlist.saveas()
end event

type cb_refresh from commandbutton within w_specialclaim_actionlist
integer x = 41
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Refresh"
end type

event clicked;inv_actionlist.of_retrieve()
dw_actionlist.setFocus()


end event

type dw_actionlist from mt_u_datawindow within w_specialclaim_actionlist
integer x = 41
integer y = 252
integer width = 4517
integer height = 2088
integer taborder = 9
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;n_service_manager	lnv_SM
n_dw_sort_service	lnv_sort

//nothing to do
if row < 0 then return

//Sort
if row = 0 then
	lnv_SM.of_loadService(lnv_sort, "n_dw_sort_service")
	lnv_sort.of_headersort( dw_actionlist, row, dwo)
	return
end if


end event

type r_1 from rectangle within w_specialclaim_actionlist
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 22628899
integer x = -41
integer width = 4645
integer height = 216
end type

