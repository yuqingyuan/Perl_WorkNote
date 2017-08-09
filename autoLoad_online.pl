use Win32::GuiTest qw( :ALL );

$itemsFile = $ARGV[0];

$userName = "ADMIN";
$passWord = "equbeprodadmin";

@windows = FindWindowLike(0,"Migration Tool");

$handle = $windows[0];
my ($x,$y,$width,$height) = GetWindowRect($handle);
#print "($x,$y)-($width,$height)\n";

#insert userName
MouseMoveAbsPix(($width+$x)/2,($height+$y)/2+68);
SendMouse('{LEFTCLICK}');
SendKeys($userName);
#insert userName
MouseMoveAbsPix(($width+$x)/2,($height+$y)/2+95);
SendMouse('{LEFTCLICK}');
SendKeys($passWord);
SendKeys('{ENTER}');
sleep(3);

$data = "";

sub beginLoad{
    MouseMoveAbsPix($width/7*2.2+$x,$y+140);
    SendMouse('{LEFTCLICK}');
    sleep(1);
    MouseMoveAbsPix($width/7*2.2+$x,$y+180);
    SendMouse('{LEFTCLICK}');
    sleep(2);
    MouseMoveAbsPix($width/7+$x,$y+280);
    SendMouse('{LEFTCLICK}');
    SendKeys($data);
    MouseMoveAbsPix($width/7/2+$x,$y+390);
    SendMouse('{LEFTCLICK}');
    sleep(2);
    MouseMoveAbsPix($width/7+$x,$y+329);
    SendMouse('{LEFTCLICK}');
    sleep(4);
    MouseMoveAbsPix($x+20,$y+270);
    SendMouse('{LEFTCLICK}');
    sleep(2);
    #可能会出现重复的情况
    SendKeys($data."_retry");
    SendKeys('{ENTER}');
    sleep(3);
    MouseMoveAbsPix($x+20,$y+270);
    SendMouse('{LEFTCLICK}');
    SendKeys('{ENTER}');
    MouseMoveAbsPix($x+140,$y+270);
    SendMouse('{LEFTCLICK}');
    sleep(2);
    SendKeys('{ENTER}');
    sleep(2);
    SendKeys('{ENTER}');
}

open DATA,"<",$itemsFile or die "read file failed";
while(<DATA>){
    chomp($_);
    $data = $_;
    #请先打开Migration Tool的网址(IE浏览器)
    beginLoad();
}