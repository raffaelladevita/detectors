use strict;
use warnings;

our %configuration;
our %parameters;

sub apollo
{
	my $thisVariation = $configuration{"variation"} ;

	
	        my $VolumeLength = 77;
	        my $TargetLength = 50; #length of the NH3 target
	        my $TargetRadius = 10; #radius of the NH3 target
	        my $TargetCenter = 0;  #center of the NH3 target
		my $TargetWindowThickness = 0.02;
		my $VacuumRadius          = 47;
		my $SpheresCenter         = $TargetLength/2+5;  
		my $BathRadius            = 20;
		my $BathHalfLength        = ($TargetLength+$TargetWindowThickness)/2;
		my $BathWindowThickness   = 0.13;
		my $ShimCoilsMandrelRin  = 23.8; 
		my $ShimCoilsMandrelRout = 24.3;
		my $ShimCoilsLength      = 12; 
		my $ShimCoilsThickness   = 0.7;
		my $ShimCoilsWindow      = 0.02;
		my $PumpingVolumeRin     = 29;
		my $PumpingVolumeRout    = 29.26;
		my $PumpingVolumeWindow  = 0.13;
		my $HeatShieldRin        = 33;
		my $HeatShieldRout       = 33.1;
		my $HeatShieldWindow     = 0.02;
		my $VacuumCanRin         = $VacuumRadius - 0.25;
		my $VacuumCanRout        = $VacuumRadius;
		my $VacuumCanWindow      = 0.13;
		
		
		# mother volume
		my $Rout         = $VacuumRadius;
		my $Zlength      = $VolumeLength + 53;  # half length along beam axis
		my %detector = init_det();
		$detector{"name"}        = "PolTarg";
		$detector{"mother"}      = "root";
		$detector{"description"} = "PolTarg Region";
		$detector{"color"}       = "ffffff";
		$detector{"type"}        = "Polycone";
		$detector{"dimensions"}  = "0.0*deg 360*deg 2*counts 0.0*mm 0.0*mm $Rout*mm $Rout*mm -$VolumeLength*mm $Zlength*mm";
		$detector{"material"}    = "G4_AIR";
		$detector{"visible"}     =  0;
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

		# vacuum volume
		%detector = init_det();
		$detector{"name"}        = "VacuumVolume";
		$detector{"mother"}      = "PolTarg";
		$detector{"description"} = "Vacuum cylindrical volume";
		$detector{"color"}       = "ffffff";
		$detector{"type"}        = "Polycone";
		$detector{"pos"}         = "0*mm 0*mm $TargetCenter*mm";
		$detector{"dimensions"}  = "0.0*deg 360*deg 2*counts 0.0*mm 0.0*mm $VacuumRadius*mm $VacuumRadius*mm -$VolumeLength*mm $SpheresCenter*mm";
		$detector{"material"}    = "G4_Galactic";
		$detector{"style"}       = 1;
		print_det(\%configuration, \%detector);
		
		# vacuum sphere
		%detector = init_det();
		$detector{"name"}        = "VacuumSphere";
		$detector{"mother"}      = "PolTarg";
		$detector{"description"} = "Vacuum half sphere volume";
		$detector{"pos"}         = "0 0 $SpheresCenter*mm";
		$detector{"color"}       = "ffffff";
		$detector{"type"}        = "Sphere";
		$detector{"dimensions"}  = "0*mm $VacuumRadius*mm 0*deg 360*deg 0*deg 90*deg";
		$detector{"material"}    = "G4_Galactic";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

		#LHe bath
		%detector = init_det();
		$detector{"name"}        = "HeliumBath";
		$detector{"mother"}      = "VacuumVolume";
		$detector{"description"} = "LHe bath";
		$detector{"color"}       = "0099ff";
		$detector{"type"}        = "Polycone";
		$detector{"pos"}         = "0*mm 0*mm $TargetCenter*mm";
		$detector{"dimensions"}  = "0.0*deg 360*deg 2*counts 0.0*mm 0.0*mm $BathRadius*mm $BathRadius*mm -$VolumeLength*mm $BathHalfLength*mm";
		$detector{"material"}    = "lHeCoolant";
		$detector{"style"}       = 1;
		print_det(\%configuration, \%detector);
		
		#LHe bath walls
		$Rout = $BathRadius + $BathWindowThickness;
		%detector = init_det();
		$detector{"name"}        = "HeliumBathWalls";
		$detector{"mother"}      = "VacuumVolume";
		$detector{"description"} = "LHe bath walls";
		$detector{"color"}       = "aaaaaa";
		$detector{"type"}        = "Polycone";
		$detector{"pos"}         = "0*mm 0*mm $TargetCenter*mm";
		$detector{"dimensions"}  = "0.0*deg 360*deg 2*counts $BathRadius*mm $BathRadius*mm $Rout*mm $Rout*mm -$VolumeLength*mm $BathHalfLength*mm";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = 1;
		print_det(\%configuration, \%detector);
		
		# NH3Targ
		my $ZCenter  = 0;   # center location of target along beam axis
		$Rout        = $TargetRadius;  # radius in mm
		my $ZhalfLength = ($TargetLength-$TargetWindowThickness)/2;  # half length along beam axis
		%detector = init_det();
		$detector{"name"}        = "NH3Targ";
		$detector{"mother"}      = "HeliumBath";
		$detector{"description"} = "NH3 target cell";
		$detector{"pos"}         = "0 0 $ZCenter*mm";
		$detector{"color"}       = "f000f0";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "0*mm $Rout*mm $ZhalfLength*mm 0*deg 360*deg";
	$detector{"material"}    = "NH3target";
	if($thisVariation eq "APOLLOnd3New") {
	  $detector{"material"}    = "ND3target";
	}
		   $detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

		# NH3Targ Cup
		my $Rin      = $TargetRadius + 0.001;  # radius in mm
		$Rout        = $TargetRadius + 0.03;   # radius in mm
		$ZhalfLength = $TargetLength/2;        # half length along beam axis
		%detector = init_det();
		$detector{"name"}        = "NH3Cup";
		$detector{"mother"}      = "HeliumBath";
		$detector{"description"} = "NH3 Target cup";
		$detector{"pos"}         = "0 0 $ZCenter*mm";
		$detector{"color"}       = "ffffff";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm $ZhalfLength*mm 0*deg 360*deg";
		$detector{"material"}    = "AmmoniaCellWalls";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

		# NH3Targ Cup Up Stream Window
		$ZCenter                 = -$TargetLength/2;
		$Rin                     = 0.0;                       # radius in mm
		$Rout                    = $TargetRadius;             # radius in mm
		$ZhalfLength             = $TargetWindowThickness/2;  # half length along beam axis
		%detector = init_det();
		$detector{"name"}        = "NH3USWindow";
		$detector{"mother"}      = "HeliumBath";
		$detector{"description"} = "NH3 Target cup Upstream Window";
		$detector{"pos"}         = "0 0 $ZCenter*mm";
		$detector{"color"}       = "aaaaaa";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm $ZhalfLength*mm 0*deg 360*deg";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

		# NH3Targ Cup Downstream Stream Window
		$ZCenter                 = $TargetLength/2;
		$Rin                     = 0.0;                       # radius in mm
		$Rout                    = $TargetRadius;             # radius in mm
		$ZhalfLength             = $TargetWindowThickness/2;  # half length along beam axis
		%detector = init_det();
		$detector{"name"}        = "NH3DSWindow";
		$detector{"mother"}      = "HeliumBath";
		$detector{"description"} = "NH3 Target cup Downstream Window";
		$detector{"pos"}         = "0 0 $ZCenter*mm";
		$detector{"color"}       = "aaaaaa";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm $ZhalfLength*mm 0*deg 360*deg";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

		#  Beam Entrance Window
		$ZCenter                 = -$BathHalfLength - $BathWindowThickness/2;
		$Rin                     = 0.0;                     # radius in mm
		$Rout                    = $TargetRadius;           # radius in mm
		$ZhalfLength             = $BathWindowThickness/2;  # half length along beam axis
		%detector = init_det();
		$detector{"name"}        = "BeamEntrance";
		$detector{"mother"}      = "HeliumBath";
		$detector{"description"} = "Beam entrance window";
		$detector{"pos"}         = "0 0 $ZCenter*mm";
		$detector{"color"}       = "aaaaaa";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm $ZhalfLength*mm 0*deg 360*deg";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

          	# Beam pipe
		$Rin  = 0;
		$Rout = $TargetRadius+3;
		$ZhalfLength = -$BathHalfLength - $BathWindowThickness;
		%detector = init_det();
		$detector{"name"}        = "BeamEntranceVacuum";
		$detector{"mother"}      = "HeliumBath";
		$detector{"description"} = "BeamEntrancePipe";
		$detector{"color"}       = "ffffff";
		$detector{"type"}        = "Polycone";
		$detector{"pos"}         = "0*mm 0*mm $TargetCenter*mm";
		$detector{"dimensions"}  = "0.0*deg 360*deg 2*counts $Rin*mm $Rin*mm $Rout*mm $Rout*mm -$VolumeLength*mm $ZhalfLength*mm";
		$detector{"material"}    = "G4_Galactic";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);
		$Rin  = $Rout;
		$Rout = $Rout+1;
		$ZhalfLength = -$BathHalfLength - $BathWindowThickness;
		%detector = init_det();
		$detector{"name"}        = "BeamEntranceVacuum";
		$detector{"mother"}      = "HeliumBath";
		$detector{"description"} = "BeamEntrancePipe";
		$detector{"color"}       = "595959";
		$detector{"type"}        = "Polycone";
		$detector{"pos"}         = "0*mm 0*mm $TargetCenter*mm";
		$detector{"dimensions"}  = "0.0*deg 360*deg 2*counts $Rin*mm $Rin*mm $Rout*mm $Rout*mm -$VolumeLength*mm $ZhalfLength*mm";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

		#  Beam Exit Window
		$ZCenter                 = $BathHalfLength + $BathWindowThickness/2;
		$Rin                     = 0.0;                     # radius in mm
		$Rout                    = $TargetRadius;           # radius in mm
		$ZhalfLength             = $BathWindowThickness/2;  # half length along beam axis
		%detector = init_det();
		$detector{"name"}        = "BeamExit";
		$detector{"mother"}      = "VacuumVolume";
		$detector{"description"} = "Beam entrance window";
		$detector{"pos"}         = "0 0 $ZCenter*mm";
		$detector{"color"}       = "aaaaaa";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm $ZhalfLength*mm 0*deg 360*deg";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

           	# Shim Coil Carrier
		$Rin  = $ShimCoilsMandrelRin;
		$Rout = $ShimCoilsMandrelRout; 
		%detector = init_det();
		$detector{"name"}        = "ShimCoilCarrier";
		$detector{"mother"}      = "VacuumVolume";
		$detector{"description"} = "Shim coil carrier";
		$detector{"color"}       = "aaaaaa";
		$detector{"type"}        = "Polycone";
		$detector{"pos"}         = "0*mm 0*mm $TargetCenter*mm";
		$detector{"dimensions"}  = "0.0*deg 360*deg 2*counts $Rin*mm $Rin*mm $Rout*mm $Rout*mm -$VolumeLength*mm $SpheresCenter*mm";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);
          	# Shim Mandrel Sphere
		$Rout = $ShimCoilsMandrelRin+$ShimCoilsWindow; 
		%detector = init_det();
		$detector{"name"}        = "ShimCoilSphere";
		$detector{"mother"}      = "VacuumSphere";
		$detector{"description"} = "Shim coil sphere";
		$detector{"pos"}         = "0 0 0*mm";
		$detector{"color"}       = "aaaaaa";
		$detector{"type"}        = "Sphere";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm 0*deg 360*deg 0*deg 90*deg";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);


           	# Shim Up Up stream Coil
		$ZCenter     = $BathHalfLength-$ShimCoilsLength/2;
		$Rin         = $ShimCoilsMandrelRout;
		$Rout        = $ShimCoilsMandrelRout+$ShimCoilsThickness;
		$ZhalfLength = $ShimCoilsLength/2;
		%detector = init_det();
		$detector{"name"}        = "ShimCoil1";
		$detector{"mother"}      = "VacuumVolume";
		$detector{"description"} = "Shim Coil 1";
		$detector{"pos"}         = "0 0 $ZCenter*mm";
		$detector{"color"}       = "a00000";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm $ZhalfLength*mm 0*deg 360*deg";
		$detector{"material"}    = "ShimCoil";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);


           	# Shim Up stream Coil
		$ZCenter                 = -4.5;
		%detector = init_det();
		$detector{"name"}        = "ShimCoil2";
		$detector{"mother"}      = "VacuumVolume";
		$detector{"description"} = "Shim Coil 2";
		$detector{"pos"}         = "0 0 $ZCenter*mm";
		$detector{"color"}       = "a00000";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm $ZhalfLength*mm 0*deg 360*deg";
		$detector{"material"}    = "ShimCoil";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

           	# Shim Down stream Coil
		$ZCenter                 = -22.5;
		%detector = init_det();
		$detector{"name"}        = "ShimCoil3";
		$detector{"mother"}      = "VacuumVolume";
		$detector{"description"} = "Shim Coil 3";
		$detector{"pos"}         = "0 0 $ZCenter*mm";
		$detector{"color"}       = "a00000";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm $ZhalfLength*mm 0*deg 360*deg";
		$detector{"material"}    = "ShimCoil";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);
		

		# Pumping Volume
		$Rin  = $PumpingVolumeRin;
		$Rout = $PumpingVolumeRout; 
		%detector = init_det();
		$detector{"name"}        = "PumpingVolumeTube";
		$detector{"mother"}      = "VacuumVolume";
		$detector{"description"} = "Pumping volume tube";
		$detector{"color"}       = "000080";
		$detector{"type"}        = "Polycone";
		$detector{"pos"}         = "0*mm 0*mm $TargetCenter*mm";
		$detector{"dimensions"}  = "0.0*deg 360*deg 2*counts $Rin*mm $Rin*mm $Rout*mm $Rout*mm -$VolumeLength*mm $SpheresCenter*mm";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);
          	$Rout = $PumpingVolumeRin + $PumpingVolumeWindow ; 
		%detector = init_det();
		$detector{"name"}        = "PumpingVolumeSphere";
		$detector{"mother"}      = "VacuumSphere";
		$detector{"description"} = "Pumping volume sphere";
		$detector{"pos"}         = "0 0 0*mm";
		$detector{"color"}       = "000080";
		$detector{"type"}        = "Sphere";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm 0*deg 360*deg 0*deg 90*deg";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

           	# Heat Shield volume
		$Rin  = $HeatShieldRin;
		$Rout = $HeatShieldRout; 
		%detector = init_det();
		$detector{"name"}        = "HeatShieldTube";
		$detector{"mother"}      = "VacuumVolume";
		$detector{"description"} = "Heat shield tube";
		$detector{"color"}       = "404040";
		$detector{"type"}        = "Polycone";
		$detector{"pos"}         = "0*mm 0*mm $TargetCenter*mm";
		$detector{"dimensions"}  = "0.0*deg 360*deg 2*counts $Rin*mm $Rin*mm $Rout*mm $Rout*mm -$VolumeLength*mm $SpheresCenter*mm";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);
		$Rout = $HeatShieldRin + $HeatShieldWindow ; 
		%detector = init_det();
		$detector{"name"}        = "HeatShieldSphere";
		$detector{"mother"}      = "VacuumSphere";
		$detector{"description"} = "Heat shield sphere";
		$detector{"pos"}         = "0 0 0*mm";
		$detector{"color"}       = "404040";
		$detector{"type"}        = "Sphere";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm 0*deg 360*deg 0*deg 90*deg";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);

           	# Vacuum can
		$Rin  = $VacuumCanRin;
		$Rout = $VacuumCanRout; 
		%detector = init_det();
		$detector{"name"}        = "VacuumCanTube";
		$detector{"mother"}      = "VacuumVolume";
		$detector{"description"} = "Vacuum can tube";
		$detector{"color"}       = "0d0d0d";
		$detector{"type"}        = "Polycone";
		$detector{"pos"}         = "0*mm 0*mm $TargetCenter*mm";
		$detector{"dimensions"}  = "0.0*deg 360*deg 2*counts $Rin*mm $Rin*mm $Rout*mm $Rout*mm -$VolumeLength*mm $SpheresCenter*mm";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);
		$Rout = $VacuumCanRin + $VacuumCanWindow ; 
		%detector = init_det();
		$detector{"name"}        = "VacuumCanSphere";
		$detector{"mother"}      = "VacuumSphere";
		$detector{"description"} = "Vacuum can sphere";
		$detector{"pos"}         = "0 0 0*mm";
		$detector{"color"}       = "0d0d0d";
		$detector{"type"}        = "Sphere";
		$detector{"dimensions"}  = "$Rin*mm $Rout*mm 0*deg 360*deg 0*deg 90*deg";
		$detector{"material"}    = "G4_Al";
		$detector{"style"}       = "1";
		print_det(\%configuration, \%detector);
	

}

1;






















