package Model::Maven;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'Model';


=head1 NAME

Model::Maven

=cut

__PACKAGE__->table("maven");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 curated_feed_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 twitter_account

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
  "curated_feed_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "twitter_account",
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

=head1 RELATIONS

=head2 curated_feed

Type: belongs_to

Related object: L<Model::CuratedFeed>

=cut

__PACKAGE__->belongs_to(
  "curated_feed",
  "Model::CuratedFeed",
  { id => "curated_feed_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-12-19 09:38:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sFR80yUo3nqa13l/zuGiRg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
