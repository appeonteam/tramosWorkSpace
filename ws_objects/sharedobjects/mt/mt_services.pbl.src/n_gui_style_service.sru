$PBExportHeader$n_gui_style_service.sru
$PBExportComments$graphic style service..
forward
global type n_gui_style_service from mt_n_baseservice
end type
end forward

global type n_gui_style_service from mt_n_baseservice
end type
global n_gui_style_service n_gui_style_service

type variables
string	is_ignoredcolorlist  = "," + string(c#color.MT_LISTHEADER_BG) + "," + string(c#color.Transparent) + ","
string	is_ignoredhandlelist = ","

end variables

forward prototypes
public subroutine documentation ()
public subroutine of_setbackgroundcolor (graphicobject ago_parent, long al_bkcolor)
public subroutine of_addignoredcolor (long al_ignoredcolor)
public subroutine of_setdefaultbackgroundcolor (graphicobject ago_parent)
public subroutine of_setfontandcolor (graphicobject ago_object, boolean ab_facename, boolean ab_textsize, boolean ab_fgcolor, boolean ab_bkcolor, string as_facename, long al_textsize, long al_fgcolor, long al_bkcolor)
public subroutine of_addignoredobject (graphicobject ago_object)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_gui_style_service
	
	<OBJECT>
		Restyles window, userobjects, controls
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		Object Usage.
		_setfontandcolor( this, true, true, true, true, "Microsoft Sans Serif", 14, c#color.mt_listheader_bg, c#color.mt_form_bg)
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   		Ref    	Author   		Comments
  	29/07/11 		CR#2403	AGL      		Brought Appeon global function into service.
	29/08/11       N/A      ZSW001         Add function of_setfontandobject(graphicobject ago_object)
********************************************************************/

end subroutine

public subroutine of_setbackgroundcolor (graphicobject ago_parent, long al_bkcolor);/********************************************************************
  of_setbackgroundcolor
   <DESC> set the background color </DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
		ago_parent : the window/userobject/tab which need to be set with this style
		al_bkcolor : Long, the background color
   </ARGS>
   <USAGE> Suggest to use in the Open event of the window to paint the UI as desired </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author       Comments
   	28/07/2011              ZSW001       First Version
   </HISTORY>
********************************************************************/

of_setfontandcolor(ago_parent, false, false, false, true, "", 0, 0, al_bkcolor)

end subroutine

public subroutine of_addignoredcolor (long al_ignoredcolor);/********************************************************************
   of_addignoredcolor
   <DESC> Don't replace the background color for special color </DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
		al_ignoredcolor : the background color which will not be replaced with the appointed background color.
   </ARGS>
   <USAGE> Suggest to use in the event "ue_addignoredcolorandobject" of the window  </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author       Comments
   	02/08/2011 N/A          ZSW001       First Version
   </HISTORY>
********************************************************************/

if pos(is_ignoredcolorlist, "," + string(al_ignoredcolor) + ",") <= 0 then is_ignoredcolorlist += string(al_ignoredcolor) + ","

end subroutine

public subroutine of_setdefaultbackgroundcolor (graphicobject ago_parent);/********************************************************************
  of_setdefaultbackgroundcolor
   <DESC> set the default background color </DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
		ago_parent : the window/userobject/tab which need to be set with this style
   </ARGS>
   <USAGE> Suggest to use in the Open event of the window to paint the UI as desired </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author       Comments
   	28/07/2011              ZSW001       First Version
   </HISTORY>
********************************************************************/

of_setfontandcolor(ago_parent, false, false, false, true, "", 0, 0, c#color.MT_FORMDETAIL_BG)

end subroutine

public subroutine of_setfontandcolor (graphicobject ago_object, boolean ab_facename, boolean ab_textsize, boolean ab_fgcolor, boolean ab_bkcolor, string as_facename, long al_textsize, long al_fgcolor, long al_bkcolor);/********************************************************************
   of_setfontandcolor
   <DESC> set the font type(facename)/size/color as well as the background color </DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
		ago_object  : the window/userobject/tab/control which need to be set with this style
		ab_facename : TRUE/FALSE, whether to set the font type or not
		ab_textsize : TRUE/FALSE, whether to set the font size or not
		ab_fgcolor  : TRUE/FALSE, whether to set the font color or not
		ab_bkcolor  : TRUE/FALSE, whether to set the background color or not
		as_facename : String, the font type name
		al_textsize : Long, the font size
		al_fgcolor  : Long, the font color
		al_bkcolor  : Long, the background color
   </ARGS>
   <USAGE> Suggest to use in the Open event of the window to paint the UI as desired </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author       Comments
   	28/07/2011              ZSW001       First Version
   </HISTORY>
********************************************************************/

window						lw_parent
checkbox						cbx_winobject
commandbutton				cb_winobject
datawindow					dw_winobject
dropdownlistbox			ddlb_winobject
dropdownpicturelistbox	ddplb_winobject
editmask						em_winobject
graph							gr_winobject
groupbox						gb_winobject
hprogressbar				hpb_winobject
hscrollbar					hsb_winobject
htrackbar					htb_winobject
listbox						lb_winobject
listview						lv_winobject
monthcalendar				lmc_winobject
multilineedit				mle_winobject
olecontrol					ole_winobject
olecustomcontrol			olm_winobject
picture						p_winobject
picturebutton				pb_winobject
picturehyperlink			phl_winobject
picturelistbox				plb_winobject
radiobutton					rb_winobject
richtextedit				rte_winobject
singlelineedit				sle_winobject
statichyperlink			shl_winobject
statictext					st_winobject
tab							tab_parent
userobject					uo_parent
treeview						tv_winobject
vprogressbar				vpb_winobject
vscrollbar					vsb_winobject
vtrackbar					vtb_winobject

string	ls_bkcolor
long		ll_objnum, ll_objcnts

choose case ago_object.typeof()
	case animation!
		//do nothing
	case checkbox!
		cbx_winobject = ago_object
		
		if ab_facename then cbx_winobject.facename = as_facename
		if ab_textsize then cbx_winobject.textsize = al_textsize
		
		if ab_fgcolor then cbx_winobject.textcolor = al_fgcolor
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(cbx_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(cbx_winobject)) + ",") <= 0 then
			cbx_winobject.backcolor = al_bkcolor
		end if
	case commandbutton!
		cb_winobject = ago_object
		
		if ab_facename then cb_winobject.facename = as_facename
		if ab_textsize then cb_winobject.textsize = al_textsize
	case datawindow!
		dw_winobject = ago_object
		try
			if dw_winobject.dynamic event ue_usedefaultbackgroundcolor() then
				if ab_bkcolor and pos(is_ignoredhandlelist, "," + string(handle(dw_winobject)) + ",") <= 0 then
					ls_bkcolor = dw_winobject.describe("datawindow.detail.color")
					if pos(is_ignoredcolorlist, "," + ls_bkcolor + ",") <= 0 then
						dw_winobject.modify("datawindow.detail.color = " + string(al_bkcolor))
					end if
					ls_bkcolor = dw_winobject.describe("datawindow.color")
					if pos(is_ignoredcolorlist, "," + ls_bkcolor + ",") <= 0 then
						dw_winobject.modify("datawindow.color = " + string(al_bkcolor))
					end if
				end if
			end if
		catch(throwable error)
			//do nothing
		end try
	case dropdownlistbox!
		ddlb_winobject = ago_object
		
		if ab_facename then ddlb_winobject.facename = as_facename
		if ab_textsize then ddlb_winobject.textsize = al_textsize
		
		if ab_fgcolor then ddlb_winobject.textcolor = al_fgcolor
		/*
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(ddlb_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(ddlb_winobject)) + ",") <= 0 then
			ddlb_winobject.backcolor = al_bkcolor
		end if
		*/
	case dropdownpicturelistbox!
		ddplb_winobject = ago_object
		
		if ab_facename then ddplb_winobject.facename = as_facename
		if ab_textsize then ddplb_winobject.textsize = al_textsize
		
		if ab_fgcolor then ddplb_winobject.textcolor = al_fgcolor
		/*
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(ddplb_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(ddplb_winobject)) + ",") <= 0 then
			ddplb_winobject.backcolor = al_bkcolor
		end if
		*/
	case editmask!
		em_winobject = ago_object
		
		if ab_facename then em_winobject.facename = as_facename
		if ab_textsize then em_winobject.textsize = al_textsize
		
		if ab_fgcolor then em_winobject.textcolor = al_fgcolor
		/*
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(em_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(em_winobject)) + ",") <= 0 then
			em_winobject.backcolor = al_bkcolor
		end if
		*/
	case graph!
		gr_winobject = ago_object
		
		if ab_fgcolor then gr_winobject.textcolor = al_fgcolor
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(gr_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(gr_winobject)) + ",") <= 0 then
			gr_winobject.backcolor = al_bkcolor
		end if
	case groupbox!
		gb_winobject = ago_object
		
		if ab_facename then gb_winobject.facename = as_facename
		if ab_textsize then gb_winobject.textsize = al_textsize
		
		if ab_fgcolor then gb_winobject.textcolor = al_fgcolor
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(gb_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(gb_winobject)) + ",") <= 0 then
			gb_winobject.backcolor = al_bkcolor
		end if
	case hprogressbar!
		//do nothing
	case hscrollbar!
		//do nothing
	case htrackbar!
		//do nothing
	case line!
		//do nothing
	case listbox!
		lb_winobject = ago_object
		
		if ab_facename then lb_winobject.facename = as_facename
		if ab_textsize then lb_winobject.textsize = al_textsize
		
		if ab_fgcolor then lb_winobject.textcolor = al_fgcolor
		/*
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(lb_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(lb_winobject)) + ",") <= 0 then
			lb_winobject.backcolor = al_bkcolor
		end if
		*/
	case listview!
		lv_winobject = ago_object
		
		if ab_facename then lv_winobject.facename = as_facename
		if ab_textsize then lv_winobject.textsize = al_textsize
		
		if ab_fgcolor then lv_winobject.textcolor = al_fgcolor
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(lv_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(lv_winobject)) + ",") <= 0 then
			lv_winobject.backcolor = al_bkcolor
		end if
	case monthcalendar!
		lmc_winobject = ago_object
		
		if ab_facename then lmc_winobject.facename = as_facename
		if ab_textsize then lmc_winobject.textsize = al_textsize
		
		if ab_fgcolor then lmc_winobject.textcolor = al_fgcolor
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(lmc_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(lmc_winobject)) + ",") <= 0 then
			lmc_winobject.backcolor = al_bkcolor
		end if
	case multilineedit!
		mle_winobject = ago_object
		
		if ab_facename then mle_winobject.facename = as_facename
		if ab_textsize then mle_winobject.textsize = al_textsize
		
		if ab_fgcolor then mle_winobject.textcolor = al_fgcolor
		/*
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(mle_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(mle_winobject)) + ",") <= 0 then
			mle_winobject.backcolor = al_bkcolor
		end if
		*/
	case olecontrol!
		ole_winobject = ago_object
		
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(ole_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(ole_winobject)) + ",") <= 0 then
			ole_winobject.backcolor = al_bkcolor
		end if
	case olecustomcontrol!
		olm_winobject = ago_object
		
		if ab_facename then olm_winobject.facename = as_facename
		if ab_textsize then olm_winobject.textsize = al_textsize
		
		if ab_fgcolor then olm_winobject.textcolor = al_fgcolor
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(olm_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(olm_winobject)) + ",") <= 0 then
			olm_winobject.backcolor = al_bkcolor
		end if
	case oval!
		//do nothing
	case picture!
		//do nothing
	case picturebutton!
		pb_winobject = ago_object
		
		if ab_facename then pb_winobject.facename = as_facename
		if ab_textsize then pb_winobject.textsize = al_textsize
		
		if ab_fgcolor then pb_winobject.textcolor = al_fgcolor
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(pb_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(pb_winobject)) + ",") <= 0 then
			pb_winobject.backcolor = al_bkcolor
		end if
	case picturehyperlink!
		//do nothing
	case picturelistbox!
		plb_winobject = ago_object
		
		if ab_facename then plb_winobject.facename = as_facename
		if ab_textsize then plb_winobject.textsize = al_textsize
		
		if ab_fgcolor then plb_winobject.textcolor = al_fgcolor
		/*
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(plb_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(plb_winobject)) + ",") <= 0 then
			plb_winobject.backcolor = al_bkcolor
		end if
		*/
	case radiobutton!
		rb_winobject = ago_object
		
		if ab_facename then rb_winobject.facename = as_facename
		if ab_textsize then rb_winobject.textsize = al_textsize
		
		if ab_fgcolor then rb_winobject.textcolor = al_fgcolor
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(rb_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(rb_winobject)) + ",") <= 0 then
			rb_winobject.backcolor = al_bkcolor
		end if
	case rectangle!
		//do nothing
	case richtextedit!
		rte_winobject = ago_object
		
		if ab_facename then rte_winobject.facename = as_facename
		if ab_textsize then rte_winobject.textsize = al_textsize
		
		/*
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(rte_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(rte_winobject)) + ",") <= 0 then
			rte_winobject.backcolor = al_bkcolor
		end if
		*/
	case roundrectangle!
		//do nothing
	case singlelineedit!
		sle_winobject = ago_object
		
		if ab_facename then sle_winobject.facename = as_facename
		if ab_textsize then sle_winobject.textsize = al_textsize
		
		if ab_fgcolor then sle_winobject.textcolor = al_fgcolor
		/*
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(sle_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(sle_winobject)) + ",") <= 0 then
			sle_winobject.backcolor = al_bkcolor
		end if
		*/
	case statichyperlink!
		shl_winobject = ago_object
		
		if ab_facename then shl_winobject.facename = as_facename
		if ab_textsize then shl_winobject.textsize = al_textsize
		
		if ab_fgcolor then shl_winobject.textcolor = al_fgcolor
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(shl_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(shl_winobject)) + ",") <= 0 then
			shl_winobject.backcolor = al_bkcolor
		end if
	case statictext!
		st_winobject = ago_object
		
		if ab_facename then st_winobject.facename = as_facename
		if ab_textsize then st_winobject.textsize = al_textsize
		
		if ab_fgcolor then st_winobject.textcolor = al_fgcolor
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(st_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(st_winobject)) + ",") <= 0 then
			st_winobject.backcolor = al_bkcolor
		end if
	case tab!
		tab_parent = ago_object
	
		if ab_facename then tab_parent.facename = as_facename
		if ab_textsize then tab_parent.textsize = al_textsize
		
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(tab_parent.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(tab_parent)) + ",") <= 0 then
			tab_parent.backcolor = al_bkcolor
		end if
		
		ll_objcnts = upperbound(tab_parent.control)
		for ll_objnum = 1 to ll_objcnts
			of_setfontandcolor(tab_parent.control[ll_objnum], ab_facename, ab_textsize, ab_fgcolor, ab_bkcolor, as_facename, al_textsize, al_fgcolor, al_bkcolor)
		next
	case treeview!
		tv_winobject = ago_object
		
		if ab_facename then tv_winobject.facename = as_facename
		if ab_textsize then tv_winobject.textsize = al_textsize
		
		if ab_fgcolor then tv_winobject.textcolor = al_fgcolor
		/*
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(tv_winobject.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(tv_winobject)) + ",") <= 0 then
			tv_winobject.backcolor = al_bkcolor
		end if
		*/
	case userobject!
		uo_parent = ago_object
	
		if ab_fgcolor then uo_parent.tabtextcolor = al_fgcolor
		if ab_bkcolor and pos(is_ignoredhandlelist, "," + string(handle(uo_parent)) + ",") <= 0 then
			if pos(is_ignoredcolorlist, "," + string(uo_parent.backcolor) + ",") <= 0 then uo_parent.backcolor = al_bkcolor
			if pos(is_ignoredcolorlist, "," + string(uo_parent.tabbackcolor) + ",") <= 0 then uo_parent.tabbackcolor = al_bkcolor
		end if
		
		ll_objcnts = upperbound(uo_parent.control)
		for ll_objnum = 1 to ll_objcnts
			of_setfontandcolor(uo_parent.control[ll_objnum], ab_facename, ab_textsize, ab_fgcolor, ab_bkcolor, as_facename, al_textsize, al_fgcolor, al_bkcolor)
		next
	case vprogressbar!
		//do nothing
	case vscrollbar!
		//do nothing
	case vtrackbar!
		//do nothing
	case window!
		lw_parent = ago_object
		
		if ab_bkcolor and pos(is_ignoredcolorlist, "," + string(lw_parent.backcolor) + ",") <= 0 &
			           and pos(is_ignoredhandlelist, "," + string(handle(lw_parent)) + ",") <= 0 then
			lw_parent.backcolor = al_bkcolor
		end if
		
		ll_objcnts = upperbound(lw_parent.control)
		for ll_objnum = 1 to ll_objcnts
			of_setfontandcolor(lw_parent.control[ll_objnum], ab_facename, ab_textsize, ab_fgcolor, ab_bkcolor, as_facename, al_textsize, al_fgcolor, al_bkcolor)
		next
end choose

end subroutine

public subroutine of_addignoredobject (graphicobject ago_object);/********************************************************************
   of_addignoredobject
   <DESC>	Don't replace the background color for special object </DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
		ago_object: the window/userobject/tab/control which's background color will not be replaced 
		with the appointed background color
   </ARGS>
   <USAGE> Suggest to use in the event "ue_addignoredcolorandobject" of the window </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	29/08/2011   N/A          ZSW001       First Version
   </HISTORY>
********************************************************************/

if pos(is_ignoredhandlelist, "," + string(handle(ago_object)) + ",") <= 0 then is_ignoredhandlelist += string(handle(ago_object)) + ","

end subroutine

on n_gui_style_service.create
call super::create
end on

on n_gui_style_service.destroy
call super::destroy
end on

