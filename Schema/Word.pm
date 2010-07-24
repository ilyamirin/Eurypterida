package Schema::Word;
#use Moose;
use CLASS;

#BEGIN { extends qw/DBIx::Class::Core/ };

use base qw/DBIx::Class::Core/;

CLASS->table('words');

CLASS->add_columns(qw/ id root /);

CLASS->set_primary_key( 'id' );

CLASS->has_many('positions' => 'Schema::Position');

#package Dunkleosteus::Models::Word::ResultSet;

#use parent 'DBIx::Class::ResultSet';

1;
