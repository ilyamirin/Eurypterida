package Dunkleosteus::DB;
use Moose;

BEGIN { extends qw/ DBIx::Class::Schema / };

__PACKAGE__->load_namespaces(
    result_namespace => 'Models/',
    resultset_namespace => '',
);

1;
