package Koha::IssuingRule;

# Copyright Vaara-kirjastot 2015
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Koha; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

use Modern::Perl;
use Koha::Database;
use base qw(Koha::Object);

=head1 NAME

Koha::Hold - Koha Hold object class

=head1 API

=head2 Class Methods

=cut

=head3 delete

=cut

sub delete {
    my ($self) = @_;

    my $branchcode = $self->branchcode eq '*' ? undef : $self->branchcode;
    my $categorycode = $self->categorycode eq '*' ? undef : $self->categorycode;
    my $itemtype = $self->itemtype eq '*' ? undef : $self->itemtype;

    Koha::CirculationRules->search({
        branchcode   => $branchcode,
        itemtype     => $itemtype,
        categorycode => $categorycode,
    })->delete;

    $self->SUPER::delete;

}

=head3 type

=cut

sub _type {
    return 'Issuingrule';
}

1;
