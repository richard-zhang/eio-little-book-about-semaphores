module Semaphore = Semaphore.Counting

let () =
  let num_leader_waiting = ref 0 in
  let num_follower_waiting = ref 0 in
  let leaderQueue = Semaphore.make 0 in
  let followerQueue = Semaphore.make 0 in
  let mutex = Semaphore.make 1 in
  let rendezvous = Semaphore.make 0 in
  let leader i () =
    Semaphore.acquire mutex;
    if !num_follower_waiting > 0 then (
      num_follower_waiting := !num_follower_waiting - 1;
      (* follower queue can dance now *)
      Semaphore.release followerQueue)
    else (
      num_leader_waiting := !num_leader_waiting + 1;
      Semaphore.release mutex;
      Semaphore.acquire leaderQueue);
    Printf.printf "leader %d\n" i;
    Semaphore.acquire rendezvous;
    Semaphore.release mutex
  in
  let follower i () =
    Semaphore.acquire mutex;
    if !num_leader_waiting > 0 then (
      num_leader_waiting := !num_leader_waiting - 1;
      Semaphore.release leaderQueue)
    else (
      num_follower_waiting := !num_follower_waiting + 1;
      Semaphore.release mutex;
      Semaphore.acquire followerQueue);
    Printf.printf "follower %d\n" i;
    Semaphore.release rendezvous
  in
  let pool = Domainslib.Task.setup_pool ~name:"hello" ~num_domains:12 () in
  let task () =
    let leader_promises =
      List.init 6 (fun i -> Domainslib.Task.async pool (leader i))
    in
    let follower_promises =
      List.init 6 (fun i -> Domainslib.Task.async pool (follower i))
    in
    List.iter (Domainslib.Task.await pool) (leader_promises @ follower_promises)
  in
  Domainslib.Task.run pool task;
  Domainslib.Task.teardown_pool pool
