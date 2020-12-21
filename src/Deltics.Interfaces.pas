
{$i deltics.interfaces.inc}

  unit Deltics.Interfaces;


interface

  uses
    Deltics.Interfaces.IReferenceCount,
    Deltics.Interfaces.ComInterfacedObject,
    Deltics.Interfaces.ComInterfacedPersistent,
    Deltics.Interfaces.FlexInterfacedObject,
    Deltics.Interfaces.InterfacedObject,
    Deltics.Interfaces.InterfacedPersistent,
    Deltics.Interfaces.InterfaceReference,
    Deltics.Interfaces.WeakInterfaceReference;

  type
    IReferenceCount           = Deltics.Interfaces.IReferenceCount.IReferenceCount;

    TComInterfacedObject      = Deltics.Interfaces.ComInterfacedObject.TComInterfacedObject;
    TComInterfacedPersistent  = Deltics.Interfaces.ComInterfacedPersistent.TComInterfacedPersistent;
    TFlexInterfacedObject     = Deltics.Interfaces.FlexInterfacedObject.TFlexInterfacedObject;
    TInterfacedObject         = Deltics.Interfaces.InterfacedObject.TInterfacedObject;
    TInterfacedPersistent     = Deltics.Interfaces.InterfacedPersistent.TInterfacedPersistent;

    TInterfaceReference       = Deltics.Interfaces.InterfaceReference.TInterfaceReference;
    TWeakInterfaceReference   = Deltics.Interfaces.WeakInterfaceReference.TWeakInterfaceReference;


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
