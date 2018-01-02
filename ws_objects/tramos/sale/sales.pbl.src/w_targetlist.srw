$PBExportHeader$w_targetlist.srw
$PBExportComments$This window lets the user edit a target.
forward
global type w_targetlist from w_list
end type
type cbx_filter_on_off from uo_cbx_base within w_targetlist
end type
type gb_2 from uo_gb_base within w_targetlist
end type
end forward

global type w_targetlist from w_list
cbx_filter_on_off cbx_filter_on_off
gb_2 gb_2
end type
global w_targetlist w_targetlist

on w_targetlist.create
int iCurrent
call super::create
this.cbx_filter_on_off=create cbx_filter_on_off
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_filter_on_off
this.Control[iCurrent+2]=this.gb_2
end on

on w_targetlist.destroy
call super::destroy
destroy(this.cbx_filter_on_off)
destroy(this.gb_2)
end on

type cb_modify from w_list`cb_modify within w_targetlist
integer y = 224
integer taborder = 70
end type

on cb_modify::clicked;
Long ll_row
S_target lstr_parm

ll_row = dw_1.GetSelectedRow(0)

If ll_Row > 0 Then
	lstr_parm.target_pk = dw_1.GetItemNumber(ll_row,"ccs_targ__pk" )
	OpenSheetWithParm(w_target_detail,lstr_parm,w_tramos_main,7,Original!)
End if
end on

type cb_delete from w_list`cb_delete within w_targetlist
boolean visible = false
integer taborder = 50
end type

type cb_new from w_list`cb_new within w_targetlist
integer taborder = 40
end type

on cb_new::clicked;s_target lstr_parm

lstr_parm.target_pk = 0
lstr_parm.charterer_pk = 0
lstr_parm.charterer_name = ""

OpenSheetWithParm(w_target_detail,lstr_parm,w_tramos_main,7,Original!)

end on

type cb_close from w_list`cb_close within w_targetlist
integer y = 304
integer taborder = 80
end type

type cb_refresh from w_list`cb_refresh within w_targetlist
integer y = 128
integer taborder = 60
end type

on cb_refresh::clicked;call w_list`cb_refresh::clicked;cb_modify.Enabled = dw_1.GetSelectedRow(0) > 0
end on

type rb_header1 from w_list`rb_header1 within w_targetlist
integer x = 91
integer y = 160
end type

type rb_header2 from w_list`rb_header2 within w_targetlist
integer x = 603
integer y = 160
integer width = 512
end type

type st_return from w_list`st_return within w_targetlist
end type

type st_1 from w_list`st_1 within w_targetlist
integer x = 91
end type

type cb_ok from w_list`cb_ok within w_targetlist
integer taborder = 90
end type

type cb_cancel from w_list`cb_cancel within w_targetlist
integer y = 304
integer taborder = 100
end type

type dw_1 from w_list`dw_1 within w_targetlist
integer taborder = 30
end type

type gb_1 from w_list`gb_1 within w_targetlist
integer y = 32
integer height = 464
end type

type sle_find from w_list`sle_find within w_targetlist
integer x = 91
integer taborder = 20
end type

type cbx_filter_on_off from uo_cbx_base within w_targetlist
integer x = 1262
integer y = 416
integer width = 375
integer height = 72
string text = "Filter ON/OFF "
end type

on clicked;call uo_cbx_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_targetlist
  
 Object     : cbx_filter_on_off
  
 Event	 : Clicked

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 21-08-96

 Description : Will set filter on list accordingly to Sort/Search and text in Find.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
21-08-96		1.0 			JH		Initial version
  
************************************************************************************/


IF This.Checked THEN
/* Filter ON */
	IF sle_find.Text = "" THEN
		/*Specify filter creteria*/
		Messagebox("Infomation","Please Enter Filter Criteria",StopSign!)
		This.Checked = FALSE
		sle_find.SetFocus()
	ELSE
		IF rb_header1.Checked THEN
			/* Filter on Sales person */
			dw_1.SetFilter("userid = '"+Upper(sle_find.text)+"'")
		ELSEIF rb_header2.Checked THEN
			/* Filter on Description */
			dw_1.SetFilter("ccs_targ_desc = '"+sle_find.text+"'")
		END IF
		dw_1.Filter()
	END IF
ELSE
/* Filter OFF */
	dw_1.SetFilter("")
	dw_1.Filter()
	sle_find.SetFocus()
END IF

end on

type gb_2 from uo_gb_base within w_targetlist
integer x = 1243
integer y = 400
integer width = 402
integer height = 112
integer taborder = 10
string text = ""
end type

