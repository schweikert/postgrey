package PostgreyRequest;

use IO::Socket::INET;

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(request);

sub request
{
    my ($path, $attrs) = @_;

    # creating a listening socket
    my $socket = new IO::Socket::UNIX (
        Type => SOCK_STREAM(),
        Peer => $path,
    );
    defined $socket or do {
        warn "ERROR: can't create socket: $!\n";
        return undef;
    };

    print $socket "request=smtpd_access_policy\n";
    for my $key (keys %$attrs) {
        print $socket "$key=$attrs->{$key}\n";
    }
    print $socket "\n";
    
    my $reply = '';
    while(my $line = readline($socket)) {
        chomp($line);
        last if $line eq '';
        $reply .= $line;
    }
    $reply =~ /^action=(.*)/ or do {
        warn "unexpected reply: $reply\n";
        return undef;
    };

    return $1;
}

1;
