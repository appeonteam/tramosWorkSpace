$PBExportHeader$w_convert_unctad.srw
$PBExportComments$Window for converting TRAMOS to UNCTAD codes
forward
global type w_convert_unctad from mt_w_sheet
end type
type cb_doit from commandbutton within w_convert_unctad
end type
type cb_close from commandbutton within w_convert_unctad
end type
type dw_unctad_convert_result from datawindow within w_convert_unctad
end type
type rb_all from uo_rb_base within w_convert_unctad
end type
type rb_failed from uo_rb_base within w_convert_unctad
end type
type rb_diff from uo_rb_base within w_convert_unctad
end type
type rb_ok from uo_rb_base within w_convert_unctad
end type
type st_totals from statictext within w_convert_unctad
end type
type gb_1 from uo_gb_base within w_convert_unctad
end type
type cb_print from commandbutton within w_convert_unctad
end type
type cbx_readonly from uo_cbx_base within w_convert_unctad
end type
type cb_save from commandbutton within w_convert_unctad
end type
end forward

global type w_convert_unctad from mt_w_sheet
integer width = 2697
integer height = 1140
string title = "Update UNCTAD Table"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean center = true
cb_doit cb_doit
cb_close cb_close
dw_unctad_convert_result dw_unctad_convert_result
rb_all rb_all
rb_failed rb_failed
rb_diff rb_diff
rb_ok rb_ok
st_totals st_totals
gb_1 gb_1
cb_print cb_print
cbx_readonly cbx_readonly
cb_save cb_save
end type
global w_convert_unctad w_convert_unctad

type variables
Boolean ib_working, ib_cancel
end variables

on w_convert_unctad.create
int iCurrent
call super::create
this.cb_doit=create cb_doit
this.cb_close=create cb_close
this.dw_unctad_convert_result=create dw_unctad_convert_result
this.rb_all=create rb_all
this.rb_failed=create rb_failed
this.rb_diff=create rb_diff
this.rb_ok=create rb_ok
this.st_totals=create st_totals
this.gb_1=create gb_1
this.cb_print=create cb_print
this.cbx_readonly=create cbx_readonly
this.cb_save=create cb_save
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_doit
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.dw_unctad_convert_result
this.Control[iCurrent+4]=this.rb_all
this.Control[iCurrent+5]=this.rb_failed
this.Control[iCurrent+6]=this.rb_diff
this.Control[iCurrent+7]=this.rb_ok
this.Control[iCurrent+8]=this.st_totals
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.cb_print
this.Control[iCurrent+11]=this.cbx_readonly
this.Control[iCurrent+12]=this.cb_save
end on

on w_convert_unctad.destroy
call super::destroy
destroy(this.cb_doit)
destroy(this.cb_close)
destroy(this.dw_unctad_convert_result)
destroy(this.rb_all)
destroy(this.rb_failed)
destroy(this.rb_diff)
destroy(this.rb_ok)
destroy(this.st_totals)
destroy(this.gb_1)
destroy(this.cb_print)
destroy(this.cbx_readonly)
destroy(this.cb_save)
end on

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : This window is used for converting a BIMCO portlist into the UNCTAD
 					table/XLS. Since this processing has been done, this window is now
					obsolete, but is kept just incase.....

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

end event

type cb_doit from commandbutton within w_convert_unctad
integer x = 1975
integer y = 816
integer width = 247
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

on clicked;
ib_working = true
ib_cancel = false
cb_close.text = "&Cancel"

dw_unctad_convert_result.Setredraw(false)
SetPointer(Hourglass!)

Integer li_handle, li_result, li_tmp, li_ok, li_diff, li_failed
String ls_unctad, ls_datastring, ls_country, ls_portname, ls_code, ls_tmp
Long ll_row 

li_handle = FileOpen("H:\SYSTEM3.DEV\CALCULE\UNCTAD\PORTS.TXT")
If li_handle > 0 Then
	DO
		If Mod(ll_row, 10)=0 Then 
			Yield()
			
			If ib_cancel Then
				ib_cancel = false

				If MessageBox("Cancel", "Do you want to cancel ?", Question!, YesNo!, 2) = 1 Then
					dw_unctad_convert_result.reset()
					Exit
				End if										
			End if		

			st_totals.text = "Lines: "+String(ll_row)
		End if
		li_result = FileRead(li_Handle, ls_datastring) 

		If li_result > 0 Then // Der er noget data
			ls_unctad = Trim(Mid(ls_datastring, 1 , 6))
			ls_country = Trim(Mid(ls_datastring, 7, 45))
			ls_portname = Trim(Mid(ls_datastring, 52))
			ls_tmp = "<error>"

			li_tmp = Pos(ls_portname, "(")
			If li_tmp > 0 Then ls_portname = Left(ls_portname, li_tmp -2)

			If Len(ls_unctad)>0 And  Len(ls_country)>0 And Len(ls_portName)>0 Then
				// Her er valide data
				ls_code = Mid(ls_unctad, 3)

				If not cbx_readonly.checked Then
					SELECT PORT_N
					INTO :ls_tmp
					FROM PORTS
					WHERE PORT_CODE = :ls_code;
					COMMIT;
			
					CHOOSE CASE SQLCA.SQLCode
						CASE -100 
							// More than one found
							li_tmp = -2
							li_failed ++
						CASE -1
							// Error
							li_tmp = -1
							li_failed ++
						CASE 0
							// Succes
							If Upper(ls_tmp) <> Upper(ls_portname)	 Then
								li_tmp = 1					
								li_diff ++
							Else
								/* UPDATE PORTS
								SET PORT_UNCTAD = :ls_unctad
								WHERE PORT_CODE = :ls_code;
								
								COMMIT USING SQLCA;
								*/
								li_tmp = 0
								li_ok ++
							End if
						CASE ELSE
							li_tmp = -3
							li_failed ++
					END CHOOSE
				Else
					ls_tmp = ""
					li_tmp = 0
				End if			

				ll_row = dw_unctad_convert_result.InsertRow(0)
				dw_unctad_convert_result.ScrollToRow(ll_row)

				dw_unctad_convert_result.SetItem(ll_row, "unctad", ls_unctad)
				dw_unctad_convert_result.SetItem(ll_row, "country", ls_country)
				dw_unctad_convert_result.SetItem(ll_row, "name", ls_portname)
				dw_unctad_convert_result.SetItem(ll_row, "tramos_name", ls_tmp)
				dw_unctad_convert_result.SetItem(ll_row, "code", li_tmp)
			End if
		End if
	LOOP UNTIL li_result < 0

	If li_result = -1 Then MessageBox("Error", "There was an error during fileread")
	FileClose(li_handle)
Else
	MessageBox("Error", "Error during opening of ports.txt")
End if

st_totals.text = "ok: "+String(li_ok)+" diff: "+String(li_diff)+" failed: "+String(li_failed)+" total: "+String(li_ok + li_diff + li_failed)

If cbx_readonly.checked Then
	dw_unctad_convert_result.SetSort("name A")
	dw_unctad_convert_result.Sort()
End if

rb_all.enabled =not cbx_readonly.checked
rb_diff.enabled =not cbx_readonly.checked
rb_failed.enabled =not cbx_readonly.checked
rb_ok.enabled =not cbx_readonly.checked

dw_unctad_convert_result.Setredraw(true)
SetPointer(Arrow!)

cb_close.text = "&Close"
ib_working = false
end on

type cb_close from commandbutton within w_convert_unctad
integer x = 2249
integer y = 816
integer width = 247
integer height = 108
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

on clicked;If ib_working then ib_cancel = true else Close(Parent)
end on

type dw_unctad_convert_result from datawindow within w_convert_unctad
integer x = 18
integer y = 32
integer width = 2615
integer height = 752
integer taborder = 20
string dataobject = "d_unctad_convert_result"
boolean vscrollbar = true
boolean livescroll = true
end type

type rb_all from uo_rb_base within w_convert_unctad
integer x = 73
integer y = 864
long backcolor = 81324524
string text = "All"
boolean checked = true
end type

on clicked;call uo_rb_base::clicked;dw_unctad_convert_result.SetFilter("")
dw_unctad_convert_result.Filter()


end on

type rb_failed from uo_rb_base within w_convert_unctad
integer x = 1006
integer y = 864
long backcolor = 81324524
string text = "Failed"
end type

on clicked;call uo_rb_base::clicked;dw_unctad_convert_result.SetFilter("code<0")
dw_unctad_convert_result.Filter()

end on

type rb_diff from uo_rb_base within w_convert_unctad
integer x = 658
integer y = 864
integer width = 311
integer height = 80
long backcolor = 81324524
string text = "Name Diff"
end type

on clicked;call uo_rb_base::clicked;dw_unctad_convert_result.SetFilter("Code=1")
dw_unctad_convert_result.Filter()

end on

type rb_ok from uo_rb_base within w_convert_unctad
integer x = 329
integer y = 864
long backcolor = 81324524
string text = "All OK"
end type

on clicked;call uo_rb_base::clicked;dw_unctad_convert_result.SetFilter("Code=0")
dw_unctad_convert_result.Filter()

end on

type st_totals from statictext within w_convert_unctad
integer x = 18
integer y = 976
integer width = 1554
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
boolean focusrectangle = false
end type

type gb_1 from uo_gb_base within w_convert_unctad
integer x = 18
integer y = 800
integer width = 1280
integer height = 160
integer taborder = 10
integer weight = 700
long textcolor = 33554432
long backcolor = 81324524
string text = "Filter"
end type

type cb_print from commandbutton within w_convert_unctad
integer x = 1701
integer y = 816
integer width = 247
integer height = 108
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

on clicked;dw_unctad_convert_result.Print()
end on

type cbx_readonly from uo_cbx_base within w_convert_unctad
integer x = 1719
integer y = 944
integer width = 731
integer height = 64
long backcolor = 81324524
string text = "Read BIMCO (no processing)"
end type

type cb_save from commandbutton within w_convert_unctad
integer x = 1408
integer y = 816
integer width = 247
integer height = 108
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save"
end type

on clicked;If dw_unctad_convert_result.SaveAs("H:\SYSTEM3.DEV\CALCULE\DIFF.XLS", Excel!, True)<>1 Then &
	MessageBox("Fejl", "Fejl under lagring")
end on

