#!perl -w
use strict;
use Test::More tests => 6;
use Data::Dumper;

require Filter::signatures;

# Anonymous
$_ = <<'SUB';
sub ($name, $value) {
        return "'$name' is '$value'"
    };
SUB
Filter::signatures::transform_arguments();
is $_, <<'RESULT', "Anonymous subroutines get converted";
sub  { my ($name,$value)=@_;
        return "'$name' is '$value'"
    };
RESULT

$_ = <<'SUB';
sub foo5 () {
        return "We can call a sub without parameters"
};
SUB
Filter::signatures::transform_arguments();
is $_, <<'RESULT', "Parameterless subroutines don't get converted";
sub foo5 { @_==0 or warn "Subroutine foo5 called with parameters.";
        return "We can call a sub without parameters"
};
RESULT

# Function default parameters
$_ = <<'SUB';
sub mylog($msg, $when=time) {
    print "[$when] $msg\n";
};
SUB
Filter::signatures::transform_arguments();
is $_, <<'RESULT', "Function default parameters get converted";
sub mylog { my ($msg,$when)=@_;$when=time if @_ <= 1;
    print "[$when] $msg\n";
};
RESULT

# Empty parameter list
$_ = <<'SUB';
sub mysub() {
    print "Yey\n";
};
SUB
Filter::signatures::transform_arguments();
is $_, <<'RESULT', "Functions without parameters get converted properly";
sub mysub { @_==0 or warn "Subroutine mysub called with parameters.";
    print "Yey\n";
};
RESULT

# Discarding parameters
$_ = <<'SUB';
sub mysub($) {
    print "Yey\n";
};
SUB
Filter::signatures::transform_arguments();
is $_, <<'RESULT', "Functions with unnamed parameters get converted properly";
sub mysub { my (undef)=@_;
    print "Yey\n";
};
RESULT

# Discarding parameters
$_ = <<'SUB';
sub mysub($foo, $, $bar) {
    print "Yey, $foo => $bar\n";
};
SUB
Filter::signatures::transform_arguments();
is $_, <<'RESULT', "Functions without parameters get converted properly";
sub mysub { my ($foo,undef,$bar)=@_;
    print "Yey, $foo => $bar\n";
};
RESULT

done_testing;