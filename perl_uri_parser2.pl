use strict;
use warnings;

use LWP::Simple;
my $url = "http://whatev.er";
my $content = get($url);
$content =~ s/ /%20/g;

$string =  ‘hello0909there’;
$string =~ m/(\d+)/;
print “$& \n”