
{$i deltics.interfaces.inc}

  unit Deltics.Interfaces.FlexInterfacedObject;


interface

  uses
    Deltics.Multicast;


  type
    TFlexInterfacedObject = class(TObject, IUnknown,
                                           IOn_Destroy)
      private
        fRefCount: Integer;
        fRefCountDisabled: Boolean;
      public
        procedure AfterConstruction; override;
        procedure BeforeDestruction; override;
        class function NewInstance: TObject; override;

      public
        procedure DisableRefCount;
        property RefCount: Integer read fRefCount;

      // IUnknown
      protected
        function QueryInterface(const aIID: TGUID; out aObj): HResult; stdcall;
        function _AddRef: Integer; stdcall;
        function _Release: Integer; stdcall;

      // IOn_Destroy
      private
        fOn_Destroy: IOn_Destroy;
        function get_On_Destroy: IOn_Destroy;
      public
        property On_Destroy: IOn_Destroy read get_On_Destroy implements IOn_Destroy;
    end;



implementation

  uses
    Windows;


{ TFlexInterfacedObject - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TFlexInterfacedObject.AfterConstruction;
  begin
    if fRefCountDisabled then
      EXIT;

    // Release the constructor's implicit refcount
    InterlockedDecrement(fRefCount);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TFlexInterfacedObject.BeforeDestruction;
  begin
    if NOT fRefCountDisabled and (fRefCount <> 0) then
      System.Error(reInvalidPtr);

    DisableRefCount;  // To avoid problems if we reference ourselves (or are
                      //  referenced by others) using an interface during
                      //  execution of the destructor chain
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TFlexInterfacedObject.DisableRefCount;
  begin
    fRefCountDisabled := TRUE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TFlexInterfacedObject.get_On_Destroy: IOn_Destroy;
  begin
    if NOT Assigned(fOn_Destroy) then
      fOn_Destroy := TOnDestroy.Create(self);

    result := fOn_Destroy;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TFlexInterfacedObject.NewInstance: TObject;
  begin
    result := inherited NewInstance;
    TFlexInterfacedObject(result).fRefCount := 1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TFlexInterfacedObject.QueryInterface(const aIID: TGUID; out aObj): HResult;
  begin
    if GetInterface(aIID, aObj) then
      result := 0
    else
      result := E_NOINTERFACE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TFlexInterfacedObject._AddRef: Integer;
  begin
    if fRefCountDisabled then
      result := 1
    else
      result := InterlockedIncrement(fRefCount);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TFlexInterfacedObject._Release: Integer;
  begin
    if fRefCountDisabled then
      result := 1
    else
    begin
      result := InterlockedDecrement(fRefCount);
      if (result = 0) then
        Destroy;
    end;
  end;


end.
