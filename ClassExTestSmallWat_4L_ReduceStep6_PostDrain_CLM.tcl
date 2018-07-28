
# Automated TCL Input script for idealized hillslopes
# Two layer case using a solid file
# 
# This script is run as follows: 
#	tclsh TwoLayer_General_SpinupTopo.tcl P Q R Hillslope
# Import the ParFlow TCL package
#
lappend auto_path $env(PARFLOW_DIR)/bin 
package require parflow
namespace import Parflow::*


set tcl_precision 16


#-----------------------------------------------------------------------------
# File input version number
#-----------------------------------------------------------------------------
pfset FileVersion 4

#-----------------------------------------------------------------------------
# Process Topology
#-----------------------------------------------------------------------------

# The first three command line arguments after tclsh name.tcl are P, Q, R

set P  6
set Q  5
set R  1

pfset Process.Topology.P $P
pfset Process.Topology.Q $Q   
pfset Process.Topology.R $R

#-----------------------------------------------------------------------------
# Computational Grid
#-----------------------------------------------------------------------------

pfset ComputationalGrid.Lower.X                0.0
pfset ComputationalGrid.Lower.Y                0.0
pfset ComputationalGrid.Lower.Z                0.0

# Get computational grid discretization

pfset ComputationalGrid.DX	               30.0
pfset ComputationalGrid.DY                     30.0
pfset ComputationalGrid.DZ	               1.0

pfset ComputationalGrid.NX                     62
pfset ComputationalGrid.NY                     64
pfset ComputationalGrid.NZ                     595

#-----------------------------------------------------------------------------
# Make a directory for the simulation 
#-----------------------------------------------------------------------------


#set path	"SmallWat_WSlopes_4Layer/NewBC_ConstantForcingTest/ReducePermeability_Step2/ReducePermeability_Step3/ReducePermeability_Step4/Step5/Step6/CLMRun/NewCLM_NoKey"
#file mkdir	$path
#cd 		$path

#Inputs will be copied into this directory
set solidFile	"W12SmallWat_InactiveXY_FlatBottom_Aug14_5patches.pfsol"
set xSlopeFile	"smallwat_slopex_Rotate.pfb"
set ySlopeFile  "smallwat_slopey_Rotate.pfb"
set indicFile   "w12_smallWat_taperedIndic_30_4layer_wzone_Jul29.pfb"
set initPressFile "W12SmallWat_4L_Step6_PostCLMDrain.out.press.00105.pfb"

set clmFile  "TrinidadCLM_2004to2010_RepeatTwo.dat"


#---------------------------------------------------------
# The Names of the GeomInputs
#---------------------------------------------------------


pfset GeomInput.Names                 		"domain_input indi_input"
pfset GeomInput.domain_input.InputType  	SolidFile
pfset GeomInput.domain_input.GeomNames  	domain
pfset GeomInput.domain_input.FileName		$solidFile

#-----------------------------------------------------------------------------
# Domain Geometry
#-----------------------------------------------------------------------------

# Patches are set on a box. These are the same between runs

pfset Geom.domain.Patches             "z-upper z-lower startperimeter outflowcells restperimeter"

#-----------------------------------------------------------------------------
# Indicator Geometry Input
#-----------------------------------------------------------------------------


pfset GeomInput.indi_input.InputType	IndicatorField
pfset GeomInput.indi_input.GeomNames	"inactive zone_upper zone_lower zone_midupper zone_midlower"
pfset Geom.indi_input.FileName		$indicFile

pfset GeomInput.inactive.Value		0
pfset GeomInput.zone_upper.Value	4
pfset GeomInput.zone_midupper.Value	3
pfset GeomInput.zone_midlower.Value	2
pfset GeomInput.zone_lower.Value	1
#-----------------------------------------------------------------------------
# Perm
#-----------------------------------------------------------------------------
#permeability units in m/hr

pfset Geom.Perm.Names "domain zone_upper zone_lower zone_midupper zone_midlower"

pfset Geom.domain.Perm.Type 		Constant
pfset Geom.domain.Perm.Value 		0.1

pfset Geom.zone_lower.Perm.Type 		Constant
pfset Geom.zone_lower.Perm.Value 		0.000001

pfset Geom.zone_midlower.Perm.Type 		Constant
pfset Geom.zone_midlower.Perm.Value 		0.00001

pfset Geom.zone_midupper.Perm.Type 		Constant
pfset Geom.zone_midupper.Perm.Value 		0.001

pfset Geom.zone_upper.Perm.Type 		Constant
pfset Geom.zone_upper.Perm.Value 		0.01

pfset Perm.TensorType               TensorByGeom

pfset Geom.Perm.TensorByGeom.Names  "domain zone_upper zone_midupper"

pfset Geom.domain.Perm.TensorValX  10.0
pfset Geom.domain.Perm.TensorValY  10.0
pfset Geom.domain.Perm.TensorValZ  1.0

pfset Geom.zone_upper.Perm.TensorValX  10.0
pfset Geom.zone_upper.Perm.TensorValY  10.0
pfset Geom.zone_upper.Perm.TensorValZ  1.0

pfset Geom.zone_midupper.Perm.TensorValX  10.0
pfset Geom.zone_midupper.Perm.TensorValY  10.0
pfset Geom.zone_midupper.Perm.TensorValZ  1.0

#-----------------------------------------------------------------------------
# Relative Permeability
#-----------------------------------------------------------------------------

pfset Phase.RelPerm.Type               VanGenuchten
pfset Phase.RelPerm.GeomNames          "domain zone_lower zone_upper zone_midupper zone_midlower" 
pfset Geom.domain.RelPerm.Alpha         6.5
pfset Geom.domain.RelPerm.N             2.0

pfset Geom.zone_lower.RelPerm.Alpha         1.5
pfset Geom.zone_lower.RelPerm.N             2.0

pfset Geom.zone_midlower.RelPerm.Alpha         1.5
pfset Geom.zone_midlower.RelPerm.N             2.0

pfset Geom.zone_midupper.RelPerm.Alpha         3.0
pfset Geom.zone_midupper.RelPerm.N             2.0

#sandy loam
pfset Geom.zone_upper.RelPerm.Alpha         3.475
pfset Geom.zone_upper.RelPerm.N             2.0



#---------------------------------------------------------
# Saturation
#---------------------------------------------------------

pfset Phase.Saturation.Type              VanGenuchten
pfset Phase.Saturation.GeomNames         "domain zone_lower zone_upper zone_midlower zone_midupper"

pfset Geom.domain.Saturation.Alpha        6.5
pfset Geom.domain.Saturation.N            2.0
pfset Geom.domain.Saturation.SRes         0.1
pfset Geom.domain.Saturation.SSat         1.0

pfset Geom.zone_lower.Saturation.Alpha        1.5
pfset Geom.zone_lower.Saturation.N            2.0
pfset Geom.zone_lower.Saturation.SRes         0.1
pfset Geom.zone_lower.Saturation.SSat         1.0

pfset Geom.zone_midlower.Saturation.Alpha        1.5
pfset Geom.zone_midlower.Saturation.N            2.0
pfset Geom.zone_midlower.Saturation.SRes         0.1
pfset Geom.zone_midlower.Saturation.SSat         1.0

pfset Geom.zone_midupper.Saturation.Alpha        3.0
pfset Geom.zone_midupper.Saturation.N            2.0
pfset Geom.zone_midupper.Saturation.SRes         0.1
pfset Geom.zone_midupper.Saturation.SSat         1.0

pfset Geom.zone_upper.Saturation.Alpha        3.475
pfset Geom.zone_upper.Saturation.N            2.0
pfset Geom.zone_upper.Saturation.SRes         0.16
pfset Geom.zone_upper.Saturation.SSat         1.0

#-----------------------------------------------------------------------------
# Specific Storage
#-----------------------------------------------------------------------------

pfset SpecificStorage.Type            Constant
pfset SpecificStorage.GeomNames       "domain"
#pfset Geom.domain.SpecificStorage.Value 1.0e-6
pfset Geom.domain.SpecificStorage.Value 1.0e-6

#-----------------------------------------------------------------------------
# Phases
#-----------------------------------------------------------------------------

pfset Phase.Names "water"

pfset Phase.water.Density.Type	Constant
pfset Phase.water.Density.Value	1.0

pfset Phase.water.Viscosity.Type	Constant
pfset Phase.water.Viscosity.Value	1.0

#-----------------------------------------------------------------------------
# Contaminants
#-----------------------------------------------------------------------------
pfset Contaminants.Names			""


#-----------------------------------------------------------------------------
# Gravity
#-----------------------------------------------------------------------------

pfset Gravity				1.0

#-----------------------------------------------------------------------------
# Setup timing info
#-----------------------------------------------------------------------------

# This script is setup for a 40000 hour simulation at a 15 minute timestep
# Timing in hours

pfset TimingInfo.BaseUnit        0.001
pfset TimingInfo.StartCount      0
pfset TimingInfo.StartTime       0.0
pfset TimingInfo.StopTime	 105120
pfset TimingInfo.DumpInterval    120.0
pfset TimeStep.Type              Constant
pfset TimeStep.Value             1.0


#-----------------------------------------------------------------------------
# Porosity
#-----------------------------------------------------------------------------

pfset Geom.Porosity.GeomNames         "domain zone_upper zone_lower zone_midlower zone_midupper"

pfset Geom.domain.Porosity.Type    Constant
pfset Geom.domain.Porosity.Value   0.39

pfset Geom.zone_upper.Porosity.Type    Constant
pfset Geom.zone_upper.Porosity.Value   0.32

pfset Geom.zone_midupper.Porosity.Type    Constant
pfset Geom.zone_midupper.Porosity.Value   0.3

pfset Geom.zone_midlower.Porosity.Type    Constant
pfset Geom.zone_midlower.Porosity.Value   0.1

pfset Geom.zone_lower.Porosity.Type    Constant
pfset Geom.zone_lower.Porosity.Value   0.02

#-----------------------------------------------------------------------------
# Domain
#-----------------------------------------------------------------------------
pfset Domain.GeomName "domain"

#-----------------------------------------------------------------------------
# Mobility
#-----------------------------------------------------------------------------
pfset Phase.water.Mobility.Type        Constant
pfset Phase.water.Mobility.Value       1.0


#-----------------------------------------------------------------------------
# Wells
#-----------------------------------------------------------------------------
pfset Wells.Names ""


#-----------------------------------------------------------------------------
# Time Cycles
#-----------------------------------------------------------------------------

pfset Cycle.Names "constant"
pfset Cycle.constant.Names              "alltime"
pfset Cycle.constant.alltime.Length      1
pfset Cycle.constant.Repeat             -1

#pfset Cycle.rainrec.Names              "rain rec"
#pfset Cycle.rainrec.rain.Length      	1000
#pfset Cycle.rainrec.rec.Length		3000
#pfset Cycle.rainrec.Repeat             	-1
 
#-----------------------------------------------------------------------------
# Boundary Conditions: Pressure
#-----------------------------------------------------------------------------

# Boundary conditions are consistent with new pfsol (5 patches)

pfset BCPressure.PatchNames          "z-upper z-lower startperimeter outflowcells restperimeter"

pfset Patch.startperimeter.BCPressure.Type			FluxConst
pfset Patch.startperimeter.BCPressure.Cycle			"constant"
pfset Patch.startperimeter.BCPressure.alltime.Value		0.0

pfset Patch.outflowcells.BCPressure.Type			DirEquilRefPatch
pfset Patch.outflowcells.BCPressure.Cycle			"constant"
pfset Patch.outflowcells.BCPressure.RefGeom			domain
pfset Patch.outflowcells.BCPressure.RefPatch			z-upper
pfset Patch.outflowcells.BCPressure.alltime.Value		0.0

#pfset Patch.outflowcells.BCPressure.Type			FluxConst
#pfset Patch.outflowcells.BCPressure.Cycle			"constant"
#pfset Patch.outflowcells.BCPressure.alltime.Value		0.0

pfset Patch.restperimeter.BCPressure.Type			FluxConst
pfset Patch.restperimeter.BCPressure.Cycle			"constant"
pfset Patch.restperimeter.BCPressure.alltime.Value		0.0

pfset Patch.z-lower.BCPressure.Type			FluxConst
pfset Patch.z-lower.BCPressure.Cycle			"constant"
pfset Patch.z-lower.BCPressure.alltime.Value		0.0

pfset Patch.z-upper.BCPressure.Type		        OverlandFlow
pfset Patch.z-upper.BCPressure.Cycle		        "constant"
pfset Patch.z-upper.BCPressure.alltime.Value		0.0



#---------------------------------------------------------
# Topo slopes in x-direction
#---------------------------------------------------------

pfset TopoSlopesX.Type 				"PFBFile"
pfset TopoSlopesX.GeomNames 			"domain"
pfset TopoSlopesX.FileName 			$xSlopeFile

#---------------------------------------------------------
# Topo slopes in y-direction
#---------------------------------------------------------
	
pfset TopoSlopesY.Type 				"PFBFile"
pfset TopoSlopesY.GeomNames 			"domain"
pfset TopoSlopesY.FileName 			$ySlopeFile

#---------------------------------------------------------
# Mannings coefficient 
#---------------------------------------------------------

pfset Mannings.Type "Constant"
pfset Mannings.GeomNames "domain"
pfset Mannings.Geom.domain.Value 4.75e-6

#---------------------------------------------------------
# Initial conditions: water pressure
#---------------------------------------------------------

### Initialize domain to be a constant distance below the top surface
#pfset ICPressure.Type                                   HydroStaticPatch
#pfset ICPressure.GeomNames                              domain
#pfset Geom.domain.ICPressure.Value                      -7.0
#pfset Geom.domain.ICPressure.RefGeom                    domain
#pfset Geom.domain.ICPressure.RefPatch                   z-upper

## Initial conditions from file (output of model run from saturated)
pfset ICPressure.Type                                   PFBFile
pfset ICPressure.GeomNames                              domain
pfset Geom.domain.ICPressure.FileName			 $initPressFile
pfset Geom.domain.ICPressure.RefGeom                    domain
pfset Geom.domain.ICPressure.RefPatch                   z-upper

#-----------------------------------------------------------------------------
# Phase sources:
#-----------------------------------------------------------------------------

pfset PhaseSources.Type                         Constant
pfset PhaseSources.GeomNames                    domain
pfset PhaseSources.Geom.domain.Value        	0.0

pfset PhaseSources.water.Type                   Constant
pfset PhaseSources.water.GeomNames              domain
pfset PhaseSources.water.Geom.domain.Value 	0.0

#-----------------------------------------------------------------------------
# Exact solution specification for error calculations
#-----------------------------------------------------------------------------

pfset KnownSolution                                    NoKnownSolution

#-----------------------------------------------------------------------------
# Set solver parameters
#-----------------------------------------------------------------------------

# CLM settings for a complete run with hourly timestep

pfset Solver.LSM				CLM
pfset Solver.CLM.CLMFileDir                     "clm_output/"
pfset Solver.CLM.IstepStart			1
pfset Solver.CLM.Print1dOut                     True
pfset Solver.BinaryOutDir                       False
pfset Solver.CLM.CLMDumpInterval                120
pfset Solver.CLM.ReuseCount			1

# Using 1D forcings for CLM.
pfset Solver.CLM.MetForcing                     1D
pfset Solver.CLM.MetFileName                    $clmFile
pfset Solver.CLM.MetFilePath                    "./"

pfset Solver.CLM.EvapBeta                        Linear
pfset Solver.CLM.VegWaterStress                  Saturation
pfset Solver.CLM.ResSat                          0.1
pfset Solver.CLM.WiltingPoint                    0.12
pfset Solver.CLM.FieldCapacity                   0.98
pfset Solver.CLM.IrrigationType                  none
pfset Solver.CLM.RootZoneNZ			 4
pfset Solver.CLM.SoilLayer			 4
pfset Solver.CLM.WriteLogs			 False
pfset Solver.CLM.WriteLastRST			 True
pfset Solver.CLM.SingleFile			 True

pfset Solver                                             Richards
pfset Solver.TerrainFollowingGrid			 False
pfset Solver.Nonlinear.VariableDz			 False

pfset Solver.MaxIter                                     200000000
pfset Solver.Drop					 1E-20
pfset Solver.AbsTol					 1E-9

pfset Solver.MaxConvergenceFailures                   	 8
pfset Solver.Nonlinear.MaxIter                           1200
pfset Solver.Nonlinear.ResidualTol                       1e-4

pfset Solver.Nonlinear.EtaChoice                         EtaConstant 
pfset Solver.Nonlinear.Etavalue				 0.001
pfset Solver.Nonlinear.UseJacobian			 True
pfset Solver.Nonlinear.StepTol				 1e-30
pfset Solver.Nonlinear.Globalization                     LineSearch
pfset Solver.Linear.KrylovDimension                      40
pfset Solver.Linear.MaxRestart                           5

pfset Solver.Linear.Preconditioner                       PFMGOctree
pfset Solver.Linear.Preconditioner.SymmetricMat		 Nonsymmetric


#Writing output (all pfb):
pfset Solver.PrintSubsurfData                         True
pfset Solver.PrintPressure                            True
pfset Solver.PrintSaturation                          True
pfset Solver.PrintMask                                True

pfset Solver.WriteSiloMannings                        True
pfset Solver.WriteSiloMask                            True
pfset Solver.WriteSiloSlopes                          True
pfset Solver.WriteSiloSubsurfData                     True
pfset Solver.WriteSiloPressure                        False
pfset Solver.WriteSiloSaturation                      False
pfset Solver.PrintCLM				      True

#-----------------------------------------------------------------------------
# Run and Unload the ParFlow output files
#-----------------------------------------------------------------------------


pfset ComputationalGrid.NX                     62
pfset ComputationalGrid.NY                     64
pfset ComputationalGrid.NZ                     1

#pfdist $xSlopeFile
#pfdist $ySlopeFile

pfset ComputationalGrid.NX                     62
pfset ComputationalGrid.NY                     64
pfset ComputationalGrid.NZ                     595

#pfdist $indicFile
#pfdist $initPressFile

# Run Program
set runname	"W12SmallWat_4L_Step6_PostDrain_CLM"
#puts $runname
#pfrun $runname

#pfundist $runname
#pfundist $xSlopeFile
#pfundist $ySlopeFile

#pfundist $indicFile
#pfundist $initPressFile

#set mask [pfload -pfb "$runname.out.mask.pfb"] 
#pfsave $mask -silo "$runname.mask.silo"

#set top [Parflow::pfcomputetop $mask]
for {set i 0} {$i < 0} {incr i} {
 set pressfile [format "%s.out.press.%05d.pfb" $runname $i]
 set data [pfload $pressfile]
# set top_data [Parflow::pfextracttop $top $data]
 pfsave $data -silo "$runname.press.$i.silo"

 set satfile [format "%s.out.satur.%05d.pfb" $runname $i]
 set sat [pfload $satfile]
# set top_data [Parflow::pfextracttop $top $data]
 pfsave $sat -silo "$runname.sat.$i.silo"
}





