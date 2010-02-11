package Data::Semantic::Test;
use strict;
use warnings;
use Test::More;
our $VERSION = '0.04';
use base 'Test::CompanionClasses::Base';

sub PLAN {
    my $self = shift;
    my $plan = 0;
    for my $test ($self->TESTDATA) {

        # see run() about the multipliers
        $plan += @{ $test->{valid} || [] } + @{ $test->{invalid} || [] };
    }
    $plan;
}

sub munge_args {
    my ($self, %args) = @_;
    %args;
}

sub test_is_valid {
    my ($self, $obj, $value, $testname) = @_;
    ok($obj->is_valid($value), $testname);
}

sub test_is_invalid {
    my ($self, $obj, $value, $testname) = @_;
    ok(!$obj->is_valid($value), $testname);
}

sub run {
    my $self = shift;
    $self->SUPER::run(@_);
    for my $test ($self->TESTDATA) {
        my %args = $self->munge_args(%{ $test->{args} || {} });

        # string representation for test name
        my $args = join ',' => map { "$_=$args{$_}" }
          sort keys %args;
        $args = '(none)' unless length $args;
        my $obj = $self->make_real_object(%args);
        $self->test_is_valid($obj, $_, "VALID   $args: $_")
          for @{ $test->{valid} || [] };

        # If a value is not even well-formed, it most certainly is not valid,
        # so add these tests as well.
        $self->test_is_invalid($obj, $_, "INVALID $args: $_")
          for @{ $test->{invalid} || [] };
    }
}
1;
__END__

=head1 NAME

Data::Semantic::Test - Testing Data::Semantic objects

=head1 SYNOPSIS

    Data::Semantic::Test->new;

=head1 DESCRIPTION

This class makes it easy to test new semantic data classes based on
L<Data::Semantic>. It uses the L<Test::CompanionClasses> mechanism. So to
test the subclass L<Data::Semantic::URI::http> you would write a corresponding
L<Data::Semantic::URI::http_TEST> test class. In your test class you need to
define the following structure:

    use constant TESTDATA => (
        {
            args => {},
            valid => [ qw(
                http://localhost/
                http://use.perl.org/~hanekomu/journal?entry=12345
            ) ],
            invalid  => [ qw(
                news://localhost/
                http://?123
                https://localhost/
            ) ],
        },
        {
            args => { scheme => 'https?' },
            valid => [ qw(
                http://localhost/
                http://use.perl.org/~hanekomu/journal?entry=12345
                https://localhost/
                https://use.perl.org/~hanekomu/journal?entry=12345
            ) ],
            invalid  => [ qw(
                news://localhost/
                http://?123
            ) ],
        },
        {
            args => { scheme => 'https' },
            valid => [ qw(
                https://localhost/
                https://use.perl.org/~hanekomu/journal?entry=12345
            ) ],
            invalid  => [ qw(
                http://localhost/
                http://use.perl.org/~hanekomu/journal?entry=12345
                http://?123
                news://localhost/
            ) ],
        },
    );

So you define one or more scenarios, each within its own hashref within the
C<TESTDATA> list. In each scenario you have a list of arguments to pass to the
semantic data object constructor. Given those arguments, certain values will
be considered valid and others invalid. 

See L<Test::CompanionClasses> for more information on how these tests are run.

=head1 METHODS

=over 4

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see L<http://search.cpan.org/dist/Data-Semantic/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2009 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

