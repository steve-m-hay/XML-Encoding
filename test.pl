# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..7\n"; }
END {print "not ok 1\n" unless $loaded;}
use XML::Encoding;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

my @prefixes = ();
my $pops = 0;
my @rnginfo = ();

sub pushpfx {
  my ($byte) = @_;

  push(@prefixes, $byte);
  undef;
}

sub poppfx {
  $pops++;
  undef;
}

sub range {
  my ($byte, $uni, $len) = @_;

  push(@rnginfo, @_);
  undef;
}

$doc1 =<<'End_of_doc;';
<encmap name="foo" expat="yes">
  <range byte='xa0' uni='x3000' len='6'/>
  <prefix byte='x81'>
    <ch byte='x41' uni='x0753'/>
    <range byte='x50' uni='x0400' len='32'/>
  </prefix>
</encmap>
End_of_doc;


my @exprng = (0xa0, 0x3000, 6, 0x41, 0x0753, 1, 0x50, 0x0400, 32);

$p = new XML::Encoding(PushPrefixFcn => \&pushpfx,
		       PopPrefixFcn  => \&poppfx,
		       RangeSetFcn   => \&range);


my $name = $p->parse($doc1);

if ($name ne 'foo') {
print "not ";
}
print "ok 2\n";

if ($prefixes[0] != 0x81) {
  print "not ";
}
print "ok 3\n";

if ($pops != @prefixes) {
  print "not ";
}
print "ok 4\n";

if (@rnginfo > @exprng) {
  print "not ";
}
print "ok 5\n";

foreach (0 .. $#exprng) {
  if ($rnginfo[$_] != $exprng[$_]) {
    print "not ";
    last;
  }
}
print "ok 6\n";

$doc1 =~ s/='32'/='200'/;

# Don't use an eval {} here to trap the parse() error
# because it causes a crash under perl-5.6.x
{
local $SIG{__DIE__} = sub {
  my $err = $_[0];
  unless ($err and $err =~ /^Len plus byte > 256/) {
    print "not ";
  }
  print "ok 7\n";
  exit;
};
$p->parse($doc1);
}

print "not ok 7\n";
