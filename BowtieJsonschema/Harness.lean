import BowtieJsonschema.Validator

import Lean
open Lean (Json)

def start: String := Id.run do

  let res : StartResponse := {
      version := 1,
      implementation := {
        language := "lean",
        name := "jsonschema-lean",
        homepage := "https://github.com/CAIMEOX/json-schema-lean",
        issues := "https://github.com/CAIMEOX/json-schema-lean/issues",
        source := "https://github.com/CAIMEOX/json-schema-lean.git",
        dialects := #[
          "http://json-schema.org/draft-07/schema#",
          "http://json-schema.org/draft-06/schema#",
          "http://json-schema.org/draft-04/schema#"
        ]
      }
    }

  return (Json.compress (Lean.toJson res))

def run (request:Json) (seq : Json): String  := Id.run do
  let schema : Json := returnSchema request
  let tests  := returnTests request

  let test_arr:= (tests.getArr?).toOption.get!

  -- validate tests in json request
  let mut valid: List Json:= []

  for test in test_arr do
      let Instance := (test.getObjVal? "instance").toOption.get!
      let res := (Lean.toJson ({valid:= validate Instance schema : ValidatorResponse}))
      valid := valid.append [res]

  let response : RunResponse := {seq := seq, results := valid}

  return (Json.compress (Lean.toJson response))


def respondCommand (request : command): String :=
  match request with
  | { cmd := "start" , ..} => start
  | { cmd := "dialect", .. } => Lean.toJson ({ ok := false }:DialectResponse)|> Json.compress
  | { cmd := "stop", ..} => "stopping"
  | { cmd := "run", case , seq} => run case seq
  | { cmd := unknown,.. } =>
    let error: ErrorResponse := { error := s!"Unknown command: {unknown}" }
    Lean.toJson error |> Json.compress


def response (input: String) : String :=
  let command := parseCommand input.trim
  match command with
    | Except.ok json => respondCommand json
    | Except.error error => error


partial def ourhar : IO Unit := do
  let stdin ← IO.getStdin
  let stdout ← IO.getStdout
  let input ←  IO.FS.Stream.getLine stdin
  if input.trim == "" then
    pure ()
  else
    let res := response input
    if res.trim == "stopping"  then
    IO.FS.Stream.flush stdout
    pure ()
    else
    IO.FS.Stream.putStrLn stdout (res)
    IO.FS.Stream.flush stdout
    ourhar
