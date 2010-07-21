#!/usr/bin/perl -w
package Duncleosteus::Pool;

#TODO: подключить логгер
#TODO: подключить базу
#TODO: вынести в отдельный класс
#TODO: подключить конфигу

use Moose;

#use warnings;
#use strict;
#use utf8;
binmode STDOUT, ":utf8";

use Benchmark qw(:all);
use Crawler;

{
    my $t0 = Benchmark->new;

    my $robot = Duncleosteus::Crawler->new(
        agent    => 'duncleosteus/0.1',
        from     => 'mirin@dvc.ru',
        timeout  => 10,
        max_size => 400000,
    );
    $robot->delay(0);

    $robot->load_page_source('http://ruside.ru');

    #print $robot->page_source;

    print $robot->parse_words."\n";
    #foreach (@{$robot->words}) {
    #    print $_."\n";
    #}

    my $t1 = Benchmark->new;
    my $td = timediff($t1, $t0);

    print "the code took:",timestr($td),"\n";

}

1;
