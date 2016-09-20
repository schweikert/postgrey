package PostgreyTestClient;

use strict;
use IO::Socket::INET;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(request);

sub new
{
    my ($class, $path) = @_;
    defined $path or die "ERROR: must define path";
    my $self = {
        path => $path,
        time => time,
    };
    return bless $self, $class;
}

sub advance_time
{
    my ($self, $seconds) = @_;
    $self->{time}+=$seconds;
}

sub request
{
    my ($self, $attrs) = @_;

    # creating a listening socket
    my $socket = new IO::Socket::UNIX (
        Type => SOCK_STREAM(),
        Peer => $self->{path},
    );
    defined $socket or do {
        warn "ERROR: can't create socket: $!\n";
        return undef;
    };

    print $socket "request=smtpd_access_policy\n";
    print $socket "policy_test_time=$self->{time}\n";
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
