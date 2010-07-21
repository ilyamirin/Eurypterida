package Duncleosteus::Pool;
use Moose;

#TODO: подключить логгер
#TODO: подключить базу
#TODO: вынести в отдельный класс
#TODO: подключить конфигу

use utf8;
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

    print "Найдено " . $robot->parse_urls . " урлов\n";
    #print $_."\n" foreach (@{$robot->urls});

    print "Найдено " . $robot->parse_words . " слов\n";
    # print $_."\n" foreach (@{$robot->words});

    my $t1 = Benchmark->new;
    my $td = timediff($t1, $t0);

    print "the code took:",timestr($td),"\n";

}

1;
