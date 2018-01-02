$PBExportHeader$w_print_preview.srw
$PBExportComments$Used for previewing gas reports.
forward
global type w_print_preview from mt_w_main
end type
type st_xml_notice from statictext within w_print_preview
end type
type cb_open from commandbutton within w_print_preview
end type
type cb_delete from commandbutton within w_print_preview
end type
type cb_insert from commandbutton within w_print_preview
end type
type cb_print from commandbutton within w_print_preview
end type
type cb_close from commandbutton within w_print_preview
end type
type dw_report from datawindow within w_print_preview
end type
type cb_save_as from commandbutton within w_print_preview
end type
end forward

global type w_print_preview from mt_w_main
integer x = 101
integer y = 100
integer width = 4402
integer height = 2216
boolean maxbox = false
boolean resizable = false
st_xml_notice st_xml_notice
cb_open cb_open
cb_delete cb_delete
cb_insert cb_insert
cb_print cb_print
cb_close cb_close
dw_report dw_report
cb_save_as cb_save_as
end type
global w_print_preview w_print_preview

type variables
Private str_parm istr_parm

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref		Author			Comments
   	21/08/14 CR3708		CCY018		F1 help application coverage - modified ancestor.
   </HISTORY>
********************************************************************/
end subroutine

on w_print_preview.create
int iCurrent
call super::create
this.st_xml_notice=create st_xml_notice
this.cb_open=create cb_open
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.cb_print=create cb_print
this.cb_close=create cb_close
this.dw_report=create dw_report
this.cb_save_as=create cb_save_as
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_xml_notice
this.Control[iCurrent+2]=this.cb_open
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_insert
this.Control[iCurrent+5]=this.cb_print
this.Control[iCurrent+6]=this.cb_close
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.cb_save_as
end on

on w_print_preview.destroy
call super::destroy
destroy(this.st_xml_notice)
destroy(this.cb_open)
destroy(this.cb_delete)
destroy(this.cb_insert)
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.dw_report)
destroy(this.cb_save_as)
end on

event open;	/*************************************************************************************
DATE			INITIALS		DESCRIPTION
06-07-2000	TAU			
*************************************************************************************/
Long ll_count, ll_rows
Double ld_outstanding

istr_parm = Message.PowerObjectParm

this.title = "Standard Report - " + istr_parm.report_name

If Not IsNull(istr_parm.blb_data) Then
	If dw_report.SetFullState(istr_parm.blb_data) = -1 Then
		MessageBox("Error","It was not possible to populate print preview window")
	End if

	dw_report.Modify("Parameters.Text='"+istr_parm.parameters+"'")
End if

// check if an xml template is associated to the datawindow.  display info
if dw_report.Describe("DataWindow.Export.XML.TemplateCount")<>"0" then
	st_xml_notice.visible=true
end if

CHOOSE CASE istr_parm.report_name
	CASE "Charterer Demurrage Statistics","Broker Demurrage Statistics"
		cb_insert.Visible = TRUE
		cb_insert.Enabled = TRUE
		cb_delete.Visible = TRUE
		cb_delete.Enabled = TRUE
		cb_open.Visible = TRUE
		cb_open.Enabled = TRUE
		dw_report.SetTabOrder(15,10)
		dw_report.SetTabOrder(28,20)
		dw_report.SetTabOrder(19,30)
		dw_report.SetTabOrder(21,40)
		dw_report.SetTabOrder(26,50)
		dw_report.SetTabOrder(27,60)
		
		dw_report.Modify("t_charterer_names.Text='"+istr_parm.charterer_names+"'")
		
	CASE "Empty"
		cb_insert.Visible = TRUE
		cb_insert.Enabled = TRUE
		cb_delete.Visible = TRUE
		cb_delete.Enabled = TRUE
		cb_open.Visible = TRUE
		cb_open.Enabled = TRUE
		
END CHOOSE

// Set pointer to arrow
SetPointer(Arrow!)


end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_print_preview
end type

type st_xml_notice from statictext within w_print_preview
boolean visible = false
integer x = 2231
integer y = 2032
integer width = 1024
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "This report is available in an advanced format.  Default export type is XML"
boolean focusrectangle = false
end type

type cb_open from commandbutton within w_print_preview
boolean visible = false
integer x = 2043
integer y = 2036
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Open"
end type

event clicked;/*************************************************************************************
DATE			INITIALS		DESCRIPTION
29-05-2001	TAU			Initial version.
*************************************************************************************/
String ls_path, ls_filename
Integer li_value

li_value = GetFileOpenName("Open Report", ls_path, ls_filename)

If li_value = 1 Then 
	dw_report.DataObject = ls_filename
Else
	MessageBox("Error","It was not possible to open the specified file",StopSign!,OK!)
End if
end event

type cb_delete from commandbutton within w_print_preview
boolean visible = false
integer x = 2848
integer y = 2036
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;/*************************************************************************************
DATE			INITIALS		DESCRIPTION
06-07-2000	TAU			
*************************************************************************************/
Long ll_row

ll_row = dw_report.GetRow()
dw_report.DeleteRow(ll_row)
end event

type cb_insert from commandbutton within w_print_preview
boolean visible = false
integer x = 2446
integer y = 2036
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Insert"
end type

event clicked;/*************************************************************************************
DATE			INITIALS		DESCRIPTION
17-05-2001	TAU			Initial version
*************************************************************************************/
Long ll_row, ll_null, ll_colour_above, ll_colour_current
DateTime ldt_null

SetNull(ll_null)
SetNull(ldt_null)

// Copy current row as new row and delete contents
ll_row = dw_report.GetRow()
dw_report.RowsCopy(ll_row,ll_row,Primary!,dw_report,ll_row,Primary!)

// Check current colour and insert appropriate colour on new line
If ll_row > 1 Then
	ll_colour_above = dw_report.GetItemNumber(ll_row - 1,"colour_change")
Else
	ll_colour_above = 0
End if
ll_colour_current = dw_report.GetItemNumber(ll_row,"colour_change")

If ll_colour_current = 0 and ll_colour_above = 0 then
	dw_report.SetItem(ll_row,"colour_change",0)
Elseif ll_colour_current = 1 and ll_colour_above = 0 then
	dw_report.SetItem(ll_row,"colour_change",0)
Elseif ll_colour_current = 1 and ll_colour_above = 1 then
	// If above is a different row insert white row
	If dw_report.GetItemNumber(ll_row,"claim_amount") > 0 Then
		dw_report.SetItem(ll_row,"colour_change",0)
	Else
		dw_report.SetItem(ll_row,"colour_change",1)
	End if
End if

dw_report.SetItem(ll_row,"vessels_vessel_name","")
dw_report.SetItem(ll_row,"claims_voyage_nr","")
dw_report.SetItem(ll_row,"vessels_vessel_nr",ll_null)
dw_report.SetItem(ll_row,"claims_cp_date",ldt_null)
dw_report.SetItem(ll_row,"claims_forwarding_date",ldt_null)
dw_report.SetItem(ll_row,"settlement_date",ldt_null)
dw_report.SetItem(ll_row,"outstanding_days",ll_null)
dw_report.SetItem(ll_row,"no_outstanding_days","")
dw_report.SetItem(ll_row,"claim_amount",ll_null)
dw_report.SetItem(ll_row,"outstanding",ll_null)
dw_report.SetItem(ll_row,"nill_outstanding","")
dw_report.SetItem(ll_row,"balance",ll_null)
dw_report.SetItem(ll_row,"claim_recieved_pct",ll_null)
dw_report.SetItem(ll_row,"counting",0)
dw_report.SetItem(ll_row,"claim_action_c_action_date",ldt_null)
dw_report.SetItem(ll_row,"comments","")
dw_report.SetItem(ll_row,"codes","")

CHOOSE CASE istr_parm.report_name
	CASE "Charterer Demurrage Statistics"
				dw_report.SetItem(ll_row,"broker_name","")
		
	CASE "Broker Demurrage Statistics"
				dw_report.SetItem(ll_row,"chart_chart_n_1","")
		
END CHOOSE
end event

type cb_print from commandbutton within w_print_preview
integer x = 3653
integer y = 2036
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
boolean default = true
end type

event clicked;/*************************************************************************************
DATE			INITIALS		DESCRIPTION
06-07-2000	TAU			
*************************************************************************************/
SetPointer(HourGlass!)
If dw_report.Print(False) = 1 Then
	Open(w_printed)
Else
	MessageBox("Error","It was not possible to print the report",StopSign!,OK!)
End if

SetPointer(Arrow!)

end event

type cb_close from commandbutton within w_print_preview
integer x = 4055
integer y = 2036
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;/*************************************************************************************
DATE			INITIALS		DESCRIPTION
06-07-2000	TAU			
*************************************************************************************/
Close(Parent)
end event

type dw_report from datawindow within w_print_preview
integer x = 14
integer y = 12
integer width = 4384
integer height = 2004
string title = "none"
string dataobject = "d_tdf"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event sqlpreview;MessageBox("", sqlsyntax )
end event

type cb_save_as from commandbutton within w_print_preview
integer x = 3255
integer y = 2036
integer width = 343
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As"
end type

event clicked;/*************************************************************************************
DATE			INITIALS		DESCRIPTION
25-07-2000	TAU
22-10-2009	AGL			Added option to include computed fields when exporting
*************************************************************************************/

if dw_report.Describe("DataWindow.Export.XML.TemplateCount")<>"0" then
	dw_report.SaveAs("",XML!,True)
else
	dw_report.SaveAs("",Excel5!,True)
end if
end event

