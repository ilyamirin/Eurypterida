package Duncleosteus::Crawler;

use warnings;
use strict;

use Socket::Class;

sub get_urls {
    my $response = shift;

    #получаем тело документа
    if ( $$response =~ m|<body[^>]*>(.+)</body>|i ) {
        my $body = $1;

        #выдираем все ссылки
        while( $body =~ m/href="?([^?^#^>^\s^"]+)/ig ) {
            print $1."\n";
        }
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

print "END \n";

1;
