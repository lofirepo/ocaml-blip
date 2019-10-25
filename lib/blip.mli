(**
{1 BLIP: BLoom-then-flIP}

This is an implementation of the BLoom-then-flIP algorithm as described in the paper {{:http://www.academia.edu/download/32383514/Blip-LNCS-Proof.pdf} BLIP: Non-interactive Differentially-Private Similarity Computation on Bloom filters}
 *)

(** [p e k] returns the optimal flipping probability of a Bloom filter.

    @param e  Differential privacy parameter ε
              that determines the privacy-utility trade-off:
              the smaller e is, the more privacy, but also the less utility.
              e <= 10 is the upper bound that still prevents an adversary
              from performing a successful profile reconstruction attack.
    @param k  Number of hash functions used in the Bloom filter.
 *)
val p : float -> int -> float

(** [flip ?g bits p] flips each element of [bits]
    independently with probability [p], using RNG [g] if provided *)
val flip : ?g:Nocrypto.Rng.g -> Bitv.t -> float -> Bitv.t

(** [sim a b] returns the cosine similarity measure
    of two bit vectors representing (flipped) Bloom filters *)
val sim : Bitv.t -> Bitv.t -> float
