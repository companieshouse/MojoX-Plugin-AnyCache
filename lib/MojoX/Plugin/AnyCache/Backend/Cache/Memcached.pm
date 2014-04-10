package MojoX::Plugin::AnyCache::Backend::Cache::Memcached;

use strict;
use warnings;
use Mojo::Base 'MojoX::Plugin::AnyCache::Backend';

use Cache::Memcached;

has 'memcached';

has 'support_sync' => sub { 1 };

sub get_memcached {
	my ($self) = @_;
	if(!$self->memcached) {
		my %opts = ();
		$opts{servers} = $self->config->{servers} if exists $self->config->{servers};
		$self->memcached(Cache::Memcached->new(%opts));
	}
	return $self->memcached;
}

sub get { shift->get_memcached->get(@_) }
sub set { shift->get_memcached->set(@_)	}
sub incr { shift->get_memcached->incr(@_) }
sub decr { shift->get_memcached->decr(@_) }
sub del { shift->get_memcached->delete(@_) }

1;