package com.company;

//Listing the files from a folder
import java.io.*;
import java.util.List;

public class ListFiles {
    public static void main ( String [] args ) {
        File folder = new File(".");
        String[] list = folder.list(new MyFilter("mp3"));
        String[] list1 = folder.list(new FilenameFilter() {
            @Override
            public boolean accept(File file, String s) {
                return file.getName().contains("andrei");
            }
        });

        for (int i = 0; i < list.length ; i ++) {
            System.out.println(list[i]);
        }
    }
}

class MyFilter implements FilenameFilter {
    String extension;
    public MyFilter (String extension) {
        this.extension = extension;
    }
    public boolean accept(File dir, String name) {
        return name.endsWith("." + extension);
    }
}