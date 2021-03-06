package org.rijksmuseum.pid;

import junit.framework.Assert;
import org.junit.Ignore;
import org.junit.Test;

import javax.xml.stream.XMLStreamException;
import javax.xml.transform.TransformerConfigurationException;
import java.io.File;
import java.io.FileNotFoundException;
import java.net.MalformedURLException;
import java.net.URL;

public class PidRequestTest {

    @Test
    public void count() throws MalformedURLException, TransformerConfigurationException, FileNotFoundException, XMLStreamException {

        System.setProperty("environment", "test");
        final File xmlFile = new File(PidRequestTest.class.getResource("/test.xml").getFile());
        PidRequests pidRequests = new PidRequests("my url", "my key", null, null);
        pidRequests.process(xmlFile);
        Assert.assertEquals(4, pidRequests.getCounter());
    }

}
