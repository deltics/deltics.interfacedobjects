
{$i deltics.interfaces.inc}

  unit Deltics.Interfaces.FlexInterfacedObject;


interface

  uses
    Deltics.Multicast;


  type
    TFlexInterfacedObject = class(TObject, IUnknown,
                                           IReferenceCount,
                                           IOn_Destroy)
      private
        fDestroying: Boolean;
        fReferenceCount: Integer;
        fReferenceCountDisabled: Boolean;
        fOn_Destroy: IOn_Destroy;
      public
        procedure AfterConstruction; override;
        procedure BeforeDestruction; override;
        class function NewInstance: TObject; override;
      public
        procedure DisableReferenceCount;
        property ReferenceCount: Integer read fReferenceCount;
        property ReferenceCountDisabled: Boolean read fReferenceCountDisabled;

      // IUnknown
      protected
        function QueryInterface(const aIID: TGUID; out aObj): HResult; stdcall;
        function _AddRef: Integer; stdcall;
        function _Release: Integer; stdcall;

      // IReferenceCount
      protected
        function get_ReferenceCount: Integer;

      // IOn_Destroy
      protected
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
    if fReferenceCountDisabled then
      EXIT;

    // Release the constructor's implicit refcount
    InterlockedDecrement(fReferenceCount);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TFlexInterfacedObject.BeforeDestruction;
  begin
    if NOT fReferenceCountDisabled and (fReferenceCount <> 0) then
      System.Error(reInvalidPtr);

    fDestroying             := TRUE;
    fReferenceCountDisabled := TRUE;

    inherited;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TFlexInterfacedObject.DisableReferenceCount;
  begin
    fReferenceCountDisabled := TRUE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TFlexInterfacedObject.get_On_Destroy: IOn_Destroy;
  begin
    // We must NOT create an On_Destroy event if we are being destroyed
    //  otherwise it will be orphaned (i.e. leaked)

    if NOT fDestroying and NOT Assigned(fOn_Destroy) then
      fOn_Destroy := TOnDestroy.Create(self);

    result := fOn_Destroy;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TFlexInterfacedObject.get_ReferenceCount: Integer;
  begin
    result := fReferenceCount;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TFlexInterfacedObject.NewInstance: TObject;
  begin
    result := inherited NewInstance;

    // Set an initial refcount of 1 to protect against automatic
    //  disposal if interface references to the new object are used
    //  in the constructor (will be decremented AFTER construction)
    TFlexInterfacedObject(result).fReferenceCount := 1;
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
    result := InterlockedIncrement(fReferenceCount);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TFlexInterfacedObject._Release: Integer;
  begin
    result := InterlockedDecrement(fReferenceCount);
    if (result = 0) and NOT fReferenceCountDisabled then
      Destroy;
  end;


end.
