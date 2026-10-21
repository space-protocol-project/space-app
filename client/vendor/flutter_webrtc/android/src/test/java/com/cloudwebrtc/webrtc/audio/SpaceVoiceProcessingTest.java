package com.cloudwebrtc.webrtc.audio;

import org.junit.Test;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import static org.junit.Assert.*;

public class SpaceVoiceProcessingTest {
    private ByteBuffer frame(float sample) {
        ByteBuffer buffer = ByteBuffer.allocateDirect(480 * 4).order(ByteOrder.nativeOrder());
        for (int i = 0; i < 480; i++) buffer.putFloat(i * 4, sample);
        return buffer;
    }

    @Test public void measuresBeforeGateAndAppliesGainToTransmittedSamples() {
        SpaceVoiceProcessing processor = new SpaceVoiceProcessing();
        processor.initialize(48000, 1);
        ByteBuffer closed = frame(16384);
        processor.process(3, 480, closed);
        assertEquals(.5, processor.level(), .0001);
        assertEquals(0, closed.getFloat(0), 0);
        processor.gain(2);
        processor.transmit(true);
        ByteBuffer open = frame(16384);
        processor.process(3, 480, open);
        assertEquals(32767, open.getFloat(0), 0);
        processor.interrupt();
        processor.transmit(true);
        ByteBuffer interrupted = frame(1000);
        processor.process(3, 480, interrupted);
        assertEquals(0, interrupted.getFloat(0), 0);
        assertTrue(processor.interrupted());
        processor.capture(true);
        assertFalse(processor.interrupted());
        ByteBuffer reset = frame(1000);
        processor.process(3, 480, reset);
        assertEquals(0, reset.getFloat(0), 0);
    }

    @Test public void malformedAudioFailsClosed() {
        SpaceVoiceProcessing processor = new SpaceVoiceProcessing();
        processor.transmit(true);
        ByteBuffer frame = frame(Float.NaN);
        processor.process(3, 480, frame);
        assertTrue(processor.interrupted());
        assertEquals(0, processor.level(), 0);
        for (int i = 0; i < 480; i++) assertEquals(0, frame.getFloat(i * 4), 0);
    }
}
