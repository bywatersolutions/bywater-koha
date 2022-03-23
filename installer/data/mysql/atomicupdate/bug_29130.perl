$DBversion = 'XXX'; # will be replaced by the RM
if( CheckVersion( $DBversion ) ) {
    $dbh->do("CREATE TABLE tmp_holdsqueue_builder LIKE tmp_holdsqueue");
    $dbh->do("CREATE TABLE hold_fill_targets_builder LIKE hold_fill_targets");

    # Always end with this (adjust the bug info)
    NewVersion( $DBversion, 29130, "Create temp tables for holds queue builder");
}
