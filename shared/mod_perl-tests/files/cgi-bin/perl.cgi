#!/usr/bin/perl
use strict;

(exists {map { $_ => 1 } @INC}->{'/var/www/cpan/perl5'}) or die "Failed to find custom cpan library in \@INC\n";

print "Content-type: text/plain\n\n";
print "Success";
