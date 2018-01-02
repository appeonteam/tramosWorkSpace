$PBExportHeader$u_profitcenter.sru
$PBExportComments$UserObject for getting information for a selected profitcenter number
forward
global type u_profitcenter from nonvisualobject
end type
end forward

global type u_profitcenter from nonvisualobject
end type
global u_profitcenter u_profitcenter

type variables
datastore ids_profitcenter
end variables

forward prototypes
public function integer of_getprofitcenter (integer ai_pc_nr)
public subroutine of_getmiscclaimaccount (ref string as_gl_account, ref string as_nom_account)
public subroutine of_getfrtclaimaccount (ref string as_gl_account, ref string as_nom_account)
public subroutine of_getdemclaimaccount (ref string as_gl_account, ref string as_nom_account)
public function string of_getdepartmentcode ()
end prototypes

public function integer of_getprofitcenter (integer ai_pc_nr);IF ids_profitcenter.Retrieve(ai_pc_nr) = 1 THEN
	COMMIT;
	Return(1)
ELSE
	MessageBox("Retrieval error","Profitcenter not found. Object: u_profitcenter, Function: of_getProfitCenter")
	COMMIT;
	Return(-1)
END IF
end function

public subroutine of_getmiscclaimaccount (ref string as_gl_account, ref string as_nom_account);as_gl_account = ids_profitcenter.GetItemString(1, "pc_misc_claim_gl_acc")
as_nom_account = ids_profitcenter.GetItemString(1, "pc_misc_claim_nom_acc")
Return
end subroutine

public subroutine of_getfrtclaimaccount (ref string as_gl_account, ref string as_nom_account);as_gl_account = ids_profitcenter.GetItemString(1, "pc_frt_claim_gl_acc")
as_nom_account = ids_profitcenter.GetItemString(1, "pc_frt_claim_nom_acc")
Return
end subroutine

public subroutine of_getdemclaimaccount (ref string as_gl_account, ref string as_nom_account);as_gl_account = ids_profitcenter.GetItemString(1, "pc_dem_claim_gl_acc")
as_nom_account = ids_profitcenter.GetItemString(1, "pc_dem_claim_nom_acc")
Return
end subroutine

public function string of_getdepartmentcode ();Return(ids_profitcenter.GetItemString(1, "pc_dept_code"))

end function

event constructor;ids_profitcenter = CREATE datastore
ids_profitcenter.DataObject = "dw_profit_center"
ids_profitcenter.SetTransObject(SQLCA)
end event

event destructor;DESTROY ids_profitcenter
end event

on u_profitcenter.create
TriggerEvent( this, "constructor" )
end on

on u_profitcenter.destroy
TriggerEvent( this, "destructor" )
end on

