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
my $aristocratadjustment = 1.012;
my $militaryspending = 0.5;
my $soldierpay = 0.001;
my $officerpay = 0.005;
my $aftertax = 0.9;
my $adminpay = 0.005;
my $adminspending = 0.5;
my $edupay = 0.002;
my $eduspending = 0.5;
my %totaldemand;

# Go through each pop to generate initial demand
foreach my $pop (@poparray){
	#ignore if unowned province
	unless ((@$pop[5] eq 'ZZZ') or (@$pop[1] =~ /^(capitalists|craftsmen|clerks|slaves|artisans)$/)){
		my $type = @$pop[1];
		my $good = @$pop[6];
		my $divisor; 
		my $lifemet;
		my $edaymet;
		my $luxmet;
		my $income;
		# Assign divisor for civilied and uncivilized
		if (grep {$_ eq @$pop[5]} @civilizedtags){
			$divisor = 200000;} else {$divisor = 250000};
		# Set Income	
		if ($type =~ /^(farmers|labourers|serfs)$/){
			$income = $RGOUT{$good} * $prices{$good} * (@$pop[4] / 40000) * $aristocratadjustment * $aftertax;
		};
		if ($type eq 'aristocrats'){
			$income = 10 * $RGOUT{$good} * $prices{$good} * (@$pop[4] / 40000) * $aristocratadjustment * $aftertax;
		};
		if ($type eq 'soldiers'){
			$income = @$pop[4] * $militaryspending * $soldierpay * $aftertax;
		}
		if ($type eq 'officers'){
			$income = @$pop[4] * $militaryspending * $officerpay * $aftertax;
		}
		if ($type eq 'bureaucrats'){
			$income = @$pop[4] * $adminspending * $adminpay * $aftertax;
		}
		if ($type eq 'clergymen'){
			$income = @$pop[4] * $eduspending * $edupay * $aftertax;
		}
		# Set all the needs costs
		my $lifecosts = $needcost{$type}{life} * (@$pop[4] / $divisor);
		my $edaycosts = $needcost{$type}{everyday} * (@$pop[4] / $divisor);
		my $luxcosts = $needcost{$type}{luxury} * (@$pop[4] / $divisor);
		# Determine percent met
		$lifemet = $income / $lifecosts;
		$edaymet = ($income - $lifecosts) / $edaycosts;
		$luxmet = ($income - ($lifecosts + $edaycosts))/  $luxcosts;
		
		#Round
		if ($lifemet gt 1){$lifemet = 1};
		if ($edaymet gt 1){$edaymet = 1};
		if ($luxmet gt 1){$luxmet = 1};
		if ($edaymet lt 0){$edaymet = 0};
		if ($luxmet lt 0){$luxmet = 0};
		
		foreach my $needtype (@needtypes){
			my $prcmet;
			if ($needtype eq 'life'){$prcmet = $lifemet};
			if ($needtype eq 'every day'){$prcmet = $edaymet};
			if ($needtype eq 'luxury'){$prcmet = $luxmet};
			foreach my $key (keys $needs{$type}{$needtype}){
				my $demand = $needs{$type}{$needtype}{$key} * $prcmet * (@$pop[4] / $divisor);
				$totaldemand{$key} += $demand;
			}
		} 
		
	};
};

print Dumper(\%totaldemand);






