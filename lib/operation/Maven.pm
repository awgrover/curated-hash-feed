package operation::Maven;
use strict; use warnings; no warnings 'uninitialized';
use WebApp::operation;
use base qw(WebApp::operation);
use Verbose; use Data::Dumper;

sub do_add {
  my $self=shift;
  my ($feed_id, $args) = @_;
  vverbose 0,"Called with $feed_id,",Dumper($args);
  my @allowed = qw(curated_feed_id twitter_account);
  my %allowed;
  @allowed{@allowed} = @$args{@allowed};
  $allowed{'curated_feed_id'} = $feed_id;

  my @twitter_account = split /,\s*/, $allowed{'twitter_account'};

  foreach my $twit (@twitter_account) {
    vverbose 0,"Allowed: ".Dumper(\%allowed);
    my $m = Model::Maven->create({%allowed, twitter_account => $twit});
    $self->webApp->pageContext->{'info'} .= "Created ".$m->twitter_account.". ";
    }
  }

1;
