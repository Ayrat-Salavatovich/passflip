#!/usr/bin/perl -w
# Author:  <Ayrat.Salavatovich@analyst.mx>
# Version: 0.01

use warnings;
use strict;

use Getopt::Long qw(GetOptions);
use Pod::Usage;
use Term::ReadKey qw(ReadMode);
use Digest::SHA qw(sha224_hex);

my $help = 0;
my @options;
use Data::Dumper;

sub main {
    GetOptions ('help|?' => \$help, '<>' => \&process);
    if ( $help ) {
        pod2usage(1);
        exit 0;
    }
    
    if ( @options != 2 ) {
        undef @options;        
        push @options, get_password('password: ');
        push @options, get_password('salt: ');
    }
    
    my $mutated = mutate();
    printf "%s\n", $mutated;
}

sub process {
    push @options, $_[0];
}

sub get_password {
    my ( $prompt ) = @_;
    print $prompt;
    ReadMode 'noecho';
    chomp(my $password = <STDIN>);
    ReadMode 'restore';
    print "\n";
    return $password;
}


sub mutate {
    my ( $password, $salt ) = @options;
    my $combined = $password . $salt;
    sha224_hex($combined);
}

&main;

__END__

=head1 NAME

passflip.pl - Command line tool to mutate passwords for different websites.

=head1 SYNOPSIS

usage: passflip.pl <password> <salt>

=item DESCRIPTION

You can use the salt to modify the result of the password mutator.

E.g.
If I wanted different passwords for Facebook and Twitter,
I would run passflip with the following standard input:

password: secret123
salt: facebook

and...

password: secret123
salt: twitter

=head1 AUTHOR

Ayrat Salavatovich, E<lt>analyst@Ayrat.Salavatovich@analyst.mxE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Ayrat Salavatovich

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.

=head1 BUGS

None reported... yet.

=cut
