package Schema;
#use Moose;

#BEGIN { extends qw/ DBIx::Class::Schema / };

use base qw/ DBIx::Class::Schema /;

__PACKAGE__->load_classes( qw/ Word Position/, {});

1;