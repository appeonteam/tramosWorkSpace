HA$PBExportHeader$n_voyage.sru
forward
global type n_voyage from nonvisualobject
end type
end forward

global type n_voyage from nonvisualobject
end type
global n_voyage n_voyage

type variables

n_datastore ids_Voyage, ids_Reports, ids_SailData, ids_RepCon, ids_Hrbr, ids_HrbrCon

string ErrText

Boolean ibool_HeaderOnly = False
end variables

forward prototypes
public function integer of_updatevoyage ()
public subroutine of_recalcvoyage (ref n_wrr ao_wrr)
public function integer of_getbunkerprices ()
public function integer of_retrievevoyage (long al_voyid, boolean abool_headeronly)
private function integer of_gettotalconsumption (ref decimal ad_hsfo, ref decimal ad_lsfo, ref decimal ad_do, ref decimal ad_go)
public function boolean of_deletevoyage (long al_voyid)
public function integer of_transfervoyages (integer ai_sourceid, integer ai_targetid)
end prototypes

public function integer of_updatevoyage ();

If ids_voyage.update( False, False) <> 1 then
	ErrText = ids_voyage.sqlerrortext
	rollback;
	return -1
End if

If Not ibool_Headeronly then

	If ids_reports.update( False, False) <> 1 then
		ErrText = ids_reports.sqlerrortext
		rollback;
		return -1
	End if
	
	If ids_saildata.update( False, False) <> 1 then
		ErrText = ids_reports.sqlerrortext
		rollback;
		return -1
	End if
	
	If ids_repcon.update( False, False) <> 1 then
		rollback;
		return -1
	End if

End If

Commit;

Return 0
end function

public subroutine of_recalcvoyage (ref n_wrr ao_wrr);// This function recalculates a voyage warranted speed/consumption

Integer li_RetCode, li_VslID, li_VslSea, li_VslWind, li_RepLoop, li_SailLoop
Integer li_VslWrrVer, li_VslWrrType, li_Temp, li_VoyType, li_Order, li_WrrPercent
decimal{3} ld_TmpVal, ld_AuxCon
decimal{3} ld_VslDev_OSpd, ld_VslDev_OCon, ld_VslDev_WSpd, ld_VslDev_WCon
decimal{3} ld_VslDev_OSpdMin, ld_VslDev_OConMin, ld_VslDev_WSpdMin, ld_VslDev_WConMin
Decimal{3} ldec_TotalDist = 0, ldec_TotalPeriod = 0, ldec_TotalCons = 0

If ibool_HeaderOnly then Return  // Exit if only voyage header exists

// Get vessel warranted settings
li_VslID = ids_voyage.GetItemNumber(1, "Vessel_ID")

// Exit if no warranted settings
If Not ao_Wrr.WrrTableExists(li_VslID, Byte(ids_Voyage.GetItemNumber(1, "Voy_Type"))) then Return

// Get warranted settings
Select TPERF_W_SEA,  
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
Into :li_VslSea,   
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
	:li_WrrPercent
From VESSELS Where VESSELS.VESSEL_ID = :li_VslID;

// Get voyage order type
li_Order = ids_Voyage.GetItemNumber(1, "Order_Type")

// Get either Warranted Speed or Consumption range and update
If (li_Order = 1) or (li_Order = 13) or (li_Order = 3) then 
	ids_Voyage.SetItem(1, "wrr_range", ld_VslDev_WSpd )
	ids_Voyage.SetItem(1, "wrr_range_min", ld_VslDev_WSpdMin )	
Else 
	ids_Voyage.SetItem(1, "wrr_range", ld_VslDev_WCon )
	ids_Voyage.SetItem(1, "wrr_range_min", ld_VslDev_WConMin )
End If

// Get either ordered speed or consumption range and update
If (li_Order = 1) or (li_Order = 13) or (li_Order = 3) then 
	ids_Voyage.SetItem(1, "ord_range", ld_VslDev_OCon)
	ids_Voyage.SetItem(1, "ord_range_min", ld_VslDev_OConMin)
Else 
	ids_Voyage.SetItem(1, "ord_range", ld_VslDev_OSpd)
	ids_Voyage.SetItem(1, "ord_range_min", ld_VslDev_OSpdMin)
End If

// Save Wrr info
ids_Voyage.setItem(1, "Wrr_Ver", li_VslWrrVer)
ids_Voyage.setItem(1, "Aux_Wrr", ld_AuxCon)
ids_Voyage.setItem(1, "Wrr_Type", li_VslWrrType)
ids_Voyage.SetItem(1, "Wrr_Percent", li_WrrPercent)

// Filter out non-full speed
ids_Saildata.SetFilter("Type = 0")
ids_Saildata.Filter()

li_VoyType = ids_Voyage.GetItemNumber(1, "Voy_Type")

// Loop thru full speed sailings and recalculate Wrr_Calc
For li_Temp = 1 to ids_Saildata.RowCount()
	If li_Order = 0 or li_Order = 10 then  // if ordered speed / Full speed
		ld_TmpVal = Round(ids_Saildata.GetItemNumber(li_Temp, "Dist") / ids_Saildata.GetItemNumber(li_Temp, "Period"), 1)
		ids_Saildata.Setitem(li_Temp, "WRR_CALC", Round(ao_Wrr.GetWrrCons(li_VslID, li_VoyType, ld_TmpVal),1))
		ldec_TotalDist += ids_Saildata.GetItemNumber(li_Temp, "Dist")		
	ElseIf li_Order = 1 or li_Order = 3 or li_Order = 13 then  // if ordered cons		
		ld_TmpVal = Round(ids_Saildata.GetItemNumber(li_Temp, "totalcons") * 24 / ids_Saildata.GetItemNumber(li_Temp, "Period"), 1)
		ids_Saildata.Setitem(li_Temp, "WRR_CALC", Round(ao_Wrr.GetWrrSpd(li_VslID, li_VoyType, ld_TmpVal),1))		
		ldec_TotalCons += ids_Saildata.GetItemNumber(li_Temp, "TotalCons")
	End if		
	ldec_TotalPeriod += ids_Saildata.GetItemNumber(li_Temp, "Period")
Next	

If ldec_TotalPeriod > 0 then
	If li_Order = 0 or li_Order = 10 then  // if ordered speed / Full speed	
		ld_TmpVal = Round(ldec_TotalDist / ldec_TotalPeriod, 1)
		ids_Voyage.Setitem(1, "WRR_CALC", Round(ao_Wrr.GetWrrCons(li_VslID, li_VoyType, ld_TmpVal),1))
	ElseIf li_Order = 1 or li_Order = 3 or li_Order = 13 then  // if ordered cons		
		ld_TmpVal = Round(ldec_TotalCons * 24 / ldec_TotalPeriod, 1)
		ids_Voyage.Setitem(1, "WRR_CALC", Round(ao_Wrr.GetWrrSpd(li_VslID, li_VoyType, ld_TmpVal),1))
	End If	
End If

end subroutine

public function integer of_getbunkerprices ();// This function gets the bunker price for the voyage leg from Tramos.
// We use the function that is used for calculating the bunker price of an off-service

// bunker.pbl > n_voyage_offservice_bunker_consumption > of_price_proposal

// Return 1 for success, -1 for fail


DateTime ldt_Start, ldt_End
Long ll_VoyageID, ll_VesselID, ll_VesselNr
Decimal ld_HSFO_Dep, ld_LSFO_Dep, ld_DO_Dep, ld_GO_Dep   // Stock at departure of voyage
Decimal ld_HSFO=0.0, ld_LSFO=0.0, ld_DO=0.0, ld_GO=0.0   // Consumption during voyage leg
Integer li_Type
String ls_TramosVoy
Any ln_bunk

// Exit if voyage is not loaded properly
If ibool_Headeronly then Return -1

// Exit if last report is not arrival report (i.e. voyage leg is not complete)
If ids_Reports.GetItemNumber(ids_Reports.RowCount(), "tperf_reports_type") < 2 then Return -1

// Get start of voyage and Vessel ID
ll_VoyageID = ids_Voyage.GetItemNumber(1, "Voy_ID")
ll_VesselID = ids_Voyage.GetItemNumber(1, "Vessel_ID")
ldt_Start = ids_Reports.GetItemDateTime(1, "localtime")
ldt_End = ids_Reports.GetItemDateTime(ids_Reports.RowCount(), "localtime")

// Get Vessel Number
Select VESSEL_NR Into :ll_VesselNr From VESSELS Where VESSEL_ID = :ll_VesselID;
Commit;

// Get Tramos voyage number using Start_Date
Select Min(VOYAGE_NR) Into :ls_TramosVoy from POC
Where VESSEL_NR = :ll_VesselNr and PORT_ARR_DT >= :ldt_Start;
Commit;

//If ls_TramosVoy <> Left(ids_Voyage.GetItemString(1, "Voy_Num"),4) then
//	Messagebox("No Match", ls_Tramosvoy + " & " + ids_Voyage.GetItemString(1, "Voy_Num"))
//End If

// Get stock at departure of voyage leg
Select QTY_HFO, QTY_LSHFO, QTY_DO, QTY_GO Into :ld_HSFO_Dep, :ld_LSFO_Dep, :ld_DO_Dep, :ld_GO_Dep
From TPERF_REPCON Where CONTYPE = 18 and REP_ID = (Select Min(REP_ID) from TPERF_REPORTS Where VOY_ID = :ll_VoyageID);
Commit;

// Get total consumption
of_GetTotalConsumption(ld_HSFO, ld_LSFO, ld_DO, ld_GO)

// Add bunker library PBD
If AddToLibraryList("bunker.pbd") < 1 then Return -1

// Create offserver object
Try
	ln_Bunk = Create Using "n_voyage_offservice_bunker_consumption"
Catch (exception ex1)
	Return -1
End Try

// Get bunker prices
Decimal ld_HSFO_Price = 0.0, ld_LSFO_Price = 0.0, ld_DO_Price = 0.0, ld_GO_Price = 0.0
Try
	If ld_HSFO > 0.0 then ln_bunk.dynamic of_Price_Proposal("HFO", ll_VesselNr, ls_TramosVoy, ldt_Start, ld_HSFO_Dep, ld_HSFO, ld_HSFO_Price, ldt_End)
	If ld_LSFO > 0.0 then ln_bunk.dynamic of_Price_Proposal("LSHFO", ll_VesselNr, ls_TramosVoy, ldt_Start, ld_LSFO_Dep, ld_LSFO, ld_LSFO_Price, ldt_End)
	If ld_DO > 0.0 then ln_bunk.dynamic of_Price_Proposal("DO", ll_VesselNr, ls_TramosVoy, ldt_Start, ld_DO_Dep, ld_DO, ld_DO_Price, ldt_End)
	If ld_GO > 0.0 then ln_bunk.dynamic of_Price_Proposal("GO", ll_VesselNr, ls_TramosVoy, ldt_Start, ld_GO_Dep, ld_GO, ld_GO_Price, ldt_End)
Catch (exception ex2)
	Return -1
End Try

Destroy ln_Bunk

// Round prices to 2 decimals (for display and to avoid SQL conversion error)
ld_HSFO_Price = Round(ld_HSFO_Price, 2)
ld_LSFO_Price = Round(ld_LSFO_Price, 2)
ld_DO_Price = Round(ld_DO_Price, 2)
ld_GO_Price = Round(ld_GO_Price, 2)

// Update Bunker prices
Update TPERF_VOY Set HFO_COST = :ld_HSFO_Price, LSHFO_COST = :ld_LSFO_Price, DO_COST = :ld_DO_Price, GO_COST = :ld_GO_Price Where VOY_ID = :ll_VoyageID;

If SQLCA.SQLCode = 0 then 
	Commit;
	Return 1
Else
	Rollback;
	Return -1
End If



end function

public function integer of_retrievevoyage (long al_voyid, boolean abool_headeronly);

ids_Voyage.retrieve( al_VoyID)

ibool_Headeronly = abool_Headeronly

If Not abool_headeronly then
	ids_reports.retrieve(al_VoyID)
	ids_saildata.retrieve(al_VoyID)
	ids_repcon.retrieve(al_VoyID)
End If

Return ids_Voyage.rowcount( ) 


end function

private function integer of_gettotalconsumption (ref decimal ad_hsfo, ref decimal ad_lsfo, ref decimal ad_do, ref decimal ad_go);// This function returns the total consumption for a voyage leg based on the oil type.

Decimal ld_Total 
Integer li_Loop

If ibool_HeaderOnly then Return -1

ad_HSFO = 0.0
ad_LSFO = 0.0
ad_DO = 0.0
ad_GO = 0.0

For li_Loop = 1 to ids_Saildata.RowCount()
	ad_HSFO += ids_SailData.GetItemNumber(li_Loop, "mehfo")
	ad_LSFO += ids_SailData.GetItemNumber(li_Loop, "melshfo")
	ad_DO += ids_SailData.GetItemNumber(li_Loop, "medo")
	ad_GO += ids_SailData.GetItemNumber(li_Loop, "mego")
Next

For li_Loop = 1 to ids_RepCon.RowCount()
	If ids_RepCon.GetItemNumber(li_Loop, "ConType") < 18 then
		ad_HSFO += ids_RepCon.GetItemNumber(li_Loop, "qty_hfo")
		ad_LSFO += ids_RepCon.GetItemNumber(li_Loop, "qty_lshfo")
		ad_DO += ids_RepCon.GetItemNumber(li_Loop, "qty_do")
		ad_GO += ids_RepCon.GetItemNumber(li_Loop, "qty_go")		
	End If
Next

Return 1
end function

public function boolean of_deletevoyage (long al_voyid);// This function deletes a complete voyage using a transaction

// Parameters: al_VoyID

// Returns True for success and False for error


Execute Immediate "Begin Transaction";  // Add Inner Trans

// Delete all SailData
DELETE TPERF_SAILDATA
FROM TPERF_REPORTS, TPERF_SAILDATA
WHERE TPERF_REPORTS.REP_ID = TPERF_SAILDATA.REP_ID
AND TPERF_REPORTS.VOY_ID=:al_VoyID;

// Delete all RepCon
If SQLCA.SQLCode >= 0 then
	DELETE TPERF_REPCON
	FROM TPERF_REPORTS, TPERF_REPCON
	WHERE TPERF_REPORTS.REP_ID = TPERF_REPCON.REP_ID
	AND TPERF_REPORTS.VOY_ID=:al_VoyID;
End If
		
// Delete all Reports
If SQLCA.SQLCode >= 0 then
	DELETE FROM TPERF_REPORTS WHERE VOY_ID=:al_VoyID;
End If
		
// Delete all HrbrCon
If SQLCA.SQLCode >= 0 then
	DELETE TPERF_HRBRCON
	FROM TPERF_HRBR,TPERF_HRBRCON
	WHERE TPERF_HRBR.H_ID = TPERF_HRBRCON.H_ID
	AND TPERF_HRBR.VOY_ID=:al_VoyID;
End If
		
// Delete all Harbours
If SQLCA.SQLCode >= 0 then
	DELETE FROM TPERF_HRBR WHERE VOY_ID=:al_VoyID;
End If
		
// Delete all Alerts
If SQLCA.SQLCode >= 0 then
	DELETE FROM TPERF_ALERTS WHERE VOY_ID=:al_VoyID;
End if			

// Finally delete voyage
If SQLCA.SQLCode >= 0 then  
	DELETE FROM TPERF_VOY WHERE VOY_ID = :al_VoyID;   // Delete Voyage
End if

If	SQLCA.SQLCode=0 Then
	Execute Immediate "Commit Transaction";  // commit inner trans
	Commit;  // Commit original PB trans
	Return True
Else
	Rollback;	
	Return False
End if

end function

public function integer of_transfervoyages (integer ai_sourceid, integer ai_targetid);// This function transfers voyage legs from one vessel to another
// Returns number of voyages transferred or -1 for error

Integer li_Count

Update TPERF_VOY Set VESSEL_ID = :ai_TargetID Where VESSEL_ID = :ai_SourceID;

If SQLCA.SQLCode<0 then 
	Rollback;
	Return -1
Else
	li_Count = SQLCA.sqlnrows
	Commit;
	Return li_Count
End If
end function

on n_voyage.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_voyage.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
ids_voyage = Create n_datastore
ids_reports = Create n_datastore
ids_saildata = Create n_datastore
ids_repcon = Create n_datastore
ids_hrbr = Create n_datastore
ids_hrbrcon = Create n_datastore

ids_voyage.dataobject = "d_sq_ff_voyedit"
ids_voyage.settransobject( SQLCA)

ids_reports.dataobject = "d_sq_tb_reportsummary"
ids_reports.settransobject( SQLCA)

ids_saildata.dataobject = "d_sq_tb_saildata"
ids_saildata.settransobject( SQLCA)

ids_repcon.dataobject = "d_sq_tb_repconedit"
ids_repcon.settransobject( SQLCA)

//ids_hrbr.settransobject( SQLCA)
//ids_hrbrcon.settransobject( SQLCA)

end event

event destructor;
destroy ids_voyage
destroy ids_saildata
destroy ids_reports
destroy ids_repcon
destroy ids_hrbr
destroy ids_hrbrcon
end event

