use Test::More tests => 10;

use utf8;

use Acme::Yomeru::Parser::TextMeCab;
use Acme::Yomeru::Parser::YahooAPI;

BEGIN {
    use_ok( 'Acme::Yomeru' );
}

my $yomeru = Acme::Yomeru->new(
    text   => 'これは、奇妙な日本語フィルタだよ。',
);

{
    isa_ok $yomeru, 'Acme::Yomeru', 'new';
}

{
    is $yomeru->text,
        'これは、奇妙な日本語フィルタだよ。',
        'get text';
}

{
    like $yomeru->parser,
        qr/Acme::Yomeru::Parser::TextMeCab/,
        'parser';
}

{
    is $yomeru->cambridgize,
        'これ は 、 きょみう な にほんご ふるぃた だ よ 。',
        'cambridgize';
}

{
    $yomeru->text('');

    eval { $yomeru->cambridgize; };
    like $@, qr/text is blank!/, 'no text';
}

    $yomeru->text('love');

{
    is $yomeru->cambridgize,
        'love',
        'words can not read';
}



my $yomeru_yahoo = Acme::Yomeru->new(
    text   => 'これは、奇妙な日本語フィルタだよ。',
    parser => Acme::Yomeru::Parser::YahooAPI->new(
        api_key => 'YOUR_APP_ID',
    ),
);

{
    like $yomeru_yahoo->parser,
        qr/Acme::Yomeru::Parser::YahooAPI/,
        'parser';
}

{
    is $yomeru_yahoo->cambridgize,
        'これ は 、 きょみう な にほんご ふるぃた だ よ 。',
        'cambridgize';
}

    $yomeru_yahoo->text('peace');

{
    is $yomeru_yahoo->cambridgize,
        'peace',
        'words can not read';
}
