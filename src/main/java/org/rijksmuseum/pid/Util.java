package org.rijksmuseum.pid;

import java.util.HashMap;

public class Util {

    public static String setValue(String _keys, HashMap<String, String> vargs) {
        String text = getValue(_keys, vargs);
        String[] keys = _keys.split(",");
        for (String key : keys) {
            vargs.put(key, text);
        }
        return text;
    }

    public static String getValue(String test, HashMap<String, String> vargs) {
        String[] keys = test.split(",");
        for (String key : keys) {
            String value = vargs.get(key);
            if (value != null) return value;
        }
        return null;
    }

    public static boolean isEmpty(String text) {
        return (text == null || text.isEmpty());
    }
}
