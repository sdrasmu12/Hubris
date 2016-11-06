#!/usr/bin/perl
use Modern::Perl;
use Data::Dumper;
use List::Util;
use YAML::XS qw(Load Dump);
use File::Slurp qw(read_file write_file);

my @poparray;
{
    my $yaml = read_file('PopArray.yml', { binmode => ':raw' });
    @poparray = @{ Load $yaml };
};

my %IDtoFilename;
{
    my $yaml1 = read_file('ProvinceIDS_to_Filename.yml', { binmode => ':raw' });
    %IDtoFilename = %{ Load $yaml1 };
};
my %IDtoSubfolder;

{
    my $yaml2 = read_file('ProvinceIDS_to_Subfolder.yml', { binmode => ':raw' });
    %IDtoSubfolder = %{ Load $yaml1 };
};




