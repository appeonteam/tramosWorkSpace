$PBExportHeader$n_fixturereport.sru
forward
global type n_fixturereport from mt_n_nonvisualobject
end type
end forward

global type n_fixturereport from mt_n_nonvisualobject
end type
global n_fixturereport n_fixturereport

type variables

mt_n_datastore	ids_Attachment, ids_PCGroups

n_fileattach_service inv_fileservice
n_Service_Manager inv_servicemanager
String is_CurPath
Datetime	idt_getdate
end variables

forward prototypes
public subroutine of_getprofitcenters (ref integer ai_pcnr[], integer ai_pcgroup)
public function long of_readfile2blob (string as_filepath, ref blob ablob_data)
public function string of_getvisiblecomments (ref mt_n_datastore adw_report, string ls_datawindow)
public subroutine of_create_daily_report (string as_pdfdriver)
public function integer of_create_weekly_report (string as_pdfdriver)
public function integer of_save_weekly_report (mt_n_datastore ads_weeklyfixrpt, integer ai_pcgroupid, integer ai_week, integer ai_year, string as_pdfdriver)
public function integer of_save_daily_report (mt_n_datastore ads_dailyfixrpt, integer ai_pcgroupid, string as_pdfdriver)
public subroutine documentation ()
end prototypes

public subroutine of_getprofitcenters (ref integer ai_pcnr[], integer ai_pcgroup);// This function gets all profitcenters belonging to a PC group and adds them to the passed array.

mt_n_datastore lds_PC
Integer li_Loop

lds_PC = Create mt_n_datastore
lds_PC.dataObject = "d_pcnr"
lds_PC.setTransObject(SQLCA)

// Reset array
ai_PCNR[] = {0}

lds_PC.Retrieve(ai_PCGroup)

For li_Loop = 1 To lds_PC.RowCount()
   ai_PCNR[li_Loop]= lds_pc.GetItemNumber(li_Loop,"pc_nr")
Next

Return
end subroutine

public function long of_readfile2blob (string as_filepath, ref blob ablob_data);// This function reads a file into a blob, deletes the file and returns the file size

Long ll_FileNR, ll_Bytes

ll_FileNR = FileOpen(as_Filepath , StreamMode!, Read!, LockRead!)
ll_Bytes = FileReadEx(ll_FileNR, ablob_Data)
FileClose(ll_FileNR)

If ll_Bytes > 0 then FileDelete(as_FilePath)

Return ll_Bytes
end function

public function string of_getvisiblecomments (ref mt_n_datastore adw_report, string ls_datawindow);DataWindowChild ldwc

adw_Report.GetChild(ls_DataWindow, ldwc)

If ldwc.RowCount( ) > 0 then Return '0' Else Return '1'
end function

public subroutine of_create_daily_report (string as_pdfdriver);// This function creates the daily report based on Profit Center Groups

mt_n_datastore lds_dailyfixrpt

// Initialize datastore for report and retrieve
lds_dailyfixrpt = create mt_n_datastore
Datawindowchild ldwc_Child
Long ll_Date1, ll_Date2
Integer li_Loop
String ls_tmp


// Run report for all profit center groups that must have daily reports
ids_PCGroups.SetFilter("MakeDailyReport = 1")
ids_PCGroups.Filter()

For li_Loop = 1 to ids_PCGroups.RowCount()

	Choose Case ids_PCGroups.GetItemNumber(li_Loop, "PCGroup_ID")
		Case 1  // Crude
			
			// Setup datastore and retrieval arguments
			lds_dailyfixrpt.DataObject = "d_daily_report_crude"
			lds_dailyfixrpt.SetTransObject(SQLCA)
			ls_Tmp = String(Today())
			ll_Date1 = Long(mid(ls_tmp,7,4) + mid(ls_tmp,4,2) + "00")-10000  // format yyyymm00 example: 20080100
			ll_Date2 = Long(mid(ls_tmp,7,4) + mid(ls_tmp,4,2) + "00")        //format yyyymm00 example: 20090100			

			// Retrieve & set comments
			lds_dailyfixrpt.Retrieve(ids_PCGroups.GetItemNumber(li_Loop, "PCGroup_ID"), ll_Date1, ll_Date2)
			lds_dailyfixrpt.Object.c1.Visible=of_GetVisibleComments(lds_dailyfixrpt,"dw_fixture_spot")
			lds_dailyfixrpt.Object.c2.Visible=of_GetVisibleComments(lds_dailyfixrpt,"dw_fixture_coa")
			lds_dailyfixrpt.Object.c3.Visible=of_GetVisibleComments(lds_dailyfixrpt,"dw_fixture_market_fix")
			lds_dailyfixrpt.Object.c4.Visible=of_GetVisibleComments(lds_dailyfixrpt,"dw_fixture_market_sub")
			lds_dailyfixrpt.Object.c5.Visible=of_GetVisibleComments(lds_dailyfixrpt,"dw_fixture_market_sub_curr")
			lds_dailyfixrpt.Object.c6.Visible=of_GetVisibleComments(lds_dailyfixrpt,"dw_fixture_market_fail")
			lds_dailyfixrpt.Object.c7.Visible=of_GetVisibleComments(lds_dailyfixrpt,"dw_crude_cargo")
			lds_dailyfixrpt.Object.c9.Visible=of_GetVisibleComments(lds_dailyfixrpt,"dw_bunker")
			lds_dailyfixrpt.Object.c10.Visible=of_GetVisibleComments(lds_dailyfixrpt,"dw_position")
			lds_dailyfixrpt.Object.c11.Visible=of_GetVisibleComments(lds_dailyfixrpt,"dw_fixture_area")			
			lds_dailyfixrpt.GetChild( "dw_position", ldwc_Child)
			If ldwc_Child.RowCount( ) > 0 then of_save_daily_report(lds_dailyfixrpt, ids_PCGroups.GetItemNumber(li_Loop, "PCGroup_ID"), as_pdfdriver)

		Case Else   // Handytankers and others
			
			// Setup datastore
			lds_dailyfixrpt.DataObject = "d_daily_report_standard"
			lds_dailyfixrpt.SetTransObject(SQLCA)
			
			// Retrieve & set comments
			lds_dailyfixrpt.Retrieve(ids_PCGroups.GetItemNumber(li_Loop, "PCGroup_ID"))
			lds_dailyfixrpt.Object.c1.Visible=of_getvisibleComments(lds_dailyfixrpt,"dw_fixture_spot")
			lds_dailyfixrpt.Object.c2.Visible=of_getvisibleComments(lds_dailyfixrpt,"dw_fixture_coa")
			lds_dailyfixrpt.Object.c3.Visible=of_getvisibleComments(lds_dailyfixrpt,"dw_bunker")
			lds_dailyfixrpt.Object.c4.Visible=of_getvisibleComments(lds_dailyfixrpt,"dw_position")
			lds_dailyfixrpt.Object.c7.Visible=of_getvisibleComments(lds_dailyfixrpt,"dw_cargo")
			lds_dailyfixrpt.Object.c8.Visible=of_getvisibleComments(lds_dailyfixrpt,"dw_fixture_market")
			lds_dailyfixrpt.GetChild( "dw_position", ldwc_Child)
			If ldwc_Child.RowCount( ) > 0 then of_save_daily_report(lds_dailyfixrpt, ids_PCGroups.GetItemNumber(li_Loop, "PCGroup_ID"), as_pdfdriver)
	End Choose
	
Next
destroy lds_dailyfixrpt
end subroutine

public function integer of_create_weekly_report (string as_pdfdriver);Integer li_Loop
Integer li_week, li_year

mt_n_datastore lds_weeklyfixrpt	
	
// Initialize datastore for report and retrieve
lds_weeklyfixrpt = create mt_n_datastore
lds_weeklyfixrpt.dataobject = "d_weeklyfixturereport"
lds_weeklyfixrpt.settransobject(SQLCA)
lds_weeklyfixrpt.retrieve( )

// Calculate the fields Week and Year (Get last week number)
SELECT DATEPART(cwk,dateadd(dd,-5,getdate())) as week, DATEPART(cyr,dateadd(dd,-5,getdate())) as year
INTO :li_week, :li_year FROM TRAMOS_VERSION;

If SQLCA.SQLCode <> 0 then	_addmessage(this.classdefinition, "of_create_weekly_report","Problem calculating Week and year fields; " + SQLCA.SQLErrText,"")

Commit using SQLCA;

// Set Report header
lds_weeklyfixrpt.Object.HeaderText.Text = "Weekly Fixture Report - Week " + string(li_Week) + "/" + string(li_Year) + " ( Created on " + String(today(), "dd mmm yyyy") + ")"

// Run report for all profit center groups that must have weekly reports
ids_PCGroups.SetFilter("MakeWeeklyReport = 1")
ids_PCGroups.Filter()
For li_Loop = 1 to ids_PCGroups.RowCount()
	of_save_weekly_report(lds_weeklyfixrpt, ids_PCGroups.GetItemNumber(li_Loop, "PCGroup_ID"), li_Week, li_Year, as_pdfdriver)
Next

// Destroy object and write to log
destroy lds_weeklyfixrpt

Return 0

end function

public function integer of_save_weekly_report (mt_n_datastore ads_weeklyfixrpt, integer ai_pcgroupid, integer ai_week, integer ai_year, string as_pdfdriver);Long ll_ReportID, ll_Row, ll_Bytes
Blob	lblb_FileContent
Integer li_PC[]
String ls_FilePath

// Get profit centers for profit center group
of_GetProfitCenters(li_PC, ai_PCGroupID)

// If nothing retrieved
If ads_weeklyfixrpt.Retrieve(li_PC) <= 0 then
	_addmessage(this.classdefinition, "of_save_weekly_report()", "No reports found for PC Group ID " + String(ai_PCGroupID),"")
	Return 0
Else
	
	// Export to PDF
	ads_weeklyfixrpt.Object.DataWindow.Export.PDF.Method = Distill!    
	ads_weeklyfixrpt.Object.DataWindow.Printer = as_pdfdriver  
	ads_weeklyfixrpt.Object.DataWindow.Export.PDF.Distill.CustomPostScript="Yes"
	ls_Filepath = is_CurPath + "\PCGroupID_" + String(ai_PCGroupID) + "_WeeklyReport.pdf"
	If ads_weeklyfixrpt.SaveAs(ls_filepath, PDF!, False) <> 1 Then 
		_addmessage(this.classdefinition, "of_save_weekly_report()", "Error saving weekly PDF report for PC Group ID " + String(ai_PCGroupID),"")
		Return -1
	End If
	
	// Check if attachment already exists
	ll_Row = ids_Attachment.Find("PCGroup_ID = " + String(ai_PCGroupID) + " and Week = " + String(ai_Week) + " and Year = " + String(ai_Year), 0, ids_Attachment.RowCount())

	// If nothing found, then add new row
	//If ll_Row <= 0 then	ll_Row = ids_Attachment.InsertRow(0)
	
	If ll_Row > 0 then
		if inv_fileservice.of_delete("PF_FIXTURE_ARCHIVE_FILES",  ids_Attachment.getitemnumber(ll_row, "PF_Archive_ID") ) < 0 then
			_addmessage(this.classdefinition, "of_save_weekly_report()", "in_FileAtt.of_delete() failed for Report ID " + String( ids_Attachment.getitemnumber(ll_row, "PF_Archive_ID")),"")
		end if
		
		ids_Attachment.deleterow( ll_row)
	end if
		
	ll_Row = ids_Attachment.InsertRow(0)
	
	// Read PDF file and delete
   ll_Bytes = of_ReadFile2Blob(ls_Filepath, lblb_FileContent )
	If ll_Bytes <= 0 then 
		_addmessage(this.classdefinition, "of_save_weekly_report()", "Unable to read weekly PDF report " + ls_Filepath,"")
		Return -1
	End If

   // Set new/existing row
	ids_Attachment.SetItem(ll_Row, "PCGroup_ID", ai_PCGroupID)
	ids_Attachment.SetItem(ll_Row, "Report_Type", 1)
	ids_Attachment.SetItem(ll_Row, "Week", ai_week)
	ids_Attachment.SetItem(ll_Row, "Year", ai_year)
	
	// If datastore is updated correctly, get Report ID and write file to _FILES database
	If ids_Attachment.Update() = 1 Then
		ll_ReportID = ids_Attachment.GetItemNumber(ll_Row, "PF_Archive_ID")
		If inv_fileservice.of_write("PF_FIXTURE_ARCHIVE_FILES", ll_ReportID, lblb_FileContent, ll_Bytes) < 0 then 
			_addmessage(this.classdefinition, "of_save_weekly_report()", "in_FileAtt.of_Write() failed for Report ID " + String(ll_ReportID),"")
			Return -1
		End If
	Else
		_addmessage(this.classdefinition, "of_save_weekly_report()", "ids_Attachment.Update() failed for PC Group ID " + String(ai_PCGroupID),"")
		Return -1
	End If

	_addmessage(this.classdefinition, "of_save_weekly_report()", "Weekly report successful for PC Group ID " + string(ai_PCGroupID),"")

End If

Return 1

end function

public function integer of_save_daily_report (mt_n_datastore ads_dailyfixrpt, integer ai_pcgroupid, string as_pdfdriver);String ls_DocPath
Blob	lbl_Doc
Long ll_Bytes, ll_Row, ll_ReportID
Date	ldt_Today
String ls_CurPath

ldt_Today = Today()
ls_CurPath = GetCurrentDirectory()

// Create PDF
ads_dailyfixrpt.Object.DataWindow.Export.PDF.Method = Distill!
ads_dailyfixrpt.Object.DataWindow.Printer = as_pdfdriver
ads_dailyfixrpt.Object.DataWindow.Export.PDF.Distill.CustomPostScript="Yes"
ls_DocPath = is_CurPath + "\dailyreport_delete" +  String(Rand(9999)) + ".pdf"

If ads_dailyfixrpt.SaveAs(ls_DocPath, PDF!, False) = 1 then
	
	// Read PDF and delete
	ll_Bytes = of_ReadFile2Blob(ls_DocPath, lbl_Doc)
	If ll_Bytes <= 0 then 
		_addmessage(this.classdefinition, "of_save_daily_report()", "Unable to read daily PDF report " + ls_DocPath,"")
		Return -1
	End If
	
	// Check if attachment already exists
	ll_Row = ids_Attachment.Find("PCGroup_ID = " + String(ai_PCGroupID) + " and Date(ReportDate) = Date(Today()) and Report_Type = 0", 0, ids_Attachment.RowCount())

	// If nothing found, then add new row
	//	If ll_Row <= 0 then ll_Row = ids_Attachment.InsertRow(0)
	
	If ll_Row > 0 then 
		if inv_fileservice.of_delete("PF_FIXTURE_ARCHIVE_FILES",  ids_Attachment.getitemnumber(ll_row, "PF_Archive_ID") ) < 0 then
			_addmessage(this.classdefinition, "of_save_daily_report()", "in_FileAtt.of_delete() failed for Report ID " + String( ids_Attachment.getitemnumber(ll_row, "PF_Archive_ID")),"")
		end if
		ids_Attachment.deleterow(ll_Row)
	end if
	 ll_Row = ids_Attachment.InsertRow(0)

   // Set new/existing row
	ids_Attachment.SetItem(ll_Row, "PCGroup_ID", ai_PCGroupID)
	ids_Attachment.SetItem(ll_Row, "ReportDate", DateTime(Today(), Now()))
	ids_Attachment.SetItem(ll_Row, "Report_Type", 0)

	// If datastore is updated correctly, get Report ID and write file to _FILES database
	If ids_Attachment.Update() = 1 Then
		ll_ReportID = ids_Attachment.GetItemNumber(ll_Row, "PF_Archive_ID")
		If inv_fileservice.of_Write("PF_FIXTURE_ARCHIVE_FILES", ll_ReportID, lbl_Doc, ll_Bytes) < 0 then 
			_addmessage(this.classdefinition, "of_save_daily_report()", "in_FileAtt.of_Write() failed for Report ID " + String(ll_ReportID),"")
			Return -1
		End If
	Else
		_addmessage(this.classdefinition, "of_save_daily_report()", "ids_Attachment.Update() failed for PC Group ID " + String(ai_PCGroupID),"")
		Return -1
	End If
	_addmessage(this.classdefinition, "of_save_daily_report()", "Daily report successful for PC Group ID " + string(ai_PCGroupID),"")	
Else
	_addmessage(this.classdefinition, "of_save_daily_report()", "Unable to save daily report","")	
End If

Return 1
end function

public subroutine documentation ();/********************************************************************
   n_object_name:  n_fixturereport
	
	<OBJECT>
		Manages the scheduled fixture report process
	</OBJECT>
   <DESC>
		Creates and saves report attachments in the current FILES database	
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/06/05 	?      	???				First Version
	10/02/16		CR4298	AGL027			Standardize server apps
********************************************************************/
end subroutine

on n_fixturereport.create
call super::create
end on

on n_fixturereport.destroy
call super::destroy
end on

event constructor;
// Initialize file attachment service (for _FILES database)
inv_servicemanager.of_loadservice(inv_fileservice, "n_fileattach_service")
inv_fileservice.of_activate()

// Initialize PCGroups datastore and retrieve
ids_PCGroups = Create mt_n_datastore
ids_PCGroups.DataObject = "d_sq_tb_pcgroup"
ids_PCGroups.SetTransObject(SQLCA)
ids_PCGroups.Retrieve()

// Initialize report file datastore
ids_Attachment = Create mt_n_datastore
ids_Attachment.DataObject = "d_report_files"
ids_Attachment.SetTransObject(SQLCA)
ids_Attachment.Retrieve( )

// Set current app path
is_CurPath = GetCurrentDirectory()


end event

event destructor;
inv_fileservice.of_Deactivate( )
inv_servicemanager.of_unloadservice("n_fileattach_service")

Destroy ids_PCGroups

Destroy ids_Attachment
end event

