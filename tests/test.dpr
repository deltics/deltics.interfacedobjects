program test;

{$apptype console}

{$i deltics.inc}

uses
  FastMM4,
  SysUtils,
  Deltics.Smoketest,
  Deltics.Interfaces in '..\src\Deltics.Interfaces.pas',
  Deltics.Interfaces.ComInterfacedObject in '..\src\Deltics.Interfaces.ComInterfacedObject.pas',
  Deltics.Interfaces.ComInterfacedPersistent in '..\src\Deltics.Interfaces.ComInterfacedPersistent.pas',
  Deltics.Interfaces.FlexInterfacedObject in '..\src\Deltics.Interfaces.FlexInterfacedObject.pas',
  Deltics.Interfaces.InterfacedObject in '..\src\Deltics.Interfaces.InterfacedObject.pas',
  Deltics.Interfaces.InterfacedPersistent in '..\src\Deltics.Interfaces.InterfacedPersistent.pas',
  Deltics.Interfaces.InterfaceReference in '..\src\Deltics.Interfaces.InterfaceReference.pas',
  Deltics.Interfaces.WeakInterfaceReference in '..\src\Deltics.Interfaces.WeakInterfaceReference.pas',
  Test.InterfacedObject in 'Test.InterfacedObject.pas',
  Test.ComInterfacedObject in 'Test.ComInterfacedObject.pas',
  Test.FlexInterfacedObject in 'Test.FlexInterfacedObject.pas',
  Test.InterfaceReference in 'Test.InterfaceReference.pas';

begin
  TestRun.Test(TInterfacedObjectTests);
  TestRun.Test(TComInterfacedObjectTests);
  TestRun.Test(TFlexInterfacedObjectTests);
  TestRun.Test(TInterfaceReferenceTests);
end.
