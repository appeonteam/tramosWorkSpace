$PBExportHeader$c#datatype.sru
$PBExportComments$Native Data Type Constants
forward
global type c#datatype from nonvisualobject
end type
end forward

global type c#datatype from nonvisualobject
end type
global c#datatype c#datatype

type variables
//data types
Constant string ANY = "any"
Constant string BLOB = "blob"
Constant string BOOLEAN = "boolean"
Constant string CHAR = "char"
Constant string CHARACTER = "character"
Constant string DATE = "date"
Constant string DATETIME = "datetime"
Constant string DEC = "dec"
Constant string DECIMAL = "decimal"
Constant string DOUBLE = "double"
Constant string INT = "int"
Constant string INTEGER = "integer"
Constant string LONG = "long"
Constant string LONGLONG = "longlong"
Constant string NUMBER = "number"
Constant string REAL = "real"
Constant string STRING = "string"
Constant string TIME = "time"
Constant string UINT = "uint"
Constant string UNSIGNEDINT = "unsignedint"
Constant string UNSIGNEDINTEGER = "unsignedinteger"
Constant string ULONG = "ulong"
Constant string UNSIGNEDLONG = "unsignedlong"
end variables

on c#datatype.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#datatype.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

