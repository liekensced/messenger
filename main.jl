import Firebase

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
  messages = []
  for data in db
    push!(messages, data[2])
  end

  sort!(messages, by=message->message["index"])
  
  for message in messages
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
    Firebase.realdb_post(PATH,Dict("msg"=>msg,"index"=>length(data)))
  end
end