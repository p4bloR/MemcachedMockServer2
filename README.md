# MemcachedMockServer2
A new version :)

Welcome!

This readme file contains:
 1. A quick explanation of project's architecture
 2. Requirements
 3. Steps to run a server and clients
 4. Sample commands
 5. Steps to run tests
 6. Class list stating responsabilities
 

1. A quick explanation of project's architecture

This project uses Client-Server architecture and follows the 'Command' design pattern.
The Server class opens a local TCP Server on a desired port. All incoming client connections are accepted in their own thread. Every connection has its own Communicator instance class to handle Server-Client Communication. Input from all clients is passed through different stages. First, input gathered by all Communicators passes through a Command Validator that dynamically runs the corresponding format checks. If the validation is successful, the Command Assembler class creates the desired Command object. Which is then sent through the Command Sender to a Priority Queue to be sequentially executed in a separate thread (to avoid data inconsistency) as soon as possible. Once executed the command access the Data Hash class (in the case of storage and retrieval commands) where all data is stored and returns the result to the client through its corresponding communicator. While all this occurs, the Expire Checker class runs on a parallel thread sending a command to purge expired keys every second.

2. REQUIREMENTS:

- Use ubuntu (you can use a Virtual Machine if necessary)
- Install ruby 2.7 or higher. Here is a tutorial on how to install the latest version of ruby: https://zoomadmin.com/HowToInstall/UbuntuPackage/ruby-rspec
- Instal rspec 3.9 or higher. Here is a tutorial on how to install the latest version of rspec: https://zoomadmin.com/HowToInstall/UbuntuPackage/ruby-rspec
 (rspec packages listed below)
  - rspec-core 3.9.1
  - rspec-expectations 3.9.0
  - rspec-mocks 3.9.1
  - rspec-support 3.9.2

3. Steps to run a server and clients
 1.	Open the Ubuntu terminal and navigate to the MemcachedMockServer2 folder
 2.	Enter the following on the terminal: ruby RunServer.rb
    If the port is free the message "Server is running" should appear on screen, if instead you see "Port is busy maybe try another" change the port value on the         settings.txt file in the same directory and do step 1 again.
 3.	With the server running now open a new terminal tab and without leaving the MemcachedMockServer folder enter  the following in the terminal: ruby RunClient.rb
    If the client can't connect to the server you'll see a message saying "Connection refused, is the server running", in which case I recommend you interrupt the         server process and go back to step 1. When the client connects to the server you'll see he message "connected to server appear in the terminal.
 4.	Now you have successfully connected a client to the server, you can connect as many clients as you like by repeating step 3.

With the client connected now you can execute set, get, gets, add, replace, append, prepend and cas commands just like in real memcached server. You can also enter "close_server" to close the server, or "close_client" to close your current session and "close_all_clients" to close all client's sessions including yours.

4. Sample Commands

This is a list of sample commands you can use to test all memcached commands. Once you want to close the server just enter "close server".

Let's add something
User input: "add element1 0 900 2"
User input: "hi"
Response: "STORED"

Retrieve it
User input: "get element1"
Response: "VALUE element1 0 2"
Response: "hi"
Response: "END"

Override it
User input: "set element1 0 900 5"
User input: "hello"
Response: "STORED"

Add another one
User input: "add element2 0 900 4"
User input: "hola"
Response: "STORED"

And retrieve both
User input: "get element1 element2"
Response: "VALUE element1 0 5"
Response: "hello"
Response: "VALUE element2 0 4"
Response: "hola"
Response: "END"

Lets use the replace command
User input: "replace element2 0 900 7"
User input: "wassup?"
Response: "STORED"

And retrieve to see if it worked
User input: "get element2"
Response: "VALUE element2 0 7"
Response: "wassup?"
Response: "END"

Now we try append
User input: "append element1 0 900 14"
User input: ", how are you?"
Response: "STORED"

And also prepend
User input: "prepend element2 0 900 5"
User input: "hey, "
Response: "STORED"

And check the results
User input: get element1 element2
Response: "VALUE element1 0 19"
Response: "hello, how are you?"
Response: "VALUE element2 0 12"
Response: "hey, wassup?"
Response: "END"

Lets use gets to get the CAS data
User input: "gets element1"
Response: "VALUE element1 0 19 5"
Response: "hello, how are you?"
Response: "END"

And let's use cas
User input: "cas element1 0 900 3 5"
User input: "bye"
Response: "STORED"

User input: "get element1"
Response: "VALUE element1 0 3"
Response: "bye"
Response: "END"

Now let's try cas again using the same cas number, it shouldn't work.
Cas should
User input: "cas element1 0 900 6 5"
Response: "EXISTS"

Let's check the expiring

User input: "add element3 0 1 9"
User input: "disappear"
Response: "STORED"

Wait two seconds and the element should be gone
User input: "get element3"
Response: "END"

By now you tried every available spec command at least once.

5. Steps to run the tests

 1.	Make sure there are no instances of either the server or the client class running
 2.	Through the terminal go to the MemcachedMockServer2 folder
 3.	Now enter the following: rspec spec
    After a few seconds of printing a lot of messages onto the console you should (hopefully D:) see the message “80 examples 0 failures”

A few things about the specs:

-	This rspec test uses the port 8080 by default, in case you get an error because the port is already in use. Open the "Test_settings.txt" on the specs folder and change the port value to one that is not being used. 
-	I added an extra spec called Expire_spec to demonstrate that expired keys are purged
-	I also added a Methods.rb file that contains a few methods used in all other specs
-	You can also run the specs individually like this "rspec filename_spec.rb" when you're inside the spec folder, but I guess you know that already


6. Class list stating responsabilities

Server: Runs the Memcached-like Server.

Communicator: Allow server to read from and write to a client.

Command Validator: Check if input follows the correct command format.

Command Assembler: Create desired command from user input

Command Sender: Send commands to a queue inside a Queue Element instance

Queue Element: Contain a command object with a certain level of priority

Priority Queue: Execute commands sequentially in a separate thread according to their priority levels

Data Hash: Contain all data entries

Data Entry: Contain data saved by the user

Expire Checker: Create commands to delete expired keys

Connection Threader: Store all client connection threads

Command Hash: Store relevant data from all commands (command name, command class name, minimum parameters needed, etc.)

System Strings: Contain all relevant strings used in the server

Looper: Contain and toggle a Boolean variable (used for running conditional loops)

Command: Superclass for all commands on the server

Internal Command: Superclass for all internal commands (not available to the user)

Delete Expired Command: Update all entries time to live and delete data entries if their ttl is equal to zero.

User Command: Superclass for all commands available to the user 

Storage Command: Superclass for all storage commands available to the user 

Set Command: Stored desired key (data entry object) on the Data Hash, either by creating a new one or overwriting a previously existing one.

Add Command: Stored desired key (data entry object) on the Data Hash if it doesn’t previously exists.

Replace Command: Stored desired key (data entry object) on the Data Hash only if already exists.

Append Command: Add data at the end of an already existing key (data entry object) on the Data Hash. 

Prepend Command: Add data at the beginning of an already existing key (data entry object) on the Data Hash. 

Cas Command: Overwrite data of existing key (data entry object)  if cas key matches (it means it hasn´t been updated since the last fetch)

Retrieval Command: Superclass for all retrieval commands available to the user 

Get Command: Retrieve data from existing key including: key, flag, bytes and value

Get Command: Retrieve data from existing key including: key, flag, bytes, value and cas id

Server Command: Superclass for all server commands available to the user

Close Client Command: Ends current client session

Close All Clients Commands: Ends the session of all connected clients

Close Server Command: Ends the session of all connected clients and closes the server

Client: allow user to communicate with the server.
