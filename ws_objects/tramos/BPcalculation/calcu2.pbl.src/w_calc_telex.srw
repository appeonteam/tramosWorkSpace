$PBExportHeader$w_calc_telex.srw
$PBExportComments$For modifying text for telex, insert into clipboard
forward
global type w_calc_telex from mt_w_response_calc
end type
type cb_cancel from uo_cb_base within w_calc_telex
end type
type cb_copy from uo_cb_base within w_calc_telex
end type
type mle_telex from uo_mle_base within w_calc_telex
end type
end forward

global type w_calc_telex from mt_w_response_calc
integer height = 1484
string title = "Telex"
cb_cancel cb_cancel
cb_copy cb_copy
mle_telex mle_telex
end type
global w_calc_telex w_calc_telex

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_calc_telex
	
	<OBJECT>

	</OBJECT>
	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	07/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
*****************************************************************/
end subroutine

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_telex
  
 Object     : 
  
 Event	 :  open

 Scope     : local

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 20-9-96

 Description : Fetch the data from the cp table and insert them into the telex window

 Arguments : cpno

 Returns   :   null

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
2-9-96		1.0 			TA		Initial version
  
************************************************************************************/
/* Get cp number */

long ll_cpno
ll_cpno = Message.DoubleParm

/* Get data from CP table */

string ls_city, ls_term
datetime ldt_date, ldt_start_date, ldt_end_date
integer li_noticebar, li_timebar, li_chart_no, li_contract_type,li_rev_freight, li_rev_dem
decimal ld_add_comm

SELECT	CAL_CERP_DATE,
		CAL_CERP_CITY,
		CAL_CERP_NOTICEBAR_DAYS,
		CAL_CERP_TIMEBAR_DAYS,
		CAL_CERP_START_DATE,
		CAL_CERP_END_DATE,
		CAL_CERP_REV_FREIGHT,
		CAL_CERP_REV_DEM,
		CHART_NR,
		CAL_CERP_ADD_COMM,
		CAL_CERP_CONTRACT_TYPE,
		CAL_CERP_TERM
INTO 	:ldt_date,
		:ls_city,
		:li_noticebar,
		:li_timebar,
		:ldt_start_date,
		:ldt_end_date,
		:li_rev_freight,
		:li_rev_dem,
		:li_chart_no,
		:ld_add_comm,
		:li_contract_type,
		:ls_term
FROM 	CAL_CERP
WHERE	CAL_CERP.CAL_CERP_ID = :ll_cpno;
COMMIT;

/* Make string for telex */
string ls_telex

If Not IsNull(ldt_date) Then
	ls_telex = ls_telex + 'Date:  ' +string(ldt_date) +"~r~n"
End If

If Not IsNull(ls_city) Or (ls_city <> '') Then
	ls_telex = ls_telex + 'City:  '+ls_city+"~r~n"
End If

If Not IsNull(li_noticebar) Or (li_noticebar <> 0) Then
	ls_telex = ls_telex + 'Notice bar:   '+string(li_noticebar) +"~r~n"
End If

If Not IsNull(li_timebar) Or (li_timebar <> 0) Then
	ls_telex = ls_telex + 'Timebar:  ' + string(li_timebar)+"~r~n"
End If

If Not IsNull(ldt_start_date) Then
	ls_telex = ls_telex + 'Start date:   ' +string(ldt_start_date) +"~r~n"
End If

If Not IsNull(ldt_end_date) Then
	ls_telex = ls_telex + 'End date:   ' +string(ldt_end_date) +"~r~n"
End If

If li_rev_freight = 1 Then
	ls_telex = ls_telex + 'Reversible freight !' +"~r~n"
End If

If li_rev_dem = 1 Then
	ls_telex = ls_telex + 'Reversible demmurage ! '+ "~r~n"
End If

If Not IsNull(li_chart_no) Or (li_chart_no <> 0) Then
	string ls_chart_name
	SELECT CHART_SN
	INTO :ls_chart_name
	FROM CHART
	WHERE CHART_NR = :li_chart_no;
	COMMIT;
	ls_telex = ls_telex + 'Charterer:  ' +ls_chart_name +"~r~n"
End If

If Not IsNull(ld_add_comm) Or (ld_add_comm <> 0) Then
	ls_telex = ls_telex + 'Address commission:   ' +String(ld_add_comm)+"~r~n"
End If

If Not IsNull(li_contract_type) Or (li_contract_type <> 0) Then
	string ls_voyage_type
	CHOOSE CASE li_contract_type
		CASE 1
			ls_voyage_type = "SPOT"
		CASE  2
			ls_voyage_type = "COA Fixed rate"
		CASE 3
			ls_voyage_type = "CVS Fixed rate"
		CASE 4
			ls_voyage_type = "All"
		CASE 5
			ls_voyage_type = "T/C - out"
		CASE 6
			ls_voyage_type = "B/B - out"
		CASE 7
			ls_voyage_type = "COA Market rate"
		CASE 8
			ls_voyage_type = "CVS Market rate"
	END CHOOSE

	ls_telex = ls_telex + 'Contract type:   ' + ls_voyage_type +"~r~n~r~n"
End If

/* Find and insert Broker and Commission */
long ll_broker_nr
double ld_comm
DECLARE broker_cur CURSOR FOR
SELECT CAL_COMM.BROKER_NR, CAL_COMM.CAL_COMM_PERCENT
FROM CAL_COMM
WHERE CAL_COMM.CAL_CERP_ID = :ll_cpno;
	OPEN broker_cur;
	DO UNTIL SQLCA.SQLCode <> 0
	FETCH broker_cur
	INTO :ll_broker_nr, :ld_comm;
		IF SQLCA.SQLCode = 0 Then
			/* Get broker name */
			string ls_broker_name
			SELECT BROKER_NAME
			INTO :ls_broker_name
			FROM BROKERS
			WHERE BROKERS.BROKER_NR = :ll_broker_nr;
			ls_telex = ls_telex + 'Broker:   ' +string(ls_broker_name)+'   '+ 'Commission:   '+ string(ld_comm) +"~r~n"
		End if
LOOP
	
CLOSE broker_cur;	
COMMIT;

/* Insert extra line */
ls_telex = ls_telex + '~r~n'
	
If Not IsNull(ls_term)  Or (ls_term <> '') Then
	ls_telex = ls_telex + 'Terms:' + '~r~n' + ls_term+ "~r~n"
End If 

/* Insert telex string into multi line edit field */

mle_telex.text = ls_telex

end event

on w_calc_telex.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_copy=create cb_copy
this.mle_telex=create mle_telex
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_copy
this.Control[iCurrent+3]=this.mle_telex
end on

on w_calc_telex.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_copy)
destroy(this.mle_telex)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_telex
end type

type cb_cancel from uo_cb_base within w_calc_telex
integer x = 1682
integer y = 1248
integer width = 238
integer height = 96
integer taborder = 20
string text = "&Cancel"
end type

on clicked;call uo_cb_base::clicked;Close(parent)
end on

type cb_copy from uo_cb_base within w_calc_telex
integer x = 1408
integer y = 1248
integer width = 238
integer height = 96
integer taborder = 30
string text = "Cop&y"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_telex
  
 Object     : 
  
 Event	 :  copy

 Scope     : copy contents to clip board

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 23-9-96

 Description : 

 Arguments : 

 Returns   :   

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
23-9-96		1.0 			TA		Initial version
  
************************************************************************************/
mle_telex.SelectText(1, Len(mle_telex.text))
mle_telex.Copy()
close(parent)
end on

type mle_telex from uo_mle_base within w_calc_telex
integer x = 37
integer y = 32
integer width = 1883
integer height = 1168
integer taborder = 10
end type

