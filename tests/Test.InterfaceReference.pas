
{$i deltics.inc}

  unit Test.InterfaceReference;


interface

  uses
    Deltics.Smoketest;


  type
    TInterfaceReferenceTests = class(TTest)
    private
      fOnDestroyCallCount: Integer;
      procedure OnDestroyCallCounter(aSender: TObject);
    published
      procedure SetupMethod;
      procedure InterfaceReferenceMaintainsStrongReference;
      procedure IsReferenceToIsTRUEWhenReferenceIsTheSameAndNotNIL;
      procedure IsReferenceToIsTRUEWhenReferencesAreNIL;
      procedure IsReferenceToIsFALSEWhenOneIsNIL;
      procedure IsReferenceToIsFALSEWhenReferencesAreDifferent;
    end;


implementation

  uses
    Deltics.Interfaces,
    Deltics.Multicast;


{ TInterfacedObjectTests }

  procedure TInterfaceReferenceTests.OnDestroyCallCounter(aSender: TObject);
  begin
    Inc(fOnDestroyCallCount);
  end;


  procedure TInterfaceReferenceTests.SetupMethod;
  begin
    fOnDestroyCallCount := 0;
  end;


  procedure TInterfaceReferenceTests.InterfaceReferenceMaintainsStrongReference;
  var
    foo: IUnknown;
    sut: TInterfaceReference;
    iod: IOn_Destroy;
  begin
    foo := TComInterfacedObject.Create;

    iod := foo as IOn_Destroy;
    iod.Add(OnDestroyCallCounter);
    iod := NIL;

    sut := TInterfaceReference.Create(foo);
    try
      // NIL'ing foo leaves the TInterfaceReference as the only reference
      //  to foo (it should not have been destroyed)
      foo := NIL;

      Test('OnDestroyCallCount').Assert(fOnDestroyCallCount).Equals(0);

    finally
      // Freeing the interface reference removes the last reference to
      //  foo - it should have been destroyed

      sut.Free;

      Test('OnDestroyCallCount').Assert(fOnDestroyCallCount).Equals(1);
    end;
  end;


  procedure TInterfaceReferenceTests.IsReferenceToIsFALSEWhenReferencesAreDifferent;
  var
    a, b: IUnknown;
    sut: TInterfaceReference;
  begin
    a := TComInterfacedObject.Create;
    b := TComInterfacedObject.Create;

    sut := TInterfaceReference.Create(a);
    try
      Test('IsReferenceTo').Assert(NOT sut.IsReferenceTo(b));

    finally
      sut.Free;
    end;
  end;


  procedure TInterfaceReferenceTests.IsReferenceToIsFALSEWhenOneIsNIL;
  var
    a, b: IUnknown;
    sut: TInterfaceReference;
  begin
    a := TComInterfacedObject.Create;
    b := NIL;

    sut := TInterfaceReference.Create(a);
    try
      Test('IsReferenceTo(NIL)').Assert(NOT sut.IsReferenceTo(b));

    finally
      sut.Free;
    end;

    sut := TInterfaceReference.Create(b);
    try
      Test('IsReferenceTo(<intf>)').Assert(NOT sut.IsReferenceTo(a));

    finally
      sut.Free;
    end;
  end;


  procedure TInterfaceReferenceTests.IsReferenceToIsTRUEWhenReferenceIsTheSameAndNotNIL;
  var
    a, b: IUnknown;
    sut: TInterfaceReference;
  begin
    a := TComInterfacedObject.Create;
    b := a;

    sut := TInterfaceReference.Create(a);
    try
      Test('IsReferenceTo').Assert(sut.IsReferenceTo(b));

    finally
      sut.Free;
    end;
  end;


  procedure TInterfaceReferenceTests.IsReferenceToIsTRUEWhenReferencesAreNIL;
  var
    sut: TInterfaceReference;
  begin
    sut := TInterfaceReference.Create(NIL);
    try
      Test('IsReferenceTo').Assert(sut.IsReferenceTo(NIL));

    finally
      sut.Free;
    end;
  end;





end.
