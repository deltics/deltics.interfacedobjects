
{$i deltics.interfacedobjects.inc}

  unit Deltics.InterfacedObjects.Interfaces.IInterfacedObject;


interface

  uses
    Deltics.InterfacedObjects.ObjectLifecycle;


  type
    IInterfacedObject = interface
    ['{567DDBF8-5758-4AE1-A706-2CEB70E8445D}']
      function get_Lifecycle: TObjectLifecycle;
      function get_Object: TObject;
      function get_ReferenceCount: Integer;
      property AsObject: TObject read get_Object;
      property Lifecycle: TObjectLifecycle read get_Lifecycle;
      property ReferenceCount: Integer read get_ReferenceCount;
    end;



implementation

end.
