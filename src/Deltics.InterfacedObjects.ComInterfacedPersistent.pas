
{$i deltics.interfacedobjects.inc}

  unit Deltics.InterfacedObjects.ComInterfacedPersistent;


interface

  uses
    Classes,
    Deltics.Multicast;


  type
    TComInterfacedPersistent = class(Classes.TInterfacedPersistent, IOn_Destroy)
    private
      fOn_Destroy: IOn_Destroy;

    // IOn_Destroy
    protected
      function get_On_Destroy: IOn_Destroy;
    public
      property On_Destroy: IOn_Destroy read get_On_Destroy implements IOn_Destroy;
  end;




implementation

{ TComInterfacedPersistent ----------------------------------------------------------------------- }

  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TComInterfacedPersistent.get_On_Destroy: IOn_Destroy;
  begin
    if NOT Assigned(fOn_Destroy) then
      fOn_Destroy := TOnDestroy.Create(self);

    result := fOn_Destroy;
  end;





end.
