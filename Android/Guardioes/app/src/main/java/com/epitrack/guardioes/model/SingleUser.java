package com.epitrack.guardioes.model;

/**
 * @author Miquéias Lopes on 09/09/15.
 */
public class SingleUser extends User {

    private static SingleUser instance;

    private SingleUser() {

    }

    public static synchronized SingleUser getInstance() {

        if (instance == null) {
            return new SingleUser();
        } else {
            return instance;
        }
    }
}
