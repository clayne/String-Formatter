#!perl
use strict;

use Test::More tests => 9;
use Test::Exception;

use String::Formatter;

my $fmt = String::Formatter->new({
  codes => {
    a => "apples",
    b => "bannanas",
    g => "grapefruits",
    m => "melons",
    w => "watermelons",
    '*' => 'brussel sprouts',
  },
});

{
  my $have = $fmt->format(q(please have some %w));
  my $want = 'please have some watermelons';

  is($have, $want, "formatting with no text after last code");;
}

{
  my $have = $fmt->format(q(I like %a, %b, and %g, but not %m or %w.));
  my $want = 'I like apples, bannanas, and grapefruits, '
           . 'but not melons or watermelons.';

  is($have, $want, "formatting with text after last code");;
}

{
  my $have = $fmt->format(q(This has no stuff.));
  my $want = 'This has no stuff.';

  is($have, $want, "formatting with no %codes");
}

throws_ok { $fmt->format(q(What is %z for?)); } qr/Unknown conversion/i;

{
  my $have = $fmt->format("We have %.5w.");
  my $want = "We have water.";
  is($have, $want, "truncate at max_chars");
}

{
  my $have = $fmt->format("We have %10a.");
  my $want = "We have     apples.";
  is($have, $want, "left-pad to reach min_chars");
}

{
  my $have = $fmt->format("We have %10.a.");
  my $want = "We have     apples.";
  is($have, $want, "left-pad to reach min_chars (with dot)");
}

{
  my $have = $fmt->format("We have %-10a.");
  my $want = "We have apples    .";
  is($have, $want, "right-pad to reach min_chars (-10)");
}

{
  my $have = $fmt->format('Please do not mention the %*.');
  my $want = 'Please do not mention the brussel sprouts.';
  is($have, $want, "non-identifier format characters");
}

