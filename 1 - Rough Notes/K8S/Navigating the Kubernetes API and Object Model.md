This chapter covers
Managing a Kubernetes cluster and the applications it hosts via its API
Understanding the structure of Kubernetes API objects
Retrieving and understanding an object’s YAML or JSON manifest
Inspecting the status of cluster nodes via Node objects
Inspecting cluster events through Event objects



The Kubernetes API is an HTTP-based RESTful API where the state is
represented by resources on which you perform CRUD operations (Create,
Read, Update, Delete) using standard HTTP methods such as POST, GET,
PUT/PATCH or DELETE.

Understanding how objects are represented

When you make a GET request for a resource, the Kubernetes API server
returns the object in structured text form. The default data model is JSON,
but you can also tell the server to return YAML instead. When you update the
object using a POST or PUT request, you also specify the new state with either
JSON or YAML.


4.1.2 Understanding the structure of an object manifest
Introducing the main parts of an object
The manifest of most Kubernetes API objects consists of the following four
sections:
Type Metadata contains information about the type of object this
manifest describes. It specifies the object type, the group to which the
type belongs, and the API version.
Object Metadata holds the basic information about the object instance,
including its name, time of creation, owner of the object, and other
identifying information. The fields in the Object Metadata are the same
for all object types.
Spec is the part in which you specify the desired state of the object. Its
fields differ between different object types. For pods, this is the part that
specifies the pod’s containers, storage volumes and other information
related to its operation.
Status contains the current actual state of the object. For a pod, it tells
you the condition of the pod, the status of each of its containers, its IP
address, the node it’s running on, and other information that revealswhat’s happening to your pod.

Understanding the spec and status sections

You use the Spec to specify the
desired state of the object and read the actual state of the object from the
Status section.
So, you are the one who writes the Spec and reads the Status,
but who or what reads the Spec and writes the Status?

The Kubernetes Control Plane runs several components called **controllers**
that manage the objects you create. Each controller is usually only
responsible for one object type. For example, the Deployment controller
manages Deployment objects.

As shown in figure 4.4, the task of a controller is to read the desired object
state from the object’s Spec section, perform the actions required to achieve
this state, and report back the actual state of the object by writing to its Status
section.
Essentially, you tell Kubernetes what it has to do by creating and updating
API objects. Kubernetes controllers use the same API objects to tell you what
they have done and what the status of their work is.
remember that almost every
object type has an associated controller and that this controller is what reads
the Spec and writes the Status of the object.

not all
have the Spec and Status sections. An example of such an object is the Event object, which is created by various
controllers to provide additional information about what is happening with an
object that the controller is managing.



Examining an object’s individual properties
kubectl get node *name* - o yaml

As you can see, the manifest starts with the apiVersion and kind fields,
which specify the API version and type of the object that this object manifest
specifies. The API version is the schema used to describe this object.

The apiVersion in the previous manifest is v1, but you’ll see in the following
chapters that the apiVersion in other object types contains more than just the
version number. For Deployment objects, for example, the apiVersion is
apps/v1. Whereas the field was originally used only to specify the API
version, it is now also used to specify the API group to which the resource
belongs. Node objects belong to the core API group, which is conventionally
omitted from the apiVersion field.


The type of object defined in the manifest is specified by the field kind. The
object kind in the previous manifest is Node. In the previous chapters, you
created objects of kind Deployment, Service, and Pod.

Fields in the Object Metadata section
The metadata section contains the metadata of this object instance. It
contains the name of the instance, along with additional attributes such as
labels and annotations, which are explained in chapter 10, and fields such
as resourceVersion, managedFields, and other low-level fields, which are
explained at depth in the second volume of this book.

Fields in the Spec section
Next comes the spec section, which is specific to each object kind. It is
relatively short for Node objects compared to what you find for other object
kinds. The podCIDR fields specify the pod IP range assigned to the node. Pods
running on this node are assigned IPs from this range. The taints field is not
important at this point. You can read about it in the second volume of this
book.Typically, an object’s spec section contains many more fields that you use to
configure the object.

Fields in the Status section
The status section also differs between the different kinds of object, but its
purpose is always the same - it contains the last observed state of the thing
the object represents. For Node objects, the status reveals the node’s IP
address(es), host name, capacity to provide compute resources, the current
conditions of the node, the container images it has already downloaded and
which are now cached locally, and information about its operating system
and the version of Kubernetes components running on it.


Using kubectl explain to explore API object fields
The kubectl tool has a nice feature that allows you to look up the explanation
of each field for each object type (kind) from the command line. Usually, you
start by asking it to provide the basic description of the object kind by
running kubectl explain <kind>, as shown here:
$ kubectl explain nodes

KIND:
Node
VERSION: v1
DESCRIPTION:
Node is a worker node in Kubernetes. Each node will have a unique
identifier in the cache (i.e. in etcd).
FIELDS:
apiVersion
<string>
APIVersion defines the versioned schema of this representation of an
object. Servers should convert recognized schemas to the latest...kind <string>
Kind is a string value representing the REST resource this object
represents. Servers may infer this from the endpoint the client...
metadata
<Object>
Standard object's metadata. More info: ...
spec <Object>
Spec defines the behavior of a node...
status
<Object>
Most recently observed status of the node. Populated by the system.
Read-only. More info: ...
The command prints the explanation of the object and lists the top-level
fields that the object can contain.




Drilling deeper into an API object’s structure
You can then drill deeper to find subfields under each specific field. For
example, you can use the following command to explain the node’s spec
field:
$ kubectl explain node.spec
KIND:
Node
VERSION: v1
RESOURCE: spec <Object>
DESCRIPTION:
Spec defines the behavior of a node.
NodeSpec describes the attributes that a node is created with.
FIELDS:
configSource <Object>
If specified, the source to get node configuration from The
DynamicKubeletConfig feature gate must be enabled for the Kubelet...
externalID
<string>
Deprecated. Not all kubelets will set this field...
podCIDR
<string>
PodCIDR represents the pod IP range assigned to the node.Please note the API version given at the top. As explained earlier, multiple
versions of the same kind can exist. Different versions can have different
fields or default values. If you want to display a different version, specify it
with the --api-version option.
Note
If you want to see the complete structure of an object (the complete
hierarchical list of fields without the descriptions), try kubectl explain
pods --recursive.





4.2.3 Understanding an object’s status conditions
The set of fields in both the spec and status sections is different for each
object kind, but the conditions field is found in many of them. It gives a list
of conditions the object is currently in. They are very useful when you need
to troubleshoot an object, so let’s examine them more closely. Since the Node
object is used as an example, this section also teaches you how to easily
identify problems with a cluster node.


$ kubectl get node kind-control-plane -o yaml
...
status:
...
conditions:
- lastHeartbeatTime: "2020-05-17T13:03:42Z"
lastTransitionTime: "2020-05-03T15:09:17Z"
message: kubelet has sufficient memory available
reason: KubeletHasSufficientMemory
status: "False"
type: MemoryPressure
- lastHeartbeatTime: "2020-05-17T13:03:42Z"
lastTransitionTime: "2020-05-03T15:09:17Z"
message: kubelet has no disk pressure
reason: KubeletHasNoDiskPressure
status: "False"
type: DiskPressure
- lastHeartbeatTime: "2020-05-17T13:03:42Z"
lastTransitionTime: "2020-05-03T15:09:17Z"
message: kubelet has sufficient PID available
reason: KubeletHasSufficientPID
status: "False"
type: PIDPressure
- lastHeartbeatTime: "2020-05-17T13:03:42Z"
lastTransitionTime: "2020-05-03T15:10:15Z"
message: kubelet is posting ready status
reason: KubeletReady
status: "True"
type: Ready

**The jq tool is very handy if you want to see only a part of the object’s**
**structure. For example, to display the node’s status conditions, you can run**
**kubectl get node <name> -o json | jq .status.conditions. The**
**equivalent tool for YAML is yq.**



There are four conditions that reveal the state of the node. Each condition has
a type and a status field, which can be True, False or Unknown, as shown in
the figure 4.6. A condition can also specify a machine-facing reason for the
last transition of the condition and a human-facing message with details about
the transition. The lastTransitionTime field indicates when the condition
moved from one status to another, whereas the lastHeartbeatTime field
reveals the last time the controller received an update on the given condition.

Although it’s the last condition in the list, the Ready condition is probably the
most important, as it signals whether the node is ready to accept new
workloads (pods). The other conditions (MemoryPressure, DiskPressure and
PIDPressure) signal whether the node is running out of resources. Remember
to check these conditions if a node starts to behave strangely - for example, if
the applications running on it start running out of resources and/or crash.


Inspecting objects using the kubectl describe command

a
more user-friendly way to inspect an object is the kubectl describe
command, which typically displays the same information or sometimes even
more.

Understanding the kubectl describe output for a Node object

$ kubectl describe node kind-worker-2

As you can see, the kubectl describe command displays all the information
you previously found in the YAML manifest of the Node object, but in a
more readable form. You can see the name, IP address, and hostname, as well
as the conditions and available capacity of the node.


In addition to the information stored in the Node object itself, the kubectl
describe command also displays the pods running on the node and the total
amount of compute resources allocated to them. Below is also a list of events
related to the node.
This additional information isn’t found in the Node object itself but is
collected by the kubectl tool from other API objects. For example, the list of
pods running on the node is obtained by retrieving Pod objects via the pods
resource.

If you run the describe command yourself, no events may be displayed. This
is because only events that have occurred recently are shown. For Node
objects, unless the node has resource capacity issues, you’ll only see events ifyou’ve recently (re)started the node.
Virtually every API object kind has events associated with it. Since they are
crucial for debugging a cluster, they warrant a closer look before you start
exploring other objects.

4.3 Observing cluster events via Event objects
As controllers perform their task of reconciling the actual state of an object
with the desired state, as specified in the object’s spec field, they generate
events to reveal what they have done. Two types of events exist: Normal and
Warning. Events of the latter type are usually generated by controllers when
something prevents them from reconciling the object. By monitoring this type
of events, you can be quickly informed of any problems that the cluster
encounters.

Like everything else in Kubernetes, events are represented by Event objects
that are created and read via the Kubernetes API. As the following figure
shows, they contain information about what happened to the object and what
the source of the event was. Unlike other objects, each Event object is deleted
one hour after its creation to reduce the burden on etcd, the data store for
Kubernetes API objects.

The amount of time to retain events is configurable via the API server’s
command-line options.

Listing events using kubectl get events

You won’t find them in the object’s YAML manifest, as they
exist on their own, just like Nodes and the other objects you’ve seen so far.

As with other objects, the kubectl get command only outputs the most
important object data. To display additional information, you can enable
additional columns by executing the command with the -o wide option:
$ kubectl get ev -o wide

The output of this command is extremely wide and is not listed here in the
book. Instead, the information that is displayed is explained in the following
table.
Table 4.1 Properties of the Event object
Property
Name
Type
Reason
Source
Object
Sub-object
Message
First seen
Last seen
Count
Description
The name of this Event object instance. Useful only if you
want to retrieve the given object from the API.
The type of the event. Either Normal or Warning .
The machine-facing description why the event occurred.
The component that reported this event. This is usually a
controller.
The object instance to which the event refers. For example,
node/xyz.
The sub-object to which the event refers. For example,
what container of the pod.
The human-facing description of the event.
The first time this event occurred. Remember that each
Event object is deleted after a while, so this may not be the
first time that the event actually occurred.
Events often occur repeatedly. This field indicates when
this event last occurred.
The number of times this event has occurred.


Displaying only warning events
Unlike the kubectl describe command, which only displays events related
to the object you’re describing, the kubectl get events command displays
all events. This is useful if you want to check if there are events that youshould be concerned about. You may want to ignore events of type Normal
and focus only on those of type Warning.
The API provides a way to filter objects through a mechanism called field
selectors. Only objects where the specified field matches the specified
selector value are returned. You can use this to display only Warning events.
The kubectl get command allows you to specify the field selector with the -
-field-selector option. To list only events that represent warnings, you
execute the following command:
$ kubectl get ev --field-selector type=Warning




You may wonder how I knew the exact name of the field to be used in the
field selector and what its exact value should be (perhaps it should have been
lower case, for example). Hats off if you guessed that this information is
provided by the kubectl explain events command. Since events are
regular API objects, you can use it to look up documentation on the event
objects’ structure. There you’ll learn that the type field can have two values:
either Normal or Warning. !!!
kubectl explain 




4.4 Summary
Kubernetes provides a RESTful API for interaction with a cluster. API
Objects map to actual components that make up the cluster, including
applications, load balancers, nodes, storage volumes, and many others.
An object instance can be represented by many resources. A single
object type can be exposed through several resources that are just
different representations of the same thing.
Kubernetes API objects are described in YAML or JSON manifests.
Objects are created by posting a manifest to the API. The status of the
object is stored in the object itself and can be retrieved by requesting the
object from the API with a GET request.
All Kubernetes API objects contain Type and Object Metadata, and
most have a spec and status sections. A few object types don’t have
these two sections, because they only contain static data.
Controllers bring objects to life by constantly watching for changes in
their spec, updating the cluster state and reporting the current state via
the object’s status field.
As controllers manage Kubernetes API objects, they emit events to
reveal what actions they have performed. Like everything else, events
are represented by Event objects and can be retrieved through the API.
Events signal what is happening to a Node or other object. They show
what has recently happened to the object and can provide clues as to
why it is broken.
The kubectl explain command provides a quick way to look up
documentation on a specific object kind and its fields from the command
line.
The status in a Node object contains information about the node’s IP
address and hostname, its resource capacity, conditions, cached
container images and other information about the node. Pods running on
the node are not part of the node’s status, but the kubectl describe
node commands gets this information from the pods resource.Many object types use status conditions to signal the state of the
component that the object represents. For nodes, these conditions are
MemoryPressure, DiskPressure and PIDPressure. Each condition is
either True, False, or Unknown and has an associated reason and
message that explain why the condition is in the specified state.