module Semaphore = Semaphore.Counting

let follower lq fq i () =
  Semaphore.release fq;
  Semaphore.acquire lq;
  Printf.printf "follower %d\n" i

let leader lq fq i () =
  Semaphore.release lq;
  Semaphore.acquire fq;
  Printf.printf "leader %d\n" i

let () =
  let leaderQueue = Semaphore.make 0 in
  let followerQueue = Semaphore.make 0 in
  let pool = Domainslib.Task.setup_pool ~name:"hello" ~num_domains:12 () in
  let task () =
    let leader_promises =
      List.init 6 (fun i ->
          Domainslib.Task.async pool (leader leaderQueue followerQueue i))
    in
    let follower_promises =
      List.init 6 (fun i ->
          Domainslib.Task.async pool (follower leaderQueue followerQueue i))
    in
    List.iter (Domainslib.Task.await pool) (leader_promises @ follower_promises)
  in
  Domainslib.Task.run pool task;
  Domainslib.Task.teardown_pool pool
