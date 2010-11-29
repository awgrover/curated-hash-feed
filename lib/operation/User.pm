package operation::User;
use strict; use warnings; no warnings 'uninitialized';
use WebApp::operation;
use base qw(WebApp::operation);
use Verbose; use Data::Dumper;

sub do_add {
  my $self=shift;
  my ($feed_id, $args) = @_;
  vverbose 0,"Called with $feed_id,",Dumper($args);
  my @allowed = qw(curated_feed_id login);
  my %allowed;
  @allowed{@allowed} = @$args{@allowed};
  $allowed{'curated_feed_id'} = $feed_id;

  my $pass = join("", map { chr(rand(26)+ord('A')) } (1..6) );
  my $two = join("", map { chr(rand(26)+ord('a')) } (1..2) );
  vverbose 0,"Allowed: ".Dumper(\%allowed);
  my $m = Model::User->create({%allowed, password => crypt($pass, $two)});
  $self->webApp->pageContext->{'info'} .= "Created ".$m->login.", Password is: $pass ";
  }

1;
