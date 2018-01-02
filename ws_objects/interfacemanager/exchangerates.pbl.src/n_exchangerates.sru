$PBExportHeader$n_exchangerates.sru
$PBExportComments$functions used by both TIM and Tramos
forward
global type n_exchangerates from mt_n_nonvisualobject
end type
end forward

global type n_exchangerates from mt_n_nonvisualobject
end type
global n_exchangerates n_exchangerates

forward prototypes
public function long of_readfile (mt_n_datastore ads_source, ref mt_n_datastore ads_target, string as_filename, ref string as_errormsg)
public function integer of_update (ref mt_n_datastore ads_target)
end prototypes

public function long of_readfile (mt_n_datastore ads_source, ref mt_n_datastore ads_target, string as_filename, ref string as_errormsg);/********************************************************************
   of_readfile
   <DESC>	Reads data from the specified file	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_filename
		as_context
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	07/01/2012   M5-5         ZSW001       First Version
   </HISTORY>
********************************************************************/

integer  li_fileindex
string	ls_workingfilepath
string ls_dataline
integer li_rc, li_importfilehandle
decimal {6} ld_exrate_DKK, ld_exrate_USD
string ls_code, ls_failedexrates=""
datetime ldt_date
long ll_row, ll_found


li_importfilehandle = fileopen(as_filename)
if li_importfilehandle = -1 then
	as_errormsg = "error, could not open import file " + ls_workingfilepath
	return c#return.Failure
end if	

ads_source.retrieve()

li_rc = fileread(li_importfilehandle, ls_dataline)
do until li_rc = -100
	if mid(ls_dataline, 1,1) = "2" then
		ls_code = mid(ls_dataline, 3, 3)
		ldt_date = datetime(date(mid(ls_dataline,9,4)+"-"+mid(ls_dataline,13,2)+"-"+mid(ls_dataline,15,2)))
		ld_exrate_DKK = dec(mid(ls_dataline,27,5))+(dec(mid(ls_dataline,33,6))/1000000)
		ld_exrate_USD = dec(mid(ls_dataline,40,5))+(dec(mid(ls_dataline,46,6))/1000000)
		ll_found = ads_source.find("curr_code='"+ls_code+"'",1,9999)
		If ll_found > 0 then
			ll_row = ads_target.insertRow(0)
			ads_target.setItem(ll_row, "curr_code", ls_code)
			ads_target.setItem(ll_row, "rate_date", ldt_date)
			ads_target.setItem(ll_row, "exrate_dkk", ld_exrate_DKK)
			ads_target.setItem(ll_row, "exrate_usd", ld_exrate_USD)
		else
			ls_failedexrates+= "," + ls_code
		end if
	end if
	li_rc = fileread(li_importfilehandle, ls_dataline)
loop
fileclose(li_importfilehandle)
as_errormsg = "fyi, following currency codes not found in currency table: " + mid(ls_failedexrates,2)

return c#return.Success

end function

public function integer of_update (ref mt_n_datastore ads_target);if ads_target.update() = 1 then
	commit using sqlca;
else
	rollback using sqlca;
	Return c#return.Failure
end if

return c#return.Success
end function

on n_exchangerates.create
call super::create
end on

on n_exchangerates.destroy
call super::destroy
end on

