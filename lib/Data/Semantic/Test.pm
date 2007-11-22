package Data::Semantic::Test;

use strict;
use warnings;
use Test::More;


our $VERSION = '0.02';


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

        my $args =
            join ',' =>
            map { "$_=$args{$_}" }
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
L<Data::Semantic>. It uses the L<Test::CompanionClasses> meechanism. So to
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

Data::Semantic::Test inherits from L<Test::CompanionClasses::Base>.

The superclass L<Test::CompanionClasses::Base> defines these methods and
functions:

    new(), clear_package(), make_real_object(), package(), package_clear(),
    planned_test_count()

The superclass L<Class::Accessor::Complex> defines these methods and
functions:

    carp(), cluck(), croak(), flatten(), mk_abstract_accessors(),
    mk_array_accessors(), mk_boolean_accessors(),
    mk_class_array_accessors(), mk_class_hash_accessors(),
    mk_class_scalar_accessors(), mk_concat_accessors(),
    mk_forward_accessors(), mk_hash_accessors(), mk_integer_accessors(),
    mk_new(), mk_object_accessors(), mk_scalar_accessors(),
    mk_set_accessors(), mk_singleton()

The superclass L<Class::Accessor> defines these methods and functions:

    _carp(), _croak(), _mk_accessors(), accessor_name_for(),
    best_practice_accessor_name_for(), best_practice_mutator_name_for(),
    follow_best_practice(), get(), make_accessor(), make_ro_accessor(),
    make_wo_accessor(), mk_accessors(), mk_ro_accessors(),
    mk_wo_accessors(), mutator_name_for(), set()

The superclass L<Class::Accessor::Installer> defines these methods and
functions:

    install_accessor(), subname()

The superclass L<Data::Inherited> defines these methods and functions:

    every_hash(), every_list(), flush_every_cache_by_key()

=head1 METHODS

=over 4



=back

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<datasemantic> tag.

=head1 VERSION 
                   
This document describes version 0.02 of L<Data::Semantic::Test>.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<<bug-data-semantic@rt.cpan.org>>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

