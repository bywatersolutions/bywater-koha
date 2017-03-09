use utf8;
package Koha::Schema::Result::AuthorisedValuesBranch;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::AuthorisedValuesBranch

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<authorised_values_branches>

=cut

__PACKAGE__->table("authorised_values_branches");

=head1 ACCESSORS

=head2 av_id

  data_type: 'integer'
  is_nullable: 1

=head2 branchcode

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "av_id",
  { data_type => "integer", is_nullable => 1 },
  "branchcode",
  { data_type => "varchar", is_nullable => 1, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2017-03-09 08:13:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:96P2bgxK4lS0PvK3Ii4svg

__PACKAGE__->set_primary_key(__PACKAGE__->columns);

1;
