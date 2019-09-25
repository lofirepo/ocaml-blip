(** BLIP *)

(** [p e k] returns the optimal flipping probability of a Bloom filter.

    @param [e] privacy parameter that determines the privacy-utility trade-off:
    the smaller e is, the more privacy, but also the less utility.
    e < 10 is the upper bound that still prevents an adversary
    from performing a successful profile reconstruction attack.
    @param [k] number of hash functions used in the Bloom filter.
 *)
val p : float -> int -> float

(** [flip bits p] flips each element of [bits]
    independently with probability [p] *)
val flip : Bitv.t -> float -> Bitv.t

(** [sim a b] returns the cosine similarity measure
    of two bit vectors representing (flipped) Bloom filters *)
val sim : Bitv.t -> Bitv.t -> float
