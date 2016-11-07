#!perl -w
use strict;
use Test::More tests => 6;
use Data::Dumper;

use Filter::signatures;
use feature 'signatures';
no warnings 'experimental::signatures';

# Anonymous
my $sub = sub ($name, $value) {
        return "'$name' is '$value'"
    };

SKIP: {
    is ref $sub, 'CODE', "we can compile a simple anonymous subroutine"
        or skip 1, $@;
    is $sub->("Foo", 'bar'), "'Foo' is 'bar'", "Passing parameters works";
}

# Named
sub foo1 ($name, $value) {
        return "'$name' is '$value'"
};

SKIP: {
    is foo1("Foo", 'bar'), "'Foo' is 'bar'", "Passing parameters works (named)";
}

# Named, with default
sub foo2 ($name, $value='default') {
        return "'$name' is '$value'"
};

SKIP: {
    is foo2("Foo"), "'Foo' is 'default'", "default parameters works";
}

# Named, with default
sub foo3 ($name, $value='default, with comma') {
        return "'$name' is '$value'"
};

SKIP: {
    is foo3("Foo"), "'Foo' is 'default, with comma'", "default parameters works even with embedded comma";
}

# No parameters
sub foo5 () {
        return "We can call a sub without parameters"
};

is foo5(), "We can call a sub without parameters", "A subroutine with an empty parameter list still compiles";

