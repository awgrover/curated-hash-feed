use Carp;
$SIG{__DIE__} = sub { Carp::confess @_ };

use lib qw(lib awgPerl);
our $Config = do 'conf/conf.pm';
use Schema;

BEGIN { print $config };
use Exporter 'import';
our @EXPORT = qw ($Config);
