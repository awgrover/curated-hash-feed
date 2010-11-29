package operation::User::Login;
use strict; use warnings; no warnings 'uninitialized';
use WebApp::operation;
use base qw(WebApp::operation);
use Verbose; use Data::Dumper;

sub do {
  my $self=shift;
  my ($args) = @_;

  my ($login, $pass) = @$args{'login','password'};

  my $found;

  foreach my $user (Model::User->search({login => $login})) {
    vverbose 0,"Auth against $user->login";
    if ( crypt($pass, $user->password) eq $user->password ) {
      $found = $user;
      last;
      }
    }
  if (!$found) {
    $self->info('Login/password not found');
    return undef;
    }

  vverbose 0,"Before setting user_id, ",Dumper($self->session->param)." ";
  $self->webApp->session->param(user_id => $found->id);
  # vverbose 0,"After setting user_id, ",Dumper($self->session->param)." ";

  $self->info("Logged in as ",$found->login,", ".$found->id);
  }

1;
