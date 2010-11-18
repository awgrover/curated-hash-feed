package operation::CuratedFeed;
use strict; use warnings; no warnings 'uninitialized';
use WebApp::operation;
use base qw(WebApp::operation);
use Verbose; use Data::Dumper;

sub do_add {
  my $self=shift;
  my ($args) = @_;
  vverbose 0,"Called with ",Dumper($args);
  my @allowed = qw(hashtag twitter_account description oauth_key);
  my %allowed; @allowed{@allowed} = @$args{@allowed};
  foreach (qw(consumer_secret oauth_key)) {
    $allowed{$_} = $MAIN::Config->{'oauth'}->{$_};
    }
  vverbose 0,"Allowed: ".Dumper(\%allowed);
  $self->webApp->pageContext->{'curatedFeed'} = Model::CuratedFeed->create(\%allowed);
  }

1;
