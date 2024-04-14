name=$1

echo "
(executables
 (names $name)
 (modules $name)
 (libraries eio eio_main domainslib))" >> dune

touch ${name}.ml

dune build