use strict;
use warnings;

use Test::More 'no_plan';

BEGIN { use_ok( 'Match::Smart', qw/ smart_match / ) }

package Foo;
   my $obj1 = bless {}, "Foo";
   my $obj2 = bless {}, "Foo";
   sub bar { return 1 }

package Bar;
   my $bar1 = bless {}, "Bar";
   my $bar2 = bless {}, "Bar";
   sub bar { return 1 }

package main;

## ok tests

ok(smart_match([1,3], [4,3]                       ), "ARRAY , ARRAY ");
ok(smart_match([1,3], sub { $_[0] == 1 }          ), "ARRAY , CODE  ");
ok(smart_match([1,3], { 3 => 1 }                  ), "ARRAY , HASH  ");
ok(smart_match([1,3], 1                           ), "ARRAY , NUMBER");
ok(smart_match([$obj2], $obj2                     ), "ARRAY , OBJECT");
ok(smart_match(["foo"], \\"foo"                   ), "ARRAY , REF   ");
ok(smart_match([1,3], qr/\A3\z/                   ), "ARRAY , REGEXP");
ok(smart_match(["foo"], \"foo"                    ), "ARRAY , SCALAR");
ok(smart_match(["foo"], "foo"                     ), "ARRAY , STRING");
ok(smart_match([1,undef], undef                   ), "ARRAY , UNDEF ");

ok(smart_match(sub { $_[0] == 1 }, [1,3]          ), "CODE  , ARRAY ");
ok(smart_match(sub { $_[0] == 1 }, sub { 1 }      ), "CODE  , CODE  ");
ok(smart_match(sub { $_[0] == 1 }, { 1 => 3 }     ), "CODE  , HASH  ");
ok(smart_match(sub { $_[0] == 1 }, 1              ), "CODE  , NUMBER");
ok(smart_match(sub { $_[0] == $obj1 }, $obj1      ), "CODE  , OBJECT");
ok(smart_match(sub { $_[0] eq "foo" }, \\"foo"    ), "CODE  , REF   ");
ok(smart_match(sub { 1 =~ $_[0] }, qr/\A1\z/      ), "CODE  , REGEXP");
ok(smart_match(sub { $_[0] eq "foo" }, \"foo"     ), "CODE  , SCALAR");
ok(smart_match(sub { $_[0] eq "foo" }, "foo"      ), "CODE  , STRING");
ok(smart_match(sub { !defined $_[0] }, undef      ), "CODE  , UNDEF ");

ok(smart_match({ 3 => 1 }, [1,3]                  ), "HASH  , ARRAY ");
ok(smart_match({ 1 => 3 }, sub { $_[0] == 1 }     ), "HASH  , CODE  ");
ok(smart_match({ 1 => 3 }, { 1 => 4 }             ), "HASH  , HASH  ");
ok(smart_match({ 1 => 3 }, 1                      ), "HASH  , NUMBER");
#   ok(smart_match({ 1 => 3 },      ), "HASH  , OBJECT - ok");
ok(smart_match({ foo => 3 }, \\"foo"              ), "HASH  , REF   ");
ok(smart_match({ 1 => 3 }, qr/\A1\z/              ), "HASH  , REGEXP");
ok(smart_match({ foo => 3 }, \"foo"               ), "HASH  , SCALAR");
ok(smart_match({ foo => 3 }, "foo"                ), "HASH  , STRING");
#   ok(smart_match({ 1 => 3 },      ), "HASH  , UNDEF  - ok");

ok(smart_match(1, [1,3]                           ), "NUMBER, ARRAY ");
ok(smart_match(1, sub { $_[0] == 1 }              ), "NUMBER, CODE  ");
ok(smart_match(1, { 1 => 3 }                      ), "NUMBER, HASH  ");
ok(smart_match(1, 1                               ), "NUMBER, NUMBER");
#   ok(smart_match(      ), "NUMBER, OBJECT - ok");
ok(smart_match(1, \\"1foo"                        ), "NUMBER, REF    - ok");
ok(smart_match(1, qr/\A1\z/                       ), "NUMBER, REGEXP");
ok(smart_match(1, \"1foo"                         ), "NUMBER, SCALAR - ok");
ok(smart_match(1, "1foo"                          ), "NUMBER, STRING - ok");
ok(!smart_match(1, undef                          ), "NUMBER, UNDEF ");

ok(smart_match($obj1, [$obj1]                     ), "OBJECT, ARRAY ");
ok(smart_match($obj1, sub { $_[0] == $obj1 }      ), "OBJECT, CODE  ");
#   ok(smart_match(     ), "OBJECT, HASH  ");
#   ok(smart_match(     ), "OBJECT, NUMBER");
ok(smart_match($obj1, $obj1                       ), "OBJECT, OBJECT");
ok(smart_match($obj1, \\"bar"                     ), "OBJECT, REF   ");
#   ok(smart_match(     ), "OBJECT, REGEXP");
ok(smart_match($obj1, \"bar"                      ), "OBJECT, SCALAR");
ok(smart_match($obj1, "bar"                       ), "OBJECT, STRING");
ok(!smart_match($obj1, undef                      ), "OBJECT, UNDEF ");

ok(smart_match(\\"foo", ["foo"],                  ), "REF   , ARRAY ");
ok(smart_match(\\"foo", sub { $_[0] eq "foo" }    ), "REF   , CODE  ");
ok(smart_match(\\"foo", { foo => 3 }              ), "REF   , HASH  ");
ok(smart_match(\\"1foo", 1                        ), "REF   , NUMBER");
ok(smart_match(\\"bar", $obj1                     ), "REF   , OBJECT");
ok(smart_match(\\"foo", \\"foo"                   ), "REF   , REF   ");
ok(smart_match(\\"foo", qr/\Afoo\z/               ), "REF   , REGEXP");
ok(smart_match(\\"foo", \"foo"                    ), "REF   , SCALAR");
ok(smart_match(\\"foo", "foo"                     ), "REF   , STRING");
ok(!smart_match(\\"foo", undef                    ), "REF   , UNDEF ");

ok(smart_match(qr/\A3\z/, [1,3]                   ), "REGEXP, ARRAY ");
ok(smart_match(qr/\A1\z/, sub { 1 =~ $_[0] }      ), "REGEXP, CODE  ");
ok(smart_match(qr/\A1\z/, { 1 => 3 }              ), "REGEXP, HASH  ");
ok(smart_match(qr/\A1\z/, 1                       ), "REGEXP, NUMBER");
#   ok(smart_match(     ), "REGEXP, OBJECT");
ok(smart_match(qr/\Afoo\z/, \\"foo"               ), "REGEXP, REF   ");
ok(smart_match(qr/\A1\z/, qr/\A1\z/               ), "REGEXP, REGEXP");
ok(smart_match(qr/\Afoo\z/, \"foo"                ), "REGEXP, SCALAR");
ok(smart_match(qr/\Afoo\z/, "foo"                 ), "REGEXP, STRING");
ok(!smart_match(qr/\A1\z/, undef                  ), "REGEXP, UNDEF ");

ok(smart_match(\"foo", ["foo"],                   ), "SCALAR, ARRAY ");
ok(smart_match(\"foo", sub { $_[0] eq "foo" }     ), "SCALAR, CODE  ");
ok(smart_match(\"foo", { foo => 3 }               ), "SCALAR, HASH  ");
ok(smart_match(\"1foo", 1                         ), "SCALAR, NUMBER");
ok(smart_match(\"bar", $obj1                      ), "SCALAR, OBJECT");
ok(smart_match(\"foo", \\"foo"                    ), "SCALAR, REF   ");
ok(smart_match(\"foo", qr/\Afoo\z/                ), "SCALAR, REGEXP");
ok(smart_match(\"foo", \"foo"                     ), "SCALAR, SCALAR");
ok(smart_match(\"foo", "foo"                      ), "SCALAR, STRING");
ok(!smart_match(\"foo", undef                     ), "SCALAR, UNDEF ");

ok(smart_match("foo", ["foo"],                    ), "STRING, ARRAY ");
ok(smart_match("foo", sub { $_[0] eq "foo" }      ), "STRING, CODE  ");
ok(smart_match("foo", { foo => 3 }                ), "STRING, HASH  ");
ok(smart_match("1foo", 1                          ), "STRING, NUMBER");
ok(smart_match("bar", $obj1                       ), "STRING, OBJECT");
ok(smart_match("foo", \\"foo"                     ), "STRING, REF   ");
ok(smart_match("foo", qr/\Afoo\z/                 ), "STRING, REGEXP");
ok(smart_match("foo", \"foo"                      ), "STRING, SCALAR");
ok(smart_match("foo", "foo"                       ), "STRING, STRING");
ok(!smart_match("foo", undef                      ), "STRING, UNDEF ");

ok(smart_match(undef, [1,undef]     ), "UNDEF , ARRAY ");
ok(smart_match(undef, sub { !defined $_[0] }      ), "UNDEF , CODE  ");
#   ok(smart_match(undef,      ), "UNDEF , HASH  ");
ok(!smart_match(undef, 1                          ), "UNDEF , NUMBER");
ok(!smart_match(undef, $obj1                      ), "UNDEF , OBJECT");
ok(!smart_match(undef, \\"foo"                    ), "UNDEF , REF   ");
ok(!smart_match(undef, qr/\A1\z/                  ), "UNDEF , REGEXP");
ok(!smart_match(undef, \"foo"                     ), "UNDEF , SCALAR");
ok(!smart_match(undef, "foo"                      ), "UNDEF , STRING");
ok(smart_match(undef, undef                       ), "UNDEF , UNDEF ");

## not ok tests

ok(!smart_match([1,3], [4,2]                       ), "ARRAY , ARRAY ");
ok(!smart_match([2,3], sub { $_[0] == 1 }          ), "ARRAY , CODE  ");
ok(!smart_match([1,3], { 2 => 1 }                  ), "ARRAY , HASH  ");
ok(!smart_match([1,3], 3                           ), "ARRAY , NUMBER");
ok(!smart_match([$obj1], $bar1                     ), "ARRAY , OBJECT");
ok(!smart_match(["foo"], \\"bar"                   ), "ARRAY , REF   ");
ok(!smart_match([1,3], qr/\A2\z/                   ), "ARRAY , REGEXP");
ok(!smart_match(["foo"], \"bar"                    ), "ARRAY , SCALAR");
ok(!smart_match(["foo"], "bar"                     ), "ARRAY , STRING");
ok(!smart_match([1,3], undef                       ), "ARRAY , UNDEF ");

ok(!smart_match(sub { $_[0] == 1 }, [2,3]          ), "CODE  , ARRAY ");
ok(!smart_match(sub { $_[0] == 1 }, sub { 2 }      ), "CODE  , CODE  ");
ok(!smart_match(sub { $_[0] == 1 }, { 2 => 3 }     ), "CODE  , HASH  ");
ok(!smart_match(sub { $_[0] == 1 }, 3              ), "CODE  , NUMBER");
ok(!smart_match(sub { $_[0] == $obj1 }, $bar1      ), "CODE  , OBJECT");
ok(!smart_match(sub { $_[0] eq "foo" }, \\"bar"    ), "CODE  , REF   ");
ok(!smart_match(sub { 1 =~ $_[0] }, qr/\A2\z/      ), "CODE  , REGEXP");
ok(!smart_match(sub { $_[0] eq "foo" }, \"bar"     ), "CODE  , SCALAR");
ok(!smart_match(sub { $_[0] eq "foo" }, "bar"      ), "CODE  , STRING");
ok(!smart_match(sub { defined $_[0] }, undef       ), "CODE  , UNDEF ");

ok(!smart_match({ 3 => 1 }, [2,4]                  ), "HASH  , ARRAY ");
ok(!smart_match({ 2 => 3 }, sub { $_[0] == 1 }     ), "HASH  , CODE  ");
ok(!smart_match({ 2 => 3 }, { 1 => 4 }             ), "HASH  , HASH  ");
ok(!smart_match({ 1 => 3 }, 2                      ), "HASH  , NUMBER");
#   ok(!smart_match({ 1 => 3 },      ), "HASH  , OBJECT - ok");
ok(!smart_match({ foo => 3 }, \\"bar"              ), "HASH  , REF   ");
ok(!smart_match({ 1 => 3 }, qr/\A2\z/              ), "HASH  , REGEXP");
ok(!smart_match({ foo => 3 }, \"bar"               ), "HASH  , SCALAR");
ok(!smart_match({ foo => 3 }, "bar"                ), "HASH  , STRING");
#   ok(!smart_match({ 1 => 3 },      ), "HASH  , UNDEF  - ok");

ok(!smart_match(1, [1,0]                           ), "NUMBER, ARRAY ");
ok(!smart_match(2, sub { $_[0] == 1 }              ), "NUMBER, CODE  ");
ok(!smart_match(2, { 1 => 3 }                      ), "NUMBER, HASH  ");
ok(!smart_match(2, 1                               ), "NUMBER, NUMBER");
#   ok(!smart_match(      ), "NUMBER, OBJECT - ok");
ok(!smart_match(2, \\"1foo"                        ), "NUMBER, REF    - ok");
ok(!smart_match(2, qr/\A1\z/                       ), "NUMBER, REGEXP");
ok(!smart_match(2, \"1foo"                         ), "NUMBER, SCALAR - ok");
ok(!smart_match(2, "1foo"                          ), "NUMBER, STRING - ok");
#   ok(!smart_match(1, undef                          ), "NUMBER, UNDEF ");

ok(!smart_match($obj1, [$bar2]                     ), "OBJECT, ARRAY ");
ok(!smart_match($obj1, sub { $_[0] == $bar1 }      ), "OBJECT, CODE  ");
#   ok(!smart_match(     ), "OBJECT, HASH  ");
#   ok(!smart_match(     ), "OBJECT, NUMBER");
ok(!smart_match($obj1, $bar2                       ), "OBJECT, OBJECT");
ok(!smart_match($obj1, \\"foo"                     ), "OBJECT, REF   ");
#   ok(!smart_match(     ), "OBJECT, REGEXP");
ok(!smart_match($obj1, \"foo"                      ), "OBJECT, SCALAR");
ok(!smart_match($obj1, "foo"                       ), "OBJECT, STRING");
#   ok(!smart_match($obj1, undef                      ), "OBJECT, UNDEF ");

ok(!smart_match(\\"bar", ["foo"],                  ), "REF   , ARRAY ");
ok(!smart_match(\\"bar", sub { $_[0] eq "foo" }    ), "REF   , CODE  ");
ok(!smart_match(\\"bar", { foo => 3 }              ), "REF   , HASH  ");
ok(!smart_match(\\"1bar", 2                        ), "REF   , NUMBER");
ok(!smart_match(\\"foo", $obj1                     ), "REF   , OBJECT");
ok(!smart_match(\\"bar", \\"foo"                   ), "REF   , REF   ");
ok(!smart_match(\\"bar", qr/\Afoo\z/               ), "REF   , REGEXP");
ok(!smart_match(\\"bar", \"foo"                    ), "REF   , SCALAR");
ok(!smart_match(\\"bar", "foo"                     ), "REF   , STRING");
#   ok(!smart_match(\\"foo", undef                    ), "REF   , UNDEF ");

ok(!smart_match(qr/\A2\z/, [1,3]                   ), "REGEXP, ARRAY ");
ok(!smart_match(qr/\A2\z/, sub { 1 =~ $_[0] }      ), "REGEXP, CODE  ");
ok(!smart_match(qr/\A2\z/, { 1 => 3 }              ), "REGEXP, HASH  ");
ok(!smart_match(qr/\A2\z/, 1                       ), "REGEXP, NUMBER");
#   ok(!smart_match(     ), "REGEXP, OBJECT");
ok(!smart_match(qr/\Abar\z/, \\"foo"               ), "REGEXP, REF   ");
ok(!smart_match(qr/\A2\z/, qr/\A1\z/               ), "REGEXP, REGEXP");
ok(!smart_match(qr/\Abar\z/, \"foo"                ), "REGEXP, SCALAR");
ok(!smart_match(qr/\Abar\z/, "foo"                 ), "REGEXP, STRING");
#   ok(!smart_match(qr/\A1\z/, undef                  ), "REGEXP, UNDEF ");

ok(!smart_match(\"bar", ["foo"],                   ), "SCALAR, ARRAY ");
ok(!smart_match(\"bar", sub { $_[0] eq "foo" }     ), "SCALAR, CODE  ");
ok(!smart_match(\"bar", { foo => 3 }               ), "SCALAR, HASH  ");
ok(!smart_match(\"2foo", 1                         ), "SCALAR, NUMBER");
ok(!smart_match(\"foo", $obj1                      ), "SCALAR, OBJECT");
ok(!smart_match(\"bar", \\"foo"                    ), "SCALAR, REF   ");
ok(!smart_match(\"bar", qr/\Afoo\z/                ), "SCALAR, REGEXP");
ok(!smart_match(\"bar", \"foo"                     ), "SCALAR, SCALAR");
ok(!smart_match(\"bar", "foo"                      ), "SCALAR, STRING");
ok(!smart_match(\"bar", undef                     ), "SCALAR, UNDEF ");

ok(!smart_match("bar", ["foo"],                    ), "STRING, ARRAY ");
ok(!smart_match("bar", sub { $_[0] eq "foo" }      ), "STRING, CODE  ");
ok(!smart_match("bar", { foo => 3 }                ), "STRING, HASH  ");
ok(!smart_match("2foo", 1                          ), "STRING, NUMBER");
ok(!smart_match("foo", $obj1                       ), "STRING, OBJECT");
ok(!smart_match("bar", \\"foo"                     ), "STRING, REF   ");
ok(!smart_match("bar", qr/\Afoo\z/                 ), "STRING, REGEXP");
ok(!smart_match("bar", \"foo"                      ), "STRING, SCALAR");
ok(!smart_match("bar", "foo"                       ), "STRING, STRING");
ok(!smart_match("bar", undef                      ), "STRING, UNDEF ");

ok(!smart_match(undef, [1,2]                       ), "UNDEF , ARRAY ");
ok(!smart_match(undef, sub { defined $_[0] }       ), "UNDEF , CODE  ");
#   ok(smart_match(undef,                         ), "UNDEF , HASH  ");
#   ok(!smart_match(undef, 1                      ), "UNDEF , NUMBER");
#   ok(!smart_match(undef, $obj1                  ), "UNDEF , OBJECT");
#   ok(!smart_match(undef, \\"foo"                ), "UNDEF , REF   ");
#   ok(!smart_match(undef, qr/\A1\z/              ), "UNDEF , REGEXP");
#   ok(!smart_match(undef, \"foo"                 ), "UNDEF , SCALAR");
#   ok(!smart_match(undef, "foo"                  ), "UNDEF , STRING");
#   ok(smart_match(undef, undef                   ), "UNDEF , UNDEF ");

## test recursion

my $foo_array = [ ];
$foo_array->[0] = $foo_array;
ok(smart_match($foo_array, $foo_array             ), "ARRAY , ARRAY  - same \$foo_array");

my $bar_array = [ ];
$bar_array->[0] = $foo_array;
ok(smart_match($foo_array, $bar_array             ), "ARRAY , ARRAY  - same \$foo_array, \$bar_array");

my $foo_ref = \\"foo";
ok(smart_match($foo_ref, $foo_ref                 ), "REF   , REF    - same");

my $foo_scalar = \"foo";
ok(smart_match($foo_scalar, $foo_scalar           ), "SCALAR, SCALAR - same");

my $baz1_array = [];
my $baz2_array = [];
$baz1_array->[0] = $baz1_array;
$baz1_array->[1] = $baz1_array;
$baz2_array->[0] = $baz2_array;
$baz2_array->[1] = $baz2_array;
ok(!smart_match($baz1_array, $baz2_array          ), "ARRAY , ARRAY  - same 1");

$baz1_array->[0] = $baz1_array;
$baz1_array->[1] = $baz2_array;
$baz2_array->[0] = $baz1_array;
$baz2_array->[1] = $baz2_array;
ok(smart_match($baz1_array, $baz2_array           ), "ARRAY , ARRAY  - same 2");

$baz1_array->[0] = $baz1_array;
$baz1_array->[1] = $baz2_array;
$baz2_array->[0] = $baz2_array;
$baz2_array->[1] = $baz1_array;
ok(smart_match($baz1_array, $baz2_array           ), "ARRAY , ARRAY  - same 3");

