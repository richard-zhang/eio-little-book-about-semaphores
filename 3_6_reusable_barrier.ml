open Eio

let guard mutex action =
  Semaphore.acquire mutex;
  action ();
  Semaphore.release mutex

module Barrier = struct
  type t = {
    total_thread : int;
    mutable current_count : int;
    mutex : Semaphore.t;
    turnstile1 : Semaphore.t;
    turnstile2 : Semaphore.t;
  }

  let make n =
    let mutex = Semaphore.make 1 in
    let turnstile1 = Semaphore.make 0 in
    let turnstile2 = Semaphore.make 0 in
    let total_thread = n in
    let current_count = 0 in
    { mutex; turnstile1; turnstile2; total_thread; current_count }

  let phase1 t =
    guard t.mutex (fun () ->
        t.current_count <- t.current_count + 1;
        if t.current_count = t.total_thread then
          for _ = 1 to t.total_thread do
            Semaphore.release t.turnstile1
          done);
    Semaphore.acquire t.turnstile1

  let phase2 t =
    guard t.mutex (fun () ->
        t.current_count <- t.current_count - 1;
        if t.current_count = 0 then
          for _ = 1 to t.total_thread do
            Semaphore.release t.turnstile2
          done);
    Semaphore.acquire t.turnstile2

  let wait t =
    phase1 t;
    phase2 t
end

let () =
  Eio_main.run (fun _ ->
      let num_thread = 5 in
      let barrier = Barrier.make num_thread in
      let action id () =
        traceln "%d a" id;
        Barrier.wait barrier;
        traceln "%d b" id;
        Barrier.wait barrier;
        traceln "%d c" id
      in
      Fiber.all (List.init num_thread action))
