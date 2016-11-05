#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;
use File::Slurp;

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
			push @poparray, [ @pop ];
		};
	}
}
print Dumper(\@poparray);