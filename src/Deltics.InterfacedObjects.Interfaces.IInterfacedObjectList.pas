
{$i deltics.interfacedobjects.inc}

  unit Deltics.InterfacedObjects.Interfaces.IInterfacedObjectList;


interface

  type
    IInterfacedObjectList = interface
    ['{C7761F1C-2DFB-4FBA-8EED-46556675E8D1}']
      function get_Capacity: Integer;
      function get_Count: Integer;
      function get_Item(const aIndex: Integer): IUnknown;
      function get_Object(const aIndex: Integer): TObject;
      procedure set_Capacity(const aValue: Integer);
      function Add(const aInterface: IInterface): Integer; overload;
      function Add(const aObject: TObject): Integer; overload;
      procedure Clear;
      function Contains(const aItem: IInterface): Boolean; overload;
      function Contains(const aItem: IInterface; var aIndex: Integer): Boolean; overload;
      function Contains(const aItem: TObject): Boolean; overload;
      function Contains(const aItem: TObject; var aIndex: Integer): Boolean; overload;
      procedure Delete(const aIndex: Integer);
      function IndexOf(const aItem: IInterface): Integer; overload;
      function IndexOf(const aItem: TObject): Integer; overload;
      function Insert(const aIndex: Integer; const aInterface: IInterface): Integer; overload;
      function Insert(const aIndex: Integer; const aObject: TObject): Integer; overload;
      function Remove(const aItem: IInterface): Boolean; overload;
      function Remove(const aItem: TObject): Boolean; overload;
      property Capacity: Integer read get_Capacity write set_Capacity;
      property Count: Integer read get_Count;
      property Items[const aIndex: Integer]: IUnknown read get_Item; default;
      property Objects[const aIndex: Integer]: TObject read get_Object;
    end;



implementation

end.

