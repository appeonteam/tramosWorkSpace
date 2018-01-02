$PBExportHeader$u_claims_analyst.sru
forward
global type u_claims_analyst from mt_u_visualobject
end type
type dw_claim_analyst from mt_u_datawindow within u_claims_analyst
end type
end forward

global type u_claims_analyst from mt_u_visualobject
integer width = 837
integer height = 64
long backcolor = 553648127
borderstyle borderstyle = styleraised!
event ue_itemchanged ( )
dw_claim_analyst dw_claim_analyst
end type
global u_claims_analyst u_claims_analyst

type variables



end variables

forward prototypes
public subroutine documentation ()
public function string of_get_analyst ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: u_claims_analyst
   <OBJECT> list the claims analysts and be able to filter reports/datawindows 
					based on the selected claims analyst.
   </OBJECT>
   <USAGE> 
   </USAGE>
   <ALSO>  used in finance_control.pbl -> w_misc_claim_statistics
												   -> w_misc_claims_settle_stat
   </ALSO>
   <HISTORY> 
		Date    		CR-Ref		Author		Comments
		08/12/16		CR2679		XSZ004		First version
		17/03/17		CR4572		XSZ004		Apply latest framework to dddw
    </HISTORY>    
********************************************************************/
end subroutine

public function string of_get_analyst ();/********************************************************************
   of_get_analyst
   <DESC></DESC>
   <RETURN> string </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		08/12/16		CR2679		XSZ004		First version
   </HISTORY>
********************************************************************/

string ls_analyst

if dw_claim_analyst.rowcount() > 0 then
	
	ls_analyst = dw_claim_analyst.getitemstring(1, "claim_analyst")
	
	if isnull(ls_analyst) then ls_analyst = ""
	
else
	ls_analyst = ""
end if

return ls_analyst
end function

on u_claims_analyst.create
int iCurrent
call super::create
this.dw_claim_analyst=create dw_claim_analyst
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_claim_analyst
end on

on u_claims_analyst.destroy
call super::destroy
destroy(this.dw_claim_analyst)
end on

event constructor;call super::constructor;n_service_manager  lnv_servicemgr
n_dw_style_service lnv_style
datawindowchild    ldwc_claimanalyst

dw_claim_analyst.x = -8
dw_claim_analyst.y = -8


dw_claim_analyst.of_set_dddwspecs(true)
dw_claim_analyst.inv_dddwsearch.of_register( )

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")

lnv_style.of_autoadjustdddwwidth(dw_claim_analyst)

dw_claim_analyst.settransobject(sqlca)
dw_claim_analyst.insertrow(0)



end event

type dw_claim_analyst from mt_u_datawindow within u_claims_analyst
integer width = 837
integer height = 64
integer taborder = 10
string dataobject = "d_ex_gr_claims_analyst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemerror;call super::itemerror;return 1
end event

event getfocus;call super::getfocus;this.post selecttext(1, 50)
end event

