package Test_Greylist;
use Test::More;
use PostgreyRequest qw(request);
use Time::HiRes;

our $tests = 4;

sub run_tests {
    my ($socket_path) = @_;

    # Make first request (should be greylisted)
    {
        my $reply = request($socket_path, {
            client_name    => 'test1.example.com',
            client_address => '192.168.0.1',
            sender         => 'test@example.com',
            recipient      => 'test@example.org',
        });
        ok(defined $reply, 'make request to postgrey');
        is($reply, "DEFER_IF_PERMIT Greylisted, see http://postgrey.schweikert.ch/help/example.org.html", "verify greylisted");
    }

    sleep(1.1);

    # We have '--delay=1', so it should be ok after 1 second
    {
        my $reply = request($socket_path, {
            client_name    => 'test1.example.com',
            client_address => '192.168.0.1',
            sender         => 'test@example.com',
            recipient      => 'test@example.org',
        });
        ok(defined $reply, 'make request to postgrey');
        like($reply, qr{PREPEND X-Greylist: delayed [12] seconds}, "verify pass");
    }
}

1;
