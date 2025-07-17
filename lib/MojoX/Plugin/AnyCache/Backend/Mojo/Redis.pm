package MojoX::Plugin::AnyCache::Backend::Mojo::Redis;

use strict;
use warnings;
use Mojo::Base 'MojoX::Plugin::AnyCache::Backend';
use Mojo::Util 'monkey_patch';

use Mojo::Redis 3.29;

has 'redis';

has 'support_async' => sub { 1 };

sub get_redis {
	my ($self) = @_;
	if(!$self->redis) {
		my %opts = ();
		$opts{url} = $self->config->{server} if exists $self->config->{server};

        if( my $protocol = $self->config->{redis_protocol} ) {
            eval "require $protocol; 1" // die "Failed to load configured redis protocol '$protocol': $@";
            monkey_patch "Mojo::Redis", protocol_redis => sub { $protocol };
        }

		$self->redis(Mojo::Redis->new(%opts));
	}
	return $self->redis;
}

sub get {
    my ($cb, $self) = (pop, shift);

    $self->get_redis->db->get(@_)->then(sub {
            my ($value) = @_;
            $cb->($value);
        })->catch(sub {
            my $err = shift;
            error "ERROR with Redis get: $err";
        });
}

sub set {
	my ($cb, $self) = (pop, shift);
    $self->get_redis->db->set(@_)->then(sub {
            my ($value) = @_;
            $cb->($value);
        })->catch(sub {
            my $err = shift;
            error "ERROR with Redis set: $err";
	});
}

sub ttl {
	my ($cb, $self) = (pop, shift);
	$self->get_redis->db->ttl(@_)->then( sub {
		my ($value) = @_;
		    $cb->($value);
        })->catch(sub {
            my $err = shift;
            error "ERROR with Redis ttl: $err";
	});
}

sub incr {
	my ($cb, $self) = (pop, shift, @_);
	$self->get_redis->db->incrby(@_)->then( sub {
		my ($value) = @_;
		    $cb->($value);
        })->catch(sub {
            my $err = shift;
            error "ERROR with Redis incr: $err";
	});
}

sub decr {
	my ($cb, $self) = (pop, shift, @_);
	$self->get_redis->db->decrby(@_)->then( sub {
		my ($value) = @_;
		    $cb->($value);
        })->catch(sub {
            my $err = shift;
            error "ERROR with Redis decr: $err";
	});
}

sub del {
	my ($cb, $self) = (pop, shift, @_);
	$self->get_redis->db->del(@_)->then( sub {
		my ($value) = @_;
		    $cb->($value);
        })->catch(sub {
            my $err = shift;
            error "ERROR with Redis del: $err";
	});
}

1;
