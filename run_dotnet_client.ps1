# powershell -ExecutionPolicy ByPass -file run_dotnet_client.ps1

Set-Location -Path "src\GrpcGreeterClient" -PassThru

dotnet clean

dotnet run