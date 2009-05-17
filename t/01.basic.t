use Test::More tests => 5;

use utf8;

BEGIN {
use_ok( 'Acme::Yomeru' );
}

my $yomeru = Acme::Yomeru->new(
   text => 'これは、奇妙な日本語フィルタだよ。',
);

{
    isa_ok $yomeru, 'Acme::Yomeru', 'new';
}

{
    is $yomeru->text,
        'これは、奇妙な日本語フィルタだよ。',
        'get text';
}


#is $yomeru->parser, 'Acme::Yomeru::Parser::YahooAPI', 'parser';

{
    is $yomeru->convert,
        'これ は 、 きょみう な にほんご ふるぃた だ よ 。',
        'convert';
}

{
    $yomeru->text('');

    eval { $yomeru->convert; };
    like($@, qr/text is blank!/, 'no text');
}