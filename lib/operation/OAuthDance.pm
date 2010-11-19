package operation::OAuthDance;
use strict; use warnings; no warnings 'uninitialized';
use WebApp::operation;
use base qw(WebApp::operation);
use Verbose; use Data::Dumper;

sub do {
  # Start the dance
  my $self=shift;
  my ($id) = @_;
  vverbose 0,"Called with ",Dumper(\@_);
  # FIXME: $session->{'twitters'}->search(id=>...)
  my $cf = Model::CuratedFeed->find({id=>$id});

  if ($cf) {
    vverbose 0,"Curated feed ", $cf->id;

    my $oauth_config = $self->webApp->config->{'oauth'};

    my $rez = Twitter_Util::twitter_query(
      { 
        account => $cf->twitter_account,
        consumer_key => $oauth_config->{'oauth_key'},
        consumer_secret => $oauth_config->{'consumer_secret'},
      },
      POST => 'https://api.twitter.com/oauth/request_token', # NOT JSON
      oauthtype => 'request token',
      callback => $self->webApp->request->url('-path' => 1),
      );

    my $uri = URI->new;
    $uri->query($rez);
    my %request_token = $uri->query_form;

    die "Got request token: ",Dumper(\%request_token)," ";
                 
    }
  else {
    $self->{'pageContext'}->{'error'} = "Don't know about the twitter feed";
    }
  }

package Twitter_Util;
use Twitter_Util;

1;
