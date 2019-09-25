open OUnit2
open Printf

module Rng = Nocrypto.Rng

let fmt = Format.std_formatter

let test1 ?g name =
  printf "\n%s\n\n" name;

  let n = 10 in
  let e = 13. in
  let a = Bloomf.create n in
  let b = Bloomf.create n in
  let c = Bloomf.create n in
  let d = Bloomf.create n in
  let k = Bloomf.k a in
  let m = Bloomf.m a in
  let p = Blip.p e k in
  let flip = Blip.flip ?g in

  Bloomf.add a "abc";
  Bloomf.add b "abc";
  Bloomf.add c "abc";
  Bloomf.add c "def";
  Bloomf.add d "def";

  let ab = Bloomf.bits a in
  let bb = Bloomf.bits b in
  let cb = Bloomf.bits c in
  let db = Bloomf.bits d in
  let ab' = flip ab p in
  let bb' = flip bb p in
  let cb' = flip cb p in
  let db' = flip db p in

  printf "m = %d\n" m;
  printf "e = %.2f\n" e;
  printf "k = %d\n" k;
  printf "p = %.2f\n" p;
  printf "\n";
  printf "ab  = %s\n" @@ Bitv.M.to_string ab;
  printf "ab' = %s\n" @@ Bitv.M.to_string ab';
  printf "\n";
  printf "bb  = %s\n" @@ Bitv.M.to_string bb;
  printf "bb' = %s\n" @@ Bitv.M.to_string bb';
  printf "\n";
  printf "cb  = %s\n" @@ Bitv.M.to_string cb;
  printf "cb' = %s\n" @@ Bitv.M.to_string cb';
  printf "\n";
  printf "db  = %s\n" @@ Bitv.M.to_string db;
  printf "db' = %s\n" @@ Bitv.M.to_string db';
  printf "\n";
  printf "sim ab bb = %.2f\n" @@ Blip.sim ab bb;
  printf "sim ab cb = %.2f\n" @@ Blip.sim ab cb;
  printf "sim ab db = %.2f\n" @@ Blip.sim ab db;
  printf "sim cb db = %.2f\n" @@ Blip.sim cb db;
  printf "\n";
  printf "sim ab bb' = %.2f\n" @@ Blip.sim ab bb';
  printf "sim ab cb' = %.2f\n" @@ Blip.sim ab cb';
  printf "sim ab db' = %.2f\n" @@ Blip.sim ab db';
  printf "sim cb db' = %.2f\n" @@ Blip.sim cb db';
  printf "\n"

let test_blip1 _ctx =
  test1 "Test 1"

let test_blip1s _ctx =
  let seed = Cstruct.create 10_000 in
  let g = Rng.create ~seed (module Rng.Generators.Null) in
  test1 ~g "Test 1 with seed"

let test_blip2 _ctx =
  printf "\nTest 2\n\n";

  let n = 100 in
  let e = 10. in
  let a = Bloomf.create n in
  let b = Bloomf.create n in
  let c = Bloomf.create n in
  let d = Bloomf.create n in
  let k = Bloomf.k a in
  let m = Bloomf.m a in
  let p = Blip.p e k in

  let rec add bf i n =
    if i < n
    then (Bloomf.add bf i; add bf (i+1) n)
    else ()
  in

  add a   0 100;
  add b  10 110;
  add c  50 150;
  add d 100 200;

  let ab = Bloomf.bits a in
  let bb = Bloomf.bits b in
  let cb = Bloomf.bits c in
  let db = Bloomf.bits d in
  let ab' = Blip.flip ab p in
  let bb' = Blip.flip bb p in
  let cb' = Blip.flip cb p in
  let db' = Blip.flip db p in

  printf "m = %d\n" m;
  printf "e = %.2f\n" e;
  printf "k = %d\n" k;
  printf "p = %.2f\n" p;
  printf "\n";
  printf "ab  = %s\n" @@ Bitv.M.to_string ab;
  printf "ab' = %s\n" @@ Bitv.M.to_string ab';
  printf "\n";
  printf "bb  = %s\n" @@ Bitv.M.to_string bb;
  printf "bb' = %s\n" @@ Bitv.M.to_string bb';
  printf "\n";
  printf "cb  = %s\n" @@ Bitv.M.to_string cb;
  printf "cb' = %s\n" @@ Bitv.M.to_string cb';
  printf "\n";
  printf "db  = %s\n" @@ Bitv.M.to_string db;
  printf "db' = %s\n" @@ Bitv.M.to_string db';
  printf "\n";
  printf "sim ab bb = %.2f\n" @@ Blip.sim ab bb;
  printf "sim ab cb = %.2f\n" @@ Blip.sim ab cb;
  printf "sim ab db = %.2f\n" @@ Blip.sim ab db;
  printf "sim cb db = %.2f\n" @@ Blip.sim cb db;
  printf "\n";
  printf "sim ab bb' = %.2f\n" @@ Blip.sim ab bb';
  printf "sim ab cb' = %.2f\n" @@ Blip.sim ab cb';
  printf "sim ab db' = %.2f\n" @@ Blip.sim ab db';
  printf "sim cb db' = %.2f\n" @@ Blip.sim cb db';
  printf "\n";

  let rec mem ?(acc=0) bf i n =
    if i < n
    then (let acc = acc + (if Bloomf.mem bf i then 1 else 0) in
          mem bf (i+1) n ~acc)
    else acc
  in

  let af = Bloomf.create n in
  Bloomf.set_bits af ab';
  let ar = (float_of_int (mem af 0 100)) /. 100. in
  printf "recall ab' = %.2f\n" ar;

  let bf = Bloomf.create n in
  Bloomf.set_bits bf bb';
  let br = (float_of_int (mem bf 10 110)) /. 100. in
  printf "recall bb' = %.2f\n" br;

  let cf = Bloomf.create n in
  Bloomf.set_bits cf cb';
  let cr = (float_of_int (mem cf 50 150)) /. 100. in
  printf "recall cb' = %.2f\n" cr;

  let df = Bloomf.create n in
  Bloomf.set_bits df db';
  let dr = (float_of_int (mem df 100 200)) /. 100. in
  printf "recall db' = %.2f\n" dr

let suite =
  "suite">:::
    [
      "blip 1">:: test_blip1;
      "blip 1 seeded">:: test_blip1s;
      "blip 2">:: test_blip2;
    ]

let () =
  Nocrypto_entropy_unix.initialize ();
  run_test_tt_main suite
