use WWW::Mechanize;

$userName = "acaiwo";
$passWord = "xxx";

$mech = "";

sub getLogin{	
	$mech = WWW::Mechanize->new();
	
	#check the authorization
	$mech->credentials('acaiwo' => 'acaiwo');

	$mech->get("http://yfjcmigprod.autoexpr.com/CAD/menu.jsp");
	
	@links = $mech->find_all_links() or die $!;
	
	foreach(@links){
		$url = $_->url();
		if($url eq "inputPLMUP.jsp"){
			$mech->get($url);
			last;
		}
	}
	
	$mech->field("PLMUser",$userName);
	$mech->field("PLMPass",$passWord);
	$mech->submit();
	
	#move to the search view
	$compareUrl = "PLMEPICBOMCompare.jsp";
	$mech->get($compareUrl);
}

$plmSite = "BUR_PROD";
%left = ('SourceLeft' => 'PLM','PartTypeLeft' => 'Part','PartNo1' => '','PartRev1' => '');
%right = ('SourceRight' => 'EPIC','PartTypeRight' => 'Part','PartNo2' => '','PartRev2' => '');

sub setStatus{
	$mech->select("PLMSite",$plmSite);
	#set left part type
	$mech->select("PartTypeLeft",$left{"PartTypeLeft"});
	#set number
	$mech->set_fields("PartNo1",$left{"PartNo1"});
	#set rev
	$mech->set_fields("PartRev1",$left{"PartRev1"});
	
	#set right part
	$mech->select("SourceRight",$right{"SourceRight"});
	#set type
	$mech->select("PartTypeRight",$left{"PartTypeRight"});
	#set number
	$mech->set_fields("PartNo2",$left{"PartNo2"});
	#set rev
	$mech->set_fields("PartRev2",$left{"PartRev2"});
}

sub sendRequest{
	#get the request
	$mech->submit();
	print $mech->content;
}

getLogin();
setStatus();
sendRequest();
