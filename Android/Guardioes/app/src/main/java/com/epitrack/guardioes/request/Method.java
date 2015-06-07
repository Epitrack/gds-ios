package com.epitrack.guardioes.request;

public enum Method {

    OPTIONS     (5),
    GET         (0),
    HEAD        (4),
    POST        (1),
    PUT         (2),
    PATCH       (7),
    DELETE      (3),
    TRACE       (6),
    CONNECT     (8);

    private final int value;

    Method(final int value) {
        this.value = value;
    }

    public final int getValue() {
        return value;
    }

    public static Method getBy(final int value) {

        for (final Method method : Method.values()) {

            if (method.getValue() == value) {
                return method;
            }
        }

        throw new IllegalArgumentException("The Method has not found.");
    }
}
