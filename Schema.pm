package Dunkleosteus::Schema;
#use Moose;

#BEGIN { extends qw/ DBIx::Class::Schema / };

use base qw/ DBIx::Class::Schema /;

__PACKAGE__->load_namespaces(
    result_namespace => 'Models',
    resultset_namespace => 'Models',
);

1;
