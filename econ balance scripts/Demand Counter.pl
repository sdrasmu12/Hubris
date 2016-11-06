#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;
use List::Util;
use YAML::XS qw(Load Dump);
use File::Slurp qw(read_file write_file);
 
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

# Go through each pop to generate initial demand
foreach my $pop (@poparray){
	#ignore if unowned province
	unless (@$pop[1] eq 'ZZZ'){
		my $type = @$pop[1];
		my $good = @$pop[6];
		my $outrate = $RGOUT{$good};
		unless(defined $good){say "$good @$pop[0]"};
		unless(defined $good){$good = 'undef'};
		unless(defined $outrate){$outrate = 1};
		# determine income
		my $size = @$pop[4] / 40000;
		my $output = $outrate * $size * 1.012 * 0.8;
		my $tincome = $output * $prices{$good};
		my $perincome = $tincome / $size;
		# determine percent need level
		my $lneedmet = $perincome / ($needcost{$type}{life} * 0.000005) ;
		if ($lneedmet gt 1){$lneedmet = 1};
		my $evercome = $perincome - ($lneedmet * $needcost{$type}{life} * 0.000005);
		my $eneedmet = $evercome / ($needcost{$type}{everyday} * 0.000005);
		if ($eneedmet lt 0){$eneedmet = 0};
		if ($eneedmet gt 1){$eneedmet = 1};
		my $luxcome = $evercome -  ($eneedmet * $needcost{$type}{everyday} * 0.000005);
		my $luxneedmet = $luxcome / ($needcost{$type}{luxury} * 0.000005);
		if ($luxneedmet lt 0){$luxneedmet = 0};
		if ($luxneedmet gt 1){$luxneedmet = 1};
		#put values into the needmet array
		my %needmet;
		$needmet{life} = $lneedmet;
		$needmet{everyday} = $eneedmet;
		$needmet{luxury} = $luxneedmet;
		print Dumper(\%needmet);
		#for each my $levels (keys %needmet){
		#	my $percent = $needmet{$level};
			
		#}
	};
};






