$PBExportHeader$w_admin.srw
forward
global type w_admin from w_events_pcgroup
end type
type st_reasonsfailed from statictext within w_admin
end type
type uo_pcgroup from u_pcgroup within w_admin
end type
type st_vesseldataiceclass from statictext within w_admin
end type
type cb_delete from mt_u_commandbutton within w_admin
end type
type cb_new from mt_u_commandbutton within w_admin
end type
type cb_save from mt_u_commandbutton within w_admin
end type
type st_vesseldatastatus from statictext within w_admin
end type
type st_vesseldatatype from statictext within w_admin
end type
type st_vesseldatahull from statictext within w_admin
end type
type st_vesseldatacoils from statictext within w_admin
end type
type st_vesseldatacoating from statictext within w_admin
end type
type st_imo from statictext within w_admin
end type
type st_cpstatus from statictext within w_admin
end type
type st_cargotype from statictext within w_admin
end type
type st_cargograde from statictext within w_admin
end type
type ddlb_admin from dropdownlistbox within w_admin
end type
type dw_admin from datawindow within w_admin
end type
end forward

global type w_admin from w_events_pcgroup
integer width = 1138
integer height = 1176
string title = "Admin"
st_reasonsfailed st_reasonsfailed
uo_pcgroup uo_pcgroup
st_vesseldataiceclass st_vesseldataiceclass
cb_delete cb_delete
cb_new cb_new
cb_save cb_save
st_vesseldatastatus st_vesseldatastatus
st_vesseldatatype st_vesseldatatype
st_vesseldatahull st_vesseldatahull
st_vesseldatacoils st_vesseldatacoils
st_vesseldatacoating st_vesseldatacoating
st_imo st_imo
st_cpstatus st_cpstatus
st_cargotype st_cargotype
st_cargograde st_cargograde
ddlb_admin ddlb_admin
dw_admin dw_admin
end type
global w_admin w_admin

type variables
integer 	ii_pcgroup, ii_index
end variables

on w_admin.create
int iCurrent
call super::create
this.st_reasonsfailed=create st_reasonsfailed
this.uo_pcgroup=create uo_pcgroup
this.st_vesseldataiceclass=create st_vesseldataiceclass
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.cb_save=create cb_save
this.st_vesseldatastatus=create st_vesseldatastatus
this.st_vesseldatatype=create st_vesseldatatype
this.st_vesseldatahull=create st_vesseldatahull
this.st_vesseldatacoils=create st_vesseldatacoils
this.st_vesseldatacoating=create st_vesseldatacoating
this.st_imo=create st_imo
this.st_cpstatus=create st_cpstatus
this.st_cargotype=create st_cargotype
this.st_cargograde=create st_cargograde
this.ddlb_admin=create ddlb_admin
this.dw_admin=create dw_admin
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_reasonsfailed
this.Control[iCurrent+2]=this.uo_pcgroup
this.Control[iCurrent+3]=this.st_vesseldataiceclass
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.cb_new
this.Control[iCurrent+6]=this.cb_save
this.Control[iCurrent+7]=this.st_vesseldatastatus
this.Control[iCurrent+8]=this.st_vesseldatatype
this.Control[iCurrent+9]=this.st_vesseldatahull
this.Control[iCurrent+10]=this.st_vesseldatacoils
this.Control[iCurrent+11]=this.st_vesseldatacoating
this.Control[iCurrent+12]=this.st_imo
this.Control[iCurrent+13]=this.st_cpstatus
this.Control[iCurrent+14]=this.st_cargotype
this.Control[iCurrent+15]=this.st_cargograde
this.Control[iCurrent+16]=this.ddlb_admin
this.Control[iCurrent+17]=this.dw_admin
end on

on w_admin.destroy
call super::destroy
destroy(this.st_reasonsfailed)
destroy(this.uo_pcgroup)
destroy(this.st_vesseldataiceclass)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.cb_save)
destroy(this.st_vesseldatastatus)
destroy(this.st_vesseldatatype)
destroy(this.st_vesseldatahull)
destroy(this.st_vesseldatacoils)
destroy(this.st_vesseldatacoating)
destroy(this.st_imo)
destroy(this.st_cpstatus)
destroy(this.st_cargotype)
destroy(this.st_cargograde)
destroy(this.ddlb_admin)
destroy(this.dw_admin)
end on

event open;ii_pcgroup=uo_pcgroup.uf_getpcgroup( )


if ii_pcgroup<0 then
	this.Post Event ue_postopen()
else

end if
	
	
end event

event ue_pcgroupchanged;call super::ue_pcgroupchanged;ii_pcgroup=ai_PCGroupID

st_cargograde.visible = false
st_cargotype.visible = false
st_cpstatus.visible = false
st_vesseldatacoating.visible = false
st_vesseldatacoils.visible = false
st_vesseldatahull.visible = false
st_vesseldatastatus.visible = false
st_vesseldatatype.visible = false
st_vesseldataiceclass.visible = false
st_IMO.visible = false
dw_admin.visible = false
dw_admin.reset()
cb_new.visible = false
cb_save.visible = false
cb_delete.visible = false
ddlb_admin.selectitem( 0)
return 0
end event

type st_reasonsfailed from statictext within w_admin
boolean visible = false
integer x = 32
integer y = 312
integer width = 1010
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reasons Failed"
boolean focusrectangle = false
end type

type uo_pcgroup from u_pcgroup within w_admin
integer x = 23
integer y = 16
integer taborder = 20
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type st_vesseldataiceclass from statictext within w_admin
boolean visible = false
integer x = 32
integer y = 312
integer width = 1010
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Data Ice Class"
boolean focusrectangle = false
end type

type cb_delete from mt_u_commandbutton within w_admin
boolean visible = false
integer x = 741
integer y = 952
integer taborder = 70
string facename = "Arial"
string text = "&Delete"
end type

event clicked;long	ll_row

ll_row = dw_admin.getRow()
if ll_row < 1 then return


if MessageBox("Confirmation", "Are you sure you you want to delete?", question!, YesNo!,2) = 1 then 
	if dw_admin.deleterow(ll_row) = 1 then
		dw_admin.update( )
		commit;	
		if ii_index = 2 then
			dw_admin.retrieve(ii_pcgroup)
		else
			dw_admin.retrieve()
		end if
		return 1
	else
		rollback;
		MessageBox("Delete Error", "Error deleting.")
		return -1
	end if
end if

end event

type cb_new from mt_u_commandbutton within w_admin
boolean visible = false
integer x = 46
integer y = 952
integer taborder = 50
string facename = "Arial"
string text = "&New"
end type

event clicked;call super::clicked;int			li_row

li_row = dw_admin.insertrow( 0)

if ii_index = 2  then
	dw_admin.setitem(li_row,"pcgroup_id",ii_pcgroup)
end if

dw_admin.setfocus( )
dw_admin.scrolltorow(li_row)
end event

type cb_save from mt_u_commandbutton within w_admin
boolean visible = false
integer x = 393
integer y = 952
integer taborder = 60
string facename = "Arial"
string text = "&Save All"
end type

event clicked;call super::clicked;int			li_x

if  dw_admin.rowcount( ) <> 0 then
	dw_admin.acceptText()
	if dw_admin.update() = 1 then
		commit;
		if ii_index = 2  then
			dw_admin.retrieve(ii_pcgroup)
		else
			dw_admin.retrieve()
		end if
	else
		rollback;
		MessageBox("Update Error", "Error updating.")
		return -1
	end if
end if
end event

type st_vesseldatastatus from statictext within w_admin
boolean visible = false
integer x = 32
integer y = 312
integer width = 1010
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Data Status"
boolean focusrectangle = false
end type

type st_vesseldatatype from statictext within w_admin
boolean visible = false
integer x = 32
integer y = 312
integer width = 1010
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Data Type"
boolean focusrectangle = false
end type

type st_vesseldatahull from statictext within w_admin
boolean visible = false
integer x = 32
integer y = 312
integer width = 1010
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Data Hull"
boolean focusrectangle = false
end type

type st_vesseldatacoils from statictext within w_admin
boolean visible = false
integer x = 32
integer y = 312
integer width = 1010
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Data Coils"
boolean focusrectangle = false
end type

type st_vesseldatacoating from statictext within w_admin
boolean visible = false
integer x = 32
integer y = 312
integer width = 1010
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Data Coating"
boolean focusrectangle = false
end type

type st_imo from statictext within w_admin
boolean visible = false
integer x = 32
integer y = 312
integer width = 1010
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "IMO"
boolean focusrectangle = false
end type

type st_cpstatus from statictext within w_admin
boolean visible = false
integer x = 32
integer y = 312
integer width = 1010
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "C/P Status"
boolean focusrectangle = false
end type

type st_cargotype from statictext within w_admin
boolean visible = false
integer x = 32
integer y = 312
integer width = 1010
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cargo type"
boolean focusrectangle = false
end type

type st_cargograde from statictext within w_admin
boolean visible = false
integer x = 32
integer y = 312
integer width = 1010
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cargo grade"
boolean focusrectangle = false
end type

type ddlb_admin from dropdownlistbox within w_admin
integer x = 23
integer y = 196
integer width = 1056
integer height = 592
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
boolean hscrollbar = true
boolean vscrollbar = true
string item[] = {"--- Choose a Table ---","Cargo grade","Contract type","Failed Reasons","Vessel data coating","Vessel data coils","Vessel data hull","Vessel data ice class","Vessel data type","Vessel data status","IMO Position"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;ii_index = index

dw_admin.visible = true

if ii_pcgroup < 0 then
	MessageBox("Validation Error", "Please select a Profitcenter Group.")
	uo_pcgroup.post setFocus()
	return
end if

cb_delete.enabled=true

if index = 2 then 
	st_cargograde.visible = true
	dw_admin.dataobject = "d_cleaningtype" //PC
elseif index = 3 then
	st_cargotype.visible = true
	dw_admin.dataobject = "d_dddw_cargotype"
elseif index = 4 then
	st_reasonsfailed.visible = true
	dw_admin.dataobject = "d_sq_tb_f_admin_reasons_failed"	
	cb_delete.enabled=false
elseif index = 5 then
	st_vesseldatacoating.visible = true
	dw_admin.dataobject = "d_vesseldatacoating"
elseif index = 6 then
	st_vesseldatacoils.visible = true
	dw_admin.dataobject = "d_vesseldatacoils"
elseif index = 7 then
	st_vesseldatahull.visible = true
	dw_admin.dataobject = "d_vesseldatahull"
elseif index =8 then
	st_vesseldataiceclass.visible = true
	dw_admin.dataobject = "d_vesseldataiceclass"
elseif index = 9 then
	st_vesseldatatype.visible = true
	dw_admin.dataobject = "d_vesseldatatype"
elseif index = 10 then
	st_vesseldatastatus.visible = true
	dw_admin.dataobject = "d_vesseldatastatus"
elseif index=11 then
	st_IMO.visible = true
	dw_admin.dataobject = "d_dddw_imo"
end if

dw_admin.settransobject(SQLCA)

if index = 2 then
	dw_admin.retrieve(ii_pcgroup)
elseif index=1 then
	dw_admin.dataobject =""
else
	dw_admin.retrieve()
end if

cb_new.visible = true
cb_save.visible = true
cb_delete.visible = true
end event

type dw_admin from datawindow within w_admin
boolean visible = false
integer x = 23
integer y = 388
integer width = 1056
integer height = 544
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_cleaningtype"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	post event rowfocuschanged( row )
end if
end event

event rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)	
end if
end event

