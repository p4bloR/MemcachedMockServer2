# MemcachedMockServer2
A new version :)

Welcome!

This readme file contains:
- A quick explanation of project's architecture
- Requirements
- Steps to run a server and clients
- Sample commands
- Steps to run tests

- A quick explanation of project's architecture
This project uses Client-Server architecture and follows the 'Command' design pattern.
The Server class opens a local TCP Server on a desired port. All incoming client connections are accepted in their own thread. Every connection has its own Communicator instance class to handle Server-Client Communication. Input from all clients is passed through different stages. First, input gathered by all Communicators passes through a Command Validator that dynamically runs the corresponding format checks. If the validation is successful, the Command Assembler class creates the desired Command object. Which is then sent through the Command Sender to a Priority Queue to be sequentially executed in a separate thread (to avoid data inconsistency) as soon as possible. Once executed the command access the Data Hash class (in the case of storage and retrieval commands) where all data is stored and returns the result to the client through its corresponding communicator. While all this occurs, the Expire Checker class runs on a parallel thread sending a command to purge expired keys every second.

- REQUIREMENTS:

- Use ubuntu (you can use a Virtual Machine if necessary)
- Install ruby 2.7 or higher. Here is a tutorial on how to install the latest version of ruby: https://zoomadmin.com/HowToInstall/UbuntuPackage/ruby-rspec
- Instal rspec 3.9 or higher. Here is a tutorial on how to install the latest version of rspec: https://zoomadmin.com/HowToInstall/UbuntuPackage/ruby-rspec
 (rspec packages listed below)
  - rspec-core 3.9.1
  - rspec-expectations 3.9.0
  - rspec-mocks 3.9.1
  - rspec-support 3.9.2

- Steps to run a server and clients
1.	Open the Ubuntu terminal and navigate to the MemcachedMockServer2 folder
2.	Enter the following on the terminal: ruby RunServer.rb
    If the port is free the message "Server is running" should appear on screen, if instead you see "Port is busy maybe try another" change the port value on the         settings.txt file in the same directory and do step 1 again.
3.	With the server running now open a new terminal tab and without leaving the MemcachedMockServer folder enter  the following in the terminal: ruby RunClient.rb
    If the client can't connect to the server you'll see a message saying "Connection refused, is the server running", in which case I recommend you interrupt the         server process and go back to step 1. When the client connects to the server you'll see he message "connected to server appear in the terminal.
4.	Now you have successfully connected a client to the server, you can connect as many clients as you like by repeating step 3.
