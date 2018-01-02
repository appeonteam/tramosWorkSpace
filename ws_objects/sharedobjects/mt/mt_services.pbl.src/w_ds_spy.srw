$PBExportHeader$w_ds_spy.srw
forward
global type w_ds_spy from mt_w_master
end type
type cb_print from mt_u_commandbutton within w_ds_spy
end type
type cb_saveas from mt_u_commandbutton within w_ds_spy
end type
type st_content from mt_u_statictext within w_ds_spy
end type
type st_colstatus from mt_u_statictext within w_ds_spy
end type
type st_rowstatus from mt_u_statictext within w_ds_spy
end type
type st_content_t from mt_u_statictext within w_ds_spy
end type
type st_colstatus_t from mt_u_statictext within w_ds_spy
end type
type st_rowstatus_t from mt_u_statictext within w_ds_spy
end type
type dw_spydata from mt_u_datawindow within w_ds_spy
end type
end forward

global type w_ds_spy from mt_w_master
integer width = 3104
integer height = 1460
event ue_postopen ( ref n_ds_spy_parameters anv_parm )
cb_print cb_print
cb_saveas cb_saveas
st_content st_content
st_colstatus st_colstatus
st_rowstatus st_rowstatus
st_content_t st_content_t
st_colstatus_t st_colstatus_t
st_rowstatus_t st_rowstatus_t
dw_spydata dw_spydata
end type
global w_ds_spy w_ds_spy

type variables
n_ds_spy_parameters inv_parm

string is_msg
end variables

forward prototypes
public subroutine wf_updatedetail (long al_row)
end prototypes

event ue_postopen(ref n_ds_spy_parameters anv_parm);dw_spydata.setfullstate(anv_parm.ibl_data)

this.title = string(today()) + " " + string(now()) + " : " + anv_parm.is_dataObject

wf_updateDetail(0)


//n_servicemanager lnv_myMgr
//n_dwStyleService   lnv_style
//lnv_myMgr.of_loadservice( lnv_style, "n_dwStyleService")
//lnv_style.of_dwlistformater( dw_spydata  )
end event

public subroutine wf_updatedetail (long al_row);string ls_colcount, ls_msg, ls_content
long ll_row, ll_col, ll_cols

if al_row < 1 then return

choose case dw_spydata.getItemStatus( al_row, 0, primary!)
	case New!
		st_rowstatus.text = "Row #"+string(al_row) + "Status = New"
	case NewModified!
		st_rowstatus.text ="Row #"+string(al_row) + "Status = NewModified"
	case DataModified!
		st_rowstatus.text = "Row #"+string(al_row) + "Status = DataModified"
	case NotModified!
		st_rowstatus.text = "Row #"+string(al_row) + "Status = NotModified"
	case else
		st_rowstatus.text = "Row #"+string(al_row) + "Status = Error"
end choose		

choose case dw_spydata.getItemStatus( al_row, dw_spydata.getColumn(), primary!)
	case New!
		st_rowstatus.text = "Column #"+string(dw_spydata.getColumn()) + "Status = New"
	case NewModified!
		st_rowstatus.text = "Column #"+string(dw_spydata.getColumn()) + "Status = NewModified"
	case DataModified!
		st_rowstatus.text = "Column #"+string(dw_spydata.getColumn()) + "Status = DataModified"
	case NotModified!
		st_rowstatus.text = "Column #"+string(dw_spydata.getColumn()) + "Status = NotModified"
	case else
		st_rowstatus.text = "Column #"+string(dw_spydata.getColumn()) + "Status = Error"
end choose



ls_colcount = dw_spydata.Object.DataWindow.Column.Count
ll_cols = long(ls_colcount)
if ll_cols < 1 then return

is_msg = ""
for ll_col = 1 to ll_cols
	choose case mid(dw_spydata.describe("#"+string(ll_col)+".ColType"),1,4)
		case "char"
			ls_content = dw_spydata.getItemString(al_row, ll_col)
		case "date"
			ls_content =string(dw_spydata.getItemdatetime(al_row, ll_col))
		case else
			ls_content = string(dw_spydata.getItemnumber(al_row, ll_col))
	end choose
	if isNull(ls_content) then ls_content = "<NULL>"
	is_msg +="Field # "+string(ll_col, "00") + " (" + dw_spydata.Describe("#"+string(ll_col)+".dbName")+") = "+ls_content+"~r~n"
next

st_content.text=is_msg
end subroutine

on w_ds_spy.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_saveas=create cb_saveas
this.st_content=create st_content
this.st_colstatus=create st_colstatus
this.st_rowstatus=create st_rowstatus
this.st_content_t=create st_content_t
this.st_colstatus_t=create st_colstatus_t
this.st_rowstatus_t=create st_rowstatus_t
this.dw_spydata=create dw_spydata
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_saveas
this.Control[iCurrent+3]=this.st_content
this.Control[iCurrent+4]=this.st_colstatus
this.Control[iCurrent+5]=this.st_rowstatus
this.Control[iCurrent+6]=this.st_content_t
this.Control[iCurrent+7]=this.st_colstatus_t
this.Control[iCurrent+8]=this.st_rowstatus_t
this.Control[iCurrent+9]=this.dw_spydata
end on

on w_ds_spy.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_saveas)
destroy(this.st_content)
destroy(this.st_colstatus)
destroy(this.st_rowstatus)
destroy(this.st_content_t)
destroy(this.st_colstatus_t)
destroy(this.st_rowstatus_t)
destroy(this.dw_spydata)
end on

event open;call super::open;
inv_parm = message.powerobjectparm

//dw_spydata.setfullstate(lnv_parm.ibl_data)

this.post event ue_postOpen(inv_parm)


end event

event close;call super::close;


end event

event resize;call super::resize;long ll_height, ll_width


if newheight < 1200 then
	ll_height = 1200
	this.height = 1200
else 
	ll_height = newheight
end if

if newwidth < 1175 then
	ll_width = 1175
	this.width = 1175
else 
	ll_width = newwidth
end if

dw_spydata.height = ll_height - 350
st_content.height =  ll_height - 330 -  st_content.y

cb_saveas.y = ll_height - (cb_saveas.height + 20)
cb_print.y = ll_height - (cb_print.height + 20)


dw_spydata.width = ll_width - 1100
// cb_detail.y = newheight - (cb_detail.height + 20)
st_colstatus_t.x = ll_width - 1050
st_rowstatus_t.x = ll_width - 1050
st_content_t.x = ll_width - 1050
st_colstatus.x = ll_width - 990
st_rowstatus.x = ll_width - 990
st_content.x = ll_width - 990



	






end event

type cb_print from mt_u_commandbutton within w_ds_spy
integer x = 393
integer y = 1240
integer taborder = 20
string text = "Print"
end type

event clicked;call super::clicked;dw_spydata.print( )
end event

type cb_saveas from mt_u_commandbutton within w_ds_spy
integer x = 32
integer y = 1240
integer taborder = 20
string text = "Sa&ve As"
end type

event clicked;call super::clicked;dw_spydata.saveas("", XML!, true)
end event

type st_content from mt_u_statictext within w_ds_spy
integer x = 2144
integer y = 400
integer width = 901
integer height = 796
long backcolor = 16777215
boolean border = true
end type

event doubleclicked;call super::doubleclicked;::Clipboard(is_msg)
messagebox("detail",is_msg)


end event

type st_colstatus from mt_u_statictext within w_ds_spy
integer x = 2144
integer y = 244
integer width = 901
long backcolor = 16777215
boolean border = true
end type

type st_rowstatus from mt_u_statictext within w_ds_spy
integer x = 2144
integer y = 100
integer width = 901
long backcolor = 16777215
boolean border = true
end type

type st_content_t from mt_u_statictext within w_ds_spy
integer x = 2089
integer y = 324
integer width = 846
integer height = 76
string text = "Content by Column index:"
end type

type st_colstatus_t from mt_u_statictext within w_ds_spy
integer x = 2089
integer y = 180
string text = "Column Status:"
end type

type st_rowstatus_t from mt_u_statictext within w_ds_spy
integer x = 2089
integer y = 36
string text = "Row Status:"
end type

type dw_spydata from mt_u_datawindow within w_ds_spy
integer x = 14
integer y = 28
integer width = 2030
integer height = 1172
integer taborder = 10
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;wf_updateDetail(row)

This.SelectRow(0, False)
This.SelectRow(row, True)

//if dwo.name="sqlsyntax" then
//	::Clipboard(getitemstring(row,"sqlsyntax"))
//	messagebox("Info","Content added to clipboard")
//end if
end event

