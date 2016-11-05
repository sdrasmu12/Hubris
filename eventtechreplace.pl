#!/usr/bin/perl
use Modern::Perl;


my $dh = 'C:\Program Files (x86)\Steam\SteamApps\common\Victoria 2\mod\Timeline\decisions';
my @cfgs;
my $folder;
# take the directory to be processed from first command line argument
opendir($folder, $dh);
# take only relevant files ie. "*.config"
@cfgs = grep { /\.txt$/ } readdir($folder);
# loop through files

				
open my $keywords,    '<', 'keywords.txt' or die "Can't open keywords: $!";
my $keyword_or = join '|', map {chomp;qr/\Q$_\E/} <$keywords>;
my $regex = qr|\b($keyword_or)\b|;

				
foreach(@cfgs) {
	open(my $fh, "$dh\\$_")
		or die "Could not open file '$_";
	print "$_ \n";
	while (<$fh>){
		while (/$regex/g){
			if(defined $1){print "$.: $1\n"};
		}
	}
}

