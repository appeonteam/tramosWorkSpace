$PBExportHeader$n_search.sru
forward
global type n_search from nonvisualobject
end type
end forward

global type n_search from nonvisualobject
end type
global n_search n_search

type variables


end variables

forward prototypes
public subroutine of_startsearch (date ad_start, date ad_end, integer ai_vesseltype, integer ai_buffer, integer ai_status, ref datawindow adw_targetdw)
end prototypes

public subroutine of_startsearch (date ad_start, date ad_end, integer ai_vesseltype, integer ai_buffer, integer ai_status, ref datawindow adw_targetdw);Integer li_RowCount, li_Loop, li_New, li_Status[]
Datastore lds_users, lds_util, lds_search, lds_Result
String ls_LastUser

/* 

This function uses four steps to search for inspectors

1) Search for all users who can inspect the given vessel type  (lds_users)
2) Calculate the YTD utilization of users using current year (lds_util)
3) Search for users tasks overlapping given dates and filter them out (lds_search)
4) Sort by travel inspectors first and then utilization (lds_Result)

*/

// Clear results
adw_targetdw.Reset()

// Initialize all datastores
lds_users = Create DataStore
lds_util = Create DataStore
lds_search = Create DataStore
lds_Result = Create DataStore
lds_users.DataObject = "d_sq_tb_searchresult0"
lds_util.DataObject = "d_sq_tb_searchresult1"
lds_search.DataObject = "d_sq_tb_searchresult2"
lds_Result.DataObject = "d_ext_results"
lds_users.SetTransObject(SQLCA)
lds_util.SetTransObject(SQLCA)
lds_Search.SetTransObject(SQLCA)

// ------ STEP 1 ------ Find all capable inspectors

li_RowCount = lds_Users.Retrieve(ai_vesseltype)

If li_RowCount <= 0 then Return

For li_Loop = 1 to li_RowCount
	li_New = lds_Result.InsertRow(0)
	If li_New > 0 then
		lds_Result.SetItem(li_New, "Userid", lds_Users.GetItemString(li_Loop, "Userid"))
		lds_Result.SetItem(li_New, "Fullname", lds_Users.GetItemString(li_Loop, "Fullname"))
		lds_Result.SetItem(li_New, "Usage", 0)
		lds_Result.SetItem(li_New, "deptname", lds_Users.GetItemString(li_Loop, "deptname"))
	End If
Next

// ------ STEP 2 ------ Retrieve and Calculate YTD utilization

li_RowCount = lds_util.Retrieve(Year(Today()))
ls_LastUser = ""

If li_RowCount > 0 then
	For li_Loop = 1 to li_RowCount
		If lds_util.GetItemString(li_Loop, "userid") <> ls_LastUser then
			ls_LastUser = lds_util.GetItemString(li_Loop, "userid")
			li_New = lds_Result.Find( "userid = '" + ls_LastUser + "'", 1, lds_Result.RowCount())
			If li_New > 0 then lds_Result.SetItem(li_New, "usage", lds_util.GetItemNumber(li_Loop, "prousage"))
		End If
	Next
End If

// ------ STEP 3 ------ Filter out busy inspectors

ad_Start = RelativeDate(ad_Start, -ai_buffer)
ad_End = RelativeDate(ad_End, ai_buffer)

li_RowCount = lds_Search.Retrieve(DateTime(ad_Start), DateTime(ad_End), ai_Status)

For li_Loop = 1 to li_RowCount
	ls_LastUser = lds_search.GetItemString(li_Loop, "userid")
	li_New = lds_Result.Find( "userid = '" + ls_LastUser + "'", 1, lds_Result.RowCount())
	If li_New > 0 then lds_Result.DeleteRow(li_New)
Next

// ------ STEP 4 ------ Sort and display

adw_targetdw.SetRedraw(False)

lds_Result.SetSort("usage asc")
lds_Result.Sort( )

// Get all travel inspectors first
For li_Loop = 1 to lds_Result.RowCount()
	ls_LastUser = lds_Result.GetItemString(li_Loop, "Deptname")
	If Left(ls_LastUser,6) = "Travel" then
		li_New = adw_targetdw.InsertRow(0)
		adw_targetdw.SetItem(li_New, "userid", lds_Result.GetItemString(li_Loop, "userid"))
		adw_targetdw.SetItem(li_New, "fullname", lds_Result.GetItemString(li_Loop, "fullname"))
		adw_targetdw.SetItem(li_New, "deptname", ls_LastUser)
		adw_targetdw.SetItem(li_New, "usage", lds_Result.GetItemNumber(li_Loop, "usage"))
	End If
Next 

// All other inspectors
For li_Loop = 1 to lds_Result.RowCount()
	ls_LastUser = lds_Result.GetItemString(li_Loop, "Deptname")
	If Left(ls_LastUser,6) <> "Travel" then
		li_New = adw_targetdw.InsertRow(0)
		adw_targetdw.SetItem(li_New, "userid", lds_Result.GetItemString(li_Loop, "userid"))
		adw_targetdw.SetItem(li_New, "fullname", lds_Result.GetItemString(li_Loop, "fullname"))
		adw_targetdw.SetItem(li_New, "deptname", ls_LastUser)
		adw_targetdw.SetItem(li_New, "usage", lds_Result.GetItemNumber(li_Loop, "usage"))
	End If
Next 

adw_targetdw.SetRedraw(True)


// Destroy all datastores
Destroy lds_users
Destroy lds_util
Destroy lds_search
Destroy lds_Result
end subroutine

on n_search.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_search.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

