

unit Test.FlexInterfacedObject;

interface

  uses
    Deltics.Smoketest;


  type
    TFlexInterfacedObjectTests = class(TTest)
    private
      fOnDestroyCallCount: Integer;
      procedure OnDestroyCallCounter(aSender: TObject);
    published
      procedure SetupMethod;
      procedure FlexInterfacedObjectRefCountIsEnabledByDefault;
      procedure FlexInterfacedObjectRaisesInvalidPtrExceptionIfFreedWhenRefCountIsEnabled;
      procedure FlexInterfacedObjectLifetimeIsNotReferenceCountedWhenRefCountIsDisabled;
      procedure FlexInterfacedObjectLifetimeIsReferenceCountedWhenRefCountIsEnabled;
    end;


implementation

  uses
    SysUtils,
    Deltics.Interfaces,
    Deltics.Multicast;


{ TFlexInterfacedObjectTests }

  procedure TFlexInterfacedObjectTests.OnDestroyCallCounter(aSender: TObject);
  begin
    Inc(fOnDestroyCallCount);
  end;


  procedure TFlexInterfacedObjectTests.SetupMethod;
  begin
    fOnDestroyCallCount := 0;
  end;


  procedure TFlexInterfacedObjectTests.FlexInterfacedObjectRaisesInvalidPtrExceptionIfFreedWhenRefCountIsEnabled;
  var
    sut: TFlexInterfacedObject;
    intf: IUnknown;
  begin
    Test.RaisesException(EInvalidPointer);

    sut   := TFlexInterfacedObject.Create;
    intf  := sut;

    sut.Free;
  end;


  procedure TFlexInterfacedObjectTests.FlexInterfacedObjectRefCountIsEnabledByDefault;
  var
    sut: TFlexInterfacedObject;
  begin
    sut := TFlexInterfacedObject.Create;

    Test('RefCountDisabled').Assert(NOT sut.ReferenceCountDisabled);

    sut.Free;
  end;


  procedure TFlexInterfacedObjectTests.FlexInterfacedObjectLifetimeIsNotReferenceCountedWhenRefCountIsDisabled;
  var
    sut: TFlexInterfacedObject;
    intf: IUnknown;
    iod: IOn_Destroy;
  begin
    sut := TFlexInterfacedObject.Create;
    try
      iod := sut.On_Destroy;
      iod.Add(OnDestroyCallCounter);
      iod := NIL;

      sut.DisableReferenceCount;

      intf  := sut;
      intf  := NIL;

    finally
      sut.Free;

      Test('TFlexInterfacedObject.On_Destroy calls').Assert(fOnDestroyCallCount).Equals(1);
    end;
  end;


  procedure TFlexInterfacedObjectTests.FlexInterfacedObjectLifetimeIsReferenceCountedWhenRefCountIsEnabled;
  var
    sut: TFlexInterfacedObject;
    intf: IUnknown;
    iod: IOn_Destroy;
  begin
    sut := TFlexInterfacedObject.Create;
    try
      iod := sut.On_Destroy;
      iod.Add(OnDestroyCallCounter);
      iod := NIL;

      intf  := sut;
      intf  := NIL;

    finally
      Test('TFlexInterfacedObject.On_Destroy calls').Assert(fOnDestroyCallCount).Equals(1);
    end;
  end;






end.
