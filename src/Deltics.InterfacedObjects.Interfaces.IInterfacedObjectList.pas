
{$i deltics.interfacedobjects.inc}

  unit Deltics.InterfacedObjects.Interfaces.IInterfacedObjectList;


interface

  type
    IInterfacedObjectList = interface
    ['{C7761F1C-2DFB-4FBA-8EED-46556675E8D1}']
      function get_Count: Integer;
      function get_Item(const aIndex: Integer): IUnknown;
      function get_Object(const aIndex: Integer): TObject;
      function Add(const aObject: TObject): Integer;
      procedure Delete(const aIndex: Integer);
      function IndexOf(const aObject: TObject): Integer;
      property Count: Integer read get_Count;
      property Items[const aIndex: Integer]: IUnknown read get_Item; default;
      property Objects[const aIndex: Integer]: TObject read get_Object;
    end;



implementation

end.

