use Modern::Perl;
use Koha::Installer::Output qw(say_success);

return {
    bug_number  => "42489",
    description => "Add RealTimeHoldsQueueUnallocated system preference",
    up          => sub {
        my ($args) = @_;
        my ( $dbh, $out ) = @$args{qw(dbh out)};

        $dbh->do(
            q{
            INSERT IGNORE INTO systempreferences (variable, value, options, explanation, type)
            VALUES ('RealTimeHoldsQueueUnallocated', '0', NULL,
                'If ON, the real time holds queue will only process unallocated holds instead of rebuilding the entire queue for the affected biblio',
                'YesNo')
        }
        );

        say_success( $out, "Added new system preference 'RealTimeHoldsQueueUnallocated'" );
    },
};
