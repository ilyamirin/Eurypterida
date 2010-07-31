package Crawler;
use Moose;

use utf8;

BEGIN { extends qw/ LWP::RobotUA / };

has page_source => ( is => 'rw', isa => 'ScalarRef');

has urls => ( is => 'rw', isa => 'ArrayRef');

has words => ( is => 'rw', isa => 'ArrayRef');

has logger => ( is => 'rw', isa => 'Object');

has db => ( is => 'rw', isa => 'Object');

sub store_results {
    my $self = shift;

    my $words = $self->db->resultset('Schema::Word');

    foreach( @{ $self->words } ) {
        $words->update_or_create({ root => lc $_ });
    }

}

sub parse_urls {
    my $self = shift ;

    #выдираем все ссылки
    my @urls;
    while( ${ $self->page_source } =~ m/href="?([^?^#^>^\s^"]+)/ig ) {
        push @urls, $1;
    }

    #удалаяем ссылки на почту
    @urls = grep $_ !~ m/mailto/i, @urls;

    #TODO: удаляем ссылки на статику

    $self->urls(\@urls);

    $self->logger->info( "Найдено " . @{ $self->urls() } . " урлов." );

}#sub parse_urls

sub parse_words {
    my $self = shift ;

    #получаем тело документа
    if ( ${ $self->page_source } =~ m|(<body[^>]*>(.+)</body>)|si ) {
        my $body = $1;

        #удаляем картинки скрипты формы
        foreach( qw/ script img form / ) {
            $body =~ s/<$_[^>]+>[^<]+(?=<\/$_>)/ /gi;
        }

        #убираем теги
        $body =~ s/<[^>]+>/ /gi;
        #убираем спецсимволы
        $body =~ s/&[^;]+;/ /gi;
        #убираем лишние пробелы
        $body =~ s/\W+/ /gi;

        my @words = split q/\s/, $body;

        $self->words(\@words);

    }#if

    $self->logger->info( "Найдено " . @{ $self->words() } . " слов." );

}#sub parse_words

sub load_page_source {
    my ( $self, $url ) = @_;

    my $response = $self->get( $url );

    if ($response->is_success) {
        $self->logger->info( 'Ищу на странице ' . $url );
        $self->page_source(\$response->decoded_content);
    }
    else {
        die $response->status_line;
    }

}#load_page_source

#__PACKAGE__->meta->make_immutable;

1;
