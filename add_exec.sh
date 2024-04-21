name=$1

echo "
(executables
 (names $name)
 (modules $name)
 (libraries eio eio_main domainslib))" >> dune

echo "
let () =
  let pool = Domainslib.Task.setup_pool ~name:\"hello\" ~num_domains:12 () in
  let task () = Printf.printf \"Hello, World\" in
  Domainslib.Task.run pool task;
  Domainslib.Task.teardown_pool pool
" > ${name}.ml

dune build