package C4::EMSServer;

use strict;

use lib '/usr/share/koha/lib'; # change if necessary - file path to Koha library
use C4::Dematic;    # Custom Marywood module for communication with the AS/RS
use IO::Socket;

use vars qw($VERSION @ISA @EXPORT);

BEGIN {
    $VERSION = 1.00.00.000;

    require Exporter;
    @ISA = qw( Exporter );

    # function exports
    @EXPORT = qw(

    );
}

my $port = '8020';
my $client;
my $data = "";

my $rsnr = '00001';

my $listener = new IO::Socket::INET(
    LocalPort => $port,
    Proto     => 'tcp',
    Listen    => 10,
    Reuse     => 1
);
die "Cannot create listener on port 8020: $!\n" unless $listener;

# print "Server is running on $port\n";

# kill children when finished with work -- otherwise resources are not freed up
$SIG{CHLD} = 'IGNORE';

while (1) {
    while ( $client = $listener->accept() ) {

        $client->recv( $data, 1024 );

        my $response = "$rsnr" . 'RSNR0000500000';

        $client->send($response);

        unless ( $rsnr == '99999' ) {

            $rsnr++;

        }
        else {
            $rsnr = '00001';
        }

        if ( $data =~ /STAT/ ) {
            if ( $data =~ /\s\s\s\s\s\s00009/ ) {

                my ($barcode) = $data =~ /(3303300\w+)/;

                email_notif($barcode);

            }
            elsif ( $data =~ /\s\s\s\s\s\s00003/ ) {

                my ($barcode) = $data =~ /(3303300\w+)/;

                emsLog( $barcode, "STAT", "Item is not in the EMS database" );

            }
            elsif ( $data =~ /\s\s\s\s\s\s00004/ ) {

                my ($barcode) = $data =~ /(3303300\w+)/;

                emsLog( $barcode, "STAT", "Item is missing" );

            }
            elsif ( $data =~ /\s\s\s\s\s\s00005/ ) {

                my ($barcode) = $data =~ /(3303300\w+)/;

                emsLog( $barcode, "STAT", "Item has not been returned" );

            }
            elsif ( $data =~ /\s\s\s\s\s\s99999/ ) {

                my ($barcode) = $data =~ /(3303300\w+)/;

                emsLog( $barcode, "STAT", "Unknown exception condition" );

            }
        }
        $client->close();
    }
}

sub email_notif {
    my ($barcode) = @_;

    my $pid = fork;    # forks email_notif so socket can return to listening
    return if $pid;    # in the parent process

    ## BEGIN - child process
    my $results = check_if_exists($barcode);

    if ( $results == 1 ) {

        my $to      = 'ldjamison@maryu.marywood.edu';
        my $from    = 'kohaadmin@maryu.marywood.edu';
        my $subject = 'Item Not Returned';
        my $message = "Item $barcode has not been checked in.";

        open( MAIL, "|/usr/sbin/sendmail -t" );

        # Email Header
        print MAIL "To: $to\n";
        print MAIL "From: $from\n";
        print MAIL "Subject: $subject\n\n";

        # Email Body
        print MAIL $message;

        close(MAIL);

        exit;    # end forked child process
        ## END - child process
    }
    else {

        exit;    # end forked child process
        ## END - child process

    }
}
