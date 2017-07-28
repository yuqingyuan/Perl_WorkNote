use File::Copy; 
# get fileName from terminal
$fileName = $ARGV[1];
$fileName = $fileName."/*";
# percentage 1~9 equals 10%~90%
$optionalValue = $ARGV[0];
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
$dividedSize = 3;
# the number of folders needed to be divided by details
$numberOfFolders = 0;
# store folders number
@numberOfFolder;

if($numberOfArgv != 2){
	print "you must insert two arguments\n example: perl xxx.pl optionalValue(1~9) FilePath\n";
	exit 1;
}else{
	#getNumberOfBoms($fileName);
	#dividedByRows();
	#selectByDetails();
	dividedByValue();
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
			print "$_"."---------"."success\n";
			
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

sub selectByDetails{
	#skip the folder catains only one file and store the files which needed to be compared into an Array
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
	
}

# divide files by optionalValue
sub dividedByValue{
	@files = glob($fileName."/");
	# all files
	$numberOfFiles = @files - 2;
	$numberOfFolders = $numberOfFiles;
	
	#tmp code
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

	foreach(@numberOfFolder){
		@file = glob($detailPath."$_");
		foreach(@file){
			#open each folder and read files
			
		}
	}
	
}





