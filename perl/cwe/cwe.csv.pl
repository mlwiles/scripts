#!/usr/bin/perl

# https://cwe.mitre.org/data/archive.html
# CSV's without proper parsing are not good dpne with way
# this is not a good implmentation, discovered there was an XML option!

use warnings;
use List::MoreUtils qw(uniq);
use Data::Dumper qw(Dumper);
use XML::Simple;

my $filename = '2000.csv';

open(FH, '<', $filename) or die $!;
$children = 0;

while(<FH>) {
    #print $_;
    @tokens = split(/,/, $_);
    #print "@tokens[0] - ";#@tokens[2]";
    $num1 = $tokens[0];
    chomp($num1);
    $cwe{$num1} = "";

    @tokens2 = split(/::/, $tokens[2]);
    foreach $tk2 (@tokens2) {
       if ($tk2 =~ /ChildOf/) {
            #print "@tk2\n";
            @tokens3 = split(/:/, $tk2);
            #print "@tokens3[3];";
            $num2 = $tokens3[3];
            chomp($num2);
            #print $num2;
            $temp = $cwe{$num1};
            if ($temp =~ "$num2;") {
            } else {
                $temp = $temp . $num2 . ";";
                $cwe{$num1} = $temp;
             }
            $children += 1;
        }
    }
    if ($children eq 0) {
        $cwe{$num1} = "ROOT";
        #print "ROOT ELEMENT"
    }
    #print "\n";
    $children = 0;
}

foreach my $num (sort keys %cwe) {
    print "$num: $cwe{$num}\n";
}

close(FH);

