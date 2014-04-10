package FakeBackend;

use Mojo::Base 'MojoX::Plugin::AnyCache::Backend';

has 'storage' => sub { {} };
has 'config';
has 'support_sync' => sub { 1 };
has 'support_async' => sub { 1 };

sub get {
	my ($self, $key, $cb) = @_;
	return $cb->($self->storage->{$key}) if $cb;
	return $self->storage->{$key};
}
sub set {
	my ($self, $key, $value, $cb) = @_;
	$self->storage->{$key} = $value;
	$cb->() if $cb;
}
sub incr {
	my ($self, $key, $amount, $cb) = @_;
	$self->storage->{$key} //= 0;
	$self->storage->{$key} += $amount;
	$cb ? $cb->($self->storage->{$key}) : $self->storage->{$key};
}
sub decr {
	my ($self, $key, $amount, $cb) = @_;
	$self->storage->{$key} //= 0;
	$self->storage->{$key} -= $amount;
	$cb ? $cb->($self->storage->{$key}) : $self->storage->{$key};
}
sub del {
	my ($self, $key, $cb) = @_;
	delete $self->storage->{$key};
	$cb->() if $cb;
}

1;
