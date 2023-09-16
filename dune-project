(lang dune 3.4)

(generate_opam_files true)

(package
 (name application)
 (allow_empty)
 (depends
   ocaml
   dune
   dream
   caqti
   caqti-lwt
   caqti-drive-postgresql
   yojson
   ppx_deriving_yojson
   ppx_rapper_lwt
   uuidm
   ptime
   ptime.clock.os))
