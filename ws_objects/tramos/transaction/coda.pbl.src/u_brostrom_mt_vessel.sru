$PBExportHeader$u_brostrom_mt_vessel.sru
$PBExportComments$UserObject for getting information for a selected vessel number
forward
global type u_brostrom_mt_vessel from nonvisualobject
end type
end forward

global type u_brostrom_mt_vessel from nonvisualobject
end type
global u_brostrom_mt_vessel u_brostrom_mt_vessel

type variables
datastore ids_brostrom_mt_vessel
end variables

forward prototypes
public subroutine of_getcrewelement (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7)
public function boolean of_vesselexists (integer ai_vessel_nr)
public function integer of_gettoelement (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7)
end prototypes

public subroutine of_getcrewelement (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7);as_el3 = ids_brostrom_mt_vessel.GetItemString(1, "coda_el3_crew")
as_el4 = ids_brostrom_mt_vessel.GetItemString(1, "coda_el4_crew")
as_el5 = ids_brostrom_mt_vessel.GetItemString(1, "coda_el5_crew")
as_el6 = ids_brostrom_mt_vessel.GetItemString(1, "coda_el6_crew")
as_el7 = ids_brostrom_mt_vessel.GetItemString(1, "coda_el7_crew")

Return
end subroutine

public function boolean of_vesselexists (integer ai_vessel_nr);IF ids_brostrom_mt_vessel.Retrieve(ai_vessel_nr) = 1 THEN
	COMMIT;
	Return(TRUE)
ELSE
	COMMIT;
	Return(FALSE)
END IF
end function

public function integer of_gettoelement (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7);as_el3 = ids_brostrom_mt_vessel.GetItemString(1, "coda_el3_to")
as_el4 = ids_brostrom_mt_vessel.GetItemString(1, "coda_el4_to")
as_el5 = ids_brostrom_mt_vessel.GetItemString(1, "coda_el5_to")
as_el6 = ids_brostrom_mt_vessel.GetItemString(1, "coda_el6_to")
as_el7 = ids_brostrom_mt_vessel.GetItemString(1, "coda_el7_to")
Return 1
end function

event constructor;ids_brostrom_mt_vessel = CREATE datastore
ids_brostrom_mt_vessel.DataObject = "d_sq_tb_brostrom_mt_vessel"
ids_brostrom_mt_vessel.SetTransObject(SQLCA)
end event

event destructor;DESTROY ids_brostrom_mt_vessel
end event

on u_brostrom_mt_vessel.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_brostrom_mt_vessel.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

