#!/usr/bin/perl -w
package Duncleosteus::Crawler;

use warnings;
use strict;
use utf8;
binmode STDOUT, ":utf8";
#use locale; use POSIX qw(locale_h); setlocale(LC_CTYPE,"ru_RU.CP1251");

use Benchmark qw(:all) ;
use HTML::Encoding 'encoding_from_http_message';
#require LWP::RobotUA;
use LWP::UserAgent;

use Encode;

sub get_urls {
    my ( $self, $response ) = @_;

    #print length $$response."\n";
    #print  $$response =~ m|<body[^>]*>.+</body>|sgi . "\n";
    #print ${ $response } =~ m|body|g;
    #print ${ $response };
    #print ${ $response };

    #получаем тело документа
    #'fghfgh<body>привет лунатикам</body>'
    if ( ${ $response } =~ m|(<body[^>]*>.+)|si ) {
        my $body = $1;
        print 'body: '.$body."\n";

        #выдираем все ссылки
        my @urls;
        while( $body =~ m/href="?([^?^#^>^\s^"]+)/ig ) {
            push @urls, $1;
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
        #$body =~ s/&[^;]+;/ /gi;
        #убираем лишние пробелы
        #$body =~ s/\s{2,}/ /gi;

        #print $body."\n";
        #print $_."\n";

        my @words = split q/\W/, $body;
        #my @words;
        #while( $body =~ m/(\w+)/ig ) {
        #    print "$1\n";
        #}

        #TODO: сохраняем слова в базу
        foreach (@words) {
            print "$_\n";
        }


    };

}#get_urls

{
    my $t0 = Benchmark->new;

    #расширить юзерагента
    my $robot = LWP::UserAgent->new;
#LWP::RobotUA->new('duncleosteus/0.1', 'mirin@dvc.ru');
    $robot->timeout(10);
    $robot->max_size( 400000 );

    my $response = $robot->get('http://ruside.ru');

    if ($response->is_success) {
        #print $response->decoded_content =~ m|body|g;
        #print  ${$response->content_ref} =~ m/html/g;
        Duncleosteus::Crawler->get_urls(\$response->decoded_content);
        #get_urls($response->content_ref);
        #print $response->decoded_content;  # or whatever
        #print $response->as_string;
    }
    else {
        die $response->status_line;
    }

    #my $enco = encoding_from_http_message($resp);
    #my $res = decode($enco => $resp->content);

    #print $response;

    my $t1 = Benchmark->new;
    my $td = timediff($t1, $t0);
    print "the code took:",timestr($td),"\n";

}

1;
