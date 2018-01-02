$PBExportHeader$w_tcowner.srw
$PBExportComments$This window lets the user modify or change a t/c owner.
forward
global type w_tcowner from window
end type
type st_notice from statictext within w_tcowner
end type
type cb_refresh from commandbutton within w_tcowner
end type
type cb_delete from commandbutton within w_tcowner
end type
type cb_2 from commandbutton within w_tcowner
end type
type cb_1 from commandbutton within w_tcowner
end type
type dw_tcowner from uo_datawindow within w_tcowner
end type
end forward

global type w_tcowner from window
integer x = 27
integer y = 208
integer width = 2866
integer height = 2520
boolean titlebar = true
string title = "T/C Owner"
boolean controlmenu = true
windowtype windowtype = child!
long backcolor = 81324524
event ue_retrieve pbm_custom40
st_notice st_notice
cb_refresh cb_refresh
cb_delete cb_delete
cb_2 cb_2
cb_1 cb_1
dw_tcowner dw_tcowner
end type
global w_tcowner w_tcowner

type variables
// LONG vessel_nr
long ll_parm
end variables

event ue_retrieve;//LONG owner_nr
//STRING fullname
//
//SELECT TCOWNER_NR, VESSEL_NAME 
//	INTO :owner_nr, :fullname FROM VESSELS 
//	WHERE VESSEL_NR = :vessel_nr;
//
//IF owner_nr = 0 OR IsNull(owner_nr) THEN
//	SetRedraw(FALSE)
//	dw_tcowner.InsertRow(0)
//	w_tcowner.title = "T/C Owner - NEW - Vessel "+fullname
//ELSE
//	SetRedraw(FALSE)
//	dw_tcowner.Retrieve(owner_nr)
//	w_tcowner.title = "T/C Owner - MODIFY - Vessel "+fullname
//END IF	
//SetRedraw(TRUE)
//
end event

event open;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : 
 Object     : 
 Event	 : 
 Scope     : 
 ************************************************************************************
 Author    : Martin
 Date       : 01-01-95
 Description : {Short description}
 Arguments : {description/none}
 Returns   : {description/none}  
 Variables : {important variables - usually only used in Open-event scriptcode}
 Other : {other comments}
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01-01-95		1.0 	 		MI             Initial version
01-07-96					JEH		Changed Window size to fit changed datawindow

  
************************************************************************************/

Move(28,110)
ll_parm = message.DoubleParm
dw_tcowner.SetTransObject(SQLCA)
IF ll_parm = 0 THEN
	dw_tcowner.InsertRow(0)
	this.title = "T/C Owner - NEW"
	dw_tcowner.SetItem(dw_tcowner.GetRow(),"tcowner_active",1)
ELSE
	dw_tcowner.Retrieve(ll_parm)
	this.title = "T/C Owner - MODIFY"
END IF	

dw_tcowner.SetFocus()

//set datawindow read-only when blocked, only finance superuser can unblock
if dw_tcowner.getitemnumber( 1, "tcowner_blocked") = 1 then
	if uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 then
		dw_tcowner.settaborder("tcowner_blocked",600)
	else
		dw_tcowner.Object.DataWindow.ReadOnly='Yes'
		cb_1.enabled = false /* Update button */
		st_notice.visible = true
	end if
end if

/* If not "administrator" then check if person is finans profile. If not disable nom_acc_nr */
IF uo_global.ii_access_level <> 3 THEN 
	if uo_global.ii_user_profile <> 3 then   
		dw_tcowner.Object.DataWindow.ReadOnly='Yes'
		cb_1.enabled = false /* Update button */
		st_notice.visible = true
		return
	end if
END IF
end event

on w_tcowner.create
this.st_notice=create st_notice
this.cb_refresh=create cb_refresh
this.cb_delete=create cb_delete
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_tcowner=create dw_tcowner
this.Control[]={this.st_notice,&
this.cb_refresh,&
this.cb_delete,&
this.cb_2,&
this.cb_1,&
this.dw_tcowner}
end on

on w_tcowner.destroy
destroy(this.st_notice)
destroy(this.cb_refresh)
destroy(this.cb_delete)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_tcowner)
end on

type st_notice from statictext within w_tcowner
boolean visible = false
integer x = 357
integer y = 2296
integer width = 1605
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Only users with Finance profile can modify TC Owners!"
boolean focusrectangle = false
end type

type cb_refresh from commandbutton within w_tcowner
boolean visible = false
integer x = 2537
integer y = 2288
integer width = 238
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;//w_tcowner.PostEvent("ue_retrieve")
end event

type cb_delete from commandbutton within w_tcowner
boolean visible = false
integer x = 2263
integer y = 2284
integer width = 238
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;//Long ll_row
//IF dw_tcowner.Rowcount() < 1 THEN return
//ll_row = dw_tcowner.GetRow()
//IF MessageBox("Delete","You are about to DELETE the T/C Owner!~r~n" + &
//							  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN RETURN
//
//
//UPDATE VESSELS
//SET TCOWNER_NR = NULL
//WHERE VESSEL_NR = :vessel_nr;
//
//IF SQLCA.SqlCode = 0 THEN
//	IF dw_tcowner.DeleteRow(ll_row) = 1 THEN
//		IF dw_tcowner.Update() = 1 THEN
//			COMMIT;
//		ELSE
//			ROLLBACK;
//			MessageBox("Error","Delete did not occur!")
//		END IF
//	ELSE
//		MessageBox("Error","Delete did not occur!")
//	END IF
//ELSE
//	MessageBox("Error","Delete did not occur!")
//END IF
//w_tcowner.PostEvent("ue_retrieve")
//
end event

type cb_2 from commandbutton within w_tcowner
integer x = 2537
integer y = 2308
integer width = 238
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

on clicked;close(parent)
end on

type cb_1 from commandbutton within w_tcowner
integer x = 2263
integer y = 2308
integer width = 238
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update"
boolean default = true
end type

event clicked;integer li_count, li_tcowner_blocked
long ll_next_tcowner_nr, ll_countryID, ll_found, ll_acc
string ls_tcowner_sn, ls_countryName, ls_acc_new
datawindowchild dwc

dw_tcowner.accepttext()

if isnull(dw_tcowner.getitemstring(dw_tcowner.getrow(), "tcowner_sn")) then
	Messagebox("Update Error", "Please enter a T/C Owner short name")
	return 
end if

if isnull(dw_tcowner.getitemstring(dw_tcowner.getrow(), "tcowner_n_1")) then
	Messagebox("Update Error", "Please enter a T/C Owner full name")
	return 
end if

ls_tcowner_sn = dw_tcowner.getitemstring(dw_tcowner.getrow(),"tcowner_sn") 

SELECT count(*)
into :li_count
FROM TCOWNERS
WHERE TCOWNER_SN = :ls_tcowner_sn ;
COMMIT USING SQLCA;

if (ll_parm = 0 and li_count = 1) then 
	Messagebox("Duplicate", "You are creating a duplicate T/C Owner!~r~nThis is not allowed.")
	return
end if

// Validate the contents of "Nominal acc. number" FR 30-08-02
string ls_account_no

ls_account_no = dw_tcowner.GetItemString(1,"nom_acc_nr")

IF isNull(ls_account_no) THEN
	MessageBox("Error","Please enter the nominal account number")
	Return
END IF

IF NOT(IsNumber(ls_account_no)) OR (Len(ls_account_no) < 5) OR (Len(ls_account_no) > 5) THEN
	MessageBox("Error","The nominal account number must have exactly five digits")
	Return
END IF

// Validate country
ll_countryID = dw_tcowner.getItemNumber(1, "country_id")
if isNull(ll_countryID) then
	MessageBox("Error","Please select country")
	dw_tcowner.setColumn( "country_id" )
	dw_tcowner.post setfocus()
	Return
end if	
dw_tcowner.getchild( "country_id", dwc)
ll_found = dwc.find( "country_id="+string(ll_countryID) , 1, 9999 )
if ll_found < 1 then 
	MessageBox("Error","Please select country")
	dw_tcowner.setColumn( "country_id" )
	dw_tcowner.post setfocus()
	Return
end if	
ls_countryName = dwc.getItemString(ll_found, "country_name")
dw_tcowner.setItem(1, "tcowner_c", ls_countryName)

if (ll_parm = 0) then 
	SELECT max(TCOWNER_NR)
	INTO :ll_next_tcowner_nr
	FROM TCOWNERS;
	COMMIT USING SQLCA;
	if (isnull(ll_next_tcowner_nr)) then
		dw_tcowner.setitem(1, "tcowner_nr", 1)
	else
		dw_tcowner.setitem(1, "tcowner_nr", ll_next_tcowner_nr +1 )
	end if
end if

/* Check if TC Owner is already blocked from AX */
ll_next_tcowner_nr = dw_tcowner.getItemNumber(1,"tcowner_nr")
SELECT COUNT(*) 
	INTO :li_count
	FROM TCOWNERS
	WHERE TCOWNER_NR <> :ll_next_tcowner_nr
	AND NOM_ACC_NR = :ls_account_no
	AND TCOWNER_BLOCKED = 1;
if li_count > 0 then
	MessageBox("Error","Entered Account number is blocked in AX.",StopSign!)
	Return
end if

//unblock an entry
SELECT NOM_ACC_NR, TCOWNER_BLOCKED
	INTO :ll_acc, :li_tcowner_blocked
	FROM TCOWNERS
	WHERE TCOWNER_NR = :ll_next_tcowner_nr;
ls_acc_new = dw_tcowner.getItemString(1,"nom_acc_nr")
if dw_tcowner.getItemNumber(1,"tcowner_blocked") = 0 and li_tcowner_blocked = 1 then
	if ls_acc_new = string(ll_acc) then
		messagebox("","Please enter a different 'Nominal Acc. Nr' when unblocking!")
		dw_tcowner.setColumn( "nom_acc_nr" )
		dw_tcowner.post setfocus()
		Return
	else
		string ls_blocked_note, ls_supplier_number, ls_supplier_name
		datetime ldt_blocked_date
		ls_blocked_note = "Unblocked, Nominal Acc. Nr changed from " + string(ll_acc) + " to " + ls_acc_new
		ldt_blocked_date = DateTime(Today(),Now())
		ls_supplier_name = dw_tcowner.getItemString(1,"tcowner_n_1")
		INSERT INTO BLOCKED_VENDOR_LOG (BLOCKED_DATE, BLOCKED, TRAMOS_TYPE, SUPPLIER_NUMBER, SUPPLIER_NAME, TRAMOS_NAME, BLOCKED_NOTE)
		VALUES (:ldt_blocked_date, 0,"T",:ls_acc_new,:ls_supplier_name,:uo_global.gos_userid,:ls_blocked_note);
	end if
end if

if (dw_tcowner.update() = 1) then
	commit;
	Close(parent)
else
	rollback;
end if






end event

type dw_tcowner from uo_datawindow within w_tcowner
integer x = 32
integer y = 16
integer width = 2798
integer height = 2240
integer taborder = 10
string dataobject = "dw_tcowner"
boolean border = false
end type

