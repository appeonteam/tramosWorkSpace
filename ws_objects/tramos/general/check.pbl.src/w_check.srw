$PBExportHeader$w_check.srw
$PBExportComments$Main window for the check module.
forward
global type w_check from mt_w_sheet
end type
type st_status from statictext within w_check
end type
type rb_14 from radiobutton within w_check
end type
type rb_13 from radiobutton within w_check
end type
type rb_11 from radiobutton within w_check
end type
type rb_2 from radiobutton within w_check
end type
type rb_1 from radiobutton within w_check
end type
type rb_4 from radiobutton within w_check
end type
type rb_10 from radiobutton within w_check
end type
type uo_pc from u_pc within w_check
end type
type cb_saveas from commandbutton within w_check
end type
type hpb_1 from hprogressbar within w_check
end type
type cb_print from commandbutton within w_check
end type
type cb_do_it from commandbutton within w_check
end type
type rb_3 from radiobutton within w_check
end type
type rb_5 from radiobutton within w_check
end type
type rb_6 from radiobutton within w_check
end type
type rb_7 from radiobutton within w_check
end type
type rb_8 from radiobutton within w_check
end type
type dw_check from mt_u_datawindow within w_check
end type
type gb_2 from groupbox within w_check
end type
type sle_rows from singlelineedit within w_check
end type
type st_row_counter from statictext within w_check
end type
type cb_1 from commandbutton within w_check
end type
type st_1 from statictext within w_check
end type
type em_1 from editmask within w_check
end type
type dw_pc from u_datagrid within w_check
end type
end forward

global type w_check from mt_w_sheet
integer x = 14
integer y = 168
integer width = 4311
integer height = 2380
string title = "Check Module"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
long backcolor = 81324524
event ue_postopen ( )
st_status st_status
rb_14 rb_14
rb_13 rb_13
rb_11 rb_11
rb_2 rb_2
rb_1 rb_1
rb_4 rb_4
rb_10 rb_10
uo_pc uo_pc
cb_saveas cb_saveas
hpb_1 hpb_1
cb_print cb_print
cb_do_it cb_do_it
rb_3 rb_3
rb_5 rb_5
rb_6 rb_6
rb_7 rb_7
rb_8 rb_8
dw_check dw_check
gb_2 gb_2
sle_rows sle_rows
st_row_counter st_row_counter
cb_1 cb_1
st_1 st_1
em_1 em_1
dw_pc dw_pc
end type
global w_check w_check

type variables
Public long il_pcnr
Public string is_pcName

end variables

forward prototypes
public subroutine wf_check_claims ()
public subroutine wf_claims_no_commission ()
public subroutine wf_check_bunker ()
public subroutine wf_check_dem_claims ()
public subroutine wf_check_estimated_claims ()
public subroutine wf_check_finished_voyages_claims ()
public subroutine wf_check_finished_voyages_commission ()
public subroutine wf_check_itinerary_proceeding ()
public subroutine wf_check_misc_income ()
public subroutine wf_check_purpose_delivery ()
public subroutine wf_check_purpose_idle ()
public subroutine wf_check_purpose_offservice ()
public subroutine wf_check_tc_currency ()
public subroutine wf_check_tcperiods ()
public subroutine wf_poc_dates ()
public subroutine wf_tc_out_type_check ()
public subroutine documentation ()
public subroutine wf_checkportvalidator ()
end prototypes

event ue_postopen();
il_pcnr=uo_pc.of_retrieve( )

dw_pc.settransobject(sqlca)
dw_pc.retrieve(uo_global.is_userid)



if il_pcnr = c#return.failure then
	Messagebox("Error", "Error selecting profit center list!")
	return
end if
end event

public subroutine wf_check_claims ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_check_ claims
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 20-08-97
 Description 	: This function checks if the amount in calculation is 
						the same described in claims in Operations.
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
20-08-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
integer 			li_number_of_voyages, i, li_result
u_check_functions lu_check
st_voyages 		lst_voyages

/* Creates object */
lu_check = create u_check_functions

/* Set redraw off */
//dw_check.setredraw(false)

/* Get all  voyages to check */
lu_check.uf_get_all_voyages(lst_voyages,em_1.text,il_pcnr)

/* Find the number of voyages to be checked */
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

/* If there are voyages then start to check */
	if li_number_of_voyages > 0 then
		hpb_1.maxposition = li_number_of_voyages
		for i=1 to li_number_of_voyages
			hpb_1.position = i
			this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
		next
	end if

/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
//dw_check.setredraw(true)

/* Destroy the object */
destroy lu_check 


end subroutine

public subroutine wf_claims_no_commission ();/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_claims_no_commission
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 23-03-97
 Description 	: This function finds voyages where claims is registred but there are no
 						commissions registrated.
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
23-03-98			1.0			BO				Initial version  
************************************************************************************/

dw_check.setredraw(false)
dw_check.dataobject = 'd_claims_commission'
dw_check.settransobject(SQLCA)
dw_check.retrieve(String(em_1.text,"YY"),il_pcnr)
dw_check.filter()
dw_check.setredraw(true)
end subroutine

public subroutine wf_check_bunker ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_check_bunker
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 19-08-97
 Description 	: This function checks if the registred bunker figures 
						is logic. The function compares the amount of diesel, fuel, gas 
						from arrival and departure. 
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
19-08-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
decimal				ld_fuel_arr, ld_diesel_arr, ld_gas_arr, ld_lshfo_arr
integer 				li_number_of_voyages, i, li_row, li_vessel_nr
u_check_functions lu_check
st_voyages 			lst_voyages
boolean 				lb_result
string					ls_message

/* Creates object */
lu_check = create u_check_functions

/* Insert titel to the report */
dw_check.object.header.text= 'Bunker Check - profit center '+is_pcname 

/* Set redraw off */
//dw_check.setredraw(false)

/* Get all finished voyages to check */
lu_check.uf_get_all_voyages(lst_voyages,em_1.text,il_pcnr)

/* Find the number of voyages to be checked */
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

/* If there are voyages then start to check */
	if li_number_of_voyages > 0 then
		hpb_1.maxposition = li_number_of_voyages
		for i=1 to li_number_of_voyages
			hpb_1.position = i
			this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
				if lb_result = lu_check.uf_check_bunker(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i], ls_message) then
					li_row = dw_check.insertrow(0)
					dw_check.setitem(li_row,"vessel_ref_nr",lst_voyages.vessel_ref_nr[i])
					dw_check.setitem(li_row,"voyage",lst_voyages.voyage_nr[i])
					dw_check.setitem(li_row,"text", "Error in bunker registration!"+"~r~n"+ls_message)
			end if
		next
	end if

if upperbound(lst_voyages.vessel_nr) > 0 then li_vessel_nr = lst_voyages.vessel_nr[1]

for i = 1 to li_number_of_voyages

	if lst_voyages.vessel_nr[i] <> li_vessel_nr then
		li_vessel_nr = lst_voyages.vessel_nr[i]
		SELECT isnull( POC.ARR_HFO,0),
				isnull(POC.ARR_DO,0),
				isnull(POC.ARR_GO,0),
				isnull(POC.ARR_LSHFO,0),
				POC.PORT_ARR_DT,
				POC.PORT_DEPT_DT
		INTO :ld_fuel_arr, :ld_diesel_arr, :ld_gas_arr, :ld_lshfo_arr
		FROM POC
		WHERE POC.VESSEL_NR = :lst_voyages.vessel_nr[i] AND 
				POC.VOYAGE_NR = (SELECT min(POC.VOYAGE_NR)
								FROM POC
								WHERE POC.VESSEL_NR = :lst_voyages.vessel_nr[i])
		ORDER BY POC.PORT_ARR_DT;
	end if

next

/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
//dw_check.setredraw(true)

/* Destroy the object */
destroy lu_check 

hpb_1.position = hpb_1.maxposition
end subroutine

public subroutine wf_check_dem_claims ();/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_check_finished_voyages_commission
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 01-12-97
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-12-97			1.0			BO				Initial version  
08-08-08			16.03			RMO			Changed to vessel reference number
************************************************************************************/

/* Declare local variables */
integer 			li_number_of_voyages, i, li_row
string 			ls_result
u_check_functions lu_check
st_voyages 		lst_voyages

/* Creates object */
lu_check = create u_check_functions

/* Give the report a title */
dw_check.object.header.text = "Check finished voyage´s dem claims! - profit center " +is_pcname

/* Set redraw off */
//dw_check.setredraw(false)

/* Get all voyages to check */
lu_check.uf_get_all_voyages(lst_voyages,em_1.text,il_pcnr)

/* Find the number of voyages to be checked */
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

/* If there are voyages then start to check */
	if li_number_of_voyages > 0 then
		hpb_1.maxposition = li_number_of_voyages
		for i=1 to li_number_of_voyages
				hpb_1.position = i
				this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
				ls_result = lu_check.uf_check_dem_claims(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i])
				if len(ls_result) > 0 then	
						li_row = dw_check.insertrow(0)
						dw_check.setitem(li_row,"voyage", lst_voyages.voyage_nr[i])
						dw_check.setitem(li_row,"vessel_ref_nr", lst_voyages.vessel_ref_nr[i])
						dw_check.setitem(li_row,"text", ls_result)  
				end if	
			
		next
			
	end if


/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
//dw_check.setredraw(true)

/* Destroy the object */
destroy lu_check 


end subroutine

public subroutine wf_check_estimated_claims ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_check_estimated_claims
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	:  05-12-97
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
05-12-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
integer 				li_number_of_voyages, i, li_row
string 				ls_result
u_check_functions lu_check
st_voyages 			lst_voyages

/* Creates object */
lu_check = create u_check_functions

/* Give the report a title */
dw_check.object.header.text = "Check Estimated Claims - profit center "+is_pcname

/* Set redraw off */
//dw_check.setredraw(false)

/* Get all voyages to check */
lu_check.uf_get_all_voyages(lst_voyages,em_1.text,il_pcnr)

/* Find the number of voyages to be checked */
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

/* If there are voyages then start to check */
	if li_number_of_voyages > 0 then
		hpb_1.maxposition = li_number_of_voyages
		for i=1 to li_number_of_voyages
				hpb_1.position = i
				this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
				ls_result = lu_check.uf_check_estimated_claims(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i])
				if len(ls_result) > 0 then
						li_row = dw_check.insertrow(0)
						dw_check.setitem(li_row,"voyage", lst_voyages.voyage_nr[i])
						dw_check.setitem(li_row,"vessel_ref_nr", lst_voyages.vessel_ref_nr[i])
						dw_check.setitem(li_row,"text", ls_result)
				end if

		next
			
	end if


/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
//dw_check.setredraw(true)

/* Destroy the object */
destroy lu_check 


end subroutine

public subroutine wf_check_finished_voyages_claims ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_check_finished_voyages_claims
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 27-11-97
 Description 	:	A finished voyage is checked for :
 						1. Expect receive date in the claims-table. Claims_in_log shall
						 	1 or 2. If the value is something else there´s an error.
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-11-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
integer 			li_number_of_voyages, i,li_row, li_result
string 			ls_text
u_check_functions lu_check
st_voyages 		lst_voyages

/* Creates object */
lu_check = create u_check_functions

/* Give the report a title */
dw_check.object.header.text = "Check finished voyages claims! - profit center "+is_pcname

/* Set redraw off */
//dw_check.setredraw(false)

/* Get all finished voyages to check */
lu_check.uf_get_all_finished_voyages(lst_voyages,em_1.text,il_pcnr)

/* Find the number of voyages to be checked */
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

/* If there are voyages then start to check */
if li_number_of_voyages > 0 then
	hpb_1.maxposition = li_number_of_voyages
	for i=1 to li_number_of_voyages
		hpb_1.position = i
		this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
		li_result = lu_check.uf_check_finished_voyages_claims(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i])
		if li_result <> 0 then
			li_row = dw_check.insertrow(0)
			dw_check.setitem(li_row,"vessel_ref_nr",lst_voyages.vessel_ref_nr[i])
			dw_check.setitem(li_row,"voyage",lst_voyages.voyage_nr[i])
			if li_result = -1 then
				ls_text = "An error occured while retrieving the database"
			else
				ls_text = "Claim_in_log value is not valid"
			end if				
			dw_check.setitem(li_row,"text",ls_text)
		end if	
	next
end if

/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
//dw_check.setredraw(true)

/* Destroy the object */
destroy lu_check 

end subroutine

public subroutine wf_check_finished_voyages_commission ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_check_finished_voyages_commission
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 27-11-97
 Description 	:	A finished voyage is checked for if the field comm_in_log in commission,
 						tccommissions and disb_expenses is set to 1.
 Arguments 		:vessel_nr and voyage_nr
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-11-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
integer 			li_number_of_voyages, i, li_row
string 			ls_result
u_check_functions lu_check
st_voyages 		lst_voyages

/* Creates object */
lu_check = create u_check_functions

/* Give the report a title */
dw_check.object.header.text = "Check finished voyage´s commission, tccommission and disb-expenses! - pcno: " +is_pcname

/* Set redraw off */
//dw_check.setredraw(false)

/* Get all finished voyages to check */
lu_check.uf_get_all_finished_voyages(lst_voyages,em_1.text,il_pcnr)

/* Find the number of voyages to be checked */
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

/* If there are voyages then start to check */
	if li_number_of_voyages > 0 then
		hpb_1.maxposition = li_number_of_voyages
		for i=1 to li_number_of_voyages
			hpb_1.position = i
				this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
				ls_result = lu_check.uf_check_finished_voyages_commission(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i])
				if len(ls_result) > 0 then
					li_row = dw_check.insertrow(0)
						dw_check.setitem(li_row,"voyage", lst_voyages.voyage_nr[i])
						dw_check.setitem(li_row,"vessel_ref_nr", lst_voyages.vessel_ref_nr[i])
				if left(ls_result,5) = 'Error' then
						dw_check.setitem(li_row,"text","An error occured while retrieving the database!")
				elseif len (ls_result) > 0 then	
						dw_check.setitem(li_row,"text",ls_result)  
				end if
			end if
		next
			
	end if


/* Give the windows original title */
this.title = "Check Module"


/* Set redraw on */
dw_check.setredraw(true)


/* Destroy the object */
destroy lu_check 


end subroutine

public subroutine wf_check_itinerary_proceeding ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_check_itinerary_proceeding
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 15-08-97
 Description 	: Make a list of all the voyages where the proceeding an itinerary 
						don´t match.
 Arguments 		: {description/none}
 Variables 		: {important variables - usually only used in Open-event scriptcode}
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
13-08-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
integer 			li_number_of_voyages, i, li_row, li_retval
string 			ls_result, ls_errortext
st_voyages 		lst_voyages
u_tramos_nvo 	lu_tramos
u_check_functions lu_check
n_portvalidator lnv_validator

/* Creates object */
lu_tramos = create u_tramos_nvo
lnv_validator = create n_portvalidator
lu_check = create u_check_functions

/* Give the report a title */
dw_check.object.header.text = " Itinerary / Proceeding not matching! - profit center " +is_pcname

/* Get the voyages to check */
lu_check.uf_get_all_voyages(lst_voyages,em_1.text,il_pcnr)

/* Get the number of voyages to check */
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

/* If there is something to check then begin */
	if li_number_of_voyages > 0 then
		hpb_1.maxposition = li_number_of_voyages
		for i=1 to li_number_of_voyages
			ls_errortext = ""
			hpb_1.position = i
			this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
			if lst_voyages.calc_id[i] > 1 then
				if f_AtoBviaC_used(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i]) then
					li_retval = lnv_validator.of_start( "CHECKER", lst_voyages.vessel_nr[i], lst_voyages.voyage_nr[i], 0, ls_errortext)
				else
					ls_result = lu_tramos.uf_check_proceed_itenerary(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i],false)
					if ls_result="-1" then
						li_retval=c#return.Failure
					end if	
				end if
				if li_retval = c#return.Failure then
					li_row=dw_check.insertrow(0)
					dw_check.setitem(li_row,"vessel_ref_nr",lst_voyages.vessel_ref_nr[i])
					dw_check.setitem(li_row,"voyage",lst_voyages.voyage_nr[i])
					dw_check.setitem(li_row,"vessel",lst_voyages.vessel_nr[i])
					if ls_errortext="" then ls_errortext="No match between proceeding and itinerary"
					dw_check.setitem(li_row,"text","No match between proceeding and itinerary")
					dw_check.setitem(li_row,"detail",ls_errortext)
				end if
			end if
		next
	end if

/* Give the windows original title */
this.title = "Check Module"


/* Destroys the objects */
destroy lu_check 
destroy lu_tramos
destroy lnv_validator

end subroutine

public subroutine wf_check_misc_income ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_check_misc_income
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 13-08-97
 Description 	:The field Miscellanous Income i calculation shall be zero when
						the voyage is marked as finished in the Port of Call-window.
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
13-08-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
integer 			li_number_of_voyages, i, li_row
u_check_functions lu_check
st_voyages 		lst_voyages
boolean			lb_result

/* Creates object */
lu_check = create u_check_functions

/* Give the report a title */
dw_check.object.header.text = "Check misc. income for finished voyages! - profit center " +is_pcname

/* Set redraw off */
//dw_check.setredraw(false)

/* Get all finished voyages to check */
lu_check.uf_get_all_finished_voyages(lst_voyages,em_1.text,il_pcnr)

/* Find the number of voyages to be checked */
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

/* If there are voyages then start to check */
	if li_number_of_voyages > 0 then
		hpb_1.maxposition = li_number_of_voyages
		for i=1 to li_number_of_voyages
				hpb_1.position = i	
				this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
				lb_result = lu_check.uf_check_misc_income(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i])
				if not lb_result  then
						li_row = dw_check.insertrow(0)
						dw_check.setitem(li_row,"vessel_ref_nr",lst_voyages.vessel_ref_nr[i])
						dw_check.setitem(li_row,"voyage",lst_voyages.voyage_nr[i])
						dw_check.setitem(li_row,"text","Miscellanous income <> 0 ")
				end if

		next
			
	end if

/* Give the windows original title */
this.title = "Check Module"


/* Set redraw on */
//dw_check.setredraw(true)


/* Destroy the object */
destroy lu_check 


end subroutine

public subroutine wf_check_purpose_delivery ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	:wf_purpose_check 
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 18-08-97
 Description 	: this function is used to get a list of all tc-vessel´s voyages where the
						the purpose in the first port of call isn´t delivery (DEL). The rule says that
						the first port on a tc-out/in voyage shall be a delivery port.   
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
18-08-97			1.0			BO				Initial version  
************************************************************************************/
/* Declare local variables */
u_check_functions lu_check
string			ls_progress_text
st_voyages		lst_voyages
integer			li_number_of_voyages, i, li_result, li_vessel_nr, li_row
boolean 			lb_test

/* Creates object */
lu_check = create u_check_functions

/* Give the report a title */
dw_check.object.header.text = "The T/C In/Out vessels 1.harbour is not delivery! - profit center "+is_pcname

/* Set redraw to false */
//dw_check.setredraw(false)

/* Get all tc voyages both tc in and tc out voyages */
lu_check.uf_get_all_voyages(lst_voyages,em_1.text,il_pcnr)

/* Get the numbers of voyages */
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

/* start check */
if li_number_of_voyages > 0 then
		hpb_1.maxposition = li_number_of_voyages
		for i=1 to li_number_of_voyages
			hpb_1.position = i	
				this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
				if lst_voyages.vessel_nr[i] <> li_vessel_nr then
					if lst_voyages.voyage_type[i] = 2  or lu_check.uf_does_vessel_have_tc_owner(lst_voyages.vessel_nr[i])  then 
						li_vessel_nr = lst_voyages.vessel_nr[i]
						lb_test = lu_check.uf_check_purpose_delivery(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i])
						if not lb_test then
							li_row=dw_check.insertrow(0)
							dw_check.setitem(li_row,"vessel_ref_nr",lst_voyages.vessel_ref_nr[i])
							dw_check.setitem(li_row,"voyage",lst_voyages.voyage_nr[i])
							dw_check.setitem(li_row,"text","The first port is not a delivery port!")
						end if
					end if	
					
				end if 
		next
			
	end if

/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
//dw_check.setredraw(true)

/* Destroys the object */
destroy lu_check 


end subroutine

public subroutine wf_check_purpose_idle ();
/************************************************************************************
Arthur Andersen PowerBuilder Development
Window  		: w_check
Object     	: wf_check_purpose_idle
************************************************************************************
Author    		:  Bettina Olsen
Date       	:  01-12-97
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01-12-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
integer 			li_number_of_voyages, i, li_row, li_result
u_check_functions lu_check
st_voyages 		lst_voyages

/* Creates object */
lu_check = create u_check_functions

/* Give the report a title */
dw_check.object.header.text = "Check Port of Call Purpose = WD, profit center "+is_pcname

/* Set redraw off */
//dw_check.setredraw(false)

/* Get all voyages to check */
lu_check.uf_get_all_voyages(lst_voyages,em_1.text,il_pcnr)

/* Find the number of voyages to be checked */
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

/* If there are voyages then start to check */
	if li_number_of_voyages > 0 then
		hpb_1.maxposition = li_number_of_voyages
		for i=1 to li_number_of_voyages
				hpb_1.position = i
				this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
				li_result = lu_check.uf_check_purpose_idle(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i])
				if li_result <> 0 then
				li_row = dw_check.insertrow(0)
						dw_check.setitem(li_row,"voyage", lst_voyages.voyage_nr[i])
						dw_check.setitem(li_row,"vessel_ref_nr", lst_voyages.vessel_ref_nr[i])
						
					if li_result = 99 then
						dw_check.setitem(li_row,"text", "An error occured while retrieving the database")
					else
						dw_check.setitem(li_row,"text", "There´s not registered any data in the Idle Module for this voyage!  ")
					end if
				end if
		next
			
	end if

/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
//dw_check.setredraw(true)

/* Destroy the object */
destroy lu_check 


end subroutine

public subroutine wf_check_purpose_offservice ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_check_purpose_offservice
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	:  02-12-97
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
02-12-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
integer 			li_number_of_voyages, i, li_row, li_result
u_check_functions lu_check
st_voyages 		lst_voyages

/* Creates object */
lu_check = create u_check_functions

/* Give the report a title */
dw_check.object.header.text = "Check Port of Call Purpose DOK and REP - profit center "+is_pcname

/* Set redraw off */
//dw_check.setredraw(false)

/* Get all voyages to check */
lu_check.uf_get_all_voyages(lst_voyages,em_1.text,il_pcnr)

/* Find the number of voyages to be checked */
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

/* If there are voyages then start to check */
	if li_number_of_voyages > 0 then
		hpb_1.maxposition = li_number_of_voyages
		for i=1 to li_number_of_voyages
				hpb_1.position = i
				this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
				li_result = lu_check.uf_check_purpose_offservice(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i])
				if li_result <> 0 then
						li_row = dw_check.insertrow(0)
						dw_check.setitem(li_row,"voyage", lst_voyages.voyage_nr[i])
						dw_check.setitem(li_row,"vessel_ref_nr", lst_voyages.vessel_ref_nr[i])
					
				if li_result = 99 then
						dw_check.setitem(li_row,"text","An error occured while retrieving the database!")
				elseif li_result = 1 then	
						dw_check.setitem(li_row,"text", "There´s not registered any data in the Offservice Module for this voyage!  ")
				end if
			end if
		next
			
	end if

/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
//dw_check.setredraw(true)

/* Destroy the object */
destroy lu_check 


end subroutine

public subroutine wf_check_tc_currency ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Object     	: wf_check_tc_currency
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 16-01-98
 Description 	: 	This functions finds all tc-periods and calls the function in 
 						u_check_functions which finds out if there are more tchires in
						the same period and if the tchires have the same currency.
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-01-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
integer 			i, li_row, li_number_of_vessels, li_vessel
string 			ls_result
u_check_functions lu_check
datastore		ds_tcvessels
datetime			ld_year_argument

/* Creates objects */
lu_check = create u_check_functions
ds_tcvessels = create datastore
ds_tcvessels.dataobject = 'd_tcvessels'
ds_tcvessels.settransobject(sqlca)
ld_year_argument = datetime(date(Integer(em_1.text),1,1))
ds_tcvessels.retrieve(ld_year_argument,il_pcnr)
li_number_of_vessels = ds_tcvessels.rowcount()

/* Set redraw off */
dw_check.setredraw(false)
dw_check.modify("header.text ='" +'Check T/C Currency! - profit center '+is_pcname + "'")

if li_number_of_vessels > 0 then	
	for li_row = 1 to li_number_of_vessels
		/* Start check */
		li_vessel = ds_tcvessels.getitemnumber(li_row,1)
		this.title = "Checking vessel number " + string(li_vessel) + "..."
		ls_result = lu_check.uf_check_tc_currency(li_vessel)
		if len(ls_result) <> 0 then
			i = dw_check.insertrow(0)
			dw_check.setitem(i,"vessel",li_vessel)
			dw_check.setitem(i,"text",ls_result)
		end if
	next
end if

/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
dw_check.setredraw(true)

/* Destroys the objects */
destroy lu_check 
destroy ds_tcvessels

end subroutine

public subroutine wf_check_tcperiods ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Object     	: wf_check_tcperiods
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 10-12-97
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
10-12-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
integer 			i, li_row, li_number_of_vessels, li_vessel
string 			ls_result
u_check_functions lu_check
datastore		ds_tcvessels
datetime			ld_year_argument

/* Creates objects */
lu_check = create u_check_functions
ds_tcvessels = create datastore
ds_tcvessels.dataobject = 'd_tcvessels'
ds_tcvessels.settransobject(sqlca)
ld_year_argument = datetime(date(Integer(em_1.text),1,1))
ds_tcvessels.retrieve(ld_year_argument,il_pcnr)
li_number_of_vessels=ds_tcvessels.rowcount()

/* Set redraw off */
dw_check.setredraw(false)
dw_check.modify("header.text ='" +'Check T/C Out Periods! - profit center '+is_pcname + "'")

if li_number_of_vessels > 0 then	
	for li_row = 1 to li_number_of_vessels
		/* Start check */
		li_vessel=ds_tcvessels.getitemnumber(li_row,1)
		this.title = "Checking vessel number " + string(li_vessel) + "..."
		ls_result = lu_check.uf_check_tcperiods(li_vessel)
		if len(ls_result) <> 0 then
			i = dw_check.insertrow(0)
			dw_check.setitem(i,"vessel",li_vessel)
			dw_check.setitem(i,"text",ls_result)
		end if
	next	
end if

/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
dw_check.setredraw(true)

/* Destroys the objects */
destroy lu_check 
destroy ds_tcvessels

end subroutine

public subroutine wf_poc_dates ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_poc_dates
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 10-01-98
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 			------- 			----- 			-------------------------------------
10-01-98			1.0				BO				Initial version  
04-09-08			16.03				RMO003		Implement change request #1333
************************************************************************************/

/* Declare local variables */
integer 	li_number_of_vessels, li_return 
long		ll_year, ll_row, ll_messageRow
string		ls_message
n_ds		lds_vessellist
u_check_functions lu_check

/* Creates object */
lu_check = create u_check_functions
lds_vessellist = create n_ds
lds_vessellist.dataObject = "d_sq_tb_vessels_in_profitcenter"
lds_vessellist.setTransObject(SQLCA)

ll_year = long(em_1.text)
if ll_year > year(today()) then
	ll_year = year(today())
end if

/* Give the report a title */
dw_check.object.header.text = " Invalid port of call arrival dates! - Profit center: " +is_pcname+" Year: "+string(ll_year)


/* Set redraw off */
//dw_check.setredraw(false)

/* Get the number of voyages to check */
lds_vessellist.retrieve( il_pcnr )
li_number_of_vessels = lds_vessellist.rowcount()

/* If there is something to check then begin */
if li_number_of_vessels > 0 then
	hpb_1.maxposition = li_number_of_vessels
	for ll_row=1 to li_number_of_vessels
			hpb_1.position = ll_row
			this.title = "Checking vessel number " + lds_vessellist.getItemString(ll_row, "vessel_ref_nr") + "..."
			li_return = lu_check.uf_check_poc_arr_dates(lds_vessellist.getItemNumber(ll_row, "vessel_nr"), ll_year, ls_message )				
			if li_return < 0 then 
				ll_messageRow=dw_check.insertrow(0)
				dw_check.setitem(ll_messageRow,"vessel_ref_nr",lds_vessellist.getItemString(ll_row, "vessel_ref_nr"))
//					dw_check.setitem(li_row,"voyage",lst_voyages.voyage_nr[i])
				dw_check.setitem(ll_messageRow,"text",ls_message)
				ls_message = ""
			end if	
	next
end if

/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
//dw_check.setredraw(true)

/* Destroys the objects */
destroy lu_check 
destroy lds_vessellist

end subroutine

public subroutine wf_tc_out_type_check ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_tc_out_type_check
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 06-08-97
 Description 	:  A voyage marked as a tc-out voyaget will be checked as follows:
						- is the ship a tc-out vessel
						- if it is a tc-out vessel then check if it is time charted in the period where 
							the voyage is.
*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
06-08-97			1.0			BO				Initial version  
************************************************************************************/

/* Declare local variables */
integer 			li_result, li_number_of_voyages, i, li_row
string 			ls_text
u_check_functions lu_check
st_voyages 		lst_voyages

/* Creates object */
lu_check = create u_check_functions

/* Set redraw off */
//dw_check.setredraw(false)
dw_check.modify("header.text ='" +'Check T/C Out voyages! - profit center ' +is_pcname + "'")

lu_check.uf_get_all_tc_voyages(lst_voyages,em_1.text,il_pcnr)
li_number_of_voyages = upperbound(lst_voyages.voyage_nr)

	/* Start check */
	if li_number_of_voyages > 0 then
		hpb_1.maxposition = li_number_of_voyages
		for i=1 to li_number_of_voyages
			hpb_1.position = i
			this.title = "Checking vessel number " + lst_voyages.vessel_ref_nr[i] + "..."
			li_result = lu_check.uf_check_tc_out_voyage(lst_voyages.vessel_nr[i],lst_voyages.voyage_nr[i])
			if li_result <> 1 then
			li_row = dw_check.insertrow(0)
			dw_check.setitem(li_row,"vessel_ref_nr",lst_voyages.vessel_ref_nr[i])
			dw_check.setitem(li_row,"Voyage",lst_voyages.voyage_nr[i])
			if li_result = 99 then
				ls_text = "An error occured while retrieving the database" 
			elseif li_result = -1 then
				ls_text = "The vessel is not a tc vessel "
			else
				ls_text = "The vessel is a tc vessel but not in that period"
			end if 
			dw_check.setitem(li_row,"text",ls_text)	
		end if
next
	end if

/* Give the windows original title */
this.title = "Check Module"

/* Set redraw on */
//dw_check.setredraw(true)

/* Destroys the object */
destroy lu_check 


end subroutine

public subroutine documentation ();
/********************************************************************
   ObjectName: w_check
   <OBJECT> 
	</OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   </ALSO>
    Date   Ref    Author        	Comments
  12/01/11	CR 2197	JMC	Profit center list replaced by standard object
********************************************************************/
end subroutine

public subroutine wf_checkportvalidator ();
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: wf_checkportvalidator
 ************************************************************************************
 Author    		:  Bettina Olsen
 Date       	: 15-08-97
 Description 	: Make a list of all the voyages where the proceeding an itinerary 
						don´t match.
 Arguments 		: {description/none}
 Variables 		: {important variables - usually only used in Open-event scriptcode}
*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
13-08-97		1.0			BO			Original version  (named wf_check_itinerary_proceeding())
28/11/11		D-CALC		AGL		Renamed and redeveloped to include new voyage locator and multiple profit centers!		

************************************************************************************/

/* Declare local variables */
long				ll_voyagecount, ll_voyageindex, ll_row 
integer 			li_retval
string 			ls_result, ls_errortext, ls_yy
st_voyages 		lst_voyages
u_tramos_nvo 	lu_tramos
u_check_functions lu_check
n_portvalidator lnv_validator
datetime			ldt_start, ldt_end
string				ls_reportheadertext
integer			li_pcrow


/* Creates object */
lu_tramos = create u_tramos_nvo
lnv_validator = create n_portvalidator
lu_check = create u_check_functions
mt_n_datastore	lds_voyages

/* Give the report a title */
ls_reportheadertext = "Port validator - Mismatches ["
st_status.visible = true
// dw_check.object.header.text = " Itinerary / Proceeding not matching! - profit center " +is_pcname

lds_voyages = create mt_n_datastore
lds_voyages.dataobject = "d_sq_gr_checkvoyagelist"
lds_voyages.settransobject(sqlca)

ls_yy = right(em_1.text,2)

for li_pcrow = 1 to dw_pc.rowcount()
	if dw_pc.isselected(li_pcrow) then
		st_status.text = "Processing " + dw_pc.getitemstring(li_pcrow,"pc_name")
		
		ls_reportheadertext+=string(dw_pc.getitemnumber(li_pcrow,"pc_nr")) + ", "
		
		lds_voyages.retrieve(dw_pc.getitemnumber(li_pcrow,"pc_nr"),ls_yy)
		
		
		ll_voyagecount = lds_voyages.rowcount()
		/* If there is something to check then begin */
		if ll_voyagecount > 0 then
			hpb_1.maxposition = ll_voyagecount
			for ll_voyageindex=1 to ll_voyagecount
				ls_errortext = ""
				hpb_1.position = ll_voyageindex
				this.title = "Validating vessel number " + lds_voyages.getitemstring(ll_voyageindex,"vessel_ref_nr") + "..."
				if  lds_voyages.getitemnumber(ll_voyageindex,"estcalc_id") > 1 then
					if f_AtoBviaC_used(lds_voyages.getitemnumber(ll_voyageindex,"vessel_nr"), lds_voyages.getitemstring(ll_voyageindex,"voyage_nr")) then
						li_retval = lnv_validator.of_start( "CHECKER",  lds_voyages.getitemnumber(ll_voyageindex,"vessel_nr"),  lds_voyages.getitemstring(ll_voyageindex,"voyage_nr"), 0, ls_errortext)
					else
						ls_result = lu_tramos.uf_check_proceed_itenerary(lds_voyages.getitemnumber(ll_voyageindex,"vessel_nr"),  lds_voyages.getitemstring(ll_voyageindex,"voyage_nr"),false)
						if ls_result="-1" then
							li_retval=c#return.Failure
						end if	
					end if
					if li_retval = c#return.Failure then
						ll_row=dw_check.insertrow(0)
						dw_check.setitem(ll_row,"vessel_ref_nr",lds_voyages.getitemstring(ll_voyageindex,"vessel_ref_nr"))
						dw_check.setitem(ll_row,"voyage",lds_voyages.getitemstring(ll_voyageindex,"voyage_nr"))
						dw_check.setitem(ll_row,"vessel",lds_voyages.getitemnumber(ll_voyageindex,"vessel_nr"))
						if ls_errortext="" then ls_errortext="No match between proceeding and itinerary"
						dw_check.setitem(ll_row,"text","No match between proceeding and itinerary")
						dw_check.setitem(ll_row,"detail",ls_errortext)
					end if
				end if
			next
			
			
		end if
	end if
next
/* Give the windows original title */

ls_reportheadertext=mid(ls_reportheadertext,1,len(ls_reportheadertext)-2) + "]"
dw_check.object.header.text = ls_reportheadertext
this.title = "Check Module"
st_status.visible = false
destroy lds_voyages

/* Destroys the objects */
destroy lu_check 
destroy lu_tramos
destroy lnv_validator

end subroutine

on w_check.create
int iCurrent
call super::create
this.st_status=create st_status
this.rb_14=create rb_14
this.rb_13=create rb_13
this.rb_11=create rb_11
this.rb_2=create rb_2
this.rb_1=create rb_1
this.rb_4=create rb_4
this.rb_10=create rb_10
this.uo_pc=create uo_pc
this.cb_saveas=create cb_saveas
this.hpb_1=create hpb_1
this.cb_print=create cb_print
this.cb_do_it=create cb_do_it
this.rb_3=create rb_3
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rb_7=create rb_7
this.rb_8=create rb_8
this.dw_check=create dw_check
this.gb_2=create gb_2
this.sle_rows=create sle_rows
this.st_row_counter=create st_row_counter
this.cb_1=create cb_1
this.st_1=create st_1
this.em_1=create em_1
this.dw_pc=create dw_pc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_status
this.Control[iCurrent+2]=this.rb_14
this.Control[iCurrent+3]=this.rb_13
this.Control[iCurrent+4]=this.rb_11
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_4
this.Control[iCurrent+8]=this.rb_10
this.Control[iCurrent+9]=this.uo_pc
this.Control[iCurrent+10]=this.cb_saveas
this.Control[iCurrent+11]=this.hpb_1
this.Control[iCurrent+12]=this.cb_print
this.Control[iCurrent+13]=this.cb_do_it
this.Control[iCurrent+14]=this.rb_3
this.Control[iCurrent+15]=this.rb_5
this.Control[iCurrent+16]=this.rb_6
this.Control[iCurrent+17]=this.rb_7
this.Control[iCurrent+18]=this.rb_8
this.Control[iCurrent+19]=this.dw_check
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.sle_rows
this.Control[iCurrent+22]=this.st_row_counter
this.Control[iCurrent+23]=this.cb_1
this.Control[iCurrent+24]=this.st_1
this.Control[iCurrent+25]=this.em_1
this.Control[iCurrent+26]=this.dw_pc
end on

on w_check.destroy
call super::destroy
destroy(this.st_status)
destroy(this.rb_14)
destroy(this.rb_13)
destroy(this.rb_11)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.rb_4)
destroy(this.rb_10)
destroy(this.uo_pc)
destroy(this.cb_saveas)
destroy(this.hpb_1)
destroy(this.cb_print)
destroy(this.cb_do_it)
destroy(this.rb_3)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rb_7)
destroy(this.rb_8)
destroy(this.dw_check)
destroy(this.gb_2)
destroy(this.sle_rows)
destroy(this.st_row_counter)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_1)
destroy(this.dw_pc)
end on

event open;call super::open;
_setfontandcolor( this, true, true, true, true, "Microsoft Sans Serif", 14, c#color.mt_listheader_bg, c#color.mt_form_bg)


em_1.text= string(year(today()))
postevent( "ue_postopen")


end event

type st_status from statictext within w_check
boolean visible = false
integer x = 23
integer y = 2104
integer width = 3163
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "status"
boolean focusrectangle = false
end type

type rb_14 from radiobutton within w_check
integer x = 41
integer y = 1068
integer width = 869
integer height = 76
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Claim registration but no commission"
end type

event clicked;uo_pc.visible=true
dw_pc.visible=false
end event

type rb_13 from radiobutton within w_check
integer x = 41
integer y = 980
integer width = 773
integer height = 76
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Valid port of call dates"
end type

event clicked;uo_pc.visible=true
dw_pc.visible=false
end event

type rb_11 from radiobutton within w_check
integer x = 41
integer y = 892
integer width = 773
integer height = 76
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "L,D,L/D registration in calc/poc"
end type

event clicked;uo_pc.visible=true
dw_pc.visible=false
end event

type rb_2 from radiobutton within w_check
integer x = 41
integer y = 644
integer width = 782
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Valid In_log values"
end type

event clicked;uo_pc.visible=true
dw_pc.visible=false
end event

type rb_1 from radiobutton within w_check
integer x = 41
integer y = 556
integer width = 663
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Valid Claims_in_log values"
end type

event clicked;uo_pc.visible=true
dw_pc.visible=false
end event

type rb_4 from radiobutton within w_check
integer x = 41
integer y = 392
integer width = 773
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Registration in idle days module "
end type

event clicked;uo_pc.visible=true
dw_pc.visible=false
end event

type rb_10 from radiobutton within w_check
integer x = 41
integer y = 304
integer width = 841
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Registration in Off service module"
end type

event clicked;uo_pc.visible=true
dw_pc.visible=false
end event

type uo_pc from u_pc within w_check
integer x = 14
integer y = 1344
integer taborder = 190
end type

on uo_pc.destroy
call u_pc::destroy
end on

type cb_saveas from commandbutton within w_check
integer x = 3941
integer y = 2176
integer width = 343
integer height = 100
integer taborder = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save&As..."
end type

event clicked;dw_check.saveas( )
end event

type hpb_1 from hprogressbar within w_check
integer x = 14
integer y = 2184
integer width = 3173
integer height = 68
unsignedinteger maxposition = 100
unsignedinteger position = 1
integer setstep = 10
end type

type cb_print from commandbutton within w_check
integer x = 3593
integer y = 2176
integer width = 343
integer height = 100
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;/* Prints the report */
dw_check.print(true)

em_1.Setfocus()


end event

type cb_do_it from commandbutton within w_check
integer x = 3246
integer y = 2176
integer width = 343
integer height = 100
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Search"
boolean default = true
end type

event clicked;
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  		: w_check
 Object     	: cb_do_it
 Event	 		: clicked!
 Scope     		: 
 ************************************************************************************
 Author    		: TA
 Date       	: 4-8-97
 Description 	: 1111111
 Arguments 		: 
 Returns   		:
 Variables 		:
 Other 			:
*************************************************************************************
Development Log 
DATE			VERSION 		NAME			DESCRIPTION
-------- 		------- 			----- 			-------------------------------------
4-8-97		1.0				TA				Initial version  
************************************************************************************/

String ls_tmp
dw_check.reset()
setpointer(hourglass!)
sle_rows.text=""
n_service_manager		lnv_serviceMgr
n_dw_style_service   lnv_style

is_pcname =uo_pc.of_getpcname( )
il_pcnr = uo_pc.of_getpc( )

if not rb_14.checked = true then
	dw_check.dataobject = 'd_check'
end if

/* Check what radiobutton is checked */

	IF rb_3.Checked = true THEN

		/* Bunker check */
		wf_check_bunker()

	ELSEIF rb_5.Checked = true THEN

		/* Check for tc-out voyages */
		wf_tc_out_type_check()

	ELSEIF rb_6.Checked = true THEN
		
		/* Check if itinerary and proceeding match */
//		wf_check_itinerary_proceeding()
wf_checkportvalidator()

	ELSEIF rb_7.Checked = true THEN

		/* Check if estimated data/claims  match */
		wf_check_estimated_claims()

	ELSEIF rb_8.Checked = true THEN

		/* Check if miscellanous income is zero when voyage is finished */
		wf_check_misc_income()

//	ELSEIF rb_9.Checked = true THEN
//
//		/* Check if the first port is a delivery port for a tc voyage */
//		wf_check_purpose_delivery()

	ELSEIF rb_1.Checked = true THEN
	
	/* Check finished voyages */
	wf_check_finished_voyages_claims()

	ELSEIF rb_2.Checked = true THEN
	
	/* Check finished voyages */
	wf_check_finished_voyages_commission()
	ELSEIF rb_4.Checked = true THEN
	
	/* Check for port of call purpose WD */
	wf_check_purpose_idle()
	ELSEIF rb_10.Checked = true THEN
	
	/* Check for port of call purpose DOK and REP */
	wf_check_purpose_offservice()

	ELSEIF rb_11.Checked = true THEN
	
	/* Check for dem claims where ther´s no forwarding date */
	wf_check_dem_claims()

//	ELSEIF rb_12.checked = true THEN
//	wf_check_tcperiods()

ELSEIF rb_13.checked = true then
	wf_poc_dates()
	
ELSEIF rb_14.checked = true then
	wf_claims_no_commission()
	ELSE 
	 	 messagebox("Notice", "Choose a validation rule!")
	END IF

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_check)


sle_rows.text = string( dw_check.rowcount())
em_1.setfocus()

end event

type rb_3 from radiobutton within w_check
integer x = 41
integer y = 152
integer width = 768
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Bunker registration"
end type

event clicked;uo_pc.visible=true
dw_pc.visible=false
end event

type rb_5 from radiobutton within w_check
integer x = 41
integer y = 816
integer width = 617
integer height = 64
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 32768
long backcolor = 81324524
string text = "T/C Out voyage type "
end type

event clicked;uo_pc.visible=true
dw_pc.visible=false
end event

type rb_6 from radiobutton within w_check
integer x = 41
integer y = 228
integer width = 782
integer height = 64
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Itinerary / Proceeding no match"
end type

event clicked;dw_pc.visible=true
uo_pc.visible = false
end event

type rb_7 from radiobutton within w_check
integer x = 41
integer y = 480
integer width = 809
integer height = 64
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Estimated data/Claims no match"
end type

event clicked;uo_pc.visible=true
dw_pc.visible=false
end event

type rb_8 from radiobutton within w_check
integer x = 41
integer y = 732
integer width = 782
integer height = 72
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Finished voyage~'s misc. income"
end type

event clicked;uo_pc.visible=true
dw_pc.visible=false
end event

type dw_check from mt_u_datawindow within w_check
integer x = 951
integer y = 80
integer width = 3328
integer height = 1936
integer taborder = 180
string dataobject = "d_check"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

on editchanged;long rows
rows = this.rowcount()

sle_rows.text = string (rows)
end on

event doubleclicked;call super::doubleclicked;n_portvalidator lnv_validator
string ls_voyagenr
long ll_vesselnr
integer li_retval



if row>0 then
	if rb_6.checked = true then
		ls_voyagenr	= this.getitemstring(row,"voyage")
		ll_vesselnr = this.getitemnumber(row,"vessel")
		if f_AtoBviaC_used(ll_vesselnr,ls_voyagenr) then
			lnv_validator = create n_portvalidator	
			li_retval = lnv_validator.of_start( "CHECKER", ll_vesselnr, ls_voyagenr, 3)
			destroy lnv_validator		
		end if	
	end if	
end if
end event

type gb_2 from groupbox within w_check
integer x = 9
integer y = 56
integer width = 910
integer height = 1120
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "Validation rule"
end type

type sle_rows from singlelineedit within w_check
integer x = 4041
integer y = 2076
integer width = 238
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_row_counter from statictext within w_check
integer x = 3845
integer y = 2092
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Rows:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_check
boolean visible = false
integer x = 23
integer y = 1200
integer width = 247
integer height = 108
integer taborder = 190
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "none"
end type

event clicked;wf_check_tc_currency()
end event

type st_1 from statictext within w_check
integer x = 453
integer y = 1228
integer width = 169
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Year:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_1 from editmask within w_check
integer x = 667
integer y = 1216
integer width = 247
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean border = false
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
string displaydata = "~t/"
double increment = 1
string minmax = "2000~~2200"
end type

event losefocus;if this.text = "" then
	messagebox("Notice","Remember to specify the year!")
	this.Setfocus()
end if
end event

type dw_pc from u_datagrid within w_check
boolean visible = false
integer x = 14
integer y = 1348
integer width = 901
integer height = 668
integer taborder = 20
string dataobject = "d_sq_tb_profit_center_list"
boolean vscrollbar = true
boolean border = false
boolean ib_multiselect = true
end type

