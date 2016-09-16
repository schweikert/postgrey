package Test_Whitelists;
use Test::More;
use PostgreyRequest qw(request);

our $tests = 2;

sub run_tests {
    my ($socket_path) = @_;

    {
        my $reply = request($socket_path, {
            client_name    => 'mail-xn1nam02ob0613.outbound.protection.outlook.com',
            client_address => '2a01:222:f400:fe44::613',
            sender         => 'test@example.com',
            recipient      => 'test@example.org',
        });
        ok(defined $reply, 'make request to postgrey');
        is($reply, 'DUNNO', "whitelisted: outlook.com");
    }
}

1;
