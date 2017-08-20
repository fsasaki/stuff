String.prototype.replaceAll = function (str1, str2, ignore)
{
    return this.replace(new RegExp(str1.replace(/([\,\!\\\^\$\{\}\[\]\(\)\.\*\+\?\|\<\>\-\&])/g, function (c) {
        return "\\" + c;
    }), "g" + (ignore ? "i" : "")), str2);
};
var endpoint = "http://dbpedia.org/sparql?format=application%2Fsparql-results%2Bjson&CXML_redir_for_subjs=121&CXML_redir_for_hrefs=&timeout=30000&debug=on&query=";
var queries = ["SELECT ?city ?population WHERE { ?city rdfs:label '@@@placeholder@@@'@en. ?city <http://dbpedia.org/ontology/populationTotal> ?population } LIMIT 10", "SELECT ?person ?birthday WHERE { ?person rdfs:label ?label. ?person <http://dbpedia.org/ontology/birthDate> ?birthday FILTER (regex(?label, '^.*@@@placeholder@@@.*$', 'xi')) } LIMIT 10"];
var responses = ["The population of @@@placeholder@@@ is @@@output@@@.", "The birthday of @@@placeholder@@@ is @@@output@@@."];
var outputVariables = ["population", "birthday"];
var myDataBase = {"persons": [{"name": "Franz Schmidt", "department": "general IT", "qualifications": "mysql, php"},
        {"name": "Ina Mayer", "department": "general IT", "qualifications": "mysql, php, java"},
        {"name": "Sarah Schulz", "department": "IoT", "qualifications": "c++, java, mysql"}]};
var placeholder;
var accessTokenAPIAI = "845fd3a89eba4ede94d90cd74825d007";
var baseUrlAPIAI = "https://api.api.ai/v1/";
var SlackBot = require('slackbots');
var params = {
    icon_emoji: ':cat:'
};
// create a bot 
var bot = new SlackBot({
    token: 'xoxb-156068754018-HEJJhjlCAWovtzFtGsU8P6qj', // Add a bot https://my.slack.com/services/new/bot and put the token  
    name: 'Lisa'
});

bot.on('start', function () {
    // more information about additional params https://api.slack.com/methods/chat.postMessage 
    var params = {
        icon_emoji: ':cat:'
    };

    // define channel, where bot exist. You can adjust it there https://my.slack.com/services  
    bot.postMessageToChannel('general', 'meow!', params);

});
bot.on('message', function (data) {

    // all ingoing events https://api.slack.com/rtm 

    if (data.text)
    {
        if (data.text.toLowerCase().includes('lisa'))
        {
            console.log("do NLU!");
            doNlu(data.text);
            console.log("I did NLU!");
        }
        ;
    }
    ;
});

function doNlu(inputMessage) {
    console.log("please write: " + inputMessage);
    bot.postMessageToChannel('general', 'I will check, hold on.', params);
    var question = inputMessage.replace("Lisa", '');
    var request = require('request');
    request({
        url: baseUrlAPIAI + "query?v=20150910", //URL to hit
        //qs: {from: 'blog example', time: +new Date()}, //Query string data
        method: 'POST',
        headers: {
            'Content-Type': "application/json; charset=utf-8",
            'Authorization': 'Bearer' + accessTokenAPIAI
        },
        body: JSON.stringify({query: question, lang: "en", sessionId: "somerandomthing"}) //Set the body as a string
    }, function (error, response, responseBody) {
        if (error) {
            console.log(error);
        } else {
            console.log(response.statusCode, responseBody);
            var responseAsJson = JSON.parse(responseBody);
            var intentNum;
            if (responseAsJson.result.action === 'show.population') {
                intentNum = 0;
                placeholder = responseAsJson.result.parameters.city;
            } else if (responseAsJson.result.action === 'show.birthday')
            {
                intentNum = 1;
                placeholder = responseAsJson.result.parameters.givenname + " " + responseAsJson.result.parameters.lastname;
            } else if (responseAsJson.result.action === 'show.persons') {
                console.log(responseAsJson.result.parameters.programminglanguages);
                var output = findPersons(responseAsJson.result.parameters.programminglanguages);
                bot.postMessageToChannel('general', output, params);
                return;
            } else
                return;
            ;
            ;
            // Using the label we got from the NLU output to fill a placeholder slot in the SPARQL query.
            console.log("placeholder now :" + placeholder);
            var queryComplete = queries[intentNum].replaceAll("@@@placeholder@@@", placeholder);
            console.log(queryComplete);

            request({
                url: endpoint + queryComplete,
                //qs: {from: 'blog example', time: +new Date()}, //Query string data
                type: 'POST',
                headers: {
                }
            }, function (error, response, responseBody) {

                if (error) {
                    console.log(error);
                } else {
                    console.log(response.statusCode, responseBody);
                    var result = JSON.parse(responseBody);
                    if (result.results.bindings[0]) {
                        var bindings = result.results.bindings;
                        output = bindings[0][outputVariables[intentNum]].value;
                        console.log(output);
                        var outputtext1 = responses[intentNum].replace("@@@placeholder@@@", placeholder);
                        var outputtext2 = outputtext1.replace("@@@output@@@", output);
                        console.log(outputtext2);
                        bot.postMessageToChannel('general', outputtext2, params);
                        return;

                    } else
                        var outputtext2 = "I don't know the answer to your question.";
                    bot.postMessageToChannel('general', outputtext2, params);
                }

            });
        }
        ;
    });
}
;
function findPersons(qualification)
{
    if (qualification.length === 0) {
        return "I don't know what qualification you are looking for. Can you re-formulate your question?";
    }
    ;
    var resultMessage;
    var count = 0;
    for (i = 0; i < myDataBase.persons.length; i++)
    {
        var currentQualification = myDataBase.persons[i].qualifications;
        console.log(myDataBase.persons[i].qualifications);
        if (currentQualification.includes(qualification))
        {
            count = count + 1;
        }
        ;
    }
    ;
    console.log(count);
    if (count > 1)
    {
        resultMessage = count + " people know about " + qualification + ". I will give you contact details in a private message.";
        return resultMessage;
    } else if (count === 1)
    {
        resultMessage = "1 person knows about " + qualification + ". I will give you contact details in a private message.";
        return resultMessage;
    } else
        (resultMessage = "We don't have people who know " + qualification + ". We should hire some!");
    return resultMessage;
}
;