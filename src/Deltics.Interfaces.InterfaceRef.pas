
{$i deltics.interfaces.inc}

  unit Deltics.Interfaces.InterfaceRef;


interface

  type
    TInterfaceRef = class(TObject, IUnknown)
    private
      fRef: IUnknown;
    protected // IUnknown
      {
        IUnknown is delegated to the contained reference using "implements"
         ALL methods of IUnknown are delegated to the fRef, meaning that
         TInterface does not need to worry about being reference counted
         itself (it won't be).
      }
      property Ref: IUnknown read fRef implements IUnknown;
    public
      constructor Create(const aRef: IUnknown);
      function IsEqual(const aOther: IUnknown): Boolean;
    end;




implementation


{ TInterfaceRef ---------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TInterfaceRef.Create(const aRef: IInterface);
  begin
    inherited Create;

    fRef := aRef as IUnknown;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfaceRef.IsEqual(const aOther: IInterface): Boolean;
  begin
    if Assigned(self) then
      result := (aOther as IUnknown) = fRef
    else
      result := (aOther = NIL);
  end;









end.
