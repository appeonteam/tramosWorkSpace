$PBExportHeader$c#basecontrol.sru
forward
global type c#basecontrol from nonvisualobject
end type
end forward

global type c#basecontrol from nonvisualobject
end type
global c#basecontrol c#basecontrol

type variables
//Base Controls
constant string CommandButton = "commandbuttoncontrol"
constant string CheckBox = "checkboxcontrol"
constant string DropDownListBox = "dropdownlistboxcontrol"
constant string DropDownPictureListBox = "dropdownpicturelistboxcontrol"
constant string Datawindow = "datawindowcontrol"
constant string DatawindowForm = "datawindowformcontrol"
constant string EditMask = "editmaskcontrol"
constant string Graph = "graphcontrol"
constant string GroupBox = "groupboxcontrol"
constant string HorizontalProgressBar = "horizontalprogressbarcontrol"
constant string HorizontalScrollBar = "horizontalscrollbarcontrol"
constant string HorizontalTrackBar = "horizontaltrackbarcontrol"
constant string ListBox = "listboxcontrol"
constant string Icon = "iconcontrol"
constant string Listview = "listviewcontrol"
constant string MultiLineEdit = "multilineeditcontrol"
constant string Picture = "picturecontrol"
constant string PictureButton = "picturebuttoncontrol"
constant string PictureHyperlink = "picturehyperlinkcontrol"
constant string PictureListbox = "picturelistboxcontrol"
constant string RadioButton = "radiobuttoncontrol"
constant string RichTextEdit = "richtexteditcontrol"
constant string StaticHyperLink = "statichyperlinlcontrol"
constant string SingleLineEdit = "singlelineeditcontrol"
constant string StaticText = "statictextcontrol"
constant string Tab = "tabcontrol"
constant string Treeview = "treeviewcontrol"
constant string UserObject = "userobjectbase"
constant string VerticalProgressBar = "verticalprogressbarcontrol"
constant string VerticalScrollBar = "verticalscrollbarcontrol"
constant string VerticalTrackBar = "verticaltrackbarcontrol"
constant string Window = "windowmain"
end variables

on c#basecontrol.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#basecontrol.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

