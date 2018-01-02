$PBExportHeader$u_vessel.sru
$PBExportComments$UserObject for getting information for a selected vessel number
forward
global type u_vessel from nonvisualobject
end type
end forward

global type u_vessel from nonvisualobject
end type
global u_vessel u_vessel

type variables
datastore ids_vessel
end variables

forward prototypes
public function integer of_getvessel (integer ai_vessel_nr)
public function string of_getvesselname ()
public function string of_getvesselrefnr ()
end prototypes

public function integer of_getvessel (integer ai_vessel_nr);IF ids_vessel.Retrieve(ai_vessel_nr) = 1 THEN
	COMMIT;
	Return(1)
ELSE
	MessageBox("Retrieval error","Vessel not found. Object: u_vessel, Function: of_getVessel")
	COMMIT;
	Return(-1)
END IF
end function

public function string of_getvesselname ();Return(ids_vessel.GetItemString(1,"vessel_name"))
end function

public function string of_getvesselrefnr ();Return(ids_vessel.GetItemString(1,"vessel_ref_nr"))
end function

event constructor;ids_vessel = CREATE datastore
ids_vessel.DataObject = "d_vessel_detail"
ids_vessel.SetTransObject(SQLCA)
end event

event destructor;DESTROY ids_vessel
end event

on u_vessel.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_vessel.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

