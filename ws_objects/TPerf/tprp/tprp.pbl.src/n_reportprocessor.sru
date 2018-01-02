$PBExportHeader$n_reportprocessor.sru
forward
global type n_reportprocessor from nonvisualobject
end type
end forward

global type n_reportprocessor from nonvisualobject
end type
global n_reportprocessor n_reportprocessor

type variables

Integer NumReports

n_Wrr WrrTable

OLEObject VoyObj, FileObj, RepFileObj
end variables

forward prototypes
private function integer of_processvoyage (string as_repfilename)
public function integer of_deletesubvoyage (long al_voyid)
public function integer of_processreports (string as_reppath, string as_datapath)
end prototypes

private function integer of_processvoyage (string as_repfilename);// This function processes a single voyage leg received as a report file (tpr file)

Integer 		li_RetCode, li_VslID, li_VslSea, li_VslWind, li_RepLoop, li_SailLoop, li_VslWrrVer, li_VslWrrType, li_Percent
n_datastore	lds_data
long			ll_Row, ll_Found, ll_VoyID, ll_RepID
String      ls_TmpStr, ls_VoyNum
Boolean     lbool_TmpBadWx
decimal{3}  ld_TmpVal, ld_TmpSpd, ld_AuxCon, ld_WrrTemp 
decimal{3}  ld_VslDev_OSpd, ld_VslDev_OCon, ld_VslDev_WSpd, ld_VslDev_WCon
decimal{3}  ld_VslDev_OSpdMin, ld_VslDev_OConMin, ld_VslDev_WSpdMin, ld_VslDev_WConMin

If Not (IsValid(VoyObj) And IsValid(FileObj)) then Return -1   // Check OLE objects

li_RetCode = FileObj.OpenFile(as_RepFileName, False, 8192)  // Open report file (tpr file)
If li_RetCode<>0 then Return -2

VoyObj.Load(FileObj)   // Load voyage object from file
FileObj.CloseFile  // Close file

If VoyObj.IOError then Return -3   // If voyage could not load (some error during load)

// Calculate Vessel ID from Vessel Key
li_VslID = (Asc(Left(VoyObj.VslKey, 1)) - 65) * 676
li_VslID = li_VslID + (Asc(Mid(VoyObj.VslKey, 2, 1)) - 65) * 26
li_VslID = li_VslID + (Asc(Right(VoyObj.VslKey, 1)) - 65)

// Check if vessel exists in DB and get warranted settings
SELECT TPERF_W_SEA,   
	TPERF_W_WIND,
	TPERF_DEV_OSPD,
	TPERF_DEV_OCON,
	TPERF_DEV_WSPD,
	TPERF_DEV_WCON,
	TPERF_DEV_OSPD_MIN,
	TPERF_DEV_OCON_MIN,
	TPERF_DEV_WSPD_MIN,
	TPERF_DEV_WCON_MIN,	
	TPERF_WRR_VER,
	TPERF_AUXCON,
	TPERF_WRRTYPE,
	TPERF_WRR_PERCENT
INTO :li_VslSea,   
	:li_VslWind,
	:ld_VslDev_OSpd,
	:ld_VslDev_OCon,
	:ld_VslDev_WSpd,
	:ld_VslDev_WCon,
	:ld_VslDev_OSpdMin,
	:ld_VslDev_OConMin,
	:ld_VslDev_WSpdMin,
	:ld_VslDev_WConMin,	
	:li_VslWrrVer,
	:ld_AuxCon,
	:li_VslWrrType,
	:li_Percent
FROM VESSELS  
WHERE VESSELS.VESSEL_ID = :li_VslID;

// If vessel not found
If SQLCA.Sqlcode<>0 then Return -4

Commit;

//Exit if Warranted settings for vessel are not present
If ld_AuxCon = 0 then Return -8

//Try to retrieve voyage leg with the same voyage key
lds_data = create n_datastore
lds_data.dataobject = "d_sq_tb_table_voyage"
lds_data.setTransObject(SQLCA)
ll_Row = lds_data.Retrieve(VoyObj.Key)

If ll_Row > 0 then  // Voyage leg already exists
	ll_Row = 1
Else  // Otherwise create a new voyage leg
	ll_Row = lds_data.InsertRow(0)
	lds_data.setItem(ll_row, "voy_string", String(VoyObj.Key))	
End if

// Check sendcount of voyage leg. Exit if voyage is older than or equal to last received
If lds_data.GetItemNumber(ll_Row, "sendcount") >= VoyObj.SendCount then	Return -5

// If voyage leg is locked, exit
If lds_data.GetItemNumber(ll_row, "locked") = 1 then
	SetNull(li_RetCode)
	f_AddAlert(lds_data.getItemNumber(ll_row, "voy_id"), 0, 140)
	Return 0
End if
	
// Save T-Perf client app version into vessel table
ls_TmpStr = VoyObj.AppVer
UPDATE VESSELS SET TPERF_VESSEL_VERSION = :ls_tmpstr WHERE VESSEL_ID = :li_VslID;

// No need to check for errors for above SQL as version is not so important
Commit;

// Check voyage number and convert to new format YYXXX(-XX) if necessary - 15 Dec 2010
ls_TmpStr = VoyObj.Number
ls_VoyNum = ls_TmpStr
If Pos(ls_TmpStr, "|") > 0 then   // is current format
	ll_Found = Integer(Right(ls_TmpStr, Len(ls_TmpStr) - Pos(ls_TmpStr, "|")))   // leg number
	ls_TmpStr = Left(ls_TmpStr, Pos(ls_TmpStr, "|") - 1)   // voyage number	
Else    // is old format
	ll_Found = Integer(Right(ls_TmpStr, 2))  // leg number	
	ls_TmpStr = Left(ls_TmpStr, Len(ls_TmpStr) - 3)  // voyage num
End If
If Len(ls_TmpStr) <> 5 and Len(ls_TmpStr) <> 8 then
	If Len(ls_TmpStr) = 4 and IsNumber(ls_TmpStr) then
		ls_VoyNum = Left(ls_TmpStr, 2) + "0" + Right(ls_TmpStr, 2)		
	ElseIf Len(ls_TmpStr) = 7 and Mid(ls_TmpStr, 5, 1) = "-" and IsNumber(Left(ls_TmpStr, 4)) then
		ls_VoyNum = Left(ls_TmpStr, 2) + "0" + Right(ls_TmpStr, 5)
		If Right(ls_VoyNum, 3) = "-xx" Then ls_VoyNum = Left(ls_VoyNum, 5)
	Else
		ls_VoyNum = ls_TmpStr
		ll_Found = 1
	End If
Else
	ls_VoyNum = ls_TmpStr
End If
ls_VoyNum += "|" + String(ll_Found)

// Update voyage fields
lds_data.setItem(ll_row, "voy_num", ls_VoyNum)
lds_data.setItem(ll_row, "voy_type", VoyObj.VoyType)
lds_data.setItem(ll_row, "order_type", VoyObj.ordertype)
lds_data.setItem(ll_row, "order_value", VoyObj.orderValue / 10)
lds_data.setItem(ll_row, "vessel_id", li_VslID )
lds_data.setItem(ll_row, "sendcount", VoyObj.Sendcount)

// Get either Warranted Speed or Consumption range (including min)
If (Voyobj.ordertype = 1) or (Voyobj.ordertype = 13) then 
	lds_data.setItem(ll_row, "wrr_range", ld_VslDev_WSpd )
	lds_data.setItem(ll_row, "wrr_range_min", ld_VslDev_WSpdMin )
Else 
	lds_data.setItem(ll_row, "wrr_range", ld_VslDev_WCon )
	lds_data.setItem(ll_row, "wrr_range_min", ld_VslDev_WConMin )
End If

// Get either ordered speed or consumption (including min)
If (Voyobj.ordertype = 1) or (Voyobj.ordertype = 13) then
	lds_data.setItem(ll_row, "ord_range", ld_VslDev_OCon)
	lds_data.setItem(ll_row, "ord_range_min", ld_VslDev_OConMin)
Else
	lds_data.setItem(ll_row, "ord_range", ld_VslDev_OSpd)
	lds_data.setItem(ll_row, "ord_range_min", ld_VslDev_OSpdMin)
End If
	

// Indicate if ranges are in percentage and not actual
lds_Data.SetItem(ll_row, "Wrr_Percent", li_Percent)

ll_found = lds_data.getitemnumber(ll_row,"Wrr_Ver")  // Save Voyage Wrr Ver for later
lds_data.setItem(ll_row, "Wrr_Ver", li_VslWrrVer)
lds_data.setItem(ll_row, "Aux_Wrr", ld_AuxCon)
lds_data.setItem(ll_row, "Wrr_Type", li_VslWrrType)

if lds_data.update() <> 1 then
	f_Write2Log("Update of voyage failed: " + lds_data.sqlerrortext)
	return -6
end if

ll_VoyID = lds_data.getItemNumber(ll_row, "voy_id")

SetNull(li_RetCode)

If Not IsNull(ll_found) Then  // version number exists
  If li_vslwrrver > ll_found Then f_addalert(ll_VoyID, 0, 130)   // Alert for Wrr Ver upgraded
End if

// Delete all rows in other tables (expect alerts) linked to this voyage
li_RetCode = of_DeleteSubVoyage(ll_VoyID)
If li_RetCode<>0 then Return -7

// Try to find another voyage with same voyage number. If found, raise alert.
ls_TmpStr = Right(VoyObj.Key,6)
Select Count(VOY_ID) Into :ll_Found From TPERF_VOY Where (VESSEL_ID = :li_VslID) and (VOY_NUM = :ls_VoyNum) and (Right(VOY_STRING,6) <> :ls_tmpstr);
If SQLCA.SQLCode = 0 then
	If ll_Found > 0 then f_AddAlert(ll_VoyID, 0, 120)
End If

Commit;

// Create and update reports
For li_reploop= 1 to VoyObj.ReportCount
	lds_data.dataobject = "d_sq_tb_table_report"
	lds_data.setTransObject(SQLCA)
	ll_row = lds_data.InsertRow(0)
	lds_data.setitem( ll_row, "VOY_ID", ll_VoyID)
	lds_data.setitem( ll_row, "UTC" ,VoyObj.Report(li_reploop).UTCTime)
	lds_data.setitem( ll_row, "Zone" ,VoyObj.Report(li_reploop).Zone/2)
	lds_data.setitem( ll_row, "Type" ,VoyObj.Report(li_reploop).RepType)
	lds_data.setitem( ll_row, "Lat" ,VoyObj.Report(li_reploop).Lat)
	lds_data.setitem( ll_row, "Lng" ,VoyObj.Report(li_reploop).Lng)
	lds_data.setitem( ll_row, "DTG" ,VoyObj.Report(li_reploop).Dtg/10)
	If li_reploop>1 then	lds_data.setitem( ll_row, "PORT" ,VoyObj.Report(li_reploop).DestPort) else lds_data.setitem( ll_row, "PORT" ,VoyObj.DepPort)
	lds_data.setitem( ll_row, "AirTemp" ,VoyObj.Report(li_reploop).Temp)
	lds_data.setitem( ll_row, "Sea" ,VoyObj.Report(li_reploop).SeaState)
	lds_data.setitem( ll_row, "Wind" ,VoyObj.Report(li_reploop).WindSpd)
	lds_data.setitem( ll_row, "Wind_Dir" ,VoyObj.Report(li_reploop).WindDir)
	lds_data.setitem( ll_row, "Draft" ,VoyObj.Report(li_reploop).Draft/10)
	lds_data.setitem( ll_row, "ETA" ,VoyObj.Report(li_reploop).LocalETA)
	lds_data.setitem( ll_row, "Remarks" ,VoyObj.Report(li_reploop).Remark)
	lds_data.setitem( ll_row, "Reason" ,VoyObj.Report(li_reploop).Reason)
	lds_data.setitem( ll_row, "Stoppage" ,VoyObj.Report(li_reploop).Stoppage/100)
	lds_data.setitem( ll_row, "Serial" ,li_reploop)
	
	ll_repID = lds_data.update( )
	
	if ll_repID <> 1 then
		f_Write2Log("Update of report failed: " + lds_data.sqlerrortext)
		return -6
	else
		commit;
	end if
	
	// Check and raise alerts for remarks, reason, stoppage & custom port
	ls_tmpstr = VoyObj.Report(li_reploop).Reason 
	If len(ls_tmpstr) > 0 then 
		ls_tmpstr = Trim(Upper(ls_tmpstr))
		If (ls_tmpstr <> "NA") and (ls_tmpstr <> "NO COMMENTS") and (ls_tmpstr <> "NO COMMENT") and (ls_tmpstr <> "NONE") and (ls_tmpstr <> "N/A") then f_AddAlert(ll_VoyID, li_reploop, 100)
	End If
	ls_tmpstr = VoyObj.Report(li_reploop).Remark 
	If len(ls_tmpstr) > 0 then 
		ls_tmpstr = Trim(Upper(ls_tmpstr))
		If (ls_tmpstr <> "NA") and (ls_tmpstr <> "NO COMMENTS") and (ls_tmpstr <> "NO COMMENT") and (ls_tmpstr <> "NONE") and (ls_tmpstr <> "N/A") then f_AddAlert(ll_VoyID, li_reploop, 90)
	End If
	ll_RepID = VoyObj.Report(li_reploop).Stoppage
	if ll_RepID > 0 then f_AddAlert(ll_VoyID, li_reploop, 110)
	If li_reploop>1 then ls_tmpstr = VoyObj.Report(li_reploop).DestPort else ls_tmpstr = VoyObj.DepPort
	If Left(ls_tmpstr,2) = "^^" then f_AddAlert(ll_VoyID, li_reploop, 160)
	
	ll_RepID = lds_data.getItemNumber(ll_row, "Rep_id")

	lbool_TmpBadWx = False	
	If (VoyObj.Report(li_reploop).WindSpd > li_VslWind) Or (VoyObj.Report(li_reploop).SeaState > li_VslSea) then lbool_TmpBadWx = True
		
	// Create and update saildata
	lds_data.dataobject = "d_sq_tb_table_saildata"
	lds_data.setTransObject(SQLCA)
	
	If lbool_TmpBadWx then // Check for weather
		ll_row = lds_data.InsertRow(0)  
		lds_data.setitem( ll_row, "REP_ID", ll_RepID)  // Set ReportID
		
		lds_data.setitem(ll_row, "Type", 4)  // Set SailType to bad wx
		lds_data.setitem(ll_row, "Period",  VoyObj.Report(li_reploop).SailData.GetPeriod(10) / 100)
		lds_data.setitem(ll_row, "Dist",  VoyObj.Report(li_reploop).SailData.GetDistance(10) / 10)
		lds_data.setitem(ll_row, "MEHSFO",  VoyObj.Report(li_reploop).SailData.GetMEHSFO(10) / 10)
		lds_data.setitem(ll_row, "MELSFO",  VoyObj.Report(li_reploop).SailData.GetMELSFO(10) / 10)
		lds_data.setitem(ll_row, "MEDO",  VoyObj.Report(li_reploop).SailData.GetMEDO(10) / 10)			
		lds_data.setitem(ll_row, "MEGO",  VoyObj.Report(li_reploop).SailData.GetMEGO(10) / 10)			
		lds_data.setitem(ll_row, "WRR_CALC", 0)
		
	Else
		
		For li_sailloop = 0 to 3
			If VoyObj.Report(li_reploop).SailData.GetPeriod(li_sailloop) > 0 then
				ll_row = lds_data.InsertRow(0)  
				lds_data.setitem( ll_row, "REP_ID", ll_RepID)  // Set ReportID
				
				lds_data.setitem(ll_row, "Type", li_sailloop)  // Set SailType
								
				lds_data.setitem(ll_row, "Period",  VoyObj.Report(li_reploop).SailData.GetPeriod(li_sailloop) / 100)
				lds_data.setitem(ll_row, "Dist",  VoyObj.Report(li_reploop).SailData.GetDistance(li_sailloop) / 10)
				lds_data.setitem(ll_row, "MEHSFO",  VoyObj.Report(li_reploop).SailData.GetMEHSFO(li_sailloop) / 10)
				lds_data.setitem(ll_row, "MELSFO",  VoyObj.Report(li_reploop).SailData.GetMELSFO(li_sailloop) / 10)
				lds_data.setitem(ll_row, "MEDO",  VoyObj.Report(li_reploop).SailData.GetMEDO(li_sailloop) / 10)			
				lds_data.setitem(ll_row, "MEGO",  VoyObj.Report(li_reploop).SailData.GetMEGO(li_sailloop) / 10)			
				
				// Check ordered spd/cons and wrr spd/cons and raise alerts if necessary
				If lds_data.GetItemnumber( ll_row, "Type") = 0 then   // Sailing is Fullspeed
					If (VoyObj.OrderType = 0) or (VoyObj.OrderType = 10) then  // If full speed is ordered
						// Get actual speed of vessel
						ld_TmpSpd = Round(Voyobj.Report(li_reploop).Saildata.GetDistance(0) * 10 / Voyobj.Report(li_reploop).Saildata.GetPeriod(0),1)
						// subtract from ordered speed to get deviation
						ld_TmpVal = (Voyobj.OrderValue / 10) - ld_TmpSpd
						If li_Percent = 0 Then  // If warranted deviation values are direct, check deviation and raise alert if out of range
							If ld_TmpVal > ld_VslDev_OSpdMin and ld_TmpVal > 0.2 then f_AddAlert(ll_VoyID, li_reploop, 10)
							If -ld_TmpVal > ld_VslDev_OSpd and ld_TmpVal < -0.2 then f_AddAlert(ll_VoyID, li_reploop, 20)	
						Else // deviation values are in percentage, check deviation and raise alert if out of range
							If ld_TmpVal > ld_VslDev_OSpdMin * Voyobj.OrderValue / 1000 and ld_TmpVal > 0.2 then f_AddAlert(ll_VoyID, li_reploop, 10)
							If -ld_TmpVal > ld_VslDev_OSpd * Voyobj.OrderValue / 1000 and ld_TmpVal < -0.2 then f_AddAlert(ll_VoyID, li_reploop, 20)
						End If
						// If warranted table exists
						If Wrrtable.WrrTableExists(li_VslID, Byte(VoyObj.VoyType)) then
							ld_TmpVal = Voyobj.Report(li_reploop).Saildata.GetMEHSFO(0) + Voyobj.Report(li_reploop).Saildata.GetMELSFO(0)+Voyobj.Report(li_reploop).Saildata.GetMEDO(0) + Voyobj.Report(li_reploop).Saildata.GetMEGO(0)
							If li_VslWrrType = 0 then   // Include A/E Cons
								ld_TmpVal = ld_TmpVal + VoyObj.Report(li_repLoop).Cons.GetOilConsHSFO(1) + VoyObj.Report(li_repLoop).Cons.GetOilConsLSFO(1) + VoyObj.Report(li_repLoop).Cons.GetOilConsDO(1) + VoyObj.Report(li_repLoop).Cons.GetOilConsGO(1)
								ld_TmpVal = ld_TmpVal + VoyObj.Report(li_repLoop).Cons.GetOilConsHSFO(2) + VoyObj.Report(li_repLoop).Cons.GetOilConsLSFO(2) + VoyObj.Report(li_repLoop).Cons.GetOilConsDO(2) + VoyObj.Report(li_repLoop).Cons.GetOilConsGO(2)							
							End If
							ld_TmpVal = Round(ld_TmpVal * 240 / Voyobj.Report(li_reploop).Saildata.GetPeriod(0),1)
							lds_data.setitem(ll_row, "WRR_CALC", Wrrtable.Getwrrcons( li_VslID, VoyObj.VoyType, ld_TmpSpd))
							ld_WrrTemp = Wrrtable.GetWrrCons( li_VslID, VoyObj.VoyType, ld_TmpSpd)
							ld_TmpVal = ld_WrrTemp - ld_TmpVal
							If li_VslWrrType = 0 then	ld_TmpVal = ld_TmpVal + ld_AuxCon   // Aux con is included
							If li_Percent = 0 then // If deviation values are direct
								If ld_TmpVal > ld_VslDev_WConMin then f_addalert(ll_VoyID, li_reploop, 80)
								If -ld_TmpVal > ld_VslDev_WCon then f_addalert(ll_VoyID, li_reploop, 70)	
							Else // deviation values are in percent
								If ld_TmpVal > ld_VslDev_WConMin * ld_WrrTemp / 100 then f_AddAlert(ll_VoyID, li_reploop, 80)
								If -ld_TmpVal > ld_VslDev_WCon * ld_WrrTemp / 100 then f_AddAlert(ll_VoyID, li_reploop, 70)								
							End If
						End if 
					ElseIf (VoyObj.OrderType = 1) or (VoyObj.OrderType = 3) or (VoyObj.OrderType = 13) then  // if ordered cons
						// Get M/E consumption HSFO + LSFO + DO + GO at full speed
						ld_TmpVal = Voyobj.Report(li_reploop).Saildata.GetMEHSFO(0) + Voyobj.Report(li_reploop).Saildata.GetMELSFO(0)+Voyobj.Report(li_reploop).Saildata.GetMEDO(0) + Voyobj.Report(li_reploop).Saildata.GetMEGO(0)
						// Calc per day consumption
						ld_TmpVal = Round(ld_TmpVal * 240 / Voyobj.Report(li_reploop).Saildata.GetPeriod(0), 1)
						// Get deviation from ordered value
						ld_TmpSpd = ld_TmpVal - (Voyobj.OrderValue / 10)
						If li_Percent = 0 then  // If deviation is direct, compare with allowed deviation and raise alert if out of range
							If ld_TmpSpd > ld_VslDev_OCon then f_AddAlert(ll_VoyID, li_reploop, 30)
							If -ld_TmpSpd > ld_VslDev_OConMin then f_AddAlert(ll_VoyID, li_reploop, 40)
						Else  // If deviation allowd is percent, calculate allowance and raise alert if out of range
							If ld_TmpSpd > Voyobj.OrderValue * ld_VslDev_OCon / 1000 then f_AddAlert(ll_VoyID, li_reploop, 30)
							If -ld_TmpSpd > Voyobj.OrderValue * ld_VslDev_OConMin / 1000 then f_AddAlert(ll_VoyID, li_reploop, 40)
						End If
						// If warranted table exists
						If Wrrtable.WrrTableExists( li_VslID, Byte(VoyObj.VoyType)) then
							// Calc full speed of vessel
							ld_TmpSpd = Round(Voyobj.Report(li_reploop).Saildata.GetDistance(0) * 10 / Voyobj.Report(li_reploop).Saildata.GetPeriod(0), 1)
							// Obtain warranted cons for that speed
							ld_WrrTemp = Round(WrrTable.Getwrrspd(li_VslID, VoyObj.VoyType, ld_TmpVal),1)
							// Save in table
							lds_data.setitem(ll_row, "WRR_CALC", ld_WrrTemp)
							// Calc deviation from warranted speed
							ld_TmpSpd = ld_WrrTemp - ld_TmpSpd
							If li_Percent = 0 then // If deviation is direct, compare with allowed deviation and raise alert if out of range
								If ld_TmpSpd > ld_VslDev_WSpdMin and ld_TmpSpd > 0.2 then f_addalert(ll_VoyID, li_reploop, 50)
								If -ld_TmpSpd > ld_VslDev_WSpd and ld_TmpSpd < -0.2 then f_addalert(ll_VoyID, li_reploop, 60)	
							Else // If deviation allowd is percent, calculate allowance and raise alert if out of range
								If ld_TmpSpd > ld_VslDev_WSpdMin * ld_WrrTemp / 100 and ld_TmpSpd > 0.2 then f_addalert(ll_VoyID, li_reploop, 50)
								If -ld_TmpSpd > ld_VslDev_WSpd * ld_WrrTemp / 100 and ld_TmpVal < -0.2 then f_addalert(ll_VoyID, li_reploop, 60)	
							End If
						end if
					end if
				Else
					lds_data.setitem(ll_row, "WRR_CALC", 0)
				end if		
			end if
		Next 
	End If	
	
	If lds_data.update() = 1 then
		commit;
	Else
		f_Write2Log("Update of Saildata: " + lds_data.sqlerrortext)
		return -6
	End if	
	
	lds_data.dataobject = "d_sq_tb_table_repcon"
	lds_data.setTransObject(SQLCA)
	li_retcode = 1
	
	// Process Aux Consumption
	ld_TmpVal = voyobj.report(li_repLoop).SailData.GetPeriod(10) + VoyObj.Report(li_RepLoop).Stoppage    // Total Period * 100
	If lbool_TmpBadWx then // Check Bad Wx
		ll_found = VoyObj.report(li_repLoop).SailData.GetPeriod(10)
		If ll_found > 0 then
			ll_row=lds_data.InsertRow(0)
			lds_data.setitem( ll_row, "REP_ID", ll_RepID)			
			lds_data.setitem( ll_row, "ConType", 4) 
			
			lds_data.setitem( ll_row, "PERIOD", ll_found/100)
			
			ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsHSFO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsHSFO(2))
			ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
			lds_data.setitem( ll_row, "QTY_HSFO", ld_TmpSpd/10)
			
			ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsLSFO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsLSFO(2))
			ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
			lds_data.setitem( ll_row, "QTY_LSFO", ld_TmpSpd/10)
			
			ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsDO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsDO(2))
			ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
			lds_data.setitem( ll_row, "QTY_DO", ld_TmpSpd/10)
			
			ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsGO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsGO(2))
			ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
			lds_data.setitem( ll_row, "QTY_GO", ld_TmpSpd/10)

			lds_data.setitem( ll_row, "SERIAL", li_retcode)
			li_RetCode++			
		End if		
	Else
		For li_SailLoop = 0 to 3
			ll_found = VoyObj.report(li_repLoop).SailData.GetPeriod(li_SailLoop)
			If ll_found > 0 then
				ll_row=lds_data.InsertRow(0)
				lds_data.setitem( ll_row, "REP_ID", ll_RepID)			
				lds_data.setitem( ll_row, "ConType", li_sailloop)
				
				lds_data.setitem( ll_row, "PERIOD", ll_found/100)
				
				ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsHSFO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsHSFO(2))
				ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
				lds_data.setitem( ll_row, "QTY_HSFO", ld_TmpSpd/10)
				
				ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsLSFO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsLSFO(2))
				ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
				lds_data.setitem( ll_row, "QTY_LSFO", ld_TmpSpd/10)
				
				ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsDO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsDO(2))
				ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
				lds_data.setitem( ll_row, "QTY_DO", ld_TmpSpd/10)
				
				ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsGO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsGO(2))
				ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
				lds_data.setitem( ll_row, "QTY_GO", ld_TmpSpd/10)
	
				lds_data.setitem( ll_row, "SERIAL", li_retcode)
				li_RetCode++			
			End if
		Next
	End If
	
	ll_found = VoyObj.Report(li_RepLoop).Stoppage 
	If ll_found > 0 then
		ll_row=lds_data.InsertRow(0)
		lds_data.setitem( ll_row, "REP_ID", ll_RepID)			
		lds_data.setitem( ll_row, "ConType", 5)
		lds_data.setitem( ll_row, "PERIOD", ll_found/100)
		
		ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsHSFO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsHSFO(2))
		ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
		lds_data.setitem( ll_row, "QTY_HSFO", ld_TmpSpd/10)
		
		ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsLSFO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsLSFO(2))
		ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
		lds_data.setitem( ll_row, "QTY_LSFO", ld_TmpSpd/10)
		
		ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsDO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsDO(2))
		ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
		lds_data.setitem( ll_row, "QTY_DO", ld_TmpSpd/10)
		
		ld_TmpSpd = (VoyObj.Report(li_reploop).Cons.GetOilConsGO(1) + VoyObj.Report(li_reploop).Cons.GetOilConsGO(2))
		ld_TmpSpd = ll_found / ld_TmpVal * ld_TmpSpd
		lds_data.setitem( ll_row, "QTY_GO", ld_TmpSpd/10)

		lds_data.setitem( ll_row, "SERIAL", li_retcode)
		li_RetCode++			
	End if
	
	// Process other consumption (3-7 >>> Vessel Oil Types)
	For li_sailloop = 3 to 7   
		if VoyObj.Report(li_reploop).Cons.GetOilPeriod(li_sailloop) > 0 then
			ll_row=lds_data.InsertRow(0)
			lds_data.setitem( ll_row, "REP_ID", ll_RepID)			
			lds_data.setitem( ll_row, "ConType", li_sailloop + 10)			
			lds_data.setitem( ll_row, "PERIOD", VoyObj.Report(li_reploop).Cons.GetOilPeriod(li_sailloop)/100)
			lds_data.setitem( ll_row, "QTY_HSFO", VoyObj.Report(li_reploop).Cons.GetOilConsHSFO(li_sailloop)/10)
			lds_data.setitem( ll_row, "QTY_LSFO", VoyObj.Report(li_reploop).Cons.GetOilConsLSFO(li_sailloop)/10)
			lds_data.setitem( ll_row, "QTY_DO", VoyObj.Report(li_reploop).Cons.GetOilConsDO(li_sailloop)/10)
			lds_data.setitem( ll_row, "QTY_GO", VoyObj.Report(li_reploop).Cons.GetOilConsGO(li_sailloop)/10)
			lds_data.setitem( ll_row, "SERIAL", li_retcode)
			li_RetCode++
		end if
	next
	ll_row=lds_data.InsertRow(0)
	lds_data.setitem( ll_row, "REP_ID", ll_RepID)
	lds_data.setitem( ll_row, "ConType", 18)  // ROB
	lds_data.setitem( ll_row, "PERIOD", 0)
	lds_data.setitem( ll_row, "QTY_HSFO", VoyObj.Report(li_reploop).Cons.GetOilConsHSFO(8)/10)
	lds_data.setitem( ll_row, "QTY_LSFO", VoyObj.Report(li_reploop).Cons.GetOilConsLSFO(8)/10)
	lds_data.setitem( ll_row, "QTY_DO", VoyObj.Report(li_reploop).Cons.GetOilConsDO(8)/10)
	lds_data.setitem( ll_row, "QTY_GO", VoyObj.Report(li_reploop).Cons.GetOilConsGO(8)/10)
	lds_data.setitem( ll_row, "SERIAL", li_retcode)

	if lds_data.update() = 1 then
		commit;
	else
		f_Write2Log("Update of RepCon failed: " + lds_data.sqlerrortext)
		return -6
	End if		
Next 


// Calc Wrr_Calc for Voyage table (only for Full speed)
VoyObj.SetWxLimit(li_VslSea, li_VslWind)  // Exclude Bad Wx

If VoyObj.GetPeriod(0) > 0 then
	if wrrtable.wrrtableexists( li_VslID, Voyobj.VoyType) then
		If (VoyObj.OrderType = 0) or (VoyObj.OrderType = 10) then
			ld_TmpVal = wrrtable.getwrrcons(li_VslID , Voyobj.VoyType, Round(VoyObj.GetDistance(0)*10/VoyObj.GetPeriod(0), 1))
		Else
			ld_TmpVal = wrrtable.getwrrspd(li_VslID , Voyobj.VoyType, Round((VoyObj.GetMEHSFO(0)+ VoyObj.GetMELSFO(0) + VoyObj.GetMEDO(0) + VoyObj.GetMEGO(0))*240/VoyObj.GetPeriod(0), 1))
		End If
		ld_TmpVal = Round(ld_TmpVal, 1)
	else
		ld_TmpVal=0
	End If
	
	// Save value into table
	UPDATE TPERF_VOY SET WRR_CALC=:ld_TmpVal WHERE VOY_ID = :ll_VoyID;
	If SQLCA.Sqlcode<>0 then f_AddSysAlert(5, as_Repfilename, SQLCA.Sqlcode, SQLCA.Sqlerrtext)
	Commit;
End if

// Create and update Dep Harbour data

For li_reploop= 1 to VoyObj.DepH.PortCount
	lds_data.dataobject = "d_sq_tb_table_hrbr"
	lds_data.setTransObject(SQLCA)
	ll_row=lds_data.InsertRow(0)
	lds_data.setitem( ll_row, "VOY_ID", ll_VoyID)
	lds_data.setitem( ll_row, "H_TYPE", VoyObj.DepH.Port(li_reploop).StayType)
	lds_data.setitem( ll_row, "PORT", VoyObj.DepH.Port(li_reploop).PortCode)
	lds_data.setitem( ll_row, "Berth", VoyObj.DepH.Port(li_reploop).Berth)
	lds_data.setitem( ll_row, "PER_MAN", VoyObj.DepH.Port(li_reploop).PortStay(1)/10)
	lds_data.setitem( ll_row, "PER_CARGO", VoyObj.DepH.Port(li_reploop).PortStay(2)/10)
	lds_data.setitem( ll_row, "PER_IDLE", VoyObj.DepH.Port(li_reploop).PortStay(3)/10)
	lds_data.setitem( ll_row, "PER_MISC", VoyObj.DepH.Port(li_reploop).PortStay(4)/10)
	lds_data.setitem( ll_row, "IS_DEP", 1)
	if lds_data.update() = 1 then
		commit;
	else
		f_Write2Log("Update of Hrbr-Dep failed: " + lds_data.sqlerrortext)
		return -6
	end if			
	ll_RepID = lds_data.GetItemNumber(ll_row, "H_ID")

	// Create & update HrbrCon
	lds_data.dataobject = "d_sq_tb_table_hrbrcon"
	lds_data.setTransObject(SQLCA)
	li_retCode = 0
	For li_sailloop = 0 to 9
		If VoyObj.DepH.Port(li_reploop).PortFuel.GetOilConsHSFO(li_sailloop) + VoyObj.DepH.Port(li_reploop).PortFuel.GetOilConsLSFO(li_sailloop)+ VoyObj.DepH.Port(li_reploop).PortFuel.GetOilConsDO(li_sailloop)+VoyObj.DepH.Port(li_reploop).PortFuel.GetOilConsGO(li_sailloop) > 0 then
			ll_row=lds_data.insertrow(0)
			lds_data.setitem( ll_row, "H_ID", ll_RepID)
			lds_data.setitem( ll_row, "ConType", li_sailloop + 10)
			lds_data.setitem( ll_row, "QTY_HSFO", VoyObj.DepH.Port(li_reploop).PortFuel.GetOilConsHSFO(li_sailloop)/10)
			lds_data.setitem( ll_row, "QTY_LSFO", VoyObj.DepH.Port(li_reploop).PortFuel.GetOilConsLSFO(li_sailloop)/10)
			lds_data.setitem( ll_row, "QTY_DO", VoyObj.DepH.Port(li_reploop).PortFuel.GetOilConsDO(li_sailloop)/10)
			lds_data.setitem( ll_row, "QTY_GO", VoyObj.DepH.Port(li_reploop).PortFuel.GetOilConsGO(li_sailloop)/10)
			lds_data.setitem( ll_row, "Serial", li_retcode)
			li_retcode++
			If lds_data.update() = 1 then
				commit;
			Else
				f_Write2Log("Update of HrbrCon-Dep: " + lds_data.sqlerrortext)
				return -6
			End If			
		End If
	Next 
Next

// Create and update Arr Harbour data
For li_reploop= 1 to VoyObj.ArrH.PortCount
	lds_data.dataobject = "d_sq_tb_table_hrbr"
	lds_data.setTransObject(SQLCA)
	ll_row=lds_data.InsertRow(0)
	lds_data.setitem( ll_row, "VOY_ID", ll_VoyID)
	lds_data.setitem( ll_row, "H_TYPE", VoyObj.ArrH.Port(li_reploop).StayType)
	lds_data.setitem( ll_row, "PORT", VoyObj.ArrH.Port(li_reploop).PortCode)
	lds_data.setitem( ll_row, "Berth", VoyObj.ArrH.Port(li_reploop).Berth)
	lds_data.setitem( ll_row, "PER_MAN", VoyObj.ArrH.Port(li_reploop).PortStay(1)/10)
	lds_data.setitem( ll_row, "PER_CARGO", VoyObj.ArrH.Port(li_reploop).PortStay(2)/10)
	lds_data.setitem( ll_row, "PER_IDLE", VoyObj.ArrH.Port(li_reploop).PortStay(3)/10)
	lds_data.setitem( ll_row, "PER_MISC", VoyObj.ArrH.Port(li_reploop).PortStay(4)/10)
	lds_data.setitem( ll_row, "IS_DEP", 0)
	if lds_data.update() = 1 then
		commit;
	else
		f_Write2Log("Update of Hrbr-Arr failed: " + lds_data.sqlerrortext)
		return -6
	end if			
	ll_RepID = lds_data.GetItemNumber(ll_row, "H_ID")

	// Create & update HrbrCon
	lds_data.dataobject = "d_sq_tb_table_hrbrcon"
	lds_data.setTransObject(SQLCA)
	li_retCode = 0
	For li_sailloop = 0 to 9
		If VoyObj.ArrH.Port(li_reploop).PortFuel.GetOilConsHSFO(li_sailloop)+VoyObj.ArrH.Port(li_reploop).PortFuel.GetOilConsLSFO(li_sailloop) + VoyObj.ArrH.Port(li_reploop).PortFuel.GetOilConsDO(li_sailloop)+VoyObj.ArrH.Port(li_reploop).PortFuel.GetOilConsGO(li_sailloop) > 0 then
			ll_row=lds_data.insertrow(0)
			lds_data.setitem( ll_row, "H_ID", ll_RepID)
			lds_data.setitem( ll_row, "ConType", li_sailloop + 10)
			lds_data.setitem( ll_row, "QTY_HSFO", VoyObj.ArrH.Port(li_reploop).PortFuel.GetOilConsHSFO(li_sailloop)/10)
			lds_data.setitem( ll_row, "QTY_LSFO", VoyObj.ArrH.Port(li_reploop).PortFuel.GetOilConsLSFO(li_sailloop)/10)
			lds_data.setitem( ll_row, "QTY_DO", VoyObj.ArrH.Port(li_reploop).PortFuel.GetOilConsDO(li_sailloop)/10)
			lds_data.setitem( ll_row, "QTY_GO", VoyObj.ArrH.Port(li_reploop).PortFuel.GetOilConsGO(li_sailloop)/10)
			lds_data.setitem( ll_row, "Serial", li_retcode)
			li_retcode++
			If lds_data.update() = 1 then
				commit;
			Else
				f_Write2Log("Update of HrbrCon-Arr: " + lds_data.sqlerrortext)
				return -6
			End if			
		End If
	Next 	
Next

Return 0


/* Return Codes

 0 = All okay
-1 = OLE Objects not ready
-2 = Could not open File
-3 = Could not load voyage
-4 = Vessel not found
-5 = Voyage is older than current
-6 = Update failed
-7 = VoyageSub Delete failed
-8 = Vessel Warranted Settings not entered

*/
end function

public function integer of_deletesubvoyage (long al_voyid);
// Delete all SailData
DELETE TPERF_SAILDATA
FROM TPERF_REPORTS,
	TPERF_SAILDATA
WHERE TPERF_REPORTS.REP_ID = TPERF_SAILDATA.REP_ID
AND TPERF_REPORTS.VOY_ID=:al_VoyID;
if SQLCA.sqlcode<>0 then return -7
commit;

// Delete all RepCon
DELETE TPERF_REPCON
FROM TPERF_REPORTS,
	TPERF_REPCON
WHERE TPERF_REPORTS.REP_ID = TPERF_REPCON.REP_ID
AND TPERF_REPORTS.VOY_ID=:al_VoyID;
if SQLCA.sqlcode<>0 then return -7
commit;

// Delete all Reports
DELETE FROM TPERF_REPORTS WHERE VOY_ID=:al_VoyID;
if SQLCA.sqlcode<>0 then return -7
Commit;

// Delete all HrbrCon
DELETE TPERF_HRBRCON
FROM TPERF_HRBR,
	TPERF_HRBRCON
WHERE TPERF_HRBR.H_ID = TPERF_HRBRCON.H_ID
AND TPERF_HRBR.VOY_ID=:al_VoyID;
if SQLCA.sqlcode<>0 then return -7
commit;

// Delete all Harbours
DELETE FROM TPERF_HRBR WHERE VOY_ID=:al_VoyID;
If SQLCA.sqlcode<>0 then return -7
commit;

Return 0
end function

public function integer of_processreports (string as_reppath, string as_datapath);// This function runs a loop and processes all incoming reports

Integer li_rep, li_counter, li_listcount
string ls_repfile, ls_errcode, ls_nextfile

// Check if ActiveX objects are valid
If Not (IsValid(VoyObj) AND IsValid(FileObj) AND IsValid(RepFileObj)) then 
	f_Write2Log("ActiveX objects not ready")
	Return -1
End If

If Not DirectoryExists(as_RepPath) then f_addsysalert(0, "N/A", 0, as_RepPath + " not found")

// Deletes other files:  *.txt  *.htm  *(?).tpr 
RepFileObj.DeleteOtherFiles(as_RepPath)

RepFileObj.CreateLockFile(g_AppFolder)

li_listcount = RepFileobj.GetReports(as_RepPath, "*.TPR")

For li_Counter=1 to li_ListCount
	ls_RepFile = RepFileObj.GetfileName(li_Counter)   // Get first file
	
	w_Main.st_Msg.Text = "Processing " + ls_RepFile
	
	//Check if next file is the same voyage leg
	If li_Counter < li_ListCount then
		ls_NextFile = RepFileObj.GetFileName(li_Counter + 1)  // Get next file
		ls_NextFile = Left(ls_NextFile, 9)    // Strip to voyage ID
		If ls_Nextfile = Left(ls_RepFile, 9)  then  // If same voyage leg
			FileDelete(as_RepPath + ls_RepFile)   // Delete file
			ls_RepFile = "" 
		End If
	End If
	
	If ls_Repfile > "" then
	
		Execute Immediate "begin transaction";   // Begin main transaction
	  
		li_Rep = of_ProcessVoyage(as_RepPath + ls_repfile)
		
		if li_Rep<>0 then 	
			Rollback;   //  This rolls back all transactions and begins new PB trans
			choose case li_rep
				case -1
					ls_errcode = "OLE Objects not ready"
				case -2
					ls_errcode = "Could not open file"
				case -3
					ls_errcode = "Voyage.IOError"
				case -4
					ls_errcode = "Vessel not found"
				case -5
					ls_errcode = "Older voyage rejected"
				Case -6
					ls_errcode = "Update failed"
				case -7
					ls_errcode = "VoySub Delete failed"
				case -8
					ls_errcode = "WRR settings not found"
			End choose
			f_AddSysAlert(1, ls_repfile, li_rep, ls_errcode)
			RepFileObj.DelVoyageFiles(as_DataPath + left(ls_repfile,3) + '\', ls_repfile)
			f_transfervoyage(ls_repfile, as_RepPath, as_DataPath, True)
			If SQLCA.SQLCode<>0 then f_Write2Log(SQLCA.SQLErrText)
		Else 
			Execute Immediate "commit transaction";  // This ends PB Trans
			Commit;     //  This commits main trans & start new PB trans
			RepFileObj.DelVoyageFiles(as_DataPath + Left(ls_repfile,3) + '\', ls_repfile)  // Delete all previous files from same voyage
			f_Transfervoyage(ls_RepFile, as_RepPath, as_DataPath, False)
		End if
	End If
Next

RepFileObj.ReleaseLockFile

Return 0
end function

on n_reportprocessor.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_reportprocessor.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;Integer li_rc

FileObj=CREATE OLEObject
li_rc = FileObj.ConnectToNewObject("ClassIO.FileClass")
If li_rc < 0 THEN DESTROY FileObj

VoyObj=CREATE OLEObject
li_rc = VoyObj.ConnectToNewObject("TPerf.VoyageClass")
If li_rc < 0 THEN DESTROY VoyObj

RepFileObj=CREATE OLEObject
li_rc = RepFileObj.ConnectToNewObject("TPerf.ReportFiles")
If li_rc < 0 THEN DESTROY RepFileObj

WrrTable = Create n_wrr

end event

event destructor;
If IsValid(VoyObj) then DESTROY VoyObj
If IsValid(FileObj) then DESTROY FileObj
If IsValid(RepFileObj) then DESTROY RepFileObj

Destroy (WrrTable)
end event

