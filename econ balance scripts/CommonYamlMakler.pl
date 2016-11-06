#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;
use List::Util;
use YAML::XS qw(Load Dump);
use File::Slurp qw(read_file write_file);

# Attempts to count demand in system assuming:
	# all pops can sell their goods
	# base game prices
	

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

# Declare poptypes and basic lifeneeds
my %needs;
my @pops = qw(aristocrats artisans bureaucrats capitalists clergymen clerks craftsmen farmers labourers officers serfs slaves soldiers);

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
{
    my $RGOoutyaml = Dump \%RGOUT;
    write_file('RgoOutput.yml', { binmode => ':raw' }, $RGOoutyaml);
}


#### Base prices of goods ####
my @prices = qw(
ammunition 18
small_arms 37
artillery 60
barrels 98
aeroplanes 110
cotton 2
dye 12
wool 0.7
silk 10
coal 2.3
iron 3.5
timber 0.9
tropical_wood 5.4
rubber 7
oil 12
precious_metal 8
steel 4.7
cement 16
machine_parts 36.5
glass 2.9
fuel 25
fertilizer 10
explosives 20
clipper_convoy 42
steamer_convoy 65
electric_gear 16
fabric 1.8
lumber 1
paper 3.4
cattle 2
fish 1.5
fruit 1.8
grain 2.2
tobacco 1.1
tea 2.6
coffee 2.1
opium 3.2
automobiles 70
telephones 16
wine 9.7
liquor 4.4
regular_clothes 5.8
luxury_clothes 65
furniture 4.9
luxury_furniture 59
radio 16 
);

my %prices = @prices;
{
    my $priceyaml = Dump \%prices;
    write_file('Prices.yml', { binmode => ':raw' }, $priceyaml);
}


my %artprod;
#### Artisan Production Types ######
# Aeroplane
$artprod{aeroplane}{input}{machine_parts} = 1.11;
$artprod{aeroplane}{input}{electric_gear} = 2;
$artprod{aeroplane}{input}{rubber} = 1;
$artprod{aeroplane}{input}{lumber} = 3.3;
$artprod{aeroplane}{output} = 0.91;
#Barrel
$artprod{barrel}{input}{machine_parts} = 1;
$artprod{barrel}{input}{electric_gear} = 0.85;
$artprod{barrel}{input}{steel} = 2;
$artprod{barrel}{input}{automobiles} = 0.3;
$artprod{barrel}{output} = 1;
#automobile
$artprod{automobile}{input}{machine_parts} = 1.05;
$artprod{automobile}{input}{electric_gear} = 1.5;
$artprod{automobile}{input}{steel} = 2.25;
$artprod{automobile}{input}{rubber} = 1;
$artprod{automobile}{output} = 1.43;
#radio
$artprod{radio}{input}{glass} = 10;
$artprod{radio}{input}{electric_gear} = 1.5;
$artprod{radio}{output} = 6.5;
#telephone
$artprod{telephone}{input}{glass} = 15;
$artprod{telephone}{input}{electric_gear} = 2.5;
$artprod{telephone}{output} = 6.5;
#electric_gear
$artprod{electric_gear}{input}{rubber} = 4;
$artprod{electric_gear}{input}{coal} = 5;
$artprod{electric_gear}{input}{steel} = 5;
$artprod{electric_gear}{output} = 5.5;
#machine_part
$artprod{machine_part}{input}{coal} = 5;
$artprod{machine_part}{input}{steel} = 9;
$artprod{machine_part}{output} = 2;
#Fuel
$artprod{fuel}{input}{oil} = 2.5;
$artprod{fuel}{output} = 2;
#steamer_convoy
$artprod{steamer_convoy}{input}{coal} = 30;
$artprod{steamer_convoy}{input}{steel} = 22;
$artprod{steamer_convoy}{input}{lumber} = 10;
$artprod{steamer_convoy}{output} = 3;
#luxury_clothes
$artprod{luxury_clothes}{input}{regular_clothes} = 0.9;
$artprod{luxury_clothes}{input}{silk} = 3.9;
$artprod{luxury_clothes}{output} = 1;
#luxury_furniture
$artprod{luxury_furniture}{input}{furniture} = 2;
$artprod{luxury_furniture}{input}{tropical_wood} = 7.5;
$artprod{luxury_furniture}{output} = 1.1;
#steel
$artprod{steel}{input}{iron} = 20;
$artprod{steel}{input}{coal} = 5;
$artprod{steel}{output} = 20;
#artillery;
$artprod{artillery}{input}{explosives} = 1;
$artprod{artillery}{input}{steel} = 8;
$artprod{artillery}{output} = 1.3;
#clipper_convoy
$artprod{clipper_convoy}{input}{fabric} = 100;
$artprod{clipper_convoy}{input}{steel} = 30;
$artprod{clipper_convoy}{input}{lumber} = 100;
$artprod{clipper_convoy}{output} = 10;
#small_arms
$artprod{small_arms}{input}{ammunition} = 2;
$artprod{small_arms}{input}{steel} = 3;
$artprod{small_arms}{output} = 2;
#furniture
$artprod{furniture}{input}{lumber} = 40;
$artprod{furniture}{output} = 12;
#paper
$artprod{paper}{input}{lumber} = 50;
$artprod{paper}{output} = 20;
#regular_clothes
$artprod{regular_clothes}{input}{fabric} = 45;
$artprod{regular_clothes}{output} = 15;
#explosives
$artprod{explosives}{input}{fertilizer} = 3;
$artprod{explosives}{input}{ammunition} = 0.8;
$artprod{explosives}{output} = 3;
#ammunition
$artprod{ammunition}{input}{sulphur} = 2;
$artprod{ammunition}{input}{coal} = 2;
$artprod{ammunition}{input}{iron} = 5;
$artprod{ammunition}{output} = 3;
#canned_food
$artprod{canned_food}{input}{steel} = 1;
$artprod{canned_food}{input}{cattle} = 12;
$artprod{canned_food}{input}{grain} = 12;
$artprod{canned_food}{input}{fish} = 12;
$artprod{canned_food}{output} = 6;
#liquor
$artprod{liquor}{input}{grain} = 10;
$artprod{liquor}{input}{glass} = 8;
$artprod{liquor}{output} = 12;
#wine
$artprod{wine}{input}{grain} = 10;
$artprod{wine}{input}{glass} = 10;
$artprod{wine}{output} = 7;
#lumber
$artprod{lumber}{input}{timber} = 100;
$artprod{lumber}{output} = 100;
#fabric
$artprod{fabric}{input}{cotton} = 23;
$artprod{fabric}{input}{dye} = 3;
$artprod{fabric}{output} = 45;
#cement
$artprod{cement}{input}{coal} = 12;
$artprod{cement}{output} = 3;
#glass
$artprod{glass}{input}{coal} = 14;
$artprod{glass}{output} = 18;
#fertilizer
$artprod{fertilizer}{input}{sulphur} = 14;
$artprod{fertilizer}{output} = 5;

{
    my $artprodyaml = Dump \%artprod;
    write_file('ArtProd.yml', { binmode => ':raw' }, $artprodyaml);
}





### POP NEEDS #####

###### aristocrats#####
$needs{aristocrats}{life}{cattle} = 3;
$needs{aristocrats}{life}{wool} = 4;
$needs{aristocrats}{life}{fish} = 4;
$needs{aristocrats}{life}{fruit} = 4;
$needs{aristocrats}{life}{grain} = 10;
$needs{aristocrats}{everyday}{coal} = 5;
$needs{aristocrats}{everyday}{paper} = 10;
$needs{aristocrats}{everyday}{luxury_clothes} = 3;
$needs{aristocrats}{everyday}{luxury_furniture} = 3;
$needs{aristocrats}{everyday}{wine} = 10;
$needs{aristocrats}{everyday}{tobacco} = 10;
$needs{aristocrats}{everyday}{coffee} = 5;
$needs{aristocrats}{everyday}{tea} = 5;
#$needs{aristocrats}{everyday}{radio} = 2;
#$needs{aristocrats}{everyday}{telephones} = 3;
#$needs{aristocrats}{everyday}{automobiles} = 1;
$needs{aristocrats}{luxury}{canned_food} = 1.5;
$needs{aristocrats}{luxury}{fruit} = 5;
$needs{aristocrats}{luxury}{wool} = 10;
$needs{aristocrats}{luxury}{opium} = 10;
#$needs{aristocrats}{luxury}{telephones} = 10;
#$needs{aristocrats}{luxury}{automobiles} = 10;
#$needs{aristocrats}{luxury}{aeroplanes} = 5;
#$needs{aristocrats}{luxury}{radio} = 10;
#$needs{aristocrats}{luxury}{fuel} = 10;
$needs{aristocrats}{luxury}{ammunition} = 1;
$needs{aristocrats}{luxury}{small_arms} = 1;
$needs{aristocrats}{luxury}{clipper_convoy} = 2;
$needs{aristocrats}{luxury}{steamer_convoy} = 2;
###### artisans #####
$needs{artisans}{life}{cattle} = 0.75;
$needs{artisans}{life}{wool} = 1;
$needs{artisans}{life}{fish} = 1;
$needs{artisans}{life}{fruit} = 1;
$needs{artisans}{life}{grain} = 2.5;
$needs{artisans}{everyday}{coal} = 1;
$needs{artisans}{everyday}{liquor} = 5;
$needs{artisans}{everyday}{regular_clothes} = 5;
$needs{artisans}{everyday}{furniture} = 4;
$needs{artisans}{everyday}{paper} = 5;
$needs{artisans}{everyday}{glass} = 1;
$needs{artisans}{everyday}{tobacco} = 3;
$needs{artisans}{everyday}{coffee} = 2;
$needs{artisans}{everyday}{tea} = 5;
$needs{artisans}{luxury}{canned_food} = 0.75;
$needs{artisans}{luxury}{fruit} = 1;
$needs{artisans}{luxury}{wool} = 3;
$needs{artisans}{luxury}{opium} = 1;
#$needs{artisans}{luxury}{telephones} = 1.25;
#$needs{artisans}{luxury}{automobiles} = 1;
#$needs{artisans}{luxury}{aeroplanes} = 0.4;
#$needs{artisans}{luxury}{radio} = 1;
#$needs{artisans}{luxury}{fuel} = 0.2;
$needs{artisans}{luxury}{luxury_clothes} = 1;
$needs{artisans}{luxury}{luxury_furniture} = 1;
###### bureaucrats #####
$needs{bureaucrats}{life}{cattle} = 1.5;
$needs{bureaucrats}{life}{wool} = 2;
$needs{bureaucrats}{life}{fish} = 2;
$needs{bureaucrats}{life}{fruit} = 2;
$needs{bureaucrats}{life}{grain} = 5;
$needs{bureaucrats}{everyday}{coal} = 2;
$needs{bureaucrats}{everyday}{liquor} = 4;
$needs{bureaucrats}{everyday}{regular_clothes} = 5;
$needs{bureaucrats}{everyday}{furniture} = 4;
$needs{bureaucrats}{everyday}{paper} = 5;
$needs{bureaucrats}{everyday}{glass} = 1;
$needs{bureaucrats}{everyday}{tobacco} = 3;
$needs{bureaucrats}{everyday}{coffee} = 2;
$needs{bureaucrats}{everyday}{tea} = 5;
$needs{bureaucrats}{everyday}{cement} = 0.5;
$needs{bureaucrats}{everyday}{steel} = 1;
$needs{bureaucrats}{luxury}{canned_food} = 0.75;
$needs{bureaucrats}{luxury}{fruit} = 1;
$needs{bureaucrats}{luxury}{wool} = 3;
$needs{bureaucrats}{luxury}{opium} = 1;
$needs{bureaucrats}{luxury}{luxury_clothes} = 1;
$needs{bureaucrats}{luxury}{luxury_furniture} = 1.5;
#$needs{bureaucrats}{luxury}{telephones} = 1.25;
#$needs{bureaucrats}{luxury}{automobiles} = 1;
$needs{bureaucrats}{luxury}{wine} = 10;
#$needs{bureaucrats}{luxury}{aeroplanes} = 0.4;
#$needs{bureaucrats}{luxury}{radio} = 1;
#$needs{bureaucrats}{luxury}{fuel} = 0.2;
### Capitalists #####
$needs{capitalists}{life}{cattle} = 3;
$needs{capitalists}{life}{wool} = 4;
$needs{capitalists}{life}{fish} = 4;
$needs{capitalists}{life}{fruit} = 4;
$needs{capitalists}{life}{grain} = 10;
$needs{capitalists}{everyday}{coal} = 20;
$needs{capitalists}{everyday}{paper} = 20;
$needs{capitalists}{everyday}{luxury_clothes} = 20;
$needs{capitalists}{everyday}{luxury_furniture} = 20;
$needs{capitalists}{everyday}{wine} = 20;
$needs{capitalists}{everyday}{tobacco} = 20;
$needs{capitalists}{everyday}{coffee} = 20;
$needs{capitalists}{everyday}{tea} = 10;
#$needs{capitalists}{everyday}{radio} = 4;
#$needs{capitalists}{everyday}{telephones} = 5;
#$needs{capitalists}{everyday}{automobiles} = 1;
$needs{capitalists}{luxury}{canned_food} = 2;
$needs{capitalists}{luxury}{fruit} = 10;
$needs{capitalists}{luxury}{wool} = 20;
$needs{capitalists}{luxury}{opium} = 20;
$needs{capitalists}{luxury}{oil} = 10;
$needs{capitalists}{luxury}{rubber} = 10;
#$needs{capitalists}{luxury}{telephones} = 20;
#$needs{capitalists}{luxury}{automobiles} = 20;
#$needs{capitalists}{luxury}{aeroplanes} = 5;
#$needs{capitalists}{luxury}{radio} = 20;
#$needs{capitalists}{luxury}{fuel} = 30;
$needs{capitalists}{luxury}{ammunition} = 1;
$needs{capitalists}{luxury}{small_arms} = 1;
$needs{capitalists}{luxury}{clipper_convoy} = 2;
$needs{capitalists}{luxury}{steamer_convoy} = 2;
#### Clergymen #####
$needs{clergymen}{life}{cattle} = 1.5;
$needs{clergymen}{life}{wool} = 2;
$needs{clergymen}{life}{fish} = 2;
$needs{clergymen}{life}{fruit} = 2;
$needs{clergymen}{life}{grain} = 5;
$needs{clergymen}{everyday}{coal} = 2;
$needs{clergymen}{everyday}{liquor} = 4;
$needs{clergymen}{everyday}{regular_clothes} = 5;
$needs{clergymen}{everyday}{furniture} = 4;
$needs{clergymen}{everyday}{paper} = 5;
$needs{clergymen}{everyday}{glass} = 1;
$needs{clergymen}{everyday}{tobacco} = 3;
$needs{clergymen}{everyday}{coffee} = 2;
$needs{clergymen}{everyday}{tea} = 5;
#$needs{clergymen}{everyday}{radio} = 0.5;
#$needs{clergymen}{everyday}{telephones} = 0.5;
$needs{clergymen}{luxury}{canned_food} = 0.75;
$needs{clergymen}{luxury}{fruit} = 1;
$needs{clergymen}{luxury}{wool} = 3;
$needs{clergymen}{luxury}{opium} = 1;
$needs{clergymen}{luxury}{luxury_clothes} = 1;
$needs{clergymen}{luxury}{luxury_furniture} = 1.5;
#$needs{clergymen}{luxury}{telephones} = 1.25;
#$needs{clergymen}{luxury}{automobiles} = 1;
$needs{clergymen}{luxury}{wine} = 10;
#$needs{clergymen}{luxury}{aeroplanes} = 0.4;
#$needs{clergymen}{luxury}{radio} = 1;
#$needs{clergymen}{luxury}{fuel} = 0.2;
##### CLERKS ######
$needs{clerks}{life}{cattle} = 0.75;
$needs{clerks}{life}{wool} = 1;
$needs{clerks}{life}{fish} = 1;
$needs{clerks}{life}{fruit} = 1;
$needs{clerks}{life}{grain} = 2.5;
$needs{clerks}{everyday}{tea} = 4;
$needs{clerks}{everyday}{coal} = 2;
$needs{clerks}{everyday}{liquor} = 2.5;
$needs{clerks}{everyday}{regular_clothes} = 3;
$needs{clerks}{everyday}{furniture} = 3;
$needs{clerks}{everyday}{coffee} = 1;
$needs{clerks}{everyday}{tobacco} = 1;
$needs{clerks}{luxury}{paper} = 5;
$needs{clerks}{luxury}{canned_food} = 0.75;
$needs{clerks}{luxury}{fruit} = 1;
$needs{clerks}{luxury}{wool} = 3;
$needs{clerks}{luxury}{opium} = 1;
$needs{clerks}{luxury}{luxury_clothes} = 1;
$needs{clerks}{luxury}{luxury_furniture} = 1.5;
#$needs{clerks}{luxury}{telephones} = 1.25;
#$needs{clerks}{luxury}{automobiles} = 1;
$needs{clerks}{luxury}{wine} = 10;
#$needs{clerks}{luxury}{aeroplanes} = 0.4;
#$needs{clerks}{luxury}{radio} = 1;
#$needs{clerks}{luxury}{fuel} = 0.2;
##### CRAFTSMEN #####
$needs{craftsmen}{life}{cattle} = 0.75;
$needs{craftsmen}{life}{wool} = 1;
$needs{craftsmen}{life}{fish} = 1;
$needs{craftsmen}{life}{fruit} = 1;
$needs{craftsmen}{life}{grain} = 2.5;
$needs{craftsmen}{everyday}{tea} = 4;
$needs{craftsmen}{everyday}{coal} = 1;
$needs{craftsmen}{everyday}{liquor} = 2.5;
$needs{craftsmen}{everyday}{regular_clothes} = 3;
$needs{craftsmen}{everyday}{furniture} = 3;
$needs{craftsmen}{everyday}{coffee} = 1;
$needs{craftsmen}{everyday}{tobacco} = 1;
$needs{craftsmen}{luxury}{regular_clothes} = 3;
$needs{craftsmen}{luxury}{furniture} = 3;
$needs{craftsmen}{luxury}{paper} = 1;
#$needs{craftsmen}{luxury}{telephones} = 1;
#$needs{craftsmen}{luxury}{automobiles} = 0.5;
#$needs{craftsmen}{luxury}{radio} = 1;
#$needs{craftsmen}{luxury}{fuel} = 0.1;
##### FARMERS #####
$needs{farmers}{life}{cattle} = 1;
$needs{farmers}{life}{wool} = 1;
$needs{farmers}{life}{fish} = 1;
$needs{farmers}{life}{fruit} = 1;
$needs{farmers}{life}{grain} = 2.5;
$needs{farmers}{everyday}{tea} = 4;
$needs{farmers}{everyday}{coal} = 1;
$needs{farmers}{everyday}{liquor} = 2.5;
$needs{farmers}{everyday}{regular_clothes} = 1.2;
$needs{farmers}{everyday}{furniture} = 1.1;
$needs{farmers}{everyday}{coffee} = 1;
$needs{farmers}{everyday}{tobacco} = 1;
$needs{farmers}{everyday}{fertilizer} = 0.5;
$needs{farmers}{luxury}{regular_clothes} = 3;
$needs{farmers}{luxury}{furniture} = 3;
$needs{farmers}{luxury}{paper} = 1;
#$needs{farmers}{luxury}{telephones} = 1;
#$needs{farmers}{luxury}{automobiles} = 0.5;
#$needs{farmers}{luxury}{radio} = 1;
#$needs{farmers}{luxury}{fuel} = 0.1;
#### labourers #####
$needs{labourers}{life}{cattle} = 0.75;
$needs{labourers}{life}{wool} = 1.72;
$needs{labourers}{life}{fish} = 1;
$needs{labourers}{life}{fruit} = 1;
$needs{labourers}{life}{grain} = 2.5;
$needs{labourers}{everyday}{tea} = 4;
$needs{labourers}{everyday}{coal} = 1;
$needs{labourers}{everyday}{liquor} = 2.5;
$needs{labourers}{everyday}{regular_clothes} = 1.2;
$needs{labourers}{everyday}{furniture} = 1.1;
$needs{labourers}{everyday}{coffee} = 1;
$needs{labourers}{everyday}{tobacco} = 1;
$needs{labourers}{everyday}{explosives} = 0.25;
$needs{labourers}{luxury}{regular_clothes} = 3;
$needs{labourers}{luxury}{furniture} = 3;
$needs{labourers}{luxury}{paper} = 1;
#$needs{labourers}{luxury}{telephones} = 1;
#$needs{labourers}{luxury}{automobiles} = 0.5;
#$needs{labourers}{luxury}{radio} = 1;
#$needs{farmers}{luxury}{fuel} = 0.1;
##### OFFICERS ######
$needs{officers}{life}{cattle} = 1.5;
$needs{officers}{life}{wool} = 2;
$needs{officers}{life}{fish} = 2;
$needs{officers}{life}{fruit} = 2;
$needs{officers}{life}{grain} = 5;
$needs{officers}{everyday}{coal} = 2;
$needs{officers}{everyday}{liquor} = 4;
$needs{officers}{everyday}{regular_clothes} = 5;
$needs{officers}{everyday}{furniture} = 4;
$needs{officers}{everyday}{paper} = 5;
$needs{officers}{everyday}{glass} = 1;
$needs{officers}{everyday}{tobacco} = 3;
$needs{officers}{everyday}{coffee} = 2;
$needs{officers}{everyday}{tea} = 5;
$needs{officers}{everyday}{ammunition} = 0.5;
$needs{officers}{everyday}{small_arms} = 0.4;
#$needs{officers}{everyday}{radio} = 0.5;
#$needs{officers}{everyday}{telephones} = 0.5;
$needs{officers}{luxury}{canned_food} = 0.75;
$needs{officers}{luxury}{fruit} = 1;
$needs{officers}{luxury}{wool} = 3;
$needs{officers}{luxury}{opium} = 1;
$needs{officers}{luxury}{luxury_clothes} = 1;
$needs{officers}{luxury}{luxury_furniture} = 1.5;
#$needs{officers}{luxury}{telephones} = 1.25;
#$needs{officers}{luxury}{automobiles} = 1;
$needs{officers}{luxury}{wine} = 10;
#$needs{officers}{luxury}{aeroplanes} = 0.4;
#$needs{officers}{luxury}{radio} = 1;
#$needs{officers}{luxury}{fuel} = 0.2;
#### SERFS ##### 
$needs{serfs}{life}{cattle} = 0.5;
$needs{serfs}{life}{wool} = 0.5;
$needs{serfs}{life}{fish} = 0.5;
$needs{serfs}{life}{fruit} = 0.5;
$needs{serfs}{life}{grain} = 1.25;
$needs{serfs}{everyday}{coal} = 1;
$needs{serfs}{everyday}{tea} = 2;
$needs{serfs}{everyday}{tobacco} = 5;
$needs{serfs}{everyday}{liquor} = 4;
$needs{serfs}{everyday}{regular_clothes} = 1.2;
$needs{serfs}{everyday}{furniture} = 1.1;
$needs{serfs}{everyday}{opium} = 10;
$needs{serfs}{everyday}{explosives} = 0.25;
$needs{serfs}{everyday}{fertilizer} = 0.5;
$needs{serfs}{luxury}{regular_clothes} = 3;
$needs{serfs}{luxury}{furniture} = 3;
$needs{serfs}{luxury}{liquor} = 1.5;
$needs{serfs}{luxury}{wine} = 1;
$needs{serfs}{luxury}{coffee} = 3;
$needs{serfs}{luxury}{tobacco} = 3;
$needs{serfs}{luxury}{paper} = 1;
#$needs{serfs}{luxury}{telephones} = 1;
#$needs{serfs}{luxury}{automobiles} = 0.5;
#$needs{serfs}{luxury}{radio} = 1;
#$needs{serfs}{luxury}{fuel} = 0.1;
$needs{serfs}{luxury}{opium} = 2;
#### Soldiers #####
$needs{soldiers}{life}{cattle} = 0.75;
$needs{soldiers}{life}{wool} = 1;
$needs{soldiers}{life}{fish} = 1;
$needs{soldiers}{life}{fruit} = 1;
$needs{soldiers}{life}{grain} = 2.5;
$needs{soldiers}{everyday}{tea} = 4;
$needs{soldiers}{everyday}{coal} = 1;
$needs{soldiers}{everyday}{liquor} = 2;
$needs{soldiers}{everyday}{regular_clothes} = 2;
$needs{soldiers}{everyday}{furniture} = 2;
$needs{soldiers}{everyday}{coffee} = 1;
$needs{soldiers}{everyday}{tobacco} = 1;
$needs{soldiers}{everyday}{ammunition} = 0.5;
$needs{soldiers}{everyday}{small_arms} = 0.35;
$needs{soldiers}{luxury}{regular_clothes} = 3;
$needs{soldiers}{luxury}{furniture} = 3;
$needs{soldiers}{luxury}{liquor} = 1.5;
$needs{soldiers}{luxury}{paper} = 1;
#$needs{soldiers}{luxury}{telephones} = 1;
#$needs{soldiers}{luxury}{automobiles} = 0.5;
#$needs{soldiers}{luxury}{radio} = 1;
#$needs{farmers}{luxury}{fuel} = 0.1;

{
    my $needsyaml = Dump \%needs;
    write_file('Needs.yml', { binmode => ':raw' }, $needsyaml);
}

print Dumper(\%needs);







