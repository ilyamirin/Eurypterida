package Schema::Word;
use Moose;
use CLASS;

BEGIN { extends qw/DBIx::Class::Core/ };

CLASS->table('words');

CLASS->add_columns(qw/ id root /);

CLASS->set_primary_key( 'id' );

#CLASS->has_many('positions' => 'Schema::Position');

1;
