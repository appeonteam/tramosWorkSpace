$PBExportHeader$w_capture_errormessage.srw
forward
global type w_capture_errormessage from mt_w_popupbox
end type
type cb_detail from commandbutton within w_capture_errormessage
end type
type dw_errormessage from mt_u_datawindow within w_capture_errormessage
end type
end forward

global type w_capture_errormessage from mt_w_popupbox
integer width = 2240
integer height = 2048
string title = "Capture Messages"
string is_windowstyle = "error"
cb_detail cb_detail
dw_errormessage dw_errormessage
end type
global w_capture_errormessage w_capture_errormessage

type variables
mt_n_datastore 	ids_errorMessage
end variables

on w_capture_errormessage.create
int iCurrent
call super::create
this.cb_detail=create cb_detail
this.dw_errormessage=create dw_errormessage
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_detail
this.Control[iCurrent+2]=this.dw_errormessage
end on

on w_capture_errormessage.destroy
call super::destroy
destroy(this.cb_detail)
destroy(this.dw_errormessage)
end on

event open;call super::open;ids_errormessage = create mt_n_datastore
ids_errorMessage = message.PowerObjectParm

ids_errormessage.sharedata(dw_errormessage)
end event

event closequery;call super::closequery;ids_errormessage.reset( )

//return 0
end event

event resize;call super::resize;dw_errormessage.width = This.width - 75
dw_errormessage.height = This.height - 400
cb_detail.y = newheight - (cb_detail.height + 20)
end event

type r_styledborder from mt_w_popupbox`r_styledborder within w_capture_errormessage
end type

type p_close from mt_w_popupbox`p_close within w_capture_errormessage
end type

type p_refresh from mt_w_popupbox`p_refresh within w_capture_errormessage
end type

type st_title from mt_w_popupbox`st_title within w_capture_errormessage
end type

type st_spacer from mt_w_popupbox`st_spacer within w_capture_errormessage
end type

type cb_detail from commandbutton within w_capture_errormessage
integer x = 14
integer y = 1900
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Detail >>"
end type

event clicked;
if dw_errormessage.dataObject = "d_ex_tb_errorMessages" then
	dw_errormessage.dataObject = "d_ex_tb_user_errorMessages"
	ids_errormessage.sharedata( dw_errormessage )
	cb_detail.text = "Detail >>"
else
	dw_errormessage.dataObject = "d_ex_tb_errorMessages"
	ids_errormessage.sharedata( dw_errormessage )
	cb_detail.text = "Detail <<"
end if

n_service_manager  lnv_myMgr
n_dw_Style_Service   lnv_style
lnv_myMgr.of_loadservice( lnv_style, "n_dw_Style_Service")
lnv_style.of_dwlistformater( dw_errormessage )

end event

type dw_errormessage from mt_u_datawindow within w_capture_errormessage
integer x = 18
integer y = 136
integer width = 2208
integer height = 1728
integer taborder = 10
string dataobject = "d_ex_tb_user_errormessages"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;n_service_manager  lnv_myMgr

n_dw_Style_Service   lnv_style

lnv_myMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_errormessage )


end event

