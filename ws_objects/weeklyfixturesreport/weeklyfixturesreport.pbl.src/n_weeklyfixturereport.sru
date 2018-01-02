$PBExportHeader$n_weeklyfixturereport.sru
forward
global type n_weeklyfixturereport from nonvisualobject
end type
end forward

global type n_weeklyfixturereport from nonvisualobject
end type
global n_weeklyfixturereport n_weeklyfixturereport

type variables

mt_n_datastore	ids_weeklyfixturereport
mt_n_datastore 	ids_attachment
string  				is_printer
string  				is_curPath, is_filepath
integer				ii_pcgroup
end variables
forward prototypes
public function integer createreport ()
public function integer of_createreport_byprofitcenter (integer ls_profitcenter[], integer ls_week, integer ls_year)
end prototypes

public function integer createreport ();integer 	arrayProfit[], li_i
integer li_week, li_year
mt_n_datastore ids_pc
	
is_printer = ProfileString ( "weeklyfixturesreport.ini","PDFDRIVER","Driver","CutePDF Writer") 

ids_weeklyfixturereport = create mt_n_datastore
ids_weeklyfixturereport.dataobject = "d_weeklyfixturereport"
ids_weeklyfixturereport.setTransObject(SQLCA)
ids_weeklyfixturereport.retrieve( )

ids_attachment = create mt_n_datastore
ids_attachment.dataObject = "d_report_files"
ids_attachment.setTransObject(sqlca)


ids_pc = create mt_n_datastore
ids_pc.dataObject = "d_pcnr"
ids_pc.setTransObject(sqlca)

//Calculate the fields Week and Year
SELECT  DATEPART(cwk,dateadd(dd,-7,getdate())) as week,    DATEPART(cyr,dateadd(dd,-7,getdate()))  as year
INTO :li_week, :li_year
FROM TRAMOS_VERSION
commit using SQLCA;	

if SQLCA.sqlcode = 0 then
	else
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + "Problem calculating Week and year fields")
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + SQLCA.sqlerrtext)
end if
ids_weeklyfixturereport.object.headerText.text = "Weekly Fixture Report  Week " + string(li_week) + " - " + string(li_year) + " (" + string(today()) + ") "

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//delete report for all profit centers
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DELETE
FROM PF_REPORT_FILES
WHERE  REPORT_TYPE=1 and WEEK=:li_week and YEAR=:li_year
commit using SQLCA;	

if SQLCA.sqlcode = 0 then
	else
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + "Problem deleting file.")
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + SQLCA.sqlerrtext)
end if

/* Handy */
ii_pcgroup=2
ids_pc.retrieve(2)
for li_i=1 to ids_pc.rowcount( )
   arrayProfit[li_i]= ids_pc.getitemnumber( li_i,"pc_nr")
next

//arrayProfit[1] = 4  //arrayProfit[2] = 17

of_createreport_byprofitcenter(arrayProfit,  li_week, li_year)

//clear array
arrayProfit[ ] = {0}

/* Crude */
ii_pcgroup=1
ids_pc.retrieve(1)
for li_i=1 to ids_pc.rowcount( )
   arrayProfit[li_i]= ids_pc.getitemnumber( li_i,"pc_nr")
next

//arrayProfit[1] = 2 //arrayProfit[2] = 0

of_createreport_byprofitcenter(arrayProfit,  li_week, li_year)

//arrayProfit[1] = 13
//arrayProfit[2] = 0
//of_createreport_byprofitcenter(arrayProfit,  li_week, li_year)

destroy ids_weeklyfixturereport
destroy ids_attachment
destroy ids_pc

fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + "ok")
return 0

end function

public function integer of_createreport_byprofitcenter (integer ls_profitcenter[], integer ls_week, integer ls_year);long ll_existingReportID
long ll_row, ll_bytes, ll_filenr,ll_reportid
blob	lblb_filecontent

ids_weeklyfixturereport.retrieve(ls_profitcenter)


if ids_weeklyfixturereport.rowcount( ) = 0 then
	fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + "Empty Report.")
	return 0
else
	
	ids_weeklyfixturereport.Object.DataWindow.Export.PDF.Method = Distill!    
	ids_weeklyfixturereport.Object.DataWindow.Printer = is_printer  
	ids_weeklyfixturereport.Object.DataWindow.Export.PDF.Distill.CustomPostScript="Yes"	
	
	is_curPath = GetCurrentDirectory()
	is_filepath = is_curPath + "\" + string(ls_profitcenter[1]) + "tmpWeeklyReport.pdf"
	if ids_weeklyfixturereport.saveas(is_filepath, PDF!, false) <> 1 then fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + "Error saving report.")

	COMMIT;
	ll_row = ids_attachment.insertRow(0)
	ll_filenr = fileOpen(is_filepath , StreamMode!, Read!, LockRead!)
     ll_bytes = fileReadEx(ll_filenr, lblb_filecontent )
     fileClose(ll_filenr)
	
	if ll_bytes < 1 then
	   return -1
     end if

    //create the new row
	ids_attachment.setItem(ll_row, "PC_NR", ls_profitcenter[1])
	ids_attachment.setItem(ll_row, "PCGROUP_ID",ii_pcgroup)
	ids_attachment.setItem(ll_row, "REPORT_TYPE", 1)
	ids_attachment.setItem(ll_row, "WEEK", ls_week)
	ids_attachment.setItem(ll_row, "YEAR", ls_year)
	ids_attachment.setItem(ll_row, "FILE_SIZE", ll_bytes)

if ids_attachment.update( ) = 1 then
	ll_reportid = ids_attachment.getitemnumber(ll_row,"REPORT_ID")
	UPDATEBLOB PF_REPORT_FILES SET
	FILE_CONTENT = :lblb_filecontent
	WHERE REPORT_ID=:ll_reportid;
	if SQLCA.sqlcode = 0 then
		COMMIT;
	else
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + "Problem updating contents!")
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + SQLCA.sqlerrtext)
		ROLLBACK;
	end if

else
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + "Error updating attachment files table.")
end if

FileDelete(is_curPath)

fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + "Profit center " + string(ls_profitcenter[1]) + " Successful.")

end if	
return 0

end function

on n_weeklyfixturereport.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_weeklyfixturereport.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

