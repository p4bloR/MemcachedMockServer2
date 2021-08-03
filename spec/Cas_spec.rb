require_relative "../lib/ServerSide/Server"
require_relative "../lib/ClientSide/Client"
require_relative '../lib/ServerSide/SystemStrings'
require_relative "Methods"
require 'rspec/expectations'

port = set_port
address = 'localhost'

RSpec.describe "Cas command" do
  before(:each) do
    @server = Server.new(address, port)
    while @server.nil? || @server.busy
      sleep(0.1)
      @server = Server.new(address, port)
    end    
    @serverThread = Thread.new{@server.run}    
    @client = Client.new(address, port)
    #command tested in this spec      
    @comm = 'cas'        

  end

  after(:each) do
    @server.close
  end

  context "if given" do 
    it "any char before the command returns ERROR" do
      enterCommand(@client, "a #{@comm}")
      expect(@client.read).to be == SystemStrings.error
      $stdin = STDIN
    end
        
    it "no parameters returns ERROR" do
      enterCommand(@client, "#{@comm}")
      expect(@client.read).to be == SystemStrings.error
      $stdin = STDIN
    end
    
    it "insufficient parameters (1) returns ERROR" do
      enterCommand(@client, "#{@comm} a")
      expect(@client.read).to be == SystemStrings.error
      $stdin = STDIN
    end

    it "insufficient parameters (2) returns ERROR" do
      enterCommand(@client, "#{@comm} a 0")
      expect(@client.read).to be == SystemStrings.error
      $stdin = STDIN
    end    

    it "insufficient parameters (3) returns ERROR" do
      enterCommand(@client, "#{@comm} a 0 9")
      expect(@client.read).to be == SystemStrings.error
      $stdin = STDIN
    end

    it "insufficient parameters (4) returns ERROR" do
      enterCommand(@client, "#{@comm} a 0 9")
      expect(@client.read).to be == SystemStrings.error
      $stdin = STDIN
    end

    it "extra parameters (6) returns bad_format" do
      enterCommand(@client, "#{@comm} a 0 9 3 5 5 4")
      expect(@client.read).to be == SystemStrings.error
      $stdin = STDIN
    end          

    it "sufficient parameters (5) including a char returns bad_format" do 
      enterCommand(@client, "#{@comm} a 0 9 4 l")
      expect(@client.read).to be == SystemStrings.bad_format
    end

    it "sufficient parameters including a -int returns bad format" do 
      enterCommand(@client, "#{@comm} a 10 29 3 -1")
      expect(@client.read).to be == SystemStrings.bad_format
    end
  end

  context "if given a correct format" do
    it "returns 'not_found' for previously non-existent keys" do  
      key, flag, ttl, bytes, cas, value = 'some_key', 1, 9, 3, 1, 'sup'
      enterCommand(@client, "#{@comm} #{key} #{flag} #{ttl} #{bytes} #{cas}", value)
      expect(@client.read).to be == SystemStrings.not_found
    end 

    it "returns exists if cas value doesn't match" do
      #user 1 set a key named 'n' 
      key = 'n'
      flag1, ttl1, bytes1, value1 = 1, 9, 3, 'sup'
      enterCommand(@client, "set #{key} #{flag1} #{ttl1} #{bytes1}", value1)
      @client.read
      enterCommand(@client, "gets n")
      cas = @client.read.split(" ").last
      expect(@client.read).to be == value1
      expect(@client.read).to be == SystemStrings.end           

      #user2 changes the value of 'n'
      flag2, ttl2, bytes2, value2 = 0, 60, 6, 'helloo' 
      client2 = Client.new(address, port)     
      enterCommand(client2, "set #{key} #{flag2} #{ttl2} #{bytes2}", value2)
      expect(client2.read).to be == SystemStrings.stored           

      enterCommand(@client, "#{@comm} #{key} #{flag1} #{ttl1} #{bytes1} #{cas}", value1)   
      expect(@client.read).to be == SystemStrings.exists           
    end  

    it "overwrites and stores if cas value matches" do 
      enterCommand(@client, "set n 0 9 1", "@")
      key, flag, ttl, bytes, cas, value = 'some_key', 1, 9, 3, 1, 'sup'
      enterCommand(@client, "#{@comm} #{key} #{flag} #{ttl} #{bytes} #{cas}", value) 
      expect(@client.read).to be == SystemStrings.stored             
    end  
  end

end