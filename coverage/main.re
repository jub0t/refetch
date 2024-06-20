let results = {};

const request_headers = {
  "Content-Type": "application/json",
  "Okay": true,
};

const data = Get("https://api.chucknorris.io/jokes/random", request_headers);
  
if (data.body != None) {
  const json_data = JsonParse(response.body);

  results.insert("body", json_data);
  results.insert("headers", response.headers);
}

return results;