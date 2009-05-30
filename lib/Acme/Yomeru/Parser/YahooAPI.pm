package Acme::Yomeru::Parser::YahooAPI;
use Moose;
use utf8;

use Carp qw(croak);

use URI;
use LWP::Simple;
use XML::Simple;
use Encode qw(encode_utf8 decode_utf8);

with 'Acme::Yomeru::Parser';

has 'api_key' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

__PACKAGE__->meta->make_immutable;

no Moose;

sub parse {
    my $self = shift;
    my $text = shift;

    croak 'api_key is blank!' if $self->api_key eq '';

    my $uri = URI->new('http://jlp.yahooapis.jp/MAService/V1/parse');

    $uri->query_form(
        appid    => $self->api_key,
        sentence => encode_utf8($text),
    );

    my $node_list = XMLin( get($uri) )->{ma_result}{word_list}{word};

    my $parsed_text;

    for my $node ( @{ $node_list } ) {

        my $surface = decode_utf8($node->{surface});
        my $yomi    = decode_utf8($node->{reading});
        next unless $surface;
        $parsed_text .= $yomi ? "$yomi " : "$surface ";

    }

    $parsed_text =~ tr/ァ-ン/ぁ-ん/;

    return $parsed_text;
}

1;

__END__

=head1 NAME

Acme::Yomeru::Parser::YahooAPI - Parse Text by YahooAPI

=head1 METHODS

=head2 parse

Parse Text by YahooAPI

=cut
