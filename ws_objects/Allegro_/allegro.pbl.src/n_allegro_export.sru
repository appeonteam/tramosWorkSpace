$PBExportHeader$n_allegro_export.sru
forward
global type n_allegro_export from mt_n_nonvisualobject
end type
end forward

global type n_allegro_export from mt_n_nonvisualobject
end type
global n_allegro_export n_allegro_export

type variables
private long		il_currentVersion
private datastore	ids_transfer, ids_trade
private datastore ids_newTrade
private integer	ii_log_filehandle
private boolean	ib_transfer_all = false   //this variable tells whether to transfer all trades or only changes
private constant boolean FAIL = true
private constant boolean SUCCES = false
n_service_manager	inv_servicemanager
n_error_service	inv_errservice
end variables

forward prototypes
public subroutine documentation ()
private subroutine of_writetolog (ref string as_errtext)
private function integer of_filltempdb (ref string as_errtext)
private function integer of_modifysyntax (ref datastore ads_trade, ref string as_errtext)
private function integer of_retrievedatastores (ref string as_errtext)
private function integer of_newtransfer (ref string as_errtext)
private function integer of_processtrade (ref string as_errtext)
private function integer of_createxmlexport (ref string as_errtext)
private function integer of_sendfile (ref string as_errtext)
public function integer of_export (boolean ab_fromtramos, ref string as_errtext, string as_commandline)
private function integer of_initialize (ref string as_errtext, boolean ab_dbconnect, string as_commandline, ref string as_monitorid)
private function integer of_cleanup (boolean ab_failed, string as_errtext, string as_monitorid)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_allegro_export - used for exporting data to Allegro
	
   <OBJECT> 
	This object is used for exporting data to Allegro. Allegro
	is a system for calculating the future coverage. The export to 
	Allegro is runned on a daily basis, by a scheduled task. It is also
	possible to run the export manually from Tramos. The object holds
	functionality to compare what has been transfered already, and only
	send changes/new/deleted items.
	The export is made as an XML-file.  The output file is only placed 
	on the server</OBJECT>
	
   <USAGE> 
	This object is very easy to use. Instantiate it and call
	the only public function of_export() with two paramenters.
	boolean whether it is called from tramos or not and a reference
	to a string error message</USAGE>

   <ALSO> 
	</ALSO>

    Date   	Ref   	Author        			Comments
  17/09/07  	     	Regin Mortensen     	First Version
  08/02/16	CR4298	AGL027					Add connection details into the code
  
********************************************************************/

end subroutine

private subroutine of_writetolog (ref string as_errtext);/********************************************************************
	of_writetolog
	<DESC>   
	This function writes the Error Message to the AllegroExport.log 
	file</DESC>
	<RETURN> None</RETURN>
	<ACCESS> 
	Private</ACCESS>
	<ARGS>	as_ErrText: The text that has to be written to the log</ARGS>
********************************************************************/

filewrite(ii_log_filehandle, string(datetime(today(), now()),"dd. mmm yyyy hh:mm:ss  ")+as_errtext)
return

end subroutine

private function integer of_filltempdb (ref string as_errtext);/********************************************************************
	of_fillTempDB( )
	<DESC>   
	This function fills the temporary created table (#TEMP_TRADE) with 
	data. The data that are filled into the table are as follows:
	- all APM owned vessels. Share for these vessels is 100%. All own 
		vessels that don't have registred a build date, will have it set 
		to 1. january 2007 and the end date set to +20 years. 
	- All vessels hired IN with following shares
		if rate = 0 share = 0% (hired by pool)
		if rate and there are registred sharemembers. Share = APM part
		if rate and no sharemembers. Share = 100%
	- All vessels hired OUT. Share for these vessels is 100% 
	- Only vessels that are marked active or have a TC contract
		that is running longer than today() are transferred
	</DESC>
	<RETURN> Integer:
				<LI> 1, X ok
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Private</ACCESS>
	<ARGS>	as_ErrText: Holds the Error Message if something went
								wrong.</ARGS>
	<USAGE>
	This function can only be used if the temp DB is already created.
	in this object it is created in of_initialize </USAGE>
********************************************************************/
string		ls_sqlSyntax

/* Own Vessels */
ls_sqlSyntax = "INSERT INTO #TEMP_TRADE  " +& 
	"( TRANSID, "+&   
	"VESSEL_NR, "+&   
	"CONTRACT_ID, "+&   
	"BEGINTIME, "+&   
	"ENDTIME, "+&   
	"TRADE_INOUT, "+&   
	"FIXEDPRICE, "+&   
	"VESSELSHARE, "+&   
	"TRADEBOOK, "+&   
	"TRANSTYPE, "+& 
	"TRANS_STATUS )  "+& 
	"SELECT  " +string(il_currentversion) +" , "+&   
	" VESSELS.VESSEL_NR, "+&   
	" NULL, "+&   
	" VESSELS.CAL_BUILD_DATE, "+&   
	" dateadd(yy,20,VESSELS.CAL_BUILD_DATE ), "+&   
	"1, "+&    
	"0, "+&
	" 1, "+&   
	" 'Owned', "+&   
	" 'INS',  "+&   
	"0 "+&
	"FROM VESSELS   "+& 
	"WHERE ( VESSELS.VESSEL_ACTIVE = 1 ) AND   "+& 
	"  ( VESSELS.APM_OWNED_VESSEL = 1 ) "
execute immediate :ls_sqlSyntax;

if sqlca.sqlcode <> 0 then
	as_ErrText = sqlca.sqlerrtext
	return -1
end if

/* TC Hire IN */
ls_sqlSyntax = "INSERT INTO #TEMP_TRADE   "+& 
	"( TRANSID, "+&   
	"VESSEL_NR, "+&   
	"CONTRACT_ID, "+&   
	"BEGINTIME, "+&   
	"ENDTIME, "+&   
	"TRADE_INOUT, "+&   
	"FIXEDPRICE, "+&   
	"VESSELSHARE, "+&   
	"TRADEBOOK, "+&   
	"TRANSTYPE, "+& 
	"TRANS_STATUS )  "+& 
	"SELECT " +string(il_currentversion) +", "+&
		 "VESSELS.VESSEL_NR, "+&   
		"NTC_TC_CONTRACT.CONTRACT_ID, "+&
		" NTC_TC_PERIOD.PERIODE_START, "+&   
		" NTC_TC_PERIOD.PERIODE_END, "+&   
		"1, "+&     
		" CASE WHEN NTC_TC_CONTRACT.MONTHLY_RATE=0 THEN NTC_TC_PERIOD.RATE ELSE ROUND((NTC_TC_PERIOD.RATE / 30.416667),2) END AS DAILY_RATE, "+&
		" CASE WHEN NTC_TC_PERIOD.RATE = 0 THEN 0 "+&
		" WHEN NTC_TC_PERIOD.RATE <> 0  "+&
		" AND (SELECT SUM(PERCENT_SHARE)  "+&
		" FROM NTC_SHARE_MEMBER  "+&
		" WHERE CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID) > 0 THEN ISNULL((SELECT SUM(PERCENT_SHARE)/100  "+&
		"																				FROM NTC_SHARE_MEMBER  "+&
		"																				WHERE CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID "+&
		"																				AND APM_COMPANY = 1),0)  "+&
		"ELSE 1 END,  "+&
		" 'Time Charter', "+&   
		" 'INS',  "+&   
		"0 "+&
		"FROM VESSELS, "+&   
		" NTC_TC_CONTRACT, "+&   
		" NTC_TC_PERIOD  "+&   
		"WHERE VESSELS.VESSEL_NR = NTC_TC_CONTRACT.VESSEL_NR and   "+& 
		" NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID and   "+& 
		" NTC_TC_CONTRACT.TC_HIRE_IN = 1 AND   "+& 
		" NTC_TC_CONTRACT.FIX_DATE is not null and  "+& 
		" VESSELS.VESSEL_ACTIVE = 1  AND   "+& 
		" VESSELS.APM_OWNED_VESSEL = 0  "
execute immediate :ls_sqlSyntax;

if sqlca.sqlcode <> 0 then
	as_ErrText = sqlca.sqlerrtext
	return -1
end if

/* TC Hire OUT */
ls_sqlSyntax = "INSERT INTO #TEMP_TRADE   "+& 
	"( TRANSID, "+&   
	"VESSEL_NR, "+&   
	"CONTRACT_ID, "+&   
	"BEGINTIME, "+&   
	"ENDTIME, "+&   
	"TRADE_INOUT, "+&   
	"FIXEDPRICE, "+&   
	"VESSELSHARE, "+&   
	"TRADEBOOK, "+&   
	"TRANSTYPE, "+& 
	"TRANS_STATUS )  "+& 
	"SELECT " +string(il_currentversion) +", "+&
		"VESSELS.VESSEL_NR, "+&   
		"NTC_TC_CONTRACT.CONTRACT_ID, "+&
		" NTC_TC_PERIOD.PERIODE_START, "+&   
		" NTC_TC_PERIOD.PERIODE_END, "+&   
		"0, "+&     
		" CASE WHEN NTC_TC_CONTRACT.MONTHLY_RATE=0 THEN NTC_TC_PERIOD.RATE ELSE ROUND((NTC_TC_PERIOD.RATE / 30.416667),2) END AS DAILY_RATE, "+&
		"1, "+&   
		" 'Time Charter', "+&   
		" 'INS',  "+&   
		"0 "+&
		"FROM VESSELS, "+&   
		" NTC_TC_CONTRACT, "+&   
		" NTC_TC_PERIOD  "+&   
		"WHERE VESSELS.VESSEL_NR = NTC_TC_CONTRACT.VESSEL_NR and   "+& 
		" NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID and   "+& 
		" NTC_TC_CONTRACT.TC_HIRE_IN = 0 AND   "+& 
		" NTC_TC_CONTRACT.FIX_DATE is not null AND "+&
		" (SELECT MAX(P2.PERIODE_END) FROM NTC_TC_PERIOD P2 WHERE P2.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID) >= GETDATE()  " 
		
execute immediate :ls_sqlSyntax;

if sqlca.sqlcode <> 0 then
	as_ErrText = sqlca.sqlerrtext
	return -1
end if

ls_sqlSyntax = "UPDATE #TEMP_TRADE  "+& 
	"SET  BEGINTIME = '1. JANUARY 2007'  "+& 
	"WHERE BEGINTIME = NULL"
execute immediate :ls_sqlSyntax;

if sqlca.sqlcode <> 0 then
	as_ErrText = sqlca.sqlerrtext
	return -1
end if

ls_sqlSyntax = "UPDATE #TEMP_TRADE  "+& 
	"SET ENDTIME= '1. JANUARY 2027'  "+& 
	"WHERE ENDTIME = NULL"
execute immediate :ls_sqlSyntax;

if sqlca.sqlcode <> 0 then
	as_ErrText = sqlca.sqlerrtext
	return -1
end if

return 1
end function

private function integer of_modifysyntax (ref datastore ads_trade, ref string as_errtext);/********************************************************************
	of_modifysyntax
	<DESC>   
	This function modifies the SQL statement behind the trade datastore
	so that it retrieves from the temporary table #TEMP_TRADE. This 
	data is used to compare with last export to find out if anything
	is changed</DESC>
	<RETURN> Integer:
				<LI> 1, X ok
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Private</ACCESS>
	<ARGS>	ads_trade: 	The datastore where SQL has to be replaced
				as_errtext:	String passing eror messages</ARGS>
********************************************************************/
string	ls_sqlSyntax
long		ll_rc

ls_sqlSyntax = "SELECT #TEMP_TRADE.TRADEID, "+&
	"#TEMP_TRADE.TRANSID, "+&  
	"#TEMP_TRADE.VESSEL_NR, "+&  
	"#TEMP_TRADE.CONTRACT_ID, "+&  
	"#TEMP_TRADE.BEGINTIME, "+&  
	"#TEMP_TRADE.ENDTIME, "+&  
	"#TEMP_TRADE.FIXEDPRICE, "+&  
	"#TEMP_TRADE.VESSELSHARE, "+&  
	"#TEMP_TRADE.TRADEBOOK, "+&  
	"#TEMP_TRADE.TRANSTYPE,   "+&
	"#TEMP_TRADE.TRADE_INOUT,  "+&
	"#TEMP_TRADE.TRANS_STATUS  "+& 
	"FROM #TEMP_TRADE   "+&
	"ORDER BY #TEMP_TRADE.VESSEL_NR ASC, "+&
	"#TEMP_TRADE.BEGINTIME ASC"   

ll_rc = ads_trade.setSqlSelect(ls_sqlSyntax)

if ll_rc = -1 then
	as_errtext = "Replace of SQL behind datastore failed!"
	return -1
end if

return 1


end function

private function integer of_retrievedatastores (ref string as_errtext);/********************************************************************
	Fof_retrieveDatastores
	<DESC>   
	This function retrieves the two datastores that has to be compared
	in order to find changes since last export</DESC>
	<RETURN> Integer:
				<LI> 1, X ok
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Private</ACCESS>
	<ARGS>	as_errtext: String passing the error message</ARGS>
********************************************************************/
long ll_rows, ll_row

if ids_trade.retrieve() = -1 then
	as_errtext = "Failed when retrieving OLD exports!"
	return -1
end if

//f_datastore_spy(ids_trade)
//f_datastore_spy(ids_newtrade)

//Delete duplicates if user decided to transfer All again
ll_rows = ids_trade.rowcount()
for ll_row = (ll_rows -1) to 1 step -1
	if ids_trade.getItemNumber(ll_row, "vessel_nr") = ids_trade.getItemNumber(ll_row +1, "vessel_nr") &
	and (ids_trade.getItemNumber(ll_row, "contract_id") = ids_trade.getItemNumber(ll_row +1, "contract_id") &
	or  (isnull(ids_trade.getItemNumber(ll_row, "contract_id")) and  isNull(ids_trade.getItemNumber(ll_row +1, "contract_id")))) &
	and ids_trade.getItemDatetime(ll_row, "begintime") = ids_trade.getItemDatetime(ll_row +1, "begintime") then
		ids_trade.deleterow(ll_row)
	end if	
next
ids_trade.resetUpdate( )

if of_modifysyntax( ids_newtrade, as_errtext ) = -1 then return -1  

if ids_newtrade.retrieve() = -1 then
	as_errtext = "Failed when retrieving NEW exports!"
	return -1
end if

//f_datastore_spy(ids_trade)
//f_datastore_spy(ids_newtrade)

return 1
end function

private function integer of_newtransfer (ref string as_errtext);/********************************************************************
	of_newtransfer
	<DESC>   
	This function creates a new transfer (creates a record in the 
	Allegro Transfer table),sets the current transfer version 
	number and saves it to the DB</DESC>
	<RETURN> Integer:
				<LI> 1, X ok
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Private</ACCESS>
	<ARGS>	as_ErrText: String passing the Error Message</ARGS>
********************************************************************/
long	ll_rows, ll_row

ll_rows = ids_transfer.retrieve( )
if ll_row = -1 or ll_row > 1 then    // can only have one row as the select says top 1
	as_errtext = "Something went wrong when retrieving transfer version!"
	return -1
elseif ll_rows > 0 then 
	il_currentversion = ids_transfer.getItemNumber(1, "transid") +1
else
	il_currentversion = 1
end if

ll_row = ids_transfer.insertRow(0)
ids_transfer.setItem(ll_row, "transdate", today())

if ids_transfer.update() <> 1 then 
	as_errtext = "Error updating transfer version!" 
	return -1
end if

il_currentversion = ids_transfer.getItemNumber(ll_row, "transid") 

return 1
end function

private function integer of_processtrade (ref string as_errtext);/********************************************************************
	of_processTrade
	<DESC>   
	First this function checks if to transfer "All current" trades as
	new trades, or just transfer changes. 
	If "All" just clear trades and move all newtrades to trades.
	If "Changes" run through all trades and compare them with
	newtrades. Find out if anything changed. Update the changes 
	in trades and set the record status to INS=insert, UPD=update or
	DEL=deleted. If no changes made the record is removed from
	trades</DESC>
	<RETURN> Integer:
				<LI> 1, X ok
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Private</ACCESS>
	<ARGS>	as_errtext: String passing the error message</ARGS>
	<USAGE>
	How to use this function.</USAGE>
********************************************************************/
long	ll_current_vessel, ll_previous_vessel
long	ll_vessels[] //used to store how many vessels to rub through and afterwards to find out is any vessels missing in new dataset so that they have to be deleted in Allegro
long	ll_rows, ll_row, ll_newtrades, ll_newtrade
string ls_filter

ll_rows = ids_newtrade.rowcount()

// The first time the transfer is runned is the same as transfer all
if ids_trade.rowcount( ) < 1 then
	ib_transfer_all = true
end if

choose case ib_transfer_all
	case true  //transfer all
		ids_trade.reset()   //empty datastore
		ids_trade.object.data[1,3,ll_rows,12] = ids_newtrade.object.data[1,3,ll_rows,12] //copy all rows from newtrans except the 3 first columns
		for ll_row = 1 to ll_rows
			ids_trade.setItem(ll_row, "transid", il_currentversion )
			ids_trade.setItem(ll_row, "transtype", "INS")
		next		
	case false //transfer changes

//		f_datastore_spy(ids_trade)
//		f_datastore_spy(ids_newtrade)

		//Build array of vessels to run through
		for ll_row = 1 to ll_rows
			ll_current_vessel = ids_newtrade.getItemNumber(ll_row, "vessel_nr")
			if ll_current_vessel = ll_previous_vessel then continue
			ll_vessels[upperbound(ll_vessels) +1] = ll_current_vessel
			ll_previous_vessel = ll_current_vessel
		next	
		
		// Run through all the vessels and compare using filter function on both datastores so that
		// only one vessel is handled at a time
		ll_rows = upperbound(ll_vessels)
		for ll_row = 1 to ll_rows
			ls_filter = "vessel_nr = "+string(ll_vessels[ll_row]) + " and transtype <> 'DEL'"
			ids_trade.setFilter( ls_filter )
			ids_newtrade.setFilter( ls_filter )
			ids_trade.filter()
			ids_newtrade.filter()

			//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//			if ll_vessels[ll_row] = 6 then 
//				f_datastore_spy(ids_trade)
//				f_datastore_spy(ids_newtrade)
//			end if
			
			ll_newtrades = ids_newtrade.rowcount()
			do until ids_trade.rowcount( ) = ll_newtrades
				if ids_trade.rowcount( ) < ll_newtrades then
					ll_newtrade = ids_trade.InsertRow(0)
				else
					ids_trade.setItem(ids_trade.rowCount(), "transtype", "DEL")
					ids_trade.setItem(ids_trade.rowCount(), "transid", il_currentversion)
					ids_trade.filter()
				end if
			loop
			
			for ll_newtrade = 1 to ll_newtrades
				if ids_trade.getItemNumber(ll_newtrade, "vessel_nr") = ids_newtrade.getItemNumber(ll_newtrade, "vessel_nr") &
				and ids_trade.getItemDatetime(ll_newtrade, "begintime") = ids_newtrade.getItemDatetime(ll_newtrade, "begintime") &
				and ids_trade.getItemDatetime(ll_newtrade, "endtime") = ids_newtrade.getItemDatetime(ll_newtrade, "endtime") &
				and ids_trade.getItemDecimal(ll_newtrade, "fixedprice") = ids_newtrade.getItemDecimal(ll_newtrade, "fixedprice") &
				and ids_trade.getItemNumber(ll_newtrade, "vesselshare") = ids_newtrade.getItemNumber(ll_newtrade, "vesselshare") &
				and ids_trade.getItemString(ll_newtrade, "tradebook") = ids_newtrade.getItemString(ll_newtrade, "tradebook") & 
				and ids_trade.getItemNumber(ll_newtrade, "trade_inout") = ids_newtrade.getItemNumber(ll_newtrade, "trade_inout") then
					continue
				else
					if isNull(ids_trade.getItemString(ll_newtrade, "transtype")) then
						ids_trade.setItem(ll_newtrade, "transtype", "INS")
					else
						ids_trade.setItem(ll_newtrade, "transtype", "UPD")
					end if				
					ids_trade.setItem(ll_newtrade, "transid", il_currentversion )
					ids_trade.setItem(ll_newtrade, "contract_id", ids_newtrade.getItemNumber(ll_newtrade, "contract_id"))
					ids_trade.setItem(ll_newtrade, "vessel_nr" , ids_newtrade.getItemNumber(ll_newtrade, "vessel_nr"))
					ids_trade.setItem(ll_newtrade, "begintime", ids_newtrade.getItemDatetime(ll_newtrade, "begintime"))
					ids_trade.setItem(ll_newtrade, "endtime", ids_newtrade.getItemDatetime(ll_newtrade, "endtime"))
					ids_trade.setItem(ll_newtrade, "fixedprice", ids_newtrade.getItemNumber(ll_newtrade, "fixedprice"))
					ids_trade.setItem(ll_newtrade, "vesselshare", ids_newtrade.getItemNumber(ll_newtrade, "vesselshare"))
					ids_trade.setItem(ll_newtrade, "tradebook", ids_newtrade.getItemString(ll_newtrade, "tradebook"))
					ids_trade.setItem(ll_newtrade, "trade_inout", ids_newtrade.getItemNumber(ll_newtrade, "trade_inout"))
				end if
			next
		next
end choose

//ids_trade.setFilter("")
//ids_trade.filter()
//f_datastore_spy(ids_trade)

return 1

	 
end function

private function integer of_createxmlexport (ref string as_errtext);/********************************************************************
	of_createXMLExport
	<DESC>   
	This function creates a datasore retrieves trades changed in
	current version, and saves it to a XML-file
	The filename will be tramosimport.XML</DESC>
	<RETURN> Integer:
				<LI> 1, X ok
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Private</ACCESS>
	<ARGS>	as_ErrText: String passing error messages</ARGS>
********************************************************************/
datastore lds_data
lds_data = create datastore
lds_data.dataObject = "d_sq_tb_trade_xml_export"
lds_data.setTransObject(SQLCA)
if lds_data.retrieve( il_currentversion ) = -1 then
	as_errtext = "Retrieve of current version failed!"
	destroy lds_data
	return -1
end if

//if lds_data.saveas( "AllegroExport"+string(il_currentversion, "0000")+".xml", XML!, true) <> 1 then
// the name of the file is fixed
if lds_data.saveas( "tramosimport.xml", XML!, true) <> 1 then
	as_errtext = "Failed to save Export to XML file"
	destroy lds_data
	return -1
end if
	
return 1	
end function

private function integer of_sendfile (ref string as_errtext);/********************************************************************
	of_sendFile
	<DESC>
   This function reads the INI file for parameters to send exported XML-file to Allegro through
	MQSeries.
	
	If any parameter is missing an error message is written to the log file.
	
	</DESC>
	<RETURN> Integer:
				<LI> 1, X ok
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Private</ACCESS>
	<ARGS>	as_ErrText: Holds the Error Message if something went
	wrong.</ARGS>
	<USAGE>
	How to use this function.</USAGE>
********************************************************************/
string 	ls_execute_string
string		ls_program, ls_manager, ls_queue

ls_program	= ProfileString ( "AllegroExport.ini", "MQSERIES", "program", "None" )
if ls_program = "None" or len(ls_program) < 2 then
	as_errtext = "Error reading MQSERIES Program name from INI-file. File not sent to Allegro!"
	return -1
end if

ls_manager	= ProfileString ( "AllegroExport.ini", "MQSERIES", "manager", "None" )
if ls_manager = "None" or len(ls_manager) < 2 then
	as_errtext = "Error reading MQSERIES Manager name from INI-file. File not sent to Allegro!"
	return -1
end if

ls_queue	= ProfileString ( "AllegroExport.ini", "MQSERIES", "queue", "None" )
if ls_queue = "None" or len(ls_queue) < 2 then
	as_errtext = "Error reading MQSERIES Queue name from INI-file. File not sent to Allegro!"
	return -1
end if

// Build up the parameters sent to MQSeries. The parameters is stored in the ini-file
ls_execute_string = ls_program + " tramosimport.xml " + ls_manager + " " + ls_queue

Return Run(ls_execute_string)

end function

public function integer of_export (boolean ab_fromtramos, ref string as_errtext, string as_commandline);/********************************************************************
	of_export
	<DESC>   
	This is the function that controlles the export proces</DESC>
	<RETURN> Integer:
				<LI> 1, X ok
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Public</ACCESS>
	<ARGS>	ab_fromTramos: This parameter tells the object if it is
								opened from TRAMOS(true) or STANDALONE(false)
				as_ErrText: This variable is by reference and holds the
								message that is given from the other functions
								if they fail. The reason why this is a parameter
								to the of_export function is that it must be 
								possible to return the value an kaldende 
								object, såfremt exporten startes fra Tramos</ARGS>
	<USAGE>
	Instantiate the object and call the function. Make sure that,
	there is an INI-file available</USAGE>
********************************************************************/
boolean	lb_ConnectToDB
string 	ls_monitorid=""

//Create datastores
if ab_fromtramos then
	lb_ConnectToDB = false
else
	lb_ConnectToDB = true
end if	
if	of_initialize( as_ErrText, lb_ConnectToDB, as_commandline, ls_monitorid ) < 1 then
	of_cleanup( FAIL , as_ErrText, ls_monitorid )
	return c#return.Failure
end if

//Create new transfer and set current version
if of_newtransfer( as_ErrText ) < 1 then
	of_cleanup( FAIL , as_ErrText, ls_monitorid )
	return c#return.Failure
end if

//Fill up the temporary tables #TEMP_TRADE and #TEMP_COMMODITY
if of_fillTempDB( as_ErrText ) < 1 then
	of_cleanup( FAIL , as_ErrText, ls_monitorid )
	return c#return.Failure
end if

//Retrieve all the datastores
if of_retrievedatastores( as_ErrText ) < 1 then
	of_cleanup( FAIL , as_ErrText, ls_monitorid )
	return c#return.Failure
end if

//Process trades
if of_processTrade( as_ErrText ) < 1 then
	of_cleanup( FAIL , as_ErrText, ls_monitorid )
	return c#return.Failure
end if

// Update trades
if ids_trade.update() <> 1 then
	as_errtext = "Failed updating trades..."+sqlca.sqlerrtext
	of_cleanup( FAIL, as_errtext, ls_monitorid )     
end if

// Export to XML
if of_createxmlexport( as_ErrText) < 1 then
	of_cleanup( FAIL, as_errtext, ls_monitorid )     
end if

_addmessage( this.classdefinition, "of_export()", "File tramosimport.xml generated OK", "")

// Send XML file - Not used!
//if of_sendfile( as_ErrText) < 1 then
//	_addmessage( this.classdefinition, "of_export()", as_errtext, "")
//end if

of_cleanup( SUCCES, as_errtext, ls_monitorid )     //false here means that everything went well no failure
_addmessage( this.classdefinition, "of_export()", "Export to Allegro succeeded...", "")

destroy inv_errservice

return c#return.Success
end function

private function integer of_initialize (ref string as_errtext, boolean ab_dbconnect, string as_commandline, ref string as_monitorid);/********************************************************************
	of_initialize
	<DESC>   
	This function is the first function that has to be called for
	exporting data to Allegro. The function creates the errorlog file,
	checks and reads the ini file, 
	connects to the database (only if running as a stand-alone version)
	if started from tramos it uses that transaction, creates the 
	temporary file, and generates	all datastores that has to be used</DESC>
	<RETURN> Integer:
				<LI> 1, X ok
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Private</ACCESS>
	<ARGS>	as_ErrText: Reference to errer text
				ab_dbconnect: 	true = read ini-fileconnect to database
									false = started from another aplication
									and can therefore use this applications
									transaction object</ARGS>
********************************************************************/
string ls_app, ls_version="", ls_logname, ls_debug, ls_transfer
boolean lb_debug = false

n_versioninfo			lnv_versioninfo
mt_n_stringfunctions	lnv_stringfunc
ls_logname = "allegroexport.log"
string ls_method = "allegroexport.open()"

string		ls_sql

lnv_versioninfo = create n_versioninfo
lnv_versioninfo.setispbapp(true)
setnull(ls_app)
ls_version = lnv_versioninfo.getversion(ls_app)
if isnull(ls_version) then ls_version = "n/a"
destroy lnv_versioninfo

/* non critical configuration options from command line */
lnv_stringfunc.of_getcommandlineparm(as_commandline,"/logoutput:", ls_logname, false)

inv_servicemanager.of_loadservice( inv_errService , "n_error_service")
inv_errservice.of_setoutput( 2, ls_logname )

lnv_stringfunc.of_getcommandlineparm(as_commandline,"/monitor_id:", as_monitorid, false)
//SQLCA.of_setmonitorid(ls_monitor_id)

inv_errservice.of_addmsg( this.classdefinition, ls_method, "*************************", "", 0, as_monitorid)
inv_errservice.of_addmsg( this.classdefinition, ls_method, "info, application started", "", 0, as_monitorid)
inv_errservice.of_addmsg( this.classdefinition, ls_method, "info, version number=" + ls_version, "", 0, as_monitorid)


/* critical configuration options from command line which may prevent us from execution */
if lnv_stringfunc.of_getcommandlineparm(as_commandline,"/server:", SQLCA.ServerName, true) = c#return.Failure then
	inv_errservice.of_addmsg( this.classdefinition, ls_method, "Error, missing server information", "", 0, as_monitorid)
	inv_errservice.of_showmessages( )
	return c#return.Failure
else
	
	lnv_stringfunc.of_getcommandlineparm(as_commandline,"/transfer:", ls_transfer, false)
	
	if upper(ls_transfer) = "ALL" then
		ib_transfer_all = true
	else
		ib_transfer_all = false
	end if
	
	if lnv_stringfunc.of_getcommandlineparm(as_commandline,"/db:", SQLCA.Database, true) = c#return.Failure then
		inv_errservice.of_addmsg( this.classdefinition, ls_method, "Error, missing database information", "", 0, as_monitorid)
		inv_errservice.of_showmessages( )
		return c#return.Failure
	else
		if as_monitorid<>"" then 
			inv_errservice.of_addmsg( this.classdefinition, ls_method, "config, monitor_id=" + upper(as_monitorid) , "", 0, as_monitorid)
		end if
				
		SQLCA.DBMS 			= "SYC Sybase System 10"
		SQLCA.LogPass 		= "LKJHGFdsa!##"
		SQLCA.LogId 			= "adminServerApp"
		SQLCA.AutoCommit 	= False
		SQLCA.DBParm 		= "Release='15',UTF8=1, appname='server_allegro' , Host='server_allegro'"
		connect using SQLCA;

		if SQLCA.SQLCode <> 0 then	
			inv_errservice.of_addmsg(this.classdefinition , "open", "Error, unable to connect to database", string(SQLCA.sqlcode) + ":" + SQLCA.sqlerrtext, 0, as_monitorid)	
			inv_errservice.of_showmessages( )
			destroy inv_errservice
			return c#return.Failure
		end if
		if lb_debug then
			inv_errservice.of_addmsg( this.classdefinition, ls_method, "config, d_e_b_u_g=enabled","")
		end if
		inv_errservice.of_addmsg( this.classdefinition, ls_method, "OK", "", 0, as_monitorid)
		inv_errservice.of_showmessages( )

		//////////////////////////
		//  Create temporary TRADE table (vessels)
		ls_sql = "create table #TEMP_TRADE ( " +&
			"TRADEID              int                            identity, " +&
			 "TRANSID              int                            null, " +&
			  "VESSEL_NR            int                            null, " +&
			  "CONTRACT_ID          numeric(7)                     null, " +&
			  "BEGINTIME            datetime                       null, " +&
			  "ENDTIME              datetime                       null, " +&
			  "TRADE_INOUT          int                            not null, " +&
			  "FIXEDPRICE           decimal(14,2)                  null, " +&
			  "VESSELSHARE          decimal(11,10)                  null, " +&
			  "TRADEBOOK            varchar(20)                    null, " +&
			  "TRANSTYPE            char(3)                        not null, " +&
			  "TRANS_STATUS         bit                            default 0 not null, " +&
			  "constraint PK_ALLEGRO_TRADE primary key (TRADEID) )"
		execute immediate :ls_sql;
		if SQLCA.sqlcode <> 0 then
			as_ErrText = "Could not create temporary table #TEMP_TRADE! SQLErrText="+sqlca.sqlerrtext
			return c#return.Failure
		end if

		ids_transfer = create datastore
		ids_transfer.dataObject = "d_sq_allegro_transfer"
		ids_transfer.setTransObject(SQLCA)
		
		ids_trade = create datastore
		ids_trade.dataObject = "d_sq_allegro_trade"
		ids_trade.setTransObject(SQLCA)
		
		ids_newTrade = create datastore
		ids_newTrade.dataObject = "d_sq_allegro_trade"
		ids_newTrade.setTransObject(SQLCA)
	end if
end if		

return 1
end function

private function integer of_cleanup (boolean ab_failed, string as_errtext, string as_monitorid);/********************************************************************
	of_cleanup
	<DESC>   
	This function COMMIT or ROLLBACK the transaction detendent on
	the parameter that is given. It also drops working tables
	and datastores that are used</DESC>
	<RETURN> Integer:
				<LI> 1, X ok 
				<LI> -1, X failed</RETURN>
	<ACCESS> 
	Private</ACCESS>
	<ARGS>	ab_failed: Boolean that tels the function if there where
								something that wents wrong.</ARGS>
	<USAGE>
	You must always call this function. Otherwise the transaction
	will not be finished as it should</USAGE>
********************************************************************/
string		ls_sql

if ab_failed then 
	rollback;
else
	commit;
end if

ls_sql = "drop table #TEMP_TRADE "
execute immediate :ls_sql;

if isValid(ids_transfer) then destroy ids_transfer
if isValid(ids_trade) then destroy ids_trade
if isValid(ids_newTrade) then destroy ids_newTrade

/* Write to log */
inv_errservice.of_addmsg(this.classdefinition , "of_cleanup()", as_errtext, "", 0, as_monitorid)

return 1
end function

on n_allegro_export.create
call super::create
end on

on n_allegro_export.destroy
call super::destroy
end on

