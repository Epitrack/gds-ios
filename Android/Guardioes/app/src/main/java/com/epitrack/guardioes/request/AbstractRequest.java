package com.epitrack.guardioes.request;

import com.android.volley.NetworkResponse;
import com.android.volley.ParseError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HttpHeaderParser;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

public abstract class AbstractRequest<T> extends Request<T> {

    private final RequestListener<T> listener;

    private ObjectMapper mapper;

    public AbstractRequest(final com.epitrack.guardioes.request.Method method,
                           final String url,
                           final RequestListener<T> listener) {

        super(method.getValue(), url, null);

        if (listener == null) {
            throw new IllegalArgumentException("The listener cannot be null.");
        }

        this.listener = listener;
    }

    private boolean isSuccessRequest(final int statusCode) {

        final StatusCode[] statusCodeArray = { StatusCode.OK,
                                               StatusCode.CREATED,
                                               StatusCode.ACCEPTED,
                                               StatusCode.NON_AUTHORITATIVE_INFORMATION,
                                               StatusCode.NO_CONTENT,
                                               StatusCode.RESET_CONTENT,
                                               StatusCode.PARTIAL_CONTENT,
                                               StatusCode.MULTI_STATUS,
                                               StatusCode.ALREADY_REPORTED };

        for (final StatusCode successCode : statusCodeArray) {

            if (statusCode == successCode.getCode()) {
                return true;
            }
        }

        return false;
    }

    @Override
    public void deliverError(final VolleyError volleyError) {

        final Error error = new Error();

        error.setStatusCode(volleyError.networkResponse.statusCode);
        error.setContent(volleyError.networkResponse.data);
        error.setHeaderArray(volleyError.networkResponse.headers);

        listener.onError(error);
    }

    @Override
    protected void deliverResponse(final T entity) {
        listener.onSuccess(entity);
    }

    @Override
    protected Response<T> parseNetworkResponse(final NetworkResponse response) {

        if (isSuccessRequest(response.statusCode)) {

            try {

                final String json = new String(response.data, HttpHeaderParser.parseCharset(response.headers));

                final T entity = getMapper().readValue(json, getTypeReference());

                return Response.success(entity, HttpHeaderParser.parseCacheHeaders(response));

            } catch (final UnsupportedEncodingException e) {
                return Response.error(new ParseError(e));

            } catch (final JsonMappingException e) {
                return Response.error(new ParseError(e));

            } catch (final JsonParseException e) {
                return Response.error(new ParseError(e));

            } catch (final IOException e) {
                return Response.error(new ParseError(e));
            }
        }

        return null;
    }

    public final ObjectMapper getMapper() {

        if (mapper == null) {
            mapper = new ObjectMapper();
        }

        return mapper;
    }

    public abstract TypeReference<T> getTypeReference();
}
