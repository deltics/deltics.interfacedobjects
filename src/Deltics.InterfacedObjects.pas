
{$i deltics.interfacedobjects.inc}

  unit Deltics.InterfacedObjects;


interface

  uses
    Classes,
    Deltics.InterfacedObjects.ObjectLifecycle,
    Deltics.InterfacedObjects.Interfaces.IInterfacedObject,
    Deltics.InterfacedObjects.Interfaces.IInterfacedObjectList,
    Deltics.InterfacedObjects.ComInterfacedObject,
    Deltics.InterfacedObjects.ComInterfacedPersistent,
    Deltics.InterfacedObjects.InterfacedObject,
    Deltics.InterfacedObjects.InterfacedObjectList,
    Deltics.InterfacedObjects.InterfacedPersistent,
    Deltics.InterfacedObjects.InterfaceReference,
    Deltics.InterfacedObjects.WeakInterfaceReference;

  type
    IInterfaceList = Classes.IInterfaceList;
    TInterfaceList = Classes.TInterfaceList;

    IInterfacedObject         = Deltics.InterfacedObjects.Interfaces.IInterfacedObject.IInterfacedObject;
    IInterfacedObjectList     = Deltics.InterfacedObjects.Interfaces.IInterfacedObjectList.IInterfacedObjectList;

    TComInterfacedObject      = Deltics.InterfacedObjects.ComInterfacedObject.TComInterfacedObject;
    TComInterfacedPersistent  = Deltics.InterfacedObjects.ComInterfacedPersistent.TComInterfacedPersistent;
    TInterfacedObject         = Deltics.InterfacedObjects.InterfacedObject.TInterfacedObject;
    TInterfacedPersistent     = Deltics.InterfacedObjects.InterfacedPersistent.TInterfacedPersistent;

    TInterfaceReference       = Deltics.InterfacedObjects.InterfaceReference.TInterfaceReference;
    TWeakInterfaceReference   = Deltics.InterfacedObjects.WeakInterfaceReference.TWeakInterfaceReference;

    TInterfacedObjectList     = Deltics.InterfacedObjects.InterfacedObjectList.TInterfacedObjectList;

  type
    TObjectLifecycle = Deltics.InterfacedObjects.ObjectLifecycle.TObjectLifecycle;

  const
    olExplicit          = Deltics.InterfacedObjects.ObjectLifecycle.olExplicit;
    olReferenceCounted  = Deltics.InterfacedObjects.ObjectLifecycle.olReferenceCounted;


  function GetReferenceCount(const aInterface: IInterface): Integer;



implementation

  uses
    SysUtils;


  function GetReferenceCount(const aInterface: IInterface): Integer;
  var
    io: IInterfacedObject;
  begin
    if Supports(aInterface, IInterfacedObject, io) then
      result := io.ReferenceCount
    else
    begin
      aInterface._AddRef;
      result := aInterface._Release;
    end;
  end;



end.
