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


TODO
======

T01 Have to check if there is a way to persist data across snap
    remove and snap install.
    Seems like $SNAP_USER_DATA and $SNAP_USER_COMMON get cleared
    during snap remove. For now access to user home directory
    should allow users to persist any data they want.

T02 Have to enable alsa interface, once issue with snack is
    resolved.

T03 Handling of email / correspondance related logic May not
    work currently. Also network interface is not enabled for
    the snap currently.

