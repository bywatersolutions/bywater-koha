$DBversion = 'XXX';
if( CheckVersion( $DBversion ) ) {
    unless( column_exists('categories', 'password_expiry_days') ){
        $dbh->do(q{
            ALTER TABLE categories ADD password_expiry_days SMALLINT(5) NULL DEFAULT NULL AFTER enrolmentperioddate
        });
    }
    unless( column_exists('borrowers', 'password_expiration_date') ){
        $dbh->do(q{
            ALTER TABLE borrowers ADD password_expiration_date DATE NULL DEFAULT NULL AFTER dateexpiry
        });
    }
    unless( column_exists('deletedborrowers', 'password_expiration_date') ){
        $dbh->do(q{
            ALTER TABLE deletedborrowers ADD password_expiration_date DATE NULL DEFAULT NULL AFTER dateexpiry
        });
    }
    NewVersion( $DBversion, 29924, "Add password expiration");
}
