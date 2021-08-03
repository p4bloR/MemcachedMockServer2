require_relative 'lib/ServerSide/Server'

port = ((File.open("settings.txt", &:readline)).split)[2]
address = 'localhost'

server = Server.new(address, port)
server.run