# Executes the actual Perl script
# The '&' puts the process into the background (as a daemon)
# EMSServer.pm acts as a socket server to accept messages
# from Marywood's EMS server

## Change path as necessary to file's actual location
perl /usr/share/koha/lib/C4/EMSServer.pm & # ampersand used to initiate module as a background process