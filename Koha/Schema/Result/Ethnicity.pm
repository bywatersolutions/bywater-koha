use utf8;
package Koha::Schema::Result::Ethnicity;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::Ethnicity

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<ethnicity>

=cut

__PACKAGE__->table("ethnicity");

=head1 ACCESSORS

=head2 code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 10

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "code",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 10 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</code>

=back

=cut

__PACKAGE__->set_primary_key("code");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-12-13 08:38:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H68b4WL+gNJTbfOyuMEc8g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
