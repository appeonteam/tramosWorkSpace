$PBExportHeader$w_list_detail.srw
$PBExportComments$Default list edit detail window
forward
global type w_list_detail from mt_w_main
end type
type cb_cancel from commandbutton within w_list_detail
end type
type cb_update from commandbutton within w_list_detail
end type
type dw_1 from uo_datawindow within w_list_detail
end type
end forward

global type w_list_detail from mt_w_main
integer x = 672
integer y = 264
integer width = 1161
integer height = 616
boolean maxbox = false
boolean resizable = false
long backcolor = 81324524
event ue_update pbm_custom01
event ue_retrieve pbm_custom16
event ue_initialize pbm_custom17
cb_cancel cb_cancel
cb_update cb_update
dw_1 dw_1
end type
global w_list_detail w_list_detail

type variables
 s_list istr_parametre
Public integer ret_val
end variables

forward prototypes
public function integer uf_copyconfigdatapcgroup (long al_oldpcgroup, long al_newpcgroup)
public subroutine documentation ()
end prototypes

event ue_update;boolean lb_validate, lb_copydata
long ll_row, ll_drc, ll_tc, ll_cap, ll_clrktype, ll_pc_nr, ll_broker, ll_clrkcompetitor
string ls_errorstring, ls_clrkname, ls_clrkflag,ls_clrkno, ls_vestypname, ls_ref_nr
string ls_pc_name, ls_acc_nr, ls_misc_gl_acc, ls_frt_gl_acc, ls_dem_gl_acc, ls_misc_nom_acc, ls_frt_nom_acc 
string ls_dem_nom_acc, ls_dept_code, ls_init
Integer li_pct, li_updatepcgroup
long ll_oldpcgroup, ll_pcgroup, ll_countitems
double ld_sdwt

dw_1.Accepttext()
ll_row = dw_1.GetRow()
lb_validate = False

CHOOSE CASE  istr_parametre.edit_datawindow
	CASE "dw_vessel"
	
	ll_drc = dw_1.GetItemNumber(ll_row,"cal_drc")
	ll_tc = dw_1.GetItemNumber(ll_row,"cal_tc")
	ll_cap = dw_1.GetItemNumber(ll_row,"cal_cap")
	ls_ref_nr = dw_1.getitemstring(ll_row, "vessel_ref_nr")
		
	if (len(ls_ref_nr) <> 3) or isnull(ls_ref_nr) then
		MessageBox("Error","Ref. nr. must exactly be 3 characters")
		Return -1
	end if
		

	If ((ll_drc <> 0 ) Or (ll_cap <> 0)) And (ll_tc <> 0 ) Then
		MessageBox("Error","It's only possible to have either a DRC and/or CAP, or a T/C rate (day)")
		Return -1
	End If

	ld_sdwt = dw_1.GetItemNumber(ll_row,"cal_sdwt")
	If ld_sdwt > 999999.99 Then
		MessageBox("Notice","SDWT must be below one million")
		Return -1
	End If

	ll_broker = dw_1.GetItemNumber(ll_row,"broker_nr")
	li_pct = dw_1.GetItemNumber(ll_row,"pool_comm_one_pct")
	If Not IsNull(ll_broker) Or ll_broker > 0 Then
		If IsNull(li_pct) Or li_pct < 0 Or li_pct > 100 Then
			MessageBox("Error","Pool Broker One pct. must have a value between 0 and 100!",StopSign!,OK!)
			Return -1
		End if
	End if
	If IsNull(ll_broker) Or ll_broker = 0 Then
		If Not IsNull(li_pct) Then
			MessageBox("Error","A Broker must be selected for Pool Broker One!",StopSign!,OK!)
			Return -1
		End if
	End if
	
	
	ll_broker = dw_1.GetItemNumber(ll_row,"bro_broker_nr")
	li_pct = dw_1.GetItemNumber(ll_row,"pool_comm_two_pct")
	If Not IsNull(ll_broker) Or ll_broker > 0 Then
		If IsNull(li_pct) Or li_pct < 0 Or li_pct > 100 Then
			MessageBox("Error","Pool Broker Two pct. must have a value between 0 and 100!",StopSign!,OK!)
			Return -1
		End if
	End if
	If IsNull(ll_broker) Or ll_broker = 0 Then
		If Not IsNull(li_pct) Then
			MessageBox("Error","A Broker must be selected for Pool Broker Two!",StopSign!,OK!)
			Return -1
		End if
	End if
	
	ll_broker = dw_1.GetItemNumber(ll_row,"bro_broker_number_2")
	li_pct = dw_1.GetItemNumber(ll_row,"pool_comm_three_pct")
	If Not IsNull(ll_broker) Or ll_broker > 0 Then
		If IsNull(li_pct) Or li_pct < 0 Or li_pct > 100 Then
			MessageBox("Error","Pool Broker Three pct. must have a value between 0 and 100!",StopSign!,OK!)
			Return -1
		End if
	End if
	If IsNull(ll_broker) Or ll_broker = 0 Then
		If Not IsNull(li_pct) Then
			MessageBox("Error","A Broker must be selected for Pool Broker Three!",StopSign!,OK!)
			Return -1
		End if
	End if
	
//	AGL027 - 	Test for auto update of field for competitor id
//					20090417 Competitors vessels name is always filled out  
 CASE "d_calc_clarkson_tank", "d_calc_clarkson_gas"

	If dw_1.GetItemNumber(ll_row,"cal_vest_type_id") = 5167 &
	and isnull(dw_1.getitemnumber( ll_row,"cal_clrk_competitor_vessel_id")) Then // hard coded :-( this is type id for competitors vessels
		
		SELECT isnull(Max(CAL_CLRK_COMPETITOR_VESSEL_ID),0) +1 
		INTO :ll_clrkcompetitor 
		FROM CAL_CLAR;
		dw_1.SetItem(ll_row, "cal_clrk_competitor_vessel_id", ll_clrkcompetitor)
		
	end if
	
 CASE  "d_calc_clarkson_detail"
	ls_clrkname = dw_1.GetItemString(ll_row,"cal_clrk_name")
	If IsNull(ls_clrkname) Or (ls_clrkname = "") Then
		ls_errorstring = "Name"
		lb_validate = True
	End If
	
	ls_clrkflag = dw_1.GetItemString(ll_row,"cal_clrk_flag") 
	If IsNull(ls_clrkflag) Or (ls_clrkflag = "") Then
		ls_errorstring = "flag"
		lb_validate = True
	End If

	ll_clrktype = dw_1.GetItemNumber(ll_row,"cal_clrk_type")
	If IsNull(ll_clrktype) Then
		ls_errorstring = "Type"
		lb_validate = True
	End If

	ll_drc = dw_1.GetItemNumber(ll_row,"cal_drc")
	ll_tc = dw_1.GetItemNumber(ll_row,"cal_tc")
	ll_cap = dw_1.GetItemNumber(ll_row,"cal_cap")

	If ((ll_drc <> 0 ) Or (ll_cap <> 0)) And (ll_tc <> 0 ) Then
		MessageBox("Error","It's only possible to have either a DRC and/or a CAP, or a T/C rate (day)")
		Return -1
	End If
	
	ls_clrkno = dw_1.GetItemString(ll_row,"cal_clrk_vsl2")
	If IsNull(ls_clrkno) Or (ls_clrkno = "") Then
		ls_errorstring = "Clarkson No."
		lb_validate = True
	End If

	ld_sdwt = dw_1.GetItemNumber(ll_row,"cal_sdwt")
	If ld_sdwt > 999999.99 Then
		MessageBox("Notice","SDWT must be below one million")
		Return -1
	End If



CASE  "d_calc_vessel_type_detail"
	ls_vestypname = dw_1.GetItemString(ll_row,"cal_vest_type_name")
	If IsNull(ls_vestypname) Or (ls_vestypname = "") Then
		ls_errorstring = "Vessel type name"
		lb_validate = True
	End If

	ll_row = dw_1.GetRow()
	
	ll_drc = dw_1.GetItemNumber(ll_row,"cal_drc")
	ll_tc = dw_1.GetItemNumber(ll_row,"cal_tc")
	ll_cap = dw_1.GetItemNumber(ll_row,"cal_cap")

	If ((ll_drc <> 0 ) Or (ll_cap <> 0)) And (ll_tc <> 0 ) Then
		MessageBox("Error","It's only possible to have either a DRC and/or a CAP, or a T/C rate (day)")
		Return -1
	End If

	ld_sdwt = dw_1.GetItemNumber(ll_row,"cal_sdwt")
	If ld_sdwt > 999999.99 Then
		MessageBox("Notice","SDWT must be below one million")
		Return -1
	End If
CASE 	"dw_profit_center"
	ll_row = dw_1.GetRow()
	ll_pc_nr = dw_1.GetItemNumber(ll_row,"pc_nr")
	ls_pc_name = dw_1.GetItemString(ll_row,"pc_name")
	ls_acc_nr = dw_1.GetItemString(ll_row,"pc_bank_acc")
	ls_misc_gl_acc = dw_1.GetItemString(ll_row,"pc_misc_claim_gl_acc")
	ls_frt_gl_acc = dw_1.GetItemString(ll_row,"pc_frt_claim_gl_acc")
	ls_dem_gl_acc = dw_1.GetItemString(ll_row,"pc_dem_claim_gl_acc")
	ls_misc_nom_acc = dw_1.GetItemString(ll_row,"pc_misc_claim_nom_acc")
	ls_frt_nom_acc = dw_1.GetItemString(ll_row,"pc_frt_claim_nom_acc")
	ls_dem_nom_acc = dw_1.GetItemString(ll_row,"pc_dem_claim_nom_acc")
	ls_dept_code = dw_1.GetItemString(ll_row,"pc_dept_code")
	IF NOT ( ll_pc_nr > 0 ) OR IsNull(ls_pc_name) OR IsNull(ls_acc_nr) &
									OR IsNull(ls_misc_gl_acc) &
									OR IsNull(ls_frt_gl_acc) OR IsNull(ls_dem_gl_acc) &
									OR IsNull(ls_misc_nom_acc) OR IsNull(ls_frt_nom_acc) &
									OR IsNull(ls_dem_nom_acc) OR IsNull(ls_dept_code) &
									OR len(ls_pc_name) < 1 OR len(ls_acc_nr) < 1 &
									OR len(ls_misc_gl_acc) < 1 &
									OR len(ls_frt_gl_acc) < 1 OR len(ls_dem_gl_acc) < 1 &
									OR len(ls_misc_nom_acc) < 1 OR len(ls_frt_nom_acc) < 1 &
									OR len(ls_dem_nom_acc) < 1 OR len(ls_dept_code) < 1 THEN
		MessageBox("Notice","Please fill in the blue fields !")
		Return -1
	END IF
	
	//Profit Center Group 
	SELECT PCGROUP_ID
    INTO :ll_oldpcgroup
	FROM PROFIT_C WHERE PC_NR=:ll_pc_nr ;
    
	ll_pcgroup = dw_1.GetItemNumber(ll_row,"pcgroup_id")

	if ll_oldpcgroup<> ll_pcgroup then
	  //pcgroup changed
		//check if the selected pcgroup is empty
		lb_copydata=false
		
		SELECT count(*)
         INTO :ll_countitems
	     FROM PF_COMPANY WHERE PCGROUP_ID=:ll_pcgroup;
		
		if ll_countitems=0 then
		
			 SELECT count(*) 
				INTO :ll_countitems
			  FROM PF_FIXTURE_CARGO WHERE PCGROUP_ID=:ll_pcgroup;
			  
			  if ll_countitems=0 then
		
				 SELECT count(*)
					INTO :ll_countitems
				  FROM PF_FIXTURE_STATUS_CONFIG WHERE PCGROUP_ID=:ll_pcgroup;	
				  
				  if ll_countitems=0 then
					SELECT count(*)
					INTO :ll_countitems
					FROM PF_FIXTURE_CLEANINGTYPE WHERE PCGROUP_ID=:ll_pcgroup;	
				 
				 	if ll_countitems=0 then

						SELECT count(*)
						INTO :ll_countitems
						FROM PF_FIXTURE_TRADE WHERE PCGROUP_ID=:ll_pcgroup;	
					    if ll_countitems=0 then
							li_updatepcgroup=MessageBox("Profit center group","The selected Profit Center Group is empty, do you want to copy the configuration data?",Question!, YesNoCancel! )
							if li_updatepcgroup = 1 then
								lb_copydata=true
							elseif li_updatepcgroup = 3 then
								return -1
							end if
						end if
					end if
				end if
			end if
 	     end if
		if lb_copydata = true then
			if uf_copyConfigDataPCGroup(ll_oldpcgroup, ll_pcgroup) = -1 then
			  return -1
			end if
		end if
		//if MessageBox("Warning!","Give access rights to the users that already belong to the group?",Question!, YesNoCancel!)=1 then
		//joana: stand-by	
			
		//end if
		
	end if
		
	

END CHOOSE

If lb_validate  Then
	MessageBox("Error",'There has to be a ' +ls_errorstring)
	Return	 -1
End If


IF dw_1.Update() = 1 THEN
	COMMIT;
	Open(w_updated)
	if dw_1.dataObject = "dw_profit_center" then
		/* if administrator or finance profile, update access to all profitccenters 
			by running refresh cached tables*/
		if uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 3 then
			w_share.TriggerEvent("ue_retrieve")
		end if
	end if
	Close(this)
	Return 1
ELSE
	ROLLBACK;
	Return 0
END IF


end event

event ue_retrieve;datawindowchild 	ldwc
integer 				li_primary_profitcenter
long		 			ll_rows

CHOOSE CASE dw_1.DataObject
	CASE "d_calc_clarkson_tank"
		SELECT PC_NR 
			INTO :li_primary_profitcenter
			FROM USERS_PROFITCENTER
			WHERE USERID = :uo_global.is_userid
			and PRIMARY_PROFITCENTER = 1;
		COMMIT;
		
		dw_1.getchild("vessel_owner", ldwc)
		ldwc.setTransObject( sqlca)
		ll_rows = ldwc.retrieve( 12, li_primary_profitcenter)   // 12 = Owner
		if ll_rows < 1 then
			ldwc.insertRow(0)
			ldwc.setItem(1, "company", "No available Owner")
			ldwc.setItem(1, "companyid", 0)
		end if
		dw_1.getchild("vessel_operator", ldwc)
		ldwc.setTransObject( sqlca)
		ll_rows = ldwc.retrieve( 30, li_primary_profitcenter)   // 30 = Operator
		if ll_rows < 1 then
			ldwc.insertRow(0)
			ldwc.setItem(1, "company", "No available Operator")
			ldwc.setItem(1, "companyid", 0)
		end if
		dw_1.getchild("pc_nr", ldwc)
		ldwc.setTransObject( sqlca)
		ldwc.retrieve( uo_global.is_userid )  
end choose


/* if VAS group populate profitcenter */
if dw_1.dataObject = "d_vessel_group" then
	dw_1.getChild("pc_nr", ldwc)
	ldwc.setTransObject(sqlca)
	ldwc.retrieve(uo_global.is_userid)
end if

if dw_1.dataObject = "dw_profit_center" then
	dw_1.getChild("pcgroup_id", ldwc)
	ldwc.setTransObject(sqlca)
	ldwc.retrieve(uo_global.is_userid)
	if uo_global.ii_access_level <> 3  then
		dw_1.settaborder( "pcgroup_id",0)
	end if
end if


If Not (IsNull(istr_parametre.edit_key_text)) And (istr_parametre.edit_key_text<>"") Then
	dw_1.retrieve(istr_parametre.edit_key_text)
Elseif Not(IsNull(istr_parametre.edit_key_number)) And (istr_parametre.edit_key_number<>0) Then
	dw_1.retrieve(istr_parametre.edit_key_number) 
Else
	// New record
	dw_1.insertRow(0)
	Return
End if


end event

event ue_initialize;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : Vessel detail
 Object     : 
 Event	 :  
 Scope     : 
 ************************************************************************************
 Author    :Teit Aunt 
 Date       : 30-8-96
 Description : 
 Arguments : 
 Returns   :   
 Variables : 
 Other : 
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
30-8-96		1.0	 		TA		Initial version
  
************************************************************************************/
/* Initialize the detail window */
long ll_row
datawindowchild	ldwc

ll_row = dw_1.GetRow()

CHOOSE CASE dw_1.DataObject
	CASE "dw_vessel"
		If IsNull(dw_1.GetItemNumber(ll_row, "cal_vest_type_id")) Then
			long ll_drc, ll_oa,ll_cap,ll_tc,ll_fo, ll_do, ll_mgo, ll_budget_comm
			ll_drc = dw_1.GetItemNumber(ll_row,"cal_drc")
			If IsNull(ll_drc) Then
				dw_1.SetItem(1,"cal_drc",0)
			End If
			ll_oa = dw_1.GetItemNumber(ll_row,"cal_oa")
			If IsNull(ll_oa) Then
				dw_1.SetItem(1,"cal_oa",0)
			End If
			ll_cap = dw_1.GetItemNumber(ll_row,"cal_cap")
			If IsNull(ll_cap) Then
				dw_1.SetItem(1,"cal_cap",0)
			End If
			ll_tc = dw_1.GetItemNumber(ll_row,"cal_tc")
			If IsNull(ll_tc) Then
				dw_1.SetItem(1,"cal_tc",0)
			End If
			ll_fo = dw_1.GetItemNumber(ll_row,"cal_fo_price")
			If IsNull(ll_fo) Then
				dw_1.SetItem(1,"cal_fo_price",0)
			End If
			ll_do = dw_1.GetItemNumber(ll_row,"cal_do_price")
			If IsNull(ll_do) Then
				dw_1.SetItem(1,"cal_do_price",0)
			End If
			ll_mgo = dw_1.GetItemNumber(ll_row,"cal_mgo_price")
			If IsNull(ll_mgo) Then
				dw_1.SetItem(1,"cal_mgo_price",0)
			End If
			ll_budget_comm = dw_1.GetItemNumber(ll_row,"budget_comm")
			If IsNull(ll_budget_comm ) Then
				dw_1.SetItem(1,"budget_comm",0)
			End If
		End if
		
		IF uo_global.ii_access_level <> 3 THEN
			dw_1.setTabOrder("apm_account_nr", 0)
		END IF
		
		dw_1.SetFocus()

	CASE "d_calc_clarkson_gas","d_calc_clarkson_tank","d_calc_clarkson_bulk"
		If IsNull(dw_1.GetItemNumber(ll_row, "cal_vest_type_id")) Then
			ll_drc = dw_1.GetItemNumber(ll_row,"cal_drc")
			If IsNull(ll_drc) Then
				dw_1.SetItem(1,"cal_drc",0)
			End If
			ll_oa = dw_1.GetItemNumber(ll_row,"cal_oa")
			If IsNull(ll_oa) Then
				dw_1.SetItem(1,"cal_oa",0)
			End If
			ll_cap = dw_1.GetItemNumber(ll_row,"cal_cap")
			If IsNull(ll_cap) Then
				dw_1.SetItem(1,"cal_cap",0)
			End If
			ll_tc = dw_1.GetItemNumber(ll_row,"cal_tc")
			If IsNull(ll_tc) Then
				dw_1.SetItem(1,"cal_tc",0)
			End If
			ll_fo = dw_1.GetItemNumber(ll_row,"cal_fo_price")
			If IsNull(ll_fo) Then
				dw_1.SetItem(1,"cal_fo_price",0)
			End If
			ll_do = dw_1.GetItemNumber(ll_row,"cal_do_price")
			If IsNull(ll_do) Then
				dw_1.SetItem(1,"cal_do_price",0)
			End If
			ll_mgo = dw_1.GetItemNumber(ll_row,"cal_mgo_price")
			If IsNull(ll_mgo) Then
				dw_1.SetItem(1,"cal_mgo_price",0)
			End If
			ll_budget_comm = dw_1.GetItemNumber(ll_row,"cal_clrk_budget_comm")
			If IsNull(ll_budget_comm ) Then
				dw_1.SetItem(1,"cal_clrk_budget_comm",0)
			End If
			if dw_1.DataObject = "d_calc_clarkson_tank" then
				dw_1.SetItem(1,"cal_clrk_type",1)
			elseif 	dw_1.DataObject = "d_calc_clarkson_gas" then
				dw_1.SetItem(1,"cal_clrk_type",600)
			end if
			dw_1.ResetUpdate()
			if isnull(dw_1.getItemNumber(1, "cal_clrk_id")) then dw_1.setItemStatus(1,0,primary!, New!)
		End if
	
			dw_1.SetFocus()
	
	CASE "d_calc_vessel_type_detail"
		ll_drc = dw_1.GetItemNumber(ll_row,"cal_drc")
		If IsNull(ll_drc) Then
			dw_1.SetItem(1,"cal_drc",0)
		End If
		ll_oa = dw_1.GetItemNumber(ll_row,"cal_oa")
		If IsNull(ll_oa) Then
			dw_1.SetItem(1,"cal_oa",0)
		End If
		ll_cap = dw_1.GetItemNumber(ll_row,"cal_cap")
		If IsNull(ll_cap) Then
			dw_1.SetItem(1,"cal_cap",0)
		End If
		ll_tc = dw_1.GetItemNumber(ll_row,"cal_tc")
		If IsNull(ll_tc) Then
			dw_1.SetItem(1,"cal_tc",0)
		End If
		ll_fo = dw_1.GetItemNumber(ll_row,"cal_fo_price")
		If IsNull(ll_fo) Then
			dw_1.SetItem(1,"cal_fo_price",0)
		End If
		ll_do = dw_1.GetItemNumber(ll_row,"cal_do_price")
		If IsNull(ll_do) Then
			dw_1.SetItem(1,"cal_do_price",0)
		End If
		ll_mgo = dw_1.GetItemNumber(ll_row,"cal_mgo_price")
		If IsNull(ll_mgo) Then
			dw_1.SetItem(1,"cal_mgo_price",0)
		End If
		ll_budget_comm = dw_1.GetItemNumber(ll_row,"cal_vest_budget_comm")
		If IsNull(ll_budget_comm ) Then
			dw_1.SetItem(1,"cal_vest_budget_comm",0)
		End If

		dw_1.SetFocus()

END CHOOSE

	


end event

public function integer uf_copyconfigdatapcgroup (long al_oldpcgroup, long al_newpcgroup);boolean  bl_clearpcgroup
long	ll_maxcompanyid
integer li_updatepcgroup


//1. PF_FIXTURE_BUNKERPLACE
COMMIT;
INSERT INTO PF_FIXTURE_BUNKERPLACE (NAME, PRICE, PCGROUP_ID)
(SELECT NAME, PRICE, :al_newpcgroup as PCGROUP_ID FROM PF_FIXTURE_BUNKERPLACE WHERE PCGROUP_ID=:al_oldpcgroup);
COMMIT USING SQLCA;
IF SQLCA.SQLcode <> 0 THEN
 MessageBox("Warning", "Error Copying trade information " + SQLCA.sqlerrtext )
 return -1
END IF

//2. PF_FIXTURE_TRADE
COMMIT;
INSERT INTO PF_FIXTURE_TRADE (NAME, LOADAREAID, DISCHARGEAREAID, DISTANCE, DAYS, FLATRATE, BUNKERID, COMMISSION, EXPENSES, COMMENT, DAYSINPORT, DPORTCODE, LPORTCODE, PCGROUP_ID)
(SELECT NAME, LOADAREAID, DISCHARGEAREAID, DISTANCE, DAYS, FLATRATE, BUNKERID, COMMISSION, EXPENSES, COMMENT, DAYSINPORT, DPORTCODE, LPORTCODE, :al_newpcgroup as PCGROUP_ID FROM PF_FIXTURE_TRADE WHERE PCGROUP_ID=:al_oldpcgroup);
COMMIT USING SQLCA;
IF SQLCA.SQLcode <> 0 THEN
 MessageBox("Warning", "Error Copying trade information " +SQLCA.sqlerrtext )
 bl_clearpcgroup=TRUE
END IF

IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	UPDATE PF_FIXTURE_TRADE  SET PF_FIXTURE_TRADE.BUNKERID=FP2.BUNKERID
	FROM  PF_FIXTURE_BUNKERPLACE FP , PF_FIXTURE_BUNKERPLACE FP2
	WHERE PF_FIXTURE_TRADE.BUNKERID=FP.BUNKERID AND PF_FIXTURE_TRADE.PCGROUP_ID=:al_newpcgroup AND
	FP2.NAME=FP.NAME AND FP2.PCGROUP_ID=:al_newpcgroup;
    COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying trade information " +SQLCA.sqlerrtext )
	 bl_clearpcgroup=TRUE
	END IF
END IF

//PF_FIXTURE_FLATRATE
IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	INSERT INTO PF_FIXTURE_FLATRATE (TRADEID, PCGROUP_ID, FLATRATE, FLATRATEYEAR)
   (SELECT TRADEID, PCGROUP_ID, 0 AS FLATRATE, year(getdate()) AS FLATRATEYEAR FROM PF_FIXTURE_TRADE WHERE PCGROUP_ID=:al_newpcgroup);
    COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying trade information " +SQLCA.sqlerrtext )
	 bl_clearpcgroup=TRUE
	END IF
END IF


//3. PF_FIXTURE_CLEANINGTYPE
IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	INSERT INTO PF_FIXTURE_CLEANINGTYPE (DESCRIPTION, PCGROUP_ID)
	(SELECT DESCRIPTION, :al_newpcgroup as PCGROUP_ID FROM PF_FIXTURE_CLEANINGTYPE WHERE PCGROUP_ID=:al_oldpcgroup);
	COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying cargo cleaning type information " + SQLCA.sqlerrtext )
	 return -1
	END IF
END IF

//4. PF_FIXTURE_CARGO
IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	INSERT INTO PF_FIXTURE_CARGO (NAME,DESCRIPTION,CPP,CLEANINGTYPEID, PCGROUP_ID)
	(SELECT NAME,DESCRIPTION,CPP,CLEANINGTYPEID , :al_newpcgroup as PCGROUP_ID FROM PF_FIXTURE_CARGO WHERE PCGROUP_ID=:al_oldpcgroup);
	COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying cargo information " + SQLCA.sqlerrtext )
	 return -1
	END IF
END IF

IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	UPDATE PF_FIXTURE_CARGO  SET PF_FIXTURE_CARGO.CLEANINGTYPEID=FP2.CLEANINGTYPEID
	FROM  PF_FIXTURE_CARGO , PF_FIXTURE_CLEANINGTYPE FP , PF_FIXTURE_CLEANINGTYPE FP2
	WHERE PF_FIXTURE_CARGO.CLEANINGTYPEID=FP.CLEANINGTYPEID AND PF_FIXTURE_CARGO.PCGROUP_ID=:al_newpcgroup AND
	FP2.DESCRIPTION=FP.DESCRIPTION AND FP2.PCGROUP_ID=:al_newpcgroup;  
    COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying cargo information " +SQLCA.sqlerrtext )
	 bl_clearpcgroup=TRUE
	END IF
END IF

//5. PF_FIXTURE_STATUS_CONFIG
IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	INSERT INTO PF_FIXTURE_STATUS_CONFIG (STATUSID,FIXTURELIST, CARGOLIST,DAYSONLIST, PCGROUP_ID )
   (SELECT STATUSID,FIXTURELIST, CARGOLIST,DAYSONLIST, :al_newpcgroup as PCGROUP_ID 
	FROM PF_FIXTURE_STATUS_CONFIG WHERE PCGROUP_ID=:al_oldpcgroup);
    COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying fixture status information " +SQLCA.sqlerrtext )
	 bl_clearpcgroup=TRUE
	END IF
END IF

//6. PF_COMPANY

IF bl_clearpcgroup = FALSE THEN
	COMMIT;
	SELECT MAX(COMPANYID) 
	INTO :ll_maxcompanyid
	FROM PF_COMPANY;
	COMMIT USING SQLCA;
	
	COMMIT;
	INSERT INTO PF_COMPANY (COMPANY,COMPANY2,SHORTNAME,ADDRESS1,ADDRESS2,ADDRESS3,CITY,POSTCODE,COUNTRYID,EMAIL,EMAIL2,TELEPHONE,TELEPHONE2,
FAX, FAX2,TELEX,TYPEID,CHASHORTPHONE,OPSSHORTPHONE,CHATM,OPSTM,SWITCHBOARD,CATEGORYID,MAILLIST,DEACTIVATED,CRLOIRATINGID,CRBANK,
CRFREIGHT,CRCOMMENT,CRLASTAUTHDATE,CRLASTMODDATE,CREXPIREDATE,DISABLEOFFICE,LASTUPDATED, PCGROUP_ID )
   (SELECT COMPANY,COMPANY2,SHORTNAME,ADDRESS1,ADDRESS2,ADDRESS3,CITY,POSTCODE,COUNTRYID,EMAIL,EMAIL2,TELEPHONE,TELEPHONE2,
FAX, FAX2,TELEX,TYPEID,CHASHORTPHONE,OPSSHORTPHONE,CHATM,OPSTM,SWITCHBOARD,CATEGORYID,MAILLIST,DEACTIVATED,CRLOIRATINGID,CRBANK,
CRFREIGHT,CRCOMMENT,CRLASTAUTHDATE,CRLASTMODDATE,CREXPIREDATE,DISABLEOFFICE,LASTUPDATED, :al_newpcgroup as PCGROUP_ID 
	FROM PF_COMPANY WHERE PCGROUP_ID=:al_oldpcgroup);
    COMMIT USING SQLCA;
	IF SQLCA.SQLcode <> 0 THEN
	 MessageBox("Warning", "Error Copying companies information " +SQLCA.sqlerrtext )
	 bl_clearpcgroup=TRUE
	END IF
END IF

//li_updatepcgroup=MessageBox("Profit center group","Copy company contacts?",Question!, YesNo! )

//if li_updatepcgroup=1 then
	
	//7. PF_COMPANYCONTACTS
//	IF bl_clearpcgroup = FALSE THEN
//		COMMIT;
//		INSERT INTO PF_COMPANYCONTACTS (CONTACTSPROFILEID,FULLNAME,COMPANYID,WORKTELEPHONE,HOMETELEPHONE,MOBILE,EMAIL,STAFFTITLE,STAFFRESPONSIBILITY,MAILLIST,
//	DEACTIVATED,LASTUPDATED,COMMENT )
//		(SELECT CONTACTSPROFILEID,FULLNAME,PF_COMPANYCONTACTS.COMPANYID,WORKTELEPHONE,HOMETELEPHONE,MOBILE,PF_COMPANYCONTACTS.EMAIL,STAFFTITLE,STAFFRESPONSIBILITY,PF_COMPANYCONTACTS.MAILLIST,
//	PF_COMPANYCONTACTS.DEACTIVATED,PF_COMPANYCONTACTS.LASTUPDATED,COMMENT
//		FROM PF_COMPANYCONTACTS, PF_COMPANY WHERE PF_COMPANYCONTACTS.COMPANYID = PF_COMPANY.COMPANYID AND PF_COMPANY.PCGROUP_ID=:al_oldpcgroup);
//		 COMMIT USING SQLCA;
//		IF SQLCA.SQLcode <> 0 THEN
//		 MessageBox("Warning", "Error Copying companies information " +SQLCA.sqlerrtext )
//		 bl_clearpcgroup=TRUE
//		END IF
//	END IF
//	
//	IF bl_clearpcgroup = FALSE THEN
//		COMMIT;
//		
//		UPDATE PF_COMPANYCONTACTS  SET PF_COMPANYCONTACTS.COMPANYID=FP2.COMPANYID
//		FROM  PF_COMPANYCONTACTS , PF_COMPANY FP , PF_COMPANY FP2
//		WHERE PF_COMPANYCONTACTS.COMPANYID=FP.COMPANYID AND FP.PCGROUP_ID=:al_oldpcgroup and 
//		FP2.COMPANY=FP.COMPANY AND  FP2.COMPANYID>:ll_maxcompanyid ;  
//	
//		 COMMIT USING SQLCA;
//		IF SQLCA.SQLcode <> 0 THEN
//		 MessageBox("Warning", "Error Copying company contacts information " +SQLCA.sqlerrtext )
//		 bl_clearpcgroup=TRUE
//		END IF
//	END IF
//end if

if bl_clearpcgroup=true then

	COMMIT;
	DELETE FROM PF_FIXTURE_FLATRATE WHERE PCGROUP_ID=:al_newpcgroup;
	DELETE FROM PF_FIXTURE_TRADE WHERE PCGROUP_ID=:al_newpcgroup;
	DELETE FROM PF_FIXTURE_BUNKERPLACE WHERE PCGROUP_ID=:al_newpcgroup;

	DELETE FROM PF_FIXTURE_CARGO WHERE PCGROUP_ID=:al_newpcgroup;
	DELETE FROM PF_FIXTURE_CLEANINGTYPE WHERE PCGROUP_ID=:al_newpcgroup;
	DELETE FROM PF_FIXTURE_STATUS_CONFIG WHERE PCGROUP_ID=:al_newpcgroup;
	
	//DELETE FROM PF_COMPANYCONTACTS WHERE COMPANYID IN  (SELECT COMPANYID FROM PF_COMPANY WHERE PCGROUP_ID=:al_newpcgroup);

	DELETE FROM PF_COMPANY WHERE PCGROUP_ID=:al_newpcgroup;

	COMMIT USING SQLCA;
   return -1
end if

return 0
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	25/08/14		CR3708	CCY018			F1 help application coverage - modified event ue_getwidowname
   </HISTORY>
********************************************************************/
end subroutine

event open;istr_parametre = Message.PowerObjectParm
this.move(1,1)

dw_1.DataObject = istr_parametre.edit_datawindow
dw_1.SetTransObject(sqlca)
this.title = istr_parametre.edit_window_title

PostEvent("ue_retrieve")

long antal_kolonner, max_bredde= 0, xx, xpos, bredde 
long max_hojde= 0, hojde, ypos
antal_kolonner = long(dw_1.describe("datawindow.column.count"))
for xx = 1 to antal_kolonner
	xpos = long(dw_1.describe("#"+string(xx)+".X"))
	bredde = long(dw_1.describe("#"+string(xx)+".width"))
	ypos = long(dw_1.describe("#"+string(xx)+".Y"))
	hojde = long(dw_1.describe("#"+string(xx)+".height"))
	if max_bredde < (xpos + bredde) then max_bredde = (xpos + bredde)
	if max_hojde < (ypos + hojde) then max_hojde = (ypos + hojde)
next
This.Width = max_bredde + 100
This.Height = max_hojde + 300
dw_1.Width = max_bredde + 50
dw_1.Height = max_hojde + 50

long xmove
xmove = cb_update.x
cb_update.move(xmove,max_hojde + 100)
xmove = cb_cancel.x
cb_cancel.move(xmove,max_hojde + 100)

/* Access control - remember to alto modify w_list */
Choose case istr_parametre.edit_datawindow
	/* Admin and Superuser */
	case "dw_claimtype", "dw_group", "dw_purpose", &
    			"d_vessel_group", "d_vessel_type" 
		if uo_global.ii_access_level > 1 then
			cb_update.enabled = true
		else
			cb_update.enabled = false
		end if
	/* Admin and Finance profile */
	case "dw_currency", "dw_voucher", "dw_voucher_group", "dw_profit_center"
		if uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 3 then
			cb_update.enabled = true
		else
			cb_update.enabled = false
		end if
end choose

Postevent("ue_initialize")

end event

on closequery;/* If there is unsaved data the user is queried is they should be saved */
long ll_tmp
integer li_return

If dw_1.AcceptText() = 1 Then
	If ((dw_1.ModifiedCount() + dw_1.DeletedCount()) > 0) AND cb_update.enabled Then
		ll_tmp = MessageBox("Warning","You have unsaved data! Save?",StopSign!,YesNoCancel!)
		CHOOSE CASE ll_tmp
			CASE 1
				This.TriggerEvent("ue_update")
				If ret_val = 0 Then
					li_return = 1
				Else
					li_return = 0
				End If
			CASE 2
				li_return = 0
			CASE 3
				li_return = 1		
		END CHOOSE
	End If
End If

Message.ReturnValue = li_return


end on

on w_list_detail.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.dw_1
end on

on w_list_detail.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.dw_1)
end on

event ue_getwindowname;call super::ue_getwindowname;if istr_parametre.window_title = "Currencies" then
	as_windowname = this.classname( ) + "_currency"
elseif istr_parametre.window_title = "Vouchers" then
	as_windowname = this.classname( ) + "_voucher"
elseif istr_parametre.window_title = "Voucher Groups" then
	as_windowname = this.classname( ) + "_vouchergroup"
else
	as_windowname = this.classname( )
end if
	
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_list_detail
end type

type cb_cancel from commandbutton within w_list_detail
integer x = 366
integer y = 400
integer width = 256
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

on clicked;Close(parent)
end on

type cb_update from commandbutton within w_list_detail
integer x = 37
integer y = 400
integer width = 297
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update"
boolean default = true
end type

event clicked;Parent.TriggerEvent("ue_update")
//Close(parent)

end event

type dw_1 from uo_datawindow within w_list_detail
integer x = 37
integer y = 16
integer width = 622
integer taborder = 10
string dataobject = "dw_agent"
end type

