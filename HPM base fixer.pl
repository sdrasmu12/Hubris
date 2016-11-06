#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;
use File::Slurp qw(read_file write_file);


my $dh = 'C:\Program Files (x86)\Steam\SteamApps\common\Victoria 2\mod\HPM\history\provinces';
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
		$data =~ s/\r/\n/g;
		$data =~ s/\n\n/\n/g;
		write_file $filename, {binmode => ':utf8'}, $data;
	}
}

