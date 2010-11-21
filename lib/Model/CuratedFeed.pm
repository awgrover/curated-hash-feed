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

=head2 description

  data_type: 'text'
  is_nullable: 0

=head2 last_search_id

  data_type: 'text'
  is_nullable: 1

=head2 oauth_token

  data_type: 'text'
  is_nullable: 1

=head2 oauth_token_secret

  data_type: (empty string)
  is_nullable: 1

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
  "description",
  { data_type => "text", is_nullable => 0 },
  "last_search_id",
  { data_type => "text", is_nullable => 1 },
  "oauth_token",
  { data_type => "text", is_nullable => 1 },
  "oauth_token_secret",
  { data_type => "", is_nullable => 1 },
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


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-11-20 21:22:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:et6INLv67XLO+WtS2OMwvw


sub oauth {
  my $self = shift;
  {
    account => $self->twitter_account,
    token => $self->oauth_token, 
    token_secret => $self->oauth_token_secret,
  };
  }
        
__PACKAGE__->meta->make_immutable;
1;
