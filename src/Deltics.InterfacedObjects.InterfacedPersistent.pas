
{$i deltics.interfacedobjects.inc}

  unit Deltics.InterfacedObjects.InterfacedPersistent;


interface


  uses
    Classes,
    Deltics.Multicast;


  type
    TInterfacedPersistent = class(TPersistent, IUnknown,
                                               IOn_Destroy)
      private
        fOn_Destroy: IOn_Destroy;

      // IUnknown
      protected
        function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
        function _AddRef: Integer; stdcall;
        function _Release: Integer; stdcall;

      // IOn_Destroy
      protected
        function get_On_Destroy: IOn_Destroy;
      public
        property On_Destroy: IOn_Destroy read get_On_Destroy implements IOn_Destroy;
    end;



implementation

{ TInterfacedPersistent -------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedPersistent.QueryInterface(const IID: TGUID;
                                                out Obj): HResult;
  begin
    if GetInterface(IID, Obj) then
      Result := 0
    else
      Result := E_NOINTERFACE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedPersistent._AddRef: Integer;
  begin
    result := 1; { NO-OP }
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedPersistent._Release: Integer;
  begin
    result := 1; { NO-OP }
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedPersistent.get_On_Destroy: IOn_Destroy;
  // Create the multi-cast event on demand, since we cannot
  //  guarantee any particular constructor call order and there
  //  may be dependencies created during construction (e.g. if
  //  multi-cast event handlers are added before/after any call
  //  to a particular inherited constructor etc etc)
  begin
    if NOT Assigned(fOn_Destroy) then
      fOn_Destroy := TOnDestroy.Create(self);

    result := fOn_Destroy;
  end;


end.
