use utf8;
package Koha::Schema::Result::TempDedupe;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::TempDedupe

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<temp_dedupe>

=cut

__PACKAGE__->table("temp_dedupe");

=head1 ACCESSORS

=head2 entry_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 biblionumber

  data_type: 'integer'
  is_nullable: 0

=head2 normal_data

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "entry_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "biblionumber",
  { data_type => "integer", is_nullable => 0 },
  "normal_data",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</entry_id>

=back

=cut

__PACKAGE__->set_primary_key("entry_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-12-13 08:38:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fn7VRhQtWyqrApmd7z+7WQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
