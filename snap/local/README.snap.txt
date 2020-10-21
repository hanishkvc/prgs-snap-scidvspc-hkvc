======================================
Notes for the scidvspc snap packaging
======================================
Author: HanishKVC
Version: 20201020IST2123


This is just a experimental snap packaging of scid_vs_pc by me.


Source
========

The upstream url for scidvspc package is

https://sourceforge.net/p/scidvspc/code/HEAD/tarball
svn checkout http://svn.code.sf.net/p/scidvspc/code/ scidvspc-code

The source for this snap packaging is

* the snap directory used by snapcraft to generate this snap package is in

  $SNAP/usr/share/doc/scidvspc-hkvc/

* the git for the same can be found at

  https://github.com/hanishkvc


Build
=======

snapcraft

* create the snap package running throu all the steps as required

snapcraft --debug

* create the snap package, while dropping down to a shell if something fails

snapcraft clean scidvspc

* to clean a specific part of a snap package like scidvspc in this example above

snapcraft clean

* clean everything including the multipass vm

snapcraft build _OR_ snapcraft stage _OR_ snapcraft _OR_ ...

* run upto including the specified step in the snap package creation steps.
  If no step specified, then run through all the steps as may be required.

snapcraft prime --shell _SAME_AS_ snapcraft stage --shell-after

* drop to a shell before or after the specified step


Runtime
=========

Environment
-------------

TCLTK_BPATH= $SNAP/usr/share/tcltk

TCL_LIBRARY= $TCLTK_BPATH/tcl8.6:$TCL_LIBRARY

* This is used by tcl to find init.tcl

TK_LIBRARY=  $TCLTK_BPATH/tk8.6:$TK_LIBRARY

* This should point to location of Tk library

TCLLIBPATH=  $SNAP/usr/lib/tcltk $SNAP/usr/lib/tcltk/x86_64-linux-gnu $TCLLIBPATH

* This is used by tcltk to find packages

Home
------

The AppWorkingDir is $HOME/snap/scidvspc-hkvc/<revision>

$SNAP_USER_DATA points to this AppWorkingDir

ToRun
------

type scidvspc-hkvc.scidvspc in a console/terminal

stockfish available in $SNAP/usr/games/

Debugging
-----------

If you want to change the application environment or so at runtime you could do

snap run --shell scidvspc-hkvc.scidvspc

then change the environment variables or anything else as required

then run the application as

$SNAP/usr/local/bin/scid



HISTORY
=========

201811XY
----------

1.Q Not able to find init.tcl
1.1 Set TCL_LIBRARY and TK_LIBRARY wrt $SNAP related tcltk paths,
    solved init.tcl but this popped up msgcat issue, SO
1.2 Tried copying usr/share/tcltk/* to usr/lib/,
    but again solved init.tcl but msgcat issue popped up.
1.3 After finding 2.2 edit tm.tcl soln;
    Avoid copying usr/share/tcltk/* to usr/lib/, by setting
    TCL_LIBRARY & TK_LIBRARY, The more elegant solution.

2.Q Not able to find msgcat
2.1 tried updating path in pkgIndex.tcl, didnt help, but as change
    is logically correct retaining
2.2 edit tm.tcl to search in $SNAP rooted paths rather than the
    default / rooted paths fixed the issue

3.Q Source for this snap package
3.1 Have added the snap directory used by snapcraft to generate
    the snap package into $SNAP/usr/share/doc/scidvspc-hkvc/

4.Q Where am I when I am running the override-prime logic
4.1 I had initially assumed that I will be in the snap folder
    which contains the snapcraft.yaml file.
    HOWEVER the way the logic failed when trying to run patch
    on usr/local/bin/scid file ...
4.2 Based on the way things are working, I assume that I am in
    $SNAPCRAFT_PRIME folder by default when I am running code
    as part of the override-prime logic


202010XY
----------

Changes to snapcrafting as of 20201019 (here after 2 years)

* One needs to use the base tag within snapcraft.yaml and
  inturn specify a base snap that should be used wrt the
  build time multipass vm. The current recommendation is
  core18.

* the snap folder used by snapcraft is available within
  project/snap folder now, instead of snap folder, when using
  the multipass based snapcraft. Rather the snap folder now
  corresponds to the runtime snap folder of the user used for
  building the snap within the multipass based vm.

* any support files within the project's snapcraft snap folder
  needs to be moved to a subfolder named local.

Fixing TDOM not found

* Rather snack installs into usr/lib/tcltk while tdom installs
  into usr/lib/tcltk/x86_64-linux-gnu so TCLLIBPATH which is used
  to search for packages needs to contain both paths. So updated
  for same. As this is a tcl list so space is used to seperate
  the paths in it.

  With this both snack and tdom are found by scidvspc.

Using alsa from snap

* make libasound2 and helpers available to this snap's runtime
  by including it in stage-packages or so.

  For this snap, tcl-snack brings in this.

* one needs to add alsa to the list of plugs.

* explicitly connect the snap package with snap system wrt the
  alsa interface. This is because alsa is not autoconnected.

  sudo snap connect scidvspc-hkvc:alsa

* cross verify the connection using

  snap interface

  snap connections

* Make alsa runtime support files accessible at /usr/share/alsa

  Use layout of snapcraft.yaml to bind mount $SNAP/usr/share/alsa
  to /usr/share/alsa.

  NOTE: if user needs to change any files in /usr/share/alsa in their
  system to make alsa work on their system, then this layout based
  bind mounting will override those changes, so rather in that case
  either the changes in the users' host system need to be exposed to
  snap (i.e propagate the other way to what is currently being done)
  and or the contents of snap's /usr/share/alsa exposed for user to
  edit in some way (which could include even a dumb mechanism like
  checking for some specific files in snap's user specific directory
  in their home folder and then bringing it into /usr/share/alsa in
  the snap's runtime environment) and or ...
  Have forgotten the nitty gritties of alsa now, so need to think
  about this and look into it if required later. Ideally based on linux
  filesystem conventions I am assuming that user doesnt need to change
  things in /usr/share/alsa, for now.

* make snack always use alsa instead of oss for audio by explicitly
  specifying that libsnack-alsa is needed for snap's runtime.

  This was required because even thou with base of core18 tcl-snack was
  pulling in libsnack-alsa, once I changed to base of core20, it pulled
  in libsnack-oss, thus leading to audio not working because alsa by
  default doesnt emulate oss sound devices. So forcing the use of alsa
  backend of libsnack now.

Switching to base core20

* newer v11 of stockfish is used.

* newer fontconfig is used which doesnt have issue with font config
  files.

  Also realised that I had a parallel issue of not installing fontconfig
  tools in the snap's runtime. This inturn was leading to this snap's
  figurines font not getting configured for the runtime during build.

  So now I explicitly install fontconfig for the snap's runtime. However
  that still hasn't solved the issue with figurines font. Maybe I need
  to do additional configuration wrt these fonts.

* The sound playback seems to have problems with core20, as only every
  alternate audio seems to play from the scidvspc program. i.e once
  a move related audio has played, then the next move audio doesnt play,
  while the one after that will play and so on. This issue seems to be
  noted on the internet wrt scidvspc and snack. And it seems to be noted
  as due to snack having some bug and needing maintainance.

Have to decide whether to stick to core20 and sacrifice wrt sound playback
in the program, while gaining newer stockfish and better fontconfig logic
or revert back to core18.


TODO
======

T01 Have to check if there is a way to persist data across snap
    remove and snap install.
    Seems like $SNAP_USER_DATA and $SNAP_USER_COMMON get cleared
    during snap remove. For now access to user home directory
    should allow users to persist any data they want.

T03 Handling of email / correspondance related logic May not
    work currently. Also network interface is not enabled for
    the snap currently.

T04 Look at fixing the issue with old fontconfig having issue with
    font configuration files, by installing a newer version.

    core20 this is fixed. Need to do for core18 if required.

T05 Use a newer version of stockfish.

    core20 this is fixed. Need to do for core18 if required.

T06 Cross verify that core20 based snap doesnt have any issue when
    run on ubuntu 16.04 or 18.04 lts releases or for that manner
    any linux distro other than ubuntu 20.04 lts.

    Ideally it shouldnt create any problem, but better to check once
    to be sure.

