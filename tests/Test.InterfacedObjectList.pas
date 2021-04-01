
{$i deltics.inc}

  unit Test.InterfacedObjectList;


interface

  uses
    Deltics.Smoketest;


  type
    TInterfacedObjectListTests = class(TTest)
      procedure InterfacedObjectAddedToListIsRemovedWhenDestroyed;
      procedure AddingItemsViaObjectReferenceIsAnInvalidOperation;
      procedure AddingItemsViaInterfaceReferenceIsSuccessful;
      procedure ItemsCanBeInsertedAtASpecificIndex;
      procedure ItemsCannotBeAddedMoreThanOnce;
      procedure ClearedListHasNoItems;
    end;


implementation

  uses
    Deltics.Exceptions,
    Deltics.InterfacedObjects;



  type
    TInterfacedObjectListSubClassExposingAddMethod = class(TInterfacedObjectList);



{ TTestInterfacedObjectList }

  procedure TInterfacedObjectListTests.AddingItemsViaInterfaceReferenceIsSuccessful;
  var
    sut: IInterfacedObjectList;
    io: TInterfacedObject;
  begin
    sut := TInterfacedObjectList.Create;

    io := TInterfacedObject.Create;
    try
      sut.Add(io);

      Test('Count').Assert(sut.Count).Equals(1);

    finally
      io.Free;
    end;
  end;


  procedure TInterfacedObjectListTests.AddingItemsViaObjectReferenceIsAnInvalidOperation;
  var
    sut: TInterfacedObjectListSubClassExposingAddMethod;
    io: TInterfacedObject;
  begin
    Test.RaisesException(EInvalidOperation);

    sut := TInterfacedObjectListSubClassExposingAddMethod.Create;
    try
      io := TInterfacedObject.Create;
      try
        sut.Add(io);

      finally
        io.Free;
      end;

    finally
      // Call the TObject.Free implementation on SUT (to bypass the reintroduced Free
      //  which raises an exception when trying to Free a COM interfaced object) otherwise
      //  the test will leak SUT.

      TObject(sut).Free;
    end;
  end;


  procedure TInterfacedObjectListTests.InterfacedObjectAddedToListIsRemovedWhenDestroyed;
  var
    sut: IInterfacedObjectList;
    io: TInterfacedObject;
  begin
    sut := TInterfacedObjectList.Create;
    io := TInterfacedObject.Create;

    Test('Count').Assert(sut.Count).Equals(0);

    sut.Add(io);

    Test('Count').Assert(sut.Count).Equals(1);

    io.Free;

    Test('Count').Assert(sut.Count).Equals(0);
  end;


  procedure TInterfacedObjectListTests.ItemsCanBeInsertedAtASpecificIndex;
  var
    sut: IInterfacedObjectList;
    io1, io2, io3: TInterfacedObject;
  begin
    sut := TInterfacedObjectList.Create;
    io1 := TInterfacedObject.Create;
    io2 := TInterfacedObject.Create;
    io3 := TInterfacedObject.Create;

    Test('Count').Assert(sut.Count).Equals(0);

    sut.Add(io1);
    sut.Add(io2);
    sut.Insert(1, io3);

    Test('Count').Assert(sut.Count).Equals(3);
    Test('Index (1st object)').Assert(sut.IndexOf(io1)).Equals(0);
    Test('Index (2nd object)').Assert(sut.IndexOf(io2)).Equals(2);
    Test('Index (3rd object)').Assert(sut.IndexOf(io3)).Equals(1);
  end;


  procedure TInterfacedObjectListTests.ItemsCannotBeAddedMoreThanOnce;
  var
    sut: IInterfacedObjectList;
    io1, io2, io3: TInterfacedObject;
    idx: Integer;
  begin
    sut := TInterfacedObjectList.Create;
    io1 := TInterfacedObject.Create;
    io2 := TInterfacedObject.Create;
    io3 := TInterfacedObject.Create;

    Test('Count').Assert(sut.Count).Equals(0);

    sut.Add(io1);
    sut.Add(io2);
    sut.Add(io3);
    idx := sut.IndexOf(io2);

    Test('Count').Assert(sut.Count).Equals(3);
    Test('Index (2nd object)').Assert(idx).Equals(1);

    idx := sut.Add(io2);

    Test('Count').Assert(sut.Count).Equals(3);
    Test('Index (2nd object)').Assert(idx).Equals(1);
  end;


  procedure TInterfacedObjectListTests.ClearedListHasNoItems;
  var
    sut: IInterfacedObjectList;
    io1, io2, io3: TInterfacedObject;
  begin
    sut := TInterfacedObjectList.Create;
    io1 := TInterfacedObject.Create;
    io2 := TInterfacedObject.Create;
    io3 := TInterfacedObject.Create;

    Test('Count').Assert(sut.Count).Equals(0);

    sut.Add(io1);
    sut.Add(io2);
    sut.Add(io3);

    Test('Count').Assert(sut.Count).Equals(3);

    sut.Clear;

    Test('Count').Assert(sut.Count).Equals(0);
  end;




end.
