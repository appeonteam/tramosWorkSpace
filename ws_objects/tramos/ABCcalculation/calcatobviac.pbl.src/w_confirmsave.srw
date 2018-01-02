$PBExportHeader$w_confirmsave.srw
forward
global type w_confirmsave from mt_w_response
end type
type cb_5 from mt_u_commandbutton within w_confirmsave
end type
type cb_4 from mt_u_commandbutton within w_confirmsave
end type
type cb_3 from mt_u_commandbutton within w_confirmsave
end type
type cb_2 from mt_u_commandbutton within w_confirmsave
end type
type cb_1 from mt_u_commandbutton within w_confirmsave
end type
type st_detail from mt_u_statictext within w_confirmsave
end type
end forward

global type w_confirmsave from mt_w_response
integer width = 1810
integer height = 400
string title = ""
boolean controlmenu = false
long backcolor = 32304364
event ue_close ( )
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
st_detail st_detail
end type
global w_confirmsave w_confirmsave

type variables
n_confirmsave  invo_confirm
end variables

forward prototypes
public function integer wf_init (n_confirmsave ano_confirm)
end prototypes

event ue_close();closewithreturn(this,invo_confirm)
end event

public function integer wf_init (n_confirmsave ano_confirm);

invo_confirm = create n_confirmsave
invo_confirm = ano_confirm

this.title = invo_confirm.is_confirm_title
this.st_detail.text = invo_confirm.is_prompt_text

if invo_confirm.is_cmdbtn_caption1 <> "" then
	cb_1.text = invo_confirm.is_cmdbtn_caption1
else
	cb_1.visible=false
end if

if invo_confirm.is_cmdbtn_caption2 <> "" then
	cb_2.text = invo_confirm.is_cmdbtn_caption2
else
	cb_2.visible=false
end if

if invo_confirm.is_cmdbtn_caption3 <> "" then
	cb_3.text = invo_confirm.is_cmdbtn_caption3
else
	cb_3.visible=false
end if

if invo_confirm.is_cmdbtn_caption4 <> "" then
	cb_4.text = invo_confirm.is_cmdbtn_caption4
else
	cb_4.visible=false
end if

if invo_confirm.is_cmdbtn_caption5 <> "" then
	cb_5.text = invo_confirm.is_cmdbtn_caption5
else
	cb_5.visible=false
end if

return 1
end function

on w_confirmsave.create
int iCurrent
call super::create
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_detail=create st_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_5
this.Control[iCurrent+2]=this.cb_4
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.st_detail
end on

on w_confirmsave.destroy
call super::destroy
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_detail)
end on

event open;call super::open;n_confirmsave lnv_confirm
lnv_confirm = message.powerobjectparm
wf_init(lnv_confirm)
end event

type cb_5 from mt_u_commandbutton within w_confirmsave
integer x = 1431
integer y = 208
integer taborder = 50
end type

event clicked;call super::clicked;invo_confirm.of_closewindow(cb_5,5,false)
end event

type cb_4 from mt_u_commandbutton within w_confirmsave
integer x = 1079
integer y = 208
integer taborder = 40
end type

event clicked;call super::clicked;invo_confirm.of_closewindow(cb_4,4,true)
end event

type cb_3 from mt_u_commandbutton within w_confirmsave
integer x = 727
integer y = 208
integer taborder = 30
boolean default = true
end type

event clicked;call super::clicked;invo_confirm.of_closewindow(cb_3,3,false)
end event

type cb_2 from mt_u_commandbutton within w_confirmsave
integer x = 375
integer y = 208
integer taborder = 20
end type

event clicked;call super::clicked;invo_confirm.of_closewindow(cb_2,2,true)
end event

type cb_1 from mt_u_commandbutton within w_confirmsave
integer x = 23
integer y = 208
integer taborder = 10
end type

event clicked;call super::clicked;invo_confirm.of_closewindow(cb_1,1,false)
end event

type st_detail from mt_u_statictext within w_confirmsave
integer x = 32
integer y = 32
integer width = 1737
integer height = 148
long backcolor = 32304364
alignment alignment = center!
end type

