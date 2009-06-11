use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'Acme::Yomeru',
    license           => 'perl',
    dist_author       => 'Dai Okabayashi <bayashi@cpan.org>',
    repository        => 'http://github.com/bayashi/Acme-Yomeru/tree',
    dist_version_from => 'lib/Acme/Yomeru.pm',
    requires => {
        'Moose'       => 0,
        'Moose::Role' => 0,
        'Carp'        => 0,

        # for Acme::Yomeru::Parser::TextMeCab
        'Text::MeCab' => 0,
        'Encode'      => 0,

        # for Acme::Yomeru::Parser::YahooAPI
        'URI'         => 0,
        'LWP::Simple' => 0,
        'XML::Simple' => 0,
    },
    build_requires => {
        'Module::Build' => 0,
        'Test::More'    => 0,
    },
    add_to_cleanup    => [ 'Acme-Yomeru-*' ],
);

$builder->create_build_script();
