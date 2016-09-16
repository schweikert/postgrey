package Test_Whitelists;
use Test::More;
use PostgreyRequest qw(request);

our $tests = 2;

sub run_tests {
    my ($socket_path) = @_;
    my $reply = request($socket_path, {
        client_name    => 'test1.example.com',
        client_address => '192.168.0.1',
        sender         => 'test@example.com',
        recipient      => 'test@example.org',
    });
    ok(defined $reply, 'make request to postgrey');
    print "reply = $reply\n";

    sleep(1);
    my $reply = request($socket_path, {
        client_name    => 'test1.example.com',
        client_address => '192.168.0.1',
        sender         => 'test@example.com',
        recipient      => 'test@example.org',
    });
    ok(defined $reply, 'make request to postgrey');
    print "reply = $reply\n";

    sleep(1);
}

1;
