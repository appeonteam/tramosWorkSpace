$PBExportHeader$w_specialclaim.srw
forward
global type w_specialclaim from mt_w_sheet
end type
type cbx_exclude_settled from mt_u_checkbox within w_specialclaim
end type
type cb_actionlist from commandbutton within w_specialclaim
end type
type cb_saveas from commandbutton within w_specialclaim
end type
type cb_cancel from commandbutton within w_specialclaim
end type
type cb_invoice from commandbutton within w_specialclaim
end type
type dw_office from mt_u_datawindow within w_specialclaim
end type
type dw_responsible from mt_u_datawindow within w_specialclaim
end type
type st_2 from mt_u_statictext within w_specialclaim
end type
type st_1 from mt_u_statictext within w_specialclaim
end type
type st_4 from mt_u_statictext within w_specialclaim
end type
type cb_delete from commandbutton within w_specialclaim
end type
type cb_update from commandbutton within w_specialclaim
end type
type cb_insert from commandbutton within w_specialclaim
end type
type tab_sc from tab within w_specialclaim
end type
type tp_base from userobject within tab_sc
end type
type dw_base from mt_u_datawindow within tp_base
end type
type tp_base from userobject within tab_sc
dw_base dw_base
end type
type tp_action from userobject within tab_sc
end type
type rb_system from mt_u_radiobutton within tp_action
end type
type rb_all from mt_u_radiobutton within tp_action
end type
type dw_action from mt_u_datawindow within tp_action
end type
type rb_user from mt_u_radiobutton within tp_action
end type
type tp_action from userobject within tab_sc
rb_system rb_system
rb_all rb_all
dw_action dw_action
rb_user rb_user
end type
type tp_transaction from userobject within tab_sc
end type
type dw_transaction from mt_u_datawindow within tp_transaction
end type
type tp_transaction from userobject within tab_sc
dw_transaction dw_transaction
end type
type tp_attachment from userobject within tab_sc
end type
type dw_attachment from mt_u_datawindow within tp_attachment
end type
type tp_attachment from userobject within tab_sc
dw_attachment dw_attachment
end type
type tab_sc from tab within w_specialclaim
tp_base tp_base
tp_action tp_action
tp_transaction tp_transaction
tp_attachment tp_attachment
end type
type dw_picklist from mt_u_datawindow within w_specialclaim
end type
type r_1 from rectangle within w_specialclaim
end type
type uo_searchbox from u_searchbox within w_specialclaim
end type
end forward

global type w_specialclaim from mt_w_sheet
integer width = 4635
integer height = 2592
string title = "Special Claims"
long backcolor = 32304364
event ue_postopen ( )
cbx_exclude_settled cbx_exclude_settled
cb_actionlist cb_actionlist
cb_saveas cb_saveas
cb_cancel cb_cancel
cb_invoice cb_invoice
dw_office dw_office
dw_responsible dw_responsible
st_2 st_2
st_1 st_1
st_4 st_4
cb_delete cb_delete
cb_update cb_update
cb_insert cb_insert
tab_sc tab_sc
dw_picklist dw_picklist
r_1 r_1
uo_searchbox uo_searchbox
end type
global w_specialclaim w_specialclaim

type variables
n_specialclaim_interface	inv_claim
mt_u_datawindow   		idw_current
string							is_responsible_filter
string							is_office_filter
string							is_excluded_filter

end variables

forward prototypes
private function integer _accepttext ()
private subroutine _setfilter (string as_trigger, string as_data)
public subroutine documentation ()
public subroutine wf_setprotectcurr ()
end prototypes

event ue_postopen();constant string METHOD_NAME = "ue_postopen "
long ll_rows

n_service_manager 	lnv_SM
n_dw_Style_Service  	lnv_dwStyle

this.setredraw( FALSE )

inv_claim = create n_specialclaim_interface

if inv_claim.of_share( "claimpicklist", dw_picklist) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for the Claim list", "The interface manager of_share() function failed while sharing the 'claimspicklist'")	
	return
end if
if inv_claim.of_share( "claimbase", tab_sc.tp_base.dw_base) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for the Base Claim information", "The interface manager of_share() function failed while sharing the 'claimbase'")	
	return
end if
if inv_claim.of_share( "claimaction", tab_sc.tp_action.dw_action) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for the Claim Action information", "The interface manager of_share() function failed while sharing the 'claimaction'")	
	return
end if
if inv_claim.of_share( "claimtransaction", tab_sc.tp_transaction.dw_transaction) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for the Claim Transaction information", "The interface manager of_share() function failed while sharing the 'claimtransaction'")	
	return
end if
if inv_claim.of_share( "claimattachment", tab_sc.tp_attachment.dw_attachment) = c#return.failure then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error getting the data for the Claim Attachment information", "The interface manager of_share() function failed while sharing the 'claimattachment'")	
	return
end if

lnv_SM.of_loadservice( lnv_dwStyle, "n_dw_style_service")
lnv_dwStyle.of_dwlistformater( dw_picklist, true )
lnv_dwStyle.of_dwformformater( tab_sc.tp_base.dw_base )
lnv_dwStyle.of_dwlistformater( tab_sc.tp_action.dw_action, true )
lnv_dwStyle.of_dwlistformater( tab_sc.tp_transaction.dw_transaction, true )
lnv_dwStyle.of_dwlistformater( tab_sc.tp_attachment.dw_attachment, true )

uo_searchbox.of_initialize( dw_picklist , "debitor")

dw_responsible.insertRow(0)
dw_office.insertRow(0)

dw_picklist.setRowFocusIndicator( FocusRect!	)

ll_rows = inv_claim.of_retrieve()

if ll_rows < 0 then
	this.setredraw( true )
	_addMessage( this.classdefinition, METHOD_NAME, "Error retrieving the Special Claim data", "n/a")	
	return
elseif ll_rows > 0 then
	dw_picklist.scrolltorow(1)
	dw_picklist.event clicked( 0, 0, 1, dw_picklist.object)
end if

if (uo_global.ii_user_profile = 3) &
or (uo_global.ii_user_profile = 2 and uo_global.ii_access_level = 2)  then
	// only finance profile and operator (superuser) can register receivables
	tab_sc.tp_transaction.dw_transaction.Object.DataWindow.ReadOnly = "No"     
else
	tab_sc.tp_transaction.dw_transaction.Object.DataWindow.ReadOnly = "Yes"     
end if

this.setredraw( true )

end event

private function integer _accepttext ();tab_sc.tp_base.dw_base.accepttext()
tab_sc.tp_action.dw_action.accepttext()
tab_sc.tp_transaction.dw_transaction.accepttext()
tab_sc.tp_attachment.dw_attachment.accepttext()

return c#return.success
end function

private subroutine _setfilter (string as_trigger, string as_data);/********************************************************************
   _setFilter
   <DESC> This function sets the filter dependant on the calling trigger (Checkbox, Responsible or office)
	AS-IS valid triggers are : 
		EXCLUDE (exclude settled claims)
		RESPONSIBLE (Responsible Operator)
		OFFICE (Responsible Office)
	</DESC>
   <RETURN> (none)</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   as_trigger: calling component
            		as_data: Selected data in DW (only valid when trigger is a datawindow)</ARGS>
   <USAGE>  </USAGE>
********************************************************************/
long  ll_null;SetNull(ll_null)
string ls_original_filter

choose case upper(as_trigger)
	case "EXCLUDE"
		if upper(as_data) = "TRUE" then
			is_excluded_filter = "claim_balance <> 0"
		else 
			is_excluded_filter = ""
		end if
	case "RESPONSIBLE"
		if not isnull(as_data) then 
			dw_office.setItem(1, "office_nr", ll_null)
			is_office_filter = ""
			uo_searchbox.cb_clear.event clicked()
			is_responsible_filter = "responsible_person='"+as_data+"'"
		else
			is_responsible_filter = ""
		end if
	case "OFFICE"
		if not isnull(as_data) then 
			dw_responsible.setItem(1, "userid", "")
			is_responsible_filter = ""
			uo_searchbox.cb_clear.event clicked()
			is_office_filter = "office_nr="+as_data
		else
			is_office_filter = ""
		end if
end choose		

// Build Filter		
if is_excluded_filter <> "" then
	ls_original_filter = is_excluded_filter
end if

if is_responsible_filter <> "" then
	if ls_original_filter = "" then
		ls_original_filter = is_responsible_filter
	else
		ls_original_filter += " and " + is_responsible_filter
	end if	
end if

if is_office_filter <> "" then
	if ls_original_filter = "" then
		ls_original_filter = is_office_filter
	else
		ls_original_filter += " and " + is_office_filter
	end if	
end if

uo_searchbox.of_setOriginalfilter( ls_original_filter )
uo_searchbox.of_DoFilter()		
		
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_specialclaim
   <OBJECT> Special Claim window. </OBJECT>
   <USAGE> </USAGE>
   <ALSO> other Objects	</ALSO>
<HISTORY> 
   Date	   CR-Ref	 Author	   Comments
  26/06/13  CR2200    WWA048		When click another special claim then go to tab 1
  13/06/16  CR4034	 CCYO18			Add amout_usd, remove ExRate
</HISTORY>    
********************************************************************/

end subroutine

public subroutine wf_setprotectcurr ();/********************************************************************
   wf_setprotectcurr
   <DESC>set the curr_code protect property</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/06/16		CR4034            CCY018        First Version
   </HISTORY>
********************************************************************/

if tab_sc.tp_transaction.dw_transaction.rowcount() > 0 then
	tab_sc.tp_base.dw_base.modify( "curr_code.protect='1' ")
	tab_sc.tp_base.dw_base.modify("curr_code.background.mode = '1'")
else
	tab_sc.tp_base.dw_base.modify( "curr_code.protect='0' ")
	tab_sc.tp_base.dw_base.modify("curr_code.Background.mode = '0'")
	tab_sc.tp_base.dw_base.modify("curr_code.Background.color = '16777215'")
end if
end subroutine

on w_specialclaim.create
int iCurrent
call super::create
this.cbx_exclude_settled=create cbx_exclude_settled
this.cb_actionlist=create cb_actionlist
this.cb_saveas=create cb_saveas
this.cb_cancel=create cb_cancel
this.cb_invoice=create cb_invoice
this.dw_office=create dw_office
this.dw_responsible=create dw_responsible
this.st_2=create st_2
this.st_1=create st_1
this.st_4=create st_4
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_insert=create cb_insert
this.tab_sc=create tab_sc
this.dw_picklist=create dw_picklist
this.r_1=create r_1
this.uo_searchbox=create uo_searchbox
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_exclude_settled
this.Control[iCurrent+2]=this.cb_actionlist
this.Control[iCurrent+3]=this.cb_saveas
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_invoice
this.Control[iCurrent+6]=this.dw_office
this.Control[iCurrent+7]=this.dw_responsible
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.cb_delete
this.Control[iCurrent+12]=this.cb_update
this.Control[iCurrent+13]=this.cb_insert
this.Control[iCurrent+14]=this.tab_sc
this.Control[iCurrent+15]=this.dw_picklist
this.Control[iCurrent+16]=this.r_1
this.Control[iCurrent+17]=this.uo_searchbox
end on

on w_specialclaim.destroy
call super::destroy
destroy(this.cbx_exclude_settled)
destroy(this.cb_actionlist)
destroy(this.cb_saveas)
destroy(this.cb_cancel)
destroy(this.cb_invoice)
destroy(this.dw_office)
destroy(this.dw_responsible)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_insert)
destroy(this.tab_sc)
destroy(this.dw_picklist)
destroy(this.r_1)
destroy(this.uo_searchbox)
end on

event open;call super::open;constant string METHOD_NAME = "open"

this.move(0,0)
uo_searchbox.of_hide_label( )

post event ue_postopen( )

end event

event closequery;call super::closequery;_accepttext( )

if inv_claim.of_Updatespending( ) then
	if MessageBox("Confirm row Changes", "You have data that is not saved yet. Would you like to save the date before closing?", Question!,YesNo!, 1) = 1 then
		return 1
	else 
		return 0
	end if
else
	return 0
end if	
end event

event activate;call super::activate;If w_tramos_main.MenuName <> "m_tramosmain" Then
	w_tramos_main.ChangeMenu(m_tramosmain)
End if
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_specialclaim
end type

type cbx_exclude_settled from mt_u_checkbox within w_specialclaim
integer x = 105
integer y = 64
integer width = 617
integer textsize = -8
long textcolor = 16777215
long backcolor = 22628899
string text = "Exclude Settled Claims"
end type

event clicked;call super::clicked;_setFilter("EXCLUDE", string(this.checked) )

end event

type cb_actionlist from commandbutton within w_specialclaim
integer x = 2345
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Actionlist..."
end type

event clicked;OpenSheet(w_specialclaim_actionlist, w_tramos_main, 0, Original!)
end event

type cb_saveas from commandbutton within w_specialclaim
integer x = 1975
integer y = 2376
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

event clicked;dw_picklist.saveas()
end event

type cb_cancel from commandbutton within w_specialclaim
integer x = 1152
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Cancel"
end type

event clicked;cb_cancel.enabled = false
dw_picklist.enabled = true
dw_responsible.enabled = true
dw_office.enabled = true
uo_searchbox.enabled = true
dw_picklist.scrolltorow(1)
dw_picklist.selectrow(0, false)
dw_picklist.selectrow(1, true)
inv_claim.of_rowfocuschanged( "claimpicklist", 1 )
//dw_picklist.event clicked( 0, 0, 1, dw_picklist.object)
wf_setprotectcurr()
end event

type cb_invoice from commandbutton within w_specialclaim
integer x = 1605
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "S&tatement"
end type

event clicked;inv_claim.of_printInvoice( dw_picklist.getRow() )
end event

type dw_office from mt_u_datawindow within w_specialclaim
event ue_dropdown pbm_dwndropdown
event ue_dwdropdown pbm_dwndropdown
event ue_keydown pbm_dwnkey
integer x = 2299
integer y = 68
integer width = 453
integer height = 72
integer taborder = 50
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
string ls_null

if key = KeyDelete! then
	setNull(ll_null); setNull(ls_null)
	choose case this.getColumnName()
		case "office_nr" 
			this.setItem(this.getRow(), "office_nr", ll_null)
			_setFilter("OFFICE", ls_null) 
	end choose
end if
	
end event

event itemchanged;call super::itemchanged;if row > 0 then
	if not isnull(data) then 
		_setFilter("OFFICE", data)
	else
		_setFilter("OFFICE", "") 
	end if
end if

end event

type dw_responsible from mt_u_datawindow within w_specialclaim
event ue_dwdropdown pbm_dwndropdown
event ue_keydown pbm_dwnkey
integer x = 1088
integer y = 68
integer width = 873
integer height = 72
integer taborder = 40
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
			_setFilter("RESPONSIBLE", ls_null ) 
	end choose
end if
		
end event

event itemchanged;call super::itemchanged;if row > 0 then
	if not isnull(data) then 
		_setFilter("RESPONSIBLE", data)
	else
		_setFilter("RESPONSIBLE", "") 
	end if
end if

end event

type st_2 from mt_u_statictext within w_specialclaim
integer x = 2967
integer y = 72
integer width = 247
long textcolor = 16777215
long backcolor = 22628899
string text = "Customer"
alignment alignment = right!
end type

event constructor;call super::constructor;this.backcolor = c#color.MT_LISTHEADER_BG
this.textcolor = c#color.MT_LISTHEADER_TEXT

end event

type st_1 from mt_u_statictext within w_specialclaim
integer x = 2153
integer y = 72
integer width = 137
long textcolor = 16777215
long backcolor = 22628899
string text = "Office"
alignment alignment = right!
end type

event constructor;call super::constructor;this.backcolor = c#color.MT_LISTHEADER_BG
this.textcolor = c#color.MT_LISTHEADER_TEXT

end event

type st_4 from mt_u_statictext within w_specialclaim
integer x = 795
integer y = 72
integer width = 279
long textcolor = 16777215
long backcolor = 22628899
string text = "Responsible"
alignment alignment = right!
end type

event constructor;call super::constructor;this.backcolor = c#color.MT_LISTHEADER_BG
this.textcolor = c#color.MT_LISTHEADER_TEXT

end event

type cb_delete from commandbutton within w_specialclaim
integer x = 782
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;constant string METHOD_NAME = "clicked"

long	ll_row 

choose case idw_current.is_dsName
	case "claimbase"
		ll_row = tab_sc.tp_base.dw_base.getRow()
	case else
		ll_row = idw_current.getSelectedRow(0)
end choose

if ll_row < 1 then 
	_addmessage( this.classdefinition, METHOD_NAME , "Please select a row before deleting", "n/a")
	return
end if

inv_claim.of_deleterow( idw_current.is_dsName , ll_row)

if idw_current.is_dsName = "claimbase" &
or  idw_current.is_dsName = "claimpicklist" then
	cb_cancel.enabled = false
	dw_picklist.enabled = true
	dw_responsible.enabled = true
	dw_office.enabled = true
	uo_searchbox.enabled = true
	dw_picklist.event clicked( 0, 0, 1, dw_picklist.object)
	dw_picklist.scrolltorow(1)
end if

end event

type cb_update from commandbutton within w_specialclaim
integer x = 411
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Update"
end type

event clicked;constant string METHOD_NAME = "clicked "

boolean		lb_newClaim = false
long			ll_found
integer		li_rc

_accepttext( )

if tab_sc.tp_base.dw_base.getItemStatus(1, 0, primary!) = newmodified! then lb_newClaim = true

if inv_claim.of_update() = c#return.success then
	if lb_newClaim then
		ll_found = dw_picklist.find("special_claim_id="+string(tab_sc.tp_base.dw_base.getItemNumber(1, "special_claim_id")),1,99999)
		if ll_found > 0 then
			dw_picklist.scrollToRow(ll_found)
			dw_picklist.selectRow(0, false)
			dw_picklist.selectRow(ll_found, true)
		end if
	end if
	cb_cancel.enabled = false
	dw_picklist.enabled = true
	dw_responsible.enabled = true
	dw_office.enabled = true
	uo_searchbox.enabled = true
end if



end event

type cb_insert from commandbutton within w_specialclaim
integer x = 41
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&New"
end type

event clicked;//  1 = claimpicklist (d_sq_tb_specialclaim_list)
//  2 = claimbase  (d_sq_tb_specialclaim_base)
//  3 = claimaction  (d_sq_tb_specialclaim_action)
//  4 = claimtransaction  (d_sq_tb_specialclaim_transaction)

long ll_row

_accepttext( )

choose case idw_current.is_dsName
	case "claimpicklist", "claimbase"
		choose case idw_current.getItemStatus( 1,0, primary!)
			case new!, newmodified!			//if already in insert mode, return
				return
		end choose
		dw_picklist.selectRow(0, false)
		if tab_sc.SelectedTab <> 1 then tab_sc.selectTab( 1 )
		tab_sc.tp_base.setFocus() // when creating new claim always set focus to base 
		cb_cancel.enabled = true
		dw_picklist.enabled = false
		dw_responsible.enabled = false
		dw_office.enabled = false
		uo_searchbox.enabled = false
end choose

inv_claim.of_insertRow(idw_current.is_dsName)
idw_current.setFocus()
idw_current.setRow(idw_current.rowcount( ))
idw_current.scrollToRow(idw_current.rowcount( ))

if idw_current.is_dsName = "claimbase" then wf_setprotectcurr()

end event

type tab_sc from tab within w_specialclaim
integer x = 41
integer y = 1168
integer width = 4521
integer height = 1188
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32304364
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tp_base tp_base
tp_action tp_action
tp_transaction tp_transaction
tp_attachment tp_attachment
end type

on tab_sc.create
this.tp_base=create tp_base
this.tp_action=create tp_action
this.tp_transaction=create tp_transaction
this.tp_attachment=create tp_attachment
this.Control[]={this.tp_base,&
this.tp_action,&
this.tp_transaction,&
this.tp_attachment}
end on

on tab_sc.destroy
destroy(this.tp_base)
destroy(this.tp_action)
destroy(this.tp_transaction)
destroy(this.tp_attachment)
end on

event selectionchanged;if newindex = 1 then
	idw_current = tab_sc.tp_base.dw_base
	wf_setprotectcurr()
elseif newindex = 2 then
	idw_current = tab_sc.tp_action.dw_action
elseif newindex = 3 then
	idw_current = tab_sc.tp_transaction.dw_transaction
elseif newindex = 4 then
	idw_current = tab_sc.tp_attachment.dw_attachment
end if
	
	
end event

type tp_base from userobject within tab_sc
integer x = 18
integer y = 104
integer width = 4485
integer height = 1068
long backcolor = 16777215
string text = "Base"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_base dw_base
end type

on tp_base.create
this.dw_base=create dw_base
this.Control[]={this.dw_base}
end on

on tp_base.destroy
destroy(this.dw_base)
end on

type dw_base from mt_u_datawindow within tp_base
integer width = 4485
integer height = 1068
integer taborder = 20
boolean border = false
boolean livescroll = false
end type

event getfocus;call super::getfocus;idw_current = this
end event

event itemchanged;call super::itemchanged;datawindowchild	ldwc
string ls_null; setNull(ls_null)

// Validate that there is an object behind the dwo reference.
IF IsNull(dwo) OR NOT IsValid(dwo) THEN	 
	return c#return.noAction
END IF 

if row < 1 then return c#return.noAction

inv_claim.of_itemchanged( tab_sc.tp_base.dw_base,  row, dwo, data )
end event

event doubleclicked;call super::doubleclicked;string ls_comment

if row < 1 then return
if dwo.name = "special_claim_desc" then
	this.accepttext()
	openwithparm(w_edit_comments , this.getItemString(row, "special_claim_desc"))
	ls_comment = message.stringParm
	if isNull(ls_comment) or ls_comment = "" then
		//do nothing
	else
		this.setItem(row, "special_claim_desc", ls_comment )
	end if
end if
end event

type tp_action from userobject within tab_sc
integer x = 18
integer y = 104
integer width = 4485
integer height = 1068
long backcolor = 16777215
string text = "Action"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
rb_system rb_system
rb_all rb_all
dw_action dw_action
rb_user rb_user
end type

on tp_action.create
this.rb_system=create rb_system
this.rb_all=create rb_all
this.dw_action=create dw_action
this.rb_user=create rb_user
this.Control[]={this.rb_system,&
this.rb_all,&
this.dw_action,&
this.rb_user}
end on

on tp_action.destroy
destroy(this.rb_system)
destroy(this.rb_all)
destroy(this.dw_action)
destroy(this.rb_user)
end on

type rb_system from mt_u_radiobutton within tp_action
integer x = 407
integer y = 972
integer width = 229
long backcolor = 16777215
string text = "System"
end type

event clicked;call super::clicked;dw_action.setFilter("user_action=0")
dw_action.Filter()
end event

event constructor;call super::constructor;this.backcolor = c#color.MT_LISTDETAIL_BG

end event

type rb_all from mt_u_radiobutton within tp_action
integer x = 32
integer y = 972
integer width = 187
long backcolor = 16777215
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_action.setFilter("")
dw_action.Filter()
end event

event constructor;call super::constructor;this.backcolor = c#color.MT_LISTDETAIL_BG


end event

type dw_action from mt_u_datawindow within tp_action
integer width = 4485
integer height = 972
integer taborder = 20
boolean vscrollbar = true
boolean border = false
end type

event getfocus;call super::getfocus;idw_current = this
end event

event itemchanged;call super::itemchanged;inv_claim.of_itemchanged( tab_sc.tp_action.dw_action, row, dwo, data)
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

event clicked;call super::clicked;n_service_manager	lnv_SM
n_dw_sort_service	lnv_sort

//Sort
if row = 0 then
	lnv_SM.of_loadService(lnv_sort, "n_dw_sort_service")
	lnv_sort.of_headersort( dw_action, row, dwo)
	return
end if

end event

type rb_user from mt_u_radiobutton within tp_action
integer x = 219
integer y = 972
integer width = 187
boolean bringtotop = true
long backcolor = 16777215
string text = "User"
end type

event clicked;call super::clicked;dw_action.setFilter("user_action=1")
dw_action.Filter()
end event

event constructor;call super::constructor;this.backcolor = c#color.MT_LISTDETAIL_BG

end event

type tp_transaction from userobject within tab_sc
integer x = 18
integer y = 104
integer width = 4485
integer height = 1068
long backcolor = 16777215
string text = "Transaction"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_transaction dw_transaction
end type

on tp_transaction.create
this.dw_transaction=create dw_transaction
this.Control[]={this.dw_transaction}
end on

on tp_transaction.destroy
destroy(this.dw_transaction)
end on

type dw_transaction from mt_u_datawindow within tp_transaction
integer width = 4485
integer height = 1056
integer taborder = 30
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event getfocus;call super::getfocus;idw_current = this
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

event clicked;call super::clicked;n_service_manager	lnv_SM
n_dw_sort_service	lnv_sort

//Sort
if row = 0 then
	lnv_SM.of_loadService(lnv_sort, "n_dw_sort_service")
	lnv_sort.of_headersort( dw_transaction, row, dwo)
	return
end if

end event

event itemchanged;call super::itemchanged;inv_claim.of_itemchanged( tab_sc.tp_transaction.dw_transaction, row, dwo, data)
end event

type tp_attachment from userobject within tab_sc
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 4485
integer height = 1068
long backcolor = 16777215
string text = "Attachment"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_attachment dw_attachment
end type

on tp_attachment.create
this.dw_attachment=create dw_attachment
this.Control[]={this.dw_attachment}
end on

on tp_attachment.destroy
destroy(this.dw_attachment)
end on

type dw_attachment from mt_u_datawindow within tp_attachment
integer x = 5
integer y = 8
integer width = 4485
integer height = 1056
integer taborder = 40
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event clicked;call super::clicked;n_service_manager	lnv_SM
n_dw_sort_service	lnv_sort

if row < 0 then return 

//Sort
if row = 0 then
	lnv_SM.of_loadService(lnv_sort, "n_dw_sort_service")
	lnv_sort.of_headersort( dw_attachment, row, dwo)
	return
end if

if dwo.name = "p_openfile" then inv_claim.of_openattachment( row )

end event

event getfocus;call super::getfocus;idw_current = this
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

this.selectrow(0,false)
this.selectrow(currentrow,true)
end event

type dw_picklist from mt_u_datawindow within w_specialclaim
integer x = 41
integer y = 252
integer width = 4485
integer height = 864
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;/********************************************************************
   clicked
   <DESC>  </DESC>
   <RETURN> long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>  </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author             Comments
   	26/06/2013   CR2200       WWA048        		When click another special claim then go to tab 1
   </HISTORY>
********************************************************************/

n_service_manager	lnv_SM
n_dw_sort_service	lnv_sort
long ll_found, ll_claimID
long ll_vessel_nr 
datawindowchild   	ldwc_voyages 

//nothing to do
if row < 0 then return

//Sort
if row = 0 then
	lnv_SM.of_loadService(lnv_sort, "n_dw_sort_service")
	lnv_sort.of_headersort( dw_picklist, row, dwo)
	return
end if

_accepttext( )

if inv_claim.of_Updatespending( ) then
	if MessageBox("Corfirm row Changes", "You have data that are not saved yet. Would you like to save the date before switching?", Question!,YesNo!, 1) = 1 then
		if inv_claim.of_update() = c#return.failure then
			ll_claimID = tab_sc.tp_base.dw_base.getItemNumber(1, "special_claim_id")
			ll_found = this.find("special_claim_id="+string(ll_claimID),1,99999)
			if ll_found > 0 then
				this.selectrow(0,false)
				this.selectrow(ll_found,true)
				this.setRow(ll_found)
				this.scrollToRow(ll_found)
				return
			end if
		end if
	end if
end if

//highlight row and retrieve children is any
this.selectrow(0,false)
this.selectrow(row,true)

inv_claim.of_rowfocuschanged( this.is_dsName, row )

/* To trigger the refresh of the voyage dropdown, trigger a change in vessel number */
ll_vessel_nr = 	tab_sc.tp_base.dw_base.getItemNumber(1, "vessel_nr")
if not isNull(ll_vessel_nr) then
	if tab_sc.tp_base.dw_base.getChild("voyage_nr", ldwc_voyages ) = 1 then
		ldwc_voyages.settransobject(SQLCA)
		ldwc_voyages.retrieve(ll_vessel_nr)
	end if
end if

//When click another special claim then go to tab 1
tab_sc.selecttab(1)
wf_setprotectcurr()

end event

event getfocus;call super::getfocus;idw_current = this
end event

type r_1 from rectangle within w_specialclaim
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 22628899
integer width = 4731
integer height = 216
end type

type uo_searchbox from u_searchbox within w_specialclaim
integer x = 3223
integer y = 60
integer width = 946
integer height = 80
integer taborder = 30
end type

on uo_searchbox.destroy
call u_searchbox::destroy
end on

event constructor;this.backcolor = c#color.MT_LISTHEADER_BG
this.st_search.text = ""
this.st_search.backcolor = c#color.MT_LISTHEADER_BG

end event

