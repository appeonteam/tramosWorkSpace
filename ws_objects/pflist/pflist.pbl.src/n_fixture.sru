$PBExportHeader$n_fixture.sru
forward
global type n_fixture from mt_n_nonvisualobject
end type
end forward

global type n_fixture from mt_n_nonvisualobject
end type
global n_fixture n_fixture

type variables
// int 		ii_fixed_codes[ ]={5,29,53,77}  // "Fixed" status codes for all profit centers
// int 		ii_failed_codes[ ]={7,31,55,79} // "Failed" status codes for all profit centers

constant int ii_FIXED_STATUS=104, ii_FAILED_STATUS=103, ii_CANCELED_STATUS=101, ii_RELEASED_STATUS=107, ii_DELETED_STATUS=114

end variables

forward prototypes
private subroutine documentation ()
public function boolean uf_f_status_exceptions (ref datawindow adw)
public function integer uf_f_update_position (ref datawindow adw, long al_row)
end prototypes

private subroutine documentation ();/********************************************************************
   ObjectName: n_Fixture
   <OBJECT> User functions</OBJECT>
   <DESC>Now used for exceptions when status is changed</DESC>
   <USAGE>  User functions</USAGE>
   <ALSO></ALSO>
    Date     Ref    Author       Comments
  28/04/09          AGL027     	Currently just supplying a fix for mixed up profit centers
  08/03/10		     AGL027			Removed most of code for above 'fix' and now controls the exceptions when 
  										   a statusid is changed.  2 status' covered.
										  
	1.Fixed 	- copy last cargo and charterer to position list
	2.Failed - open dialogue window w_f_confirm_status 
			 	- if fixture is an APM vessel allow user to add reason. 
			 	- ask user if he/she wants to copy fixture to cargo list.
	25/06/13	3244	 WWA048			Duplicate the features specific to profit center group Crude to Nova
	25/10/26	CR2001	KSH092		Change function uf_f_update_position,if position list window is valid, then retrieve data
********************************************************************/

end subroutine

public function boolean uf_f_status_exceptions (ref datawindow adw);/********************************************************************
  uf_f_status_exceptions( /*ref datawindow adw */)
   <DESC>All status dependent business logic for fixture/cargo lists should be here</DESC>
   <RETURN> Boolean:
            <LI> True, ok
            <LI> False, failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   adw: ancestor datawindow
   <USAGE>It uses simple arrays to loop through all status codes that may be loaded in all profit centers.
	Check the instance arrays ii_fixed_codes[] and ii_failed_codes[] for current usage.</USAGE>
********************************************************************/

int li_current_row, li_loop_counter, li_orig_status, li_null; SetNull(li_null) 
long ll_total_rows,ll_fixture_id
string ls_valid
s_status lstr_confirmstatus 


if adw.dataobject = "d_fixture_list" or adw.dataobject = "d_fixture_list_crude" or adw.dataobject = "d_fixture" then

	for li_current_row = 1 to adw.rowcount()
		if adw.GetItemStatus(li_current_row,0,Primary!)<>NotModified! then
			li_orig_status = adw.getitemnumber(li_current_row,"pf_fixture_statusid",Primary!,true)
			lstr_confirmstatus.i_statusid = adw.getitemnumber(li_current_row,"pf_fixture_statusid")
			lstr_confirmstatus.b_copytocargolist = true
			
			/*
			Status FIXED		
			*/
			if (lstr_confirmstatus.i_statusid = ii_FIXED_STATUS) and (li_orig_status <>  ii_FIXED_STATUS) then
				 if uf_f_update_position(adw,li_current_row)<0 then
					// MessageBox("Positioning Update Problem","not working. please contact Tramos development team")
				 end if
			end if
			
			/*
			Status FAILED
			*/
			if (lstr_confirmstatus.i_statusid = ii_FAILED_STATUS) and (li_orig_status <>  ii_FAILED_STATUS) then
					
				ls_valid=adw.Describe("fixtureid.ColType")
				if ls_valid<>"!" then
					lstr_confirmstatus.l_id=adw.getitemnumber(li_current_row,"fixtureid")
				else
					lstr_confirmstatus.l_id=adw.getitemnumber(li_current_row,"fixture_id")
				end if				
				
				openwithparm(w_f_confirm_status,lstr_confirmstatus)
				// load the amended values from window into the structure
				lstr_confirmstatus=message.powerobjectparm

				if not isnull(lstr_confirmstatus.i_reasoncode) and lstr_confirmstatus.i_reasoncode > 0 then adw.setitem(li_current_row,"rsnid",lstr_confirmstatus.i_reasoncode)
				if not isnull(lstr_confirmstatus.s_comment) then adw.setitem(li_current_row,"rsn_comment",lstr_confirmstatus.s_comment)
				
				if lstr_confirmstatus.b_copytocargolist=true then 
					adw.rowscopy( li_current_row, li_current_row, Primary!, adw, 1, Primary!) 
					adw.setitem(1,"isfixture",0)
					adw.setitem(1,"pf_fixture_cargoreported",today())
					adw.setitem(1,"vesselid",li_null)
					adw.setitem(1,"pf_fixture_vesselid_web",li_null)	
					adw.setitem(1,"rsnid",li_null)
					adw.setitem(1,"rsn_comment","")
				end if
				
				if lstr_confirmstatus.b_copytocargolist=true then li_current_row++
			end if
		end if
		
	next	// for li_current_row = 1 to adw.rowcount()
	
end if			

Return True

end function

public function integer uf_f_update_position (ref datawindow adw, long al_row);/********************************************************************
   uf_f_update_position( /*ref datawindow adw */)
   <DESC>Updates company detail. Exception if dataobject of adw is crude also update cargo
	</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   adw: The fixture datawindow</ARGS>
   <USAGE>  How to use this function.
	</USAGE>
	<HISTORY> 
   	Date	    CR-Ref	  Author	   Comments
  		26/06/13  CR3244    WWA048		Duplicate the features specific to profit center group Crude to Nova
   </HISTORY>
********************************************************************/
datawindowchild	ldwc
mt_n_datastore ids_position
int li_pcgroup, li_retval; li_retval=0
long ll_row_found, ll_companyid, ll_vesselid, ll_f_cargoid, ll_positionid, ll_position_row_found, ll_cargorow
string ls_cargo_1st, ls_cargo_2nd, ls_f_cargo
boolean lb_retval, lb_refreshposition


li_pcgroup = adw.getitemnumber(al_row,"pcgroup_id") 

ll_vesselid=adw.getitemnumber(al_row,"vesselid")
if isnull(ll_vesselid) then
	// no need to go further as it must be a competitor vessel...
	return li_retval
end if
ll_companyid=adw.getitemnumber(al_row,"chartererid")

//////////////////////
// Initialise object
ids_position = create mt_n_datastore
ids_position.dataobject = "d_f_update_position"
ids_position.setTransObject(sqlca)
ids_position.retrieve(li_pcgroup)

// loop through positions with matching vessel id - should be just one record.
ll_row_found = ids_position.Find("VESSELID=" + string(ll_vesselid), 1, ids_position.RowCount())
Do while ll_row_found > 0
	ids_position.setitem(ll_row_found,"companyid", ll_companyid)	
	ll_positionid=ids_position.getitemnumber(ll_row_found,"positionid")
	
	// if pc is CRUDE/NOVA we update cargo too
	if li_pcgroup = c#pcgroup.ii_CRUDE or li_pcgroup = c#pcgroup.ii_NOVA then
		// init vars
		ll_f_cargoid=adw.getitemnumber(al_row,"cargoid")
		adw.getChild("cargoid",ldwc)
		ll_cargorow= ldwc.find("cargoid=" + string(ll_f_cargoid),1,ldwc.RowCount())
		ls_f_cargo=ldwc.getitemstring(ll_cargorow,"name")
		
		ls_cargo_1st= ids_position.getitemstring(ll_row_found,"lastcargo")
		ls_cargo_2nd= ids_position.getitemstring(ll_row_found,"secondlast")
		// update cargo related fields
		if not isnull(ls_cargo_2nd) and not isnull(ls_f_cargo) then ids_position.setitem(ll_row_found,"thirdlast", ls_cargo_2nd)
		if not isnull(ls_cargo_1st) and not isnull(ls_f_cargo) then ids_position.setitem(ll_row_found,"secondlast", ls_cargo_1st)
		if not isnull(ls_f_cargo) then ids_position.setitem(ll_row_found,"lastcargo", ls_f_cargo)
	end if
	lb_refreshposition = true
//	if IsValid(w_position_list) then
//		w_position_list.post event ue_refreshonerow(ids_position.getitemnumber(ll_row_found,"positionid"))	
//	end if
	
	if ids_position.RowCount()> ll_row_found then
		ll_row_found = ids_position.Find("VESSELID=" + string(ll_vesselid), ll_row_found+1, ids_position.RowCount())
	else
		ll_row_found=0
	end if
	
	li_retval++
loop

if ids_position.Update() = 1 then
	COMMIT;
	if lb_refreshposition  and isvalid(w_position_list) then
		w_position_list.post event ue_reload(li_pcgroup)
	end if
	
else
	ROLLBACK;
	destroy ids_position
	return -1
end if

destroy ids_position

return li_retval
end function

on n_fixture.create
call super::create
end on

on n_fixture.destroy
call super::destroy
end on

