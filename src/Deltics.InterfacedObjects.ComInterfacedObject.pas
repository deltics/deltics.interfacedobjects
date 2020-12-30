
{$i deltics.interfacedobjects.inc}

  unit Deltics.InterfacedObjects.ComInterfacedObject;


interface

  uses
    Deltics.InterfacedObjects.InterfacedObject,
    Deltics.InterfacedObjects.ObjectLifecycle;


  type
    TComInterfacedObject = class(TInterfacedObject)
    private
      fReferenceCount: Integer;
    protected
      procedure DoDestroy; virtual;
    public
      class function NewInstance: TObject; override;
      procedure AfterConstruction; override;
      procedure BeforeDestruction; override;

    // IUnknown
    protected
      function _AddRef: Integer; override;
      function _Release: Integer; override;

    // IInterfacedObject overrides
    protected
      function get_IsReferenceCounted: Boolean; override;
      function get_Lifecycle: TObjectLifecycle; override;
      function get_ReferenceCount: Integer; override;

    public
      procedure Free; reintroduce;
    end;




implementation

  uses
    Windows,
    SysUtils;


{ TComInterfacedObject --------------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedObject._AddRef: Integer;
  begin
    if NOT (IsBeingDestroyed) then
      result := InterlockedIncrement(fReferenceCount)
    else
      result := 1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedObject._Release: Integer;
  begin
    if NOT (IsBeingDestroyed) then
    begin
      result := InterlockedDecrement(fReferenceCount);
      if (result = 0) then
        DoDestroy;
    end
    else
      result := 1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TComInterfacedObject.AfterConstruction;
  begin
    inherited;

    // Now that the constructors are done, remove the reference count we added
    //  in NewInstance - the reference count will typically be zero at this
    //  point as a result, but will then get bumped back to 1 (one) by the
    //  assignment of the constructed instance to some interface reference var

    InterlockedDecrement(fReferenceCount);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TComInterfacedObject.BeforeDestruction;
  begin
    if (fReferenceCount <> 0) then
      System.Error(reInvalidPtr);

    inherited;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TComInterfacedObject.DoDestroy;
  begin
    Destroy;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TComInterfacedObject.Free;
  begin
    if (fReferenceCount > 0) then
      raise EInvalidPointer.Create('You must not explicitly free a COM interfaced object (or class '
                                 + 'derived from it) where interface references have been '
                                 + 'obtained.  The lifecycle of these objects is determined by '
                                 + 'reference counting.');
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedObject.get_IsReferenceCounted: Boolean;
  begin
    result := TRUE;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedObject.get_Lifecycle: TObjectLifecycle;
  begin
    result := olReferenceCOunted;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedObject.get_ReferenceCount: Integer;
  begin
    result := fReferenceCount;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  class function TComInterfacedObject.NewInstance: TObject;
  begin
    result := inherited NewInstance;

    // Ensure a minimum reference count of 1 during execution of the constructors
    //  to protect against _Release destroying ourselves as a result of interface
    //  references being passed around

    InterlockedIncrement(TComInterfacedObject(result).fReferenceCount);
  end;





end.
