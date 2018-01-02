$PBExportHeader$w_atobviac_calc_recalc.srw
$PBExportComments$Window for recalcing all calculations
forward
global type w_atobviac_calc_recalc from mt_w_response_calc
end type
type em_nbrofcalcs from mt_u_editmask within w_atobviac_calc_recalc
end type
type uo_calculation from u_atobviac_calculation within w_atobviac_calc_recalc
end type
type cb_cancel from commandbutton within w_atobviac_calc_recalc
end type
type dw_status_log from uo_datawindow within w_atobviac_calc_recalc
end type
type cb_recalc from commandbutton within w_atobviac_calc_recalc
end type
type st_status from statictext within w_atobviac_calc_recalc
end type
type st_no_calc from statictext within w_atobviac_calc_recalc
end type
type st_no_calculations from statictext within w_atobviac_calc_recalc
end type
type st_elapsed_time from statictext within w_atobviac_calc_recalc
end type
type st_time from statictext within w_atobviac_calc_recalc
end type
type st_avgtime from statictext within w_atobviac_calc_recalc
end type
type st_avg_time from statictext within w_atobviac_calc_recalc
end type
type st_timeleft_ from statictext within w_atobviac_calc_recalc
end type
type st_timeleft from statictext within w_atobviac_calc_recalc
end type
type cbx_no_reload from uo_cbx_base within w_atobviac_calc_recalc
end type
type rb_all from uo_rb_base within w_atobviac_calc_recalc
end type
type rb_failed from uo_rb_base within w_atobviac_calc_recalc
end type
type rb_ok from uo_rb_base within w_atobviac_calc_recalc
end type
type cbx_save from uo_cbx_base within w_atobviac_calc_recalc
end type
type rb_autocomp_none from uo_rb_base within w_atobviac_calc_recalc
end type
type rb_autocomp_read from uo_rb_base within w_atobviac_calc_recalc
end type
type rb_autocomp_write from uo_rb_base within w_atobviac_calc_recalc
end type
type sle_autocomp_filename from singlelineedit within w_atobviac_calc_recalc
end type
type st_1 from statictext within w_atobviac_calc_recalc
end type
type cbx_adhook_print from uo_cbx_base within w_atobviac_calc_recalc
end type
type gb_status from groupbox within w_atobviac_calc_recalc
end type
type cb_print from commandbutton within w_atobviac_calc_recalc
end type
type gb_time from uo_gb_base within w_atobviac_calc_recalc
end type
type gb_show from uo_gb_base within w_atobviac_calc_recalc
end type
type cb_close from commandbutton within w_atobviac_calc_recalc
end type
type gb_options from uo_gb_base within w_atobviac_calc_recalc
end type
type gb_autocompare from uo_gb_base within w_atobviac_calc_recalc
end type
type dw_status_log_check from datawindow within w_atobviac_calc_recalc
end type
type cb_1 from uo_cb_base within w_atobviac_calc_recalc
end type
end forward

global type w_atobviac_calc_recalc from mt_w_response_calc
integer x = 640
integer width = 2930
integer height = 1924
string title = "Recalc Utility"
em_nbrofcalcs em_nbrofcalcs
uo_calculation uo_calculation
cb_cancel cb_cancel
dw_status_log dw_status_log
cb_recalc cb_recalc
st_status st_status
st_no_calc st_no_calc
st_no_calculations st_no_calculations
st_elapsed_time st_elapsed_time
st_time st_time
st_avgtime st_avgtime
st_avg_time st_avg_time
st_timeleft_ st_timeleft_
st_timeleft st_timeleft
cbx_no_reload cbx_no_reload
rb_all rb_all
rb_failed rb_failed
rb_ok rb_ok
cbx_save cbx_save
rb_autocomp_none rb_autocomp_none
rb_autocomp_read rb_autocomp_read
rb_autocomp_write rb_autocomp_write
sle_autocomp_filename sle_autocomp_filename
st_1 st_1
cbx_adhook_print cbx_adhook_print
gb_status gb_status
cb_print cb_print
gb_time gb_time
gb_show gb_show
cb_close cb_close
gb_options gb_options
gb_autocompare gb_autocompare
dw_status_log_check dw_status_log_check
cb_1 cb_1
end type
global w_atobviac_calc_recalc w_atobviac_calc_recalc

type variables
Long il_id_list[], il_id_count=1
Boolean ib_processing, ib_cancel
DataWindow idw_summary
end variables

forward prototypes
public subroutine wf_create_id_list ()
public subroutine wf_compare (double ad_value, string as_fieldname, ref string as_text)
public function string wf_time_to_str (long al_time)
public subroutine wf_load_original_speedlist ()
public function integer wf_account_numbers ()
public subroutine documentation ()
end prototypes

public subroutine wf_create_id_list ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Creates a list IL_ID_LIST that contains all calculation ID's

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Long ll_id_empty[], ll_index
long ll_counter=1

// Clear the list
il_id_list = ll_id_empty
il_id_count=1


mt_n_datastore  lds_recalc
lds_recalc = create mt_n_datastore
lds_recalc.dataobject="d_sq_gr_recalc"
lds_recalc.settransobject(sqlca)
lds_recalc.retrieve(long(em_nbrofcalcs.text))

do
	if not isnull(lds_recalc.getitemnumber(il_id_count,"cal_calc_id")) then
		il_id_list[upperbound(il_id_list)+1] = lds_recalc.getitemnumber(il_id_count,"cal_calc_id")
	end if
	il_id_count++
loop until il_id_count>lds_recalc.rowcount()	


// Decrement the number of cargoes (to avoid calculation #1 - the dummy calculation),
// this should actually be done as a WHERE statement instead.
il_id_count --
st_no_calc.text=String(il_id_count)
end subroutine

public subroutine wf_compare (double ad_value, string as_fieldname, ref string as_text);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Compares the value given in AD_VALUE with the value from the field
 					named AS_FIELDNAME. If the different between the two values is greater
					than 5 (difference treshold), the two values together with the 
					fieldname is added to the AS_TEXT field.

 Arguments : AD_VALUE as double,
 				 AS_FIELDNAME as string
				 AS_TEXT as string REF 

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Decimal{2}  ld_comparevalue, ld_value

ld_value = ad_value
ld_comparevalue = idw_summary.getItemNumber(1, as_fieldname)

// Check if the difference is greater than the treshold value
If Abs(ld_value - ld_comparevalue)>5 Then
	
	// Remove "CAL_CALC" from fieldname, if it's there
	If Pos(as_fieldname,'cal_calc')=1 Then
		as_fieldname=Mid(as_fieldname,10)
	end if

	// And update the AS_TEXT variable
	as_text += as_fieldname+" ("+String(ld_value)+") ("+String(ld_comparevalue)+") "
End if
end subroutine

public function string wf_time_to_str (long al_time);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Converts the time given in AL_TIME to a string

 Arguments : AL_TIME as integer

 Returns   : Time as String   

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(String(Int(al_time / 60000), "00") + ":" + &
			String(Int(Mod(al_time,60000) / 1000),"00") + ":"  + &
					Left(String(Mod(al_time,1000),"00"),2))
end function

public subroutine wf_load_original_speedlist ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : 

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Variable declaration
Long ll_fix_id, ll_count
String ls_tmp

// Get the fixtured ID
ll_fix_id = uo_calculation.uf_get_fix_id()
// and return if it's null
If IsNull(ll_fix_id) Then Return

// Declare a cursor for retrieving all consumptions WHERE FIX_ID = our fix ID and
// fixture type is 4 (=fixture). This will retrieve all the consumptions for that
// calculation
DECLARE speedcursor CURSOR FOR  
SELECT CAL_CONS_TYPE,  
        	CAL_CONS_SPEED,   
		CAL_CONS_FO,   
        	CAL_CONS_DO,   
         	CAL_CONS_MGO   
    	FROM CAL_CCON  
  	WHERE CAL_CALC_ID = 
		(SELECT CAL_CALC_ID 
		FROM CAL_CALC
		WHERE (CAL_CALC_FIX_ID = :ll_fix_id) AND
		(CAL_CALC_STATUS = 4));
COMMIT;

// Open the cursor
OPEN speedcursor;

ll_count = 1

// And fetch all consumption entries into the speedlist on the calculation
DO WHILE SQLCA.SQLCode =  0

	FETCH speedcursor 
	INTO :uo_calculation.iuo_calc_nvo.istr_speedlist[ll_count].i_type,
		:uo_calculation.iuo_calc_nvo.istr_speedlist[ll_count].d_speed,
		:uo_calculation.iuo_calc_nvo.istr_speedlist[ll_count].d_fo,
		:uo_calculation.iuo_calc_nvo.istr_speedlist[ll_count].d_do,
		:uo_calculation.iuo_calc_nvo.istr_speedlist[ll_count].d_mgo;

	If SQLCA.SQLCode = 0 Then
		// Set the text for each speedentry
		CHOOSE CASE uo_calculation.iuo_calc_nvo.istr_speedlist[ll_count].i_type
			CASE 1
				ls_tmp = "Ballasted"
			CASE 2
				ls_tmp = "Loaded"
			CASE 3
				ls_tmp = "At Sea"
			CASE 4
				ls_tmp = "At port"
			CASE 5
				ls_tmp = "At port w/ gear"
		END CHOOSE	

		uo_calculation.iuo_calc_nvo.istr_speedlist[ll_count].s_name = ls_tmp 
		// round the entry to avoid long decimals (14.888888888889)
		Round(uo_calculation.iuo_calc_nvo.istr_speedlist[ll_count].d_speed,4)
		ll_count ++
	End if			
LOOP

CLOSE speedcursor;
COMMIT;

// Clear the last entry, since it contains garbage
s_speed lstr_speed
	uo_calculation.iuo_calc_nvo.istr_speedlist[ll_count] = lstr_speed

end subroutine

public function integer wf_account_numbers ();/************************************************************************************
 Arthur Andersen PowerBuilder Development

 Author  : Teit Aunt 
   
 Date    : 9-12-97

 Description : Generates and inserts the account number for each broker and each
 					charterer in the tables.

 Arguments   : None

 Returns     : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
9-12-97	1.0		TA		Initial version
************************************************************************************/
// Variables
datastore lds_broker_datastore, lds_charterer_datastore
long ll_rows, ll_count, ll_broker_no, ll_charterer_no
string ls_number
integer li_length, li_return, li_set

// Initial values
li_return = 1

// This is the creation of the charterer account numbers

// Declare broker datastore and populate it
lds_broker_datastore = CREATE datastore
lds_broker_datastore.DataObject = "d_broker_acc_no"

lds_broker_datastore.SetTransObject(SQLCA)
lds_broker_datastore.Retrieve()

// Get a row and investigate the broker number
ll_rows = lds_broker_datastore.RowCount()

CHOOSE CASE uo_global.is_database
	CASE "TG_TRAMOS_PRIMARY_CPH"
		
		FOR ll_count = 1 TO ll_rows
			
			ll_broker_no = lds_broker_datastore.GetItemNumber(ll_count, "broker_nr")
			
			// Investigate size
			li_length = Len(string(ll_broker_no))
			
			CHOOSE CASE li_length
				CASE 1
					ls_number = "300000" + string(ll_broker_no)
				CASE 2
					ls_number = "30000" + string(ll_broker_no)
				CASE 3
					ls_number = "3000" + string(ll_broker_no)
				CASE 4
					ls_number = "300" + string(ll_broker_no)
				CASE ELSE
					MessageBox("Error","The broker number has a wrong size ~r~n" + &
								"The number is: " + string(ll_broker_no))
			END CHOOSE
		
			li_set = lds_broker_datastore.SetItem(ll_count, "apm_acc_nr", ls_number)
			If li_set <> 1 then li_return = -1
			
		NEXT
		
	CASE "BU_TRAMOS_PRIMARY_CPH"

		FOR ll_count = 1 TO ll_rows
			
			ll_broker_no = lds_broker_datastore.GetItemNumber(ll_count, "broker_nr")
			
			// Investigate size
			li_length = Len(string(ll_broker_no))
			
			CHOOSE CASE li_length
				CASE 1
					ls_number = "310000" + string(ll_broker_no)
				CASE 2
					ls_number = "31000" + string(ll_broker_no)
				CASE 3
					ls_number = "3100" + string(ll_broker_no)
				CASE 4
					ls_number = "310" + string(ll_broker_no)
				CASE ELSE
					MessageBox("Error","The broker number has a wrong size ~r~n" + &
								"The number is: " + string(ll_broker_no))
			END CHOOSE
		
			li_set = lds_broker_datastore.SetItem(ll_count, "apm_acc_nr", ls_number)
			If li_set <> 1 then li_return = -1
			
		NEXT
		
	CASE "VL_TRAMOS_PRIMARY_CPH"
		
				FOR ll_count = 1 TO ll_rows
			
			ll_broker_no = lds_broker_datastore.GetItemNumber(ll_count, "broker_nr")
			
			// Investigate size
			li_length = Len(string(ll_broker_no))
			
			CHOOSE CASE li_length
				CASE 1
					ls_number = "320000" + string(ll_broker_no)
				CASE 2
					ls_number = "32000" + string(ll_broker_no)
				CASE 3
					ls_number = "3200" + string(ll_broker_no)
				CASE 4
					ls_number = "320" + string(ll_broker_no)
				CASE ELSE
					MessageBox("Error","The broker number has a wrong size" + &
								"The number is: " + string(ll_broker_no))
			END CHOOSE
		
			li_set = lds_broker_datastore.SetItem(ll_count, "apm_acc_nr", ls_number)
			If li_set <> 1 then li_return = -1
			
		NEXT

	CASE ELSE
		Return(-3)
END CHOOSE

// Update table with result
lds_broker_datastore.Update()

// Destroy the datastore
Destroy lds_broker_datastore

// This is the creation of the charterer account numbers

// Declare charterer datastore and populate it
lds_charterer_datastore = CREATE datastore
lds_charterer_datastore.DataObject = "d_charterer_acc_no"

lds_charterer_datastore.SetTransObject(SQLCA)
lds_charterer_datastore.Retrieve()

// Get a row and investigate the broker number
ll_rows = lds_charterer_datastore.RowCount()

CHOOSE CASE uo_global.is_database
	CASE "TG_TRAMOS_PRIMARY_CPH"
		
		FOR ll_count = 1 TO ll_rows
			
			ll_charterer_no = lds_charterer_datastore.GetItemNumber(ll_count, "chart_nr")
			
			// Investigate size
			li_length = Len(string(ll_charterer_no))
			
			CHOOSE CASE li_length
				CASE 1
					ls_number = "301000" + string(ll_charterer_no)
				CASE 2
					ls_number = "30100" + string(ll_charterer_no)
				CASE 3
					ls_number = "3010" + string(ll_charterer_no)
				CASE 4
					ls_number = "301" + string(ll_charterer_no)
				CASE ELSE
					MessageBox("Error","The charterer number has a wrong size" + &
								"The number is: " + string(ll_charterer_no))
			END CHOOSE
		
			li_set = lds_charterer_datastore.SetItem(ll_count, "chart_apm_acc_nr", ls_number)
			If li_set <> 1 then li_return = -2
			
		NEXT
		
	CASE "BU_TRAMOS_PRIMARY_CPH"

		FOR ll_count = 1 TO ll_rows
			
			ll_charterer_no = lds_charterer_datastore.GetItemNumber(ll_count, "chart_nr")
			
			// Investigate size
			li_length = Len(string(ll_charterer_no))
			
			CHOOSE CASE li_length
				CASE 1
					ls_number = "311000" + string(ll_charterer_no)
				CASE 2
					ls_number = "31100" + string(ll_charterer_no)
				CASE 3
					ls_number = "3110" + string(ll_charterer_no)
				CASE 4
					ls_number = "311" + string(ll_charterer_no)
				CASE ELSE
					MessageBox("Error","The charterer number has a wrong size" + &
								"The number is: " + string(ll_charterer_no))
			END CHOOSE
		
			li_set = lds_charterer_datastore.SetItem(ll_count, "chart_apm_acc_nr", ls_number)
			If li_set <> 1 then li_return = -2
			
		NEXT
		
	CASE "VL_TRAMOS_PRIMARY_CPH"
		
		FOR ll_count = 1 TO ll_rows
			
			ll_charterer_no = lds_charterer_datastore.GetItemNumber(ll_count, "chart_nr")
			
			// Investigate size
			li_length = Len(string(ll_charterer_no))
			
			CHOOSE CASE li_length
				CASE 1
					ls_number = "321000" + string(ll_charterer_no)
				CASE 2
					ls_number = "32100" + string(ll_charterer_no)
				CASE 3
					ls_number = "3210" + string(ll_charterer_no)
				CASE 4
					ls_number = "321" + string(ll_charterer_no)
				CASE ELSE
					MessageBox("Error","The charterer number has a wrong size" + &
								"The number is: " + string(ll_charterer_no))
			END CHOOSE
		
			li_set = lds_charterer_datastore.SetItem(ll_count, "chart_apm_acc_nr", ls_number)
			If li_set <> 1 then li_return = -2
			
		NEXT

	CASE ELSE
		Return(-3)
END CHOOSE

// Update the result to the table
lds_charterer_datastore.Update()

// Destroy the datastore
Destroy lds_charterer_datastore

return(li_return)

end function

public subroutine documentation ();/********************************************************************
   w_atobviac_calc_recalc
	
	<OBJECT>

	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	06/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
********************************************************************/
end subroutine

event ue_retrieve;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calls the WF_CREATE_ID_LIST to update the list of ID's

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

//wf_create_id_list()
end event

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Posts the retrieve event

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

_setfontandcolor( this, true, true, true, true, "Microsoft Sans Serif", 14, c#color.mt_listheader_bg, c#color.mt_form_bg)



PostEvent("ue_retrieve")
end event

on w_atobviac_calc_recalc.create
int iCurrent
call super::create
this.em_nbrofcalcs=create em_nbrofcalcs
this.uo_calculation=create uo_calculation
this.cb_cancel=create cb_cancel
this.dw_status_log=create dw_status_log
this.cb_recalc=create cb_recalc
this.st_status=create st_status
this.st_no_calc=create st_no_calc
this.st_no_calculations=create st_no_calculations
this.st_elapsed_time=create st_elapsed_time
this.st_time=create st_time
this.st_avgtime=create st_avgtime
this.st_avg_time=create st_avg_time
this.st_timeleft_=create st_timeleft_
this.st_timeleft=create st_timeleft
this.cbx_no_reload=create cbx_no_reload
this.rb_all=create rb_all
this.rb_failed=create rb_failed
this.rb_ok=create rb_ok
this.cbx_save=create cbx_save
this.rb_autocomp_none=create rb_autocomp_none
this.rb_autocomp_read=create rb_autocomp_read
this.rb_autocomp_write=create rb_autocomp_write
this.sle_autocomp_filename=create sle_autocomp_filename
this.st_1=create st_1
this.cbx_adhook_print=create cbx_adhook_print
this.gb_status=create gb_status
this.cb_print=create cb_print
this.gb_time=create gb_time
this.gb_show=create gb_show
this.cb_close=create cb_close
this.gb_options=create gb_options
this.gb_autocompare=create gb_autocompare
this.dw_status_log_check=create dw_status_log_check
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_nbrofcalcs
this.Control[iCurrent+2]=this.uo_calculation
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.dw_status_log
this.Control[iCurrent+5]=this.cb_recalc
this.Control[iCurrent+6]=this.st_status
this.Control[iCurrent+7]=this.st_no_calc
this.Control[iCurrent+8]=this.st_no_calculations
this.Control[iCurrent+9]=this.st_elapsed_time
this.Control[iCurrent+10]=this.st_time
this.Control[iCurrent+11]=this.st_avgtime
this.Control[iCurrent+12]=this.st_avg_time
this.Control[iCurrent+13]=this.st_timeleft_
this.Control[iCurrent+14]=this.st_timeleft
this.Control[iCurrent+15]=this.cbx_no_reload
this.Control[iCurrent+16]=this.rb_all
this.Control[iCurrent+17]=this.rb_failed
this.Control[iCurrent+18]=this.rb_ok
this.Control[iCurrent+19]=this.cbx_save
this.Control[iCurrent+20]=this.rb_autocomp_none
this.Control[iCurrent+21]=this.rb_autocomp_read
this.Control[iCurrent+22]=this.rb_autocomp_write
this.Control[iCurrent+23]=this.sle_autocomp_filename
this.Control[iCurrent+24]=this.st_1
this.Control[iCurrent+25]=this.cbx_adhook_print
this.Control[iCurrent+26]=this.gb_status
this.Control[iCurrent+27]=this.cb_print
this.Control[iCurrent+28]=this.gb_time
this.Control[iCurrent+29]=this.gb_show
this.Control[iCurrent+30]=this.cb_close
this.Control[iCurrent+31]=this.gb_options
this.Control[iCurrent+32]=this.gb_autocompare
this.Control[iCurrent+33]=this.dw_status_log_check
this.Control[iCurrent+34]=this.cb_1
end on

on w_atobviac_calc_recalc.destroy
call super::destroy
destroy(this.em_nbrofcalcs)
destroy(this.uo_calculation)
destroy(this.cb_cancel)
destroy(this.dw_status_log)
destroy(this.cb_recalc)
destroy(this.st_status)
destroy(this.st_no_calc)
destroy(this.st_no_calculations)
destroy(this.st_elapsed_time)
destroy(this.st_time)
destroy(this.st_avgtime)
destroy(this.st_avg_time)
destroy(this.st_timeleft_)
destroy(this.st_timeleft)
destroy(this.cbx_no_reload)
destroy(this.rb_all)
destroy(this.rb_failed)
destroy(this.rb_ok)
destroy(this.cbx_save)
destroy(this.rb_autocomp_none)
destroy(this.rb_autocomp_read)
destroy(this.rb_autocomp_write)
destroy(this.sle_autocomp_filename)
destroy(this.st_1)
destroy(this.cbx_adhook_print)
destroy(this.gb_status)
destroy(this.cb_print)
destroy(this.gb_time)
destroy(this.gb_show)
destroy(this.cb_close)
destroy(this.gb_options)
destroy(this.gb_autocompare)
destroy(this.dw_status_log_check)
destroy(this.cb_1)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_atobviac_calc_recalc
end type

type em_nbrofcalcs from mt_u_editmask within w_atobviac_calc_recalc
integer x = 1531
integer y = 1216
integer width = 293
integer height = 72
integer taborder = 130
string text = "10"
boolean spin = true
double increment = 1
string minmax = "1~~1000"
end type

type uo_calculation from u_atobviac_calculation within w_atobviac_calc_recalc
boolean visible = false
integer x = 2647
integer y = 1180
integer width = 215
integer height = 208
integer taborder = 20
end type

on uo_calculation.destroy
call u_atobviac_calculation::destroy
end on

type cb_cancel from commandbutton within w_atobviac_calc_recalc
integer x = 2359
integer y = 1440
integer width = 247
integer height = 108
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Ca&ncel"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Cancels the recalculation, by setting the IB_CANCEL to true. 
 					The recalculation process checkes this flag during it's recalc
					process

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Beep(1)
ib_cancel = true

end event

type dw_status_log from uo_datawindow within w_atobviac_calc_recalc
integer x = 32
integer y = 8
integer width = 2834
integer height = 1148
integer taborder = 70
string dataobject = "d_calc_recalc_log"
boolean vscrollbar = true
boolean border = false
end type

type cb_recalc from commandbutton within w_atobviac_calc_recalc
integer x = 2359
integer y = 1184
integer width = 247
integer height = 108
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Recalc"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 14-2-97

 Description : Recalculates all calculations - and stores them if requested.

 Arguments : none

 Returns   : none

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
14-2-97		3.0			MI		Initial version  
************************************************************************************/

// Variable declaration
Long ll_count, ll_row, ll_time, ll_tmp, ll_row_check
Double ld_gross_freight, ld_commission, ld_adr_commission, ld_miles_ballasted, ld_miles_loaded, ld_days_loading, ld_days_discharging
Double ld_total_laytime, ld_days_port, ld_days_canal, ld_total_days, ld_other_days, ld_bunkering_days, ld_idle_days
Double ld_total_demurrage, ld_fo_total, ld_do_total, ld_mgo_total, ld_fo_expenses, ld_do_expenses, ld_mgo_expenses
Double ld_canal_expenses, ld_port_expenses, ld_total_expenses, ld_total_costs
Double ld_net_day, ld_gross_day, ld_after_drc, ld_after_cap, ld_tc_eqv		
Double ld_tc, ld_oa, ld_cap, ld_drc
Integer li_ok, li_failed, li_warnings, li_errors, li_status, li_tmp
String ls_text, ls_tmp
s_calculation_parm lstr_parm, lstr_parm_empty
Boolean lb_vessel_data_changed, lb_ok, lb_old_consumption_data

// Set the DW_STATUS_LOG to be a D_CALC_RECALC_LOG (just incase it was changed earlier)
dw_status_log.DataObject = "d_calc_recalc_log"

// Get a local pointer to the DW_CALC_SUMMARY datawindow on the calculation object
idw_summary = uo_calculation.uo_calc_summary.dw_calc_summary

// Create new list of ID's
wf_create_id_list()

// Return if user cancels the acknowledge dialog
If MessageBox("Recalc test", String(il_id_count)+" calculations will be recalculated~r~n~r~nContinue ?", Exclamation!, YesNo!, 1) <> 1 Then return

// Double-acknowledge if the save calculation is checked
If cbx_save.checked then
	If MessageBox("Warning", "You have checked the 'save calculation' box, and all calculations will therefore be saved after calculation~r~n~r~nContinue ?", Exclamation!, YesNo!, 1) <> 1 Then return
end if

// Reset the LOG and LOG_CHECK datawindows
dw_status_log.Reset()
dw_status_log_check.Reset()

// If automatic compare is on (RB_AUTOCOMP_READ.CHECKED) then read the autocomp
// file into the DW_STATUS_LOG_CHECK datawindow
If rb_autocomp_read.checked Then
	li_tmp = dw_status_log_check.ImportFile(sle_autocomp_filename.text)
	If li_tmp < 0 Then
		Messagebox("Error", "Error reading check file~r~n~r~n'"+sle_autocomp_filename.text+"' code: "+String(li_tmp))
		Return
	End if
End if

// Update the button's statuses
cb_recalc.enabled = false
cb_close.enabled = false
cb_cancel.enabled = true
ib_processing = true
ib_cancel = false

// Get the initial time
ll_time = cpu()

// Set the calculation object not to show messages, WS reload and VESSEL data reload
// according to the CBX_NO_RELOAD checkbox
uo_calculation.ib_show_messages = false
uo_calculation.ib_no_ws_reload = cbx_no_reload.checked
uo_calculation.ib_no_vesseldata_reload = cbx_no_reload.checked

// Loop through all calculation ID's (stored in the IL_ID_LIST) except for the
// first (ID=1), since this is the dummy calculation
For ll_count = 1 To il_id_count
	
	// Set vesseldata change, old consumption data and ok to false
	lb_vessel_data_changed = false
	lb_old_consumption_data = false
	lb_ok = false

	// Yeild to update other programs, and display the calculation in the ST_STATUS field
	Yield()
	Yield()
	st_status.text = "Calulating " + String(ll_count)	+" of "+String(il_id_count)+" OK: "+String(li_ok)+" failed: "+String(li_failed)+" warnings: "+ &
		String(li_warnings)+" errors: "+String(li_errors)+" "+String(il_id_list[ll_count])
	Yield()
	Yield()
	Yield()
	
	// Use code like the line below, if you're only trying specific calculations
	//	 If (il_id_list[ll_count]<117) Or (il_id_list[ll_count]>119) Then Continue

	// Retrieve the calculation into the calculation object
	uo_calculation.uf_retrieve(il_id_list[ll_count])

	// Get the calculation status into the local LI_STATUS variable
	li_status = uo_calculation.uf_get_status(0)

	// Save current data that will be used for comparison after calculation
	ld_cap = uo_calculation.uo_calc_summary.dw_calc_summary.GetItemNumber(1, "cal_calc_cap")
	ld_oa = uo_calculation.uo_calc_summary.dw_calc_summary.GetItemNumber(1, "cal_calc_oa")
	ld_tc = uo_calculation.uo_calc_summary.dw_calc_summary.GetItemNumber(1, "cal_calc_tc")
	ld_drc = uo_calculation.uo_calc_summary.dw_calc_summary.GetItemNumber(1, "cal_calc_drc")

	ld_gross_freight = idw_summary.GetItemNumber(1, "cal_calc_gross_freight")	
	ld_commission = idw_summary.GetItemNumber(1, "cal_calc_total_commission")
	ld_adr_commission = idw_summary.GetItemNumber(1, "cal_calc_total_adr_commission")
	ld_miles_ballasted = idw_summary.GetItemNumber(1, "cal_calc_miles_ballasted")	
	ld_miles_loaded = idw_summary.GetItemNumber(1, "cal_calc_miles_loaded")
	ld_days_loading = idw_summary.GetItemNumber(1, "cal_calc_days_loading")
	ld_days_discharging = idw_summary.GetItemNumber(1, "cal_calc_days_discharging")
	ld_total_laytime = idw_summary.GetItemNumber(1, "cal_calc_total_laytime")
	ld_days_port = idw_summary.GetItemNumber(1, "cal_calc_days_port")
	ld_days_canal = idw_summary.GetItemNumber(1, "cal_calc_days_chanal")
	ld_total_days = idw_summary.GetItemNumber(1, "cal_calc_total_days")
	ld_other_days = idw_summary.GetItemNumber(1, "cal_calc_add_other_days")
	ld_bunkering_days = idw_summary.GetItemNumber(1, "cal_calc_add_bunkering_days")
	ld_idle_days = idw_summary.GetItemNumber(1, "cal_calc_add_idle_days")

	ld_total_demurrage = idw_summary.GetItemNumber(1, "cal_calc_total_demurrage")
	ld_fo_total  = idw_summary.GetItemNumber(1, "cal_calc_fo_total")
	ld_do_total =  idw_summary.GetItemNumber(1, "cal_calc_do_total")
	ld_mgo_total  = idw_summary.GetItemNumber(1, "cal_calc_mgo_total")

	ld_fo_expenses =  idw_summary.GetItemNumber(1, "cal_calc_fo_expenses")
	ld_do_expenses  = idw_summary.GetItemNumber(1, "cal_calc_do_expenses")
	ld_mgo_expenses  = idw_summary.GetItemNumber(1, "cal_calc_mgo_expenses")
		
	ld_canal_expenses  = idw_summary.GetItemNumber(1, "cal_calc_chanal_expenses")
	ld_port_expenses  = idw_summary.GetItemNumber(1, "cal_calc_port_expenses")
	ld_total_expenses  = idw_summary.GetItemNumber(1, "cal_calc_total_expenses")
	ld_total_costs  = idw_summary.GetItemNumber(1, "cal_calc_total_costs")

	ld_net_day  = idw_summary.GetItemNumber(1, "cal_calc_net_day")
	ld_gross_day  = idw_summary.GetItemNumber(1, "cal_calc_gross_day")
	ld_after_drc  = idw_summary.GetItemNumber(1, "cal_calc_after_drc_oa")
	ld_after_cap  = idw_summary.GetItemNumber(1, "cal_calc_after_drc_oa_cap")
	ld_tc_eqv  = idw_summary.GetItemNumber(1, "cal_calc_tc_eqv")

	Yield()
	Yield()
	Yield()
	Yield()

	// Load the original or new speedlist depending on the IB_NO_VESSELDATA_RELOAD
	// flag in the calculation
	if uo_calculation.ib_no_vesseldata_reload Then
		wf_load_original_speedlist()
	Else
		uo_calculation.uf_reload_speedlist()
	End if

	Yield()
	Yield()	
	Yield()
	Yield()

	ls_text = ""

	// Set up the calculation parm for silent calculation (code 2)
	lstr_parm = lstr_parm_empty
	
	lstr_parm.b_silent_calculation = true
	lstr_parm.i_function_code = 2

	// and do the calculation
	If uo_calculation.uf_calculate_with_parm(lstr_parm) Then

		// Compare fuel consumption with old fuel consumption
		wf_compare(ld_fo_total , "cal_calc_fo_total", ls_text)
		wf_compare(ld_do_total, "cal_calc_do_total", ls_text)
		wf_compare(ld_mgo_total, "cal_calc_mgo_total", ls_text)

		// If consumption was different (LS_TEXT<>"") and it's a fixture or above on 
		// IB_NO_VESSELDATA_RELOAD was false, then try the calculation again with
		// the original consumption
 		If (ls_text <> "") and (li_status>=4)  and (not uo_calculation.ib_no_vesseldata_reload ) Then

			// Redo the calculation steps
			lstr_parm = lstr_parm_empty
			lstr_parm.b_silent_calculation = true
			lstr_parm.i_function_code = 2
			
			// Reset itinerary calculation
			uo_calculation.TriggerEvent("ue_port_changed")
			
			// load the original speedlist and recalculate
			wf_load_original_speedlist()
			uo_calculation.uf_calculate_with_parm(lstr_parm)

			// Now compare the fuel comsumption again
			ls_text = ""
			wf_compare(ld_fo_total , "cal_calc_fo_total", ls_text)
			wf_compare(ld_do_total, "cal_calc_do_total", ls_text)
			wf_compare(ld_mgo_total, "cal_calc_mgo_total", ls_text)

			If ls_text <> "" Then
				// Didn't help - do it with new values again, so we have valid
				// data for the next comparisons

				lstr_parm = lstr_parm_empty
				lstr_parm.b_silent_calculation = true
				lstr_parm.i_function_code = 2
				
				// reload speedlist and reset the itinerary calculation
				uo_calculation.uf_reload_speedlist()
				uo_calculation.TriggerEvent("ue_port_changed") 
				
				uo_calculation.uf_calculate_with_parm(lstr_parm)
			Else
				lb_old_consumption_data = true
			End if				
		End if

		// Now compare all fields, changes between original and new values will
		// be written to the LS_TEXT variable
		ls_text = ""

		Yield()
		Yield()
		Yield()
		Yield()

		wf_compare(ld_gross_freight, "cal_calc_gross_freight", ls_text)
		wf_compare(ld_commission, "cal_calc_total_commission", ls_text)
		wf_compare(ld_adr_commission, "cal_calc_total_adr_commission", ls_text)
		wf_compare(ld_miles_ballasted,  "cal_calc_miles_ballasted", ls_text)	
		wf_compare(ld_miles_loaded, "cal_calc_miles_loaded", ls_text)
		wf_compare(ld_days_loading , "cal_calc_days_loading", ls_text)
		wf_compare(ld_days_discharging,"cal_calc_days_discharging", ls_text)
		wf_compare(ld_total_laytime, "cal_calc_total_laytime", ls_text)
		wf_compare(ld_days_port, "cal_calc_days_port", ls_text)
		wf_compare(ld_days_canal, "cal_calc_days_chanal", ls_text)
		wf_compare(ld_total_days, "cal_calc_total_days", ls_text)
		//if cbx_check_add_other_days.checked then wf_compare(ld_other_days,"cal_calc_add_other_days", ls_text)
		wf_compare(ld_bunkering_days,"cal_calc_add_bunkering_days", ls_text)
		wf_compare(ld_idle_days,"cal_calc_add_idle_days", ls_text)

		wf_compare(ld_total_demurrage,  "cal_calc_total_demurrage", ls_text)
		wf_compare(ld_fo_total , "cal_calc_fo_total", ls_text)
		wf_compare(ld_do_total, "cal_calc_do_total", ls_text)
		wf_compare(ld_mgo_total, "cal_calc_mgo_total", ls_text)

		Yield()
		Yield()
		Yield()
		Yield()	
	
		wf_compare(ld_fo_expenses, "cal_calc_fo_expenses", ls_text)
		wf_compare(ld_do_expenses, "cal_calc_do_expenses", ls_text)
		wf_compare(ld_mgo_expenses, "cal_calc_mgo_expenses", ls_text)
		
		wf_compare(ld_canal_expenses, "cal_calc_chanal_expenses", ls_text)
		wf_compare(ld_port_expenses, "cal_calc_port_expenses", ls_text)
		wf_compare(ld_total_expenses, "cal_calc_total_expenses", ls_text)

		// If vesseldata (TC, DRC, OA & CAP) is different than the original ones,
		// then set LB_VESSEL_DATA_CHANGED to true to add the comment (VESSEL DATA 
		// HAS CHANGED) to the LS_TEXT
		if (ls_text = "") and (li_status>=4) Then
			if ld_tc <> uo_calculation. iuo_calc_nvo.istr_calc_vessel_data.d_tc Or &
			ld_drc <> uo_calculation. iuo_calc_nvo.istr_calc_vessel_data.d_drc Or &
			ld_oa <> uo_calculation. iuo_calc_nvo.istr_calc_vessel_data.d_oa Or &
			ld_cap <> uo_calculation. iuo_calc_nvo.istr_calc_vessel_data.d_cap Then
				lb_vessel_data_changed = true
			End if
		End if 

		wf_compare(ld_total_costs, "cal_calc_total_costs", ls_text)

		wf_compare(ld_net_day, "cal_calc_net_day", ls_text)
		wf_compare(ld_gross_day, "cal_calc_gross_day", ls_text)
		wf_compare(ld_after_drc, "cal_calc_after_drc_oa", ls_text)
		wf_compare(ld_after_cap, "cal_calc_after_drc_oa_cap", ls_text)
		wf_compare(ld_tc_eqv, "cal_calc_tc_eqv", ls_text)

		// If LS_TEXT is empty, then everything is OK. If LS_TEXT is not empty
		// and the LB_VESSEL_DATA_CHANGED is true, then we can't validate the
		// data, and must there consider the calculation to be ok (since we only
		// want to trap the calculation that makes differences that we can validate)
		If (ls_text = "") or (lb_vessel_data_changed) Then 
	
			If ls_text = "" Then 
				ls_text = "Compare ok"		
			Else
				ls_text = " Compare ok (vessel data has changed)"
			End if

			If lb_old_consumption_data Then ls_text += " (old consumption)"

			li_ok ++
			lb_ok = true
		Else
			li_failed ++
		End if

		// Save the calculation if CBX_SAVE is checked
		If cbx_save.checked then  uo_calculation.uf_save(true)
	Else
		ls_text = "Unable to recalculate "+String(il_id_list[ll_count])
		li_errors ++
	End if

	// Update the LS_TEXT with the different messages, there might be
	// from the calculation object.
	if uo_calculation.is_message <> "" Then
		ls_text = "Information: "+uo_calculation.is_message + "~r~n"+ls_text
		uo_calculation.is_message = ""
	End if

	if lstr_parm.result.s_warningtext <> "" Then
		ls_text = "Warning: "+lstr_parm.result.s_warningtext+"~r~n"+ls_text
		li_warnings++
	End if		

	If lstr_parm.result.s_errortext <> "" Then
		ls_text = "Error: "+lstr_parm.result.s_errortext+"~r~n"+ls_text
	End if

	Yield()
	Yield()
	Yield()
	Yield()

	// Turn redraw off
	dw_status_log.uf_redraw_off()

	// And insert a row in the DW_STATUS_LOG datawindow with all information gathered
	// during the calculation 
	ll_row = dw_status_log.InsertRow(0)
	dw_status_log.ScrollToRow(ll_row)
	dw_status_log.SetItem(ll_row, "calc_id", il_id_list[ll_count])

	Choose Case li_status
		Case 0 
			ls_tmp = "Deleted"
		Case 1
			 ls_tmp = "Template"
		Case 2
			 ls_tmp = "Working"
		Case 3
			ls_tmp = "Offer"
		Case 4
			ls_tmp = "Fixture"
		Case 5
			ls_tmp = "Calculated"
		Case 6
			ls_tmp = "Estimated"
	End Choose

	dw_status_log.SetItem(ll_row, "creator", idw_summary.GetItemString(1, "cal_calc_created_by"))
	dw_status_log.SetItem(ll_row, "description", uo_calculation.uf_get_description(0) + "~r~n"+ls_tmp+"~r~n"+uo_calculation.uf_get_vessel_name())
	dw_status_log.SetItem(ll_row, "status", ls_text)

	if lb_ok then li_tmp = 1 else li_tmp = 0	
	dw_status_log.SetItem(ll_row, "ok", li_tmp)

	// If the autocompare is on, then check this row against the corrosponding row in the
	// DW_STATUS_LOG_CHECK datawindow, if the entries for these two rows are the same
	// then delete the rows in both datawindows. This will result in a DW_STATUS_LOG that
	// only contains differences from the last recalc.
	If rb_autocomp_read.checked Then
		ll_row = dw_status_log.Find("calc_id = "+ String(il_id_list[ll_count]), 1, 999999) 
		ll_row_check = dw_status_log_check.Find("calc_id = "+ String(il_id_list[ll_count]), 1, 999999) 

		If (ll_row <>0) And (ll_row_check<>0) Then
//			MessageBox("rows er fundet", "row: "+String(ll_row)+" check row: "+String(ll_row_check))
			
			If dw_status_log.GetItemString(ll_row, "creator") = dw_status_log_check.GetItemString(ll_row_check, "creator") And &
			dw_status_log.GetItemString(ll_row, "description") = dw_status_log_check.GetItemString(ll_row_check, "description") And &
			dw_status_log.GetItemString(ll_row, "status") = dw_status_log_check.GetItemString(ll_row_check, "status") Then
				dw_status_log.DeleteRow(ll_row)
				dw_status_log_check.DeleteRow(ll_row_check)
			Else
				dw_status_log.SetItem(ll_row, "status", &
					dw_status_log.GetItemString(ll_row, "status") + "~r~n~r~nOld status:~r~n"+ &
					dw_status_log_check.GetItemString(ll_row_check, "status"))
					
//				MessageBox("Status", '"'+dw_status_log.GetItemString(ll_row, "status")+'"~r~n~r~n'+ &
//							'"'+dw_status_log_check.GetItemString(ll_row_check, "status"))
	
			End if
		End if
	End if	

	// Turn redraw back on
	dw_status_log.uf_redraw_on()

	Yield()
	Yield()
	Yield()

	// Exit if the user clicked exit
	If ib_cancel Then Exit

	Yield()
	Yield()
	Yield()

	// Update the time calculation
	ll_tmp = Cpu() - ll_time
	st_elapsed_time.text = wf_time_to_str(ll_tmp)
	st_avg_time.text = wf_time_to_Str(ll_tmp / (ll_count ))

	Yield()
	Yield()
	Yield()
	Yield()

	// Calculate estimated time left for calculation
	st_timeleft.text = wf_time_to_str((ll_tmp / (ll_count)) * (il_id_count - ll_count ))	

	// And print pages for each 100 rows, if adhook printing is selected. Reset
	// the datawindow afterwards
	If cbx_adhook_print.checked and dw_status_log.Rowcount() > 100 Then
		dw_status_log.Print()
		dw_status_log.Reset()
	End if
Next

// We're done. Update the status text
st_status.text = "Total recalculated: "+String(ll_count - 1)+" OK: "+String(li_ok)+" failed: "+String(li_failed)+" warnings: "+String(li_warnings)+" errors: "+String(li_errors)

// Print final pages if adhook print selected 
If (not ib_cancel) And (cbx_adhook_print.checked) and (dw_status_log.Rowcount() > 0) Then
	dw_status_log.Print()
	dw_status_log.Reset()
End if

// Write the compare file to SLE_AUTOCOMP_FILENAME.TEXT, if autocompare write is selected
If rb_autocomp_write.checked Then
	If dw_status_log.Saveas(sle_autocomp_filename.text, Text!, False) <> 1 Then
		MessageBox("Error", "Error saving datawindow to~r~n~r~n'"+sle_autocomp_filename.text+"'")
	End if
End if

// Insert final line in the DW_STATUS_LOG containing the total status
ll_row = dw_status_log.InsertRow(0)
dw_status_log.ScrollToRow(ll_row)
dw_status_log.SetItem(ll_row, "description", "status:")
dw_status_log.SetItem(ll_row, "status", st_status.text)

// Add an "Recalculation was aborted" line if recalc was aborted
if ib_cancel Then
	ll_row = dw_status_log.InsertRow(0)
	dw_status_log.ScrollToRow(ll_row)
	dw_status_log.SetItem(ll_row, "status", "Recalculation was aborted")
End if

// Enable & disable appropriate buttons
cb_close.enabled = true
cb_cancel.enabled = false
cb_recalc.enabled = true
ib_processing = false
cb_print.enabled = dw_status_log.RowCount()>0

end event

type st_status from statictext within w_atobviac_calc_recalc
integer x = 46
integer y = 1280
integer width = 2231
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "Click Recalc to begin recalculation"
boolean focusrectangle = false
end type

type st_no_calc from statictext within w_atobviac_calc_recalc
integer x = 544
integer y = 1216
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "xx"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_no_calculations from statictext within w_atobviac_calc_recalc
integer x = 50
integer y = 1216
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "No. of calculations:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_elapsed_time from statictext within w_atobviac_calc_recalc
integer x = 366
integer y = 1712
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "00:00:000"
boolean focusrectangle = false
end type

type st_time from statictext within w_atobviac_calc_recalc
integer x = 55
integer y = 1712
integer width = 297
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "Elapsed time:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_avgtime from statictext within w_atobviac_calc_recalc
integer x = 713
integer y = 1712
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "Avg. calc. time:"
boolean focusrectangle = false
end type

type st_avg_time from statictext within w_atobviac_calc_recalc
integer x = 1079
integer y = 1712
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "00:00:000"
boolean focusrectangle = false
end type

type st_timeleft_ from statictext within w_atobviac_calc_recalc
integer x = 1390
integer y = 1712
integer width = 471
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "Estimated time left:"
boolean focusrectangle = false
end type

type st_timeleft from statictext within w_atobviac_calc_recalc
integer x = 1865
integer y = 1712
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "00:00:000"
boolean focusrectangle = false
end type

type cbx_no_reload from uo_cbx_base within w_atobviac_calc_recalc
integer x = 549
integer y = 1424
integer width = 439
integer height = 64
long backcolor = 67108864
string text = "No data reload"
end type

type rb_all from uo_rb_base within w_atobviac_calc_recalc
integer x = 1573
integer y = 1424
integer width = 183
long backcolor = 67108864
string text = "&All"
boolean checked = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the filter so that ALL recalculations is shown

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_status_log.SetFilter("")
dw_status_log.Filter()
end event

type rb_failed from uo_rb_base within w_atobviac_calc_recalc
integer x = 1792
integer y = 1424
long backcolor = 67108864
string text = "&Failed"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the filter so that ALL FAILED recalculations is shown

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_status_log.SetFilter("OK=0")
dw_status_log.Filter()
end event

type rb_ok from uo_rb_base within w_atobviac_calc_recalc
integer x = 2066
integer y = 1424
integer width = 183
long backcolor = 67108864
string text = "&Ok"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the filter so that ALL SUCCEDED recalculations is shown

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_status_log.SetFilter("OK=1")
dw_status_log.Filter()
end event

type cbx_save from uo_cbx_base within w_atobviac_calc_recalc
integer x = 55
integer y = 1424
integer width = 512
integer height = 64
long backcolor = 67108864
string text = "&Save calculations"
end type

type rb_autocomp_none from uo_rb_base within w_atobviac_calc_recalc
integer x = 55
integer y = 1576
integer width = 219
integer height = 64
long backcolor = 67108864
boolean checked = true
end type

type rb_autocomp_read from uo_rb_base within w_atobviac_calc_recalc
integer x = 640
integer y = 1576
integer width = 384
integer height = 64
long backcolor = 67108864
string text = "Compare file"
end type

type rb_autocomp_write from uo_rb_base within w_atobviac_calc_recalc
integer x = 329
integer y = 1576
integer width = 311
integer height = 64
long backcolor = 67108864
string text = " Write file"
end type

type sle_autocomp_filename from singlelineedit within w_atobviac_calc_recalc
integer x = 1317
integer y = 1568
integer width = 951
integer height = 80
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "C:\RECALC.TXT"
end type

type st_1 from statictext within w_atobviac_calc_recalc
integer x = 1061
integer y = 1584
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "Filename:"
boolean focusrectangle = false
end type

type cbx_adhook_print from uo_cbx_base within w_atobviac_calc_recalc
integer x = 1006
integer y = 1424
integer width = 421
integer height = 64
long backcolor = 67108864
string text = "Adhook print"
end type

type gb_status from groupbox within w_atobviac_calc_recalc
integer x = 18
integer y = 1168
integer width = 2286
integer height = 192
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Status"
end type

type cb_print from commandbutton within w_atobviac_calc_recalc
integer x = 2359
integer y = 1312
integer width = 247
integer height = 108
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Print"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Prints the DW_STATUS_LOG datawindow

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

dw_status_log.Print()
end event

type gb_time from uo_gb_base within w_atobviac_calc_recalc
integer x = 18
integer y = 1664
integer width = 2286
integer height = 128
integer taborder = 40
long backcolor = 67108864
string text = "Time:"
end type

type gb_show from uo_gb_base within w_atobviac_calc_recalc
integer x = 1518
integer y = 1360
integer width = 786
integer height = 160
integer taborder = 30
long backcolor = 67108864
string text = "Show"
end type

type cb_close from commandbutton within w_atobviac_calc_recalc
integer x = 2359
integer y = 1696
integer width = 247
integer height = 108
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the recalc window

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Close(Parent)
end event

type gb_options from uo_gb_base within w_atobviac_calc_recalc
integer x = 18
integer y = 1360
integer width = 1481
integer height = 160
integer taborder = 60
long backcolor = 67108864
string text = "Options:"
end type

type gb_autocompare from uo_gb_base within w_atobviac_calc_recalc
integer x = 18
integer y = 1520
integer width = 2286
integer height = 144
integer taborder = 20
long backcolor = 67108864
string text = "Auto compare"
end type

type dw_status_log_check from datawindow within w_atobviac_calc_recalc
boolean visible = false
integer x = 69
integer y = 784
integer width = 2775
integer height = 360
integer taborder = 110
string dataobject = "d_calc_recalc_log"
boolean livescroll = true
end type

type cb_1 from uo_cb_base within w_atobviac_calc_recalc
integer x = 2359
integer y = 1568
integer taborder = 10
boolean enabled = false
string text = "Check"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_recalc
  
 Object     : cb_1
  
 Event	 :  clicked

 Scope     : local / global

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 17-06-1997

 Description : Converts the Cargo data in the database from version 4.4 to version 5.00

 Arguments : Non

 Returns   :   Boolean 

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
17-6-97		1.0 			TA		Initial version
  
************************************************************************************/
// This is the code for converting data between v. 4.4 and 5.0 of TRAMOS
//Boolean lb_continue
//
//If MessageBox("Warning","This funktion will convert the data in the database to version 5.00. &
//Do you want to continue?", Information!, OkCancel!) = 1 Then
//
//	dw_status_log.DataObject = "d_conversion_log"
//
//	lb_continue = wf_convert_port_expenses()
//
//	MessageBox("Resultatet","af Cargo konverteringen kan nu læses i vinduet")
//
//	If lb_continue Then
//		 wf_convert_cargo_expenses()
//	End if
//End if
//
//cb_print.enabled = True


// Calling the check module
//Open(w_check)
end on

