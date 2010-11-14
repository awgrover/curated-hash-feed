package Model::CuratedFeed;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'Model';


=head1 NAME

Model::CuratedFeed

=cut

__PACKAGE__->table("curated_feed");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 twitter_account

  data_type: 'text'
  is_nullable: 0

=head2 hashtag

  data_type: 'text'
  is_nullable: 0

=head2 oauth_key

  data_type: 'text'
  is_nullable: 0

=head2 consumer_secret

  data_type: 'text'
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
  "twitter_account",
  { data_type => "text", is_nullable => 0 },
  "hashtag",
  { data_type => "text", is_nullable => 0 },
  "oauth_key",
  { data_type => "text", is_nullable => 0 },
  "consumer_secret",
  { data_type => "text", is_nullable => 0 },
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


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-11-14 13:03:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cA1BDPYkKK+i4Ta3qvRaOA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;