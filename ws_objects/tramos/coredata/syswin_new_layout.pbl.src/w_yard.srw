$PBExportHeader$w_yard.srw
forward
global type w_yard from w_coredata_ancestor
end type
end forward

global type w_yard from w_coredata_ancestor
integer width = 3753
integer height = 1532
string title = "Yards"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
end type
global w_yard w_yard

forward prototypes
public function integer uf_updatespending ()
public subroutine documentation ()
end prototypes

public function integer uf_updatespending ();long ll_anyModifications = 0

tab_1.tabpage_1.dw_1.acceptText()

ll_anymodifications = tab_1.tabpage_1.dw_1.modifiedCount() + tab_1.tabpage_1.dw_1.deletedCount()

if ll_anymodifications > 0 then
	if MessageBox("Updates pending", "Data modified but not saved.~r~nWould you like to update changes?",Question!,YesNo!,1)=1 then
		return -1
	else
		return 0
	end if
end if

return 0
end function

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
   	28/08/14	CR3781	   CCY018		    The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_yard.create
int iCurrent
call super::create
end on

on w_yard.destroy
call super::destroy
end on

event open;call super::open;dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)				

// Triggers the Clicked event of dw_list
If dw_list.retrieve() = 0 Then
	Messagebox("Message", "No Yardss to be shown.")
Else
	dw_list.event Clicked(0,0,1,dw_list.object)
End If

// Sort DW
dw_list.Setsort("yardname")
dw_list.Sort( )

// Initialize search box
uo_SearchBox.of_initialize(dw_List, "yardname+'#'+country")
uo_SearchBox.sle_search.POST setfocus()

// If external APM/Partner
If uo_global.ii_access_level < 0 then
	cb_Cancel.Enabled = False
	cb_Update.Enabled = False
	cb_New.Enabled = False
	cb_Delete.Enabled = False
	tab_1.tabpage_1.dw_1.Object.Datawindow.Readonly = "Yes"
End If

end event

event closequery;call super::closequery;double ll_rc, ll_button, ll_rc_2

IF uf_updatespending() = 0 THEN
	return 0
ELSE
	ll_rc = cb_update.event clicked()
	IF ll_rc = -1 THEN 
		return 1
	ELSE 
		return 0
	END IF
END IF
	
// 1 prevent from closing
// 0 allows closing
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_yard
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_yard
integer y = 16
integer width = 1463
end type

type st_1 from w_coredata_ancestor`st_1 within w_yard
boolean visible = false
integer x = 1371
integer y = 16
integer width = 165
boolean enabled = false
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_yard
boolean visible = false
integer x = 1445
integer y = 16
integer width = 233
integer taborder = 0
boolean enabled = false
end type

type dw_list from w_coredata_ancestor`dw_list within w_yard
integer y = 272
integer width = 1463
integer height = 1152
integer taborder = 30
string dataobject = "d_sq_tb_yard_picklist"
end type

event dw_list::clicked;long ll_yardID

// Call ancestor Clicked event to perform sorting
Super::Event Clicked(xpos, ypos, row, dwo)

if uf_updatesPending() = -1 then return

//IF IsValid(tab_1.tabpage_1.dw_1.Object) THEN
//	IF  uo_global.ii_access_level = 3 or (uo_global.ii_access_level = 2 and tab_1.selectedtab <> 1) THEN
//		IF tab_1.selectedtab = 1 THEN
//			uf_setwindow(tab_1.selectedtab,"picklist")
//		END IF
//	END IF
//END IF

IF row < 1 THEN return
SetPointer(HourGlass!)
	
// Retrieval argument for tabpages
ll_yardID = this.getItemNumber(row,"yard_id")
this.selectrow(0, false)
this.selectrow(row, true)
// Retrieve tabpages
tab_1.tabpage_1.dw_1.POST Retrieve(ll_yardid)

SetPointer(Arrow!)

end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;
If currentrow>0 Then This.event clicked(0, 0, currentrow, This.Object)
end event

type cb_close from w_coredata_ancestor`cb_close within w_yard
integer x = 3310
integer y = 1312
integer taborder = 90
end type

event cb_close::clicked;close ( parent )
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_yard
integer x = 2871
integer y = 1312
integer taborder = 80
end type

event cb_cancel::clicked;call super::clicked;// Triggers the Clickedevent of dw_list

tab_1.tabpage_1.dw_1.reset()

dw_list.event Clicked(0,0,dw_list.Getrow(),dw_list.object)

cb_Update.Enabled = True
cb_Delete.Enabled = True
cb_New.Enabled = True

end event

type cb_delete from w_coredata_ancestor`cb_delete within w_yard
integer x = 2432
integer y = 1312
integer taborder = 70
end type

event cb_delete::clicked;long ll_response, ll_rc, ll_tabpage, ll_row, ll_getrow

ll_tabpage = tab_1.SelectedTab
ll_getrow = dw_list.getRow()

// Deleting selected row depending on the selected tabpage 
CHOOSE CASE ll_tabpage
	CASE 1
			ll_response = Messagebox("Deleting!","You are about to delete a Yard. ~r~n" + & 
			"Do you wish to continue?", Question!, YesNo!, 2)
			IF ll_response = 1 THEN
				ll_rc = tab_1.tabpage_1.dw_1.deleterow(tab_1.tabpage_1.dw_1.getrow())
				if ll_rc > 0 then ll_rc = tab_1.tabpage_1.dw_1.update()
				IF ll_rc < 0 THEN
					Messagebox("Error message; "+ this.ClassName(),"Update not done. This could be due to~r~n" + &
					"the grade being used other places in the system or a database error.")
					rollback;
					tab_1.tabpage_1.dw_1.retrieve(dw_list.getItemString(ll_getrow, "yard_id"))
					return
				ELSE
					commit;
					dw_list.Retrieve()
					dw_list.Sort()
					dw_list.event Clicked(0,0,ll_getrow,dw_list.object)
					dw_list.scrollToRow(ll_getrow)
			   END IF
			END IF
	END CHOOSE
	   
	commit;
end event

type cb_new from w_coredata_ancestor`cb_new within w_yard
integer x = 1554
integer y = 1312
integer taborder = 50
end type

event cb_new::clicked;double ll_row, ll_rc

If uf_updatesPending() = -1 then return
	
tab_1.tabpage_1.dw_1.Reset()

tab_1.tabpage_1.dw_1.insertRow(0)
tab_1.tabpage_1.dw_1.setFocus()

cb_New.Enabled = False
cb_Delete.Enabled = False

end event

type cb_update from w_coredata_ancestor`cb_update within w_yard
integer x = 1993
integer y = 1312
integer taborder = 60
end type

event cb_update::clicked;double ll_rc, ll_rowcount, ll_clncount, ll_getrow, ll_row
double ll_tabpage,ll_selected,ll_selectrow
string	ls_find

// General - Updates all tabpages
tab_1.tabpage_1.dw_1.acceptText()

ll_rc = tab_1.tabpage_1.dw_1.update(TRUE, FALSE)
IF ll_rc < 0 THEN
	Messagebox("Error message; "+ this.ClassName(), "General Update failed~r~nRC=" + String(ll_rc))
	Rollback;
	return -1
END IF

tab_1.tabpage_1.dw_1.resetUpdate()
COMMIT;


tab_1.tabpage_1.dw_1.accepttext()
ls_find = "yard_id = " + string(tab_1.tabpage_1.dw_1.GetItemNumber( tab_1.tabpage_1.dw_1.getRow(), "yard_id" ) )
dw_list.Retrieve()
dw_list.Sort()

//If ll_rc < 0 Then	Return -1

ll_GetRow = dw_list.Find(  ls_find, 1, dw_list.rowCount() ) 

If ll_GetRow = 0 then  // In case unable to find due to filter, remove filter and find again
	uo_searchbox.cb_clear.event clicked( )
	ll_GetRow = dw_list.Find(  ls_find, 1, dw_list.rowCount() ) 
End If


	
dw_list.event Clicked( 0,0,ll_getrow,dw_list.object )
dw_list.scrollToRow(ll_getrow)
cb_new.enabled=true
cb_delete.enabled = true 

return 1
end event

type st_list from w_coredata_ancestor`st_list within w_yard
integer y = 208
string text = "Yards:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_yard
integer x = 1554
integer y = 64
integer width = 2158
integer height = 1216
integer taborder = 45
end type

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer y = 100
integer width = 2121
integer height = 1100
end type

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
integer x = 37
integer y = 40
integer width = 1810
integer height = 768
string dataobject = "d_sq_ff_yard"
end type

