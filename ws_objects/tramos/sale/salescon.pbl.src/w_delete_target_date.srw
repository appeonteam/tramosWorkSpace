$PBExportHeader$w_delete_target_date.srw
$PBExportComments$Response Window to delete targets by 'target period end date'.  Returns 1 if targets were deleted else 0.
forward
global type w_delete_target_date from w_sale_response
end type
type st_1 from uo_st_base within w_delete_target_date
end type
type st_2 from uo_st_base within w_delete_target_date
end type
type sle_delete from uo_sle_base within w_delete_target_date
end type
type st_3 from uo_st_base within w_delete_target_date
end type
type cb_ok from uo_cb_base within w_delete_target_date
end type
type cb_cancel from uo_cb_base within w_delete_target_date
end type
type dw_date from datawindow within w_delete_target_date
end type
end forward

global type w_delete_target_date from w_sale_response
integer width = 1394
integer height = 968
string title = "Delete Targets by Date"
boolean controlmenu = false
st_1 st_1
st_2 st_2
sle_delete sle_delete
st_3 st_3
cb_ok cb_ok
cb_cancel cb_cancel
dw_date dw_date
end type
global w_delete_target_date w_delete_target_date

forward prototypes
private subroutine wf_delete_targets ()
public subroutine documentation ()
end prototypes

private subroutine wf_delete_targets ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  :w_delete_target_date 
  
 Object     : wf_delete_target_date
  
 Event	 :

 Scope     : Private

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 27-08-96

 Description : Deletes all targets with date entered in window.

 Arguments : none

 Returns   : none  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0 			JH		Initial version
29-08-96					JH		Added code to handle cascade delete  
24-09-96					JH		Not delete targets marked not delete
************************************************************************************/

DateTime  ldt_date

ldt_date = DateTime(dw_date.GetItemDate(1,1))



/* Delete Action keycode*/
  DELETE ACTION_KEYCODES  
    FROM ACTION_KEYCODES,   
         CCS_ACTS,   
         CCS_TARG  
   WHERE ( CCS_ACTS.CCS_ACTS_PK = ACTION_KEYCODES.CCS_ACTS_PK ) and  
         ( CCS_TARG.CCS_TARG__PK = CCS_ACTS.CCS_TARG__PK ) and  
	( ( CCS_TARG.CCS_TARG_NOT_DELETE < 1 ) AND
         ( CCS_TARG.CCS_TARG_TO_D = :ldt_date ) )   ;

IF SQLCA.SQLCode = 0 THEN
//Delete action keycodes ok
	/* Delete Action */
	DELETE CCS_ACTS  
	 FROM CCS_ACTS,   
         CCS_TARG  
	 WHERE ( CCS_TARG.CCS_TARG__PK = CCS_ACTS.CCS_TARG__PK ) and  
         	( ( CCS_TARG.CCS_TARG_NOT_DELETE < 1 ) AND
        	 ( CCS_TARG.CCS_TARG_TO_D = :ldt_date ) )   ;

	IF SQLCA.SQLCode = 0 THEN
//	Delete actions ok
		/*Delete target keycodes */
  		 DELETE TARGET_KEYCODES
   		 FROM TARGET_KEYCODES ,   
       			 CCS_TARG 
 		  WHERE ( CCS_TARG.CCS_TARG__PK = TARGET_KEYCODES.CCS_TARG__PK ) and  
     				    ( ( CCS_TARG.CCS_TARG_NOT_DELETE < 1 ) AND
        				 ( CCS_TARG.CCS_TARG_TO_D = :ldt_date ) )   ;

			
		IF SQLCA.SQLCode = 0 THEN
//		Delete target keycodes ok
			/*Delete charterers targets */
			 DELETE CHARTERERS_TARGETS	  
   			 FROM  CHARTERERS_TARGETS,   
         				CCS_TARG
 			  WHERE ( CCS_TARG.CCS_TARG__PK = CHARTERERS_TARGETS.CCS_TARG__PK ) and  
   			     ( ( CCS_TARG.CCS_TARG_NOT_DELETE < 1 ) AND
        			 ( CCS_TARG.CCS_TARG_TO_D = :ldt_date ) )   ;


			IF SQLCA.SQLCode = 0 THEN
//			Delete charterers targets ok
				/* Delete support definitions */
				 DELETE CCS_SDEF  
   				 FROM CCS_SDEF,   
  				       CCS_TARG  
				 WHERE ( CCS_TARG.CCS_TARG__PK = CCS_SDEF.CCS_TARG__PK ) and  
				        ( ( CCS_TARG.CCS_TARG_NOT_DELETE < 1 ) AND
        				 ( CCS_TARG.CCS_TARG_TO_D = :ldt_date ) )   ;


				IF SQLCA.SQLCode = 0 THEN
//				Delete support definitions ok
					/* Delete target */
					  DELETE FROM CCS_TARG  
  					   WHERE ( CCS_TARG.CCS_TARG_NOT_DELETE < 1 ) AND  
        					 ( CCS_TARG.CCS_TARG_TO_D = :ldt_date )   ;
				
					IF SQLCA.SQLCode = 0 THEN
//					Delete target ok
						COMMIT ;						
					ELSE
//						Couldn't delete target
						MessageBox("DB Error","Can not delete target table. Please try later!",StopSign!)
						ROLLBACK;
					END IF												
				ELSE
//					Couldn't delete Support definition
					MessageBox("DB Error","Not able to delete target; because can not delete support "+&
								"definition table. Please try later!",StopSign!)
					ROLLBACK;
				END IF
			ELSE
//				Couldn't delete charterers targets
				MessageBox("DB Error","Not able to delete target; because can not delete charterers "+&
							"targets table. Please try later!",StopSign!)
				ROLLBACK;
			END IF
		ELSE
//			Couldn't delete target keycodes
			MessageBox("DB Error","Not able to delete target; because can not delete targets "+&
								"keycodes table. Please try later!",StopSign!)
			ROLLBACK;
		END IF
	ELSE
//	Couldn't delete actions
		MessageBox("DB Error","Not able to delete target; because can not delete actions "+&
								"table. Please try later!",StopSign!)
		ROLLBACK;
	END IF
ELSE
//	Couldn't delete action keycodes
	MessageBox("DB Error","Not able to delete target; because can not delete actions "+&
								"keycodes table. Please try later!",StopSign!)
	ROLLBACK;
END IF

end subroutine

public subroutine documentation ();/********************************************************************
	w_delete_target_date
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on open;call w_sale_response::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  :w_delete_target_date 
  
 Object     : 
  
 Event	 :Open! 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 27-08-96

 Description : Lets the user delete all targets with target period end date as entered.

 Arguments : {description/none}

 Returns   : Returns 1 if targets were deleted else 0

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0 			JH		Initial version
  
************************************************************************************/
end on

on w_delete_target_date.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.sle_delete=create sle_delete
this.st_3=create st_3
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_date=create dw_date
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_delete
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.dw_date
end on

on w_delete_target_date.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_delete)
destroy(this.st_3)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_date)
end on

type st_hidemenubar from w_sale_response`st_hidemenubar within w_delete_target_date
end type

type st_1 from uo_st_base within w_delete_target_date
integer x = 37
integer y = 112
integer width = 987
integer height = 192
integer textsize = -14
string text = "Delete ALL targets with Target Period END Date: "
alignment alignment = left!
end type

type st_2 from uo_st_base within w_delete_target_date
integer x = 37
integer y = 320
integer width = 1243
integer height = 112
integer textsize = -12
integer weight = 700
string text = "Except targets marked ~'Not Delete~'"
alignment alignment = left!
end type

type sle_delete from uo_sle_base within w_delete_target_date
integer x = 1024
integer y = 512
integer width = 256
integer height = 80
integer taborder = 10
end type

type st_3 from uo_st_base within w_delete_target_date
integer x = 640
integer y = 512
integer width = 366
integer height = 64
string text = "Write ~"Delete:~""
alignment alignment = right!
end type

type cb_ok from uo_cb_base within w_delete_target_date
integer x = 640
integer y = 720
integer width = 311
integer height = 96
integer taborder = 20
string text = "&OK"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  :w_delete_target_date 
  
 Object     : cb_ok
  
 Event	 :Clicked! 

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 27-08-96

 Description : Deletes all targets with date entered.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0 			JH		Initial version
  
************************************************************************************/

String ls_text


/* User must write delete before deleting can proceed */
ls_text = Lower(sle_delete.text)

IF ls_text = "delete" THEN
/* Deleting can proceed */
	wf_delete_targets()
	CloseWithReturn(parent,1)
	return
ELSE
	MessageBox("Information","Please write 'Delete' to delete targets with Target Period End Date: "&
				+ String(dw_date.GetItemDate(1,1)) +" !",StopSign!)
	sle_delete.SetFocus()
END IF


end event

type cb_cancel from uo_cb_base within w_delete_target_date
integer x = 969
integer y = 720
integer width = 311
integer height = 96
integer taborder = 30
string text = "Cancel"
boolean cancel = true
end type

on clicked;call uo_cb_base::clicked;CloseWithReturn(parent,0)
end on

type dw_date from datawindow within w_delete_target_date
integer x = 1019
integer y = 216
integer width = 297
integer height = 88
integer taborder = 1
boolean bringtotop = true
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

