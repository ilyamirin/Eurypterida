package Schema;
use Moose;

BEGIN { extends qw/ DBIx::Class::Schema / };

__PACKAGE__->load_classes( qw/ Word /, {});

1;
