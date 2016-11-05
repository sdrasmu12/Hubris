#!/usr/bin/perl
use Modern::Perl;


my $dh = 'C:\Program Files (x86)\Steam\SteamApps\common\Victoria 2\mod\Timeline\history\units';
my @cfgs;
my $folder;
# take the directory to be processed from first command line argument
opendir($folder, $dh);
# take only relevant files ie. "*.config"
@cfgs = grep { /\.txt$/ } readdir($folder);
# loop through files


foreach(@cfgs) {
	open(my $fh, "$dh/$_")
		or die "Could not open file '$_";
	open(my $ph, '>', "prints/common/countries//$_");	
	while (my $row = <$fh>) {
		chomp $row;
		$row = " "
		print $ph "$row\n";
	}
	close $ph
}