
{$i deltics.interfacedobjects.inc}

  unit Deltics.InterfacedObjects.InterfacedObjectList;


interface

  uses
    Contnrs,
    Deltics.InterfacedObjects.Interfaces.IInterfacedObjectList,
    Deltics.InterfacedObjects.ComInterfacedObject;


  type
    TInterfacedObjectList = class(TComInterfacedObject, IInterfacedObjectList)
    // IInterfacedObjectList
    protected
      function get_Capacity: Integer;
      function get_Count: Integer;
      function get_Item(const aIndex: Integer): IUnknown;
      function get_Object(const aIndex: Integer): TObject;
      procedure set_Capacity(const aValue: Integer);
      function Add(const aItem: IInterface): Integer; overload;
      function Add(const aItem: TObject): Integer; overload;
      procedure Clear;
      function Contains(const aItem: IInterface): Boolean; overload;
      function Contains(const aItem: IInterface; var aIndex: Integer): Boolean; overload;
      function Contains(const aItem: TObject): Boolean; overload;
      function Contains(const aItem: TObject; var aIndex: Integer): Boolean; overload;
      procedure Delete(const aIndex: Integer);
      function IndexOf(const aItem: IInterface): Integer; overload;
      function IndexOf(const aItem: TObject): Integer; overload;
      function Insert(const aIndex: Integer; const aItem: IInterface): Integer; overload;
      function Insert(const aIndex: Integer; const aItem: TObject): Integer; overload;
      function Remove(const aItem: IInterface): Boolean; overload;
      function Remove(const aItem: TObject): Boolean; overload;
      property Capacity: Integer read get_Capacity write set_Capacity;
      property Count: Integer read get_Count;
      property Items[const aIndex: Integer]: IUnknown read get_Item; default;
      property Objects[const aIndex: Integer]: TObject read get_Object;

    private
      fItems: TObjectList;
      function InternalAdd(const aIndex: Integer; const aItem: TObject): Integer;
      procedure OnItemDestroyed(aSender: TObject);
    public
      constructor Create;
      destructor Destroy; override;
    end;



implementation

  uses
    Classes,
    SysUtils,
    Deltics.Multicast,
    Deltics.InterfacedObjects;



{ TInterfacedObjectList -------------------------------------------------------------------------- }

  type
    TListItem = class
      ItemObject: TObject;
      ItemInterface: IUnknown;
    end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  constructor TInterfacedObjectList.Create;
  begin
    inherited Create;

    fItems := TObjectList.Create(TRUE);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  destructor TInterfacedObjectList.Destroy;
  begin
    FreeAndNIL(fItems);

    inherited;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TInterfacedObjectList.OnItemDestroyed(aSender: TObject);
  var
    idx: Integer;
  begin
    idx := IndexOf(aSender);
    if idx = -1 then
      EXIT;

    Delete(idx);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TInterfacedObjectList.set_Capacity(const aValue: Integer);
  begin
    fItems.Capacity := aValue;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.get_Capacity: Integer;
  begin
    result := fItems.Capacity;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.get_Count: Integer;
  begin
    result := fItems.Count;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.get_Item(const aIndex: Integer): IUnknown;
  begin
    result := TListItem(fItems[aIndex]).ItemInterface;
  end;



  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.get_Object(const aIndex: Integer): TObject;
  begin
    result := TListItem(fItems[aIndex]).ItemObject;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.Add(const aItem: IInterface): Integer;
  var
    i: IInterfacedObject;
  begin
    if NOT Supports(aItem, IInterfacedObject, i) then
      raise EInvalidOperation.CreateFmt('Items added to a %s must implement IInterfacedObject', [ClassName]);

    result := Add(i.AsObject);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.Add(const aItem: TObject): Integer;
  begin
    result := InternalAdd(-1, aItem);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TInterfacedObjectList.Clear;
  begin
    fItems.Clear;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.Contains(const aItem: IInterface): Boolean;
  begin
    result := IndexOf(aItem) <> -1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.Contains(const aItem: IInterface;
                                          var aIndex: Integer): Boolean;
  begin
    aIndex  := IndexOf(aItem);
    result  := aIndex <> -1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.Contains(const aItem: TObject): Boolean;
  begin
    result := IndexOf(aItem) <> -1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.Contains(const aItem: TObject;
                                          var aIndex: Integer): Boolean;
  begin
    aIndex  := IndexOf(aItem);
    result  := aIndex <> -1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  procedure TInterfacedObjectList.Delete(const aIndex: Integer);
  begin
    fItems.Delete(aIndex);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.IndexOf(const aItem: IInterface): Integer;
  var
    unk: IUnknown;
  begin
    unk := aItem as IUnknown;

    for result := 0 to Pred(fItems.Count) do
      if TListItem(fItems[result]).ItemInterface = unk then
        EXIT;

    result := -1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.IndexOf(const aItem: TObject): Integer;
  begin
    for result := 0 to Pred(fItems.Count) do
      if TListItem(fItems[result]).ItemObject = aItem then
        EXIT;

    result := -1;
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.Insert(const aIndex: Integer;
                                        const aItem: IInterface): Integer;
  var
    i: IInterfacedObject;
  begin
    if NOT Supports(aItem, IInterfacedObject, i) then
      raise EInvalidOperation.CreateFmt('Items added to a %s must implement IInterfacedObject', [ClassName]);

    result := InternalAdd(aIndex, i.AsObject);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.Insert(const aIndex: Integer;
                                        const aItem: TObject): Integer;
  begin
    result := InternalAdd(aIndex, aItem);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.InternalAdd(const aIndex: Integer;
                                             const aItem: TObject): Integer;
  var
    item: TListItem;
    intf: IInterfacedObject;
    onDestroy: IOn_Destroy;
  begin
    if (ReferenceCount = 0) then
      raise EInvalidOperation.Create('You appear to be using a reference counted object list via an object reference.  Reference counted object lists MUST be used via an interface reference to avoid errors arising from the internal On_Destroy mechanism');

    item := TListItem.Create;
    item.ItemObject := aItem;

    if Assigned(aItem) then
    begin
      aItem.GetInterface(IUnknown, item.ItemInterface);

      // If the object being added is reference counted then its presence in this
      //  list ensures it will not be freed unless and until it is removed.
      //
      // But if the object is NOT reference counted then it could be destroyed
      //  while in this list; we need to subscribe to its On_Destroy event so
      //  that we can remove the item from the list if it is destroyed.
      //
      // NOTE: Subscribing to the On_Destroy of a reference counted object
      //        establishes a mutual dependency between the list and the object
      //        which causes a death-embrace when the list is destroyed.
      //
      //   i.e. Do NOT subscribe to reference counted object On_Destroy events!

      if Supports(aItem, IInterfacedObject, intf)
       and (NOT intf.IsReferenceCounted)
       and Supports(aItem, IOn_Destroy, onDestroy) then
        onDestroy.Add(OnItemDestroyed);
    end;

    result := IndexOf(aItem);
    if result <> -1 then
      EXIT;

    result := aIndex;

    if (result = -1) or (result >= fItems.Count) then
      result := fItems.Add(item)
    else
      fItems.Insert(result, item);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.Remove(const aItem: IInterface): Boolean;
  var
    idx: Integer;
  begin
    idx := IndexOf(aItem);
    result := idx <> -1;
    if result then
      Delete(idx);
  end;


  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function TInterfacedObjectList.Remove(const aItem: TObject): Boolean;
  var
    idx: Integer;
  begin
    idx := IndexOf(aItem);
    result := idx <> -1;
    if result then
      Delete(idx);
  end;







end.
