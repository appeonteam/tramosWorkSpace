$PBExportHeader$w_company_contacts_overview.srw
$PBExportComments$Chartering contacts (single company view): Used in modify fixture and cargo, positions email list and send certificates by email
forward
global type w_company_contacts_overview from mt_w_response
end type
type st_3 from statictext within w_company_contacts_overview
end type
type cb_deletemap from commandbutton within w_company_contacts_overview
end type
type pb_new from picturebutton within w_company_contacts_overview
end type
type st_2 from statictext within w_company_contacts_overview
end type
type dw_outstanding from mt_u_datawindow within w_company_contacts_overview
end type
type dw_linkdetail from mt_u_datawindow within w_company_contacts_overview
end type
type cb_change_map from mt_u_commandbutton within w_company_contacts_overview
end type
type cb_update from mt_u_commandbutton within w_company_contacts_overview
end type
type uo_searchbox from u_searchbox within w_company_contacts_overview
end type
type dw_contact_detail from mt_u_datawindow within w_company_contacts_overview
end type
type dw_company_detail from mt_u_datawindow within w_company_contacts_overview
end type
type cb_cancel from mt_u_commandbutton within w_company_contacts_overview
end type
type gb_1 from groupbox within w_company_contacts_overview
end type
type gb_2 from groupbox within w_company_contacts_overview
end type
type dw_overview from mt_u_datawindow within w_company_contacts_overview
end type
type gb_6 from groupbox within w_company_contacts_overview
end type
type gb_7 from groupbox within w_company_contacts_overview
end type
type gb_8 from groupbox within w_company_contacts_overview
end type
type st_1 from statictext within w_company_contacts_overview
end type
end forward

global type w_company_contacts_overview from mt_w_response
integer width = 3611
integer height = 2568
long backcolor = 32304364
event ue_postopen ( )
st_3 st_3
cb_deletemap cb_deletemap
pb_new pb_new
st_2 st_2
dw_outstanding dw_outstanding
dw_linkdetail dw_linkdetail
cb_change_map cb_change_map
cb_update cb_update
uo_searchbox uo_searchbox
dw_contact_detail dw_contact_detail
dw_company_detail dw_company_detail
cb_cancel cb_cancel
gb_1 gb_1
gb_2 gb_2
dw_overview dw_overview
gb_6 gb_6
gb_7 gb_7
gb_8 gb_8
st_1 st_1
end type
global w_company_contacts_overview w_company_contacts_overview

type variables
s_company	istr_company_details
n_company_contacts_interface	inv_company_contacts
end variables

forward prototypes
private function integer _accepttext ()
public subroutine documentation ()
end prototypes

event ue_postopen();constant string METHOD_NAME = "ue_postopen "
long ll_row, ll_rows
string ls_linktable
long	ll_linkid, ll_pcgroupid, ll_companyid

n_service_manager 	lnv_SM
n_dw_Style_Service  	lnv_dwStyle

this.setredraw( FALSE )

inv_company_contacts = create n_company_contacts_interface

if inv_company_contacts.of_share( "companydetails", dw_company_detail) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Company detail", "The interface manager of_share() function failed while sharing the 'companydetails'")	
	return
end if
if inv_company_contacts.of_share( "contacts", dw_contact_detail) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Contacts detail", "The interface manager of_share() function failed while sharing the 'contacts'")	
	return
end if
if inv_company_contacts.of_share( "linkdetail", dw_linkdetail) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Link detail", "The interface manager of_share() function failed while sharing the 'linkdetail'")	
	return
end if
if inv_company_contacts.of_share( "incomeoverview", dw_overview) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Income Overview", "The interface manager of_share() function failed while sharing the 'incomeoverview'")	
	return
end if

lnv_SM.of_loadservice( lnv_dwStyle, "n_dw_style_service")

lnv_dwStyle.of_registercolumn("shortname",true,false)
lnv_dwStyle.of_registercolumn("company",true,false)
lnv_dwStyle.of_registercolumn("typeid",true,false)
lnv_dwStyle.of_registercolumn("countryid",true,false)
lnv_dwStyle.of_registercolumn("categoryid",true,false)

lnv_dwStyle.of_dwformformater(dw_company_detail)
lnv_dwStyle.of_dwlistformater(dw_contact_detail)


//Search Box
uo_SearchBox.of_initialize(dw_contact_detail, "fullname")
uo_SearchBox.st_search.backcolor = c#color.MT_FORM_BG


//Focus
if istr_company_details.companyid = 0 then
	dw_company_detail.setfocus( )
elseif istr_company_details.contactid <1 then
	uo_SearchBox.sle_search.setfocus()
end if

ll_rows = inv_company_contacts.of_retrieve_company( istr_company_details)

if ll_rows < 0 then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error retrieving data", "n/a")	
	return
end if

ls_linktable = dw_company_detail.getitemstring(ll_rows,"link_table")


if ls_linktable = "CHART" then
	if inv_company_contacts.of_share( "outstandingchart", dw_outstanding) = c#return.failure then
		this.setredraw( true )
		_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Outstanding Chart", "The interface manager of_share() function failed while sharing the 'outstandingchart'")	
		return
	end if
elseif  ls_linktable = "BROKER" then
	if inv_company_contacts.of_share( "outstandingbroker", dw_outstanding) = c#return.failure then
		this.setredraw( true )
		_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Outstanding Broker", "The interface manager of_share() function failed while sharing the 'outstandingbroker'")	
		return
	end if
else 
  //No data
end if

ll_rows = inv_company_contacts.of_retrieve_mapping( )
if ll_rows < 0 then
	_addMessage( this.classdefinition, METHOD_NAME, "Error retrieving data - map", "n/a")	
end if


//Window Title
if istr_company_details.companyid > 0 then
	this.title ="Company Details: " + dw_company_detail.getitemstring(1,"company")
else
	this.cb_change_map.enabled = false
	this.cb_deletemap.enabled = false
end if


this.setredraw( true )

end event

private function integer _accepttext ();dw_company_detail.accepttext()
dw_contact_detail.accepttext()

return c#return.success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_company_contacts_overview	- Contacts Overview (company+contacts)
   <OBJECT> Contacts overview by company 	</OBJECT>
   <USAGE> Displays company details and the list of contacts. Usage:
					- list of users in "send certificates by email"
					- list of users that receive the position list
					- fixture and cargo - company detail
   </USAGE>
   <ALSO>   	
   </ALSO>
<HISTORY> 
   Date	CR-Ref	 Author	Comments
   17/06/10	CR1412	Joana Carvalho	First Version
   19/10/10  CR1412	Joana Carvalho	Object redesign	
</HISTORY>    
********************************************************************/
end subroutine

on w_company_contacts_overview.create
int iCurrent
call super::create
this.st_3=create st_3
this.cb_deletemap=create cb_deletemap
this.pb_new=create pb_new
this.st_2=create st_2
this.dw_outstanding=create dw_outstanding
this.dw_linkdetail=create dw_linkdetail
this.cb_change_map=create cb_change_map
this.cb_update=create cb_update
this.uo_searchbox=create uo_searchbox
this.dw_contact_detail=create dw_contact_detail
this.dw_company_detail=create dw_company_detail
this.cb_cancel=create cb_cancel
this.gb_1=create gb_1
this.gb_2=create gb_2
this.dw_overview=create dw_overview
this.gb_6=create gb_6
this.gb_7=create gb_7
this.gb_8=create gb_8
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.cb_deletemap
this.Control[iCurrent+3]=this.pb_new
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_outstanding
this.Control[iCurrent+6]=this.dw_linkdetail
this.Control[iCurrent+7]=this.cb_change_map
this.Control[iCurrent+8]=this.cb_update
this.Control[iCurrent+9]=this.uo_searchbox
this.Control[iCurrent+10]=this.dw_contact_detail
this.Control[iCurrent+11]=this.dw_company_detail
this.Control[iCurrent+12]=this.cb_cancel
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.dw_overview
this.Control[iCurrent+16]=this.gb_6
this.Control[iCurrent+17]=this.gb_7
this.Control[iCurrent+18]=this.gb_8
this.Control[iCurrent+19]=this.st_1
end on

on w_company_contacts_overview.destroy
call super::destroy
destroy(this.st_3)
destroy(this.cb_deletemap)
destroy(this.pb_new)
destroy(this.st_2)
destroy(this.dw_outstanding)
destroy(this.dw_linkdetail)
destroy(this.cb_change_map)
destroy(this.cb_update)
destroy(this.uo_searchbox)
destroy(this.dw_contact_detail)
destroy(this.dw_company_detail)
destroy(this.cb_cancel)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.dw_overview)
destroy(this.gb_6)
destroy(this.gb_7)
destroy(this.gb_8)
destroy(this.st_1)
end on

event open;call super::open;constant string METHOD_NAME = "open"

istr_company_details = message.powerobjectparm

dw_contact_detail.height = 1190

post event ue_postopen( )
end event

event closequery;call super::closequery;_accepttext( )

if inv_company_contacts.of_Updatespending( ) then
	if MessageBox("Confirm row Changes", "You have data that is not saved yet. Would you like to save the data before closing?", Question!,YesNo!, 1) = 1 then
		return 1
	else 
		return 0
	end if
else
	return 0
end if	
end event

type st_3 from statictext within w_company_contacts_overview
integer x = 2537
integer y = 52
integer width = 983
integer height = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
string text = "Link this company and get a Financial Overview"
boolean focusrectangle = false
end type

type cb_deletemap from commandbutton within w_company_contacts_overview
integer x = 3173
integer y = 176
integer width = 352
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete Map"
end type

event clicked;//Delete mapping
inv_company_contacts.of_map_company_delete( )


end event

type pb_new from picturebutton within w_company_contacts_overview
integer x = 2322
integer y = 964
integer width = 110
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Insert!"
alignment htextalign = left!
string powertiptext = "New Contact"
end type

event clicked;//Add new contact to the list

long ll_row

_accepttext( )

ll_row = inv_company_contacts.of_insertrow("contacts")

dw_contact_detail.scrolltorow( ll_row)		
dw_contact_detail.setColumn("fullname")
dw_contact_detail.setfocus()

end event

type st_2 from statictext within w_company_contacts_overview
integer x = 2546
integer y = 1132
integer width = 562
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
string text = "Outstanding Amounts"
boolean focusrectangle = false
end type

type dw_outstanding from mt_u_datawindow within w_company_contacts_overview
integer x = 2551
integer y = 1208
integer width = 987
integer height = 1056
integer taborder = 40
boolean vscrollbar = true
boolean border = false
end type

type dw_linkdetail from mt_u_datawindow within w_company_contacts_overview
integer x = 2551
integer y = 292
integer width = 987
integer height = 324
integer taborder = 20
boolean border = false
end type

type cb_change_map from mt_u_commandbutton within w_company_contacts_overview
integer x = 2811
integer y = 176
integer width = 352
integer taborder = 30
string text = "Change &Map"
end type

event clicked;call super::clicked;//Change the mapping

constant string METHOD_NAME = "change_map"

s_company lstr_company_details

_accepttext( )

istr_company_details.shortname = dw_company_detail.getitemstring( 1, "shortname")
istr_company_details.companyname = dw_company_detail.getitemstring( 1, "company")
istr_company_details.type_id = dw_company_detail.getitemnumber( 1, "typeid")
istr_company_details.country_id = dw_company_detail.getitemnumber( 1, "countryid")
istr_company_details.link_table_name = dw_company_detail.getitemstring( 1, "link_table")
istr_company_details.link_id = dw_company_detail.getitemnumber( 1, "link_id")

openWithParm(w_companies_link,istr_company_details)

lstr_company_details =  message.powerobjectparm

if (lstr_company_details.link_id =istr_company_details.link_id and lstr_company_details.link_table_name =istr_company_details.link_table_name) or isnull(lstr_company_details.link_id) then return
	
istr_company_details = lstr_company_details

if istr_company_details.link_table_name = "CHART" then
	if inv_company_contacts.of_share( "outstandingchart", dw_outstanding) = c#return.failure then
		this.setredraw( true )
		_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Outstanding Chart", "The interface manager of_share() function failed while sharing the 'outstandingchart'")	
		return
	end if
elseif   istr_company_details.link_table_name  = "BROKER" then
	if inv_company_contacts.of_share( "outstandingbroker", dw_outstanding) = c#return.failure then
		this.setredraw( true )
		_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Outstanding Broker", "The interface manager of_share() function failed while sharing the 'outstandingbroker'")	
		return
	end if
else 
  //No data
end if


inv_company_contacts.of_map_company(lstr_company_details.link_table_name, lstr_company_details.link_id)

end event

type cb_update from mt_u_commandbutton within w_company_contacts_overview
integer x = 1769
integer y = 2340
integer taborder = 20
string text = "&Update"
end type

event clicked;call super::clicked;
constant string METHOD_NAME = "cb_update_clicked "
long	ll_companyid
s_company lstr_company_details

_accepttext( )

//Code disabled
//istr_company_details.shortname = dw_company_detail.getitemstring( 1, "shortname")
//istr_company_details.companyname = dw_company_detail.getitemstring( 1, "company")
//istr_company_details.link_table_name = dw_company_detail.getitemstring( 1, "link_table")
//istr_company_details.link_id = dw_company_detail.getitemnumber( 1, "link_id")
//
////If company is not mapped, then asks the user to map it
//if isnull(istr_company_details.link_table_name) or isnull(istr_company_details.link_id) then
//	if inv_company_contacts.of_check_company_link()>0 then
//		
//		istr_company_details.type_id = dw_company_detail.getitemnumber( 1, "typeid")
//		istr_company_details.country_id = dw_company_detail.getitemnumber( 1, "countryid")
//	
//		openWithParm(w_companies_link,istr_company_details)
//		lstr_company_details =  message.powerobjectparm
//	
//		if istr_company_details.link_id =lstr_company_details.link_id and istr_company_details.link_table_name =lstr_company_details.link_table_name then return
//		
//		istr_company_details = lstr_company_details
//	
//		inv_company_contacts.of_map_company(lstr_company_details.link_table_name, lstr_company_details.link_id)
//	
//	end if
//end if

//Update
if inv_company_contacts.of_update() = c#return.success then
	ll_companyid = dw_company_detail.getitemnumber( 1, "companyid")
	CloseWithReturn(Parent, ll_companyid)
end if






end event

type uo_searchbox from u_searchbox within w_company_contacts_overview
integer x = 82
integer y = 900
integer width = 1381
integer taborder = 40
long backcolor = 32304364
end type

on uo_searchbox.destroy
call u_searchbox::destroy
end on

type dw_contact_detail from mt_u_datawindow within w_company_contacts_overview
integer x = 82
integer y = 1080
integer width = 2345
integer height = 1188
integer taborder = 20
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;//Delete a contact

if row<1 then return 

if dwo.name = "t_delete" then
	inv_company_contacts.of_deleterow( "contacts", row)
end if
end event

type dw_company_detail from mt_u_datawindow within w_company_contacts_overview
integer x = 82
integer y = 72
integer width = 2345
integer height = 720
integer taborder = 10
boolean border = false
end type

type cb_cancel from mt_u_commandbutton within w_company_contacts_overview
integer x = 2139
integer y = 2340
integer taborder = 10
string text = "&Cancel"
end type

event clicked;call super::clicked;
CloseWithReturn(Parent, istr_company_details.companyid)
end event

type gb_1 from groupbox within w_company_contacts_overview
integer x = 41
integer width = 2427
integer height = 828
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
end type

type gb_2 from groupbox within w_company_contacts_overview
integer x = 41
integer y = 828
integer width = 2427
integer height = 1476
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
end type

type dw_overview from mt_u_datawindow within w_company_contacts_overview
integer x = 2551
integer y = 740
integer width = 987
integer height = 328
integer taborder = 40
boolean bringtotop = true
boolean border = false
end type

type gb_6 from groupbox within w_company_contacts_overview
integer x = 2514
integer y = 1096
integer width = 1051
integer height = 1204
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
end type

type gb_7 from groupbox within w_company_contacts_overview
integer x = 2514
integer y = 4
integer width = 1051
integer height = 648
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
end type

type gb_8 from groupbox within w_company_contacts_overview
integer x = 2514
integer y = 660
integer width = 1051
integer height = 432
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
end type

type st_1 from statictext within w_company_contacts_overview
integer x = 2551
integer y = 696
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
string text = "Overview"
boolean focusrectangle = false
end type

