package Data::Semantic;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.04';
use base qw(Class::Accessor::Complex);
__PACKAGE__->mk_new;

sub is_valid {
    my ($self, $value) = @_;

    # value can be undef
    return 1 unless defined $value;
    my $normalized = $self->normalize($value);
    return 0 unless defined $normalized;
    $self->is_valid_normalized_value($normalized);
}

sub normalize {
    my ($self, $value) = @_;
    $value;
}

sub is_valid_normalized_value {
    my ($self, $normalized) = @_;
    defined $normalized;
}
1;
__END__

=head1 NAME

Data::Semantic - Common API for data with semantics attached to them

=head1 SYNOPSIS

    Data::Semantic->new;

=head1 DESCRIPTION

There are various distributions on CPAN dealing with data that has semantics
attached them. For example, an IP address is not just a string, but it has a
format the can be checked.

There is L<Data::Domain>. It does not store the values to be tested, it just
tests them and records messages.

Then there is L<Class::Value>. It does store the value and it records
exceptions.

Both share the same underlying concept of a value that can be tested for
validity. Data::Semantic provides this underlying mechanism. It does not store
the value and it does not record the message. All it does is validate data and
say whether it is good or bad. What L<Data::Domain> or L<Class::Value> do with
this information is their thing.

If you have a new type of semantic data, here is how you can handle it.

    if it can be a Regexp::Common pattern:
        make a Regexp::Common pattern
        make a subclass of Data::Semantic::RegexpAdapter
    else:
        make a subclass of Data::Semantic::Base
        if there is a CPAN module for that data type:
            wrap that module in your semantic data class
            forward methods onto the object if possible

    make an adapter class for Class::Value
    make an adapter class for Data::Domain

=head1 METHODS

=over 4

=item C<new>

    my $obj = Data::Semantic->new;
    my $obj = Data::Semantic->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

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
