
import Lean
import Lean.Data.Json
-- import Lean.Elab
-- import Lean.Data.HashMap
open Lean.Data Lean

structure Refs where
  _refs : String
deriving Lean.ToJson ,Lean.FromJson, Repr

structure IHOP where
  oneof : List Refs
deriving Lean.ToJson, Lean.FromJson, Repr


def data: IHOP :=
  {
    oneof :=
        [
        {_refs := "tag:bowtie.report,2023:ihop:command:start"},
        {_refs := "tag:bowtie.report,2023:ihop:command:dialect"},
        {_refs := "tag:bowtie.report,2023:ihop:command:run"},
        {_refs := "tag:bowtie.report,2023:ihop:command:stop"}
        ]
  }


def start   :=
  Lean.Json.parse "{}"

def stop   :=
  Lean.Json.parse "{}"


def main : IO Unit := do
  let error ← IO.getStderr
  let input ← IO.getStdin
  let out ← IO.getStdout
  let mut working := true

  while working do
    let line ← input.getLine
    let data := Lean.Json.parse line

    match data.toOption with
    | none  => IO.throwServerError "Invalid"
    | some parsed => do
      let cmd := parsed.getObjVal? "cmd"

      if cmd.toOption.get!.compress = "\"start\""  then
        error.putStr "STARTING"
        working := true
        out.putStr s!"{start.toOption.get!.compress}\n"
        out.flush
      else if cmd.toOption.get!.compress = "\"stop\"" then
        error.putStr "STOPPING"
        out.putStr s!"{stop.toOption.get!.compress}\n"
        out.flush

      else
        IO.throwServerError "Error parsing"
        working := false
        return
