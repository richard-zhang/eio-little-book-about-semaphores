(*
  Thread A:
  statement a1
  statement a2   

  Thread B:
  statement b1
  statement b2
*)

open Eio

let () =
  Eio_main.run (fun env ->
      Switch.run (fun sw ->
          let a1IsDone = Semaphore.make 0 in
          let b1IsDone = Semaphore.make 0 in
          Fiber.fork ~sw (fun () ->
              traceln "A1";
              Semaphore.release a1IsDone;
              Semaphore.acquire b1IsDone;
              traceln "A2");
          Fiber.fork ~sw (fun () ->
              traceln "B1";
              Semaphore.release b1IsDone;
              Semaphore.acquire a1IsDone;
              traceln "B2")))
