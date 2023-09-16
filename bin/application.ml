open Application (* Import all of the functions in the Application module *)

(* Web endpoint declaration *)
let main () =
  let open Dream in (* Locally import all of the Dream web service functions *)
  run
  @@ logger
  @@ set_secret (to_base64url (random 32))
  @@ cookie_sessions
  @@ router
       [ get "/" ( fun _req -> html ~status:`OK "Foo Bar" ) ]

(* Execute the application on the main-thread, migrating all of our DB migrations first. *)
let () =
  let open Lwt.Infix in
  Lwt_main.run
    (Lwt_list.iter_s
       (fun migration -> Database.dispatch_unsafe migration.Migration.up)
       Migration.migrations
     >>= fun () -> Lwt.return @@ main () )
