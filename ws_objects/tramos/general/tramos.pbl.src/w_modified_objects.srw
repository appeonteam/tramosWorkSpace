$PBExportHeader$w_modified_objects.srw
forward
global type w_modified_objects from window
end type
type cb_reset from commandbutton within w_modified_objects
end type
type cb_exit from commandbutton within w_modified_objects
end type
type cb_copy from commandbutton within w_modified_objects
end type
type cb_import from commandbutton within w_modified_objects
end type
type dw_modified_objects from datawindow within w_modified_objects
end type
end forward

global type w_modified_objects from window
integer width = 2085
integer height = 1192
boolean titlebar = true
string title = "Get Modified Objects List"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_reset cb_reset
cb_exit cb_exit
cb_copy cb_copy
cb_import cb_import
dw_modified_objects dw_modified_objects
end type
global w_modified_objects w_modified_objects

forward prototypes
public function string of_getsyntax ()
end prototypes

public function string of_getsyntax ();string	ls_Syntax

ls_Syntax = &
"release 12;~r~n" + &
"datawindow(units=0 timer_interval=0 color=16777215 brushmode=0 transparency=0 gradient.angle=0 gradient.color=8421504 gradient.focus=0 gradient.repetition.count=0 gradient.repetition.length=100 gradient.repetition.mode=0 gradient.scale=100 gradient.spread=100 gradient.transparency=0 picture.blur=0 picture.clip.bottom=0 picture.clip.left=0 picture.clip.right=0 picture.clip.top=0 picture.mode=0 picture.scale.x=100 picture.scale.y=100 picture.transparency=0 processing=1 HTMLDW=no print.printername=~"~" print.documentname=~"~" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 96 print.margin.bottom = 96 print.paper.source = 0 print.paper.size = 0 print.canusedefaultprinter=yes print.prompt=no print.buttons=no print.preview.buttons=no print.cliptext=no print.overrideprintjob=no print.collate=yes print.background=no print.preview.background=no print.preview.outline=yes hidegrayline=no showbackcoloronxp=no picture.file=~"~" grid.lines=0 selected.mouse=no )~r~n" + &
"header(height=64 color=~"536870912~" transparency=~"0~" gradient.color=~"8421504~" gradient.transparency=~"0~" gradient.angle=~"0~" brushmode=~"0~" gradient.repetition.mode=~"0~" gradient.repetition.count=~"0~" gradient.repetition.length=~"100~" gradient.focus=~"0~" gradient.scale=~"100~" gradient.spread=~"100~" )~r~n" + &
"summary(height=0 color=~"536870912~" transparency=~"0~" gradient.color=~"8421504~" gradient.transparency=~"0~" gradient.angle=~"0~" brushmode=~"0~" gradient.repetition.mode=~"0~" gradient.repetition.count=~"0~" gradient.repetition.length=~"100~" gradient.focus=~"0~" gradient.scale=~"100~" gradient.spread=~"100~" )~r~n" + &
"footer(height=0 color=~"536870912~" transparency=~"0~" gradient.color=~"8421504~" gradient.transparency=~"0~" gradient.angle=~"0~" brushmode=~"0~" gradient.repetition.mode=~"0~" gradient.repetition.count=~"0~" gradient.repetition.length=~"100~" gradient.focus=~"0~" gradient.scale=~"100~" gradient.spread=~"100~" )~r~n" + &
"detail(height=72 color=~"536870912~~tif(getrow() = currentrow(), rgb(0, 128, 0), 536870912)~" transparency=~"0~" gradient.color=~"8421504~" gradient.transparency=~"0~" gradient.angle=~"0~" brushmode=~"0~" gradient.repetition.mode=~"0~" gradient.repetition.count=~"0~" gradient.repetition.length=~"100~" gradient.focus=~"0~" gradient.scale=~"100~" gradient.spread=~"100~" )~r~n" + &
"table(column=(type=char(1000) updatewhereclause=no name=object_name dbname=~"object_name~" )~r~n" + &
" column=(type=char(1000) updatewhereclause=no name=object_user dbname=~"object_user~" )~r~n" + &
" column=(type=char(1000) updatewhereclause=no name=object_date dbname=~"object_date~" )~r~n" + &
" column=(type=char(1000) updatewhereclause=no name=object_version dbname=~"object_version~" )~r~n" + &
" column=(type=char(1000) updatewhereclause=no name=object_action dbname=~"object_action~" )~r~n" + &
" column=(type=char(1000) updatewhereclause=no name=object_comment dbname=~"object_comment~" )~r~n" + &
" column=(type=char(1000) updatewhereclause=yes name=object_library dbname=~"object_library~" )~r~n" + &
"  sort=~"object_name A    long(object_version) A ~" )~r~n" + &
"text(band=header alignment=~"2~" text=~"Name~" border=~"0~" color=~"0~" x=~"119~" y=~"4~" height=~"56~" width=~"713~" html.valueishtml=~"0~"  name=object_name_t visible=~"1~"  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"700~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" background.transparency=~"0~" background.gradient.color=~"8421504~" background.gradient.transparency=~"0~" background.gradient.angle=~"0~" background.brushmode=~"0~" background.gradient.repetition.mode=~"0~" background.gradient.repetition.count=~"0~" background.gradient.repetition.length=~"100~" background.gradient.focus=~"0~" background.gradient.scale=~"100~" background.gradient.spread=~"100~" tooltip.backcolor=~"134217752~" tooltip.delay.initial=~"0~" tooltip.delay.visible=~"32000~" tooltip.enabled=~"0~" tooltip.hasclosebutton=~"0~" tooltip.icon=~"0~" tooltip.isbubble=~"0~" tooltip.maxwidth=~"0~" tooltip.textcolor=~"134217751~" tooltip.transparency=~"0~" transparency=~"0~" )~r~n" + &
"text(band=header alignment=~"2~" text=~"Version~" border=~"0~" color=~"0~" x=~"1339~" y=~"4~" height=~"56~" width=~"306~" html.valueishtml=~"0~"  name=object_version_t visible=~"1~"  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"700~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" background.transparency=~"0~" background.gradient.color=~"8421504~" background.gradient.transparency=~"0~" background.gradient.angle=~"0~" background.brushmode=~"0~" background.gradient.repetition.mode=~"0~" background.gradient.repetition.count=~"0~" background.gradient.repetition.length=~"100~" background.gradient.focus=~"0~" background.gradient.scale=~"100~" background.gradient.spread=~"100~" tooltip.backcolor=~"134217752~" tooltip.delay.initial=~"0~" tooltip.delay.visible=~"32000~" tooltip.enabled=~"0~" tooltip.hasclosebutton=~"0~" tooltip.icon=~"0~" tooltip.isbubble=~"0~" tooltip.maxwidth=~"0~" tooltip.textcolor=~"134217751~" tooltip.transparency=~"0~" transparency=~"0~" )~r~n" + &
"text(band=header alignment=~"2~" text=~"Library~" border=~"0~" color=~"0~" x=~"841~" y=~"4~" height=~"56~" width=~"489~" html.valueishtml=~"0~"  name=object_library_t visible=~"1~"  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"700~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" background.transparency=~"0~" background.gradient.color=~"0~" background.gradient.transparency=~"0~" background.gradient.angle=~"0~" background.brushmode=~"0~" background.gradient.repetition.mode=~"0~" background.gradient.repetition.count=~"0~" background.gradient.repetition.length=~"0~" background.gradient.focus=~"0~" background.gradient.scale=~"0~" background.gradient.spread=~"0~" tooltip.backcolor=~"0~" tooltip.delay.initial=~"0~" tooltip.delay.visible=~"0~" tooltip.enabled=~"0~" tooltip.hasclosebutton=~"0~" tooltip.icon=~"0~" tooltip.isbubble=~"0~" tooltip.maxwidth=~"0~" tooltip.textcolor=~"0~" tooltip.transparency=~"0~" transparency=~"0~" )~r~n" + &
"compute(band=header alignment=~"2~" expression=~"rowcount()~"border=~"0~" color=~"33554432~" x=~"5~" y=~"4~" height=~"56~" width=~"105~" format=~"[GENERAL]~" html.valueishtml=~"0~"  name=compute_count visible=~"1~"  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"700~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" background.transparency=~"0~" background.gradient.color=~"8421504~" background.gradient.transparency=~"0~" background.gradient.angle=~"0~" background.brushmode=~"0~" background.gradient.repetition.mode=~"0~" background.gradient.repetition.count=~"0~" background.gradient.repetition.length=~"100~" background.gradient.focus=~"0~" background.gradient.scale=~"100~" background.gradient.spread=~"100~" tooltip.backcolor=~"134217752~" tooltip.delay.initial=~"0~" tooltip.delay.visible=~"32000~" tooltip.enabled=~"0~" tooltip.hasclosebutton=~"0~" tooltip.icon=~"0~" tooltip.isbubble=~"0~" tooltip.maxwidth=~"0~" tooltip.textcolor=~"134217751~" tooltip.transparency=~"0~" transparency=~"0~" )~r~n" + &
"text(band=header alignment=~"2~" text=~"Action~" border=~"0~" color=~"0~" x=~"1655~" y=~"4~" height=~"56~" width=~"297~" html.valueishtml=~"0~"  name=object_action_t visible=~"1~"  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"700~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" background.transparency=~"0~" background.gradient.color=~"8421504~" background.gradient.transparency=~"0~" background.gradient.angle=~"0~" background.brushmode=~"0~" background.gradient.repetition.mode=~"0~" background.gradient.repetition.count=~"0~" background.gradient.repetition.length=~"100~" background.gradient.focus=~"0~" background.gradient.scale=~"100~" background.gradient.spread=~"100~" tooltip.backcolor=~"134217752~" tooltip.delay.initial=~"0~" tooltip.delay.visible=~"32000~" tooltip.enabled=~"0~" tooltip.hasclosebutton=~"0~" tooltip.icon=~"0~" tooltip.isbubble=~"0~" tooltip.maxwidth=~"0~" tooltip.textcolor=~"134217751~" tooltip.transparency=~"0~" transparency=~"0~" )~r~n" + &
"column(band=detail id=1 alignment=~"0~" tabsequence=10 border=~"0~" color=~"0~~tif(getrow() = currentrow(), rgb(255, 255, 255), 0)~" x=~"119~" y=~"0~" height=~"72~" width=~"713~" format=~"[general]~" html.valueishtml=~"0~"  name=object_name visible=~"1~" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=yes edit.autohscroll=yes  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" background.transparency=~"0~" background.gradient.color=~"8421504~" background.gradient.transparency=~"0~" background.gradient.angle=~"0~" background.brushmode=~"0~" background.gradient.repetition.mode=~"0~" background.gradient.repetition.count=~"0~" background.gradient.repetition.length=~"100~" background.gradient.focus=~"0~" background.gradient.scale=~"100~" background.gradient.spread=~"100~" tooltip.backcolor=~"134217752~" tooltip.delay.initial=~"0~" tooltip.delay.visible=~"32000~" tooltip.enabled=~"0~" tooltip.hasclosebutton=~"0~" tooltip.icon=~"0~" tooltip.isbubble=~"0~" tooltip.maxwidth=~"0~" tooltip.textcolor=~"134217751~" tooltip.transparency=~"0~" transparency=~"0~" )~r~n" + &
"column(band=detail id=4 alignment=~"2~" tabsequence=30 border=~"0~" color=~"0~~tif(getrow() = currentrow(), rgb(255, 255, 255), 0)~" x=~"1339~" y=~"0~" height=~"72~" width=~"306~" format=~"[general]~" html.valueishtml=~"0~"  name=object_version visible=~"1~" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=yes edit.autohscroll=yes  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" background.transparency=~"0~" background.gradient.color=~"8421504~" background.gradient.transparency=~"0~" background.gradient.angle=~"0~" background.brushmode=~"0~" background.gradient.repetition.mode=~"0~" background.gradient.repetition.count=~"0~" background.gradient.repetition.length=~"100~" background.gradient.focus=~"0~" background.gradient.scale=~"100~" background.gradient.spread=~"100~" tooltip.backcolor=~"134217752~" tooltip.delay.initial=~"0~" tooltip.delay.visible=~"32000~" tooltip.enabled=~"0~" tooltip.hasclosebutton=~"0~" tooltip.icon=~"0~" tooltip.isbubble=~"0~" tooltip.maxwidth=~"0~" tooltip.textcolor=~"134217751~" tooltip.transparency=~"0~" transparency=~"0~" )~r~n" + &
"column(band=detail id=7 alignment=~"0~" tabsequence=20 border=~"0~" color=~"0~~tif(getrow() = currentrow(), rgb(255, 255, 255), 0)~" x=~"841~" y=~"0~" height=~"72~" width=~"489~" format=~"[general]~" html.valueishtml=~"0~"  name=object_library visible=~"1~" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" background.transparency=~"0~" background.gradient.color=~"8421504~" background.gradient.transparency=~"0~" background.gradient.angle=~"0~" background.brushmode=~"0~" background.gradient.repetition.mode=~"0~" background.gradient.repetition.count=~"0~" background.gradient.repetition.length=~"100~" background.gradient.focus=~"0~" background.gradient.scale=~"100~" background.gradient.spread=~"100~" tooltip.backcolor=~"134217752~" tooltip.delay.initial=~"0~" tooltip.delay.visible=~"32000~" tooltip.enabled=~"0~" tooltip.hasclosebutton=~"0~" tooltip.icon=~"0~" tooltip.isbubble=~"0~" tooltip.maxwidth=~"0~" tooltip.textcolor=~"134217751~" tooltip.transparency=~"0~" transparency=~"0~" )~r~n" + &
"compute(band=detail alignment=~"2~" expression=~"getrow()~"border=~"0~" color=~"33554432~~tif(getrow() = currentrow(), rgb(255, 255, 255), 0)~" x=~"9~" y=~"0~" height=~"72~" width=~"101~" format=~"[GENERAL]~" html.valueishtml=~"0~"  name=compute_row visible=~"1~"  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" background.transparency=~"0~" background.gradient.color=~"8421504~" background.gradient.transparency=~"0~" background.gradient.angle=~"0~" background.brushmode=~"0~" background.gradient.repetition.mode=~"0~" background.gradient.repetition.count=~"0~" background.gradient.repetition.length=~"100~" background.gradient.focus=~"0~" background.gradient.scale=~"100~" background.gradient.spread=~"100~" tooltip.backcolor=~"134217752~" tooltip.delay.initial=~"0~" tooltip.delay.visible=~"32000~" tooltip.enabled=~"0~" tooltip.hasclosebutton=~"0~" tooltip.icon=~"0~" tooltip.isbubble=~"0~" tooltip.maxwidth=~"0~" tooltip.textcolor=~"134217751~" tooltip.transparency=~"0~" transparency=~"0~" )~r~n" + &
"column(band=detail id=5 alignment=~"2~" tabsequence=40 border=~"0~" color=~"0~~tif(getrow() = currentrow(), rgb(255, 255, 255), 0)~" x=~"1655~" y=~"0~" height=~"72~" width=~"297~" format=~"[general]~" html.valueishtml=~"0~"  name=object_action visible=~"1~" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=yes edit.autohscroll=yes  font.face=~"Tahoma~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" background.transparency=~"0~" background.gradient.color=~"8421504~" background.gradient.transparency=~"0~" background.gradient.angle=~"0~" background.brushmode=~"0~" background.gradient.repetition.mode=~"0~" background.gradient.repetition.count=~"0~" background.gradient.repetition.length=~"100~" background.gradient.focus=~"0~" background.gradient.scale=~"100~" background.gradient.spread=~"100~" tooltip.backcolor=~"134217752~" tooltip.delay.initial=~"0~" tooltip.delay.visible=~"32000~" tooltip.enabled=~"0~" tooltip.hasclosebutton=~"0~" tooltip.icon=~"0~" tooltip.isbubble=~"0~" tooltip.maxwidth=~"0~" tooltip.textcolor=~"134217751~" tooltip.transparency=~"0~" transparency=~"0~" )~r~n" + &
"htmltable(border=~"1~" )~r~n" + &
"htmlgen(clientevents=~"1~" clientvalidation=~"1~" clientcomputedfields=~"1~" clientformatting=~"0~" clientscriptable=~"0~" generatejavascript=~"1~" encodeselflinkargs=~"1~" netscapelayers=~"0~" pagingmethod=0 generatedddwframes=~"1~" )~r~n" + &
"xhtmlgen() cssgen(sessionspecific=~"0~" )~r~n" + &
"xmlgen(inline=~"0~" )~r~n" + &
"xsltgen()~r~n" + &
"jsgen()~r~n" + &
"export.xml(headgroups=~"1~" includewhitespace=~"0~" metadatatype=0 savemetadata=0 )~r~n" + &
"import.xml()~r~n" + &
"export.pdf(method=0 distill.custompostscript=~"0~" xslfop.print=~"0~" )~r~n" + &
"export.xhtml()~r~n" + &
" "

Return ls_Syntax

end function

on w_modified_objects.create
this.cb_reset=create cb_reset
this.cb_exit=create cb_exit
this.cb_copy=create cb_copy
this.cb_import=create cb_import
this.dw_modified_objects=create dw_modified_objects
this.Control[]={this.cb_reset,&
this.cb_exit,&
this.cb_copy,&
this.cb_import,&
this.dw_modified_objects}
end on

on w_modified_objects.destroy
destroy(this.cb_reset)
destroy(this.cb_exit)
destroy(this.cb_copy)
destroy(this.cb_import)
destroy(this.dw_modified_objects)
end on

event open;dw_Modified_Objects.Create(of_GetSyntax())

dw_Modified_Objects.Modify("DataWindow.ReadOnly = 'yes'")

end event

type cb_reset from commandbutton within w_modified_objects
integer x = 9
integer y = 992
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Reset"
end type

event clicked;dw_Modified_Objects.Reset()

end event

type cb_exit from commandbutton within w_modified_objects
integer x = 1719
integer y = 992
integer width = 343
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Exit"
end type

event clicked;Close(Parent)

end event

type cb_copy from commandbutton within w_modified_objects
integer x = 1152
integer y = 992
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Copy"
end type

event clicked;long		ll_Loop, ll_Count
String	ls_ObjName, ls_LibName, ls_Version, ls_Action, ls_Text

ll_Count = dw_Modified_Objects.RowCount()
for ll_Loop = 1 to ll_Count
	ls_ObjName = dw_Modified_Objects.GetItemString(ll_Loop, "object_name")
	if IsNull(ls_ObjName) then ls_ObjName = ""
	
	ls_LibName = dw_Modified_Objects.GetItemString(ll_Loop, "object_library")
	if IsNull(ls_LibName) then ls_LibName = ""
	
	ls_Version = dw_Modified_Objects.GetItemString(ll_Loop, "object_version")
	if IsNull(ls_Version) then ls_Version = ""
	
	ls_Action = dw_Modified_Objects.GetItemString(ll_Loop, "object_action")
	if IsNull(ls_Action) then ls_Action = ""
	
	ls_Text += ls_ObjName + "~t" + ls_LibName + "~t" + ls_Version + "~t" + ls_Action + "~r~n"
next

ClipBoard(ls_Text)

end event

type cb_import from commandbutton within w_modified_objects
integer x = 581
integer y = 992
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Import"
end type

event clicked;String	ls_PathName, ls_FileName, ls_ObjName, ls_Version, ls_Action
String	ls_LibName, ls_LibList, ls_ObjList
long		ll_RtnVal, ll_Loop, ll_Count, ll_Pos, ll_Find

ll_RtnVal = GetFileOpenName("Select Import File", ls_PathName, ls_FileName, "", "CSV(.csv),*.csv,Tab-separated file(.txt),*.txt,Dbase II & III(.dbf),*.dbf,XML(.xml),*.xml")
if ll_RtnVal <> 1 then Return

dw_Modified_Objects.SetRedraw(false)

dw_Modified_Objects.Reset()

ll_RtnVal = dw_Modified_Objects.ImportFile(ls_PathName, 2)
if ll_RtnVal <= 0 then
	if ll_RtnVal < 0 then MessageBox("Import Error(" + String(ll_RtnVal) + ")", "Failed to import file '" + ls_PathName + "'", StopSign!)
	dw_Modified_Objects.SetRedraw(true)
	Return
end if

dw_Modified_Objects.SetFilter("object_name not like '%.sr%'")
dw_Modified_Objects.Filter()
dw_Modified_Objects.RowsDiscard(1, dw_Modified_Objects.RowCount(), Primary!)
dw_Modified_Objects.SetFilter("")
dw_Modified_Objects.Filter()

ll_Count = dw_Modified_Objects.RowCount()
for ll_Loop = 1 to ll_Count
	ls_ObjName = dw_Modified_Objects.GetItemString(ll_Loop, "object_name")
	
	ll_Pos = LastPos(ls_ObjName, "/")
	if ll_Pos > 0 then ls_ObjName = Mid(ls_ObjName, ll_Pos + Len("/"))
	
	ll_Pos = Pos(ls_ObjName, ".sr")
	if ll_Pos > 0 then ls_ObjName = Left(ls_ObjName, ll_Pos - 1)
	
	dw_Modified_Objects.SetItem(ll_Loop, "object_name", ls_ObjName)
	
	ls_Action = dw_Modified_Objects.GetItemString(ll_Loop, "object_action")
	if ls_Action = "Added" then
		dw_Modified_Objects.SetItem(ll_Loop, "object_action", "Add")
	elseif ls_Action = "Checked in" then
		dw_Modified_Objects.SetItem(ll_Loop, "object_action", "Change")
	end if
next

dw_Modified_Objects.SetSort("object_name A, long(object_version) A")
dw_Modified_Objects.Sort()

ll_Count = dw_Modified_Objects.RowCount()
for ll_Loop = 2 to ll_Count
	if dw_Modified_Objects.GetItemString(ll_Loop, "object_name") = dw_Modified_Objects.GetItemString(ll_Loop - 1, "object_name") then
		ls_Version = dw_Modified_Objects.GetItemString(ll_Loop - 1, "object_version") + ", " + dw_Modified_Objects.GetItemString(ll_Loop, "object_version")
		dw_Modified_Objects.SetItem(ll_Loop - 1, "object_version", ls_Version)
		dw_Modified_Objects.DeleteRow(ll_Loop)
		ll_Loop -= 1
		ll_Count -= 1
	end if
next

ls_LibList = GetLibraryList() + ","

do 
	ll_Pos = Pos(ls_LibList, ",")
	if ll_Pos > 0 then
		ls_LibName = Trim(Left(ls_LibList, ll_Pos - 1))
		ls_LibList = Trim(Mid(ls_LibList, ll_Pos + Len(",")))
		
		if ls_LibName <> "" then
			ls_ObjList = LibraryDirectory(ls_LibName, DirAll!)
			
			ll_Pos = LastPos(ls_LibName, "\")
			if ll_Pos > 0 then ls_LibName = Mid(ls_LibName, ll_Pos + Len("\"))
			
			do 
				ll_Pos = Pos(ls_ObjList, "~t")
				if ll_Pos > 0 then
					ls_ObjName = Trim(Left(ls_ObjList, ll_Pos - 1))
					if ls_ObjName <> "" then
						ll_Find = dw_Modified_Objects.Find("object_name = '" + ls_ObjName + "'", 1, ll_Count)
						if ll_Find > 0 then
							dw_Modified_Objects.SetItem(ll_Find, "object_library", ls_LibName)
						end if
					end if
				end if
				
				ll_Pos = Pos(ls_ObjList, "~n")
				if ll_Pos > 0 then
					ls_ObjList = Trim(Mid(ls_ObjList, ll_Pos + Len("~n")))
				end if
			loop while ls_ObjList <> ""
		end if
	end if
loop while Trim(ls_LibList) <> ""

dw_Modified_Objects.SetRedraw(true)

end event

type dw_modified_objects from datawindow within w_modified_objects
integer x = 9
integer y = 12
integer width = 2053
integer height = 952
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

