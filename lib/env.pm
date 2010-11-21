use Carp;
$SIG{__DIE__} = sub { Carp::confess @_ };

use lib qw(lib awgPerl);
BEGIN {our $Config = do 'conf/conf.pm' || die "$!\n$@";}

BEGIN {$main::Config = $Config}
use Schema;

use Exporter 'import';
our @EXPORT = qw ($Config);
