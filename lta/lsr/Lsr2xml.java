// Java script for converting language subtag registry to XML. Part of language tag analyzer (lta). For documentation see http://www.w3.org/2008/05/lta/ 
import java.net.*;
import java.util.regex.*;
import java.io.*;
import java.util.Stack;

public class Lsr2xml {
    private Stack<String> openElem;
    private static Pattern delim = Pattern.compile("^%%.*");
    private static        Pattern type = Pattern.compile("^(Type: )(.+)$");
    private static        Pattern subtag = Pattern.compile("^(Subtag: )(.+)$");
    private static        Pattern tag = Pattern.compile("^(Tag: )(.+)$");
    private static        Pattern description = Pattern.compile("^(Description: )(.+)$");
    private static        Pattern added = Pattern.compile("^(Added: )(.+)$");
    private static        Pattern suppressScript = Pattern.compile("^(Suppress-Script: )(.+)$");
    private static        Pattern preferredValue = Pattern.compile("^(Preferred-Value: )(.+)$");
    private static        Pattern deprecated = Pattern.compile("^(Deprecated: )(.+)$");
    private static        Pattern macrolanguage = Pattern.compile("^(Macrolanguage: )(.+)$");
    private static        Pattern scope = Pattern.compile("^(Scope: )(.+)$");
    private static        Pattern prefix = Pattern.compile("^(Prefix: )(.+)$");
    private static        Pattern comments = Pattern.compile("^(Comments: )(.+)$");

    public Lsr2xml () 
    {
	this.openElem = new Stack<String>();
    }

    private void checkLine (String line, int linenum) throws IOException {
	String newline;
	linenum++;
	Matcher mdel = delim.matcher(line);
	Matcher mt = type.matcher(line);
	Matcher ms = subtag.matcher(line);
	Matcher mtag = tag.matcher(line);
	Matcher md = description.matcher(line);
	Matcher ma = added.matcher(line);
	Matcher ss = suppressScript.matcher(line);
	Matcher mpv = preferredValue.matcher(line);
	Matcher mdep = deprecated.matcher(line);
	Matcher mmacl = macrolanguage.matcher(line);
	Matcher mscope = scope.matcher(line);
	Matcher mpre = prefix.matcher(line);
	Matcher mcom = comments.matcher(line);

	if (mdel.matches()) {
	    if(openElem.empty()) { } else
		{
		    if(openElem.peek().compareTo("desc")==0)
			{
			    System.out.println("</lta:desc>");
			    openElem.pop();
			} else
		    if(openElem.peek().compareTo("comment")==0)
			{
			    System.out.println("</lta:comment>");
			    openElem.pop();
			}
		}
	    System.out.println (
				"</lta:unit>\n<lta:unit>");
	}
	else if (mt.matches()) {
	    System.out.println (
				"<lta:type>" + mt.group(2) + "</lta:type>");
	} else if (ms.matches()) {
	    System.out.println (
				"<lta:subtag>" + ms.group(2) + "</lta:subtag>");
	}
	else if (mtag.matches()) {
	    System.out.println (
				"<lta:tag>" + mtag.group(2) + "</lta:tag>");
	}
	else if (md.matches()) {
  if(openElem.empty()) { } else
		{
		    if(openElem.peek().compareTo("desc")==0)
			{
			    System.out.println("</lta:desc>");
			    openElem.pop();
			} else
		    if(openElem.peek().compareTo("comment")==0)
			{
			    System.out.println("</lta:comment>");
			    openElem.pop();
			}
		}
	    openElem.push("desc");
	    System.out.println (				
				"<lta:desc>" + md.group(2));
	}
	else if (ma.matches()) {
	    if(openElem.empty()) { } else
		{
		    if(openElem.peek().compareTo("desc")==0)
			{
			    System.out.println("</lta:desc>");
			    openElem.pop();
			} else
		    if(openElem.peek().compareTo("comment")==0)
			{
			    System.out.println("</lta:comment>");
			    openElem.pop();
			}
		}
	    System.out.println (
				"<lta:added>" + ma.group(2) + "</lta:added>");
	}
	else if (ss.matches()) {
	    System.out.println (
				"<lta:suppressScript>" + ss.group(2) + "</lta:suppressScript>");
	}
	else if (mpv.matches()) {
	    System.out.println (
				"<lta:preferredValue>" + mpv.group(2) + "</lta:preferredValue>");
	}
	else if (mdep.matches()) {
	    System.out.println (
				"<lta:deprecated>" + mdep.group(2) + "</lta:deprecated>");
	}
	else if (mpre.matches()) {
	    System.out.println (
				"<lta:prefix>" + mpre.group(2) + "</lta:prefix>");
	}
	else if (mcom.matches()) {
	    openElem.push("comment");
	    System.out.println (
				"<lta:comment>" + mcom.group(2));
	}
	else if (mmacl.matches()) {
	    System.out.println (
				"<lta:macrolanguage>" + mmacl.group(2) + "</lta:macrolanguage>");
	}
	else if (mscope.matches()) {
	    System.out.println (
				"<lta:scope>" + mscope.group(2) + "</lta:scope>");
	}
	else System.out.println(line);	  
    }

    public static void main (String [] args) throws Exception, IOException {  
	Lsr2xml r = new Lsr2xml();
	String line;
	int linenum = 1;
	System.out.println("<?xml version='1.0' encoding='utf-8'?>\n<lta:lsr xmlns:lta='http://www.w3.org/2008/05/lta/'\nxmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'\n xsi:schemaLocation='http://www.w3.org/2008/05/lta/ lsr.xsd'>");      
	try {
	    BufferedReader get = new BufferedReader(new FileReader(args[0]));
	    System.out.println ("<lta:filedate>" + get.readLine() + "</lta:filedate>\n<lta:unit>");
	    String start = get.readLine();
	    while ((line = get.readLine()) != null)
		{
		    r.checkLine(line,linenum);
		}

	    System.out.println("</lta:unit>\n</lta:lsr>");
	}
	catch (FileNotFoundException e)
	    {}
    }
}