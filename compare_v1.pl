use WWW::Mechanize;
use HTTP::Cookies;

$userName = "acaiwo";
$passWord = "Migration12!@";

$mech;

sub getLoginView{	
	$mech = WWW::Mechanize->new();

	$mech->credentials('acaiwo' => 'acaiwo');

	$mech->get("http://yfjcmigprod.autoexpr.com/CAD/");
	
	$mech->get("menu.jsp");
	
	@links = $mech->find_all_links() or die $!;

	$compareUrl = "PLMEPICBOMCompare.jsp";
	
	foreach(@links){
		$url = $_->url();
		if($url eq "inputPLMUP.jsp"){
			$mech->get($url);
			last;
		}
	}
	
	$a = $mech->submit_form(
		fields =>{
			PLMUser => $userName,
			PLMPass => $passWord,
		},
	);
	
	$mech->get($compareUrl);
	
	print $mech->content;
}

$plmSite = "BUR_PROD";
%left = ('SourceLeft' => 'PLM','PartTypeLeft' => 'Part','PartNo1' => '','PartRev1' => '');
%right = ('SourceRight' => 'EPIC','PartTypeRight' => 'Part','PartNo2' => '','PartRev2' => '');;

sub sendRequest{
	
	
	
	
}

getLoginView();