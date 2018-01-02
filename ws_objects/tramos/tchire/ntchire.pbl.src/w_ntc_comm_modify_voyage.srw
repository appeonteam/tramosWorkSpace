$PBExportHeader$w_ntc_comm_modify_voyage.srw
$PBExportComments$Used to show TC comm. by vessel/contract that will get voyagenr updated.
forward
global type w_ntc_comm_modify_voyage from mt_w_response
end type
type cb_print from commandbutton within w_ntc_comm_modify_voyage
end type
type dw_commissions from u_datagrid within w_ntc_comm_modify_voyage
end type
type st_1 from statictext within w_ntc_comm_modify_voyage
end type
type st_2 from statictext within w_ntc_comm_modify_voyage
end type
type dw_print from datawindow within w_ntc_comm_modify_voyage
end type
type cb_ok from commandbutton within w_ntc_comm_modify_voyage
end type
end forward

global type w_ntc_comm_modify_voyage from mt_w_response
integer width = 2587
integer height = 1712
string title = "TC Commissions (modify voyage number)"
boolean controlmenu = false
cb_print cb_print
dw_commissions dw_commissions
st_1 st_1
st_2 st_2
dw_print dw_print
cb_ok cb_ok
end type
global w_ntc_comm_modify_voyage w_ntc_comm_modify_voyage

type variables
n_ds	ids_data
n_service_manager inv_servicemgr
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_ntc_comm_modify_voyage
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_ntc_comm_modify_voyage.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_commissions=create dw_commissions
this.st_1=create st_1
this.st_2=create st_2
this.dw_print=create dw_print
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_commissions
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_print
this.Control[iCurrent+6]=this.cb_ok
end on

on w_ntc_comm_modify_voyage.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.dw_commissions)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_print)
destroy(this.cb_ok)
end on

event open;n_dw_style_service   lnv_style
string ls_vessel_ref_nr,ls_voyage

ids_data = create n_ds
ids_data = message.PowerObjectParm

ids_data.shareData(dw_commissions )
ids_data.sharedata(dw_print)
inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_commissions, false)

ls_vessel_ref_nr = dw_commissions.getitemstring(1,'show_vessel_ref_nr')
ls_voyage = dw_commissions.getitemstring(1,'show_voyage_nr')
if isnull(ls_vessel_ref_nr) then ls_vessel_ref_nr = ''
if isnull(ls_voyage) then ls_voyage = ''
st_1.text = 'Following Commissions will have voyage number changed to:'+"V"+ls_vessel_ref_nr+" / T"+ls_voyage

end event

event close;dw_commissions.shareDataOff()
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_ntc_comm_modify_voyage
end type

type cb_print from commandbutton within w_ntc_comm_modify_voyage
integer x = 2199
integer y = 1516
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
boolean default = true
end type

event clicked;dw_print.print()
end event

type dw_commissions from u_datagrid within w_ntc_comm_modify_voyage
integer x = 37
integer y = 112
integer width = 2496
integer height = 1312
integer taborder = 10
string dataobject = "d_ntc_comm_modify_voyage"
boolean border = false
end type

type st_1 from statictext within w_ntc_comm_modify_voyage
integer x = 18
integer y = 32
integer width = 2496
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Following Commissions will have voyage number changed to:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_ntc_comm_modify_voyage
integer x = 18
integer y = 1440
integer width = 2267
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "Please remember to change voyage number in AX"
boolean focusrectangle = false
end type

type dw_print from datawindow within w_ntc_comm_modify_voyage
boolean visible = false
integer x = 37
integer y = 1584
integer width = 110
integer height = 64
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_tb_ntc_comm_modify_voyage_print"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_ok from commandbutton within w_ntc_comm_modify_voyage
integer x = 1852
integer y = 1516
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;long		ll_rows, ll_row
string		ls_voyage

ls_voyage = dw_commissions.getItemString(1, "show_voyage_nr")
ll_rows = dw_commissions.rowCount()

for ll_row = 1 to ll_rows
	dw_commissions.setItem(ll_row, "voyage_nr", ls_voyage)
next

if dw_commissions.update() = 1 then
	commit;
else
	MessageBox("Update Error", "Application failed when updating TC Commissions~n~r~n~r" +&
			"SQLErrText="+sqlca.sqlerrtext)
	rollback;
end if
close(parent)
end event

