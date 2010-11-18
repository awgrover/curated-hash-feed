use Carp;
$SIG{__DIE__} = sub { Carp::confess @_ };

use lib qw(lib awgPerl);
our $Config = do '..'.__FILE__.'/conf/conf.pm' || die "$!\n$@";
use Schema;

BEGIN { print $config };
use Exporter 'import';
our @EXPORT = qw ($Config);
