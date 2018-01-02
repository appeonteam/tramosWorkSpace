$PBExportHeader$w_area.srw
forward
global type w_area from w_coredata_ancestor
end type
end forward

global type w_area from w_coredata_ancestor
integer width = 3511
integer height = 1472
string title = "Areas"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
end type
global w_area w_area

forward prototypes
public function integer uf_updatespending ()
public subroutine documentation ()
end prototypes

public function integer uf_updatespending ();
tab_1.tabpage_1.dw_1.acceptText()

If tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount() > 0 then
	If MessageBox("Updates Pending", "Data modified but not saved.~r~nWould you like to update changes?",Question!,YesNo!,1)=1 then
		return -1
	Else
		tab_1.tabpage_1.dw_1.reset()		
		return 0
	End if
End if

Return 0
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14		CR3781	CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

event open;call super::open;// Init datawindows
dw_dddw.setTransObject(SQLCA)
dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
dw_list.Retrieve()

// If external APM only read access
if uo_global.ii_access_level = -1 then
	cb_new.enabled = false
	cb_update.enabled = false
	cb_delete.enabled = false
	cb_cancel.enabled = false
	tab_1.tabpage_1.dw_1.Object.DataWindow.ReadOnly="Yes"
end if

// Sort and select
dw_list.SetSort("area_pk")
dw_list.Sort( )
dw_list.event Clicked(0, 0, 1,dw_list.object)

// Initialize search box
uo_SearchBox.of_initialize(dw_List, "area_pk+'~'+area_sn+'~'+area_name")
uo_SearchBox.sle_search.POST setfocus()

end event

on w_area.create
int iCurrent
call super::create
end on

on w_area.destroy
call super::destroy
end on

event closequery;call super::closequery;
If uf_updatespending() = 0 Then Return 0

If cb_update.event clicked() = -1 Then Return 1 Else Return 0


end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_area
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_area
integer y = 32
integer width = 1207
end type

type st_1 from w_coredata_ancestor`st_1 within w_area
boolean visible = false
integer x = 933
integer y = 208
integer width = 274
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_area
boolean visible = false
integer x = 1207
integer y = 1152
end type

type dw_list from w_coredata_ancestor`dw_list within w_area
integer y = 272
integer width = 1207
integer height = 1088
string dataobject = "d_area_list"
end type

event dw_list::clicked;call super::clicked;Integer li_Area

// Call ancestor Clicked event to perform sorting
// Super::Event Clicked(xpos, ypos, row, dwo)

If row < 1 then return

If uf_updatespending() = -1 then 
	cb_Update.Event Clicked()
	Return
End If

setPointer(hourGlass!)

li_Area = dw_list.getItemNumber(row, "area_pk")

dw_list.selectRow(0,false)
dw_list.selectRow(row,true)

//Retrieve tabpages
tab_1.tabpage_1.dw_1.POST Retrieve(li_Area)

SetPointer(Arrow!)
end event

type cb_close from w_coredata_ancestor`cb_close within w_area
integer x = 3072
integer y = 1248
end type

event cb_close::clicked;call super::clicked;
close ( parent )
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_area
integer x = 2633
integer y = 1248
end type

event cb_cancel::clicked;call super::clicked;// Triggers the Clickedevent of dw_list
datawindow ldw_d

tab_1.tabpage_1.dw_1.reset()

dw_list.event Clicked(0,0,dw_list.Getrow(),dw_list.object)

cb_new.enabled = (dw_list.rowcount() > 0)
cb_delete.enabled = cb_new.enabled
cb_update.enabled = cb_new.enabled
cb_cancel.enabled = cb_new.enabled

end event

type cb_delete from w_coredata_ancestor`cb_delete within w_area
integer x = 2194
integer y = 1248
end type

event cb_delete::clicked;call super::clicked;Long ll_rc

If Messagebox("Deleting!","You are about to delete a Area.~r~nDo you wish to continue?", Question!, YesNo!, 2) = 2 Then Return

ll_rc = tab_1.tabpage_1.dw_1.deleterow(1)
if ll_rc > 0 then ll_rc = tab_1.tabpage_1.dw_1.update()
If ll_rc < 0 Then
	Messagebox("Error message; "+ this.ClassName(),"Update not done. This could be due to~r~nthe area being used other places in the system or a database error.")
	rollback;
	tab_1.tabpage_1.dw_1.retrieve(dw_list.getItemNumber(dw_list.getRow(), "area_pk"))
	return
Else
	commit;
	dw_list.Retrieve()
	dw_list.Sort()
	dw_list.event Clicked(0,0,dw_list.getRow(),dw_list.object)
	dw_list.scrollToRow(dw_list.getRow())
End IF
end event

type cb_new from w_coredata_ancestor`cb_new within w_area
integer x = 1317
integer y = 1248
end type

event cb_new::clicked;call super::clicked;
If uf_updatesPending() = -1 then return

tab_1.tabpage_1.dw_1.Reset()
tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_1.dw_1.setFocus()

cb_new.enabled = false
cb_delete.enabled = false
cb_update.enabled = true
cb_cancel.enabled = true

end event

type cb_update from w_coredata_ancestor`cb_update within w_area
integer x = 1755
integer y = 1248
end type

event cb_update::clicked;call super::clicked;Long ll_rc, ll_GetRow

// Set buttons
cb_update.enabled = true
cb_cancel.enabled = true
cb_new.enabled = true
cb_delete.enabled = true

// Perform update
tab_1.tabpage_1.dw_1.acceptText()
ll_rc = tab_1.tabpage_1.dw_1.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Messagebox("Error message; "+ this.ClassName(), "General Update failed~r~nRC=" + String(ll_rc))
	Rollback;
	return -1
End If

// Retrieve and select from main list
tab_1.tabpage_1.dw_1.resetUpdate()
Commit;

dw_list.Retrieve()
dw_list.Sort()
ll_GetRow = dw_list.Find("area_pk = " + string(tab_1.tabpage_1.dw_1.GetItemNumber( tab_1.tabpage_1.dw_1.getRow(), "area_pk" ) ), 1, dw_list.rowCount() ) 

If ll_GetRow = 0 then  // In case unable to find due to filter, remove filter and find again
	uo_searchbox.cb_clear.event clicked( )
	ll_GetRow = dw_list.Find("area_pk = " + string(tab_1.tabpage_1.dw_1.GetItemNumber( tab_1.tabpage_1.dw_1.getRow(), "area_pk" ) ), 1, dw_list.rowCount() ) 
End If
	
dw_list.event Clicked( 0, 0, ll_GetRow, dw_list.object )
dw_list.scrollToRow(ll_getrow)

return 1
	

end event

type st_list from w_coredata_ancestor`st_list within w_area
integer y = 208
string text = "List of Areas:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_area
integer x = 1317
integer y = 32
integer width = 2158
integer height = 1184
end type

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer width = 2121
integer height = 1068
string text = "Area Information"
end type

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
integer x = 37
integer y = 56
integer width = 1993
integer height = 720
string dataobject = "d_area_detail"
end type

