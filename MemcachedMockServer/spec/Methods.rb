def set_port
  #reads the port from file
  port = ((File.open("/home/pablo/Desktop/TercerIntento/V8/spec/Test_settings.txt", &:readline)).split)[2]
  #if there is a problem readig the file the test uses the default value 8080
  port ||= 8080
  return port
end

def user_input(input)
  allow($stdin).to receive(:gets).and_return(input)
end

# this simulates command \n value\n
def enterCommand(client, command, value = false)
  user_input(command)
  #this checks what's being sent is == to what the "user" wrote
  expect(client.write).to be == command
  if value
    user_input(value)
    expect(client.write).to be == value
  end
end

