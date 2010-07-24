package Dunkleosteus::Models::Result::Word;
use Moose;
use CLASS;

BEGIN { extends qw/DBIx::Class::Core/ };

CLASS->table('words');

CLASS->add_columns(qw/ id root /);

CLASS->set_primary_key( 'id' );

#CLASS->has_many('positions' => 'MyDatabase::Main::Result::Cd');

package Dunkleosteus::Models::Word::ResultSet;

use parent 'DBIx::Class::ResultSet';

1;
