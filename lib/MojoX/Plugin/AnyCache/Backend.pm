package MojoX::Plugin::AnyCache::Backend;

use strict;
use warnings;
use Mojo::Base '-base';

has 'config';
has 'support_sync' => sub { 0 };
has 'support_async' => sub { 0 };
has 'serialiser';

sub get { die("Must be overridden in backend module") };
sub set { die("Must be overridden in backend module") };

1;