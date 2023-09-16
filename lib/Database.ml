open Lwt.Syntax

exception Query_failed of string

let db_uri =
  match Sys.getenv_opt "APPLICATION_DB" with
  | None -> failwith "APPLICATION_DB must be set before the application can be run."
  | Some s -> s

let pool =
  match Caqti_lwt.connect_pool ~max_size:5 (Uri,of_string db_uri) with
  | Ok pool -> pool
  | Error e -> failwith (Caqti_error.show e)

let dispatch_die f =
  let* result = Caqti_lwt.Pool.use f pool in
  match result with
  | Ok t -> Lwt.return t
  | Error e -> Lwt.fail (Query_failed (Caqti_error.show e))

let dispatch f =
  Caqti_lwt.Pool.use f pool

let dispatch_func ~f q =
  let open Lwt_result.Infix in
  Caqti_lwt.Pool.use q pool >|= f
