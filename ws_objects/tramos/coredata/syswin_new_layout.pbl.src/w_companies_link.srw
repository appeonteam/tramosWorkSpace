$PBExportHeader$w_companies_link.srw
forward
global type w_companies_link from mt_w_response
end type
type st_name from statictext within w_companies_link
end type
type st_2 from statictext within w_companies_link
end type
type st_shortname from statictext within w_companies_link
end type
type cb_confirm from commandbutton within w_companies_link
end type
type mle_1 from multilineedit within w_companies_link
end type
type cb_close from commandbutton within w_companies_link
end type
type st_1 from statictext within w_companies_link
end type
type dw_companies_link from datawindow within w_companies_link
end type
type r_1 from rectangle within w_companies_link
end type
end forward

global type w_companies_link from mt_w_response
integer width = 2153
integer height = 1296
string title = "Confirm address"
boolean controlmenu = false
long backcolor = 32304364
boolean center = false
st_name st_name
st_2 st_2
st_shortname st_shortname
cb_confirm cb_confirm
mle_1 mle_1
cb_close cb_close
st_1 st_1
dw_companies_link dw_companies_link
r_1 r_1
end type
global w_companies_link w_companies_link

type variables
private	string	_is_companyname
private string		_is_shortname
private	long 		_il_typeid
private	long 		_il_countryid
private n_service_manager _inv_serviceMgr
s_company	istr_company

end variables

forward prototypes
public subroutine _retrieve ()
public subroutine documentation ()
end prototypes

public subroutine _retrieve ();/********************************************************************
   _retrieve
   <DESC>	Retrieves the search results		</DESC>
   <RETURN>	</RETURN>
   <ACCESS>	Private	</ACCESS>
   <ARGS>		</ARGS>
   <USAGE>	Find a chartering company in : BROKER,OWNER, CHART and AGENT tables.
	1. Search by name, type, country
	2. Search by name, type
	3. Search by name, country
	4. Search by name
	</USAGE>
********************************************************************/

long	ll_items
string	ls_type, ls_filter

dw_companies_link.settransobject(sqlca)

//Search by shortname and name
ll_items = dw_companies_link.retrieve(UPPER(_is_shortname), UPPER(mid(_is_companyname,1,10)))

//not found (should be avoided)
if ll_items  = 0 then return

choose case _il_typeid
	case 10 
		ls_type = "BROKER"
	case 12 
		ls_type = "OWNER"
	case 18 
		ls_type = "CHART"
	case 29 
		ls_type = "AGENT"
	case else 
		ls_type = ""
end choose

if ls_type <>"" then
	ls_filter = "link_table='" + ls_type + "' and "
end if

ls_filter = ls_filter + "country_id=" + string(_il_countryid)

//filter by type and country
dw_companies_link.setfilter(ls_filter)
dw_companies_link.filter()

ll_items = dw_companies_link.rowcount( )

if ll_items = 0 and ls_type<>"" then
	//If not found then filter only by type (filter by type only)
	dw_companies_link.setfilter("")
	dw_companies_link.setfilter("link_table='" + ls_type + "'")
	dw_companies_link.filter()
	ll_items = dw_companies_link.rowcount( )
	if ll_items = 0 then
		//If not found, filter only by country
		dw_companies_link.setfilter("")
		dw_companies_link.setfilter("country_id=" + string(_il_countryid))
		dw_companies_link.filter()
		ll_items = dw_companies_link.rowcount( )
	end if
end if


if ll_items = 0 then
	//If not found, reset filters and search only by name
	dw_companies_link.setfilter("")
	dw_companies_link.filter()
	ll_items = dw_companies_link.rowcount( )
end if


end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_companies_link
   <OBJECT> Window used to link a chartering company to a finance company 	</OBJECT>
   <USAGE> Used from w_companies and w_company_contacts_overview
   </USAGE>
   <ALSO>   	
   </ALSO>
<HISTORY> 
   Date	CR-Ref	 Author	Comments
   21/10/10	CR1412	Joana Carvalho	First Version
</HISTORY>    
********************************************************************/
end subroutine

on w_companies_link.create
int iCurrent
call super::create
this.st_name=create st_name
this.st_2=create st_2
this.st_shortname=create st_shortname
this.cb_confirm=create cb_confirm
this.mle_1=create mle_1
this.cb_close=create cb_close
this.st_1=create st_1
this.dw_companies_link=create dw_companies_link
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_name
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_shortname
this.Control[iCurrent+4]=this.cb_confirm
this.Control[iCurrent+5]=this.mle_1
this.Control[iCurrent+6]=this.cb_close
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.dw_companies_link
this.Control[iCurrent+9]=this.r_1
end on

on w_companies_link.destroy
call super::destroy
destroy(this.st_name)
destroy(this.st_2)
destroy(this.st_shortname)
destroy(this.cb_confirm)
destroy(this.mle_1)
destroy(this.cb_close)
destroy(this.st_1)
destroy(this.dw_companies_link)
destroy(this.r_1)
end on

event open;call super::open;//Receives a s_company (shortname, companyname,type_id, country_id ) as input

n_dw_style_service   lnv_style

/* setup datawindow formatter service */
_inv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_companies_link)

istr_company = message.powerObjectParm

_is_shortname = istr_company.shortname
_is_companyname =istr_company.companyname

_il_typeid = istr_company.type_id
_il_countryid = istr_company.country_id

st_shortname.text = "'" + _is_shortname + "'"
st_name.text = "'" +  mid(_is_companyname,1,10) + "'"

_retrieve()

if isvalid(w_company_contacts_overview) then
	this.x =  w_company_contacts_overview.x+50 
	this.y =  w_company_contacts_overview.y + 900
elseif isvalid(w_companies) then
	this.x =  w_companies.x+400
	this.y =  w_companies.y +1300
end if
	



end event

type st_name from statictext within w_companies_link
integer x = 1198
integer y = 160
integer width = 526
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
borderstyle borderstyle = StyleBox!
boolean focusrectangle = false
end type

type st_2 from statictext within w_companies_link
integer x = 23
integer y = 160
integer width = 1166
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
string text = "Search by 10 first characters of the company name:"
borderstyle borderstyle = StyleBox!
boolean focusrectangle = false
end type

type st_shortname from statictext within w_companies_link
integer x = 553
integer y = 104
integer width = 526
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
borderstyle borderstyle = StyleBox!
boolean focusrectangle = false
end type

type cb_confirm from commandbutton within w_companies_link
integer x = 1399
integer y = 1080
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Confirm"
end type

event clicked;//Apply selection
long	ll_row, ll_link_id
string	ls_link_table


ll_row = dw_companies_link.getselectedrow(0)

if ll_row = 0 and dw_companies_link.rowcount( ) = 1 then
	ll_row=1
end if

if ll_row = 0 then
	MessageBox("Warning", "Please select an address from the list.")
end if

//select contact from the list and search the id
istr_company.link_table_name  = dw_companies_link.getitemstring( ll_row, "link_table")
istr_company.link_id = dw_companies_link.getitemnumber( ll_row, "link_id")

CloseWithReturn(Parent, istr_company)

end event

type mle_1 from multilineedit within w_companies_link
integer x = 23
integer y = 36
integer width = 1893
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 32304364
string text = "Select a company from the list"
boolean border = false
boolean displayonly = true
borderstyle borderstyle = styleraised!
end type

type cb_close from commandbutton within w_companies_link
integer x = 1769
integer y = 1080
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

event clicked;CloseWithReturn(Parent, istr_company)
end event

type st_1 from statictext within w_companies_link
integer x = 23
integer y = 104
integer width = 526
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32304364
string text = "Search by Short Name:"
borderstyle borderstyle = StyleBox!
boolean focusrectangle = false
end type

type dw_companies_link from datawindow within w_companies_link
integer y = 216
integer width = 2098
integer height = 828
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_companies_link"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;this.selectrow( 0, false)
this.selectrow( row, true)
end event

type r_1 from rectangle within w_companies_link
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 32304364
integer x = 41
integer y = 36
integer width = 2098
integer height = 972
end type

