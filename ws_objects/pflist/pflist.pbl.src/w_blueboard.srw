$PBExportHeader$w_blueboard.srw
forward
global type w_blueboard from w_tramos_container
end type
type st_1 from statictext within w_blueboard
end type
type uo_pc from u_pc within w_blueboard
end type
type cbx_date from checkbox within w_blueboard
end type
type dp_date from datepicker within w_blueboard
end type
type st_2 from statictext within w_blueboard
end type
type cbx_hide from checkbox within w_blueboard
end type
type cb_collapse from commandbutton within w_blueboard
end type
type cb_expand from commandbutton within w_blueboard
end type
type uo_search from u_searchbox within w_blueboard
end type
type cb_reply from commandbutton within w_blueboard
end type
type cb_refresh from commandbutton within w_blueboard
end type
type cb_new from commandbutton within w_blueboard
end type
type dw_board from datawindow within w_blueboard
end type
type r_2 from rectangle within w_blueboard
end type
end forward

global type w_blueboard from w_tramos_container
integer width = 4535
integer height = 2984
string title = "Blueboard"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
string icon = "images\blueboard.ico"
event ue_pcchanged ( long al_pc,  ref integer ai_return )
st_1 st_1
uo_pc uo_pc
cbx_date cbx_date
dp_date dp_date
st_2 st_2
cbx_hide cbx_hide
cb_collapse cb_collapse
cb_expand cb_expand
uo_search uo_search
cb_reply cb_reply
cb_refresh cb_refresh
cb_new cb_new
dw_board dw_board
r_2 r_2
end type
global w_blueboard w_blueboard

type variables

Integer il_CurRow
long	il_pcnr
end variables

forward prototypes
public subroutine wf_expandallreplies (long al_rowcount)
public subroutine documentation ()
end prototypes

event ue_pcchanged(long al_pc, ref integer ai_return);il_pcnr = al_pc
cb_Refresh.Postevent("Clicked")
end event

public subroutine wf_expandallreplies (long al_rowcount);// This function expands each item if there are replies present

Integer li_Loop

For li_Loop = 1 to al_RowCount
   If Not IsNull(dw_Board.GetItemString(li_Loop, "cname")) then dw_Board.Expand(li_Loop, 1)
Next


end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_blueboard
	
   <OBJECT>
		This is the main window for the Blueboard functionality. It displays a list
		of messages in reverse chrolonogical order along with replies for each message
		
	</OBJECT>
	
   <USAGE>
		Self-explanatory.		
	</USAGE>

<HISTORY> 
   Date	   CR-Ref	 	Author	Comments
20/06/10		CR1821	   CONASW	First Version
13/01/11		CR2197		JMC112	Replacement of profit center selection by standard object u_pc
04/08/2014 	CR3708		AGL027	F1 help application coverage - change ancestor
28/08/14		CR3781		CCY018	The window title match with the text of a menu item
</HISTORY>    
********************************************************************/
end subroutine

on w_blueboard.create
int iCurrent
call super::create
this.st_1=create st_1
this.uo_pc=create uo_pc
this.cbx_date=create cbx_date
this.dp_date=create dp_date
this.st_2=create st_2
this.cbx_hide=create cbx_hide
this.cb_collapse=create cb_collapse
this.cb_expand=create cb_expand
this.uo_search=create uo_search
this.cb_reply=create cb_reply
this.cb_refresh=create cb_refresh
this.cb_new=create cb_new
this.dw_board=create dw_board
this.r_2=create r_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_pc
this.Control[iCurrent+3]=this.cbx_date
this.Control[iCurrent+4]=this.dp_date
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cbx_hide
this.Control[iCurrent+7]=this.cb_collapse
this.Control[iCurrent+8]=this.cb_expand
this.Control[iCurrent+9]=this.uo_search
this.Control[iCurrent+10]=this.cb_reply
this.Control[iCurrent+11]=this.cb_refresh
this.Control[iCurrent+12]=this.cb_new
this.Control[iCurrent+13]=this.dw_board
this.Control[iCurrent+14]=this.r_2
end on

on w_blueboard.destroy
call super::destroy
destroy(this.st_1)
destroy(this.uo_pc)
destroy(this.cbx_date)
destroy(this.dp_date)
destroy(this.st_2)
destroy(this.cbx_hide)
destroy(this.cb_collapse)
destroy(this.cb_expand)
destroy(this.uo_search)
destroy(this.cb_reply)
destroy(this.cb_refresh)
destroy(this.cb_new)
destroy(this.dw_board)
destroy(this.r_2)
end on

event open;call super::open;dw_Board.SetTransObject(SQLCA)

// Set Profit Center
il_pcnr = uo_pc.of_retrieve( )
if il_pcnr = c#return.failure then
	MessageBox("Error", "Error on getting profit center list!")
	return
end if

uo_pc.of_setbackcolor( c#color.MT_LISTHEADER_BG, false)

// Initialize search box
uo_Search.st_search.text = ""
uo_Search.st_search.backcolor = c#color.MT_LISTHEADER_BG
uo_Search.of_initialize(dw_Board, "bname+'_'+btext+'_'+If(Isnull(cname),'',cname)+'_'+If(Isnull(ctext),'',ctext)")
uo_Search.sle_search.Post SetFocus()

// Refresh datawindow
cb_Refresh.event Clicked( )

// Refresh every 30 minutes
Timer(1800)
end event

event timer;call super::timer;
If Not IsValid(w_BlueboardPost) then cb_Refresh.event clicked( )
end event

type st_hidemenubar from w_tramos_container`st_hidemenubar within w_blueboard
end type

type st_1 from statictext within w_blueboard
integer x = 41
integer y = 80
integer width = 293
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 22628899
string text = "Profit Center"
boolean focusrectangle = false
end type

type uo_pc from u_pc within w_blueboard
integer x = 352
integer width = 850
integer height = 152
integer taborder = 40
end type

on uo_pc.destroy
call u_pc::destroy
end on

type cbx_date from checkbox within w_blueboard
integer x = 2619
integer y = 68
integer width = 384
integer height = 88
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Filter By Date"
end type

event clicked;String ls_Filter

// Filters datawindow based on date

dw_Board.SetRedraw(False)

// Set filters on the searchbox
If This.Checked then
	ls_Filter = "string(btime,'yyyymmdd') = '" + String(dp_Date.value, "yyyymmdd") + "' or string(ctime,'yyyymmdd') = '" + String(dp_Date.value, "yyyymmdd") + "'"	
	uo_Search.of_SetOriginalFilter(ls_Filter)
Else
	uo_Search.of_SetOriginalFilter("")	
End If

// Force filter
uo_Search.of_DoFilter()

wf_Expandallreplies(dw_Board.RowCount())
	
dw_Board.SetRedraw(True)
	
	
end event

type dp_date from datepicker within w_blueboard
integer x = 3022
integer y = 72
integer width = 402
integer height = 80
integer taborder = 30
boolean border = true
borderstyle borderstyle = stylelowered!
datetimeformat format = dtfcustom!
string customformat = "dd MMM yyyy"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2014-08-28"), Time("15:50:52.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

event valuechanged;
If cbx_Date.Checked then cbx_Date.event clicked( )
end event

type st_2 from statictext within w_blueboard
integer x = 1289
integer y = 80
integer width = 197
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "Search"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_hide from checkbox within w_blueboard
integer x = 3621
integer y = 60
integer width = 859
integer height = 104
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 22628899
string text = "&Hide Messages older than 3 months"
boolean checked = true
end type

event clicked;
cb_Refresh.Event Clicked()

end event

type cb_collapse from commandbutton within w_blueboard
integer x = 1234
integer y = 2772
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Collapse All"
end type

event clicked;
Integer li_Loop

For li_Loop = 1 to dw_Board.RowCount()
   If Not IsNull(dw_Board.GetItemString(li_Loop, "cname")) then dw_Board.Collapse(li_Loop, 1)
Next
end event

type cb_expand from commandbutton within w_blueboard
integer x = 864
integer y = 2772
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "E&xpand All"
end type

event clicked;
SetRedraw(False)
wf_ExpandAllReplies(dw_Board.RowCount())
SetRedraw(True)
end event

type uo_search from u_searchbox within w_blueboard
integer x = 1509
integer y = 8
integer width = 1006
integer height = 144
integer taborder = 20
long backcolor = 22628899
end type

on uo_search.destroy
call u_searchbox::destroy
end on

event clearclicked;call super::clearclicked;
dw_Board.SetRedraw(False)

wf_ExpandAllReplies(dw_Board.RowCount())

dw_Board.SetRedraw(True)
end event

type cb_reply from commandbutton within w_blueboard
integer x = 411
integer y = 2772
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Re&ply To Post"
end type

event clicked;String ls_Post, ls_UserID
Long ll_MsgID

// Open post window
Open(w_blueboardpost)

// Get return post. If nothing, then exit
ls_Post = Message.StringParm
If ls_Post = "" then Return

// Get UserID, PC_NR
ls_UserID = uo_Global.GetUserID()
ll_MsgID = dw_Board.GetItemNumber(il_CurRow, "bmsgid")

// Post message
Insert Into BLUEBOARD (USERID, PC_NR, MSGTEXT, PARENT) Values (:ls_UserId, :il_pcnr, :ls_Post, :ll_MsgID);
If SQLCA.SQLCode=0 then 
	Commit;
	cb_Refresh.Event clicked( )
Else
	Rollback;
	//_AddMessage(This.ClassDefinition, "Clicked", "Unable to post message", SQLCA.SQLErrText)
	MessageBox("DB Error", "Unable to post message!~n~nError: " + SQLCA.SQLErrText)
End If


end event

type cb_refresh from commandbutton within w_blueboard
integer x = 1687
integer y = 2772
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;Long li_Age

// This function all controls and datwindow and reloads

// Disable redraw & erase all data
dw_Board.SetRedraw(False)
dw_Board.Reset()

// Reset all controls (except cbxHide)
cbx_Date.Checked = False
dw_Board.SetFilter("")
dw_Board.Filter()
dw_Board.Object.Selection.Expression = "'0'"
cb_Reply.Enabled = False
uo_Search.cb_clear.event clicked( )

// Set age of messages (in days) and retrieve
If cbx_Hide.Checked then li_Age = 92 Else li_Age = 1825  // 3 months else 5 years
dw_Board.Retrieve(il_pcnr , li_Age)



end event

type cb_new from commandbutton within w_blueboard
integer x = 41
integer y = 2772
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New Post"
end type

event clicked;String ls_Post, ls_UserID

// Open post window
Open(w_blueboardpost)

// Get return post. If nothing, then exit
ls_Post = Message.StringParm
If ls_Post = "" then Return

// Get UserID, PC_NR
ls_UserID = uo_Global.GetUserID()

// Post message
Insert Into BLUEBOARD (USERID, PC_NR, MSGTEXT) Values (:ls_UserId, :il_pcnr, :ls_Post);
If SQLCA.SQLCode=0 then 
	Commit;
	cb_Refresh.Event clicked( )
Else
	Rollback;
	//_AddMessage(This.ClassDefinition, "Clicked", "Unable to post message", SQLCA.SQLErrText)
	MessageBox("DB Error", "Unable to post message!~n~nError: " + SQLCA.SQLErrText)
End If


end event

type dw_board from datawindow within w_blueboard
integer x = 41
integer y = 252
integer width = 4443
integer height = 2484
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tv_blueboard"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
string ls_band
integer li_tab, li_tmprow

ls_band = this.GetBandAtPointer()

li_tab = Pos(ls_band, "~t", 1)
li_tmpRow = Integer(Mid(ls_band, li_tab + 1))

if li_tmpRow=0 then return

il_CurRow = li_tmpRow

dw_Board.Object.Selection.Expression = "'" + String(This.GetItemNumber(li_tmpRow, "bmsgid")) + "'"

dw_Board.SetRedraw(True)

cb_Reply.Enabled = True
end event

event retrieveend;
wf_ExpandAllReplies(rowcount)

SetRedraw(True)
end event

type r_2 from rectangle within w_blueboard
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 22628899
integer width = 4526
integer height = 216
end type

