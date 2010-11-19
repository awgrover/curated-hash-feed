#!/usr/bin/env perl
# --- twitter > followingers
use strict; use warnings; no warnings 'uninitialized';

use Net::OAuth;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;
use HTTP::Request::Common;
use LWP::UserAgent;
use URI::QueryParam;
use Data::Dumper;
use Carp qw( confess );
$SIG{__DIE__} =  \&confess;
use JSON;
use feature qw(switch);
use lib qw(lib);
use env;
use Schema;
use Verbose; $kVerbose = $ENV{'VERBOSE'} || 4;

my $UserAgent = 'curated-tag-feed';
my %Rate_Limit = (
  # as of 2010.11.04. http://dev.twitter.com/pages/rate-limiting#rest
  # for GET, REST
  # Rate limits will trigger status 400 (in REST)
  OAuth => [350,'hour'], # per hour
  Anonymous => [150,'hour'], # per hour per IP
  # as of 2010.11.04. http://support.twitter.com/forums/10711/entries/15364
  Updates => [1000, 'day'], # per day, retweets included, semi-hourly rate also imposed (unknown rate): wait for "several hours"
  Following => [1000, 'day'], # per day, additional constraints at 2000 followings
  # "Features", e.g. search, further limit the GET limits above
  );

=notes
    request_url => 'https://api.twitter.com/oauth/request_token',
    Access token URL: https://api.twitter.com/oauth/access_token
    Authorize URL: https://api.twitter.com/oauth/authorize
=cut

sub twitter_query {
    # ---  \%oauth_keys, [POST] url [oauthtype=>x,] k=>v
    my ($oauth_keys) = shift;
    my $post;
    if ($_[0] eq 'POST') {
      $post = 'POST';
      shift @_;
      }
    my ($request_url, %params) = @_;
    my $oauth_type = (delete $params{'oauthtype'}) || 'protected resource';
    my $callback = delete $params{'callback'};

    # warn Dumper(Net::OAuth->request($oauth_type)->all_params);
    my $ua = LWP::UserAgent->new;
    $ua->agent($ua->agent." ".$UserAgent);

    my $nonce = join("",map {('a'..'z','0'..'1')[rand(36)]} (1..20));
    vverbose 4,"OAuth info for ".$oauth_keys->{'account'}." ",Dumper($oauth_keys);
    my $oauth = Net::OAuth->request($oauth_type)->new(
        %$oauth_keys,
        ($callback ? (callback => $callback) : ()),
        request_method => $post || 'GET',
        signature_method => 'HMAC-SHA1',
        timestamp => time,
        nonce => $nonce,
        extra_params => \%params,
        request_url => $request_url,
        );
    $oauth->sign;

    my $uri = URI->new($oauth->normalized_request_url);
    if (!$post) {
      $uri->query_param($_ => $params{$_}) foreach keys %params;
      }
    vverbose 4,"Going to ",$post || 'GET'," $uri (from $request_url)";
    vverbose 4,"With auth header: ",$oauth->to_authorization_header;
    my $req = $post
      ? POST($uri, \%params, Authorization => $oauth->to_authorization_header)
      : HTTP::Request->new(GET => $uri, [ Authorization => $oauth->to_authorization_header ])
      ;

    my $res = $ua->simple_request($req);
    vverbose 4,"Result Status: ",$res->code;

    # $feed->update_rate_limit($res->header('x-ratelimit-class') => $res->header('x-ratelimit-remaining'));

    if ($res->code eq '400') {
      warn "Headers ",Dumper($res->headers);
      warn Dumper($res->content);
      warn "Twitter rate limited, I think\n";
      exit 1;
      }

    vverbose 0, "Rate limit: ",$res->header('x-ratelimit-class'),
      " => ",$res->header('x-ratelimit-remaining'),"/",$res->header('x-ratelimit-limit'),"\n";

    if ($res->code eq '401') {
      warn "Headers ",Dumper($res->headers);
      warn Dumper($res->content);
      warn "Twitter Doesn't like that, I think\n";
      die $res->code." Request failed: ".$res->status_line.", ".$res->message;
      }

    my $data;

    if ($uri =~ /\.js$/) {
      $data =  eval { JSON->new->decode($res->content); };

      if ($@) {
        warn "INTERNAL JSON Decode failed: $@";
        warn "Content in the http result:\n";
        warn Dumper($res->content);
        die "INTERNAL JSON Decode failed: $@";
        }
      }
    else {
      $data = $res->content;
      }

    if ($res->is_success) {
      return $data;
      }
    else {
      # warn Dumper($res);
      die $res->code." Request failed: ".$res->status_line.", ".$res->message,", ".$data->{'error'};
      }

    }

sub oauth_simple {
  my %args = @_;
  vverbose 0,"ARgs ",Dumper(\%args)," ";
  my @tokens = qw(consumer_key consumer_secret);
  my %tokens; @tokens{@tokens} = @args{@tokens};
  Net::OAuth::Simple->new(
    protocol_version => '1.0a',
    urls => {
      authorization_url => "https://api.twitter.com/oauth/authorize",
      request_token_url => "https://api.twitter.com/oauth/request_token",
      access_token_url => "https://api.twitter.com/oauth/access_token",
      },
    tokens => \%tokens,
    );
  }
1;


