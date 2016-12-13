use utf8;
package Koha::Schema::Result::PrintersProfileTmp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::PrintersProfileTmp

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<printers_profile_tmp>

=cut

__PACKAGE__->table("printers_profile_tmp");

=head1 ACCESSORS

=head2 profile_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 printer_name

  data_type: 'varchar'
  default_value: 'Default Printer'
  is_nullable: 0
  size: 40

=head2 template_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 paper_bin

  data_type: 'varchar'
  default_value: 'Bypass'
  is_nullable: 0
  size: 20

=head2 offset_horz

  data_type: 'float'
  default_value: 0
  is_nullable: 0

=head2 offset_vert

  data_type: 'float'
  default_value: 0
  is_nullable: 0

=head2 creep_horz

  data_type: 'float'
  default_value: 0
  is_nullable: 0

=head2 creep_vert

  data_type: 'float'
  default_value: 0
  is_nullable: 0

=head2 units

  data_type: 'char'
  default_value: 'POINT'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
  "profile_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "printer_name",
  {
    data_type => "varchar",
    default_value => "Default Printer",
    is_nullable => 0,
    size => 40,
  },
  "template_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "paper_bin",
  {
    data_type => "varchar",
    default_value => "Bypass",
    is_nullable => 0,
    size => 20,
  },
  "offset_horz",
  { data_type => "float", default_value => 0, is_nullable => 0 },
  "offset_vert",
  { data_type => "float", default_value => 0, is_nullable => 0 },
  "creep_horz",
  { data_type => "float", default_value => 0, is_nullable => 0 },
  "creep_vert",
  { data_type => "float", default_value => 0, is_nullable => 0 },
  "units",
  { data_type => "char", default_value => "POINT", is_nullable => 0, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</profile_id>

=back

=cut

__PACKAGE__->set_primary_key("profile_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<printername>

=over 4

=item * L</printer_name>

=item * L</template_id>

=item * L</paper_bin>

=back

=cut

__PACKAGE__->add_unique_constraint("printername", ["printer_name", "template_id", "paper_bin"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-12-13 08:38:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aYbwf6ldNnokC94F9v+j3Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
