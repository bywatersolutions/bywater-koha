use utf8;
package Koha::Schema::Result::LabelsProfile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::LabelsProfile

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<labels_profile>

=cut

__PACKAGE__->table("labels_profile");

=head1 ACCESSORS

=head2 tmpl_id

  data_type: 'integer'
  is_nullable: 0

=head2 prof_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "tmpl_id",
  { data_type => "integer", is_nullable => 0 },
  "prof_id",
  { data_type => "integer", is_nullable => 0 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<prof_id>

=over 4

=item * L</prof_id>

=back

=cut

__PACKAGE__->add_unique_constraint("prof_id", ["prof_id"]);

=head2 C<tmpl_id>

=over 4

=item * L</tmpl_id>

=back

=cut

__PACKAGE__->add_unique_constraint("tmpl_id", ["tmpl_id"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-12-13 08:38:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yxjsSezlj17Hok0b1N/zfQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
