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
my %color = ('kapton' => "bf0000", "Al" => "2a3158", "gas" => " afb0ba", "Cu" => "fd7f00", "dlc" => "14b6ce", "Cr" => "1433ce", "glue" => "14ce3d", "g10" => "aa44d8", "nomex" => "ecdb3a");
my %colorGem = ('kapton' => "bf0000", "Al" => "2a3158", "gas" => " afb0ba", "Cu" => "fd7f00", "dlc" => "14b6ce", "Cr" => "1433ce", "glue" => "14ce3d", "g10" => "888808", "nomex" => "dddd3a");

my @window = ("kapton", "Al", "gas");
my @cathode = ("kapton", "Al", "gas");
my @muRwell = ("Cu", "kapton", "dlc");
my @capa_sharing_layer1 = ("glue", "Cr", "kapton");
my @capa_sharing_layer2 = ("glue", "Cr", "kapton");
my @readout1 = ("glue", "Cu", "kapton");
my @readout2 = ("glue", "Cu", "kapton");
my @readout3 = ("glue");
my @support_skin1 = ("g10");
my @support_skin2 =("g10");
my @support_honeycomb = ("nomex");


sub make_regions
{
    my $nregion = 6;
    
    for(my $R=1; $R<=$nregion; $R++){
            my %detector = init_det();
            my $vname = "LMU_region$R";

            $detector{"name"}        = $vname;
            $detector{"mother"}      = $mothers->{$vname};

            $detector{"description"} = "LDRD URwell,  Region $R";

            $detector{"pos"}         = $positions->{$vname};
            $detector{"rotation"}    = $rotations->{$vname};
            $detector{"type"}        = $types->{$vname};
            $detector{"dimensions"}  = $dimensions->{$vname};

            $detector{"color"}       = "aa0000";
            $detector{"material"}    = "G4_Galactic";
            $detector{"style"}       = 0;
            $detector{"visible"}     = 0;
            print_det(\%main::configuration, \%detector);
            make_chamber($R);
    }
}

sub make_chamber
{
        my $region = $_[0];

    
        my %detector = init_det();
        my $vname = "region$region";
        $detector{"name"}        = $vname;
        $detector{"mother"}      = $mothers->{$vname};
        $detector{"description"} = "Region $region";

        $detector{"pos"} = $positions->{$vname};
        $detector{"rotation"} = $rotations->{$vname};
        $detector{"type"} = $types->{$vname};
        $detector{"dimensions"}  = $dimensions->{$vname};
        $detector{"color"}       = "4f84f7";
        $detector{"material"}    = "G4_Galactic";
        $detector{"style"}       = 0;
        $detector{"visible"}     = 0;
        print_det(\%main::configuration, \%detector);
        
        # Window
        for(my $ii=0; $ii<=$#window; $ii++) {
            make_layers($region, "window",$window[$ii]);
        }
        
        # Cathode
        for(my $ii=0; $ii<=$#cathode; $ii++) {
            make_layers($region, "cathode",$cathode[$ii]);
        }
        
        #muRwell
        for(my $ii=0; $ii<=$#muRwell; $ii++) {
            make_layers($region, "muRwell",$muRwell[$ii]);
        }
        
        #@capa_sharing_layer1
        for(my $ii=0; $ii<=$#capa_sharing_layer1; $ii++) {
            make_layers($region,"capa_sharing_layer1",$capa_sharing_layer1[$ii]);
        }
        
        #@capa_sharing_layer2
        for(my $ii=0; $ii<=$#capa_sharing_layer2; $ii++) {
            make_layers($region, "capa_sharing_layer2",$capa_sharing_layer2[$ii]);
        }
        
        #@readout1
        for(my $ii=0; $ii<=$#readout1; $ii++) {
            make_layers($region,  "readout1",$readout1[$ii]);
        }

        #@readout2
        for(my $ii=0; $ii<=$#readout2; $ii++) {
            make_layers($region,  "readout2",$readout2[$ii]);
        }

        #@readout3
        for(my $ii=0; $ii<=$#readout3; $ii++) {
            make_layers($region,  "readout3",$readout3[$ii]);
        }
        
        #@support_skin1
        for(my $ii=0; $ii<=$#support_skin1; $ii++) {
            make_layers($region,  "support_skin1",$support_skin1[$ii]);
        }

        #@support_skin2
        for(my $ii=0; $ii<=$#support_skin2; $ii++) {
            make_layers($region,  "support_skin2",$support_skin2[$ii]);
        }
        
        #@support_honeycomb
        for(my $ii=0; $ii<=$#support_honeycomb; $ii++) {
            make_layers($region,  "support_honeycomb",$support_honeycomb[$ii]);
        }
        
    
}

# Layers

sub make_layers{
    
        my $region = $_[0];
        my $layer = $_[1];
        my $material = $_[2];
        my %detector = init_det();


        my $vname = "region$region"."_$layer"."_$material";

        $detector{"name"}        = $vname;
        $detector{"mother"}      = $mothers->{$vname};
        $detector{"description"} = "Region $region, $layer $material";
        $detector{"pos"} = $positions->{$vname};
        $detector{"rotation"} = $rotations->{$vname};
        $detector{"type"} = $types->{$vname};
        $detector{"dimensions"}  = $dimensions->{$vname};
        if($region eq 1 || $region eq 6) {
            $detector{"color"}       = $colorGem{$material};
        }
        else {
            $detector{"color"}       = $color{$material};
        }        
        $detector{"material"}    = $material;
       
        if($layer eq "cathode" && $material eq "gas" ){
            $detector{"sensitivity"} = "flux";
            $detector{"hit_type"} = "flux";
            $detector{"identifiers"} ="region manual $region layer manual 1 component manual 1";
        }
        $detector{"style"}       = 1;
        $detector{"visible"}     = 1;
        print_det(\%main::configuration, \%detector);

}





sub makeLMU
{

	($mothers, $positions, $rotations, $types, $dimensions, $ids) = @main::volumes;
    
    make_regions();


}



1;
