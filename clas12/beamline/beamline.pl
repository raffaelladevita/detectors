#!/usr/bin/perl -w


use strict;
use lib ("$ENV{GEMC}/api/perl");
use utils;
use parameters;
use geometry;
use math;
use materials;

use Math::Trig;

# Help Message
sub help()
{
	print "\n Usage: \n";
	print "   beamline.pl <configuration filename>\n";
 	print "   Will create the CLAS12 beamline and materials\n";
 	print "   Note: The passport and .visa files must be present if connecting to MYSQL. \n\n";
	exit;
}

# Make sure the argument list is correct
if( scalar @ARGV != 1)
{
	help();
	exit;
}

# Loading configuration file and paramters
our %configuration = load_configuration($ARGV[0]);


# Global pars - these should be read by the load_parameters from file or DB

# General:
our $inches = 25.4;

# materials
require "./materials.pl";


# vacuum line throughout the shields, torus and downstream
require "./vacuumLineNew.pl";
require "./ELMOline.pl";
require "./ELMOlinemod1.pl";
require "./ELMOlinemod2.pl";
require "./ELMOlinemod3.pl";
require "./ELMOlinemod4.pl";
require "./ELMOlinemod5.pl";
require "./ELMOlinemod6.pl";
require "./fluxes.pl";

my @allConfs = ("FTOn", "FTOff","ELMO","ELMOmod1","ELMOmod2","ELMOmod3","ELMOmod4","ELMOmod5","ELMOmod6","fluxes");

foreach my $conf ( @allConfs )
{

	$configuration{"variation"} = $conf ;

	# materials
	materials();

	# vacuum line throughout the shields, torus and downstream
	# temp includes the torus back nose
	if( $configuration{"variation"} eq "FTOff" or $configuration{"variation"} eq "FTOn") {
	vacuumLine();
	}
	if( $configuration{"variation"} eq "ELMO") {
	    ELMOline();
	}
	if( $configuration{"variation"} eq "ELMOmod1") {
	    ELMOlinemod1();
	}
	if( $configuration{"variation"} eq "ELMOmod2") {
	    ELMOlinemod2();
	}
	if( $configuration{"variation"} eq "ELMOmod3") {
	    ELMOlinemod3();
	}
	if( $configuration{"variation"} eq "ELMOmod4") {
	    ELMOlinemod4();
	}
	if( $configuration{"variation"} eq "ELMOmod5") {
	    ELMOlinemod5();
	}
	if( $configuration{"variation"} eq "ELMOmod6") {
	    ELMOlinemod6();
	}
	if( $configuration{"variation"} eq "fluxes") {
	    fluxes();
	}
}



