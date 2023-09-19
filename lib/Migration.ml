type migration_rapper =
  (module Rapper_helper.CONNECTION) -> (unit, Caqti_error.t) result Lwt.t
type t = { id : string
         ; author : string
         ; up : migration_rapper
         ; down : migration_rapper }

let make_migration ~id ~author ~up ~down =
  { id; author; up; down }

(** Migrations to be run by a PostgreSQL runner via Caqti.

    Example:
    let migrations = \[
        make_migration
            ~id:"Example migration"
            ~author:"cooldude23"
            ~up:\[%rapper
                    execute
                    {sql|
                    CREATE TABLE IF NOT EXISTS example (
                    pkey_id INTEGER AUTOINCREMENT PRIMARY KEY,
                    name VARCHAR(255)
                    )
                    |sql}
            \]
            ~down:\[%rapper
                        execute
                        {sql|DROP TABLE IF EXISTS example|sql}
            \]
        ; make_migration ...            
    \]
 *)
let migrations = []
