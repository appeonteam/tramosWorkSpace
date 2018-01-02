$PBExportHeader$w_modify_cargo.srw
forward
global type w_modify_cargo from mt_w_response
end type
type p_source from picture within w_modify_cargo
end type
type p_broker from picture within w_modify_cargo
end type
type p_char from picture within w_modify_cargo
end type
type cb_cancel from mt_u_commandbutton within w_modify_cargo
end type
type cb_update from mt_u_commandbutton within w_modify_cargo
end type
type dw_cargo from datawindow within w_modify_cargo
end type
end forward

global type w_modify_cargo from mt_w_response
integer width = 1723
integer height = 1696
boolean controlmenu = false
p_source p_source
p_broker p_broker
p_char p_char
cb_cancel cb_cancel
cb_update cb_update
dw_cargo dw_cargo
end type
global w_modify_cargo w_modify_cargo

type variables
s_pf 		istr_cargo	
mt_n_dddw_searchasyoutype inv_dddw_search
end variables

forward prototypes
public subroutine uf_setdddw (datawindow adw)
public subroutine _select_company (string as_field)
public subroutine of_documentation ()
public subroutine documentation ()
end prototypes

public subroutine uf_setdddw (datawindow adw);long 	ll_rows, ll_row

datawindowchild	ldwc
/* retrieve DDDW - charterer*/
adw.getchild("chartererid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_cargo.pcgroup,18)
/* retrieve DDDW - broker*/
adw.getchild("brokerid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_cargo.pcgroup,10)
/* retrieve DDDW - source*/
adw.getchild("pf_fixture_sourceid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_cargo.pcgroup)
/* retrieve DDDW - cargo*/
adw.getchild("cargoid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_cargo.pcgroup)
/* retrieve DDDW - trade*/
adw.getchild("pf_fixture_tradeid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_cargo.pcgroup)
/* retrieve DDDW - status*/
adw.getchild("pf_fixture_statusid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_cargo.pcgroup)
/* retrieve DDDW - office*/
adw.getchild("pf_fixture_officeid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_cargo.pcgroup)
/* retrieve DDDW - area*/
adw.getchild("areaid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(istr_cargo.pcgroup)
end subroutine

public subroutine _select_company (string as_field);/********************************************************************
   _select_company
   <DESC> Opens window with company details and contacts list </DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>	as_field: string - company field - chartererid, brokerid, sourceid
   </ARGS>
   <USAGE>		- if a company is selected, then the user visualizes the company details
						- if a company is not selected, then it´s possible to add a new company.
	</USAGE>
********************************************************************/

s_company 	lstr_company
long				ll_companyid
datawindowchild	ldwc

dw_cargo.accepttext()
if isnull(dw_cargo.getitemnumber( 1, as_field)) then
	lstr_company.companyid = 0
else 
	lstr_company.companyid = dw_cargo.getitemnumber( 1, as_field)
end if
lstr_company.pcgroup = dw_cargo.getitemnumber( 1, "pcgroup_id")

OpenWithParm(w_company_contacts_overview, lstr_company)

ll_companyid =  message.doubleparm

if lstr_company.companyid = 0 and  ll_companyid>0 then
	uf_setdddw( dw_cargo)
	dw_cargo.setitem( 1, as_field,ll_companyid)
end if

end subroutine

public subroutine of_documentation ();/********************************************************************
   ObjectName: w_modify_cargo
	
   <OBJECT>
		This is the cargo detail window for cargoes in the main cargo/fixture list
		window w_fixture_list.		
	</OBJECT>
	
   <USAGE>
		Self-explanatory.		
	</USAGE>

<HISTORY> 
   Date	   CR-Ref	 Author	Comments
06/09/11		CR 2214	CONASW	Added functionality to copy cargo
14/08/17	     CR2894 	 KSH092			  As soon as user types a value in a numeric field ,allowed to leave it empay.
</HISTORY>    
********************************************************************/
end subroutine

public subroutine documentation ();/********************************************************************
	w_modify_cargo
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
	 	25/06/2013	CR3244	 	WWA048		Duplicate the features specific to profit center group Crude to Nova
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		14/08/2017	CR2894		KSH092		Cargo Size column allow value is null when press Ctrl +0
	</HISTORY>
********************************************************************/
end subroutine

on w_modify_cargo.create
int iCurrent
call super::create
this.p_source=create p_source
this.p_broker=create p_broker
this.p_char=create p_char
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.dw_cargo=create dw_cargo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_source
this.Control[iCurrent+2]=this.p_broker
this.Control[iCurrent+3]=this.p_char
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_update
this.Control[iCurrent+6]=this.dw_cargo
end on

on w_modify_cargo.destroy
call super::destroy
destroy(this.p_source)
destroy(this.p_broker)
destroy(this.p_char)
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.dw_cargo)
end on

event open;/********************************************************************
   open
   <DESC>  </DESC>
   <RETURN> long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>  </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author             Comments
   	26/06/2013   CR3244       WWA048        		Duplicate the features specific to profit center group Crude to Nova
   </HISTORY>
********************************************************************/

datawindowchild	ldwc
long 					ll_row
integer 				li_officeid, li_office_group

istr_cargo = message.powerobjectparm
dw_cargo.setTransObject(SQLCA)

this.width = 1760
this.height = 1750
this.move(1050,0)


if isNull(istr_cargo.id) then	
	uf_setDDDW(dw_cargo)
	dw_cargo.retrieve(0)
	ll_row = dw_cargo.InsertRow(0)
	if ll_row < 1 then return
	dw_cargo.setitem( 1,"pcgroup_id",istr_cargo.pcgroup)
	// set status = Possible when creating new cargo
	dw_cargo.setitem( 1,"pf_fixture_statusid",110) 
	// for crude/nova we also set a default cargoid
	if istr_cargo.pcgroup = c#pcgroup.ii_CRUDE then 
		dw_cargo.setitem(1, "cargoid", 89)
	elseif istr_cargo.pcgroup = c#pcgroup.ii_NOVA then
		dw_cargo.setitem(1, "cargoid", 306)
	end if
	
	dw_cargo.setitem( 1,"pf_fixture_cargotypeid",1) //spot
	dw_cargo.resetUpdate()    //set status to notModified!
	dw_cargo.setitemstatus(1, 0, Primary!, New!)  //set status back to New!
	
	SELECT USERS.OFFICE_NR, OFFICES.PCGROUP_ID 
	INTO :li_officeid, :li_office_group
	FROM USERS, OFFICES
	WHERE USERID=:uo_global.is_userid AND USERS.OFFICE_NR= OFFICES.OFFICE_NR;
	if li_office_group = istr_cargo.pcgroup then
	  dw_cargo.setitem( 1,"pf_fixture_officeid",li_officeid) 
	end if	
else	
	uf_setDDDW(dw_cargo)
	dw_cargo.retrieve(istr_cargo.id)
	if istr_cargo.iscopy = True Then   // CR 2214 - If copying existing cargo
		dw_Cargo.setitemstatus(1, 0, Primary!, NewModified!)
		setnull(ll_row)
		dw_Cargo.setitem(1, "fixture_id", ll_row)
		this.title = "Create New Cargo"
	else
		this.title = "Modify Cargo #"+string(istr_cargo.id)
	end If
end if




end event

event closequery;dw_cargo.accepttext()
if dw_cargo.modifiedcount() > 0 then
	if MessageBox("Confirmation", "Data Changed but not saved. Close anyway?", question!, YesNo!,2) = 2 then
		dw_cargo.POST setFocus()
		return 1
	end if
end if
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_modify_cargo
end type

type p_source from picture within w_modify_cargo
integer x = 1600
integer y = 288
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "images\DISTLSTL.GIF"
boolean focusrectangle = false
string powertiptext = "See details (if empty, click to create new source)"
end type

event clicked;_select_company( "pf_fixture_sourceid")



end event

type p_broker from picture within w_modify_cargo
integer x = 1600
integer y = 216
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "images\DISTLSTL.GIF"
boolean focusrectangle = false
string powertiptext = "See details (if empty, click to create  new broker)"
end type

event clicked;_select_company( "brokerid")

end event

type p_char from picture within w_modify_cargo
integer x = 1600
integer y = 148
integer width = 73
integer height = 64
string picturename = "images\DISTLSTL.GIF"
boolean focusrectangle = false
string powertiptext = "See details (if empty, click to create new charterer)"
end type

event clicked;_select_company( "chartererid")

end event

type cb_cancel from mt_u_commandbutton within w_modify_cargo
integer x = 1280
integer y = 1488
integer width = 402
integer height = 112
integer taborder = 40
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_update from mt_u_commandbutton within w_modify_cargo
integer x = 878
integer y = 1488
integer width = 402
integer height = 112
integer taborder = 30
string facename = "Arial"
string text = "&Update"
end type

event clicked;string 	ls_portcode
long		ll_found

n_fixture lnv_fixture
lnv_fixture = CREATE n_fixture

dw_cargo.acceptText()

if  dw_cargo.rowcount( ) <> 0 then
	/* Validate that the loadport is in the dropdown list */
	ls_portcode = dw_cargo.getItemString(1, "pf_fixture_lportcode")
	if not isNull(ls_portcode) then
		ll_found = w_share.dw_calc_port_dddw.find("port_code='"+ls_portcode+"'", 1, 99999)
		if ll_found = 0 then 
			MessageBox("Validation Error", "Entered Loadport is not correct. Please select a valid port from the list.")
			dw_cargo.post setcolumn( "pf_fixture_lportcode" )
			dw_cargo.post setFocus()
			return
		end if
	end if
	/* Validate that the dischargeport is in the dropdown list */
	ls_portcode = dw_cargo.getItemString(1, "pf_fixture_dportcode")
	if not isNull(ls_portcode) then
		ll_found = w_share.dw_calc_port_dddw.find("port_code='"+ls_portcode+"'", 1, 99999)
		if ll_found = 0 then 
			MessageBox("Validation Error", "Entered Dischargeport is not correct. Please select a valid port from the list.")
			dw_cargo.post setcolumn( "pf_fixture_dportcode" )
			dw_cargo.post setFocus()
			return
		end if
	end if
	
	if isNull(dw_cargo.getItemnumber(1, "brokerid")) and not isNull(dw_cargo.getItemNumber(1, "pf_fixture_sourceid")) then
		dw_cargo.setitem(1, "brokerid",dw_cargo.getitemnumber(1,"pf_fixture_sourceid"))
	end if
	
	dw_cargo.setitem( 1,"pf_fixture_cargoreported",today())
	
	if dw_cargo.update() = 1 then
		commit;
		if isValid(w_fixture_list) then	
			w_fixture_list.post uf_setDDDW(w_fixture_list.dw_cargo)
			w_fixture_list.event ue_refreshonerow(dw_cargo.getitemnumber(1, "fixture_id"))
		end if
		close(parent)
	else		
		rollback;
		MessageBox("Update Error", "Error updating position.")
		return -1
	end if
end if
end event

type dw_cargo from datawindow within w_modify_cargo
event ue_dwnkeypress pbm_dwnkey
integer x = 14
integer y = 8
integer width = 1682
integer height = 1436
integer taborder = 10
string title = "none"
string dataobject = "d_cargo"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_dwnkeypress;dec 	ldc_null

setnull(ldc_null)

if keyflags = 2 and (key = Key0! or key = KeyNumpad0!) then 
	if  this.getcolumnname()= 'pf_fixture_cargosize'  then
		this.setitem(this.getrow(),'pf_fixture_cargosize',ldc_null)
		this.selecttext(1,30)
	end if
end if
end event

event editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, dw_cargo)


end event

event itemchanged;/********************************************************************
   itemchanged
   <DESC>  </DESC>
   <RETURN> long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author            Comments
   	26/06/2013 CR3244       WWA048        		Duplicate the features specific to profit center group Crude to Nova
   </HISTORY>
********************************************************************/


if dwo.name = 'pf_fixture_cargosize' then
	this.setitem( row, 'pf_fixture_cargosize', abs(dec(data)))
	return 2
end if

if istr_cargo.pcgroup = c#pcgroup.ii_CRUDE or istr_cargo.pcgroup = c#pcgroup.ii_NOVA then return
// If PC Group Crude/Nova Ignore Setting Source = Broker 
choose case dwo.name
	case "brokerid"
		this.accepttext( )
		if isnull(getitemnumber( row,"pf_fixture_sourceid" )) then
			this.setitem(row, "pf_fixture_sourceid",getitemnumber(row,"brokerid"))
		end if
end choose


end event

event itemfocuschanged;
if dwo.name = 'pf_fixture_cargosize'  then
	this.selecttext(1,30)
end if


end event

event getfocus;if this.getcolumnname() = 'pf_fixture_cargosize'  then
	this.selecttext(1,30)
end if
end event

