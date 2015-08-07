package com.epitrack.guardioes.request;

import java.util.HashMap;
import java.util.Map;

public class HeaderBuilder {

    public Map<String, String> add(final IHeader... headerArray) {

        final Map<String, String> headerMap = new HashMap<>(headerArray.length);

        for (int i = 0; i < headerArray.length; i++) {
            headerMap.put(headerArray[i].getHeader().getValue(), headerArray[i].getValue());
        }

        return headerMap;
    }
}
