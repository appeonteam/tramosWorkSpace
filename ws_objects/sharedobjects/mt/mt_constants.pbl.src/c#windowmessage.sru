$PBExportHeader$c#windowmessage.sru
forward
global type c#windowmessage from nonvisualobject
end type
end forward

global type c#windowmessage from nonvisualobject
end type
global c#windowmessage c#windowmessage

type variables
CONSTANT long WM_NULL                         = 0//0x0000
CONSTANT long WM_CREATE                       = 1//0x0001
CONSTANT long WM_DESTROY                      = 2//0x0002
CONSTANT long WM_MOVE                         = 3//0x0003
CONSTANT long WM_SIZE                         = 5//0x0005

CONSTANT long WM_ACTIVATE                     = 6//0x0006
CONSTANT long WM_SETFOCUS                     = 7//0x0007
CONSTANT long WM_KILLFOCUS                    = 8//0x0008
CONSTANT long WM_ENABLE                       = 10//0x000A
CONSTANT long WM_SETREDRAW                    = 11//0x000B
CONSTANT long WM_SETTEXT                      = 12//0x000C
CONSTANT long WM_GETTEXT                      = 13//0x000D
CONSTANT long WM_GETTEXTLENGTH                = 14//0x000E
CONSTANT long WM_PAINT                        = 15//0x000F
CONSTANT long WM_CLOSE                        = 16//0x0010
CONSTANT long WM_QUERYENDSESSION              = 17//0x0011
CONSTANT long WM_QUERYOPEN                    = 19//0x0013
CONSTANT long WM_ENDSESSION                   = 22//0x0016
CONSTANT long WM_QUIT                         = 18//0x0012
CONSTANT long WM_ERASEBKGND                   = 20//0x0014
CONSTANT long WM_SYSCOLORCHANGE               = 21//0x0015
CONSTANT long WM_SHOWWINDOW                   = 24//0x0018
CONSTANT long WM_WININICHANGE                 = 26//0x001A
CONSTANT long WM_SETTINGCHANGE                = WM_WININICHANGE
CONSTANT long WM_DEVMODECHANGE                = 27//0x001B
CONSTANT long WM_ACTIVATEAPP                  = 28//0x001C
CONSTANT long WM_FONTCHANGE                   = 29//0x001D
CONSTANT long WM_TIMECHANGE                   = 30//0x001E
CONSTANT long WM_CANCELMODE                   = 31//0x001F
CONSTANT long WM_SETCURSOR                    = 32//0x0020
CONSTANT long WM_MOUSEACTIVATE                = 33//0x0021
CONSTANT long WM_CHILDACTIVATE                = 34//0x0022
CONSTANT long WM_QUEUESYNC                    = 35//0x0023

CONSTANT long WM_GETMINMAXINFO                = 36//0x0024
CONSTANT long WM_PAINTICON                    = 38//0x0026
CONSTANT long WM_ICONERASEBKGND               = 39//0x0027
CONSTANT long WM_NEXTDLGCTL                   = 40//0x0028
CONSTANT long WM_SPOOLERSTATUS                = 42//0x002A
CONSTANT long WM_DRAWITEM                     = 43//0x002B
CONSTANT long WM_MEASUREITEM                  = 44//0x002C
CONSTANT long WM_DELETEITEM                   = 45//0x002D
CONSTANT long WM_VKEYTOITEM                   = 46//0x002E
CONSTANT long WM_CHARTOITEM                   = 47//0x002F
CONSTANT long WM_SETFONT                      = 48//0x0030
CONSTANT long WM_GETFONT                      = 49//0x0031
CONSTANT long WM_SETHOTKEY                    = 50//0x0032
CONSTANT long WM_GETHOTKEY                    = 51//0x0033
CONSTANT long WM_QUERYDRAGICON                = 55//0x0037
CONSTANT long WM_COMPAREITEM                  = 57//0x0039
CONSTANT long WM_GETOBJECT                    = 61//0x003D
CONSTANT long WM_COMPACTING                   = 65//0x0041
CONSTANT long WM_COMMNOTIFY                   = 68//0x0044  /* no longer suported */
CONSTANT long WM_WINDOWPOSCHANGING            = 70//0x0046
CONSTANT long WM_WINDOWPOSCHANGED             = 71//0x0047

CONSTANT long WM_POWER                        = 72//0x0048
CONSTANT long WM_COPYDATA                     = 74//0x004A
CONSTANT long WM_CANCELJOURNAL                = 75//0x004B
CONSTANT long WM_NOTIFY                       = 78//0x004E
CONSTANT long WM_INPUTLANGCHANGEREQUEST       = 80//0x0050
CONSTANT long WM_INPUTLANGCHANGE              = 81//0x0051
CONSTANT long WM_TCARD                        = 82//0x0052
CONSTANT long WM_HELP                         = 83//0x0053
CONSTANT long WM_USERCHANGED                  = 84//0x0054
CONSTANT long WM_NOTIFYFORMAT                 = 85//0x0055
CONSTANT long WM_CONTEXTMENU                  = 123//0x007B
CONSTANT long WM_STYLECHANGING                = 124//0x007C
CONSTANT long WM_STYLECHANGED                 = 125//0x007D
CONSTANT long WM_DISPLAYCHANGE                = 126//0x007E
CONSTANT long WM_GETICON                      = 127//0x007F
CONSTANT long WM_SETICON                      = 128//0x0080
CONSTANT long WM_NCCREATE                     = 129//0x0081
CONSTANT long WM_NCDESTROY                    = 130//0x0082
CONSTANT long WM_NCCALCSIZE                   = 131//0x0083
CONSTANT long WM_NCHITTEST                    = 132//0x0084
CONSTANT long WM_NCPAINT                      = 133//0x0085
CONSTANT long WM_NCACTIVATE                   = 134//0x0086
CONSTANT long WM_GETDLGCODE                   = 135//0x0087
CONSTANT long WM_SYNCPAINT                    = 136//0x0088
CONSTANT long WM_NCMOUSEMOVE                  = 160//0x00A0
CONSTANT long WM_NCLBUTTONDOWN                = 161//0x00A1
CONSTANT long WM_NCLBUTTONUP                  = 162//0x00A2
CONSTANT long WM_NCLBUTTONDBLCLK              = 163//0x00A3
CONSTANT long WM_NCRBUTTONDOWN                = 164//0x00A4
CONSTANT long WM_NCRBUTTONUP                  = 165//0x00A5
CONSTANT long WM_NCRBUTTONDBLCLK              = 166//0x00A6
CONSTANT long WM_NCMBUTTONDOWN                = 167//0x00A7
CONSTANT long WM_NCMBUTTONUP                  = 168//0x00A8
CONSTANT long WM_NCMBUTTONDBLCLK              = 169//0x00A9
CONSTANT long WM_NCXBUTTONDOWN                = 171//0x00AB
CONSTANT long WM_NCXBUTTONUP                  = 172//0x00AC
CONSTANT long WM_NCXBUTTONDBLCLK              = 173//0x00AD
CONSTANT long WM_INPUT                        = 255//0x00FF
CONSTANT long WM_KEYFIRST                     = 256//0x0100
CONSTANT long WM_KEYDOWN                      = 256//0x0100
CONSTANT long WM_KEYUP                        = 257//0x0101
CONSTANT long WM_CHAR                         = 258//0x0102
CONSTANT long WM_DEADCHAR                     = 259//0x0103
CONSTANT long WM_SYSKEYDOWN                   = 260//0x0104
CONSTANT long WM_SYSKEYUP                     = 261//0x0105
CONSTANT long WM_SYSCHAR                      = 262//0x0106
CONSTANT long WM_SYSDEADCHAR                  = 263//0x0107
CONSTANT long WM_UNICHAR                      = 265//0x0109
CONSTANT long WM_KEYLAST                      = 265//0x0109
CONSTANT long UNICODE_NOCHAR                  = 65535//0xFFFF
//CONSTANT long WM_KEYLAST                      = 264//0x0108
CONSTANT long WM_IME_STARTCOMPOSITION         = 269//0x010D
CONSTANT long WM_IME_ENDCOMPOSITION           = 270//0x010E
CONSTANT long WM_IME_COMPOSITION              = 271//0x010F
CONSTANT long WM_IME_KEYLAST                  = 271//0x010F

CONSTANT long WM_INITDIALOG                   = 272//0x0110
CONSTANT long WM_COMMAND                      = 273//0x0111
CONSTANT long WM_SYSCOMMAND                   = 274//0x0112
CONSTANT long WM_TIMER                        = 275//0x0113
CONSTANT long WM_HSCROLL                      = 276//0x0114
CONSTANT long WM_VSCROLL                      = 277//0x0115
CONSTANT long WM_INITMENU                     = 278//0x0116
CONSTANT long WM_INITMENUPOPUP                = 279//0x0117
CONSTANT long WM_MENUSELECT                   = 287//0x011F
CONSTANT long WM_MENUCHAR                     = 288//0x0120
CONSTANT long WM_ENTERIDLE                    = 289//0x0121
CONSTANT long WM_MENURBUTTONUP                = 290//0x0122
CONSTANT long WM_MENUDRAG                     = 291//0x0123
CONSTANT long WM_MENUGETOBJECT                = 292//0x0124
CONSTANT long WM_UNINITMENUPOPUP              = 293//0x0125
CONSTANT long WM_MENUCOMMAND                  = 294//0x0126

CONSTANT long WM_CHANGEUISTATE                = 295//0x0127
CONSTANT long WM_UPDATEUISTATE                = 296//0x0128
CONSTANT long WM_QUERYUISTATE                 = 297//0x0129
CONSTANT long WM_CTLCOLORMSGBOX               = 306//0x0132
CONSTANT long WM_CTLCOLOREDIT                 = 307//0x0133
CONSTANT long WM_CTLCOLORLISTBOX              = 308//0x0134
CONSTANT long WM_CTLCOLORBTN                  = 309//0x0135
CONSTANT long WM_CTLCOLORDLG                  = 310//0x0136
CONSTANT long WM_CTLCOLORSCROLLBAR            = 311//0x0137
CONSTANT long WM_CTLCOLORSTATIC               = 312//0x0138
CONSTANT long MN_GETHMENU                     = 481//0x01E1

CONSTANT long WM_MOUSEFIRST                   = 512//0x0200
CONSTANT long WM_MOUSEMOVE                    = 512//0x0200
CONSTANT long WM_LBUTTONDOWN                  = 513//0x0201
CONSTANT long WM_LBUTTONUP                    = 514//0x0202
CONSTANT long WM_LBUTTONDBLCLK                = 515//0x0203
CONSTANT long WM_RBUTTONDOWN                  = 516//0x0204
CONSTANT long WM_RBUTTONUP                    = 517//0x0205
CONSTANT long WM_RBUTTONDBLCLK                = 518//0x0206
CONSTANT long WM_MBUTTONDOWN                  = 519//0x0207
CONSTANT long WM_MBUTTONUP                    = 520//0x0208
CONSTANT long WM_MBUTTONDBLCLK                = 521//0x0209
CONSTANT long WM_MOUSEWHEEL                   = 522//0x020A
CONSTANT long WM_XBUTTONDOWN                  = 523//0x020B
CONSTANT long WM_XBUTTONUP                    = 524//0x020C
CONSTANT long WM_XBUTTONDBLCLK                = 525//0x020D
CONSTANT long WM_MOUSELAST                    = 522//0x020A

CONSTANT long WM_PARENTNOTIFY                 = 528//0x0210
CONSTANT long WM_ENTERMENULOOP                = 529//0x0211
CONSTANT long WM_EXITMENULOOP                 = 530//0x0212

CONSTANT long WM_NEXTMENU                     = 531//0x0213
CONSTANT long WM_SIZING                       = 532//0x0214
CONSTANT long WM_CAPTURECHANGED               = 533//0x0215
CONSTANT long WM_MOVING                       = 534//0x0216
CONSTANT long WM_POWERBROADCAST               = 536//0x0218
CONSTANT long WM_DEVICECHANGE                 = 537//0x0219
CONSTANT long WM_MDICREATE                    = 544//0x0220
CONSTANT long WM_MDIDESTROY                   = 545//0x0221
CONSTANT long WM_MDIACTIVATE                  = 546//0x0222
CONSTANT long WM_MDIRESTORE                   = 547//0x0223
CONSTANT long WM_MDINEXT                      = 548//0x0224
CONSTANT long WM_MDIMAXIMIZE                  = 549//0x0225
CONSTANT long WM_MDITILE                      = 550//0x0226
CONSTANT long WM_MDICASCADE                   = 551//0x0227
CONSTANT long WM_MDIICONARRANGE               = 552//0x0228
CONSTANT long WM_MDIGETACTIVE                 = 553//0x0229


CONSTANT long WM_MDISETMENU                   = 560//0x0230
CONSTANT long WM_ENTERSIZEMOVE                = 561//0x0231
CONSTANT long WM_EXITSIZEMOVE                 = 562//0x0232
CONSTANT long WM_DROPFILES                    = 563//0x0233
CONSTANT long WM_MDIREFRESHMENU               = 564//0x0234


CONSTANT long WM_IME_SETCONTEXT               = 641//0x0281
CONSTANT long WM_IME_NOTIFY                   = 642//0x0282
CONSTANT long WM_IME_CONTROL                  = 643//0x0283
CONSTANT long WM_IME_COMPOSITIONFULL          = 644//0x0284
CONSTANT long WM_IME_SELECT                   = 645//0x0285
CONSTANT long WM_IME_CHAR                     = 646//0x0286
CONSTANT long WM_IME_REQUEST                  = 648//0x0288
CONSTANT long WM_IME_KEYDOWN                  = 656//0x0290
CONSTANT long WM_IME_KEYUP                    = 657//0x0291
CONSTANT long WM_MOUSEHOVER                   = 673//0x02A1
CONSTANT long WM_MOUSELEAVE                   = 675//0x02A3
CONSTANT long WM_NCMOUSEHOVER                 = 672//0x02A0
CONSTANT long WM_NCMOUSELEAVE                 = 674//0x02A2

CONSTANT long WM_WTSSESSION_CHANGE            = 689//0x02B1

CONSTANT long WM_TABLET_FIRST                 = 704//0x02c0
CONSTANT long WM_TABLET_LAST                  = 735//0x02df
CONSTANT long WM_CUT                          = 768//0x0300
CONSTANT long WM_COPY                         = 769//0x0301
CONSTANT long WM_PASTE                        = 770//0x0302
CONSTANT long WM_CLEAR                        = 771//0x0303
CONSTANT long WM_UNDO                         = 772//0x0304
CONSTANT long WM_RENDERFORMAT                 = 773//0x0305
CONSTANT long WM_RENDERALLFORMATS             = 774//0x0306
CONSTANT long WM_DESTROYCLIPBOARD             = 775//0x0307
CONSTANT long WM_DRAWCLIPBOARD                = 776//0x0308
CONSTANT long WM_PAINTCLIPBOARD               = 777//0x0309
CONSTANT long WM_VSCROLLCLIPBOARD             = 778//0x030A
CONSTANT long WM_SIZECLIPBOARD                = 779//0x030B
CONSTANT long WM_ASKCBFORMATNAME              = 780//0x030C
CONSTANT long WM_CHANGECBCHAIN                = 781//0x030D
CONSTANT long WM_HSCROLLCLIPBOARD             = 782//0x030E
CONSTANT long WM_QUERYNEWPALETTE              = 783//0x030F
CONSTANT long WM_PALETTEISCHANGING            = 784//0x0310
CONSTANT long WM_PALETTECHANGED               = 785//0x0311
CONSTANT long WM_HOTKEY                       = 786//0x0312

CONSTANT long WM_PRINT                        = 791//0x0317
CONSTANT long WM_PRINTCLIENT                  = 792//0x0318
CONSTANT long WM_APPCOMMAND                   = 793//0x0319
CONSTANT long WM_THEMECHANGED                 = 794//0x031A
CONSTANT long WM_HANDHELDFIRST                = 856//0x0358
CONSTANT long WM_HANDHELDLAST                 = 863//0x035F

CONSTANT long WM_AFXFIRST                     = 864//0x0360
CONSTANT long WM_AFXLAST                      = 895//0x037F

CONSTANT long WM_PENWINFIRST                  = 896//0x0380
CONSTANT long WM_PENWINLAST                   = 911//0x038F

CONSTANT long WM_APP                          = 32768//0x8000

end variables

on c#windowmessage.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#windowmessage.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

