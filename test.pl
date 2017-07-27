use File::Copy; 

# get fileName from terminal
$fileName = $ARGV[0];
$fileName = $fileName."/*";
# store the name of file
$storeName = "";
# use hash to store
%storeList;
# the path of files
$filePath = "C:/CATDM/tmp/Divided/";
# get number from file
sub getNumberOfBoms{
    my @files = glob($_[0]);

    foreach(@files){
        $numberOfBoms = 0;
        $fileQuantity += 1;
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
	while($sizeOfHash!=1){
		#print "$storeList{$List[$flag]}";
		$flagNumber = $storeList{$List[0]};
		
		$count += 1;
		
		for($flag2 = 1;$flag2 <$sizeOfHash;$flag2 += 1){
			
			if(abs($storeList{$List[$flag2]} - $flagNumber) < 3){
				$newHashCount = $storeList{$List[$flag2]} - $flagNumber;
				
				#print "$newHashCount"." ";
				
				#store into a new HashMap
				$newHash{$List[$flag2]} = $storeList{$List[$flag2]};
				delete $storeList{$List[$flag2]};
			}else{
				#skip the loop this time
			}
		}
		#print "$sizeOfHash"."\n";
		
		$newHash{$List[0]} = $storeList{$List[0]};
		delete $storeList{$List[0]};
	
		@newList = keys % newHash;
		$sizeOfNewHash = @newList;
		
		#tmpPath ------ temporary path to store
		$tmpPath = $filePath."$fileCount";
		mkdir($tmpPath) or die "failed";
		$fileCount += 1;
		
		foreach(@newList){
			print "$_"."---------"."$newHash{$_}"."\n";
			
			#remove files in newHash to new folder divided by count
			move($_,$tmpPath);
			
		}
		
		@List = keys % storeList;
		$sizeOfHash = @List;
		
		if($sizeOfHash == 1){
			print "$List[0]"."--------"."$storeList{$List[0]}"."\n";
		}
	}
	
	print "----$count--------$sizeOfNewHash";
}

getNumberOfBoms($fileName);

dividedByRows();
