$PBExportHeader$w_vessel_list.srw
$PBExportComments$w_calc_vessel_list ancestor - List window for editing vessels
forward
global type w_vessel_list from w_list
end type
type cb_tcowner from uo_securitybutton within w_vessel_list
end type
type rb_clarkson from uo_rb_base within w_vessel_list
end type
type rb_apm_vessels from uo_rb_base within w_vessel_list
end type
type st_2 from uo_st_base within w_vessel_list
end type
type dw_profit_c_no_lb from u_datawindow_sqlca within w_vessel_list
end type
type gb_table from uo_gb_base within w_vessel_list
end type
type rb_ship_type from uo_rb_base within w_vessel_list
end type
type cb_consumption from uo_cb_base within w_vessel_list
end type
end forward

global type w_vessel_list from w_list
integer width = 2277
integer height = 1664
long backcolor = 32304364
boolean center = true
cb_tcowner cb_tcowner
rb_clarkson rb_clarkson
rb_apm_vessels rb_apm_vessels
st_2 st_2
dw_profit_c_no_lb dw_profit_c_no_lb
gb_table gb_table
rb_ship_type rb_ship_type
cb_consumption cb_consumption
end type
global w_vessel_list w_vessel_list

forward prototypes
protected subroutine wf_selecttable (integer ai_tableno, boolean ai_retrieve)
end prototypes

protected subroutine wf_selecttable (integer ai_tableno, boolean ai_retrieve);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_vessel_list
  
 Object     : wf_selecttable
  
 Event	 : open

 Scope     : local

 ************************************************************************************

 Author    : Teit Aunt 
   
 Date       : 18-7-96

 Description : open the datawindow acording to the choise of the user via the radiobuttons.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
18-7-96		1.0			TA		Initial version  
************************************************************************************/
/* Selects a data window acording to the chosen radio button, and sets text on sort buttons */

long ll_sortparm
integer li_pc_no
string ls_profit_center

CHOOSE CASE ai_tableno

	CASE 1
		dw_profit_c_no_lb.Visible = true
		st_2.Text = "Sort PC no:"
		// ddlb_type.Visible = False
		dw_1.dataobject = "dw_vessel_list"
		istr_parametre.edit_datawindow = "dw_vessel"
		istr_parametre.edit_window = "w_list_detail"
		istr_parametre.column[0] = "vessel_nr"
		istr_parametre.column[1] = "vessel_nr"
		istr_parametre.column[2] = "vessel_name"
		ib_column_string[0] = FALSE
		rb_header1.text = "Number"
		rb_header2.text = "Name"
		rb_header2.Checked = true
		ll_sortparm = 2
		sle_find.Text = " "
		istr_parametre.edit_window_title = "APM vessel detail"
		
		/* Enable/disable command buttons */
		cb_new.Enabled = TRUE
		cb_delete.Enabled = FALSE
		cb_refresh.Enabled = TRUE
		cb_modify.Enabled = TRUE
		cb_tcowner.Enabled = TRUE
		cb_close.Enabled = TRUE
		dw_profit_c_no_lb.Enabled = True

		SELECT VESSELS.PC_NR
		INTO :li_pc_no
		FROM VESSELS
		WHERE VESSEL_NR = :istr_parametre.additional_numbers[2]
		COMMIT;

		If IsNull(li_pc_no) or (li_pc_no = 0) Then
			li_pc_no = uo_global.get_profitcenter_no( )
//			If IsNull(li_pc_no) or (li_pc_no = 0) Then li_pc_no = 2
		End if

		ls_profit_center = "pc_nr = " + string(li_pc_no)
		dw_1.SetFilter(ls_profit_center)
		dw_1.Filter()
		
		dw_profit_c_no_lb.SetItem(1,"pc_nr",li_pc_no)
		
	CASE 2
		li_pc_no =  uo_global.get_profitcenter_no( )		

		// dw_profit_c_no_lb.Visible = false
		// st_2.Visible = False

		dw_profit_c_no_lb.Visible = true
		st_2.Visible = true
		dw_1.dataobject = "d_calc_clarkson"
		istr_parametre.edit_datawindow = "d_calc_clarkson_detail"
		istr_parametre.edit_window = "w_list_detail"
		istr_parametre.column[0] = "cal_clrk_id"
		istr_parametre.column[1] = "cal_clrk_type"
		istr_parametre.column[2] = "cal_clrk_name"
		ib_column_string[0] = FALSE
		rb_header1.text = "Type"
		rb_header2.text = "Comp. Name"
		rb_header2.checked = true
		ll_sortparm = 2
		sle_find.Text = " "
		dw_1.SetSort("cal_clrk_name A")
		dw_1.Sort()

		/* Enable/disable command buttons */
		cb_new.Enabled = TRUE
		cb_delete.Enabled = FALSE
		cb_refresh.Enabled = TRUE
		cb_modify.Enabled = TRUE
		cb_tcowner.Enabled = FALSE
		cb_close.Enabled = TRUE
		dw_profit_c_no_lb.Enabled = True

	CASE 3
		dw_1.dataobject ="d_calc_vessel_type"
		istr_parametre.edit_datawindow = "d_calc_vessel_type_detail" 
		istr_parametre.edit_window = "w_list_detail"
		istr_parametre.column[0] = "cal_vest_type_id"
		istr_parametre.column[1] = "cal_vest_type_id"
		istr_parametre.column[2] = "cal_vest_type_name"
		ib_column_string[0] = FALSE
		rb_header1.text = "Type"
		rb_header2.text = "Name"
		rb_header2.checked = true
		ll_sortparm = 3
		sle_find.Text = " "
		istr_parametre.edit_window_title = "Ship type detail"
		dw_1.SetSort("cal_vest_type_name")
		dw_1.Sort()

		/* Enable/disable command buttons */
		cb_new.Enabled =TRUE
		cb_delete.Enabled = FALSE
		cb_refresh.Enabled = TRUE
		cb_tcowner.Enabled = FALSE
		cb_close.Enabled = TRUE
		dw_profit_c_no_lb.Enabled = False

END CHOOSE

dw_1.SetTransObject(SQLCA)
If ai_retrieve Then PostEvent("ue_retrieve")

n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_1 ,false)
end subroutine

event ue_retrieve;call super::ue_retrieve;string ls_dw_filter
integer li_pc

li_pc = uo_global.get_profitcenter_no( )
If (dw_1.dataobject = "d_calc_clarkson" and (li_pc = 2 or li_pc = 4 or li_pc = 10)) Then
	ls_dw_filter = "cal_clrk_type < 100"
	dw_1.SetFilter(ls_dw_filter)
	dw_1.Filter()
ElseIf (dw_1.dataobject = "d_calc_clarkson" and (li_pc = 8 or li_pc = 9)) Then
	ls_dw_filter = "cal_clrk_type > 600"
	dw_1.SetFilter(ls_dw_filter)
	dw_1.Filter()
End If



end event

event open;call super::open;integer li_profit_center
string ls_profit_center
datawindowchild	ldwc

rb_header2.Checked = true
rb_header2.TriggerEvent(Clicked!)

dw_profit_c_no_lb.getchild( "pc_nr", ldwc)
ldwc.setTransobject( sqlca )
ldwc.Retrieve(uo_global.is_userid )
dw_profit_c_no_lb.Retrieve(uo_global.is_userid )

st_2.Text = "Sort PC no:"
// ddlb_type.Visible = False

// Sort list and show only vessels belonging to users profit center
//Get primary profitcenter
li_profit_center = uo_global.get_profitcenter_no( )

dw_profit_c_no_lb.SetItem(1,"pc_nr",li_profit_center)

n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_1 ,false)
end event

on w_vessel_list.create
int iCurrent
call super::create
this.cb_tcowner=create cb_tcowner
this.rb_clarkson=create rb_clarkson
this.rb_apm_vessels=create rb_apm_vessels
this.st_2=create st_2
this.dw_profit_c_no_lb=create dw_profit_c_no_lb
this.gb_table=create gb_table
this.rb_ship_type=create rb_ship_type
this.cb_consumption=create cb_consumption
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_tcowner
this.Control[iCurrent+2]=this.rb_clarkson
this.Control[iCurrent+3]=this.rb_apm_vessels
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_profit_c_no_lb
this.Control[iCurrent+6]=this.gb_table
this.Control[iCurrent+7]=this.rb_ship_type
this.Control[iCurrent+8]=this.cb_consumption
end on

on w_vessel_list.destroy
call super::destroy
destroy(this.cb_tcowner)
destroy(this.rb_clarkson)
destroy(this.rb_apm_vessels)
destroy(this.st_2)
destroy(this.dw_profit_c_no_lb)
destroy(this.gb_table)
destroy(this.rb_ship_type)
destroy(this.cb_consumption)
end on

type cb_modify from w_list`cb_modify within w_vessel_list
integer x = 1792
integer y = 496
integer taborder = 110
string text = "De&tail"
end type

type cb_delete from w_list`cb_delete within w_vessel_list
integer x = 1792
integer y = 304
integer taborder = 90
boolean enabled = true
end type

type cb_new from w_list`cb_new within w_vessel_list
integer x = 1792
integer y = 208
integer taborder = 80
end type

type cb_close from w_list`cb_close within w_vessel_list
integer x = 1792
integer y = 1472
integer taborder = 170
end type

type cb_refresh from w_list`cb_refresh within w_vessel_list
integer x = 1792
integer y = 400
integer taborder = 100
end type

type rb_header1 from w_list`rb_header1 within w_vessel_list
integer x = 91
integer width = 366
integer height = 64
integer taborder = 130
long backcolor = 32304364
boolean checked = false
end type

type rb_header2 from w_list`rb_header2 within w_vessel_list
integer x = 512
integer width = 384
integer height = 64
integer taborder = 140
long backcolor = 32304364
string text = "Header 2"
boolean checked = true
end type

type st_return from w_list`st_return within w_vessel_list
long backcolor = 32304364
end type

type st_1 from w_list`st_1 within w_vessel_list
integer x = 91
integer y = 256
long backcolor = 32304364
end type

type cb_ok from w_list`cb_ok within w_vessel_list
integer x = 1792
integer y = 208
integer taborder = 0
end type

type cb_cancel from w_list`cb_cancel within w_vessel_list
integer x = 1792
integer y = 1472
integer taborder = 0
end type

type dw_1 from w_list`dw_1 within w_vessel_list
integer y = 464
integer height = 1088
integer taborder = 0
boolean border = false
end type

type gb_1 from w_list`gb_1 within w_vessel_list
integer width = 1079
integer height = 432
integer taborder = 120
long textcolor = 0
long backcolor = 32304364
end type

type sle_find from w_list`sle_find within w_vessel_list
integer x = 91
integer y = 320
integer taborder = 20
end type

type cb_tcowner from uo_securitybutton within w_vessel_list
boolean visible = false
integer x = 1481
integer y = 1136
integer width = 402
integer height = 80
integer taborder = 150
string text = "&T/C-owner"
end type

on clicked;call uo_securitybutton::clicked;LONG vessel_nr,ll_row

ll_row = dw_1.GetSelectedRow(0)
If ll_Row > 0 Then

	vessel_nr = dw_1.GetItemNumber(ll_row, "vessel_nr")

	OpenSheetWithParm(w_tcowner, vessel_nr, w_tramos_main, gi_win_pos,Original!)
end if
end on

type rb_clarkson from uo_rb_base within w_vessel_list
integer x = 1170
integer y = 208
integer width = 457
integer height = 80
integer taborder = 60
long backcolor = 32304364
string text = "Competitor"
end type

on clicked;call uo_rb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_vessels
  
 Object     : rb_clarkson
  
 Event	 : clicked

 Scope     : lokal

 ************************************************************************************

 Author    : Teit Aunt
   
 Date       : 22-7-96

 Description : {Short description}

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-7-96		1.0			TA		Initial version
************************************************************************************/
/* Calls window function to get text on radiobuttons and the right data window */

wf_selecttable(2,true)



end on

type rb_apm_vessels from uo_rb_base within w_vessel_list
integer x = 1170
integer y = 112
integer width = 494
integer height = 80
integer taborder = 50
long backcolor = 32304364
string text = "APM-vessels"
boolean checked = true
end type

on clicked;call uo_rb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_vessels
  
 Object     : rb_apm_vessels
  
 Event	 : clicked

 Scope     : local

 ************************************************************************************

 Author    : Teit Aunt
   
 Date       : 22-7-96

 Description : {Short description}

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-7-96		1.0			TA		Initial version  
************************************************************************************/
/* Select data object and put tekst on sort radio buttons */

wf_selecttable(1,true)




end on

type st_2 from uo_st_base within w_vessel_list
integer x = 1774
integer y = 32
integer width = 261
integer height = 64
long backcolor = 32304364
string text = "Sort PC-no:"
alignment alignment = right!
end type

type dw_profit_c_no_lb from u_datawindow_sqlca within w_vessel_list
integer x = 1774
integer y = 96
integer width = 457
integer height = 80
integer taborder = 30
string dataobject = "d_calc_profit_c_no_lb"
boolean border = false
boolean livescroll = false
end type

on itemchanged;call u_datawindow_sqlca::itemchanged;integer li_profit_center
string ls_profit_center

dw_profit_c_no_lb.AcceptText()
li_profit_center = dw_profit_c_no_lb.GetItemNumber(1,"pc_nr")

ls_profit_center = "pc_nr = " + string(li_profit_center)

dw_1.SetFilter(ls_profit_center)
dw_1.Filter()

end on

type gb_table from uo_gb_base within w_vessel_list
integer x = 1134
integer y = 16
integer width = 567
integer height = 432
integer taborder = 40
integer weight = 700
long backcolor = 32304364
string text = "Table"
end type

type rb_ship_type from uo_rb_base within w_vessel_list
integer x = 1170
integer y = 320
integer width = 421
integer height = 64
integer taborder = 70
boolean bringtotop = true
long backcolor = 32304364
string text = "Ship type"
end type

on clicked;call uo_rb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_vessels
  
 Object     : rb_vessel_type
  
 Event	 : clicked

 Scope     : local

 ************************************************************************************

 Author    : Teit Aunt
   
 Date       : 22-7-96

 Description : {Short description}

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
22-7-96		1.0			TA		Initial version  
************************************************************************************/
/* Select datawindow and put text on sort buttons */

wf_selecttable(3,true)





end on

type cb_consumption from uo_cb_base within w_vessel_list
integer x = 1792
integer y = 1280
integer width = 402
integer height = 80
integer taborder = 160
string text = "Consu&mption"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_vessel_dropdown
  
 Object     : cb_consumption
  
 Event	 :  clicked

 Scope     : local

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 12-8-96

 Description : 

 Arguments : 

 Returns   :   

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
12-8-96		1.0 			TA		Initial version
  
************************************************************************************/
/* Create structure to open consumption window */

s_calc_vessel_id lstr_calc_vessel_id
Long ll_row

SetNull(lstr_calc_vessel_id.l_vessel_type_id)
SetNull(lstr_calc_vessel_id.l_vessel_id)
SetNull(lstr_calc_vessel_id.l_clarkson_id)

ll_row = dw_1.GetSelectedRow(0)

If ll_row > 0 Then
	If rb_ship_type.checked then
		lstr_calc_vessel_id.l_vessel_type_id = dw_1.GetItemNumber(ll_row,"cal_vest_type_id")
	Elseif rb_apm_vessels.checked then
		lstr_calc_vessel_id.l_vessel_id = dw_1.GetItemNumber(ll_row, "vessel_nr")
	Elseif rb_clarkson.checked Then
		lstr_calc_vessel_id.l_clarkson_id = dw_1.GetItemNumber(ll_row, "cal_clrk_id")
	End if

	OpenWithParm(w_calc_consumption, lstr_calc_vessel_id)
End if
//original
end on

