open Application

let main () =
  let module D = Dream in
  D.run
  @@ D.logger
  @@ D.set_secret (D.to_base64url (D.random 32))
  @@ D.cookie_sessions
  @@ D.router
       [ D.get "/" fun _req -> D.html ~status:`OK "Foo Bar" ]

type migration_rapper =
  unit -> (module Rapper_helper.CONNECTION) -> (unit, Caqti_error.t) result Lwt.t
type migration = { id : string; up : migration_rapper; down : migration_rapper; }

let make_migration ~id ~up ~down () =
  { id; up; down; }
;;


let migrations = []

let () =
  
