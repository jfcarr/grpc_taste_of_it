# gRPC - Taste of IT

gRPC materials for Taste of IT 2022 talk

# Project Setup

## .NET gRPC Service

Create root folder for the projects:

```bash
mkdir src

cd src
```
Create service:

```bash
dotnet new grpc -o GrpcGreeterService
```

Update the applicationUrl in launchsettings.json to this:

```json
"applicationUrl": "http://localhost:6000;https://localhost:6001"
```

_(You can use whatever ports you need in your own projects. We're using these for consistency in the examples.)_

Build the service:

```bash
cd GrpcGreeterService

dotnet build
```

Update Protos/greet.proto, extending it with a couple of new messages:

```protobuf
message GoodbyeRequest { string name = 1; }

message GoodbyeReply { string message = 1; }
```

Build again:

```bash
dotnet build
```

Add a new method using the new messages:

```protobuf
service Greeter {
  // Sends a Hello greeting
  rpc SayHello(HelloRequest) returns (HelloReply);

  // Sends a Goodbye greeting
  rpc SayGoodbye(GoodbyeRequest) returns (GoodbyeReply);
}
```
Build again:

```bash
dotnet build
```

Open GreeterService.cs and add a new method using the new messages:

```csharp
public override Task<GoodbyeReply> SayGoodbye(GoodbyeRequest request, ServerCallContext context)
{
	return Task.FromResult(new GoodbyeReply
	{
		Message = "Goodbye " + request.Name
	});
}
```

Build again:

```bash
dotnet build
```

## .NET gRPC Client

Change to the project root (src):

```bash
cd ..
```

Create the client project:

```bash
dotnet new console -o GrpcGreeterClient
```

Switch to the folder and add dependencies:

```bash
cd GrpcGreeterClient

dotnet add package Grpc.Net.Client
dotnet add package Google.Protobuf
dotnet add package Grpc.Tools
```

Create a Protos folder, then copy the .proto file from the service project:

```bash
mkdir Protos

cp ../GrpcGreeterService/Protos/greet.proto Protos/
```

Update the namespace inside the greet.proto file to the project's namespace:

```protobuf
option csharp_namespace = "GrpcGreeterClient";
```

Edit the GrpcGreeterClient.csproj project file and add an item group with a `<Protobuf>` element that refers to the greet.proto file:

```xml
<ItemGroup>
  <Protobuf Include="Protos\greet.proto" GrpcServices="Client" />
</ItemGroup>
```

Build the client to generate the types:

```bash
dotnet build
```

Replace the contents of Program.cs with this:

```csharp
using System.Threading.Tasks;
using Grpc.Net.Client;
using GrpcGreeterClient;

// The port number must match the port of the gRPC server.
using var channel = GrpcChannel.ForAddress("http://localhost:6000");

var client = new Greeter.GreeterClient(channel);
var reply = await client.SayHelloAsync(new HelloRequest { Name = "GreeterClient" });

Console.WriteLine("Greeting: " + reply.Message);
Console.WriteLine("Press any key to exit...");
```

Run the client:

```bash
dotnet run
```

You should see this:

```
Greeting: Hello GreeterClient
Press any key to exit...
```

## Python gRPC Client

Create a virtual Python environment:

```bash
cd src

python3 -m venv grpc_env

cd grpc_env

source bin/activate
```

Create requirements.txt file:

```bash
echo 'grpcio-tools ~= 1.30' > requirements.txt
```

Install the dependencies:

```bash
pip install -r requirements.txt

```

Create project folders:

```bash
mkdir grpc_client

cd grpc_client

mkdir protobufs

mkdir src
```

Copy the protocol buffer file from the server project:

```bash
cp ../../GrpcGreeterService/Protos/greet.proto protobufs/

```

Generate Python code:

```bash
cd src

python -m grpc_tools.protoc -I ../protobufs --python_out=. --grpc_python_out=. ../protobufs/greet.proto
```

This generates two files:

* greet_pb2_grpc.py
* greet_pb2.py

Create a client.py file with the following contents:

```python
import grpc

import greet_pb2_grpc
from greet_pb2 import HelloRequest, GoodbyeRequest

channel = grpc.insecure_channel("localhost:6000")

client = greet_pb2_grpc.GreeterStub(channel)

hello_request = HelloRequest (
	name = "Jim"
)

goodbye_request = GoodbyeRequest (
	name = "Jim"
)

hello_result = client.SayHello(hello_request)
goodbye_result = client.SayGoodbye(goodbye_request)

print(hello_result.message)
print(goodbye_result.message)

```

Run the client.py file:

```bash
python client.py
```

Results:

```
Hello Jim
Goodbye Jim
```
