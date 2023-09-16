type migration_rapper =
  (module Rapper_helper.CONNECTION) -> (unit, Caqti_error.t) result Lwt.t
type t = { id : string; up : migration_rapper; down : migration_rapper; }

let make_migration ~id ~up ~down =
  { id; up; down; }

let migrations = []
