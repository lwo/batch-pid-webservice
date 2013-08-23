package org.rijksmuseum.pid;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.ByteArrayRequestEntity;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.RequestEntity;
import org.apache.log4j.Logger;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.*;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.MalformedURLException;
import java.util.HashMap;


/**
 * Mass import of files into the index
 * <p/>
 * args:
 * -f,--file = import document
 * -e,--endpoint = PID webservice endpoint
 * -k,--key = PID webservice key
 * -s, --stylesheet = optional xslt stylesheet
 * -p, --parameters = optional xslt stylesheet parameters.
 */
public class PidRequests {

    final HttpClient httpclient;
    final private String endpoint;
    final private String key;
    final private Transformer transformer;
    final private long numMillisecondsToSleep = 15000; // 15 seconds
    private int counter = 0;
    private boolean sleep;
    private boolean test;

    public PidRequests(String endpoint, String key, String stylesheet, String _parameters) throws TransformerConfigurationException, FileNotFoundException, MalformedURLException {

        this.endpoint = endpoint;
        this.key = key;
        final TransformerFactory tf = TransformerFactory.newInstance();
        transformer = (Util.isEmpty(stylesheet)) ? tf.newTransformer() : tf.newTransformer(new StreamSource(new File(stylesheet)));

        String[] parameters = (Util.isEmpty(_parameters)) ? new String[]{} : _parameters.split(",|;");
        for (String parameter : parameters) {
            String[] split = parameter.split(":");
            transformer.setParameter(split[0], split[1]);
        }
        httpclient = new HttpClient();
        sleep = Boolean.parseBoolean(System.getProperty("sleep", "false"));
        test = System.getProperty("environment", "production").equalsIgnoreCase("test");
    }

    public void process(File xmlFile) throws FileNotFoundException, XMLStreamException {

        final XMLInputFactory xif = XMLInputFactory.newInstance();
        FileInputStream inputStream = new FileInputStream(xmlFile);
        final XMLStreamReader xsr = xif.createXMLStreamReader(inputStream, "utf-8");

        while (xsr.hasNext()) {

            if (xsr.getEventType() == XMLStreamReader.START_ELEMENT) {
                String elementName = xsr.getLocalName();
                if ("Envelope".equals(elementName)) {
                    try {
                        process(xsr);
                    } catch (Exception e) {
                        log.warn(e);
                    }
                } else {
                    xsr.next();
                }
            } else {
                xsr.next();
            }
        }
    }

    private void process(XMLStreamReader xsr) throws TransformerException, IOException {
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        transformer.transform(new StAXSource(xsr), new StreamResult(baos));

        if (test)
            write(baos.toByteArray());
        else
            send(baos.toByteArray());
    }

    private void write(byte[] bytes) {
        log.info("Writing " + ++counter);
        log.info(new String(bytes));
    }

    private void send(byte[] record) throws IOException {

        final PostMethod post = new PostMethod(endpoint);
        final RequestEntity entity = new ByteArrayRequestEntity(record, "text/xml; charset=utf-8");
        post.setRequestHeader("Authorization", "Bearer " + key);
        post.setRequestEntity(entity);
        log.info("Sending record number " + ++counter);
        if (log.isInfoEnabled()) write(record);

        int sc = 0;
        while (sc != 200)
            try {
                sc = httpclient.executeMethod(post);
                post.releaseConnection();
            } catch (Exception e) {
                post.releaseConnection();
                log.error(e);
                log.info("Will retry because of the last exception.");
                sleep();
            }

        if (sc != 200) {
            log.info("Got response:");
            String responseBodyAsString = post.getResponseBodyAsString(1000);
            if (responseBodyAsString != null) write(responseBodyAsString.getBytes());
        }

        if (sleep)
            if (counter % 1000 == 1) {
                log.info("Pause");
                sleep();
            }
    }

    /**
     * We give ourselves a breather for the socket connections to expire
     */
    private void sleep() {
        try {
            Thread.sleep(numMillisecondsToSleep);
        } catch (InterruptedException e) {
            log.warn(e);
        }
    }

    public int getCounter() {
        return this.counter;
    }

    public static void main(String[] args) throws Exception {

        HashMap<String, String> vargs = new HashMap<String, String>(3);
        for (int i = 0; i < args.length; i += 2) {
            vargs.put(args[i], args[i + 1]);
        }

        final String[] EXPECT = new String[]{"-f,--file", "-e,--endpoint", "-k,--key"};
        for (String key : EXPECT) {
            String value = Util.setValue(key, vargs);
            if (value == null) {
                log.fatal("Missing parameter: " + key);
                System.exit(-1);
            }
        }
        final String[] OPTIONAL = new String[]{"-s,--stylesheet", "-p,--parameters"};
        for (String key : OPTIONAL) {
            Util.setValue(key, vargs);
        }

        File xmlFile = new File(Util.getValue("-f", vargs));
        if (!xmlFile.exists() || xmlFile.isDirectory()) {
            log.fatal("File not found: " + xmlFile.getAbsolutePath());
            System.exit(1);
        }

        final PidRequests requests = new PidRequests(
                Util.getValue("--endpoint", vargs),
                Util.getValue("--key", vargs),
                Util.getValue("--stylesheet", vargs),
                Util.getValue("--parameters", vargs));
        requests.process(xmlFile);
    }

    private static Logger log = Logger.getLogger(PidRequests.class.getName());

}