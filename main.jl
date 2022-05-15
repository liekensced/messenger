

println("Welcome to julia-chat")
println("===")
print("Please enter username: ")
name = readline()

println("Booting, please wait...")
using Dates
try
  using Firebase
catch
  import Pkg
  println("Need to install dependencies, this might takes some minutes")
  Pkg.add("Firebase")

  using Firebase
end

const PATH = "/messenger/pol176/"

Firebase.realdb_init("https://julia-firebase-default-rtdb.europe-west1.firebasedatabase.app/")


function showMessages()
  db = Firebase.realdb_get(PATH)
  if(db == nothing)
    db = []
  end
  for i in 1:50
    println("")
  end
  println("=======[Server:"*PATH*"]=======")
  messages = []
  for data in db
    message = data[2]

    if(!haskey(message, "msg"))
      message["msg"] = ""
    end
    if(!haskey(message, "name"))
      message["name"] = "unknown"
    end
    if(!haskey(message, "index"))
      message["index"] = 0
    end

    if(!haskey(message, "date"))
      message["date"] = ""
    end
    
    push!(messages, message)
  end

  sort!(messages, by=message->message["index"])
  
  for message in messages
    printstyled(message["name"]*"> ", color=:green)
    text = message["msg"]
    if (isempty(text))
      continue
    end
    if(text[1]=='!')
      newtext = text[2:length(text)]
      printstyled(newtext, color=:red, bold=true)
    elseif(text[1]=='?')
      newtext = text[2:length(text)]
      printstyled(newtext, color=:blue)
    else
      print(text)
    end

    printstyled("\t\t\t\t\t"*message["date"]*"\n", color=:light_black)
    
  end
  println("======")
  print("Enter message:  ")
  return messages
end


showMessages()
while(true)
  data = showMessages()
  msg = readline()
  if(msg == "")
    println("Fetching updates...")
  elseif(msg == "exit" || msg == "close")
      break
  elseif(msg == "CLEAR")
    printstyled("Sure you want to clear "*PATH*" completely (y/n)? ", color=:red)
    if(readline()=="y")
      realdb_delete(PATH)
    end
  else
    Firebase.realdb_post(PATH,Dict("msg"=>msg,"index"=>length(data),"name"=>name, "date"=>Dates.format(now(), "dd-mm @ HH:MM:SS")))
  end
end