#!/usr/bin/perl -w
package Duncleosteus::Crawler;

use Moose;

use warnings;
use strict;
use utf8;

use LWP::RobotUA;

BEGIN { extends qw/ LWP::RobotUA / };

has page_source => ( is => 'rw', isa => 'Str');

sub get_urls {
    my ( $self, $response ) = @_;

    #получаем тело документа
    if ( ${ $response } =~ m|(<body[^>]*>(.+)</body>)|si ) {
        my $body = $1;

        #выдираем все ссылки
        my @urls;
        while( $body =~ m/href="?([^?^#^>^\s^"]+)/ig ) {
            push @urls, $1;
            #print $1 . "\n";
        }

        #удалаяем ссылки на почту
        @urls = grep $_ !~ m/mailto/i, @urls;

        #TODO: удаляем ссылки на статику

        #TODO: сохраняем урлы в базу
        #foreach (@urls) {
        #    print "$_\n";
        #}

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

        #TODO: сохраняем слова в базу
        foreach (@words) {
           print "$_\n";
        }

    };

}#get_urls

sub load_page_source {
    my ( $self, $url ) = @_;

    my $response = $robot->get( $url );

    if ($response->is_success) {
        $self->page_source(\$response->decoded_content);
    }
    else {
        die $response->status_line;
    }

}#load_page_source

1;
