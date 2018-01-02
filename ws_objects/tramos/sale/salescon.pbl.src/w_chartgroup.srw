$PBExportHeader$w_chartgroup.srw
$PBExportComments$Lets the user edit charterer groups.
forward
global type w_chartgroup from w_list
end type
type cb_update from uo_cb_base within w_chartgroup
end type
end forward

global type w_chartgroup from w_list
integer width = 1655
integer height = 1816
cb_update cb_update
end type
global w_chartgroup w_chartgroup

forward prototypes
public function boolean wf_save ()
end prototypes

public function boolean wf_save ();/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : w_chartgroup
 Object     : wf_save
 Event	 : 
 Scope     : Public
 ************************************************************************************
 Author    : Jeannette Holland
 Date       : 06-09-96
 Description : Updates the charterer group table
 Arguments : none
 Returns   : Boolean; True if it went well  
 Variables : {important variables - usually only used in Open-event scriptcode}
 Other : {other comments}
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
06-09-96		1.0	 		JH		Initial version
  
************************************************************************************/
Long 					ll_count, ll_allrows, ll_row
datawindowchild 	dwc

dw_1.AcceptText()

ll_allrows = dw_1.RowCount()

IF ll_allrows >0  THEN
	FOR ll_count= 1 TO ll_allrows
		ll_row = dw_1.GetRow()		
		IF IsNull(dw_1.GetItemString(ll_row,istr_parametre.column[1])) THEN
			MessageBox("Update Error","Please enter Chareter Group Name in row "+String(ll_row),Stopsign!)
			dw_1.ScrollToRow(ll_row)
			dw_1.SetColumn(istr_parametre.column[1])
			dw_1.SetFocus()
			Return FALSE			
		END IF		
	NEXT
END IF

IF dw_1.Update() <> 1 THEN
	MessageBox("DB Error","The database was unable to update changes. Please try again later!")
	ROLLBACK;
	Return FALSE
END IF

COMMIT;
/* Update Charterer DDDW if window is open */
if isValid(w_charterer) then
	if w_charterer.dw_charterer.getchild("ccs_chgp_pk", dwc) = 1 then
		dwc.setTransObject( sqlca )
		dwc.retrieve()
		commit;
	end if
end if

Return TRUE




end function

on closequery;call w_list::closequery;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_chartgroup
  
 Object     : 
  
 Event	 : closequery

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 06-09-96

 Description : Check if any changes has been made to charterer group list

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
06-09-96		1.0	 		JH		Initial version
  
************************************************************************************/
Integer li_ans

dw_1.AcceptText()

IF dw_1.ModifiedCount() > 0 OR dw_1.DeletedCount() > 0 THEN
	li_ans = MessageBox("Warning","You have modified the list of Charterer Group! Do you wish to save "&
						+"before closing?",Question!,YesNOCancel!)
END IF


IF li_ans = 1 THEN
	/* save changes before closing*/
	cb_update.TriggerEvent(Clicked!)
ELSEIF li_ans = 3 THEN
	/* Cancel close */
	Message.ReturnValue = 1
END IF
end on

on w_chartgroup.create
int iCurrent
call super::create
this.cb_update=create cb_update
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_update
end on

on w_chartgroup.destroy
call super::destroy
destroy(this.cb_update)
end on

event open;call super::open;integer li_profile 

/* Only Administrator and Finance profile can modify Charterer Groups */
IF uo_global.ii_access_level = 3 or uo_global.ii_user_profile = 3 then
	//
else
	cb_new.visible = false
	cb_update.visible = false
	cb_delete.visible = false
	cb_cancel.visible = false	
	dw_1.Object.DataWindow.ReadOnly='Yes'
	return
END IF



end event

type cb_modify from w_list`cb_modify within w_chartgroup
boolean visible = false
integer x = 1189
integer y = 1232
integer taborder = 80
end type

type cb_delete from w_list`cb_delete within w_chartgroup
integer x = 1189
integer y = 128
integer taborder = 60
end type

on cb_delete::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_chartgroup
  
 Object     : cb_delete
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 06-09-96

 Description : Delete a charetere Group, but only if it isn't used bu any charterers

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
06-09-96		1.0	 		JH		Initial version
  
************************************************************************************/

Long ll_row,ll_key, ll_chart

ll_row = dw_1.GetRow()
ll_key = dw_1.GetItemNumber(ll_row,istr_parametre.column[0])

IF ll_row > 0 THEN
	IF MessageBox("Delete","You are about to DELETE !~r~n Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN return
	
	IF IsNull(ll_key) THEN
	// Line don't exist in database
		dw_1.DeleteRow(ll_row)
	ELSE
		/* Only delete if charterer group isn't used by any charterer */
		SELECT CHART.CHART_NR  
   			 INTO :ll_chart  
   		FROM CHART  
  			 WHERE CHART.CCS_CHGP_PK = :ll_key   ;
	
		IF ll_chart > 0 THEN
			MessageBox("Can Not Delete","Charterer Group "+dw_1.GetItemString(ll_row,istr_parametre.column[1])+&
						" is used by charterers") 
		ELSE
			dw_1.DeleteRow(ll_row)
		END IF
	END IF

END IF

sle_find.Text =""
sle_find.SetFocus()
cb_delete.Enabled = dw_1.GetSelectedRow(0) > 0
end on

type cb_new from w_list`cb_new within w_chartgroup
integer x = 1189
integer taborder = 50
end type

on cb_new::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_chartgroup
  
 Object     : cb_new
  
 Event	 :Clicked! 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 04-09-96

 Description : Insert new row in charterer Group list to create new Charterer Group

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : Override Ancestor

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
04-09-96		1.0 			JH		Initial version
  
************************************************************************************/
Long ll_newrow

	dw_1.SetRedraw(FALSE)
	ll_newrow = dw_1.InsertRow(0)
	dw_1.ScrollToRow(ll_newrow)
	dw_1.SelectRow(0,FALSE)
	dw_1.SelectRow(ll_newrow,TRUE)
	dw_1.SetFocus()
	cb_delete.Enabled = TRUE
	dw_1.SetRedraw(TRUE)

end on

type cb_close from w_list`cb_close within w_chartgroup
integer x = 1189
integer y = 1632
integer taborder = 90
boolean cancel = true
end type

type cb_refresh from w_list`cb_refresh within w_chartgroup
integer x = 1189
integer taborder = 70
end type

type rb_header1 from w_list`rb_header1 within w_chartgroup
boolean visible = false
integer x = 1390
integer y = 800
end type

type rb_header2 from w_list`rb_header2 within w_chartgroup
boolean visible = false
integer x = 1390
integer y = 880
end type

type st_return from w_list`st_return within w_chartgroup
integer x = 1189
integer y = 1040
end type

type st_1 from w_list`st_1 within w_chartgroup
integer x = 37
integer y = 32
end type

type cb_ok from w_list`cb_ok within w_chartgroup
integer x = 1189
integer taborder = 100
end type

type cb_cancel from w_list`cb_cancel within w_chartgroup
boolean visible = false
integer x = 1189
integer y = 1312
integer taborder = 110
end type

type dw_1 from w_list`dw_1 within w_chartgroup
integer y = 192
integer width = 1115
integer height = 1524
integer taborder = 40
end type

on dw_1::rowfocuschanged;call w_list`dw_1::rowfocuschanged;/* Activate ancestors script */
ib_auto = TRUE

cb_delete.Enabled = dw_1.GetSelectedRow(0) > 0
end on

on dw_1::doubleclicked;/* Must Override the ancestors script as there is no doublecliked even here */
end on

type gb_1 from w_list`gb_1 within w_chartgroup
boolean visible = false
integer x = 1317
integer y = 768
integer width = 878
integer height = 192
end type

type sle_find from w_list`sle_find within w_chartgroup
integer x = 18
integer y = 96
integer width = 1115
integer taborder = 30
end type

type cb_update from uo_cb_base within w_chartgroup
integer x = 1189
integer y = 224
integer width = 402
integer height = 80
integer taborder = 20
string text = "&Update"
end type

event clicked;call super::clicked;IF wf_save()  THEN
	parent.postevent("ue_retrieve")
END IF

end event

