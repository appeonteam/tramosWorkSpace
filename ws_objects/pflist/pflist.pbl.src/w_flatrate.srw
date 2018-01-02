$PBExportHeader$w_flatrate.srw
forward
global type w_flatrate from w_events_pcgroup
end type
type uo_pcgroup from u_pcgroup within w_flatrate
end type
type cb_save from mt_u_commandbutton within w_flatrate
end type
type cb_retrieve from mt_u_commandbutton within w_flatrate
end type
type cb_new from mt_u_commandbutton within w_flatrate
end type
type cb_delete from mt_u_commandbutton within w_flatrate
end type
type cb_close from mt_u_commandbutton within w_flatrate
end type
type st_1 from mt_u_statictext within w_flatrate
end type
type dw_flatrate_year from datawindow within w_flatrate
end type
type dw_flatrate from datawindow within w_flatrate
end type
end forward

global type w_flatrate from w_events_pcgroup
integer width = 2615
integer height = 1944
string title = "Fixture Flatrate"
uo_pcgroup uo_pcgroup
cb_save cb_save
cb_retrieve cb_retrieve
cb_new cb_new
cb_delete cb_delete
cb_close cb_close
st_1 st_1
dw_flatrate_year dw_flatrate_year
dw_flatrate dw_flatrate
end type
global w_flatrate w_flatrate

type variables
integer ii_year, ii_pcgroup
end variables

forward prototypes
public function integer uf_refresh_listyear ()
public subroutine documentation ()
end prototypes

public function integer uf_refresh_listyear ();
datawindowchild ldwc

dw_flatrate_year.settransobject(SQLCA)
dw_flatrate_year.getchild("flatrateyear",ldwc)
ldwc.SetTransObject(SQLCA)
if ldwc.retrieve(ii_pcgroup) > 0 then
	ii_year = ldwc.getitemnumber(1,"flatrateyear")
	dw_flatrate_year.insertrow(0)
	dw_flatrate_year.setitem(1,"flatrateyear",ii_year)
else
	dw_flatrate_year.reset()
	dw_flatrate.reset( )
end if

return 0
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		28/08/14		CR3781		CCY018		The window title match with the text of a menu item
		10/10/14		CR3839		XSZ004		Fix a historical bug
   </HISTORY>
********************************************************************/
end subroutine

on w_flatrate.create
int iCurrent
call super::create
this.uo_pcgroup=create uo_pcgroup
this.cb_save=create cb_save
this.cb_retrieve=create cb_retrieve
this.cb_new=create cb_new
this.cb_delete=create cb_delete
this.cb_close=create cb_close
this.st_1=create st_1
this.dw_flatrate_year=create dw_flatrate_year
this.dw_flatrate=create dw_flatrate
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_pcgroup
this.Control[iCurrent+2]=this.cb_save
this.Control[iCurrent+3]=this.cb_retrieve
this.Control[iCurrent+4]=this.cb_new
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.cb_close
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.dw_flatrate_year
this.Control[iCurrent+9]=this.dw_flatrate
end on

on w_flatrate.destroy
call super::destroy
destroy(this.uo_pcgroup)
destroy(this.cb_save)
destroy(this.cb_retrieve)
destroy(this.cb_new)
destroy(this.cb_delete)
destroy(this.cb_close)
destroy(this.st_1)
destroy(this.dw_flatrate_year)
destroy(this.dw_flatrate)
end on

event open;ii_pcgroup=uo_pcgroup.uf_getpcgroup( )
ii_year = 1

uf_refresh_listyear()

if ii_pcgroup<0 then
	this.Post Event ue_postopen()
else
	cb_retrieve.event clicked( )
end if



end event

event ue_pcgroupchanged;call super::ue_pcgroupchanged;ii_pcgroup=ai_pcgroupid
uf_refresh_listyear() 
cb_retrieve.event clicked( )
return 0
end event

type st_hidemenubar from w_events_pcgroup`st_hidemenubar within w_flatrate
end type

type uo_pcgroup from u_pcgroup within w_flatrate
integer x = 50
integer y = 24
integer height = 188
integer taborder = 20
end type

on uo_pcgroup.destroy
call u_pcgroup::destroy
end on

type cb_save from mt_u_commandbutton within w_flatrate
integer x = 1509
integer y = 1716
integer taborder = 50
string facename = "Arial"
boolean enabled = false
string text = "&Save"
end type

event clicked;int		li_i
long	ll_tradeid, ll_flatratevalue, ll_flatrateid

dw_flatrate.accepttext( )
if dw_flatrate.modifiedcount( ) > 0 then
  for li_i=1 to dw_flatrate.rowcount( )
	if dw_flatrate.GetItemStatus(li_i,0,Primary!)<>NotModified! then
		dw_flatrate.setitem( li_i, "pf_fixture_flatrate_tradeid",dw_flatrate.getitemnumber( li_i,  "pf_fixture_trade_tradeid") )
		dw_flatrate.setitem( li_i, "pf_fixture_flatrate_pcgroup_id",ii_pcgroup)
		dw_flatrate.setitem( li_i, "pf_fixture_flatrate_flatrateyear",ii_year)
			
		if isnull(dw_flatrate.getitemnumber(li_i,"fixtureflatrateid")) then
			dw_flatrate.setitemstatus( li_i,0, Primary!, NewModified!	)
		else
			dw_flatrate.setitemstatus( li_i,0, Primary!, DataModified!	)
		end if

//		ll_tradeid = dw_flatrate.getitemnumber( li_i, "pf_fixture_trade_tradeid")
//		ll_flatratevalue = dw_flatrate.getitemnumber( li_i, "pf_fixture_flatrate_flatrate")
//		ll_flatrateid = dw_flatrate.getitemnumber(li_i,"fixtureflatrateid")
//		
//		if isnull(dw_flatrate.getitemnumber(li_i,"fixtureflatrateid")) then
//			//INSERT
//			INSERT INTO PF_FIXTURE_FLATRATE (TRADEID, FLATRATE,FLATRATEYEAR,PCGROUP_ID  ) 
//			VALUES(:ll_tradeid, :ll_flatratevalue ,  :ii_year , :ii_pcgroup )
//			COMMIT USING SQLCA;
//			If sqlca.sqlcode <> 0 Then
//				Messagebox("Error Insert",Sqlca.sqlerrtext)
//				exit
//			End If
//	    else
//			//UPDATE
//			UPDATE PF_FIXTURE_FLATRATE SET FLATRATE = :ll_flatratevalue 
//			WHERE FIXTUREFLATRATEID =:ll_flatrateid
//			COMMIT USING SQLCA;
//			If sqlca.sqlcode <> 0 Then
//				Messagebox("Error Update",Sqlca.sqlerrtext)
//				exit
//			End If		
//		end if
		
	end if
	
  next
  
  if dw_flatrate.update() = 1 then
	 commit;
  else
	rollback;
	MessageBox("Update Error", "Error updating flatrate.")
	return -1 
  end if
			
			
  cb_retrieve.event clicked()
end if



//dw_flatrate.acceptText()
//if dw_flatrate.modifiedcount( ) > 0 then
//	for li_i = 1 to dw_flatrate.rowcount( )
//		if isnull(dw_flatrate.getitemnumber(li_i,"fixtureflatrateid")) then
//			dw_flatrate.setitemstatus( li_i,0, Primary!, NewModified!	)
//		else
//			dw_flatrate.setitemstatus( li_i,0, Primary!, DataModified!	)
//		end if
//	next
//	if dw_flatrate.update() = 1 then
//		commit;
//		
//		cb_retrieve.event clicked()
//		
//		// w_flatrate.post event open( )
//	else
//		rollback;
//		MessageBox("Update Error", "Error updating flatrate.")
//		return -1
//	end if
//end if


end event

type cb_retrieve from mt_u_commandbutton within w_flatrate
integer x = 1179
integer y = 76
integer taborder = 40
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;if dw_flatrate_year.rowcount() > 0 then
	if isnull(dw_flatrate_year.getitemnumber(1, "flatrateyear")) then
		MessageBox("Validation Error", "Please select a Flatrate year")
		dw_flatrate_year.post setFocus()
		return
	end if
else
	ii_year = 0
end if

dw_flatrate.setTransObject(SQLCA)
dw_flatrate.retrieve(ii_year, ii_pcgroup)

if SQLCA.SQLcode = -1 then
	Messagebox("Error retrieve", SQLCA.sqlerrtext )
	return 
end if

if  dw_flatrate.rowcount( ) > 0 then
	cb_save.enabled = true
else 
	cb_save.enabled = false
end if
end event

type cb_new from mt_u_commandbutton within w_flatrate
integer x = 1161
integer y = 1716
integer taborder = 40
string facename = "Arial"
string text = "&New"
end type

event clicked;call super::clicked;int				li_row, li_year, li_i
long 			ll_defaultrade
datawindowchild ldwc

open(w_flatrate_new)

li_year = message.doubleparm

if dw_flatrate.rowcount( ) > 0 then
	
	ll_defaultrade = dw_flatrate.getitemnumber( 1,"pf_fixture_trade_tradeid")
	INSERT INTO PF_FIXTURE_FLATRATE (TRADEID, FLATRATE, FLATRATEYEAR, PCGROUP_ID) 
	VALUES (:ll_defaultrade, 0, :li_year, :ii_pcgroup )
	COMMIT USING SQLCA;
    uf_refresh_listyear()
	cb_retrieve.event clicked( )
else
  Messagebox("Warning", "Is not possible to create a new Year if no trades!")
end if

end event

type cb_delete from mt_u_commandbutton within w_flatrate
integer x = 1856
integer y = 1716
integer taborder = 40
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;datawindowchild			ldwc

if MessageBox("Confirmation", "Are you sure you want to delete all flatrates for year " + string(ii_year) +" ?", question!, YesNo!,2) = 1 then 
	DELETE 
	FROM PF_FIXTURE_FLATRATE
	WHERE FLATRATEYEAR = :ii_year AND PCGROUP_ID = :ii_pcgroup
	;
	if SQLCA.SQLCODE = 0 then
		commit;
		w_flatrate.post event open( )
		return
	else
		rollback;
		MessageBox("Delete Error", "Error deleting flatrate year.")
		return -1
	end if
end if

end event

type cb_close from mt_u_commandbutton within w_flatrate
integer x = 2203
integer y = 1716
integer taborder = 30
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type st_1 from mt_u_statictext within w_flatrate
integer x = 823
integer y = 24
integer width = 357
integer height = 56
integer weight = 700
string facename = "Arial"
string text = "Flatrate year:"
end type

type dw_flatrate_year from datawindow within w_flatrate
integer x = 823
integer y = 96
integer width = 219
integer height = 80
integer taborder = 20
string title = "none"
string dataobject = "d_flatrate_year"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ii_year = Integer(data)
cb_retrieve.event clicked()
end event

type dw_flatrate from datawindow within w_flatrate
integer x = 46
integer y = 236
integer width = 2496
integer height = 1456
integer taborder = 10
string title = "none"
string dataobject = "d_flatrate"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

