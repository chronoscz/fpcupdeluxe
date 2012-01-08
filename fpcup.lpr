{ FPC/Lazarus installer/updater
  Copyright (C) 2012 Reinier Olislagers

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}
program fpcup;

{ Command line interface to installing/updating FPC/Lazarus instances }
{$mode objfpc}{$H+}
{
First verify: check existing fpc locations, versions, check svn present
Compiler test if suitable found: compile test file

Command: tfplist or something timestamp, sequence description; each has log
Log: timestamp, sequence, description

Choices: set by properties etc.
<id>, choice/value, description
Read out at end to show user what happened

Options startup: unattended: assume update if possible, if not, install
Do not set path, create shortcuts/batch files to start, with --primary-config-path
Add something like fpcup.config in the settings dir so we know for which fpc/laz combo this dir is used
}
uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  installer,
  svnclient;

//{$R *.res} //Keep it simple, no resources
var
  FInstaller: TInstaller;
begin
  writeln('FCPUp FreePascal/Lazarus downloader/installer started.');
  writeln('This program will download the FPC and Lazarus sources');
  writeln('from the source Subversion/SVN repositories,');
  writeln('compile, and install.');
  writeln('Result: you get a fresh, up-to-date Lazarus/FPC installation.');
  // Let's start simple: checkout, update, make for FPC+Lazarus.
  try
    // Adjust these directories to taste/your situation.
    FInstaller := TInstaller.Create;
    FInstaller.BootstrapCompilerDirectory := 'c:\development\fpcbootstrap\';
    //Has existing compiler that can compile FPC sources. Should be FPC 2.4.4, other versions might work
    FInstaller.FPCDirectory := 'c:\development\fpc';
    //Directory where FPC installation will end up
    FInstaller.FPCURL := 'http://svn.freepascal.org/svn/fpc/branches/fixes_2_6';
    //Use fixes 2.6, not default set by updater (trunk/2.7.1) as Lazarus doesn't work with 2.7.1
    FInstaller.LazarusDirectory := 'c:\development\lazarus';
    FInstaller.LazarusURL := 'http://svn.freepascal.org/svn/lazarus/trunk';
    //svn2 seems to lag behind a lot.
    FInstaller.MakePath := 'C:\development\binutils\';
    //Existing make needed to compile FPC. Will be downloaded if doesn't exit

    // Get/update/compile (if needed) FPC; only compile Lazarus if succeeded.
    installer.debugln('getting and compiling fpc:');
    if FInstaller.GetFPC then
    begin
      installer.debugln('getting and compiling lazarus:');
      FInstaller.GetLazarus;
    end;
  finally
    FInstaller.Free;
  end;
  writeln('end');
end.

