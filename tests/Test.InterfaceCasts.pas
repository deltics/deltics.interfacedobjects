
{$i deltics.inc}

unit Test.InterfaceCasts;


interface

  uses
    Deltics.Smoketest;


  type
    TInterfaceCastTests = class(TTest)
      procedure ReturnsFALSEWhenInvalidImplementationClassRequested;
      procedure ReturnsFALSEWhenInvalidInterfaceRequested;
      procedure ReturnsValidImplementationClassWhenRequested;
      procedure ReturnsValidInterfaceWhenRequested;
    end;



implementation

  uses
    Deltics.InterfacedObjects;



  type
    IFoo = interface ['{4214B99C-CF8B-4311-833A-81C902E0A0C2}'] end;


{ InterfaceCasts }

  procedure TInterfaceCastTests.ReturnsFALSEWhenInvalidImplementationClassRequested;
  var
    io: IUnknown;
    ref: TObject;
    returns: Boolean;
  begin
    io := TComInterfacedObject.Create;

    returns := InterfaceCast(io, TTest, ref);

    Test('InterfaceCast returns').Assert(returns).IsFalse;
    Test('InterfaceCast').Assert(ref).IsNIL;
  end;



  procedure TInterfaceCastTests.ReturnsFALSEWhenInvalidInterfaceRequested;
  var
    io: IUnknown;
    ref: TObject;
    returns: Boolean;
  begin
    io := TComInterfacedObject.Create;

    returns := InterfaceCast(io, IFoo, ref);

    Test('InterfaceCast returns').Assert(returns).IsFalse;
    Test('InterfaceCast').Assert(ref).IsNIL;
  end;


  procedure TInterfaceCastTests.ReturnsValidImplementationClassWhenRequested;
  var
    io: IUnknown;
    ref: TObject;
    returns: Boolean;
  begin
    io := TComInterfacedObject.Create;

    returns := InterfaceCast(io, TComInterfacedObject, ref);

    Test('InterfaceCast returns').Assert(returns).IsTrue;
    Test('InterfaceCast').Assert(ref.ClassType = TComInterfacedObject);
  end;



  procedure TInterfaceCastTests.ReturnsValidInterfaceWhenRequested;
  var
    io: IUnknown;
    ref: IInterfacedObject;
    returns: Boolean;
  begin
    io := TComInterfacedObject.Create;

    returns := InterfaceCast(io, IInterfacedObject, ref);

    Test('InterfaceCast returns').Assert(returns).IsTrue;
    Test('InterfaceCast').Assert(ref).IsAssigned;
  end;




end.
