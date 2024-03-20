import BowtieJsonschema.Helpers
import Lean
open Lean (Json)


def validateType (schema: Json) (data : Except String Json): Bool := Id.run do
  let mut Valid := false
  -- Keeping this as of now to skip array in types

  -- if type.getArr?.toBool then
    -- let arr := (type.getArr?).toOption.get!
    -- for types in arr do
    --   Valid := matchType types.compress data

  -- else
  let type := ((schema.getObjVal? "type").toOption.get!.getStr?.toOption.get!)

  Valid := matchType type data

  return Valid

def validate (jsonObject : Json) (schema : Json): Bool  := Id.run do
  if schema.isNull then
    return false

  let mut VALID : Bool := true

  if (schema.getObjVal? "type").isOk then

    VALID := validateType schema (Json.parse jsonObject.compress)

  return VALID
