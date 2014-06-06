package MojoX::Plugin::AnyCache::Serialiser::MessagePack;

use strict;
use warnings;
use Mojo::Base 'MojoX::Plugin::AnyCache::Serialiser';

use MIME::Base64;

use Data::MessagePack;

no utf8;

sub deserialise {
    my ($self, $data) = @_;

    return unless defined $data;

print "DESER: [$data]\n";
use Data::Dumper; print Dumper $data;

#    $data = decode_base64($data);

    # TODO implement serialiser configuration
    my $mp = Data::MessagePack->new();
    $mp->prefer_integer(0);
    return $mp->unpack( $data );
}

sub serialise {
    my ($self, $data) = @_;

    return unless defined $data;

print "SER: [$data]\n";

    my $mp = Data::MessagePack->new();
    $mp->prefer_integer(0);
    return $mp->pack( $data );

#    $data = encode_base64($data);

#print "SER2: [$data2]\n";
#
#    return $data2;
}

1;
