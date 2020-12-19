
{$i deltics.interfaces.inc}

  unit Deltics.Interfaces.ComInterfacedObject;


interface

  uses
    Deltics.Multicast;


  type
    TComInterfacedObject = class(TObject, IUnknown,
                                          IOn_Destroy)
      // IOn_Destroy
      private
        fDestroying: Boolean;
        fRefCount: Integer;
        fOn_Destroy: IOn_Destroy;
        function get_On_Destroy: IOn_Destroy;

      public // IUnknown
        function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
        function _AddRef: Integer; stdcall;
        function _Release: Integer; stdcall;

      public
        class function NewInstance: TObject; override;
        procedure AfterConstruction; override;
        procedure BeforeDestruction; override;
        property RefCount: Integer read fRefCount;
        property On_Destroy: IOn_Destroy read get_On_Destroy implements IOn_Destroy;
    end;




implementation

  uses
    Windows;


{ TComInterfacedObject --------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedObject._AddRef: Integer;
  begin
    if NOT (fDestroying) then
      result := InterlockedIncrement(fRefCount)
    else
      result := 1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedObject._Release: Integer;
  begin
    if NOT (fDestroying) then
    begin
      result := InterlockedDecrement(fRefCount);
      if (result = 0) then
        Destroy;
    end
    else
      result := 1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TComInterfacedObject.AfterConstruction;
  begin
    inherited;
    InterlockedDecrement(fRefCount);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TComInterfacedObject.BeforeDestruction;
  begin
    fDestroying := TRUE;
    inherited;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedObject.get_On_Destroy: IOn_Destroy;
  begin
    if NOT Assigned(fOn_Destroy) then
      fOn_Destroy := TOnDestroy.Create(self);

    result := fOn_Destroy;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TComInterfacedObject.NewInstance: TObject;
  begin
    result := inherited NewInstance;
    InterlockedIncrement(TComInterfacedObject(result).fRefCount);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedObject.QueryInterface(const IID: TGUID; out Obj): HResult;
  begin
    if GetInterface(IID, Obj) then
      result := 0
    else
      result := E_NOINTERFACE;
  end;









end.
