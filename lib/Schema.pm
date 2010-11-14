package Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces(
    result_namespace => '+Model',
);


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-11-14 12:43:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0dP4fONt1YTNF3KY6GSKBA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
