.. _protocol:

Hedgehog Protocol
=================

Hedgehog uses a client-server protocol based on ZeroMQ_ and `Protocol Buffers`_.
An overview is given in the :ref:`architecture document <architecture-protocol>`;
this document describes details about the structure and order of messages, to allow developers to implement the
protocol properly.

Hedgehog uses ZeroMQ, a message queue library.
ZeroMQ supports different transport layer protocols, handles reconnects transparently,
and offers different kinds of unicast and multicast communication models.
This means that we won't concern ourselves with stream fragmentation or recovery from disconnects,
instead focusing on the structure of communication and the meaning of messages that make up the protocol.

.. _ZeroMQ: http://zeromq.org/
.. _Protocol Buffers: https://developers.google.com/protocol-buffers/

.. _protocol-kinds:

Message kinds and order
-----------------------

In the Hedgehog protocol, a message can be one of three kinds:

A "request" or "action" is a message sent by a client to the server; conceptually, they are the same.
If the message's main purpose is to retrieve data, it is a request;
if it's purpose is causing a side effect, it's an action.

Requests and actions are answered by the server with "replies" or "acknowledgements".
Replies carry result data, whereas acknowledgements do not; they just signal that a client's message was handled.
Again, these are equivalent from a protocol standpoint, but depending on the particular message in question,
one of the expressions is used.
When talking about the protocol in general, they are used interchangeably.

Lastly, the server may send "asynchronous updates" to a client.
These messages are triggered by server-side events, but are only sent to clients that are interested in them, e.g.:

- a client has subscribed to a sensor, and receives updates about that sensor asynchronously; or
- a client has started a child process, and receives updates about data written to stdout and stderr,
  or about the process terminating.

Without first sending a request that signifies the client's interest (such as subscribing to a sensor value),
the server won't send asynchronous updates to a client.
Likewise, after telling the server that there is no interest any more (such as cancelling the subscription),
the server will cease to send updates.

Every message sent by the server can be identified as either a reply or an asynchronous update,
and every request gets exactly one reply.
This means that the order of replies is sufficient to match requests and replies on the client side.

A conversation might look like this::

    Client        Server
      | -- Req 1 -> |     # client sends a request
      | <- Rep 1 -- |     # server sends reply to Req 1
      |             |
      | -- Req 2 -> |     # client sends another request
      | -- Act 3 -> |     # client sends an action, without waiting for a reply first
      |             |     #   let's assume the action subscribes the client to sensor 0
      | <- Rep 2 -- |     # server responds to Req 2 first
      | <- Ack 3 -- |     # server then responds to Act 3 with an acknowledgement
      |             |
      | <- Upd 3a - |     # server sends an update regarding the subscription established
      |             |     #   by Act 3. Upd 3a does not identify Act 3 as the source, but
      |             |     #   it's an update for sensor 0, so the client can recognize it
      |             |
      | -- Req 4 -> |
      | <- Upd 3b - |     # an update comes interspersed between a request and its reply
      | <- Req 4 -- |
      |             |
      | -- Act 5**  |     # Act 5 unsubscribes from the sensor again
      |             |     #   in reality, the message takes some time in transit
      | <- Upd 3c - |     # another update comes after the client sent Act 5, but before
      |             |     #   the server processed it.
      |  **Act 5 -> |     # Act 5 arrives at the server
      | <- Ack 5 -- |     # After processing the unsubscribe action,
      |             |     #   no more Updates for sensor 3 will be sent.
      |             |

.. _protocol-multipart:

Multipart messages
^^^^^^^^^^^^^^^^^^

When talking about messages, what was meant here were the units of information that are transferred between client and
server.
Let's shortly forget about this meaning and talk about the concept of a "ZeroMQ message".

In ZeroMQ, a message is the unit of transport: a single message is either received completely, or not at all.
Messages consist of one or more "frames", with each frame basically being an array of bytes.
What each frame means depends on the application; for example, ZeroMQ router sockets use header frames to identify a
message's sender, so that replies (and later messages) can be sent to the correct original sender.

So, a ZeroMQ message consists of several frames, some of them containing routing information or similar metadata.
In the Hedgehog Protocol, there are one or more additional payload frames, each containing a single serialized message,
i.e. a request, reply or asynchronous update.
Most of the time, there is only one payload frame per ZeroMQ message, but this can be used to make sure that multiple
messages are executed with low latency between them, e.g. when moving multiple servos in coordination.
When multiple requests are sent as part of the same ZeroMQ message, then and only then their responses will also be sent
in a single response ZeroMQ message.
There is no such guarantee for asynchronous updates; multiple updates may come in a single or separate ZeroMQ messages.

.. _protocol-serialization:

Message serialization
---------------------

Up until now, the communication structure was described: how to match requests with replies,
and when asynchronous updates may be sent.
Of course, it is also essential to know what particular messages there are, and what they mean.
Before exploring this, let's describe how messages are encoded inside ZeroMQ frames.

For serializing messages, i.e. converting messages to sequences of bytes, Protocol Buffers, or Protobuf, is used.
In Protobuf, a message type specification looks like this::

    message Msg {
        uint32 field = 1;
    }

Each message type has a name, and consists of a number of fields, each with a data type and a numeric label.
A field's data type can in turn be another message type.
You can find all details at the `original website`_,
but what's important is how working with a Protobuf message type works.
Let's look at a small Python example::

    # create & initialize message
    msg = Msg()
    msg.field = 42

    # serialize message
    msg_bytes = msg.SerializeToString()

    # create empty message
    msg = Msg()

    # deserialize message
    msg.ParseFromString(msg_bytes)

    print(msg.field)  # 42

It's important to note that, to deserialize the message, we have to know it's a ``Msg`` in advance!
This means there has to be a single top-level message type for the Hedgehog protocol,
which is fittingly called ``HedgehogMessage``, and some sort of discrimination for the wrapped message types.
Protobuf gives us the ``oneof`` feature, which does just that::

    // `HedgehogMessage` represents a message of any kind of the Hedgehog protocol.
    message HedgehogMessage {
        // Contains any one of the different Hedgehog commands.
        // See their respective files for command information.
        oneof payload {
            // ack.proto
            Acknowledgement acknowledgement = 1;
            // io.proto
            IOStateAction io_state_action = 2;
            IOStateMessage io_state_message = 19;
            // ...skipped...
        }
    }

So ``HedgehogMessage`` is at the top of the message hierarchy;
the ``oneof payload`` contains one of several concrete message types.

.. _original website: https://developers.google.com/protocol-buffers/

.. _protocol-types:

Message types
-------------

The rest of the document will describe the different message types.
Each type comes with a link to its message definition on GitHub, a short description, and the message's syntax.
The message syntax describes how the message is used as a request, reply or asynchronous update,
and for requests what is sent as a reply.
For example, let's look at ``AnalogMessage``.
Here is the definition, for reference::

    message AnalogMessage {
        uint32 port = 1;
        uint32 value = 2;
        Subscription subscription = 3;
    }

This is the corresponding syntax description::

    => (port):  analog request => analog reply
    <= (port, value):  analog reply
    => (port, subscription):  analog subscribe => ack
    <- (port, value, subscription):  analog update

This tells us that ``AnalogMessage`` can be used in four different ways:

- as `analog request`. The initial ``=>`` denotes it is a request, ``=> analog reply`` denotes the the kind of reply.
  Only the ``port`` field is used in this case.
- as `analog reply`. The ``<=`` denotes this is a reply message.
- as `analog subscribe`. This is an action, its reply is an acknowledgement.
- as `analog update`. The ``<-`` identifies this as an asynchronous update.

Two additional notations are used: ``[field]`` indicates a field is optional in that syntax,
and ``field1/field2`` means a choice of fields (usually through a ``oneof``).

It should be noted that for primitive values (such as ``value``), the default value (e.g. zero) is indicated by skipping
the field -- one can not determine whether a primitive field was given or not.
Embedded messages (such as ``subscription``) on the other hand are encoded in a way that makes it possible to check for
presence.

This means that `analog request` and `analog reply` can not be distinguished on the wire.
However, as they go in different directions, this does not pose a problem.
In cases where there would be ambiguity, one message would have to use a different field in ``HedgehogMessage``.

.. _protocol-types-list:

List of message types
^^^^^^^^^^^^^^^^^^^^^

Acknowledgement
    ::

        <= (code, [message]):  ack

IOAction
    ::

        => (port, flags):  IO action => ack

IOCommandMessage
    ::

        => (port):  IO command request => IO command reply
        <= (port, flags):  IO command reply
        => (port, subscription):  IO command subscribe => ack
        <- (port, flags, subscription):  IO command update

AnalogMessage
    ::

        => (port):  analog request => analog reply
        <= (port, value):  analog reply
        => (port, subscription):  analog subscribe => ack
        <- (port, value, subscription):  analog update

DigitalMessage
    ::

        => (port):  digital request => digital reply
        <= (port, value):  digital reply
        => (port, subscription):  digital subscribe => ack
        <- (port, value, subscription):  digital update

MotorAction
    ::

        => (port, state, amount):  indefinite motor action => ack
        => (port, state, amount, reached_state, relative/absolute):  terminating motor action => ack

MotorCommandMessage
    ::

        => (port):  motor command request => motor command reply
        <= (port, state, amount):  motor command reply
        => (port, subscription):  motor command subscribe => ack
        <- (port, state, amount, subscription):  motor command update

MotorStateMessage
    ::

        => (port):  motor state request => motor state reply
        <= (port, velocity, position):  motor state reply
        => (port, subscription):  motor state subscribe => ack
        <- (port, velocity, position, subscription):  motor state update

MotorSetPositionAction
    ::

        => (port, position):  set motor position action => ack

ServoAction
    ::

        => (port, active, position):  servo action => ack

ServoCommandMessage
    ::

        => (port):  servo command request => servo command reply
        <= (port, active, position):  servo command reply
        => (port, subscription):  servo command subscribe => ack
        <- (port, active, position, subscription):  servo command update

ProcessExecuteAction
    ::

        => (*args, [working_dir]):  process execute action => process execute reply

ProcessExecuteReply
    ::

        <= (pid):  process execute reply

ProcessStreamMessage
    ::

        => (pid, fileno, chunk):  stream data action => ack
        <- (pid, fileno, chunk):  stream data update

ProcessSignalAction
    ::

        => (pid, signal): process signal action => ack

ProcessExitUpdate
    ::

        <- (pid, exit_code):  process exit update
