package Model::Event;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'Model';


=head1 NAME

Model::Event

=cut

__PACKAGE__->table("event");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 twitter_guid

  data_type: 'text'
  is_nullable: 0

=head2 curated_feed_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 tweet

  data_type: 'text'
  is_nullable: 0

=head2 event_date

  data_type: 'datetime'
  is_nullable: 0

=head2 created_at

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 1

=head2 updated_at

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "twitter_guid",
  { data_type => "text", is_nullable => 0 },
  "curated_feed_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "tweet",
  { data_type => "text", is_nullable => 0 },
  "event_date",
  { data_type => "datetime", is_nullable => 0 },
  "created_at",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 1,
  },
  "updated_at",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 1,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("twitter_guid_unique", ["twitter_guid"]);


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-12-19 17:00:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KfbyBLkjeIVYVwU6U3mxHg

sub time {
  my $self=shift;
  return undef;
  # FIXME: it seems the time in the db field is for the local tz, but when read we get utc
  if ($self->event_date->hour != 0 || $self->event_date->second !=0 || $self->event_date->nanosecond != 0) {
    $self->event_date->strftime('%l:%M%P');
    }
  else {
    }
  }

__PACKAGE__->meta->make_immutable;
1;
