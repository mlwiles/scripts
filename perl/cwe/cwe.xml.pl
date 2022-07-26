#!/usr/bin/perl
#################################
# Michael Wiles - michael.wiles@intel.com
# 2022/04/29
# CWE treebuidler via XML

# was going to user OO / classes here, but when I tried to create a linked list it fell flat on it face. 
# leaving this for historical purposes, nothing to see here ... move along to the next section

package CWE;
sub new {
   print "CWE::new called\n";
   my $class = shift;
   my $self = {
        _id => shift,
        _desc => shift,
   };
   bless $self, $class;
   return $self;
}
sub DESTROY {
   print "CWE::DESTROY called\n";
}
sub getId {
   return $self->{_id};
}
sub setId {
   my ( $self, $id ) = @_;
   $self->{_id} = $id if defined($id);
   return $self->{_id};
}
sub getDesc {
   return $self->{_desc};
}
sub setDesc {
   my ( $self, $desc ) = @_;
   $self->{_desc} = $desc if defined($desc);
   return $self->{_desc};
}
#################################

# main program - there is where the magic starts (in my Shia Labeouf voice)
package main;

use List::MoreUtils qw(uniq);
use Data::Dumper qw(Dumper);
use XML::Simple;

# https://cwe.mitre.org/data/archive.html
#my $filename = 'cwec_v4.6.xml';
my $filename = 'cwec_v4.8.xml';

#2dim array - key (CWEID) - data (NAME, DESC) 
my %CWEData = {};
#2dim hashtable - key (CWEID) - data (CHILDREN)
my %CWEChildren = {};
#array of root ids
my @rootCWES = ();

my $simple = XML::Simple->new();
# read XML file
my $data = $simple->XMLin($filename);
#$data = $xml->XMLin($filename, ForceArray => 1, KeyAttr => [], KeepRoot => 1, );

my $filename = 'cwe.html';
open(FH, '>', $filename);

#https://stackoverflow.com/questions/657058/how-do-i-retrieve-tag-attributes-with-xmlsimple
foreach my $weakness_node (@{$data->{Weaknesses}->{Weakness}})
{
    my $cweid = $weakness_node->{ID};
    if ($DEBUG) { print "ID->$cweid\n"; }

    my %CWDDetails = {};
    $CWDDetails{ 'name' } = $weakness_node->{Name}; 
    if ($DEBUG) { print "ID->$CWDDetails{ 'name' }\n"; }
    $CWDDetails{ 'desc' } = $weakness_node->{Description}; 
    if ($DEBUG) { print "ID->$CWDDetails{ 'desc' }\n"; }

    $CWEData{ $cweid } = \%CWDDetails;

    my $relatedWeaknesses = $weakness_node->{Related_Weaknesses};
    if ( $relatedWeaknesses != 0 )  {
        if ($DEBUG) { print "ID->relatedWeaknesses not null\n"; }

        $cwes{$cweid} = $cweid;
        #https://stackoverflow.com/questions/3789284/how-can-i-test-that-something-is-a-hash-in-perl
        if (ref $relatedWeaknesses->{Related_Weakness} eq 'HASH' ) {
            if ($DEBUG) { print "ID->Related_Weakness eq HASH\n"; }

            my $related_cwe = $relatedWeaknesses->{Related_Weakness}->{CWE_ID};
            if ($DEBUG) { print "Parent->$relatedWeaknesses->{Related_Weakness}->{Nature}:$related_cwe\n"; } 
            #add to CWEChildOf / remove duplicate entries
            addCWEChild($related_cwe, $cweid);
        } else {
            if ($DEBUG) { print "ID->Related_Weakness not HASH\n"; }

            foreach my $related_weakness_node (@{$relatedWeaknesses->{Related_Weakness}} )
            {
                my $nature = $related_weakness_node->{Nature};
                if ($nature eq "ChildOf") {
                    my $related_cwe = $related_weakness_node->{CWE_ID};
                    if ($DEBUG) { print "Parent->$nature:$related_cwe\n"; }
                    #add to CWEChildOf / remove duplicate entries
                    addCWEChild($related_cwe, $cweid);
                }
            }
        }
    } else {
        if ($DEBUG) { print "ID->relatedWeaknesses null\n"; }
        #its a root - no ChildOf, add to root array
        push(@rootCWES, $cweid);
    }
}

sub  addCWEChild {
    my ($in_parent, $in_child) = @_;
    if ($DEBUG) {
        print "addCWEChild:in_parent:$in_parent:\n";
        print "addCWEChild:in_child:$in_child:\n";
    }
    my @children = @{$CWEChildren{$in_parent}};
    if (@children) {
        if ($DEBUG) { print "addCWEChild:children not null\n"; }

        my $found = 0;

        my @sorted_children = sort { int($a) <=> int($b) } @children;
        foreach my $child (@sorted_children) {
            if ($in_child eq $child) {
                $found = 1;
            }
        }
        if (!$found) {
            if ($DEBUG) { print "addCWEChild:not found\n"; }
            push(@sorted_children, $in_child);
            $CWEChildren{$in_parent} = \@sorted_children;
            my $sorted_children = @sorted_children;
            if ($DEBUG) { print "addCWEChild:[$sorted_children] @sorted_children\n"; }
        }
    } else {
        if ($DEBUG) { print "addCWEChild:children null\n"; }
        my @newchildren = ();
        push(@newchildren, $in_child);
        $CWEChildren{$in_parent} = \@newchildren;
    }
}

sub getCWEDetails {
    my ($in_id) = @_;
    my $lookup_name = $CWEData{$in_id}->{ 'name' }; 
    my $lookup_desc = $CWEData{$in_id}->{ 'desc' };
    return ($lookup_name, $lookup_desc);
}

sub  getCWEChildren {
    my ($in_id, $breadcrumbs) = @_;
    if ($DEBUG) { print "getCWEChildren:in_id:$in_id\n"; }
    if ($DEBUG) { print "getCWEChildren:breadcrumbs:$breadcrumbs\n"; }
    if (!$in_id) {
        return;
    }
    my @children = @{$CWEChildren{$in_id}};
    my @sorted_children = sort { int($a) <=> int($b) } @children;
    
    if ($DEBUG) {
        foreach my $child_id (@sorted_children) {
            print "getCWEChildren:child_id:$child_id\n";
        }
    }

    foreach my $child_id (@sorted_children) {
        my ($c_name, $c_desc) = getCWEDetails($child_id);        
        #build the breadcrumbs
        my $newbreadcrumbs = "";
        if (length($breadcrumbs) < 1) {
            $newbreadcrumbs = "$in_id";
        } else {
            $newbreadcrumbs = "$breadcrumbs:$in_id";   
        }
        print FH "<li><input type=\"checkbox\" id=\"$newbreadcrumbs:$child_id\" name=\"$newbreadcrumbs:$child_id\" value=\"$newbreadcrumbs:$child_id\" onclick=\"checkTree('$newbreadcrumbs:$child_id');\"><span class=\"caret\"><a href=\"https://cwe.mitre.org/data/definitions/$child_id.html\" target=\"_blank\">$child_id</a>:$c_name</span>\n";
        print FH "<ul class=\"nested\">\n";

        
        #print children recursively here
        getCWEChildren($child_id, $newbreadcrumbs);
        print FH "</ul>\n";
        print FH "</li>\n";
    }
}

sub printTree {
    my (@in_roots) = @_;
    print FH "<ul id=\"myUL\">\n";
    foreach my $root_id (@in_roots) {
        my ($c_name, $c_desc) = getCWEDetails($root_id);

        if ($c_name =~ /^DEPRECATED/){
            print FH "<div class=\"deprecated\">\n";
        }
        print FH "<li><input type=\"checkbox\" id=\"$root_id\" name=\"$root_id\" value=\"$root_id\" onclick=\"checkTree('$root_id');\"><span class=\"caret\"><a href=\"https://cwe.mitre.org/data/definitions/$root_id.html\" target=\"_blank\">$root_id</a>:$c_name</span>\n";
        print FH "<ul class=\"nested\">\n";
        getCWEChildren($root_id,"");
        print FH "</ul>\n";
        print FH "</li>\n";
        if ($c_name =~ /^DEPRECATED/){
            print FH "</div>\n";
        }           
    }
    print FH "</ul>\n";
}

sub printTopPage {

    my $topPage = <<"ENDTOPPAGE";
<!-- https://www.w3schools.com/howto/howto_js_treeview.asp -->
<html>
    <head>
        <!-- <link rel="stylesheet" type="text/css" href="cwe.css" /> -->
        <style>
            /* Remove default bullets */
            ul, #myUL {
                list-style-type: none;
            }
            
            /* Remove margins and padding from the parent ul */
            #myUL {
                margin: 0;
                padding: 0;
            }
            
            /* Style the caret/arrow */
            .caret {
                cursor: pointer;
                user-select: none; /* Prevent text selection */
            }
            
            /* Create the caret/arrow with a unicode, and style it */
            .caret::before {
                content: "\\25B6";
                color: black;
                display: inline-block;
                margin-right: 6px;
            }
            
            /* Rotate the caret/arrow icon when clicked on (using JavaScript) */
            .caret-down::before {
                transform: rotate(90deg);
            }
            
            /* Hide the nested list */
            .nested {
                display: none;
            }
            
            /* Show the nested list when the user clicks on the caret/arrow (with JavaScript) */
            .active {
                display: block;
            }
        </style>
        <script type = "text/javascript">  
            function expandAll () {
                var expander = document.getElementById( "expander" ).value;
                var carets = document.getElementsByClassName("caret");
                var nesteds = document.getElementsByClassName("nested");
                var cstyle,cstyle2, ctext, cvalue;

                if (expander == "0") {
                    cstyle = "caret";
                    cstyle2 = "nested";
                    cvalue = "1";
                    ctext = "Expand All";
                } else {
                    cstyle = "caret caret-down";
                    cstyle2 = "nested active";
                    cvalue = "0";
                    ctext = "Collapse All";
                }

                for (var i=0, max=carets.length; i < max; i++) {
                    //all[i].dispatchEvent(new Event("click"));
                    carets[i].className  = cstyle;
                    nesteds[i].className  = cstyle2;
                }
                document.getElementById("expander").value = cvalue;
                document.getElementById("expanderBTN").value = ctext;
            }
            function hideDeprecated () {
                var deprecated = document.getElementById( "deprecated" ).value;
                var elements = document.querySelectorAll('.deprecated')
                for (index = 0; index < elements.length; index++) {
                    element = elements[index];
                    if (deprecated == "0") {
                        element.style.display = 'none';
                    } else {
                        element.style.display = '';
                    }
                }

                if (deprecated == "0") {
                    cvalue = "1";
                    ctext = "Show Deprecated";
                } else {
                    cvalue = "0";
                    ctext = "Hide Deprecated";
                
                }
                document.getElementById("deprecated").value = cvalue;
                document.getElementById("deprecatedBTN").value = ctext;
            }
            function checkTree (id_in) {
                var parent;
                var count = 0;
                var id = "";
                var checked = document.getElementById(id_in).checked;
                uncheckElements();

                try {
                    count = id_in.match(/:/g).length;
                } catch (error) {
                }
                if (count > 0) { element
                    count++;
                    crumbs = id_in.split(":",count);
                    for (let i = 0; i < count; i++) {
                        id = id + crumbs[i];
                        document.getElementById(id).checked = checked;
                        id = id + ":";
                    }
                } else {
                    document.getElementById(id_in).checked = checked;
                }
            }
            function uncheckElements()
            {
                var uncheck=document.getElementsByTagName('input');
                for(var i = 0; i < uncheck.length; i++) {
                    if (uncheck[i].type == 'checkbox') {
                        uncheck[i].checked = false;
                    }
                }
            }
        </script>
    </head>
    <body>
    <input type="hidden" id="expander" value="1"/>
    <input type="hidden" id="deprecated" value="0"/>
    <input type="button" onclick="expandAll();" id="expanderBTN" value="Expand All"/>
    <input type="button" onclick="hideDeprecated();" id="deprecatedBTN" value="Hide Deprecated"/>
ENDTOPPAGE
    print FH "$topPage\n";
}

sub printBottomPage {

    my $bottomPage = <<"ENDBOTTOMPAGE";
            <script>
        var toggler = document.getElementsByClassName("caret");
        var i;
        
        for (i = 0; i < toggler.length; i++) {
            toggler[i].addEventListener("click", function() {
            this.parentElement.querySelector(".nested").classList.toggle("active");
            this.classList.toggle("caret-down");
            });
        }
        </script>
    
    </body>
</html>
ENDBOTTOMPAGE
    print FH "$bottomPage\n";
}

# debug output
if ($DUMPER) {
    print Dumper($data);
}
my @sorted_rootCWES = sort { int($a) <=> int($b) } @rootCWES;
if ($DEBUG) { print "THE ROOTS\n"; }
if ($DEBUG) { print Dumper(@sorted_rootCWES); }

if ($DEBUG) { print "THE CWE Details\n"; }
foreach my $sortedCWE (sort { int($a) <=> int($b) } keys %CWEData) {
    if ($DEBUG) { printf "%-8s %s\n", $sortedCWE, $CWEData{$sortedCWE}->{'name'}; }
}
if ($DUMPER) {
    print Dumper(%CWEData)
}
if ($DEBUG) { print "THE CWE Details\n"; }
foreach my $sortedCWEChildren (sort { int($CWEChildren{$a}) <=> int($CWEChildren{$b}) } keys %CWEChildren) {
    if ($DEBUG) {
        printf "%-8s\n", $sortedCWEChildren; 
        print Dumper(@CWEChildren{$sortedCWEChildren});
    }
}
if ($DUMPER) {
    print Dumper(%CWEChildren);
}
if ($DEBUG) { print "$_\n" for sort keys %CWEChildren; }

#print to file
printTopPage();
printTree(@sorted_rootCWES);
printBottomPage();

close(FH);
