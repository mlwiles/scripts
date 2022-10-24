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
use File::Copy;

# https://cwe.mitre.org/data/archive.html
#my $filename = 'cwec_v4.6.xml';
my $filename = 'cwec_v4.9.xml';

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

my $cweIDCount = 0;
my $cweIDCountStatusDeprecated = 0;
my $cweIDCountStatusDraft = 0;
my $cweIDCountStatusIncomplete = 0;
my $cweIDCountStatusStable = 0;
my $cweIDCountStatusOther = 0;

my $cweVersion = $data->{Version};
my $cweDate = $data->{Date};

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

    if ($weakness_node->{Status} =~ /^Draft/) {
        $cweIDCountStatusDraft++;
    } elsif ($weakness_node->{Status} =~ /^Incomplete/) {
        $cweIDCountStatusIncomplete++;
    } elsif ($weakness_node->{Status} =~ /^Deprecated/) {
        $cweIDCountStatusDeprecated++;
    } elsif ($weakness_node->{Status} =~ /^Stable/) {
        $cweIDCountStatusStable++;
    } else {
        if ($DEBUG) { print "weakness_node->{Status}=$weakness_node->{Status}\n" };
        $cweIDCountStatusOther++;
    }
    
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
        if ($c_name =~ /^DEPRECATED/){
            print FH "<div class=\"deprecated\">\n";
        }
        
        print FH "<li><input type=\"checkbox\" id=\"$newbreadcrumbs:$child_id\" name=\"$newbreadcrumbs:$child_id\" value=\"$newbreadcrumbs:$child_id\" onclick=\"checkTree('$newbreadcrumbs:$child_id');\"><span class=\"caret\"><span id=\"div$newbreadcrumbs:$child_id\" class=\"cwedata\" data-hover=\"CWE-$child_id:$c_name -- $c_desc\"><a href=\"https://cwe.mitre.org/data/definitions/$child_id.html\" target=\"_blank\">CWE-$child_id</a>:$c_name</span></span>\n";
        print FH "<ul class=\"nested\">\n";
        
        #print children recursively here
        getCWEChildren($child_id, $newbreadcrumbs);
        print FH "</ul>\n";
        print FH "</li>\n";

        if ($c_name =~ /^DEPRECATED/){
            print FH "</div>\n";
        }
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
        print FH "<li><input type=\"checkbox\" id=\"$root_id\" name=\"$root_id\" value=\"$root_id\" onclick=\"checkTree('$root_id');\"><span class=\"caret\"><span id=\"div$root_id\" class=\"cwedata\" data-hover=\"CWE-$root_id:$c_name -- $c_desc\"><a href=\"https://cwe.mitre.org/data/definitions/$root_id.html\" target=\"_blank\">CWE-$root_id</a>:$c_name</span></span>\n";
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
            span, input, td {
                font-family: Tahoma, Verdana, sans-serif;
            }

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

            .highlight {
                background-color: yellow;
            }

            .hovertext {
                position: relative;
                border-bottom: 1px dotted black;
            }

            .hovertext:before {
                content: attr(data-hover);
                visibility: hidden;
                opacity: 0;
                width: 600px;
                background-color: black;
                color: #fff;
                text-align: center;
                border-radius: 5px;
                padding: 5px 0;
                transition: opacity 1s ease-in-out;

                position: absolute;
                z-index: 1;
                left: 0;
                top: 110%;
            }

            .hovertext:hover:before {
                opacity: 1;
                visibility: visible;
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
                var div = "";
                var divid = "";
                var checked = document.getElementById(id_in).checked;
                var classnames = "";
                uncheckElements();
                unHighlightElements();

                try {
                    count = id_in.match(/:/g).length;
                } catch (error) {
                }
                if (checked) {
                    if (count > 0) {
                        count++;
                        crumbs = id_in.split(":",count);
                        for (let i = 0; i < count; i++) {
                            id = id + crumbs[i];
                            document.getElementById(id).checked = checked;
                            divid = "div" + id
                            div = document.getElementById(divid);
                            classnames = div.className
                            classnames = classnames + " highlight";
                            div.className  = classnames;
                            id = id + ":";
                        }
                    } else {
                        document.getElementById(id_in).checked = checked;
                        divid = "div" + id_in
                        div = document.getElementById(divid);
                        classnames = div.className
                        classnames = classnames + " highlight";
                        div.className  = classnames;
                    }
                    document.getElementById("copytextBTN").disabled = false;
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
                document.getElementById("copytextBTN").disabled = true;
            }
            function unHighlightElements()
            {
                var div=document.getElementsByClassName('cwedata');
                var classnames = "";
                for(var i = 0; i < div.length; i++) {
                    classnames = div[i].className
                    classnames = classnames.replace("highlight", "");
                    div[i].className  = classnames;
                }
            }
            function loadCounts() {
                var cweIDCount = document.getElementById('cweIDCountDisplay');
                cweIDCount.innerHTML = document.getElementById('cweIDCountHidden').value;
                cweIDCount.style.fontWeight = "bold";
                var cweIDCountStatusDeprecated = document.getElementById('cweIDCountStatusDeprecatedDisplay');
                cweIDCountStatusDeprecated.innerHTML = document.getElementById('cweIDCountStatusDeprecatedHidden').value;
                cweIDCountStatusDeprecated.style.fontWeight = "bold";
                var cweIDCountStatusIncomplete = document.getElementById('cweIDCountStatusIncompleteDisplay');
                cweIDCountStatusIncomplete.innerHTML = document.getElementById('cweIDCountStatusIncompleteHidden').value;
                cweIDCountStatusIncomplete.style.fontWeight = "bold";
                var cweIDCountStatusStable = document.getElementById('cweIDCountStatusStableDisplay');
                cweIDCountStatusStable.innerHTML = document.getElementById('cweIDCountStatusStableHidden').value;
                cweIDCountStatusStable.style.fontWeight = "bold";
                var cweIDCountStatusDraft = document.getElementById('cweIDCountStatusDraftDisplay');
                cweIDCountStatusDraft.innerHTML = document.getElementById('cweIDCountStatusDraftHidden').value;
                cweIDCountStatusDraft.style.fontWeight = "bold";
                var cweIDCountStatusOther = document.getElementById('cweIDCountStatusOtherDisplay');
                cweIDCountStatusOther.innerHTML = document.getElementById('cweIDCountStatusOtherHidden').value;
                cweIDCountStatusOther.style.fontWeight = "bold";
            }
            function toggleHoverText() {
                var hover = document.getElementById("hover").value;
                var classnames = "";
                var ctext = "";
                var htext = hover;

                var div=document.getElementsByClassName('cwedata');
                for(var i = 0; i < div.length; i++) {
                    classnames = div[i].className
                    if (hover == "0") {
                        classnames = classnames + " hovertext";
                        ctext ="Hide HoverText";
                        htext = "1";
                    } else {
                        classnames = classnames.replace("hovertext", "")
                        ctext = "Show HoverText";
                        htext = "0";
                    }
                    div[i].className  = classnames;
                }        
                document.getElementById("hovertextBTN").value = ctext;
                document.getElementById("hover").value = htext;
            }
            function textToClipBoard() {
                var count = 0;
                var checked = document.querySelectorAll('input[type=checkbox]:checked');
                var id = "";
                var divid = "";
                var div = "";
                var cbtext = "";

                if (checked) {
                    for(var i = 0; i < checked.length; i++) {
                        id = checked[i].id;
                        document.getElementById(id).checked = checked;
                        divid = "div" + id
                        div = document.getElementById(divid);
                        cbtext = cbtext + div.textContent + "\\n";
                    }
                    copyTextToClipboard(cbtext);
                }
            }
            async function copyTextToClipboard(text) {
                try {
                    await navigator.clipboard.writeText(text);
                        alert('Text copied to clipboard');
                    } catch(err) {
                        alert('Error in copying text: ', err);
                }
            }
            function checkVersion() {
                var current = $cweVersion;
                let xmlHttpReq = new XMLHttpRequest();
                xmlHttpReq.open("GET", "https://cwe.mitre.org/data/index.html", false); 
                xmlHttpReq.setRequestHeader("Access-Control-Allow-Origin", "*");
                xmlHttpReq.setRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;");
                xmlHttpReq.send(null);
                alert(xmlHttpReq.responseText);
            }
        </script>
    </head>
    <body body onLoad="loadCounts();" bgcolor="lightblue">
    <input type="hidden" id="hover" value="0"/>
    <input type="hidden" id="expander" value="1"/>
    <input type="hidden" id="deprecated" value="0"/>

    <center>
    <table>
    <tr><td colspan="2" align="center"><b>CWETree</b></td></tr>
    <tr><td>Generated from CWE Version:</td><td td align="right"><b>$cweVersion ($cweDate)</b></td></tr>
    <!-- <tr><td>&nbsp;</td><td td align="right"><input type="button" onclick="checkVersion();" id="versionBTN" value="Check Version"/></td></tr> -->
    <tr><td><b>TOTAL</b> Number of CWE Weaknesses:</td><td align="right" id="cweIDCountDisplay"></td></tr>
    <tr><td>Number of Deprecated CWE Weaknesses:</td><td align="right" id="cweIDCountStatusDeprecatedDisplay"></td></tr>
    <tr><td>Number of Incomplete CWE Weaknesses:</td><td align="right" id="cweIDCountStatusIncompleteDisplay"></td></tr>
    <tr><td>Number of Stable CWE Weaknesses:</td><td align="right" id="cweIDCountStatusStableDisplay"></td></tr>
    <tr><td>Number of Draft CWE Weaknesses:</td><td align="right" id="cweIDCountStatusDraftDisplay"></td></tr>
    <tr><td>Number of Other CWE Weaknesses:</td><td align="right" id="cweIDCountStatusOtherDisplay"></td></tr>
    </table>
    </center>

    <br><br>

    <input type="button" onclick="expandAll();" id="expanderBTN" value="Expand All"/>
    <input type="button" onclick="hideDeprecated();" id="deprecatedBTN" value="Hide Deprecated"/>
    <input type="button" onclick="toggleHoverText();" id="hovertextBTN" value="Show HoverText"/>
    <input type="button" onclick="textToClipBoard();" id="copytextBTN" value="Copy Selected to Clipboard" disabled="true"/>
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
        <input type="hidden" id="cweIDCountHidden" value="$cweIDCount">
        <input type="hidden" id="cweIDCountStatusDraftHidden" value="$cweIDCountStatusDraft">
        <input type="hidden" id="cweIDCountStatusIncompleteHidden" value="$cweIDCountStatusIncomplete">
        <input type="hidden" id="cweIDCountStatusStableHidden" value="$cweIDCountStatusStable">
        <input type="hidden" id="cweIDCountStatusDeprecatedHidden" value="$cweIDCountStatusDeprecated">
        <input type="hidden" id="cweIDCountStatusOtherHidden" value="$cweIDCountStatusOther">
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
$cweIDCount = $cweIDCountStatusDraft;
$cweIDCount += $cweIDCountStatusIncomplete;
$cweIDCount += $cweIDCountStatusStable;

printTopPage();
printTree(@sorted_rootCWES);
printBottomPage();

print "cweIDCount=$cweIDCount\n";
print "cweIDCountStatusDeprecated=$cweIDCountStatusDeprecated\n";
print "cweIDCountStatusDraft=$cweIDCountStatusDraft\n";
print "cweIDCountStatusIncomplete=$cweIDCountStatusIncomplete\n";
print "cweIDCountStatusStable=$cweIDCountStatusStable\n";
print "cweIDCountStatusOther=$cweIDCountStatusOther\n";

close(FH);

my $newfile = "..\\..\\..\\www\\cwe\\index.html";
copy($filename, $newfile);
