package Dunkleosteus::Models::Position;
use Moose;
use CLASS;

BEGIN { extends qw/DBIx::Class::Core/ };

CLASS->table('positions');

CLASS->add_columns(qw/ id word /);

CLASS->set_primary_key( 'id' );

CLASS->belongs_to('word' => 'Dunkleosteus::Models::Word', 'word');

1;
