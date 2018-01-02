$PBExportHeader$w_bankaccount.srw
forward
global type w_bankaccount from mt_w_sheet
end type
type st_1 from statictext within w_bankaccount
end type
type cb_new from mt_u_commandbutton within w_bankaccount
end type
type cb_update from mt_u_commandbutton within w_bankaccount
end type
type cb_delete from mt_u_commandbutton within w_bankaccount
end type
type dw_base from mt_u_datawindow within w_bankaccount
end type
type dw_picklist from mt_u_datawindow within w_bankaccount
end type
type cb_cancel from mt_u_commandbutton within w_bankaccount
end type
type gb_1 from groupbox within w_bankaccount
end type
end forward

global type w_bankaccount from mt_w_sheet
integer width = 2930
integer height = 1184
string title = "Bank Accounts"
long backcolor = 32304364
event ue_postopen ( )
st_1 st_1
cb_new cb_new
cb_update cb_update
cb_delete cb_delete
dw_base dw_base
dw_picklist dw_picklist
cb_cancel cb_cancel
gb_1 gb_1
end type
global w_bankaccount w_bankaccount

type variables
n_bankaccount		inv_bankaccount
long	il_bankaccountid

end variables

forward prototypes
public function integer wf_refresh (long al_row)
public subroutine _init_gui ()
public function integer _accepttext ()
end prototypes

event ue_postopen();constant string METHOD_NAME = "ue_postopen "

long ll_rows

n_service_manager 	lnv_SM
n_dw_Style_Service  	lnv_dwStyle

this.setredraw( FALSE )

inv_bankaccount = create n_bankaccount

if inv_bankaccount.of_share( "bankaccountlist", dw_picklist) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for the Bank Account list", "The interface manager of_share() function failed while sharing the 'bankaccountlist'")	
	return
end if

if inv_bankaccount.of_share( "bankaccountdetail", dw_base) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for the bank account details", "The interface manager of_share() function failed while sharing the 'bankaccountdetail'")	
	return
end if

lnv_SM.of_loadservice( lnv_dwStyle, "n_dw_style_service")

lnv_dwStyle.of_registercolumn("curr_code",true,false)
lnv_dwStyle.of_registercolumn("bank_account_desc",true,false)
lnv_dwStyle.of_registercolumn("bank_name",true,false)
lnv_dwStyle.of_registercolumn("bank_account_nr",true,false)

lnv_dwStyle.of_dwlistformater(dw_picklist)
lnv_dwStyle.of_dwformformater(dw_base)

//Select contact
wf_refresh( 0)

//Buttons
_init_gui( )

this.setredraw( true )

end event

public function integer wf_refresh (long al_row);constant string METHOD_NAME = "wf_refresh "

long	ll_rows

//Retrieves list

ll_rows = inv_bankaccount.of_retrieve()
if ll_rows < 0 then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error retrieving list", "n/a")	
	return 0
end if

if al_row = 0 then 
	if il_bankaccountid>0 then
		al_row = dw_picklist.find( "bank_account_id=" + string(il_bankaccountid), 1, dw_picklist.rowcount( ))
	else
		al_row = 1
	end if
end if

if al_row > dw_picklist.rowcount( ) or al_row <1 then al_row = 1

cb_new.enabled = true
cb_delete.enabled = true

//Select row
dw_picklist.event clicked(0, 0, al_row,dw_picklist.object)

return 0
end function

public subroutine _init_gui ();//check user

If uo_global.ii_user_profile <> 3 and  uo_global.ii_access_level <> 3   then

	dw_base.object.datawindow.readonly = "Yes"
	cb_new.enabled = false
	cb_update.enabled = false
	cb_delete.enabled = false
	cb_cancel.enabled = false
	
end if
end subroutine

public function integer _accepttext ();dw_base.accepttext()

return c#return.success
end function

on w_bankaccount.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_new=create cb_new
this.cb_update=create cb_update
this.cb_delete=create cb_delete
this.dw_base=create dw_base
this.dw_picklist=create dw_picklist
this.cb_cancel=create cb_cancel
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_new
this.Control[iCurrent+3]=this.cb_update
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.dw_base
this.Control[iCurrent+6]=this.dw_picklist
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.gb_1
end on

on w_bankaccount.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_new)
destroy(this.cb_update)
destroy(this.cb_delete)
destroy(this.dw_base)
destroy(this.dw_picklist)
destroy(this.cb_cancel)
destroy(this.gb_1)
end on

event open;call super::open;
post event ue_postopen( )
end event

event closequery;call super::closequery;_accepttext( )

if inv_bankaccount.of_Updatespending( ) then
	if MessageBox("Confirm row Changes", "You have data that is not saved yet. Would you like to save the data before closing?", Question!,YesNo!, 1) = 1 then
		return 1
	else 
		return 0
	end if
else
	return 0
end if	
end event

type st_1 from statictext within w_bankaccount
integer x = 27
integer y = 20
integer width = 507
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 32304364
string text = "Bank Accounts"
boolean focusrectangle = false
end type

type cb_new from mt_u_commandbutton within w_bankaccount
integer x = 1472
integer y = 956
integer taborder = 30
string text = "&New"
end type

event clicked;call super::clicked;
_accepttext( )

if inv_bankaccount.of_Updatespending( ) then
	if MessageBox("Confirm row Changes", "You have data that is not saved yet. Would you like to save the data before closing?", Question!,YesNo!, 1) = 1 then
		return 1
	end if
end if


inv_bankaccount.of_insertrow( "bankaccountdetail")

dw_base.post setfocus()

//il_companyid  = 0

cb_new.enabled = false
cb_delete.enabled = false

cb_update.enabled = true
cb_cancel.enabled = true 


end event

type cb_update from mt_u_commandbutton within w_bankaccount
integer x = 1824
integer y = 956
integer taborder = 30
string text = "&Update"
end type

event clicked;call super::clicked;
constant string METHOD_NAME = "update clicked "

long	ll_row_find

_accepttext( )

if inv_bankaccount.of_update() =c#return.success then

	il_bankaccountid =dw_base.getitemnumber( 1, "bank_account_id")
	
	if il_bankaccountid>0 then
		ll_row_find = dw_picklist.find( "bank_account_id=" + string(il_bankaccountid), 1, dw_picklist.rowcount( ))
	else
		ll_row_find = -1
	end if

	wf_refresh(ll_row_find)

end if
end event

type cb_delete from mt_u_commandbutton within w_bankaccount
integer x = 2176
integer y = 956
integer taborder = 20
string text = "&Delete"
end type

event clicked;call super::clicked;long	 ll_row_find

//Finds the first row of the contact
ll_row_find = dw_picklist.find( "bank_account_id=" + string(il_bankaccountid ), 1, dw_picklist.rowcount( ))

if inv_bankaccount.of_deleterow( "bankaccountdetail", 1) =  c#return.success then
	
	wf_refresh(ll_row_find)

end if

end event

type dw_base from mt_u_datawindow within w_bankaccount
integer x = 1157
integer y = 176
integer width = 1682
integer height = 712
integer taborder = 20
string dataobject = "d_sq_ff_bankaccountdetail"
boolean border = false
end type

type dw_picklist from mt_u_datawindow within w_bankaccount
integer x = 23
integer y = 100
integer width = 1079
integer height = 944
integer taborder = 10
string dataobject = "d_sq_tb_bankaccountlist"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;string	ls_sort
n_service_manager	lnv_SM
n_dw_sort_service	lnv_sort


if dw_picklist.rowcount( ) <1 then return 

// Perform Sorting
if row = 0 then
	lnv_SM.of_loadService(lnv_sort, "n_dw_sort_service")
	lnv_sort.of_headersort( dw_picklist, row, dwo)
	return
end if

_accepttext( )

if inv_bankaccount.of_updatespending( )  then 
	if MessageBox("Corfirm row Changes", "You have data that are not saved yet. Would you like to save the date before switching?", Question!,YesNo!, 1) = 1 then return
end if

inv_bankaccount.of_rowfocuschanged( "bankaccountlist", row)

this.selectrow(0,false)
this.selectrow(row,true)

this.setRow(row)
this.scrollToRow(row)

il_bankaccountid = dw_picklist.getitemnumber(row,"bank_account_id")
	

end event

type cb_cancel from mt_u_commandbutton within w_bankaccount
integer x = 2528
integer y = 956
integer taborder = 10
string text = "&Cancel"
end type

event clicked;call super::clicked;
dw_base.reset()

dw_picklist.event Clicked(0,0,dw_picklist.Getrow(),dw_picklist.object)
end event

type gb_1 from groupbox within w_bankaccount
integer x = 1147
integer y = 92
integer width = 1714
integer height = 828
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32304364
string text = "General information"
end type

event constructor;_accepttext( )

//if inv_company_contacts.of_Updatespending( ) then
//	if MessageBox("Confirm row Changes", "You have data that is not saved yet. Would you like to save the data before closing?", Question!,YesNo!, 1) = 1 then
//		return 1
//	end if
//end if
//
//tab_1.selecttab( 1)
//
//tab_1.tabpage_2.uo_searchbox_contact.visible = false
//
//inv_company_contacts.of_insertrow( "companydetails")
//
//tab_1.tabpage_1.dw_company_detail.post setfocus()
//
//il_companyid  = 0
//
//tab_1.tabpage_2.enabled = true
//cb_update.enabled = true
//cb_new.enabled = false
//cb_cancel.enabled = true 
//
end event

