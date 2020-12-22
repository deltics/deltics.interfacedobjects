program test;

{$apptype console}

{$i deltics.inc}

uses
  FastMM4,
  SysUtils,
  Deltics.Smoketest,
  Deltics.InterfacedObjects in '..\src\Deltics.InterfacedObjects.pas',
  Deltics.InterfacedObjects.ComInterfacedObject in '..\src\Deltics.InterfacedObjects.ComInterfacedObject.pas',
  Deltics.InterfacedObjects.ComInterfacedPersistent in '..\src\Deltics.InterfacedObjects.ComInterfacedPersistent.pas',
  Deltics.InterfacedObjects.FlexInterfacedObject in '..\src\Deltics.InterfacedObjects.FlexInterfacedObject.pas',
  Deltics.InterfacedObjects.InterfacedObject in '..\src\Deltics.InterfacedObjects.InterfacedObject.pas',
  Deltics.InterfacedObjects.InterfacedPersistent in '..\src\Deltics.InterfacedObjects.InterfacedPersistent.pas',
  Deltics.InterfacedObjects.InterfaceReference in '..\src\Deltics.InterfacedObjects.InterfaceReference.pas',
  Deltics.InterfacedObjects.WeakInterfaceReference in '..\src\Deltics.InterfacedObjects.WeakInterfaceReference.pas',
  Deltics.InterfacedObjects.IReferenceCount in '..\src\Deltics.InterfacedObjects.IReferenceCount.pas',
  Test.InterfacedObject in 'Test.InterfacedObject.pas',
  Test.ComInterfacedObject in 'Test.ComInterfacedObject.pas',
  Test.FlexInterfacedObject in 'Test.FlexInterfacedObject.pas',
  Test.InterfaceReference in 'Test.InterfaceReference.pas',
  Test.WeakInterfaceReference in 'Test.WeakInterfaceReference.pas';

begin
  TestRun.Test(TInterfacedObjectTests);
  TestRun.Test(TComInterfacedObjectTests);
  TestRun.Test(TFlexInterfacedObjectTests);
  TestRun.Test(TInterfaceReferenceTests);
  TestRun.Test(TWeakInterfaceReferenceTests);
end.
