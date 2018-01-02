$PBExportHeader$u_transaction_hire.sru
$PBExportComments$Ancestor object for generating TC Hire cms and coda transactions. Inherited from u_transaction. Only change is commit in save function.
forward
global type u_transaction_hire from u_transaction
end type
end forward

global type u_transaction_hire from u_transaction
end type
global u_transaction_hire u_transaction_hire

forward prototypes
public function integer of_save ()
end prototypes

public function integer of_save ();/* Saves the transactions (datastores) in transaction log */
long ll_transkey, ll_rows, ll_rowno

//f_datastore_spy(ids_apost)
//f_datastore_spy(ids_bpost)

IF ids_apost.RowCount() = 1 THEN
	IF ids_bpost.RowCount() > 0 THEN
		/* Save apost and fill transkey in bpost and save bpost */
		IF ids_apost.Update() = 1 THEN
			ll_transkey = ids_apost.GetItemNumber(1,"trans_key")
			IF IsNull(ll_transkey) OR ll_transkey = 0 THEN
				of_messagebox("Generate transaction error", "No value found for transaction key")
				ROLLBACK;
				Return(-1)
			ELSE
				ll_rows = ids_bpost.RowCount()
				FOR ll_rowno = 1 TO ll_rows
					ids_bpost.SetItem(ll_rowno, "trans_key", ll_transkey)
				NEXT
				ids_bpost.AcceptText()
				IF ids_bpost.Update() = 1 THEN
					// no commit here as transaction is part of an LUW that will be committed as a whole	
					//COMMIT;
					Return(1)
				ELSE
					ROLLBACK;
					of_messagebox("Error","ids_Apost ok, but ids_Bpost went wrong in update")
					Return(-1)
				END IF
			END IF
		ELSE
			of_messagebox("Error","Update of ids_Apost went wrong" + SQLCA.SqlErrText)
			ROLLBACK;
			Return(-1)
		END IF
	ELSE
		of_messagebox("Generate transaction","No CODA transaction Generated. Probably because all CODA transactions already posted!")
		Return(1)
	END IF
ELSE
	of_messagebox("Generate transaction error", "Non or to many rows found in A-post")
	Return(-1)
END IF

end function

on u_transaction_hire.create
call super::create
end on

on u_transaction_hire.destroy
call super::destroy
end on

