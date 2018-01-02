$PBExportHeader$u_charterer.sru
$PBExportComments$UserObject for getting information for a selected charter number
forward
global type u_charterer from nonvisualobject
end type
end forward

global type u_charterer from nonvisualobject
end type
global u_charterer u_charterer

type variables
datastore ids_charterer
end variables

forward prototypes
public function integer of_getcharterer (integer ai_charterer_nr)
public function boolean of_own ()
public function string of_getnominalaccount ()
public function boolean of_blocked ()
end prototypes

public function integer of_getcharterer (integer ai_charterer_nr);IF ids_charterer.Retrieve(ai_charterer_nr) = 1 THEN
	COMMIT;
	Return(1)
ELSE
	MessageBox("Retrieval error","Charterer not found. Object: u_charterer, Function: of_getCharterer")
	COMMIT;
	Return(-1)
END IF
end function

public function boolean of_own ();IF ids_charterer.getItemNumber(1, "chart_custsupp") = 1 THEN
	Return(TRUE) /* Internal supplier */
ELSE
	Return(FALSE) /* Foreign supplier */
END IF
end function

public function string of_getnominalaccount ();string ls_nom_acc

ls_nom_acc = ids_charterer.GetItemString(1,"chart_nom_acc_nr")
IF IsNull(ls_nom_acc) THEN ls_nom_acc = ""
Return ls_nom_acc
end function

public function boolean of_blocked ();if ids_charterer.getItemNumber(1, "chart_blocked") = 1 then
	return true
else
	return false
end if
end function

event constructor;ids_charterer = CREATE datastore
ids_charterer.DataObject = "dw_charterer_ns"
ids_charterer.SetTransObject(SQLCA)
end event

event destructor;DESTROY ids_charterer
end event

on u_charterer.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_charterer.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

