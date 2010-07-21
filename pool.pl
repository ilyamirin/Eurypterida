#!/usr/bin/perl -w
package Duncleosteus::Pool;

#TODO: подключить логгер
#TODO: подключить базу
#TODO: вынести в отдельный класс
#TODO: подключить конфигу

use Moose;

use warnings;
use strict;
use utf8;
binmode STDOUT, ":utf8";

use Benchmark qw(:all);
#use Duncleosteus::Crawler;

{
    my $t0 = Benchmark->new;

    my $robot = Crawler->new();#'duncleosteus/0.1', 'mirin@dvc.ru');
    $robot->delay(0);
    $robot->timeout(10);

    $robot->max_size( 400000 );

    $robot->load_page_source();

    print $robot->page_source;

    #my $response = $robot->get('http://ruside.ru');

    #if ($response->is_success) {
    #    Duncleosteus::Crawler->get_urls(\$response->decoded_content);
    #}
    #else {
    #    die $response->status_line;
    #}

    my $t1 = Benchmark->new;
    my $td = timediff($t1, $t0);

    print "the code took:",timestr($td),"\n";

}

1;
