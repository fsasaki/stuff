function xsltTransform(xslSourcePath, xmlString, params) {
    console.log("xsl in path: " + xslSourcePath);
    var proc = Saxon.newXSLT20Processor();
    if (params) {
        $.each(params, function (index, item) {
            console.log("ns:" + item.ns + "name:" + item.name);
            proc.setParameter(item.ns, item.name, item.value);
        });
    }
    ;
    var xslSource = Saxon.requestXML(xslSourcePath);
    var xmlSource = Saxon.parseXML(xmlString);
    proc.importStylesheet(xslSource);
    var fragment = proc.transformToFragment(xmlSource, document);
    return Saxon.serializeXML(fragment);
}
;