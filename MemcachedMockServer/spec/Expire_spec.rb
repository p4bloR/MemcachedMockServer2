require_relative "../lib/ServerSide/Server"
require_relative "../lib/ClientSide/Client"
require_relative '../lib/ServerSide/SystemStrings'
require_relative "Methods"
require 'rspec/expectations'

port = set_port
address = 'localhost'

def get_from_array(entries)
  entries.each do |e|
    enterCommand(@client, "get #{e[0]}")
    expect(@client.read).to be == "#{SystemStrings.value} #{e[0]} #{e[1]} #{e[3]}"
    expect(@client.read).to be == e[4]
    expect(@client.read).to be == SystemStrings.end    
  end
end

RSpec.describe "Deletion of expired keys:" do
  before(:each) do
    @server = Server.new(address, port)
    @serverThread = Thread.new{@server.run}    
    @client = Client.new(address, port)
  end

  after(:each) do
    @server.close
  end

  it "letting 3 keys expire" do
    # 0   1    2   3     4     
    # key flag ttl bytes value
    e_1 = ['a', '0', '2', '4', 'what']
    e_2 = ['b', '0', '4', '3', 'why']
    e_3 = ['c', '0', '6', '3', 'who']
    entries = [e_3, e_2, e_1]

    entries.each do |e|
    enterCommand(@client, "set #{e[0]} #{e[1]} #{e[2]} #{e[3]}", e[4])
    @client.read
    end

    #veryfing that keys were stored
    get_from_array(entries) #all 3 exist

    #lets check how they expire one by one
    sleep(2)
    enterCommand(@client, "get #{e_1[0]}")
    expect(@client.read).to be == SystemStrings.end    
    entries.pop
    get_from_array(entries) #2 exits

    sleep(2)
    enterCommand(@client, "get #{e_2[0]}")
    expect(@client.read).to be == SystemStrings.end    
    entries.pop 
    get_from_array(entries) #1 exits   

    sleep(2)   
    enterCommand(@client, "get #{e_2[0]}")
    expect(@client.read).to be == SystemStrings.end    
    entries.pop
    # now all 3 keys are gone
    enterCommand(@client, "get #{e_1} #{e_2} #{e_3}")
    expect(@client.read).to be == SystemStrings.end        
  end
end