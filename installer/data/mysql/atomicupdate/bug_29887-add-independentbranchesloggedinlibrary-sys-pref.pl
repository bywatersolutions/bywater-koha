use Modern::Perl;

return {
    bug_number => "29887",
    description => "Add system preference IndependentBranchesLoggedInLibrary",
    up => sub {
        my ($args) = @_;
        my ($dbh, $out) = @$args{qw(dbh out)};
        # Do you stuffs here
        $dbh->do(q{
            INSERT IGNORE INTO systempreferences ( `variable`, `value`, `options`, `explanation`, `type` )
        SELECT 'IndependentBranchesLoggedInLibrary', value, NULL, 'Prevent non-superlibrarians from switching logged in locations','YesNo'
        FROM systempreferences WHERE variable = 'IndependentBranches'
        });
        # Print useful stuff here
        say $out "Bug 29887 database update finished";
    },
}
