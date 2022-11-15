# powershell -ExecutionPolicy ByPass -file helper.ps1 <step #>

Param (
	$Step
)

if ($Step -eq '101') {
	Set-Location -Path "src" -PassThru
	
	dotnet new grpc -o GrpcGreeterService

	Set-Location -Path ".." -PassThru

	Copy-Item "blocks\launchSettings_101.json" -Destination "src\GrpcGreeterService\Properties\launchSettings.json"

	Set-Location -Path "src\GrpcGreeterService" -PassThru

	dotnet build
}

if ($Step -eq '102') {
	Copy-Item "blocks\greet_102.proto" -Destination "src\GrpcGreeterService\Protos\greet.proto"

	Set-Location -Path "src\GrpcGreeterService"

	dotnet build
}

if ($Step -eq '103') {
	Copy-Item "blocks\greet_103.proto" -Destination "src\GrpcGreeterService\Protos\greet.proto"

	Set-Location -Path "src\GrpcGreeterService"

	dotnet build
}

if ($Step -eq '104') {
	Copy-Item "blocks\GreeterService_104.cs" -Destination "src\GrpcGreeterService\Services\GreeterService.cs"

	Set-Location -Path "src\GrpcGreeterService"

	dotnet clean
	
	dotnet build
}

if ($Step -eq '201') {
	Set-Location "src"

	dotnet new console -o GrpcGreeterClient

	Set-Location -Path "GrpcGreeterClient"

	dotnet build
}

if ($Step -eq '202') {
	Set-Location -Path "src\GrpcGreeterClient"

	dotnet add package Grpc.Net.Client --version 2.49.0
	dotnet add package Google.Protobuf -- version 3.21.9
	dotnet add package Grpc.Tools --version 2.50.0
}

if ($Step -eq '203') {
	New-Item -Path "src\GrpcGreeterClient\Protos" -ItemType Directory

	Copy-Item "blocks\greet_203.proto" -Destination "src\GrpcGreeterClient\Protos\greet.proto"
}

if ($Step -eq '204') {
	Copy-Item "blocks\GrpcGreeterClient_204.csproj" -Destination "src\GrpcGreeterClient\GrpcGreeterClient.csproj"

	Set-Location -Path "src\GrpcGreeterClient"

	dotnet build
}

if ($Step -eq '205') {
	Copy-Item "blocks\Program_205.cs" -Destination "src\GrpcGreeterClient\Program.cs"

	Set-Location -Path "src\GrpcGreeterClient"

	dotnet clean

	dotnet build
}

if ($Step -eq '301') {
	Set-Location -Path "src" -PassThru

	python -m venv grpc_env
}

if ($Step -eq '302') {
	Set-Location -Path "src\grpc_env" -PassThru

	Scripts\activate.ps1

	echo 'grpcio-tools ~= 1.30' > requirements.txt

	pip install -r requirements.txt
}

if ($Step -eq '303') {
	New-Item -Path 'src\grpc_env\grpc_client' -ItemType Directory

	New-Item -Path 'src\grpc_env\grpc_client\protobufs' -ItemType Directory

	New-Item -Path 'src\grpc_env\grpc_client\src' -ItemType Directory
}

if ($Step -eq '304') {
	Copy-Item "src\GrpcGreeterService\Protos\greet.proto" -Destination "src\grpc_env\grpc_client\protobufs\"
}

if ($Step -eq '305') {
	Set-Location -Path "src\grpc_env" -PassThru

	Scripts\activate.ps1

	Set-Location -Path "grpc_client\src" -PassThru

	python -m grpc_tools.protoc -I ..\protobufs --python_out=. --grpc_python_out=. ..\protobufs\greet.proto
}

if ($Step -eq '306') {
	Copy-Item "blocks\client_306.py" -Destination "src\grpc_env\grpc_client\src\client.py"
}



if ($Step -eq '999') {
	Remove-Item -path "src\" -recurse -force

	New-Item -Path 'src\' -ItemType Directory
}