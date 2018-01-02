$PBExportHeader$u_demurrage_analyst.sru
$PBExportComments$The object is used to filter the result list based on predefined demurrage analyst.
forward
global type u_demurrage_analyst from userobject
end type
type dw_demurrage_analyst from datawindow within u_demurrage_analyst
end type
end forward

global type u_demurrage_analyst from userobject
integer width = 823
integer height = 68
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_demurrage_analyst dw_demurrage_analyst
end type
global u_demurrage_analyst u_demurrage_analyst

type variables

end variables

forward prototypes
public subroutine of_reset ()
private subroutine documentation ()
public function string of_itemchanged (datawindow adw, singlelineedit asle_vessels, multilineedit amle_charterers, ref s_demurrage_stat_selection astr_parm, boolean abl_dwselect)
public function string of_itemchanged (datawindow adw, singlelineedit asle_vessels, singlelineedit asle_charterers, ref s_demurrage_stat_selection astr_parm, boolean abl_dwselect)
end prototypes

public subroutine of_reset ();/********************************************************************
   of_reset()
   <DESC>     This function is to set the display value in dw_demurrage_analyst to empty
				  when the vessel text field is empty.				
   </DESC>
   <RETURN> None																	</RETURN>
   <ACCESS> Public																	</ACCESS>
   <ARGS>    																			</ARGS>
   <USAGE>  Called from the vessel question mark button of the parent window.				
   </USAGE>
********************************************************************/

dw_demurrage_analyst.setitem(1, "userid", "")

end subroutine

private subroutine documentation ();/********************************************************************
   ObjectName: u_demurrage_analyst
   <OBJECT> list the demurrage analysts and be able to filter reports/datawindows 
					based on the selected demurrage analyst.
   </OBJECT>
   <USAGE> can be used when need a report (need to have vessel, profitcenter fields) 
				on the predefined user (demurrage analyst) level.
   </USAGE>
   <ALSO>  used in finance_control.pbl -> w_demurrage_section
												   -> w_demurrage_section_settle_stat
   </ALSO>
   <HISTORY> 
		Date			CR-Ref	 Author		Comments
		09/02/10		1395	 	Jing Sun		first version
		07/28/11    2411     LGX001      add the charterer demurrage analyst
		07/12/17    4651     EPE080      add overloaded function for of_change()
    </HISTORY>    
********************************************************************/

end subroutine

public function string of_itemchanged (datawindow adw, singlelineedit asle_vessels, multilineedit amle_charterers, ref s_demurrage_stat_selection astr_parm, boolean abl_dwselect);/********************************************************************
   of_itemchanged(/*datawindow adw */, /*singlelineedit asle_vessels*/,
						/*s_demurrage_stat_selection astr_parm*/,/*boolean abl_dwselect*/)
   <DESC>     This function is to set the values for the filter of the parent window.
				  and also set the values for the vessel text field of the parent window.
   </DESC>
   <RETURN> String:	<LI> ls_vessel_filter, X ok<LI> "-1", X failed			</RETURN>
   <ACCESS> Public																	</ACCESS>
   <ARGS>    adw: profit center datawindow, which need to be selected/highlighted when the call
						if from ue_userrespitemchagned event of the parent window.
				 asle_vessels, vessel text field
				 astr_parm: structure to save all the filter parameters.
				 abl_dwselect: judge if the call if from ue_userrespitemchagned event 
				 				   of the parent window or from the click event of the profit 
								   center list.
   </ARGS>
   <USAGE>  Called from ue_userrespitemchagned event and click event of the profit center list
				 of the parent window.
   </USAGE>
********************************************************************/

string 		ls_empty[], ls_vessel_filter, ls_null, ls_pclist
string		ls_vessels_list, ls_charterer_list
integer		li_empty[]
long			ll_row, ll_dem_analyst_rows, ll_pc_nr, ll_pc_rows, ll_found_row

datastore	lds_dem_analyst, lds_dem_chart_analyst

CONSTANT string ls_DELIMITER = ", "

ls_pclist = ls_DELIMITER

//reset
asle_vessels.text       = ""
amle_charterers.text    = ""
astr_parm.vessel_ref_nr = ls_empty
astr_parm.vessel_nr     = li_empty
astr_parm.chart_nr      = li_empty

if abl_dwselect then
	astr_parm.profitcenter = li_empty
	adw.selectrow(0, false)
	
	//get analyst id
	dw_demurrage_analyst.accepttext()
	astr_parm.analyst = dw_demurrage_analyst.getitemstring(1, "userid")
end if

//set values 
if not isnull(astr_parm.analyst) then
	lds_dem_analyst = create datastore
	lds_dem_chart_analyst = create datastore
	
	if abl_dwselect then
		lds_dem_analyst.dataobject = "d_demurrage_stat_select_vessel_all"
		lds_dem_analyst.settransobject(SQLCA)
		lds_dem_analyst.retrieve(astr_parm.analyst)
		
		//CR2411 Added by LGX001 on 25/07/2011. Change desc: get the charterers with claims, which the selected demurrage analyst is responsible for
		lds_dem_chart_analyst.dataobject = "d_sq_gr_dem_stat_select_charterer_all"
		lds_dem_chart_analyst.settransobject(SQLCA)
		lds_dem_chart_analyst.retrieve(astr_parm.analyst)
	else
		lds_dem_analyst.dataobject = "d_demurrage_stat_select_vessel_demanalyst"
		lds_dem_analyst.settransobject(SQLCA)
		lds_dem_analyst.retrieve(astr_parm.analyst,astr_parm.profitcenter)
		
		//CR2411 Added by LGX001 on 25/07/2011. Change desc:  get the charterers with claims, when the analyst and profit centers are both selected 
		lds_dem_chart_analyst.dataobject = "d_sq_gr_dem_stat_select_charterer_demanalyst"
		lds_dem_chart_analyst.settransobject(SQLCA)
		lds_dem_chart_analyst.retrieve(astr_parm.analyst, astr_parm.profitcenter)
	end if
	
	//if no rows, empty the demurrage analyst
	if lds_dem_analyst.rowcount() = 0 and upperbound(astr_parm.profitcenter) <> 0 then
		setnull(ls_null)
		dw_demurrage_analyst.selectrow(0, false)
		dw_demurrage_analyst.SetItem(1, 1, ls_null)
		this.dynamic event ue_userrespitemchanged("")
		astr_parm.analyst = ""
	end if
	
	ll_pc_rows = adw.rowcount()
	ll_dem_analyst_rows = lds_dem_analyst.rowcount()
	for ll_row = 1 to ll_dem_analyst_rows
		astr_parm.vessel_nr[ll_row] = lds_dem_analyst.getitemnumber(ll_row, "number")
		astr_parm.vessel_ref_nr[ll_row] = lds_dem_analyst.getitemstring(ll_row, "vessel_ref_nr")
		ll_pc_nr = lds_dem_analyst.getitemnumber(ll_row, "pc_nr")
		
		ls_vessels_list += astr_parm.vessel_ref_nr[ll_row] + ls_DELIMITER								//Add the vessel to vessel list
		ls_vessel_filter += string(astr_parm.vessel_nr[ll_row]) + ls_DELIMITER
		
		if abl_dwselect then
			if pos(ls_pclist, ls_DELIMITER + string(ll_pc_nr) + ls_DELIMITER) <= 0 then			//Distinct the profit center
				astr_parm.profitcenter[upperbound(astr_parm.profitcenter) + 1] = ll_pc_nr
				ls_pclist += string(ll_pc_nr) + ls_DELIMITER
				
				ll_found_row = adw.find("pc_nr = " + string(ll_pc_nr), 1, ll_pc_rows)				//Select the found profit center
				if ll_found_row > 0 then
					adw.selectrow(ll_found_row, true)
				end if
			end if
		end if
	next
	
	if right(ls_vessels_list, Len(ls_DELIMITER)) = ls_DELIMITER then ls_vessels_list = left(ls_vessels_list, len(ls_vessels_list) - len(ls_DELIMITER))
	if right(ls_vessel_filter, Len(ls_DELIMITER)) = ls_DELIMITER then ls_vessel_filter = left(ls_vessel_filter, len(ls_vessel_filter) - len(ls_DELIMITER))
	
	//CR2411 Added by LGX001 on 25/07/2011. Change desc: set sle_charterers.text in the window of w_demurrage_section or w_demurrage_section_settle_stat
	ll_dem_analyst_rows = lds_dem_chart_analyst.rowcount()
	for ll_row = 1 to ll_dem_analyst_rows
		astr_parm.chart_nr[ll_row] = lds_dem_chart_analyst.getitemnumber(ll_row, "claims_chart_nr")
		ls_charterer_list += string(astr_parm.chart_nr[ll_row]) + ls_DELIMITER							//Add the charterer to charterer list
	next
	
	if right(ls_charterer_list, Len(ls_DELIMITER)) = ls_DELIMITER then ls_charterer_list = left(ls_charterer_list, len(ls_charterer_list) - len(ls_DELIMITER))
	
	destroy lds_dem_analyst
	destroy lds_dem_chart_analyst
end if

asle_vessels.text = ls_vessels_list
amle_charterers.text = ls_charterer_list

return trim(ls_vessel_filter)

end function

public function string of_itemchanged (datawindow adw, singlelineedit asle_vessels, singlelineedit asle_charterers, ref s_demurrage_stat_selection astr_parm, boolean abl_dwselect);/********************************************************************
   of_itemchanged(/*datawindow adw */, /*singlelineedit asle_vessels*/,
						/*s_demurrage_stat_selection astr_parm*/,/*boolean abl_dwselect*/)
   <DESC>     This function is to set the values for the filter of the parent window.
				  and also set the values for the vessel text field of the parent window.
   </DESC>
   <RETURN> String:	<LI> ls_vessel_filter, X ok<LI> "-1", X failed			</RETURN>
   <ACCESS> Public																	</ACCESS>
   <ARGS>    adw: profit center datawindow, which need to be selected/highlighted when the call
						if from ue_userrespitemchagned event of the parent window.
				 asle_vessels, vessel text field
				 astr_parm: structure to save all the filter parameters.
				 abl_dwselect: judge if the call if from ue_userrespitemchagned event 
				 				   of the parent window or from the click event of the profit 
								   center list.
   </ARGS>
   <USAGE>  Called from ue_userrespitemchagned event and click event of the profit center list
				 of the parent window.
   </USAGE>
********************************************************************/

string 		ls_empty[], ls_vessel_filter, ls_null, ls_pclist
string		ls_vessels_list, ls_charterer_list
integer		li_empty[]
long			ll_row, ll_dem_analyst_rows, ll_pc_nr, ll_pc_rows, ll_found_row

datastore	lds_dem_analyst, lds_dem_chart_analyst

CONSTANT string ls_DELIMITER = ", "

ls_pclist = ls_DELIMITER

//reset
asle_vessels.text       = ""
asle_charterers.text    = ""
astr_parm.vessel_ref_nr = ls_empty
astr_parm.vessel_nr     = li_empty
astr_parm.chart_nr      = li_empty

if abl_dwselect then
	astr_parm.profitcenter = li_empty
	adw.selectrow(0, false)
	
	//get analyst id
	dw_demurrage_analyst.accepttext()
	astr_parm.analyst = dw_demurrage_analyst.getitemstring(1, "userid")
end if

//set values 
if not isnull(astr_parm.analyst) then
	lds_dem_analyst = create datastore
	lds_dem_chart_analyst = create datastore
	
	if abl_dwselect then
		lds_dem_analyst.dataobject = "d_demurrage_stat_select_vessel_all"
		lds_dem_analyst.settransobject(SQLCA)
		lds_dem_analyst.retrieve(astr_parm.analyst)
		
		//CR2411 Added by LGX001 on 25/07/2011. Change desc: get the charterers with claims, which the selected demurrage analyst is responsible for
		lds_dem_chart_analyst.dataobject = "d_sq_gr_dem_stat_select_charterer_all"
		lds_dem_chart_analyst.settransobject(SQLCA)
		lds_dem_chart_analyst.retrieve(astr_parm.analyst)
	else
		lds_dem_analyst.dataobject = "d_demurrage_stat_select_vessel_demanalyst"
		lds_dem_analyst.settransobject(SQLCA)
		lds_dem_analyst.retrieve(astr_parm.analyst,astr_parm.profitcenter)
		
		//CR2411 Added by LGX001 on 25/07/2011. Change desc:  get the charterers with claims, when the analyst and profit centers are both selected 
		lds_dem_chart_analyst.dataobject = "d_sq_gr_dem_stat_select_charterer_demanalyst"
		lds_dem_chart_analyst.settransobject(SQLCA)
		lds_dem_chart_analyst.retrieve(astr_parm.analyst, astr_parm.profitcenter)
	end if
	
	//if no rows, empty the demurrage analyst
	if lds_dem_analyst.rowcount() = 0 and upperbound(astr_parm.profitcenter) <> 0 then
		setnull(ls_null)
		dw_demurrage_analyst.selectrow(0, false)
		dw_demurrage_analyst.SetItem(1, 1, ls_null)
		this.dynamic event ue_userrespitemchanged("")
		astr_parm.analyst = ""
	end if
	
	ll_pc_rows = adw.rowcount()
	ll_dem_analyst_rows = lds_dem_analyst.rowcount()
	for ll_row = 1 to ll_dem_analyst_rows
		astr_parm.vessel_nr[ll_row] = lds_dem_analyst.getitemnumber(ll_row, "number")
		astr_parm.vessel_ref_nr[ll_row] = lds_dem_analyst.getitemstring(ll_row, "vessel_ref_nr")
		ll_pc_nr = lds_dem_analyst.getitemnumber(ll_row, "pc_nr")
		
		ls_vessels_list += astr_parm.vessel_ref_nr[ll_row] + ls_DELIMITER								//Add the vessel to vessel list
		ls_vessel_filter += string(astr_parm.vessel_nr[ll_row]) + ls_DELIMITER
		
		if abl_dwselect then
			if pos(ls_pclist, ls_DELIMITER + string(ll_pc_nr) + ls_DELIMITER) <= 0 then			//Distinct the profit center
				astr_parm.profitcenter[upperbound(astr_parm.profitcenter) + 1] = ll_pc_nr
				ls_pclist += string(ll_pc_nr) + ls_DELIMITER
				
				ll_found_row = adw.find("pc_nr = " + string(ll_pc_nr), 1, ll_pc_rows)				//Select the found profit center
				if ll_found_row > 0 then
					adw.selectrow(ll_found_row, true)
				end if
			end if
		end if
	next
	
	if right(ls_vessels_list, Len(ls_DELIMITER)) = ls_DELIMITER then ls_vessels_list = left(ls_vessels_list, len(ls_vessels_list) - len(ls_DELIMITER))
	if right(ls_vessel_filter, Len(ls_DELIMITER)) = ls_DELIMITER then ls_vessel_filter = left(ls_vessel_filter, len(ls_vessel_filter) - len(ls_DELIMITER))
	
	//CR2411 Added by LGX001 on 25/07/2011. Change desc: set sle_charterers.text in the window of w_demurrage_section or w_demurrage_section_settle_stat
	ll_dem_analyst_rows = lds_dem_chart_analyst.rowcount()
	for ll_row = 1 to ll_dem_analyst_rows
		astr_parm.chart_nr[ll_row] = lds_dem_chart_analyst.getitemnumber(ll_row, "claims_chart_nr")
		ls_charterer_list += string(astr_parm.chart_nr[ll_row]) + ls_DELIMITER							//Add the charterer to charterer list
	next
	
	if right(ls_charterer_list, Len(ls_DELIMITER)) = ls_DELIMITER then ls_charterer_list = left(ls_charterer_list, len(ls_charterer_list) - len(ls_DELIMITER))
	
	destroy lds_dem_analyst
	destroy lds_dem_chart_analyst
end if

asle_vessels.text = ls_vessels_list
asle_charterers.text = ls_charterer_list

return trim(ls_vessel_filter)

end function

on u_demurrage_analyst.create
this.dw_demurrage_analyst=create dw_demurrage_analyst
this.Control[]={this.dw_demurrage_analyst}
end on

on u_demurrage_analyst.destroy
destroy(this.dw_demurrage_analyst)
end on

event constructor;datawindowchild	dwc

dw_demurrage_analyst.insertRow(0)
dw_demurrage_analyst.getchild( "userid", dwc)
dwc.setTransObject(sqlca)
dwc.retrieve() 
end event

type dw_demurrage_analyst from datawindow within u_demurrage_analyst
event ue_keydown pbm_dwnkey
integer width = 823
integer height = 88
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_demurrage_analyst"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*The function is to allow user to use DELETE key in the keyboard to clear everything*/

window  lw_parent
string 	ls_null

if key = KeyDelete! then
	setnull(ls_null)
	this.selectrow(0, false)
	this.setitem(1, 1, ls_null)
	lw_parent = parent.getparent()
	lw_parent.dynamic event ue_userrespitemchanged("")
end if

end event

event doubleclicked;string	ls_null

setnull(ls_null)

this.selectrow(0, false)
this.setitem(1, 1, ls_null)

this.event itemchanged(0, dwo, ls_null)

end event

event itemchanged;window  lw_parent

lw_parent = parent.getparent()
lw_parent.dynamic event ue_userrespitemchanged(data)

end event

