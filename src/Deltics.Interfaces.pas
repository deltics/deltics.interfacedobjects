
{$i deltics.interfaces.inc}

  unit Deltics.Interfaces;


interface

  uses
    Deltics.Interfaces.ComInterfacedObject,
    Deltics.Interfaces.ComInterfacedPersistent,
    Deltics.Interfaces.FlexInterfacedObject,
    Deltics.Interfaces.InterfacedObject,
    Deltics.Interfaces.InterfacedPersistent,
    Deltics.Interfaces.InterfaceReference,
    Deltics.Interfaces.WeakInterfaceReference;

  type
    TComInterfacedObject      = Deltics.Interfaces.ComInterfacedObject.TComInterfacedObject;
    TComInterfacedPersistent  = Deltics.Interfaces.ComInterfacedPersistent.TComInterfacedPersistent;
    TFlexInterfacedObject     = Deltics.Interfaces.FlexInterfacedObject.TFlexInterfacedObject;
    TInterfacedObject         = Deltics.Interfaces.InterfacedObject.TInterfacedObject;
    TInterfacedPersistent     = Deltics.Interfaces.InterfacedPersistent.TInterfacedPersistent;

    TInterfaceReference       = Deltics.Interfaces.InterfaceReference.TInterfaceReference;
    TWeakInterfaceReference   = Deltics.Interfaces.WeakInterfaceReference.TWeakInterfaceReference;


implementation

end.
