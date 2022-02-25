$DBversion = 'XXX'; # will be replaced by the RM
if( CheckVersion( $DBversion ) ) {
    $dbh->do(q{
        INSERT IGNORE INTO systempreferences ( `variable`, `value`, `options`, `explanation`, `type` ) VALUES
        ('EnableExpiredPasswordReset', '0', NULL, 'Enable ability for patrons with expired password to reset their password directly', 'YesNo')
    });
    NewVersion( $DBversion, 29925, "Add EnableExpirePasswordReset system preference");
}
