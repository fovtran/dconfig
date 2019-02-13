use strict;
use WWW::Mechanize;

my $mech = WWW::Mechanize->new();
my $url = 'https://www.kernel.org/feeds/kdist.xml';
$mech->get($url);
print $mech->content;
my @links = $mech->rss;
my @item = $mech->item;
foreach my $link (@items) {
    print ($link->title), "\n";   
}