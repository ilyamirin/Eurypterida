package Duncleosteus::Pool;
use Moose;

#TODO: подключить базу
#TODO: подключить конфигу

use utf8;
binmode STDOUT, ":utf8";

use Crawler;

use Benchmark qw(:all);
use Log::Handler Pool => "LOG";
use Config::JSON;

{
    my $config = Config::JSON->new('config');
    #$config->set('Pool/agent', 'duncleosteus/0.1');
    #$config->set('Pool/from', 'mirin@dvc.ru');
    #$config->set('Pool/timeout', '10');
    #$config->set('Pool/max_size', '400000');
    #$config->set('Pool/delay', '0');

    #$config->write;

    LOG->add(
        screen => {
            log_to     => "STDOUT",
            maxlevel   => "info",
            minlevel   => "notice",
            timeformat => "%Y/%m/%d %H:%M:%S",
        },
    );

    my $robot = Duncleosteus::Crawler->new( %{ $config->get('Pool') });
    $robot->delay(0);

    my $t0 = Benchmark->new;

    $robot->load_page_source('http://ruside.ru');
    #print $robot->page_source;

    LOG->info( "Найдено " . $robot->parse_urls . " урлов." );
    #print $_."\n" foreach (@{$robot->urls});

    LOG->info( "Найдено " . $robot->parse_words . " слов." );
    # print $_."\n" foreach (@{$robot->words});

    my $t1 = Benchmark->new;
    my $td = timediff($t1, $t0);

    print "the code took:",timestr($td),"\n";

}

1;
