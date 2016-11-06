#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;
use List::Util;
use YAML::XS qw(Load Dump);
use File::Slurp qw(read_file write_file);

## File Counts the total output of all RGO's in owned provinces with full employment and no productivity gains
## Assumes 1.2% of population is aristocrats 


my @poparray;
{
    my $yaml = read_file('PopArray.yml', { binmode => ':raw' });
    @poparray = @{ Load $yaml };
}

# Reminder About poparray values
# Pop[0] = province ID
#Pop[1] = poptype
#pop[2] = culture
#pop{3} = religion
#pop[4] = size
#pop[5] = ownder
#pop[6] = trade_good
#pop[7] = life_rating

#RGO Output
my @RGOoutput = qw{
cattle 2.8
coal 3
coffee 2.5
cotton 3
dye 0.22
fish 3.5
grain 2.5
iron 1.8
oil 1
opium 0.7
fruit 6
precious_metal 3
rubber 0.75
wool 15.5
sulphur 2
tea 3
timber 8
tobacco 3
tropical_wood 4
silk 0.4
};

my %RGOUT = @RGOoutput;
my %totalcapacity;


foreach my $pop (@poparray){
	if (@$pop[1] eq "farmers" or "labourers"){
		unless (@$pop[1] eq 'ZZZ'){
		my $good = @$pop[6];
		my $outrate = $RGOUT{$good};
		unless(defined $good){say "$good @$pop[0]"};
		unless(defined $good){$good = 'undef'};
		unless(defined $outrate){$outrate = 1};
		my $size = @$pop[4] / 40000;
		my $output = $outrate * $size * 1.012;
		unless (@$pop[5] eq 'ZZZ'){$totalcapacity{$good} += $output};
		}
	};
};

print Dumper(\%totalcapacity);







