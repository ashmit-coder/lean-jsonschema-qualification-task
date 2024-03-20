import BowtieJsonschema.Definations
import Lean
open Lean (Json)

-- Helper functions for handling Json data

def parseCommand (s: String) : Except String command := do
  let j : Json <- Json.parse s
  Lean.fromJson? j

def returnSchema (request:Json):Json :=
  match (request.getObjVal? "schema").toOption with
    | none => Json.null
    | some schema => schema

def returnTests (request:Json):Json:=
  match (request.getObjVal? "tests").toOption with
    | none  => (Json.parse "error").toOption.get!
    | some tests => tests


-- Helpers functions to find the data type of a particular key in Json Object

def isBool (jsonData : Except String Json)  : Bool :=
  jsonData.toOption.get!.getBool?.toBool

def isString (jsonData : Except String Json)  : Bool :=
  jsonData.toOption.get!.getStr?.toBool

def isInt (jsonData : Except String Json)  : Bool :=
  jsonData.toOption.get!.getInt?.toBool

def isNum (jsonData : Except String Json)  : Bool :=
  jsonData.toOption.get!.getNum?.toBool

def isObj (jsonData : Except String Json)   : Bool :=
  jsonData.toOption.get!.getObj?.toBool

def isArr (jsonData : Except String Json)  : Bool :=
  jsonData.toOption.get!.getArr?.toBool

def isNull (jsonData : Except String Json)  : Bool :=
  jsonData.toOption.get!.isNull


-- Matching String data from type keyword
def matchType (type: String) (data : Except String Json) :=
  match type with
  | "string" => isString data
  | "integer" => isInt data
  | "number" => isNum data
  | "boolean" => isBool data
  | "array" => isArr data
  | "object" => isObj data
  | "null" => isNull data
  | _ => true
