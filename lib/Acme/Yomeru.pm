package Acme::Yomeru;

use Moose;
use utf8;
use Carp qw(croak);
#use UNIVERSAL::require;

use Text::MeCab;
use Encode qw(decode_utf8);

our $VERSION = '0.0.2';

has 'text' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

#has 'parser' => (
#    is      => 'rw',
#    isa     => 'Str',
#    default => __PACKAGE__ . '::Parser::TextMeCab',
#);

__PACKAGE__->meta->make_immutable;

no Moose;

sub convert {
    my $self = shift;

    croak 'text is blank!' unless $self->text;

    # load parser
    #my $module = $self->parser;
    #$module->require or croak 'can not load' . $module;

    return $self->_randomize($self->_smoothing->_parse_text);
}

sub _smoothing {
    my $self = shift;

    my $text = $self->text;

    $text =~ tr/[０-９]/[0-9]/;

    $self->text($text);

    $self;
}

sub _parse_text {
    my $self = shift;

    my $parsed_text;

    my $mecab = Text::MeCab->new;

    for (my $node = $mecab->parse($self->text); $node; $node = $node->next) {

        my $surface = decode_utf8($node->surface);
        next unless $surface;
        my $feature = decode_utf8($node->feature);
        my ($type, $yomi) = ( split /,/, $feature )[0, 7];
        $parsed_text .= $yomi ? "$yomi " : "$surface ";

    }

    $parsed_text =~ tr/ァ-ン/ぁ-ん/;

    return $parsed_text;
}

sub _randomize {
    my $self        = shift;
    my $parsed_text = shift;

    srand(length $parsed_text);

    my $randomized;
    for my $text ( split / /, $parsed_text ) {
        if ($text =~ /^[ぁ-ん]+$/ && $text =~ m!^(.)(..+)(.)$!) {
            $randomized .=
                $1 . join('', $self->_shuffle(split //, $2)) . $3 . ' ';
        }
        else {
            $randomized .= $text . ' ';
        }
    }
    $randomized =~ s/\s+$//;

    return $randomized;
}

sub _shuffle {
    my $self  = shift;
    my @array = @_;

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

    use utf8;
    use Acme::Yomeru;

    my $yomeru = Acme::Yomeru->new(
        text => 'これは、奇妙な日本語フィルタだよ。',
    );

    print $yomeru->convert;
    

=head1 METHOD

=over

=item new(I<$arg>)

constructor. required text(utf-8 flag on).

=item convert

convert text into Mysterious Texts.

=back


=head1 AUTHOR

Copyright (c) 2009, Dai Okabayashi C<< <bayashi@cpan.org> >>


=head1 LICENCE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

