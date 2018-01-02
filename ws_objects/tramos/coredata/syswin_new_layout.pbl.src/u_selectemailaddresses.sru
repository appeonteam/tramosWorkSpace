$PBExportHeader$u_selectemailaddresses.sru
forward
global type u_selectemailaddresses from mt_u_visualobject
end type
type cb_showall from commandbutton within u_selectemailaddresses
end type
type cb_showselected from commandbutton within u_selectemailaddresses
end type
type cb_addnewcompany from commandbutton within u_selectemailaddresses
end type
type cb_collapse from commandbutton within u_selectemailaddresses
end type
type cb_expand from commandbutton within u_selectemailaddresses
end type
type uo_searchbox from u_searchbox within u_selectemailaddresses
end type
type dw_emailslist from datawindow within u_selectemailaddresses
end type
end forward

global type u_selectemailaddresses from mt_u_visualobject
integer width = 2665
integer height = 1952
cb_showall cb_showall
cb_showselected cb_showselected
cb_addnewcompany cb_addnewcompany
cb_collapse cb_collapse
cb_expand cb_expand
uo_searchbox uo_searchbox
dw_emailslist dw_emailslist
end type
global u_selectemailaddresses u_selectemailaddresses

type variables
private n_service_manager _inv_serviceMgr
s_company	istr_company
end variables

forward prototypes
public function integer uf_init (integer al_pcgroupid)
public subroutine uf_getselectedemails (ref string as_emails[])
public subroutine uf_opendetails ()
public subroutine documentation ()
private subroutine _uf_refesh ()
end prototypes

public function integer uf_init (integer al_pcgroupid);/********************************************************************
   uf_init
   <DESC> Initializes object </DESC>
   <RETURN> 
		0:		ok
		-1:	error
   </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>	al_pcgroupid: Profit Center Group Id
   </ARGS>
   <USAGE>	Use this function to Initialize object. 	</USAGE>
********************************************************************/

string ls_vesselname

if dw_emailslist.retrieve(al_pcgroupid) < 0 then
	MessageBox("Error","Invalid retrieval!")
	return -1
end if

dw_Emailslist.expandall() 

istr_company.pcgroup = al_pcgroupid

return 0
end function

public subroutine uf_getselectedemails (ref string as_emails[]);/********************************************************************
   uf_getselectedemails 
   <DESC> Returns an array with the selected valid email addresses.	</DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>	reference as_emails[] : array of selected emails addresses
   </ARGS>
   <USAGE>	Use this function to get a list of the selected email addresses.
					Only valid email addresses are included in the array.
	</USAGE>
********************************************************************/

string	ls_tmp, ls_email, ls_returnmsg, ls_invalidemails
string	ls_empty[]
long	ll_row, ll_row_res
mt_n_outgoingmail	lnv_mail
lnv_mail = create mt_n_outgoingmail

as_emails = ls_empty

cb_showselected.event clicked( )
ls_tmp = ""
ll_row_res = 1
for ll_row=1 to dw_emailslist.rowcount( )
	ls_email = dw_emailslist.getitemstring( ll_row, "email")
	if isnull(ls_email) = false then
		//check if is valid
		if lnv_mail.of_verifyreceiveraddress( ls_email,ls_returnmsg) = 1 then
			as_emails[ll_row_res] = ls_email
			ll_row_res = ll_row_res +1
		else
			ls_invalidemails = ls_invalidemails + "; " + ls_email
		end if
	end if
next
destroy lnv_mail
if ls_invalidemails <>"" then
	MessageBox("Warning", "Invalid email addresses found: " + mid(ls_invalidemails,2))
end if

uo_searchbox.cb_clear.event clicked( )


end subroutine

public subroutine uf_opendetails ();/********************************************************************
   uf_opendetails 
   <DESC> Opens the company details window, and refreshs contacts list	</DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Use this function to open the contact details and get the changes in the
					contacts list.
	</USAGE>
********************************************************************/

long	ll_find, ll_companyid

//astr_company
OpenWithParm(w_company_contacts_overview, istr_company)

ll_companyid =  message.doubleparm

if ll_companyid<1 then return

//refresh contacts window
_uf_refesh( )

//Select company
if ll_companyid > 0 then
	ll_find = dw_emailslist.find( "companyid=" + string(ll_companyid), 1, dw_emailslist.rowcount( ))
	if ll_find >0 then

		dw_emailslist.SelectTreeNode(0,2,false)
		dw_emailslist.SelectTreeNode(0,1,false)
		dw_emailslist.scrolltorow(ll_find)
		
		dw_emailslist.SelectTreeNode(ll_find,1,true)
		
	end if
end if

end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: u_selectemailaddresses - Email addresses selection
   <OBJECT> 	Returns the list of all contacts and emails by profitcenter group 	</OBJECT>
   <USAGE>  	Used to display a list of contacts and respective emails. 
							public uf_init  - initializes object
							public uf_opendetails  - opens window with company details (double click/button add new)
							public uf_getselectedemails - get selected emails from the list
							private uf_refesh - refresh contacts list, keeping the selected emails
						The list displays all the companies and all the contacts with email address
						for the profit center group, where the vessel belongs.
						With double click, the user can see the details and edit data (create, edit
						and delete contacts, edit company details)
						
						s_company	istr_company (companyid, contactid, pcgroup)
						
						Object Structure (called from w_mailcertificates):
						u_selectemailaddresses
								w_contacts_overview
										u_company_detail
										u_contact_detail
										
	</USAGE>
   <ALSO>	</ALSO>
<HISTORY> 
   Date	CR-Ref	 Author	Comments
   17/06/10	CR1412	Joana Carvalho	First Version
</HISTORY>    
********************************************************************/
end subroutine

private subroutine _uf_refesh ();/********************************************************************
   uf_refresh
   <DESC> Refresh window after a contact is edited. </DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Use this function to refresh the contacts list with the changes made by the
					user. 
	</USAGE>
********************************************************************/

long	ll_row, ll_find
s_company	lstr_array[]
s_company	lstr_company

//Save the selected email addresses

cb_showselected.event clicked( )

for ll_row=1 to dw_emailslist.rowcount( )
	
	lstr_company.companyid = dw_emailslist.getitemnumber( ll_row, "companyid")
	
	if dw_emailslist.getitemstring( ll_row, "contact") = "_Chart. email" then
		lstr_company.contactid = -1
	elseif dw_emailslist.getitemstring( ll_row, "contact") = "_Oper. email" then
		lstr_company.contactid = -2
	else
		lstr_company.contactid = dw_emailslist.getitemnumber( ll_row, "contactid")
	end if
	lstr_array[ll_row] = lstr_company
next


//Refresh datawindow
dw_emailslist.setfilter("")
dw_emailslist.filter()

dw_emailslist.settransobject(SQLCA)

if dw_emailslist.retrieve(istr_company.pcgroup) < 0 then
	MessageBox("Error","Invalid retrieval!")
	return
end if

//select back the email addresses previously selected
for ll_row = 1 to upperbound(lstr_array)
	if lstr_array[ll_row].contactid >0 then
		ll_find = dw_emailslist.find( "companyid =" + string(lstr_array[ll_row].companyid) + " and contactid =" + string(lstr_array[ll_row].contactid), 1, dw_emailslist.rowcount() )
	
	elseif lstr_array[ll_row].contactid = -1 then // "_Chart. email" 
		ll_find = dw_emailslist.find( "companyid =" + string(lstr_array[ll_row].companyid) + " and contact ='_Chart. email'", 1, dw_emailslist.rowcount() )
		
	elseif lstr_array[ll_row].contactid = -2 then // "_Oper. email"
		ll_find = dw_emailslist.find( "companyid =" + string(lstr_array[ll_row].companyid) + " and contact ='_Oper. email'", 1, dw_emailslist.rowcount() )
		
	end if
	
	if ll_find>0 then
		dw_emailslist.setitem( ll_find, "selectemail", 1)
	end if
	
next

end subroutine

on u_selectemailaddresses.create
int iCurrent
call super::create
this.cb_showall=create cb_showall
this.cb_showselected=create cb_showselected
this.cb_addnewcompany=create cb_addnewcompany
this.cb_collapse=create cb_collapse
this.cb_expand=create cb_expand
this.uo_searchbox=create uo_searchbox
this.dw_emailslist=create dw_emailslist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_showall
this.Control[iCurrent+2]=this.cb_showselected
this.Control[iCurrent+3]=this.cb_addnewcompany
this.Control[iCurrent+4]=this.cb_collapse
this.Control[iCurrent+5]=this.cb_expand
this.Control[iCurrent+6]=this.uo_searchbox
this.Control[iCurrent+7]=this.dw_emailslist
end on

on u_selectemailaddresses.destroy
call super::destroy
destroy(this.cb_showall)
destroy(this.cb_showselected)
destroy(this.cb_addnewcompany)
destroy(this.cb_collapse)
destroy(this.cb_expand)
destroy(this.uo_searchbox)
destroy(this.dw_emailslist)
end on

event constructor;n_dw_style_service   lnv_style

/* setup datawindow formatter service */
_inv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_emailslist, false)
//dw_emailslist.Object.DataWindow.Detail.Color=C#COLOR.MT_LISTDETAIL_BG

dw_emailslist.settransobject(SQLCA)

// Initialize search box
uo_SearchBox.of_initialize(dw_emailslist, "company+'~'+contact1")
uo_SearchBox.sle_search.POST setfocus()

end event

type cb_showall from commandbutton within u_selectemailaddresses
integer x = 1870
integer y = 68
integer width = 375
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show &All"
end type

event clicked;uo_searchbox.cb_clear.event clicked( )

end event

type cb_showselected from commandbutton within u_selectemailaddresses
integer x = 2258
integer y = 68
integer width = 375
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show Selec&ted"
end type

event clicked;uo_searchbox.cb_clear.event clicked( )

dw_emailslist.setfilter( "selectemail=1")
dw_emailslist.filter()
end event

type cb_addnewcompany from commandbutton within u_selectemailaddresses
integer x = 2263
integer y = 1852
integer width = 375
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New Company"
end type

event clicked;istr_company.companyid=0
istr_company.contactid=0

uf_opendetails()

end event

type cb_collapse from commandbutton within u_selectemailaddresses
integer x = 389
integer y = 1852
integer width = 375
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Colla&pse All"
end type

event clicked;dw_emailslist.collapseall( )

end event

type cb_expand from commandbutton within u_selectemailaddresses
integer x = 5
integer y = 1852
integer width = 375
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "E&xpand All"
end type

event clicked;dw_emailslist.expandall()
end event

type uo_searchbox from u_searchbox within u_selectemailaddresses
integer x = 9
integer width = 1577
integer taborder = 10
end type

on uo_searchbox.destroy
call u_searchbox::destroy
end on

type dw_emailslist from datawindow within u_selectemailaddresses
integer x = 5
integer y = 184
integer width = 2633
integer height = 1644
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tv_company_email_by_pcgroup"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//string ls_band
//integer li_tab, li_tmprow
//
//if row>0 then return
//
//ADD NEW CONTACT
//if dwo.name = "t_newcontact" then
//	ls_band = this.GetBandAtPointer()
//	li_tab = Pos(ls_band, "~t", 1)
//	li_tmpRow = Integer(Mid(ls_band, li_tab + 1))
//
//	if li_tmpRow=0 then return
//	
//	ls_band = Left(ls_band, li_tab - 1)
//
//	//OPEN COMPANY DETAILS, AND ADD A NEW CONTACT
//	//Messagebox("test", "selected company" + " ROW=" + string(li_tmpRow) + " Company=" + this.getitemstring(li_tmpRow, "company") + "  (" + string(this.getitemnumber(li_tmpRow, "companyid")) + ")")
//	
//	istr_company.companyid=this.getitemnumber(li_tmpRow, "companyid")
//	istr_company.contactid=0
//
//	uf_opendetails()
//
//end if
	
	
end event

event doubleclicked;//check if node is a company.... if yes open the details

long	ll_companyid
integer	li_level
string ls_band
integer li_tab, li_tmprow

if row = 0 then
	//double click company
	
	ls_band = this.GetBandAtPointer()
	
	li_tab = Pos(ls_band, "~t", 1)
	li_tmpRow = Integer(Mid(ls_band, li_tab + 1))
	
	//click on header
	if li_tmpRow=0 then return
	
	ls_band = Left(ls_band, li_tab - 1)

	istr_company.companyid=this.getitemnumber(li_tmpRow, "companyid")
	istr_company.contactid=-1
		
else
	//Messagebox("Warning", "Edit contact " + this.getitemstring(row, "contact"))
	istr_company.companyid=this.getitemnumber(row, "companyid")
	if isnull(this.getitemnumber(row, "contactid")) = true  then
		istr_company.contactid=-1
	else
		istr_company.contactid=this.getitemnumber(row, "contactid")
	end if
end if

uf_opendetails()

end event

