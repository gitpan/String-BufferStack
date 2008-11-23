use warnings;
use strict;

use Test::More tests => 33;

use vars qw/$BUFFER/;

use_ok 'String::BufferStack';

my $stack = String::BufferStack->new( out_method => sub { $BUFFER .= join("", @_) });
ok($stack, "Made an object");
isa_ok($stack, 'String::BufferStack');

# Check data depth with no data set
$stack->push;
is($stack->depth, 1, "Pushing alters depth");
is($stack->data_depth, 0, "With no data, data depth is still 0");
is($stack->data, undef, "Has no data");
$stack->pop;

# Simple data tests
my $data = {key => "value"};
$stack->push( data => $data);
is($stack->depth, 1, "Pushing alters depth");
is($stack->data_depth, 1, "With data, increases data depth");
is($stack->data, $data, "Is same ref");
is_deeply($stack->data, {key => "value"}, "Can get top data");

# Stores the same ref, so can alter $data
$data->{key} = "new";
is_deeply($stack->data, {key => "new"}, "Can get top data");

# Indexing
is_deeply($stack->data(0), $stack->data, "Index 0 is same data");
is_deeply($stack->data(-1), $stack->data, "Index -1 is same data");

# Add more for indexing
$stack->push( data => "deeper" );
is($stack->data, "deeper", "Has new data value");
$stack->push( data => "deepest" );
is($stack->data, "deepest", "Has new data value");
is($stack->data_depth, 3, "Pushed two data levels");
is_deeply($stack->data(0), $data, "Index 0 is same data");
is_deeply($stack->data(1), "deeper", "Index 1 is deeper");
is_deeply($stack->data(2), "deepest", "Index 2 is deepest");
is_deeply($stack->data(-1), "deepest", "Index -1 is deepest");

# Test that we can munge the ref
is_deeply($stack->data_ref, [{key => "new"}, "deeper", "deepest"], "Have ref");
push @{$stack->data_ref}, "moose!";
is($stack->data_depth, 4, "Affected data depth");
is($stack->data, "moose!", "Can see added data");
pop @{$stack->data_ref};

# Check popping makes sense
$stack->pop;
is($stack->data, "deeper", "Back to previous value");
$stack->pop;
is($stack->data, $data, "Back to first value");
is($stack->data_depth, 1, "Only one level deep");

# Extra non-data pushes don't change it
$stack->push;
is($stack->depth, 2, "Pushing alters depth");
is($stack->data_depth, 1, "Second push had no data");
is_deeply($stack->data, {key => "new"}, "Top data is unchanged");

# Popping non-data frames don't change it
$stack->pop;
is($stack->data_depth, 1, "Popping non-data element doesn't change data depth");
is_deeply($stack->data, {key => "new"}, "Top data is unchanged");

# Popping the data frame makes it go away
$stack->pop;
is($stack->data_depth, 0, "Popping data element changes data depth");
is($stack->data, undef, "Top data is no more");
