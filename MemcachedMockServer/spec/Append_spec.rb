require_relative "../lib/ServerSide/Server"
require_relative "../lib/ClientSide/Client"
require_relative '../lib/ServerSide/SystemStrings'
require_relative "Methods"
require 'rspec/expectations'

port = set_port
address = 'localhost'

RSpec.describe "Append command" do
  before(:each) do
    @server = Server.new(address, port)
    while @server.nil? || @server.busy
      sleep(0.1)
      @server = Server.new(address, port)
    end   
    @serverThread = Thread.new{@server.run}    
    @client = Client.new(address, port)
    #command tested in this spec
    @comm = 'append'        
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

    it "extra parameters (5) returns bad_format" do
      enterCommand(@client, "#{@comm} a 0 9 3 5 5 4")
      expect(@client.read).to be == SystemStrings.error
      $stdin = STDIN
    end          

    it "sufficient parameters (4) including a char return bad_format" do 
      enterCommand(@client, "#{@comm} a 0 9 l")
      expect(@client.read).to be == SystemStrings.bad_format
    end

    it "sufficient parameters including a -int return bad format" do 
      enterCommand(@client, "#{@comm} a 10 29 -1")
      expect(@client.read).to be == SystemStrings.bad_format
    end
  end

  context "given a correct format" do
    it "can't store/append a previously non existing keys" do
      key1, flag1, ttl1, bytes1, value1 = 'some_key', 1, 9, 3, 'yep'
      enterCommand(@client, "#{@comm} #{key1} #{flag1} #{ttl1} #{bytes1}", value1)      
      expect(@client.read).to be == SystemStrings.not_stored     
    end 

    it "appends previously existing keys" do
      key = 'a_key'
      flag1, ttl1, bytes1, value1 = 1, 9, 3, 'sup'
      enterCommand(@client, "set #{key} #{flag1} #{ttl1} #{bytes1}", value1)      
      expect(@client.read).to be == SystemStrings.stored  
      #overwriting the existent key
      flag2, ttl2, bytes2, value2 = 3, 93, 8, 'lalalala'
      enterCommand(@client, "#{@comm} #{key} #{flag2} #{ttl2} #{bytes2}", value2)      
      expect(@client.read).to be == SystemStrings.stored  
      
      #getting the value to check
      bytes = bytes1 + bytes2
      value = value1 + value2
      enterCommand(@client, "get #{key}")   
      expect(@client.read).to be == "#{SystemStrings.value} #{key} #{flag2} #{bytes}"
      expect(@client.read).to be == value          
      expect(@client.read).to be == SystemStrings.end       
    end  
  end

end