require_relative "../lib/ServerSide/Server"
require_relative "../lib/ClientSide/Client"
require_relative '../lib/ServerSide/SystemStrings'
require_relative "Methods"
require 'rspec/expectations'

port = set_port
address = 'localhost'

RSpec.describe "Get command" do
  before(:each) do
    @server = Server.new(address, port)
    while @server.nil? || @server.busy
      sleep(0.1)
      @server = Server.new(address, port)
    end    
    @serverThread = Thread.new{@server.run}    
    @client = Client.new(address, port)
    #command tested in this spec    
    @comm = 'gets'
  end

  after(:each) do
    @server.close
  end

  context "when given non existent keys" do 
    it "any char before the command returns ERROR" do
      enterCommand(@client, "a #{@comm}")
      expect(@client.read).to be == SystemStrings.error
      $stdin = STDIN
    end
        
    it "a single one return END" do 
      enterCommand(@client, "#{@comm} a")
      expect(@client.read).to be == SystemStrings.end
      $stdin = STDIN      
    end

    it "multiple ones return END" do
      enterCommand(@client, "#{@comm} a b c")
      expect(@client.read).to be == SystemStrings.end
      $stdin = STDIN
    end
  end
#=begin
  context "when given no arguments returns:" do
      it "error" do
      enterCommand(@client, "#{@comm}")
      expect(@client.read).to be == SystemStrings.error
      $stdin = STDIN    
    end
  end
#=end
  context "when given existing keys" do
    it "a single one returns 'VALUE' + flag + bytes + cas + value" do
      #cas value starts at 1 and gets +1 for every data_entry created
      key , flag, ttl, bytes, cas, value,= 'word', 0, 9, 5, 1, 'hello'

      enterCommand(@client, "set #{key} #{flag} #{ttl} #{bytes}", value)
      @client.read
      enterCommand(@client, "#{@comm} word")      
      expect(@client.read).to be == "#{SystemStrings.value} #{key} #{flag} #{bytes} #{cas}"
      expect(@client.read).to be == value
      expect(@client.read).to be == SystemStrings.end
    end 

    it "2 keys are returned sequentially" do
      #data for saving

      key1, flag1, ttl1, bytes1, cas1, value1 = 'word', 0, 9, 5, 1,'hello'
      key2, flag2, ttl2, bytes2, cas2, value2 = 'z', 5, 3, 3, 2, 'bye'

      #saving keys to be returned
      enterCommand(@client, "set #{key1} #{flag1} #{ttl1} #{bytes1}", value1)
      @client.read
      enterCommand(@client, "set #{key2} #{flag2} #{ttl2} #{bytes2}", value2)
      @client.read      

      enterCommand(@client, "#{@comm} #{key1} #{key2}")    

      expect(@client.read).to be == "#{SystemStrings.value} #{key1} #{flag1} #{bytes1} #{cas1}"
      expect(@client.read).to be == value1

      expect(@client.read).to be == "#{SystemStrings.value} #{key2} #{flag2} #{bytes2} #{cas2}"
      expect(@client.read).to be == value2          
      expect(@client.read).to be == SystemStrings.end
    end    

    it "3 keys are returned sequentially" do
      #data for saving

      key1, flag1, ttl1, bytes1, cas1, value1 = 'r', 2, 7, 10, 1, '0123456789'
      key2, flag2, ttl2, bytes2, cas2, value2 = 't', 4, 2, 1, 2, 'K'
      key3, flag3, ttl3, bytes3, cas3, value3 = 'y', 9, 5, 4, 3, '[%<]'

      #saving keys to be returned
      enterCommand(@client, "set #{key1} #{flag1} #{ttl1} #{bytes1}", value1)
      @client.read
      enterCommand(@client, "set #{key2} #{flag2} #{ttl2} #{bytes2}", value2)
      @client.read      
      enterCommand(@client, "set #{key3} #{flag3} #{ttl3} #{bytes3}", value3)
      @client.read      
      enterCommand(@client, "#{@comm} #{key1} #{key2} #{key3}")    

      expect(@client.read).to be == "#{SystemStrings.value} #{key1} #{flag1} #{bytes1} #{cas1}"
      expect(@client.read).to be == value1
      expect(@client.read).to be == "#{SystemStrings.value} #{key2} #{flag2} #{bytes2} #{cas2}"
      expect(@client.read).to be == value2   
      expect(@client.read).to be == "#{SystemStrings.value} #{key3} #{flag3} #{bytes3} #{cas3}"
      expect(@client.read).to be == value3       

      expect(@client.read).to be == SystemStrings.end
    end        
  end

  context "when given existing and non-existing keys" do
    it "only returns the existing ones" do
      #data for saving
      key1, flag1, ttl1, bytes1, cas1, value1 = 'r', 2, 7, 10, 1, '0123456789'
      key2, flag2, ttl2, bytes2, cas2, value2 = 't', 4, 2, 1, 2, 'K'
      key3 = "non-existing"
      #saving keys to be returned
      enterCommand(@client, "set #{key1} #{flag1} #{ttl1} #{bytes1}", value1)
      @client.read
      enterCommand(@client, "set #{key2} #{flag2} #{ttl2} #{bytes2}", value2)
      @client.read      

      enterCommand(@client, "#{@comm} #{key1} #{key2} #{key3}")    

      expect(@client.read).to be == "#{SystemStrings.value} #{key1} #{flag1} #{bytes1} #{cas1}"
      expect(@client.read).to be == value1
      expect(@client.read).to be == "#{SystemStrings.value} #{key2} #{flag2} #{bytes2} #{cas2}"
      expect(@client.read).to be == value2      

      expect(@client.read).to be == SystemStrings.end
    end 
  end

end