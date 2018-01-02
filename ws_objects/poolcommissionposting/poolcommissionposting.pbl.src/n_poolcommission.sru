$PBExportHeader$n_poolcommission.sru
forward
global type n_poolcommission from mt_n_nonvisualobject
end type
end forward

global type n_poolcommission from mt_n_nonvisualobject
end type
global n_poolcommission n_poolcommission

type variables
long	il_maxbalance
end variables

forward prototypes
private function integer of_settle_tchire_poolcomm ()
private function integer of_settle_claims_poolcomm ()
public function integer of_unsettle_claims_poolcomm ()
public function integer of_run (long al_maxbalance)
public subroutine documentation ()
public function integer of_unsettle_tchire_poolcomm ()
end prototypes

private function integer of_settle_tchire_poolcomm ();/********************************************************************
	of_settle_tchire_poolcomm( )
   <DESC> Settle Pool Commissions related with tc hire - Available for voyages from 2011 
	</DESC>
   <RETURN> 
		Success or failure
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>  </ARGS>
   <USAGE>	</USAGE>
********************************************************************/

constant string METHOD_NAME = "of_settle_tchire_poolcomm"
long					ll_row, ll_rows, li_trans_ok, ll_commid, ll_counter
mt_n_datastore	lds_tchire_poolcommission
string	ls_temp

s_transaction_input						lstr_transaction_input 
u_transaction_commission_claim_coda 	lnv_trans_coda

_addmessage( this.classdefinition, "of_settle_tchire_poolcomm()", "2. Settle TC Hire Pool Commissions", "--")

//d_sq_tb_tchire_poolcommission - list of not settled comm. since 2011

lds_tchire_poolcommission = create mt_n_datastore

lds_tchire_poolcommission.dataobject = "d_sq_tb_tchire_poolcommission"

lds_tchire_poolcommission.setTransObject(sqlca)

if lds_tchire_poolcommission.retrieve() = -1 then
	_addmessage( this.classdefinition, METHOD_NAME, "ERROR: Retrieve datawindow d_sq_tb_tchire_poolcommission: " + sqlca.sqlerrtext, "--")
	destroy lds_tchire_poolcommission
	return c#return.failure
end if

ll_rows =  lds_tchire_poolcommission.rowcount( ) 
if ll_rows= 0 then 
	_addmessage( this.classdefinition, "of_settle_tchire_poolcomm()", "Nothing to do", "--")
	return c#return.noaction
end if

ll_counter = 0
for ll_row = 1 to ll_rows

	commit; 
	
	lstr_transaction_input.coda_or_cms = TRUE // This is a CODA transaction
	lstr_transaction_input.vessel_no = lds_tchire_poolcommission.GetItemNumber(ll_row,"vessel_nr")
	lstr_transaction_input.broker_no = lds_tchire_poolcommission.GetItemNumber(ll_row,"broker_nr")

	lstr_transaction_input.amount_local = lds_tchire_poolcommission.GetItemNumber(ll_row,"amount")
	lstr_transaction_input.comm_amount = lds_tchire_poolcommission.GetItemNumber(ll_row,"amount") * lds_tchire_poolcommission.GetItemNumber(ll_row,"ntc_payment_ex_rate_usd")/100
		
	lstr_transaction_input.tc_cp_date = lds_tchire_poolcommission.GetItemDatetime(ll_row,"cp_date")
	lstr_transaction_input.disb_currency_code = lds_tchire_poolcommission.GetItemString(ll_row,"curr_code")
	lstr_transaction_input.voyage_no = lds_tchire_poolcommission.GetItemString(ll_row,"voyage_nr")
	lstr_transaction_input.payment_start = lds_tchire_poolcommission.GetItemDatetime(ll_row,"period_start")
	lstr_transaction_input.payment_end = lds_tchire_poolcommission.GetItemDatetime(ll_row,"period_end")
	lstr_transaction_input.payment_id = lds_tchire_poolcommission.GetItemNumber(ll_row,"payment_id")


	lstr_transaction_input.comm_inv_no = lds_tchire_poolcommission.GetItemString(ll_row, "inv_nr")
	
	ll_commid = lds_tchire_poolcommission.GetItemNumber(ll_Row,"ntc_commission_ntc_comm_id")
	lstr_transaction_input.comm_inv_no = lds_tchire_poolcommission.GetItemString(ll_row, "inv_nr")
	if  left(upper(lstr_transaction_input.comm_inv_no),13)  = "DO NOT SETTLE" then
		lstr_transaction_input.comm_inv_no = "TCPoolComm" + string(ll_commid)
		lds_tchire_poolcommission.SetItem( ll_row,  "inv_nr", lstr_transaction_input.comm_inv_no )		
	end if
	
	lnv_trans_coda = CREATE u_transaction_commission_claim_coda //CODA
				
	li_trans_ok = lnv_trans_coda.of_generate_transaction(lstr_transaction_input) //Generate CODA transaction
	
	If li_trans_ok  <> 1 THEN
		rollback;
		ls_temp = "ERROR TRANSACTION GENERATION -  Vessel: " + string(lstr_transaction_input.vessel_no) + " Broker: " +  string(lstr_transaction_input.broker_no) + " Invoice number: " + lstr_transaction_input.comm_inv_no
		_addmessage( this.classdefinition, METHOD_NAME, ls_temp, "--")

	else
			
		//Update With settle markings if trans is ok.
		lds_tchire_poolcommission.SetItem( ll_row, "settle_date",Today () )
		
		// Update, close and exit
		IF lds_tchire_poolcommission.update() = 1 THEN
			commit;
			ll_counter =ll_counter +1
		ELSE
			
			rollback;
			ls_temp = "ERROR COMMISSIONS UPDATE -  Vessel: " + string(lstr_transaction_input.vessel_no) + " Broker: " +  string(lstr_transaction_input.broker_no) + " Invoice number: " + lstr_transaction_input.comm_inv_no
			_addmessage( this.classdefinition, METHOD_NAME, ls_temp, "--")
		END IF     	
	
		Destroy lnv_trans_coda
		
	End if

next

destroy lds_tchire_poolcommission

_addmessage( this.classdefinition, METHOD_NAME, "Total= " + string(ll_rows) + " settled = " + string(ll_counter) , "--")

return c#return.success
end function

private function integer of_settle_claims_poolcomm ();/********************************************************************
	of_settle_claims_poolcomm( )
   <DESC> Settle Pool Commissions belonging to claims with balance <= 10 USD 
		and settle credit notes - Available for voyages from 2011 </DESC>
   <RETURN> 
		Success or failure
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>  </ARGS>
   <USAGE>	</USAGE>
********************************************************************/

constant string METHOD_NAME = "of_settle_claims_poolcomm"
long					ll_row, ll_rows, li_trans_ok, ll_commid, ll_counter
mt_n_datastore	lds_poolcommission
string	ls_temp

s_transaction_input						lstr_transaction_input 
u_transaction_commission_claim_coda 	lnv_trans_coda

_addmessage( this.classdefinition, "of_settle_claims_poolcomm()", "4. Settle Pool Commissions", "--")

//d_sq_tb_unsettled_poolcommissions - list of not settled comm. since 2011 with claims balance <=10 USD

lds_poolcommission = create mt_n_datastore

lds_poolcommission.dataobject = "d_sq_tb_not_settled_poolcommissions"

lds_poolcommission.setTransObject(sqlca)

if lds_poolcommission.retrieve(il_maxbalance) = -1 then
	destroy lds_poolcommission
	_addmessage( this.classdefinition, METHOD_NAME, "ERROR: Retrieve datawindow d_sq_tb_not_settled_poolcommissions: " + sqlca.sqlerrtext, "--")
	return c#return.failure
end if

ll_rows =  lds_poolcommission.rowcount( ) 
if ll_rows= 0 then 
	_addmessage( this.classdefinition, "of_settle_claims_poolcomm()", "Nothing to do", "--")
	return c#return.noaction
end if
	
ll_counter = 0

for ll_row = 1 to ll_rows

	commit; 
	
	lstr_transaction_input.coda_or_cms = TRUE // This is a CODA transaction
	lstr_transaction_input.vessel_no = lds_poolcommission.GetItemNumber(ll_row,"commissions_vessel_nr")
	lstr_transaction_input.voyage_no = lds_poolcommission.GetItemString(ll_row,"commissions_voyage_nr")
	lstr_transaction_input.claim_no = lds_poolcommission.GetItemNumber(ll_row,"commissions_claim_nr")
	lstr_transaction_input.charter_no = lds_poolcommission.GetItemNumber(ll_row,"commissions_chart_nr")
	lstr_transaction_input.broker_no =lds_poolcommission.GetItemNumber(ll_row,"commissions_broker_nr")
	
	lstr_transaction_input.comm_amount = lds_poolcommission.GetItemNumber(ll_row,"commissions_comm_amount")
	
	lstr_transaction_input.amount_local = lds_poolcommission.GetItemNumber(ll_row,"commissions_comm_amount_local_curr")
	lstr_transaction_input.disb_currency_code = lds_poolcommission.GetItemString(ll_row,"claims_curr_code")
		
	ll_commid = lds_poolcommission.GetItemNumber(ll_row,"commissions_comm_id")
	
	lstr_transaction_input.comm_inv_no = lds_poolcommission.GetItemString(ll_row, "commissions_invoice_nr")
	
	if left(upper(lstr_transaction_input.comm_inv_no),13)  = "DO NOT SETTLE" then
		 lstr_transaction_input.comm_inv_no = "PoolComm" + string(ll_commid)
	end if
	
	setNull( lstr_transaction_input.tc_cp_date )
	
	lnv_trans_coda = CREATE u_transaction_commission_claim_coda //CODA
	
	li_trans_ok = lnv_trans_coda.of_generate_transaction(lstr_transaction_input) //Generate CODA transaction

	If li_trans_ok  <> 1 THEN
		rollback;
		ls_temp = "ERROR TRANSACTION GENERATION -  Vessel: " + string(lstr_transaction_input.vessel_no) + " Broker: " +  string(lstr_transaction_input.broker_no) + " Invoice number: " + lstr_transaction_input.comm_inv_no
		
		_addmessage( this.classdefinition, METHOD_NAME, ls_temp, "--")

	else
	
		//Update With settle markings if trans is ok.
		lds_poolcommission.SetItem( ll_row, "commissions_comm_settled_date",Today () )
		lds_poolcommission.SetItem( ll_row, "commissions_comm_auto", "Locked")
		lds_poolcommission.SetItem( ll_row,  "commissions_comm_settled",1 )		
		lds_poolcommission.SetItem( ll_row, "commissions_invoice_nr", lstr_transaction_input.comm_inv_no)
	
		IF lds_poolcommission.update() = 1 THEN
			COMMIT;
			ll_counter =ll_counter +1
		ELSE
			ROLLBACK;
			ls_temp = "ERROR COMMISSION UPDATE -  Vessel: " + string(lstr_transaction_input.vessel_no) + " Broker: " +  string(lstr_transaction_input.broker_no) + " Invoice number: " + lstr_transaction_input.comm_inv_no
			_addmessage( this.classdefinition, METHOD_NAME, ls_temp  , "--")
		END IF     	

		Destroy lnv_trans_coda
	End if
	
next

destroy lds_poolcommission

_addmessage( this.classdefinition, METHOD_NAME, "Total= " + string(ll_rows) + " settled = " + string(ll_counter) , "--")

return c#return.success
end function

public function integer of_unsettle_claims_poolcomm ();/********************************************************************
	of_unsettle_claims_poolcomm( )
   <DESC> Create credit notes for settled Pool Commissions wich balance >=10 USD 
		- Available for voyages from 2011 </DESC>
   <RETURN> 
		Success or failure
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>  </ARGS>
   <USAGE>	</USAGE>
********************************************************************/
//Reverse

constant string METHOD_NAME = "of_unsettle_claims_poolcomm"

long					ll_row, ll_rows, ll_counter
long	ll_broker_no,ll_claim_no
integer	li_chart_no, li_vessel_no, li_cc
string	ls_voyage_no, ls_invoice, ls_temp, ls_currency
decimal{4}	 ld_amount, ld_amount_local, ld_rate
mt_n_datastore	lds_poolcommission

n_exchangerate	lnv_exchangerare

_addmessage( this.classdefinition, "of_unsettle_claims_poolcomm()", "3. Reverse pool commissions", "--")

//d_sq_tb_not_settled_poolcommissions - list of not settled comm. since 2011

lds_poolcommission = create mt_n_datastore

lds_poolcommission.dataobject = "d_sq_tb_settled_poolcommissions"

lds_poolcommission.setTransObject(sqlca)

if lds_poolcommission.retrieve(il_maxbalance) = -1 then
	destroy lds_poolcommission
	_addmessage( this.classdefinition, METHOD_NAME, "ERROR: Retrieve datawindow d_sq_tb_settled_poolcommissions : " + sqlca.sqlerrtext, "--")
	return c#return.failure
end if

ll_rows =  lds_poolcommission.rowcount( ) 
if ll_rows= 0 then 
	_addmessage( this.classdefinition, "of_unsettle_claims_poolcomm()", "Nothing to do", "--")
	return c#return.noaction
end if

ll_counter = 0
for ll_row = 1 to ll_rows
	
	ld_amount_local =  lds_poolcommission.GetItemNumber( ll_row,  "diff_amount_local" )

	//Create credit notes when amount>0 and the sum is zero
	
	if   ld_amount_local>0 then
		
		ls_currency =  lds_poolcommission.GetItemString( ll_row,  "claims_curr_code" )
		ld_rate = lnv_exchangerare.of_gettodaysusdrate( ls_currency )
	
		ld_amount = ld_amount_local * ld_rate/100
		
		
		ll_broker_no = lds_poolcommission.GetItemNumber( ll_row,  "COMMISSIONS_BROKER_NR" )
		li_chart_no = lds_poolcommission.GetItemNumber( ll_row,  "COMMISSIONS_CHART_NR" )
		li_vessel_no = lds_poolcommission.GetItemNumber( ll_row,  "COMMISSIONS_VESSEL_NR" )
		ls_voyage_no = lds_poolcommission.GetItemString( ll_row,  "COMMISSIONS_VOYAGE_NR" )
		ll_claim_no = lds_poolcommission.GetItemNumber( ll_row,  "COMMISSIONS_CLAIM_NR" )

		ls_invoice = "DO NOT SETTLE CP" 
		
		commit;
		
		 INSERT INTO COMMISSIONS  
				( BROKER_NR, CHART_NR, VESSEL_NR, VOYAGE_NR,  CLAIM_NR, INVOICE_NR,   COMM_AMOUNT, COMM_AMOUNT_LOCAL_CURR, COMM_SETTLED, COMM_AUTO)  
		 VALUES ( :ll_broker_no, :li_chart_no, :li_vessel_no, :ls_voyage_no,  :ll_claim_no,  :ls_invoice, :ld_amount, :ld_amount_local, 0 , "Auto")  ;
		 
		 IF sqlca.sqlcode <> 0 THEN
			ls_temp = " Vessel: " + string(li_vessel_no) + " Broker: " +  string(ll_broker_no) + " Invoice number: " + ls_invoice
			_addmessage( this.classdefinition, METHOD_NAME, "ERROR transaction: " + ls_temp + SQLCA.sqlerrtext , "--")
		end if
			
		ld_amount = -ld_amount
		ld_amount_local = -ld_amount_local
		
		//change name of the reverse statement - Tries 10 times, to find an unic invoice number
		for li_cc  = 1 to 10
			ls_invoice =   "CR " + lds_poolcommission.GetItemString( ll_row,  "max_invoice_nr" )
			if li_cc > 1 then
				ls_invoice =  ls_invoice + " " + string(li_cc)
			end if
		
			 INSERT INTO COMMISSIONS  
					( BROKER_NR, CHART_NR, VESSEL_NR, VOYAGE_NR,  CLAIM_NR, INVOICE_NR, COMM_AMOUNT, COMM_AMOUNT_LOCAL_CURR, COMM_SETTLED)  
			 VALUES ( :ll_broker_no, :li_chart_no, :li_vessel_no, :ls_voyage_no,  :ll_claim_no,  :ls_invoice, :ld_amount, :ld_amount_local, 0 )  ;
			
			IF sqlca.sqlcode <> 0 THEN
//				 ls_temp = " Vessel: " + string(li_vessel_no) + " Broker: " +  string(ll_broker_no) + " Invoice number: " + ls_invoice
//				_addmessage( this.classdefinition, METHOD_NAME, "ERROR creating credit transaction: " + ls_temp + SQLCA.sqlerrtext , "--")
//				rollback;
			else	
				commit;
				ll_counter =ll_counter+1
				exit
			END IF
		next
		if li_cc =11 then
			 ls_temp = " Vessel: " + string(li_vessel_no) + " Broker: " +  string(ll_broker_no) + " Invoice number: " + ls_invoice
			_addmessage( this.classdefinition, METHOD_NAME, "ERROR creating credit transaction: " + ls_temp + SQLCA.sqlerrtext , "--")
			rollback;
		end if
	end if
next


destroy lds_poolcommission

_addmessage( this.classdefinition, METHOD_NAME, "Total= " + string(ll_rows) + " settled = " + string(ll_counter) , "--")

return c#return.success
end function

public function integer of_run (long al_maxbalance);constant string METHOD_NAME = "of_run"

il_maxbalance = al_maxbalance

//0. Unsettle TChire
of_unsettle_tchire_poolcomm( )

// 1. Settle TCHire
of_settle_tchire_poolcomm( )

// 2. Reverse transactions that are settled and balance > 10 USD
of_unsettle_claims_poolcomm()


// 3. UnSettled Claims with balance 0
of_settle_claims_poolcomm()

return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_poolcommission
   <OBJECT> Post of pool commissions </OBJECT>
   <DESC>   of_settle_tchire_poolcomm( ) - Settles all tc hire pool commissions
				of_unsettle_claims_poolcomm( ) - creates credit notes for settled comm
						which claim balance is bigger than <il_maxbalance>
				of_settle_claims_poolcomm( ) - settles all credit notes and unsetted 
						commissions wich claim balance is less and equal to <il_maxbalance>
	</DESC>
   <USAGE>  </USAGE>
   <ALSO>   </ALSO>
    Date   	Ref    		Author        Comments
  24/02/11	CR2264	JMC			First Version
  07/03-11	2264		RMO003		fixed error in currency code when generating claims
 											pool commissions
********************************************************************/
end subroutine

public function integer of_unsettle_tchire_poolcomm ();/********************************************************************
	of_unsettle_claims_poolcomm( )
   <DESC> Create credit transactions for settled Pool Commissions wich payment status<>5 
		- Available for voyages from 2011 </DESC>
   <RETURN> 
		Success or failure
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>  </ARGS>
   <USAGE>	</USAGE>
********************************************************************/
constant string METHOD_NAME = "of_unsettle_tc_poolcomm"

//create transactions to reverse the rows 
long		ll_row, ll_rows, ll_counter, ll_commid
integer	li_trans_ok
string		ls_temp
mt_n_datastore		lds_tchire_poolcommission
s_transaction_input	lstr_transaction_input 
u_transaction_commission_claim_coda 	lnv_trans_coda

_addmessage( this.classdefinition, METHOD_NAME, "1. Reverse TC Hire Pool Commissions", "--")

lds_tchire_poolcommission = create mt_n_datastore

lds_tchire_poolcommission.dataobject = "d_sq_tb_tchire_settled_poolcommission"

lds_tchire_poolcommission.setTransObject(sqlca)

if lds_tchire_poolcommission.retrieve() = -1 then
	_addmessage( this.classdefinition, METHOD_NAME, "ERROR: Retrieve datawindow d_sq_tb_tchire_settled_poolcommission: " + sqlca.sqlerrtext, "--")
	destroy lds_tchire_poolcommission
	return c#return.failure
end if

ll_rows =  lds_tchire_poolcommission.rowcount( ) 
if ll_rows= 0 then 
	_addmessage( this.classdefinition, "d_sq_tb_tchire_settled_poolcommission()", "Nothing to do", "--")
	return c#return.noaction
end if

ll_counter = 0
for ll_row = ll_rows  to 1 step -1
		
	commit; 
	
	lstr_transaction_input.coda_or_cms = TRUE // This is a CODA transaction
	lstr_transaction_input.vessel_no = lds_tchire_poolcommission.GetItemNumber(ll_row,"vessel_nr")
	lstr_transaction_input.broker_no = lds_tchire_poolcommission.GetItemNumber(ll_row,"broker_nr")

	lstr_transaction_input.amount_local = lds_tchire_poolcommission.GetItemNumber(ll_row,"amount") * -1
	lstr_transaction_input.comm_amount = (lds_tchire_poolcommission.GetItemNumber(ll_row,"amount") * lds_tchire_poolcommission.GetItemNumber(ll_row,"ntc_payment_ex_rate_usd")/100) * -1
		
	lstr_transaction_input.tc_cp_date = lds_tchire_poolcommission.GetItemDatetime(ll_row,"cp_date")
	lstr_transaction_input.disb_currency_code = lds_tchire_poolcommission.GetItemString(ll_row,"curr_code")
	lstr_transaction_input.voyage_no = lds_tchire_poolcommission.GetItemString(ll_row,"voyage_nr")
	lstr_transaction_input.payment_start = lds_tchire_poolcommission.GetItemDatetime(ll_row,"period_start")
	lstr_transaction_input.payment_end = lds_tchire_poolcommission.GetItemDatetime(ll_row,"period_end")
	lstr_transaction_input.payment_id = lds_tchire_poolcommission.GetItemNumber(ll_row,"payment_id")

	lstr_transaction_input.comm_inv_no = lds_tchire_poolcommission.GetItemString(ll_row, "inv_nr")  + " CR"
	
	ll_commid = lds_tchire_poolcommission.GetItemNumber(ll_Row,"ntc_commission_ntc_comm_id")
	lstr_transaction_input.comm_inv_no = lds_tchire_poolcommission.GetItemString(ll_row, "inv_nr")
	if  left(upper(lstr_transaction_input.comm_inv_no),13)  = "DO NOT SETTLE" then
		lstr_transaction_input.comm_inv_no = "TCPoolComm" + string(ll_commid) +  " CR"	
	end if

	lnv_trans_coda = CREATE u_transaction_commission_claim_coda //CODA
				
	li_trans_ok = lnv_trans_coda.of_generate_transaction(lstr_transaction_input) //Generate CODA transaction
	
	If li_trans_ok  <> 1 THEN
		rollback;
		ls_temp = "ERROR TRANSACTION GENERATION -  Vessel: " + string(lstr_transaction_input.vessel_no) + " Broker: " +  string(lstr_transaction_input.broker_no) + " Invoice number: " + lstr_transaction_input.comm_inv_no
		_addmessage( this.classdefinition, METHOD_NAME, ls_temp, "--")

	else

		lds_tchire_poolcommission.deleterow( ll_row)
		
		if lds_tchire_poolcommission.update( ) = 1 then
			commit;
			ll_counter =ll_counter+1
		else
			rollback;
			ls_temp = "ERROR COMMISSIONS UPDATE -  Vessel: " + string(lstr_transaction_input.vessel_no) + " Broker: " +  string(lstr_transaction_input.broker_no) + " Invoice number: " + lstr_transaction_input.comm_inv_no
			_addmessage( this.classdefinition, METHOD_NAME, ls_temp, "--")
		end if
	
		Destroy lnv_trans_coda
	End if
next

destroy lds_tchire_poolcommission

_addmessage( this.classdefinition, METHOD_NAME, "Total= " + string(ll_rows) + " settled = " + string(ll_counter) , "--")




return c#return.success

end function

on n_poolcommission.create
call super::create
end on

on n_poolcommission.destroy
call super::destroy
end on

