#!/usr/bin/perl
use strict;
print "Content-type: text/plain\n\n";

if(exists {map { $_ => 1 } @INC}->{'/var/www/cpan/perl5'})
{
	print "Success";
}
else
{
	print "Failed to find custom cpan library in \@INC\n";
}
