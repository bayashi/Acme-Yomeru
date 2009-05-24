use Test::More tests => 7;

use utf8;

use Acme::Yomeru::Parser::TextMeCab;

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

    $yomeru->text('テスト');

{
    is $yomeru->text,
        'テスト',
        'get text again';
}