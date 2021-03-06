
{$i deltics.inc}

unit Test.ComInterfacedObject;

interface

  uses
    Deltics.Smoketest;


  type
    TComInterfacedObjectTests = class(TTest)
    private
      fOnDestroyCallCount: Integer;
      procedure OnDestroyCallCounter(aSender: TObject);
    published
      procedure SetupMethod;
      procedure ComInterfacedObjectLifetimeIsReferenceCounted;
      procedure ComInterfacedObjectWithoutReferencesCanBeFreed;
      procedure ComInterfacedObjectFreedAfterReferencesUsedRaisesEInvalidPointer;
    end;


implementation

  uses
    SysUtils,
    Deltics.InterfacedObjects,
    Deltics.Multicast;


{ TInterfacedObjectTests }

  procedure TComInterfacedObjectTests.OnDestroyCallCounter(aSender: TObject);
  begin
    Inc(fOnDestroyCallCount);
  end;


  procedure TComInterfacedObjectTests.SetupMethod;
  begin
    fOnDestroyCallCount := 0;
  end;


  procedure TComInterfacedObjectTests.ComInterfacedObjectWithoutReferencesCanBeFreed;
  var
    sut: TComInterfacedObject;
    iod: IOn_Destroy;
  begin
    sut := TComInterfacedObject.Create;
    try
      iod := sut as IOn_Destroy;
      iod.Add(OnDestroyCallCounter);
      iod := NIL;

      Test('TComInterfaceObject.On_Destroy calls').Assert(fOnDestroyCallCount).Equals(0);

    finally
      sut.Free;

      Test('TComInterfaceObject.On_Destroy calls').Assert(fOnDestroyCallCount).Equals(1);
    end;
  end;


  procedure TComInterfacedObjectTests.ComInterfacedObjectFreedAfterReferencesUsedRaisesEInvalidPointer;
  var
    sut: TComInterfacedObject;
    intf: IUnknown;
    iod: IOn_Destroy;
  begin
    Test.Raises(EInvalidPointer);

    sut := TComInterfacedObject.Create;

    iod := sut as IOn_Destroy;
    iod.Add(OnDestroyCallCounter);
    iod := NIL;

    Test('TComInterfaceObject.On_Destroy calls').Assert(fOnDestroyCallCount).Equals(0);

    intf  := sut;
    intf  := NIL;

    Test('TComInterfaceObject.On_Destroy calls').Assert(fOnDestroyCallCount).Equals(1);

    sut.Free;
  end;


  procedure TComInterfacedObjectTests.ComInterfacedObjectLifetimeIsReferenceCounted;
  var
    sut: TComInterfacedObject;
    intf: IUnknown;
    iod: IOn_Destroy;
  begin
    sut := TComInterfacedObject.Create;

    iod := sut as IOn_Destroy;
    iod.Add(OnDestroyCallCounter);
    iod := NIL;

    intf  := sut;
    intf  := NIL;

    Test('TComInterfaceObject.On_Destroy calls').Assert(fOnDestroyCallCount).Equals(1);
  end;





end.

