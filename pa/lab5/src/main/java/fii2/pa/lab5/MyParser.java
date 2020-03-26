package fii2.pa.lab5;

import java.io.File;
import java.io.FileInputStream;

import org.apache.tika.exception.TikaException;
import org.apache.tika.metadata.Metadata;
import org.apache.tika.parser.AutoDetectParser;
import org.apache.tika.parser.ParseContext;
import org.apache.tika.parser.Parser;
import org.apache.tika.sax.BodyContentHandler;
import org.xml.sax.SAXException;

import java.io.*;
import java.sql.SQLOutput;

public class MyParser {

    public static void parseDoc(Document document){
        //Assume sample.txt is in your current directory
        File file = new File(document.getLocation());

        try {

            //parse method parameters
            Parser parser = new AutoDetectParser();
            BodyContentHandler handler = new BodyContentHandler();
            Metadata metadata = new Metadata();
            FileInputStream inputstream = new FileInputStream(file);
            ParseContext context = new ParseContext();

            //parsing the file
            parser.parse(inputstream, handler, metadata, context);
            System.out.println("File content : " + handler.toString());
            System.out.println("Metadata: " + metadata.toString());

        } catch (IOException | TikaException | SAXException e) {
            e.printStackTrace();
        }

    }
}
