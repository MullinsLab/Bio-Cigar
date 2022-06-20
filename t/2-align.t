# Test the align() method of Bio::Cigar.

use strict;
use warnings;
use Test::More tests => 3;
use Bio::Cigar;
use Test::Exception;

my $query_seq = 'ATGCGGAAAATCGGC';
my   $ref_seq = 'GGCGGGATGCAAA';
my $cigar_string = '4S2=4IX3D4M3N2P10H';
my $cigar;

# Test align method availablility.
subtest 'Callable' => sub {
    plan tests => 2;

    $cigar = Bio::Cigar->new($cigar_string);
    isa_ok $cigar, 'Bio::Cigar';
    can_ok $cigar, 'align';
} or BAIL_OUT('Cannot instantiate CIGAR string object or cannot align, stopping');

# Test sanity checks.
subtest 'Sanity checks' => sub {
    plan tests => 3;

    my $wrong_query = 'ATGC';
    my $wrong_ref   = 'CGTA';

    throws_ok { $cigar->align($query_seq, $wrong_ref) }
              qr/Reference was expected to have length/;
    throws_ok { $cigar->align($wrong_query, $ref_seq) }
              qr/Query was expected to have length/;
    lives_ok  { $cigar->align($query_seq, $ref_seq) }
              'correct input lives';
};

# Test correctness of alignments.
subtest 'Alignment' => sub {
    plan tests => 7;

    # Align sequences.
    my $aln = $cigar->align($query_seq, $ref_seq);
    isa_ok $aln, ref [];                # is an array ref
    cmp_ok scalar(@$aln), '==', 2;      # we have two aligned sequences
    my ($query_aln, $ref_aln) = @$aln;

    # Verify results.
    is $query_aln =~ s/[^ATGCU]//gr, $query_seq, 'removing gaps yields query';
    is   $ref_aln =~ s/[^ATGCU]//gr,   $ref_seq, 'removing gaps yields reference';
    cmp_ok length $query_aln, '==', length $ref_aln,
        'aligned sequences have equal length';

    is $query_aln, 'ATGCGGAAAAT---CGGC---', 'query correctly aligned';
    is   $ref_aln, '----GG----CGGGATGCAAA', 'reference correctly aligned';
};


# EOF
