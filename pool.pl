package Dunkleosteus::Pool;
use Moose;

#TODO: подключить базу
#TODO: дать краулеру имя, которе он будет писать вотладке
#TODO: сделать создание краулеров из кофиги
#TODO: починить дилей и логгер
#TODO: добавить информативных сообщений о процессе работы
#TODO: сделать из краулера поток, а из пула пул) посм клаас краулера потока
#TODO: заюзать фишки муза

use utf8;
binmode STDOUT, ":utf8";

use Crawler;
use Schema;
#use Models::Word;

use Benchmark qw(:all);
use Log::Handler;
use Config::JSON;

use DBI;

{
    my $log = Log::Handler->new();

    $log->add(
        screen => {
            log_to     => "STDOUT",
            maxlevel   => "info",
            minlevel   => "notice",
            timeformat => "%Y/%m/%d %H:%M:%S",
        },
    );

    my $config = Config::JSON->new('config');

    my $crawler = Crawler->new( %{ $config->get('Pool') } );
    $crawler->delay(0);
    $crawler->logger($log);

    my $t0 = Benchmark->new;

    my $db = Schema->connect('dbi:SQLite:dbname=dunkleosteus.db');
    #my $db = Dunkleosteus::Models::DB->
    #    connect('DBI:mysql:host=localhost;database=dunckleosteus;mysql_enable_utf8=1');

    #print $db->storage->connected."\n";
    print $db->class('Word')."\n";
    $db->populate('Word', [
        [ qw/ root / ],
        ( ['имба'], ['шляпа'], ['термометр'] ) ,
    ]);

    #$db->do("create table users (user_name text);");
    #print $db->resultset('Dunkleosteus::Models::Word')->count ."\n";

    #$crawler->load_page_source('http://ruside.ru');
    #$crawler->parse_urls;
    #$crawler->parse_words;

    my $t1 = Benchmark->new;
    my $td = timediff($t1, $t0);

    print "the code took:",timestr($td),"\n";

}

1;
