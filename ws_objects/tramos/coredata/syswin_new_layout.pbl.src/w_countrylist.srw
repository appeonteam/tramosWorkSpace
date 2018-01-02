$PBExportHeader$w_countrylist.srw
forward
global type w_countrylist from w_coredata_ancestor
end type
end forward

global type w_countrylist from w_coredata_ancestor
integer width = 3557
integer height = 1256
string title = "Countries"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
end type
global w_countrylist w_countrylist

type variables

Long il_Country_ID
end variables

forward prototypes
private function integer uf_updatespending ()
public subroutine documentation ()
end prototypes

private function integer uf_updatespending ();If Not cb_update.enabled then return 0

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
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    	CR-Ref	Author		Comments
		28/08/14	CR3781	CCY018		The window title match with the text of a menu item
		19/09/16	CR2212	LHG008		Sanctions restrictions
   </HISTORY>
********************************************************************/
end subroutine

on w_countrylist.create
int iCurrent
call super::create
end on

on w_countrylist.destroy
call super::destroy
end on

event open;call super::open;// Init datawindows
dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
dw_list.Retrieve()

// Sort and select
dw_list.SetSort("country_id")
dw_list.Sort( )
dw_list.event Clicked(0, 0, 1, dw_list.object)

// Initialize search box
uo_SearchBox.of_initialize(dw_List, "String(country_id)+'#'+country_name+'#'+country_sn2+'#'+country_sn3")
uo_SearchBox.sle_search.POST setfocus()

// Set access control
If uo_global.ii_access_level < 3 and uo_global.ii_user_profile < 3 then
	cb_update.Enabled = False
	cb_delete.Enabled = False
	cb_New.Enabled = False
	cb_Cancel.Enabled = False
	tab_1.tabpage_1.dw_1.object.datawindow.readonly = "Yes"
End If
end event

event closequery;call super::closequery;
If uf_updatespending() = 0 Then Return 0

If cb_update.event clicked() = -1 Then Return 1 Else Return 0
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_countrylist
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_countrylist
integer y = 32
integer width = 1262
end type

type st_1 from w_coredata_ancestor`st_1 within w_countrylist
boolean visible = false
integer x = 987
integer y = 208
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_countrylist
boolean visible = false
integer x = 731
integer y = 208
integer width = 219
end type

type dw_list from w_coredata_ancestor`dw_list within w_countrylist
integer y = 288
integer width = 1262
integer height = 864
string dataobject = "d_country_list"
end type

event dw_list::clicked;call super::clicked;// Call ancestor Clicked event to perform sorting
// Super::Event Clicked(xpos, ypos, row, dwo)

If row < 1 then return

If uf_updatespending() = -1 then 
	cb_Update.Event Clicked()
	Return
End If

If cb_Update.Enabled then
	cb_New.Enabled = True
	cb_Delete.Enabled = True
	cb_Cancel.Enabled = True
End If

setPointer(hourGlass!)

dw_list.selectRow(0,false)
dw_list.selectRow(row,true)

il_Country_ID = This.GetItemNumber(row, "country_id")

//Retrieve tabpages
tab_1.tabpage_1.dw_1.Retrieve(il_Country_ID)

SetPointer(Arrow!)
end event

type cb_close from w_coredata_ancestor`cb_close within w_countrylist
integer x = 3109
integer y = 1040
end type

event cb_close::clicked;call super::clicked;
Close(Parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_countrylist
integer x = 2670
integer y = 1040
end type

event cb_cancel::clicked;call super::clicked;// Triggers the Clickedevent of dw_list
tab_1.tabpage_1.dw_1.reset()

dw_list.event Clicked(0,0,dw_list.Getrow(),dw_list.object)

cb_new.enabled = (dw_list.rowcount() > 0)
cb_delete.enabled = cb_new.enabled
cb_update.enabled = cb_new.enabled
cb_cancel.enabled = cb_new.enabled

end event

type cb_delete from w_coredata_ancestor`cb_delete within w_countrylist
integer x = 2231
integer y = 1040
end type

event cb_delete::clicked;call super::clicked;Long ll_row, ll_country_id

ll_row = dw_list.GetSelectedRow(0)

If ll_Row <> 0 Then
	If MessageBox("Delete","You are about to DELETE the country!~r~nAre you sure you want to continue?",Question!,YesNo!,2) = 2 Then Return
	
	ll_country_id = dw_list.getitemnumber(ll_row, "country_id")
	
	dw_list.DeleteRow(ll_row)
	
	delete COUNTRY_CURR_RST
	 where COUNTRY_ID = :ll_country_id;
	
	if sqlca.sqlcode = 0 then
		If dw_list.Update() = 1 Then
			Commit;
		Else
			Rollback;
		End If
	else
		Rollback;
		messagebox("Error",  "Failed to delete sanction information!", StopSign!)
	end if
	
	If dw_list.Retrieve() > 0 then 
		If ll_Row > dw_List.RowCount() then ll_Row = dw_List.RowCount()
		dw_List.SelectRow(ll_Row, True)
		dw_List.event clicked(0,0, ll_row, dw_list.object)
		dw_List.ScrollToRow(ll_row)
	Else
		tab_1.tabpage_1.dw_1.Reset( )
		cb_Update.Enabled = False
	End If			
end if
end event

type cb_new from w_coredata_ancestor`cb_new within w_countrylist
integer x = 1335
integer y = 1040
end type

event cb_new::clicked;call super::clicked;If uf_updatesPending() = -1 then return

tab_1.tabpage_1.dw_1.Reset()
tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_1.dw_1.setFocus()

cb_new.enabled = false
cb_delete.enabled = false
cb_update.enabled = true
cb_cancel.enabled = true

il_Country_ID = 0

end event

type cb_update from w_coredata_ancestor`cb_update within w_countrylist
integer x = 1774
integer y = 1040
end type

event cb_update::clicked;call super::clicked;Long ll_Found

tab_1.tabpage_1.dw_1.AcceptText()

If IsNull(tab_1.tabpage_1.dw_1.GetItemNumber(1, "country_id")) or IsNull(tab_1.tabpage_1.dw_1.GetItemString(1, "country_sn2")) or IsNull(tab_1.tabpage_1.dw_1.GetItemString(1, "country_sn3")) then 
	MessageBox("Error", "Please enter data in all required fields!", Exclamation!)
	Return
End If

If tab_1.tabpage_1.dw_1.Update() = 1 then
	Commit;
Else
	Rollback;
	Return
End If

// Set buttons
cb_update.enabled = true
cb_cancel.enabled = true
cb_new.enabled = true
cb_delete.enabled = true

// Retrieve and select from main list
dw_list.Retrieve()
dw_list.Sort()
ll_found = dw_list.Find("country_id = " + String(tab_1.tabpage_1.dw_1.GetItemNumber(1, "country_id" ) ) , 1, dw_list.rowCount() ) 
If ll_found = 0 then  // In case unable to find due to filter, remove filter and find again
	uo_searchbox.cb_clear.event clicked( )
	ll_found = dw_list.Find("country_id = " + String(tab_1.tabpage_1.dw_1.GetItemNumber(1, "country_id" ) ), 1, dw_list.rowCount() ) 
End If
dw_list.event Clicked( 0, 0, ll_found, dw_list.object )
dw_list.scrollToRow(ll_found)

Return 1


end event

type st_list from w_coredata_ancestor`st_list within w_countrylist
integer y = 224
string text = "Countries:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_countrylist
integer x = 1335
integer y = 16
integer width = 2176
integer height = 1008
end type

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer width = 2139
integer height = 892
string text = "Country Details"
end type

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
integer x = 37
integer y = 24
integer width = 1408
integer height = 560
string dataobject = "d_country_detail"
end type

