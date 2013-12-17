# SDSC "gamess" roll

## Overview

This roll bundles the GAMESS quantum chemistry package.

For more information about the various packages included in the gamess roll please visit their official web pages:

- <a href="http://www.msg.chem.iastate.edu/GAMESS/" target="_blank">GAMESS</a> is a general ab initio quantum chemistry package.


## Requirements

To build/install this roll you must have root access to a Rocks development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must
download the appropriate gamess source file(s) using a machine that does
have Internet access and copy them into the `src/gamess` directories on your
Rocks development machine.


## Dependencies

Unknown at this time.


## Building

To build the gamess-roll, execute these instructions on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make default 2>&1 | tee build.log
% grep "RPM build error" build.log
```

If nothing is returned from the grep command then the roll should have been
created as... `gamess-*.iso`. If you built the roll on a Rocks frontend then
proceed to the installation step. If you built the roll on a Rocks development
appliance you need to copy the roll to your Rocks frontend before continuing
with installation.

The build process currently supports the values "intel" and "gnu" for the
ROLLCOMPILER variable, defaulting to "gnu", e.g.,

% make ROLLCOMPILER=intel

This roll also supports the `ROLLOPTS` make variable.  If it contains 'vsmp',
the gamess executable uses mpi for communication; otherwise, it uses sockets.


## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll *.iso
% rocks enable roll gamess
% cd /export/rocks/install
% rocks create distro
% rocks run roll gamess | bash
```

In addition to the software itself, the roll installs gamess environment
module files in:

```shell
/opt/modulefiles/applications/.(compiler)/gamess.
```


## Testing

The gamess-roll includes a test script which can be run to verify proper
installation of the gamess-roll documentation, binaries and module files. To
run the test scripts execute the following command(s):

```shell
% /root/rolltests/gamess.t 
ok 1 - gamess is installed
ok 2 - gamess test run
ok 3 - gamess module installed
ok 4 - gamess version module installed
ok 5 - gamess version module link created
1..5
```






  To install, execute
these instructions on a Rocks development machine (e.g., a frontend), starting
in this directory:

% make
% rocks add roll *.iso
% rocks enable roll gamess
% cd /export/rocks/install
% rocks create distro
% rocks run roll gamess | bash

In addition to the software itself, the roll installs GAMESS environment module
files in /opt/modulefiles/applications/gamess.

