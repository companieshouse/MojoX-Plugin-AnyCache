package MojoX::Plugin::AnyCache::Backend::Mojo::Redis;

use strict;
use warnings;
use Mojo::Base 'MojoX::Plugin::AnyCache::Backend';
use Mojo::Util 'monkey_patch';

use Mojo::Redis 3.29;
use Data::Dumper;

has 'redis';

has 'support_async' => sub { 1 };

sub support_xsync { return 1; }

sub get_redis {
	my ($self) = @_;
	if(!$self->redis) {
		my %opts = ();
		# $opts{server} = $self->config->{server} if exists $self->config->{server};
        # $opts{url} = $self->config->{server} if exists $self->config->{server};
        # Use default MOJO_REDIS_URL in docker-compose
        # $opts{encoding} = undef;

        # if( my $protocol = $self->config->{redis_protocol} ) {
        #     eval "require $protocol; 1" // die "Failed to load configured redis protocol '$protocol': $@";
        #     monkey_patch "Mojo::Redis", protocol_redis => sub { $protocol };
        # }

		$self->redis(Mojo::Redis->new(%opts));
	}
	return $self->redis;
}

sub get {
    my ($cb, $self) = (pop, shift);

    $self->get_redis->db->get_p(@_)->then(sub {
            my ($value) = @_;
            $cb->($value);
        })->catch(sub {
            my $err = shift;
            warn "ERROR with Redis get: $err";
        });
}

sub set {
	my ($cb, $self) = (pop, shift);

    my ( $key, $value, $expiry ) = @_;
    my $ex = defined $expiry ? 'EX' : undef;
    $self->get_redis->db->set_p($key, $value, $ex, $expiry)->then(sub {
            my ($value) = @_;
            $cb->($value);
        })->catch(sub {
            my $err = shift;
            warn "ERROR with Redis set: $err";
	});
}

sub ttl {
    my ($cb, $self) = (pop, shift);

    $self->get_redis->db->ttl_p(@_)->then( sub {
            my ($value) = @_;
            $cb->($value);
        })->catch(sub {
            my $err = shift;
            warn "ERROR with Redis ttl: $err";
        });
}

sub incr {
	my ($cb, $self) = (pop, shift, @_);
	$self->get_redis->db->incrby_p(@_)->then( sub {
		my ($value) = @_;
		    $cb->($value);
        })->catch(sub {
            my $err = shift;
            warn "ERROR with Redis incr: $err";
	});
}

sub decr {
	my ($cb, $self) = (pop, shift, @_);
	$self->get_redis->db->decrby_p(@_)->then( sub {
		my ($value) = @_;
		    $cb->($value);
        })->catch(sub {
            my $err = shift;
            warn "ERROR with Redis decr: $err";
	});
}

sub del {
	my ($cb, $self) = (pop, shift, @_);
	$self->get_redis->db->del_p(@_)->then( sub {
		my ($value) = @_;
		    $cb->($value);
        })->catch(sub {
            my $err = shift;
            warn "ERROR with Redis del: $err";
	});
}

1;
