module Rng = Nocrypto.Rng

let foi = float_of_int

(** Optimal flipping probability of a Bloom filter *)
let p e k =
  1. /. (1. +. exp (e /. (foi k)))

(** Independent random bit flip of all elements of a bit vector *)
let flip bits p =
  Bitv.map (fun b -> if foi (Rng.Int.gen 1000) /. 1000. < p
                     then not b else b) bits

(** Cosine similarity measure *)
let sim a b =
  foi (Bitv.pop (Bitv.bw_and a b))
  /. sqrt (foi ((Bitv.pop a) * (Bitv.pop b)))
