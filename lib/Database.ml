open Lwt.Syntax

(** Specific exception that will kill the program,
    basically this is only to be used when the migrations
    are being run. *)
exception Query_failed of string

(** The database URI sourced from ["APPLICATION_DB"] *)
let db_uri =
  match Sys.getenv_opt "APPLICATION_DB" with
  (* Kill the program if we can't connect to the database. *)
  | None -> failwith "APPLICATION_DB must be set before the application can be run."
  | Some s -> s

(** Postgres connection pool.
    Note you should use one of the [dispatch] functions instead of the pool directly. *)
let pool =
  match Caqti_lwt.connect_pool ~max_size:5 (Uri.of_string db_uri) with
  | Ok pool -> pool
  | Error e -> failwith (Caqti_error.show e)

(** Please use [dispatch] instead,
    unless you really know what you're doing.
    Even then, this is a VERY DANGEROUS function.*)
let dispatch_unsafe f =
  let* result = Caqti_lwt.Pool.use f pool in
  match result with
  | Ok t -> Lwt.return t
  | Error e -> Lwt.fail (Query_failed (Caqti_error.show e))

(** Dispatch a query against the Postgres connection pool *)
let dispatch f =
  Caqti_lwt.Pool.use f pool

(** Dispatch a query [q] and a function to apply to its result [~f] *)
let dispatch_func ~f q =
  let open Lwt_result.Infix in
  Caqti_lwt.Pool.use q pool >|= f
