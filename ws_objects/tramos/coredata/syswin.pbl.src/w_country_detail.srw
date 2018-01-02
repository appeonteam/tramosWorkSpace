$PBExportHeader$w_country_detail.srw
$PBExportComments$Used for displaying country details
forward
global type w_country_detail from window
end type
type cb_cancel from commandbutton within w_country_detail
end type
type cb_update from commandbutton within w_country_detail
end type
type dw_country_detail from datawindow within w_country_detail
end type
end forward

global type w_country_detail from window
integer width = 1541
integer height = 732
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
long backcolor = 67108864
event ue_validate_country_detail ( )
cb_cancel cb_cancel
cb_update cb_update
dw_country_detail dw_country_detail
end type
global w_country_detail w_country_detail

type variables
Boolean ib_new_row
Long il_country_id

end variables

on w_country_detail.create
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.dw_country_detail=create dw_country_detail
this.Control[]={this.cb_cancel,&
this.cb_update,&
this.dw_country_detail}
end on

on w_country_detail.destroy
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.dw_country_detail)
end on

event open;il_country_id = message.doubleParm
dw_country_detail.SetTransObject(SQLCA)

IF IsNull(il_country_id) or il_country_id = 0 THEN
	dw_country_detail.InsertRow(0)
	ib_new_row = True
	
	this.title = "Country - NEW"
ELSE
	dw_country_detail.Retrieve(il_country_id)
	this.title = "Country - MODIFY"
	ib_new_row = false
END IF	

If uo_global.ii_access_level < 2 Then cb_update.enabled = false

dw_country_detail.SetFocus()
end event

type cb_cancel from commandbutton within w_country_detail
integer x = 347
integer y = 496
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

type cb_update from commandbutton within w_country_detail
integer x = 73
integer y = 496
integer width = 238
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update"
boolean default = true
end type

event clicked;String ls_name, ls_namesn2, ls_namesn3, ls_country
Long ll_len, ll_tmp

//dw_country_detail.Accepttext()

// Check if dataupdate succesful
IF dw_country_detail.Update() = 1 THEN
	COMMIT;
	Open(w_updated)
	
//	Destroy ds_country
	Close(parent)
ELSE
	ROLLBACK;
//	Messagebox("Error message","Update NOT succesful.")
	
//	Destroy ds_country
END IF


end event

type dw_country_detail from datawindow within w_country_detail
event ue_validate_country_detail ( )
integer x = 69
integer y = 40
integer width = 1399
integer height = 424
integer taborder = 10
string title = "none"
string dataobject = "d_country_detail"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_name,ls_country,ls_country_name,ls_null,ls_country_namesn2,ls_country_namesn3
Long ll_len, ll_tmp
Long ll_country_name,ll_country_sn2,ll_country_sn3

//This.accepttext()

ls_name = dw_country_detail.GetColumnName()

SetNull(ls_country_name)
SetNull(ls_country_namesn2)
SetNull(ls_country_namesn3)

CHOOSE CASE ls_name
	CASE "country_name"
				SELECT COUNTRY.COUNTRY_NAME
				INTO :ls_country_name
				FROM COUNTRY
				WHERE COUNTRY.COUNTRY_NAME = :data;
				
			   If Not IsNull(ls_country_name) then
					Messagebox("Error message","The countryname already exists.")
					Return 1				
				End if
				
				If len(data)<1 then
					Messagebox("Error message","This field is mandatory.")
					Return 1
				End if	
				
	CASE "country_sn2"
				SELECT COUNTRY.COUNTRY_SN2
				INTO :ls_country_namesn2
				FROM COUNTRY
				WHERE COUNTRY.COUNTRY_SN2 = :data;
				
				If len(data)<>2 then
					Messagebox("Error message","This field should be filled out with exactly 2 characters.")
					Return 1
				End if
				
				If Not IsNull(ls_country_namesn2) then
					Messagebox("Error message","The short countryname(2) already exists.")
					Return 1				
				End if
				
	CASE "country_sn3"
				SELECT COUNTRY.COUNTRY_SN3
				INTO :ls_country_namesn3
				FROM COUNTRY
				WHERE COUNTRY.COUNTRY_SN3 = :data;
							
				If Not IsNull(ls_country_namesn3) then
					Messagebox("Error message","The short countryname(3) already exists.")
					Return 1
				End if
				
				If len(data)<>3 then
					Messagebox("Error message","This field should be filled out with exactly 3 characters.")
					Return 1
				End if
				
END CHOOSE
end event

event itemerror;Return 1
end event

