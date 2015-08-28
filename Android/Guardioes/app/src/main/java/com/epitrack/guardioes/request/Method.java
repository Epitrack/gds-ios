package com.epitrack.guardioes.request;

/**
 * @author Igor Morais
 */
enum Method {

    OPTIONS     ("Options"),
    GET         ("Get"),
    HEAD        ("Head"),
    POST        ("Post"),
    PUT         ("Put"),
    PATCH       ("Patch"),
    DELETE      ("Delete"),
    TRACE       ("Trace"),
    CONNECT     ("Connect");

    private final String name;

    Method(final String name) {
        this.name = name;
    }

    public final String getName() {
        return name;
    }

    public static Method getBy(final String name) {

        for (final Method method : Method.values()) {

            if (method.getName().equals(name)) {
                return method;
            }
        }

        throw new IllegalArgumentException("The Method has not found.");
    }
}
