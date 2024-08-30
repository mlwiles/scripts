#!c:/Perl64/bin/perl.exe

use LWP::UserAgent;
my $ua = LWP::UserAgent->new;
my $server_target = "https://www.bing.com/customerfeedback/queue/full/submission";
$ua->ssl_opts( verify_hostname => 0 );

#################################################################
# set custom HTTP request header fields
my $req = HTTP::Request->new(POST => $server_target);

#$req->header(':authority' => 'www.bing.com');
#$req->header(':method' => 'POST');
#$req->header(':path' => '/customerfeedback/queue/full/submission');
#$req->header(':scheme' => 'https');
$req->header('accept' => '*/*');
$req->header('accept-encoding' => 'gzip, deflate, br');
$req->header('accept-language' => 'en-US,en;q=0.9');
$req->header('content-length' => '545681');
$req->header('content-type' => 'text/plain;charset=UTF-8');
#$req->header('cookie' => 'MUID=18B6B6F7AC2267F91FC8BB07A82264CB; MUIDB=18B6B6F7AC2267F91FC8BB07A82264CB; SRCHD=AF=NOFORM; SRCHUID=V=2&GUID=5EC65D75CA8B49DC81E5A2E516347DFF&dmnchg=1; _EDGE_S=SID=35B7E0417F5063D43B5FEE777ED26205; _HPVN=CS=eyJQbiI6eyJDbiI6MSwiU3QiOjAsIlFzIjowLCJQcm9kIjoiUCJ9LCJTYyI6eyJDbiI6MSwiU3QiOjAsIlFzIjowLCJQcm9kIjoiSCJ9LCJReiI6eyJDbiI6MSwiU3QiOjAsIlFzIjowLCJQcm9kIjoiVCJ9LCJBcCI6dHJ1ZSwiTXV0ZSI6dHJ1ZSwiTGFkIjoiMjAxOS0xMi0yMlQwMDowMDowMFoiLCJJb3RkIjowLCJEZnQiOm51bGwsIk12cyI6MCwiRmx0IjowLCJJbXAiOjF9; _RwBf=s=70&o=18&g=0; SRCHUSR=DOB=20191218&T=1577052973000; SRCHHPGUSR=WTS=63712649773; _SS=SID=30FC18ED4F676178031816DB4EE560E7&R=-1&RG=200&RP=-1&RD=0&RM=0&RE=0&HV=1577053008');
$req->header('origin' => 'https://www.bing.com');
$req->header('referer' => 'https://www.bing.com/maps?FORM=Z9LH2');
$req->header('sec-fetch-mode' => 'cors');
$req->header('sec-fetch-site' => 'same-origin');
#$req->header('user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36');


#################################################################
# add POST data to HTTP request body
my $post_data = '{"FORM":"Problem With Search","Query":"2989 thurman dairy rd, wake forest, nc","MapStyle":"Road","MapViewBoundingBox":{"NELatLon":{"Latitude":35.925461881903374,"Longitude":-78.51093578338623},"SWLatLon":{"Latitude":35.91792033192294,"Longitude":-78.5555248260498}},"MapViewCenter":{"Latitude":35.92072677612303,"Longitude":-78.52415370941162},"Zoom":16,"FeedbackType":"DSAT","Scenario":"Map","Issue":"Location is incorrect","UserComment":"The location is inaccurate on the map.","SuggestedEntity":{"GeoLocation":{"Latitude":35.921202189891,"Longitude":-78.5315293749317},"SuggestedEntityType":"Place"},"IsPushpinMoved":true,"ScenarioKey":"ELG","IssueEntity":{"GeoLocation":{"Latitude":35.92072677612305,"Longitude":-78.52848815917969},"Name":"2989 Thurman Dairy Loop, Wake Forest, NC 27587","Identifier":{"Identifier":"sid:986285f6-8d5c-c59e-74c4-2ffe661f4e46"}},"IssueEntityType":"Place","SearchImpressionGuid":"58CC352617D94E13819D542D4AE6690E|Active","TraceID":"326E1F734A0D45EB847B35FB1D4FF8E6|Active","ImpressionGuid":"342428F493C8473CAD27F91A7D0AD80C","ReproURL":"https://www.bing.com/maps?&cp=35.921691~-78.53323&lvl=16&osid=c0f0323e-cb46-4a70-b449-fd753ce5c0ac&v=2&sV=2&form=S00027","SchemaVersion":"2.0","ClientType":"MapWebsite","ClientMarket":"en-us","html":"<html lang=\"en\" xml:lang=\"en\" xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:web=\"http://schemas.live.com/Web/\" class=\"gr__bing_com\" style=\"overflow-y: auto;\"><link type=\"text/css\" id=\"dark-mode\" rel=\"stylesheet\" href=\"\"><style type=\"text/css\" id=\"dark-mode-custom-style\"></style><head><script src=\"https://apis.google.com/_/scs/apps-static/_/js/k=oz.gapi.en.xh-S9KbEGSE.O/m=client/rt=j/sv=1/d=1/ed=1/am=AQc/rs=AGLTcCMI6cckfOgfLoXSkY9UoCFGZek6-A/cb=gapi.loaded_0\" async=\"\"></script><script type=\"text/javascript\">//<![CDATA[\nsi_ST=new Date\n//]]></script><!--pc--><title>Bing Maps - Directions, trip planning, traffic cameras &amp; more</title><meta content=\"IE=Edge\" http-equiv=\"X-UA-Compatible\"><meta content=\"Map, directions, Traffic information, Road trip, Maps and directions, Road conditions, Driving directions, Satellite, Street view, Mapquest, Zip codes, Road maps, Yelp, Google maps, Travel, transit, Bus schedule, Birds eye view\" name=\"keywords\"><meta content=\"Map multiple locations, get transit/walking/driving directions, view live traffic conditions, plan trips, view satellite, aerial and street side imagery. Do more with Bing Maps.\" name=\"description\"><meta content=\"NOODP\" name=\"robots\"><meta content=\"Bing Maps\" property=\"og:title\"><meta content=\"Map multiple locations, get transit/walking/driving directions, view live traffic conditions, plan trips, view satellite, aerial and street side imagery. Do more with Bing Maps.\" property=\"og:description\"><meta content=\"Bing Maps\" property=\"og:site_name\"><meta content=\"Website\" property=\"og:type\"><meta content=\"2249142638525661\" property=\"fb:app_id\"><meta content=\"http://www.bing.com/sa/simg/mapShow more';
$req->content($post_data);

#################################################################
# check the HTTP response
my $resp = $ua->request($req);
if ($resp->is_success)
{
   print "HTTP POST success code: ", $resp->code, "\n";
   print "HTTP POST success message: ", $resp->message, "\n";
}
else
{
   print "HTTP POST error code: ", $resp->code, "\n";
   print "HTTP POST error message: ", $resp->message, "\n";
} 

# {FORM: "Problem With Search", Query: "2989 thurman dairy rd, wake forest, nc", MapStyle: "Road",…}
# FORM: "Problem With Search"
# Query: "2989 thurman dairy rd, wake forest, nc"
# MapStyle: "Road"
# MapViewBoundingBox: {NELatLon: {Latitude: 35.925461881903374, Longitude: -78.51093578338623},…}
# MapViewCenter: {Latitude: 35.92072677612303, Longitude: -78.52415370941162}
# Latitude: 35.92072677612303
# Longitude: -78.52415370941162
# Zoom: 16
# FeedbackType: "DSAT"
# Scenario: "Map"
# Issue: "Location is incorrect"
# UserComment: "The location is inaccurate on the map."
# SuggestedEntity: {GeoLocation: {Latitude: 35.921202189891, Longitude: -78.5315293749317}, SuggestedEntityType: "Place"}
# IsPushpinMoved: true
# ScenarioKey: "ELG"
# IssueEntity: {GeoLocation: {Latitude: 35.92072677612305, Longitude: -78.52848815917969},…}
# IssueEntityType: "Place"
# SearchImpressionGuid: "58CC352617D94E13819D542D4AE6690E|Active"
# TraceID: "326E1F734A0D45EB847B35FB1D4FF8E6|Active"
# ImpressionGuid: "342428F493C8473CAD27F91A7D0AD80C"
# ReproURL: "https://www.bing.com/maps?&cp=35.921691~-78.53323&lvl=16&osid=c0f0323e-cb46-4a70-b449-fd753ce5c0ac&v=2&sV=2&form=S00027"
# SchemaVersion: "2.0"
# ClientType: "MapWebsite"
# ClientMarket: "en-us"
# html: "<html lang="en" xml:lang="en" xmlns="http://www.w3"
# width: 2077
# height: 453
# partner: "SUrFLegacy"  

#{"FORM":"Problem With Search","Query":"2989 thurman dairy rd, wake forest, nc","MapStyle":"Road","MapViewBoundingBox":{"NELatLon":{"Latitude":35.925461881903374,"Longitude":-78.51093578338623},"SWLatLon":{"Latitude":35.91792033192294,"Longitude":-78.5555248260498}},"MapViewCenter":{"Latitude":35.92072677612303,"Longitude":-78.52415370941162},"Zoom":16,"FeedbackType":"DSAT","Scenario":"Map","Issue":"Location is incorrect","UserComment":"The location is inaccurate on the map.","SuggestedEntity":{"GeoLocation":{"Latitude":35.921202189891,"Longitude":-78.5315293749317},"SuggestedEntityType":"Place"},"IsPushpinMoved":true,"ScenarioKey":"ELG","IssueEntity":{"GeoLocation":{"Latitude":35.92072677612305,"Longitude":-78.52848815917969},"Name":"2989 Thurman Dairy Loop, Wake Forest, NC 27587","Identifier":{"Identifier":"sid:986285f6-8d5c-c59e-74c4-2ffe661f4e46"}},"IssueEntityType":"Place","SearchImpressionGuid":"58CC352617D94E13819D542D4AE6690E|Active","TraceID":"326E1F734A0D45EB847B35FB1D4FF8E6|Active","ImpressionGuid":"342428F493C8473CAD27F91A7D0AD80C","ReproURL":"https://www.bing.com/maps?&cp=35.921691~-78.53323&lvl=16&osid=c0f0323e-cb46-4a70-b449-fd753ce5c0ac&v=2&sV=2&form=S00027","SchemaVersion":"2.0","ClientType":"MapWebsite","ClientMarket":"en-us","html":"<html lang=\"en\" xml:lang=\"en\" xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:web=\"http://schemas.live.com/Web/\" class=\"gr__bing_com\" style=\"overflow-y: auto;\"><link type=\"text/css\" id=\"dark-mode\" rel=\"stylesheet\" href=\"\"><style type=\"text/css\" id=\"dark-mode-custom-style\"></style><head><script src=\"https://apis.google.com/_/scs/apps-static/_/js/k=oz.gapi.en.xh-S9KbEGSE.O/m=client/rt=j/sv=1/d=1/ed=1/am=AQc/rs=AGLTcCMI6cckfOgfLoXSkY9UoCFGZek6-A/cb=gapi.loaded_0\" async=\"\"></script><script type=\"text/javascript\">//<![CDATA[\nsi_ST=new Date\n//]]></script><!--pc--><title>Bing Maps - Directions, trip planning, traffic cameras &amp; more</title><meta content=\"IE=Edge\" http-equiv=\"X-UA-Compatible\"><meta content=\"Map, directions, Traffic information, Road trip, Maps and directions, Road conditions, Driving directions, Satellite, Street view, Mapquest, Zip codes, Road maps, Yelp, Google maps, Travel, transit, Bus schedule, Birds eye view\" name=\"keywords\"><meta content=\"Map multiple locations, get transit/walking/driving directions, view live traffic conditions, plan trips, view satellite, aerial and street side imagery. Do more with Bing Maps.\" name=\"description\"><meta content=\"NOODP\" name=\"robots\"><meta content=\"Bing Maps\" property=\"og:title\"><meta content=\"Map multiple locations, get transit/walking/driving directions, view live traffic conditions, plan trips, view satellite, aerial and street side imagery. Do more with Bing Maps.\" property=\"og:description\"><meta content=\"Bing Maps\" property=\"og:site_name\"><meta content=\"Website\" property=\"og:type\"><meta content=\"2249142638525661\" property=\"fb:app_id\"><meta content=\"http://www.bing.com/sa/simg/mapShow more
