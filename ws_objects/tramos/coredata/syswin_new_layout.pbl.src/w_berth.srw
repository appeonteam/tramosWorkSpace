$PBExportHeader$w_berth.srw
$PBExportComments$Maintainance of vessel coredata
forward
global type w_berth from w_coredata_ancestor
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_4 dw_4
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
end forward

global type w_berth from w_coredata_ancestor
integer width = 4535
integer height = 2100
string title = "Berths"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
end type
global w_berth w_berth

type variables
n_comment	in_comment
integer		ii_max_no_of_tanks = 18

end variables

forward prototypes
public function datawindow uf_getdatawindow (userobject arg_object, integer arg_dw_no)
public function datawindow uf_getdatawindow (userobject arg_object)
public subroutine uf_enabletabpages (boolean arg_enable, integer arg_first_tab, integer arg_last_tab)
public function long uf_gui_control (integer arg_tabpage, string arg_command)
public subroutine uf_updatepicklist ()
public function integer uf_updatespending ()
public function integer uf_validategeneral ()
public function integer uf_deleteberth (integer al_row)
end prototypes

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

public subroutine uf_enabletabpages (boolean arg_enable, integer arg_first_tab, integer arg_last_tab);long ll_index

FOR ll_index = arg_first_tab TO arg_last_tab
	   tab_1.Control[ll_index].enabled = arg_enable
NEXT


end subroutine

public function long uf_gui_control (integer arg_tabpage, string arg_command);DataWindow ldw_d
long ll_rc

Choose case arg_tabpage
	Case 1
		Choose case arg_command
			Case "New"
				   uf_enableTabPages(FALSE, 2, 5)
			Case "Delete"
			Case "Update"
			Case "Cancel"
               uf_enableTabPages(TRUE, 2, 5)
			Case "Tab"
		End choose
End choose

Return 1

end function

public subroutine uf_updatepicklist ();double ld_berthID
long ll_row, ll_rc, ll_port_row,ll_GetRow
string ls_find_berth, ls_portname, ls_min, ls_max
datawindowchild ldwc

ll_row = dw_list.getSelectedRow(0)
if tab_1.tabpage_1.dw_1.rowCount() > 0 then
	ld_berthID = tab_1.tabpage_1.dw_1.GetItemNumber(tab_1.tabpage_1.dw_1.getRow(), "berth_id")
else
	setNull(ld_berthID)
end if

IF (tab_1.SelectedTab = 1 ) THEN
//
	ls_portname = dw_dddw.getItemString(dw_dddw.getRow(), "port_n")
	IF ls_portname = "<All>" THEN
		ls_min = "000"
		ls_max = "ÅÅÅ"
	ELSE	
		dw_dddw.getChild("port_n", ldwc)
		ll_port_row = ldwc.find("port_n='"+ls_portname+"'",1, 99999)
		ls_min = ldwc.getItemString(ll_port_row, "port_code")
		ls_max = ls_min
	END IF
	
//
	dw_list.retrieve(ls_min, ls_max)		
	IF tab_1.tabpage_1.dw_1.rowCount() > 0 THEN  //new or modified
	   tab_1.tabpage_1.dw_1.accepttext()
	   tab_1.tabpage_2.dw_2.accepttext()
	   ls_find_berth = "berth_id = " + string(ld_berthID)
	   ll_row = dw_list.Find(ls_find_berth, 1, dw_list.rowCount() )
	END IF
	IF ll_row < 1 OR ll_row > dw_list.rowCount() THEN // delete
   	ll_row = 1
	END IF
END IF



ll_GetRow = dw_list.Find("berth_id = " + string(ld_berthID), 1, dw_list.rowCount() ) 

If ll_GetRow = 0 then  // In case unable to find due to filter, remove filter and find again
	uo_searchbox.cb_clear.event clicked( )
	ll_GetRow = dw_list.Find("berth_id = " + string(ld_berthID), 1, dw_list.rowCount() ) 
End If

// Triggers the Clicked-event of dw_list with the selected row
dw_list.EVENT Clicked(0, 0, ll_GetRow, dw_list.object)

//Scroll to the selected row
//ll_row = dw_list.getRow()
//IF NOT isNull(ld_berthID) THEN
//   ls_find_berth = "berth_id = " + string(ld_berthID)
//   ll_row = dw_list.Find(ls_find_berth, 1, dw_list.rowCount() ) 
//END IF

dw_list.scrollToRow(ll_GetRow)

//enable all tabpages
uf_enableTabPages(TRUE, 2, 5)

end subroutine

public function integer uf_updatespending ();long ll_anyModifications = 0

tab_1.tabpage_1.dw_1.acceptText()
tab_1.tabpage_2.dw_2.acceptText()
tab_1.tabpage_3.dw_3.acceptText()
tab_1.tabpage_4.dw_4.acceptText()
tab_1.tabpage_5.dw_5.acceptText()

ll_anymodifications = tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount()
ll_anymodifications += tab_1.tabpage_2.dw_2.modifiedCount() + tab_1.tabpage_2.dw_2.deletedCount()
ll_anymodifications += tab_1.tabpage_3.dw_3.modifiedCount() + tab_1.tabpage_3.dw_3.deletedCount()
ll_anymodifications += tab_1.tabpage_4.dw_4.modifiedCount() + tab_1.tabpage_4.dw_4.deletedCount()
ll_anymodifications += tab_1.tabpage_5.dw_5.modifiedCount() + tab_1.tabpage_5.dw_5.deletedCount()

if ll_anymodifications > 0 then
	if MessageBox("Updates pending", "Data modified but not saved.~r~nWould you like to update changes?",Question!,YesNo!,1)=1 then
		return -1
	else
		tab_1.tabpage_1.dw_1.reset()
		tab_1.tabpage_2.dw_2.reset()
		tab_1.tabpage_3.dw_3.reset()
		tab_1.tabpage_4.dw_4.reset()
		tab_1.tabpage_5.dw_5.reset()		
		return 0
	end if
end if

return 0
end function

public function integer uf_validategeneral ();tab_1.tabpage_1.dw_1.Accepttext()
	
if isnull(tab_1.tabpage_1.dw_1.object.berth_type[1]) then
	MessageBox("Error","You must enter a berth type")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("berth_type")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

if isnull(tab_1.tabpage_1.dw_1.object.berth_name[1]) then
	MessageBox("Error","You must enter a berth name")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("berth_name")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

if isnull(tab_1.tabpage_1.dw_1.object.port_code[1]) then
	MessageBox("Error","You must select a port")
	tab_1.post selectTab(1)
	tab_1.tabpage_1.dw_1.post setColumn("port_code")
	tab_1.tabpage_1.dw_1.post setFocus()
	Return -1
end if

return 1
end function

public function integer uf_deleteberth (integer al_row);double ld_berthID

ld_berthID = dw_list.getItemNumber(al_row, "berth_id")

DELETE   
	FROM BERTH_ILL_LAST3_GRADE  
	WHERE BERTH_ID  = :ld_berthID;
if sqlca.sqlcode <> 0 then return -1
	
DELETE   
	FROM BERTH_COND_GRADE  
	WHERE BERTH_ID  = :ld_berthID;
if sqlca.sqlcode <> 0 then return -1

DELETE   
	FROM BERTH_CNSTR  
	WHERE BERTH_ID  = :ld_berthID;
if sqlca.sqlcode <> 0 then return -1

DELETE   
	FROM BERTH_AVAIL_GRADE  
	WHERE BERTH_ID  = :ld_berthID;
if sqlca.sqlcode <> 0 then return -1

return 1
end function

on w_berth.create
int iCurrent
call super::create
end on

on w_berth.destroy
call super::destroy
end on

event open;call super::open;datawindowchild ldwc
long ll_row, ll_selected_row
double ld_berthID
string ls_max, ls_min, ls_berth_portcode, ls_selected_portname

ld_berthID = message.doubleparm

in_comment = create n_comment 

dw_dddw.setTransObject(SQLCA)
dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
tab_1.tabpage_2.dw_2.setTransObject(SQLCA)
tab_1.tabpage_3.dw_3.setTransObject(SQLCA)
tab_1.tabpage_4.dw_4.setTransObject(SQLCA)
tab_1.tabpage_5.dw_5.setTransObject(SQLCA)

// retrieve Ports, insert <All> in dw and dddw and select IT
if dw_dddw.retrieve()=0 then 
	Messagebox("Message", "Retrieve Port went wrong. Contact Administrator")
	return
end if
dw_dddw.getChild("port_n", ldwc)
ll_row = ldwc.insertRow(1)
ldwc.setItem(ll_row, "port_n", "<All>")
ldwc.setItem(ll_row, "port_code", "xxxxxx")
ll_row = dw_dddw.insertRow(1)
dw_dddw.object.port_n[ll_row] = "<All>"
dw_dddw.object.port_code[ll_row] = "xxxxxx"
dw_dddw.setRow(1)
	
if isNull(ld_berthID) then
	// opened from menu. no berth selected
	ls_min = "000"
	ls_max = "ÅÅÅ"
	ll_selected_row = 1
	// Triggers the Clickedevent of dw_list
	IF dw_list.retrieve(ls_min, ls_max) = 0 THEN
		Messagebox("Message", "No Berths to be shown.")
	ELSE
		dw_list.event Clicked(0,0,ll_selected_row,dw_list.object)
	END IF
else
	// opened from port. bertid selected
	SELECT BERTH.PORT_CODE  
		INTO :ls_berth_portcode  
		FROM BERTH  
		WHERE BERTH.BERTH_ID = :ld_berthID;
	if sqlca.sqlcode < 0 then 
		MessageBox("Error", "Berth not found!")
		post close(this)
		return
	end if
	// set retrieval arg.
	ls_min = ls_berth_portcode
	ls_max = ls_min
	// Set portlist Port
	dw_dddw.getChild("port_n", ldwc)
	ll_selected_row = ldwc.find("port_code='"+ls_berth_portcode+"'",1,99999)
	ls_selected_portname = ldwc.getItemString(ll_selected_row, "port_n")
	dw_dddw.setItem(dw_dddw.getRow(), "port_n", ls_selected_portname)
	//retrive 
	dw_list.retrieve(ls_min, ls_max)
	// find berth
	ll_selected_row = dw_list.find("berth_id="+string(ld_berthID),1,99999)
	dw_list.event Clicked(0,0,ll_selected_row,dw_list.object)
end if	

//If external APM, make readonly
If uo_global.ii_access_level = -1 then
	cb_new.enabled = False
	cb_update.enabled = False
	cb_delete.enabled = False
	cb_Cancel.Enabled = False
	tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly="Yes"
	tab_1.tabpage_2.dw_2.Object.DataWindow.ReadOnly="Yes"
	tab_1.tabpage_3.dw_3.Object.DataWindow.ReadOnly="Yes"
	tab_1.tabpage_4.dw_4.Object.DataWindow.ReadOnly="Yes"
	tab_1.tabpage_5.dw_5.Object.DataWindow.ReadOnly="Yes"
End If

// Init search box and sort
st_1.Text = "Select Port:"
uo_SearchBox.of_Initialize(dw_List, "berth_name")
dw_list.SetSort("berth_name")
dw_list.Sort()
uo_SearchBox.sle_Search.POST setfocus()

end event

event closequery;call super::closequery;if uf_updatesPending() = -1 then
	// prevent
	return 1
else
	//allow
	RETURN 0
end if
end event

event close;call super::close;destroy in_comment
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_berth
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_berth
integer y = 192
end type

type st_1 from w_coredata_ancestor`st_1 within w_berth
integer y = 16
integer width = 640
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_berth
integer y = 80
integer taborder = 100
string dataobject = "d_berth_port_picklist"
boolean livescroll = false
end type

event dw_dddw::itemchanged;call super::itemchanged;string ls_min, ls_max
long ll_row

if uf_updatesPending() = -1 then 
	cb_update.POST setFocus()
	return 2
end if

IF data = "<All>" THEN
	ls_min = "000"
	ls_max = "ÅÅÅ"
ELSE	
	ll_row = dw_dddw.find("port_n='"+data+"'",1, 99999)
	ls_min = this.getItemString(ll_row, "port_code")
	ls_max = ls_min
END IF

uo_SearchBox.cb_Clear.Event clicked( )

If dw_list.retrieve(ls_min, ls_max) = 0 THEN
	Messagebox("Message", "No berths to be shown.")
ELSE
	dw_list.event Clicked(0,0,1,dw_list.object)
END IF

end event

event dw_dddw::itemerror;call super::itemerror;return 1
end event

type dw_list from w_coredata_ancestor`dw_list within w_berth
integer y = 448
integer height = 1552
integer taborder = 120
string dataobject = "d_berth_picklist"
end type

event dw_list::clicked;double ld_berthID
datawindowchild ldwc

// Call ancestor Clicked event to perform sorting
Super::Event Clicked(xpos, ypos, row, dwo)

if uf_updatespending() = -1 then return

if row < 1 then return
setPointer(hourGlass!)

// Retrieval argument for tabpages
ld_berthID = dw_list.getItemNumber(row, "berth_id")
dw_list.selectRow(0,false)
dw_list.selectRow(row,true)
//Retrieve tabpages
tab_1.tabpage_1.dw_1.POST Retrieve(ld_berthID)
tab_1.tabpage_2.dw_2.POST Retrieve(ld_berthID)
if tab_1.tabpage_3.dw_3.Retrieve(ld_berthID) > 0 then
	tab_1.tabpage_3.dw_3.getChild("berth_grade_id", ldwc)   //dddw populate
	ldwc.setTransObject(SQLCA)
	ldwc.retrieve(ld_berthID)
end if
tab_1.tabpage_4.dw_4.POST Retrieve(ld_berthID)
tab_1.tabpage_5.dw_5.POST Retrieve(ld_berthID)

cb_new.enabled=true
cb_delete.enabled=true
uf_enableTabPages(TRUE, 2, 5)

SetPointer(Arrow!)
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;
If currentrow>0 Then This.event clicked(0, 0, currentrow, This.Object)
end event

type cb_close from w_coredata_ancestor`cb_close within w_berth
integer x = 4078
integer y = 1888
integer taborder = 90
end type

event cb_close::clicked;call super::clicked;close(parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_berth
integer x = 3639
integer y = 1888
integer taborder = 80
end type

event cb_cancel::clicked;call super::clicked;uf_gui_control(tab_1.selectedTab, "Cancel")

datawindow ldw_d
ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab], 1)
ldw_d.reset()
dw_list.EVENT POST Clicked(0, 0, dw_list.GetSelectedRow(0), dw_list.Object)


end event

type cb_delete from w_coredata_ancestor`cb_delete within w_berth
integer x = 3200
integer y = 1888
integer taborder = 70
end type

event cb_delete::clicked;long ll_response, ll_rc, ll_update, ll_row, ll_rowCount, ll_selectedrow
dataWindow ldw_d
long ll_currentrow

ll_currentrow = dw_list.getRow()

uf_gui_control(tab_1.selectedTab, "Delete")

ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab], 1)

// Deleting selected row depending on the selected tabpage (the general page or any other page)
CHOOSE CASE tab_1.SelectedTab
    CASE 1
      ll_response = Messagebox("Deleting!","You are about to delete a berth and all information connected to it. ~r~n" + & 
                               "Do you wish to continue?", Question!, YesNo!, 2)
		IF ll_response = 1 THEN
			ll_rc = uf_deleteBerth(ll_currentrow)
			if ll_rc > 0 then ll_rc = tab_1.tabpage_1.dw_1.deleterow(tab_1.tabpage_1.dw_1.getrow())
			if ll_rc > 0 then ll_rc = tab_1.tabpage_1.dw_1.update()
			IF ll_rc < 0 THEN
				Messagebox("Error","Update not done. This could be due to data on tabpage # ~r~n" + &
							  string(tab_1.selectedTab) + " being used other places in the system or database error.~r~n~r~n")
				rollback;
				tab_1.tabpage_1.dw_1.retrieve(dw_list.getItemNumber(ll_currentrow, "berth_id"))
				return
			ELSE
				commit;
				uf_updatepicklist()
				dw_list.Sort()
				dw_list.event Clicked(0, 0, ll_currentrow, dw_list.object)
				dw_list.scrollToRow(ll_currentrow)
			END IF
		END IF
	CASE 2, 3, 4, 5  //Tabular form
		ll_row = ldw_d.getRow()
		IF ll_row < 1 THEN
			RETURN
		END IF
      ll_response = Messagebox("Deleting!","You are about to delete the selected row on tabpage #"+string(tab_1.SelectedTab)+"~r~n" & 
                               , Question!, YesNo!, 2)
		IF ll_response = 1 THEN
			ldw_d.deleterow(ll_row)
			IF ldw_d.update() <> 1 THEN
				Messagebox("Error","Update not done. This could be due to data on tabpage #" + &
				           string(tab_1.SelectedTab) + " being used other places in the system or database error.~r~n~r~n")
				rollback;
				ldw_d.retrieve(dw_list.getItemNumber(ll_currentrow, "berth_id"))
				RETURN
			END IF
  		END IF
END CHOOSE
end event

type cb_new from w_coredata_ancestor`cb_new within w_berth
integer x = 2341
integer y = 1888
integer taborder = 50
end type

event cb_new::clicked;long 					ll_row, ll_dddw_row
dataWindow 			ldw_d
dataWindowChild	ldwc
string				ls_pick_portname

uf_gui_control(tab_1.selectedTab, "New")

CHOOSE CASE tab_1.selectedTab
	CASE 1
		if uf_updatesPending() = -1 then return
		tab_1.tabpage_2.dw_2.reset()
		tab_1.tabpage_3.dw_3.reset()
		tab_1.tabpage_4.dw_4.reset()
		tab_1.tabpage_5.dw_5.reset()
      ldw_d = uf_getDataWindow(tab_1.Control[1])
		ldw_d.reset()
      ll_row = ldw_d.insertRow(0)
		tab_1.tabpage_1.dw_1.Object.berth_active[ll_row] = 1
		// Set general.port_code = portcode picklist if <> <All>
		ls_pick_portname = dw_dddw.getItemString(dw_dddw.getRow(), "port_n")
		if ls_pick_portname <> "<All>" then
			tab_1.tabpage_1.dw_1.getChild("port_code", ldwc)
			ll_dddw_row = ldwc.find("port_n='"+ls_pick_portname+"'",1,99999)
			if ll_dddw_row > 0 then
				tab_1.tabpage_1.dw_1.setItem(ll_row, "port_code", ldwc.getItemString(ll_dddw_row, "port_code"))
			end if
		end if	
		
      ldw_d.scrollToRow(ll_row)
		ldw_d.POST setfocus()
		ldw_d.POST setcolumn("berth_name")
   CASE ELSE
      ldw_d = uf_getDataWindow(tab_1.Control[tab_1.selectedTab],1)
      ll_row = ldw_d.insertRow(0)
		if tab_1.selectedTab = 2 then 
			tab_1.tabpage_2.dw_2.Object.grade_vap_ret_line[ll_row] = 0
			tab_1.tabpage_2.dw_2.resetUpdate()
		end if
		if tab_1.selectedTab = 3 then
			tab_1.tabpage_3.dw_3.getChild("berth_grade_id", ldwc)
			ldwc.setTransObject(SQLCA)
			ldwc.retrieve(dw_list.getItemNumber(dw_list.getRow(), "berth_id"))
		end if			
      ldw_d.scrollToRow(ll_row)
		ldw_d.setColumn(1)
		ldw_d.setfocus()
END CHOOSE

cb_new.enabled=false
cb_delete.enabled=false


end event

type cb_update from w_coredata_ancestor`cb_update within w_berth
integer x = 2761
integer y = 1888
integer taborder = 60
end type

event cb_update::clicked;long ll_rc
long ll_tabpage, ll_row, ll_picklist_row
dataWindow ldw_d
string ls_result
string ls_pick_portname, ls_general_portname, ls_general_portcode
long  ll_general_row
datawindowchild ldwc

uf_gui_control(tab_1.selectedTab, "Update")

//Set foreign keys
ll_picklist_row = dw_list.getSelectedRow(0)
FOR ll_tabpage = 2 TO 5
	ldw_d = uf_getDataWindow(tab_1.Control[ll_tabpage], 1)
  	FOR ll_row = 1 TO  ldw_d.rowCount()
   	IF ldw_d.modifiedCount() > 0 THEN
			ldw_d.object.berth_id[ll_row] = dw_list.object.berth_id[ll_picklist_row]
		END IF	
	NEXT
NEXT

//General - Update all tabpages
tab_1.tabpage_1.dw_1.acceptText()
tab_1.tabpage_2.dw_2.acceptText()
tab_1.tabpage_3.dw_3.acceptText()
tab_1.tabpage_4.dw_4.acceptText()
tab_1.tabpage_5.dw_5.acceptText()

if uf_validategeneral() = -1 then return

ll_rc = tab_1.tabpage_1.dw_1.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Messagebox("Error message; "+ this.ClassName(), "General Update failed~r~nRC=" + String(ll_rc))
	Rollback;
	return -1
END IF

ll_rc = tab_1.tabpage_2.dw_2.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Messagebox("Error message; "+ this.ClassName(), "Conditioning grades Update failed~r~nRC=" + String(ll_rc))
	Rollback;
	return -1
END IF

ll_rc = tab_1.tabpage_3.dw_3.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Messagebox("Error message; "+ this.ClassName(), "Illegal last 3 grades Update failed~r~nRC=" + String(ll_rc))
	Rollback;
	return -1
END IF

ll_rc = tab_1.tabpage_4.dw_4.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Messagebox("Error message; "+ this.ClassName(), "Available grades Update failed~r~nRC=" + String(ll_rc))
	Rollback;
	return -1
END IF

ll_rc = tab_1.tabpage_5.dw_5.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Messagebox("Error message; "+ this.ClassName(), "Constraints Update failed~r~nRC=" + String(ll_rc))
	Rollback;
	return -1
END IF

tab_1.tabpage_1.dw_1.resetUpdate()
tab_1.tabpage_2.dw_2.resetUpdate()
tab_1.tabpage_3.dw_3.resetUpdate()
tab_1.tabpage_4.dw_4.resetUpdate()
tab_1.tabpage_5.dw_5.resetUpdate()
COMMIT;

// if ports picklist <> <All> 
// and ports picklist <> berth.port
// then set ports picklist = berth.port
ls_pick_portname = dw_dddw.getItemString(dw_dddw.getRow(), "port_n")
if ls_pick_portname <> "<All>" then
	ls_general_portcode = tab_1.tabpage_1.dw_1.getItemString(1, "port_code")
	tab_1.tabpage_1.dw_1.getChild("port_code", ldwc)
	ll_general_row = ldwc.find("port_code='"+ls_general_portcode+"'",1,99999)
	ls_general_portname = ldwc.getItemString(ll_general_row, "port_n")
	if ls_pick_portname <> ls_general_portname then
		dw_dddw.setItem(dw_dddw.getRow(), "port_n", ls_general_portname)
	end if
end if	

// Update picklist
uf_updatePicklist()

cb_new.enabled=true
cb_delete.enabled=true

RETURN 1
end event

type st_list from w_coredata_ancestor`st_list within w_berth
integer y = 384
string text = "Berths:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_berth
integer width = 3456
integer height = 1824
integer taborder = 10
boolean multiline = true
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_2
this.Control[iCurrent+2]=this.tabpage_3
this.Control[iCurrent+3]=this.tabpage_4
this.Control[iCurrent+4]=this.tabpage_5
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer width = 3419
integer height = 1708
string text = "General  "
end type

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
event ue_keydown pbm_dwnkey
string tag = "1"
integer x = 9
integer y = 4
integer width = 3387
integer height = 1712
string dataobject = "d_berth_detail"
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

event dw_1::doubleclicked;call super::doubleclicked;inet linet_base

// Implemented for the hyperlink
if (row > 0) then 
	CHOOSE CASE dw_1.getColumnName()
		CASE "hyperlink"
			string ls_hyperlink
			THIS.GetContextService("Internet", linet_base)
			linet_base.HyperlinkToURL (this.getitemstring(row, "hyperlink"))
	END CHOOSE

end if
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3419
integer height = 1708
long backcolor = 67108864
string text = "Conditioning Grades"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
event ue_mousemove pbm_dwnmousemove
string tag = "1"
integer x = 32
integer y = 32
integer width = 3369
integer height = 1648
integer taborder = 50
string title = "none"
string dataobject = "d_berth_cond_grade"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;If dwo.name = "comments" Then
	if not isValid(w_comment) and not isNull(this.Object.berth_cond_cmmnt[row]) then
	   	in_comment.setComment(this.Object.berth_cond_cmmnt[row])		
	   	in_comment.setX(pixelsToUnits(xpos, xPixelsToUnits!) + this.x + parent.x + tab_1.x)
      	in_comment.setY(pixelsToUnits(ypos, yPixelsToUnits!) + this.y + parent.y + tab_1.y) 
		openWithParm (w_popupHelp, in_comment, w_berth)	
   end if
Else
   If isValid(w_popupHelp) Then
      close (w_popupHelp)
	End if
End if
return 0
end event

event itemchanged;datawindowchild idwc_ref
string ls_grade_name, ls_grade_group

// Code to insert Grade Group, when a Grade Name is selected

CHOOSE CASE dwo.name

	// Column with Grade Name changed
	
	CASE "grade_name"
		
		// The GRADE GROUP is set by getting the child (dddw) and getting the 
		// the GRADE GROUP of the selected row, and inserting it to the GRADE
		// GROUP column of the datawindow.
		
		this.GetChild("grade_name", idwc_ref)
		ls_grade_group = idwc_ref.getitemstring(idwc_ref.getrow(),"grade_group")
		this.SetItem(this.getRow(), "grade_group", ls_grade_group)

end choose

end event

event clicked;if (row > 0) then // if the user has clicked on a row
	selectRow(0,false)
	selectRow(row,true)
	scrolltorow(row)
end if

If dwo.name = "comments" Then
   close (w_popupHelp)	
	in_comment.setComment(this.Object.berth_cond_cmmnt[row])
   openWithParm (w_comment, in_comment, w_berth)	
	in_comment = Message.PowerObjectParm
   if in_comment.getReturnCode() = 1 Then

		this.Object.berth_cond_cmmnt[row] = in_comment.getComment()
		
	End if
Else
   If isValid(w_comment) Then
      close (w_comment)
	End if
End if
return 0
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3419
integer height = 1708
long backcolor = 67108864
string text = "Illegal Last 3 Grades"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_3
string tag = "1"
integer x = 32
integer y = 32
integer width = 3369
integer height = 1648
integer taborder = 50
string title = "none"
string dataobject = "d_berth_ill_last3_grade"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;datawindowchild idwc_ref
string ls_grade_name, ls_grade_group

// Code to insert Grade Group, when a Grade Name is selected

CHOOSE CASE dwo.name

	// Column with Grade Name changed
	
	CASE "grade_name"
		
		// The GRADE GROUP is set by getting the child (dddw) and getting the 
		// the GRADE GROUP of the selected row, and inserting it to the GRADE
		// GROUP column of the datawindow.
		
		this.GetChild("grade_name", idwc_ref)
		ls_grade_group = idwc_ref.getitemstring(idwc_ref.getrow(),"grade_group")
		this.SetItem(this.getRow(), "grade_group", ls_grade_group)

end choose

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3419
integer height = 1708
long backcolor = 67108864
string text = "Available Grades"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_4 dw_4
end type

on tabpage_4.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_4.destroy
destroy(this.dw_4)
end on

type dw_4 from datawindow within tabpage_4
string tag = "1"
integer x = 32
integer y = 32
integer width = 3369
integer height = 1648
integer taborder = 40
string title = "none"
string dataobject = "d_berth_avail_grade"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;datawindowchild idwc_ref
string ls_grade_name, ls_grade_group

// Code to insert Grade Group, when a Grade Name is selected

CHOOSE CASE dwo.name

	// Column with Grade Name changed
	
	CASE "grade_name"
		
		// The GRADE GROUP is set by getting the child (dddw) and getting the 
		// the GRADE GROUP of the selected row, and inserting it to the GRADE
		// GROUP column of the datawindow.
		
		this.GetChild("grade_name", idwc_ref)
		ls_grade_group = idwc_ref.getitemstring(idwc_ref.getrow(),"grade_group")
		this.SetItem(this.getRow(), "grade_group", ls_grade_group)

end choose

end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3419
integer height = 1708
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
integer x = 32
integer y = 32
integer width = 3369
integer height = 1648
integer taborder = 40
string title = "none"
string dataobject = "d_berth_cnstr"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long ue_mousemove(integer xpos, integer ypos, long row, dwobject dwo);/*If dwo.name = "comments" Then
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
*/
return 0
end event

event clicked;IF row > 0 THEN
   this.selectRow(0,false)
   this.selectRow(row,true)
END IF

end event

event itemchanged;datawindowchild ldwc
long ll_found

IF row < 1 THEN return

if dwo.name = "type_id" then
	this.getChild("type_id", ldwc)
	ll_found = ldwc.find("type_id="+data, 1, 9999)
	this.setItem(row, "cnstr_cnstr_type", ldwc.getItemNumber(ll_found, "cnstr_type")) 
end if	
end event

