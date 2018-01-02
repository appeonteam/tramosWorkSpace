$PBExportHeader$w_sentmail.srw
forward
global type w_sentmail from window
end type
type ddlb_last from dropdownlistbox within w_sentmail
end type
type st_4 from statictext within w_sentmail
end type
type st_3 from statictext within w_sentmail
end type
type dw_hd from datawindow within w_sentmail
end type
type st_2 from statictext within w_sentmail
end type
type st_1 from statictext within w_sentmail
end type
type ole_wb from olecustomcontrol within w_sentmail
end type
type dw_log from datawindow within w_sentmail
end type
type sle_find from singlelineedit within w_sentmail
end type
end forward

global type w_sentmail from window
integer width = 4777
integer height = 2416
boolean titlebar = true
string title = "Sent Mail"
boolean controlmenu = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = child!
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\VIMS\emailsent.ico"
boolean center = true
ddlb_last ddlb_last
st_4 st_4
st_3 st_3
dw_hd dw_hd
st_2 st_2
st_1 st_1
ole_wb ole_wb
dw_log dw_log
sle_find sle_find
end type
global w_sentmail w_sentmail

type variables

String is_HTML
end variables

forward prototypes
public subroutine sethtml (string as_html)
public subroutine loademail (long al_logid)
public subroutine filter_dw ()
end prototypes

public subroutine sethtml (string as_html);
// Sets the HTML content of the browser

is_HTML = as_HTML

ole_wb.object.Navigate("about:blank");

end subroutine

public subroutine loademail (long al_logid);
If dw_HD.Retrieve(al_LogID)=1 Then
	SetHTML(dw_HD.GetItemString(1,"Body"))
Else
	SetHTML("")
End If

end subroutine

public subroutine filter_dw ();// Filters the DW based on subject

String ls_Text

ls_Text = Upper(Trim(sle_Find.Text, True))

If ls_Text > "" Then dw_Log.SetFilter("Upper(Subject) like '%" + ls_Text + "%'") Else dw_Log.SetFilter("")
dw_Log.Filter()

If dw_Log.Rowcount( ) > 0 Then
	LoadEmail(dw_Log.GetItemNumber(dw_Log.GetRow(),"LogID"))
Else
	LoadEmail(0)
End If

end subroutine

on w_sentmail.create
this.ddlb_last=create ddlb_last
this.st_4=create st_4
this.st_3=create st_3
this.dw_hd=create dw_hd
this.st_2=create st_2
this.st_1=create st_1
this.ole_wb=create ole_wb
this.dw_log=create dw_log
this.sle_find=create sle_find
this.Control[]={this.ddlb_last,&
this.st_4,&
this.st_3,&
this.dw_hd,&
this.st_2,&
this.st_1,&
this.ole_wb,&
this.dw_log,&
this.sle_find}
end on

on w_sentmail.destroy
destroy(this.ddlb_last)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.dw_hd)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ole_wb)
destroy(this.dw_log)
destroy(this.sle_find)
end on

event open;
dw_Log.SetTransObject(SQLCA)
dw_HD.SetTransObject(SQLCA)

Post Resize(this.width,this.height)

ddlb_Last.selectitem(1)
dw_Log.Post Retrieve(30)


end event

event resize;
ole_wb.Resize( newwidth - ole_wb.x - dw_log.x, newheight - ole_wb.y - dw_log.x )
ole_wb.object.Width = UnitsToPixels( ole_wb.width, XUnitsToPixels! )
ole_wb.object.Height = UnitsToPixels( ole_wb.Height,YUnitsToPixels! )

dw_HD.width = newwidth - dw_HD.x - dw_log.x
dw_log.height=newheight - dw_log.y - dw_log.x



end event

type ddlb_last from dropdownlistbox within w_sentmail
integer x = 293
integer y = 8
integer width = 466
integer height = 516
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Last 1 Month","Last 3 Months","Last 6 Months","Last 1 Year","All Emails"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;
Long ll_Days

Choose Case Index
	Case 1
		ll_Days = 30  // 1 Month
	Case 2
		ll_Days = 91  // 3 Months
	Case 3
		ll_Days = 183 // 6 Months
	Case 4
		ll_Days = 365  // 1 Year
	Case 5
		ll_Days = 99999   // All Mails
End Choose

dw_Log.Retrieve(ll_Days)
end event

type st_4 from statictext within w_sentmail
integer x = 951
integer y = 24
integer width = 215
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sentmail
integer x = 1518
integer y = 432
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Email Content"
boolean focusrectangle = false
end type

type dw_hd from datawindow within w_sentmail
integer x = 1518
integer y = 96
integer width = 1646
integer height = 320
integer taborder = 20
string title = "none"
string dataobject = "d_sq_ff_sentmail"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_sentmail
integer x = 1518
integer y = 16
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Email Info"
boolean focusrectangle = false
end type

type st_1 from statictext within w_sentmail
integer x = 18
integer y = 16
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Email Log"
boolean focusrectangle = false
end type

type ole_wb from olecustomcontrol within w_sentmail
event statustextchange ( string text )
event progresschange ( long progress,  long progressmax )
event commandstatechange ( long command,  boolean enable )
event downloadbegin ( )
event downloadcomplete ( )
event titlechange ( string text )
event propertychange ( string szproperty )
event beforenavigate2 ( oleobject pdisp,  any url,  any flags,  any targetframename,  any postdata,  any headers,  ref boolean cancel )
event newwindow2 ( ref oleobject ppdisp,  ref boolean cancel )
event navigatecomplete2 ( oleobject pdisp,  any url )
event documentcomplete ( oleobject pdisp,  any url )
event onquit ( )
event onvisible ( boolean ocx_visible )
event ontoolbar ( boolean toolbar )
event onmenubar ( boolean menubar )
event onstatusbar ( boolean statusbar )
event onfullscreen ( boolean fullscreen )
event ontheatermode ( boolean theatermode )
event windowsetresizable ( boolean resizable )
event windowsetleft ( long left )
event windowsettop ( long top )
event windowsetwidth ( long ocx_width )
event windowsetheight ( long ocx_height )
event windowclosing ( boolean ischildwindow,  ref boolean cancel )
event clienttohostwindow ( ref long cx,  ref long cy )
event setsecurelockicon ( long securelockicon )
event filedownload ( boolean activedocument,  ref boolean cancel )
event navigateerror ( oleobject pdisp,  any url,  any frame,  any statuscode,  ref boolean cancel )
event printtemplateinstantiation ( oleobject pdisp )
event printtemplateteardown ( oleobject pdisp )
event updatepagestatus ( oleobject pdisp,  any npage,  any fdone )
event privacyimpactedstatechange ( boolean bimpacted )
event setphishingfilterstatus ( long phishingfilterstatus )
event newprocess ( long lcauseflag,  oleobject pwb2,  ref boolean cancel )
event redirectxdomainblocked ( oleobject pdisp,  any starturl,  any redirecturl,  any frame,  any statuscode )
integer x = 1518
integer y = 496
integer width = 2194
integer height = 1328
integer taborder = 30
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_sentmail.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

event navigatecomplete2(oleobject pdisp, any url);
// Sets the HTML here
ole_wb.object.Document.Write(is_HTML)
ole_wb.object.Post Refresh()

end event

type dw_log from datawindow within w_sentmail
integer x = 18
integer y = 96
integer width = 1463
integer height = 1792
integer taborder = 10
string dataobject = "d_sq_tb_sentmaillog"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
String ls_sort

If (dwo.type = "text") and row=0 then
	ls_Sort = trim(dwo.Tag)
	If Len(ls_Sort) > 1 then
		this.setSort(ls_sort)
		this.Sort()
		if right(ls_sort,1) = "A" then 
			ls_sort = replace(ls_sort, len(ls_sort),1, "D")
		else
			ls_sort = replace(ls_sort, len(ls_sort),1, "A")
		end if
		dwo.Tag = ls_sort
	End If
End if

If row>0 then LoadEmail(this.GetItemNumber(row,"LogID"))
end event

event retrieveend;
If RowCount>0 Then LoadEmail(this.GetItemNumber(1,"LogID"))
end event

type sle_find from singlelineedit within w_sentmail
event ue_keyup pbm_keyup
integer x = 1134
integer y = 12
integer width = 343
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_keyup;// Call search function

Post Filter_DW()
end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Aw_sentmail.bin 
2500000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000ed56098001ce6b1f00000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f00000000ed56098001ce6b1fed56098001ce6b1f000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009c000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c0000319c000022500000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c046000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000003000300090006000d000700030009000500050009000700050003000600030007000700000004c0000319c000022500000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c046000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000ffff00700070003000b00050007000700120006000500070ffff00b0ffff00700030ffff005000300070005000a000700090006000500060ffff00b0007000600030003000700070007000700070007000a000600080006000500090007000a000900060006000600070006000400070006000600080006000c000c0006000c0008000800080008000800080007000b00060006000600060005000500050005000700090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Aw_sentmail.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
