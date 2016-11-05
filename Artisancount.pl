#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;
use List::Util;


# Define Useful Hashes
my %fullname;
# ID -> Subfolder
my %provids;
# ID -> File name w/out .txt
my %idstoowner;
# ID -> Owner's Tag
my %idstotrade_good;
# ID -> trade_good Type
my %idstolife_rating;
# ID -> life rating

#Values for linking province history to ID
my $dh = 'C:\Program Files (x86)\Steam\SteamApps\common\Victoria 2\mod\Timeline\history\provinces';
my $folder;
my @subfolders = ( 'africa','asia','austria','australia','balkan','canada','carribean','central asia',
'china','france','germany','india','indonesia','italy','japan','low countries','mexico','pacific island',
'portugal', 'scandinavia', 'south america', 'soviet', 'spain', 'united kingdom', 'usa');
				
#create hashes connecting province id to file name and subdirectory
foreach my $sfolder (@subfolders){
	# Open Each Subdir and put the filenames in an array
	my $dir = "$dh\\$sfolder";
	opendir($folder, $dir);
	my @provfilenames = grep { /\.txt$/ } readdir($folder);
	
	# Make a hash in which the id can be used to find the full name
	foreach my $prov (@provfilenames){
		my $provid = substr($prov, 0, index($prov, ' '));
		$provids{$provid} = $prov;
		$fullname{$provid} = $sfolder;
	};
};

#Iterate over all provinces
foreach my $key (keys %fullname){
		# Open Each Province History File
		my $fullname = $provids{$key};
		my $sfolder = $fullname{$key};
		open(my $fh, "$dh/$sfolder/$fullname");
	
		
		while (my $row = <$fh>) {
			chomp $row;
			# Establish Owner Create Hash linking Owner to ProvID
			if ($row =~ m/^owner = .../){
				my @ownerline = split / /, $row;
				my $owner = $ownerline[2];
				$idstoowner{$key} = $owner;
			};
			# Establish trade_good Create Hash linking trade_good to ProvID
			my $trade_good;
			my @trade_goodline;
			if ($row =~ m/^trade_goods = /){
				my @trade_goodline = split / /, $row;
				$trade_good = $trade_goodline[2];
				$idstotrade_good{$key} = $trade_good;
			};
			# Establish life_ratong Create Hash linking life_rating to ProvID
			my $life_rating;
			my @life_ratingline;
			if ($row =~ m/^life_rating = /){
				my @life_ratingline = split / /, $row;
				$life_rating = $life_ratingline[2];
				$idstolife_rating{$key} = $life_rating;
			};
		};
};

#print Dumper(\%idstoowner);


# Connect pops to province ID 
#Creates Array of Arrays
#Each Array is Province ID, type, culture, religion, size

my $popdh = 'C:\Program Files (x86)\Steam\SteamApps\common\Victoria 2\mod\Timeline\history\pops\1836.1.1';
my @poptxt;
my $popfolder;
# take the directory to be processed from first command line argument
opendir($popfolder, $popdh);
# take only relevant files ie. "*.config"
@poptxt = grep { /\.txt$/ } readdir($popfolder);
# loop through files
my @poparray;
	
foreach my $txt(@poptxt) {
	open(my $fh, "$popdh\\$txt");
	my $id;
	my $poptype;
	my $culture;
	my $religion;
	my $size;
	my @pop;
	while (my $row = <$fh>){
		my $undefcnt = 0;
		# Strip out comments
		$row =~ s/^#.*//;
		# Extract and set province ID
		if ( $row =~ m/\d{1,4} =*/ ){
			($id) = $row =~ m/\d{1,4}/g;
			@pop[0] = $id;
		};
		#set poptype
		if ( $row =~ m/[a-z]{1,15} = \{/ ){
			($poptype) = $row =~ m/\w{1,15}/g;
			@pop[1] = $poptype;
		};
		# extract culture
		if ( $row =~ m/culture = */ ){
			my @cultureline = split(' ', $row);
			$culture = $cultureline[2];
			@pop[2] = $culture;
		};
		if ( $row =~ m/religion = */ ){
			my @religionline = split(' ', $row);
			$religion = $religionline[2];
			@pop[3] = $religion;
		};
		if ( $row =~ m/size = */ ){
			($size) = $row =~ m/\d{1,15}/g;
			@pop[4] = $size;
			@pop[5] = $idstoowner{$id};
			@pop[6] = $idstotrade_good{$id};
			@pop[7] = $idstolife_rating{$id};
			push @poparray, [ @pop ];
		};
	}
}
my %artisans;
my %totalpops;
foreach my $pop (@poparray){
	if (@$pop[1] eq "artisans"){
		$artisans{@$pop[5]} += @$pop[4];
	};
	$totalpops{@$pop[5]} += @$pop[4];
};

my %artisanprct;
foreach my $tag (keys %totalpops){
	my $artcnt = $artisans{$tag};
	my $tpops = $totalpops{$tag};
	say "$artcnt / $tpops";
	my $div = $artcnt / $tpops;
	$artisanprct{$tag} = $div;
};
print Dumper(\%artisanprct);







