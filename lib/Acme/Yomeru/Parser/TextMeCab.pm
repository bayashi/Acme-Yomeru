package Acme::Yomeru::Parser::TextMeCab;
use Moose;
use utf8;

use Text::MeCab;
use Encode qw(decode_utf8);

with 'Acme::Yomeru::Parser';

__PACKAGE__->meta->make_immutable;

no Moose;

sub parse {
    my $self = shift;
    my $text = shift;

    my $parsed_text;

    my $mecab = Text::MeCab->new;

    for (my $node = $mecab->parse($text); $node; $node = $node->next) {

        my $surface = decode_utf8($node->surface);
        next unless $surface;
        my $yomi = ( split /,/, decode_utf8($node->feature) )[7];
        $parsed_text .= $yomi ? "$yomi " : "$surface ";

    }

    $parsed_text =~ tr/ァ-ン/ぁ-ん/;

    return $parsed_text;
}

1;

__END__

=head1 NAME

Acme::Yomeru::Parser::TextMeCab - Parse Text by Text::MeCab

=head1 METHODS

=head2 parse

Parse Text by Text::MeCab

=cut