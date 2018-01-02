$PBExportHeader$w_calc_expiry.srw
$PBExportComments$List of expiried calculations
forward
global type w_calc_expiry from mt_w_response_calc
end type
type cb_2 from uo_cb_base within w_calc_expiry
end type
type cb_delete from uo_cb_base within w_calc_expiry
end type
type st_1 from uo_st_base within w_calc_expiry
end type
type dw_calc_expiry from uo_datawindow_multiselect within w_calc_expiry
end type
end forward

global type w_calc_expiry from mt_w_response_calc
integer x = 87
integer y = 480
integer width = 2802
integer height = 864
string title = "Expired Calculations"
long backcolor = 32304364
string icon = "images\calcmenu.ICO"
cb_2 cb_2
cb_delete cb_delete
st_1 st_1
dw_calc_expiry dw_calc_expiry
end type
global w_calc_expiry w_calc_expiry

type variables
// Private (Kun denne), Protected (Andre kun læse), Public (Alle)
Private boolean iv_b_all_flaged
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_calc_expiry
	
	<OBJECT>

	</OBJECT>
	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
	<HISTORY>
		Date    		Ref   	Author		Comments
		07/08/14		CR3708	AGL027		F1 help application coverage - corrected ancestor
		28/08/14		CR3708	CCY018		F1 help application coverage - fixed a problem
		12/09/14		CR3773	XSZ004		Change icon absolute path to reference path
	</HISTORY>
*****************************************************************/
end subroutine

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_expiry
  
 Object     : 
  
 Event	 :  open

 Scope     : local

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 23-7-96

 Description : Opens window if rows is to be deleted

 Arguments : non

 Returns   :   non

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
------------------------------------------------------------------------------------
23-7-96			1.0 		TA		Initial version
  
************************************************************************************/
/* If retrieve gets result the window is allowed to open, else it is closed */ 

mt_n_datastore lds_calc_expiry

lds_calc_expiry = message.powerobjectparm

dw_calc_expiry.SetTransObject(SQLCA)
lds_calc_expiry.sharedata( dw_calc_expiry)

/* Selects all rows in data window */

dw_calc_expiry.SelectRow(0,TRUE)

iv_b_all_flaged = TRUE

n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_calc_expiry,false)

end event

on w_calc_expiry.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_delete=create cb_delete
this.st_1=create st_1
this.dw_calc_expiry=create dw_calc_expiry
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_calc_expiry
end on

on w_calc_expiry.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_delete)
destroy(this.st_1)
destroy(this.dw_calc_expiry)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_expiry
end type

type cb_2 from uo_cb_base within w_calc_expiry
integer x = 2423
integer y = 644
integer width = 343
integer height = 100
integer taborder = 20
string text = "&Close"
end type

on clicked;call uo_cb_base::clicked;close(w_calc_expiry)
end on

type cb_delete from uo_cb_base within w_calc_expiry
integer x = 2062
integer y = 644
integer width = 343
integer height = 100
integer taborder = 30
string text = "&Delete"
boolean default = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_expiry
  
 Object     : cb_delete
  
 Event	 :  clicked

 Scope     : local

 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 23-7-96

 Description : If all row are marked they are deleted, if one row is marked it is deleted

 Arguments : 

 Returns   :   true if succesful, false is an error occured

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
------------------------------------------------------------------------------------
23-7-96		1.0 			TA		Initial version
  
************************************************************************************/
/* Delete all selected rows */

long ll_RowNum

ll_rownum =  dw_calc_expiry.GetSelectedRow(0)

DO WHILE ll_rownum > 0 
	dw_calc_expiry.SetItem(ll_RowNum,"cal_calc_cal_calc_status",0)
	ll_RowNum = dw_calc_expiry.GetSelectedRow(ll_rownum)
LOOP

If dw_calc_expiry.Update() = 1 Then
	COMMIT;
Else
	ROLLBACK;
	MessageBox("Error","Could not update the database")
End if

dw_calc_expiry.Retrieve(Today(), uo_global.is_userid )

// Tell manager that's somethings changed

If IsValid(w_calc_manager) Then w_calc_manager.TriggerEvent("ue_datachanged")
end event

type st_1 from uo_st_base within w_calc_expiry
integer x = 18
integer y = 20
integer width = 1979
long backcolor = 32304364
string text = "These calculations have expired. Press ~'Delete~' to delete all highlighted entries."
alignment alignment = left!
end type

type dw_calc_expiry from uo_datawindow_multiselect within w_calc_expiry
integer x = 18
integer y = 100
integer width = 2743
integer height = 512
integer taborder = 10
string dataobject = "d_calc_expiry"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

on clicked;call uo_datawindow_multiselect::clicked;cb_delete.Enabled = This.GetSelectedRow(0)>0 
end on

on constructor;call uo_datawindow_multiselect::constructor;ib_simpleselect = true
end on

