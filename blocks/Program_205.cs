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
