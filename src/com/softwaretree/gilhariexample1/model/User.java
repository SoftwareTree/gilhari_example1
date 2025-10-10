package com.softwaretree.gilhariexample1.model;

import org.json.JSONException;
import org.json.JSONObject;

import com.softwaretree.jdx.JDX_JSONObject;

/**
 * A shell (container) class defining a domain model object class for Employee objects 
 * based on the class JSONObject.  This class needs to define just two constructors.
 * Most of the processing is handled by the superclass JDX_JSONObject.
 * <p> 
 * @author Damodar Periwal
 *
 */
public class User extends JDX_JSONObject {

    public User() {
        super();
    }

    public User(JSONObject jsonObject) throws JSONException {
        super(jsonObject);
    }
}
