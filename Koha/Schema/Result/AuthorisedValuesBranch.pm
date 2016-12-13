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
  is_nullable: 0

=head2 branchcode

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=cut

__PACKAGE__->add_columns(
  "av_id",
  { data_type => "integer", is_nullable => 0 },
  "branchcode",
  { data_type => "varchar", is_nullable => 0, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-12-13 08:38:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HQRBnRppIkYNVRr5uE0dVg

__PACKAGE__->set_primary_key(__PACKAGE__->columns);

1;
