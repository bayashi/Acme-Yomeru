use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Acme::Yomeru',
    license             => 'perl',
    dist_author         => 'Dai Okabayashi <bayashi@cpan.org>',
    dist_version_from   => 'lib/Acme/Yomeru.pm',
    requires => {
        'Test::More' => 0,
        'Carp'       => 0,
    },
    add_to_cleanup      => [ 'Acme-Yomeru-*' ],
);

$builder->create_build_script();
