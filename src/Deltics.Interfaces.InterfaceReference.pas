
{$i deltics.interfaces.inc}

  unit Deltics.Interfaces.InterfaceReference;


interface

  type
    TInterfaceReference = class(TObject, IUnknown)
    private
      fRef: IUnknown;
    public
      constructor Create(const aRef: IUnknown);
      function IsReferenceTo(const aOther: IUnknown): Boolean;

    // IUnknown
    protected
      {
        IUnknown is delegated to the contained reference using "implements"
         ALL methods of IUnknown are delegated to the fRef, meaning that
         TInterface does not need to worry about being reference counted
         itself (it won't be).
      }
      property Ref: IUnknown read fRef implements IUnknown;
    end;




implementation


{ TInterfaceRef ---------------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TInterfaceReference.Create(const aRef: IInterface);
  begin
    inherited Create;

    fRef := aRef as IUnknown;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfaceReference.IsReferenceTo(const aOther: IInterface): Boolean;
  begin
    result := (aOther as IUnknown) = fRef
  end;









end.
