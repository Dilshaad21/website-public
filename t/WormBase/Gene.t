# t/WormBase/APIPluggable::Factory.t

use strict;
use warnings;

use Test::More tests => 7;

use WormBase::APIPluggable;

# Test object construction.
# Object construction also connects to sgifaceserver at localhost::2005
ok ( 
    ( my $wormbase = WormBase::APIPluggable->new()),
    'Constructed WormBase::APIPluggable object ok'
    );

# Can we fetch the version and does it look like something expected?
like ( my $version = $wormbase->version,
       qr/WS\d\d\d/,
       "Check version of database ok: " . $wormbase->version );

# Have we correctly instantiated a Service::acedb?
my $dbh = $wormbase->dbh('acedb');
isa_ok ( $dbh,'WormBase::APIPluggable::Service::acedb');



# Can we instantiate a WormBase::APIPluggable::Object via fetch?
my $variation = $wormbase->fetch(-class=>'Variation',-name=>'e345');
isa_ok ($variation,'WormBase::APIPluggable::Object::Variation');

# What about the name of the variation?
is ($variation->name,
   'e345',
   "Successfully called local method " . ref($variation) . "->name");


# Try it again, this time with ::Gene
my $gene = $wormbase->fetch(-class=>'Gene',-name=>'WBGene00006763');
isa_ok($gene,'WormBase::APIPluggable::Object::Gene');

is ($gene->object->Public_name,
   'unc-26',
   "Successfully called an (autoload) method " . ref($gene) . "->name");

## Test out our factory
#my $gene = $wormbase->fetch('Gene','WBGene00006763');
#isa_ok($gene,"WormBase::APIPluggable::Object::Gene");

#is( $gene->name,
#       'WBGene00006763',
#       "Successfully fetched object/created: " . ref($gene) . " - " . $gene->name);

