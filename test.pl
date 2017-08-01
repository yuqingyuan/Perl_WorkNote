use File::Copy; 
# get fileName from terminal
$fileName = $ARGV[1];
$fileName = $fileName."/*";
# percentage 1~9 equals 10%~90%
$optionalValue = $ARGV[0]/10;
$numberOfArgv = @ARGV;
# store the name of file
$storeName = "";
# use hash to store
%storeList;
# the path of files
$filePath = "C:/CATDM/tmp/Divided/";
# detail folders' Path
$detailPath = "C:/CATDM/tmp/Divided/";
# the number of rows you want to divided
$dividedSize = 10;
# the number of folders needed to be divided by details
$numberOfFolders = 0;
# store folders number
@numberOfFolder;
# store the files needed to be compared
@comparedFiles;

$matchPercentage = 0;

@uselessItem = "";
if($numberOfArgv != 2){
	print "you must insert two arguments\n example: perl xxx.pl optionalValue(1~9) FilePath\n";
	exit 1;
}else{
	getNumberOfBoms($fileName);
	dividedByRows();
	dividedByValue();
	removeRepeat();
}

# get number from file
sub getNumberOfBoms{
    my @files = glob($_[0]);

    foreach(@files){
        $numberOfBoms = 0;
        
        open DATA,"<",$_ or die "open files failed";
        
		$storeName = $_; 
        
		while(<DATA>){
            $numberOfBoms += 1;
        }
        
		#Build the HashMap
		$storeList{$storeName} = $numberOfBoms;
		
        #print "$storeName"."------$numberOfBoms"."\n";
		
    }
	close DATA;
}

sub dividedByRows{	
	@List = keys % storeList;
	#create a new HashMap
	my %newHash;
	#store the size of new HashMap
	my $newHashCount = 0;
	#check the number
	my $count = 0;
	#get size of HashMap
	my $sizeOfHash = @List;
	#the flag number
	my $flagNumber = 0;
	#count the file needed to be created
	my $fileCount = 0;
	#divide files by folders

	#move out the files contain single row
	for($singleRow = 0;$singleRow < $sizeOfHash;$singleRow += 1){
		#pick the single row and move into newHash
		$number = $storeList{$List[$singleRow]};
		
		if($storeList{$List[$singleRow]} == 1){
			$newHash{$List[$singleRow]} = $storeList{$List[$singleRow]};
			delete $storeList{$List[$singleRow]}
		}
	}
	
	#file to store single row files
	$singleRowFilePath = $filePath."SingleRow";
	mkdir($singleRowFilePath) or die "Create file failed";
	
	@tmpList = keys % newHash;
	
	foreach(@tmpList){
		move($_,$singleRowFilePath);
		delete $newHash{$_};
	}
	
	#refresh the size of Hash
	@List = keys % storeList;
	$sizeOfHash = @List;
	
	while($sizeOfHash!=0){
		#print "$storeList{$List[$flag]}";
		$flagNumber = $storeList{$List[0]};
		
		$count += 1;
		
		for($flag2 = 1;$flag2 < $sizeOfHash;$flag2 += 1){
			
			if(abs($storeList{$List[$flag2]} - $flagNumber) < $dividedSize){
				$newHashCount = $storeList{$List[$flag2]} - $flagNumber;
				
				#print "$newHashCount"." ";
				
				#store into a new HashMap
				$newHash{$List[$flag2]} = $storeList{$List[$flag2]};
				delete $storeList{$List[$flag2]};
			}else{
				#skip the loop this time
			}
		}
		
		#if the rows of file is too big,store it into single folder
		$newHash{$List[0]} = $storeList{$List[0]};
		delete $storeList{$List[0]};
	
		@newList = keys % newHash;
		$sizeOfNewHash = @newList;
		
		#tmpPath ------ temporary path to store
		$tmpPath = $filePath."$fileCount";
		mkdir($tmpPath) or die "failed";
		$fileCount += 1;
		
		foreach(@newList){
			#print "$_"."---------"."success\n";
			
			#remove files in newHash to new folder divided by count
			move($_,$tmpPath);
			
			delete $newHash{$_};
		}
		
		@List = keys % storeList;
		$sizeOfHash = @List;
		
		if($sizeOfHash == 0){
			print "Finish!"."\n";
		}
	}
	$numberOfFolders = $count - 1;
}

# divide files by optionalValue
sub dividedByValue{
	@files = glob($filePath."/*");
	# all files
	$numberOfFiles = @files - 1;
	$numberOfFolders = $numberOfFiles;
	
	#check out the folders which contain only one file
	while($numberOfFolders != -1){
		$filesCount = 0;
		$tmp = $detailPath.$numberOfFolders."/*";
		
		@tmpFiles = glob($tmp);
		
		foreach(@tmpFiles){
			$filesCount += 1;
		}
		
		if($filesCount == 1){
			#skip this folder
		}else{
			#mark folders' number
			push(@numberOfFolder,$numberOfFolders);
		}
		$numberOfFolders -= 1;
	}
	
	$tmpString = "";
	$tmpStirng_2 = "";
	$mark_1 = "";
	$mark_2 = "";
	 
	foreach(@numberOfFolder){
		@folder = glob($detailPath."$_");
		foreach(@folder){
			#open each folder and read files
			@files = glob($_."/*");
			$count = @files;
			for($flag = 0;$flag < $count;$flag += 1){
				$tmpString = reverse($files[$flag]);
				if($tmpString =~ /\//){
					$tmpString = reverse($`);
					if($tmpString =~ /.txt/){
						$mark_1 = substr($`,0,4);
					}
				}
				for($flag_2 = $flag + 1;$flag_2 < $count;$flag_2 += 1){
					$tmpString_2 = reverse($files[$flag_2]);
					if($tmpString_2 =~ /\//){
						$tmpString_2 = reverse($`);
						if($tmpString_2 =~ /.txt/){
							$mark_2 = substr($`,0,4);
						}
					}
					
					if($mark_1 == $mark_2 && $files[$flag] ne $files[$flag_2]){
						@array_1 = "";
						@array_2 = "";
						#start to compare detais here
						open DATA_1,"<",$files[$flag] or die "open files failed";
						
						foreach(<DATA_1>){
							chomp($_);
							push(@array_1,$_);
						}
						
						open DATA_2,"<",$files[$flag_2] or die "open files failed";
						
						foreach(<DATA_2>){
							chomp($_);
							push(@array_2,$_);
						}
						
						$count_1 = @array_1;
						$count_2 = @array_2;
						
						$loopCount = ($count_1 > $count_2)?$count_2:$count_1;
						$loopCount_2 = 0;
						if($count_1>$count_2){
							$loopCount = $count_2;
							$loopCount_2 = $count_1;
						}else{
							$loopCount = $count_1;
							$loopCount_2 = $count_2;
						}
						
						for($loop_1 = 0;$loop_1 < $loopCount;$loop_1 += 1){
							for($loop_2 = 0;$loop_2 < $loopCount_2 ;$loop_2 += 1){
								if($array_1[$loop_1] eq $array_2[$loop_2]){
									if($array_1[$loop_1] ne ""&&$array_2[$loop_2] ne ""){
										$matchPercentage += 1;
									}
								}
							}
						}
						if($loopCount == $count_1){
							$min = $matchPercentage/$count_1;
							if($min>$optionalValue){
								#print "$files[$flag]------$files[$flag_2]"."\n";
								$tmp = $files[$flag];
								push(@uselessItem,$tmp);
							}
						}else{
							$min = $matchPercentage/$count_2;
							if($min>$optionalValue){
								#print "$files[$flag]------$files[$flag_2]"."\n";
								$tmp = $files[$flag];
								push(@uselessItem,$tmp);
							}
						}
						
						$matchPercentage = 0;
						close DATA_1,DATA_2;
					}
					
				}
				
			}
		}
	}
}

#remove the repeat elements
sub removeRepeat{
	%saw;
	@saw{ @uselessItem } = ( );
	my @uniq_array = sort keys %saw;
	
	mkdir($filePath."IgnoreItem") or die "Create folder failed";
	
	foreach(@uniq_array){
		move($_,$filePath."IgnoreItem");
	}
	
}



