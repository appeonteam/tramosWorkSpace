$PBExportHeader$w_disb_print_disb_account.srw
$PBExportComments$Print of disbursement account.
forward
global type w_disb_print_disb_account from w_print_basewindow
end type
end forward

global type w_disb_print_disb_account from w_print_basewindow
end type
global w_disb_print_disb_account w_disb_print_disb_account

type variables
s_disbursement lstr_disb
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/*******************************************************************************************************
   ObjectName: w_disb_print_disb_account
   <OBJECT> </OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   </ALSO>
	<HISTORY>
		Date   		Ref   		Author      Comments
		07/05/15		CR3854		XSZ004		Historical bug.
	</HISTORY>
*********************************************************************************************************/
end subroutine

event open;call super::open;double ld_dif_pay_ex_rate
string ls_mod
long   ll_dec_pos

decimal{2} ld_total_local, ld_total_usd, ld_total_adv_local, ld_total_adv_usd

datawindowchild dwc_1, dwc_2

lstr_disb    = Message.PowerObjectParm
ii_startup   = 2
ib_autoclose = TRUE

dw_print.Retrieve(lstr_disb.vessel_nr, lstr_disb.voyage_nr, lstr_disb.port_code, lstr_disb.pcn, lstr_disb.agent_nr)

IF dw_print.GetChild("rep_1",dwc_1) = -1 THEN messagebox("","dwchild_1 get failed")

IF dw_print.GetChild("rep_2",dwc_2) = -1 THEN messagebox("","dwchild_2 get failed")

ld_total_local = dwc_1.GetItemNumber(1,"total_local")
ld_total_usd   = dwc_1.GetItemNumber(1,"total_usd")

if ld_total_usd <> 0 then
	ld_dif_pay_ex_rate = ld_total_local/ld_total_usd
end if

ls_mod     =string(ld_dif_pay_ex_rate)
ll_dec_pos = pos(ls_mod, ",", 1)

IF ll_dec_pos > 0 THEN ls_mod = Replace ( ls_mod, ll_dec_pos, 1, "." )

ls_mod ="payment_to_disb_rate.expression = '" + ls_mod + "'"

dwc_2.modify(ls_mod)

ld_total_adv_local = dwc_2.GetItemNumber(1,"total_adv_disb")
ld_total_adv_usd   = dwc_2.GetItemNumber(1,"total_adv_usd")

ls_mod =string(ld_total_adv_local - ld_total_local)

ll_dec_pos = pos(ls_mod,",",1)

IF ll_dec_pos > 0 THEN ls_mod = Replace ( ls_mod, ll_dec_pos, 1, "." )

ls_mod = "balance_due_disb.expression = '" + ls_mod + "'"

dwc_2.modify(ls_mod)

ls_mod = string(ld_total_adv_usd - ld_total_usd)

ll_dec_pos = pos(ls_mod, ",", 1)

IF ll_dec_pos > 0 THEN ls_mod = Replace ( ls_mod, ll_dec_pos, 1, "." ) 

ls_mod = "balance_due_usd.expression = '" + ls_mod + "'"

dwc_2.modify(ls_mod)

dw_print.modify("signer.text = '" + uo_global.getuserid() + "'")

end event

on w_disb_print_disb_account.create
call super::create
end on

on w_disb_print_disb_account.destroy
call super::destroy
end on

type st_hidemenubar from w_print_basewindow`st_hidemenubar within w_disb_print_disb_account
end type

type cbx_save_size from w_print_basewindow`cbx_save_size within w_disb_print_disb_account
end type

type dw_print from w_print_basewindow`dw_print within w_disb_print_disb_account
integer x = 1161
string dataobject = "dw_disb_print_disb_account_report"
end type

type cb_fullpreview from w_print_basewindow`cb_fullpreview within w_disb_print_disb_account
end type

type st_previewtext from w_print_basewindow`st_previewtext within w_disb_print_disb_account
end type

type em_zoom from w_print_basewindow`em_zoom within w_disb_print_disb_account
end type

type cb_pageforward10 from w_print_basewindow`cb_pageforward10 within w_disb_print_disb_account
end type

type cb_pageforward from w_print_basewindow`cb_pageforward within w_disb_print_disb_account
end type

type cb_pageback from w_print_basewindow`cb_pageback within w_disb_print_disb_account
end type

type cb_pageback10 from w_print_basewindow`cb_pageback10 within w_disb_print_disb_account
end type

type st_percent from w_print_basewindow`st_percent within w_disb_print_disb_account
end type

type st_1 from w_print_basewindow`st_1 within w_disb_print_disb_account
end type

type st_misc_print_file from w_print_basewindow`st_misc_print_file within w_disb_print_disb_account
end type

type cbx_misc_print_to_file from w_print_basewindow`cbx_misc_print_to_file within w_disb_print_disb_account
end type

type cbx_misc_collate_copies from w_print_basewindow`cbx_misc_collate_copies within w_disb_print_disb_account
end type

type sle_misc_print_file from w_print_basewindow`sle_misc_print_file within w_disb_print_disb_account
integer weight = 700
long backcolor = 16776960
end type

type cb_misc_file from w_print_basewindow`cb_misc_file within w_disb_print_disb_account
string text = "&File..."
end type

type rb_range_pages from w_print_basewindow`rb_range_pages within w_disb_print_disb_account
end type

type rb_range_current from w_print_basewindow`rb_range_current within w_disb_print_disb_account
end type

type rb_range_all from w_print_basewindow`rb_range_all within w_disb_print_disb_account
end type

type cb_select_filecollate from w_print_basewindow`cb_select_filecollate within w_disb_print_disb_account
end type

type cb_select_pages from w_print_basewindow`cb_select_pages within w_disb_print_disb_account
end type

type cb_select_options from w_print_basewindow`cb_select_options within w_disb_print_disb_account
boolean enabled = true
end type

type st_range from w_print_basewindow`st_range within w_disb_print_disb_account
end type

type sle_range_range from w_print_basewindow`sle_range_range within w_disb_print_disb_account
long backcolor = 16776960
end type

type cb_options_printer from w_print_basewindow`cb_options_printer within w_disb_print_disb_account
boolean visible = false
end type

type sle_options_no_copies from w_print_basewindow`sle_options_no_copies within w_disb_print_disb_account
boolean visible = false
end type

type st_options_text from w_print_basewindow`st_options_text within w_disb_print_disb_account
boolean visible = false
end type

type st_options_2 from w_print_basewindow`st_options_2 within w_disb_print_disb_account
boolean visible = false
boolean enabled = false
end type

type st_optins_1 from w_print_basewindow`st_optins_1 within w_disb_print_disb_account
boolean visible = false
boolean enabled = false
end type

type cb_cancel from w_print_basewindow`cb_cancel within w_disb_print_disb_account
end type

type cb_print from w_print_basewindow`cb_print within w_disb_print_disb_account
end type

type gb_misc_print from w_print_basewindow`gb_misc_print within w_disb_print_disb_account
end type

type gb_range from w_print_basewindow`gb_range within w_disb_print_disb_account
end type

type gb_options from w_print_basewindow`gb_options within w_disb_print_disb_account
boolean visible = false
end type

type cb_saveas from w_print_basewindow`cb_saveas within w_disb_print_disb_account
end type

