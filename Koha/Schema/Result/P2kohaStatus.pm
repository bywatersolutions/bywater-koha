use utf8;
package Koha::Schema::Result::P2kohaStatus;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::P2kohaStatus - Support table to convert P6 Status to the correct Koha autho

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<p2koha_status>

=cut

__PACKAGE__->table("p2koha_status");

=head1 ACCESSORS

=head2 p6_status

  data_type: 'varchar'
  is_nullable: 0
  size: 2

=head2 koha_dest

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 authorised_value

  data_type: 'varchar'
  is_nullable: 0
  size: 80

=cut

__PACKAGE__->add_columns(
  "p6_status",
  { data_type => "varchar", is_nullable => 0, size => 2 },
  "koha_dest",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "authorised_value",
  { data_type => "varchar", is_nullable => 0, size => 80 },
);

=head1 PRIMARY KEY

=over 4

=item * L</p6_status>

=back

=cut

__PACKAGE__->set_primary_key("p6_status");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-12-13 08:38:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e6R8oEjnHcwmvzkkXZIM4Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
