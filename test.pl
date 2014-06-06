use MojoX::Plugin::AnyCache;

package App {
    use Mojo::Base -base;
    sub helper {
        
    }
}

package FakeSerialiser {
    use Mojo::Base -base;
    use Data::Dumper;

    has 'config';

    sub serialise {
        my ($self, $content) = @_;
        $content =~ tr/a-z/A-Z/;
        print "S-CONTENT: [$content]\n";
        return $content;
    }

    sub deserialise {
        my ($self, $content) = @_;
        $content =~ tr/A-Z/a-z/;
        print "DS-CONTENT: [$content]\n";
        return $content;
    }
}

#use MojoX::Plugin::AnyCache::Serialiser::MessagePack;
#my $mp = MojoX::Plugin::AnyCache::Serialiser::MessagePack->new;
#my $data = $mp->serialise("\x{a3}bar");
#$mp = MojoX::Plugin::AnyCache::Serialiser::MessagePack->new;
#print $mp->deserialise($data);
#exit;

my $c = MojoX::Plugin::AnyCache->new;
$c->register(new App, {
  "backend" => "MojoX::Plugin::AnyCache::Backend::Mojo::Redis",
#  "server" => "ws-kvm3.orctel.internal:6379",
  "server" => "localhost:9999",
  "serialiser" => "MojoX::Plugin::AnyCache::Serialiser::MessagePack",
#  "serialiser" => "FakeSerialiser",
  "redis_protocol" => "Protocol::Redis::XS",
});

$c->set("foo", "bar", sub {
    $c->get("foo", sub {
        use Data::Dumper;
        print Dumper \@_;
        Mojo::IOLoop->stop;
    });
});

Mojo::IOLoop->start;
