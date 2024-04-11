open Eio

let () =
  Eio_main.run (fun env ->
      Switch.run (fun sw ->
          let fiber2isDone = Semaphore.make 0 in
          Fiber.fork ~sw (fun () ->
              traceln "A";
              Semaphore.acquire fiber2isDone;
              traceln "C");
          Fiber.fork ~sw (fun () ->
              traceln "B";
              Semaphore.release fiber2isDone)))
