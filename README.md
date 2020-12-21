# Deltics.InterfacedObjects

Various classes to provide base implementations for classes of objects that implement
interfaces.  The implementations provide choices (and in some cases flexibility) over
lifetime management of objects, enabling the (careful!) use of interfaced objects
without necessarily enforcing reference counted lifteime management.

The implementations also fix bugs in the existing TInterfacedObject class in the RTL
Classes unit for all versions of Delphi from 7 and later.  Some of these bugs are
fixed in later versions of the Delphi RTL implementation.


## TComInterfacedObject

Provides a reference counted lifetime object that implements interfaces with a multi-cast
On_Destroy event.


## TInterfacedObject

Provides an explicit lifetime lifetime object that implements interfaces with a multi-cast
On_Destroy event.


## TInterfaceReference

Provides a strong-reference to some interface.


## TWeakInterfaceReference

Provides a weak-reference to some interface.  If the referenced interface supports an
IOn_Destroy event, the reference will subscribe to that event to ensure that the weak
reference that it holds is NIL'd if the referenced object is destroyed.
