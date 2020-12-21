
{$i deltics.interfaces.inc}

  unit Deltics.Interfaces.ComInterfacedObject;


interface

  uses
    Deltics.Interfaces.IReferenceCount,
    Deltics.Multicast;


  type
    TComInterfacedObject = class(TObject, IUnknown,
                                          IReferenceCount,
                                          IOn_Destroy)
    private
      fDestroying: Boolean;
      fReferenceCount: Integer;
    private // IOn_Destroy
      fOn_Destroy: IOn_Destroy;
      function get_On_Destroy: IOn_Destroy;
    private // IUnknown
      function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
      function _AddRef: Integer; stdcall;
      function _Release: Integer; stdcall;
    private // IReferenceCount
      function get_ReferenceCount: Integer;

    public
      class function NewInstance: TObject; override;
      procedure AfterConstruction; override;
      procedure BeforeDestruction; override;
      property ReferenceCount: Integer read fReferenceCount;
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
      result := InterlockedIncrement(fReferenceCount)
    else
      result := 1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedObject._Release: Integer;
  begin
    if NOT (fDestroying) then
    begin
      result := InterlockedDecrement(fReferenceCount);
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
    InterlockedDecrement(fReferenceCount);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TComInterfacedObject.BeforeDestruction;
  begin
    if (fReferenceCount <> 0) then
      System.Error(reInvalidPtr);

    fDestroying := TRUE;
    inherited;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedObject.get_On_Destroy: IOn_Destroy;
  begin
    // We must NOT create an On_Destroy event if we are being destroyed
    //  otherwise it will be orphaned (i.e. leaked)

    if NOT fDestroying and NOT Assigned(fOn_Destroy) then
      fOn_Destroy := TOnDestroy.Create(self);

    result := fOn_Destroy;
  end;


  function TComInterfacedObject.get_ReferenceCount: Integer;
  begin
    result := fReferenceCount;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TComInterfacedObject.NewInstance: TObject;
  begin
    result := inherited NewInstance;
    InterlockedIncrement(TComInterfacedObject(result).fReferenceCount);
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
