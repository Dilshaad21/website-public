package WormBase::API::Object::Gene_class;
use Moose;

with 'WormBase::API::Role::Object';
extends 'WormBase::API::Object';

=pod 

=head1 NAME

WormBase::API::Object::Gene_class

=head1 SYNPOSIS

Model for the Ace ?Gene_class class.

=head1 URL

http://wormbase.org/species/gene_class

=cut

#######################################
#
# The Overview widget 
#
#######################################

=head3 name

This method will return a data structure of the 
name and ID of the requested gene class.

=head4 PERL API

 $data = $model->name();

=head4 REST API

=head5 Request Method

GET

=head5 Requires Authentication

No

=head5 Parameters

A Gene class (eg unc)

=head5 Returns

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

=head5 Request example

curl -H content-type:application/json http://api.wormbase.org/rest/field/gene_class/unc/name

=head5 Response example

<div class="response-example"></div>

=cut 

# Provided by Object.pm; retain pod for complete documentation of the API
#sub name { }

=head3 other_names

This method will return a data structure containing 
other names that have been used to describe the 
requested gene class.

=head4 PERL API

 $data = $model->other_names();

=head4 REST API

=head5 Request Method

GET

=head5 Requires Authentication

No

=head5 Parameters

A Gene class (eg unc)

=head5 Returns

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

=head5 Request example

curl -H content-type:application/json http://api.wormbase.org/rest/field/gene_class/unc/other-names

=head5 Response example

<div class="response-example"></div>

=cut 

sub other_names {
    my $self = shift;
    my $object = $self->object;
    my @other_names = map { $self->_pack_obj($_) } $object->Other_name;
    my $data = { description => 'other names that have been used for this gene class',
		 data        => \@other_names };
    return $data;
}


=head3 description

This method will return a data structure containing
a brief description of the gene class abbreviation.

=head4 PERL API

 $data = $model->description();

=head4 REST API

=head5 Request Method

GET

=head5 Requires Authentication

No

=head5 Parameters

A Gene class (eg unc)

=head5 Returns

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

=head5 Request example

curl -H content-type:application/json http://api.wormbase.org/rest/field/gene_class/unc/description

=head5 Response example

<div class="response-example"></div>

=cut 

sub description {
    my $self = shift;
    my $object = $self->object;
    my $description = $object->Description;
    my $data = { description => 'a brief description of the gene class abbreviation',
		 data        => "$description" };
    return $data;
}

# laboratory() is provided by Object.pm. Documentation
# duplicated here for completeness of API

=head3 laboratory

This method will return a data structure containing
the laboratory that coined the gene class.

=head4 PERL API

 $data = $model->laboratory();

=head4 REST API

=head5 Request Method

GET

=head5 Requires Authentication

No

=head5 Parameters

A Gene class (eg unc)

=head5 Returns

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

=head5 Request example

curl -H content-type:application/json http://api.wormbase.org/rest/field/gene_class/unc/laboratory

=head5 Response example

<div class="response-example"></div>

=cut 

=head3 phenotype

This method will return a data structure containing
a string describing the general phenotype of genes
placed in this gene class.

=head4 PERL API

 $data = $model->phenotype();

=head4 REST API

=head5 Request Method

GET

=head5 Requires Authentication

No

=head5 Parameters

A Gene class (eg unc)

=head5 Returns

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

=head5 Request example

curl -H content-type:application/json http://api.wormbase.org/rest/field/gene_class/unc/phenotype

=head5 Response example

<div class="response-example"></div>

=cut 

sub phenotype {
    my $self = shift;
    my $object    = $self->object;
    my $phenotype = $object->Phenotype;
    my $data      = { description => 'general phenotype of genes placed in this gene class',
		      data        => "$phenotype" || undef };
    return $data;
}

# remarks() provided by Object.pm. We retain here for completeness of the API documentation.

=head3 remarks

This method will return a data structure containing
curatorial remarks for the gene class.

=head4 PERL API

 $data = $model->remarks();

=head4 REST API

=head5 Request Method

GET

=head5 Requires Authentication

No

=head5 Parameters

A Gene class (eg unc)

=head5 Returns

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

=head5 Request example

curl -H content-type:application/json http://api.wormbase.org/rest/field/gene_class/unc/remarks

=head5 Response example

<div class="response-example"></div>

=cut 


#######################################
#
# The Current Genes widget 
#
#######################################

=head3 current_genes

This method will return a data structure containing
all genes assigned to the class, organized by species.

=head4 PERL API

 $data = $model->current_genes();

=head4 REST API

=head5 Request Method

GET

=head5 Requires Authentication

No

=head5 Parameters

A Gene class (eg unc)

=head5 Returns

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

=head5 Request example

curl -H content-type:application/json http://api.wormbase.org/rest/field/gene_class/unc/current_genes

=head5 Response example

<div class="response-example"></div>

=cut 

sub current_genes {
    my $self   = shift;
    my $object = $self->object;
    
    my @genes  = $object->Genes;

    my %data;
    foreach my $gene (@genes) {
	
	my $species = $gene->Species;
	
	my $sequence_name = $gene->Sequence_name;
	my $locus_name    = $gene->Public_name;
	my $name = ($locus_name ne $sequence_name) ? "$locus_name ($locus_name)" : "$locus_name";

	# Some redundancy in the data structure here while
	# we decide how to format this data.
	push @{$data{$species}},
	{ species  => "$species",
	  locus    => $self->_pack_obj($gene),
	  sequence => "$sequence_name",
	};		     
    }
    my $data = { description => 'genes assigned to the gene class, organized by species',
		 data        => \%data };
    return $data;
}

#######################################
#
# The Previous Genes widget 
#
#######################################

=head3 former_genes

This method will return a data structure containing
genes that used to belong to the current gene class
but have been reassigned to another class, or that
have been reassigned a new gene name within the same
class.

=head4 PERL API

 $data = $model->former_genes();

=head4 REST API

=head5 Request Method

GET

=head5 Requires Authentication

No

=head5 Parameters

A Gene class (eg unc)

=head5 Returns

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

=head5 Request example

curl -H content-type:application/json http://api.wormbase.org/rest/field/gene_class/unc/former_genes

=head5 Response example

<div class="response-example"></div>

=cut 

sub former_genes {
    my $self   = shift;
    my $object = $self->object;

    my %data_pack;
    my @genes = $object->Old_member;

    foreach my $old_gene (@genes) {
	my $gene = $old_gene->Other_name_for || $old_gene->Public_name_for;

	my $data = $self->_stash_former_member($gene,$old_gene,'reassigned to new class');
	
	my $species = $gene->Species;
	push @{$data_pack{$species}},$data;
    }

    my $data = { description => 'genes formerly in the class that have been reassigned to a new class',
		 data        => \%data_pack };    
}


=head3 reassigned_genes

This method will return a data structure containing
genes that have been reassigned within the gene class.

=head4 PERL API

 $data = $model->reassigned_genes();

=head4 REST API

=head5 Request Method

GET

=head5 Requires Authentication

No

=head5 Parameters

A Gene class (eg unc)

=head5 Returns

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

=head5 Request example

curl -H content-type:application/json http://api.wormbase.org/rest/field/gene_class/unc/reassigned_genes

=head5 Response example

<div class="response-example"></div>

=cut 

sub reassigned_genes {
    my $self   = shift;
    my $object = $self->object;
    my $dbh = $self->ace_dsn->dbh;
     
    my @genes = eval {$dbh->fetch(-query=>qq{find Gene where Other_name="$object*"})};
    my %data_pack;
    foreach my $gene (@genes) {
	my $species = $gene->Species;

	# Only keep them if their current locus name matches the object name
	# We're looking for genes that have been reassigned
	my $public_name = $gene->Public_name;
	my @other_names =  grep { /$public_name/ } $gene->Other_name;
	foreach (@other_names) {
	    my $data = $self->_stash_former_member($gene,$_);
	    push @{$data_pack{$species}},$data;
	}
    }
    my $data = { description => 'genes that have been reassigned a new name in the same class',
		 data        => \%data_pack };    
    return $data;
}

##############################
#
# Internal methods
#
##############################
sub _stash_former_member {
    my ($self,$gene,$old_gene,$reason) = @_;
    
    my $sequence_name = $gene->Sequence_name;
    my $locus_name    = $gene->Public_name;
    my %data = ( species     => $self->_pack_obj($gene->Species),
		 former_name => "$old_gene",
		 new_name    => $self->_pack_obj($gene,$gene->Public_name),
		 sequence    => ($sequence_name) ? $self->_pack_obj($sequence_name) : undef,
		 reason      => $reason );
    return \%data;
}

1;
