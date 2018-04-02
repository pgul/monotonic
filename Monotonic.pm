package Monotonic;
use warnings;
use strict;

=head1 NAME

Monotonic - find monotonic subsequences in the list

=head1 PUBLIC FUNCTIONS

=over

=item B<find_monotonic($array)>

Returns length of maximum monotonic subsequence in $array and start index of the first such subsequence

=back
=cut

use parent qw(Exporter);
our @EXPORT_OK = qw(find_monotonic);

sub find_monotonic {
    my $array = shift;

    ref $array eq 'ARRAY' or die "Incorrect params for find_monotonic, expected arrayref";
    my ($max_length, $start_max) = (0, 0);
    my ($start_ascent, $start_descent) = (0, 0);
    my ($current_ascent, $current_descent);
    my $index = 0;
    my $prev_value;
    foreach my $value (@$array) {
        if (!defined $prev_value || $prev_value == $value) {
            $current_ascent++;
            $current_descent++;
        }
        elsif ($value > $prev_value) {
            $current_ascent++;
            $current_descent = 1;
            $start_descent = $index;
        }
        else { # $value < $prev_value
            $current_descent++;
            $current_ascent = 1;
            $start_ascent = $index;
        }
        if ($current_ascent > $max_length) {
            $start_max = $start_ascent;
            $max_length = $current_ascent;
        }
        elsif ($current_descent > $max_length) {
            $start_max = $start_descent;
            $max_length = $current_descent;
        }
        $prev_value = $value;
        $index++;
    }
    return ($max_length, $start_max);
}

1;
