package marshall::twitter::mavens;
use Moose;

sub marshall {
  my $self=shift;
  my ($webApp) = @_;

  my $cf = Model::CuratedFeed->find({id=>$webApp->request->param('id')});
  die "not found" if !$cf;
  
  {twitter => $cf}
  }

no Moose;
1;
