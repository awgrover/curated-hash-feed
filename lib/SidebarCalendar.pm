package SidebarCalendar;
use strict; use warnings; no warnings 'uninitialized';
use Moose;
use Data::Dumper; 

has date => (is => 'ro', required => 1);
has curated_feed => (is => 'ro', required => 1);

sub month_name {
  shift->date->month_name;
  }

sub short_abbrev_weekdays { [qw(Su Mo Tu We Th Fr Sa)] }

sub weeks {
  my $self=shift;
 
  my @weeks;
  my $week = [];
  for my $d ((1.. DateTime->last_day_of_month(year => $self->date->year, month => $self->date->month)->day)) {
    my $aDate = $self->date->clone->set_day($d)->set( hour => 0, minute => 0, second => 0, nanosecond => 0);
    my $dow = $aDate->day_of_week;

    # stupid datatime column is not "deflated" in conditions
    my $deflator = sub { $_->strftime('%Y-%m-%d %H:%M:%S') };
    my $events = [$self->curated_feed->events({
        event_date => { -between => [ map {$deflator->($_)} ($aDate, $aDate->clone->add(days => 1)->subtract(seconds => 1)) ] }
        })->all];
    $week->[$dow - 1] = { 
      date => $aDate, 
      events => @$events ? $events : undef,
      };

    if ($dow == 7) {
      push @weeks, $week;
      $week = [];
      }
    }
    use Data::Dumper;
    push @weeks, $week if $weeks[-1] != $week;
    while (scalar(@{$weeks[-1]}) < 7) { push @{$weeks[-1]}, undef }

  \@weeks;
  }

1;
