import Lake
open Lake DSL

package «bowtie-jsonschema» where
  -- add package configuration options here

lean_lib «BowtieJsonschema» where
  -- add library configuration options here

@[default_target]
lean_exe «bowtie-jsonschema» where
  root := `Main
