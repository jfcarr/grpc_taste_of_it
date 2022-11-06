import grpc

import greet_pb2_grpc
from greet_pb2 import HelloRequest, GoodbyeRequest

channel = grpc.insecure_channel("localhost:6000")

client = greet_pb2_grpc.GreeterStub(channel)

hello_request = HelloRequest (
	name = "GreeterClient"
)

goodbye_request = GoodbyeRequest (
	name = "GreeterClient"
)

hello_result = client.SayHello(hello_request)
goodbye_result = client.SayGoodbye(goodbye_request)

print(hello_result.message)
print(goodbye_result.message)
