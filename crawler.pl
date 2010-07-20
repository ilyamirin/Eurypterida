
package Duncleosteus::Crawler;

use warnings;
use strict;

use Socket::Class;
use Regexp;

sub get_urls {

    my $response = @_;

    #получаем тело документа
    my $re = new Regexp q|<body[^>]*>(.+)</body>|;

    if (match $re $response) {
        print $re->lastmatch;
    }

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
    $sock->read( $res, 1048576 )
        or die $sock->error;

    get_urls($res);
    #print $res;

    $sock->free();
}

print "END \n";

1;
