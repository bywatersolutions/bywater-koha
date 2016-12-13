use utf8;
package Koha::Schema::Result::LabelsTemplate;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::LabelsTemplate

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<labels_templates>

=cut

__PACKAGE__->table("labels_templates");

=head1 ACCESSORS

=head2 tmpl_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 tmpl_code

  data_type: 'char'
  default_value: (empty string)
  is_nullable: 1
  size: 100

=head2 tmpl_desc

  data_type: 'char'
  default_value: (empty string)
  is_nullable: 1
  size: 100

=head2 page_width

  data_type: 'float'
  default_value: 0
  is_nullable: 1

=head2 page_height

  data_type: 'float'
  default_value: 0
  is_nullable: 1

=head2 label_width

  data_type: 'float'
  default_value: 0
  is_nullable: 1

=head2 label_height

  data_type: 'float'
  default_value: 0
  is_nullable: 1

=head2 topmargin

  data_type: 'float'
  default_value: 0
  is_nullable: 1

=head2 leftmargin

  data_type: 'float'
  default_value: 0
  is_nullable: 1

=head2 cols

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 rows

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 colgap

  data_type: 'float'
  default_value: 0
  is_nullable: 1

=head2 rowgap

  data_type: 'float'
  default_value: 0
  is_nullable: 1

=head2 active

  data_type: 'integer'
  is_nullable: 1

=head2 units

  data_type: 'char'
  default_value: 'PX'
  is_nullable: 1
  size: 20

=head2 fontsize

  data_type: 'integer'
  default_value: 3
  is_nullable: 0

=head2 font

  data_type: 'char'
  default_value: 'TR'
  is_nullable: 0
  size: 10

=cut

__PACKAGE__->add_columns(
  "tmpl_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "tmpl_code",
  { data_type => "char", default_value => "", is_nullable => 1, size => 100 },
  "tmpl_desc",
  { data_type => "char", default_value => "", is_nullable => 1, size => 100 },
  "page_width",
  { data_type => "float", default_value => 0, is_nullable => 1 },
  "page_height",
  { data_type => "float", default_value => 0, is_nullable => 1 },
  "label_width",
  { data_type => "float", default_value => 0, is_nullable => 1 },
  "label_height",
  { data_type => "float", default_value => 0, is_nullable => 1 },
  "topmargin",
  { data_type => "float", default_value => 0, is_nullable => 1 },
  "leftmargin",
  { data_type => "float", default_value => 0, is_nullable => 1 },
  "cols",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "rows",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "colgap",
  { data_type => "float", default_value => 0, is_nullable => 1 },
  "rowgap",
  { data_type => "float", default_value => 0, is_nullable => 1 },
  "active",
  { data_type => "integer", is_nullable => 1 },
  "units",
  { data_type => "char", default_value => "PX", is_nullable => 1, size => 20 },
  "fontsize",
  { data_type => "integer", default_value => 3, is_nullable => 0 },
  "font",
  { data_type => "char", default_value => "TR", is_nullable => 0, size => 10 },
);

=head1 PRIMARY KEY

=over 4

=item * L</tmpl_id>

=back

=cut

__PACKAGE__->set_primary_key("tmpl_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-12-13 08:38:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KuCl1qnRiOHeLIytDN16FA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
