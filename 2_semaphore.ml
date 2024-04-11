open Eio

let () =
  Eio_main.run (fun env ->
      Switch.run (fun sw ->
          let sema = Semaphore.make 1 in
          Semaphore.acquire sema;
          Fiber.fork ~sw (fun () ->
              traceln "A";
              Fiber.yield ();
              Semaphore.acquire sema;
              traceln "D");
          Fiber.fork ~sw (fun () ->
              Semaphore.acquire sema;
              traceln "C";
              Semaphore.release sema);
          traceln "B";
          Semaphore.release sema))
