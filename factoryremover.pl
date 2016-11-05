#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;
use File::Slurp qw(read_file write_file);


my @strings = ('state_building = ', 'level = 1', 'level = 2', 'level = 3', 'level = 4', 'level = 5',
'upgrade = yes', 'building = furniture_factory', 'building = paper_mill', 'building = ammunition_factory',
'building = small_arms_factory', 'building = clipper_shipyard', 'building = fabric_factory');


my $dh = 'C:\Program Files (x86)\Steam\SteamApps\common\Victoria 2\mod\Timeline\history\provinces';
my $folder;
my @subfolders = ( 'africa','asia','austria','australia','balkan','canada','carribean','central asia',
'china','france','germany','india','indonesia','italy','japan','low countries','mexico','pacific island',
'portugal', 'scandinavia', 'south america', 'soviet', 'spain', 'united kingdom', 'usa');
my %fullname;
my %provids;
				
#create hashes connecting province id to file name and subdirectory
foreach my $sfolder (@subfolders){
	# Open Each Subdir and put the filenames in an array
	my $dir = "$dh\\$sfolder";
	opendir($folder, $dir);
	my @provfilenames = grep { /\.txt$/ } readdir($folder);
	foreach my $pfname (@provfilenames){
		my $filename = "$dir\\$pfname";
		my $data = read_file $filename, {binmode => ':utf8'};
		$data =~ s/\nstate_building = .//g;
		$data =~ s/\nlevel = .//g;
		$data =~ s/\nrailroad = .//g;
		foreach my $string (@strings){
			$data =~ s/\n$string\n//g;
		}
		write_file $filename, {binmode => ':utf8'}, $data;
	}
}

