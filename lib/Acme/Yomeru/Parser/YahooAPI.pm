package Acme::Yomeru::Parser::YahooAPI;
use utf8;

use Carp qw(croak);

use URI;
use LWP::Simple;
use XML::Simple;
use Encode qw(encode_utf8 decode_utf8);

use Moose;

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
    my $obj  = shift;

    my $uri = URI->new('http://jlp.yahooapis.jp/MAService/V1/parse');

    $uri->query_form(
        appid    => $self->api_key,
        sentence => encode_utf8($obj->text),
    );

    my $node_list = XMLin( get($uri) )->{ma_result}{word_list}{word};

    my $parsed_text;

    if ( ref $node_list ne 'ARRAY' ) {
        $node_list = [$node_list];
    }

    for my $node ( @{ $node_list } ) {

        my $surface = decode_utf8($node->{surface});
        my $yomi    = decode_utf8($node->{reading});
        $parsed_text .= "$yomi ";

    }

    $parsed_text =~ tr/ァ-ン/ぁ-ん/;

    $obj->_convert_text($parsed_text);

    return $obj;
}

1;

__END__

=head1 NAME

Acme::Yomeru::Parser::YahooAPI - Parse Text by YahooAPI

=head1 METHODS

=head2 parse

Parse Text by YahooAPI

=cut
