package WormBase::API::Role::Service::gff;

use Moose::Role;

has 'mysql_user' => (
    is => 'ro',
    isa => 'Str',
    default => 'root',
    );

has 'mysql_pass' => (
    is => 'ro',
    isa => 'Str',
    default => '3l3g@nz',
    );
    
has 'mysql_host' => (
    is => 'ro',
    isa => 'Str',
    default => 'localhost'
    );

has 'dsn' => (
    is => 'ro',
    isa => 'ArrayRef'
    );

has 'dbh' => (
    is        => 'rw',
    isa       => 'Bio::DB::GFF',   # Could also be a seq feature store, eh?
    lazy      => 1,
    builder   => '_build_dbh',
    predicate => 'has_dbh',
    writer    => 'set_dbh',
#    handles   => [qw/fetch/],
    );

around 'dbh' => sub {
    my $orig = shift;
    my $self = shift;

    my $species = $self->species;
        
    # Do we already have a dbh? HOW TO TEST THIS WITH HASH REF?
    if ($self->has_dbh) {
	$self->log->debug("     gff-dbh for $species exists and is alive!");
	return $self->$orig;
    } else {
	$self->log->debug("     gff-dbh for $species doesn't exist yet; trying to connect");
	my $dbh = $self->connect($species);
    }
};


has 'version' => (
    is  => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub {
	my $self = shift;
	return $self->dbh->version;
    },
    );

sub connect {
    my $self    = shift;
    my $species = $self->species;
    
    $self->log->info("Connecting to the GFF database for $species:");
    my $gff_args = $self->dsn->{$species};
    
    return unless ($gff_args);

    # THESE ARGUMENTS ARE NOT BEING PASSED...

    
    $gff_args->{-user} = $self->mysql_user;
    $gff_args->{-pass} = $self->mysql_pass;
    $gff_args->{-dsn}  = "dbi:mysql:database=$species;host=" . $self->mysql_host;
    
    if ($self->log->is_debug()) {
	$self->log->debug("     using the following parameters:");
	foreach (keys %$gff_args) {
	    $self->log->debug("       $_" . " "  . $gff_args->{$_});
	}
    }  
    
    my $dbh = Bio::DB::GFF->new(%$gff_args)
	or $self->log->fatal("Couldn't connect to the $species GFF database!");
    
    $dbh
	? $self->log->info("   --> succesfully established connection to $species GFF")
	: $self->log->fatal("Could not connect to the mysql server at " . $self->mysql_host . ": $!");
    
    #my $dbh = Bio::DB::GFF->new(%$gff_args) or die;  
    # How to set the dbh?  This is different
    # the acedb dbh which is a scalar (actually, even that should be a list of available datasources to pick at random)
    $self->set_dbh($dbh);
    return $self;
}




1;
