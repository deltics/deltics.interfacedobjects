
{$i deltics.interfaces.inc}

  unit Deltics.Interfaces.WeakInterfaceReference;


interface

  type
    TWeakInterfaceReference = class(TObject, IUnknown)
    private
      fRef: Pointer;
      function get_Ref: IUnknown;
    protected // IUnknown
      {
        IUnknown is delegated to the contained reference using "implements"
         ALL methods of IUnknown are delegated to the fRef, meaning that
         TWeakInterface does not need to worry about being reference counted
         itself (it won't be).
      }
      property Ref: IUnknown read get_Ref implements IUnknown;
    public
      constructor Create(const aRef: IUnknown);
      procedure Update(const aRef: IUnknown);
    end;



implementation


{ TWeakInterfaceRef ------------------------------------------------------------------------------ }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TWeakInterfaceReference.Create(const aRef: IInterface);
  begin
    inherited Create;

    fRef := Pointer(aRef);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TWeakInterfaceReference.get_Ref: IUnknown;
  begin
    result := IUnknown(fRef);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TWeakInterfaceReference.Update(const aRef: IInterface);
  begin
    fRef := Pointer(aRef);
  end;









end.
