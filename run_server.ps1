# powershell -ExecutionPolicy ByPass -file run_server.ps1

Set-Location -Path "src\GrpcGreeterService" -PassThru

dotnet clean

dotnet run