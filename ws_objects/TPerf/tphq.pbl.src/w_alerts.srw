$PBExportHeader$w_alerts.srw
forward
global type w_alerts from window
end type
type cbx_pc from checkbox within w_alerts
end type
type cb_print from commandbutton within w_alerts
end type
type cbx_filter from checkbox within w_alerts
end type
type cb_del from commandbutton within w_alerts
end type
type cb_tree from commandbutton within w_alerts
end type
type cb_voy from commandbutton within w_alerts
end type
type cb_close from commandbutton within w_alerts
end type
type cb_unack from commandbutton within w_alerts
end type
type cb_ack from commandbutton within w_alerts
end type
type dw_tree from datawindow within w_alerts
end type
end forward

global type w_alerts from window
integer width = 3566
integer height = 2164
boolean titlebar = true
string title = "Performance Alerts"
boolean controlmenu = true
long backcolor = 67108864
string icon = "H:\Tramos.Dev\Resource\TPerf\Exclm.ico"
boolean center = true
event ue_treemenu ( integer ai_menusel )
cbx_pc cbx_pc
cb_print cb_print
cbx_filter cbx_filter
cb_del cb_del
cb_tree cb_tree
cb_voy cb_voy
cb_close cb_close
cb_unack cb_unack
cb_ack cb_ack
dw_tree dw_tree
end type
global w_alerts w_alerts

type variables

byte     ib_sel
long  il_currow

m_Treealerts TreeMenu

n_registry Reg
end variables

forward prototypes
private subroutine wf_applyalert (byte ab_ack)
end prototypes

event ue_treemenu(integer ai_menusel);long ll_count

SetPointer(HourGlass!)

choose case ai_menusel
	case 1  //  Expand all
		dw_tree.expandall( )
	case 2  //  Expand all active
		for ll_count = 1 to dw_tree.rowcount( )	
			if dw_tree.getitemnumber( ll_count, "ack") = 0 then
	   		dw_tree.expand( ll_count, 1)
				dw_tree.expand( ll_count, 2)
				dw_tree.expand( ll_count, 3)
			end if
		next
	case 3	// Collapse all
		dw_tree.collapseall( )
end choose
end event

private subroutine wf_applyalert (byte ab_ack);long ll_row, voy_id, vsl_id, Rep_ID, ll_tmpRepID, ll_tmpVoyID

If il_currow = 0 then return

vsl_id = dw_tree.getitemnumber( il_currow, "Vsl_ID")  // Retrieve vsl_id, voy_id and rep_id
voy_id = dw_tree.getitemnumber( il_currow, "Voy_ID")
Rep_ID = dw_tree.getitemnumber( il_currow, "Rep_ID" )

if ib_sel = 2 then   // If voyage is selected then comfirm
	if ab_ack=1 then 
		if messagebox("Confirm Acknowledge","Are you sure you want to acknowledge all alerts pertaining to this voyage?",Question!,YesNo!)=2 then return
	else
		if messagebox("Confirm Un-Acknowledge","Are you sure you want to un-acknowledge all alerts pertaining to this voyage?",Question!,YesNo!)=2 then return		
	end if
end if	

ll_row = il_currow   // Get selected row

choose case ib_sel   // Choose selection type
	Case 2   // Voyage selection
		Do
			dw_tree.setitem(ll_row, "Ack", ab_ack)   // update row
			ll_row++      // increment row
			if ll_row>dw_tree.rowcount( ) then    //  check if row exists
				ll_tmpVoyID = -1000
			else
				ll_tmpVoyID = dw_tree.getitemnumber( ll_row, "Voy_ID")  //  get voy_ID for next row
			end if
		loop until ll_tmpVoyID<>voy_id   //  if Voy_ID is same then loop
	Case 3   // Report selection
		if isnull(Rep_ID) then   // Check if report ID is null
			Do
				dw_tree.setitem(ll_row, "Ack", ab_ack)  // update row
				ll_row++   // increment row
				if ll_row<=dw_tree.rowcount( ) then  // check if row exists
					ll_tmpRepID = dw_tree.getitemnumber( ll_row, "Rep_ID")  // get rep_id for next row
					ll_tmpVoyID = dw_tree.getitemnumber( ll_row, "Voy_ID")  // get voy_id for next row
				else  // otherwise
					ll_tmprepID = -1000	
					ll_tmpVoyID = -1000
				end if
			loop until not isnull(ll_tmpRepID) or (ll_tmpVoyID<>voy_ID)   // if rep_id is null and voy_id is same then loop
		Else
			Do
				dw_tree.setitem(ll_row, "Ack", ab_ack)  // update row
				ll_row++    // Increment row
				if ll_row<=dw_tree.rowcount( ) then  // check if row exists
					ll_tmpRepID = dw_tree.getitemnumber( ll_row, "Rep_ID")  // get rep_id
					if isnull(ll_tmpRepID) then ll_tmpRepID = -1000   //  if next rep_id is null, then set to -1000
				else  // otherwise
					ll_tmpRepID = -1000										
				end if
			loop until (ll_tmpRepID<>Rep_ID)   // if rep_id is same then loop
		end if
	Case 4   // Alert selection
		dw_tree.setitem(ll_row, "Ack", ab_ack)   // update alert
End Choose

if dw_tree.update( )<>1 then    // attempt to update
	MessageBox ("Update Failed","The database could not be updated. Changes may be lost.")
	rollback;
else
	commit;
	w_back.event timer()
end if


end subroutine

event open;Integer li_PCSel

li_PCSel = Integer(Reg.GetSetting("AlertPC", "0"))

If li_PCSel = 0 then 
	li_PCSel = -1 
Else 
	li_PCSel = 0
	cbx_pc.Checked = True
End If

dw_tree.setTransObject(sqlca)
dw_tree.post retrieve(g_userinfo.userid, li_PCSel)

TreeMenu = create m_treealerts

cbx_filter.event clicked( )
end event

on w_alerts.create
this.cbx_pc=create cbx_pc
this.cb_print=create cb_print
this.cbx_filter=create cbx_filter
this.cb_del=create cb_del
this.cb_tree=create cb_tree
this.cb_voy=create cb_voy
this.cb_close=create cb_close
this.cb_unack=create cb_unack
this.cb_ack=create cb_ack
this.dw_tree=create dw_tree
this.Control[]={this.cbx_pc,&
this.cb_print,&
this.cbx_filter,&
this.cb_del,&
this.cb_tree,&
this.cb_voy,&
this.cb_close,&
this.cb_unack,&
this.cb_ack,&
this.dw_tree}
end on

on w_alerts.destroy
destroy(this.cbx_pc)
destroy(this.cb_print)
destroy(this.cbx_filter)
destroy(this.cb_del)
destroy(this.cb_tree)
destroy(this.cb_voy)
destroy(this.cb_close)
destroy(this.cb_unack)
destroy(this.cb_ack)
destroy(this.dw_tree)
end on

event resize;integer li_x

dw_tree.width = newwidth - dw_tree.x * 2

dw_tree.height = newheight - cb_ack.height - dw_tree.y * 3

cb_ack.y = dw_tree.height + dw_tree.y * 2

cb_close.y = cb_ack.y
cb_del.y = cb_ack.y
cb_tree.y = cb_ack.y
cb_unack.y = cb_ack.y
cb_voy.y = cb_ack.y
cb_print.y = cb_ack.y
cbx_Filter.y = cb_ack.y - 16
cbx_PC.y = cbx_Filter.y + cbx_Filter.Height

li_x = newwidth - dw_tree.x - cb_close.width
If li_x < (cbx_pc.x + cbx_pc.width) then li_x = cbx_pc.x + cbx_pc.width

cb_close.x = li_x
end event

event key;
If Key = KeyF1! then f_LaunchWiki("Office%20Program.aspx")
end event

event close;
If cbx_PC.Checked then
	Reg.SaveSetting("AlertsPC", "1")
Else
	Reg.SaveSetting("AlertsPC", "0")
End If

end event

type cbx_pc from checkbox within w_alerts
integer x = 1829
integer y = 1392
integer width = 695
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Primary Profit Center only"
end type

event clicked;
If This.Checked then
	dw_tree.Retrieve(g_UserInfo.userid, 0)
Else
	dw_tree.Retrieve(g_UserInfo.userid, -1)
End If
end event

type cb_print from commandbutton within w_alerts
integer x = 1481
integer y = 1344
integer width = 293
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print..."
end type

event clicked;
dw_Tree.Print(True,True)
end event

type cbx_filter from checkbox within w_alerts
integer x = 1829
integer y = 1328
integer width = 494
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Last 60 days only"
boolean checked = true
end type

event clicked;String ls_60Days

ls_60Days = String(RelativeDate( Today(), -60), "yyyy-mm-dd")

If This.Checked then 
	dw_Tree.SetFilter("utc > Date('" + ls_60Days + "')")
Else
	dw_Tree.SetFilter("")
End If

dw_Tree.Filter( )

end event

type cb_del from commandbutton within w_alerts
integer x = 896
integer y = 1344
integer width = 293
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Delete"
end type

event clicked;
if ib_sel=4 then 
	If MessageBox("Confirm Delete", "Are you sure you want to delete the selected alert?", Question!, YesNo!) = 2 then Return
	dw_tree.deleterow( il_currow )
	If dw_tree.update( )<>1 then
		MessageBox("Delete Error", "Unable to update the database.", Exclamation!)
		dw_tree.Retrieve( g_userinfo.pc_num )
	Else
		commit;
		w_back.event timer()		
		cb_ack.enabled = False
		cb_unack.enabled = False
		cb_Del.enabled = False
		cb_voy.enabled = False
		if dw_tree.rowcount( ) = 0 then cb_tree.enabled = False
	End If
End If
end event

type cb_tree from commandbutton within w_alerts
integer x = 18
integer y = 1344
integer width = 293
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Tree >"
end type

event clicked;
treemenu.popmenu(w_alerts.x+w_alerts.pointerx(),w_alerts.y+ w_alerts.pointery())
end event

type cb_voy from commandbutton within w_alerts
integer x = 1189
integer y = 1344
integer width = 293
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Open"
end type

event clicked;

g_parameters.voyageid = dw_tree.getitemnumber( il_currow, "Voy_ID")
g_parameters.reportid = dw_tree.getitemnumber( il_currow, "Rep_ID")

if (ib_sel=2) or isnull(g_parameters.reportid) then 
	opensheet(w_voydetail, w_main, 0, Original!) 
Else 
	opensheet(w_reportview, w_main, 0, Original!)
End If
end event

type cb_close from commandbutton within w_alerts
integer x = 2706
integer y = 1344
integer width = 347
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_unack from commandbutton within w_alerts
integer x = 603
integer y = 1344
integer width = 293
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Un-Ack"
end type

event clicked;
wf_applyalert( 0 )
end event

type cb_ack from commandbutton within w_alerts
integer x = 311
integer y = 1344
integer width = 293
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Ack"
end type

event clicked;
wf_applyalert( 1 )
end event

type dw_tree from datawindow within w_alerts
integer x = 18
integer y = 16
integer width = 3273
integer height = 1280
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tree_alerts"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_band
integer li_tab, li_tmprow

ls_band = this.GetBandAtPointer()

li_tab = Pos(ls_band, "~t", 1)
li_tmpRow = Integer(Mid(ls_band, li_tab + 1))

if li_tmpRow=0 then return

il_currow=li_tmpRow

ls_band = Left(ls_band, li_tab - 1)

Choose Case ls_band
	Case 'tree.level.1'
		ib_sel=1
	Case 'tree.level.2'
		ib_sel=2
	case 'tree.level.3'
		ib_sel=3
	case 'detail'
		ib_sel=4
End Choose

if ib_sel>1 then 
	cb_ack.enabled=true
	cb_unack.enabled=true
	cb_voy.enabled=true
else
	cb_ack.enabled=false
	cb_unack.enabled=false
	cb_voy.enabled=false
end if

cb_del.enabled = (ib_sel = 4)
end event

event doubleclicked;string ls_band
integer li_tab, li_tmprow

ls_band = this.GetBandAtPointer()

li_tab = Pos(ls_band, "~t", 1)
li_tmpRow = Integer(Mid(ls_band, li_tab + 1))

if li_tmpRow=0 then return

il_currow=li_tmpRow

ls_band = Left(ls_band, li_tab - 1)

if ls_band='detail' then return

ib_sel=integer(right(ls_band,1))

if this.isexpanded( li_tmprow, ib_sel) then
	this.CollapseAllChildren(li_tmprow, ib_sel)
else
	this.ExpandAllChildren(li_tmprow, ib_sel)
end if

end event

event retrieveend;
cb_tree.enabled = (rowcount>0)

Commit;
end event

