import Lean.Data.Json
import Lean.Data.Json.Basic

open Lean (Json)

structure Implementation where
  language: String
  name: String
  homepage: String
  issues: String
  source: String
  dialects: Array String
  deriving Lean.FromJson, Lean.ToJson

structure command where
  cmd : String
  case: Json
  seq : Json
  deriving Lean.FromJson, Lean.ToJson

structure StartResponse where
  version: Nat
  implementation: Implementation
  deriving Lean.FromJson, Lean.ToJson

structure DialectResponse where
  ok: Bool
  deriving Lean.FromJson, Lean.ToJson

structure ErrorResponse where
  error: String
  deriving Lean.FromJson, Lean.ToJson

structure Schema where
  Schema :String
  deriving Lean.FromJson, Lean.ToJson

structure RunResponse where
  seq : Json
  results : List Json
  deriving Lean.FromJson, Lean.ToJson

structure RunCommand where
  case: Schema
  deriving Lean.FromJson, Lean.ToJson

structure ValidatorResponse where
  valid : Bool
  deriving Lean.FromJson,Lean.ToJson
