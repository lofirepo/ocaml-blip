(*
  Copyright (C) 2019 TG x Thoth

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published by
  the Free Software Foundation, either version 3 of the License.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
*)

module Rng = Nocrypto.Rng

let foi = float_of_int

(** Optimal flipping probability of a Bloom filter *)
let p e k =
  1. /. (1. +. exp (e /. (foi k)))

(** Independent random bit flip of all elements of a bit vector *)
let flip ?g bits p =
  Bitv.map (fun b -> if foi (Rng.Int.gen ?g 1000) /. 1000. < p
                      then not b else b) bits

(** Cosine similarity measure *)
let sim a b =
  foi (Bitv.pop (Bitv.bw_and a b))
  /. sqrt (foi ((Bitv.pop a) * (Bitv.pop b)))
