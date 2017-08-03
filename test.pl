use File::Copy;
#get similiar percentage and file path from terminal
$optionalValue = $ARGV[0]/10;
$filePath = $ARGV[1];
#limit the number of ARGV
$numberOfArgv = @ARGV;
#path to store tmp files
$storePath = "C:/CATDM/tmp/";
%storeList;

@storeCompareFiles;
@compareArray_1 = ();
@compareArray_2 = ();

$matchCount = 0;
$repeatCount = 0;
#judge the the number of ARGV
if($numberOfArgv != 2){
	print "you must insert two arguments\n example: perl xxx.pl optionalValue(1~9) FilePath\n";
	exit 1;
}else{
	#run the functions
	getSingleRow();
	furtherCompare();
	detailCompare();
	finalCompare();
}
#get the number of Boms and get the single Bom out
sub getSingleRow{
	mkdir($storePath."SingleRow") or die "create folder failed";
	@files = glob($filePath."/*");
	foreach(@files){
		$numberOfBoms = 0;
		$fileName = $_;
		open DATA,"<",$_ or die "open files failed";
		while(<DATA>){
			$numberOfBoms += 1;
		}
		close DATA;
		#check the number of boms
		if($numberOfBoms == 1){
			#move the single row files to new Folder
			move($fileName,$storePath."SingleRow");
		}else{
			$storeList{$fileName} = splitFileName($fileName);
		}
	}
}
sub splitFileName{
	$compareString;
	$tmpString = reverse($_[0]);
	if($tmpString =~ /\//){
		$tmpString = reverse($`);
		if($tmpString =~ /.txt/){
			$compareString = substr($`,0,4);
		}
	}
	return $compareString;
}
sub furtherCompare{
	@a = keys % storeList;
	$loopCount = 0,$count = @a;
	$tmp,$tmpPath;
	while($count!=0){
		@a = keys % storeList;
		$count = @a;
		#when hash is empty break the loop
		if($count == 0){
			last;
		}
		$tmp = $storeList{$a[0]};
		$tmpPath = $storePath."Store/"."$storeList{$a[$loopCount]}";
		mkdir($tmpPath) or die "create folder failed\n";
		for($i = 1;$i < $count;$i += 1){
			if($tmp eq $storeList{$a[$i]}){
				move($a[$i],$tmpPath);
				delete $storeList{$a[$i]};
			}
		}
		move($a[$loopCount],$tmpPath);
		delete $storeList{$a[$loopCount]};
	}
}
sub detailCompare{
	$filesCount = 0;
	$folderName;
	$tmp = $storePath."Store/";
	@folders = glob($tmp."*");
	foreach(@folders){
		$folderName = $_;
		@files = glob($_."/*");
		foreach(@files){
			$filesCount += 1;
		}
		#folders can be compared
		if($filesCount > 1){
			push(@storeCompareFiles,$folderName);
		}
		$filesCount = 0;
	}
}
sub finalCompare{
	mkdir($storePath."Ignore") or die $!;
	$fileNumber = 0,$loop = 0;
	#start to compare
	foreach(@storeCompareFiles){
		@files = glob($_."/*");
		$loop = @files;
		for($i = 0;$i < $loop;$i += 1){
			undef @compareArray_1;
			open DATA_1,"<",$files[$i] or die "failed";
			#store in local Array
			while(<DATA_1>){
				chomp($_);
				push(@compareArray_1,$_);
			}
			for($j = $i + 1;$j < $loop;$j += 1){
				undef @compareArray_2;
				open DATA_2,"<",$files[$j] or die "failed";
				while(<DATA_2>){
					chomp($_);
					push(@compareArray_2,$_);
				}
				$flag = compareDetail();
				if($flag == 1){
					#move files
					$repeatCount = $repeatCount + 1;
					close DATA_1;
					move($files[$i],$storePath."Ignore") or die $!;
					last;
				}
				close DATA_2;
			}
		}
	}
	print "$repeatCount\n";
}
sub compareDetail{
	$count_1 = @compareArray_1;
	$count_2 = @compareArray_2;
	$percentage = 0;
	$tmp_1,$tmp_2;
	if($count_1<$count_2){
		foreach(@compareArray_1){
			$tmp_1 = $_;
			foreach(@compareArray_2){
				$tmp_2 = $_;
				if($tmp_1 eq $tmp_2){
					$matchCount += 1;
				}
			}
		}
		$percentage = $matchCount/$count_1;
	}else{
		foreach(@compareArray_2){
			$tmp_1 = $_;
			foreach(@compareArray_1){
				$tmp_2 = $_;
				if($tmp_1 eq $tmp_2){
					$matchCount += 1;
				}
			}
		}
		$percentage = $matchCount/$count_2;
	}
	$matchCount = 0;
	if($percentage > $optionalValue){
		$percentage = 0;
		return 1;
	}else{
		$percentage = 0;
		return 0;
	}
}