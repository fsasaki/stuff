function callFremeNer(selectedLanguage, selectedDataset, doctype, approach, sourceContent) {
    this.selectedLanguage = selectedLanguage;
    this.selectedDataset = selectedDataset;
    this.doctype = doctype;
    this.approach = approach;
    this.sourceContent = sourceContent;
    var xslSourcePathOriginalToHtml = "";
    var xslSourcePathApproach2 = "";
    var xslSourcePathApproach3 = "";
    var xslSourcePathApproach4 = "";
    var xslSourcePathApproach5 = "";
    var inputSettings = {"docbook": {"input2html": "lib/docbook-processing/docbook2temp-html.xsl", "approach2": "lib/tei-processing/temp2tei-approach-2.xsl", "approach3": "lib/docbook-processing/temp2docbook-approach-3.xsl", "approach4": "lib/docbook-processing/temp2docbook-approach-4.xsl", "approach5": "lib/docbook-processing/temp2docbook-approach-5.xsl"}, "tei": {"input2html": "lib/tei-processing/tei2temp-html.xsl", "approach2": "lib/tei-processing/temp2tei-approach-2.xsl", "approach3": "lib/tei-processing/temp2tei-approach-3.xsl", "approach4": "lib/tei-processing/temp2tei-approach-4.xsl", "approach5": "lib/tei-processing/temp2tei-approach-5.xsl"}, "xliff2": {"input2html": "lib/xliff2-processing/xliff2-2temp-html.xsl", "approach2": "lib/xliff2-processing/temp2xliff2-approach-2.xsl", "approach3": "lib/xliff2-processing/temp2xliff2-approach-3.xsl", "approach4": "lib/xliff2-processing/temp2xliff2-approach-4.xsl", "approach5": "lib/xliff2-processing/temp2xliff2-approach-5.xsl"}};
    var params = [{"ns": null, "name": "tbd", "value": "tbd"}];
    xslSourcePathOriginalToHtml = inputSettings[doctype].input2html;
    xslSourcePathApproach2 = inputSettings[doctype].approach2;
    xslSourcePathApproach3 = inputSettings[doctype].approach3;
    xslSourcePathApproach4 = inputSettings[doctype].approach4;
    xslSourcePathApproach5 = inputSettings[doctype].approach5;
    console.log("approach:" + approach);
    console.log("doctype: " + doctype);
    console.log("language: " + selectedLanguage);
    console.log("dataset: " + selectedDataset);
    console.log("doctype2htmlpath " + xslSourcePathOriginalToHtml);
    console.log("xslSourcePathApproach2 " + xslSourcePathApproach2);
    console.log("xslSourcePathApproach3 " + xslSourcePathApproach3);
    console.log("xslSourcePathApproach4 " + xslSourcePathApproach4);
    console.log("xslSourcePathApproach5 " + xslSourcePathApproach5);
    var requestBody = xsltTransform(xslSourcePathOriginalToHtml, sourceContent, []);
    console.log(requestBody);
    var fremeApiUrl = "http://api.freme-project.eu/current";
    //for dev version : http://api-dev.freme-project.eu/current
    //for latest stable version: http://api.freme-project.eu/current
    var requestURL = fremeApiUrl + "/e-entity/freme-ner/documents?language=" + selectedLanguage + "&dataset=" + selectedDataset;
    return new Promise(function (resolve, reject) {
        if (approach === "2" || approach === "3" || approach === "5") {
            $.ajax({
                type: 'POST',
                url: requestURL,
                data: requestBody,
                async: true,
                headers: {
                    'Accept': 'text/html',
                    'Content-Type': 'text/html'
                }
            })
                    .done(function (result1) {
                        $("#out").empty().append(result1);
                        console.log("transform back start");
                        console.log("approachchoice " + approach);
                        switch (approach) {
                            case "2" :
                                xslSourcePath235 = xslSourcePathApproach2;
                                break;
                            case "3" :
                                xslSourcePath235 = xslSourcePathApproach3;
                                break;
                            case "5" :
                                xslSourcePath235 = xslSourcePathApproach2;
                        }
                        ;
                        console.log("approach 2,3,5 path" + xslSourcePath235);
                        var tempstring = xsltTransform(xslSourcePath235, sourceContent, []);
                        console.log("approach:" + approach);
                        if (approach === "2" || approach === "3") {
                            var tempstring2 = tempstring.replace(/</g, "&lt;");
                            resolve(tempstring2);
                        } else if (approach === "5") {
                            console.log("running approach 5");
                            $("#output2").empty().addClass('output');
                            console.log("approach 5 path:" + xslSourcePathApproach5);
                            var tempstring5 = xsltTransform(xslSourcePathApproach5, tempstring, []);
                            console.log("tempstring:" + tempstring);
                            var tempstring52 = tempstring5.replace(/</g, "&lt;");
                            resolve(tempstring52);
                            $("#output2").empty().append(tempstring52);
                        }
                    })
                    .fail(function (xhr, statusText, err) {
                        console.log("error");
                        console.log(xhr + statusText + err);
                        reject(xhr + statusText + err);
                    });
        } else {
            $.ajax({
                type: 'POST',
                url: requestURL,
                data: sourceContent,
                async: true,
                headers: {
                    'Accept': 'text/turtle',
                    'Content-Type': 'text/html'
                }
            })
                    .done(function (result1) {
                        var tempstring2 = result1.replace(/</g, "&lt;");
                        if (approach === "1") {
                            resolve(tempstring2);
                        } else if (approach === "4") {
                            console.log("xsl source for approach 4: " + xslSourcePathApproach4);
                            var tempstring = xsltTransform(xslSourcePathApproach4, sourceContent, [{"ns": null, "name": "rdfoutput", "value": tempstring2}]);
                            var tempstring3 = tempstring.replace(/</g, "&lt;");
                            resolve(tempstring3);
                        }
                        ;
                    })
                    .fail(function (xhr, statusText, err) {
                        console.log("error");
                        console.log(xhr + statusText + err);
                        reject(xhr + statusText + err);
                    });
        }
        ;
        ;
    });
}
;