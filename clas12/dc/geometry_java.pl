package coatjava;

use strict;
use warnings;

use geometry;

my $mothers;
my $positions;
my $rotations;
my $types;
my $dimensions;
my $ids;

our @mother_dx1= (0,0,0);
our @mother_dx2= (0,0,0);
our @mother_dy= (0,0,0);
our @mother_dz= (0,0,0);
our @mother_xcent= (0,0,0);
our @mother_ycent= (0,0,0);
our @mother_zcent= (0,0,0);

sub make_region
{
	my $iregion = shift;
	my $region = $iregion + 1;
	my $nSectors = 6;

	for(my $s=1; $s<=$nSectors; $s++)
	{
		my %detector = init_det();
		my $vname = "region$region"."_s$s";

		$detector{"name"}        = $vname;
		$detector{"mother"}      = $mothers->{$vname};
		$detector{"description"} = "CLAS12 Drift Chambers, Sector $s Region $region";

		$detector{"pos"}            = $positions->{$vname};
		$detector{"rotation"}   = $rotations->{$vname};
		$detector{"type"}           = $types->{$vname};
		$detector{"dimensions"}  = $dimensions->{$vname};

                        my $sizes = $detector{"dimensions"};
                        $sizes =~ s/\*cm//g;

                        my @numbers = split(/[ \t]+/,$sizes);
                        (my $dz, my $tilt, my $phi, my $dy, my $dx1, my $dx2, my $angle1, my $dy1, my $dx11, my $dx21, my $angle2) = @numbers;
                        my $ireg = $iregion-1; ;  # index is c++ convention
                        $mother_dx1[$ireg]     = $dx1 + 1.0;   # Custom enlarging mother volume to contain daugthers
                        $mother_dx2[$ireg]     = $dx2 + 1.0;
                        $mother_dy[$ireg]      = $dy  + 1.0;
                        $mother_dz[$ireg]      = $dz;

                        $sizes = $detector{"pos"};
                        $sizes =~ s/\*cm//g;
                        my @poses = split(/[ \t]+/,$sizes);
                        (my $xcent, my $ycent, my $zcent) = @poses;
                        $mother_xcent[$ireg]   = $xcent;
                        $mother_ycent[$ireg]   = $ycent;
                        $mother_zcent[$ireg]   = $zcent;
		$detector{"color"}       = "aa0000";
		$detector{"material"}    = "dcgas";
		$detector{"visible"}     = 0;
		print_det(\%main::configuration, \%detector);
	}

}

# Layers
sub make_layers
{
	my $iregion = shift;
	my $region = $iregion + 1;
	
	my $superlayer_min = $region*2 - 1;
	my $superlayer_max = $region*2;
	
	for (my $isup = $superlayer_min; $isup < $superlayer_max+1 ; $isup++)
	{
		for (my $ilayer = 1; $ilayer < 7 ; $ilayer++)
		{
			my $nSectors = 6;
			
			for(my $s=1; $s<=$nSectors; $s++)
			{
				# names
				my $nlayer               = $ilayer;

				my %detector = init_det();
				my $vname = "sl$isup"."_layer$nlayer"."_s$s";

				$detector{"name"}        = $vname;
				$detector{"mother"}      = $mothers->{$vname};
				$detector{"description"} = "Region $region, Super Layer $isup, layer $ilayer, Sector $s";

				$detector{"pos"} = $positions->{$vname};
				$detector{"rotation"} = $rotations->{$vname};
				$detector{"type"} = $types->{$vname};
				$detector{"dimensions"}  = $dimensions->{$vname};

				$detector{"color"}       = "99aaff2";
				$detector{"material"}    = "dcgas";
				$detector{"style"}       = 1;
				$detector{"sensitivity"} = "dc";
				$detector{"hit_type"}    = "dc";
				$detector{"identifiers"} = "sector manual $s superlayer manual $isup layer manual $nlayer wire manual 1";

				print_det(\%main::configuration, \%detector);
			}
		}
	}
}


sub makeDC
{
	($mothers, $positions, $rotations, $types, $dimensions, $ids) = @main::volumes;

	make_region(0);
	make_region(1);
	make_region(2);
		
	make_layers(0);
	make_layers(1);
	make_layers(2);
}

1;
