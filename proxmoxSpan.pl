#!/usr/bin/perl

# You can set this via qm with
# qm set <vmid> -hookscript <volume-id>
# where <volume-id> has to be an executable file in the snippets folder
# of any storage with directories e.g.:
# qm set 100 -hookscript local:snippets/createSpan.pl

use strict;
use warnings;

# First argument is the vmid

my $vmid = shift;

# Second argument is the phase

my $phase = shift;
if ($phase eq 'pre-start'){
} elsif ($phase eq 'post-start') {

    # Second phase 'post-start' will be executed after the guest
    # successfully started.

       my  $tapInterface = "tap".$vmid."i1" ;
        # line for creating the Span
        my $spanName = "span".$vmid;
	# EDIT THE LINE BELOW TO CONFIGURE WHAT VLANs you want to mirror
    system("ovs-vsctl -- --id=\@p get port $tapInterface     -- --id=\@m create mirror name=$spanName select-all=true select-vlan=[110, 120, 130, 140, 150, 210, 220, 230, 240, 250, 310, 311, 320, 321] output-port=\@p     -- set bridge vmbr0 mirrors=\@m")

}elsif ($phase eq 'pre-stop') {

        system("ovs-vsctl clear bridge vmbr0 mirrors")
        # cleans up the Mirror on vmbr0 where we created the interface

} elsif ($phase eq 'post-stop') {

        #this is the phase incase the VM gets shut off via the stop function
        system("ovs-vsctl clear bridge vmbr0 mirrors")
} else {
    die "got unknown phase '$phase'\n";
}

exit(0);
