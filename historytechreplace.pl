#!/usr/bin/perl
use Modern::Perl;


my $dh = 'C:\Program Files (x86)\Steam\SteamApps\common\Victoria 2\mod\Timeline\history\countries';
my @cfgs;
my $folder;
# take the directory to be processed from first command line argument
opendir($folder, $dh);
# take only relevant files ie. "*.config"
@cfgs = grep { /\.txt$/ } readdir($folder);
# loop through files

my @techs = qw(flintlock_rifles bronze_muzzle_loaded_artillery no_standard guild_based_production classicism_n_early_romanticism 
				late_enlightenment_philosophy piston_steam_engine post_napoleonic_thought strategic_mobility point_defense_system
				muzzle_loaded_rifles iron_muzzle_loaded_artillery iron_breech_loaded_artillery military_staff_system military_plans army_command_principle
				army_professionalism post_nelsonian_thought battleship_column_doctrine raider_group_doctrine clipper_design steamers iron_steamers
				naval_design_bureaus fire_control_systems weapon_platforms alphabetic_flag_signaling naval_plans the_command_principle naval_professionalism
				private_banks stock_exchange business_banks ad_hoc_money_bill_printing private_bank_money_bill_printing early_classical_theory_and_critique 
				late_classical_theory freedom_of_trade market_structure business_regulations organized_factories malthusian_thought enlightenment_thought introspectionism
				publishing_industry mechanized_mining experimental_railroad basic_chemistry mechanical_production clean_coal romanticism realism idealism malthusian_thought enlightenment_thought 
				introspectionism publishing_industry mechanized_mining basic_chemistry);

				my @inventions = qw(corvettes commerce_raiders precision_work);
				
				
foreach(@cfgs) {
	open(my $fh, "$dh\\$_")
		or die "Could not open file '$_";
	open(my $ph, '>', "prints//history//countries$_");	
	while (my $row = <$fh>) {
		chomp $row;
		$row =~ s/decision \= */\#/g;
		foreach my $tech (@techs){
			$row =~ s/$tech \= 1//g;	
		};
		foreach my $invent (@inventions){
			$row =~ s/$invent \= yes//g;	
		};
		print $ph "$row\n";
	};
	close $ph
}