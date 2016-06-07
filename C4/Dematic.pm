package C4::Dematic;

# Copyright 2016
# Lee Jamison
# Marywood University
#
# This file is independent from Koha
#
# Koha is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Koha is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Koha; if not, see <http://www.gnu.org/licenses>.
use strict;

use Carp;
use C4::Context;
use C4::Items;
use Koha::Database;
use DateTime::Format::MySQL;
use Koha::DateUtils qw/dt_from_string/;
use IO::Socket::INET;

use vars qw($VERSION @ISA @EXPORT);

BEGIN {
    $VERSION = 1.00.00.000;

    require Exporter;
    @ISA = qw( Exporter );

    # function exports
    @EXPORT = qw(
      check_if_exists
      ADDI
      DELI
      RETI
      REQI
      emsLog
    );
}

my $handle;

my $dbhandler = C4::Context->dbh;
$dbhandler->do( "
    CREATE TABLE IF NOT EXISTS ems_transaction_logs(
        transactionID BIGINT NOT NULL AUTO_INCREMENT,
        barcode VARCHAR(20) NOT NULL,
        transactionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        transactionType VARCHAR(4),
        comments VARCHAR(255),
        PRIMARY KEY (transactionID)
    )
" );

my $dbhand = C4::Context->dbh;
$dbhand->do( "
    CREATE TABLE IF NOT EXISTS ems_returned(
        transactionID INT NOT NULL AUTO_INCREMENT,
        barcode VARCHAR(20) NOT NULL,
        timeReturned TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        comments VARCHAR(255),
        PRIMARY KEY (transactionID)
    )
" );

sub check_if_exists {

    my ($barcode) = @_;

    my $dbh = C4::Context->dbh;

    my $sth = $dbh->prepare( "
        SELECT *
        FROM ems_transaction_logs
        WHERE barcode = ? AND transactionType = 'REQI'
    " );
    $sth->execute($barcode);

    my $results = 0;

    while ( defined( $sth->fetchrow_arrayref ) ) {
        ++$results;
    }

    if ( $results > 0 ) {
        return 1;
    }
    else {
        return 0;
    }

}

=head1 NAME

C4::Dematic - Dematic AS/RS ILS connection functions

=head1 DESCRIPTION

This module contains an API for communicating with
the Dematic Automated Storage/Retrieval System (AS/RS)
and is used by cataloguing and circulation.

This module is primarily intended for use when a new item is created (C<ADDI>), 
deleted (C<DELI>), checked in (C<RETI>), or when a user places a hold 
on an item which is located in an AS/RS item location (C<REQI>).

Additionally, this module interacts with the C<DematicStatServer> to handle
response communications from the AS/RS server.

=head1 CORE EXPORTED FUNCTIONS

The following functions are meant for use by users of C<C4::Dematic>

=cut

=head2 send

&send($handle, $msg);

Processes C<send> socket communications. Retries if connection failed 
on first attempt.

=cut

sub send {
    my ($request_message) = @_;
    local $@;

    eval { $handle->send($request_message); };

    print 'Crash: ' . $@ if $@;

    if ($@) {
        $handle->close();
        $handle = initConnection();
        eval { $handle->send($request_message); };
    }
}

=head2 recv

$response = &recv();

Receives socket response initiated by the C<send> function and 
returns it to the caller.

=cut

sub recv {
    my $msg = " ";

    eval {
        local $SIG{ALRM} = sub { die 'Timed Out'; };
        alarm 10;    # set timeout on waiting for reply
        $handle->recv( $msg, 12000 );
        alarm 0;
    };
    alarm 0;
    if ( $@ && $@ =~ /Timed Out/ ) {
        return "";
    }

    # Log action

    return $msg;
}

=head2 initConnection

$connected = initConnection($host, $port);

Creates TCP socket connection to AS/RS to transmit messages. Returns C<$handle>.

=cut

sub initConnection {

    # Socket Connection initializations
    my $host = '192.159.104.202';
    my $port = '8010';
    my $handle;

    # create a TCP connection to the specified host and port
    $handle = IO::Socket::INET->new(
        Proto    => 'tcp',
        PeerAddr => $host,
        PeerPort => $port
    ) or $handle = 0;    # die "can't connect to port $port on $host: $!";

    if ( $handle != 0 ) {
        $handle->autoflush(1);    # so output gets there right away
    }
    else {
        # Log failure
    }
    return $handle;
}

=head2 sendRequest

&sendRequest($request_message);

Wrapper for C<send> function. Applies C<$handle> socket connection 
and passes it to C<send> for processing.

=cut

sub sendRequest() {
    my ( $handle, $msg ) = @_;
    &send( $handle, $msg );
}

=head2 ADDI

ADDI(@barcode);

Adds an item into the AS/RS database. Accepts a barcode as 
an argument and transmits the item's barcode, Call Number, 
Author, and Title to the AS/RS database.

=cut

sub ADDI {
    my ($barcode) = @_;

    my $dbh = C4::Context->dbh;

    # Request message initializations
    my $sequence_number = '00001';

    unless ($barcode) {
        croak "FAILED ADDI() - no barcode supplied";
    }

    my $callNumber = "";
    my $author;
    my $title;

    # DBI result scalars
    my $dbi_barcode;       # item barcode
    my $dbi_callNumber;    # item call number
    my $dbi_author;        # item author
    my $dbi_title;         # item title

    my $sth;               # DBI Statement Handler

    $sth = $dbh->prepare( "
        SELECT
            items.barcode,
            items.itemcallnumber,
            biblio.author,
            biblio.title
        FROM
            items
        INNER JOIN biblio
            ON biblio.biblionumber = items.biblionumber
        WHERE items.barcode = ?
    " );
    $sth->execute($barcode);

    # Associate scalar variables with each output column
    $sth->bind_col( 1, \$dbi_barcode );
    $sth->bind_col( 2, \$dbi_callNumber );
    $sth->bind_col( 3, \$dbi_author );
    $sth->bind_col( 4, \$dbi_title );

    # DBI results assignment to EMS scalars
    while ( $sth->fetch ) {
        $barcode    = $dbi_barcode;
        $callNumber = $dbi_callNumber;
        $author     = $dbi_author;
        $title      = $dbi_title;
    }

    # Transmit item to AS/RS
    $handle = initConnection();

    if ( !$handle ) {
        emsLog( $barcode, "ADDI", "Error! Could not connect! $!" );
    }
    else {
        # Item ID + Call Num + Author + Title + Height + Configuration
        my $msglength = 20 + 70 + 70 + 70 + 5 + 1;
        my $space5    = "     ";
        my $space1    = " ";
        my $request_msg =
          sprintf( "%sADDI%05d%-20.20s%-70.70s%-70.70s%-70.70s%s%s",
            $sequence_number, $msglength, $barcode, $callNumber, $author,
            $title, $space5, $space1 );

        unless ( $sequence_number == '99999' ) {
            $sequence_number++;
        }
        else {
            $sequence_number = '00001';
        }

        &sendRequest($request_msg);
        my $resp_msg = &recv();
        if ( $resp_msg =~ /RSNR0000500000/ ) {
            emsLog( $barcode, "ADDI", "$barcode has been added - $resp_msg" );
        }
        elsif ( $resp_msg =~ /RSNR0000500006/ ) {
            emsLog( $barcode, "ADDI",
                "$barcode has a bad item number - $resp_msg" );
        }
        elsif ( $resp_msg =~ /RSNR0000500008/ ) {
            emsLog( $barcode, "ADDI",
                "$barcode is already in EMS database - $resp_msg" );
        }
        else {
            # Try again!
            $handle = initConnection();
            &sendRequest($request_msg);
            my $resp_msg = &recv();
            if ( $resp_msg !~ /RSNR0000500000/ ) {
                emsLog( $barcode, "ADDI", "Error with $barcode - $resp_msg" );
            }
        }
        $handle->close();
    }
}

=head2 DELI

DELI($barcode);

Accepts a barcode as an argument and deletes the item 
from the AS/RS database.

=cut

sub DELI {
    my ($barcode) = @_;

    # Request message initializations
    my $sequence_number = '00001';

    unless ($barcode) {
        croak "FAILED DELI() - no barcode supplied";
    }

    $handle = initConnection();

    if ( !$handle ) {
        emsLog( $barcode, "DELI", "Error! Could not connect! $!" );
    }
    else {
        my $msglength   = 20;                              #Item ID
        my $space5      = "     ";
        my $space1      = " ";
        my $request_msg = sprintf( "%sDELI%05d%-20.20s",
            $sequence_number, $msglength, $barcode );

        unless ( $sequence_number == '99999' ) {
            $sequence_number++;
        }
        else {
            $sequence_number = '00001';
        }

        &sendRequest($request_msg);
        my $resp_msg = &recv();
        if ( $resp_msg =~ /RSNR0000500000/ ) {
            emsLog( $barcode, "DELI",
                "$barcode has been deleted from EMS - $resp_msg" );
        }
        elsif ( $resp_msg =~ /RSNR0000500001/ ) {
            emsLog( $barcode, "DELI",
                "$barcode has already been committed to work - $resp_msg" );
        }
        elsif ( $resp_msg =~ /RSNR0000500003/ ) {
            emsLog( $barcode, "DELI",
                "$barcode is NOT in EMS database - $resp_msg" );
        }
        elsif ( $resp_msg =~ /RSNR0000500009/ ) {
            emsLog( $barcode, "DELI", "$barcode is stored - $resp_msg" );
        }
        elsif ( $resp_msg =~ /RSNR0000500010/ ) {
            logaction(
                "REPORTS", "DELETE",
                "",        "$barcode is in a Locked location, $resp_msg"
            );

            # &LogIt("$barcode is in a Locked location, $resp_msg");
            emsLog( $barcode, "DELI",
                "$barcode is in a Locked location, $resp_msg" );
        }
        else {
            # Try again!
            $handle = initConnection();
            &sendRequest($request_msg);
            my $resp_msg = &recv();
            if ( $resp_msg !~ /RSNR0000500000/ ) {
                emsLog( $barcode, "DELI", "Error with $barcode, $resp_msg" );
            }
        }
        $handle->close();
    }
}

=head2 RETI

RETI($barcode);

Accepts a barcode as a parameter and signals 
the AS/RS database that an item has been returned 
and to anticipate the item to be stored.

=cut

sub RETI {
    my ($barcode) = @_;

    # REQI to delete a request record after being checked in
    emsLogDelete($barcode, "REQI"); 

    emsReturned($barcode);
}

=head2 REQI

REQI($reserve_id);

Accepts a Reserve ID from the B<Reserves> table.

=cut

sub REQI {
    my ($reserve_id) = @_;

    my $sequence_number = '00001';

    # EMS scalars
    my $priorityFlag   = "N";            # required EMS priority flag
    my $pickupLocation = "MARYWOODU";    # default EMS pickup location
    my $patronNumber;                    # Patron card number
    my $patronName;                      #

    my $dbh = C4::Context->dbh;
    my $sth;                             # DBI Statement Handler

    my $barcode;
    my $dbi_barcode;                     # item barcode
    my $dbi_cardnumber;                  # patron card number
    my $dbi_lastname;                    # patron last name
    my $dbi_firstname;                   # patron first name

    # Query Koha 'reserves' table for barcode,
    # patron card number, patron last name,
    # and patron first name where reserves.reserve_id = $reserve_id
    $sth = $dbh->prepare( "
        SELECT
            reserves.reserve_id,
            reserves.borrowernumber,
            biblio.biblionumber,
            items.barcode,
            borrowers.borrowernumber,
            borrowers.cardnumber,
            borrowers.surname,
            borrowers.firstname
        FROM
            reserves
        INNER JOIN borrowers
            ON borrowers.borrowernumber = reserves.borrowernumber
        INNER JOIN biblio
            ON biblio.biblionumber = reserves.biblionumber
        INNER JOIN items
            ON items.biblionumber = biblio.biblionumber
        WHERE reserves.reserve_id = $reserve_id
    " );
    $sth->execute();

    ## Assign scalars with each output column
    $sth->bind_col( 4, \$dbi_barcode );
    $sth->bind_col( 6, \$dbi_cardnumber );
    $sth->bind_col( 7, \$dbi_lastname );
    $sth->bind_col( 8, \$dbi_firstname );

    while ( $sth->fetch ) {
        $barcode      = $dbi_barcode;
        $patronNumber = $dbi_cardnumber;
        $patronName   = $dbi_lastname . ', ' . $dbi_firstname;
    }
    $sth->finish;

    my $itemDetail = C4::Items::GetItem( undef, $dbi_barcode );
    my $itemLocation = $itemDetail->{location};
    emsLog( $dbi_barcode, 'REQI',
        "Item location (using dbi_barcode) - $itemLocation" );
    emsLog( $barcode, 'REQI', "Item location (using barcode) - $itemLocation" );
    unless ( $itemLocation eq 'ARCHITECH'
        || $itemLocation eq 'CURR-LIB'
        || $itemLocation eq 'MARKET_PL'
        || $itemLocation eq '' )
    {
        $sth = $dbh->prepare( "
            INSERT INTO ems_transaction_logs (barcode, transactionTime, transactionType) 
            VALUES (?, now(), ?)
        " );
        $sth->execute( $barcode, "REQI" );
        $sth->finish;

        $handle = initConnection();

        if ( !$handle ) {
            emsLog( $dbi_barcode, "REQI", "Could not connect! $!" );
        }
        else {
            my $msglength =
              20 + 1 + 20 + 20 +
              40; # Barcode Number + Priority + Pickup + Patron ID + Patron Name

            my $request_msg = sprintf(
                "%sREQI%05d%-20.20s%-1.1s%-20.20s%-20.20s%-40.40s",
                $sequence_number, $msglength,      $barcode,
                $priorityFlag,    $pickupLocation, $patronNumber,
                $patronName
            );

            unless ( $sequence_number == '99999' ) {
                $sequence_number++;
            }
            else {
                $sequence_number = '00001';
            }

            &sendRequest($request_msg);

            my $resp_msg = &recv();

            if ( $resp_msg !~ /RSNR0000500000/ ) {

                # Try again!
                $handle = initConnection();

                &sendRequest($request_msg);

                my $resp_msg = &recv();

                if ( $resp_msg !~ /RSNR0000500000/ ) {

                    if ( $resp_msg =~ /RSNR0000500001/ ) {
                        emsLog( $dbi_barcode, "REQI",
                            "$barcode has already been committed to work - $resp_msg"
                        );
                    }
                    elsif ( $resp_msg =~ /RSNR0000500002/ ) {
                        emsLog( $dbi_barcode, "REQI",
                            "$barcode is checked out of container - $resp_msg"
                        );
                    }
                    elsif ( $resp_msg =~ /RSNR0000500003/ ) {
                        emsLog( $dbi_barcode, "REQI",
                            "$barcode is not in EMS database - $resp_msg" );
                    }
                    elsif ( $resp_msg =~ /RSNR0000500004/ ) {
                        emsLog( $dbi_barcode, "REQI",
                            "$barcode is missing - $resp_msg" );
                    }
                    elsif ( $resp_msg =~ /RSNR0000500005/ ) {
                        emsLog( $dbi_barcode, "REQI",
                            "$barcode has NOT been returned - $resp_msg" );
                    }
                    elsif ( $resp_msg =~ /RSNR0000500010/ ) {
                        emsLog( $dbi_barcode, "REQI",
                            "$barcode is in Locked location - $resp_msg" );
                    }
                    elsif ( $resp_msg =~ /RSNR0000500011/ ) {
                        emsLog( $dbi_barcode, "REQI",
                            "Work request for $barcode was deleted before completion - $resp_msg"
                        );
                    }
                }    # end if/else for /RSNR0000500000/
            }
            $handle->close();
        }
    }    # end - else ($itemLocation)
}

sub emsLog {
    my ( $barcode, $transactionType, $message ) = @_;

    my $dbh = C4::Context->dbh;
    my $sth = $dbh->prepare("
        INSERT INTO ems_transaction_logs (barcode, transactionTime, transactionType, comments)
        VALUES (?, now(), ?, ?)
    ");
    $sth->execute( $barcode, $transactionType, $message );
    $sth->finish;

}

sub emsLogDelete {

    my ( $barcode, $transactionType ) = @_;

    my $dbh = C4::Context->dbh;
    my $sth;
    my $dbi_transactID;
    my $transactID;

    $sth = $dbh->prepare("
        SELECT MAX(transactionID) FROM ems_transaction_logs 
        WHERE barcode = ? AND transactionType = ?
    ");
    $sth->execute( $barcode, $transactionType );

    ## Assign value of result column(s) to scalar
    $sth->bind_col( 1, \$dbi_transactID );

    while ( $sth->fetch ) {
        $transactID = $dbi_transactID;
    }
    $sth->finish;

    $sth = $dbh->prepare("
        DELETE FROM ems_transaction_logs WHERE transactionID = ?
    ");
    $sth->execute($transactID);
    $sth->finish;

}

sub emsReturned {
    my ($barcode) = @_;

    my $dbh = C4::Context->dbh;
    my $sth = $dbh->prepare("
        INSERT INTO ems_returned ( barcode, timeReturned ) VALUES ( ?, NOW() )
    ");
    $sth->execute($barcode);
    $sth->finish;
}
1;
