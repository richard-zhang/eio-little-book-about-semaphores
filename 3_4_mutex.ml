open Eio

let () =
  Eio_main.run (fun env ->
      let token = Semaphore.make 1 in
      let count = ref 0 in
      Fiber.both
        (fun _ ->
          Semaphore.acquire token;
          count := !count + 1;
          Semaphore.release token)
        (fun _ ->
          Semaphore.acquire token;
          count := !count + 1;
          Semaphore.release token);
      traceln "%d" !count)
