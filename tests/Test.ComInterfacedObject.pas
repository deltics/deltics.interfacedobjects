

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
      procedure InterfacedObjectLifetimeIsExplicit;
    end;


implementation

  uses
    SysUtils,
    Deltics.Interfaces,
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


  procedure TComInterfacedObjectTests.InterfacedObjectLifetimeIsExplicit;
  var
    sut: TComInterfacedObject;
    intf: IUnknown;
    iod: IOn_Destroy;
  begin
    Test.RaisesException(EInvalidPointer);

    sut := TComInterfacedObject.Create;
    try
      iod := sut.On_Destroy;
      iod.Add(OnDestroyCallCounter);
      iod := NIL;

      intf  := sut;
      intf  := NIL;

    finally
      Test('TComInterfaceObject.On_Destroy calls').Assert(fOnDestroyCallCount).Equals(1);
      sut.Free;
    end;
  end;


  procedure TComInterfacedObjectTests.ComInterfacedObjectLifetimeIsReferenceCounted;
  var
    sut: TComInterfacedObject;
    intf: IUnknown;
    iod: IOn_Destroy;
  begin
    sut := TComInterfacedObject.Create;

    iod := sut.On_Destroy;
    iod.Add(OnDestroyCallCounter);
    iod := NIL;

    intf  := sut;
    intf  := NIL;

    Test('TComInterfaceObject.On_Destroy calls').Assert(fOnDestroyCallCount).Equals(1);
  end;





end.
