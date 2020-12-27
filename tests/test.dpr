program test;

{$apptype console}

{$i deltics.inc}

uses
  FastMM4,
  SysUtils,
  Deltics.Smoketest,
  Deltics.InterfacedObjects in '..\src\Deltics.InterfacedObjects.pas',
  Deltics.InterfacedObjects.ObjectLifecycle in '..\src\Deltics.InterfacedObjects.ObjectLifecycle.pas',
  Deltics.InterfacedObjects.ComInterfacedObject in '..\src\Deltics.InterfacedObjects.ComInterfacedObject.pas',
  Deltics.InterfacedObjects.ComInterfacedPersistent in '..\src\Deltics.InterfacedObjects.ComInterfacedPersistent.pas',
  Deltics.InterfacedObjects.InterfacedObject in '..\src\Deltics.InterfacedObjects.InterfacedObject.pas',
  Deltics.InterfacedObjects.InterfacedObjectList in '..\src\Deltics.InterfacedObjects.InterfacedObjectList.pas',
  Deltics.InterfacedObjects.InterfacedPersistent in '..\src\Deltics.InterfacedObjects.InterfacedPersistent.pas',
  Deltics.InterfacedObjects.InterfaceReference in '..\src\Deltics.InterfacedObjects.InterfaceReference.pas',
  Deltics.InterfacedObjects.WeakInterfaceReference in '..\src\Deltics.InterfacedObjects.WeakInterfaceReference.pas',
  Test.InterfacedObject in 'Test.InterfacedObject.pas',
  Test.ComInterfacedObject in 'Test.ComInterfacedObject.pas',
  Test.InterfaceReference in 'Test.InterfaceReference.pas',
  Test.WeakInterfaceReference in 'Test.WeakInterfaceReference.pas',
  Test.InterfacedObjectList in 'Test.InterfacedObjectList.pas',
  Deltics.InterfacedObjects.Interfaces.IInterfacedObject in '..\src\Deltics.InterfacedObjects.Interfaces.IInterfacedObject.pas',
  Deltics.InterfacedObjects.Interfaces.IInterfacedObjectList in '..\src\Deltics.InterfacedObjects.Interfaces.IInterfacedObjectList.pas';

begin
  TestRun.Test(TInterfacedObjectTests);
  TestRun.Test(TComInterfacedObjectTests);
  TestRun.Test(TInterfaceReferenceTests);
  TestRun.Test(TWeakInterfaceReferenceTests);
  TestRun.Test(TInterfacedObjectListTests);
end.
