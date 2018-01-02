$PBExportHeader$w_contlist.srw
$PBExportComments$This window shows all contact persons in the system.
forward
global type w_contlist from w_list
end type
end forward

global type w_contlist from w_list
end type
global w_contlist w_contlist

on w_contlist.create
call w_list::create
end on

on w_contlist.destroy
call w_list::destroy
end on

on cb_modify::clicked;Long ll_row, ll_brokernr
S_contact lstr_parm

ll_row = dw_1.GetSelectedRow(0)

If ll_Row > 0 Then
	lstr_parm.cont_id = dw_1.GetItemNumber(ll_row,"ccs_cont_pk" )
	ll_brokernr = dw_1.GetItemNumber(ll_row,"broker_nr")
	IF NOT IsNull(ll_brokernr) THEN
		lstr_parm.chart_or_broker = "B"
	END IF

	OpenSheetWithParm(w_cont,lstr_parm,w_tramos_main,7,Original!)
End if
end on

on cb_delete::clicked;Long ll_row,ll_cont_id

ll_row = dw_1.GetRow()
ll_cont_id = dw_1.GetItemNumber(ll_row,"ccs_cont_pk" )

IF  ll_Row <> 0 THEN
	IF MessageBox("Delete","You are about to DELETE !~r~nThis will cause all gifts for this person to be deleted"&
						+" as well.~r~nAre you sure you want to continue?",Question!,YesNo!,2) = 2 THEN return
	
	DELETE 
			FROM CCS_GIFT
			WHERE CCS_CONT_PK = :ll_cont_id;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("SQL error",SQLCA.SQLErrText,Information!)
				ROLLBACK;
				Return
			ELSE
				dw_1.DeleteRow(ll_row)
				dw_1.Update()
				IF SQLCA.SQLCode = 0 THEN
					COMMIT;
					dw_1.PostEvent("ue_retrieve")
				ELSE
					ROLLBACK;
				END IF

			END IF	
END IF
end on

on cb_new::clicked;
// Structure to send in PowerObjectParm
s_contact lstr_parm

// Contact person do not exist yet
lstr_parm.cont_id = 0


OpenSheetWithParm(w_cont,lstr_parm,w_tramos_main,7,Original!)
end on

on cb_refresh::clicked;call w_list`cb_refresh::clicked;cb_modify.Enabled = dw_1.GetSelectedRow(0) > 0
cb_delete.Enabled = cb_modify.Enabled
end on

