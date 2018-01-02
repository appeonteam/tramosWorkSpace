$PBExportHeader$w_vessel.srw
$PBExportComments$Maintainance of vessel coredata
forward
global type w_vessel from w_coredata_ancestor
end type
type cb_show_imovessels from commandbutton within tabpage_1
end type
type tabpage_details from userobject within tab_1
end type
type gb_1 from groupbox within tabpage_details
end type
type dw_vessel_text from mt_u_datawindow within tabpage_details
end type
type uo_vessel_att from u_fileattach within tabpage_details
end type
type tabpage_details from userobject within tab_1
gb_1 gb_1
dw_vessel_text dw_vessel_text
uo_vessel_att uo_vessel_att
end type
type tabpage_9 from userobject within tab_1
end type
type dw_details_log_desc from mt_u_datawindow within tabpage_9
end type
type dw_details_log_query from u_datagrid within tabpage_9
end type
type tabpage_9 from userobject within tab_1
dw_details_log_desc dw_details_log_desc
dw_details_log_query dw_details_log_query
end type
type tabpage_2 from userobject within tab_1
end type
type dw_brostrommt from datawindow within tabpage_2
end type
type dw_2 from mt_u_datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_brostrommt dw_brostrommt
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from u_datagrid within tabpage_3
end type
type uo_tperf from v_tperf_vessel_performance within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
uo_tperf uo_tperf
end type
type tabpage_tank from userobject within tab_1
end type
type dw_tank_list from u_datagrid within tabpage_tank
end type
type gb_2 from groupbox within tabpage_tank
end type
type dw_tank_summary from u_datagrid within tabpage_tank
end type
type tabpage_tank from userobject within tab_1
dw_tank_list dw_tank_list
gb_2 gb_2
dw_tank_summary dw_tank_summary
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_6 from userobject within tab_1
end type
type dw_6 from u_datagrid within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_6 dw_6
end type
type tabpage_7 from userobject within tab_1
end type
type cb_email from commandbutton within tabpage_7
end type
type uo_att from u_fileattach within tabpage_7
end type
type tabpage_7 from userobject within tab_1
cb_email cb_email
uo_att uo_att
end type
type tabpage_8 from userobject within tab_1
end type
type dw_81 from datawindow within tabpage_8
end type
type dw_8 from datawindow within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_81 dw_81
dw_8 dw_8
end type
type cb_modifyvesselnumber from commandbutton within w_vessel
end type
type cb_newbuildings from commandbutton within w_vessel
end type
type uo_pc from u_pc within w_vessel
end type
type st_background from u_topbar_background within w_vessel
end type
end forward

global type w_vessel from w_coredata_ancestor
integer width = 4576
integer height = 2600
string title = "Vessels"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
event ue_keydown pbm_dwnkey
event ue_pcchanged ( long al_pc,  ref integer ai_return )
cb_modifyvesselnumber cb_modifyvesselnumber
cb_newbuildings cb_newbuildings
uo_pc uo_pc
st_background st_background
end type
global w_vessel w_vessel

type variables
integer 		ii_max_no_of_tanks = 18
integer 		ii_vimsrole
n_comment 	in_comment
long			il_pcnr_array[]
long	il_pcnr

mt_n_dddw_includecurrentvalue inv_dddwincludecurrentvalue
n_messagebox inv_messagebox

boolean ib_generalchanged = false
boolean ib_financialchanged = false
boolean ib_webconfigchanged = false
boolean ib_detailschanged = false

string is_operatetype


end variables

forward prototypes
public function long uf_settankconnections ()
public function long uf_newtankconnection (double arg_from_tank_id, double arg_to_tank_id)
public function long uf_readdataset (string arg_dataset, double arg_key, ref datastore arg_datastore)
public function long uf_istankincluded (double arg_vol_reduc_factor_id, double arg_tank_id)
public function integer uf_readdataset (string arg_dataset, double arg_key, integer arg_dw_no)
public function long uf_setuptankdisplay (datawindow arg_dw, boolean arg_all_tanks, integer arg_function)
public function long uf_readdataset (string arg_dataset, double arg_key)
public function long uf_istanksconnected (double arg_from_tank_id, double arg_to_tank_id)
public function datawindow uf_getdatawindow (userobject arg_object, integer arg_dw_no)
public function datawindow uf_getdatawindow (userobject arg_object)
public function long uf_gui_control (integer arg_tabpage, string arg_command)
public subroutine uf_enabletabpages (boolean arg_enable, integer arg_first_tab, integer arg_last_tab)
public function integer uf_validategeneral ()
public function long uf_deletetankconnection (double arg_from_tank_id, double arg_to_tank_id)
public subroutine uf_updatepicklist ()
public function integer uf_deletevessel (integer al_row)
public function integer uf_deletetank (ref datawindow adw, long al_row)
public subroutine wf_retrievewebvesselconfig (integer ai_vessel_nr)
private function integer uf_validateconsumption ()
private function integer wf_validatetank ()
public function integer of_validation (datawindow adw, boolean ab_selectrow)
public subroutine documentation ()
public function integer uf_updatespending (long al_newrow)
public function dwitemstatus wf_get_cons_status (long al_row, integer ai_column, dwbuffer adb_dwbuffer)
public function integer wf_deletedetailattachments ()
private subroutine _set_permission (datawindow adw, boolean ab_log)
private function integer wf_validation_delete (integer adw_getrow)
private subroutine wf_set_accessright_detailatt ()
private subroutine wf_insert_vesseldetailhistory (datastore ds_vessel_detail_history, string as_new, string as_old, long ad_vessel_nr, datetime adt_today, string as_type)
public subroutine wf_setselectedrow (ref mt_u_datawindow adw_object, long al_selectedrow)
public subroutine wf_setselectedrow (ref mt_u_datawindow adw_object, string as_columnname, string as_value)
public subroutine wf_dwsetredraw (boolean ab_redraw)
public function integer wf_getmodifieddata ()
public function integer wf_setlistselectedvessel (boolean ab_click, long al_vesselnr)
public function integer wf_setlistselectedvessel (long al_rownumber, boolean ab_click)
public subroutine wf_resetdatachangeflag (string as_tab)
public subroutine wf_newvessel ()
end prototypes

event ue_pcchanged(long al_pc, ref integer ai_return);//Called from uo_pc.dw_pc.itemchanged()

long ll_row
long	ll_pcnr[]

if uf_updatesPending(0) = -1 then 
	cb_update.POST setFocus()
	ai_return = c#return.failure
	return
end if

il_pcnr =al_pc

IF al_pc = 999 THEN
	ll_pcnr = il_pcnr_array
ELSE	
	ll_pcnr[1] =il_pcnr
END IF

uo_SearchBox.cb_Clear.event Clicked( )

IF dw_list.retrieve(ll_pcnr) = 0 THEN
	Messagebox("Message", "No vessels to be shown.")
ELSE
	dw_list.event post Clicked(0,0,1,dw_list.object)
END IF

ai_return = c#return.success

end event

public function long uf_settankconnections ();/*long ll_rc, ll_row1, ll_row2
double ld_from_tank_id, ld_to_tank_id
dataWindow ldw_d
string ls_tank_name, ls_tankCombinations
boolean lb_dwmodified

ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab])
lb_dwmodified = ldw_d.modifiedCount() > 0

FOR ll_row1 = 1 TO ldw_d.rowCount()
	 ld_from_tank_id = ldw_d.Object.tank_id[ll_row1]
    ls_tankCombinations = ""

    ll_rc = inv_interface.resetArguments("tank_conn_ds")
    IF ll_rc <> 1 THEN
	    MessageBox(ClassName(), "inv_interface.resetArguments(tank_conn_ds) failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
       RETURN ll_rc
    END IF
		
    ll_rc = inv_interface.addArgument("tank_conn_ds", ld_from_tank_id)
    IF ll_rc <> 1 THEN
	    MessageBox(ClassName(), "inv_interface.addArgument(tank_combi_draft_stow,ll_draft_stow_id) failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
       RETURN ll_rc
    END IF
	 
    ll_rc = inv_interface.retrieve("tank_conn_ds")
    IF ll_rc <> 1 THEN
       MessageBox(ClassName(), "inv_interface.retrieve(tank_conn_ds) failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
     	 RETURN  ll_rc
    END IF
	 
	 FOR ll_row2 = 1 TO ids_tank_conn.rowCount()
        ld_to_tank_id = ids_tank_conn.Object.tank_conn_tan_tank_id[ll_row2]		
        ls_tank_name = ids_tank_conn.Object.tank_tank_name[ll_row2]
	     IF ld_from_tank_id <> ld_to_tank_id THEN
//   		  IF uf_istankconnected(ld_from_tank_id, ld_to_tank_id) THEN
// 		  		  ls_tankCombinations = ls_tankCombinations + ls_tank_name + "    " 
//           END IF
        END IF
	 NEXT
	 ldw_d.Object.tank_connections[ll_row1] = ls_tankCombinations
NEXT

IF NOT lb_dwmodified THEN
	ldw_d.resetUpdate()
END IF
*/
RETURN 1

end function

public function long uf_newtankconnection (double arg_from_tank_id, double arg_to_tank_id);long ll_row
/*
ll_row = ids_tank_conn.insertRow(0)
IF ll_row > 0 THEN
   ids_tank_conn.Object.tank_conn_tank_id[ll_row] = arg_from_tank_id
	ids_tank_conn.Object.tank_conn_tan_tank_id[ll_row] = arg_to_tank_id
	RETURN 1
END IF

RETURN ll_row*/
return 1

end function

public function long uf_readdataset (string arg_dataset, double arg_key, ref datastore arg_datastore);long ll_rc
/*
IF arg_datastore.rowCount() > 0 THEN
	RETURN 1
END IF

//Register dataset 
ll_rc = inv_interface.registerDataset(arg_dataset, arg_dataset, "datagroup", arg_datastore, inv_interface.RETRIEVE_FULLONNEED)
//IF ll_rc <> 1 the dataset has already been registered but contains no rows!
//if ll_rc <> 1 then
//	MessageBox(this.ClassName(), &
//	   "inv_interface.registerDataset(" + arg_dataset + ") failed!~r~n~r~n" + &
//		 inv_interface.getLastError() + "~r~nRC=" + String(ll_rc))
//   return ll_rc
//end if

ll_rc = inv_interface.resetArguments(arg_dataset)
IF ll_rc <> 1 THEN
   MessageBox(ClassName(), "inv_interface.resetArguments(" + arg_dataset + ") failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
   RETURN ll_rc
END IF

ll_rc = inv_interface.addArgument(arg_dataset, arg_key)
IF ll_rc <> 1 THEN
   MessageBox(ClassName(), "inv_interface.addArgument(" + arg_dataset + ",arg_key) failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
   RETURN ll_rc
END IF

ll_rc = inv_interface.retrieve(arg_dataset)
IF ll_rc <> 1 THEN
   MessageBox(ClassName(), "inv_interface.retrieve(" + arg_dataset + ") failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
   RETURN ll_rc
END IF
*/
RETURN 1
end function

public function long uf_istankincluded (double arg_vol_reduc_factor_id, double arg_tank_id);long ll_row, ll_rowCount
string ls_search
/*
ll_rowCount = ids_tank_combi_vol_reduc_fa.rowCount()

ls_search = "tank_combi_vol_reduc_fa_tank_id ="+string(arg_tank_id) + &
				" and tank_combi_vol_reduc_fa_vol_reduc_factor_act_id ="+string(arg_vol_reduc_factor_id)

ll_row = ids_tank_combi_vol_reduc_fa.Find(ls_search, 1, ll_rowCount )
IF ll_row > 0 THEN
	RETURN 1
ELSE
	RETURN 0
END IF
*/
return 1
end function

public function integer uf_readdataset (string arg_dataset, double arg_key, integer arg_dw_no);long ll_rc, ll_tabpage
dataWindow ldw_d
/*
ll_tabpage = tab_1.selectedtab
IF ll_tabpage = 2 THEN
	ll_tabpage = 1
END IF

ldw_d = uf_getDataWindow(tab_1.Control[ll_tabpage], arg_dw_no)

IF ldw_d.rowCount() > 0 THEN
	RETURN 1
END IF

//Register dataset 
ll_rc = inv_interface.registerDataset(arg_dataset, arg_dataset, "datagroup", ldw_d, inv_interface.RETRIEVE_FULLONNEED)
//IF ll_rc <> 1 the dataset has already been registered but contains no rows!
//if ll_rc <> 1 then
//	MessageBox(this.ClassName(), &
//	   "inv_interface.registerDataset(" + arg_dataset + ") failed!~r~n~r~n" + &
//		 inv_interface.getLastError() + "~r~nRC=" + String(ll_rc))
//   return ll_rc
//end if
//
ll_rc = inv_interface.resetArguments(arg_dataset)
IF ll_rc <> 1 THEN
   MessageBox(ClassName(), "inv_interface.resetArguments(" + arg_dataset + ") failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
   RETURN ll_rc
END IF

ll_rc = inv_interface.addArgument(arg_dataset, arg_key)
IF ll_rc <> 1 THEN
   MessageBox(ClassName(), "inv_interface.addArgument(" + arg_dataset + ",arg_key) failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
   RETURN ll_rc
END IF

ll_rc = inv_interface.retrieve(arg_dataset)
IF ll_rc <> 1 THEN
   MessageBox(ClassName(), "inv_interface.retrieve(" + arg_dataset + ") failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
   RETURN ll_rc
ELSE
   ldw_d.setRedraw(TRUE)	
END IF

CHOOSE CASE arg_dataset
	CASE "volume_reduction"
//   	inv_interface.setupdatesendtype("volume_reduction", inv_interface.update_sendall)
	CASE "vessel_decktank"
//   	inv_interface.setupdatesendtype("vessel_decktank", inv_interface.update_sendall)		
END CHOOSE

IF ll_tabpage = 1 THEN
	ll_rc = tab_1.tabpage_1.dw_1.shareData(tab_1.tabpage_2.dw_2)
END IF
*/
RETURN 1
end function

public function long uf_setuptankdisplay (datawindow arg_dw, boolean arg_all_tanks, integer arg_function);long ll_rc, ll_row1, ll_row2, ll_rowCount1, ll_rowCount2, ll_columnIndex
double ld_from_tank_id, ld_to_tank_id
string ls_tank_name, ls_tank_id, ls_tank_selected
boolean lb_dwModified
/*
lb_dwModified = FALSE

//arg_dw.setRedraw(FALSE)
ll_rowCount1 = arg_dw.rowCount()
ll_rowCount2 = ids_tank.rowCount()

in_tank_parms.setUpperBound(ll_rowCount2)

//setup tank names
CHOOSE CASE arg_function
	CASE 2, 3, 4
		FOR ll_row2 = 1 TO ll_rowCount2
		   ls_tank_name = "tn_" + string(ll_row2)	
			arg_dw.Modify(ls_tank_name + ".text = '"+ids_tank.Object.tank_name[ll_row2]+"'")
		NEXT
END CHOOSE

FOR ll_row1 = 1 TO ll_rowCount1
	IF arg_dw.getItemStatus(ll_row1, 0, Primary!) = New! THEN
		lb_dwModified = TRUE
	END IF
	ld_from_tank_id = arg_dw.Object.tank_id[ll_row1]
	ll_columnIndex = 0
	FOR ll_row2 = 1 TO ll_rowCount2
		IF arg_all_tanks OR arg_dw.Object.tank_id[ll_row1] <> ids_tank.Object.tank_id[ll_row2] THEN
			ld_to_tank_id = ids_tank.Object.tank_id[ll_row2]
			ll_columnIndex++
		   ls_tank_id       = "ti_" + string(ll_columnIndex)
		   ls_tank_selected = "ts_" + string(ll_columnIndex)
		   ll_rc = arg_dw.setItem(ll_row1, ls_tank_id,       ids_tank.Object.tank_id[ll_row2])
			IF arg_function = 1 THEN
				ls_tank_name     = "tn_" + string(ll_columnIndex)				
			   ll_rc = arg_dw.setItem(ll_row1, ls_tank_name,       ids_tank.Object.tank_name[ll_row2])				
			END IF
			choose case arg_function
            case 1 //Tank connections
   		     ll_rc = arg_dw.setItem(ll_row1, ls_tank_selected, uf_isTanksConnected(ld_from_tank_id, ld_to_tank_id))	
			   case 2 //Volume reduction
   		     ll_rc = arg_dw.setItem(ll_row1, ls_tank_selected, uf_isTankIncluded(arg_dw.Object.vol_reduc_factor_act_vol_reduc_factor_act_id[ll_row1], ld_to_tank_id))					
			   case 3 //Draft Stowage
              ll_rc = arg_dw.setItem(ll_row1, ls_tank_selected, uf_getLoadingPct(arg_dw.Object.draft_stow_combi_draft_stow_id[ll_row1], ld_to_tank_id))											
				  ids_tank_combi_draft_stow.resetUpdate()
   			case 4 //New Volume reduction
				  IF ll_row1 = ll_rowCount1 THEN
   		        ll_rc = arg_dw.setItem(ll_row1, ls_tank_selected, 0)															
				  END IF
    		end choose
         //Set-up n_tank_parms for the search facility in Draft/Stowage
		   IF ll_row1 = 1 Then 
		      in_tank_parms.setTank_name(String(ids_tank.Object.tank_name[ll_row2]), ll_row2)
         END IF		
      END IF
	NEXT
NEXT

IF NOT lb_dwModified THEN
   arg_dw.resetUpdate()
END IF
//arg_dw.setRedraw(TRUE)
*/		
RETURN 1	

end function

public function long uf_readdataset (string arg_dataset, double arg_key);long ll_rc, ll_tabpage
dataWindow ldw_d
/*
ll_tabpage = tab_1.selectedtab
IF ll_tabpage = 2 THEN
	ll_tabpage = 1
END IF

ldw_d = uf_getDataWindow(tab_1.Control[ll_tabpage])

IF ldw_d.rowCount() > 0 THEN
	RETURN 1
END IF

//Register dataset 
ll_rc = inv_interface.registerDataset(arg_dataset, arg_dataset, "datagroup", ldw_d, inv_interface.RETRIEVE_FULLONNEED)
//IF ll_rc <> 1 the dataset has already been registered but contains no rows!
//if ll_rc <> 1 then
//	MessageBox(this.ClassName(), &
//	   "inv_interface.registerDataset(" + arg_dataset + ") failed!~r~n~r~n" + &
//		 inv_interface.getLastError() + "~r~nRC=" + String(ll_rc))
//   return ll_rc
//end if
//
ll_rc = inv_interface.resetArguments(arg_dataset)
IF ll_rc <> 1 THEN
   MessageBox(ClassName(), "inv_interface.resetArguments(" + arg_dataset + ") failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
   RETURN ll_rc
END IF

ll_rc = inv_interface.addArgument(arg_dataset, arg_key)
IF ll_rc <> 1 THEN
   MessageBox(ClassName(), "inv_interface.addArgument(" + arg_dataset + ",arg_key) failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
   RETURN ll_rc
END IF

ll_rc = inv_interface.retrieve(arg_dataset)
IF ll_rc <> 1 THEN
   MessageBox(ClassName(), "inv_interface.retrieve(" + arg_dataset + ") failed ~r~n~r~n"+inv_interface.getLastError()+"~r~nRC="+string(ll_rc))
   RETURN ll_rc
ELSE
   ldw_d.setRedraw(TRUE)	
END IF

CHOOSE CASE arg_dataset
	CASE "vessel_consumption"
		inv_interface.setupdatesendtype("vessel_consumption", inv_interface.update_sendall)
	CASE "vessel_decktank"
//		inv_interface.setupdatesendtype("vessel_decktank", inv_interface.update_sendall)
	CASE "volume_reduction"
//   	inv_interface.setupdatesendtype("volume_reduction", inv_interface.update_sendall)
	CASE "vessel_decktank"
//   	inv_interface.setupdatesendtype("vessel_decktank", inv_interface.update_sendall)		
END CHOOSE

IF ll_tabpage = 1 THEN
	ll_rc = tab_1.tabpage_1.dw_1.shareData(tab_1.tabpage_2.dw_2)
END IF
*/
RETURN 1
end function

public function long uf_istanksconnected (double arg_from_tank_id, double arg_to_tank_id);long ll_row, ll_rowCount
string ls_search
/*
ll_rowCount = ids_tank_conn.rowCount()

ls_search = "tank_conn_tank_id ="+string(arg_from_tank_id) + &
				" and tank_conn_tan_tank_id ="+string(arg_to_tank_id)

ll_row = ids_tank_conn.Find(ls_search, 1, ll_rowCount )
IF ll_row > 0 THEN
	RETURN 1
ELSE
	RETURN 0
END IF
*/
return 1
end function

public function datawindow uf_getdatawindow (userobject arg_object, integer arg_dw_no);DataWindow ldw_result
long ll_index

FOR ll_index = 1 TO upperBound(arg_object.control)
   IF arg_object.control[ll_index].typeOf() = DataWindow! THEN
		ldw_result = arg_object.control[ll_index]
		If ldw_result.tag = string(arg_dw_no) Then
			Return ldw_result
		End if
   END IF
NEXT

RETURN ldw_result

end function

public function datawindow uf_getdatawindow (userobject arg_object);DataWindow ldw_result
long ll_index

FOR ll_index = 1 TO upperBound(arg_object.control)
   IF arg_object.control[ll_index].typeOf() = DataWindow! THEN
		ldw_result = arg_object.control[ll_index]
		RETURN ldw_result
   END IF
NEXT

RETURN ldw_result

end function

public function long uf_gui_control (integer arg_tabpage, string arg_command);DataWindow ldw_d
long ll_rc

Choose case arg_tabpage
	Case 1, 2, 4, 10
		Choose case arg_command
			Case "New"
				   uf_enableTabPages(FALSE, 5, 9)
					uf_enableTabpages(False,2,3)
					//tab_1.tabpage_1.dw_1.modify("b_veo.enabled = false")
			Case "Delete"
			Case "Update"
			Case "Cancel"
               uf_enableTabPages(TRUE, 5, 9)
					uf_enableTabpages(True,2,3)
					//tab_1.tabpage_1.dw_1.modify("b_veo.enabled = true")
			Case "Tab"
		End choose
End choose

Return 1

end function

public subroutine uf_enabletabpages (boolean arg_enable, integer arg_first_tab, integer arg_last_tab);long ll_index

FOR ll_index = arg_first_tab TO arg_last_tab
	   tab_1.Control[ll_index].enabled = arg_enable
NEXT


end subroutine

public function integer uf_validategeneral ();decimal 				lc_drc, lc_tc, lc_cap, lc_sdwt
string 				ls_ref_nr, ls_name, ls_vessel_name, ls_msgtip
long					ll_found, ll_Disp, ll_pcnr, ll_vesselnr, ll_imo_number
datawindowchild	ldwc
boolean				lb_nonMThandled=false

tab_1.tabpage_1.dw_1.Accepttext()
tab_1.tabpage_details.dw_vessel_text.accepttext()
tab_1.tabpage_2.dw_2.Accepttext()

tab_1.tabpage_2.dw_brostrommt.accepttext( )

ls_ref_nr = tab_1.tabpage_1.dw_1.getitemstring(1, "vessel_ref_nr")
if (len(ls_ref_nr) <> 3) or isnull(ls_ref_nr) then
	MessageBox("Error","Vessel number must be exactly 3 characters")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("vessel_ref_nr")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

If tab_1.tabpage_1.dw_1.getitemStatus( 1, 0, primary!) = newModified! then
	ls_ref_nr = Upper(Trim(tab_1.tabpage_1.dw_1.getitemstring(1, "vessel_ref_nr"), True))
	Select Count(*) Into :ll_Found from VESSELS Where VESSEL_REF_NR=:ls_ref_nr;

	if ll_found > 0 then 
		MessageBox("Duplicate Vessel","A vessel with this number already exists.")
		tab_1.post selectTab(1)
		tab_1.tabpage_1.dw_1.post setColumn("vessel_ref_nr")
		tab_1.tabpage_1.dw_1.post setFocus()
		Return -1
	end if
End if

//CR2707 - Add a restriction that apostrophe is not allowed to be used in Vessel name.
ls_vessel_name = tab_1.tabpage_1.dw_1.getitemstring(1, "vessel_name")
if isnull(ls_vessel_name) or ls_vessel_name = "" then
	ls_msgtip = "You must enter a vessel name."
elseif pos(ls_vessel_name, "'") > 0 then
	ls_msgtip = "Vessel name can't include apostrophe character."
end if
if len(ls_msgtip) > 0 then
	messagebox("Error", ls_msgtip)
	tab_1.post selecttab(1)
	tab_1.tabpage_1.dw_1.post setcolumn("vessel_name")
	tab_1.tabpage_1.dw_1.post setfocus()
	return -1
end if

// CR 2527 Start - CONASW 2/8/11 - Prevent vessel with same name as another
ls_name=""
// In case of new vessel
if tab_1.tabpage_1.dw_1.getitemStatus( 1, 0, primary!) = newModified! then
	ls_Name = Upper(Trim(tab_1.tabpage_1.dw_1.getitemstring(1, "vessel_name"), True))
	Select VESSEL_REF_NR + ' - ' + VESSEL_NAME Into :ls_Name from VESSELS Where Upper(VESSEL_NAME)=:ls_Name;
	
	If SQLCA.SQLCode=100 then ls_Name=""

end if
// In case of changing vessel name
if tab_1.tabpage_1.dw_1.getitemstatus(1, "vessel_name", primary!) = DataModified! then
	ls_Name = Upper(Trim(tab_1.tabpage_1.dw_1.getitemstring(1, "vessel_name"), True))
	ll_vesselnr = tab_1.tabpage_1.dw_1.getitemnumber(1, "vessel_nr")
	Select VESSEL_REF_NR + ' - ' + VESSEL_NAME Into :ls_Name from VESSELS Where Upper(VESSEL_NAME)=:ls_Name and VESSEL_NR<>:ll_vesselnr;
	
	If SQLCA.SQLCode=100 then ls_Name=""
	
end if
if ls_Name > "" Then
	MessageBox("Duplicate Vessel","Another vessel with the same name already exists (" + ls_Name + ").~n~nPlease rename the other vessel first or use another name.")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("vessel_name")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

// CR 2527 End

if isnull(tab_1.tabpage_1.dw_1.object.vessel_operator[1]) then
	MessageBox("Error","You must enter a responsible operator")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("vessel_operator")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

if isnull(tab_1.tabpage_1.dw_1.object.vessel_fin_resp[1]) then
	MessageBox("Error","You must enter a vessel finance responsible")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("vessel_fin_resp")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

if isnull(tab_1.tabpage_1.dw_1.object.vessel_dem_analyst[1]) then
	MessageBox("Error","You must enter a vessel demurrage analyst")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("vessel_dem_analyst")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

if isnull(tab_1.tabpage_1.dw_1.object.cal_vest_type_id[1]) then
	MessageBox("Error","You must enter a Ship Type")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("cal_vest_type_id")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

//CR20 vessel communication
ll_imo_number = tab_1.tabpage_1.dw_1.getitemnumber(1, "imo_number")
if  isnull(ll_imo_number) or len(string(ll_imo_number)) < 7 then
	MessageBox("Error","You must enter at least a 7 digits vessel IMO number.")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("imo_number")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

if isnull(tab_1.tabpage_2.dw_2.object.pc_nr[1]) then
	MessageBox("Error","You must select a Profitcenter")
	tab_1.post selectTab(4)
	tab_1.tabpage_2.dw_2.post setColumn("pc_nr")
	tab_1.tabpage_2.dw_2.post setFocus()
	Return -1
end if

// If Crew and/or T.O. managed by CPH is set = true
// check if profitcenter is marked as "Non-MT Commercially handled"
// in this case it is not allowed to turn it on
if tab_1.tabpage_2.dw_2.object.cph_crew_managed[1] = 1 &
or tab_1.tabpage_2.dw_2.object.cph_to_managed[1] = 1 then
	ll_pcnr = tab_1.tabpage_2.dw_2.object.pc_nr[1]
	SELECT NON_APM_COMM_HANDLED
	INTO :lb_nonMThandled
	FROM PROFIT_C
	WHERE PC_NR = :ll_pcnr;

	if lb_nonMThandled then
		MessageBox("Error","You are not allowed to turn on 'Crew and/or T.O. managed by Copenhagen' ~r~n when the Profitcenter is marked as 'Non-MT Commercially handled'")
		tab_1.post selectTab(4)
		tab_1.tabpage_2.dw_2.post setColumn("cph_crew_managed")
		tab_1.tabpage_2.dw_2.post setFocus()
		Return -1
	end if
end if

//Check Profitcenter against IOM/SIN or Brostr?m/MT setup
if tab_1.tabpage_2.dw_2.getItemStatus(1,"pc_nr", primary!) = dataModified! then
	if tab_1.tabpage_2.dw_2.getChild( "pc_nr", ldwc ) = 1 then
		ll_found = ldwc.find( "pc_nr="+string(tab_1.tabpage_2.dw_2.object.pc_nr[1]), 1, 999)
		if ll_found > 0 then 
			if ldwc.getItemNumber(ll_found, "non_apm_comm_handled") = 1 then
				// do nothing
			else
				if tab_1.tabpage_2.dw_brostrommt.rowCount() > 0 then
					MessageBox("Error", "The selected Profit center does not allow the Brostr?m/MT vessel setup.~r~n~r~nPlease delete vessel from setup before switching Profit center")
					return -1
				end if
			end if
		else
			MessageBox("Error", "Can't get child datawindow behind Profit Center. Please contact Administrator")
			return -1
		end if
	else
		MessageBox("Error", "Can't get child datawindow behind Profit Center. Please contact Administrator")
		return -1
	end if
end if

if isnull(tab_1.tabpage_2.dw_2.object.vessel_tc_index[1]) then
	MessageBox("Error","You must enter a TC Index")
	tab_1.post selectTab(4)
	tab_1.tabpage_2.dw_2.post setColumn("vessel_tc_index")
	tab_1.tabpage_2.dw_2.post setFocus()
	Return -1
end if
	
lc_drc = tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_drc")
if isNull(lc_drc) then lc_drc = 0
lc_tc = tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_tc")
if isNull(lc_tc) then lc_tc = 0
lc_cap = tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_cap")
if isNull(lc_cap) then lc_cap = 0

If ((lc_drc <> 0 ) Or (lc_cap <> 0)) And (lc_tc <> 0 ) Then
	MessageBox("Error","It's only possible to have either a DRC and/or CAP, or a T/C rate (day)")
	tab_1.post selectTab(4)
	tab_1.tabpage_2.dw_2.post setColumn("cal_drc")
	tab_1.tabpage_2.dw_2.post setFocus()
	Return -1
End If

lc_sdwt = tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_sdwt")
If lc_sdwt > 999999.99 Then
	MessageBox("Notice","SDWT must be below one million")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("cal_sdwt")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
End If

// Check displacements
ll_Disp = tab_1.tabpage_1.dw_1.GetItemNumber(1,"summer_disp_ldd")
If Not IsNull(ll_Disp) then
	If ll_Disp < 1000 then
		tab_1.post selectTab(1)
		tab_1.tabpage_1.dw_1.post setColumn("summer_disp_ldd")
		tab_1.tabpage_1.dw_1.post setFocus()		
		MessageBox("Notice","Loaded Displacement is invalid")
		Return -1	
	Else
		If IsNull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"summer_disp_bll")) then
			tab_1.tabpage_1.dw_1.post setColumn("summer_disp_bll")
			tab_1.tabpage_1.dw_1.post setFocus()					
			MessageBox("Notice","Both Loaded and Ballast displacements must be specified or none at all.")
			Return -1				
		End If
	End If
End If
ll_Disp = tab_1.tabpage_1.dw_1.GetItemNumber(1,"summer_disp_bll")
If Not IsNull(ll_Disp) then
	If ll_Disp < 1000 then
		tab_1.post selectTab(1)
		tab_1.tabpage_1.dw_1.post setColumn("summer_disp_bll")
		tab_1.tabpage_1.dw_1.post setFocus()		
		MessageBox("Notice","Ballast Displacement is invalid")
		Return -1	
	Else
		If IsNull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"summer_disp_ldd")) then
			tab_1.tabpage_1.dw_1.post setColumn("summer_disp_ldd")
			tab_1.tabpage_1.dw_1.post setFocus()					
			MessageBox("Notice","Both Loaded and Ballast displacements must be specified or none at all.")
			Return -1				
		End If		
	End If
End If

// Validate Dem Bank Account
if isNull(tab_1.tabpage_2.dw_2.getItemString(1,"apm_account_nr")) or len(tab_1.tabpage_2.dw_2.getItemString(1, "apm_account_nr")) < 1 then
	MessageBox("Information","Please ask the finance/administrator to update 'Demurrage Bank Account' for selected vessel")
end if


// Validate Brostrom / MT CODA Postings
if tab_1.tabpage_2.dw_brostrommt.rowcount() > 0 then
	if isNull(tab_1.tabpage_2.dw_brostrommt.getItemString(1, "coda_el3_crew")) &
	or isNull(tab_1.tabpage_2.dw_brostrommt.getItemString(1, "coda_el4_crew")) &
	or isNull(tab_1.tabpage_2.dw_brostrommt.getItemString(1, "coda_el3_to")) &
	or isNull(tab_1.tabpage_2.dw_brostrommt.getItemString(1, "coda_el4_to")) then
		messageBox("Information", "Please fill in Brostr?m/MT CODA elements")
		return -1
	end if
end if

return 1
end function

public function long uf_deletetankconnection (double arg_from_tank_id, double arg_to_tank_id);long ll_rc, ll_row, ll_rowCount
/*
ll_rowCount = ids_tank_conn.rowCount()
FOR ll_row = 1 TO ll_rowCount
	IF ids_tank_conn.Object.tank_conn_tank_id[ll_row] = arg_from_tank_id AND &
	   ids_tank_conn.Object.tank_conn_tan_tank_id[ll_row] = arg_to_tank_id THEN
		ll_rc = ids_tank_conn.deleteRow(ll_row)
		RETURN ll_rc
	END IF
NEXT
*/
RETURN 0
end function

public subroutine uf_updatepicklist ();integer li_vessel_nr
long ll_row, ll_rc, ll_pc_row, ll_min, ll_max
string ls_find_vessel_nr
long ll_pcnr[]

ll_row = dw_list.getSelectedRow(0)
if tab_1.tabpage_1.dw_1.rowCount() > 0 then
	li_vessel_nr = tab_1.tabpage_1.dw_1.GetItemNumber(tab_1.tabpage_1.dw_1.getRow(), "vessel_nr")
else
	setNull(li_vessel_nr)
end if

IF (tab_1.SelectedTab = 1 OR tab_1.SelectedTab = 2 OR tab_1.SelectedTab = 4 or tab_1.SelectedTab = 10) THEN
	//pc_nr = 999 - All profit centers
	IF il_pcnr = 999 THEN
		ll_min = -9999
		ll_max = 9999
		dw_list.retrieve(il_pcnr_array)
	ELSE			
		ll_min = uo_pc.of_getpc( )
		ll_max = ll_min
		ll_pcnr[1] = ll_min 
		dw_list.retrieve(ll_pcnr)	
	END IF

	IF tab_1.tabpage_1.dw_1.rowCount() > 0 THEN  //new or modified
	   tab_1.tabpage_1.dw_1.accepttext()
		tab_1.tabpage_details.dw_vessel_text.accepttext()
	   tab_1.tabpage_2.dw_2.accepttext()
	   ls_find_vessel_nr = "vessel_nr = " + string(li_vessel_nr)
	   ll_row = dw_list.Find(ls_find_vessel_nr, 1, dw_list.rowCount() )
	END IF
END IF

// Triggers the Clicked-event of dw_list with the selected row
if ll_row>0 and  ll_row <= dw_list.rowCount() then
	dw_list.EVENT Clicked(0, 0, ll_row, dw_list.object)
end if

//Scroll to the selected row
ll_row = dw_list.getRow()
if ll_row > 0 then
	IF NOT isNull(li_vessel_nr) THEN
		ls_find_vessel_nr = "vessel_nr = " + string(li_vessel_nr)
		ll_row = dw_list.Find(ls_find_vessel_nr, 1, dw_list.rowCount() ) 
	END IF
	dw_list.scrollToRow(ll_row)
end if

//enable all tabpages
uf_enableTabPages(TRUE, 5, 9)
uf_enableTabPages(TRUE,2,3)


//Enable VEO button
//tab_1.tabpage_1.dw_1.modify("b_veo.enabled = true")


end subroutine

public function integer uf_deletevessel (integer al_row);integer li_vessel_nr

li_vessel_nr = dw_list.getItemNumber(al_row, "vessel_nr")

DELETE FROM TANK  
	WHERE TANK.VESSEL_NR = :li_vessel_nr  ;
if sqlca.sqlcode <> 0 then return -1

DELETE FROM CAL_CONS  
	WHERE CAL_CONS.VESSEL_NR = :li_vessel_nr  ;
if sqlca.sqlcode <> 0 then return -1
	
DELETE FROM VSL_CNSTR  
	WHERE VSL_CNSTR.VESSEL_NR = :li_vessel_nr ;
if sqlca.sqlcode <> 0 then return -1

DELETE FROM FIN_RESP_HISTORY  
	WHERE FIN_RESP_HISTORY.VESSEL_NR = :li_vessel_nr ;
if sqlca.sqlcode <> 0 then return -1

DELETE FROM VESSELS_LOG  
	WHERE VESSELS_LOG.VESSEL_NR = :li_vessel_nr ;
if sqlca.sqlcode <> 0 then return -1
	
DELETE FROM VESSEL_CERT 
	WHERE VESSEL_CERT.VESSEL_NR = :li_vessel_nr ;
if sqlca.sqlcode <> 0 then return -1

DELETE FROM VESSELS_WEB 
	WHERE VESSELS_WEB.VESSEL_NR = :li_vessel_nr ;
if sqlca.sqlcode <> 0 then return -1

DELETE FROM VESSELS_DETAIL_HISTORY
	WHERE VESSELS_DETAIL_HISTORY.VESSEL_NR = :li_vessel_nr;
if sqlca.sqlcode <> 0 then return -1

return 1
end function

public function integer uf_deletetank (ref datawindow adw, long al_row);double ld_tankID

ld_tankID = adw.getItemNumber(al_row, "tank_id")

return 1
end function

public subroutine wf_retrievewebvesselconfig (integer ai_vessel_nr);tab_1.tabpage_8.dw_81.Retrieve(ai_vessel_nr) 

if tab_1.tabpage_8.dw_81.rowcount()=0 then
	 tab_1.tabpage_8.dw_81.insertrow( 0)
end if

//vessel certificates
tab_1.tabpage_7.cb_email.enabled = true

tab_1.tabpage_7.uo_att.of_init(ai_vessel_nr)

		  
if uo_global.ii_access_level >= 0 then
	 tab_1.tabpage_7.uo_att.dw_file_listing.Object.DataWindow.ReadOnly="No"
	 if tab_1.tabpage_7.uo_att.dw_file_listing.rowcount( ) = 0 then
		 tab_1.tabpage_7.cb_email.enabled = false
	end if
else
	 tab_1.tabpage_7.uo_att.dw_file_listing.Object.DataWindow.ReadOnly="Yes"
	  tab_1.tabpage_7.cb_email.enabled = false
end if
end subroutine

private function integer uf_validateconsumption ();/********************************************************************
   uf_validateconsumption
   <DESC> validate consumption</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	18/11/2013 CR2658       LGX001       1. Restruct the source code
														 2. call n_service_manager
   	25/03/16	  CR4157       LHG008       Default Speed extended(Consumption type-zone-speed must be unique)
   </HISTORY>
********************************************************************/

long ll_rowcount, ll_found, ll_row, ll_constype, ll_zone_id
decimal ld_speed

n_service_manager          lnv_svcmgr
n_dw_validation_service    lnv_rules

ll_rowcount = tab_1.tabpage_3.dw_3.rowcount( )
ll_found = 1

//remove any empty records
ll_found =  tab_1.tabpage_3.dw_3.find("isRowNew()", ll_found, ll_rowcount + 1)
do while ll_found > 0 
	if tab_1.tabpage_3.dw_3.getItemStatus(ll_found, 0, primary!) = New! then tab_1.tabpage_3.dw_3.deleterow(ll_found) else ll_found ++
	ll_found =  tab_1.tabpage_3.dw_3.find("isRowNew()", ll_found, ll_rowcount + 1)
loop

//Consumption type-zone-speed must be unique
if tab_1.tabpage_3.dw_3.modifiedcount() + tab_1.tabpage_3.dw_3.deletedcount() > 0 then
	for ll_row = 1 to ll_rowcount - 1
		ll_constype = tab_1.tabpage_3.dw_3.getitemnumber(ll_row, "cal_cons_type")
		ll_zone_id = tab_1.tabpage_3.dw_3.getitemnumber(ll_row, "zone_id")
		ld_speed = tab_1.tabpage_3.dw_3.getitemnumber(ll_row, "cal_cons_speed")
		ll_found = tab_1.tabpage_3.dw_3.find("cal_cons_type = " + string(ll_constype) + " and zone_id = " + string(ll_zone_id) + " and cal_cons_speed = " + string(ld_speed), ll_row + 1, ll_rowcount) 
		if ll_found > 0 then
			tab_1.selecttab(tab_1.tabpage_3)
			tab_1.tabpage_3.dw_3.setrow(ll_row)
			tab_1.tabpage_3.dw_3.post setfocus()
			messagebox("Validation Error", "You cannot enter duplicate consumptions with the same consumption type, zone and speed.", StopSign!)
			return c#return.Failure
		end if
	next
end if

//register all columns requiring validation
lnv_svcmgr.of_loadservice(lnv_rules, "n_dw_validation_service")
lnv_rules.of_registerruledecimal("cal_cons_type", true, "consumption type")
lnv_rules.of_registerruledecimal("zone_id", true, "zone")
if lnv_rules.of_validate(tab_1.tabpage_3.dw_3, true) = c#return.Failure then return c#return.Failure

ll_rowcount = tab_1.tabpage_3.dw_3.rowcount( )
//Sailing-Laden and Sailing-Ballast and Sailing Idle and Sailing-Heating
ll_found = tab_1.tabpage_3.dw_3.find("cal_cons_type in (1, 2, 9, 10) and (isnull(cal_cons_speed) or cal_cons_speed <= 0)", 1, ll_rowcount) 
if ll_found > 0 then
	_addmessage(this.classdefinition, "uf_validateconsumption()", "Speed for Sailing Laden/Sailing Ballast/Sailing Idle/Sailing Heating must be greater than 0.", "")
	tab_1.post selecttab(tab_1.tabpage_3)
	tab_1.tabpage_3.dw_3.post setrow(ll_found)
	tab_1.tabpage_3.dw_3.post setcolumn("cal_cons_speed")
	tab_1.tabpage_3.dw_3.post setfocus()
	return c#return.Failure
end if

return c#return.Success
end function

private function integer wf_validatetank ();/********************************************************************
   wf_validatetank
   <DESC> validate tank</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	25/07/16	  CR4667       EPE080       First version
   </HISTORY>
********************************************************************/

long ll_return, ll_errorrow, ll_row
integer li_errorcolumn
string  ls_message, ls_columnname, ls_columnlabel
n_dw_validation_service lnv_validation
n_service_manager lnv_servicemgr

//remove any empty records
for ll_row = tab_1.tabpage_tank.dw_tank_list.rowCount() to 1 step -1
	if tab_1.tabpage_tank.dw_tank_list.getitemstatus(ll_row, 0, Primary!) = new! then
		tab_1.tabpage_tank.dw_tank_list.rowsdiscard( ll_row, ll_row, Primary!)
	end if
next

lnv_servicemgr.of_loadservice(lnv_validation, "n_dw_validation_service")

lnv_validation.of_registerrulestring('tank_name',true,'Tank Name',true)
lnv_validation.of_registerrulestring('segregation',true,'Segregation',false)
lnv_validation.of_registerruledecimal("filling_limit", true, 0, 100, "Filling Limit %")
lnv_validation.of_registerruledecimal("tank_cap", true, "CBM Capacity")

ll_return = lnv_validation.of_validate(tab_1.tabpage_tank.dw_tank_list, ls_message, ll_errorrow, li_errorcolumn)
if ll_return = C#Return.Failure then
	tab_1.tabpage_tank.dw_tank_list.setfocus()
	tab_1.tabpage_tank.dw_tank_list.setrow(ll_errorrow)
	tab_1.tabpage_tank.dw_tank_list.setcolumn(li_errorcolumn)
	ls_columnname = tab_1.tabpage_tank.dw_tank_list.getcolumnname()
	ls_columnlabel = tab_1.tabpage_tank.dw_tank_list.describe(ls_columnname+'_t.text')
	choose case ls_columnname
		case 'tank_name'
			if len(tab_1.tabpage_tank.dw_tank_list.getitemstring(ll_errorrow,ls_columnname)) > 0 then
				ls_message = 'This ' + ls_columnlabel + ' already exists, you must change the tank layout.'
			else
				ls_message = 'You must enter a ' + ls_columnlabel + '.'
			end if
		case 'segregation'
			ls_message = 'You must enter a ' + ls_columnlabel + '.'
		case 'filling_limit'
			if isnull(tab_1.tabpage_tank.dw_tank_list.getitemnumber(ll_errorrow,ls_columnname)) then
				ls_message = 'You must enter a ' + ls_columnlabel + '.'
			else
				ls_message = 'You can only enter a ' + ls_columnlabel + ' which is from 0.01 to 100.00.'
			end if	
		case 'tank_cap'
			if isnull(tab_1.tabpage_tank.dw_tank_list.getitemnumber(ll_errorrow,ls_columnname)) then
				ls_message = 'You must enter a ' + ls_columnlabel + '.'
			else
				ls_message = 'You can only enter values greater than 0.'
			end if	
	end choose
		
	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, ls_message, this)

	return c#return.Failure
end if

return c#return.Success


end function

public function integer of_validation (datawindow adw, boolean ab_selectrow);/********************************************************************
   of_validation( /*datawindow adw */,/*boolean ab_selectrow */)
   <DESC>     This function is to validate if the description and expired date for the certificates are correct
   </DESC>
   <RETURN> Integer:	<LI> 1, X ok<LI> -1, X failed									</RETURN>
   <ACCESS> Public																				</ACCESS>
   <ARGS>    adw: reference to the datawindow
				  ab_selectrow: if the row need to be selected. <LI> true, selected, for the list<LI> false, not selected, for the small window
   </ARGS>
   <USAGE>  Called from the Update function of this object and the update button of the small window
   </USAGE>
********************************************************************/

string	ls_description
datetime	ld_expired_date
integer li_row

adw.accepttext( )
if adw.modifiedcount() > 0 then
	for li_row = 1 to adw.rowcount( ) 
		if adw.GetItemStatus(li_row, 0, Primary!) = DataModified! or adw.GetItemStatus(li_row, 0, Primary!) = NewModified! then
			ls_description = adw.getitemstring(li_row,"description")
			ld_expired_date = adw.getitemdatetime(li_row,"expired_date") 
			if isnull(ls_description) or ls_description=""  then
				MessageBox("Validation Error", "Please enter description for the certificate.")
				if ab_selectrow then
					adw.scrolltorow(li_row)
					adw.selectrow( li_row, true)
				end if
				adw.post setcolumn( "description" )
				adw.post setFocus()
				return -1
			end if
			if isnull(ld_expired_date) then
				MessageBox("Validation Error", "Please enter a expire date for the certificate.")
				if ab_selectrow then
					adw.scrolltorow(li_row)
					adw.selectrow( li_row, true)
				end if
				adw.post setcolumn( "expired_date" )
				adw.post setFocus()
				return -1
//			elseif  date(ld_expired_date) < today()  then
//				MessageBox("Validation Error", "Please enter a expire date for the certificate which is greater than today's date.")
//				if ab_selectrow then
//					adw.scrolltorow(li_row)
//					adw.selectrow( li_row, true)
//				end if
//				adw.post setcolumn( "expired_date" )
//				adw.post setFocus()
//				return -1
			end if
		end if
	next
end if
return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_vessel
	
   <OBJECT></OBJECT>
   <DESC></DESC>
   <USAGE>   </USAGE>
   <ALSO></ALSO>
	<HISTORY>
		Date       		CR-Ref			Author			Comments
		00/00/07			?					Name Here		First Version
		13/01/11			CR 2797			JMC112			Added standard object u_pc
		13/05/11			CR 2400			CONASW			Fix error		
		23/05/11			CR 2400			JMC112			Fix Error
		30/05/11			CR 2445			JMC112			Only Finance super user and administrator can change PC
		27/06/11			CR 2453			rmo003			Added Crew and T.O. managed by Copenhagen
		02/08/11			CR 2527			CONASW			Added check for duplicate vessel name in function uf_validategeneral()
		03/08/11			CR 253			CONASW			Added check to see if message.stringparm is a number in open event
		12/07/12			CR#2874			AGL027			Removed all IOM/Singapore configuration code from Vessels window.
		13/07/12			CR2172			WWG004			Added a field to save commerical segment.
		10/08/12			CR2172			JMC112			Deletion of commercial segment value using delete key
		15/10/12			CR2707			ZSW001			Add a restriction that apostrophe is not allowed to be used in Vessel name.
		12/03/13			CR2658			LHG008			Change consumption type, UI of consumption tab and add new column zone.
		20/03/13			CR3049			LGX001			The tabpage Consumption must only be editable for 
																	users with Group Access "Superusers" and Profile "Charterer" and/or "Operator".
		03/05/13			CR3198			ZSW001			Update the Vessels System Table according to current GUI guidelines
		04/09/13			CR3150			ZSW001			After having tried to update Constraints tab, which fails with error message 
																	"The column VESSEL_NR in table VSL_CNSTR does not allow null values
		02/10/13			CR2975			CONASW			Add check for VIMS superuser when changing ShipNet Interface or Active in VIMS
		23/12/13			CR3240			XSZ004			add for VM and VEO	
		21/02/14			CR3240UAT		LHG008			In the Voyage Manager (VM) field, show only active users with Operator profile, 
																	advanced_user and current selected user.
		06/06/14			CR3427			CCY018			Only one instance of the same system table window can be opened at the same time.
		12/08/14			CR3708			AGL027			F1 help application coverage - corrected ancestor
		28/08/14			CR3781			CCY018			The window title match with the text of a menu item
		10/10/14			CR3715			XSZ004			Disable veo button and adjust UI
		09/06/15			CR3998			CCY018			Add two columns Updated By and Updated At to every consumption type row.
		15/07/15			CR3923			KSH092			Merge the current 8 "vessel text" fields into one;Add tabpage details log; Add detail attachments.
		15/10/15			CR4048			XSZ004			Add active column.
		10/11/15			CR3250			CCY018			Add lsfo column.
		04/12/15			CR3381			XSZ004			Fix a history bug.
		25/03/16			CR4157			LHG008			Default Speed extended(Consumption type-zone-speed must be unique)
		25/07/17			CR4157			EPE080			Modify the UI of tank's datawindow and add some checksum
		24/11/17			CR4661			XSZ004			Change delete attachments access for Details tab.	
	</HISTORY>
********************************************************************/
end subroutine

public function integer uf_updatespending (long al_newrow);long ll_anyModifications = 0
long i, ll_return, ll_row
string las_tabpage[]
int lai_tabpageindex[]
int li_selectedtab, li_toselecttab

tab_1.tabpage_1.dw_1.acceptText()
tab_1.tabpage_details.dw_vessel_text.accepttext()
tab_1.tabpage_2.dw_2.acceptText()
tab_1.tabpage_3.dw_3.acceptText()
tab_1.tabpage_tank.dw_tank_list.acceptText()
tab_1.tabpage_5.dw_5.acceptText()
tab_1.tabpage_7.uo_att.dw_file_listing.acceptText()
//tab_1.tabpage_6.dw_6.acceptText()
tab_1.tabpage_8.dw_8.acceptText()
tab_1.tabpage_8.dw_81.acceptText()

i = 0
if ib_generalchanged = true then
	if  tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount() > 0 then 
		ll_anymodifications += tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount()
	end if 
	i++
	las_tabpage[ i ] = tab_1.tabpage_1.text
	lai_tabpageindex[ i ] = 1
end if

if ib_detailschanged = true or tab_1.tabpage_details.uo_vessel_att.dw_file_listing.modifiedcount( )  > 0 or tab_1.tabpage_details.uo_vessel_att.dw_file_listing.deletedcount( ) > 0 then
	if  tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount() > 0 then 
		ll_anymodifications += tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount()
	end if 
	i++
	las_tabpage[ i ] = tab_1.tabpage_details.text
	lai_tabpageindex[ i ] = 2
end if

if ib_financialchanged = true then
	if  tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount() > 0 then 
		ll_anymodifications += tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount()
	end if 
	if tab_1.tabpage_2.dw_brostrommt.modifiedCount() + tab_1.tabpage_2.dw_brostrommt.deletedCount() > 0 then 
		ll_anymodifications += tab_1.tabpage_2.dw_brostrommt.modifiedCount() + tab_1.tabpage_2.dw_brostrommt.deletedCount()
	end if
	i++
	las_tabpage[ i ] = tab_1.tabpage_2.text
	lai_tabpageindex[ i ] = 4
end if
if  tab_1.tabpage_3.dw_3.modifiedCount() + tab_1.tabpage_3.dw_3.deletedCount() > 0 then 
	ll_anymodifications += tab_1.tabpage_3.dw_3.modifiedCount() + tab_1.tabpage_3.dw_3.deletedCount()
	i++
	las_tabpage[ i ] = tab_1.tabpage_3.text
	lai_tabpageindex[ i ] = 5
end if
if  tab_1.tabpage_tank.dw_tank_list.modifiedCount() + tab_1.tabpage_tank.dw_tank_list.deletedCount() > 0 then 
	ll_anymodifications += tab_1.tabpage_tank.dw_tank_list.modifiedCount() + tab_1.tabpage_tank.dw_tank_list.deletedCount()
	i++
	las_tabpage[ i ] = tab_1.tabpage_tank.text
	lai_tabpageindex[ i ] = 6
end if
if  tab_1.tabpage_5.dw_5.modifiedCount() + tab_1.tabpage_5.dw_5.deletedCount() > 0 then 
	ll_anymodifications += tab_1.tabpage_5.dw_5.modifiedCount() + tab_1.tabpage_5.dw_5.deletedCount()
	i++
	las_tabpage[ i ] = tab_1.tabpage_5.text
	lai_tabpageindex[ i ] = 7
end if
if  tab_1.tabpage_7.uo_att.dw_file_listing.modifiedCount() + tab_1.tabpage_7.uo_att.dw_file_listing.deletedCount() > 0 then 
	ll_anymodifications += tab_1.tabpage_7.uo_att.dw_file_listing.modifiedCount() + tab_1.tabpage_7.uo_att.dw_file_listing.deletedCount()
	i++
	las_tabpage[ i ] = tab_1.tabpage_7.text
	lai_tabpageindex[ i ] = 9
end if
if ib_webconfigchanged = true then
	if  tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount() > 0 then 
		ll_anymodifications += tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount()
	end if 
	if  tab_1.tabpage_8.dw_81.modifiedCount() + tab_1.tabpage_8.dw_81.deletedCount() > 0 then 
		ll_anymodifications += tab_1.tabpage_8.dw_81.modifiedCount() + tab_1.tabpage_8.dw_81.deletedCount()	
	end if
	i++	
	las_tabpage[ i ] = tab_1.tabpage_8.text
	lai_tabpageindex[ i ] = 10
end if
If ll_anymodifications > 0 then	
	
	ll_return = inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_UNSAVED_DATA,'',this,las_tabpage,'Data not saved')
	choose case ll_return
		case 1
			is_operatetype = 'search-click'
			if cb_update.event clicked() = c#return.Failure then
				return c#return.Failure
			end if	
		case 2
			tab_1.tabpage_1.dw_1.reset()
			tab_1.tabpage_2.dw_2.reset()
			tab_1.tabpage_3.dw_3.reset()
			tab_1.tabpage_tank.dw_tank_list.reset()
			tab_1.tabpage_tank.dw_tank_summary.reset()
			tab_1.tabpage_5.dw_5.reset()		
			tab_1.tabpage_8.dw_8.reset()
			tab_1.tabpage_8.dw_81.reset()
			tab_1.tabpage_7.uo_att.of_clearimages()
			
			wf_resetdatachangeflag('all')
			uf_gui_control(tab_1.selectedTab, "Cancel")
			// If row was changed, then init vessel (CR 2400)
			if al_newrow>0 then tab_1.tabpage_7.uo_att.of_init(dw_list.getItemNumber(al_newrow, "vessel_nr"))
			
			return 0
		case 3
			if dw_list.getselectedrow(0) = 0 then
				if tab_1.tabpage_1.dw_1.rowcount() = 0 then
					ll_row = 1
				else
					ll_row = dw_list.find("vessel_nr = "+string(tab_1.tabpage_1.dw_1.object.vessel_nr[1]),1,dw_list.rowcount(),primary!)
					if ll_row = 0 or isnull(ll_row) then uo_searchbox.cb_clear.event clicked()
					ll_row = dw_list.find("vessel_nr = "+string(tab_1.tabpage_1.dw_1.object.vessel_nr[1]),1,dw_list.rowcount(),primary!)
				end if
					
				dw_list.post selectrow(0,false)
				if ll_row > 0  then
					dw_list.post selectrow(ll_row,true)
					dw_list.post scrolltorow(ll_row)
				end if
			end if
			
			li_selectedtab = tab_1.selectedtab
			if upperbound(lai_tabpageindex) > 0 then
				for i = 1 to upperbound(lai_tabpageindex)
					if li_selectedtab = lai_tabpageindex[i] then
						li_toselecttab = li_selectedtab
						exit
					end if
				next
				if li_toselecttab <> li_selectedtab then tab_1.selecttab(lai_tabpageindex[1])
			end if
			return -1
	end choose
End if

return 0
end function

public function dwitemstatus wf_get_cons_status (long al_row, integer ai_column, dwbuffer adb_dwbuffer);/********************************************************************
   wf_get_cons_status
   <DESC>	</DESC>
   <RETURN>	DWItemStatus:
   <ACCESS> public </ACCESS>
   <ARGS>
		al_row
		ai_column
		adb_dwbuffer
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author			Comments
		10/06/15		CR3998		CCY018			First Version
		15/10/15		CR4048		XSZ004			Add active column.
		10/11/15		CR3250		CCY018			Add lsfo column.
   </HISTORY>
********************************************************************/

mt_u_datawindow ldw_cons
dwitemstatus ldws_row, ldws_type, ldws_zone, ldws_speed, ldws_sss, ldws_meco, ldws_hfo, ldws_do, ldws_go, ldws_active, ldws_lsfo

ldw_cons = tab_1.tabpage_3.dw_3

if ai_column = 0 then
	ldws_row =  ldw_cons.getitemstatus( al_row, 0, adb_dwbuffer)
	if ldws_row <> DataModified! then return ldws_row
	
	ldws_type = ldw_cons.getitemstatus( al_row, "cal_cons_type", adb_dwbuffer)
	ldws_zone = ldw_cons.getitemstatus( al_row, "zone_id", adb_dwbuffer)
	ldws_speed = ldw_cons.getitemstatus( al_row, "cal_cons_speed", adb_dwbuffer)
	ldws_sss = ldw_cons.getitemstatus( al_row, "cal_cons_sss", adb_dwbuffer)
	ldws_meco = ldw_cons.getitemstatus( al_row, "cal_cons_meco", adb_dwbuffer)
	ldws_hfo = ldw_cons.getitemstatus( al_row, "cal_cons_fo", adb_dwbuffer)
	ldws_do = ldw_cons.getitemstatus( al_row, "cal_cons_do", adb_dwbuffer)
	ldws_go = ldw_cons.getitemstatus( al_row, "cal_cons_mgo", adb_dwbuffer)
	ldws_active = ldw_cons.getitemstatus( al_row, "cal_cons_active", adb_dwbuffer)
	ldws_lsfo = ldw_cons.getitemstatus( al_row, "cal_cons_lsfo", adb_dwbuffer)
	
	if ldws_type <> NotModified! or  ldws_zone <> NotModified! or ldws_speed <> NotModified! or ldws_sss <> NotModified! &
	or ldws_meco <> NotModified! or ldws_hfo <> NotModified! or ldws_do <> NotModified! or ldws_go <> NotModified! or ldws_active <> NotModified! &
	or ldws_lsfo <> NotModified! then
		return DataModified!
	else
		return NotModified!
	end if
else
	return ldw_cons.getitemstatus( al_row, ai_column, adb_dwbuffer)
end if
end function

public function integer wf_deletedetailattachments ();/********************************************************************
   wf_deletedetailattachments
   <DESC>delete detail attachments.</DESC>
   <RETURN>	(none)  
   <ACCESS> private </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE> delete button </USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
  		20/07/2015		CR3923		KSH092		First Version	      
   </HISTORY>
********************************************************************/
int li_count, li_row, li_rc_attachment
n_service_manager 			lnv_svcmgr
n_dw_validation_service 	lnv_actionrules
					 

tab_1.tabpage_details.uo_vessel_att.dw_file_listing.accepttext( )

li_count = tab_1.tabpage_details.uo_vessel_att.dw_file_listing.rowcount()
if li_count > 0 then
	for li_row = li_count to 1 step -1
		tab_1.tabpage_details.uo_vessel_att.of_deleteimage(li_row, true)
	next
	lnv_svcmgr.of_loadservice( lnv_actionrules, "n_dw_validation_service")
	lnv_actionrules.of_registerrulestring("description", true, "description")
	if lnv_actionrules.of_validate(tab_1.tabpage_details.uo_vessel_att.dw_file_listing, true) = c#return.Failure then return -1
	
	li_rc_attachment = tab_1.tabpage_details.uo_vessel_att.of_updateattach() 
	if li_rc_attachment < 0 then
		Rollback;
		Messagebox("Error message; "+ this.ClassName(), "Vessel Details Attachments Update failed~r~nRC=" + String(li_rc_attachment))
		return -1
	else
		return 1
		
	end if
else
	return 1
end if
end function

private subroutine _set_permission (datawindow adw, boolean ab_log);/********************************************************************
   _set_permission(datawindow adw,boolean ab_log)
   <DESC>
	  
	</DESC>
   <RETURN>	
   <ACCESS> Private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29-07-2015 CR3923       KSH092       First Version
		
   </HISTORY>
********************************************************************/

	cb_new.enabled = false
	cb_delete.enabled = false	
	cb_update.enabled = false
	cb_cancel.enabled = false
	cb_modifyvesselnumber.enabled = false
	if ab_log = true then
		cb_new.visible = false
		cb_delete.visible = false
		cb_update.visible = false
		cb_cancel.visible = false
		cb_modifyvesselnumber.visible = false
	else
		cb_new.visible = true
		cb_delete.visible = true
		cb_update.visible = true
		cb_cancel.visible = true
		if uo_global.ii_access_level = 3 then
			cb_modifyvesselnumber.visible = true
		end if
	end if
	if adw.object.datawindow.readonly = "no"  and ab_log = false then
		if adw <> tab_1.tabpage_details.uo_vessel_att.dw_file_listing then
			cb_new.enabled = true
			cb_delete.enabled = true	
		end if
		cb_update.enabled = true
		cb_cancel.enabled = true
		cb_modifyvesselnumber.enabled = true
	end if

end subroutine

private function integer wf_validation_delete (integer adw_getrow);/********************************************************************
  of_validation_delete( /*integer adw_getrow */)
   <DESC>when delete vessel,validation </DESC>
   <RETURN>	(none)  
   <ACCESS> private </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE> delete button </USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
  		31/07/2015		CR3923		KSH092		First Version	      
   </HISTORY>
********************************************************************/

long ll_row, ll_vessel_nr

ll_vessel_nr = dw_list.getitemnumber(adw_getrow,"VESSEL_NR")

//VOYAGES
SELECT COUNT(*)
INTO :LL_ROW
FROM VOYAGES
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if

//NTC_TC_CONTRACT
SELECT COUNT(*)
INTO :LL_ROW
FROM NTC_TC_CONTRACT
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if

//SPECIAL_CLAIM
SELECT COUNT(*)
INTO :LL_ROW
FROM SPECIAL_CLAIM
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if

//BROSTROM_MT_VESSELS
SELECT COUNT(*)
INTO :LL_ROW
FROM BROSTROM_MT_VESSELS
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if

//ACTUAL_EARNINGS
SELECT COUNT(*)
INTO :LL_ROW
FROM ACTUAL_EARNINGS
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if

//DAILY_RUNNING_COSTS
SELECT COUNT(*)
INTO :LL_ROW
FROM DAILY_RUNNING_COSTS
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if

//GRADE_COND_FACTOR
SELECT COUNT(*)
INTO :LL_ROW
FROM GRADE_COND_FACTOR
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if
//NTC_POOL_VESSELS
SELECT COUNT(*)
INTO :LL_ROW
FROM NTC_POOL_VESSELS
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if

//POOL_WEEKLY_FIXTURE
SELECT COUNT(*)
INTO :LL_ROW
FROM POOL_WEEKLY_FIXTURE
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if


//TCHIRES
SELECT COUNT(*)
INTO :LL_ROW
FROM TCHIRES
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if
//VAS_FILE_DATA
SELECT COUNT(*)
INTO :LL_ROW
FROM VAS_FILE_DATA
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if

//VESSEL_VEOS
SELECT COUNT(*)
INTO :LL_ROW
FROM VESSEL_VEOS
WHERE VESSEL_NR = :LL_VESSEL_NR;
if ll_row > 0 then
	return C#return.Failure
end if

return c#return.Success
end function

private subroutine wf_set_accessright_detailatt ();/********************************************************************
   wf_set_accessright_detailatt()
   <DESC>
	  
	</DESC>
   <RETURN>	
   <ACCESS> Private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date				CR-Ref			Author			Comments
		07-07-2015		CR3923			KSH092			First Version
		24/11/17			CR4661			XSZ004			Change delete attachments access for Details tab.	
   </HISTORY>
********************************************************************/

if (uo_global.ii_user_profile < 3) and (uo_global.ii_access_level >= C#usergroup.#USER) then	

	tab_1.tabpage_details.uo_vessel_att.dw_file_listing.modify("Datawindow.ReadOnly = 'No'")
	tab_1.tabpage_details.dw_vessel_text.object.details.edit.displayonly = 'No'
	tab_1.tabpage_details.uo_vessel_att.pb_new.enabled = true
//		tab_1.tabpage_details.uo_vessel_att.ib_allow_dragdrop = true
	tab_1.tabpage_details.uo_vessel_att.dw_file_listing.object.description.edit.displayonly = 'No'
   
else
	
	tab_1.tabpage_details.uo_vessel_att.dw_file_listing.modify("Datawindow.ReadOnly = 'Yes'")
	tab_1.tabpage_details.dw_vessel_text.object.details.edit.displayonly = 'Yes'
	tab_1.tabpage_details.uo_vessel_att.pb_new.enabled = false

	tab_1.tabpage_details.uo_vessel_att.dw_file_listing.object.description.edit.displayonly = 'Yes'
end if

if ( uo_global.ii_access_level = C#usergroup.#ADMINISTRATOR or uo_global.ii_access_level = C#usergroup.#SUPERUSER ) &
	and uo_global.ii_user_profile < 3 then
	
	tab_1.tabpage_details.uo_vessel_att.pb_delete.enabled = true
else
	tab_1.tabpage_details.uo_vessel_att.pb_delete.enabled = false
end if

end subroutine

private subroutine wf_insert_vesseldetailhistory (datastore ds_vessel_detail_history, string as_new, string as_old, long ad_vessel_nr, datetime adt_today, string as_type);	/********************************************************************
   wf_insert_vesseldetailhistory()
   <DESC>	When update attachment,insert change history	</DESC>
   <RETURN>	integer:
           
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	cb_update.event clicked( )	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		2015-07-07	CR3923        KSH092   First Version
   </HISTORY>
********************************************************************/

int li_row
	
li_row = ds_vessel_detail_history.insertrow(0)
ds_vessel_detail_history.setitem(li_row,'vessel_nr',ad_vessel_nr)
if isnull(as_new) then as_new = ''
if isnull(as_old) then as_old = ''
if as_type = 'details' then
	ds_vessel_detail_history.setitem(li_row,'description','Vessel detail changed. See text below.')
	ds_vessel_detail_history.setitem(li_row,'detail_new',as_new)
	ds_vessel_detail_history.setitem(li_row,'detail_old',as_old)
elseif as_type = 'delete' then
	ds_vessel_detail_history.setitem(li_row,'description','Delete attachment: ' + as_new)
end if

	
ds_vessel_detail_history.setitem(li_row,'updated_date',adt_today)
ds_vessel_detail_history.setitem(li_row,'updated_by',uo_global.gos_userid)
end subroutine

public subroutine wf_setselectedrow (ref mt_u_datawindow adw_object, long al_selectedrow);long ll_rowcount, ll_row

ll_rowcount = adw_object.rowcount()
if ll_rowcount > 0 then
	if al_selectedrow > ll_rowcount then al_selectedrow = ll_rowcount	
	
	if adw_object.getselectedrow(0) <> al_selectedrow then
		adw_object.setrow(al_selectedrow)
		adw_object.scrolltorow(al_selectedrow)
		if al_selectedrow = adw_object.getrow() then adw_object.event rowfocuschanged(al_selectedrow)
	end if
end if

end subroutine

public subroutine wf_setselectedrow (ref mt_u_datawindow adw_object, string as_columnname, string as_value);
long ll_selectrow

ll_selectrow = adw_object.find(as_columnname+" = '"+as_value+"'",1,adw_object.rowcount())
If ll_selectrow = 0 then ll_selectrow = 1

wf_setselectedrow(adw_object,ll_selectrow)
end subroutine

public subroutine wf_dwsetredraw (boolean ab_redraw);tab_1.tabpage_tank.dw_tank_list.setredraw(ab_redraw)
tab_1.tabpage_tank.dw_tank_summary.setredraw(ab_redraw)
end subroutine

public function integer wf_getmodifieddata ();long ll_anymodifications = 0
tab_1.tabpage_1.dw_1.accepttext()
tab_1.tabpage_details.dw_vessel_text.accepttext()
tab_1.tabpage_2.dw_2.accepttext()
tab_1.tabpage_3.dw_3.accepttext()
tab_1.tabpage_tank.dw_tank_list.accepttext()
tab_1.tabpage_5.dw_5.accepttext()
tab_1.tabpage_7.uo_att.dw_file_listing.accepttext()
tab_1.tabpage_8.dw_8.accepttext()
tab_1.tabpage_8.dw_81.accepttext()

ll_anymodifications += tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount()
ll_anymodifications += tab_1.tabpage_2.dw_2.modifiedCount() + tab_1.tabpage_2.dw_2.deletedCount()
ll_anymodifications += tab_1.tabpage_3.dw_3.modifiedCount() + tab_1.tabpage_3.dw_3.deletedCount()
ll_anymodifications += tab_1.tabpage_tank.dw_tank_list.modifiedCount() + tab_1.tabpage_tank.dw_tank_list.deletedCount()
ll_anymodifications += tab_1.tabpage_5.dw_5.modifiedCount() + tab_1.tabpage_5.dw_5.deletedCount()
ll_anymodifications += tab_1.tabpage_7.uo_att.dw_file_listing.modifiedCount() + tab_1.tabpage_7.uo_att.dw_file_listing.deletedCount()
ll_anymodifications += tab_1.tabpage_8.dw_8.modifiedCount() + tab_1.tabpage_8.dw_8.deletedCount()
ll_anymodifications += tab_1.tabpage_8.dw_81.modifiedCount() + tab_1.tabpage_8.dw_81.deletedCount()

return ll_anymodifications
end function

public function integer wf_setlistselectedvessel (boolean ab_click, long al_vesselnr);/********************************************************************
   wf_setlistselectedvessel
   <DESC>set selected vessel in list,</DESC>
   <RETURN>	integer:
		   <LI> c#return.Success, ok
            <LI> c#return.Failure, failed
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_click       if triger clicked event after selected vessel
		al_vesselnr  vessel number to be select
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08/09/17		CR4667		EPE080		First Version
   </HISTORY>
********************************************************************/

long ll_rowcount, ll_selectedrow, ll_findrow

if tab_1.tabpage_1.dw_1.rowcount() = 0 then
	ll_selectedrow = dw_list.getSelectedRow(0)
	if ll_selectedrow > 0  then
		ll_findrow = ll_selectedrow
	else
		ll_rowcount = dw_list.rowcount()
		if ll_rowcount = 0 then
			uo_searchbox.cb_clear.event clicked()
		end if
		
		if isnull(al_vesselnr)  then 
			ll_findrow = 1
		else
			ll_findrow = dw_list.find("vessel_nr = "+string(al_vesselnr),1,dw_list.rowcount(),primary!)
			if ll_findrow = 0 then 
				uo_searchbox.cb_clear.event clicked()
				ll_findrow = dw_list.find("vessel_nr = "+string(al_vesselnr),1,dw_list.rowcount(),primary!)
			end if
		end if
	end if
else
	if isnull(al_vesselnr)  then 
		if tab_1.tabpage_1.dw_1.rowcount() > 0 then al_vesselnr = tab_1.tabpage_1.dw_1.object.vessel_nr[1]
	end if
	ll_selectedrow = dw_list.getSelectedRow(0)
	if ll_selectedrow > 0 then
		if al_vesselnr = dw_list.object.vessel_nr[ll_selectedrow] then
			ll_findrow = ll_selectedrow
		else
			ll_findrow = dw_list.find("vessel_nr = "+string(al_vesselnr),1,dw_list.rowcount(),primary!)
			if ll_findrow = 0 then 
				uo_searchbox.cb_clear.event clicked()
				ll_findrow = dw_list.find("vessel_nr = "+string(al_vesselnr),1,dw_list.rowcount(),primary!)
			end if
		end if
	else
		ll_findrow = dw_list.find("vessel_nr = "+string(al_vesselnr),1,dw_list.rowcount(),primary!)
		if ll_findrow = 0 then 
			uo_searchbox.cb_clear.event clicked()
			ll_findrow = dw_list.find("vessel_nr = "+string(al_vesselnr),1,dw_list.rowcount(),primary!)
		end if
	end if
end if

if ll_findrow > 0  then
	return wf_setlistselectedvessel(ll_findrow,ab_click)
else
	return c#return.Failure
end if
return c#return.Success
end function

public function integer wf_setlistselectedvessel (long al_rownumber, boolean ab_click);/********************************************************************
   wf_setlistselectedvessel
   <DESC>set selected vessel in list,</DESC>
   <RETURN>	integer:
		   <LI> c#return.Success, ok
            <LI> c#return.Failure, failed
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_rownumber  row number of vessel to be select
		ab_click       if triger clicked event after selected vessel
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08/09/17		CR4667		EPE080		First Version
   </HISTORY>
********************************************************************/


if al_rownumber > 0  then
	dw_list.post selectrow(0,false)
	dw_list.post selectrow(al_rownumber,true)
	dw_list.post scrolltorow(al_rownumber)
	if ab_click = true then
		dw_list.EVENT post Clicked(0, 0, al_rownumber, dw_list.Object)
	end if
else
	return c#return.Failure
end if
return c#return.Success
end function

public subroutine wf_resetdatachangeflag (string as_tab);/********************************************************************
   wf_resetdatachangeflag
   <DESC>set via of change flag to false</DESC>
   <RETURN>	none
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tab       name of via to be set,eg general\financial
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08/09/17		CR4667		EPE080		First Version
   </HISTORY>
********************************************************************/


choose case as_tab
	case 'general'
		ib_generalchanged = false
	case 'financial'
		ib_financialchanged = false
	case 'details'
		ib_detailschanged = false
	case 'webconfig'
		ib_webconfigchanged = false
	case else
		ib_generalchanged = false
		ib_financialchanged = false
		ib_detailschanged = false
		ib_webconfigchanged = false
end choose
end subroutine

public subroutine wf_newvessel ();/********************************************************************
   wf_newvessel
   <DESC>new a vessel,</DESC>
   <RETURN>	
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08/09/17		CR4667		EPE080		First Version
   </HISTORY>
********************************************************************/

long ll_row

tab_1.tabpage_1.dw_1.reset()
tab_1.tabpage_2.dw_brostrommt.reset()
tab_1.tabpage_3.dw_3.reset()
tab_1.tabpage_tank.dw_tank_list.reset()
tab_1.tabpage_tank.dw_tank_summary.reset()
tab_1.tabpage_5.dw_5.reset()
tab_1.tabpage_6.dw_6.reset()
tab_1.tabpage_7.uo_att.dw_file_listing.reset()
tab_1.tabpage_8.dw_8.reset()
tab_1.tabpage_9.dw_details_log_desc.reset()
tab_1.tabpage_9.dw_details_log_query.reset()
tab_1.tabpage_8.dw_81.reset()
tab_1.tabpage_8.dw_81.insertRow(0)
ll_row = tab_1.tabpage_1.dw_1.insertRow(0)
tab_1.tabpage_1.dw_1.Object.vessel_active[ll_row] = 1
tab_1.tabpage_1.dw_1.Object.apm_owned_vessel[ll_row] = 0
tab_1.tabpage_1.dw_1.POST setfocus()
tab_1.tabpage_1.dw_1.POST setcolumn("vessel_ref_nr")
tab_1.tabpage_2.dw_2.settaborder("pc_nr",10)

ib_generalchanged = true

//wf_setlistselectedvessel(false,tab_1.tabpage_1.dw_1.object.vessel_nr[1])
//dw_list.selectrow(0,false)
end subroutine

on w_vessel.create
int iCurrent
call super::create
this.cb_modifyvesselnumber=create cb_modifyvesselnumber
this.cb_newbuildings=create cb_newbuildings
this.uo_pc=create uo_pc
this.st_background=create st_background
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_modifyvesselnumber
this.Control[iCurrent+2]=this.cb_newbuildings
this.Control[iCurrent+3]=this.uo_pc
this.Control[iCurrent+4]=this.st_background
end on

on w_vessel.destroy
call super::destroy
destroy(this.cb_modifyvesselnumber)
destroy(this.cb_newbuildings)
destroy(this.uo_pc)
destroy(this.st_background)
end on

event open;call super::open;long ll_row, ll_rows
datawindowchild 	ldwc
n_dw_style_service lnv_styleservice
n_service_manager lnv_servicemanager
in_comment = create n_comment

n_service_manager		lnv_service_manager
n_dw_style_service	lnv_dwstyle

dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
tab_1.tabpage_2.dw_2.setTransObject(SQLCA)
tab_1.tabpage_2.dw_2.retrieve(0)  // only to populate dddw
/* Populate Profitcenter DDDW */
tab_1.tabpage_2.dw_2.getChild( "pc_nr", ldwc )   
ldwc.setTransObject(sqlca)
ldwc.retrieve( uo_global.is_userid )

lnv_servicemanager.of_loadservice( lnv_styleservice , "n_dw_style_service")

lnv_styleservice.of_registercolumn("vessel_name", true)
lnv_styleservice.of_registercolumn("vessel_operator", true)
lnv_styleservice.of_registercolumn("vessel_fin_resp", true)
lnv_styleservice.of_registercolumn("vessel_dem_analyst", true)
lnv_styleservice.of_registercolumn("cal_vest_type_id", true)
lnv_styleservice.of_registercolumn("imo_number", true) 
lnv_styleservice.of_registercolumn("tank_name", true)
lnv_styleservice.of_registercolumn("segregation", true)

tab_1.tabpage_tank.dw_tank_summary.of_setallcolumnsresizable(true)
tab_1.tabpage_tank.dw_tank_list.of_setallcolumnsresizable(true)
tab_1.tabpage_tank.dw_tank_list.of_set_dddwspecs(true)
tab_1.tabpage_tank.dw_tank_list.inv_dddwsearch.of_register()
//lnv_styleservice.of_dwformformater(tab_1.tabpage_1.dw_1)

tab_1.tabpage_1.dw_1.sharedata(tab_1.tabpage_details.dw_vessel_text)

/* Share general and finance tabpages */
if tab_1.tabpage_1.dw_1.sharedata(tab_1.tabpage_2.dw_2) = -1 then
	Messagebox("Error", "Datawindow share between tabpage 1 & 2 failed. Contact Administrator")
	return
end if

tab_1.tabpage_8.dw_8.setTransObject(SQLCA)
/* Share general and Web Config tabpages*/
if tab_1.tabpage_1.dw_1.sharedata(tab_1.tabpage_8.dw_8) = -1 then
	Messagebox("Error", "Datawindow share between tabpage 1 & 8 failed. Contact Administrator")
	return
end if

lnv_styleservice.of_registercolumn("cal_cons_type", true)
lnv_styleservice.of_registercolumn("zone_id", true) 
lnv_styleservice.of_dwlistformater(tab_1.tabpage_3.dw_3)
lnv_styleservice.of_dwlistformater(tab_1.tabpage_tank.dw_tank_list)
//lnv_styleservice.of_dwlistformater(tab_1.tabpage_tank.dw_tank_summary)
lnv_styleservice.of_dwlistformater(dw_list, false)

tab_1.tabpage_3.dw_3.setTransObject(SQLCA)
tab_1.tabpage_tank.dw_tank_list.setTransObject(SQLCA)
tab_1.tabpage_tank.dw_tank_summary.setTransObject(SQLCA)
tab_1.tabpage_5.dw_5.setTransObject(SQLCA)
tab_1.tabpage_6.dw_6.setTransObject(SQLCA)
tab_1.tabpage_8.dw_81.setTransObject(SQLCA)
tab_1.tabpage_9.dw_details_log_desc.settransobject(sqlca)
tab_1.tabpage_9.dw_details_log_query.settransobject(sqlca)

tab_1.tabpage_2.dw_brostrommt.setTransObject(SQLCA)

tab_1.tabpage_details.dw_vessel_text.is_hyperlinkshortcut = "details"

/* Retrieve Profitcenter available for user */
il_pcnr=uo_pc.of_retrieve( )

if il_pcnr=c#return.failure then 
	Messagebox("Message", "Retrieve profitcenter went wrong. Contact Administrator")
	return
end if

// build Profitcenter number array - for retrieval argument
uo_pc.of_getpcarray(il_pcnr_array)

/* Insert 'All' item */
uo_pc.of_addnew( 999, "<All>")
il_pcnr = 999

//vessels detail attachment
tab_1.tabpage_details.uo_vessel_att.of_init()

tab_1.tabpage_details.uo_vessel_att.dw_file_listing.modify("description.width = 2225")
tab_1.tabpage_details.uo_vessel_att.of_addupdatetable("ATTACHMENTS","file_id")
tab_1.tabpage_details.uo_vessel_att.of_addupdatetable("VESSELS_ACTION","vessel_nr,file_id","vessel_nr,file_id")
tab_1.tabpage_details.uo_vessel_att.visible = true
tab_1.tabpage_details.uo_vessel_att.pb_new.visible = true
tab_1.tabpage_details.uo_vessel_att.pb_delete.visible = true
tab_1.tabpage_details.uo_vessel_att.dw_file_listing.ib_columntitlesort = true
tab_1.tabpage_details.uo_vessel_att.dw_file_listing.ib_multicolumnsort = true
tab_1.tabpage_details.uo_vessel_att.dw_file_listing.ib_setselectrow = true
wf_set_accessright_detailatt()

//Set-up user access
choose case uo_global.ii_access_level
	case 3	/* Administrator */
		cb_modifyvesselnumber.visible = true
		tab_1.tabpage_2.dw_2.setTabOrder("apm_account_nr",40)
		tab_1.tabpage_2.dw_2.setTabOrder("cph_crew_managed", 140)
		tab_1.tabpage_2.dw_2.setTabOrder("cph_to_managed", 150)
		tab_1.tabpage_2.dw_brostrommt.Object.DataWindow.ReadOnly="No"
	case else
		cb_modifyvesselnumber.visible = false

		/* if finance profile access to demurrage account */
		if uo_global.ii_user_profile = 3 then   
			tab_1.tabpage_2.dw_2.setTabOrder("apm_account_nr", 40)
			tab_1.tabpage_2.dw_2.setTabOrder("cph_crew_managed", 140)
			tab_1.tabpage_2.dw_2.setTabOrder("cph_to_managed", 150)
			tab_1.tabpage_2.dw_brostrommt.Object.DataWindow.ReadOnly="No"
		else
			tab_1.tabpage_2.dw_2.setTabOrder("apm_account_nr", 0)
			tab_1.tabpage_2.dw_2.setTabOrder("cph_crew_managed", 0)
			tab_1.tabpage_2.dw_2.setTabOrder("cph_to_managed", 0)
			tab_1.tabpage_2.dw_brostrommt.Object.DataWindow.ReadOnly="Yes"
	end if
end choose
	
// If external partner/APM only read access to attached profitcenter vessels
if uo_global.ii_access_level < 0 then
	
	tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly="Yes"
	//tab_1.tabpage_1.dw_1.modify("b_veo.enabled = false")
	tab_1.tabpage_2.dw_2.Object.DataWindow.ReadOnly="Yes"
	tab_1.tabpage_3.dw_3.Object.DataWindow.ReadOnly="Yes"
	tab_1.tabpage_tank.dw_tank_list.Object.DataWindow.ReadOnly="Yes"
	tab_1.tabpage_5.dw_5.Object.DataWindow.ReadOnly="Yes"
	tab_1.tabpage_8.dw_8.Object.DataWindow.ReadOnly="Yes"
	tab_1.tabpage_8.dw_81.Object.DataWindow.ReadOnly="Yes"
	_set_permission(tab_1.tabpage_1.dw_1,false)
end if

// Set-up user access tab_1.tabpage_3(Consumption) --Superusers and (Charterer or Operator)
if uo_global.ii_access_level = c#usergroup.#SUPERUSER and (uo_global.ii_user_profile = 1 or uo_global.ii_user_profile = 2) then
	tab_1.tabpage_3.dw_3.object.datawindow.readonly = "No"
else
	tab_1.tabpage_3.dw_3.object.datawindow.readonly = "Yes"
end if

// Retrieve vessel list
if dw_list.retrieve(il_pcnr_array ) = 0 THEN
	Messagebox("Message", "No vessels to be shown.")
else
	
	dw_list.Setsort("vessel_ref_nr")
	dw_list.Sort( )
	
	// window may be opened (via calc module) as a response! window.  
	// if so we need to use the parameter received
	if isnull(Message.StringParm) or Message.StringParm="" or Not (IsNumber(Message.StringParm)) then 
		ll_row=1
	else
		ll_row=dw_list.find("vessel_nr="+Message.StringParm,1,dw_list.rowcount())
		if ll_row<1 then ll_row=1
	end if
end if

dw_list.event Clicked(0,0,ll_row,dw_list.object)
dw_list.scrolltorow(ll_row)

// Initialize search box
uo_searchbox.of_setlabel("Search", false)
uo_SearchBox.of_initialize(dw_List, "vessel_ref_nr+'~'+vessel_name")
uo_SearchBox.sle_search.post setfocus()
 
SELECT VETT_ACCESS INTO :ii_vimsrole FROM USERS WHERE USERID = :uo_global.is_userid;
commit;

uo_pc.of_setlabelcolor(c#color.MT_LISTHEADER_TEXT)
uo_pc.of_setbackcolor(c#color.MT_LISTHEADER_BG, true)

lnv_service_manager.of_loadservice(lnv_dwstyle, "n_dw_style_service")
lnv_dwstyle.of_dwlistformater(w_vessel.tab_1.tabpage_6.dw_6, false)
lnv_dwstyle.of_dwlistformater(w_vessel.tab_1.tabpage_9.dw_details_log_query, false)
w_vessel.tab_1.tabpage_9.dw_details_log_query.of_setallcolumnsresizable(true)

inv_dddwincludecurrentvalue.of_registerdddw(tab_1.tabpage_1.dw_1, "vessel_operator", "user_profile = 2 and user_group <> 3 and user_group <> -2 and deleted <> 1")

if ib_setdefaultbackgroundcolor then _setbackgroundcolor()
end event

event closequery;call super::closequery;if uf_updatesPending(0) = -1 then
	// prevent
	return 1
else
	//allow
	RETURN 0
end if
end event

event close;call super::close;destroy in_comment
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_vessel
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_vessel
integer width = 1051
integer taborder = 10
boolean ib_standard_ui = true
end type

event uo_searchbox::clearclicked;call super::clearclicked;if wf_getmodifieddata() = 0 then
	dw_list.event clicked(0,0,1,dw_list.object)
else
	wf_setlistselectedvessel(false,tab_1.tabpage_1.dw_1.object.vessel_nr[1])
end if
end event

type st_1 from w_coredata_ancestor`st_1 within w_vessel
boolean visible = false
integer y = 332
string text = "Profit Center:"
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_vessel
boolean visible = false
integer y = 396
integer taborder = 120
boolean livescroll = false
end type

type dw_list from w_coredata_ancestor`dw_list within w_vessel
integer y = 496
integer width = 1051
integer height = 1864
integer taborder = 20
string dataobject = "d_vessel_picklist"
boolean border = false
end type

event dw_list::clicked;integer li_vessel_nr
long ll_row, ll_picklist_row
string ls_sort, ls_sort2

// Call ancestor Clicked event to perform sorting
//Super::Event Clicked(xpos, ypos, row, dwo)

// Perform Sorting
//When ordering by web, then is ordering by web+vessel name
If row = 0 then
	if dwo.name = "datawindow" then return 1

	If (String(dwo.type) = "text") then
		if abs(xpos - unitstopixels(long(this.describe(dwo.name + ".x")), xunitstopixels!)) <= 1 then return 1

		If (String(dwo.tag)>"") then
			ls_sort = dwo.Tag
			ls_sort2 = ls_sort
			if mid(ls_sort2,1,2) ="#5" then
				ls_sort2 = ls_sort2 + " #2 A"
			end if
			This.SetSort(ls_sort2)
			This.Sort()
			If right(ls_sort,1) = "A" then 
				ls_sort = Replace(ls_sort, len(ls_sort),1, "D")
			Else
				ls_sort = Replace(ls_sort, len(ls_sort),1, "A")
			End if
			dwo.Tag = ls_sort		
		End If
	End if
End If

wf_dwsetredraw(false)

if uf_updatespending(row) = -1 then 
	post wf_setlistselectedvessel(false,tab_1.tabpage_1.dw_1.object.vessel_nr[1])

	wf_dwsetredraw(true)
	return
end if

if row < 1  or row > dw_list.rowcount() then 
	wf_dwsetredraw(true)
	return
end if
setPointer(hourGlass!)

// Retrieval argument for tabpages
// AGL 7/8/9 - the following causes a runtime error when user deletes the vessel!
li_vessel_nr = dw_list.getItemNumber(row, "vessel_nr")

if wf_getmodifieddata() = 0 then
	dw_list.selectRow(0,false)
	dw_list.selectRow(row,true)
	dw_list.scrolltoRow(row)
end if
//Retrieve tabpages
tab_1.tabpage_1.dw_1.POST Retrieve(li_vessel_nr)
//tab_1.tabpage_2.dw_2.POST Retrieve(li_vessel_nr)  /* datawindow shared with tabpage 1 */
tab_1.tabpage_3.dw_3.POST Retrieve(li_vessel_nr)

tab_1.tabpage_tank.dw_tank_list.Retrieve(li_vessel_nr)
tab_1.tabpage_tank.dw_tank_summary.Retrieve(li_vessel_nr)
wf_setselectedrow(tab_1.tabpage_tank.dw_tank_list,1)

tab_1.tabpage_5.dw_5.POST Retrieve(li_vessel_nr)
tab_1.tabpage_6.dw_6.POST Retrieve(li_vessel_nr)
//tab_1.tabpage_2.dw_iomsin.POST Retrieve(li_vessel_nr)
tab_1.tabpage_2.dw_brostrommt.POST Retrieve(li_vessel_nr)
tab_1.tabpage_9.dw_details_log_query.POST Retrieve(li_vessel_nr)
tab_1.tabpage_details.uo_vessel_att.post of_init()
tab_1.tabpage_9.dw_details_log_query.setrow(1)
tab_1.tabpage_9.dw_details_log_query.scrolltorow(1)

//Only Administrator and Finance super user is able to change the profit center
if uo_global.ii_access_level =3 or (uo_global.ii_access_level =2 and uo_global.ii_user_profile=3) then
	tab_1.tabpage_2.dw_2.settaborder("pc_nr",10)
else
	tab_1.tabpage_2.dw_2.settaborder("pc_nr",0)
end if

post wf_retrievewebvesselconfig(li_vessel_nr)

tab_1.tabpage_3.uo_TPerf.Post of_LoadVessel(li_Vessel_Nr)

uf_enableTabPages(TRUE, 4, 8)

post wf_dwsetredraw(true)

SetPointer(Arrow!)
end event

type cb_close from w_coredata_ancestor`cb_close within w_vessel
boolean visible = false
integer x = 4206
integer y = 2380
integer width = 343
integer height = 100
end type

event cb_close::clicked;call super::clicked;close(parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_vessel
integer x = 4206
integer y = 2380
integer width = 343
integer height = 100
integer taborder = 90
end type

event cb_cancel::clicked;call super::clicked;string ls_tankname, ls_segregation
long ll_selectrow, ll_vesselnr
datawindow ldw_d

uf_gui_control(tab_1.selectedTab, "Cancel")

ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab], 1)
if tab_1.selectedTab = 6 then	
	wf_dwsetredraw(false)
	// Remember currently selected ID
	ll_selectrow = tab_1.tabpage_tank.dw_tank_list.Getselectedrow(0)
	If ll_selectrow > 0 then ls_tankname = tab_1.tabpage_tank.dw_tank_list.getitemstring(ll_selectrow, "tank_name")
end if

if tab_1.tabpage_1.dw_1.rowcount() = 1 then 
	ll_vesselnr = tab_1.tabpage_1.dw_1.object.vessel_nr[1]
else
	setnull(ll_vesselnr)
end if

tab_1.tabpage_1.dw_1.reset()
tab_1.tabpage_2.dw_2.reset()
tab_1.tabpage_3.dw_3.reset()
tab_1.tabpage_tank.dw_tank_list.reset()
tab_1.tabpage_tank.dw_tank_summary.reset()
tab_1.tabpage_5.dw_5.reset()		
tab_1.tabpage_8.dw_8.reset()
tab_1.tabpage_8.dw_81.reset()
tab_1.tabpage_7.uo_att.of_cancelchanges()

wf_setlistselectedvessel(true,ll_vesselnr)
if dw_list.getselectedrow(0) > 0 then
	tab_1.tabpage_7.uo_att.of_init(dw_list.getItemNumber(dw_list.getselectedrow(0), "vessel_nr"))
else
	if isnull(ll_vesselnr) then ll_vesselnr = 0
	tab_1.tabpage_7.uo_att.of_init(ll_vesselnr)
end if

if tab_1.selectedTab = 6 then	
	post wf_setselectedrow(tab_1.tabpage_tank.dw_tank_list,'tank_name',ls_tankname)
	post wf_dwsetredraw(true)
end if

wf_resetdatachangeflag('all')	

end event

type cb_delete from w_coredata_ancestor`cb_delete within w_vessel
integer x = 3858
integer y = 2380
integer width = 343
integer height = 100
integer taborder = 80
end type

event cb_delete::clicked;long ll_response, ll_rc, ll_update, ll_row, ll_rowcount, ll_selectedrow
datawindow ldw_d
long ll_currentrow, ll_vesselnr
string ls_tankname, ls_segregation, ls_changeflag, ls_vesselnr
DWItemStatus le_rowstatus, le_itemstatus

ll_currentrow = dw_list.getselectedrow(0)

uf_gui_control(tab_1.selectedtab, "Delete")

ldw_d = uf_getdatawindow(tab_1.control[tab_1.selectedtab], 1)

// Deleting selected row depending on the selected tabpage (the general page or any other page)
choose case tab_1.selectedtab
    case 1,2,4,10    //Free form
		if ll_currentrow=0 and tab_1.tabpage_1.dw_1.getitemstatus(1,0,primary!) <> New! and tab_1.tabpage_1.dw_1.getitemstatus(1,0,primary!) <> newmodified!  then
			messagebox("Deleting!","Vessel is not selected. Please select a vessel from the list.")
			return
		end if
		
		ll_response = messagebox("Deleting!","You are about to delete a vessel and all information connected to it. ~r~n" + & 
                               "Do you wish to continue?", Question!, YesNo!, 2)
		if ll_response = 1 then
			if tab_1.tabpage_1.dw_1.getitemstatus(1,0,primary!) = New! or tab_1.tabpage_1.dw_1.getitemstatus(1,0,primary!) = newmodified! then
				tab_1.tabpage_1.dw_1.setredraw(false)
				tab_1.tabpage_2.dw_2.setredraw(false)
				tab_1.tabpage_8.dw_8.setredraw(false)
				tab_1.tabpage_8.dw_81.setredraw(false)
				tab_1.tabpage_1.dw_1.reset()
				tab_1.tabpage_2.dw_2.reset()
				tab_1.tabpage_8.dw_8.reset()
				tab_1.tabpage_8.dw_81.reset()
				wf_resetdatachangeflag('all')
				uf_gui_control(tab_1.selectedTab, "Cancel")
				wf_setlistselectedvessel(true,ll_vesselnr)
				tab_1.tabpage_1.dw_1.setredraw(true)
				tab_1.tabpage_2.dw_2.setredraw(true)
				tab_1.tabpage_8.dw_8.setredraw(true)
				tab_1.tabpage_8.dw_81.setredraw(true)
				return
			end if
			if wf_validation_delete(ll_currentrow) = C#Return.Failure  then
				messagebox("Information","You cannot delete the selected vessel, because it has been used.",Information!)
				return
			end if
			if wf_deletedetailattachments() < 0 then
				return
			end if
			ll_rc = uf_deletevessel(ll_currentrow)
			if ll_rc > 0 then ll_rc = tab_1.tabpage_1.dw_1.deleterow(tab_1.tabpage_1.dw_1.getrow())
			if ll_rc > 0 then ll_rc = tab_1.tabpage_1.dw_1.update()
			if ll_rc < 0 then
				rollback;
				messagebox("Error","Update not done. This could be due to data on tabpage # ~r~n" + &
							  string(tab_1.selectedTab) + " being used other places in the system or database error.~r~n~r~n")
				tab_1.tabpage_1.dw_1.retrieve(dw_list.getItemNumber(ll_currentrow, "vessel_nr"))
				return
			else
				commit;
				if  ll_currentrow - 1 >0 then
					dw_list.event clicked(0, 0,  ll_currentrow - 1 , dw_list.object)
				end if
				uf_updatepicklist()
				dw_list.sort()
				ll_currentrow= ll_currentrow - 1
				dw_list.scrolltorow(ll_currentrow)
				
				wf_resetdatachangeflag('all')

			end if
		end if
	case 5,7  //Tabular form
		ll_row = ldw_d.getrow()
		if ll_row < 1 then
			return
		end if
		ll_response = messagebox("Deleting!","You are about to delete the selected row on tabpage #"+string(tab_1.selectedtab)+"~r~n" & 
                               , Question!, YesNo!, 2)
		if ll_response = 1 then
			ldw_d.deleterow(ll_row)
			if tab_1.selectedtab = 7 then
				if ldw_d.update() <> 1 then
					messagebox("Error","Update not done. This could be due to data on tabpage #" + &
								  string(tab_1.selectedtab) + " being used other places in the system or database error.~r~n~r~n")
					rollback;
					ldw_d.retrieve(dw_list.getitemnumber(ll_currentrow, "vessel_nr"))
					return
				end if
			end if
  		end if
	case 6  //Tank
		ll_row = ldw_d.getSelectedRow(0)
		if ll_row < 1 then
			return
		end if
				
		wf_dwsetredraw(false)
		le_rowstatus = ldw_d.getitemstatus( ll_row, 0, primary!)
		if le_rowstatus = New! or le_rowstatus = NewModified! then
			ldw_d.deleterow(ll_row)
		else
			ll_response = inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_CONFIRM_DELETE, "the selected Tank", this)
			if ll_response = 1 then
				ll_vesselnr = tab_1.tabpage_tank.dw_tank_list.getitemnumber(ll_row, "VESSEL_NR")
				
				le_itemstatus = ldw_d.getitemstatus( ll_row, 'tank_name', primary!)
				if le_itemstatus = DataModified! then
					ls_tankname = tab_1.tabpage_tank.dw_tank_list.getitemstring(ll_row, "tank_name",primary!,true)
				else
					ls_tankname = tab_1.tabpage_tank.dw_tank_list.getitemstring(ll_row, "tank_name")
				end if
				 
				delete from TANK
				where VESSEL_NR = :ll_vesselnr
				    and TANK_NAME = :ls_tankname;
				
				if sqlca.sqlcode <> 0 then
					rollback;
					inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_GENERAL_ERROR, "Delete failed.", this)
					
					ldw_d.retrieve(dw_list.getitemnumber(ll_currentrow, "vessel_nr"))
					post wf_setselectedrow(tab_1.tabpage_tank.dw_tank_list,'tank_name',ls_tankname)	
					
					post wf_dwsetredraw(true)
					
					return
				else
					commit;

					tab_1.tabpage_tank.dw_tank_summary.retrieve(dw_list.getitemnumber(ll_currentrow, "vessel_nr"))
					tab_1.tabpage_tank.dw_tank_list.rowsdiscard( ll_row, ll_row, primary!)
					if ll_row > tab_1.tabpage_tank.dw_tank_list.rowcount() then ll_row = tab_1.tabpage_tank.dw_tank_list.rowcount()
					if ll_row > 0 then tab_1.tabpage_tank.dw_tank_list.event post clicked(0,0,ll_row,dw_list.object)
					
				end if
			end if
		end if
		post wf_dwsetredraw(true)
	case 9 //Certificates
		tab_1.tabpage_7.uo_att.of_deleteimage( )
		
end choose
end event

type cb_new from w_coredata_ancestor`cb_new within w_vessel
integer x = 3163
integer y = 2380
integer width = 343
integer height = 100
integer taborder = 60
end type

event cb_new::clicked;long ll_row, ll_vesselnr
dataWindow ldw_d

if dw_list.getselectedrow(0) = 0 then
	if tab_1.tabpage_1.dw_1.rowcount() = 1 then
		ll_vesselnr = tab_1.tabpage_1.dw_1.Object.vessel_nr[1]
		wf_setlistselectedvessel(false,ll_vesselnr)
	end if
end if

CHOOSE CASE tab_1.selectedTab
	CASE 1, 2, 4, 10 //Synchronize tab1 and tab2
		if uf_updatesPending(0) = -1 then return
		post wf_newvessel()
		
   CASE 6
		ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab],1)		
		ll_row = ldw_d.insertRow(0)
		ldw_d.scrollToRow(ll_row)
		ldw_d.setRow(ll_row)	
		ldw_d.setColumn("tank_name")
		ldw_d.setFocus()
		uf_setupTankDisplay(ldw_d, TRUE, 4)	
	CASE 9 
	   tab_1.tabpage_7.uo_att.of_addnewimage( )		  
   CASE ELSE
      ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab],1)
      ll_row = ldw_d.insertRow(0)
		
		if ldw_d.classname() = "dw_3" then
			ldw_d.setitem(ll_row, "cal_cons_active", 1)
		end if
		
      ldw_d.scrollToRow(ll_row)
		ldw_d.setColumn(1)
		ldw_d.setfocus()
END CHOOSE

uf_gui_control(tab_1.selectedTab, "New")


end event

type cb_update from w_coredata_ancestor`cb_update within w_vessel
integer x = 3511
integer y = 2380
integer width = 343
integer height = 100
integer taborder = 70
end type

event cb_update::clicked;long ll_rc, ll_vessel_nr, ll_selectrow, ll_rowid
long ll_tabpage, ll_row, ll_picklist_row
dataWindow ldw_d
Boolean lb_dtank1_modified = FALSE, lb_dtank2_modified = FALSE
string ls_result, ls_new, ls_old, ls_tankname, ls_segregation
string ls_pick_pcname, ls_finance_pcname, ls_sqlerrtext
long ll_finance_pcnr, ll_finance_row, ll_rc_history, li_rc_attachment
datetime ldt_today
datawindowchild ldwc
n_service_manager 			lnv_svcmgr
n_dw_validation_service 	lnv_actionrules
mt_n_datastore ds_vessel_detail_history

uf_gui_control(tab_1.selectedTab, "Update")

//General - Update all tabpages
tab_1.tabpage_1.dw_1.acceptText()
tab_1.tabpage_details.dw_vessel_text.accepttext()
tab_1.tabpage_details.uo_vessel_att.dw_file_listing.accepttext()
tab_1.tabpage_2.dw_2.acceptText()
tab_1.tabpage_3.dw_3.acceptText()
tab_1.tabpage_tank.dw_tank_list.acceptText()
tab_1.tabpage_5.dw_5.acceptText()
tab_1.tabpage_2.dw_brostrommt.accepttext()
tab_1.tabpage_8.dw_8.acceptText()

if uf_validategeneral() = -1 then return -1
if uf_validateconsumption() = -1 then return -1
if wf_validatetank() = -1 then 
	if tab_1.selectedtab <> 6 then tab_1.selecttab(6) 
	return -1
end if
//Set foreign keys
FOR ll_tabpage = 5 TO 7
	ldw_d = uf_getDataWindow(tab_1.Control[ll_tabpage], 1)
  	FOR ll_row = 1 TO  ldw_d.rowCount()
   	IF ldw_d.modifiedCount() > 0 THEN
			ldw_d.object.vessel_nr[ll_row] = tab_1.tabpage_1.dw_1.object.vessel_nr[1] 
		END IF	
	NEXT
NEXT

for ll_row = 1 to tab_1.tabpage_3.dw_3.rowcount()
	if wf_get_cons_status(ll_row, 0, primary!) <> NotModified! then
		tab_1.tabpage_3.dw_3.setitem(ll_row, "last_edit_by", uo_global.is_userid)
		tab_1.tabpage_3.dw_3.setitem(ll_row, "last_edit_date", datetime(today(), now()))
	end if
next

// Set next available vessel number. Reason for numbers less than 10000 is that some vessels, not in use any more
// and where reference number where reused by 'some central system', where renumbered to 10000+vessel_nr
if tab_1.tabpage_1.dw_1.getitemStatus( 1, 0, primary!) = newModified! then
	SELECT MAX(VESSEL_NR) INTO :ll_vessel_nr FROM VESSELS WHERE VESSEL_NR < 10000;
	if sqlca.sqlcode <> 0 then
		ls_sqlerrtext = sqlca.sqlerrtext
		Rollback;
		Messagebox("Error message; "+ this.ClassName(), "System failed getting next available vessel nr~r~n~r~n" + ls_sqlerrtext )
		return -1
	END IF
	ll_vessel_nr ++
	tab_1.tabpage_1.dw_1.setItem( 1, "vessel_nr", ll_vessel_nr )
end if

//add vessels detail history
ds_vessel_detail_history = create mt_n_datastore
ds_vessel_detail_history.dataobject = 'd_sq_gr_vessels_detail_history'
ds_vessel_detail_history.settransobject(sqlca)
ds_vessel_detail_history.reset()

ldt_today = datetime(string(today(),'yyyy-mm-dd hh:mm:ss'))
ll_vessel_nr = tab_1.tabpage_1.dw_1.getitemnumber(1,'vessel_nr')
ls_new = tab_1.tabpage_details.dw_vessel_text.getitemstring(1,'details')
ls_old = tab_1.tabpage_details.dw_vessel_text.getitemstring(1,'details',Primary!,true)
if isnull(ls_new) then ls_new = ''
if isnull(ls_old) then ls_old = ''
if ls_old <> ls_new then
	wf_insert_vesseldetailhistory(ds_vessel_detail_history,ls_new,ls_old,ll_vessel_nr,ldt_today,'details')
end if

ll_rc = tab_1.tabpage_1.dw_1.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Rollback;
	Messagebox("Error message; "+ this.ClassName(), "General/Finance Update failed~r~nRC=" + String(ll_rc))
	return -1
else
	ll_rc_history = ds_vessel_detail_history.update(TRUE,FALSE)
	if ll_rc_history < 0 then
		Rollback;
		Messagebox("Error message; "+ this.ClassName(), "General Update failed~r~nRC=" + String(ll_rc_history))
		return -1
	else
		if tab_1.tabpage_details.uo_vessel_att.dw_file_listing.modifiedcount( )  > 0 or tab_1.tabpage_details.uo_vessel_att.dw_file_listing.deletedcount( ) > 0 then
			
			lnv_svcmgr.of_loadservice( lnv_actionrules, "n_dw_validation_service")
			lnv_actionrules.of_registerrulestring("description", true, "description")
			if lnv_actionrules.of_validate(tab_1.tabpage_details.uo_vessel_att.dw_file_listing, true) = c#return.Failure then return c#return.Failure
			li_rc_attachment = tab_1.tabpage_details.uo_vessel_att.of_updateattach() 
			if li_rc_attachment < 0 then
				Rollback;
				Messagebox("Error message; "+ this.ClassName(), "General Update failed~r~nRC=" + String(li_rc_attachment))
				return -1
			end if
		end if
	end if
	
END IF

//Brostom/MT update
if tab_1.tabpage_2.dw_brostrommt.rowcount() > 0 then
	ll_rc = tab_1.tabpage_2.dw_brostrommt.update(TRUE, FALSE)
	IF ll_rc < 0 THEN
		Rollback;
		Messagebox("Error message; "+ this.ClassName(), "Brostr?m/MT setup Update failed~r~nRC=" + String(ll_rc))
		return -1
	END IF
end if	

ll_rc = tab_1.tabpage_3.dw_3.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Rollback;
	tab_1.post selecttab(tab_1.tabpage_3)
	return -1
END IF

if tab_1.selectedTab = 6 then	
	ll_selectrow = tab_1.tabpage_tank.dw_tank_list.getSelectedRow(0)
	If ll_selectrow > 0 then ls_tankname = tab_1.tabpage_tank.dw_tank_list.getitemstring(ll_selectrow, "tank_name")
end if
ll_rc = tab_1.tabpage_tank.dw_tank_list.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Rollback;
	Messagebox("Error message; "+ this.ClassName(), "Tank Update failed~r~nRC=" + String(ll_rc))
	return -1
END IF

ll_rc = tab_1.tabpage_5.dw_5.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Rollback;
	Messagebox("Error message; "+ this.ClassName(), "Constraints Update failed~r~nRC=" + String(ll_rc))
	return -1
END IF

//if vessel name changes, the certificates modified date needs to be updated
if tab_1.tabpage_1.dw_1.getitemStatus( 1, "vessel_name", primary!)= dataModified! or tab_1.tabpage_8.dw_8.getitemstatus(1,"vessels_web_transfer_vessel", primary!) =dataModified!  then
	for ll_row = 1 to tab_1.tabpage_7.uo_att.dw_file_listing.rowcount( )
		tab_1.tabpage_7.uo_att.dw_file_listing.setitemstatus( ll_row,  "sent_to_web", Primary!, DataModified!)
	next
end if

//update certificates
if tab_1.tabpage_1.dw_1.getItemStatus(1,0,primary!) <> NewModified! then
	if of_validation(tab_1.tabpage_7.uo_att.dw_file_listing, true)	= -1 then	
		return -1
	else
		tab_1.tabpage_7.uo_att.of_updateattach()
	end if
end if

//update web config
tab_1.tabpage_8.dw_81.acceptText()

if isnull(tab_1.tabpage_8.dw_81.getitemnumber(1, "vessel_nr") ) then
	tab_1.tabpage_8.dw_81.setitem( 1, "vessel_nr",tab_1.tabpage_1.dw_1.getitemnumber( 1,"vessel_nr") )
end if

ll_rc = tab_1.tabpage_8.dw_81.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Rollback;
	Messagebox("Error message; "+ this.ClassName(), "Web Config Update failed~r~nRC=" + String(ll_rc))
	return -1
END IF

tab_1.tabpage_1.dw_1.resetUpdate()
tab_1.tabpage_details.dw_vessel_text.resetUpdate()
tab_1.tabpage_2.dw_2.resetUpdate()
tab_1.tabpage_3.dw_3.resetUpdate()
tab_1.tabpage_tank.dw_tank_list.resetUpdate()
tab_1.tabpage_5.dw_5.resetUpdate()
tab_1.tabpage_2.dw_brostrommt.resetUpdate()
tab_1.tabpage_8.dw_8.resetUpdate()
tab_1.tabpage_8.dw_81.resetUpdate()

wf_resetdatachangeflag('all')

COMMIT;

//select vessel and retrieve
ll_picklist_row = dw_list.getSelectedRow(0)
if ll_picklist_row > 0  then
	if tab_1.tabpage_1.dw_1.object.vessel_nr[1] <> dw_list.object.vessel_nr[ll_picklist_row]  then
		dw_list.event clicked(0,0,ll_picklist_row,dw_list.object)
	end if
else
	if is_operatetype = 'search-click' then
		 is_operatetype = ''
		 if dw_list.rowcount() = 0 then  wf_setlistselectedvessel(true,tab_1.tabpage_1.dw_1.object.vessel_nr[1])		
	else
		wf_setlistselectedvessel(true,tab_1.tabpage_1.dw_1.object.vessel_nr[1])
	end if
end if 

// if profitcenter picklist <> <All> 
// and porfitcenter picklist <> finance.profitcenter
// then set profitcenter picklist = finance profitcenter
ll_finance_pcnr = tab_1.tabpage_2.dw_2.getItemNumber(1, "pc_nr")
if il_pcnr <> 999 then
	if il_pcnr <> ll_finance_pcnr then
		uo_pc.of_setcurrentpc( ll_finance_pcnr)
	end if
end if	
destroy ds_vessel_detail_history
// Update picklist
wf_dwsetredraw(false)
uf_updatePicklist()

if tab_1.selectedTab = 6 then	
	post wf_setselectedrow(tab_1.tabpage_tank.dw_tank_list,'tank_name',ls_tankname)	
end if
post wf_dwsetredraw(true)

RETURN 1
end event

type st_list from w_coredata_ancestor`st_list within w_vessel
integer y = 416
integer width = 311
integer weight = 400
string text = "Vessel List:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_vessel
integer x = 1111
integer y = 240
integer width = 3438
integer height = 2124
integer taborder = 30
integer weight = 400
boolean multiline = true
tabpage_details tabpage_details
tabpage_9 tabpage_9
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_tank tabpage_tank
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
end type

on tab_1.create
this.tabpage_details=create tabpage_details
this.tabpage_9=create tabpage_9
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_tank=create tabpage_tank
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_details,&
this.tabpage_9,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_tank,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7,&
this.tabpage_8}
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_details)
destroy(this.tabpage_9)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_tank)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
end on

event tab_1::selectionchanged;// if tab selected is the log tab disable command buttons
long ll_vessel_nr

choose case newindex
	case 8,3 // the log tab
		_set_permission(tab_1.tabpage_9.dw_details_log_query,true)
	case 5 //consumption tab
		_set_permission(tab_1.tabpage_3.dw_3,false)
	
	case 2
		_set_permission(tab_1.tabpage_details.uo_vessel_att.dw_file_listing,false)
	
	case 1,4,10
		
		_set_permission(tab_1.tabpage_1.dw_1,false)
	case 6
		_set_permission(tab_1.tabpage_tank.dw_tank_list,false)
	
	case 7
		_set_permission(tab_1.tabpage_5.dw_5,false)
	
	case 9
		_set_permission(tab_1.tabpage_7.uo_att.dw_file_listing,false)
	
		
end choose

choose case newindex
	case 3
		if dw_list.getselectedrow(0) > 0 then
			ll_vessel_nr = dw_list.getItemNumber(dw_list.getselectedrow(0), "vessel_nr")
			tab_1.tabpage_9.dw_details_log_query.reset()
			tab_1.tabpage_9.dw_details_log_query.retrieve(ll_vessel_nr)
			tab_1.tabpage_9.dw_details_log_query.setrow(1)
			tab_1.tabpage_9.dw_details_log_query.scrolltorow(1)
			tab_1.tabpage_9.dw_details_log_query.selectrow(1,true)
		end if
end choose


end event

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer width = 3401
integer height = 2008
cb_show_imovessels cb_show_imovessels
end type

on tabpage_1.create
this.cb_show_imovessels=create cb_show_imovessels
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_show_imovessels
end on

on tabpage_1.destroy
call super::destroy
destroy(this.cb_show_imovessels)
end on

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
event ue_keydown pbm_dwnkey
string tag = "1"
integer x = 9
integer y = 16
integer width = 3392
integer height = 1432
string dataobject = "d_vessel_detail"
end type

event dw_1::ue_keydown;long ll_null

if key = KeyDelete! then
	setNull(ll_null)
	choose case this.getColumnName()
		case "tcowner_nr" 
			this.setItem(this.getRow(), "tcowner_nr", ll_null)
		case "cal_vest_type_id" 
			this.setItem(this.getRow(), "cal_vest_type_id", ll_null)
		case "comm_segment_id" 
			this.setItem(this.getRow(), "comm_segment_id", ll_null)
	end choose
end if
	
end event

event dw_1::itemchanged;call super::itemchanged;integer	li_null;setNull(li_null)

accepttext( )
choose case dwo.name
	CASE "tcowner_nr"
		if f_tcowner_active( long(data)) = false then 
			MessageBox("Validation Error", "Selected TC Owner is marked as inactive. Please select another TC Owner")
			if this.getItemNumber(row, "tcowner_nr", primary!, true) <>  this.getItemNumber(row, "tcowner_nr", primary!, false) then
				this.setItem(row, "tcowner_nr", this.getItemNumber(row, "tcowner_nr", primary!, true) )
			else
				this.setItem(row, "tcowner_nr", li_null)
			end if
			setColumn("tcowner_nr")
			return 2
		end if
		
		CASE "vessel_active"
		  if data="0" then
			if this.getitemnumber( row, "web_transfer_vessel") = 1 then
				this.setitem(row, "web_transfer_vessel",0)
			end if 
		 end if
		 CASE "vims_shipnet_interface", "vett_invims"  
		 	if ii_vimsrole < 3 then
		 		messagebox("Validation Error", "You do not have the permission to change these settings.", Exclamation!)
		 		return 2
			end if
end choose

ib_generalchanged = true



// Control of IOM/SIN vessel show hide
//choose case dwo.name
//	case "apm_owned_vessel"
//		if isnull(this.getitemnumber(row, "tcowner_nr")) or data = "0" then
//			tab_1.tabpage_2.dw_iomsin.post hide()
//		else
//			tab_1.tabpage_2.dw_iomsin.post show()
//			if tab_1.tabpage_2.dw_iomsin.rowcount() = 0 then tab_1.tabpage_2.dw_iomsin.insertRow(0)
//		end if	
//	case "tcowner_nr"
//		if isnull(this.getitemnumber(row, "tcowner_nr")) or this.getItemNumber(row, "apm_owned_vessel")=0 then
//			tab_1.tabpage_2.dw_iomsin.post hide()
//		else
//			tab_1.tabpage_2.dw_iomsin.post show()
//			if tab_1.tabpage_2.dw_iomsin.rowcount() = 0 then tab_1.tabpage_2.dw_iomsin.insertRow(0)
//		end if	
//end choose
end event

event dw_1::buttonclicked;call super::buttonclicked;long ll_vessel_nr

if dwo.name = "b_veo" then
	ll_vessel_nr = this.getitemnumber(row, "VESSEL_NR")
	openwithparm(w_veolist, ll_vessel_nr)
end if
end event

event dw_1::retrieveend;call super::retrieveend;inv_dddwincludecurrentvalue.of_includecurrentvalue(this)
this.setredraw(true)
end event

event dw_1::retrievestart;call super::retrievestart;this.setredraw(false)
end event

type cb_show_imovessels from commandbutton within tabpage_1
integer x = 1742
integer y = 888
integer width = 585
integer height = 80
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Vessels with same &IMO..."
end type

event clicked;s_vessels_with_same_imonumber_parm		lstr_parm

tab_1.tabpage_1.dw_1.accepttext()

lstr_parm.imo_number = tab_1.tabpage_1.dw_1.getItemNumber(1, "imo_number")
lstr_parm.vessel_number = tab_1.tabpage_1.dw_1.getItemNumber(1, "vessel_nr")

if isNull(lstr_parm.imo_number) then
	MessageBox("Information", "Please enter an IMO # and try again")
	return
end if

if isNull(lstr_parm.vessel_number) then
	MessageBox("Information", "Please press update vessel before this button")
	return
end if

openwithparm( w_vessels_with_same_imonumber, lstr_parm  )

end event

type tabpage_details from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3401
integer height = 2008
long backcolor = 67108864
string text = "Details"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
gb_1 gb_1
dw_vessel_text dw_vessel_text
uo_vessel_att uo_vessel_att
end type

on tabpage_details.create
this.gb_1=create gb_1
this.dw_vessel_text=create dw_vessel_text
this.uo_vessel_att=create uo_vessel_att
this.Control[]={this.gb_1,&
this.dw_vessel_text,&
this.uo_vessel_att}
end on

on tabpage_details.destroy
destroy(this.gb_1)
destroy(this.dw_vessel_text)
destroy(this.uo_vessel_att)
end on

type gb_1 from groupbox within tabpage_details
integer x = 18
integer y = 1380
integer width = 3355
integer height = 616
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Attachments"
end type

type dw_vessel_text from mt_u_datawindow within tabpage_details
integer x = 14
integer y = 24
integer width = 3355
integer height = 1340
integer taborder = 30
string dataobject = "d_sq_ff_vessel_text"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

event itemchanged;call super::itemchanged;ib_detailschanged = true
end event

type uo_vessel_att from u_fileattach within tabpage_details
integer x = 37
integer y = 1448
integer width = 3319
integer height = 536
integer taborder = 30
boolean bringtotop = true
string is_dataobjectname = "d_sq_ff_vessel_detail_files"
string is_counterlabel = "Files:"
boolean ib_allow_dragdrop = true
boolean ib_enable_cancel_button = false
boolean ib_autosave = true
boolean ib_multitableupdate = true
string is_modulename = "vessels_action"
end type

on uo_vessel_att.destroy
call u_fileattach::destroy
end on

event ue_preupdateattach;call super::ue_preupdateattach;string ls_port_code,ls_description
long li_row,ll_count,ll_vessel_nr
datetime ldt_today
int i
mt_n_datastore ds_vessel_detail_history

li_row = dw_list.getselectedrow(0)
if li_row > 0 then
	ll_vessel_nr = dw_list.GetItemNumber(li_row, "vessel_nr")
	ll_count = uo_vessel_att.dw_file_listing.rowcount()
	if ll_count > 0 then
		for i = 1 to ll_count
		
			if uo_vessel_att.dw_file_listing.GetItemStatus(i,0,PRIMARY!) = NewModified! then
			//			     
			 	uo_vessel_att.dw_file_listing.setitem(i,'vessel_nr',ll_vessel_nr)
			//					 
			
			end if
		next
	end if
end if
//insert delete attachment log
ldt_today = datetime(string(today(),'yyyy-mm-dd hh:mm:ss'))

//add port detail history
ds_vessel_detail_history = create mt_n_datastore
ds_vessel_detail_history.dataobject = 'd_sq_gr_vessels_detail_history'
ds_vessel_detail_history.settransobject(sqlca)
ds_vessel_detail_history.reset()
if  tab_1.tabpage_details.uo_vessel_att.dw_file_listing.deletedcount( ) > 0 then
	 for i = 1 to tab_1.tabpage_details.uo_vessel_att.dw_file_listing.deletedcount( )
		ls_description = tab_1.tabpage_details.uo_vessel_att.dw_file_listing.getitemstring(i,'description',Delete!,True)
		wf_insert_vesseldetailhistory(ds_vessel_detail_history,ls_description,ls_description,ll_vessel_nr,ldt_today,'delete')
	 next
end if
if ds_vessel_detail_history.update() = 1 then
	
else
	rollback;
	return -1
end if

return 1
end event

event constructor;// override

if (uo_global.ii_user_profile < 3) and (uo_global.ii_access_level >= C#usergroup.#USER) then	
   ib_allow_dragdrop = true
else
	ib_allow_dragdrop = false
end if


super::event constructor( )
end event

event ue_retrievefilelist;// Overrided

long li_row,ll_vessel_nr

li_row = dw_list.getselectedrow(0)
if li_row > 0 then
	ll_vessel_nr = dw_list.GetItemNumber(li_row, "vessel_nr")
	return adw_file_listing.Retrieve(ll_vessel_nr)
end if

return c#return.Failure
end event

event ue_postupdateattach;// override

if  ai_returncode = c#return.SUCCESS then
	COMMIT;
else
	rollback;
end if

call super::ue_postupdateattach
end event

type tabpage_9 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3401
integer height = 2008
long backcolor = 67108864
string text = "Details Log"
long picturemaskcolor = 536870912
dw_details_log_desc dw_details_log_desc
dw_details_log_query dw_details_log_query
end type

on tabpage_9.create
this.dw_details_log_desc=create dw_details_log_desc
this.dw_details_log_query=create dw_details_log_query
this.Control[]={this.dw_details_log_desc,&
this.dw_details_log_query}
end on

on tabpage_9.destroy
destroy(this.dw_details_log_desc)
destroy(this.dw_details_log_query)
end on

type dw_details_log_desc from mt_u_datawindow within tabpage_9
integer x = 9
integer y = 776
integer width = 3374
integer height = 1216
integer taborder = 30
string dataobject = "d_sq_ff_vessels_detail_history_desc"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dw_details_log_query from u_datagrid within tabpage_9
integer x = 9
integer y = 16
integer width = 3374
integer height = 752
integer taborder = 20
string dataobject = "d_sq_gr_vessels_detail_history_query"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event rowfocuschanged;call super::rowfocuschanged;DEC ldc_no
dw_details_log_desc.reset()
if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	ldc_no = this.getitemdecimal(currentrow,'c_no')
	
	dw_details_log_desc.retrieve(ldc_no)
end if
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3401
integer height = 2008
long backcolor = 67108864
string text = "Financial  "
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_brostrommt dw_brostrommt
dw_2 dw_2
end type

on tabpage_2.create
this.dw_brostrommt=create dw_brostrommt
this.dw_2=create dw_2
this.Control[]={this.dw_brostrommt,&
this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_brostrommt)
destroy(this.dw_2)
end on

type dw_brostrommt from datawindow within tabpage_2
integer x = 14
integer y = 1704
integer width = 3054
integer height = 304
integer taborder = 140
string title = "none"
string dataobject = "d_sq_tb_brostrom_mt_vessel"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_financialchanged = true
end event

type dw_2 from mt_u_datawindow within tabpage_2
string tag = "1"
integer x = 9
integer y = 20
integer width = 3131
integer height = 1560
integer taborder = 50
string dataobject = "d_vessel_finance"
boolean border = false
end type

event itemchanged;call super::itemchanged;ib_financialchanged = true
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3401
integer height = 2008
long backcolor = 67108864
string text = "Consumption  "
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_3 dw_3
uo_tperf uo_tperf
end type

on tabpage_3.create
this.dw_3=create dw_3
this.uo_tperf=create uo_tperf
this.Control[]={this.dw_3,&
this.uo_tperf}
end on

on tabpage_3.destroy
destroy(this.dw_3)
destroy(this.uo_tperf)
end on

type dw_3 from u_datagrid within tabpage_3
string tag = "1"
integer x = 23
integer y = 28
integer width = 3346
integer height = 1928
integer taborder = 50
string dataobject = "d_cal_cons"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event itemchanged;string ls_colname, ls_find, ls_cons_type
integer li_cons_type, li_zone_id
long ll_find

ls_colname = dwo.name
choose case ls_colname
	case "cal_cons_type"
		if long(data) = 9 or long(data) = 10 then
			if long(data) = 9 then
				ls_cons_type = 'Sailing - Idle'
			elseif long(data) = 10 then
				ls_cons_type = 'Sailing - Heating'
			end if
			messagebox('Information','Consumption type '+ls_cons_type+' is not allowed to select.')
			THIS.post setcolumn ('cal_cons_type')
			return 2
		end if
		if long(data) = 3 or long(data) = 4 or long(data) = 6 or long(data) = 7 or long(data) = 8 then
			this.object.cal_cons_speed[row] = 0
		end if
		this.object.cal_cons_sss[row] = 0
		this.object.cal_cons_meco[row] = 0
	case "zone_id"
		this.object.cal_cons_sss[row] = 0
		this.object.cal_cons_meco[row] = 0
	//For same consumption type and Zone only one row can be checked.
	case "cal_cons_sss", "cal_cons_meco"
		if data = '1' then
			li_cons_type = this.getitemnumber(row, "cal_cons_type")
			li_zone_id = this.getitemnumber(row,'zone_id')
			ls_find = "cal_cons_type = " + string(li_cons_type) + " and " + ls_colname + " = 1 and zone_id = " + string(li_zone_id)
			ll_find = this.find(ls_find, 1, this.rowcount())
			if ll_find > 0 then
				this.setitem(ll_find, ls_colname, 0)
			end if
		end if
	case 'cal_cons_active'
		if data = '1' then
			li_cons_type = this.getitemnumber(row,"cal_cons_type")
			if li_cons_type = 9 or li_cons_type = 10 then
				THIS.post setcolumn ('cal_cons_active')
				return 2
			end if
		end if
			
end choose
end event

event rowfocuschanged;if currentrow > 0 then
	this.setrow(currentrow)
	this.selectrow(0,false)
	this.selectrow(currentrow,true)
end if
end event

event clicked;call super::clicked;event rowfocuschanged(row)
end event

event dberror;/********************************************************************
   dberror
   <DESC>	Replace customized message with system message	</DESC>
   <RETURN>	long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		sqldbcode
		sqlerrtext
		sqlsyntax
		buffer
		row
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		04-09-2013	CR2658	LHG008	First Version
		25/03/16		CR4157	LHG008	Default Speed extended(Consumption type-zone-speed must be unique)
   </HISTORY>
********************************************************************/

choose case sqldbcode
	case 25061, 25062 //CAL_CONS_INSERT_TRIGGER/CAL_CONS_UPDATE_TRIGGER
		messagebox("Validation Error", "You cannot enter duplicate consumptions with the same consumption type, zone and speed.", StopSign!)
		
	case 25063 //CAL_CONS_UPDATE_TRIGGER
		messagebox("Validation Error", "You cannot update the consumption type, zone, speed, because it has been used.", StopSign!)

	case 25064 //CAL_CONS_DELETE_TRIGGER
		messagebox("Validation Error", "You cannot delete the consumption, because it has been used.", StopSign!)
		
	case else
		messagebox("Error", "Consumption Update failed.~r~nRC=" + String(sqldbcode) + "~r~n" + sqlerrtext, StopSign!)
end choose

return 1
end event

type uo_tperf from v_tperf_vessel_performance within tabpage_3
boolean visible = false
integer x = 2089
integer y = 8
integer width = 1280
integer height = 2032
integer taborder = 140
end type

on uo_tperf.destroy
call v_tperf_vessel_performance::destroy
end on

type tabpage_tank from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3401
integer height = 2008
long backcolor = 67108864
string text = "Tanks  "
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_tank_list dw_tank_list
gb_2 gb_2
dw_tank_summary dw_tank_summary
end type

on tabpage_tank.create
this.dw_tank_list=create dw_tank_list
this.gb_2=create gb_2
this.dw_tank_summary=create dw_tank_summary
this.Control[]={this.dw_tank_list,&
this.gb_2,&
this.dw_tank_summary}
end on

on tabpage_tank.destroy
destroy(this.dw_tank_list)
destroy(this.gb_2)
destroy(this.dw_tank_summary)
end on

type dw_tank_list from u_datagrid within tabpage_tank
string tag = "1"
integer x = 37
integer y = 32
integer width = 1970
integer height = 1944
integer taborder = 40
string dataobject = "d_sq_gr_vessel_tank"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
boolean ib_setselectrow = true
boolean ib_usectrl0 = true
boolean ib_editmaskselect = true
end type

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
end if
end event

event clicked;call super::clicked;long ll_row

if row > 0 then
	ll_row = this.getSelectedRow(0)
	
	if ll_row <> row then
		this.setrow(row)
		this.scrolltorow(row)
		if row = this.getrow() then this.event rowfocuschanged(row)
	end if
end if
end event

event itemchanged;if row < 1 then return
if this.of_itemchanged() = c#return.failure then return 2

if dwo.name = 'filling_limit' or dwo.name = 'tank_cap' then
	if  dec(data) < 0 then
		this.setitem( row, string(dwo.name),abs(dec(data))) 
		return 2
	end if
end if
end event

type gb_2 from groupbox within tabpage_tank
integer x = 2043
integer y = 8
integer width = 1326
integer height = 1972
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_tank_summary from u_datagrid within tabpage_tank
integer x = 2098
integer y = 44
integer width = 1262
integer height = 1912
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sq_gr_vessel_tank_summary"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_multicolumnsort = false
boolean ib_setselectrow = true
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3401
integer height = 2008
long backcolor = 67108864
string text = "Constraints  "
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from datawindow within tabpage_5
event ue_mousemove pbm_dwnmousemove
string tag = "1"
integer x = 37
integer y = 40
integer width = 2098
integer height = 1940
integer taborder = 40
string title = "none"
string dataobject = "d_vsl_cnstr"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;If dwo.name = "comments" Then
	if not isValid(w_comment) and not isNull(this.Object.vsl_cnstr_cmmnt[row]) then
	   in_comment.setComment(this.Object.vsl_cnstr_cmmnt[row])		
		in_comment.setX(pixelsToUnits(xpos, xPixelsToUnits!) + tab_1.x + parent.x + this.x)
		in_comment.setY(pixelsToUnits(ypos, yPixelsToUnits!) + tab_1.y + parent.y + this.y)
      openWithParm (w_popupHelp, in_comment, w_vessel)	
   end if
Else
   If isValid(w_popupHelp) Then
      close (w_popupHelp)
	End if
End if

return 0
end event

event clicked;IF row > 0 THEN
   this.selectRow(0,false)
   this.selectRow(row,true)
	this.scrollToRow(row)
END IF

If dwo.name = "comments" Then
   close (w_popupHelp)	
	in_comment.setComment(this.Object.vsl_cnstr_cmmnt[row])
   openWithParm (w_comment, in_comment, w_vessel)	
	in_comment = Message.PowerObjectParm
   if in_comment.getReturnCode() = 1 Then
		this.Object.vsl_cnstr_cmmnt[row] = in_comment.getComment()
	End if
Else
   If isValid(w_comment) Then
      close (w_comment)
	End if
End if

return 0
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3401
integer height = 2008
long backcolor = 67108864
string text = "Log"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_6.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_6.destroy
destroy(this.dw_6)
end on

type dw_6 from u_datagrid within tabpage_6
integer x = 9
integer y = 16
integer width = 3374
integer height = 1964
integer taborder = 110
string dataobject = "d_vessel_log"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3401
integer height = 2008
long backcolor = 67108864
string text = "Certificates"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_email cb_email
uo_att uo_att
end type

on tabpage_7.create
this.cb_email=create cb_email
this.uo_att=create uo_att
this.Control[]={this.cb_email,&
this.uo_att}
end on

on tabpage_7.destroy
destroy(this.cb_email)
destroy(this.uo_att)
end on

type cb_email from commandbutton within tabpage_7
integer x = 2610
integer y = 52
integer width = 393
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Send by Email"
end type

event clicked;long	ll_row
long	ll_vesselnr

if tab_1.tabpage_7.uo_att.dw_file_listing.rowcount( ) > 0 then
	ll_row = dw_list.getSelectedrow( 0 )
	if ll_row < 1 then return
	ll_vesselnr = dw_list.getItemNumber(ll_row, "vessel_nr")
	OpenWithParm( w_mailcertificates,ll_vesselnr)
end if 

end event

type uo_att from u_fileattach within tabpage_7
integer x = 9
integer width = 2546
integer height = 1980
integer taborder = 30
string is_dataobjectname = "d_vessel_certificates"
boolean ib_allow_dragdrop = true
boolean ib_allow_repeated_filenames = false
integer ii_buttonmode = 0
end type

on uo_att.destroy
call u_fileattach::destroy
end on

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3401
integer height = 2008
long backcolor = 67108864
string text = "Web Config"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_81 dw_81
dw_8 dw_8
end type

on tabpage_8.create
this.dw_81=create dw_81
this.dw_8=create dw_8
this.Control[]={this.dw_81,&
this.dw_8}
end on

on tabpage_8.destroy
destroy(this.dw_81)
destroy(this.dw_8)
end on

type dw_81 from datawindow within tabpage_8
event ue_keydown pbm_dwnkey
integer x = 9
integer y = 580
integer width = 3378
integer height = 1336
integer taborder = 130
string title = "none"
string dataobject = "d_vessel_webconfig"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;long ll_null

if key = KeyDelete! then
	setNull(ll_null)
	choose case this.getColumnName()
		case "iceclassid"
			this.setItem(this.getRow(), "iceclassid", ll_null)
		case "imo_id"
			this.setItem(this.getRow(), "imo_id", ll_null)
		end choose
end if
end event

event itemchanged;ib_webconfigchanged = true
end event

type dw_8 from datawindow within tabpage_8
integer x = 9
integer y = 44
integer width = 3392
integer height = 520
integer taborder = 30
string title = "none"
string dataobject = "d_vessel_detail_general"
boolean border = false
boolean livescroll = true
end type

event itemchanged;ib_webconfigchanged = true
end event

type cb_modifyvesselnumber from commandbutton within w_vessel
integer x = 1111
integer y = 2380
integer width = 686
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Modify Vessel Number"
end type

event clicked;string	ls_begin_tran 	= "begin transaction"
string ls_end_tran 		= "commit transaction"
string	ls_rollback 		= "rollback transaction"
n_vessel_modify		lnv_vessel
integer 					li_vessel_nr, li_new_vessel
long						ll_row
long  						ll_pc_row, ll_min, ll_max
string 					ls_find_vessel_nr, ls_pcname

wf_dwsetredraw(false)

if uf_updatespending(0) = -1 then 
	wf_dwsetredraw(true)
	return
end if
ll_row = dw_list.getSelectedrow( 0 )
if ll_row < 1 then 
	wf_dwsetredraw(true)
	return
end if

dw_list.EVENT Clicked(0, 0, dw_list.GetSelectedRow(0), dw_list.Object)

post wf_dwsetredraw(true)

// Retrieval argument for tabpages
li_vessel_nr = dw_list.getItemNumber(ll_row, "vessel_nr")

li_new_vessel = integer(f_get_string("Enter New Vessel Number", 5, "N", "", true))

If IsNull(li_New_Vessel) then Return

if MessageBox("Confirm modification", "Are You sure that you want to change Vessel number "+string(li_vessel_nr)+ " to "+string(li_new_vessel)+" ?"&
					+"~r~n~r~nPlease be aware that no re-posting will take place in CODA !", Question!, YesNo!, 2) = 2 then return

setPointer(hourGlass!)
lnv_vessel = create n_vessel_modify

EXECUTE IMMEDIATE :ls_begin_tran using sqlca;
if lnv_vessel.of_modifyvessel(li_vessel_nr, li_new_vessel) = 1 then
	destroy lnv_vessel
	EXECUTE IMMEDIATE :ls_end_tran using sqlca;
else
	destroy lnv_vessel
	EXECUTE IMMEDIATE :ls_rollback using sqlca;
end if
setPointer(arrow!)


ls_pcname =uo_pc.of_getpcname( )

IF il_pcnr = 999 THEN
	ll_min = -9999
	ll_max = 9999
ELSE	
	ll_min =uo_pc.of_getpc()
	ll_max = ll_min
END IF
	
dw_list.retrieve(ll_min, ll_max)		
IF tab_1.tabpage_1.dw_1.rowCount() > 0 THEN  //new or modified
	ls_find_vessel_nr = "vessel_nr = " + string(li_new_vessel)
	ll_row = dw_list.Find(ls_find_vessel_nr, 1, dw_list.rowCount() )
END IF
IF ll_row < 1 OR ll_row > dw_list.rowCount() THEN // delete
	ll_row = 1
END IF

// Triggers the Clicked-event of dw_list with the selected row
dw_list.EVENT Clicked(0, 0, ll_row, dw_list.object)

//IF rb_1.checked THEN
//   uo_search.of_setcolumn("vessel_nr", FALSE)	
//ELSE
//   uo_search.of_setcolumn("vessel_name",TRUE)	
//END IF

//Scroll to the selected row
ll_row = dw_list.getselectedrow(0)
IF NOT isNull(li_new_vessel) THEN
   ls_find_vessel_nr = "vessel_nr = " + string(li_new_vessel)
   ll_row = dw_list.Find(ls_find_vessel_nr, 1, dw_list.rowCount() ) 
END IF
dw_list.scrollToRow(ll_row)

//enable all tabpages
uf_enableTabPages(TRUE, 4, 8)

end event

type cb_newbuildings from commandbutton within w_vessel
integer x = 37
integer y = 2380
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "New &Buildings"
end type

event clicked;OpenSheet(w_new_buildings, w_tramos_main, 0, Original!)

end event

type uo_pc from u_pc within w_vessel
integer x = 37
integer y = 20
integer width = 1051
integer taborder = 100
boolean bringtotop = true
end type

on uo_pc.destroy
call u_pc::destroy
end on

type st_background from u_topbar_background within w_vessel
end type

