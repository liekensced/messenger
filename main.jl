print("Enter username: ")
name = readline()

try
  using Firebase
catch
  import Pkg
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
    
    push!(messages, message)
  end

  sort!(messages, by=message->message["index"])
  
  for message in messages
    printstyled(message["name"]*"> ", color=:green)
    println(message["msg"])
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
  else
    Firebase.realdb_post(PATH,Dict("msg"=>msg,"index"=>length(data),"name"=>name))
  end
end