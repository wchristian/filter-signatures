#!perl -w
use strict;
use Test::More tests => 5;
use Data::Dumper;

my $sub = eval <<'PERL';
    use Filter::signatures;
    use feature 'signatures';
    sub ($name, $value) {
        return "'$name' is '$value'"
    }
PERL

is ref $sub, 'CODE', "we can compile a simple subroutine";
is $sub->("Foo", 'bar'), "'Foo' is 'bar'", "Passing parameters works";

$sub = eval <<'PERL';
    use Filter::signatures;
    use feature 'signatures';
    sub ($name, $value, @) {
        return "'$name' is '$value'"
    }
PERL

is ref $sub, 'CODE', "we can compile a simple subroutine";

{
    my @warnings;
    local $SIG{__WARN__} = sub { push @warnings, \@_};
    is $sub->("Foo", 'bar', 'baz'), "'Foo' is 'bar'", "Passing parameters works";
    is_deeply \@warnings, [], "No warnings get raised during call"
        or diag Dumper \@warnings;
}