$PBExportHeader$u_voucher.sru
$PBExportComments$UserObject for getting information for a selected voucher number
forward
global type u_voucher from nonvisualobject
end type
end forward

global type u_voucher from nonvisualobject
end type
global u_voucher u_voucher

type variables
datastore ids_voucher
end variables

forward prototypes
public function integer of_getvoucher (integer ai_voucher_nr)
public subroutine of_getapmelements (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7, ref string as_resp_dept, ref long al_amount_dkk, ref integer ai_ca_or_oa, ref integer ai_illegal_combination, ref string as_voucher_name, ref string as_illegal_message)
public subroutine of_gettcinelements (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7, ref string as_resp_dept, ref long al_amount_dkk, ref integer ai_ca_or_oa, ref integer ai_illegal_combination, ref string as_voucher_name, ref string as_illegal_message)
public subroutine of_gettcinoutelements (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7, ref string as_resp_dept, ref long al_amount_dkk, ref integer ai_ca_or_oa, ref integer ai_illegal_combination, ref string as_voucher_name, ref string as_illegal_message)
public subroutine of_gettcoutelements (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7, ref string as_resp_dept, ref long al_amount_dkk, ref integer ai_ca_or_oa, ref integer ai_illegal_combination, ref string as_voucher_name, ref string as_illegal_message)
public function string of_getvouchername ()
end prototypes

public function integer of_getvoucher (integer ai_voucher_nr);IF ids_voucher.Retrieve(ai_voucher_nr) = 1 THEN
	COMMIT;
	Return(1)
ELSE
	MessageBox("Retrieval error","Voucher not found. Object: u_voucher, Function: of_getVoucher")
	COMMIT;
	Return(-1)
END IF
end function

public subroutine of_getapmelements (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7, ref string as_resp_dept, ref long al_amount_dkk, ref integer ai_ca_or_oa, ref integer ai_illegal_combination, ref string as_voucher_name, ref string as_illegal_message);as_el3 = 		ids_voucher.GetItemString(1, "coda_el_3_apm")
as_el4 = 		ids_voucher.GetItemString(1, "coda_el_4_apm")
as_el5 = 		ids_voucher.GetItemString(1, "coda_el_5_apm")
as_el6 = 		ids_voucher.GetItemString(1, "coda_el_6_apm")
as_el7 = 		ids_voucher.GetItemString(1, "coda_el_7_apm")
as_resp_dept = ids_voucher.GetItemString(1, "resp_comp_or_dept_apm")
al_amount_dkk =ids_voucher.GetItemNumber(1, "min_amount_dkk_apm")
ai_ca_or_oa = 0
ai_illegal_combination = ids_voucher.GetItemNumber(1, "illegal_apm")
as_voucher_name = ids_voucher.GetItemString(1, "voucher_name")
as_illegal_message = ids_voucher.getItemString(1, "illegal_message_apm")
Return
end subroutine

public subroutine of_gettcinelements (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7, ref string as_resp_dept, ref long al_amount_dkk, ref integer ai_ca_or_oa, ref integer ai_illegal_combination, ref string as_voucher_name, ref string as_illegal_message);as_el3 = 		ids_voucher.GetItemString(1, "coda_el_3_tcin")
as_el4 = 		ids_voucher.GetItemString(1, "coda_el_4_tcin")
as_el5 = 		ids_voucher.GetItemString(1, "coda_el_5_tcin")
as_el6 = 		ids_voucher.GetItemString(1, "coda_el_6_tcin")
as_el7 = 		ids_voucher.GetItemString(1, "coda_el_7_tcin")
as_resp_dept = ids_voucher.GetItemString(1, "resp_comp_or_dept_tcin")
al_amount_dkk =ids_voucher.GetItemNumber(1, "min_amount_dkk_tcin")
ai_ca_or_oa = 	ids_voucher.GetItemNumber(1, "tcin_ca_or_oa")
ai_illegal_combination = ids_voucher.GetItemNumber(1, "illegal_tcin")
as_voucher_name = ids_voucher.GetItemString(1, "voucher_name")
as_illegal_message = ids_voucher.getItemString(1, "illegal_message_tcin")
Return
end subroutine

public subroutine of_gettcinoutelements (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7, ref string as_resp_dept, ref long al_amount_dkk, ref integer ai_ca_or_oa, ref integer ai_illegal_combination, ref string as_voucher_name, ref string as_illegal_message);as_el3 = 		ids_voucher.GetItemString(1, "coda_el_3_tcinout")
as_el4 = 		ids_voucher.GetItemString(1, "coda_el_4_tcinout")
as_el5 = 		ids_voucher.GetItemString(1, "coda_el_5_tcinout")
as_el6 = 		ids_voucher.GetItemString(1, "coda_el_6_tcinout")
as_el7 = 		ids_voucher.GetItemString(1, "coda_el_7_tcinout")
as_resp_dept = ids_voucher.GetItemString(1, "resp_comp_or_dept_tcinout")
al_amount_dkk =ids_voucher.GetItemNumber(1, "min_amount_dkk_tcinout")
ai_ca_or_oa = ids_voucher.GetItemNumber(1, "tcinout_ca_or_oa")
ai_illegal_combination = ids_voucher.GetItemNumber(1, "illegal_tcinout")
as_voucher_name = ids_voucher.GetItemString(1, "voucher_name")
as_illegal_message = ids_voucher.getItemString(1, "illegal_message_tcinout")
Return
end subroutine

public subroutine of_gettcoutelements (ref string as_el3, ref string as_el4, ref string as_el5, ref string as_el6, ref string as_el7, ref string as_resp_dept, ref long al_amount_dkk, ref integer ai_ca_or_oa, ref integer ai_illegal_combination, ref string as_voucher_name, ref string as_illegal_message);as_el3 = 		ids_voucher.GetItemString(1, "coda_el_3_tcout")
as_el4 = 		ids_voucher.GetItemString(1, "coda_el_4_tcout")
as_el5 = 		ids_voucher.GetItemString(1, "coda_el_5_tcout")
as_el6 = 		ids_voucher.GetItemString(1, "coda_el_6_tcout")
as_el7 = 		ids_voucher.GetItemString(1, "coda_el_7_tcout")
as_resp_dept = ids_voucher.GetItemString(1, "resp_comp_or_dept_tcout")
al_amount_dkk =ids_voucher.GetItemNumber(1, "min_amount_dkk_tcout")
ai_ca_or_oa = 	ids_voucher.GetItemNumber(1, "tcout_ca_or_oa")
ai_illegal_combination = ids_voucher.GetItemNumber(1, "illegal_tcout")
as_voucher_name = ids_voucher.GetItemString(1, "voucher_name")
as_illegal_message = ids_voucher.getItemString(1, "illegal_message_tcout")
Return
end subroutine

public function string of_getvouchername ();return  ids_voucher.GetItemString(1, "voucher_name")
end function

event constructor;ids_voucher = CREATE datastore
ids_voucher.DataObject = "dw_voucher"
ids_voucher.SetTransObject(SQLCA)
end event

event destructor;DESTROY ids_voucher
end event

on u_voucher.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_voucher.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

