use Modern::Perl;

return {
    bug_number => "29130",
    description => "Create temp tables for holds queue builder",
    up => sub {
        my ($args) = @_;
        my ($dbh, $out) = @$args{qw(dbh out)};
        $dbh->do("CREATE TABLE tmp_holdsqueue_builder LIKE tmp_holdsqueue");
        $dbh->do("CREATE TABLE hold_fill_targets_builder LIKE hold_fill_targets");
    },
}
