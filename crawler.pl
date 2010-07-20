package Duncleosteus::Crawler;

use warnings;
use strict;

use locale; use POSIX qw(locale_h); setlocale(LC_CTYPE,"ru_RU.UTF-8");
use Socket::Class;

sub get_urls {
    my $response = shift;

    #получаем тело документа
    if ( $$response =~ m|<body[^>]*>(.+)</body>|i ) {
        my $body = $1;

        #выдираем все ссылки
        my @urls;
        while( $body =~ m/href="?([^?^#^>^\s^"]+)/ig ) {
            push @urls, $1;
        }

        #удалаяем ссылки на почту
        @urls = grep $_ !~ m/mailto/i, @urls;

        #TODO: удаляем ссылки на статику

        #TODO: сохраняем урлы в базу
        #print "Урлы \n";
        #foreach (@urls) {
        #    print "$_\n";
        #}

        #удаляем формы картинки и тп
        #$_ = $body;
        #$_ =~ s/<form[^>]*>.+<\/form>/ /gi;

        #убираем теги
        #$_ = $body;
        #$_ =~ s/<[^>]+>/ /gi;

        #print $body."\n";
        #print $_."\n";

        my @words = split ' ', $body;
        foreach( @words ) {
            print "$_\n";
        }

        #TODO: сохраняем слова в базу
        #foreach (@words) {
        #    print "$_\n";
        #}


    };

}#get_urls

{
    my $sock = Socket::Class->new(
        'remote_addr' => 'www.ruside.ru',
        'remote_port' => 'http',
    ) or die Socket::Class->error;

    $sock->write(
        "GET / HTTP/1.0\r\n" .
        "User-Agent: Not Mozilla\r\n" .
        "\r\n"
    ) or die $sock->error;

    my $res;
    for( my $line = $sock->readline() or die $sock->error; defined $line; ) {
        $res .= $line;
        $line = $sock->readline();
    }

    get_urls(\$res);
    #print $res;

    $sock->free();
}

1;
