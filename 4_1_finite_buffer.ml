module Semaphore = Semaphore.Counting

module Buffer = struct
  type t = {
    mutex : Semaphore.t;
    canConsume : Semaphore.t;
    canProduce : Semaphore.t;
    mutable queue : int list;
  }

  let make capacity =
    let mutex = Semaphore.make 1 in
    (*
       block until there is an item in the queue
    *)
    let canConsume = Semaphore.make 0 in
    let canProduce = Semaphore.make capacity in
    let queue = [] in
    { mutex; canConsume; queue; canProduce }

  let add t item =
    Semaphore.acquire t.canProduce;
    Semaphore.acquire t.mutex;
    let current_size = List.length t.queue in
    t.queue <- item :: t.queue;
    Semaphore.release t.mutex;
    Semaphore.release t.canConsume

  let get t =
    Semaphore.acquire t.canConsume;
    Semaphore.acquire t.mutex;
    let work_item = List.hd t.queue in
    Semaphore.release t.mutex;
    Semaphore.release t.canProduce;
    work_item

  (*
    classic blocking on a semaphore while holding a mutex
    consumer will never able to write to queue    
  *)
  let deadlock_get t =
    Semaphore.acquire t.mutex;
    Semaphore.acquire t.canConsume;
    let work_item = List.hd t.queue in
    t.queue <- List.tl t.queue;
    Semaphore.release t.mutex;
    work_item
end

let () =
  let pool = Domainslib.Task.setup_pool ~name:"hello" ~num_domains:12 () in
  let task () = Printf.printf "Hello, World" in
  Domainslib.Task.run pool task;
  Domainslib.Task.teardown_pool pool
