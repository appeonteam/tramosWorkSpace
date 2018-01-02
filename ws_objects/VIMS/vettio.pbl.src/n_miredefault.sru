$PBExportHeader$n_miredefault.sru
forward
global type n_miredefault from nonvisualobject
end type
end forward

global type n_miredefault from nonvisualobject
end type
global n_miredefault n_miredefault

forward prototypes
public function integer of_adddefaultitems (long al_inspid, integer ai_imid, string as_vessel, string as_imo, string as_date, string as_port, string as_inspector)
end prototypes

public function integer of_adddefaultitems (long al_inspid, integer ai_imid, string as_vessel, string as_imo, string as_date, string as_port, string as_inspector);Integer li_Ret, li_Loop, li_Risk
Long ll_ID
String ls_Data, ls_VslName
Datastore lds_mire

lds_mire = Create Datastore

// Load MIRE Chapter 1
lds_mire.DataObject = "d_sq_tb_mire_chap1"
lds_mire.SetTransObject(SQLCA)
li_Ret = lds_mire.Retrieve(ai_imid)

If li_Ret < 1 then Return -1

// Loop thru items
For li_Loop = 1 to li_Ret
	ll_ID = lds_mire.GetItemNumber(li_Loop, "ObjText")
	Choose Case ll_ID
		Case 489
			ls_Data = as_Vessel
		Case 490, 3136
			ls_Data = as_imo
		Case 491, 3161
			ls_Data = as_date
		Case 492
			ls_Data = as_port
		Case 500
			ls_Data = as_inspector
		Case Else
			SetNull(ls_Data)		
	End Choose
	ll_ID = lds_mire.GetItemNumber(li_Loop, "Obj_ID")
	Insert Into VETT_ITEM(INSP_ID, OBJ_ID, ANS, DEF, REPORT, RISK, CLOSED, CLOSEDATE, INSPCOMM) Values (:al_inspid, :ll_ID, 0, 0, 0, 0, 1, '2000-01-01', :ls_Data);

	If SQLCA.SQLCode <> 0 then 	
		Rollback;
		Return -1
	End If
Next

lds_mire.DataObject = "d_sq_tb_mire_chap2onward"
lds_mire.SetTransObject(SQLCA)
li_Ret = lds_mire.Retrieve(ai_imid)

If li_Ret < 1 then Return -1

SetNull(ls_Data)		
For li_Loop = 1 to li_Ret
	ll_ID = lds_mire.GetItemNumber(li_Loop, "Obj_ID")
	li_Risk = lds_mire.GetItemNumber(li_loop, "DefRisk")
	Insert Into VETT_ITEM(INSP_ID, OBJ_ID, ANS, DEF, REPORT, RISK, CLOSED, CLOSEDATE, INSPCOMM) Values (:al_inspid, :ll_ID, 0, 0, 0, :li_Risk, 1, '2000-01-01', :ls_Data);

	If SQLCA.SQLCode <> 0 then 
		Rollback;
		Return -1
	End If
Next

Commit;

Return 0

end function

on n_miredefault.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_miredefault.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

