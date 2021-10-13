$DBversion = 'XXX';
if( CheckVersion( $DBversion ) ) {
    $dbh->do("CREATE TABLE tmp_holdsqueue_builder LIKE tmp_holdsqueue");
    $dbh->do("CREATE TABLE hold_fill_targets_builder LIKE hold_fill_targets");
    NewVersion( $DBversion, 29130, "Holds queue is empty while holds queue builder is running");
}
