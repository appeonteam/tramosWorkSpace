$PBExportHeader$w_agent.srw
$PBExportComments$Window for editing agents
forward
global type w_agent from window
end type
type st_notice from statictext within w_agent
end type
type cb_2 from commandbutton within w_agent
end type
type cb_1 from commandbutton within w_agent
end type
type dw_agent from uo_datawindow within w_agent
end type
end forward

global type w_agent from window
integer x = 27
integer y = 208
integer width = 2871
integer height = 2408
boolean titlebar = true
string title = "Agent"
boolean controlmenu = true
windowtype windowtype = child!
long backcolor = 81324524
st_notice st_notice
cb_2 cb_2
cb_1 cb_1
dw_agent dw_agent
end type
global w_agent w_agent

type variables
long ll_parm
end variables

event open;integer					li_profile

this.Move(28,110)
ll_parm = message.DoubleParm
dw_agent.SetTransObject(SQLCA)
IF ll_parm = 0 THEN
	dw_agent.InsertRow(0)
	this.title = "Agent - NEW"
	dw_agent.SetItem(dw_agent.GetRow(),"agent_disc",0)
	dw_agent.SetItem(dw_agent.GetRow(),"agent_custsupp",0)
	dw_agent.SetItem(dw_agent.GetRow(),"agent_active",1)
ELSE
	dw_agent.Retrieve(ll_parm,0)
	this.title = "Agent - MODIFY"
END IF	

//set datawindow read-only when blocked, only finance superuser can unblock
if dw_agent.getitemnumber( 1, "agent_blocked") = 1 then
	if uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 then
		dw_agent.settaborder("agent_blocked",600)
	else
		dw_agent.Object.DataWindow.ReadOnly='Yes'
		cb_1.enabled = false /* Update button */
		st_notice.visible = true
	end if
end if

//// Administrator and Superuser have access to change agent for import file set taborder for this field
//if uo_global.ii_access_level > 1 then
//	dw_agent.settaborder("import_file",35)	
//end if

/* Only Administrator and Finance profile can modify Agents */
IF uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 3 then
	//
else
	dw_agent.Object.DataWindow.ReadOnly='Yes'
	cb_1.enabled = false /* Update button */
	st_notice.visible = true
	return
END IF




end event

on w_agent.create
this.st_notice=create st_notice
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_agent=create dw_agent
this.Control[]={this.st_notice,&
this.cb_2,&
this.cb_1,&
this.dw_agent}
end on

on w_agent.destroy
destroy(this.st_notice)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_agent)
end on

type st_notice from statictext within w_agent
boolean visible = false
integer x = 379
integer y = 2196
integer width = 1513
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Only users with Finance profile can modify Agents!"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_agent
integer x = 2583
integer y = 2204
integer width = 238
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

on clicked;close(parent)
end on

type cb_1 from commandbutton within w_agent
integer x = 2313
integer y = 2204
integer width = 238
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
string text = "Update"
boolean default = true
end type

event clicked;int li_next_agent_nr, li_intr_suppl, li_count, li_agent_blocked
long ll_acc, ll_countryID, ll_found
string ls_account_no, ls_countryName, ls_acc_new
datawindowchild	dwc

IF ll_parm = 0 THEN
	SELECT max(AGENT_NR)
	INTO :li_next_agent_nr
	FROM AGENTS;
	IF IsNull(li_next_agent_nr) THEN 
		dw_agent.SetItem(1,"agent_nr",1)
	ELSE
		dw_agent.SetItem(1,"agent_nr",li_next_agent_nr + 1)
	END IF
END IF

// Validate the contents of "Nominal acc. number"
dw_agent.AcceptText()
li_intr_suppl = dw_agent.GetItemNumber(1, "agent_custsupp")
ls_account_no = dw_agent.GetItemString(1, "nom_acc_nr")
ll_countryID = dw_agent.GetItemNumber(1, "country_id")

IF isNull(ls_account_no) THEN
	MessageBox("Error","Please enter the nominal account number")
	Return
END IF

// Validate country
if isNull(ll_countryID) then
	MessageBox("Error","Please select country")
	dw_agent.setColumn( "country_id" )
	dw_agent.post setfocus()
	Return
end if	
dw_agent.getchild( "country_id", dwc)
ll_found = dwc.find( "country_id="+string(ll_countryID) , 1, 9999 )
if ll_found < 1 then 
	MessageBox("Error","Please select country")
	dw_agent.setColumn( "country_id" )
	dw_agent.post setfocus()
	Return
end if	
ls_countryName = dwc.getItemString(ll_found, "country_name")
dw_agent.setItem(1, "agent_c", ls_countryName)
	
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


/* Check if Agent is already blocked from AX */
li_next_agent_nr = dw_agent.getItemNumber(1,"agent_nr")
SELECT COUNT(*) 
	INTO :li_count
	FROM AGENTS
	WHERE AGENT_NR <> :li_next_agent_nr
	AND NOM_ACC_NR = :ls_account_no
	AND AGENT_BLOCKED = 1;
if li_count > 0 then
	MessageBox("Error","Entered Account number is blocked in AX.",StopSign!)
	Return
end if

//unblock an entry
SELECT NOM_ACC_NR, AGENT_BLOCKED
	INTO :ll_acc, :li_agent_blocked
	FROM AGENTS
	WHERE AGENT_NR = :li_next_agent_nr;
ls_acc_new = dw_agent.getItemString(1,"nom_acc_nr")
if dw_agent.getItemNumber(1,"agent_blocked") = 0 and li_agent_blocked = 1 then
	if ls_acc_new = string(ll_acc) then
		messagebox("","Please enter a different 'Nominal Acc. Nr' when unblocking!")
		dw_agent.setColumn( "nom_acc_nr" )
		dw_agent.post setfocus()
		Return
	else
		string ls_blocked_note, ls_supplier_number, ls_supplier_name
		datetime ldt_blocked_date
		ls_blocked_note = "Unblocked, Nominal Acc. Nr changed from " + string(ll_acc) + " to " + ls_acc_new
		ldt_blocked_date = DateTime(Today(),Now())
		ls_supplier_name = dw_agent.getItemString(1,"agent_n_1")
		INSERT INTO BLOCKED_VENDOR_LOG (BLOCKED_DATE, BLOCKED, TRAMOS_TYPE, SUPPLIER_NUMBER, SUPPLIER_NAME, TRAMOS_NAME, BLOCKED_NOTE)
		VALUES (:ldt_blocked_date, 0,"A",:ls_acc_new,:ls_supplier_name,:uo_global.gos_userid,:ls_blocked_note);
	end if
end if

IF dw_agent.Update() = 1 THEN
	commit;
	Close(parent)
ELSE
	rollback;
END IF
end event

type dw_agent from uo_datawindow within w_agent
integer x = 37
integer y = 16
integer width = 2802
integer height = 2156
integer taborder = 10
string dataobject = "dw_agent"
boolean border = false
end type

