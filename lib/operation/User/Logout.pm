package operation::User::Logout;
use strict; use warnings; no warnings 'uninitialized';
use WebApp::operation;
use base qw(WebApp::operation);
use Verbose; use Data::Dumper;

sub do_get {
  my $self=shift;

  my $user = $self->request->caps('user');
  if ($user) {
    delete $self->request->caps->{'user'};
    delete $self->session->param->{'user_id'};
    }
  1;
  }

1;
