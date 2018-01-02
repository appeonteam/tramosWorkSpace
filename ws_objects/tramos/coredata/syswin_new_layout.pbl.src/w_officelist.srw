$PBExportHeader$w_officelist.srw
forward
global type w_officelist from w_coredata_ancestor
end type
end forward

global type w_officelist from w_coredata_ancestor
integer width = 3447
integer height = 2096
string title = "Offices"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
end type
global w_officelist w_officelist

type variables

Long il_Office_nr
end variables

forward prototypes
private function integer uf_updatespending ()
public subroutine documentation ()
end prototypes

private function integer uf_updatespending ();
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
   ObjectName: w_officelist
	
   <OBJECT></OBJECT>
   <DESC></DESC>
   <USAGE>   </USAGE>
   <ALSO></ALSO>
    	Date   	Ref		Author		Comments
  	00/00/07	?      		Name Here	First Version
  	11/04/17   CR4365		KSH092		Add Email Address: Claims
********************************************************************/
end subroutine

on w_officelist.create
int iCurrent
call super::create
end on

on w_officelist.destroy
call super::destroy
end on

event open;call super::open;// Init datawindows
dw_list.setTransObject(SQLCA)
tab_1.tabpage_1.dw_1.setTransObject(SQLCA)
dw_list.Retrieve()

il_Office_nr = Message.DoubleParm
If IsNull(il_Office_nr) then il_Office_nr = 0

// Sort and select
Long ll_Found
dw_list.SetSort("office_sn")
dw_list.Sort( )
If il_Office_nr = 0 then
	ll_Found = 1
Else
	ll_Found = dw_List.Find("office_nr = " + String(il_Office_nr), 0, dw_List.RowCount())
	If ll_Found <= 0 then ll_Found = 1
End If
dw_list.event Clicked(0, 0, ll_Found, dw_list.object)
dw_List.ScrollToRow(ll_Found)


// Initialize search box
uo_SearchBox.of_initialize(dw_List, "office_sn+'#'+office_name")
uo_SearchBox.sle_search.POST setfocus()

// Set access
If uo_global.ii_access_level = -1 then
	cb_new.enabled = false
	cb_delete.enabled = false
	cb_update.Enabled = False
	cb_Cancel.Enabled = False
	tab_1.tabpage_1.dw_1.object.datawindow.readonly = "Yes"
End if
end event

event closequery;call super::closequery;
If uf_updatespending() = 0 Then Return 0

If cb_update.event clicked() = -1 Then Return 1 Else Return 0
end event

type st_hidemenubar from w_coredata_ancestor`st_hidemenubar within w_officelist
end type

type uo_searchbox from w_coredata_ancestor`uo_searchbox within w_officelist
integer y = 32
integer width = 1317
end type

type st_1 from w_coredata_ancestor`st_1 within w_officelist
boolean visible = false
integer x = 549
integer y = 176
end type

type dw_dddw from w_coredata_ancestor`dw_dddw within w_officelist
boolean visible = false
integer x = 731
integer y = 208
integer width = 219
end type

type dw_list from w_coredata_ancestor`dw_list within w_officelist
integer y = 288
integer width = 1317
integer height = 1668
string dataobject = "dw_office_list"
end type

event dw_list::clicked;call super::clicked;// Call ancestor Clicked event to perform sorting
// Super::Event Clicked(xpos, ypos, row, dwo)

If row < 1 then return

If uf_updatespending() = -1 then 
	cb_Update.Event Clicked()
	Return
End If

setPointer(hourGlass!)

dw_list.selectRow(0,false)
dw_list.selectRow(row,true)

il_Office_Nr = This.GetItemNumber(row, "office_nr")

//Retrieve tabpages
tab_1.tabpage_1.dw_1.Retrieve(il_Office_Nr)

SetPointer(Arrow!)
end event

type cb_close from w_coredata_ancestor`cb_close within w_officelist
integer x = 3003
integer y = 1844
end type

event cb_close::clicked;call super::clicked;
Close(Parent)
end event

type cb_cancel from w_coredata_ancestor`cb_cancel within w_officelist
integer x = 2601
integer y = 1844
end type

event cb_cancel::clicked;call super::clicked;// Triggers the Clickedevent of dw_list
tab_1.tabpage_1.dw_1.reset()

dw_list.event Clicked(0,0,dw_list.Getrow(),dw_list.object)

cb_new.enabled = (dw_list.rowcount() > 0)
cb_delete.enabled = cb_new.enabled
cb_update.enabled = cb_new.enabled
cb_cancel.enabled = cb_new.enabled

end event

type cb_delete from w_coredata_ancestor`cb_delete within w_officelist
integer x = 2199
integer y = 1844
end type

event cb_delete::clicked;call super::clicked;Long ll_row

ll_row = dw_list.GetSelectedRow(0)

If ll_Row <> 0 Then
	If MessageBox("Delete","You are about to DELETE the office!~r~nAre you sure you want to continue?",Question!,YesNo!,2) = 2 Then Return
	dw_list.DeleteRow(ll_row)
	If dw_list.Update() = 1 Then
		Commit;
	Else
		Rollback;
	End If
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

type cb_new from w_coredata_ancestor`cb_new within w_officelist
integer x = 1394
integer y = 1844
end type

event cb_new::clicked;call super::clicked;If uf_updatesPending() = -1 then return

tab_1.tabpage_1.dw_1.Reset()
tab_1.tabpage_1.dw_1.InsertRow(0)
tab_1.tabpage_1.dw_1.SetItem(1, "office_active", 1)
tab_1.tabpage_1.dw_1.setFocus()

cb_new.enabled = false
cb_delete.enabled = false
cb_update.enabled = true
cb_cancel.enabled = true

il_Office_nr = 0

end event

type cb_update from w_coredata_ancestor`cb_update within w_officelist
integer x = 1797
integer y = 1844
end type

event cb_update::clicked;call super::clicked;Int li_next_office_nr, li_count
String ls_office_sn, ls_emailclaims

tab_1.tabpage_1.dw_1.AcceptText()

IF IsNull(tab_1.tabpage_1.dw_1.GetItemString(1,"office_sn")) or trim(tab_1.tabpage_1.dw_1.GetItemString(1,"office_sn")) = '' Then
	MessageBox("Update Error","Please enter a office short name!")
	tab_1.tabpage_1.dw_1.setfocus()
	tab_1.tabpage_1.dw_1.setcolumn('office_sn')
	Return
End If	
If IsNull(tab_1.tabpage_1.dw_1.GetItemstring(1,"office_name")) or trim(tab_1.tabpage_1.dw_1.GetItemstring(1,"office_name")) = '' THEN
	MessageBox("Update Error","Please enter a office name!")
	tab_1.tabpage_1.dw_1.setfocus()
	tab_1.tabpage_1.dw_1.setcolumn('office_name')
	Return
End If
If IsNull(tab_1.tabpage_1.dw_1.GetItemstring(1,"office_a_1")) or trim(tab_1.tabpage_1.dw_1.GetItemstring(1,"office_a_1")) = '' THEN
	MessageBox("Update Error","Please enter the office address!")
	tab_1.tabpage_1.dw_1.setfocus()
	tab_1.tabpage_1.dw_1.setcolumn('office_a_1')
	Return
End If
If IsNull(tab_1.tabpage_1.dw_1.GetItemstring(1,"office_c")) or trim(tab_1.tabpage_1.dw_1.GetItemstring(1,"office_c")) = '' THEN
	MessageBox("Update Error","Please enter the office country!")
	tab_1.tabpage_1.dw_1.setfocus()
	tab_1.tabpage_1.dw_1.setcolumn('office_c')
	Return
End If

ls_office_sn = tab_1.tabpage_1.dw_1.GetItemString(1,"office_sn")
SELECT count(*) INTO :li_count FROM OFFICES WHERE OFFICE_SN = :ls_office_sn;
IF (il_Office_Nr = 0 AND li_Count = 1) THEN
	MessageBox("Duplicate","You are creating a duplicate office!~r~nThis is not allowed.")
	tab_1.tabpage_1.dw_1.setfocus()
	tab_1.tabpage_1.dw_1.setcolumn('office_sn')
	Return
End If

/* If Office is avtive, the email addresses must be entered */
If tab_1.tabpage_1.dw_1.GetItemNumber(1,"office_active") = 1 THEN
	If IsNull(tab_1.tabpage_1.dw_1.GetItemstring(1,"email_adr_charterer")) or trim(tab_1.tabpage_1.dw_1.GetItemstring(1,"email_adr_charterer")) = '' THEN
		MessageBox("Update Error","Please enter the Charterer Email Address!")
		tab_1.tabpage_1.dw_1.setfocus()
		tab_1.tabpage_1.dw_1.setcolumn('email_adr_charterer')
		Return
	End If

	If IsNull(tab_1.tabpage_1.dw_1.GetItemstring(1,"email_adr_operation")) or trim(tab_1.tabpage_1.dw_1.GetItemstring(1,"email_adr_operation")) = '' THEN
		MessageBox("Update Error","Please enter the Operations Email Address!")
		tab_1.tabpage_1.dw_1.setfocus()
		tab_1.tabpage_1.dw_1.setcolumn('email_adr_operation')
		Return
	End If

	If IsNull(tab_1.tabpage_1.dw_1.GetItemstring(1,"email_adr_finance")) or trim(tab_1.tabpage_1.dw_1.GetItemstring(1,"email_adr_finance")) = '' THEN
		MessageBox("Update Error","Please enter the Finance Email Address!")
		tab_1.tabpage_1.dw_1.setfocus()
		tab_1.tabpage_1.dw_1.setcolumn('email_adr_finance')
		Return
	End If
	
	//CR2253 Begin added by ZSW001 on 22/05/2012
	if isnull(tab_1.tabpage_1.dw_1.getitemstring(1, "email_adr_demurrage")) or trim(tab_1.tabpage_1.dw_1.getitemstring(1, "email_adr_demurrage")) = '' then
		messagebox("Update Error", "Please enter the Demurrage Email Address!")
		tab_1.tabpage_1.dw_1.setfocus()
		tab_1.tabpage_1.dw_1.setcolumn('email_adr_demurrage')
		return
	end if
	//CR2253 End added by ZSW001 on 22/05/2012
	
	ls_emailclaims = tab_1.tabpage_1.dw_1.getitemstring(1,'email_adr_claims')
	if isnull(ls_emailclaims) or trim(ls_emailclaims) = '' then
		messagebox("Update Error", "Please enter the Claims Email Address!")
		tab_1.tabpage_1.dw_1.setfocus()
		tab_1.tabpage_1.dw_1.setcolumn('email_adr_claims')
		return
	end if
	
	if isnull(tab_1.tabpage_1.dw_1.getitemstring(1, "email_adr_psm")) or trim(tab_1.tabpage_1.dw_1.getitemstring(1, "email_adr_psm")) = '' then
		messagebox("Update Error", "Please enter the PSM Email Address!")
		tab_1.tabpage_1.dw_1.setfocus()
		tab_1.tabpage_1.dw_1.setcolumn('email_adr_psm')
		return
	end if
end if

IF il_Office_Nr = 0 THEN
	SELECT max(OFFICE_NR) INTO :li_next_office_nr FROM OFFICES;
	If IsNull(li_next_office_nr) Then
		tab_1.tabpage_1.dw_1.SetItem(1,"office_nr",1)
	Else
		tab_1.tabpage_1.dw_1.SetItem(1,"office_nr",li_next_office_nr + 1)
	End If
End If

If tab_1.tabpage_1.dw_1.Update() = 1 Then
	commit;
Else
	rollback;
	Return
END IF

Long ll_Found

// Set buttons
cb_update.enabled = true
cb_cancel.enabled = true
cb_new.enabled = true
cb_delete.enabled = true

// Retrieve and select from main list
dw_list.Retrieve()
dw_list.Sort()
ll_found = dw_list.Find("office_nr = " + String(tab_1.tabpage_1.dw_1.GetItemNumber(1, "office_nr" )), 1, dw_list.rowCount() ) 
If ll_found = 0 then  // In case unable to find due to filter, remove filter and find again
	uo_searchbox.cb_clear.event clicked( )
	ll_found = dw_list.Find("office_nr = " + String(tab_1.tabpage_1.dw_1.GetItemNumber(1, "office_nr" )), 1, dw_list.rowCount() ) 
End If
dw_list.event Clicked( 0, 0, ll_found, dw_list.object )
dw_list.scrollToRow(ll_found)

Return 1


end event

type st_list from w_coredata_ancestor`st_list within w_officelist
integer y = 224
string text = "Offices:"
end type

type tab_1 from w_coredata_ancestor`tab_1 within w_officelist
integer x = 1390
integer width = 2002
integer height = 1780
end type

type tabpage_1 from w_coredata_ancestor`tabpage_1 within tab_1
integer width = 1966
integer height = 1664
string text = "Office Details"
end type

type dw_1 from w_coredata_ancestor`dw_1 within tabpage_1
integer x = 37
integer y = 24
integer width = 1335
integer height = 1636
string dataobject = "dw_office"
end type

