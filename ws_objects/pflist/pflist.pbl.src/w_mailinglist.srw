$PBExportHeader$w_mailinglist.srw
forward
global type w_mailinglist from w_events_pcgroup
end type
type st_status from statictext within w_mailinglist
end type
type cb_collapse from commandbutton within w_mailinglist
end type
type cb_expand from commandbutton within w_mailinglist
end type
type uo_pcgroup from u_pcgroup within w_mailinglist
end type
type cbx_allcontact from mt_u_checkbox within w_mailinglist
end type
type cb_add from mt_u_commandbutton within w_mailinglist
end type
type cbx_deactivated from mt_u_checkbox within w_mailinglist
end type
type cb_print from mt_u_commandbutton within w_mailinglist
end type
type dw_mailinglist from datawindow within w_mailinglist
end type
end forward

global type w_mailinglist from w_events_pcgroup
integer width = 3589
integer height = 2600
string title = "Position Mailinglist"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
event ue_refreshonerow ( long al_companyid )
event ue_retrieve ( )
st_status st_status
cb_collapse cb_collapse
cb_expand cb_expand
uo_pcgroup uo_pcgroup
cbx_allcontact cbx_allcontact
cb_add cb_add
cbx_deactivated cbx_deactivated
cb_print cb_print
dw_mailinglist dw_mailinglist
end type
global w_mailinglist w_mailinglist

type variables
integer ii_profitcenter, ii_pcgroup
string is_sort, is_sort_temp, is_filter_mailcompany, is_filter_deactivated, is_filter
private n_service_manager _inv_serviceMgr
private 	s_company 	istr_company
end variables

forward prototypes
private function integer cbx_click ()
private subroutine _opendetails ()
private subroutine _savechanges ()
public subroutine documentation ()
end prototypes

event ue_refreshonerow(long al_companyid);long ll_found

setpointer(hourglass!)
dw_mailinglist.setredraw( false )

dw_mailinglist.settransobject( SQLCA)
dw_mailinglist.retrieve(ii_pcgroup)

dw_mailinglist.setfilter(is_filter_mailcompany + " " +is_filter_deactivated)
dw_mailinglist.filter()
	
ll_found = dw_mailinglist.find("pf_company_companyid ="+string(al_companyid),1,999999)
if ll_found > 0 then
	dw_mailinglist.selectrow(0, false)
	dw_mailinglist.selectrow(ll_found,true)
	dw_mailinglist.scrolltorow(ll_found)
end if

dw_mailinglist.setredraw( true )
setpointer(Arrow!)
dw_mailinglist.POST setfocus()
end event

event ue_retrieve();/* Profitcenter */
if ii_pcgroup < 1 then
	MessageBox("Validation Error", "Please select a Profit Center Group.")
	return
end if



dw_mailinglist.retrieve(ii_pcgroup)

cbx_click()

if dw_mailinglist.rowcount( ) > 0 then
	cb_print.enabled = true

else
	cb_print.enabled = false
end if
end event

private function integer cbx_click ();
dw_mailinglist.setredraw(false)

is_filter=""
if cbx_deactivated.checked = true then
	is_filter_deactivated = ""
	//cbx_deactivated.text = "Hide deactivated companies"
else
	is_filter_deactivated = "pf_company_deactivated = 0"
	//cbx_deactivated.text = "Show deactivated companies"
end if

if cbx_allcontact.checked = true then
	is_filter_mailcompany = ""
//	is_filter_mailcompany =   " pf_companycontacts_maillist =1 and pf_companycontacts_deactivated = 0"
else
	is_filter_mailcompany = "( pf_companycontacts_maillist =1  or pf_companycontacts_imo_check = 1) and pf_companycontacts_deactivated = 0 "
end if


if is_filter <> "" then
	if is_filter_mailcompany <> "" then
		is_filter = is_filter + " and " + is_filter_mailcompany
	end if
else
	is_filter = is_filter_mailcompany
end if

if is_filter <> "" then
	if is_filter_deactivated <> "" then
		is_filter = is_filter + " and " + is_filter_deactivated
	end if
else
	is_filter = is_filter_deactivated
end if

//messagebox("",is_filter)

dw_mailinglist.setfilter(is_filter)

dw_mailinglist.filter()
dw_mailinglist.setredraw(true)

st_status.text = "Rows count: " + string(dw_mailinglist.rowcount( ))

return 0
end function

private subroutine _opendetails ();/********************************************************************
   opendetails 
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
this.event ue_retrieve()

//Select company
if ll_companyid > 0 then
	ll_find = dw_mailinglist.find( "pf_company_companyid=" + string(ll_companyid), 1, dw_mailinglist.rowcount( ))
	if ll_find >0 then

		dw_mailinglist.SelectTreeNode(0,2,false)
		dw_mailinglist.SelectTreeNode(0,1,false)
		dw_mailinglist.scrolltorow(ll_find)
		
		dw_mailinglist.SelectTreeNode(ll_find,1,true)
		
	end if
end if

end subroutine

private subroutine _savechanges ();if dw_mailinglist.modifiedcount( ) >0 then
	if dw_mailinglist.update(true, true) = -1 then
		MessageBox("Error", "Error saving changes. Please refresh and try again.")
	end if
	commit;
end if
	
end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	Description	</DESC>
   <RETURN>	(none):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14		CR3781	CCY018			The window title match with the text of a menu item
		23/12/2016	CR4387	KSH092			Add column IMO, change mailling as Public, change filter "Show mailinglist companies" to "Show all contacts"
   </HISTORY>
********************************************************************/
end subroutine

on w_mailinglist.create
int iCurrent
call super::create
this.st_status=create st_status
this.cb_collapse=create cb_collapse
this.cb_expand=create cb_expand
this.uo_pcgroup=create uo_pcgroup
this.cbx_allcontact=create cbx_allcontact
this.cb_add=create cb_add
this.cbx_deactivated=create cbx_deactivated
this.cb_print=create cb_print
this.dw_mailinglist=create dw_mailinglist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_status
this.Control[iCurrent+2]=this.cb_collapse
this.Control[iCurrent+3]=this.cb_expand
this.Control[iCurrent+4]=this.uo_pcgroup
this.Control[iCurrent+5]=this.cbx_allcontact
this.Control[iCurrent+6]=this.cb_add
this.Control[iCurrent+7]=this.cbx_deactivated
this.Control[iCurrent+8]=this.cb_print
this.Control[iCurrent+9]=this.dw_mailinglist
end on

on w_mailinglist.destroy
call super::destroy
destroy(this.st_status)
destroy(this.cb_collapse)
destroy(this.cb_expand)
destroy(this.uo_pcgroup)
destroy(this.cbx_allcontact)
destroy(this.cb_add)
destroy(this.cbx_deactivated)
destroy(this.cb_print)
destroy(this.dw_mailinglist)
end on

event open;n_dw_style_service   lnv_style

this.post move(0,0)

dw_mailinglist.settransobject(SQLCA)

uo_pcgroup.dw_pcgroup.Object.DataWindow.Color = c#color.MT_FORM_BG
ii_pcgroup=uo_pcgroup.uf_getpcgroup( )
istr_company.pcgroup = ii_pcgroup

if ii_pcgroup<0 then
	this.Post Event ue_postopen()
else
	this.post event ue_retrieve()
end if

/* setup datawindow formatter service */
_inv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_mailinglist, false)



end event

event ue_pcgroupchanged;call super::ue_pcgroupchanged;ii_pcgroup=ai_pcgroupid
istr_company.pcgroup = ai_pcgroupid

this.event ue_retrieve()
return 0
end event

type st_hidemenubar from w_events_pcgroup`st_hidemenubar within w_mailinglist
end type

type st_status from statictext within w_mailinglist
integer x = 2747
integer y = 2424
integer width = 622
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_collapse from commandbutton within w_mailinglist
integer x = 1221
integer y = 2420
integer width = 375
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Colla&pse All"
end type

event clicked;dw_mailinglist.collapseall( )

end event

type cb_expand from commandbutton within w_mailinglist
integer x = 837
integer y = 2420
integer width = 375
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "E&xpand All"
end type

event clicked;dw_mailinglist.expandall()
end event

type uo_pcgroup from u_pcgroup within w_mailinglist
integer x = 59
integer y = 52
integer taborder = 20
long backcolor = 32304364
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type cbx_allcontact from mt_u_checkbox within w_mailinglist
integer x = 41
integer y = 828
integer width = 763
integer textsize = -8
long backcolor = 32304364
string text = "Show all contacts"
boolean checked = true
end type

event clicked;call super::clicked;cbx_click()

return 0
end event

type cb_add from mt_u_commandbutton within w_mailinglist
integer x = 55
integer y = 2288
integer width = 389
integer taborder = 40
string text = "&Add Company"
end type

event clicked;//s_company		lstr_company
//
//// if ii_profitcenter = 17 then ii_profitcenter = 4  // If MR Handy show the contacts for Handy
//// lstr_company.pc_nr = ii_profitcenter
//
//lstr_company.pcgroup = ii_pcgroup
//lstr_company.companyid = 0
//
//opensheetwithparm(w_company, lstr_company ,parent.parentWindow(),0,Original!)

istr_company.companyid=0
istr_company.contactid=0

_opendetails()

end event

type cbx_deactivated from mt_u_checkbox within w_mailinglist
integer x = 41
integer y = 748
integer width = 763
integer textsize = -8
long backcolor = 32304364
string text = "Show deactivated companies"
end type

event clicked;call super::clicked;
cbx_click()

return 0

/*dw_mailinglist.setredraw(false)

if cbx_deactivated.checked = true then
	is_filter_deactivated = ""
	cbx_deactivated.text = "Hide deactivated companies"
else
	is_filter_deactivated = "deactivated = 0"
	cbx_deactivated.text = "Show deactivated companies"
end if


if is_filter <> "" then
	if is_filter_mailcompany <> "" then
		is_filter = is_filter + " and " + is_filter_mailcompany
	end if
else
	is_filter = is_filter_mailcompany
end if

if is_filter <> "" then
	if is_filter_deactivated <> "" then
		is_filter = is_filter + " and " + is_filter_deactivated
	end if
else
	is_filter = is_filter_deactivated
end if

messagebox("",is_filter)

dw_mailinglist.setfilter(is_filter)
//dw_mailinglist.setfilter(is_filter_mailcompany)
dw_mailinglist.filter()
dw_mailinglist.setredraw(true)*/
end event

type cb_print from mt_u_commandbutton within w_mailinglist
integer x = 55
integer y = 2400
integer width = 389
integer taborder = 40
boolean enabled = false
string text = "&Print"
end type

event clicked;dw_mailinglist.print()

end event

type dw_mailinglist from datawindow within w_mailinglist
integer x = 823
integer y = 36
integer width = 2729
integer height = 2376
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_tv_mailinglist"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;//s_company		lstr_company
//
//if row < 1 then return
//
//lstr_company.pcgroup = ii_pcgroup
//lstr_company.companyid = dw_mailinglist.getitemnumber(row,"pf_company_companyid")
//
//opensheetwithparm(w_company, lstr_company ,parent.parentWindow(),0,Original!)
//

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

	istr_company.companyid=this.getitemnumber(li_tmpRow, "pf_company_companyid")
	istr_company.contactid=-1
		
else
	//Messagebox("Warning", "Edit contact " + this.getitemstring(row, "contact"))
	istr_company.companyid=this.getitemnumber(row, "pf_company_companyid")
	if isnull(this.getitemnumber(row, "pf_companycontacts_contactsid")) = true  then
		istr_company.contactid=-1
	else
		istr_company.contactid=this.getitemnumber(row, "pf_companycontacts_contactsid")
	end if
end if

_opendetails()


end event

event dberror;//Messagebox("Tramos Error","Error message: "+sqlerrtext + "~r~n Occurred for this statement:"+sqlsyntax)
if sqldbcode=547 then
	Messagebox("Tramos Error","Deletion is not possible.~r~nThere is dependent historic data in the fixture list.~r~nPerhaps deactivate the company instead.")
	return 1
end if
end event

event clicked;if dwo.name = "pf_companycontacts_maillist" then
	_savechanges( )
end if
end event

event losefocus;_savechanges( )

return 0
end event

