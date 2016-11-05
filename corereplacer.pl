#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;

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
	
	# Make a hashin which the id can be used to find the full name
	foreach my $prov (@provfilenames){
		my $provid = substr($prov, 0, index($prov, ' '));
		$provids{$provid} = $prov;
		$fullname{$provid} = $sfolder;
	};
};



my @toremove = qw(
948 RUS
945 RUS
946 RUS
);

my @toadd = qw(
948 POL
945 POL
946 POL
);

my %removals = @toremove;
my %additions = @toadd;

foreach my $key (keys(%removals)){
	my $fullname = $provids{$key};
	my $sfolder = $fullname{$key};
	my $tag = $removals{$key};
	open(my $fh, "$dh/$sfolder/$fullname");
	open(my $ph, '>', "prints/history/provinces/$sfolder/$fullname");
	while (my $row = <$fh>) {
		chomp $row;
		say $row;
		$row =~ s/^add_core = $tag//g;	
		print $ph "$row\n";
		};
};

foreach my $key (keys(%additions)){
	my $fullname = $provids{$key};
	my $sfolder = $fullname{$key};
	my $tag = $additions{$key};
	open(my $fh, "$dh/$sfolder/$fullname");
	open(my $ph, '>', "prints/history/provinces/$sfolder/$fullname");
	while (my $row = <$fh>) {
		chomp $row;
		if ($row =~ /^controller = .../){
		print $ph "$row\n";
		print $ph "add_core = $tag\n";
		} else { print $ph "$row\n"; }
	};
};





