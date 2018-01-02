$PBExportHeader$n_object_usage_log.sru
$PBExportComments$Used to determine which objects (MOSTLY WINDOW) in Tramos are redundant and which are not.
forward
global type n_object_usage_log from nonvisualobject
end type
end forward

global type n_object_usage_log from nonvisualobject autoinstantiate
end type

forward prototypes
public function integer uf_log_object (string as_object_name)
end prototypes

public function integer uf_log_object (string as_object_name);/********************************************************************
   uf_log_object( /*string as_object_name */)
   <DESC>[CHGREQ:1672]Increments usage counter and sets current date for objects/menuitems
	that we think are unused.  This should give us a guide to the activity.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   as_object_name: the name of the menuitem/window that is to be checked</ARGS>
   <USAGE>  2 examples:
				- for a menuitem in the click event:
					n_object_usage_log use_log
					use_log.uf_log_object(this.text)
				- for a window (perhaps in the open event)
					n_object_usage_log use_log
					use_log.uf_log_object(this.classname())
	</USAGE>
********************************************************************/
string ls_object, ls_userid, ls_yearmonth
long ll_counter, ll_yearmonth
integer li_charpos, li_charcode
boolean lb_standard_char

		for li_charpos = 1 TO len(as_object_name)
			lb_standard_char=false
			li_charcode=asc(mid(as_object_name,li_charpos,1))
			choose case li_charcode
				case 32 to 136
					lb_standard_char=true				
//				case else
//					messagebox("Notice",mid(as_object_name,li_charpos,1) + " is not covered!")
			end choose
			if lb_standard_char then ls_object=ls_object + mid(as_object_name,li_charpos,1)
		next

ls_yearmonth = string(today(), "yyyymm")
ll_yearmonth = long(ls_yearmonth)


		SELECT COUNT(*)
		INTO :ll_counter 
		FROM OBJECT_USAGE_LOG
		WHERE OBJECT_NAME = :ls_object and YEAR_MONTH=:ll_yearmonth;
		COMMIT;
		
		if ll_counter=0 then
			INSERT INTO OBJECT_USAGE_LOG (OBJECT_NAME, USED_COUNTER, LAST_USED_DATE, LAST_USER, YEAR_MONTH)
			VALUES (:ls_object,1, GETDATE(),  :uo_global.is_userid, :ll_yearmonth);
			
		else		
			UPDATE OBJECT_USAGE_LOG 
			SET USED_COUNTER=USED_COUNTER+1, LAST_USED_DATE=GETDATE(), LAST_USER=:uo_global.is_userid
			WHERE OBJECT_NAME = :ls_object and YEAR_MONTH=:ll_yearmonth;
		end if

		if SQLCA.sqlcode<>0 then
			Rollback;
			return -1
		end if			
		
		COMMIT;
			

return 1
end function

event constructor;/********************************************************************
   ObjectName: Object Short Description
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   Ref    Author        Comments
  00/00/07 ?      Name Here     First Version
********************************************************************/

end event

on n_object_usage_log.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_object_usage_log.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

