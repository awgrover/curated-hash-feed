package Model;
# Enable the DBIx::ResultSet methods on the model
# Convenience methods

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
# use namespace::autoclean; breaks overload
extends 'DBIx::Class::Core';
use overload '""' => 'to_s';
__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

use Carp;

our $AUTOLOAD;
use overload cmp => sub { $_[0]->id <=> $_[1]->id; };

# overload @-deref for resultSet
DBIx::Class::ResultSet->overload::OVERLOAD( '@{}' => sub { [shift->all] } );

sub transaction {
  # execute sub{} in a transaction
  my $class = shift;
  my ($fn) = @_;
  Schema::db->txn_do($fn);
  }

sub txn_rollback {
  my $self = shift;
  Schema::db->txn_rollback;
  }

sub source_name {
  my $self = shift;
  my $prefix = '^'.__PACKAGE__.'::';
  my ($name) = $self =~ /$prefix(.+)/;
  return $name;
  }

sub _rs {
  my $class = shift;
  Schema::db->resultset($class->source_name);
  }

sub AUTOLOAD {
  # Enable all the DBIx::ResultSet methods on our model objects
  # E.g. XX::Model::Url->all

  # we only proxy "class" methods
  my ($method_name) = $AUTOLOAD =~ /([^:]+)$/;
  if (! ref $_[0]) {
    my ($class) = @_;
    my $rs = Schema::db->resultset($class->source_name);
    if (1 || $rs->can($method_name)) { 
      # warn "found ".$_[0]." $method_name";
      # warn "will call on ".ref($rs);
      shift @_;
      return $rs->$method_name(@_);
      }
    }

  # unknown!
  my $super_method_name = "SUPER::$method_name";
  eval {
    no strict 'refs';
    return $_[0]->$super_method_name(@_);
    use strict 'refs';
    };
  if ($@ && $@ =~ /^(Can't locate object method "$method_name" via package "Model")/) {
    my $msg = $1;
    my $class = ref($_[0]) || $_[0];
    $msg =~ s/"Model"/"$class"/;
    local $Carp::CarpLevel=1;
    confess $msg;
    }
  elsif ($@) { 
    die $@;
    }
  }

sub to_s {
  my $self=shift;
  no warnings 'uninitialized';
  sprintf "<%s #%d %s>",ref($self), ($self->has_column('id') ? $self->id : '0'), join(", ", map {$_."=>".$self->$_()} $self->columns);
  use warnings 'uninitialized';
  }

1;
