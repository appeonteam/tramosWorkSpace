$PBExportHeader$w_portvalidator.srw
forward
global type w_portvalidator from mt_w_popupbox
end type
type dw_validator from u_datagrid within w_portvalidator
end type
type st_messagedetail from mt_u_statictext within w_portvalidator
end type
end forward

global type w_portvalidator from mt_w_popupbox
boolean visible = false
integer width = 1618
integer height = 228
long backcolor = 32304364
string icon = "Asterisk!"
event ue_lbuttondown pbm_lbuttondown
dw_validator dw_validator
st_messagedetail st_messagedetail
end type
global w_portvalidator w_portvalidator

type variables
string				is_windowtitle	
string				is_messagedetail
string 				is_reference				/* the main controller that manages the business logic regarding the scenario*/
string				is_portcode=""
string				is_voyagenr
string				is_vesselref
boolean				ib_enginecontrol
integer				ii_action=0					/* value to return back to the validators calling process */
integer				ii_vesselnr=0
integer				ii_previousvesselnr=-1	/* used to test if vessel nr has changed */
long					il_calcid					/* the current calc id what ever the status is */
long					il_calcalcid				/* if applicable the calculated calc id */
long					il_estcalcid				/* if applicable the estimated calc id */
long					il_fixtureid 				/* if applicable the fixtured calc id */
long 					il_winheight

end variables

forward prototypes
public subroutine documentation ()
public function integer of_generate ()
public function string of_get_previousvoyage (long al_vesselnr, string as_voyagenr)
end prototypes

event ue_lbuttondown;//Send( Handle( this ), 274, 61458, 0 )
end event

public subroutine documentation ();/********************************************************************
   w_portvalidator: window container for portvalidator tool
	
	<OBJECT>
		Object Description
	</OBJECT>
   <DESC>
		Used when any mismatches occur between ports/purposes on the calcualtion
		itinerary and the proceeeding/poc.
	</DESC>
   <USAGE>
		Always called through the n_portvalidator object
	</USAGE>
   <ALSO>
		n_portvalidator
		n_portvalidatordata
		d_ex_gr_portvalidator
	</ALSO>
	<HISTORY>
		Date    		Ref   		Author		Comments
		00/00/07		?     		AGL   		First Version
		23/11/11		D-CALC		AGL   		Created shortcut functionality	
		05/12/14		CR3514		XSZ004		Open calculation, Proceeding or POC window 
		        		      		      		when double clicked on ballast port purpose in port validation popup
	</HISTROY>
********************************************************************/
end subroutine

public function integer of_generate ();/* object that opens this window is destroyed so we must copy 
all we need including the rows, into this window object */

long ll_row, ll_rowcount, ll_columnheight, ll_adjustheight

constant integer ii_SHOWNMAXROWS = 20
constant integer li_DWHEADERHEIGHT = 144
constant integer li_TIPYPOS = 368

ll_columnheight=76
if dw_validator.rowcount() > ii_SHOWNMAXROWS then
	ll_adjustheight = li_DWHEADERHEIGHT + (ll_columnheight * ii_SHOWNMAXROWS)
else
	ll_adjustheight = li_DWHEADERHEIGHT + (ll_columnheight * dw_validator.rowcount())
end if 

if this.height <> il_winheight + ll_adjustheight then
	this.height = il_winheight + ll_adjustheight
	dw_validator.height = ll_adjustheight	
	// r_border.height = this.height
end if

this.setredraw( false )

/* load data from powerobject 
passed into controls */
st_messagedetail.text = is_messagedetail

if ii_previousvesselnr <> ii_vesselnr then
	SELECT "(" + VESSEL_REF_NR + ")"
	INTO :is_vesselref
	FROM VESSELS
	WHERE VESSEL_NR = :ii_vesselnr;
	ii_previousvesselnr = ii_vesselnr
end if	

st_title.text = is_windowtitle + " " + is_vesselref + " - " + is_voyagenr
this.setredraw( true )

return c#return.Success
end function

public function string of_get_previousvoyage (long al_vesselnr, string as_voyagenr);/********************************************************************
 of_get_previousvoyage
<DESC> Get previous voyage number. </DESC>
<RETURN>
	string: voyage number
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	al_vesselnr
	as_voyagenr
</ARGS>
<USAGE>
</USAGE>
<HISTORY>
	Date    		CR-Ref		Author		Comments
	05/12/14		CR3514		XSZ004		First version
</HISTORY>
********************************************************************/

string ls_previousvoyage

SELECT MAX(VOYAGES.VOYAGE_NR) INTO :ls_previousvoyage 
  FROM VOYAGES, PROCEED
 WHERE VOYAGES.VESSEL_NR = PROCEED.VESSEL_NR AND
       VOYAGES.VOYAGE_NR = PROCEED.VOYAGE_NR AND
		 VOYAGES.VESSEL_NR = :al_vesselnr     AND
		 VOYAGES.VOYAGE_NR < :as_voyagenr AND
		 CONVERT(INT,SUBSTRING(VOYAGES.VOYAGE_NR,1,5)) < 90000;

return ls_previousvoyage
end function

on w_portvalidator.create
int iCurrent
call super::create
this.dw_validator=create dw_validator
this.st_messagedetail=create st_messagedetail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_validator
this.Control[iCurrent+2]=this.st_messagedetail
end on

on w_portvalidator.destroy
call super::destroy
destroy(this.dw_validator)
destroy(this.st_messagedetail)
end on

event open;call super::open;il_winheight = this.height
//of_generate()

end event

event closequery;call super::closequery;//destroy inv_windata
end event

event ue_refresh;call super::ue_refresh;n_portvalidator lnv_validator
lnv_validator = create n_portvalidator
integer	li_retval
/* this uses the operational functions to initialise even if generated from calculation */
li_retval = lnv_validator.of_start( is_reference, ii_vesselnr, is_voyagenr, 5)
destroy n_portvalidator
end event

type st_hidemenubar from mt_w_popupbox`st_hidemenubar within w_portvalidator
end type

type r_styledborder from mt_w_popupbox`r_styledborder within w_portvalidator
end type

type p_close from mt_w_popupbox`p_close within w_portvalidator
end type

type p_refresh from mt_w_popupbox`p_refresh within w_portvalidator
string powertiptext = "Refresh Validator"
end type

type st_title from mt_w_popupbox`st_title within w_portvalidator
end type

type st_spacer from mt_w_popupbox`st_spacer within w_portvalidator
end type

type dw_validator from u_datagrid within w_portvalidator
integer x = 5
integer y = 200
integer width = 1600
integer height = 0
integer taborder = 10
string dragicon = "AppIcon!"
string dataobject = "d_ex_gr_portvalidator"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event doubleclicked;call super::doubleclicked;/********************************************************************
  dw_validator.doubleclicked()
<DESC>   
	Shortcut to detail.  
</DESC>
<RETURN>
	n/a
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	pb defaults for standard event
</ARGS>
<USAGE>
	calls existing processes to control shortcuts from finance control library.
</USAGE>
<HISTORY>
	Date    		CR-Ref		Author		Comments
	?       		?     		?     		First version
	05/12/14		CR3514		XSZ004		Open calculation, Proceeding or POC window 
		        		      		      	when double clicked on ballast port purpose in port validation popup

</HISTORY>
********************************************************************/

long   ll_portmatched, ll_purposematched
string ls_voyagenr

u_jump_poc        lnv_jumppoc
s_opencalc_parm   lstr_opencalc_parm
n_jump_proceeding lnv_jumpproc

w_atobviac_calc_calculation 	lw_calc

if row > 0 then
	if trim(this.getitemstring(row, "itin_portname")) = "..." then return
end if

CHOOSE CASE dwo.name
		
	CASE "itin_portcode", "itin_portname", "itin_purposecode"	
		/* direct user to the calculation */	
		/* declare specific vars */
		integer li_retval
		n_calcwindowcontrol lnv_calcwincontrol
		
		//lw_calc = of_getopencalc(il_calcid)
		lnv_calcwincontrol = create n_calcwindowcontrol		
		lw_calc = lnv_calcwincontrol.of_getavailablecalc( il_calcalcid, il_fixtureid, 5, li_retval)
		
		destroy lnv_calcwincontrol
		
		if isvalid(lw_calc) then
			/* aldready open so attempt to switch the page */
			lw_calc.setfocus( )
			/* expand calculation no matter what mode it is in */
			lw_calc.wf_cpact_change_winsize( 3 - lw_calc.uo_calculation.uf_cpact_get_win_mode( ) )
			
			if dwo.name="itin_purposecode" then
				lw_calc.uo_calculation.uf_select_page( 3 )
			else
				lw_calc.uo_calculation.uf_select_page( 2 )
			end if
		else
			/* not open already! */	
			lstr_opencalc_parm.l_calc_id = il_calcalcid
			if dwo.name="itin_purposecode" then
				lstr_opencalc_parm.i_defaultpage = 3
			else
				lstr_opencalc_parm.i_defaultpage = 2
			end if
			
			/* if not already active create instance */
			if not isvalid(gnv_atobviac) then gnv_atobviac = create n_atobviac
			
			/* if not open open tables - can take number of seconds */
			if not gnv_atobviac.of_getTableOpen( ) then
				open(w_startup_screen)
				gnv_atobviac.of_opentable()
				close(w_startup_screen)
			end if 
			
			opensheetwithparm(lw_calc, lstr_opencalc_parm,w_tramos_main,0,Original!)
		end if			
		
	CASE "proc_portcode", "proc_portname"	
		/* direct user to the proceeding window, selecting port */	
		ll_portmatched = this.getitemnumber(row,"port_matched")
		/* additional validation is needed in this case due to the possibility of selected port being empty  */
		lnv_jumpproc = create n_jump_proceeding
		
		if  isnull(this.getitemstring(row,"proc_portcode")) or this.getitemstring(row,"proc_portcode")="" then
			lnv_jumpproc.of_openproceeding(ii_vesselnr, is_voyagenr)
		else
			if this.getitemstring(row, "itin_purposecode") = "B" then
				ls_voyagenr = of_get_previousvoyage(ii_vesselnr, is_voyagenr)	
			else
				ls_voyagenr = is_voyagenr
			end if
			
			lnv_jumpproc.of_openproceeding(ii_vesselnr, ls_voyagenr, this.getitemstring(row,"proc_portcode")  , this.getitemnumber(row,"proc_pcn"))
		end if
		
		destroy lnv_jumpproc
		
	CASE "proc_purposecode"			
		/* direct user to the port of call */	
		/* it is taken for granted that there is a proc port code available. */
		ll_purposematched = this.getitemnumber(row,"purpose_matched")
		lnv_jumppoc = create u_jump_poc
		
		if ll_purposematched = 3 then		
			lnv_jumppoc.of_open_poc(ii_vesselnr, ls_voyagenr, this.getitemstring(row,"proc_portcode")  , this.getitemnumber(row,"proc_pcn"))
		else
			lnv_jumppoc.of_open_poc(ii_vesselnr, is_voyagenr)
		end if
		
		destroy lnv_jumppoc				
	CASE ELSE
		/* do nothing */	
END CHOOSE		
end event

type st_messagedetail from mt_u_statictext within w_portvalidator
event ue_lbuttondown pbm_lbuttondown
integer x = 14
integer y = 120
integer width = 1577
integer height = 68
integer weight = 700
long textcolor = 128
long backcolor = 553648127
string text = "* datawindow has 0 height, access through control list *"
alignment alignment = center!
end type

