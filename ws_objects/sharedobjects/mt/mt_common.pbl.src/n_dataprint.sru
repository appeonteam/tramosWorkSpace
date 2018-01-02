$PBExportHeader$n_dataprint.sru
forward
global type n_dataprint from mt_n_nonvisualobject
end type
type str_css_class from structure within n_dataprint
end type
end forward

type str_css_class from structure
	string		s_name
	string		s_type
end type

global type n_dataprint from mt_n_nonvisualobject autoinstantiate
end type

type variables

end variables

forward prototypes
public subroutine documentation ()
public function integer of_print (mt_u_datawindow adw_print)
public function integer of_print (mt_n_datastore ads_print)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_dataprint
	
	<OBJECT>
		Used to print data from datawindow
	</OBJECT>
   <DESC>
		
	</DESC>
   <USAGE>
		Used directly in mt_u_datawindow ancestor
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
   Date   		Ref    				Author   	Comments
  	24/10/16 	CR4501      		HXH010		First Version
********************************************************************/
end subroutine

public function integer of_print (mt_u_datawindow adw_print);/********************************************************************
   of_print
   <DESC> </DESC>
   <RETURN>	
		c#return.failure : -1
		c#return.success : 1
   </RETURN>
   <ACCESS>	public		</ACCESS>
   <ARGS>
		mt_u_datawindow adw_print
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	24/10/16 CR4501      HXH010        	First Version
   </HISTORY>
********************************************************************/
long ll_rt
blob lblb_data
mt_n_datastore lds_print

lds_print = create mt_n_datastore
lds_print.dataobject = adw_print.dataobject
lds_print.settransobject(sqlca)

ll_rt =  adw_print.getfullstate(lblb_data)
if ll_rt =-1 then return c#return.failure

ll_rt = lds_print.setfullstate(lblb_data)
if ll_rt =-1 then return c#return.failure

of_print(lds_print)

destroy lds_print

return c#return.success
end function

public function integer of_print (mt_n_datastore ads_print);/********************************************************************
   of_print
   <DESC> </DESC>
   <RETURN>	
		c#return.failure : -1
		c#return.success : 1
   </RETURN>
   <ACCESS>	public		</ACCESS>
   <ARGS>
		mt_n_datastore ads_print
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	24/10/16 CR4501      HXH010        	 First Version
   </HISTORY>
********************************************************************/
long ll_count , ll_i, ll_zoom

ads_print.modify("datawindow.print.preview = yes")
ll_count = long(ads_print.describe("evaluate('pagecountacross()', 1)"))
ll_i = 1
do while (ll_count >1 and ll_i < 100)
	ll_zoom = 100 - 1*ll_i
	ads_print.modify("datawindow.zoom = " + string(ll_zoom))
	ll_count = long(ads_print.describe("evaluate('pagecountacross()', 1)"))
	ll_i ++
loop 

ads_print.print()
ads_print.modify("datawindow.zoom = 100 " )
ads_print.modify("datawindow.print.preview = no")

return c#return.success
end function

on n_dataprint.create
call super::create
end on

on n_dataprint.destroy
call super::destroy
end on

