
{$i deltics.interfaces.inc}

  unit Deltics.Interfaces;


interface

  uses
    Deltics.Interfaces.ComInterfacedObject,
    Deltics.Interfaces.ComInterfacedPersistent,
    Deltics.Interfaces.FlexInterfacedObject,
    Deltics.Interfaces.InterfacedObject,
    Deltics.Interfaces.InterfacedPersistent,
    Deltics.Interfaces.InterfaceRef,
    Deltics.Interfaces.WeakInterfaceRef;

  type
    TComInterfacedObject      = Deltics.Interfaces.ComInterfacedObject.TComInterfacedObject;
    TComInterfacedPersistent  = Deltics.Interfaces.ComInterfacedPersistent.TComInterfacedPersistent;
    TFlexInterfacedObject     = Deltics.Interfaces.FlexInterfacedObject.TFlexInterfacedObject;
    TInterfacedObject         = Deltics.Interfaces.InterfacedObject.TInterfacedObject;
    TInterfacedPersistent     = Deltics.Interfaces.InterfacedPersistent.TInterfacedPersistent;

    TInterfaceRef             = Deltics.Interfaces.InterfaceRef.TInterfaceRef;
    TWeakInterfaceRef         = Deltics.Interfaces.WeakInterfaceRef.TWeakInterfaceRef;


implementation

end.
