$PBExportHeader$w_select_voyage_charterer.srw
$PBExportComments$Used when creating new Claims
forward
global type w_select_voyage_charterer from mt_w_response
end type
type dw_select_cp from datawindow within w_select_voyage_charterer
end type
type cb_cancel from commandbutton within w_select_voyage_charterer
end type
type cb_ok from commandbutton within w_select_voyage_charterer
end type
type dw_list_voyage_charterer from uo_datawindow within w_select_voyage_charterer
end type
end forward

shared variables

end variables

global type w_select_voyage_charterer from mt_w_response
integer x = 681
integer y = 480
integer width = 1701
integer height = 960
string title = "Select Voyage And Charterer"
long backcolor = 81324524
boolean ib_setdefaultbackgroundcolor = true
event ue_retrieve pbm_custom01
dw_select_cp dw_select_cp
cb_cancel cb_cancel
cb_ok cb_ok
dw_list_voyage_charterer dw_list_voyage_charterer
end type
global w_select_voyage_charterer w_select_voyage_charterer

type variables
s_select_voyage_charterer istr_parametre
long ia_cparray[50] 
integer ii_vessel_nr
String is_claim_type
end variables

forward prototypes
public subroutine wf_get_cp_array (integer vessel, string voyage, integer charter)
public subroutine documentation ()
end prototypes

event ue_retrieve;long ll_row
string ls_filter

setredraw(false)

ll_row = dw_list_voyage_charterer.retrieve(ii_vessel_nr)

If is_claim_type <> "MISC" Then
	ls_filter = "voyages_voyage_type <> 2"
	dw_list_voyage_charterer.setfilter(ls_filter)
	dw_list_voyage_charterer.filter()
	ll_Row = dw_list_voyage_charterer.rowcount()
End if

If ll_row > 0 Then
	dw_list_voyage_charterer.scrolltorow(ll_Row)
	dw_list_voyage_charterer.selectrow(0, false)
	dw_list_voyage_charterer.selectrow(ll_Row, true)
End if

setredraw(true)
end event

public subroutine wf_get_cp_array (integer vessel, string voyage, integer charter);Long ll_cp_nr, ll_old_cp, ll_counter

FOR ll_counter = 1 TO 50
	ia_cparray[ll_counter] = 0
NEXT
 ll_counter = 1

 DECLARE cp_cur CURSOR FOR  
  SELECT CARGO.CAL_CERP_ID  
  FROM CARGO  
  WHERE  (CARGO.VESSEL_NR = :vessel ) AND
	        ( CARGO.VOYAGE_NR = :voyage ) AND  
        	( CARGO.CHART_NR = :charter)
ORDER BY CARGO.CAL_CERP_ID ASC;

OPEN cp_cur;

FETCH cp_cur INTO :ll_cp_nr;

DO WHILE SQLCA.SQLCODE = 0
	
	IF ll_old_cp <> ll_cp_nr THEN
		ia_cparray[ll_counter] = ll_cp_nr
		ll_counter++	
	END IF
	ll_old_cp = ll_cp_nr
	
FETCH cp_cur INTO :ll_cp_nr;

LOOP
CLOSE cp_cur;
COMMIT USING SQLCA;
end subroutine

public subroutine documentation ();/********************************************************************
	w_select_voyage_charterer
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
		14/03/11  	CR1549      JSU    		Multi currencies
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

event open;s_select_parm	lstr_parm
n_service_manager 	lnv_sm
n_dw_style_service  	lnv_dwstyle

lstr_parm = message.powerObjectParm

ii_vessel_nr = lstr_parm.vessel_nr
is_claim_type = lstr_parm.claim_type

dw_list_voyage_charterer.SetTransObject(SQLCA)
PostEvent("ue_retrieve")

lnv_sm.of_loadservice( lnv_dwstyle, "n_dw_style_service")
lnv_dwstyle.of_dwlistformater(dw_list_voyage_charterer, false)
end event

on w_select_voyage_charterer.create
int iCurrent
call super::create
this.dw_select_cp=create dw_select_cp
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_list_voyage_charterer=create dw_list_voyage_charterer
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_select_cp
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.dw_list_voyage_charterer
end on

on w_select_voyage_charterer.destroy
call super::destroy
destroy(this.dw_select_cp)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_list_voyage_charterer)
end on

event close;call super::close;if istr_parametre.voyage_nr='' then
	istr_parametre.voyage_nr="cancel"
end if
CloseWithReturn(this,istr_parametre)
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_select_voyage_charterer
end type

type dw_select_cp from datawindow within w_select_voyage_charterer
boolean visible = false
integer x = 18
integer y = 100
integer width = 2304
integer height = 624
integer taborder = 20
string dataobject = "d_select_cp"
boolean livescroll = true
end type

event clicked;long ll_rowno
ll_rowno = GetClickedRow()
IF ll_rowno > 0 THEN
	SelectRow(0,FALSE)
	SetRow(ll_rowno)
	SelectRow(ll_rowno,TRUE)
END IF
end event

type cb_cancel from commandbutton within w_select_voyage_charterer
integer x = 1312
integer y = 748
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;istr_parametre.voyage_nr = "cancel"
CloseWithReturn(parent,istr_parametre)
Return
end event

type cb_ok from commandbutton within w_select_voyage_charterer
integer x = 965
integer y = 748
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  :  w_select_voyage_charter
  
 Object     : 
  
 Event	 : clicked for cb_ok

 Scope     : 

 ************************************************************************************

 Author    : Leith Noval
   
 Date       :  18/7-96

 Description : Select voyage and charter for claim. If the claim is a dem/(des) then find out if there is
		      any cp_nr in CARGO, which if true indicates that there is a Calculation. IF there is more than one
		     cp_nr in CARGO show a datawindow for selection of which one. Save all cp_nr in an instance array,
		     and after a selection save the one only. But if there is a dem/des claim dont allow another. That cp_nr
		     will then be used for calling NVO's in Calc. system to  get data for claim base and for dem/des claim 
		     datawindows.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
18/7-96                                    	LN  
12/12-96		3.0			RM		added COMMIT's
03/10-08     16.04			RM		changed used vesselnumber to ii_vessel_nr
************************************************************************************/
Integer li_claim_nr
long ll_rowno, ll_charter_nr,  ll_cerp_id, ll_dem_des_cp,ll_voyage_type
String ls_voyage_nr


IF dw_list_voyage_charterer.Visible THEN
	ll_rowno = dw_list_voyage_charterer.GetRow()
	IF ll_rowno > 0 THEN
		ls_voyage_nr = dw_list_voyage_charterer.GetItemString(ll_rowno,"cargo_voyage_nr")
		ll_charter_nr = dw_list_voyage_charterer.GetItemNumber(ll_rowno,"cargo_chart_nr")
		ll_voyage_type = dw_list_voyage_charterer.GetItemNumber(ll_rowno,"voyages_voyage_type")
	END IF
	istr_parametre.voyage_nr = ls_voyage_nr
	istr_parametre.charter_nr = ll_charter_nr
	istr_parametre.cp_multiple = 1
	istr_parametre.voyage_type = ll_voyage_type
	IF (is_claim_type = "DEM" OR is_claim_type = "FRT") AND (ll_rowno > 0) THEN
		istr_parametre.voyage_nr = ls_voyage_nr
		istr_parametre.charter_nr = ll_charter_nr
		istr_parametre.calc_yes_no = FALSE
		istr_parametre.cp_id = 0
		wf_get_cp_array(ii_vessel_nr,ls_voyage_nr,ll_charter_nr)
		IF  ia_cparray[2] > 0 THEN istr_parametre.cp_multiple = 2
		IF  ia_cparray[2] > 0 AND is_claim_type = "DEM" THEN
			dw_list_voyage_charterer.Hide()
			w_select_voyage_charterer.Width = 2355
			dw_select_cp.Show()
			dw_select_cp.SetTransObject(SQLCA)
			dw_select_cp.Retrieve(ia_cparray)
			COMMIT USING SQLCA;
		ELSEIF ia_cparray[1] > 0 OR is_claim_type = "FRT" THEN
			IF ll_rowno > 0 THEN
				ll_cerp_id =  ia_cparray[1]
				IF ll_cerp_id = 1 THEN
				   IF is_claim_type = "DEM" THEN
					  SELECT CLAIM_NR 
					  INTO :li_claim_nr
					  FROM CLAIMS
					  WHERE VESSEL_NR = :ii_vessel_nr
					  AND VOYAGE_NR = :ls_voyage_nr
					  AND CHART_NR = :ll_charter_nr
					  AND CLAIM_TYPE = "DEM"
					  USING SQLCA;
					  IF SQLCA.SQLCode <> 100 THEN
						MessageBox("Error","You can't create more than one Dem Claim for the same Charterer.~r~n~r~nSelect another Charterer!")
						istr_parametre.voyage_nr = "cancel"
					  END IF
					  COMMIT USING SQLCA;
				   END IF
				       istr_parametre.cp_id = ll_cerp_id
				       CloseWithReturn(parent,istr_parametre)
						 Return
				END IF
				/* Check if there is a dem with this combination. Not allowed. */			
				IF is_claim_type = "DEM" THEN
					SELECT CAL_CERP_ID
					INTO :ll_dem_des_cp
					FROM DEM_DES_CLAIMS
		        		WHERE VOYAGE_NR = :ls_voyage_nr AND CHART_NR = :ll_charter_nr AND 
			      		VESSEL_NR = :ii_vessel_nr AND CAL_CERP_ID = :ll_cerp_id
					USING SQLCA;
					IF SQLCA.SQLCode = 100 THEN
						istr_parametre.cp_id = ll_cerp_id
					        istr_parametre.calc_yes_no = TRUE
					ELSEIF SQLCA.SQLCode = -1 THEN
						MessageBox("Error", "Error in searching for Dem/Des Cp nr.")	
						istr_parametre.voyage_nr = "cancel"
					ELSE
						MessageBox("Duplicate Error", "You can't create more than one Dem/des Claim for the same Charterer,~r~nVessel,Voyage and CP. Select another CP !")
						istr_parametre.voyage_nr = "cancel"
					END IF
				COMMIT USING SQLCA;	
				ELSEIF is_claim_type = "FRT" THEN
				/* Check if there is a FRT on this combination. Not allowed. */
					SELECT CAL_CERP_ID
					INTO :ll_dem_des_cp
					FROM FREIGHT_CLAIMS
		         		WHERE VOYAGE_NR = :ls_voyage_nr AND CHART_NR = :ll_charter_nr AND 
			     	  	VESSEL_NR = :ii_vessel_nr AND CAL_CERP_ID = :ll_cerp_id
					USING SQLCA;
					IF SQLCA.SQLCode = 100 THEN
						istr_parametre.cp_id = ll_cerp_id
						istr_parametre.calc_yes_no = TRUE
					ELSEIF SQLCA.SQLCode = -1 THEN
						MessageBox("Error", "Error in searching for FRT  Cp nr.")	
						istr_parametre.voyage_nr = "cancel"
						CloseWithReturn(parent,istr_parametre)
						Return
					ELSE
						MessageBox("Duplicate Error", "You can't create more than one FRT Claim for the same Charterer,~r~nVessel,Voyage and CP. Select another CP !")
						istr_parametre.voyage_nr = "cancel"
						CloseWithReturn(parent,istr_parametre)
						Return
					END IF	
					COMMIT USING SQLCA;
					/* Check if there is a AFC on this combination. Not allowed. */
					SELECT CAL_CERP_ID
					INTO :ll_dem_des_cp
					FROM FREIGHT_ADVANCED
		         		WHERE VOYAGE_NR = :ls_voyage_nr AND CHART_NR = :ll_charter_nr AND 
			     	  	VESSEL_NR = :ii_vessel_nr AND CAL_CERP_ID = :ll_cerp_id
					USING SQLCA;
					IF SQLCA.SQLCode = 100 THEN
						istr_parametre.cp_id = ll_cerp_id
						istr_parametre.calc_yes_no = TRUE
					ELSEIF SQLCA.SQLCode = -1 THEN
						MessageBox("Error", "Error in searching for AFC  Cp nr.")	
						istr_parametre.voyage_nr = "cancel"
					ELSE
						MessageBox("Duplicate Error", "You can't create more than one AFC Claim for the same Charterer,~r~nVessel,Voyage and CP. Select another CP !")
						istr_parametre.voyage_nr = "cancel"
						istr_parametre.calc_yes_no = FALSE
					END IF		
				COMMIT USING SQLCA;
				END IF
				CloseWithReturn(parent,istr_parametre)
				Return
			END IF
		ELSE
			SELECT CLAIM_NR 
			INTO :li_claim_nr
			FROM CLAIMS
			WHERE VESSEL_NR = :ii_vessel_nr
			AND VOYAGE_NR = :ls_voyage_nr
			AND CHART_NR = :ll_charter_nr
			AND CLAIM_TYPE = "DEM"
			USING SQLCA;
			IF SQLCA.SQLCode <> 100 THEN
				MessageBox("Error","You can't create more than one Dem Claim for the same Charterer.~r~n~r~nSelect another Charterer!")
				istr_parametre.voyage_nr = "cancel"
			END IF
			COMMIT USING SQLCA;
			istr_parametre.calc_yes_no = FALSE
		END IF	
	END IF
	
	IF ll_rowno > 0  AND Not dw_select_cp.Visible THEN
		wf_get_cp_array(ii_vessel_nr,ls_voyage_nr,ll_charter_nr)
		istr_parametre.cp_id = ia_cparray[1]
		CloseWithReturn(parent,istr_parametre)
		Return
	END IF
ELSEIF dw_select_cp.Visible THEN
	ll_rowno = dw_select_cp.GetRow()
	IF ll_rowno > 0 THEN
		ll_cerp_id =  dw_select_cp.GetItemNumber(ll_rowno,"cal_cerp_cal_cerp_id")
		IF is_claim_type = "DEM" THEN
		SELECT CAL_CERP_ID
		INTO :ll_dem_des_cp
		FROM DEM_DES_CLAIMS
		WHERE VOYAGE_NR = :ls_voyage_nr AND CHART_NR = :ll_charter_nr AND 
			     VESSEL_NR = :ii_vessel_nr AND CAL_CERP_ID = :ll_cerp_id
		USING SQLCA;
		IF SQLCA.SQLCode = 100 THEN
			istr_parametre.cp_id = ll_cerp_id
			IF ll_cerp_id > 1 THEN istr_parametre.calc_yes_no = TRUE
		ELSEIF SQLCA.SQLCode = -1 THEN
			MessageBox("Error", "Error in searching for Dem/Des Cp nr.")	
			istr_parametre.voyage_nr = "cancel"
		ELSE
			MessageBox("Duplicate Error", "You can't create more than one Dem/des Claim for the same Charterer,~r~nVessel,Voyage and CP. Select another CP !")
			istr_parametre.voyage_nr = "cancel"
		END IF		
		COMMIT USING SQLCA;
		END IF
		CloseWithReturn(parent,istr_parametre)
		Return
	END IF
END IF


	
end event

type dw_list_voyage_charterer from uo_datawindow within w_select_voyage_charterer
integer x = 37
integer y = 32
integer width = 1618
integer height = 700
integer taborder = 10
string dataobject = "dw_list_voyage_charterer"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

on clicked;call uo_datawindow::clicked;long ll_rowno
ll_rowno = GetClickedRow()
IF ll_rowno > 0 THEN
	SelectRow(0,FALSE)
	SetRow(ll_rowno)
	SelectRow(ll_rowno,TRUE)
END IF

end on

on doubleclicked;call uo_datawindow::doubleclicked;//long ll_rowno
//ll_rowno = GetClickedRow()
//IF ll_rowno > 0 THEN
//	SelectRow(0,FALSE)
//	SetRow(ll_rowno)
//	SelectRow(ll_rowno,TRUE)
	cb_ok.TriggerEvent(Clicked!)
//END IF

end on

