# powershell -ExecutionPolicy ByPass -file run_python_client.ps1

Set-Location -Path "src\grpc_env" -PassThru

Scripts\activate.ps1

Set-Location -Path "grpc_client\src"

python client.py