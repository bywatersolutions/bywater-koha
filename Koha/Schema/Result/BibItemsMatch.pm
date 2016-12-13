use utf8;
package Koha::Schema::Result::BibItemsMatch;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::BibItemsMatch - Temporary stage for item matching with bib records

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<bib_items_match>

=cut

__PACKAGE__->table("bib_items_match");

=head1 ACCESSORS

=head2 ID

  accessor: 'id'
  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 biblionumber

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 biblioitemnumber

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 barcode

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 itemcallnumber

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 title

  data_type: 'mediumtext'
  is_nullable: 0

=head2 OCLC

  accessor: 'oclc'
  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "ID",
  {
    accessor          => "id",
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
  },
  "biblionumber",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "biblioitemnumber",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "barcode",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "itemcallnumber",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "title",
  { data_type => "mediumtext", is_nullable => 0 },
  "OCLC",
  { accessor => "oclc", data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</ID>

=back

=cut

__PACKAGE__->set_primary_key("ID");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-12-13 08:38:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:q/FzJbFZby0aN2ZTjc3eRg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
