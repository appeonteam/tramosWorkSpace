$PBExportHeader$w_fixture_list.srw
forward
global type w_fixture_list from w_tramos_container
end type
type cb_copycargo from mt_u_commandbutton within w_fixture_list
end type
type uo_fix_filterbox from u_fix_filterbox within w_fixture_list
end type
type uo_pcgroup from u_pcgroup within w_fixture_list
end type
type cb_newfixture from mt_u_commandbutton within w_fixture_list
end type
type cb_deletecargo from mt_u_commandbutton within w_fixture_list
end type
type cb_editfixture from mt_u_commandbutton within w_fixture_list
end type
type cb_save from mt_u_commandbutton within w_fixture_list
end type
type st_6 from mt_u_statictext within w_fixture_list
end type
type cb_fix from mt_u_commandbutton within w_fixture_list
end type
type cb_newcargo from mt_u_commandbutton within w_fixture_list
end type
type cb_editcargo from mt_u_commandbutton within w_fixture_list
end type
type cb_deletefixture from mt_u_commandbutton within w_fixture_list
end type
type cb_print from mt_u_commandbutton within w_fixture_list
end type
type cb_saveas from mt_u_commandbutton within w_fixture_list
end type
type cb_refresh from mt_u_commandbutton within w_fixture_list
end type
type dw_fixture from datawindow within w_fixture_list
end type
type dw_cargo from datawindow within w_fixture_list
end type
end forward

global type w_fixture_list from w_tramos_container
integer width = 5746
integer height = 3144
string title = "Fixture/Cargo List"
string icon = "images\fixture_list.ico"
event ue_refreshonerow ( long al_fixtureid )
event ue_refreshrequest ( )
cb_copycargo cb_copycargo
uo_fix_filterbox uo_fix_filterbox
uo_pcgroup uo_pcgroup
cb_newfixture cb_newfixture
cb_deletecargo cb_deletecargo
cb_editfixture cb_editfixture
cb_save cb_save
st_6 st_6
cb_fix cb_fix
cb_newcargo cb_newcargo
cb_editcargo cb_editcargo
cb_deletefixture cb_deletefixture
cb_print cb_print
cb_saveas cb_saveas
cb_refresh cb_refresh
dw_fixture dw_fixture
dw_cargo dw_cargo
end type
global w_fixture_list w_fixture_list

type variables
int 		ii_fixture_days, ii_pcgroup
int			ii_mod_ynresp

int			ii_cargo_width, ii_cargo_x_pos, ii_cargo_y_pos, ii_min_cargo_height, ii_max_cargo_height, ii_window_height, ii_nice_cargo_height, ii_nice_cargo_width
string		is_sort, is_sort_temp, is_vessel_filter,is_vessel_competitor_filter,is_vessel_id, is_charterer_filter, is_broker_filter, is_operator_filter, is_office_filter, is_cargo_filter,is_darea_filter, is_larea_filter, is_day_filter
string 	is_cargodw_filter, is_fixturedw_filter
int			ii_areafilter

mt_n_dddw_searchasyoutype inv_dddw_search
//	s_pf 		istr_fixture

constant integer resp_empty = 0
constant integer resp_yes = 1
constant integer resp_no = 2
end variables

forward prototypes
public subroutine of_setretrieveargs (datawindow adw, integer row, string column, ref integer tmp[])
private function boolean uf_modify_pc (datawindow adw, integer row)
private function boolean wf_set_dw_dataobject (ref datawindow adw, string as_do_name)
public subroutine wf_setbutton (integer al_button, string as_datawindow, boolean ab_enable_button)
public function integer uf_setdddw (datawindow adw)
public subroutine documentation ()
end prototypes

event ue_refreshonerow(long al_fixtureid);long ll_found

setpointer(hourglass!)



dw_cargo.setredraw( false )
dw_cargo.settransobject( SQLCA)
dw_cargo.retrieve(ii_pcgroup,uo_fix_filterbox.of_getnbrofdays() )

ll_found = dw_cargo.find("fixture_id ="+string(al_fixtureid),1,999999)
if ll_found > 0 then
	dw_cargo.selectrow(0, false)
	dw_cargo.selectrow(ll_found,true)
	dw_cargo.scrolltorow(ll_found)
end if

dw_cargo.setredraw( true )
dw_cargo.POST setfocus()
dw_fixture.setredraw( false )

dw_fixture.settransobject( SQLCA)
dw_fixture.retrieve(ii_pcgroup,uo_fix_filterbox.of_getnbrofdays())

ll_found = dw_fixture.find("fixture_id ="+string(al_fixtureid),1,999999)
if ll_found > 0 then
	dw_fixture.selectrow(0, false)
	dw_fixture.selectrow(ll_found,true)
	dw_fixture.scrolltorow(ll_found)
end if

dw_fixture.setredraw( true )


setpointer(Arrow!)
dw_fixture.POST setfocus()

end event

event ue_refreshrequest();/********************************************************************
   event ue_refreshrequest( )
   <DESC>   Used so the refresh event can now be accessed from the user filter
	control</DESC>
   <RETURN>n/a</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS></ARGS>
   <USAGE>  something like the following -
				lw_fixture = parent.getparent( )
				lw_fixture.PostEvent("ue_refreshrequest")
	</USAGE>
	<HISTORY>
   	Date         CR-Ref       Author             Comments
   	26/06/2013   CR3244       WWA048        		Duplicate the features specific to profit center group Crude to Nova
   </HISTORY>
********************************************************************/

datawindowchild	ldwc
string				ls_userid
int 					li_number
long					ll_retrieval_days, ll_entered_days

if ii_mod_ynresp=resp_empty then
	if dw_fixture.modifiedcount( )>0 or dw_cargo.modifiedcount( )>0 then
		ii_mod_ynresp=MessageBox("Confirmation", "Data Changed but not saved. Lose changes?", question!, YesNo!,2)
	end if
end if

if ii_mod_ynresp<>resp_no then
	ii_mod_ynresp=resp_empty
	if ii_pcgroup = 0 then
		MessageBox("Error", "No profit center groups available")
		return
	end if

	if ii_pcgroup = c#pcgroup.ii_CRUDE or ii_pcgroup = c#pcgroup.ii_NOVA then // profit center group is Crude or Nova
		wf_set_dw_dataobject(dw_fixture,"d_fixture_list_crude")
		wf_set_dw_dataobject(dw_cargo,"d_cargo_list_crude")
	else
		wf_set_dw_dataobject(dw_fixture,"d_fixture_list")
		wf_set_dw_dataobject(dw_cargo,"d_cargo_list")
	end if

	dw_cargo.setTransObject(SQLCA)
	dw_fixture.setTransObject(SQLCA)
	
	if uf_setDDDW(dw_cargo) = -1 then
		dw_cargo.reset( )
		dw_fixture.reset( )
		wf_setbutton(1,"",false)
		return
	end if
	
	if uf_setDDDW(dw_fixture) = -1 then
		dw_cargo.reset( )
		dw_fixture.reset( )
		wf_setbutton(1,"",false)
		return
	end if

		
	if dw_cargo.retrieve(ii_pcgroup, uo_fix_filterbox.of_getnbrofdays()) > 0 then
		wf_setbutton(1,"d_cargo_list",true)
	else
		wf_setbutton(1,"d_cargo_list",false)
	end if
	if dw_fixture.retrieve(ii_pcgroup, uo_fix_filterbox.of_getnbrofdays()) > 0 then
		wf_setbutton(1,"d_fixture_list",true)
	else
		wf_setbutton(1,"d_fixture_list",false)
	end if
	if dw_cargo.rowcount()=0 and dw_fixture.rowcount()=0 then			
		wf_setbutton(1,"",false)
	end if

	
	commit;
else
	ii_mod_ynresp=resp_empty
end if

end event

public subroutine of_setretrieveargs (datawindow adw, integer row, string column, ref integer tmp[]);integer li_empty[]
integer li_x, li_count
String   ls_count

if (row > 0) then
	if adw.isselected(row) then
		adw.selectrow(row,false)
	else
		adw.selectrow(row,true)
	end if
	tmp = li_empty
	for li_x = 1 to adw.rowCount()
		if adw.isselected(li_x) then
			li_count ++
			tmp[li_count] = adw.getItemNumber(li_x, column)
		end if
	next
end if


end subroutine

private function boolean uf_modify_pc (datawindow adw, integer row);/********************************************************************
   FunctionName
   <DESC>   Description</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/

if adw.dataobject = "d_fixture_list" or adw.dataobject = "d_fixture_list_crude" then
	MessageBox("","ok we have reference to the object...")
end if

return True
end function

private function boolean wf_set_dw_dataobject (ref datawindow adw, string as_do_name);/********************************************************************
   wf_set_dw_dataobject( /*ref datawindow adw*/, /*string as_do_name */)
   <DESC>Simple function to reapply pc headers and sorting if necessary</DESC>
   <RETURN> Boolean (not really used in call):
            <LI> True, ok
   <ACCESS>Private</ACCESS>
   <ARGS>   adw: fixture/cargo datawindow reference
            as_do_name: dataobject name</ARGS>
   <USAGE>Simple usage</USAGE>
********************************************************************/

if adw.dataobject <> as_do_name then 
	adw.dataobject=as_do_name
end if

return True
end function

public subroutine wf_setbutton (integer al_button, string as_datawindow, boolean ab_enable_button);if as_datawindow = ""  then
	cb_editcargo.enabled = ab_enable_button
	cb_copycargo.enabled = ab_enable_button
	cb_editfixture.enabled = ab_enable_button
	cb_deletecargo.enabled = ab_enable_button
	cb_deletefixture.enabled = ab_enable_button
	cb_fix.enabled = ab_enable_button
	cb_saveas.enabled = ab_enable_button
	cb_print.enabled = ab_enable_button
	cb_save.enabled = ab_enable_button
else
	if pos(as_datawindow,"d_cargo_list") = 0 then 
		cb_editfixture.enabled = ab_enable_button
		cb_deletefixture.enabled = ab_enable_button
	elseif pos(as_datawindow,"d_fixture_list") = 0 then 
		cb_editcargo.enabled = ab_enable_button
		cb_copycargo.enabled = ab_enable_button
		cb_deletecargo.enabled = ab_enable_button
		cb_fix.enabled = ab_enable_button
	end if
	if al_button > 1 then //al_button = 2,  cargo and fixture list are empty
		cb_saveas.enabled = ab_enable_button
		cb_print.enabled = ab_enable_button
		cb_save.enabled = ab_enable_button
	else
		cb_saveas.enabled = true
		cb_print.enabled = true
		cb_save.enabled = true
	end if
end if

//if upperbound(ii_profitcenter)>0 then 
//	choose case ii_profitcenter[1]
//		case 2, 4, 13, 17
//			cb_newcargo.enabled=true
//			cb_newfixture.enabled=true
//		case else
//			cb_newcargo.enabled=false	
//			cb_newfixture.enabled=false
//	end choose
//end if

// uo_filterbox.enabled=ab_enable_button
end subroutine

public function integer uf_setdddw (datawindow adw);datawindowchild	ldwc
long					ll_rows, ll_row

/* retrieve DDDW - vessel*/
//adw.getchild("pf_fixture_vesselname", ldwc)
adw.getchild("pf_fixture_vesselid_web", ldwc)
ldwc.SetTransObject(SQLCA)
// fix - just in case there are no competitor vessels
if ldwc.retrieve(ii_pcgroup) = 0 then
	ldwc.insertrow(0)
end if
adw.getchild("vesselid", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve(ii_pcgroup)

/* retrieve DDDW - charterer*/
adw.getchild("chartererid", ldwc)
ldwc.SetTransObject(SQLCA)
if ldwc.retrieve(ii_pcgroup) <= 0 then
	return -1
end if
/* retrieve DDDW - broker*/
adw.getchild("brokerid", ldwc)
ldwc.SetTransObject(SQLCA)
if ldwc.retrieve(ii_pcgroup) <= 0 then
	return -1
end if
/* retrieve DDDW - cargo*/
adw.getchild("cargoid", ldwc)
ldwc.SetTransObject(SQLCA)
if ldwc.retrieve(ii_pcgroup) <= 0 then
	return -1
end if
/* retrieve DDDW - trade*/
adw.getchild("pf_fixture_tradeid", ldwc)
ldwc.SetTransObject(SQLCA)
if ldwc.retrieve(ii_pcgroup) <= 0 then
	return -1
end if
/* retrieve DDDW - status*/
adw.getchild("pf_fixture_statusid", ldwc)
ldwc.SetTransObject(SQLCA)
if ldwc.retrieve(ii_pcgroup) <= 0 then
	return -1
end if





end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_fixture_list
	
   <OBJECT>
		This is the main window for the Cargo/Fixture list functionality. It displays a list
		of cargoes and fixtures and allows users to create, edit, fix cargos and fixtures.
		
	</OBJECT>
	
   <USAGE>
		Self-explanatory.		
	</USAGE>

<HISTORY> 
   Date	   	CR-Ref	 Author	Comments
	06/09/11		CR 2214	 	CONASW	Added the "Copy Cargo" button to copy selected cargo.
	25/06/13		CR3244	 	WWA048	Duplicate the features specific to profit center group Crude to Nova
	04/08/14 	CR3708		AGL027	F1 help application coverage - change ancestor
	28/08/14		CR3781		CCY018	The window title match with the text of a menu item
	21/11/14		CR3708		CCY018	Fixed a problem,change event risize()
	14/08/17		CR3350		KSH092	When close Tramos,Close this window
	14/08/17 	CR2894		KSH092	Size and rate column allow value is null when press Ctrl +0 
</HISTORY>    
********************************************************************/
end subroutine

on w_fixture_list.create
int iCurrent
call super::create
this.cb_copycargo=create cb_copycargo
this.uo_fix_filterbox=create uo_fix_filterbox
this.uo_pcgroup=create uo_pcgroup
this.cb_newfixture=create cb_newfixture
this.cb_deletecargo=create cb_deletecargo
this.cb_editfixture=create cb_editfixture
this.cb_save=create cb_save
this.st_6=create st_6
this.cb_fix=create cb_fix
this.cb_newcargo=create cb_newcargo
this.cb_editcargo=create cb_editcargo
this.cb_deletefixture=create cb_deletefixture
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.cb_refresh=create cb_refresh
this.dw_fixture=create dw_fixture
this.dw_cargo=create dw_cargo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copycargo
this.Control[iCurrent+2]=this.uo_fix_filterbox
this.Control[iCurrent+3]=this.uo_pcgroup
this.Control[iCurrent+4]=this.cb_newfixture
this.Control[iCurrent+5]=this.cb_deletecargo
this.Control[iCurrent+6]=this.cb_editfixture
this.Control[iCurrent+7]=this.cb_save
this.Control[iCurrent+8]=this.st_6
this.Control[iCurrent+9]=this.cb_fix
this.Control[iCurrent+10]=this.cb_newcargo
this.Control[iCurrent+11]=this.cb_editcargo
this.Control[iCurrent+12]=this.cb_deletefixture
this.Control[iCurrent+13]=this.cb_print
this.Control[iCurrent+14]=this.cb_saveas
this.Control[iCurrent+15]=this.cb_refresh
this.Control[iCurrent+16]=this.dw_fixture
this.Control[iCurrent+17]=this.dw_cargo
end on

on w_fixture_list.destroy
call super::destroy
destroy(this.cb_copycargo)
destroy(this.uo_fix_filterbox)
destroy(this.uo_pcgroup)
destroy(this.cb_newfixture)
destroy(this.cb_deletecargo)
destroy(this.cb_editfixture)
destroy(this.cb_save)
destroy(this.st_6)
destroy(this.cb_fix)
destroy(this.cb_newcargo)
destroy(this.cb_editcargo)
destroy(this.cb_deletefixture)
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.cb_refresh)
destroy(this.dw_fixture)
destroy(this.dw_cargo)
end on

event open;call super::open;datawindowchild	ldwc
long ll_pcnr, ll_found

// dynamic resizing of window - init variables
ii_cargo_width=dw_cargo.width
ii_nice_cargo_width=ii_cargo_width
ii_window_height=this.height
ii_max_cargo_height=ii_window_height - 300
ii_min_cargo_height=200
ii_cargo_y_pos=dw_cargo.y
ii_cargo_x_pos=dw_cargo.x
ii_nice_cargo_height = 1388
dw_fixture.height=ii_window_height -(dw_cargo.height+50)
// dynamic resizing of window - init variables : end 

uo_fix_filterbox.of_registerdw(dw_fixture)
uo_fix_filterbox.of_registerdw(dw_cargo)


ii_pcgroup=uo_pcgroup.uf_getpcgroup( )
if ii_pcgroup<0 then
	this.Post Event ue_postopen()
else
	// initialise ii_pc[] array
	if (ii_pcgroup>0) then
		event ue_refreshrequest( )
		uo_fix_filterbox.of_updatefilterdddw(ii_pcgroup) 
	end if
	if dw_cargo.rowcount( ) > 0 then
		if dw_cargo.rowcount( )<20 then
			dw_cargo.height = 100 * dw_cargo.rowcount( ) + 100
		else
			dw_cargo.height = ii_nice_cargo_height
		end if
	end if	
end if
end event

event closequery;call super::closequery;n_messagebox lnv_messagebox
integer      li_messagebox, li_return

dw_fixture.accepttext()

dw_cargo.accepttext()

if dw_fixture.modifiedcount() > 0 or dw_cargo.modifiedcount() > 0 then
	
	this.bringtotop = true
	
	if this.windowstate = Minimized! then
		this.windowstate = Normal!
	end if
	li_messagebox = lnv_messagebox.of_messagebox(lnv_messagebox.is_TYPE_UNSAVED_DATA, '', this)
	
	choose case li_messagebox
		case 1
			if isvalid(w_modify_fixture) then
				w_modify_fixture.dw_fixture.accepttext()
				if w_modify_fixture.dw_fixture.modifiedcount() > 0 then
					if w_modify_fixture.event ue_update() = c#return.failure then
						return c#return.failure
					end if
				end if
			end if
			if cb_save.event clicked() = C#return.Failure then
				return C#return.Failure
			end if
		case 2
			if isvalid(w_modify_fixture) then
				w_modify_fixture.dw_fixture.retrieve(0)
			end if
			dw_cargo.retrieve(ii_pcgroup,uo_fix_filterbox.of_getnbrofdays())
			dw_fixture.retrieve(ii_pcgroup,uo_fix_filterbox.of_getnbrofdays())
		case else
			return C#return.Failure
	end choose
else
	if isvalid(w_modify_fixture) then
		
		li_return = w_modify_fixture.event closequery()
		if li_return = c#return.failure then
		 
			return c#return.failure
		elseif li_return = 0 then
			return 0
		elseif li_return = c#return.success then
			return 0
		end if
	end if
end if

return 0
end event

event resize;call super::resize;// dynamic resizing of main window - event

ii_window_height = this.height 

if sizetype = 1 then return	
if  ii_window_height - 300 > ii_min_cargo_height then
	ii_max_cargo_height = ii_window_height - 300	
end if

if this.width > ii_nice_cargo_width + ii_cargo_x_pos +60 then
	ii_cargo_width =ii_nice_cargo_width
else
	ii_cargo_width = this.width - (ii_cargo_x_pos + 60)
end if

dw_fixture.width=ii_cargo_width
dw_cargo.event post resize(0, ii_cargo_width, dw_cargo.height)

end event

event ue_pcgroupchanged;call super::ue_pcgroupchanged;
datawindowchild ldwc

// reset instance variable 
ii_mod_ynresp=resp_empty

if ii_pcgroup > 0 then
	if dw_fixture.modifiedcount( )>0 or dw_cargo.modifiedcount( )>0 then
		ii_mod_ynresp=MessageBox("Confirmation", "Data Changed but not saved. Lose changes?", question!, YesNo!,2)
	end if
	if ii_mod_ynresp<>resp_no then
		ii_pcgroup = ai_pcgroupid		
		this.setredraw( false)
		event ue_refreshrequest( )
		uo_fix_filterbox.of_updatefilterdddw(ii_pcgroup) 
		this.setredraw( true)
	else
		return ii_pcgroup
	end if
else
	if dw_fixture.modifiedcount( )>0 or dw_cargo.modifiedcount( )>0 then
		ii_mod_ynresp=MessageBox("Confirmation", "Data Changed but not saved. Lose changes?", question!, YesNo!,2)
	end if
	if ii_mod_ynresp<>resp_no then
		wf_setbutton(1,"",false)
	end if
	ii_mod_ynresp=resp_empty
end if

return ii_pcgroup
end event

type st_hidemenubar from w_tramos_container`st_hidemenubar within w_fixture_list
end type

type cb_copycargo from mt_u_commandbutton within w_fixture_list
integer x = 366
integer y = 500
integer width = 361
integer taborder = 60
string facename = "Arial"
boolean enabled = false
string text = "&Copy Cargo"
end type

event clicked;long		ll_row
s_pf 		lstr_fixture

if dw_cargo.modifiedcount( )>0 then
	if messagebox("Loose Changes", "You have made changes but not saved them. Do you want to lose the changes?", Question!,YesNo!)=2 then Return
end if

lstr_fixture.id = 0

if dw_cargo.visible then
	ll_row = dw_cargo.getselectedRow(0)
	if ll_row > 0 then lstr_fixture.id = dw_cargo.getitemnumber(ll_row,"fixture_id") 
end if

if dw_fixture.visible and ll_row<1 then
	ll_row = dw_fixture.getselectedRow(0)
	if ll_row > 0 then lstr_fixture.id = dw_fixture.getitemnumber(ll_row,"fixture_id") 
end if

if lstr_fixture.id=0 then
	Messagebox("Nothing Selected", "Please select a Cargo or Fixture to copy from", Exclamation!)
	return
end if

lstr_fixture.iscopy=true
lstr_fixture.pcgroup=ii_pcgroup
openwithparm(w_modify_cargo, lstr_fixture)



end event

type uo_fix_filterbox from u_fix_filterbox within w_fixture_list
integer y = 1232
integer taborder = 130
end type

on uo_fix_filterbox.destroy
call u_fix_filterbox::destroy
end on

type uo_pcgroup from u_pcgroup within w_fixture_list
event ue_change pbm_enchange
integer x = 9
integer y = 20
integer height = 152
integer taborder = 160
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type cb_newfixture from mt_u_commandbutton within w_fixture_list
integer y = 500
integer width = 361
integer taborder = 50
string facename = "Arial"
string text = "Ne&w Fixture"
end type

event clicked;long		ll_null, ll_row
s_pf 		lstr_position

setNull(ll_null)

/* Profitcenter Group */
if ii_pcgroup=0 then
	MessageBox("Error", "No profit center group selected")
	return
else 
	lstr_position.id = ll_null
	lstr_position.pcgroup = ii_pcgroup
	openWithParm(w_modify_fixture, lstr_position) 
	return 1
end if

 



end event

type cb_deletecargo from mt_u_commandbutton within w_fixture_list
integer y = 396
integer width = 361
integer taborder = 30
string facename = "Arial"
boolean enabled = false
string text = "&Delete Cargo"
end type

event clicked;long	ll_row

if dw_cargo.modifiedcount( )>0 then
	if messagebox("Loose Changes", "You have made changes but not saved them. Do you want to lose the changes?", Question!,YesNo!)=2 then Return
end if

if dw_cargo.visible then
	//ll_row = dw_cargo.getRow()
	ll_row = dw_cargo.getselectedrow( 0)
	if ll_row < 1 then
		MessageBox("Warning", "Please select a cargo.")
		return
	end if
		
	if MessageBox("Confirmation", "Are you sure you you want to delete the cargo?", question!, YesNo!,2) = 1 then 
		//if dw_cargo.deleterow(ll_row) = 1 then
		if dw_cargo.setitem(ll_row, "pf_fixture_statusid", 114) = 1 then
			dw_cargo.update( )
			commit;	
			//dw_cargo.retrieve(ii_pcgroup,0)		
			dw_cargo.retrieve(ii_pcgroup,uo_fix_filterbox.of_getnbrofdays())
			return 1
		else
			MessageBox("Delete Error", "Error deleting cargo.")
			return -1
		end if
	end if
end if
end event

type cb_editfixture from mt_u_commandbutton within w_fixture_list
integer x = 366
integer y = 604
integer width = 361
integer taborder = 80
string facename = "Arial"
boolean enabled = false
string text = "Ed&it Fixture"
end type

event clicked;long		ll_row
s_pf 		lstr_position

ll_row = dw_fixture.getselectedRow(0)
if ll_row < 1 then return

lstr_position.id = dw_fixture.getitemnumber(ll_row,"fixture_id") 
lstr_position.pcgroup=ii_pcgroup
openwithparm(w_modify_fixture, lstr_position)



end event

type cb_save from mt_u_commandbutton within w_fixture_list
integer y = 812
integer width = 727
integer taborder = 110
string facename = "Arial"
boolean enabled = false
string text = "&Update Changes"
end type

event clicked;n_fixture lnv_fixture
//create object
lnv_fixture = CREATE n_fixture
int ii_loop_counter

// Cargo Listing
dw_cargo.acceptText()
if dw_cargo.modifiedcount( ) > 0 then
	if dw_cargo.update() = 1 then
		commit;
		parent.post event ue_refreshonerow(dw_cargo.getitemnumber(dw_cargo.getrow(),"fixture_id") )
	else
		rollback;
		MessageBox("Update Error", "Error updating fixtures.")
		return -1
	end if
end if

// Fixture Listing
dw_fixture.acceptText()
if dw_fixture.modifiedcount( ) > 0 then
	lnv_fixture.uf_f_status_exceptions( dw_fixture)
	if dw_fixture.update() = 1 then
		commit;
		parent.post event ue_refreshonerow(dw_fixture.getitemnumber(dw_fixture.getrow(),"fixture_id") )
	else
		rollback;
		MessageBox("Update Error", "Error updating cargos.")
		return -1
	end if
end if

return 1
end event

type st_6 from mt_u_statictext within w_fixture_list
integer x = -1897
integer y = -12988
integer width = 507
integer weight = 700
string facename = "Arial"
string text = "Select Area(s):"
end type

type cb_fix from mt_u_commandbutton within w_fixture_list
integer x = 366
integer y = 396
integer width = 361
integer taborder = 40
string facename = "Arial"
boolean enabled = false
string text = "&Fix Cargo"
end type

event clicked;long		ll_row
s_pf 		lstr_position

if dw_cargo.visible then
	ll_row = dw_cargo.getselectedrow( 0)
	if ll_row < 1 then 
		MessageBox("Warning", "Please select a cargo.")
		return
	end if
	
	//JMC112 28/10/2010 When Fixing a cargo, any changes in cargo and fixture list were lost
	if dw_cargo.update( ) = -1 then
		MessageBoX("Error", "Error in Cargo list. Please check the errors before fixing the cargo.")
		return
	end if
	if dw_fixture.update() = -1 then
		MessageBoX("Error", "Error in Fixture list. please check the errors before fixing the cargo.")
		return
	end if
	
	commit;
						
	lstr_position.id = dw_cargo.getitemnumber(ll_row,"fixture_id") 
	lstr_position.pcgroup=ii_pcgroup
	openwithparm(w_modify_fixture, lstr_position)
end if

end event

type cb_newcargo from mt_u_commandbutton within w_fixture_list
integer y = 292
integer width = 361
integer taborder = 10
string facename = "Arial"
string text = "&New Cargo"
end type

event clicked;long		ll_null, ll_row
s_pf 		lstr_position

setNull(ll_null)

if dw_cargo.modifiedcount( )>0 then
	if messagebox("Loose Changes", "You have made changes but not saved them. Do you want to lose the changes?", Question!,YesNo!)=2 then Return
end if

/* Profitcenter */
if ii_pcgroup=0 then
	MessageBox("Error", "Please select a Profitcenter Group.")
	return
else 
	lstr_position.iscopy=false
	lstr_position.id = ll_null
	lstr_position.pcgroup = ii_pcgroup
	openWithParm(w_modify_cargo, lstr_position) 
	return 1
end if

 



end event

type cb_editcargo from mt_u_commandbutton within w_fixture_list
integer x = 366
integer y = 292
integer width = 361
integer taborder = 20
string facename = "Arial"
boolean enabled = false
string text = "&Edit Cargo"
end type

event clicked;long		ll_row
s_pf 		lstr_fixture

if dw_cargo.modifiedcount( )>0 then
	if messagebox("Loose Changes", "You have made changes but not saved them. Do you want to lose the changes?", Question!,YesNo!)=2 then Return
end if

if dw_cargo.visible then
	ll_row = dw_cargo.getselectedRow(0)
	if ll_row < 1 then return
	lstr_fixture.id = dw_cargo.getitemnumber(ll_row,"fixture_id") 
end if

lstr_fixture.iscopy=false
lstr_fixture.pcgroup=ii_pcgroup
openwithparm(w_modify_cargo, lstr_fixture)



end event

type cb_deletefixture from mt_u_commandbutton within w_fixture_list
integer y = 604
integer width = 361
integer taborder = 70
string facename = "Arial"
boolean enabled = false
string text = "De&lete Fixture"
end type

event clicked;long	ll_row

if dw_fixture.visible then
	ll_row = dw_fixture.getselectedrow( 0)
	
	if ll_row < 1 then 
		MessageBox("Warning", "Please select a fixture.")
		return
	end if
	
	if MessageBox("Confirmation", "Are you sure you you want to delete the fixture?", question!, YesNo!,2) = 1 then 
		if dw_fixture.setitem(ll_row, "pf_fixture_statusid", 114) = 1 then
		//if dw_fixture.deleterow(ll_row) = 1 then
			dw_fixture.update( )
			commit;	
			dw_fixture.retrieve(ii_pcgroup,uo_fix_filterbox.of_getnbrofdays())
			return 1
		else
			MessageBox("Delete Error", "Error deleting fixture.")
			return -1
		end if
	end if
end if
end event

type cb_print from mt_u_commandbutton within w_fixture_list
integer y = 708
integer width = 361
integer taborder = 90
string facename = "Arial"
boolean enabled = false
string text = "&Print"
end type

event clicked;if dw_cargo.visible then
	dw_cargo.print()
end if

if dw_fixture.visible then
	dw_fixture.print()
end if

end event

type cb_saveas from mt_u_commandbutton within w_fixture_list
integer x = 366
integer y = 708
integer width = 361
integer taborder = 100
string facename = "Arial"
boolean enabled = false
string text = "Save &As..."
end type

event clicked;if dw_cargo.visible then
	dw_cargo.saveas()
end if

if dw_fixture.visible then
	dw_fixture.saveas()
end if

end event

type cb_refresh from mt_u_commandbutton within w_fixture_list
integer y = 916
integer width = 727
integer height = 116
integer taborder = 120
string facename = "Arial"
string text = "&Refresh"
end type

event clicked;call super::clicked;Parent.PostEvent("ue_refreshrequest")
end event

type dw_fixture from datawindow within w_fixture_list
event ue_dwnkeypress pbm_dwnkey
integer x = 731
integer y = 1396
integer width = 4951
integer height = 1632
integer taborder = 150
boolean bringtotop = true
string title = "none"
string dataobject = "d_fixture_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_dwnkeypress;dec 	ldc_null
string ls_columnname

setnull(ldc_null)

ls_columnname = this.getcolumnname()
if keyflags = 2 and (key = Key0! or key = KeyNumpad0!) then 
	if  ls_columnname = 'pf_fixture_cargosize'  or ls_columnname = 'pf_fixture_rate'  then
		this.setitem(this.getrow(),ls_columnname,ldc_null)
		this.selecttext(1,30)
	end if
end if
end event

event clicked;string ls_reported_sort

if dwo.type = "text" then
	ls_reported_sort=""
//	if cbx_profit.checked = true then
//		is_sort_pcnr  = "profit_c_pc_name A, "
//	end if
	is_sort = dwo.Tag
	// secondary sorting always on reported date, except when its the primary
	if not isnull(is_sort) and left(is_sort,8)<>"reported" then
		ls_reported_sort = ", reported D"
	end if
//	this.setSort(is_sort_pcnr + is_sort + ls_reported_sort)
	this.setSort(is_sort + ls_reported_sort)
	this.Sort()
	// this part switches the tag to the alternate
	if right(is_sort,1) = "A" then 
		is_sort = replace(is_sort, len(is_sort),1, "D")
	else
		is_sort = replace(is_sort, len(is_sort),1, "A")
	end if
	is_sort_temp = dwo.Tag
	dwo.Tag = is_sort 
	// process sorting
	this.groupCalc()
end if

if row > 0 then
	selectrow(0, false)
	selectrow(row, true)	
	dw_fixture.setfocus( )
	dw_fixture.scrolltorow( row)
	dw_cargo.event losefocus( )
	dw_cargo.selectrow(0, false)
//	dw_vessel.enabled = true
//	dw_vessel_competitor.enabled = true
end if

/* Competitor vessel */
long ll_webid
string ls_clrk_name
if dwo.name = "p_green" then
	if row > 0 then
		ll_webid = this.getItemNumber(row, "pf_fixture_vesselid_web")
		SELECT CAL_CLRK_NAME  
			INTO :ls_clrk_name 
			FROM CAL_CLAR  
			WHERE CAL_CLRK_ID = :ll_webid   ;
		commit;
		opensheet(w_vessel_competitor, w_tramos_main, 0, original!)
		do while w_vessel_competitor.dw_list.rowCount() < 1
			/* do nothing, just wait until data present */
		loop
		//w_vessel_competitor.uo_search.POST of_setText( ls_clrk_name )
		//w_vessel_competitor.uo_search.sle_edit.POST Event ue_keydown(keyEnter!, 0)
		// Above 2 lines are obsolete
		w_vessel_competitor.uo_SearchBox.of_FindAndSelect(ls_clrk_name)
	end if
end if

/* APM vessel */
long ll_vesselid
string ls_vessel_refnr
if dwo.name = "p_blue" then
	if row > 0 then
		ll_vesselid = this.getItemNumber(row, "vesselid")
		SELECT VESSEL_REF_NR
			INTO :ls_vessel_refnr
			FROM VESSELS
			WHERE VESSEL_NR = :ll_vesselid;
		commit;
		opensheet(w_vessel, w_tramos_main, 0, original!)
		do while w_vessel.dw_list.rowCount() < 1
			/* do nothing, just wait until data present */
		loop
		//w_vessel.uo_search.POST of_setText( ls_vessel_refnr )
		//w_vessel.uo_search.sle_edit.POST Event ue_keydown(keyEnter!, 0)
		// Above 2 lines are obsolete
		w_vessel.uo_SearchBox.of_FindAndSelect(ls_vessel_refnr)
	end if
end if

end event

event doubleclicked;if row < 1 then return

cb_editfixture.triggerevent(clicked!)
end event

event itemchanged;dw_fixture.accepttext( )


if dwo.name = 'pf_fixture_cargosize' or dwo.name = 'pf_fixture_rate' then
	this.setitem( row,string(dwo.name), abs(dec(data)))
	return 2
end if
end event

event editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, dw_fixture)
end event

event getfocus;if this.getcolumnname() = 'pf_fixture_cargosize'  or this.getcolumnname() = 'pf_fixture_rate' then
	this.selecttext(1,30)
end if
end event

event itemfocuschanged;if dwo.name = 'pf_fixture_cargosize' or dwo.name ='pf_fixture_rate' then
	this.selecttext(1,30)
end if

end event

type dw_cargo from datawindow within w_fixture_list
event ue_dwnkeypress pbm_dwnkey
integer x = 731
integer y = 8
integer width = 4951
integer height = 1384
integer taborder = 140
boolean bringtotop = true
string title = "none"
string dataobject = "d_cargo_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
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

event clicked;string ls_lc_date_sort

if dwo.type = "text" then
	 ls_lc_date_sort=""
//	if cbx_profit.checked = true then
//		is_sort_pcnr  = "profit_c_pc_name A, "
//	end if
	is_sort = dwo.Tag
	// secondary sorting always on reported date, except when its the primary
	if not isnull(is_sort) and left(is_sort,13)<>"pf_fixture_lc" then
		ls_lc_date_sort = ", pf_fixture_lcstart A"
	end if
//	this.setSort(is_sort_pcnr + is_sort + ls_lc_date_sort)
	this.setSort(is_sort + ls_lc_date_sort)
	this.Sort()
	// this part switches the tag to the alternate
	if right(is_sort,1) = "A" then 
		is_sort = replace(is_sort, len(is_sort),1, "D")
	else
		is_sort = replace(is_sort, len(is_sort),1, "A")
	end if
	is_sort_temp = dwo.Tag
	dwo.Tag = is_sort 
	// process sorting
	this.groupCalc()
end if

if row > 0 then
	selectrow(0, false)
	selectrow(row, true)	
	dw_cargo.setfocus( )
	dw_cargo.scrolltorow( row)
	dw_fixture.event losefocus( )
	dw_fixture.selectrow(0, false)
end if


end event

event doubleclicked;if row < 1 then return

cb_editcargo.triggerevent(clicked!)
end event

event itemchanged;dw_cargo.accepttext( )

if dwo.name = 'pf_fixture_cargosize' then
	this.setitem( row, 'pf_fixture_cargosize', abs(dec(data)))
	return 2
end if
end event

event editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, dw_cargo)
end event

event resize;// dynamic resizing of datawindow - event

this.X = ii_cargo_x_pos
this.Y = ii_cargo_y_pos
this.width = ii_cargo_width

if this.height<=ii_min_cargo_height then
	this.height=ii_min_cargo_height
end if
if this.height>=ii_max_cargo_height then
	this.height=ii_max_cargo_height
end if

dw_fixture.move( ii_cargo_x_pos, this.height+13)
dw_fixture.height= ii_window_height - dw_cargo.height - 200

end event

event getfocus;if this.getcolumnname() = 'pf_fixture_cargosize'  then
	this.selecttext(1,30)
end if
end event

event itemfocuschanged;if dwo.name = 'pf_fixture_cargosize'  then
	this.selecttext(1,30)
end if

end event

