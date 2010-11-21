package operation::OAuthDance;
use strict; use warnings; no warnings 'uninitialized';
use WebApp::operation;
use base qw(WebApp::operation);
use Verbose; use Data::Dumper;

sub do {
  # Start the dance
  my $self=shift;
  my ($id, $params) = @_;
  vverbose 0,"Called with ",Dumper(\@_);
  # FIXME: $session->{'twitters'}->search(id=>...)
  my $cf = Model::CuratedFeed->find({id=>$id});

  if ($cf) {
    vverbose 0,"Curated feed ", $cf->id;

    my $oauth_config = $self->webApp->config->{'oauth'};

    my $rez = Twitter_Util::twitter_query(
      { 
        account => $cf->twitter_account,
        consumer_key => $oauth_config->{'consumer_key'},
        consumer_secret => $oauth_config->{'consumer_secret'},
      },
      POST => 'https://api.twitter.com/oauth/request_token', # NOT JSON
      oauthtype => 'request token',
      callback => $self->webApp->request->url('-path' => 1)."?op=OAuthDance.requestToken&id=$id",
      );

    my $uri = URI->new;
    $uri->query($rez);
    my %request_token = $uri->query_form;

    $cf->update({oauth_token_secret => $request_token{'oauth_token_secret'}});

    $params->{'redirect'} .= '?oauth_token='.$request_token{'oauth_token'};
    vverbose 0,"Set redir to ".$params->{'redirect'};
    1;             
    }
  else {
    $self->webApp->pageContext->{'error'} = "Don't know about the twitter feed";
    }
  }

sub do_get_requestToken {
  my $self=shift;
  my ($params) = @_;
  
  my $cf = Model::CuratedFeed->find({id => $params->{'id'}});
  my $oauth_config = $self->webApp->config->{'oauth'};

  my $rez = Twitter_Util::twitter_query(
    {
      account => $cf->twitter_account,
      consumer_key => $oauth_config->{'consumer_key'},
      consumer_secret => $oauth_config->{'consumer_secret'},
      verifier => $params->{'oauth_verifier'},
      token => $params->{'oauth_token'},
      token_secret =>  $cf->oauth_token_secret,
    },
    'https://api.twitter.com/oauth/access_token', # NOT JSON
    oauthtype => 'access token',
    );

  my $uri = URI->new;
  $uri->query($rez);
  my %request_token = $uri->query_form;

  vverbose 0,"rez ",Dumper(\%request_token);

  if (lc($cf->twitter_account) ne lc($request_token{'screen_name'})) {
    $self->error("Authenticated the wrong twitter account, got ",$request_token{'screen_name'},", expected ",$cf->twitter_account);
    return undef;
    }

  $cf->update({
    oauth_token => $request_token{'oauth_token'},
    oauth_token_secret => $request_token{'oauth_token_secret'},
    });
 
   $self->webApp->pageContext->{'info'} = "Authenticated ".$cf->{'twitter_account'};
  }

package Twitter_Util;
use Twitter_Util;

1;
