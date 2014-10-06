# NAME

Bio::Cigar - Parse CIGAR strings and translate coordinates to/from reference/query

# SYNOPSIS

    use 5.014;
    use Bio::Cigar;
    my $cigar = Bio::Cigar->new("2M1D1M1I4M");
    say "Query length is ", $cigar->query_length;
    say "Reference length is ", $cigar->reference_length;
    
    my ($qpos, $op) = $cigar->rpos_to_qpos(3);
    say "Alignment operation at reference position 3 is $op";

# DESCRIPTION

Bio::Cigar is a small library to parse CIGAR strings ("Compact Idiosyncratic
Gapped Alignment Report"), such as those used in the SAM file format.  CIGAR
strings minimally describe the alignment of a query sequence to an (often
longer) reference sequence.

Parsing follows the [SAM v1 spec](http://samtools.github.io/hts-specs/SAMv1.pdf)
for the `CIGAR` column.

Parsed strings are represented by an object that provides a few utility
methods.

# ATTRIBUTES

All attributes are read-only.

## string

The CIGAR string for this object.

## reference\_length

The length of the reference sequence segment aligned with the query sequence
described by the CIGAR string.

## query\_length

The length of the query sequence described by the CIGAR string.

## ops

An arrayref of `[length, operation]` tuples describing the CIGAR string.
Lengths are integers, [possible operations are below](#cigar-operations).

### CIGAR operations

The CIGAR operations are given in the following table, taken from the SAM v1
spec:

    Op  Description
    ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
    M   alignment match (can be a sequence match or mismatch)
    I   insertion to the reference
    D   deletion from the reference
    N   skipped region from the reference
    S   soft clipping (clipped sequences present in SEQ)
    H   hard clipping (clipped sequences NOT present in SEQ)
    P   padding (silent deletion from padded reference)
    =   sequence match
    X   sequence mismatch

    • H can only be present as the first and/or last operation.
    • S may only have H operations between them and the ends of the string.
    • For mRNA-to-genome alignment, an N operation represents an intron.
      For other types of alignments, the interpretation of N is not defined.
    • Sum of the lengths of the M/I/S/=/X operations shall equal the length of SEQ.

# CONSTRUCTOR

## new

Takes a CIGAR string as the sole argument and returns a new Bio::Cigar object.

# METHODS

## rpos\_to\_qpos

Takes a reference position (origin 1, base-numbered) and returns the
corresponding position (origin 1, base-numbered) on the query sequence.  Indels
affect how the numbering maps from reference to query.

In list context returns a tuple of `[query position, operation at position]`.
Operation is a single-character string.  See the
[table of CIGAR operations](#cigar-operations).

If the reference position does not map to the query sequence (as with a
deletion, for example), returns `undef` or `[undef, operation]`.

## qpos\_to\_rpos

Takes a query position (origin 1, base-numbered) and returns the corresponding
position (origin 1, base-numbered) on the reference sequence.  Indels affect
how the numbering maps from query to reference.

In list context returns a tuple of `[references position, operation at position]`.
Operation is a single-character string.  See the
[table of CIGAR operations](#cigar-operations).

If the query position does not map to the reference sequence (as with an
insertion, for example), returns `undef` or `[undef, operation]`.

## op\_at\_rpos

Takes a reference position and returns the operation at that position.  Simply
a shortcut for calling ["rpos\_to\_qpos"](#rpos_to_qpos) in list context and discarding the
first return value.

## op\_at\_qpos

Takes a query position and returns the operation at that position.  Simply
a shortcut for calling ["qpos\_to\_rpos"](#qpos_to_rpos) in list context and discarding the
first return value.

# AUTHOR

Thomas Sibley <trsibley@uw.edu>

# COPYRIGHT

Copyright 2014- Mullins Lab, Department of Microbiology, University of Washington.

# LICENSE

This library is free software; you can redistribute it and/or modify it under
the GNU General Public License, version 2.

# SEE ALSO

[SAMv1 spec](http://samtools.github.io/hts-specs/SAMv1.pdf)
