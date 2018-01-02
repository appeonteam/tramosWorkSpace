HA$PBExportHeader$w_admin.srw
forward
global type w_admin from window
end type
type cb_Voy from commandbutton within w_admin
end type
type cb_portmatch from commandbutton within w_admin
end type
type cbx_active from checkbox within w_admin
end type
type cbx_tperf from checkbox within w_admin
end type
type cb_exp from commandbutton within w_admin
end type
type cb_reset from commandbutton within w_admin
end type
type cb_setpc from commandbutton within w_admin
end type
type dw_pc from datawindow within w_admin
end type
type cb_tphc from commandbutton within w_admin
end type
type dw_tphc from datawindow within w_admin
end type
type dw_users from datawindow within w_admin
end type
type dw_ports from datawindow within w_admin
end type
type dw_vsl from datawindow within w_admin
end type
type cb_refresh from commandbutton within w_admin
end type
type cb_del from commandbutton within w_admin
end type
type cb_ack from commandbutton within w_admin
end type
type dw_syserr from datawindow within w_admin
end type
type ln_1 from line within w_admin
end type
type ln_2 from line within w_admin
end type
end forward

global type w_admin from window
integer width = 4402
integer height = 2044
boolean titlebar = true
string title = "System Administration"
boolean controlmenu = true
long backcolor = 67108864
string icon = "Function!"
boolean center = true
cb_Voy cb_Voy
cb_portmatch cb_portmatch
cbx_active cbx_active
cbx_tperf cbx_tperf
cb_exp cb_exp
cb_reset cb_reset
cb_setpc cb_setpc
dw_pc dw_pc
cb_tphc cb_tphc
dw_tphc dw_tphc
dw_users dw_users
dw_ports dw_ports
dw_vsl dw_vsl
cb_refresh cb_refresh
cb_del cb_del
cb_ack cb_ack
dw_syserr dw_syserr
ln_1 ln_1
ln_2 ln_2
end type
global w_admin w_admin

type variables
long il_CurRow

integer ii_count, ii_loop
end variables

on w_admin.create
this.cb_Voy=create cb_Voy
this.cb_portmatch=create cb_portmatch
this.cbx_active=create cbx_active
this.cbx_tperf=create cbx_tperf
this.cb_exp=create cb_exp
this.cb_reset=create cb_reset
this.cb_setpc=create cb_setpc
this.dw_pc=create dw_pc
this.cb_tphc=create cb_tphc
this.dw_tphc=create dw_tphc
this.dw_users=create dw_users
this.dw_ports=create dw_ports
this.dw_vsl=create dw_vsl
this.cb_refresh=create cb_refresh
this.cb_del=create cb_del
this.cb_ack=create cb_ack
this.dw_syserr=create dw_syserr
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.cb_Voy,&
this.cb_portmatch,&
this.cbx_active,&
this.cbx_tperf,&
this.cb_exp,&
this.cb_reset,&
this.cb_setpc,&
this.dw_pc,&
this.cb_tphc,&
this.dw_tphc,&
this.dw_users,&
this.dw_ports,&
this.dw_vsl,&
this.cb_refresh,&
this.cb_del,&
this.cb_ack,&
this.dw_syserr,&
this.ln_1,&
this.ln_2}
end on

on w_admin.destroy
destroy(this.cb_Voy)
destroy(this.cb_portmatch)
destroy(this.cbx_active)
destroy(this.cbx_tperf)
destroy(this.cb_exp)
destroy(this.cb_reset)
destroy(this.cb_setpc)
destroy(this.dw_pc)
destroy(this.cb_tphc)
destroy(this.dw_tphc)
destroy(this.dw_users)
destroy(this.dw_ports)
destroy(this.dw_vsl)
destroy(this.cb_refresh)
destroy(this.cb_del)
destroy(this.cb_ack)
destroy(this.dw_syserr)
destroy(this.ln_1)
destroy(this.ln_2)
end on

event open;

dw_syserr.settransobject( SQLCA)
dw_syserr.retrieve( )

dw_vsl.settransobject( SQLCA)
dw_vsl.retrieve( )

dw_ports.settransobject( SQLCA)
dw_ports.retrieve( )

dw_users.settransobject( SQLCA)
dw_users.retrieve( )

dw_tphc.settransobject( SQLCA)
dw_tphc.retrieve( )

dw_pc.settransobject( SQLCA)
ii_count = dw_pc.retrieve( )
dw_pc.selectrow(0, False)
For ii_loop = 1 to ii_count
	If dw_pc.getitemnumber( ii_loop, "PC_NR") = g_userinfo.pc_num then 
		dw_pc.selectrow( ii_loop, True)
		dw_pc.scrolltorow( ii_loop)
	End If			
Next 

cb_setpc.Enabled = False

If g_userinfo.access = 0 then
	cb_ack.Enabled = False
	cb_Del.Enabled = False
	cb_exp.Enabled = False
	cb_reset.Enabled = False
	cb_tphc.Enabled = False
End If
end event

event key;
If Key = KeyF1! then f_LaunchWiki("Office%20Program.aspx")
end event

type cb_Voy from commandbutton within w_admin
integer x = 2011
integer y = 1872
integer width = 672
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Convert Voyage Numbers"
end type

event clicked;
Open(w_voyconvert)
end event

type cb_portmatch from commandbutton within w_admin
integer x = 2688
integer y = 1152
integer width = 786
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Match Custom Ports..."
end type

event clicked;
Open(w_CustomPorts)
end event

type cbx_active from checkbox within w_admin
integer x = 1280
integer y = 1872
integer width = 521
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show InActive"
end type

event clicked;String ls_Filter

If cbx_tperf.checked then ls_Filter = "(voycount > 0)"
If Not This.checked then 
	if Len(ls_Filter) > 0 then ls_Filter += " and "
	ls_Filter += "(active = 1)"
End If
dw_vsl.SetFilter(ls_Filter)
dw_vsl.Filter( )
dw_vsl.Sort()


end event

type cbx_tperf from checkbox within w_admin
integer x = 768
integer y = 1872
integer width = 366
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "T-Perf Only"
end type

event clicked;String ls_Filter

If This.checked then ls_Filter = "(voycount > 0)"
If not cbx_Active.checked then 
	if Len(ls_Filter) > 0 then ls_Filter += " and "
	ls_Filter += "(active = 1)"
End If
dw_vsl.SetFilter(ls_Filter)
dw_vsl.Filter( )
dw_vsl.Sort()
end event

type cb_exp from commandbutton within w_admin
integer x = 475
integer y = 512
integer width = 457
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Export"
end type

event clicked;
dw_syserr.saveas( )
end event

type cb_reset from commandbutton within w_admin
integer x = 37
integer y = 1872
integer width = 512
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Erase All Ver"
end type

event clicked;

If MessageBox("Confirm Reset", "Erase T-Perf Version for all vessels?", Question!, YesNo!) = 2 then Return

UPDATE VESSELS SET TPERF_VESSEL_VERSION = "-";

If SQLCA.SqlCode = 0 then 
	Commit;
	dw_Vsl.Retrieve( )
Else
	MessageBox("DB Error", SQLCA.sqlerrtext, Exclamation!) 
End If




end event

type cb_setpc from commandbutton within w_admin
integer x = 3730
integer y = 1872
integer width = 622
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set Temp"
end type

event clicked;
g_userinfo.pc_num = dw_pc.getitemnumber( dw_pc.getrow() , "PC_NR")
g_userinfo.pc_name = dw_pc.getitemstring( dw_pc.getrow() , "PC_NAME")

w_back.st_PC.text = "!!! " + g_userinfo.pc_name + " !!!"

w_back.event timer()

MessageBox ("Done!", "Profit Center changed to " + g_userinfo.pc_name + " for temporary use. Please close and re-open all windows to data.",Information!)
end event

type dw_pc from datawindow within w_admin
integer x = 3730
integer y = 1264
integer width = 622
integer height = 608
integer taborder = 90
string title = "none"
string dataobject = "d_sq_tb_pclist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
this.selectrow(0, False)
this.selectrow(currentrow, True)
end event

type cb_tphc from commandbutton within w_admin
integer x = 2688
integer y = 1872
integer width = 1024
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create tphc.dat"
end type

event clicked;
OLEObject PortObj
Long Counter 
String PCode, PName, FPath

If MessageBox("Confirm", "Are you sure you want to create tphc.dat?", Question!, YesNo!) = 2 then Return

PortObj=CREATE OLEObject
Counter = PortObj.ConnectToNewObject("TPerf.PortDB")
IF Counter < 0 THEN 
	DESTROY PortObj
	MessageBox ("OLE Error", "Could not create PortDB Object. Error: " + String(Counter), Exclamation!)
	Return
End If

PortObj.ClearPorts

For Counter = 1 to dw_tphc.rowcount( )
	PCode = dw_tphc.getitemstring( Counter, "PORT_CODE")
   PName = dw_tphc.getitemstring( Counter, "PORT_N")
	PortObj.AddPort(PCode, PName)
Next

FPath = "G:\TPA\TPerf2 Vessel Installation\"

Counter = PortObj.WritePortFile(FPath)

If Counter>0 then 
	MessageBox ("Success", String(Counter) + " ports were written to " + FPath + "tphc.dat", Information!)
Else
	MessageBox ("Error", "Could not create file. OLE Object returned error.")
End If

Destroy PortObj
end event

type dw_tphc from datawindow within w_admin
integer x = 2688
integer y = 1264
integer width = 1024
integer height = 608
integer taborder = 80
string title = "none"
string dataobject = "d_sq_tb_portlist"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.selectrow( 0, False)
this.selectrow( currentrow, True)
end event

event clicked;string ls_sort
if dwo.type = "text" then
	ls_sort = dwo.Tag
	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort
end if

end event

type dw_users from datawindow within w_admin
integer x = 3474
integer y = 624
integer width = 878
integer height = 608
integer taborder = 70
string title = "none"
string dataobject = "d_sq_tb_usersonline"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.selectrow( 0, False)
this.selectrow( currentrow, True)
end event

type dw_ports from datawindow within w_admin
integer x = 2688
integer y = 624
integer width = 768
integer height = 528
integer taborder = 60
string title = "none"
string dataobject = "d_sq_tb_customports"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.selectrow( 0, False)
this.selectrow( currentrow, True)
end event

type dw_vsl from datawindow within w_admin
integer x = 37
integer y = 624
integer width = 2633
integer height = 1248
integer taborder = 50
string title = "none"
string dataobject = "d_sq_tb_sysvsl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_sort
if dwo.type = "text" then
	ls_sort = dwo.Tag
	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort
end if

end event

event rowfocuschanged;
this.selectrow( 0, False)
this.selectrow( currentrow, True)
end event

type cb_refresh from commandbutton within w_admin
boolean visible = false
integer x = 3803
integer y = 512
integer width = 293
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;dw_syserr.retrieve( )
dw_vsl.retrieve( )
dw_ports.retrieve( )
dw_users.retrieve( )
dW_tphc.retrieve( )

ii_count = dw_pc.retrieve( )
dw_pc.selectrow(0, False)
For ii_loop = 1 to ii_count
	If dw_pc.getitemnumber( ii_loop, "PC_NR") = g_userinfo.pc_num then 
		dw_pc.selectrow( ii_loop, True)
		dw_pc.scrolltorow( ii_loop)
	End If			
Next 
end event

type cb_del from commandbutton within w_admin
integer x = 4096
integer y = 512
integer width = 256
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;

dw_syserr.deleterow( il_CurRow)

if dw_syserr.update( )<>1 then MessageBox ("Delete Error", "Could not delete row.")

if dw_syserr.rowcount( )=0 then 	
	cb_del.enabled = false
else
	dw_syserr.selectrow( dw_syserr.GetRow(), True)
end if


end event

type cb_ack from commandbutton within w_admin
integer x = 37
integer y = 512
integer width = 439
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ack"
end type

event clicked;
integer li_ack

li_ack = dw_syserr.getitemnumber( il_CurRow, "Ack")

li_ack = 1 - li_ack

dw_syserr.SetItem( il_CurRow, "Ack", li_ack)

if dw_syserr.update( )<> 1 then MessageBox ("Update Error", "Could not update Table")



end event

type dw_syserr from datawindow within w_admin
integer x = 37
integer y = 16
integer width = 4315
integer height = 496
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_syserr"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;
this.selectrow( 0, False)
this.selectrow( currentrow, True)

il_currow = currentrow
end event

event clicked;
If Row > 0 then
	this.selectrow( 0, False)
	this.selectrow( row, True)
	il_CurRow = row
End if

string ls_sort
if dwo.type = "text" then
	ls_sort = dwo.Tag
	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort
end if
end event

event retrieveend;If rowcount = 0 then
	cb_Ack.Enabled=False
	cb_Del.Enabled=False
	cb_exp.Enabled=False
else
	cb_Ack.Enabled=True
	cb_Del.Enabled=True
	cb_exp.Enabled=True
end if
end event

event updateend;
If dw_syserr.rowcount( ) = 0 then
	cb_Ack.Enabled=False
	cb_Del.Enabled=False
	cb_Exp.Enabled=False
else
	cb_Ack.Enabled=True
	cb_Del.Enabled=True
	cb_Exp.Enabled=True
end if
end event

type ln_1 from line within w_admin
long linecolor = 33554432
integer linethickness = 4
integer beginx = 4334
integer beginy = 1248
integer endx = 2688
integer endy = 1248
end type

type ln_2 from line within w_admin
long linecolor = 33554432
integer linethickness = 4
integer beginx = 4334
integer beginy = 600
integer endx = 37
integer endy = 600
end type

