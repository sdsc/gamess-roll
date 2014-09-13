#!/usr/bin/perl -w
# gamess roll installation test.  Usage:
# gamess.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my $isInstalled = -d '/opt/gamess';
my $output;

my $TESTFILE = 'tmpgamess';

open(OUT, ">$TESTFILE");
print OUT <<END;
#!/bin/bash
if test -f /etc/profile.d/modules.sh; then
  . /etc/profile.d/modules.sh
  module load intel mvapich2_ib gamess
fi
mkdir $TESTFILE.dir
cd $TESTFILE.dir
cp /opt/gamess/tests/standard/*.inp .
export PBS_NUM_PPN=1
export PBS_JOBID=1
export PBS_O_LOGNAME=1
echo `hostname` >nodes
export PBS_NODEFILE=`pwd`/nodes
for input in *.inp; do
  testname=`echo \$input | sed 's/\\..*//'`
  /opt/gamess/rungms \$testname 00 1
done
END
close(OUT);

# gamess-common.xml
if($appliance =~ /$installedOnAppliancesPattern/) {
  ok($isInstalled, 'gamess installed');
} else {
  ok(! $isInstalled, 'gamess not installed');
}
SKIP: {

  skip 'gamess roll not installed', 4 if ! $isInstalled;
  print "Running gamess verification tests (takes ~6 minutes)\n";
  $output = `/bin/bash $TESTFILE >$TESTFILE.out 2>&1`;
  my $passed = `grep -c 'TERMINATED NORMALLY' $TESTFILE.out`;
  chomp($passed);
  my $total = `ls /opt/gamess/tests/standard/*.inp | wc -w`;
  chomp($total);
  ok($passed == $total, "test 100% pass rate $passed/$total");

  skip 'modules not installed', 3 if ! -f '/etc/profile.d/modules.sh';
  `/bin/ls /opt/modulefiles/applications/gamess/[0-9]* 2>&1`;
  ok($? == 0, 'gamess module installed');
  `/bin/ls /opt/modulefiles/applications/gamess/.version.[0-9]* 2>&1`;
  ok($? == 0, 'gamess version module installed');
  ok(-l '/opt/modulefiles/applications/gamess/.version',
     'gamess version module link created');

}

`rm -fr $TESTFILE*`;
