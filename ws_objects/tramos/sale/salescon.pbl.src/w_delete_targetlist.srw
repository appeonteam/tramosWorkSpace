$PBExportHeader$w_delete_targetlist.srw
$PBExportComments$Lets the user delete targets either one at a time or grouped by date.
forward
global type w_delete_targetlist from w_targetlist
end type
type cb_delete_by_date from uo_cb_base within w_delete_targetlist
end type
end forward

global type w_delete_targetlist from w_targetlist
cb_delete_by_date cb_delete_by_date
end type
global w_delete_targetlist w_delete_targetlist

forward prototypes
public subroutine wf_delete_target ()
end prototypes

public subroutine wf_delete_target ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_delete_targetlist
  
 Object     : wf_delete_target
  
 Event	 : 

 Scope     : Public

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 29-08-96

 Description : Deletes a given target after deleting all related relations

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
29-08-96		1.0	 		JH		Initial version
24-09-96					JH		Not delete targets marked not delete
  
************************************************************************************/

Long ll_target_key
Integer li_targ_not_delete

IF MessageBox("Delete","You are about to DELETE !~r~n" + &
					"This will delete related Actions and Support Definitions.~r~n" + &
					  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN 
	return
ELSE
	ll_target_key = dw_1.GetItemNumber(dw_1.GetRow(),"ccs_targ__pk")

	/* Check if target may be deleted */
	SELECT CCS_TARG.CCS_TARG_NOT_DELETE  
   		 INTO :li_targ_not_delete  
    	FROM CCS_TARG  
  	 WHERE CCS_TARG.CCS_TARG__PK = :ll_target_key   ;

	IF li_targ_not_delete = 1 THEN
		MessageBox("Can not Delete","Target is marked Not Delete")
		Return
	ELSE
	/* Delete Action keycode*/
   		 DELETE ACTION_KEYCODES  
   		 FROM ACTION_KEYCODES,   
        		 CCS_ACTS,   
        		 CCS_TARG  
 		  WHERE ( CCS_ACTS.CCS_ACTS_PK = ACTION_KEYCODES.CCS_ACTS_PK ) and  
        		 ( CCS_TARG.CCS_TARG__PK = CCS_ACTS.CCS_TARG__PK ) and  
        		 ( ( CCS_TARG.CCS_TARG__PK = :ll_target_key ) )   ;

		IF SQLCA.SQLCode = 0 THEN
//		Delete action keycodes ok
			/* Delete Action */
 			DELETE FROM CCS_ACTS  
  			 WHERE CCS_ACTS.CCS_TARG__PK = :ll_target_key   ;

			IF SQLCA.SQLCode = 0 THEN
//			Delete actions ok
				/*Delete target keycodes */
  				DELETE FROM TARGET_KEYCODES  
  				 WHERE TARGET_KEYCODES.CCS_TARG__PK = :ll_target_key   ;
			
				IF SQLCA.SQLCode = 0 THEN
//				Delete target keycodes ok
					/*Delete charterers targets */
					 DELETE FROM CHARTERERS_TARGETS  
  					  WHERE CHARTERERS_TARGETS.CCS_TARG__PK = :ll_target_key   ;

					IF SQLCA.SQLCode = 0 THEN
//					Delete charterers targets ok
						/* Delete support definitions */
						 DELETE FROM CCS_SDEF  
 						  WHERE CCS_SDEF.CCS_TARG__PK = :ll_target_key   ;

						IF SQLCA.SQLCode = 0 THEN
//						Delete support definitions ok
							/* Delete target */
 							 DELETE FROM CCS_TARG  
  							 WHERE CCS_TARG.CCS_TARG__PK = :ll_target_key   ;
						
							IF SQLCA.SQLCode = 0 THEN
//							Delete target ok
								COMMIT ;
								dw_1.Retrieve()												
							ELSE
//								Couldn't delete target
								MessageBox("DB Error","Can not delete target table. Please try later!",StopSign!)
								ROLLBACK;
							END IF												
						ELSE
//							Couldn't delete Support definition
							MessageBox("DB Error","Not able to delete target; because can not delete support "+&
										"definition table. Please try later!",StopSign!)
							ROLLBACK;
						END IF
					ELSE
//						Couldn't delete charterers targets
						MessageBox("DB Error","Not able to delete target; because can not delete charterers "+&
									"targets table. Please try later!",StopSign!)
						ROLLBACK;
					END IF
				ELSE
//					Couldn't delete target keycodes
					MessageBox("DB Error","Not able to delete target; because can not delete targets "+&
									"keycodes table. Please try later!",StopSign!)
					ROLLBACK;
				END IF
			ELSE
//				Couldn't delete actions
				MessageBox("DB Error","Not able to delete target; because can not delete actions "+&
										"table. Please try later!",StopSign!)
				ROLLBACK;
			END IF
		ELSE
//			Couldn't delete action keycodes
			MessageBox("DB Error","Not able to delete target; because can not delete actions "+&
										"keycodes table. Please try later!",StopSign!)
			ROLLBACK;
		END IF
	END IF
END IF
end subroutine

on w_delete_targetlist.create
int iCurrent
call w_targetlist::create
this.cb_delete_by_date=create cb_delete_by_date
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=cb_delete_by_date
end on

on w_delete_targetlist.destroy
call w_targetlist::destroy
destroy(this.cb_delete_by_date)
end on

type cb_modify from w_targetlist`cb_modify within w_delete_targetlist
int TabOrder=80
boolean Visible=false
end type

type cb_delete from w_targetlist`cb_delete within w_delete_targetlist
int Y=145
int TabOrder=60
boolean Visible=true
end type

on cb_delete::clicked;/* Override ancestor script to handle cascade delete */
wf_delete_target()
This.Enabled = dw_1.GetSelectedRow(0) > 0
end on

type cb_new from w_targetlist`cb_new within w_delete_targetlist
int TabOrder=50
boolean Visible=false
end type

type cb_close from w_targetlist`cb_close within w_delete_targetlist
int TabOrder=90
end type

type cb_refresh from w_targetlist`cb_refresh within w_delete_targetlist
int TabOrder=70
end type

type cb_ok from w_targetlist`cb_ok within w_delete_targetlist
int TabOrder=100
boolean Visible=false
end type

type cb_cancel from w_targetlist`cb_cancel within w_delete_targetlist
int TabOrder=110
end type

type dw_1 from w_targetlist`dw_1 within w_delete_targetlist
int TabOrder=40
end type

on dw_1::doubleclicked;/* Override ancestor script to ignore event */
end on

type sle_find from w_targetlist`sle_find within w_delete_targetlist
int TabOrder=30
end type

type gb_2 from w_targetlist`gb_2 within w_delete_targetlist
int TabOrder=20
end type

type cb_delete_by_date from uo_cb_base within w_delete_targetlist
int X=1463
int Y=337
int Width=403
int Height=81
int TabOrder=10
string Text="Delete &by Date"
end type

on clicked;call uo_cb_base::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_delete_targetlist
  
 Object     : cb_delete_by_date
  
 Event	 : Clicked!

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 27-08-96

 Description :Open responce window; so the user can delete all targets by target end period date 

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : 

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
27-08-96		1.0 			JH		Initial version
  
************************************************************************************/
Integer li_rtn


/* Open the responce window and wait for return */	
Open(w_delete_target_date)

li_rtn = Message.DoubleParm

/* Test if changes were made */
IF li_rtn = 1 THEN
	/* Targets were deleted so refresh datawindow list */	
	dw_1.Retrieve()
	cb_delete.Enabled = dw_1.GetSelectedRow(0) > 0
	
END IF

end on

