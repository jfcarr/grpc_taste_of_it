# gRPC - Taste of IT

gRPC materials for Taste of IT 2022 talk

# Requirements

* .NET SDK (I used version 6)
* Python 3 with the venv module installed.

# Project Setup

All instructions assume a Linux environment.  It shouldn't be hard to adapt for others, though.

Reset everything with helper script: `./helper 999`

## .NET gRPC Service

### Step 1.01

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 101`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 101`

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

### Step 1.02

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 102`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 102`

Update Protos/greet.proto, extending it with a couple of new messages:

```protobuf
message GoodbyeRequest { string name = 1; }

message GoodbyeReply { string message = 1; }
```

Build again:

```bash
dotnet build
```

### Step 1.03

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 103`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 103`

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

### Step 1.04

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 104`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 104`

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

### Manual Step

Run the server:

Operating System | Server Script
---------|----------
Linux | `./run_server.sh`
Windows | `powershell -ExecutionPolicy ByPass -file run_server.ps1`

## .NET gRPC Client

### Step 2.01

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 201`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 201`

Change to the project root (src):

```bash
cd ..
```

Create the client project:

```bash
dotnet new console -o GrpcGreeterClient
```

### Step 2.02

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 202`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 202`

Switch to the folder and add dependencies:

```bash
cd GrpcGreeterClient

dotnet add package Grpc.Net.Client
dotnet add package Google.Protobuf
dotnet add package Grpc.Tools
```

### Step 2.03

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 203`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 203`

Create a Protos folder, then copy the .proto file from the service project:

```bash
mkdir Protos

cp ../GrpcGreeterService/Protos/greet.proto Protos/
```

Update the namespace inside the greet.proto file to the project's namespace:

```protobuf
option csharp_namespace = "GrpcGreeterClient";
```

### Step 2.04

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 204`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 204`

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

### Step 2.05

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 205`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 205`

Replace the contents of Program.cs with this:

```csharp
using System.Threading.Tasks;
using Grpc.Net.Client;
using GrpcGreeterClient;

// The port number must match the port of the gRPC server.
using var channel = GrpcChannel.ForAddress("http://localhost:6000");

var client = new Greeter.GreeterClient(channel);

var helloReply = await client.SayHelloAsync(new HelloRequest { Name = "GreeterClient" });
Console.WriteLine("Greeting: " + helloReply.Message);

var goodbyeReply = await client.SayGoodbyeAsync(new GoodbyeRequest { Name = "GreeterClient" });
Console.WriteLine("Greeting: " + goodbyeReply.Message);
```

### Manual Step

Run the client:

Operating System | Server Script
---------|----------
Linux | `./run_dotnet_client.sh`
Windows | `powershell -ExecutionPolicy ByPass -file run_dotnet_client.ps1`

You should see this:

```
Greeting: Hello GreeterClient
Press any key to exit...
```

## Python gRPC Client

### Step 3.01

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 301`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 301`

Create a virtual Python environment:

```bash
cd src

python3 -m venv grpc_env

cd grpc_env

source bin/activate
```

### Step 3.02

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 302`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 302`

Create requirements.txt file:

```bash
echo 'grpcio-tools ~= 1.30' > requirements.txt
```

Install the dependencies:

```bash
pip install -r requirements.txt

```

### Step 3.03

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 303`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 303`

Create project folders:

```bash
mkdir grpc_client

cd grpc_client

mkdir protobufs

mkdir src
```

### Step 3.04

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 304`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 304`

Copy the protocol buffer file from the server project:

```bash
cp ../../GrpcGreeterService/Protos/greet.proto protobufs/

```

### Step 3.05

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 305`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 305`

Generate Python code:

```bash
cd src

python -m grpc_tools.protoc -I ../protobufs --python_out=. --grpc_python_out=. ../protobufs/greet.proto
```

This generates two files:

* greet_pb2_grpc.py
* greet_pb2.py

### Step 3.06

Operating System | Helper Script
---------|----------
Linux | `./helper.sh 306`
Windows | `powershell -ExecutionPolicy ByPass -file helper.ps1 306`

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

### Manual Step

Run the Python client:

Operating System | Server Script
---------|----------
Linux | `./run_python_client.sh`
Windows | `powershell -ExecutionPolicy ByPass -file run_python_client.ps1`

Results:

```
Hello Jim
Goodbye Jim
```
