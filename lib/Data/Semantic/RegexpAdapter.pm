package Data::Semantic::RegexpAdapter;

use strict;
use warnings;
use Regexp::Common;


our $VERSION = '0.01';


use base qw(
    Data::Semantic
    Data::Inherited
);


__PACKAGE__
    ->mk_scalar_accessors(qw(re))
    ->mk_boolean_accessors(qw(keep))
    ->mk_hash_accessors(qw(kept));


use constant LOAD => '';
use constant REGEXP_KEYS => ();
use constant KEEP_KEYS  => ();


sub init {
    my $self = shift;

    Regexp::Common->import($self->LOAD) if $self->LOAD;

    my @regexp_keys = $self->every_list('REGEXP_KEYS');

    @regexp_keys || die "REGEXP_KEYS is not defined";
    my $re_spec = sprintf '$RE%s',
        join '' =>
        map { "{$_}" }
        @regexp_keys, $self->flags;
    my $re = eval $re_spec;
    die $@ if $@;

    $self->re($re);
}


# turn the object's settings into a list of flags to be passed to
# Regexp::Common's $RE

sub flags {
    my $self = shift;
    my @flags;
    push @flags => '-keep' if $self->keep;
    @flags;

}


sub is_valid_normalized_value {
    my ($self, $value) = @_;
    my $re = $self->re;
    my $ok = $value =~ /^$re$/;

    # assume {-keep} was given in any case - the user will know whether kept()
    # will return anything useful.

    my %keep;
    @keep{ $self->KEEP_KEYS } =
        map { defined($_) ? $_ : '' }
        ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
    $self->kept(%keep);

    $ok;
}


1;


__END__



=head1 NAME

Data::Semantic::RegexpAdapter - Adapter for Regexp::Common patterns

=head1 SYNOPSIS

    Data::Semantic::RegexpAdapter->new;

=head1 DESCRIPTION

This class is an adapter (wrapper) that turns L<Regexp::Common> patterns into
Data::Semantic objects.

Data::Semantic::RegexpAdapter inherits from L<Data::Semantic> and
L<Data::Inherited>.

The superclass L<Data::Semantic> defines these methods and functions:

    new(), is_valid(), normalize()

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

=item clear_keep

    $obj->clear_keep;

Clears the boolean value by setting it to 0.

=item clear_kept

    $obj->clear_kept;

Deletes all keys and values from the hash.

=item clear_re

    $obj->clear_re;

Clears the value.

=item delete_kept

    $obj->delete_kept(@keys);

Takes a list of keys and deletes those keys from the hash.

=item exists_kept

    if ($obj->exists_kept($key)) { ... }

Takes a key and returns a true value if the key exists in the hash, and a
false value otherwise.

=item keep

    $obj->keep($value);
    my $value = $obj->keep;

If called without an argument, returns the boolean value (0 or 1). If called
with an argument, it normalizes it to the boolean value. That is, the values
0, undef and the empty string become 0; everything else becomes 1.

=item keep_clear

    $obj->keep_clear;

Clears the boolean value by setting it to 0.

=item keep_set

    $obj->keep_set;

Sets the boolean value to 1.

=item kept

    my %hash     = $obj->kept;
    my $hash_ref = $obj->kept;
    my $value    = $obj->kept($key);
    my @values   = $obj->kept([ qw(foo bar) ]);
    $obj->kept(%other_hash);
    $obj->kept(foo => 23, bar => 42);

Get or set the hash values. If called without arguments, it returns the hash
in list context, or a reference to the hash in scalar context. If called
with a list of key/value pairs, it sets each key to its corresponding value,
then returns the hash as described before.

If called with exactly one key, it returns the corresponding value.

If called with exactly one array reference, it returns an array whose elements
are the values corresponding to the keys in the argument array, in the same
order. The resulting list is returned as an array in list context, or a
reference to the array in scalar context.

If called with exactly one hash reference, it updates the hash with the given
key/value pairs, then returns the hash in list context, or a reference to the
hash in scalar context.

=item kept_clear

    $obj->kept_clear;

Deletes all keys and values from the hash.

=item kept_delete

    $obj->kept_delete(@keys);

Takes a list of keys and deletes those keys from the hash.

=item kept_exists

    if ($obj->kept_exists($key)) { ... }

Takes a key and returns a true value if the key exists in the hash, and a
false value otherwise.

=item kept_keys

    my @keys = $obj->kept_keys;

Returns a list of all hash keys in no particular order.

=item kept_values

    my @values = $obj->kept_values;

Returns a list of all hash values in no particular order.

=item keys_kept

    my @keys = $obj->keys_kept;

Returns a list of all hash keys in no particular order.

=item re

    my $value = $obj->re;
    $obj->re($value);

A basic getter/setter method. If called without an argument, it returns the
value. If called with a single argument, it sets the value.

=item re_clear

    $obj->re_clear;

Clears the value.

=item set_keep

    $obj->set_keep;

Sets the boolean value to 1.

=item values_kept

    my @values = $obj->values_kept;

Returns a list of all hash values in no particular order.

=item LOAD

    use constant LOAD => 'AT::NICAT';

This is the optional name of the Regexp::Common module to load. For example,
if you use a pattern from L<Regexp::Common::AT::NICAT>, you would set this
to C<AT::NICAT>. If you use patterns bundled in the same distribution as
Regexp::Common you can leave it empty.

=item REGEXP_KEYS

    use constant REGEXP_KEYS => qw(URI file);

These is the list of keys that you would pass to Regexp::Common's C<$RE>. For
example, if you wanted to match HTTP URIs, you would use C<qw(URI HTTP)>.
Compare with L<Regexp::Common::URI::http>. See L<Regexp::Common> for more
details on this mechanism.

=item KEEP_KEYS

    use constant KEEP_KEYS => qw(scheme host port query);

This class supports Regexp::Common's C<-keep> mechanism. C<kept()> returns a
hash of the patterns returned by Regexp::Common. In this list you can specify
the hash keys that C<$1>, C<$2> and so on are mapped to.

=item flags

Turns the object's settings into a list of flags to be passed to
Regexp::Common's C<$RE>. For example, Regexp::Common expects a C<{-keep}> key,
but this class has a C<keep()> accessor. If you subclass this class and
add more accessors that correspond to Regexp::Common keys, you need to
override this method and map the attributes to the keys. Be sure to call
C<SUPER::flags()>. See L<Data::Semantic::URI::http> for an example.

=back

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<datasemantic> tag.

=head1 VERSION 
                   
This document describes version 0.01 of L<Data::Semantic::RegexpAdapter>.

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

