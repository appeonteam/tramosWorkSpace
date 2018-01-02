$PBExportHeader$mt_w_frame.srw
forward
global type mt_w_frame from mt_w_master
end type
type mdi_1 from mdiclient within mt_w_frame
end type
end forward

global type mt_w_frame from mt_w_master
integer height = 1484
string menuname = "mt_m_frame"
windowtype windowtype = mdihelp!
mdi_1 mdi_1
end type
global mt_w_frame mt_w_frame

on mt_w_frame.create
int iCurrent
call super::create
if this.MenuName = "mt_m_frame" then this.MenuID = create mt_m_frame
this.mdi_1=create mdi_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mdi_1
end on

on mt_w_frame.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

type mdi_1 from mdiclient within mt_w_frame
long BackColor=12632256
end type

