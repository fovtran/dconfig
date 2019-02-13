use strict;
use warnings;

use XML::Simple;
use LWP::Simple;

$URL = "http://www.exampleurl.com";
my $content = get($url);
$content =~ s/ /%20/g;


my $xml = q{<booklist>
    <author>George Orwell</author>
    <book>    
        <title>Animal Farm</title>
        <year>1945</year>
        <language>English</language>
        <country>United Kingdom</country>
    </book>
</booklist>};

my $data = XMLin($xml);