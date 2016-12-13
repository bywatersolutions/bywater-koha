use utf8;
package Koha::Schema::Result::Printer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::Printer

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<printers>

=cut

__PACKAGE__->table("printers");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 queue

  data_type: 'text'
  is_nullable: 1

=head2 type

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "queue",
  { data_type => "text", is_nullable => 1 },
  "type",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-12-13 08:38:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NvCCPErehjpUTzX5UTdTiw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
