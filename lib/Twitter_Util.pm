#!/usr/bin/env perl
# --- twitter > followingers
use strict; use warnings;

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
use Verbose; $kVerbose = $ENV{'VERBOSE'} || 0;

my $UserAgent = 'curated-tag-feed';

=notes
    request_url => 'https://api.twitter.com/oauth/request_token',
    Access token URL: https://api.twitter.com/oauth/access_token
    Authorize URL: https://api.twitter.com/oauth/authorize
=cut

sub twitter_query {
    my ($feed, $request_url, %params) = @_;

    # warn Dumper(Net::OAuth->request("protected resource")->all_params);
    my $ua = LWP::UserAgent->new;
    $ua->agent($ua->agent." ".$UserAgent);

    my $nonce = join("",map {('a'..'z','0'..'1')[rand(36)]} (1..20));
    vverbose 4,"OAuth info for ".$feed->twitter_account." ",Dumper($feed->oauth);
    my $oauth = Net::OAuth->request("protected resource")->new(
        %{$feed->oauth},
        request_method => 'GET',
        signature_method => 'HMAC-SHA1',
        timestamp => time,
        nonce => $nonce,
        extra_params => \%params,
        request_url => $request_url,
        );
    $oauth->sign;

    my $uri = URI->new($oauth->normalized_request_url);
    $uri->query_param($_ => $params{$_}) foreach keys %params;
    vverbose 4,"Going to ask $uri (from $request_url)";
    vverbose 4,"With auth header: ",$oauth->to_authorization_header;
    my $req = HTTP::Request->new(GET => $uri, [ Authorization => $oauth->to_authorization_header ]);

    my $res = $ua->request($req);

    my $data =  eval { JSON->new->decode($res->content); };
    if ($@) {
      warn "INTERNAL JSON Decode failed: $@";
      warn "Content in the http result:\n";
      warn Dumper($res->content);
      exit 1;
      }

    if ($res->is_success) {
        return $data;
        }
    else {
        # warn Dumper($res);
        die "Something went wrong: ".$res->status_line.", ".$res->message,", ".$data->{'error'};
      }

    }

1;


