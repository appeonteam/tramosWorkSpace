$PBExportHeader$w_ccs_brokerlist.srw
$PBExportComments$This window lists the Brokers for the salessystem.
forward
global type w_ccs_brokerlist from w_ccs_chartlist
end type
end forward

global type w_ccs_brokerlist from w_ccs_chartlist
end type
global w_ccs_brokerlist w_ccs_brokerlist

on open;call w_ccs_chartlist::open;/* Indicate broker */
istr_parametre.additional_numbers[1] = 2

/* Sort on long name */
wf_select_column(2)
end on

on w_ccs_brokerlist.create
call w_ccs_chartlist::create
end on

on w_ccs_brokerlist.destroy
call w_ccs_chartlist::destroy
end on

type cb_modify from w_ccs_chartlist`cb_modify within w_ccs_brokerlist
string Text="Contacts"
end type

on cb_modify::clicked;/* Open list of contacts for the chosen broker */
s_contact lstr_parm
Long ll_row

ll_row = dw_1.GetSelectedRow(0)

If ll_Row > 0 Then
	lstr_parm.chart_or_broker = "B"
	lstr_parm.owner_id = dw_1.GetItemNumber(ll_row, Istr_parametre.column[0] )
	lstr_parm.owner_short_name = dw_1.GetItemString(ll_row, Istr_parametre.column[1] )
	OpenSheetWithParm(w_contacts,lstr_parm,w_tramos_main,7,Original!)
	
//	istr_parametre.edit_key_number = dw_1.GetItemNumber(ll_row, Istr_parametre.column[0] )
//	OpenSheetWithParm(w_contacts,istr_parametre,w_tramos_main,7,Original!)
End if

end on

