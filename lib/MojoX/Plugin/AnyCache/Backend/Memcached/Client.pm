package MojoX::Plugin::AnyCache::Backend::Memcached::Client;

use strict;
use warnings;
use Mojo::Base 'MojoX::Plugin::AnyCache::Backend';

use EV;
use AnyEvent;
use Memcached::Client;

has 'memcached';

has 'support_async' => sub { 1 };

sub get_memcached {
	my ($self) = @_;
	if(!$self->memcached) {
		my %opts = ();
		$opts{servers} = $self->config->{servers} if exists $self->config->{servers};
		$self->memcached(Memcached::Client->new(%opts));
	}
	return $self->memcached;
}

sub get { 
	my ($cb, $self) = (pop, shift);
	$self->get_memcached->get(@_, sub { $cb->(shift) });
}

sub set {
	my ($cb, $self) = (pop, shift);
	$self->get_memcached->set(@_, sub { $cb->() });
}

sub incr {
	my ($cb, $self) = (pop, shift);
	$self->get_memcached->incr(@_, sub { $cb->() });
}

sub decr {
	my ($cb, $self) = (pop, shift);
	$self->get_memcached->decr(@_, sub { $cb->() });
}

sub del {
	my ($cb, $self) = (pop, shift);
	$self->get_memcached->delete(@_, sub { $cb->() });
}

1;