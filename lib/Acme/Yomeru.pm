package Acme::Yomeru;
use Moose;
use utf8;

use Carp qw(croak);

our $VERSION = '0.0.3';

has 'text' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'parser' => (
    is      => 'rw',
    does    => 'Acme::Yomeru::Parser',
    default => sub { 'Acme::Yomeru::Parser::TextMeCab'->new; },
    required => 1,
    handles  => [ 'parse' ]
);

__PACKAGE__->meta->make_immutable;

no Moose;

sub cambridgize {
    my $self = shift;

    croak 'text is blank!' if $self->text eq '';

    $self->_randomize( $self->parse($self->_smoothing) );
}

sub _smoothing {
    my $self = shift;
    my $text = $self->text;
    $text =~ tr/[０-９]/[0-9]/;
    return $text;
}

sub _randomize {
    my $self        = shift;
    my $parsed_text = shift;

    srand(length $parsed_text);

    my $randomized;
    for my $text ( split / /, $parsed_text ) {
        if ( $text =~ /^[ぁ-ん]+$/ && $text =~ m!^(.)(..+)(.)$! ) {
            $randomized .=
                $1 . join('', $self->_shuffle_words($2)) . $3 . ' ';
        }
        else {
            $randomized .= $text . ' ';
        }
    }
    $randomized =~ s/\s+$//;

    return $randomized;
}

sub _shuffle_words {
    my $self = shift;
    my $word = shift;

    my @array = split //, $word;

    my $i;
    for ($i = @array; --$i; ) {
        my $j = int( rand($i+1) );
        next if $i == $j;
        @array[$i,$j] = @array[$j,$i];
    }
    return @array;
}

1;

__END__


=head1 NAME

Acme::Yomeru - Japanese Texts are Converted into Mysterious Texts.


=head1 SYNOPSIS

    #!/usr/bin/perl

    use strict;
    use warnings;
    use utf8;

    use Acme::Yomeru;
    use Acme::Yomeru::Parser::TextMeCab; # Default

    my $yomeru = Acme::Yomeru->new(
        text => 'これは、奇妙な日本語フィルタだよ。',
    );

    print $yomeru->cambridgize;


=head1 METHOD

=over

=item new(I<$arg>)

constructor. required text(utf-8 flag on).

=item cambridgize

convert text into Mysterious Texts.

=back


=head1 AUTHOR

Copyright (c) 2009, Dai Okabayashi C<< <bayashi@cpan.org> >>


=head1 LICENCE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

