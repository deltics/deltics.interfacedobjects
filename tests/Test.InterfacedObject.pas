

unit Test.InterfacedObject;

interface

  uses
    Deltics.Smoketest;


  type
    TInterfacedObjectTests = class(TTest)
    private
      fOnDestroyCallCount: Integer;
      procedure OnDestroyCallCounter(aSender: TObject);
    published
      procedure SetupMethod;
      procedure InterfacedObjectLifetimeIsNotReferenceCounted;
      procedure InterfacedObjectLifetimeIsExplicit;
    end;


implementation

  uses
    Deltics.Interfaces,
    Deltics.Multicast;


{ TInterfacedObjectTests }

  procedure TInterfacedObjectTests.OnDestroyCallCounter(aSender: TObject);
  begin
    Inc(fOnDestroyCallCount);
  end;


  procedure TInterfacedObjectTests.SetupMethod;
  begin
    fOnDestroyCallCount := 0;
  end;


  procedure TInterfacedObjectTests.InterfacedObjectLifetimeIsExplicit;
  var
    sut: TInterfacedObject;
    intf: IUnknown;
    iod: IOn_Destroy;
  begin
    sut := TInterfacedObject.Create;
    try
      iod := sut.On_Destroy;
      iod.Add(OnDestroyCallCounter);
      iod := NIL;

      intf  := sut;
      intf  := NIL;

    finally
      sut.Free;

      Test('TInterfaceObject.On_Destroy calls').Assert(fOnDestroyCallCount).Equals(1);
    end;
  end;


  procedure TInterfacedObjectTests.InterfacedObjectLifetimeIsNotReferenceCounted;
  var
    sut: TInterfacedObject;
    intf: IUnknown;
    iod: IOn_Destroy;
  begin
    sut := TInterfacedObject.Create;
    try
      iod := sut.On_Destroy;
      iod.Add(OnDestroyCallCounter);
      iod := NIL;

      intf  := sut;
      intf  := NIL;

      Test('TInterfaceObject.On_Destroy calls').Assert(fOnDestroyCallCount).Equals(0);

    finally
      sut.Free;
    end;
  end;





end.
