package Duncleosteus::Pool;
use Moose;

#TODO: подключить базу
#TODO: починить мерзкий дилей
#TODO: добавить информативных сообщений о процессе работы
#TODO: сделать из краулера поток, а из пул пул) посм клаас краулера потока

use utf8;
binmode STDOUT, ":utf8";

use Crawler;

use Benchmark qw(:all);
use Log::Handler Pool => "LOG";
use Config::JSON;

{
    my $config = Config::JSON->new('config');

    LOG->add(
        screen => {
            log_to     => "STDOUT",
            maxlevel   => "info",
            minlevel   => "notice",
            timeformat => "%Y/%m/%d %H:%M:%S",
        },
    );

    my $crawler = Duncleosteus::Crawler->new( %{ $config->get('Pool') } );
    $crawler->delay(0);

    my $t0 = Benchmark->new;

    $crawler->load_page_source('http://ruside.ru');
    #print $crawler->page_source;

    LOG->info( "Найдено " . $crawler->parse_urls . " урлов." );
    #print $_."\n" foreach (@{$crawler->urls});

    LOG->info( "Найдено " . $crawler->parse_words . " слов." );
    # print $_."\n" foreach (@{$crawler->words});

    my $t1 = Benchmark->new;
    my $td = timediff($t1, $t0);

    print "the code took:",timestr($td),"\n";

}

1;
