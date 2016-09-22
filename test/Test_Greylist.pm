package Test_Greylist;

use strict;
use Test::More;
use Time::HiRes;
use BerkeleyDB;

our $tests = 8;

sub run_tests {
    my ($client) = @_;

    # Make first request (should be greylisted)
    {
        my $reply = $client->request({
            client_name    => 'test1.example.com',
            client_address => '192.168.0.1',
            sender         => 'test@example.com',
            recipient      => 'test@example.org',
        });
        ok(defined $reply, 'send request');
        is($reply, "DEFER_IF_PERMIT Greylisted, see http://postgrey.schweikert.ch/help/example.org.html", "verify greylisted");
    }

    $client->advance_time(310);

    {
        my $reply = $client->request({
            client_name    => 'test1.example.com',
            client_address => '192.168.0.1',
            sender         => 'test@example.com',
            recipient      => 'test@example.org',
        });
        ok(defined $reply, 'send request');
        like($reply, qr{PREPEND X-Greylist: delayed 31[0123] seconds}, "verify pass");
    }

    # We should also pass when coming from different IP but same /24 network
    {
        my $reply = $client->request({
            client_name    => 'test1.example.com',
            client_address => '192.168.0.2',
            sender         => 'test@example.com',
            recipient      => 'test@example.org',
        });
        ok(defined $reply, 'send request');
        is($reply, 'DUNNO', 'verify pass (same subnet)');
    }

    # We should not pass when coming from a completely different IP
    {
        my $reply = $client->request({
            client_name    => 'test1.example.com',
            client_address => '10.1.50.2',
            sender         => 'test@example.com',
            recipient      => 'test@example.org',
        });
        ok(defined $reply, 'send request');
        like($reply, qr{^DEFER_IF_PERMIT}, 'verify greylist (different ip)');
    }
}

sub run_tests_post_stop {
    # verify content of db

}

1;
