$PBExportHeader$w_companies.srw
forward
global type w_companies from mt_w_sheet
end type
type dw_companieslist from mt_u_datawindow within w_companies
end type
type cb_new from commandbutton within w_companies
end type
type cb_update from commandbutton within w_companies
end type
type cb_cancel from commandbutton within w_companies
end type
type cb_delete from commandbutton within w_companies
end type
type cb_collapse from commandbutton within w_companies
end type
type cb_expand from commandbutton within w_companies
end type
type uo_searchbox from u_searchbox within w_companies
end type
type uo_pcgroup from u_pcgroup within w_companies
end type
type pb_new from picturebutton within w_companies
end type
type tab_1 from tab within w_companies
end type
type tabpage_1 from userobject within tab_1
end type
type st_3 from statictext within tabpage_1
end type
type st_2 from statictext within tabpage_1
end type
type dw_outstanding from mt_u_datawindow within tabpage_1
end type
type st_1 from statictext within tabpage_1
end type
type dw_overview from mt_u_datawindow within tabpage_1
end type
type cb_deletemap from commandbutton within tabpage_1
end type
type cb_1 from mt_u_commandbutton within tabpage_1
end type
type cb_change_map from mt_u_commandbutton within tabpage_1
end type
type dw_1 from mt_u_datawindow within tabpage_1
end type
type dw_linkdetail from mt_u_datawindow within tabpage_1
end type
type dw_company_detail from mt_u_datawindow within tabpage_1
end type
type gb_1 from groupbox within tabpage_1
end type
type gb_2 from groupbox within tabpage_1
end type
type ln_1 from line within tabpage_1
end type
type tabpage_1 from userobject within tab_1
st_3 st_3
st_2 st_2
dw_outstanding dw_outstanding
st_1 st_1
dw_overview dw_overview
cb_deletemap cb_deletemap
cb_1 cb_1
cb_change_map cb_change_map
dw_1 dw_1
dw_linkdetail dw_linkdetail
dw_company_detail dw_company_detail
gb_1 gb_1
gb_2 gb_2
ln_1 ln_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_contact_detail from mt_u_datawindow within tabpage_2
end type
type uo_searchbox_contact from u_searchbox within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_contact_detail dw_contact_detail
uo_searchbox_contact uo_searchbox_contact
end type
type tab_1 from tab within w_companies
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_companies from mt_w_sheet
integer width = 3698
integer height = 2408
string title = "Companies"
boolean maxbox = false
long backcolor = 32304364
string icon = "images\DISTLSTL.ICO"
boolean center = false
event type integer ue_pcgroupchanged ( integer ai_pcgroupid )
event ue_postopen ( )
dw_companieslist dw_companieslist
cb_new cb_new
cb_update cb_update
cb_cancel cb_cancel
cb_delete cb_delete
cb_collapse cb_collapse
cb_expand cb_expand
uo_searchbox uo_searchbox
uo_pcgroup uo_pcgroup
pb_new pb_new
tab_1 tab_1
end type
global w_companies w_companies

type variables
integer	ii_pcgroup
n_company_contacts_interface	inv_company_contacts
//s_company	istr_company_details
long	il_companyid, il_selectedrow

end variables

forward prototypes
public subroutine wf_list_selectrow (long al_row, integer ai_level)
public subroutine documentation ()
private subroutine _init_gui ()
private function integer wf_refresh_contactslist (long al_row, integer ai_selecttab)
private function integer _accepttext ()
private subroutine _showlinkoverview (boolean ab_show)
private subroutine _changeoutstanding (string as_link_table)
end prototypes

event type integer ue_pcgroupchanged(integer ai_pcgroupid);constant string METHOD_NAME = "ue_pcgroupchanged"

long	ll_rows

_accepttext( )

if inv_company_contacts.of_updatespending( ) =true then 
	if MessageBox("Corfirm row Changes", "You have data that are not saved yet. Would you like to save the date before switching?", Question!,YesNo!, 1) = 1 then
		return ii_pcgroup
	end if
end if

il_companyid = 0
il_selectedrow = 0
//cancel changes
tab_1.tabpage_1.dw_company_detail.reset()
tab_1.tabpage_2.dw_contact_detail.reset()
		
ii_pcgroup = ai_pcgroupid
ll_rows = inv_company_contacts.of_retrieve(ii_pcgroup)
if ll_rows < 0 then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error retrieving data", "n/a")	
	return ii_pcgroup
end if

_init_gui( )

wf_refresh_contactslist( 0, 1)

return ii_pcgroup
end event

event ue_postopen();constant string METHOD_NAME = "ue_postopen "
long ll_row, ll_rows
string ls_linktable
long	ll_linkid, ll_pcgroupid, ll_companyid

n_service_manager 	lnv_SM
n_dw_Style_Service  	lnv_dwStyle

this.setredraw( FALSE )

inv_company_contacts = create n_company_contacts_interface

if inv_company_contacts.of_share( "companypicklist", dw_companieslist) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for PickList", "The interface manager of_share() function failed while sharing the 'companypicklist'")	
	return
end if

if inv_company_contacts.of_share( "companydetails", tab_1.tabpage_1.dw_company_detail) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Company detail", "The interface manager of_share() function failed while sharing the 'companydetails'")	
	return
end if
if inv_company_contacts.of_share( "contacts", tab_1.tabpage_2.dw_contact_detail) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Contacts detail", "The interface manager of_share() function failed while sharing the 'contacts'")	
	return
end if
if inv_company_contacts.of_share( "linkdetail", tab_1.tabpage_1.dw_linkdetail) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Link detail", "The interface manager of_share() function failed while sharing the 'linkdetail'")	
	return
end if
if inv_company_contacts.of_share( "incomeoverview", tab_1.tabpage_1.dw_overview) = c#return.failure then
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

lnv_dwStyle.of_dwformformater(tab_1.tabpage_1.dw_company_detail)
lnv_dwStyle.of_dwlistformater(tab_1.tabpage_2.dw_contact_detail)
lnv_dwStyle.of_dwlistformater(dw_companieslist)

//search
uo_SearchBox.of_initialize(dw_companieslist, "company")
uo_SearchBox.sle_search.POST setfocus()

//uo_searchbox_contact
tab_1.tabpage_2.uo_searchbox_contact.of_initialize(tab_1.tabpage_2.dw_contact_detail, "fullname")

//Select contact
wf_refresh_contactslist( 0, 1)

//Buttons
_init_gui( )

this.setredraw( true )


end event

public subroutine wf_list_selectrow (long al_row, integer ai_level);//selects a row in the tree view
dw_companieslist.SelectTreeNode(0,2,false)
dw_companieslist.SelectTreeNode(0,1,false)		
dw_companieslist.SelectTreeNode(al_row,ai_level,true)

tab_1.selecttab(ai_level)


end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_contacts	- Window Contacts
   <OBJECT> List of Companies. List of contacts by company.
	Company and contacts details. Map company to a finance company 	</OBJECT>
   <USAGE> To search a company and/or a contact
   </USAGE>
   <ALSO>   	
   </ALSO>
<HISTORY> 
   Date			CR-Ref		Author		Comments
	17/06/10		CR1412		Joana			First Version
	21/10/10		CR1412		Joana			Redesign
	10/08/12		CR2903		Koko			Modify closequery, open
  	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
</HISTORY>    
********************************************************************/

end subroutine

private subroutine _init_gui ();//buttons enable and disable
if dw_companieslist.rowcount( ) > 0 then
	cb_new.enabled = true 
	cb_update.enabled = true
	cb_delete.enabled = true
	cb_cancel.enabled = true
	cb_collapse.enabled = true
	cb_expand.enabled = true
	tab_1.tabpage_2.enabled = true
	_showlinkoverview(true)
else
	cb_new.enabled = true 
	cb_update.enabled = false
	cb_delete.enabled = false
	cb_cancel.enabled = false
	cb_collapse.enabled = false
	cb_expand.enabled = false
	tab_1.tabpage_2.enabled = false
	_showlinkoverview(false)
end if

end subroutine

private function integer wf_refresh_contactslist (long al_row, integer ai_selecttab);//search for a contact in the list and make sure the right node is selected and expanded

constant string METHOD_NAME = "wf_refresh_contactslist "

long	ll_rows

//Retrieves companies list
ll_rows = inv_company_contacts.of_retrieve(ii_pcgroup)
if ll_rows < 0 then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error retrieving list", "n/a")	
	return 0
end if

//Search company and gets the row
if al_row = -1 then
	al_row = dw_companieslist.find( "companyid=" + string(il_companyid), 1, dw_companieslist.rowcount( ))
end if

if al_row > dw_companieslist.rowcount( ) or al_row <1 then al_row = 1
	
//Select row
dw_companieslist.event clicked(0, 0, al_row,dw_companieslist.object)

//Expands company and shows contacts in the list
if al_row = 0 then
	dw_companieslist.SelectTreeNode(1,1,true)
else
	dw_companieslist.expand( al_row, 1)
	dw_companieslist.scrolltorow(al_row)
end if

tab_1.selecttab(ai_selecttab)

_init_gui( )

return 0
end function

private function integer _accepttext ();//aply user changes

tab_1.tabpage_1.dw_company_detail.accepttext()
tab_1.tabpage_2.dw_contact_detail.accepttext()

return c#return.success
end function

private subroutine _showlinkoverview (boolean ab_show);tab_1.tabpage_1.dw_linkdetail.visible = ab_show
tab_1.tabpage_1.dw_overview.visible = ab_show
tab_1.tabpage_1.cb_change_map.visible = ab_show
tab_1.tabpage_1.cb_deletemap.visible = ab_show
tab_1.tabpage_1.dw_outstanding.visible = ab_show


end subroutine

private subroutine _changeoutstanding (string as_link_table);//change dw_outstanding

constant string METHOD_NAME = "_changeoutstanding"
if as_link_table = "CHART" then
	if inv_company_contacts.of_share( "outstandingchart", tab_1.tabpage_1.dw_outstanding) = c#return.failure then
		this.setredraw( true )
		_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Outstanding Chart", "The interface manager of_share() function failed while sharing the 'outstandingchart'")	
		return
	end if
elseif  as_link_table  = "BROKER" then
	if inv_company_contacts.of_share( "outstandingbroker",  tab_1.tabpage_1.dw_outstanding) = c#return.failure then
		this.setredraw( true )
		_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Outstanding Broker", "The interface manager of_share() function failed while sharing the 'outstandingbroker'")	
		return
	end if
else 
  //No data
end if
end subroutine

on w_companies.create
int iCurrent
call super::create
this.dw_companieslist=create dw_companieslist
this.cb_new=create cb_new
this.cb_update=create cb_update
this.cb_cancel=create cb_cancel
this.cb_delete=create cb_delete
this.cb_collapse=create cb_collapse
this.cb_expand=create cb_expand
this.uo_searchbox=create uo_searchbox
this.uo_pcgroup=create uo_pcgroup
this.pb_new=create pb_new
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_companieslist
this.Control[iCurrent+2]=this.cb_new
this.Control[iCurrent+3]=this.cb_update
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.cb_collapse
this.Control[iCurrent+7]=this.cb_expand
this.Control[iCurrent+8]=this.uo_searchbox
this.Control[iCurrent+9]=this.uo_pcgroup
this.Control[iCurrent+10]=this.pb_new
this.Control[iCurrent+11]=this.tab_1
end on

on w_companies.destroy
call super::destroy
destroy(this.dw_companieslist)
destroy(this.cb_new)
destroy(this.cb_update)
destroy(this.cb_cancel)
destroy(this.cb_delete)
destroy(this.cb_collapse)
destroy(this.cb_expand)
destroy(this.uo_searchbox)
destroy(this.uo_pcgroup)
destroy(this.pb_new)
destroy(this.tab_1)
end on

event open;constant string METHOD_NAME = "open"

this.post move(0,0)

//profit center group
ii_pcgroup=uo_pcgroup.uf_getpcgroup( )
if ii_pcgroup<0 then
	MessageBox("Error", "You do not have all profit centers required on your profile " + &
	"to open this window. Please contact the Tramos support team.")
	close(this)
else
	
	uo_SearchBox.st_search.backcolor = c#color.MT_FORM_BG
	
	//search
	uo_SearchBox.st_search.backcolor = c#color.MT_FORM_BG
	tab_1.tabpage_2.uo_searchbox_contact.st_search.backcolor = c#color.MT_FORM_BG
	uo_pcgroup.dw_pcgroup.Object.DataWindow.Color = c#color.MT_FORM_BG

	post event ue_postopen( )
end if



end event

event closequery;call super::closequery;_accepttext( )

if isvalid(inv_company_contacts) then
	if inv_company_contacts.of_Updatespending( ) then
		if MessageBox("Confirm row Changes", "You have data that is not saved yet. Would you like to save the data before closing?", Question!,YesNo!, 1) = 1 then
			return 1		
		end if
	end if
end if

return 0




end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_companies
end type

type dw_companieslist from mt_u_datawindow within w_companies
integer x = 37
integer y = 396
integer width = 1061
integer height = 1752
integer taborder = 50
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;constant string METHOD_NAME = "companieslist_click "

string	ls_band, ls_linktable
integer	li_tab, li_tmpRow
long	 ll_companyid_new, ll_contactid_new, ll_findrow

if dw_companieslist.rowcount( ) <1 then return 

//Get company ID of the selected row
if row=0 then
	ls_band = this.GetBandAtPointer()
	
	li_tab = Pos(ls_band, "~t", 1)
	li_tmpRow = Integer(Mid(ls_band, li_tab + 1))
	
	//click on header
	if li_tmpRow=0 then li_tmpRow = 1
	
	ls_band = Left(ls_band, li_tab - 1)

	ll_companyid_new=this.getitemnumber(li_tmpRow, "companyid")
	ll_contactid_new=-1
else 	
	ll_companyid_new=dw_companieslist.getitemnumber(row, "companyid")
	ll_contactid_new=dw_companieslist.getitemnumber(row, "pf_companycontacts_contactsid")
end if

//If user selects a node that belongs to the same company that is selected (for example a contact)
// then company details and contacts are not refreshed. In this case it´s only need to select the node
if  il_companyid =ll_companyid_new then 	
	if li_tmpRow >0 then
		wf_list_selectrow( li_tmpRow, 1)
		il_selectedrow= li_tmpRow
	else	
		wf_list_selectrow( row, 2)
		il_selectedrow = row
	end if
	//Select contact in the contacts list
	if ll_contactid_new > 0 then
		ll_findrow = tab_1.tabpage_2.dw_contact_detail.find("contactsid=" + string(ll_contactid_new), 1,  tab_1.tabpage_2.dw_contact_detail.rowcount( ))
		if ll_findrow > 0 then
			 tab_1.tabpage_2.dw_contact_detail.scrolltorow( ll_findrow)
			 tab_1.tabpage_2.dw_contact_detail.setcolumn( "fullname")
			 tab_1.tabpage_2.dw_contact_detail.setfocus( )
		end if
	end if
	
	return 
end if

_accepttext( )

//Check updates pending
if inv_company_contacts.of_updatespending( ) =true then 
	if MessageBox("Corfirm row Changes", "You have data that are not saved yet. Would you like to save the date before switching?", Question!,YesNo!, 1) = 1 then return
end if

setPointer(hourGlass!)

//Select new row
if li_tmpRow >0 then
	wf_list_selectrow( li_tmpRow, 1)
	il_selectedrow = li_tmpRow
else	
	wf_list_selectrow( row, 2)
	il_selectedrow = row
end if

 il_companyid =ll_companyid_new

tab_1.tabpage_2.uo_searchbox_contact.cb_clear.event clicked( )

//Retrieves company
if li_tmpRow >0 then
	 inv_company_contacts.of_rowfocuschanged( "companypicklist", li_tmpRow)
else
	 inv_company_contacts.of_rowfocuschanged( "companypicklist", row)
end if

ls_linktable = tab_1.tabpage_1.dw_company_detail.getitemstring(1,"link_table")

 _changeoutstanding(ls_linktable)
 
 tab_1.tabpage_1.dw_outstanding.visible = true
 
 inv_company_contacts.of_retrieve_mapping( )
  
 if tab_1.tabpage_1.dw_outstanding.rowcount( ) =0 then
	tab_1.tabpage_1.dw_outstanding.visible = false
end if

//if contact selected, then select contact in the contacts list
if ll_contactid_new > 0 then
	ll_findrow = tab_1.tabpage_2.dw_contact_detail.find("contactsid=" + string(ll_contactid_new), 1,  tab_1.tabpage_2.dw_contact_detail.rowcount( ))
	if ll_findrow > 0 then
		 tab_1.tabpage_2.dw_contact_detail.scrolltorow( ll_findrow)
		 tab_1.tabpage_2.dw_contact_detail.setcolumn( "fullname")
		 tab_1.tabpage_2.dw_contact_detail.setfocus( )
	end if
end if
	
 _init_gui( )

 SetPointer(Arrow!)	



 

end event

type cb_new from commandbutton within w_companies
integer x = 2226
integer y = 2184
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
end type

event clicked;
_accepttext( )

if inv_company_contacts.of_Updatespending( ) then
	if MessageBox("Confirm row Changes", "You have data that is not saved yet. Would you like to save the data before closing?", Question!,YesNo!, 1) = 1 then
		return 1
	end if
end if

tab_1.selecttab( 1)

tab_1.tabpage_2.uo_searchbox_contact.visible = false

inv_company_contacts.of_insertrow( "companydetails")

tab_1.tabpage_1.dw_company_detail.post setfocus()

il_companyid  = 0

tab_1.tabpage_2.enabled = true
cb_update.enabled = true
cb_new.enabled = false
cb_cancel.enabled = true 


end event

type cb_update from commandbutton within w_companies
integer x = 2578
integer y = 2184
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;
constant string METHOD_NAME = "clicked "
long	ll_row_find, ll_companyid
integer	li_selectedtab

ll_companyid =  tab_1.tabpage_1.dw_company_detail.getitemnumber( 1, "companyid")

_accepttext( )

if inv_company_contacts.of_update() =c#return.success then

	il_companyid = tab_1.tabpage_1.dw_company_detail.getitemnumber( 1, "companyid")
	
	tab_1.tabpage_2.uo_searchbox_contact.visible = true 
	
	//refreh list
	if ll_companyid>0 then
		//Finds the first row of the contact
		ll_row_find = dw_companieslist.find( "companyid=" + string(il_companyid), 1, dw_companieslist.rowcount( ))
	else
		ll_row_find = -1
	end if
	li_selectedtab = tab_1.SelectedTab
	
	wf_refresh_contactslist(ll_row_find, li_selectedtab)

end if
end event

type cb_cancel from commandbutton within w_companies
integer x = 3282
integer y = 2184
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;string	ls_linktable
tab_1.tabpage_1.dw_outstanding.visible = true

if il_selectedrow<1 then
	//cancel changes
	tab_1.tabpage_1.dw_company_detail.reset()
	tab_1.tabpage_2.dw_contact_detail.reset()
	_init_gui( )
	return
else
	tab_1.tabpage_2.uo_searchbox_contact.visible = true
end if

inv_company_contacts.of_rowfocuschanged( "companypicklist", il_selectedrow)

ls_linktable = tab_1.tabpage_1.dw_company_detail.getitemstring(1,"link_table")

 _changeoutstanding(ls_linktable)
 
 tab_1.tabpage_1.dw_outstanding.visible = true
 
 inv_company_contacts.of_retrieve_mapping( )
  
 if tab_1.tabpage_1.dw_outstanding.rowcount( ) =0 then
	tab_1.tabpage_1.dw_outstanding.visible = false
end if


end event

type cb_delete from commandbutton within w_companies
integer x = 2930
integer y = 2184
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;long	 ll_row_find

//Finds the first row of the contact
ll_row_find = dw_companieslist.find( "companyid=" + string(il_companyid ), 1, dw_companieslist.rowcount( ))

if inv_company_contacts.of_deleterow( "companydetails", 1) =  c#return.success then
	
	wf_refresh_contactslist(ll_row_find, 1)

end if


end event

type cb_collapse from commandbutton within w_companies
integer x = 389
integer y = 2164
integer width = 343
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Colla&pse All"
end type

event clicked;dw_companieslist.collapseall( )

end event

type cb_expand from commandbutton within w_companies
integer x = 37
integer y = 2164
integer width = 343
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "E&xpand All"
end type

event clicked;dw_companieslist.expandall()

end event

type uo_searchbox from u_searchbox within w_companies
integer x = 37
integer y = 208
integer width = 1042
integer taborder = 20
long backcolor = 32304364
end type

on uo_searchbox.destroy
call u_searchbox::destroy
end on

type uo_pcgroup from u_pcgroup within w_companies
event ue_change pbm_enchange
integer x = 37
integer y = 36
integer height = 152
integer taborder = 160
long backcolor = 32304364
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type pb_new from picturebutton within w_companies
integer x = 3456
integer y = 292
integer width = 110
integer height = 96
integer taborder = 40
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

event clicked;long ll_row

_accepttext( )

ll_row = inv_company_contacts.of_insertrow("contacts")

tab_1.tabpage_2.dw_contact_detail.scrolltorow( ll_row)		
tab_1.tabpage_2.dw_contact_detail.setColumn("fullname")
tab_1.tabpage_2.dw_contact_detail.setfocus()

end event

type tab_1 from tab within w_companies
integer x = 1152
integer y = 36
integer width = 2469
integer height = 2124
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;if newindex = 1 then
	pb_new.visible = False
else
	pb_new.visible = True
end if
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2432
integer height = 2008
long backcolor = 32304364
string text = "General"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_3 st_3
st_2 st_2
dw_outstanding dw_outstanding
st_1 st_1
dw_overview dw_overview
cb_deletemap cb_deletemap
cb_1 cb_1
cb_change_map cb_change_map
dw_1 dw_1
dw_linkdetail dw_linkdetail
dw_company_detail dw_company_detail
gb_1 gb_1
gb_2 gb_2
ln_1 ln_1
end type

on tabpage_1.create
this.st_3=create st_3
this.st_2=create st_2
this.dw_outstanding=create dw_outstanding
this.st_1=create st_1
this.dw_overview=create dw_overview
this.cb_deletemap=create cb_deletemap
this.cb_1=create cb_1
this.cb_change_map=create cb_change_map
this.dw_1=create dw_1
this.dw_linkdetail=create dw_linkdetail
this.dw_company_detail=create dw_company_detail
this.gb_1=create gb_1
this.gb_2=create gb_2
this.ln_1=create ln_1
this.Control[]={this.st_3,&
this.st_2,&
this.dw_outstanding,&
this.st_1,&
this.dw_overview,&
this.cb_deletemap,&
this.cb_1,&
this.cb_change_map,&
this.dw_1,&
this.dw_linkdetail,&
this.dw_company_detail,&
this.gb_1,&
this.gb_2,&
this.ln_1}
end on

on tabpage_1.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_outstanding)
destroy(this.st_1)
destroy(this.dw_overview)
destroy(this.cb_deletemap)
destroy(this.cb_1)
destroy(this.cb_change_map)
destroy(this.dw_1)
destroy(this.dw_linkdetail)
destroy(this.dw_company_detail)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.ln_1)
end on

type st_3 from statictext within tabpage_1
integer x = 73
integer y = 904
integer width = 1029
integer height = 116
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

type st_2 from statictext within tabpage_1
integer x = 1349
integer y = 872
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

type dw_outstanding from mt_u_datawindow within tabpage_1
integer x = 1353
integer y = 940
integer width = 987
integer height = 1020
integer taborder = 50
boolean vscrollbar = true
boolean border = false
end type

type st_1 from statictext within tabpage_1
integer x = 82
integer y = 1516
integer width = 343
integer height = 56
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

type dw_overview from mt_u_datawindow within tabpage_1
integer x = 78
integer y = 1584
integer width = 987
integer height = 340
integer taborder = 50
boolean border = false
end type

type cb_deletemap from commandbutton within tabpage_1
integer x = 713
integer y = 1024
integer width = 352
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete Map"
end type

event clicked;inv_company_contacts.of_map_company_delete( )


end event

type cb_1 from mt_u_commandbutton within tabpage_1
boolean visible = false
integer x = 352
integer y = 876
integer width = 352
integer taborder = 40
string text = "Change &Map"
end type

event clicked;call super::clicked;//constant string METHOD_NAME = "change_map"
//
//s_company lstr_company_details
//
//_accepttext( )
//
//istr_company_details.shortname = dw_company_detail.getitemstring( 1, "shortname")
//istr_company_details.companyname = dw_company_detail.getitemstring( 1, "company")
//istr_company_details.type_id = dw_company_detail.getitemnumber( 1, "typeid")
//istr_company_details.country_id = dw_company_detail.getitemnumber( 1, "countryid")
//istr_company_details.link_table_name = dw_company_detail.getitemstring( 1, "link_table")
//istr_company_details.link_id = dw_company_detail.getitemnumber( 1, "link_id")
//
//openWithParm(w_companies_link,istr_company_details)
//
//lstr_company_details =  message.powerobjectparm
//
//if istr_company_details.link_id =lstr_company_details.link_id and istr_company_details.link_table_name =lstr_company_details.link_table_name then return
//	
//istr_company_details = lstr_company_details
//
//if istr_company_details.link_table_name = "CHART" then
//	if inv_company_contacts.of_share( "outstandingchart", dw_outstanding) = c#return.failure then
//		this.setredraw( true )
//		_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Outstanding Chart", "The interface manager of_share() function failed while sharing the 'outstandingchart'")	
//		return
//	end if
//elseif   istr_company_details.link_table_name  = "BROKER" then
//	if inv_company_contacts.of_share( "outstandingbroker", dw_outstanding) = c#return.failure then
//		this.setredraw( true )
//		_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for Outstanding Broker", "The interface manager of_share() function failed while sharing the 'outstandingbroker'")	
//		return
//	end if
//else 
//  //No data
//end if
//
//
//inv_company_contacts.of_map_company(lstr_company_details.link_table_name, lstr_company_details.link_id)
//
end event

type cb_change_map from mt_u_commandbutton within tabpage_1
integer x = 352
integer y = 1024
integer width = 352
integer taborder = 40
string text = "Change &Map"
end type

event clicked;call super::clicked;constant string METHOD_NAME = "change_map"

s_company lstr_company_details
s_company lstr_company_details_new

_accepttext( )

lstr_company_details.shortname = dw_company_detail.getitemstring( 1, "shortname")
lstr_company_details.companyname = dw_company_detail.getitemstring( 1, "company")
lstr_company_details.type_id = dw_company_detail.getitemnumber( 1, "typeid")
lstr_company_details.country_id = dw_company_detail.getitemnumber( 1, "countryid")
lstr_company_details.link_table_name = dw_company_detail.getitemstring( 1, "link_table")
lstr_company_details.link_id = dw_company_detail.getitemnumber( 1, "link_id")

openWithParm(w_companies_link,lstr_company_details)

lstr_company_details_new =  message.powerobjectparm

if (lstr_company_details.link_id =lstr_company_details_new.link_id and lstr_company_details.link_table_name =lstr_company_details_new.link_table_name) or isnull(lstr_company_details_new.link_id) then return
	
_changeoutstanding( lstr_company_details_new.link_table_name)

inv_company_contacts.of_map_company(lstr_company_details_new.link_table_name, lstr_company_details_new.link_id)



end event

type dw_1 from mt_u_datawindow within tabpage_1
boolean visible = false
integer x = 82
integer y = 1000
integer width = 987
integer height = 324
integer taborder = 30
boolean border = false
end type

type dw_linkdetail from mt_u_datawindow within tabpage_1
integer x = 82
integer y = 1144
integer width = 987
integer height = 324
integer taborder = 30
boolean border = false
end type

type dw_company_detail from mt_u_datawindow within tabpage_1
integer x = 41
integer y = 60
integer width = 2345
integer height = 720
integer taborder = 20
boolean border = false
end type

type gb_1 from groupbox within tabpage_1
integer x = 37
integer y = 860
integer width = 1097
integer height = 636
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

type gb_2 from groupbox within tabpage_1
integer x = 41
integer y = 1484
integer width = 1093
integer height = 472
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

type ln_1 from line within tabpage_1
long linecolor = 8421504
integer linethickness = 4
integer beginx = 41
integer beginy = 848
integer endx = 2386
integer endy = 848
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2432
integer height = 2008
long backcolor = 32304364
string text = "Contacts"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_contact_detail dw_contact_detail
uo_searchbox_contact uo_searchbox_contact
end type

on tabpage_2.create
this.dw_contact_detail=create dw_contact_detail
this.uo_searchbox_contact=create uo_searchbox_contact
this.Control[]={this.dw_contact_detail,&
this.uo_searchbox_contact}
end on

on tabpage_2.destroy
destroy(this.dw_contact_detail)
destroy(this.uo_searchbox_contact)
end on

type dw_contact_detail from mt_u_datawindow within tabpage_2
integer x = 50
integer y = 260
integer width = 2345
integer height = 1716
integer taborder = 30
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;if row<1 then return 

if dwo.name = "t_delete" then
	inv_company_contacts.of_deleterow( "contacts", row)
end if
end event

type uo_searchbox_contact from u_searchbox within tabpage_2
integer x = 46
integer y = 72
integer width = 1125
integer taborder = 30
long backcolor = 32304364
end type

on uo_searchbox_contact.destroy
call u_searchbox::destroy
end on

