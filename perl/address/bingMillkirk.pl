#!c:/Perl64/bin/perl.exe

use LWP::UserAgent;
my $ua = LWP::UserAgent->new;
my $server_target = "http://www.bing.com/customerfeedback/queue/full/surf?ft=Maps.Search&src=Location&id=35627&cm=en-us&ct=MapWebsite";
 
#################################################################
# set custom HTTP request header fields
my $req = HTTP::Request->new(POST => $server_target);
$req->header('content-type' => 'application/json; charset=UTF-8');
$req->header('host' => 'www.bing.com');
$req->header('connection' => 'keep-alive');
$req->header('content-length' => '1067');
$req->header('origin' => 'http://www.bing.com');
$req->header('user-agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.65 Safari/537.36');
$req->header('accept' => '*/*');
$req->header('referer' => 'http://www.bing.com/maps/');
$req->header('accept-encoding' => 'gzip, deflate');
$req->header('accept-language' => 'en-US,en;q=0.8');
$req->header('cookie' => 'MUID=2303EC27F0106EFE39D4EAD1F4106862; SRCHD=AF=NOFORM; SRCHUID=V=2&GUID=B3CAE21AF00547D9AF15660E6F93BA39; SRCHUSR=AUTOREDIR=0&GEOVAR=&DOB=20141127; _EDGE_S=SID=1821A4A656E364B833C2A259579265E6; MUIDB=2303EC27F0106EFE39D4EAD1F4106862; _RwBf=s=70&o=16; _SS=SID=0EAB00BFB6C54904B6E78CAC38D3B039&C=20&R=0&nhIm=83-; RMS=F=OAAABAAAAAR; WLS=TS=63552702106; _HOP=');

#################################################################
# add POST data to HTTP request body
my $post_data = '{"ReproURL":"http://www.bing.com/maps/?v=2&cp=35.977118~-78.509350&lvl=12&sty=r&q=9409%20millkirk%20circle%2C%20wake%20forest%2C%20nc","MapViewCenter":{"Latitude":35.97711753845215,"Longitude":-78.50934982299805},"MapViewBoundingBox":{"NELatLon":{"Latitude":36.073883453739256,"Longitude":-78.39038848876953},"SWLatLon":{"Latitude":35.88023284103477,"Longitude":-78.62831115722656}},"ProblemDescription":"I am trying to sell my home and many of the realtor sites are powered by bing maps ...\nplease add Millkirk residents to your database (Goggle, Yahoo, and MapQuest all have the correct information)\n9409 Millkirk Cir\nWake Forest, NC 27587\n36.037928, -78.638487\nThank you,\nMike Wiles\nmike.lee.wiles@gmail.com","SuggestedEntity":{"GeoLocation":{"Latitude":36.03792666315582,"Longitude":-78.6390151977539}},"GeoEntityType":"PopulatedPlace","OriginalEntity":{"Name":"Wake Forest, NC","Identifier":{"Identifier":"35627"},"GeoLocation":{"Latitude":35.97509002685547,"Longitude":-78.50752258300781}},"SubScenario":"Location result displayed at incorrect location"}';
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

# the schema of the HTTP request body that is being sent
#{
#   "ReproURL":"http://www.bing.com/maps/?v=2&cp=35.977118~-78.509350&lvl=12&sty=r&q=9409%20millkirk%20circle%2C%20wake%20forest%2C%20nc",
#   "MapViewCenter":
#                   {
#                      "Latitude":35.97711753845215,
#                      "Longitude":-78.50934982299805
#                   },
#   "MapViewBoundingBox":
#                        {
#                           "NELatLon":
#                                      {
#                                         "Latitude":36.073883453739256,
#                                         "Longitude":-78.39038848876953
#                                      },
#                           "SWLatLon":
#                                      {
#                                         "Latitude":35.88023284103477,
#                                         "Longitude":-78.62831115722656
#                                      }
#                        },
#   "ProblemDescription":"I am trying to sell my home and many of the realtor sites are powered by bing maps ...\nplease add Millkirk residents to your database (Goggle, Yahoo, and MapQuest all have the correct information)\n9409 Millkirk Cir\nWake Forest, NC 27587\n36.037928, -78.638487\nThank you,\nMike Wiles\nmike.lee.wiles@gmail.com",
#   "SuggestedEntity":
#                     {
#                        "GeoLocation":
#                                      {
#                                         "Latitude":36.03792666315582,
#                                         "Longitude":-78.6390151977539
#                                      }
#                     },
#   "GeoEntityType":"PopulatedPlace",
#   "OriginalEntity":
#                    {
#                       "Name":"Wake Forest, NC",
#                       "Identifier":
#                                    {
#                                       "Identifier":"35627"
#                                    },
#                                    "GeoLocation":
#                                                  {
#                                                     "Latitude":35.97509002685547,
#                                                     "Longitude":-78.50752258300781
#                                                  }
#                    },
#   "SubScenario":"Location result displayed at incorrect location"
#}