
{$i deltics.interfacedobjects.inc}

  unit Deltics.InterfacedObjects.IReferenceCount;


interface

  type
    IReferenceCount = interface
    ['{F1BE6BA8-2055-4B94-8ECA-B6C9897E360B}']
      function get_ReferenceCount: Integer;
      property ReferenceCount: Integer read get_ReferenceCount;
    end;


implementation



end.

