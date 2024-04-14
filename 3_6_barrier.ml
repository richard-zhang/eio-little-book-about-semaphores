open Eio

let num_fiber = 5

let () =
  Eio_main.run (fun env ->
      let count, total_thread, turnstile1, turnstile2, mutex =
        (ref 0, num_fiber, Semaphore.make 0, Semaphore.make 1, Semaphore.make 1)
      in
      let action id () =
        traceln "%d a" id;
        Semaphore.acquire mutex;
        count := !count + 1;
        if !count = total_thread then (
          Semaphore.acquire turnstile2;
          Semaphore.release turnstile1);
        Semaphore.release mutex;
        Semaphore.acquire turnstile1;
        Semaphore.release turnstile1;
        traceln "%d b" id;
        Semaphore.acquire mutex;
        count := !count - 1;
        if !count = 0 then (
          Semaphore.acquire turnstile1;
          Semaphore.release turnstile2);
        Semaphore.release mutex;
        Semaphore.acquire turnstile2;
        Semaphore.release turnstile2;
        traceln "%d c" id
      in
      Fiber.all (List.init num_fiber action))
