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

sub do_delete {
  my $self=shift;
  my ($id) = @_;
  
  my $maven = $self->request->caps->{'user'}->curated_feed->mavens->by_id($id);
  if ($maven) {
    $maven->delete;
    $self->info('Deleted '.$maven->twitter_account);
    }
  else {
    $self->error("No such maven, or doesn't belong to you");
    }
  }
1;
