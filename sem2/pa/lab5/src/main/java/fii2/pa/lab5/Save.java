package fii2.pa.lab5;

import java.io.*;
import java.security.NoSuchAlgorithmException;
import java.security.MessageDigest;

public class Save implements ICommand {
    @Override
    public void execute(Object catalog) {
        try {
            if(catalog.getClass() != Catalog.class){
                throw new ClassCastException();
            }
        }catch (ClassCastException e){
            e.printStackTrace();
        }


        Integer tempName = null;
        try {
            MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
            messageDigest.update(catalog.toString().getBytes());
            String encryptedString = new String(messageDigest.digest());
            tempName = encryptedString.hashCode();
        }
        catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        try(FileOutputStream fos = new FileOutputStream(tempName.toString());
            ObjectOutputStream o = new ObjectOutputStream(fos);){
            o.writeObject(catalog);
        } catch (NullPointerException | IOException e){
            e.printStackTrace();
        }

    }

    @Override
    public void unexecute(Object catalog) {
    }
}
