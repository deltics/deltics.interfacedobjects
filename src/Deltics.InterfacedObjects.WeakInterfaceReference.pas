
{$i deltics.interfacedobjects.inc}

  unit Deltics.InterfacedObjects.WeakInterfaceReference;


interface

  uses
    Deltics.Multicast;


  type
    TWeakInterfaceReference = class(TObject, IUnknown,
                                             IOn_Destroy)
    private
      fRef: Pointer;
      fOnDestroy: IOn_Destroy;
      function get_Ref: IUnknown;
      procedure OnTargetDestroyed(aSender: TObject);
    public
      constructor Create(const aRef: IUnknown);
      destructor Destroy; override;
      procedure UpdateReference(const aRef: IUnknown);
      function IsReferenceTo(const aOther: IUnknown): Boolean;

    // IUnknown
    protected
      {
        IUnknown is delegated to the contained reference using "implements"
         ALL methods of IUnknown are delegated to the fRef, meaning that
         TWeakInterface does not need to worry about being reference counted
         itself (it won't be).
      }
      property Ref: IUnknown read get_Ref implements IUnknown;

    // IOn_Destroy
    protected
      function get_OnDestroy: IOn_Destroy;
      property On_Destroy: IOn_Destroy read get_OnDestroy implements IOn_Destroy;
    end;



implementation

  uses
    SysUtils;



{ TWeakInterfaceRef ------------------------------------------------------------------------------ }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TWeakInterfaceReference.Create(const aRef: IInterface);
  begin
    inherited Create;

    UpdateReference(aRef);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  destructor TWeakInterfaceReference.Destroy;
  begin
    UpdateReference(NIL);

    inherited;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TWeakInterfaceReference.get_OnDestroy: IOn_Destroy;
  begin
    if NOT Assigned(fOnDestroy) then
      fOnDestroy := TOnDestroy.Create(self);

    result := fOnDestroy;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TWeakInterfaceReference.get_Ref: IUnknown;
  begin
    result := IUnknown(fRef);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TWeakInterfaceReference.OnTargetDestroyed(aSender: TObject);
  begin
    UpdateReference(NIL);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TWeakInterfaceReference.UpdateReference(const aRef: IInterface);
  var
    onDestroy: IOn_Destroy;
  begin
    if Supports(IUnknown(fRef), IOn_Destroy, onDestroy) then
      onDestroy.Remove(OnTargetDestroyed);

    fRef := Pointer(aRef as IUnknown);

    if Supports(aRef, IOn_Destroy, onDestroy) then
      onDestroy.Add(OnTargetDestroyed);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TWeakInterfaceReference.IsReferenceTo(const aOther: IInterface): Boolean;
  begin
    if Assigned(self) and Assigned(fRef) then
      result := Pointer(aOther as IUnknown) = fRef
    else
      result := (aOther = NIL);
  end;




end.
