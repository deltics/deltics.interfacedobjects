
{$i deltics.interfacedobjects.inc}

  unit Deltics.InterfacedObjects;


interface

  uses
    Deltics.InterfacedObjects.IReferenceCount,
    Deltics.InterfacedObjects.ComInterfacedObject,
    Deltics.InterfacedObjects.ComInterfacedPersistent,
    Deltics.InterfacedObjects.FlexInterfacedObject,
    Deltics.InterfacedObjects.InterfacedObject,
    Deltics.InterfacedObjects.InterfacedPersistent,
    Deltics.InterfacedObjects.InterfaceReference,
    Deltics.InterfacedObjects.WeakInterfaceReference;

  type
    IReferenceCount           = Deltics.InterfacedObjects.IReferenceCount.IReferenceCount;

    TComInterfacedObject      = Deltics.InterfacedObjects.ComInterfacedObject.TComInterfacedObject;
    TComInterfacedPersistent  = Deltics.InterfacedObjects.ComInterfacedPersistent.TComInterfacedPersistent;
    TFlexInterfacedObject     = Deltics.InterfacedObjects.FlexInterfacedObject.TFlexInterfacedObject;
    TInterfacedObject         = Deltics.InterfacedObjects.InterfacedObject.TInterfacedObject;
    TInterfacedPersistent     = Deltics.InterfacedObjects.InterfacedPersistent.TInterfacedPersistent;

    TInterfaceReference       = Deltics.InterfacedObjects.InterfaceReference.TInterfaceReference;
    TWeakInterfaceReference   = Deltics.InterfacedObjects.WeakInterfaceReference.TWeakInterfaceReference;


    function GetReferenceCount(const aInterface: IInterface): Integer;

implementation

  uses
    SysUtils;


  function GetReferenceCount(const aInterface: IInterface): Integer;
  var
    rc: IReferenceCount;
  begin
    if Supports(aInterface, IReferenceCount, rc) then
      result := rc.ReferenceCount
    else
    begin
      aInterface._AddRef;
      result := aInterface._Release;
    end;
  end;

end.
