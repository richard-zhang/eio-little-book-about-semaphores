let () =
  let _ = Domain.spawn (fun () -> Printf.printf "A\n") in
  let _ = Domain.spawn (fun () -> Printf.printf "B\n") in
  ()
