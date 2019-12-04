#!/usr/bin/perl

# Tests for SIP::ILS::Transaction
# Current state is very rudimentary. Please help to extend it!

use Modern::Perl;
use Test::More tests => 5;

use Koha::Database;
use t::lib::TestBuilder;
use t::lib::Mocks;
use C4::SIP::ILS::Patron;
use C4::SIP::ILS::Transaction::RenewAll;
use C4::SIP::ILS::Transaction::Checkout;
use C4::SIP::ILS::Transaction::Hold;

use C4::Reserves;
use Koha::IssuingRules;

my $schema = Koha::Database->new->schema;
$schema->storage->txn_begin;

my $builder = t::lib::TestBuilder->new();
my $borr1 = $builder->build({ source => 'Borrower' });
my $card = $borr1->{cardnumber};
my $sip_patron = C4::SIP::ILS::Patron->new( $card );

# Create transaction RenewAll, assign patron, and run (no items)
my $transaction = C4::SIP::ILS::Transaction::RenewAll->new();
is( ref $transaction, "C4::SIP::ILS::Transaction::RenewAll", "New transaction created" );
is( $transaction->patron( $sip_patron ), $sip_patron, "Patron assigned to transaction" );
isnt( $transaction->do_renew_all, undef, "RenewAll on zero items" );

subtest fill_holds_at_checkout => sub {
    plan tests => 6;


    my $category = $builder->build({ source => 'Category', value => { category_type => 'A' }});
    my $branch   = $builder->build({ source => 'Branch' });
    my $borrower = $builder->build({ source => 'Borrower', value =>{
        branchcode => $branch->{branchcode},
        categorycode=>$category->{categorycode}
        }
    });
    t::lib::Mocks::mock_userenv({ branchcode => $branch->{branchcode}, flags => 1 });

    my $itype = $builder->build({ source => 'Itemtype', value =>{notforloan=>0} });
    my $biblio = $builder->build({ source => 'Biblio' });
    my $biblioitem = $builder->build({ source => 'Biblioitem', value=>{biblionumber=>$biblio->{biblionumber}} });
    my $item1 = $builder->build({ source => 'Item', value => {
        barcode       => 'barcode4test',
        homebranch    => $branch->{branchcode},
        holdingbranch => $branch->{branchcode},
        biblionumber  => $biblio->{biblionumber},
        itype         => $itype->{itemtype},
        notforloan       => 0,
        }
    });
    my $item2 = $builder->build({ source => 'Item', value => {
        homebranch    => $branch->{branchcode},
        holdingbranch => $branch->{branchcode},
        biblionumber  => $biblio->{biblionumber},
        itype         => $itype->{itemtype},
        notforloan       => 0,
        }
    });

    Koha::IssuingRule->new({
        categorycode     => $borrower->{categorycode},
        itemtype         => $itype->{itemtype},
        branchcode       => $branch->{branchcode},
        onshelfholds     => 1,
        reservesallowed  => 3,
        holds_per_record => 3,
        issuelength      => 5,
        lengthunit       => 'days',
    })->store;

    my $reserve1 = AddReserve($branch->{branchcode},$borrower->{borrowernumber},$biblio->{biblionumber});
    my $reserve2 = AddReserve($branch->{branchcode},$borrower->{borrowernumber},$biblio->{biblionumber});
    my $bib = Koha::Biblios->find( $biblio->{biblionumber} );
    is( $bib->holds->count(), 2, "Bib has 2 holds");

    my $sip_patron = C4::SIP::ILS::Patron->new( $borrower->{cardnumber} );
    my $sip_item   = C4::SIP::ILS::Item->new( $item1->{barcode} );
    my $transaction = C4::SIP::ILS::Transaction::Checkout->new();
    is( ref $transaction, "C4::SIP::ILS::Transaction::Checkout", "New transaction created" );
    is( $transaction->patron( $sip_patron ), $sip_patron, "Patron assigned to transaction" );
    is( $transaction->item( $sip_item ), $sip_item, "Item assigned to transaction" );
    my $checkout = $transaction->do_checkout();
    use Data::Dumper; # Temporary debug statement
    is( $bib->holds->count(), 1, "Bib has 1 holds remaining") or diag Dumper $checkout;

    t::lib::Mocks::mock_preference('itemBarcodeInputFilter', 'whitespace');
    $sip_item   = C4::SIP::ILS::Item->new( ' barcode 4 test ');
    $transaction = C4::SIP::ILS::Transaction::Checkout->new();
    is( $sip_item->{barcode}, $item1->{barcode}, "Item assigned to transaction" );
};

subtest cancel_hold => sub {
    plan tests => 7;

    my $library = $builder->build_object ({ class => 'Koha::Libraries' });
    my $patron = $builder->build_object(
        {
            class => 'Koha::Patrons',
            value => {
                branchcode => $library->branchcode,
            }
        }
    );
    t::lib::Mocks::mock_userenv({ branchcode => $library->branchcode, flags => 1 });

    my $item = $builder->build_sample_item({
        library       => $library->branchcode,
    });

    Koha::IssuingRule->new({
        categorycode     => $patron->categorycode,
        itemtype         => $item->effective_itemtype,
        branchcode       => $library->branchcode,
        onshelfholds     => 1,
        reservesallowed  => 3,
        holds_per_record => 3,
        issuelength      => 5,
        lengthunit       => 'days',
    })->store;

    my $reserve1 =
      AddReserve( $library->branchcode, $patron->borrowernumber,
        $item->biblio->biblionumber,
        undef, undef, undef, undef, undef, undef, $item->itemnumber );
    is( $item->biblio->holds->count(), 1, "Hold was placed on bib");
    is( Koha::Holds->search({itemnumber=>$item->itemnumber})->count() ,1,"Hold was placed on specific item");

    my $sip_patron = C4::SIP::ILS::Patron->new( $patron->cardnumber );
    my $sip_item   = C4::SIP::ILS::Item->new( $item->barcode );
    my $transaction = C4::SIP::ILS::Transaction::Hold->new();
    is( ref $transaction, "C4::SIP::ILS::Transaction::Hold", "New transaction created" );
    is( $transaction->patron( $sip_patron ), $sip_patron, "Patron assigned to transaction" );
    is( $transaction->item( $sip_item ), $sip_item, "Item assigned to transaction" );
    my $hold = $transaction->drop_hold();
    is( $item->biblio->holds->count(), 0, "Bib has 0 holds remaining");
    is( Koha::Holds->search({itemnumber=>$item->itemnumber})->count(), 0,  "Item has 0 holds remaining");
};

$schema->storage->txn_rollback;
