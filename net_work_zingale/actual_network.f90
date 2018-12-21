module actual_network
  use physical_constants, only: ERG_PER_MeV
  use bl_types
  
  implicit none

  public num_rate_groups

  double precision, parameter :: avo = 6.0221417930d23
  double precision, parameter :: c_light = 2.99792458d10
  double precision, parameter :: enuc_conv2 = -avo*c_light*c_light

  double precision, parameter :: ev2erg  = 1.60217648740d-12
  double precision, parameter :: mev2erg = ev2erg*1.0d6
  double precision, parameter :: mev2gr  = mev2erg/c_light**2

  double precision, parameter :: mass_neutron  = 1.67492721184d-24
  double precision, parameter :: mass_proton   = 1.67262163783d-24
  double precision, parameter :: mass_electron = 9.10938215450d-28

  integer, parameter :: nrates = 16
  integer, parameter :: num_rate_groups = 4

  ! Evolution and auxiliary
  integer, parameter :: nspec_evolve = 11
  integer, parameter :: naux  = 0

  ! Number of nuclear species in the network
  integer, parameter :: nspec = 11

  ! Number of reaclib rates
  integer, parameter :: nrat_reaclib = 16
  
  ! Number of tabular rates
  integer, parameter :: nrat_tabular = 0

  ! Binding Energies Per Nucleon (MeV)
  double precision :: ebind_per_nucleon(nspec)

  ! aion: Nucleon mass number A
  ! zion: Nucleon atomic number Z
  ! nion: Nucleon neutron number N
  ! bion: Binding Energies (ergs)

  ! Nuclides
  integer, parameter :: jp   = 1
  integer, parameter :: jhe4   = 2
  integer, parameter :: jo16   = 3
  integer, parameter :: jo20   = 4
  integer, parameter :: jf20   = 5
  integer, parameter :: jne20   = 6
  integer, parameter :: jmg24   = 7
  integer, parameter :: jal27   = 8
  integer, parameter :: jsi28   = 9
  integer, parameter :: jp31   = 10
  integer, parameter :: js32   = 11

  ! Reactions
  integer, parameter :: k_o20__f20   = 1
  integer, parameter :: k_f20__ne20   = 2
  integer, parameter :: k_ne20__he4_o16   = 3
  integer, parameter :: k_he4_o16__ne20   = 4
  integer, parameter :: k_he4_ne20__mg24   = 5
  integer, parameter :: k_he4_mg24__si28   = 6
  integer, parameter :: k_p_al27__si28   = 7
  integer, parameter :: k_he4_al27__p31   = 8
  integer, parameter :: k_he4_si28__s32   = 9
  integer, parameter :: k_p_p31__s32   = 10
  integer, parameter :: k_o16_o16__p_p31   = 11
  integer, parameter :: k_o16_o16__he4_si28   = 12
  integer, parameter :: k_he4_mg24__p_al27   = 13
  integer, parameter :: k_p_al27__he4_mg24   = 14
  integer, parameter :: k_he4_si28__p_p31   = 15
  integer, parameter :: k_p_p31__he4_si28   = 16

  ! reactvec indices
  integer, parameter :: i_rate        = 1
  integer, parameter :: i_drate_dt    = 2
  integer, parameter :: i_scor        = 3
  integer, parameter :: i_dscor_dt    = 4
  integer, parameter :: i_dqweak      = 5
  integer, parameter :: i_epart       = 6

  character (len=16), save :: spec_names(nspec) 
  character (len= 5), save :: short_spec_names(nspec)
  character (len= 5), save :: short_aux_names(naux)

  double precision :: aion(nspec), zion(nspec), bion(nspec)
  double precision :: nion(nspec), mion(nspec), wion(nspec)

  !$acc declare create(aion, zion, bion, nion, mion, wion)

contains

  subroutine actual_network_init()
    
    implicit none
    
    integer :: i

    spec_names(jp)   = "hydrogen-1"
    spec_names(jhe4)   = "helium-4"
    spec_names(jo16)   = "oxygen-16"
    spec_names(jo20)   = "oxygen-20"
    spec_names(jf20)   = "fluorine-20"
    spec_names(jne20)   = "neon-20"
    spec_names(jmg24)   = "magnesium-24"
    spec_names(jal27)   = "aluminum-27"
    spec_names(jsi28)   = "silicon-28"
    spec_names(jp31)   = "phosphorus-31"
    spec_names(js32)   = "sulfur-32"

    short_spec_names(jp)   = "h1"
    short_spec_names(jhe4)   = "he4"
    short_spec_names(jo16)   = "o16"
    short_spec_names(jo20)   = "o20"
    short_spec_names(jf20)   = "f20"
    short_spec_names(jne20)   = "ne20"
    short_spec_names(jmg24)   = "mg24"
    short_spec_names(jal27)   = "al27"
    short_spec_names(jsi28)   = "si28"
    short_spec_names(jp31)   = "p31"
    short_spec_names(js32)   = "s32"

    ebind_per_nucleon(jp)   = 0.00000000000000d+00
    ebind_per_nucleon(jhe4)   = 7.07391500000000d+00
    ebind_per_nucleon(jo16)   = 7.97620600000000d+00
    ebind_per_nucleon(jo20)   = 7.56857000000000d+00
    ebind_per_nucleon(jf20)   = 7.72013400000000d+00
    ebind_per_nucleon(jne20)   = 8.03224000000000d+00
    ebind_per_nucleon(jmg24)   = 8.26070900000000d+00
    ebind_per_nucleon(jal27)   = 8.33155300000000d+00
    ebind_per_nucleon(jsi28)   = 8.44774400000000d+00
    ebind_per_nucleon(jp31)   = 8.48116700000000d+00
    ebind_per_nucleon(js32)   = 8.49312900000000d+00

    aion(jp)   = 1.00000000000000d+00
    aion(jhe4)   = 4.00000000000000d+00
    aion(jo16)   = 1.60000000000000d+01
    aion(jo20)   = 2.00000000000000d+01
    aion(jf20)   = 2.00000000000000d+01
    aion(jne20)   = 2.00000000000000d+01
    aion(jmg24)   = 2.40000000000000d+01
    aion(jal27)   = 2.70000000000000d+01
    aion(jsi28)   = 2.80000000000000d+01
    aion(jp31)   = 3.10000000000000d+01
    aion(js32)   = 3.20000000000000d+01

    zion(jp)   = 1.00000000000000d+00
    zion(jhe4)   = 2.00000000000000d+00
    zion(jo16)   = 8.00000000000000d+00
    zion(jo20)   = 8.00000000000000d+00
    zion(jf20)   = 9.00000000000000d+00
    zion(jne20)   = 1.00000000000000d+01
    zion(jmg24)   = 1.20000000000000d+01
    zion(jal27)   = 1.30000000000000d+01
    zion(jsi28)   = 1.40000000000000d+01
    zion(jp31)   = 1.50000000000000d+01
    zion(js32)   = 1.60000000000000d+01

    nion(jp)   = 0.00000000000000d+00
    nion(jhe4)   = 2.00000000000000d+00
    nion(jo16)   = 8.00000000000000d+00
    nion(jo20)   = 1.20000000000000d+01
    nion(jf20)   = 1.10000000000000d+01
    nion(jne20)   = 1.00000000000000d+01
    nion(jmg24)   = 1.20000000000000d+01
    nion(jal27)   = 1.40000000000000d+01
    nion(jsi28)   = 1.40000000000000d+01
    nion(jp31)   = 1.60000000000000d+01
    nion(js32)   = 1.60000000000000d+01

    do i = 1, nspec
       bion(i) = ebind_per_nucleon(i) * aion(i) * ERG_PER_MeV
    end do

    ! Set the mass
    mion(:) = nion(:) * mass_neutron + zion(:) * (mass_proton + mass_electron) &
         - bion(:)/(c_light**2)

    ! Molar mass
    wion(:) = avo * mion(:)

    ! Common approximation
    !wion(:) = aion(:)

    !$acc update device(aion, zion, bion, nion, mion, wion)
  end subroutine actual_network_init

  subroutine actual_network_finalize()
    ! STUB FOR MAESTRO
  end subroutine actual_network_finalize
  
  subroutine ener_gener_rate(dydt, enuc)
    ! Computes the instantaneous energy generation rate
    !$acc routine seq
  
    implicit none

    double precision :: dydt(nspec), enuc

    ! This is basically e = m c**2

    enuc = sum(dydt(:) * mion(:)) * enuc_conv2

  end subroutine ener_gener_rate

end module actual_network