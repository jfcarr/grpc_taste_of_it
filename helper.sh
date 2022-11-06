#!/bin/bash

# Arguments:
#   101 - Generate the gRPC Service project

if (( $# != 1 )); then
	echo 'Arguments:'
	echo ''

	echo '  101 - Generate and build the .NET gRPC Service project'
	echo '  102 - Add new messages to greet.proto, and build'
	echo '  103 - Add method for new messages, and build'
	echo '  104 - Update GreeterService to implement new methods'

	echo ''

	echo '  201 - Generate and build the .NET gRPC Client project'
	echo '  202 - Add dependencies'
	echo '  203 - Copy protocol buffers file from service project and update the namespace'
	echo '  204 - Add Protobuf item group to project, and build'
	echo '  205 - Update Program.cs'

	echo ''

	echo '  300 - Scaffold entire Python project'
	echo '  301 - Create Python virtual environment'
	echo '  302 - Install dependencies'
	echo '  303 - Create project folders'
	echo '  304 - Copy protocol buffer from the server'
	echo '  305 - Generate Python code'
	echo '  306 - Create client script'

	echo ''
	echo '  999 - Empty the src/ directory'

	exit 0
fi

if [ $1 == '101' ]
then
	cd src

	dotnet new grpc -o GrpcGreeterService

	cd ..

	cp blocks/launchSettings_101.json src/GrpcGreeterService/Properties/launchSettings.json

	cd src/GrpcGreeterService

	dotnet build
fi

if [ $1 == '102' ]
then
	cp blocks/greet_102.proto src/GrpcGreeterService/Protos/greet.proto

	cd src/GrpcGreeterService

	dotnet build
fi

if [ $1 == '103' ]
then
	cp blocks/greet_103.proto src/GrpcGreeterService/Protos/greet.proto

	cd src/GrpcGreeterService

	dotnet build
fi

if [ $1 == '104' ]
then
	cp blocks/GreeterService_104.cs src/GrpcGreeterService/Services/GreeterService.cs

	cd src/GrpcGreeterService

	dotnet build
fi

if [ $1 == '201' ]
then
	cd src

	dotnet new console -o GrpcGreeterClient

	cd GrpcGreeterClient

	dotnet build
fi

if [ $1 == '202' ]
then
	cd src/GrpcGreeterClient

	dotnet add package Grpc.Net.Client --version 2.49.0
	dotnet add package Google.Protobuf -- version 3.21.9
	dotnet add package Grpc.Tools --version 2.50.0
fi

if [ $1 == '203' ]
then
	mkdir src/GrpcGreeterClient/Protos

	cp blocks/greet_203.proto src/GrpcGreeterClient/Protos/greet.proto
fi

if [ $1 == '204' ]
then
	cp blocks/GrpcGreeterClient_204.csproj src/GrpcGreeterClient/GrpcGreeterClient.csproj

	cd src/GrpcGreeterClient

	dotnet build
fi

if [ $1 == '205' ]
then
	cp blocks/Program_205.cs src/GrpcGreeterClient/Program.cs

	cd src/GrpcGreeterClient

	dotnet build
fi

if [ $1 == '301' ]
then
	cd src

	python3 -m venv grpc_env
fi

if [ $1 == '302' ]
then
	cd src/grpc_env

	source bin/activate

	echo 'grpcio-tools ~= 1.30' > requirements.txt

	pip install -r requirements.txt
fi

if [ $1 == '303' ]
then
	mkdir src/grpc_env/grpc_client

	mkdir src/grpc_env/grpc_client/protobufs

	mkdir src/grpc_env/grpc_client/src
fi

if [ $1 == '304' ]
then
	cp src/GrpcGreeterService/Protos/greet.proto src/grpc_env/grpc_client/protobufs/
fi

if [ $1 == '305' ]
then
	cd src/grpc_env

	source bin/activate

	cd grpc_client/src

	python -m grpc_tools.protoc -I ../protobufs --python_out=. --grpc_python_out=. ../protobufs/greet.proto
fi

if [ $1 == '306' ]
then
	cp blocks/client_306.py src/grpc_env/grpc_client/src/client.py
fi

if [ $1 == '999' ]
then
	rm -rf src/

	mkdir src/
fi