$PBExportHeader$w_office.srw
$PBExportComments$Window for editing offices
forward
global type w_office from window
end type
type cb_1 from commandbutton within w_office
end type
type cb_2 from commandbutton within w_office
end type
type dw_office from uo_datawindow within w_office
end type
end forward

global type w_office from window
integer x = 672
integer y = 264
integer width = 1294
integer height = 1440
boolean titlebar = true
string title = "Offices"
boolean controlmenu = true
windowtype windowtype = child!
long backcolor = 81324524
cb_1 cb_1
cb_2 cb_2
dw_office dw_office
end type
global w_office w_office

type variables
long ll_parm
end variables

on open;Move(28,110)
ll_parm = message.DoubleParm
dw_office.SetTransObject(SQLCA)
IF ll_parm = 0 THEN
	dw_office.InsertRow(0)
	this.title = "office - NEW"
ELSE
	dw_office.Retrieve(ll_parm)
	this.title = "office - MODIFY"
END IF	
dw_office.SetFocus()
end on

on w_office.create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_office=create dw_office
this.Control[]={this.cb_1,&
this.cb_2,&
this.dw_office}
end on

on w_office.destroy
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_office)
end on

type cb_1 from commandbutton within w_office
integer x = 23
integer y = 1236
integer width = 238
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update"
boolean default = true
end type

on clicked;int li_next_office_nr
string ls_office_sn
int li_count
dw_office.AcceptText()
IF IsNull(dw_office.GetItemString(dw_office.GetRow(),"office_sn")) THEN
	MessageBox("Update Error","Please enter a office Short Name!")
	Return
END IF	
IF IsNull(dw_office.GetItemstring(dw_office.GetRow(),"office_name")) THEN
	MessageBox("Update Error","Please enter a office Full Name (Blue Line)!")
	Return
END IF	
ls_office_sn = dw_office.GetItemString(dw_office.GetRow(),"office_sn")
SELECT count(*)
INTO :li_count
FROM OFFICES
WHERE OFFICE_SN = :ls_office_sn;
IF (ll_parm = 0 AND li_count = 1) THEN
	MessageBox("Duplicate","You are creating a duplicate office!~r~nThis is not allowed")
	Return
END IF

IF ll_parm = 0 THEN
	SELECT max(OFFICE_NR)
	INTO :li_next_office_nr
	FROM OFFICES;
	IF IsNull(li_next_office_nr) THEN 
		dw_office.SetItem(1,"office_nr",1)
	ELSE
		dw_office.SetItem(1,"office_nr",li_next_office_nr + 1)
	END IF
END IF
IF dw_office.Update() = 1 THEN
	commit;
	Close(parent)
ELSE
	rollback;
END IF
end on

type cb_2 from commandbutton within w_office
integer x = 279
integer y = 1236
integer width = 238
integer height = 80
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

type dw_office from uo_datawindow within w_office
integer x = 18
integer y = 16
integer width = 1243
integer height = 1184
integer taborder = 30
string dataobject = "dw_office"
boolean border = false
end type

