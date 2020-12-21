
{$i deltics.inc}

  unit Test.WeakInterfaceReference;


interface

  uses
    Deltics.Smoketest;


  type
    TWeakInterfaceReferenceTests = class(TTest)
    private
      fOnDestroyCallCount: Integer;
      procedure OnDestroyCallCounter(aSender: TObject);
    published
      procedure SetupMethod;
      procedure ReferencedObjectDestroyingDoesNotCrashIfWeakReferenceHasBeenDestroyed;
      procedure WeakInterfaceReferenceIsNILedWhenReferencedObjectIsDestroyed;
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

  procedure TWeakInterfaceReferenceTests.OnDestroyCallCounter(aSender: TObject);
  begin
    Inc(fOnDestroyCallCount);
  end;


  procedure TWeakInterfaceReferenceTests.SetupMethod;
  begin
    fOnDestroyCallCount := 0;
  end;




  procedure TWeakInterfaceReferenceTests.ReferencedObjectDestroyingDoesNotCrashIfWeakReferenceHasBeenDestroyed;
  var
    foo: IUnknown;
    sut: TWeakInterfaceReference;
    iod: IOn_Destroy;
  begin
    Test('OnDestroyCallCount').Assert(fOnDestroyCallCount).Equals(0);

    foo := TComInterfacedObject.Create;

    iod := foo as IOn_Destroy;
    iod.Add(OnDestroyCallCounter);
    iod := NIL;

    Test('OnDestroyCallCount').Assert(fOnDestroyCallCount).Equals(0);

    // Create and immediately Destroy a weak reference to foo
    sut := TWeakInterfaceReference.Create(foo);
    sut.Free;

    Test('OnDestroyCallCount').Assert(fOnDestroyCallCount).Equals(0);

    // NIL'ing the ref to foo will destroy foo which will notify any listeners
    //  via the On_Destroy
    foo := NIL;

    Test('OnDestroyCallCount').Assert(fOnDestroyCallCount).Equals(1);
  end;


  procedure TWeakInterfaceReferenceTests.WeakInterfaceReferenceIsNILedWhenReferencedObjectIsDestroyed;
  var
    foo: IUnknown;
    sut: TWeakInterfaceReference;
    iod: IOn_Destroy;
  begin
    foo := TComInterfacedObject.Create;

    iod := foo as IOn_Destroy;
    iod.Add(OnDestroyCallCounter);
    iod := NIL;

    Test('OnDestroyCallCount').Assert(fOnDestroyCallCount).Equals(0);

    sut := TWeakInterfaceReference.Create(foo);
    try
      // NIL'ing foo leaves the TWeakInterfaceReference as the only reference
      //  to foo (it should not have been destroyed)
      foo := NIL;

      Test('OnDestroyCallCount').Assert(fOnDestroyCallCount).Equals(1);
      Test('WeakReference').Assert(NOT Assigned(sut as IUnknown));

    finally
      sut.Free;
    end;
  end;


  procedure TWeakInterfaceReferenceTests.IsReferenceToIsFALSEWhenReferencesAreDifferent;
  var
    a, b: IUnknown;
    sut: TWeakInterfaceReference;
  begin
    a := TComInterfacedObject.Create;
    b := TComInterfacedObject.Create;

    sut := TWeakInterfaceReference.Create(a);
    try
      Test('IsReferenceTo').Assert(NOT sut.IsReferenceTo(b));

    finally
      sut.Free;
    end;
  end;


  procedure TWeakInterfaceReferenceTests.IsReferenceToIsFALSEWhenOneIsNIL;
  var
    a, b: IUnknown;
    sut: TWeakInterfaceReference;
  begin
    a := TComInterfacedObject.Create;
    b := NIL;

    sut := TWeakInterfaceReference.Create(a);
    try
      Test('IsReferenceTo(NIL)').Assert(NOT sut.IsReferenceTo(b));

    finally
      sut.Free;
    end;

    sut := TWeakInterfaceReference.Create(b);
    try
      Test('IsReferenceTo(<intf>)').Assert(NOT sut.IsReferenceTo(a));

    finally
      sut.Free;
    end;
  end;


  procedure TWeakInterfaceReferenceTests.IsReferenceToIsTRUEWhenReferenceIsTheSameAndNotNIL;
  var
    a, b: IUnknown;
    sut: TWeakInterfaceReference;
  begin
    a := TComInterfacedObject.Create;
    b := a;

    sut := TWeakInterfaceReference.Create(a);
    try
      Test('IsReferenceTo').Assert(sut.IsReferenceTo(b));

    finally
      sut.Free;
    end;
  end;


  procedure TWeakInterfaceReferenceTests.IsReferenceToIsTRUEWhenReferencesAreNIL;
  var
    sut: TWeakInterfaceReference;
  begin
    sut := TWeakInterfaceReference.Create(NIL);
    try
      Test('IsReferenceTo').Assert(sut.IsReferenceTo(NIL));

    finally
      sut.Free;
    end;
  end;





end.
