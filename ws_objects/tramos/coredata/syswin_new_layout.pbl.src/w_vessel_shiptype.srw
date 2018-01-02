$PBExportHeader$w_vessel_shiptype.srw
$PBExportComments$Maintainance of competitor vessel coredata
forward
global type w_vessel_shiptype from w_coredata_ancestor
end type
type tabpage_4 from userobject within tab_1
end type
type uo_specialfeatures from u_vesseltype_specialfeatures within tabpage_4
end type
type tabpage_4 from userobject within tab_1
uo_specialfeatures uo_specialfeatures
end type
type tabpage_2 from userobject within tab_1
end type
type cb_defaultportstay from mt_u_commandbutton within tabpage_2
end type
type dw_port_stay from u_datagrid within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_defaultportstay cb_defaultportstay
dw_port_stay dw_port_stay
end type
end forward

global type w_vessel_shiptype from w_coredata_ancestor
integer width = 3447
integer height = 1524
string title = "Ship Types"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
end type
global w_vessel_shiptype w_vessel_shiptype

type variables
boolean		ib_isnew
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
public function integer uf_updatespending ()
public subroutine uf_updatepicklist ()
private subroutine uf_insertiomsin ()
public subroutine uf_getspecialfeatures (integer al_shiptype_id)
public subroutine documentation ()
end prototypes

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

public function long uf_gui_control (integer arg_tabpage, string arg_command);if isnull(arg_tabpage) or arg_tabpage <= 0 or arg_tabpage > upperbound(tab_1.control) then return 1

if tab_1.control[arg_tabpage] = tab_1.tabpage_1 and arg_command="New" then
		cb_delete.enabled = False 
		cb_new.enabled = False 
		tab_1.tabpage_4.enabled = False
		tab_1.tabpage_2.enabled = False
	else		
		cb_delete.enabled = not (tab_1.control[arg_tabpage] = tab_1.tabpage_2 and (arg_command = "Cancel" or arg_command = "Update")) 
		cb_new.enabled = not (tab_1.control[arg_tabpage] = tab_1.tabpage_2 and (arg_command = "Cancel" or arg_command = "Update")) 
		tab_1.tabpage_4.enabled = True 	
		tab_1.tabpage_2.enabled = True
end if

Return 1

end function

public subroutine uf_enabletabpages (boolean arg_enable, integer arg_first_tab, integer arg_last_tab);

end subroutine

public function integer uf_validategeneral ();string ls_shiptype_name
string	ls_errormessage

ls_errormessage = "Please fill in mandatory fields!"

tab_1.tabpage_1.dw_1.Accepttext()

ls_shiptype_name = tab_1.tabpage_1.dw_1.GetItemString(1,"cal_vest_type_name")
If IsNull(ls_shiptype_name) Or (trim(ls_shiptype_name) = "") Then
	MessageBox("Validation Error", "Please enter a ship type name")
	tab_1.tabpage_1.dw_1.post setFocus()
	return -1
end if

if isnull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_drc")) then
	MessageBox("Validation Error", ls_errormessage)
	return -1
end if

if isnull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_oa")) then
	MessageBox("Validation Error", ls_errormessage)
	return -1
end if

if isnull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_cap")) then
	MessageBox("Validation Error", ls_errormessage)
	return -1
end if

if isnull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_tc")) then
	MessageBox("Validation Error", ls_errormessage)
	return -1
end if

if isnull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_vest_budget_comm")) then
	MessageBox("Validation Error", ls_errormessage)
	return -1
end if

if isnull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_fo_price")) then
	MessageBox("Validation Error", ls_errormessage)
	return -1
end if

if isnull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_do_price")) then
	MessageBox("Validation Error", ls_errormessage)
	return -1
end if

if isnull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_mgo_price")) then
	MessageBox("Validation Error", ls_errormessage)
	return -1
end if

if isnull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_lsfo_price")) then
	MessageBox("Validation Error", ls_errormessage)
	return -1
end if

if isnull(tab_1.tabpage_1.dw_1.GetItemNumber(1,"cal_sdwt")) then
	MessageBox("Validation Error", ls_errormessage)
	return -1
end if

return 1
end function

public function integer uf_updatespending ();long ll_anyModifications = 0

tab_1.tabpage_1.dw_1.acceptText()
tab_1.tabpage_2.dw_port_stay.acceptText()
tab_1.tabpage_4.uo_specialfeatures.dw_specialfeatures.accepttext( )

ll_anymodifications = tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount()

ll_anymodifications += tab_1.tabpage_2.dw_port_stay.modifiedCount() + tab_1.tabpage_2.dw_port_stay.deletedCount()

ll_anymodifications += tab_1.tabpage_4.uo_specialfeatures.dw_specialfeatures.modifiedCount() + tab_1.tabpage_4.uo_specialfeatures.dw_specialfeatures.deletedCount()

if ll_anymodifications > 0 then
	if MessageBox("Updates pending", "Data modified but not saved.~r~nWould you like to update changes?",Question!,YesNo!,1)=1 then
		return -1
	else
		tab_1.tabpage_1.dw_1.reset()
		tab_1.tabpage_2.dw_port_stay.reset()
		tab_1.tabpage_4.uo_specialfeatures.dw_specialfeatures.reset( )
		return 0
	end if
end if

return 0
end function

public subroutine uf_updatepicklist ();integer li_vessel_nr
long ll_row, ll_rc, ll_pc_row, ll_min, ll_max
string ls_find_vessel_nr, ls_pcname
datawindowchild ldwc

ll_row = dw_list.getSelectedRow(0)

if tab_1.tabpage_1.dw_1.rowCount() > 0 then
	li_vessel_nr = tab_1.tabpage_1.dw_1.GetItemNumber(tab_1.tabpage_1.dw_1.getRow(), "cal_vest_type_id")
else
	setNull(li_vessel_nr)
end if

IF (tab_1.SelectedTab = 1) THEN
	IF tab_1.tabpage_1.dw_1.rowCount() > 0 THEN  //new or modified
	   tab_1.tabpage_1.dw_1.accepttext()
	   ls_find_vessel_nr = "cal_vest_type_id = " + string(li_vessel_nr)
	   ll_row = dw_list.Find(ls_find_vessel_nr, 1, dw_list.rowCount() )
	END IF
	IF ll_row < 1 OR ll_row > dw_list.rowCount() THEN // delete
   	ll_row = 1
	END IF
END IF

// Triggers the Clicked-event of dw_list with the selected row

dw_list.EVENT Clicked(0, 0, ll_row, dw_list.object.cal_vest_type_name)

//Scroll to the selected row
ll_row = dw_list.getRow()
IF NOT isNull(li_vessel_nr) THEN
   ls_find_vessel_nr = "cal_vest_type_id = " + string(li_vessel_nr)
   ll_row = dw_list.Find(ls_find_vessel_nr, 1, dw_list.rowCount() ) 
END IF
dw_list.scrollToRow(ll_row)
end subroutine

private subroutine uf_insertiomsin ();//checks if conditions for inserting a row on retrieval are present
////if tab_1.tabpage_2.dw_iomsin.rowcount() > 0 then return
////
////if not isnull(tab_1.tabpage_1.dw_1.getItemNumber(1, "tcowner_nr")) and tab_1.tabpage_1.dw_1.getItemNumber(1, "apm_owned_vessel")=1 then
////	tab_1.tabpage_2.dw_iomsin.insertRow(0)
////end if
////
end subroutine

public subroutine uf_getspecialfeatures (integer al_shiptype_id);if tab_1.tabpage_4.uo_specialfeatures.of_getlist(al_shiptype_id) <> 1 then
	MessageBox("Error", "Error getting special features")
end if

tab_1.tabpage_4.uo_specialfeatures.il_vesseltypeid = al_shiptype_id
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_vessel_shiptype
	
   <OBJECT></DESC>
   <USAGE>   </USAGE>
   <ALSO></ALSO>
    	Date   	Ref		Author		Comments
  	00/00/07	?      		Name Here	First Version
  	13/01/11	CR 2197		JMC112		Delete dataobject of dw_dddw because is not used
	10/17/11 CR 2535		LHC010		Add port stay
	09/03/12	CR2536,2535	JMC112		Make Laden and Ballaste speed mandatory
	12/03/13	CR2658		LHG008		Change consumption type, UI of consumption tab and add new column zone.
	12/08/14	CR3708  		AGL027		F1 help application coverage - corrected ancestor
	28/08/14	CR3781		CCY018		The window title match with the text of a menu item
	10/06/15	CR3998		CCY018		Add two columns Updated By and Updated At to every consumption type row.
	24/12/15 CR3250		CCY018		Add lsfo column.
	25/03/16	CR4157		LHG008		Default Speed extended(Remove consumption tab)
********************************************************************/
end subroutine

on w_vessel_shiptype.create
int iCurrent
call super::create
end on

on w_vessel_shiptype.destroy
call super::destroy
end on

event open;call super::open;datawindowchild ldwc
long ll_row, ll_rows
long ll_drc, ll_oa,ll_cap,ll_tc,ll_fo, ll_do, ll_mgo, ll_budget_comm
integer li_vessel
string ls_search_string
n_service_manager 	lnv_SM
n_dw_Style_Service  	lnv_dwStyle

lnv_SM.of_loadservice( lnv_dwStyle, "n_dw_style_service")
lnv_dwStyle.of_dwlistformater(dw_list)
lnv_dwStyle.of_dwlistformater(tab_1.tabpage_2.dw_port_stay)
lnv_dwStyle.of_dwlistformater(tab_1.tabpage_4.uo_specialfeatures.dw_specialfeatures)

lnv_dwStyle.of_registercolumn("cal_vest_type_name", true)
lnv_dwStyle.of_registercolumn("cal_drc", true)
lnv_dwStyle.of_registercolumn("cal_oa", true)
lnv_dwStyle.of_registercolumn("cal_cap", true)
lnv_dwStyle.of_registercolumn("cal_tc", true)
lnv_dwStyle.of_registercolumn("cal_vest_budget_comm", true)
lnv_dwStyle.of_registercolumn("cal_fo_price", true)
lnv_dwStyle.of_registercolumn("cal_do_price", true)
lnv_dwStyle.of_registercolumn("cal_mgo_price", true)
lnv_dwStyle.of_registercolumn("cal_lsfo_price",true)
lnv_dwStyle.of_registercolumn("cal_sdwt", true)
lnv_dwStyle.of_dwformformater(tab_1.tabpage_1.dw_1)

if ib_setdefaultbackgroundcolor then _setbackgroundcolor()

lnv_dwStyle.of_registercolumn("cal_cons_type", true)
lnv_dwStyle.of_registercolumn("zone_id", true)

ib_isnew=false

dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
tab_1.tabpage_2.dw_port_stay.setTransObject(SQLCA)

// If external APM, only read access to attached profitcenter vessels
if uo_global.ii_access_level = -1 then
	cb_new.enabled = false
	cb_update.enabled = false
	cb_delete.enabled = false
	cb_cancel.enabled = false
	tab_1.tabpage_2.cb_defaultportstay.enabled = false
	tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly="Yes"
	tab_1.tabpage_2.dw_port_stay.Object.DataWindow.ReadOnly="Yes"
end if

// Retrieve vessel list
IF dw_list.retrieve() = 0 THEN
	Messagebox("Message", "No ship types to be shown.")
ELSE
	if isnull(Message.StringParm) or Message.StringParm="" then 
		ll_row=1
	else
		ll_row=dw_list.find("cal_vest_type_name='"+Message.StringParm + "'",1,dw_list.rowcount())
		if ll_row<1 then ll_row=1
	end if	
END IF

dw_list.SetSort("cal_vest_type_name")
dw_list.Sort()
dw_list.event Clicked(0,0,ll_row,dw_list.object.cal_vest_type_name)
dw_list.scrolltorow( ll_row)

// Init searchbox
uo_SearchBox.of_Initialize(dw_List, "cal_vest_type_name")
uo_SearchBox.sle_Search.SetFocus()

end event

event closequery;call super::closequery;if uf_updatesPending() = -1 then
	// prevent
	return 1
else
	//allow
	RETURN 0
end if
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_vessel_shiptype
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_vessel_shiptype
integer y = 16
end type

type st_1 from w_coredata_ancestor`st_1 within w_vessel_shiptype
boolean visible = false
integer x = 841
integer y = 80
string text = "Profit Center:"
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_vessel_shiptype
boolean visible = false
integer x = 841
integer y = 144
integer taborder = 100
boolean livescroll = false
end type

event dw_dddw::itemerror;call super::itemerror;return 1
end event

type dw_list from w_coredata_ancestor`dw_list within w_vessel_shiptype
integer y = 272
integer height = 1136
integer taborder = 120
string dataobject = "d_vessel_picklist_shiptype"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_list::clicked;integer li_count
long ll_rows, ll_x, ll_shiptype_id, ll_row
string	ls_find_vessel_nr

datawindowchild	ldwc

// Call ancestor Clicked event to perform sorting
Super::Event Clicked(xpos, ypos, row, dwo)

if uf_updatespending() = -1 then return

parent.uf_gui_control(tab_1.selectedtab,"Cancel")

if row < 1 then return
setPointer(hourGlass!)

// Retrieval argument for tabpages

dw_list.selectRow(0,false)
dw_list.selectRow(row,true)

//Retrieve tabpages
ll_shiptype_id = dw_list.getItemNumber(row, "cal_vest_type_id")
tab_1.tabpage_1.dw_1.POST Retrieve(ll_shiptype_id)
tab_1.tabpage_2.dw_port_stay.POST Retrieve(ll_shiptype_id)

POST uf_getspecialfeatures(ll_shiptype_id) 

SetPointer(Arrow!)
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;
//If currentrow>0 Then This.event clicked(0, 0, currentrow, This.Object)

end event

type cb_close from w_coredata_ancestor`cb_close within w_vessel_shiptype
boolean visible = false
integer x = 1554
integer y = 1312
integer width = 343
integer height = 100
integer taborder = 90
end type

event cb_close::clicked;call super::clicked;close(parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_vessel_shiptype
integer x = 3072
integer y = 1312
integer width = 343
integer height = 100
integer taborder = 80
end type

event cb_cancel::clicked;call super::clicked;uf_gui_control(tab_1.selectedTab, "Cancel")

datawindow ldw_d
if tab_1.control[tab_1.selectedtab] = tab_1.tabpage_4 then
	tab_1.tabpage_4.uo_specialfeatures.dw_specialfeatures.reset() 
else 
	ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab], 1)
	ldw_d.reset()
end if

dw_list.EVENT POST Clicked(0, 0, dw_list.GetSelectedRow(0), dw_list.object.cal_vest_type_name)



end event

type cb_delete from w_coredata_ancestor`cb_delete within w_vessel_shiptype
integer x = 2725
integer y = 1312
integer width = 343
integer height = 100
integer taborder = 70
end type

event cb_delete::clicked;long ll_response, ll_rc, ll_update, ll_row, ll_rowCount, ll_selectedrow, ll_shiptype_id
dataWindow ldw_d
long ll_currentrow

ll_currentrow = dw_list.getSelectedRow(0)

uf_gui_control(tab_1.selectedTab, "Delete")

ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab], 1)

// Deleting selected row depending on the selected tabpage (the general page or any other page)
CHOOSE CASE tab_1.control[tab_1.selectedtab]
    CASE tab_1.tabpage_1    //Free form
      ll_response = Messagebox("Deleting!","You are about to delete a ship type and all information connected to it. ~r~n" + & 
                               "Do you wish to continue?", Question!, YesNo!, 2)
		IF ll_response = 1 THEN
			
			ll_shiptype_id=tab_1.tabpage_1.dw_1.GetItemNumber(tab_1.tabpage_1.dw_1.getrow(),"cal_vest_type_id")
			
			DELETE FROM CAL_VEST_SFEATURES 
			WHERE CAL_VEST_SFEATURES.CAL_VEST_TYPE_ID = :ll_shiptype_id;
			
			DELETE FROM CAL_CONS  
			WHERE CAL_CONS.CAL_VEST_TYPE_ID = :ll_shiptype_id;
			
			DELETE FROM CAL_VEST_PORTSTAY
			WHERE CAL_VEST_PORTSTAY.CAL_VEST_TYPE_ID = :ll_shiptype_id;
			
			if sqlca.sqlcode <> 0 then 
				rollback;
				return
			end if
			
			ll_rc = tab_1.tabpage_1.dw_1.deleterow(tab_1.tabpage_1.dw_1.getrow())
			if ll_rc > 0 then ll_rc = tab_1.tabpage_1.dw_1.update()
			IF ll_rc < 0 THEN
				rollback;
				Messagebox("Error","Update not done. This could be due to data on tabpage # ~r~n" + &
							  string(tab_1.selectedTab) + " being used other places in the system or database error.~r~n~r~n")
				tab_1.tabpage_1.dw_1.retrieve(dw_list.getItemNumber(ll_currentrow, "cal_vest_type_id"))
				return
			ELSE
				commit;
				
				dw_list.deleterow(ll_currentrow)
				
				IF ll_currentrow>dw_list.ROWcount( ) THEN ll_currentrow=dw_list.ROWcount( )
				
				uf_updatepicklist()
				dw_list.Sort()
				dw_list.event Clicked(0, 0, ll_currentrow, dw_list.object.cal_vest_type_name)
				dw_list.scrollToRow(ll_currentrow)
			END IF
		END IF
	CASE tab_1.tabpage_4
		tab_1.tabpage_4.uo_specialfeatures.of_deleteitem( )
END CHOOSE
end event

type cb_new from w_coredata_ancestor`cb_new within w_vessel_shiptype
integer x = 2030
integer y = 1312
integer width = 343
integer height = 100
integer taborder = 50
end type

event cb_new::clicked;long ll_row
integer li_pc
datawindow ldw_d
datawindowchild ldwc

uf_gui_control(tab_1.selectedtab, "New")

choose case tab_1.control[tab_1.selectedtab]
	case tab_1.tabpage_1
		if uf_updatespending() = -1 then return
		
		ib_isnew = true
		
		ldw_d = uf_getdatawindow(tab_1.control[tab_1.selectedtab])
		
		ldw_d.reset()
		ll_row = ldw_d.insertrow(0)
		
		ldw_d.scrolltorow(ll_row)
		ldw_d.post setfocus()
		ldw_d.post setcolumn("cal_vest_type_name")	
	case tab_1.tabpage_4
		tab_1.tabpage_4.uo_specialfeatures.of_additem( )
end choose

end event

type cb_update from w_coredata_ancestor`cb_update within w_vessel_shiptype
integer x = 2377
integer y = 1312
integer width = 343
integer height = 100
integer taborder = 60
end type

event cb_update::clicked;long ll_rc, ll_shiptype_id, ll_row
long ll_tabpage, ll_picklist_row
string ls_shiptype_desc
integer li_shiptype_id

dataWindow ldw_d

datawindowchild ldwc

ll_row = tab_1.tabpage_1.dw_1.GetRow()

//General - Update all tabpages
tab_1.tabpage_1.dw_1.acceptText()

if uf_validategeneral() = -1 then return

uf_gui_control(tab_1.selectedTab, "Update")

ll_rc = tab_1.tabpage_1.dw_1.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Rollback;
	Messagebox("Error message; "+ this.ClassName(), "General Update failed~r~nRC=" + String(ll_rc))
	return -1
END IF

ll_shiptype_id=tab_1.tabpage_1.dw_1.GetItemNumber(ll_row,"cal_vest_type_id")
ls_shiptype_desc=tab_1.tabpage_1.dw_1.GetItemString(ll_row,"cal_vest_type_name")

if ib_isnew then
	ll_row = dw_list.insertRow(0)
	dw_list.setitem(ll_row,"cal_vest_type_id",ll_shiptype_id)
	dw_list.setitem(ll_row,"cal_vest_type_name",ls_shiptype_desc)
	ib_isnew=false
else
	// updated name perhaps??
	ll_row=dw_list.getselectedrow(0)
	dw_list.setitem(ll_row,"cal_vest_type_name",ls_shiptype_desc)
end if

ll_rc = tab_1.tabpage_2.dw_port_stay.update(true, false)
IF ll_rc < 0 THEN
	Rollback;
	Messagebox("Error message; "+ this.ClassName(), "Port Stay  Update failed~r~nRC=" + String(ll_rc))
	return -1
END IF

tab_1.tabpage_4.uo_specialfeatures.dw_specialfeatures.update(TRUE, FALSE)

tab_1.tabpage_1.dw_1.resetUpdate()
tab_1.tabpage_2.dw_port_stay.resetUpdate()
tab_1.tabpage_4.uo_specialfeatures.dw_specialfeatures.resetUpdate()
COMMIT;

// Update picklist
uf_updatePicklist()

RETURN 1
end event

type st_list from w_coredata_ancestor`st_list within w_vessel_shiptype
integer y = 208
integer weight = 400
string text = "Ship Types:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_vessel_shiptype
integer x = 1061
integer width = 2350
integer height = 1248
integer taborder = 10
integer weight = 400
boolean multiline = true
tabpage_4 tabpage_4
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_4=create tabpage_4
this.tabpage_2=create tabpage_2
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_4
this.Control[iCurrent+2]=this.tabpage_2
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_4)
destroy(this.tabpage_2)
end on

event tab_1::selectionchanged;CHOOSE CASE tab_1.control[newindex]
	CASE tab_1.tabpage_2
		cb_new.enabled = false
		cb_delete.enabled = false	
END CHOOSE

if oldindex > 0 then
	CHOOSE CASE tab_1.control[oldindex]
		CASE tab_1.tabpage_2
			cb_new.enabled = true
			cb_delete.enabled = true
	END CHOOSE
end if
end event

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer width = 2313
integer height = 1132
end type

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
event ue_keydown pbm_dwnkey
event type boolean ue_usedefaultbackgroundcolor ( )
string tag = "1"
integer x = 18
integer y = 24
integer width = 2286
integer height = 1088
string dataobject = "d_vessel_detail_shiptype"
borderstyle borderstyle = stylebox!
end type

event dw_1::ue_keydown;long ll_null

if key = KeyDelete! then
	setNull(ll_null)
	choose case this.getColumnName()
		case "tcowner_nr" 
			this.setItem(this.getRow(), "tcowner_nr", ll_null)
		case "cal_vest_type_id" 
			this.setItem(this.getRow(), "cal_vest_type_id", ll_null)
	end choose
end if
	
end event

event type boolean dw_1::ue_usedefaultbackgroundcolor();return true

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2313
integer height = 1132
long backcolor = 67108864
string text = "Special Features"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
uo_specialfeatures uo_specialfeatures
end type

on tabpage_4.create
this.uo_specialfeatures=create uo_specialfeatures
this.Control[]={this.uo_specialfeatures}
end on

on tabpage_4.destroy
destroy(this.uo_specialfeatures)
end on

type uo_specialfeatures from u_vesseltype_specialfeatures within tabpage_4
integer y = 8
integer width = 2304
integer height = 1088
integer taborder = 110
end type

on uo_specialfeatures.destroy
call u_vesseltype_specialfeatures::destroy
end on

event constructor;call super::constructor;this.dw_specialfeatures.border = false

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2313
integer height = 1132
long backcolor = 67108864
string text = "Port Stay"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_defaultportstay cb_defaultportstay
dw_port_stay dw_port_stay
end type

on tabpage_2.create
this.cb_defaultportstay=create cb_defaultportstay
this.dw_port_stay=create dw_port_stay
this.Control[]={this.cb_defaultportstay,&
this.dw_port_stay}
end on

on tabpage_2.destroy
destroy(this.cb_defaultportstay)
destroy(this.dw_port_stay)
end on

type cb_defaultportstay from mt_u_commandbutton within tabpage_2
integer x = 1614
integer y = 24
integer width = 686
integer taborder = 20
string text = "&Set Default Port Stay"
end type

event clicked;call super::clicked;if tab_1.tabpage_2.dw_port_stay.rowcount() > 0 then
	tab_1.tabpage_2.dw_port_stay.object.port_stay.primary = tab_1.tabpage_2.dw_port_stay.object.purpose_portstay.primary
end if

end event

type dw_port_stay from u_datagrid within tabpage_2
integer x = 18
integer y = 24
integer width = 1559
integer height = 1088
integer taborder = 110
string dataobject = "d_sq_tb_shiptype_portstay"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;IF row > 0 THEN
   this.selectRow(0,false)
	this.setrow( row )
	this.scrolltorow( row )
   this.selectRow(row,true)
END IF
end event

event itemfocuschanged;call super::itemfocuschanged;if dwo.name ='port_stay' then
	 this.post selecttext(1,7) 
end if
end event

