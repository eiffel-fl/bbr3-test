#! /usr/bin/env perl
# Copyright (c) 2024 Francis Laniel <flaniel@linux.microsoft.com>
# SPDX-License-Identifier: MPL-2.0
use strict;
use warnings;

my $path = pop(@ARGV) or die "Usage: $0 file.out";
open(my $fh, '<', $path) or die "opening $path: $!";

my $line;
my @array = ();
while ($line = readline($fh)) {
	if ($line !~ m@(\d+) Mbits/sec\s+(\d+)\s+sender@) {
		next;
	}

	push(@array, { 'sent' => $1, 'retrans' => $2 });
}

close $fh or die "closing $path: $!";

open($fh, '>', "${path}.csv") or die "opening ${path}.csv: $!";

printf($fh "sent,retrans\n");
for my $dict (@array) {
	printf($fh "$dict->{sent},$dict->{retrans}\n");
}

close $fh or die "closing ${path}.csv: $!"