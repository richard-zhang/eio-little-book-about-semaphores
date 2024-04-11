let () =
  Eio_posix.run (fun env ->
      Eio.Flow.copy_string "Hello, World\n" (Eio.Stdenv.stdout env))
