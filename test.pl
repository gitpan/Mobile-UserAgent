#!/usr/bin/perl -w
use strict;
use lib qw(lib);
use Test;

BEGIN {
 plan tests => 7;
}

# Test 1
print_test('Require module');
eval {require Mobile::UserAgent;};
ok($@ ? 0 : 1);
print 'This version: ' . $Mobile::UserAgent::VERSION . "\n";


# Test 2
print_test('Create object');
my $o = new Mobile::UserAgent('Nokia6600/1.0 (4.09.1) SymbianOS/7.0s Series60/2.0 Profile/MIDP-2.0 Configuration/CLDC-1.0');
ok(defined($o) ? 1 : 0);


# Test 3
$o = new Mobile::UserAgent('portalmmm/2.0 N400i(c20;TB)');
print_test('Parse an i-mode useragent');
ok($o->success() && $o->isImode());


# Test 4
$o = new Mobile::UserAgent('Nokia6600/1.0 (4.09.1) SymbianOS/7.0s Series60/2.0 Profile/MIDP-2.0 Configuration/CLDC-1.0');
print_test('Parse a standard user-agent');
ok($o->success() && $o->isStandard());


# Test 5
$o = new Mobile::UserAgent('Mozilla/1.22 (compatible; MMEF20; Cellphone; Sony CMD-Z5;Pz063e+wt16)');
print_test('Parse a Mozilla user-agent');
ok($o->success() && $o->isMozilla());


# Test 6
$o = new Mobile::UserAgent('PHILIPS-FISIO 620/3');
print_test('Parse a rubbish user-agent');
ok($o->success() && $o->isRubbish());


# Test 7
print_test('Parse all user-agents in "useragents.txt"');
eval {
  my $h;
  open($h, '<useragents.txt') || die "Failed to open test useragents file \"useragents.txt\".\n";
  my @lines = <$h>;
  close($h);
  foreach my $line (@lines) {
    chomp($line);
    my $o = new Mobile::UserAgent($line);
    if ($o->success()) {
      unless(defined($o->vendor()) && defined($o->model())) {
        die "Logic error: parse returned success but vendor and model aren't both defined.\n";
      }
    }
  }
};
if ($@) {
  warn $@;
}
ok($@ ? 0 : 1);


sub print_test {
 my $s = shift;
 $s .= '.' x (44 - length($s));
 print $s;
}
