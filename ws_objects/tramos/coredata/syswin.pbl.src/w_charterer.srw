$PBExportHeader$w_charterer.srw
$PBExportComments$Window for editing charterers
forward
global type w_charterer from window
end type
type cb_refresh_group_list from commandbutton within w_charterer
end type
type st_notice from statictext within w_charterer
end type
type cb_1 from commandbutton within w_charterer
end type
type cb_2 from commandbutton within w_charterer
end type
type dw_charterer from uo_datawindow within w_charterer
end type
end forward

global type w_charterer from window
integer x = 672
integer y = 264
integer width = 4320
integer height = 2448
boolean titlebar = true
string title = "Charterer"
boolean controlmenu = true
windowtype windowtype = child!
long backcolor = 80269524
cb_refresh_group_list cb_refresh_group_list
st_notice st_notice
cb_1 cb_1
cb_2 cb_2
dw_charterer dw_charterer
end type
global w_charterer w_charterer

type variables
long ll_parm
end variables

forward prototypes
private subroutine wf_settab_onlyalternateaddress ()
end prototypes

private subroutine wf_settab_onlyalternateaddress ();/* Set tab order so that normal users only can modify alternate invoice address */

dw_charterer.settaborder("chart_nr",0)		
dw_charterer.settaborder("chart_sn",0)		
dw_charterer.settaborder("chart_n_1",0)		
dw_charterer.settaborder("chart_n_2",0)		
dw_charterer.settaborder("chart_a_1",0)		
dw_charterer.settaborder("chart_a_2",0)		
dw_charterer.settaborder("chart_a_3",0)		
dw_charterer.settaborder("chart_a_4",0)		
dw_charterer.settaborder("chart_c",0)		
dw_charterer.settaborder("chart_att",0)		
dw_charterer.settaborder("chart_ph",0)		
dw_charterer.settaborder("chart_tx",0)		
dw_charterer.settaborder("chart_tx_ab",0)		
dw_charterer.settaborder("chart_tfx",0)		
dw_charterer.settaborder("chart_nom_acc_nr",0)		
dw_charterer.settaborder("chart_chart_custsupp",0)	
dw_charterer.settaborder("ccs_chgp_pk",0)	
dw_charterer.settaborder("chart_chart_last_tx",0)		
dw_charterer.settaborder("chart_chart_email",0)		
dw_charterer.settaborder("chart_chart_homepage",0)		
dw_charterer.settaborder("chart_vat_nr",0)		
dw_charterer.settaborder("chart_apl_vat_rate",0)		
dw_charterer.settaborder("chart_active",0)

return



end subroutine

event open;/*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01-01-95		1.0 	 		MI             Initial version
01-07-96					JEH		Changed Window size to fit changed datawindow

  
************************************************************************************/

Move(28,110)
ll_parm = message.DoubleParm
dw_charterer.SetTransObject(SQLCA)
IF ll_parm = 0 THEN
	dw_charterer.InsertRow(0)
	this.title = "Charterer - NEW"
	dw_charterer.SetItem(dw_charterer.GetRow(),"chart_chart_custsupp",0)
	dw_charterer.SetItem(dw_charterer.GetRow(),"chart_active",1)
ELSE
	dw_charterer.Retrieve(ll_parm)
	this.title = "Charterer - MODIFY"
END IF	
dw_charterer.SetFocus()

//set datawindow read-only when blocked, only finance superuser can unblock
if dw_charterer.getitemnumber( 1, "chart_blocked") = 1 then
	if uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 then
		dw_charterer.settaborder("chart_blocked",600)
	else
		dw_charterer.Object.DataWindow.ReadOnly='Yes'
		cb_1.enabled = false /* Update button */
		st_notice.visible = true
	end if
end if

/* If not "administrator" then check if person is finans profile. If not disable fields */
IF uo_global.ii_access_level <> 3 THEN 
	if uo_global.ii_user_profile <> 3 then  
		wf_settab_onlyalternateaddress()
//		dw_charterer.Object.DataWindow.ReadOnly='Yes'
//		cb_1.enabled = false /* Update button */
//		st_notice.visible = true
		return
	end if
END IF

end event

on w_charterer.create
this.cb_refresh_group_list=create cb_refresh_group_list
this.st_notice=create st_notice
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_charterer=create dw_charterer
this.Control[]={this.cb_refresh_group_list,&
this.st_notice,&
this.cb_1,&
this.cb_2,&
this.dw_charterer}
end on

on w_charterer.destroy
destroy(this.cb_refresh_group_list)
destroy(this.st_notice)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_charterer)
end on

type cb_refresh_group_list from commandbutton within w_charterer
integer x = 1691
integer y = 108
integer width = 466
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh Group List"
end type

event clicked;datawindowchild	dwc
if dw_charterer.getchild("ccs_chgp_pk", dwc) = 1 then
	dwc.setTransObject( sqlca )
	dwc.retrieve()
	commit;
end if
end event

type st_notice from statictext within w_charterer
boolean visible = false
integer x = 1435
integer y = 2256
integer width = 2135
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "As you are a user without Finance profile, you can only modify comment!"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_charterer
integer x = 78
integer y = 2236
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update"
end type

event clicked;int li_next_charterer_nr, li_intr_suppl
string ls_chart_sn, ls_account_no, ls_countryName,ls_acc_new
int li_count, li_chart_blocked
long ll_countryID, ll_found, ll_acc
datawindowchild dwc

dw_charterer.AcceptText()

IF IsNull(dw_charterer.GetItemString(dw_charterer.GetRow(),"chart_sn")) THEN
	MessageBox("Update Error","Please enter a Charterer Short Name!")
	Return
END IF	

IF IsNull(dw_charterer.GetItemstring(dw_charterer.GetRow(),"chart_n_1")) THEN
	MessageBox("Update Error","Please enter a Charterer Full Name (Blue Line)!")
	Return
END IF

ls_chart_sn = dw_charterer.GetItemString(dw_charterer.GetRow(),"chart_sn")
SELECT count(*)
INTO :li_count
FROM CHART
WHERE CHART_SN = :ls_chart_sn;
IF (ll_parm = 0 AND li_count = 1) THEN
	MessageBox("Duplicate","You are creating a duplicate Charterer!~r~nThis is not allowed")
	Return
END IF

// Validate the contents of "Nominal acc. number"
li_intr_suppl = dw_charterer.GetItemNumber(dw_charterer.GetRow(),"chart_chart_custsupp")
ls_account_no = dw_charterer.GetItemString(dw_charterer.GetRow(),"Chart_nom_acc_nr")
ll_countryID = dw_charterer.GetItemNumber(dw_charterer.GetRow(),"country_id")

IF isNull(ls_account_no) THEN
	MessageBox("Error","Please enter the nominal account number")
	Return
END IF

// Validate country
if isNull(ll_countryID) then
	MessageBox("Error","Please select country")
	dw_charterer.setColumn( "country_id" )
	dw_charterer.post setfocus()
	Return
end if	
dw_charterer.getchild( "country_id", dwc)
ll_found = dwc.find( "country_id="+string(ll_countryID) , 1, 9999 )
if ll_found < 1 then 
	MessageBox("Error","Please select country")
	dw_charterer.setColumn( "country_id" )
	dw_charterer.post setfocus()
	Return
end if	
ls_countryName = dwc.getItemString(ll_found, "country_name")
dw_charterer.setItem(1, "chart_c", ls_countryName)

IF li_intr_suppl = 0 THEN
	// Not internal supplier - numeric(5)
	IF NOT(IsNumber(ls_account_no)) OR (Len(ls_account_no) < 5) OR (Len(ls_account_no) > 5) THEN
		MessageBox("Error","The nominal account number must have exactly five digits")
		Return
	END IF
ELSE
	// Internal supplier - text(3)
	IF (Len(ls_account_no) < 3) OR (Len(ls_account_no) > 3) THEN
		MessageBox("Error","The nominal account number must have exactly three characters")
		Return
	END IF
END IF

IF IsNull(dw_charterer.GetItemNumber(dw_charterer.GetRow(),"ccs_chgp_pk")) THEN
	MessageBox("Update Error","Please select a Charterer Group")
	Return
END IF

IF ll_parm = 0 THEN
	SELECT max(CHART_NR)
	INTO :li_next_charterer_nr
	FROM CHART;
	IF IsNull(li_next_charterer_nr) THEN 
		dw_charterer.SetItem(1,"chart_nr",1)
	ELSE
		dw_charterer.SetItem(1,"chart_nr",li_next_charterer_nr + 1)
	END IF
END IF

/* Check if Charterer is already blocked from AX */
li_next_charterer_nr = dw_charterer.getItemNumber(1,"chart_nr")
SELECT COUNT(*) 
	INTO :li_count
	FROM CHART
	WHERE CHART_NR <> :li_next_charterer_nr
	AND NOM_ACC_NR = :ls_account_no
	AND CHART_BLOCKED = 1;
if li_count > 0 then
	MessageBox("Error","Entered Account number is blocked in AX.",StopSign!)
	Return
end if

//unblock an entry
SELECT NOM_ACC_NR, CHART_BLOCKED
	INTO :ll_acc, :li_chart_blocked
	FROM CHART
	WHERE CHART_NR = :li_next_charterer_nr;
ls_acc_new = dw_charterer.getItemString(1,"chart_nom_acc_nr")
if dw_charterer.getItemNumber(1,"chart_blocked") = 0 and li_chart_blocked = 1 then
	if ls_acc_new = string(ll_acc) then
		messagebox("","Please enter a different 'Nominal Acc. Nr' when unblocking!")
		dw_charterer.setColumn( "chart_nom_acc_nr" )
		dw_charterer.post setfocus()
		Return
	else
		string ls_blocked_note, ls_supplier_number, ls_supplier_name
		datetime ldt_blocked_date
		ls_blocked_note = "Unblocked, Nominal Acc. Nr changed from " + string(ll_acc) + " to " + ls_acc_new
		ldt_blocked_date = DateTime(Today(),Now())
		ls_supplier_name = dw_charterer.getItemString(1,"chart_n_1")
		INSERT INTO BLOCKED_VENDOR_LOG (BLOCKED_DATE, BLOCKED, TRAMOS_TYPE, SUPPLIER_NUMBER, SUPPLIER_NAME, TRAMOS_NAME, BLOCKED_NOTE)
		VALUES (:ldt_blocked_date, 0,"C",:ls_acc_new,:ls_supplier_name,:uo_global.gos_userid,:ls_blocked_note);
	end if
end if



IF dw_Charterer.Update() = 1 THEN
	commit;
	Close(parent)
ELSE
	rollback;
END IF
end event

type cb_2 from commandbutton within w_charterer
integer x = 489
integer y = 2236
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

on clicked;close(parent)
end on

type dw_charterer from uo_datawindow within w_charterer
integer x = 18
integer y = 16
integer width = 4283
integer height = 2192
integer taborder = 30
string dataobject = "dw_charterer_ns"
boolean border = false
end type

