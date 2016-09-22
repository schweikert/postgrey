package Test_Whitelists;

use strict;
use Test::More;
use BerkeleyDB;

our $tests = 8;

sub run_tests {
    my ($client) = @_;

    {
        my $reply = $client->request({
            client_name    => 'mail-xn1nam02ob0613.outbound.protection.outlook.com',
            client_address => '2a01:222:f400:fe44::613',
            sender         => 'test@example.com',
            recipient      => 'test@example.org',
        });
        ok(defined $reply, 'send request');
        is($reply, 'DUNNO', "whitelisted: outlook.com");
    }

    # Verify whitelist entry: 195.235.39
    {
        my $reply = $client->request({
            client_name    => 'blabla.example.com',
            client_address => '195.235.39.10',
            sender         => 'test@example.com',
            recipient      => 'test@example.org',
        });
        ok(defined $reply, 'send request');
        is($reply, 'DUNNO', "whitelisted: 195.235.39.10");
    }

    # Verify whitelist entry: 2a01:111:f400:7c00::10
    {
        my $reply = $client->request({
            client_name    => 'blabla.example.com',
            client_address => '2a01:111:f400:7c00::10',
            sender         => 'test@example.com',
            recipient      => 'test@example.org',
        });
        ok(defined $reply, 'send request');
        is($reply, 'DUNNO', "whitelisted: 2a01:111:f400:7c00::10");
    }
}

sub run_tests_post_stop {
    my ($client, $tmpdir) = @_;

    my $dbenv = BerkeleyDB::Env->new(
	-Home     => $tmpdir,
	-Flags    => DB_INIT_TXN|DB_INIT_MPOOL|DB_INIT_LOG,
    ) or die "ERROR: can't open DB environment: $!\n";

    my %db;
    tie(%db, 'BerkeleyDB::Btree',
            -Filename => 'postgrey.db',
            -Flags => DB_RDONLY,
            -Env => $dbenv,
    ) or die "ERROR: can't open database postgrey.db: $!\n";

    my $key = '10.1.50.0/test@example.com/test@example.org';
    ok(defined $db{$key}, "verify db entry exists");
    like($db{$key}, qr{^\d+,\d+$}, "verify db entry value");
}

1;
