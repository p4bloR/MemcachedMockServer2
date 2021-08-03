require_relative 'lib/ClientSide/Client'

port = ((File.open("settings.txt", &:readline)).split)[2]
address = 'localhost'

client = Client.new(address, port)
client.run