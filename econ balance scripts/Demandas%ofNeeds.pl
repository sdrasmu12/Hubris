#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;
use List::Util;
use YAML::XS qw(Load Dump);
use File::Slurp qw(read_file write_file);
 
 my @civilizedtags = qw(POR SPA FRA BEL AUS ENG POL RUS TUR SWI PRU DEN SWE NOR NET
 SIC SAR PAP TUS CRS VEN BAV BAD WUR SGM HEK HES RHI WES LIP COB MEI WEI HAN BRA LUB HAM
 SWH SCH MEC ANH LIT AZB QUE USA MEX PEU CLM MOD);
 
 # Read Files In
 my %prices;
{
    my $priceyaml = read_file('Prices.yml', { binmode => ':raw' });
    %prices = %{ Load $priceyaml };
};

my @poparray;
{
    my $yaml = read_file('PopArray.yml', { binmode => ':raw' });
    @poparray = @{ Load $yaml };
};

my %needs;
{
    my $needyaml = read_file('Needs.yml', { binmode => ':raw' });
    %needs = %{ Load $needyaml };
};

my %RGOUT;
{
    my $RGOUTyaml = read_file('RgoOutput.yml', { binmode => ':raw' });
    %RGOUT = %{ Load $RGOUTyaml };
};

my %ArtProd;
{
    my $artprodyaml = read_file('ArtProd.yml', { binmode => ':raw' });
    %ArtProd = %{ Load $artprodyaml };
};

#Set up poptypes and need level
my @poptypes = qw(aristocrats artisans bureaucrats capitalists clergymen clerks craftsmen farmers labourers officers serfs soldiers);
my @needtypes = qw(life everyday luxury);
my @needsrecieved = (1, 0.5, 0);
my %needcost;

# Build an Array with the total cost for each need level for each poptype
foreach my $poptype (@poptypes){
	foreach my $needtype (@needtypes){
		my $tcost;
		foreach my $key (keys %{$needs{$poptype}{$needtype}}){
			my $amount = $needs{$poptype}{$needtype}{$key};
			my $price = $prices{$key};
			my $cost = $amount * $price;
			$needcost{$poptype}{$needtype} += $cost;
			if (undef $cost){say $key};
		};
	}; 
};

#print Dumper(\%needcost);


# Reminder About poparray values
# Pop[0] = province ID
#Pop[1] = poptype
#pop[2] = culture
#pop{3} = religion
#pop[4] = size
#pop[5] = owner
#pop[6] = trade_good
#pop[7] = life_rating

# Assumed Values;
my %directdemand;
my %totaldemand;
my %totalpops;
my %unitpops;

# Go through each pop to generate initial demand
foreach my $pop (@poparray){
	#ignore if unowned province
	unless (@$pop[5] eq 'ZZZ'){
		my $type = @$pop[1];
		my $size = @$pop[4];
		my $divisor;
		if (grep {$_ eq @$pop[5]} @civilizedtags){
			$divisor = 200000;} else {$divisor = 250000};
		$totalpops{$type} += $size;
		$unitpops{$type} += $size / $divisor;
	}
};

print Dumper(\%totalpops);
print Dumper(\%unitpops);

foreach my $pops (keys %unitpops){
	foreach my $level (@needtypes){
		foreach my $good (keys $need{$pops}{$level}){
			my $amount = 
		}
	};
};




