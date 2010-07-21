#!/usr/bin/perl -w
package Duncleosteus::Crawler;

#TODO: подключить логгер
#TODO: подключить базу
#TODO: вынести в отдельный класс

use Moose;

use warnings;
use strict;

use utf8;
binmode STDOUT, ":utf8";

use Benchmark qw(:all) ;
use LWP::RobotUA;

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

{
    my $t0 = Benchmark->new;

    #расширить юзерагента
    my $robot = LWP::RobotUA->new('duncleosteus/0.1', 'mirin@dvc.ru');
    $robot->delay(0);
    $robot->timeout(10);

    $robot->max_size( 400000 );

    my $response = $robot->get('http://ruside.ru');

    if ($response->is_success) {
        Duncleosteus::Crawler->get_urls(\$response->decoded_content);
    }
    else {
        die $response->status_line;
    }

    my $t1 = Benchmark->new;
    my $td = timediff($t1, $t0);

    print "the code took:",timestr($td),"\n";

}

1;
