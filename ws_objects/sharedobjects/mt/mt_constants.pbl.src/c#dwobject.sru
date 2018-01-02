$PBExportHeader$c#dwobject.sru
$PBExportComments$Datawindow Object Type Constants
forward
global type c#dwobject from nonvisualobject
end type
end forward

global type c#dwobject from nonvisualobject
end type
global c#dwobject c#dwobject

type variables
//object types
CONSTANT string DATAWINDOW = "datawindow"
CONSTANT string BITMAP = "bitmap"
CONSTANT string BUTTON = "button"
CONSTANT string COLUMN = "column"
CONSTANT string COMPUTE = "compute"
CONSTANT string GRAPH = "graph"
CONSTANT string GROUPBOX = "groupbox"
CONSTANT string LINE = "line"
CONSTANT string OLE = "ole"
CONSTANT string OVAL = "ellipse"
CONSTANT string RECTANGLE = "rectangle"
CONSTANT string REPORT = "report"
CONSTANT string ROUNDRECTANGLE = "roundrectangle"
CONSTANT string TABLEBLOB = "tableblob"
CONSTANT string TEXT = "text"
end variables

on c#dwobject.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#dwobject.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

